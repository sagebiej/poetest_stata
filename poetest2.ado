*poetest by Julian Sagebiel 14.12.2015
*version 0.4

capture program drop poetest2
capture mata: mata drop poe()
capture mata: mata drop krdraw()

program poetest2, rclass
version 11
syntax namelist,  [model1(string) model2(string) price(name) currentdata repl(integer 1000) seed(integer 5426) mixlln]

*CHECK IF SINTAX IS ENTERED CORRECTLY 
if "`model1'"== "" & "`model2'"!= "" | "`model2'"== "" & "`model1'"!= "" {
di in red "When using the model options, please use model1 and model2"
exit 450
}

if "`model1'"== "" & "`model2'"== "" & "`currentdata'"== "" {
di in red "Use either model1 and model2 options or use currentdata option"
exit 450
}
scalar repl = `repl' 												//change replications to user specified number

set seed `seed'
***BEGIN TAKING DRAWS FROM MODELS
if "`currentdata'"==""{



forvalues i=1/2{
tempname wtp`i'
qui est restore `model`i''
mat b=e(b)
mat v=e(V)
local attrnames: colfullnames b
local namenum: list posof "Mean:`price'" in attrnames
local sdnamenum: list posof "SD:`price'" in attrnames


if `namenum'== 0 {
di in red "Price attribute not found in coefficient matrix. Check the name by typing mat list e(b)"
exit 450
}
mata: krdraw()


mat colnames wtp = `attrnames'
mat `wtp`i''=wtp
*scalar mean`i' =_b[`namelist']/_b[`price']
scalar mean`i' =_b[Mean:`namelist']/ exp(_b[`price'] +(_b[SD:`price']^2)/2)
mat `wtp`i''=`wtp`i''[.,"Mean:`namelist'"]
}
mat wtp=`wtp1'[.,"Mean:`namelist'"],`wtp2'[.,"Mean:`namelist'"]

}


if "`currentdata'"!="" {
mkmat `namelist', mat(wtp) nomissing
}

mata: poe()
matrix meanwtp = mean1, mean2
matrix colnames meanwtp = `model1' `model2'
matrix rownames meanwtp = WTP_`namelist'
disp _n _n "H1: WTP1<WTP2: The probability p is " as result pval1 _n "H2: WTP1>WTP2: p is " as result pval2 _n ///
"Number of Replications: " `repl' _n  ///
"Mean WTP" 
mat list meanwtp

return scalar p1 = pval1
return scalar p2 = pval2
return scalar replications = repl
return matrix wtp_draws =wtp
return matrix meanwtp =meanwtp
end


mata:
void krdraw()
{
numeric scalar repl
matrix V, B
V=st_matrix("v")
B=st_matrix("b")
repl=st_numscalar("repl")
prno=  strtoreal(st_local("namenum"))
sdprno=  strtoreal(st_local("sdnamenum"))
wtpl=J(0,0,.)

C=cholesky(V)
draw=invnormal(uniform(cols(B),1))
sd=C*draw
Z=B'+sd
PR=Z[prno,1]
sdPR=Z[sdprno,1]
wtpl=Z/exp(PR +(sdPR^2)/2)

for (i=2; i<=repl ; i++)
{

draw=invnormal(uniform(cols(B),1))
sd=C*draw
Z=B'+sd
PR=Z[prno,1]
wtp=Z/exp(PR +(sdPR^2)/2)
wtpl=wtpl,wtp
}

wtp2=wtpl'
wtpmean=mean(wtp2)
st_matrix("wtp",wtp2)
st_matrix("mean",wtpmean)
}
end




mata:
void poe()
{

wtp=st_matrix("wtp")
x=wtp[.,1]
y=wtp[.,2]
n=rows(x)
full = J(n,1,x[1,1]),y
for (i=2; i<=n ; i++)
{
full = full\J(n,1,x[i,1]),y

}
fulldiff=full[.,1]-full[.,2]
Idiff1=fulldiff:<0
Idiff2=fulldiff:>0
full=full,fulldiff,Idiff1,Idiff2
sum=colsum(Idiff1)
h01=sum/rows(Idiff1)
p1=1-h01
sum=colsum(Idiff2)
h02=sum/rows(Idiff2)
p2=1-h02
st_numscalar("pval1",p1)
st_numscalar("pval2",p2)




}
end


