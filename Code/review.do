cd "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy/"


*| Requires following packages
*| ssc install psacalc regsensitivity

* Clean data, start here.
use "Data/ColonialEFW.dta", clear

tabulate colonizer, generate(colonizer_dummy)


*--- Table 1: Summary Statistics 

* Colony Economic Freedom Measures 
sum efw Area1 Area2 Area3 Area4 Area5 std 

* Colonizer Economic Freedom Measures
sum efw_colonizer first_hiel hiel_indep 

* Colonizer
sum colonizer_dummy*

* Geography 
sum america africa asia lat_abst landlock island goldm iron silv zinc coal oilres

* Controls
sum ruggedness logem4 lpd1500s legor_uk legor_fr legor_sc legor_ge legor_so ///
	euro_share share_euro share_euro2 



*--- Table 2: List of Colonies by Colonizer
* No Change



*--- Table 3: Economic Freedom of Colonizer

eststo clear 

cap drop t3c*

*---Column 1: Base Sample	
eststo:reg avg_efw efw_colonizer, cluster(colonizer)

* Get the predicted values for calculating weights later. Nomenclature: Table3Column1
predict t3c1 

*---Column 2: Contrlling for Location
eststo:reg avg_efw efw_colonizer america africa asia lat_abst landlock island, cluster(colonizer) 

predict t3c2 

*---Column 3: Controlling for pre-colonial characteristics
eststo: reg avg_efw efw_colonizer america africa asia lat_abst landlock island ///
 ruggedness logem4 lpd1500s humid* temp* steplow  deslow stepmid desmid drystep ///
 hiland drywint goldm iron silv zinc oilres i.colonizer, cluster(colonizer) 
				
predict t3c3
				
test  humid1 = humid2 = humid3 = humid4 = 0
test  temp1 = temp2 =temp3 = temp4 = temp5 = 0  
test steplow = deslow = stepmid = desmid = drystep = hiland = drywint = 0
test goldm = iron =  silv = zinc = oilres = 0 

*---Column 4: Including legal origins
eststo:reg avg_efw efw_colonizer america africa asia lat_abst landlock island ///
ruggedness logem4 lpd1500s humid* temp* steplow  deslow ///
				stepmid desmid  drystep hiland drywint goldm iron silv zinc ///
				oilres legor_fr legor_uk i.colonizer, cluster(colonizer) 
				
predict t3c4
				
test  humid1 = humid2 = humid3 = humid4 = 0
test  temp1 = temp2 =temp3 = temp4 = temp5 = 0  
test steplow = deslow = stepmid = desmid = drystep = hiland = drywint = 0
test goldm = iron =  silv = zinc = oilres = 0 

local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
esttab using "`path'/Results/Review/Table3.tex", replace star(* 0.10 ** 0.05 *** 0.01) se r2 

cap drop *_t3c*
* Calculate weights
forvalues v= 1/4{
	egen obs_t3c`v' = sum(_est_est`v') // Total obs
	
	gen wts_t3c`v' = abs(efw_colonizer-t3c`v') // Weight of obs
	egen sumwts_t3c`v' = sum(wts_t3c`v') // Total weight
	gen relwt_t3c`v' = wts_t3c`v'/sumwts_t3c`v' // Share of weight by obs
	
	gen ratio_t3c`v' = relwt_t3c`v' / (1 / wts_t3c`v') // Weight to obs ratio by col.
	
	egen obs_col_t3c`v' = sum(_est_est`v'), by(colonizer) // Total obs by colonizer
	gen  col_wt_t3c`v' = obs_col_t3c`v' / obs_t3c`v' // Share of obs by colonizer
	egen obs_cont_t3c`v' = sum(_est_est`v'), by(continent) // Total obs by continent
	gen cont_wt_t3c`v' = obs_cont_t3c`v' / obs_t3c`v' // Share of obs by continent

	egen col_sumwts_t3c`v' = sum(wts_t3c`v'), by(colonizer) // Total weight by col.
	gen col_relwt_t3c`v' = col_sumwts_t3c`v' / sumwts_t3c`v' // Share weight by col.
	egen cont_sumwts_t3c`v' = sum(wts_t3c`v'), by(continent) // Total weight by cont.
	gen cont_relwt_t3c`v' = cont_sumwts_t3c`v' / sumwts_t3c`v' // Share weight by cont.
	
	gen col_ratio_t3c`v' = col_relwt_t3c`v' / col_wt_t3c`v' // Weight to obs ratio by col.
	gen cont_ratio_t3c`v'= cont_relwt_t3c`v' / cont_wt_t3c`v' // Weight to obs ratio by col.

	display("Mean stats, Table 3, column `v'")
	display("Stats, by colonizer:")
		table colonizer, stat(mean obs_col_t3c`v' col_wt_t3c`v' col_relwt_t3c`v' col_ratio_t3c`v')
	display("Stats, by continent:")
		table continent, stat(mean obs_cont_t3c`v' cont_wt_t3c`v' cont_relwt_t3c`v' cont_ratio_t3c`v')
}


