cd "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy/"

* Clean data, start here.
use "Data/ColonialEFW.dta", clear


* Table 3: Economic Freedom of Colonizer

eststo clear 

*---Column 1: Base Sample	
eststo:reg avg_efw efw_colonizer, cluster(colonizer) 

*---Column 2: Contrlling for Location
eststo:reg avg_efw efw_colonizer america africa asia lat_abst landlock island, cluster(colonizer) 

*---Column 3: Controlling for pre-colonial characteristics
eststo:reg avg_efw efw_colonizer america africa asia lat_abst landlock island ///
	ruggedness logem4 lpd1500s humid* temp* steplow  deslow ///
				stepmid desmid  drystep hiland drywint goldm iron silv zinc ///
				oilres, cluster(colonizer) 
				
test  humid1 = humid2 = humid3 = humid4 = 0
test  temp1 = temp2 =temp3 = temp4 = temp5 = 0  
test steplow = deslow = stepmid = desmid = drystep = hiland = drywint = 0
test goldm = iron =  silv = zinc = oilres = 0 

*---Column 4: Including legal origins
eststo:reg avg_efw efw_colonizer america africa asia lat_abst landlock island ///
ruggedness logem4 lpd1500s humid* temp* steplow  deslow ///
				stepmid desmid  drystep hiland drywint goldm iron silv zinc ///
				oilres legor_fr legor_uk, cluster(colonizer) 
				
test  humid1 = humid2 = humid3 = humid4 = 0
test  temp1 = temp2 =temp3 = temp4 = temp5 = 0  
test steplow = deslow = stepmid = desmid = drystep = hiland = drywint = 0
test goldm = iron =  silv = zinc = oilres = 0 

local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
esttab using "`path'/Results/Review/Table3.tex", replace star(* 0.10 ** 0.05 *** 0.01) se r2 

*---Table 4: Sample Splits

eststo clear

*---Column 1: Post-1850
eststo: reg avg_efw efw_colonizer america africa asia lat_abst landlock island ///
ruggedness lpd1500s if first>=1850, cluster(colonizer) 

*---Column 2: No Africa
eststo:reg avg_efw efw_colonizer america africa asia lat_abst landlock island ///
ruggedness lpd1500s if africa!=1, cluster(colonizer) 
	
*---Column 3: No Americas
eststo:reg avg_efw efw_colonizer america africa asia lat_abst landlock island ///
ruggedness lpd1500s if america!=1, cluster(colonizer)  

*---Column 4: Without neo-Europes
eststo: reg avg_efw efw_colonizer america africa asia lat_abst landlock island ///
ruggedness lpd1500s if rich4!=1, cluster(colonizer) 

local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
esttab using "`path'/Results/Review/Table4.tex", replace star(* 0.10 ** 0.05 *** 0.01) se r2 






**** GRAPHS 

* Correlation EFW Colonizer, EFW Colonized

twoway (scatter avg_efw efw_colonizer, colorvar(colonizer) colordiscrete ///     
             colorrule(phue) zlabel(, valuelabel) coloruseplegend) ///
       (lfit avg_efw efw_colonizer), legend(off) ///
       xlabel(, labsize(small)) ylabel(, labsize(small)) ///
       xtitle("Colonizer's Economic Freedom During Colonization ") ///
       ytitle("Colony Average Economic Freedom (2000-2019)")
	   
	   local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
	   graph export "`path'/Results/Plots/efw_corr.png", as(png) replace
	   graph export "`path'/Results/Review/efw_corr.eps", as(eps) replace
	   
	   
	   
	   

