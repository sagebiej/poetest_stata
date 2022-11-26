{smcl}
{* *! version 1.2.0  02jun2011}{...}
{findalias asfradohelp}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] help" "help help"}{...}
{viewerjumpto "Syntax" "examplehelpfile##syntax"}{...}
{viewerjumpto "Description" "examplehelpfile##description"}{...}
{viewerjumpto "Options" "examplehelpfile##options"}{...}
{viewerjumpto "Remarks" "examplehelpfile##remarks"}{...}
{viewerjumpto "Examples" "examplehelpfile##examples"}{...}
{title:Title}

{phang}
{bf:poetest} {hline 2} Test for differences in Willingness to Pay values (or other empirical distributions) according to the complete combinatorial approach presented in Poe et al. (2005)


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd: poetest namelist}
{cmd:,}
{cmd: [model1({modelspec1}) model2({modelspec2}) price(string) currentdata repl({#}) seed({#})] }

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opth model1(modelspec1)}}stored results of model 1.{p_end}
{synopt:{opth model2(modelspec2)}}stored results of model 2.{p_end}
{synopt:{opth price(string)}}identifies the price attribute. {p_end}
{synopt:currentdata}specifiy this option instead of model1 and model2 if you provide your own draws.{p_end}
{synopt:{opth repl(#)}}specifies the number of replications of Krinsky Robb draws. The default is repl(1000).{p_end}
{synopt:{opth seed(#)}} set the seed. Default value is  seed(5426).{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{cmd:by} is not allowed; see {manhelp by D}.{p_end}
{p 4 6 2}
{cmd:fweight}s are not allowed; see {help weight}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:poetest} applies the complete combinatorial method to test for differences in Willingness To Pay values (or any distributions) of two independent samples. The test was origially proposed by Poe et al. (1994) and modified in Poe et al. (2005). The attribute is specified in namelist and the price attribut in the option price. Further, the command can also be used to take Krinsky Robb draws of any nonlinear combination in the form of a/b, where a is the parameter of namelist and b is specified in price. The draws are saved as a matrix. Type {cmd:return list} after poetest. {p_end} 

{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt model1} specifies the first model of which WTP values should be compared.

{phang}
{opt model2} specifies the second model of which WTP values should be compared. 

{phang}
{opt price}  specifies the price attribute. That is the denominator of a/b 

{phang}
{opt currentdata} can only be used if model1 and model2 are not used. When this option is used, {it:varlist} is assumed to be two variables where the first one are draws from the first distribution and the second one are the draws from the second distribution.  

{phang}
{opt repl} sets the number of replications. The default is 1000. Be careful: with 1000 replications you make 1 Mio. comparisions. Too many replications will overburden Statas capabilities

{phang}
{opt seed} sets the seed. The default is 5426.


{marker remarks}{...}
{title:Remarks}

{pstd}
This command is in beta version. Do not rely on results. Comments are welcome.


{marker examples}{...}
{title:Examples}

{pstd}
Consider the following example that contains the first rows from the data used in Huber and Train (2001). 
{cmd:pid} is the agent, {cmd:gid} the choice situation, {cmd:y} the dependent variable. price local wknown tod and seasonal are attributes. In the example we want to test whether the first 50 respondents decided different to the last 50 respondents:

{cmd}
     pid   gid     y      price   contract   local   wknown   tod   seasonal
      1     1      0        7        5         0       1       0       0
      1     1      0        9        1         1       0       0       0
      1     1      0        0        0         0       0       0       1
      1     1      1        0        5         0       1       1       0
      1     2      0        7        0         0       1       0       0
      1     2      0        9        5         0       1       0       0
      1     2      1        0        1         1       0       1       0
      1     2      0        0        5         0       0       0       1               {txt}

          
{pstd}

{phang2}{cmd:. use http://fmwww.bc.edu/repec/bocode/t/traindata.dta, clear}{p_end}
{phang2}{cmd:. clogit y contract local wknown tod seasonal price if pid<=50, group(gid)}{p_end}
{phang2}{cmd:. est store first50} {p_end}
{phang2}{cmd:. clogit y contract local wknown tod seasonal price if pid>50, group(gid)}{p_end}
{phang2}{cmd:. est store second50} {p_end}
{phang2}{cmd:. poetest contract, model1(first50) model2(second50) price(price) repl(500)} seed(1002) {p_end}
{phang2}{cmd:. clear} {p_end}
{phang2}{cmd:. mat will=r(wtp_draws)} {p_end}
{phang2}{cmd:. svmat will} {p_end}
{phang2}{cmd:. poetest will1 will2 ,  currentdata} {p_end}



{marker results}{...}
{title:Stored results}

{pstd}
{cmd:poetest} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(reps)}}Number of replications used {p_end}
{synopt:{cmd:r(p2)}}Probability of H2: WTP1>WTP2 {p_end}
{synopt:{cmd:r(p1)}}Probability of H1: WTP1<WTP2 {p_end}


{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(meanwtp)}}Mean WTP values{p_end}
{synopt:{cmd:e(wtp_draws)}}Draws used in the test{p_end}




{title:References}

{phang}
Poe G. L., K. L. Giraud, and J. B. Loomis 2005. Computational methods for measuring the difference of
empirical distributions. {it:American Journal of Agricultural Economics}, 87: 353–365.


{phang}
Poe G. L., E. K. Severance-Lossin, and W. P. Welsh 1994. Measuring the difference (X - Y) of simulated
distributions: A convolutions approach. {it:American Journal of Agricultural Economics}, 76: 904–915.

{phang}
Huber, J., and K. Train, 2001.  On the similarity of classical
and Bayesian estimates of individual mean partworths. 
{it:Marketing Letters} 12: 259-269.




{title:Authors}

{pstd}Comments and suggestions are welcome.

{pstd}Julian Sagebiel{p_end}
{pstd}Institute for Ecological Economy Research{p_end}
{pstd}Berlin, Germany{p_end}
{pstd}julian.sagebiel@ioew.de{p_end}
{pstd}juliansagebiel@gmail.com{p_end}


{title:Acknowledgements}

{pstd}I appreciate comments, inputs and testing from Juergen Meyerhoff and Klaus Glenk.

{title:Also see}



{p 7 14 2}
Help:  {helpb wtp}, {helpb wtpcikr} (if installed)
{p_end}