*---Table 4: Beginning and End of Colonization
eststo clear 
*---Column 1: HIEL at Beginning 
eststo: reg avg_efw first_hiel first_hiel_year america africa asia lat_abst landlock island ///
ruggedness lpd1500s if first>1850, cluster(first_colonizer) 

predict t5c1 

*---Column 2: HIEL at Beginning: only if first is from the main
eststo: reg avg_efw first_hiel first_hiel_year america africa asia lat_abst landlock island ///
ruggedness lpd1500s i.first_colonizer if first_hiel_colonizer==main & first>1850, cluster(first_colonizer) 

predict t5c2

*---Column 3: HIEL at Independence
eststo: reg avg_efw hiel_indep year_indep america africa asia lat_abst landlock island ///
ruggedness lpd1500s i.colonizer_indep, cluster(colonizer_indep) 

predict t5c3

*---Column 4: Bauer Hypothesis
eststo: reg avg_efw postwar america africa asia lat_abst landlock island ///
ruggedness lpd1500s i.colonizer_indep, cluster(colonizer_indep)

predict t5c4

*---Column 5: Bauer Hypothesis
eststo: reg avg_efw postwar##c.hiel_indep america africa asia lat_abst landlock island ///
ruggedness lpd1500s i.colonizer_indep, cluster(colonizer_indep)

predict t5c5 

local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
esttab using "`path'/Results/Review/Table5.tex", replace star(* 0.10 ** 0.05 *** 0.01) se r2 


* Calculate weights
forvalues v= 1/5{
	gen wts_t5c`v' = (efw_colonizer-t5c`v')
	egen sumwts_t5c`v' = sum(wts_t5c`v')
	gen reltwt_t5c`v' = wts_t5c`v'/sumwts_t5c`v'
}


*---Table 5: Mechanism: Direct and Indirect Rule

gen share_euro2 = share_euro
replace share_euro2 = .2743236 if country=="Barbados" | country=="Bahamas"
replace share_euro2 = .9736003 if country=="New Zealand"

foreach v in euro_share share_euro share_euro2 {
	replace `v' = `v' * 100
}

*---Panel A: Easterly and Levine, 2016 (euro_share)

eststo clear

* Additive 
eststo: reg avg_efw efw_colonizer euro_share, cluster(colonizer)
eststo: reg avg_efw efw_colonizer euro_share america asia africa lat_abst landlock island ///
ruggedness lpd1500s, cluster(colonizer) 
eststo: reg avg_efw efw_colonizer euro_share america africa asia lat_abst landlock island ///
ruggedness lpd1500s i.colonizer, cluster(colonizer) 


* Multiplicative 
eststo: reg avg_efw c.efw_colonizer##c.euro_share, cluster(colonizer)
eststo: reg avg_efw c.efw_colonizer##c.euro_share america africa asia lat_abst landlock island ///
ruggedness lpd1500s, cluster(colonizer) 
eststo: reg avg_efw c.efw_colonizer##c.euro_share america africa asia lat_abst landlock island ///
ruggedness  lpd1500s i.colonizer, cluster(colonizer) 

local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
esttab using "`path'/Results/Review/Table6A.tex", replace star(* 0.10 ** 0.05 *** 0.01) se r2 

*---Panel B: Giuliano & Nunn, 2018 (share_euro) Additive
eststo clear

