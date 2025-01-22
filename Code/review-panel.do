*** Colonial Rule and Economic Freedom

*| Panel Data Summary Statistics 

*---Table 7: Persistence

cd "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy/"
use  "Data/ColonialEFW_Panel.dta", clear

eststo clear

*---Column 1: Basic
eststo: reg efw c.hiel_indep##c.time year i.year if year >= year_independence, cluster(colonizer_indep) 

*---Column 2: Baseline
eststo: reg efw c.hiel_indep##c.time year america africa asia lat_abst landlock island ///
	ruggedness logem4 lpd1500s i.year if year >= year_independence, cluster(colonizer_indep)
	
*---Column 3: Baseline + Full
eststo: reg efw c.hiel_indep##c.time year america africa asia lat_abst landlock island ///
	humid* temp* steplow  deslow stepmid desmid  drystep hiland drywint goldm iron silv zinc ///
	ruggedness logem4 lpd1500s legor_uk legor_fr i.year i.colonizer_indep if year >= year_independence, cluster(colonizer_indep)
	
	test  humid1 = humid2 = humid3 = humid4 = 0
	test  temp1 = temp2 =temp3 = temp4 = temp5 = 0  
	test steplow = deslow = stepmid = desmid = drystep = hiland = drywint = 0 
	test goldm = iron = 0 

*---Column 4: Basic
eststo: reg efw c.efw_colonizer##c.time year i.year if year >= year_independence, cluster(colonizer) 

*---Column 5: Baseline
eststo: reg efw c.efw_colonizer##c.time year america africa asia lat_abst landlock island ///
	ruggedness logem4 lpd1500s i.year if year >= year_independence, cluster(colonizer)
	
*---Column 6: Baseline + Full
eststo: reg efw c.efw_colonizer##c.time year america africa asia lat_abst landlock island ///
	humid* temp* steplow  deslow stepmid desmid  drystep hiland drywint goldm iron silv zinc ///
	ruggedness logem4 lpd1500s legor_uk legor_fr i.year i.colonizer if year >= year_independence, cluster(colonizer)
	
	test  humid1 = humid2 = humid3 = humid4 = 0
	test  temp1 = temp2 =temp3 = temp4 = temp5 = 0  
	test steplow = deslow = stepmid = desmid = drystep = hiland = drywint = 0 
	test goldm = iron = 0 

/* Calculate weights for hiel_indep
forvalues v= 1/3{
	gen wts_t7c`v' = ((hiel_indep*time)*-t7c`v')
	gen totalwt_t7c`v' =  sum(wts_t7c`v')
	bysort country: egen sumwts_t7c`v' = sum(wts_t7c`v')
	gen reltwt_t7c`v' = sumwts_t7c`v'/totalwt_t7c`v'
}	
	
* Calculate weights for efw_colonizer 
forvalues v= 4/6{
	gen wts_t7c`v' = ((efw_colonizer*time)*-t7c`v')
	gen totalwt_t7c`v' =  sum(wts_t7c`v')
	bysort country: egen sumwts_t7c`v' = sum(wts_t7c`v')
	gen reltwt_t7c`v' = sumwts_t7c`v'/totalwt_t7c`v'
}
*/

local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
esttab using "`path'/Results/Review/Table7.tex", replace star(* 0.10 ** 0.05 *** 0.01) se r2 ///
	keep(hiel_indep efw_colonizer time c.hiel_indep#c.time c.efw_colonizer#c.time ///
	year america africa asia lat_abst landlock island ruggedness ///
	logem4 lpd1500s legor_uk legor_fr goldm iron)
	
	
*---Table A1: Summary Statistics for Panel Data

* Colony Economic Freedom Measures 
sum avg_efw Area1 Area2 Area3 Area4 Area5 std 

* Colonizer Economic Freedom Measures
sum efw_colonizer first_hiel hiel_indep 

* Colonizer
sum colonizer_dummy*

* Geography 
sum america africa asia lat_abst landlock island goldm iron silv zinc coal oilres

* Controls
sum ruggedness logem4 lpd1500s legor_uk legor_fr legor_sc legor_ge legor_so euro_share  
