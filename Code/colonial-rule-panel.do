*|==============================================================================
*| TITLE:
*| Colonial Rule and Economic Freedom, Public Choice, 2025
*|
*| AUTHOR:
*| João Pedro Bastos
*| Texas Tech University | Joao-Pedro.Bastos@ttu.edu
*|
*| DESCRIPTION: Replicates Table 4: Persistence Panel
*|==============================================================================

cd "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy/"
use  "Data/ColonialEFW_Panel.dta", clear

*------------------------------------------------------------------------------*
*| Table 4: Persistence Panel
*------------------------------------------------------------------------------*

* Requires panel version of the dataset
use  "Data/ColonialEFW_Panel.dta", clear

eststo clear

*---Column 1: Basic
eststo: reg efw c.hiel_indep##c.time year i.year if year >= year_independence, ///
	cluster(colonizer_indep) 

*---Column 2: Baseline
eststo: reg efw c.hiel_indep##c.time year america africa asia ///
	lat_abst landlock island ruggedness logem4 lpd1500s i.year ///
	if year >= year_independence, cluster(colonizer_indep)
	
*---Column 3: Baseline + Full
eststo: reg efw c.hiel_indep##c.time year america africa asia ///
	lat_abst landlock island humid* temp* steplow  deslow stepmid ///
	desmid  drystep hiland drywint goldm iron silv zinc ///
	ruggedness logem4 lpd1500s legor_uk legor_fr i.year i.colonizer_indep ///
	if year >= year_independence, cluster(colonizer_indep)
	
	test  humid1 = humid2 = humid3 = humid4 = 0
	test  temp1 = temp2 =temp3 = temp4 = temp5 = 0  
	test steplow = deslow = stepmid = desmid = drystep = hiland = drywint = 0 
	test goldm = iron = 0 

*---Column 4: Basic
eststo: reg efw c.efw_colonizer##c.time year i.year ///
	if year >= year_independence, cluster(colonizer) 

*---Column 5: Baseline
eststo: reg efw avg_time time efw_colonizer year america africa asia ///
	lat_abst landlock island ruggedness logem4 lpd1500s i.year ///
	if year >= year_independence, cluster(colonizer)
	
*---Column 6: Baseline + Full
eststo: reg efw c.efw_colonizer##c.time year america africa asia ///
	lat_abst landlock island humid* temp* steplow  deslow stepmid desmid ///
	drystep hiland drywint goldm iron silv zinc ///
	ruggedness logem4 lpd1500s legor_uk legor_fr i.year i.colonizer ///
	if year >= year_independence, cluster(colonizer)
	
	test  humid1 = humid2 = humid3 = humid4 = 0
	test  temp1 = temp2 =temp3 = temp4 = temp5 = 0  
	test steplow = deslow = stepmid = desmid = drystep = hiland = drywint = 0 
	test goldm = iron = 0 

local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
esttab using "`path'/Results/Review/Table7.tex", ///
	replace star(* 0.10 ** 0.05 *** 0.01) se r2 ///
	keep(hiel_indep efw_colonizer time c.hiel_indep#c.time ///
	c.efw_colonizer#c.time year america africa asia ///
	lat_abst landlock island ruggedness ///
	logem4 lpd1500s legor_uk legor_fr goldm iron)