* Additive
eststo: reg avg_efw efw_colonizer share_euro, cluster(colonizer)
eststo: reg avg_efw efw_colonizer share_euro america africa asia lat_abst landlock island ///
ruggedness  lpd1500s, cluster(colonizer) 
eststo: reg avg_efw efw_colonizer share_euro america africa asia lat_abst landlock island ///
				ruggedness logem4 lpd1500s humid* temp* steplow  deslow ///
				stepmid desmid  drystep hiland drywint goldm iron silv zinc ///
				oilres legor_fr legor_uk i.colonizer, cluster(colonizer) 

* Multiplicative 
eststo: reg avg_efw c.efw_colonizer##c.share_euro, cluster(colonizer)
eststo: reg avg_efw c.efw_colonizer##c.share_euro america africa asia lat_abst landlock island ///
ruggedness lpd1500s, cluster(colonizer) 
eststo: reg avg_efw c.efw_colonizer##c.share_euro america africa asia lat_abst landlock island ///
				ruggedness logem4 lpd1500s humid* temp* steplow  deslow ///
				stepmid desmid  drystep hiland drywint goldm iron silv zinc ///
				oilres legor_fr legor_uk i.colonizer, cluster(colonizer)

local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
esttab using "`path'/Results/Review/Table6B.tex", replace star(* 0.10 ** 0.05 *** 0.01) se r2  

*---Panel C: Adj. Giuliano & Nunn, 2018 (share_euro2)

eststo clear

* Additive 
eststo: reg avg_efw efw_colonizer share_euro2, cluster(colonizer)
eststo: reg avg_efw efw_colonizer share_euro2 america africa asia lat_abst landlock island ///
ruggedness lpd1500s, cluster(colonizer) 
eststo: reg avg_efw efw_colonizer share_euro2 america africa asia lat_abst landlock island ///
				ruggedness logem4 lpd1500s humid* temp* steplow  deslow ///
				stepmid desmid  drystep hiland drywint goldm iron silv zinc ///
				oilres legor_fr legor_uk i.colonizer, cluster(colonizer) 

* Multiplicative 
eststo: reg avg_efw c.efw_colonizer##c.share_euro2, cluster(colonizer)
eststo: reg avg_efw c.efw_colonizer##c.share_euro2 america africa asia lat_abst landlock island ///
ruggedness  lpd1500s, cluster(colonizer) 
eststo: reg avg_efw c.efw_colonizer##c.share_euro2 america africa asia lat_abst landlock island ///
				ruggedness logem4 lpd1500s humid* temp* steplow  deslow ///
				stepmid desmid  drystep hiland drywint goldm iron silv zinc ///
				oilres legor_fr legor_uk i.colonizer, cluster(colonizer) 

local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
esttab using "`path'/Results/Review/Table6C.tex", replace star(* 0.10 ** 0.05 *** 0.01) se r2  



********************************************************************************
********************************************************************************

**** APPENDIX A: DATA DESCRIPTION


*---Table A1: Sum Stats By Colonizer and Continent
table colonizer, stat(mean avg_efw) stat(sd avg_efw) ///
				 stat(mean efw_colonizer) stat(sd efw_colonizer) ///
				 stat(freq) stat(percent)

table continent, stat(mean avg_efw) stat(sd avg_efw) ///
				 stat(mean efw_colonizer) stat(sd efw_colonizer) ///
				 stat(freq) stat(percent)

				 
* Correlation EFW Colonizer, EFW Colonized
twoway (scatter avg_efw efw_colonizer, colorvar(colonizer) colordiscrete ///     
             colorrule(phue) zlabel(, valuelabel) coloruseplegend) ///
       (lfit avg_efw efw_colonizer), legend(off) ///
       xlabel(, labsize(small)) ylabel(, labsize(small)) ///
       xtitle("Colonizer's Economic Freedom During Colonization ") ///
       ytitle("Colony Average Economic Freedom (2000-2019)")
	   
	   local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
	   *graph export "`path'/Results/Plots/efw_corr.png", as(png) replace
	   graph export "`path'/Results/Review/efw_corr.eps", as(eps) replace
	   
	   
twoway (scatter avg_efw efw_colonizer) ///
       (lfit avg_efw efw_colonizer), legend(off) by(continent) ///
       xtitle("Colonizer's Economic Freedom During Colonization ") ///
       ytitle("Colony Average Economic Freedom (2000-2019)")
	   
	   local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
	   *graph export "`path'/Results/Plots/efw_corr_continent.png", as(png) replace
	   graph export "`path'/Results/Review/efw_corr_continent.eps", as(eps) replace
	   
	 
	
				 
********************************************************************************
********************************************************************************

**** APPENDIX B: ADDITIONAL RESULTS
	
*---Table B1: Sample Splits

eststo clear

*---Column 1: Post-1850
eststo: reg avg_efw efw_colonizer america africa asia lat_abst landlock island ///
ruggedness lpd1500s if first>=1850, cluster(colonizer) 

predict t4c1 

*---Column 2: No Africa
eststo:reg avg_efw efw_colonizer america africa asia lat_abst landlock island ///
ruggedness lpd1500s if africa!=1, cluster(colonizer) 

predict t4c2 
	
*---Column 3: No Americas
eststo:reg avg_efw efw_colonizer america africa asia lat_abst landlock island ///
ruggedness lpd1500s if america!=1, cluster(colonizer)  

predict t4c3

*---Column 4: Without neo-Europes
eststo: reg avg_efw efw_colonizer america africa asia lat_abst landlock island ///
ruggedness lpd1500s if rich4!=1, cluster(colonizer) 

predict t4c4

local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
esttab using "`path'/Results/Review/Table4.tex", replace star(* 0.10 ** 0.05 *** 0.01) se r2 

* Calculate weights
forvalues v= 1/4{
	gen wts_t4c`v' = (efw_colonizer-t4c`v')
	egen sumwts_t4c`v' = sum(wts_t4c`v')
	gen reltwt_t4c`v' = wts_t4c`v'/sumwts_t4c`v'
}


*--- Table B2: Areas of EFW 

foreach v in Area1 Area2 Area3 Area4 Area5 {
	
eststo clear 
	
*---Column 1: Base Sample	
eststo:reg `v' efw_colonizer, cluster(colonizer)

*---Column 2: Contrlling for Location
eststo:reg `v' efw_colonizer america africa asia lat_abst landlock island, cluster(colonizer) 

*---Column 3: Controlling for pre-colonial characteristics
eststo: reg `v' efw_colonizer america africa asia lat_abst landlock island ///
 ruggedness logem4 lpd1500s humid* temp* steplow  deslow stepmid desmid drystep ///
 hiland drywint goldm iron silv zinc oilres i.colonizer, cluster(colonizer) 
				
test  humid1 = humid2 = humid3 = humid4 = 0
test  temp1 = temp2 =temp3 = temp4 = temp5 = 0  
test steplow = deslow = stepmid = desmid = drystep = hiland = drywint = 0
test goldm = iron =  silv = zinc = oilres = 0 

*---Column 4: Including legal origins
eststo:reg `v' efw_colonizer america africa asia lat_abst landlock island ///
ruggedness logem4 lpd1500s humid* temp* steplow  deslow ///
				stepmid desmid  drystep hiland drywint goldm iron silv zinc ///
				oilres legor_fr legor_uk i.colonizer, cluster(colonizer) 

local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
esttab using "`path'/Results/Review/TableB2_`v'.tex", replace star(* 0.10 ** 0.05 *** 0.01) se r2 ///
	keep(efw_colonizer)

}

*--- Table B3: Multiple Colonizers and Std
eststo clear

*---Column 1: Base Sample	
eststo:reg std multiple, cluster(colonizer)

*---Column 2: Contrlling for Location
eststo:reg std multiple america africa asia lat_abst landlock island, cluster(colonizer) 

*---Column 3: Controlling for pre-colonial characteristics
eststo: reg std multiple america africa asia lat_abst landlock island ///
 ruggedness logem4 lpd1500s humid* temp* steplow  deslow stepmid desmid drystep ///
 hiland drywint goldm iron silv zinc oilres i.colonizer, cluster(colonizer) 
				
*---Column 4: Including legal origins
eststo:reg std multiple america africa asia lat_abst landlock island ///
ruggedness logem4 lpd1500s humid* temp* steplow  deslow ///
				stepmid desmid  drystep hiland drywint goldm iron silv zinc ///
				oilres legor_fr legor_uk i.colonizer, cluster(colonizer) 
				
local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
esttab using "`path'/Results/Review/TableB3.tex", replace star(* 0.10 ** 0.05 *** 0.01) se r2 	



*--- Table C4: Population Weighted
eststo clear

*---Column 1: Base Sample	
eststo:reg avg_efw efw_colonizer [iweight=pop], cluster(colonizer)

*---Column 2: Contrlling for Location
eststo:reg avg_efw efw_colonizer america africa asia lat_abst landlock island [iweight=pop], cluster(colonizer) 

*---Column 3: Controlling for pre-colonial characteristics
eststo: reg avg_efw efw_colonizer america africa asia lat_abst landlock island ///
 ruggedness logem4 lpd1500s humid* temp* steplow  deslow stepmid desmid drystep ///
 hiland drywint goldm iron silv zinc oilres i.colonizer [iweight=pop], cluster(colonizer)
 
 test  humid1 = humid2 = humid3 = humid4 = 0
test  temp1 = temp2 =temp3 = temp4 = temp5 = 0  
test steplow = deslow = stepmid = desmid = drystep = hiland = drywint = 0
test goldm = iron =  silv = zinc = oilres = 0 
				
*---Column 4: Including legal origins
eststo:reg avg_efw efw_colonizer america africa asia lat_abst landlock island ///
ruggedness logem4 lpd1500s humid* temp* steplow  deslow ///
				stepmid desmid  drystep hiland drywint goldm iron silv zinc ///
				oilres legor_fr legor_uk i.colonizer [iweight=pop], cluster(colonizer) 
				
test  humid1 = humid2 = humid3 = humid4 = 0
test  temp1 = temp2 =temp3 = temp4 = temp5 = 0  
test steplow = deslow = stepmid = desmid = drystep = hiland = drywint = 0
test goldm = iron =  silv = zinc = oilres = 0 
				
local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
esttab using "`path'/Results/Review/TableC4.tex", replace star(* 0.10 ** 0.05 *** 0.01) se r2 	


/* NOT USING: 

* Persistence

*---Table 7: Persistence

encode country, gen(id)
replace euro_share = euro_share * 100

eststo clear

*---Column 1: Basic
eststo: reg efw hiel_indep time year i.year if year >= year_independence, cluster(colonizer_indep) 

*---Column 2: Baseline
eststo: reg efw hiel_indep time year america africa asia lat_abst landlock island ///
	ruggedness logem4 lpd1500s i.year if year >= year_independence, cluster(colonizer_indep)
	
*---Column 3: Baseline + Full
eststo: reg efw hiel_indep time year america africa asia lat_abst landlock island ///
	humid* temp* steplow  deslow stepmid desmid  drystep hiland drywint goldm iron silv zinc ///
	ruggedness logem4 lpd1500s legor_uk legor_fr i.year i.colonizer_indep if year >= year_independence, cluster(colonizer_indep)
	
	test  humid1 = humid2 = humid3 = humid4 = 0
	test  temp1 = temp2 =temp3 = temp4 = temp5 = 0  
	test steplow = deslow = stepmid = desmid = drystep = hiland = drywint = 0 
	test goldm = iron = 0 

*---Column 1: Basic
eststo: reg efw efw_colonizer time year i.year if year >= year_independence, cluster(colonizer) 

*---Column 2: Baseline
eststo: reg efw efw_colonizer time year america africa asia lat_abst landlock island ///
	ruggedness logem4 lpd1500s i.year if year >= year_independence, cluster(colonizer)
	
*---Column 3: Baseline + Full
eststo: reg efw efw_colonizer  time year america africa asia lat_abst landlock island ///
	humid* temp* steplow  deslow stepmid desmid  drystep hiland drywint goldm iron silv zinc ///
	ruggedness logem4 lpd1500s legor_uk legor_fr i.year i.colonizer if year >= year_independence, cluster(colonizer)
	
	test  humid1 = humid2 = humid3 = humid4 = 0
	test  temp1 = temp2 =temp3 = temp4 = temp5 = 0  
	test steplow = deslow = stepmid = desmid = drystep = hiland = drywint = 0 
	test goldm = iron = 0 
	
forvalues i = 1/6 {
	sum time if _est_est`i'==1
}

local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
esttab using "`path'/Results/Review/Table7.tex", replace star(* 0.10 ** 0.05 *** 0.01) se r2 ///
	keep(hiel_indep efw_colonizer time year america africa asia lat_abst landlock island ruggedness ///
	logem4 lpd1500s legor_uk legor_fr goldm iron)
	
*** Persistence with Cross-section

eststo clear 

*---Column 1: First decade
eststo: reg  efw efw_colonizer efw_indep_year america africa asia lat_abst landlock island ///
ruggedness lpd1500s, cluster(colonizer) 

*---Column 2: Second decade
eststo: reg  efw_indep2 efw_colonizer efw_indep2_year america africa asia lat_abst landlock island ///
ruggedness lpd1500s, cluster(colonizer) 

*---Column 3: Third decade
eststo: reg  efw_indep3 efw_colonizer efw_indep3_year america africa asia lat_abst landlock island ///
ruggedness lpd1500s, cluster(colonizer) 

*---Column 4: Fourth decade
eststo: reg  efw_indep4 efw_colonizer efw_indep4_year america africa asia lat_abst landlock island ///
ruggedness lpd1500s, cluster(colonizer) 

*---Column 5: Fifth decade
eststo: reg  efw_indep5 efw_colonizer efw_indep5_year america africa asia lat_abst landlock island ///
ruggedness lpd1500s, cluster(colonizer) 

*---Column 6: Today
eststo: reg  efw_2019 efw_colonizer america africa asia lat_abst landlock island ///
ruggedness lpd1500s, cluster(colonizer) 

local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
esttab using "`path'/Results/Review/Table5.tex", replace star(* 0.10 ** 0.05 *** 0.01) se r2 
*/

**** GRAPHS 

* Share euro
scatter euro_share share_euro, mlabel(country)

pwcorr share_euro share_euro2 logem4 
	   
	   
twoway (scatter avg_efw efw_colonizer) ///
       (lfit avg_efw efw_colonizer), legend(off) by(colonizer) ///
       xtitle("Colonizer's Economic Freedom During Colonization ") ///
       ytitle("Colony Average Economic Freedom (2000-2019)")
	   
	   local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
	   graph export "`path'/Results/Plots/efw_corr_colonizer.png", as(png) replace
	   graph export "`path'/Results/Review/efw_corr_colonizer.eps", as(eps) replace

	   
twoway (scatter avg_efw year_indep) ///
       (lfit avg_efw year_indep), ///
	   legend(off) ///
       xtitle("Colonizer's Economic Freedom During Colonization ") ///
       ytitle("Colony Average Economic Freedom (2000-2019)")
	   
	   
twoway (scatter avg_efw year_indep) ///
       (lfit avg_efw year_indep), ///
	   legend(off) by(colonizer) ///
       xtitle("Colonizer's Economic Freedom During Colonization ") ///
       ytitle("Colony Average Economic Freedom (2000-2019)")
	   

****
scatter avg_efw efw_colonizer if colonizer==2 & ncolonizer==1, mlabel(country) 

* Burundi vs. Rwanda
list country avg_efw efw_colonizer year_indep first multiple legor_uk legor_ge if colonizer==4

* Zimbabwe vs. South Africa 
list country avg_efw efw_colonizer efw_britain colstart_britain colend_britain year_indep first multiple legor_uk if country=="Zimbabwe" | country=="South Africa"

* Niger -> Mali -> Burkina Faso -> Benin
list country avg_efw efw_colonizer efw_france colstart_france colend_france year_indep first multiple legor_fr if country=="Niger" | country=="Burkina Faso" | country=="Mali" | country=="Benin"

list country avg_efw efw_colonizer  logem4 lpd1500s  if country=="Niger" | country=="Burkina Faso" | country=="Mali" | country=="Benin"




twoway (scatter avg_efw efw_colonizer if colonizer==2 country!="Morocco" & country!="Lebanon", mlabel(country)) ///
	   (lfit avg_efw efw_colonizer if colonizer==2 &country!="Morocco" & country!="Lebanon")


*
twoway (scatter avg_efw efw_colonizer, colorvar(colonizer) colordiscrete ///     
             colorrule(phue) zlabel(, valuelabel) coloruseplegend) ///
       (lfit avg_efw efw_colonizer), legend(off) ///
