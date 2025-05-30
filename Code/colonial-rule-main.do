*|==============================================================================
*| TITLE:
*| Colonial Rule and Economic Freedom, Public Choice, 2025
*|
*| AUTHOR:
*| João Pedro Bastos
*| Texas Tech University | Joao-Pedro.Bastos@ttu.edu
*|
*| DESCRIPTION: Replicates main results with auxiliary files
*|==============================================================================

*------------------------------------------------------------------------------*
*| Requires following packages
*------------------------------------------------------------------------------*

* ssc install psacalc 
* ssc install regsensitivity 
* ssc install estout

*------------------------------------------------------------------------------*
*| Tables and Figures NOT directly replicated in this code
*------------------------------------------------------------------------------*
* Figure 1: Colonization Map - see file: colonial-rule.ipynb
* Tables C3-A, C3-B, C3-C - see file: conley.r


*------------------------------------------------------------------------------*
*| Change to the path where the folder if saved in your local machine
*------------------------------------------------------------------------------*
cd "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy/"

*------------------------------------------------------------------------------*
*| Setup, load data, start log
*------------------------------------------------------------------------------*
use "Data/ColonialEFW.dta", clear

log using results.smcl, replace

*------------------------------------------------------------------------------*
*| Table 1: Economic Freedom of Colonizer
*------------------------------------------------------------------------------*
eststo clear 

*---Column 1: Base Sample	
eststo:reg avg_efw efw_colonizer, cluster(colonizer)

*---Column 2: Contrlling for Location
eststo:reg avg_efw efw_colonizer america africa asia lat_abst ///
	landlock island, cluster(colonizer) 

*---Column 3: Controlling for pre-colonial characteristics
eststo: reg avg_efw efw_colonizer america africa asia lat_abst landlock island ///
 ruggedness logem4 lpd1500s humid* temp* steplow  deslow stepmid desmid drystep ///
 hiland drywint goldm iron silv zinc oilres i.colonizer, cluster(colonizer) 

test  humid1 = humid2 = humid3 = humid4 = 0
test  temp1 = temp2 =temp3 = temp4 = temp5 = 0  
test steplow = deslow = stepmid = desmid = drystep = hiland = drywint = 0
test goldm = iron =  silv = zinc = oilres = 0 

*---Column 4: Including legal origins
eststo:reg avg_efw efw_colonizer america africa asia lat_abst landlock island ///
ruggedness logem4 lpd1500s humid* temp* steplow  deslow ///
				stepmid desmid  drystep hiland drywint goldm iron silv zinc ///
				oilres legor_fr legor_uk i.colonizer, cluster(colonizer) 

test  humid1 = humid2 = humid3 = humid4 = 0
test  temp1 = temp2 =temp3 = temp4 = temp5 = 0  
test steplow = deslow = stepmid = desmid = drystep = hiland = drywint = 0
test goldm = iron =  silv = zinc = oilres = 0 

local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
esttab using "`path'/Results/Table3.tex", ///
	replace star(* 0.10 ** 0.05 *** 0.01) se r2 

*------------------------------------------------------------------------------*
*| Table 2: Alternative Measures: Beginning and End of Colonization
*------------------------------------------------------------------------------*

eststo clear 
*---Column 1: HIEL at Beginning 
eststo: reg avg_efw first_hiel first_hiel_year america africa asia ///
	lat_abst landlock island ruggedness lpd1500s if first>1850, ///
	cluster(first_colonizer) 

*---Column 2: HIEL at Beginning: only if first is from the main
eststo: reg avg_efw first_hiel first_hiel_year america africa asia ///
	lat_abst landlock island ruggedness lpd1500s i.first_colonizer ///
	if first_hiel_colonizer==main & first>1850, cluster(first_colonizer) 

*---Column 3: HIEL at Independence
eststo: reg avg_efw hiel_indep year_indep america africa asia lat_abst ///
	landlock island ruggedness lpd1500s i.colonizer_indep, ///
	cluster(colonizer_indep) 

*---Column 4: Bauer Hypothesis
eststo: reg avg_efw postwar america africa asia lat_abst landlock island ///
ruggedness lpd1500s i.colonizer_indep, cluster(colonizer_indep)

*---Column 5: Bauer Hypothesis
eststo: reg avg_efw postwar##c.hiel_indep america africa asia ///
	lat_abst landlock island ruggedness lpd1500s i.colonizer_indep, ///
	cluster(colonizer_indep)

local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
esttab using "`path'/Results/Table5.tex", ///
	replace star(* 0.10 ** 0.05 *** 0.01) se r2 

	
*------------------------------------------------------------------------------*
*| Table 3: Mechanism: European Settlement, Direct, and Indirect Rule
*------------------------------------------------------------------------------*

gen share_euro2 = share_euro
replace share_euro2 = .2743236 /// Inpute the value of Belize
	if country=="Barbados" | country=="Bahamas"
replace share_euro2 = .9736003 /// Inpute the value of Australia
	if country=="New Zealand"

* Get in percentage terms for more convenient interpretation
foreach v in euro_share share_euro share_euro2 {
	replace `v' = `v' * 100
}

*---Panel A: Easterly and Levine, 2016 (euro_share)

eststo clear

* Additive 
eststo: reg avg_efw efw_colonizer euro_share, cluster(colonizer)
eststo: reg avg_efw efw_colonizer euro_share america asia africa ///
	lat_abst landlock island ruggedness lpd1500s, cluster(colonizer) 
eststo: reg avg_efw efw_colonizer euro_share america africa asia ///
	lat_abst landlock island ruggedness lpd1500s i.colonizer, cluster(colonizer) 


* Multiplicative 
eststo: reg avg_efw c.efw_colonizer##c.euro_share, cluster(colonizer)
eststo: reg avg_efw c.efw_colonizer##c.euro_share america africa asia ///
	lat_abst landlock island ///
ruggedness lpd1500s, cluster(colonizer) 
eststo: reg avg_efw c.efw_colonizer##c.euro_share america africa asia ///
	lat_abst landlock island ruggedness  lpd1500s i.colonizer, ///
	cluster(colonizer) 

local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
esttab using "`path'/Results/Table6A.tex", ///
	replace star(* 0.10 ** 0.05 *** 0.01) se r2 

*---Panel B: Giuliano & Nunn, 2018 (share_euro) Additive
eststo clear

* Additive
eststo: reg avg_efw efw_colonizer share_euro, cluster(colonizer)
eststo: reg avg_efw efw_colonizer share_euro america africa asia ///
	lat_abst landlock island 
ruggedness  lpd1500s, cluster(colonizer) 
eststo: reg avg_efw efw_colonizer share_euro america africa asia ///
	lat_abst landlock island ruggedness logem4 lpd1500s humid* temp* ///
		steplow  deslow stepmid desmid  drystep hiland drywint ///
		goldm iron silv zinc oilres legor_fr legor_uk i.colonizer, ///
		cluster(colonizer) 

* Multiplicative 
eststo: reg avg_efw c.efw_colonizer##c.share_euro, cluster(colonizer)
eststo: reg avg_efw c.efw_colonizer##c.share_euro america africa asia ///
	lat_abst landlock island ruggedness lpd1500s, cluster(colonizer) 
eststo: reg avg_efw c.efw_colonizer##c.share_euro america africa asia ///
	lat_abst landlock island ruggedness logem4 lpd1500s humid* temp* ///
		steplow  deslow stepmid desmid  drystep hiland drywint ///
		goldm iron silv zinc oilres legor_fr legor_uk i.colonizer, ///
		cluster(colonizer)

local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
esttab using "`path'/Results/Table6B.tex", ///
	replace star(* 0.10 ** 0.05 *** 0.01) se r2  

*---Panel C: Adj. Giuliano & Nunn, 2018 (share_euro2)

eststo clear

* Additive 
eststo: reg avg_efw efw_colonizer share_euro2, cluster(colonizer)
eststo: reg avg_efw efw_colonizer share_euro2 america africa asia ///
	lat_abst landlock island ruggedness lpd1500s, cluster(colonizer) 
eststo: reg avg_efw efw_colonizer share_euro2 america africa asia  ///
	lat_abst landlock island ruggedness logem4 lpd1500s humid* temp* ///
	steplow  deslow stepmid desmid  drystep hiland drywint goldm ///
	iron silv zinc oilres legor_fr legor_uk i.colonizer, cluster(colonizer) 

* Multiplicative 
eststo: reg avg_efw c.efw_colonizer##c.share_euro2, cluster(colonizer)
eststo: reg avg_efw c.efw_colonizer##c.share_euro2 america africa asia ///
	lat_abst landlock island ruggedness  lpd1500s, cluster(colonizer) 
eststo: reg avg_efw c.efw_colonizer##c.share_euro2 america africa asia ///
	lat_abst landlock island ruggedness logem4 lpd1500s humid* temp* ///
	steplow  deslow stepmid desmid  drystep hiland drywint goldm ///
	iron silv zinc oilres legor_fr legor_uk i.colonizer, cluster(colonizer) 

local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
esttab using "`path'/Results/Table6C.tex", replace star(* 0.10 ** 0.05 *** 0.01) se r2  

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


*==============================================================================*
*| APPENDIX A: DATA DESCRIPTION
*==============================================================================*

* Since Table 4 requires a different dataset, reload the data
use "Data/ColonialEFW.dta", clear

*------------------------------------------------------------------------------*
*| Table A1: Summary Statistics 
*------------------------------------------------------------------------------*

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

*------------------------------------------------------------------------------*
*| Table A2: List of Colonies by Colonizer
*------------------------------------------------------------------------------*
bysort colonizer: tab country

*------------------------------------------------------------------------------*
*| Table A3: Sum Stats By Colonizer and Continent
*------------------------------------------------------------------------------*

table colonizer, stat(mean avg_efw) stat(sd avg_efw) ///
				 stat(mean efw_colonizer) stat(sd efw_colonizer) ///
				 stat(freq) stat(percent)

table continent, stat(mean avg_efw) stat(sd avg_efw) ///
				 stat(mean efw_colonizer) stat(sd efw_colonizer) ///
				 stat(freq) stat(percent)

*------------------------------------------------------------------------------*
*| Figure A1: Raw correlation economic freedom of colony and its colonizer
*------------------------------------------------------------------------------*				 
twoway (scatter avg_efw efw_colonizer, colorvar(colonizer) colordiscrete ///     
             colorrule(phue) zlabel(, valuelabel) coloruseplegend) ///
       (lfit avg_efw efw_colonizer), legend(off) ///
       xlabel(, labsize(small)) ylabel(, labsize(small)) ///
       xtitle("Colonizer's Economic Freedom During Colonization ") ///
       ytitle("Colony Average Economic Freedom (2000-2019)")
	   
	   local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
	   graph export "`path'/Results/Plots/efw_corr.png", as(png) replace
	   *graph export "`path'/Results/efw_corr.eps", as(eps) replace
	   
*------------------------------------------------------------------------------*
*| Figure A2: Raw correlation economic freedom, by continent
*------------------------------------------------------------------------------*
	   
twoway (scatter avg_efw efw_colonizer) ///
       (lfit avg_efw efw_colonizer), legend(off) by(continent) ///
       xtitle("Colonizer's Economic Freedom During Colonization ") ///
       ytitle("Colony Average Economic Freedom (2000-2019)")
	   
	   local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
	   graph export "`path'/Results/Plots/efw_corr_continent.png", as(png) replace
	   *graph export "`path'/Results/efw_corr_continent.eps", as(eps) replace
	   

*|=============================================================================*
*| APPENDIX B: ADDITIONAL RESULTS
*|=============================================================================*

*------------------------------------------------------------------------------*
*| Table B1: Sample Splits
*------------------------------------------------------------------------------*
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
esttab using "`path'/Results/Table4.tex", ///
	replace star(* 0.10 ** 0.05 *** 0.01) se r2 

*------------------------------------------------------------------------------*
*| Table B2: Areas of EFW 
*------------------------------------------------------------------------------*

foreach v in Area1 Area2 Area3 Area4 Area5 {
	
eststo clear 
	
*---Column 1: Base Sample	
eststo:reg `v' efw_colonizer, cluster(colonizer)

*---Column 2: Contrlling for Location
eststo:reg `v' efw_colonizer america africa asia lat_abst landlock island, ///
	cluster(colonizer) 

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
esttab using "`path'/Results/TableB2_`v'.tex", ///
	replace star(* 0.10 ** 0.05 *** 0.01) se r2 ///
	keep(efw_colonizer)

}

*------------------------------------------------------------------------------*
*| Table B3: Multiple Colonizers and Institutional Cohesion
*------------------------------------------------------------------------------*
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
esttab using "`path'/Results/TableB3.tex", ///
	replace star(* 0.10 ** 0.05 *** 0.01) se r2 	

*------------------------------------------------------------------------------*
*| Table B4: Multiple Colonizers and Institutional Cohesion
*------------------------------------------------------------------------------*
eststo clear

*---Column 1: Base Sample	
eststo:reg avg_efw efw_colonizer, cluster(long_colonizer)

*---Column 2: Contrlling for Location
eststo:reg avg_efw efw_colonizer america africa asia ///
	lat_abst landlock island, cluster(long_colonizer) 

*---Column 3: Controlling for pre-colonial characteristics
eststo: reg avg_efw efw_colonizer america africa asia lat_abst landlock island ///
 ruggedness logem4 lpd1500s humid* temp* steplow  deslow stepmid desmid drystep ///
 hiland drywint goldm iron silv zinc oilres i.long_colonizer, cluster(long_colonizer) 
			
				
test  humid1 = humid2 = humid3 = humid4 = 0
test  temp1 = temp2 =temp3 = temp4 = temp5 = 0  
test steplow = deslow = stepmid = desmid = drystep = hiland = drywint = 0
test goldm = iron =  silv = zinc = oilres = 0 

*---Column 4: Including legal origins
eststo:reg avg_efw efw_colonizer america africa asia lat_abst landlock island ///
	ruggedness logem4 lpd1500s humid* temp* steplow  deslow stepmid desmid  ///
	drystep hiland drywint goldm iron silv zinc ///
	oilres legor_fr legor_uk i.long_colonizer, ///
	cluster(long_colonizer) 

test  humid1 = humid2 = humid3 = humid4 = 0
test  temp1 = temp2 =temp3 = temp4 = temp5 = 0  
test steplow = deslow = stepmid = desmid = drystep = hiland = drywint = 0
test goldm = iron =  silv = zinc = oilres = 0 

local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
esttab using "`path'/Results/TableB4.tex", ///
	replace star(* 0.10 ** 0.05 *** 0.01) se r2 	

*==============================================================================*
*| APPENDIX C: ROBUSTNESS CHECKS
*==============================================================================*

*------------------------------------------------------------------------------*
*| Tables C1.A and C1.B: Effective Regression Weights by Continent and Colonizer
*------------------------------------------------------------------------------*

* Clean Setup
eststo clear 
cap drop t1c*
cap drop *_t1c*

* Rerun the estimates from Table 1 and get the predicted values. 
qui reg avg_efw efw_colonizer, cluster(colonizer)
predict t1c1 
qui reg avg_efw efw_colonizer america africa asia lat_abst ///
	landlock island, cluster(colonizer) 
predict t1c2 
qui reg avg_efw efw_colonizer america africa asia lat_abst landlock island ///
 ruggedness logem4 lpd1500s humid* temp* steplow  deslow stepmid desmid drystep ///
 hiland drywint goldm iron silv zinc oilres i.colonizer, cluster(colonizer) 
predict t1c3
qui reg avg_efw efw_colonizer america africa asia lat_abst landlock island ///
ruggedness logem4 lpd1500s humid* temp* steplow  deslow ///
				stepmid desmid  drystep hiland drywint goldm iron silv zinc ///
				oilres legor_fr legor_uk i.colonizer, cluster(colonizer) 			
predict t1c4

* Calculate weights
forvalues v= 1/4{
	egen obs_t1c`v' = sum(_est_est`v') // Total obs
	
	gen wts_t1c`v' = abs(efw_colonizer-t1c`v') // Weight of obs
	egen sumwts_t1c`v' = sum(wts_t1c`v') // Total weight
	gen relwt_t1c`v' = wts_t1c`v'/sumwts_t1c`v' // Share of weight by obs
	
	gen ratio_t1c`v' = relwt_t1c`v' / (1 / wts_t1c`v') // Weight to obs ratio by col.
	
	egen obs_col_t1c`v' = sum(_est_est`v'), by(colonizer) // Total obs by colonizer
	gen  col_wt_t1c`v' = obs_col_t1c`v' / obs_t1c`v' // Share of obs by colonizer
	egen obs_cont_t1c`v' = sum(_est_est`v'), by(continent) // Total obs by continent
	gen cont_wt_t1c`v' = obs_cont_t1c`v' / obs_t1c`v' // Share of obs by continent

	egen col_sumwts_t1c`v' = sum(wts_t1c`v'), by(colonizer) // Total weight by col.
	gen col_relwt_t1c`v' = col_sumwts_t1c`v' / sumwts_t1c`v' // Share weight by col.
	egen cont_sumwts_t1c`v' = sum(wts_t1c`v'), by(continent) // Total weight by cont.
	gen cont_relwt_t1c`v' = cont_sumwts_t1c`v' / sumwts_t1c`v' // Share weight by cont.
	
	gen col_ratio_t1c`v' = col_relwt_t1c`v' / col_wt_t1c`v' // Weight to obs ratio by col.
	gen cont_ratio_t1c`v'= cont_relwt_t1c`v' / cont_wt_t1c`v' // Weight to obs ratio by col.

	display("Mean stats, Table 3, column `v'")
	display("Stats, by colonizer:")
		table colonizer, stat(mean obs_col_t1c`v' col_wt_t1c`v' ///
		col_relwt_t1c`v' col_ratio_t1c`v')
	display("Stats, by continent:")
		table continent, stat(mean obs_cont_t1c`v' cont_wt_t1c`v' ///
		cont_relwt_t1c`v' cont_ratio_t1c`v')
}

*------------------------------------------------------------------------------*
*| Table C2.A: Sensitivity Analysis for Table 1-2
*------------------------------------------------------------------------------*

**** For Table 1

global w1 "america africa asia lat_abst landlock island"

global model3 "ruggedness logem4 lpd1500s humid* temp* steplow  deslow stepmid desmid drystep hiland drywint goldm iron silv zinc oilres i.colonizer"

global model4 "ruggedness logem4 lpd1500s humid* temp* steplow  deslow stepmid desmid  drystep hiland drywint goldm iron silv zinc oilres legor_fr legor_uk i.colonizer"

* Oster (2019)
regsensitivity breakdown avg_efw efw_colonizer $w1 $model3, compare($w1) /// 
	oster rlong(1.3, relative) 
regsensitivity breakdown avg_efw efw_colonizer $w1 $model4, compare($w1) /// 
	oster rlong(1.3, relative) 
	
*-- DMP (2022)
* 1) Rybar = + inf, c=(0.25, 0.5, 0.75, 1)
regsensitivity breakdown avg_efw efw_colonizer $w1 $model3, cbar(0.25(0.25)1) ///
	compare($w1) 
regsensitivity breakdown avg_efw efw_colonizer $w1 $model4, cbar(0.25(0.25)1) ///
	compare($w1) 

* 2) Rybar = Rxbar, c=1
regsensitivity breakdown avg_efw efw_colonizer $w1 $model3, rybar(=rxbar) ///
	compare($w1) 
regsensitivity breakdown avg_efw efw_colonizer $w1 $model4, rybar(=rxbar) ///
	compare($w1) 
	
	
**** For Table 2 

global baseline "ruggedness lpd1500s"

gen postwar_int = postwar*hiel_indep

* Oster (2019)
* Postwar - Column 4
regsensitivity breakdown avg_efw postwar $w1 $baseline i.colonizer_indep, ///
	compare($w1) oster rlong(1.3, relative) 
	
* HIEL Indep. X Postwar
regsensitivity breakdown avg_efw postwar_int postwar hiel_indep $w1 ///
	$baseline i.colonizer_indep, ///
	compare($w1) oster rlong(1.3, relative) // Column 5
	
*-- DMP (2022)
* 1) Rybar = + inf, c=(0.25, 0.5, 0.75, 1)
regsensitivity breakdown avg_efw postwar $w1 $baseline i.colonizer_indep, ///
	cbar(0.25(0.25)1) /// Column 4
	compare($w1) 
regsensitivity breakdown avg_efw postwar_int postwar hiel_indep $w1 $baseline /// Column 5
	i.colonizer_indep, cbar(0.25(0.25)1) compare($w1) 
	
	
*------------------------------------------------------------------------------*
*| Table C2.B: Sensitivity Analysis for Table 1-2
*------------------------------------------------------------------------------*
	
**** For Table 3 

global baseline "ruggedness lpd1500s"

gen share_euro2 = share_euro
replace share_euro2 = .2743236 if country=="Barbados" | country=="Bahamas"
replace share_euro2 = .9736003 if country=="New Zealand"

foreach v in euro_share share_euro share_euro2 {
	replace `v' = `v' * 100
}

gen hiel_euro_share = efw_colonizer * euro_share
gen hiel_share_euro = efw_colonizer * share_euro
gen hiel_share_euro2 = efw_colonizer * share_euro2

*** Panel A:

** Oster (2019)

* Avg. HIEL
regsensitivity breakdown avg_efw efw_colonizer euro_share $w1 $baseline, ///
	compare($w1) ///  Column 2
	oster rlong(1.3, relative) 
	
* Euro Share
regsensitivity breakdown avg_efw euro_share efw_colonizer $w1 $baseline, ///
	compare($w1) ///  Column 2
	oster rlong(1.3, relative) 
	
	
*-- DMP (2022)
* 1) Rybar = + inf, c=(0.25, 0.5, 0.75, 1)

* Avg. HIEL
regsensitivity breakdown avg_efw efw_colonizer euro_share $w1 $baseline, ///
	compare($w1) ///  Column 2
	 cbar(0.25(0.25)1) 
	
* Euro Share
regsensitivity breakdown avg_efw euro_share efw_colonizer $w1 $baseline, ///
	compare($w1) ///  Column 2
	 cbar(0.25(0.25)1)

	 
* Panel B: Share Euro

** Oster (2019)

* Avg. HIEL
regsensitivity breakdown avg_efw efw_colonizer share_euro $w1 $baseline, ///
	compare($w1) ///  Column 2
	oster rlong(1.3, relative) 
	
regsensitivity breakdown avg_efw efw_colonizer share_euro $w1 $model4, ///
	compare($w1) ///  Column 3
	oster rlong(1.3, relative) 
	
regsensitivity breakdown avg_efw efw_colonizer share_euro hiel_share_euro ///
	$w1 $baseline, compare($w1) ///  Column 5
	oster rlong(1.3, relative) 
	
regsensitivity breakdown avg_efw efw_colonizer share_euro hiel_share_euro ///
	$w1 $model4, compare($w1) ///  Column 6
	oster rlong(1.3, relative) 
	
* Euro Origins 	
regsensitivity breakdown avg_efw share_euro efw_colonizer hiel_share_euro ///
	$w1 $model4, compare($w1) ///  Column 6
	oster rlong(1.3, relative) 
	
* Avg. HIEL X Euro Origins 
	
regsensitivity breakdown avg_efw hiel_share_euro share_euro efw_colonizer ///
	$w1 $model4, compare($w1) ///  Column 6
	oster rlong(1.3, relative) 
	
	
*-- DMP (2022)
* 1) Rybar = + inf, c=(0.25, 0.5, 0.75, 1)

* Avg. HIEL
regsensitivity breakdown avg_efw efw_colonizer share_euro $w1 $baseline, ///
	compare($w1) ///  Column 2
	 cbar(0.25(0.25)1) 
	
regsensitivity breakdown avg_efw efw_colonizer share_euro $w1 $model4, ///
	compare($w1) ///  Column 3
	 cbar(0.25(0.25)1) 
	 
regsensitivity breakdown avg_efw efw_colonizer share_euro hiel_share_euro ///
	$w1 $baseline, compare($w1) ///  Column 5
	cbar(0.25(0.25)1) 
	
regsensitivity breakdown avg_efw efw_colonizer share_euro hiel_share_euro ///
	$w1 $model4, compare($w1) ///  Column 6
	cbar(0.25(0.25)1) 
	
* Euro Origins 
	
regsensitivity breakdown avg_efw share_euro efw_colonizer hiel_share_euro ///
	$w1 $model4, compare($w1) ///  Column 6
	cbar(0.25(0.25)1) 
	
* Avg. HIEL X Euro Origins 
	
regsensitivity breakdown avg_efw hiel_share_euro share_euro efw_colonizer ///
	$w1 $model4, compare($w1) ///  Column 6
	cbar(0.25(0.25)1)  
	
	
* Panel C: Share Euro 2  

** Oster (2019)

* Avg. HIEL
regsensitivity breakdown avg_efw efw_colonizer share_euro2 $w1 $baseline, ///
	compare($w1) ///  Column 2
	oster rlong(1.3, relative) 
	
regsensitivity breakdown avg_efw efw_colonizer share_euro2 $w1 $model4, ///
	compare($w1) ///  Column 3
	oster rlong(1.3, relative) 
	
regsensitivity breakdown avg_efw efw_colonizer share_euro2 hiel_share_euro2 ///
	$w1 $baseline, compare($w1) ///  Column 5
	oster rlong(1.3, relative) 
	
regsensitivity breakdown avg_efw efw_colonizer share_euro2 hiel_share_euro2 ///
	$w1 $model4, compare($w1) ///  Column 6
	oster rlong(1.3, relative) 
	
* Euro Origins 
	
regsensitivity breakdown avg_efw share_euro2 efw_colonizer hiel_share_euro2 ///
	$w1 $model4, compare($w1) ///  Column 6
	oster rlong(1.3, relative) 
	
* Avg. HIEL X Euro Origins 
	
regsensitivity breakdown avg_efw hiel_share_euro2 share_euro2 efw_colonizer ///
	$w1 $model4, compare($w1) ///  Column 6
	oster rlong(1.3, relative) 
	
	
*-- DMP (2022)
* 1) Rybar = + inf, c=(0.25, 0.5, 0.75, 1)

* Avg. HIEL
regsensitivity breakdown avg_efw efw_colonizer share_euro2 $w1 $baseline, ///
	compare($w1) ///  Column 2
	 cbar(0.25(0.25)1) 
	
regsensitivity breakdown avg_efw efw_colonizer share_euro2 $w1 $model4, ///
	compare($w1) ///  Column 3
	 cbar(0.25(0.25)1) 
	 
regsensitivity breakdown avg_efw efw_colonizer share_euro2 hiel_share_euro2 ///
	$w1 $baseline, compare($w1) ///  Column 5
	cbar(0.25(0.25)1) 
	
regsensitivity breakdown avg_efw efw_colonizer share_euro2 hiel_share_euro2 ///
	$w1 $model4, compare($w1) ///  Column 6
	cbar(0.25(0.25)1) 
	
* Euro Origins 
	
regsensitivity breakdown avg_efw share_euro2 efw_colonizer hiel_share_euro2 ///
	$w1 $model4, compare($w1) ///  Column 6
	cbar(0.25(0.25)1) 
	
* Avg. HIEL X Euro Origins 
	
regsensitivity breakdown avg_efw hiel_share_euro2 share_euro2 efw_colonizer ///
	$w1 $model4, compare($w1) ///  Column 6
	cbar(0.25(0.25)1) 
	
*** Table 4:

cd "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy/"
use  "Data/ColonialEFW_Panel.dta", clear

global full_indep "year america africa asia lat_abst landlock island humid* temp* steplow  deslow stepmid desmid  drystep hiland drywint goldm iron silv zinc ruggedness logem4 lpd1500s legor_uk legor_fr i.year i.colonizer_indep"

global full_avg "year america africa asia lat_abst landlock island humid* temp* steplow  deslow stepmid desmid  drystep hiland drywint goldm iron silv zinc ruggedness logem4 lpd1500s legor_uk legor_fr i.year i.colonizer"

global baseline_panel "year ruggedness logem4 lpd1500s i.year"

gen indep_time = hiel_indep * time
gen avg_time = efw_colonizer * time

** Oster (2019)

* Column 3

* HIEL Indep
regsensitivity breakdown efw hiel_indep indep_time time $full_indep ///
	if year >= year_independence, compare($w1) ///
	oster rlong(1.3, relative) 

* HIEL Indep X Years since Indep  
regsensitivity breakdown efw indep_time hiel_indep time $full_indep ///
	if year>=year_indep, compare($w1) ///
	oster rlong(1.3, relative) 
	
* Column 5

* HIEL Indep
regsensitivity breakdown efw efw_colonizer avg_time time $baseline_panel $w1 ///
	if year >= year_independence, ///
	compare($w1) ///
	oster rlong(1.3, relative)

	
* HIEL Indep X Years since Indep  
regsensitivity breakdown efw avg_time efw_colonizer time $baseline_panel $w1 ///
	if year >= year_independence, ///
	compare($w1) ///
	oster rlong(1.3, relative)

	
* Column 6 
	
* Avg. HIEL
regsensitivity breakdown efw efw_colonizer avg_time time $full_avg ///
	if year >= year_independence, compare($w1) ///
	oster rlong(1.3, relative) 
	

* Avg. HIEL X Years since Indep  
regsensitivity breakdown efw avg_time efw_colonizer time $full_avg ///
	if year>=year_indep, compare($w1) ///
	oster rlong(1.3, relative) 
	
*-- DMP (2022)
* 1) Rybar = + inf, c=(0.25, 0.5, 0.75, 1)

* Column 3

* HIEL Indep
regsensitivity breakdown efw hiel_indep indep_time time $full_indep ///
	if year >= year_independence, compare($w1) ///
	cbar(0.25(0.25)1)

* HIEL Indep X Years since Indep  
regsensitivity breakdown efw indep_time hiel_indep time $full_indep ///
	if year>=year_indep, compare($w1) ///
	cbar(0.25(0.25)1)
	
* Column 5

* HIEL Indep
regsensitivity breakdown efw efw_colonizer avg_time time $baseline_panel $w1 ///
	if year >= year_independence, ///
	compare($w1) ///
	cbar(0.25(0.25)1)

	
* HIEL Indep X Years since Indep  
regsensitivity breakdown efw avg_time efw_colonizer time $baseline_panel $w1 ///
	if year >= year_independence, ///
	compare($w1) ///
	cbar(0.25(0.25)1)

	
* Column 6 
	
* Avg. HIEL
regsensitivity breakdown efw efw_colonizer avg_time time $full_avg ///
	if year >= year_independence, compare($w1) ///
	cbar(0.25(0.25)1)
	

* Avg. HIEL X Years since Indep  
regsensitivity breakdown efw avg_time efw_colonizer time $full_avg ///
	if year>=year_indep, compare($w1) ///
	cbar(0.25(0.25)1)
	
*------------------------------------------------------------------------------*
*| Table C3.A-C: Accounting for Spatial Correlation
*------------------------------------------------------------------------------*

* See file conley.r for replication

*------------------------------------------------------------------------------*
*| Table C4: Population Weighted
*------------------------------------------------------------------------------*
* Since Table C2.B requires a different dataset, reload the data
use "Data/ColonialEFW.dta", clear

eststo clear

*---Column 1: Base Sample	
eststo:reg avg_efw efw_colonizer [iweight=pop], cluster(colonizer)

*---Column 2: Contrlling for Location
eststo:reg avg_efw efw_colonizer america africa asia lat_abst landlock island ///
	[iweight=pop], cluster(colonizer) 

*---Column 3: Controlling for pre-colonial characteristics
eststo: reg avg_efw efw_colonizer america africa asia lat_abst ///
	landlock island ruggedness logem4 lpd1500s humid* temp* steplow ///
	deslow stepmid desmid drystep hiland drywint goldm iron silv zinc ///
	oilres i.colonizer [iweight=pop], cluster(colonizer)
 
 test  humid1 = humid2 = humid3 = humid4 = 0
test  temp1 = temp2 =temp3 = temp4 = temp5 = 0  
test steplow = deslow = stepmid = desmid = drystep = hiland = drywint = 0
test goldm = iron =  silv = zinc = oilres = 0 
				
*---Column 4: Including legal origins
eststo:reg avg_efw efw_colonizer america africa asia lat_abst landlock island ///
	ruggedness logem4 lpd1500s humid* temp* steplow  deslow /stepmid desmid ///
	drystep hiland drywint goldm iron silv zinc oilres legor_fr legor_uk ///
	i.colonizer [iweight=pop], cluster(colonizer) 
				
test  humid1 = humid2 = humid3 = humid4 = 0
test  temp1 = temp2 =temp3 = temp4 = temp5 = 0  
test steplow = deslow = stepmid = desmid = drystep = hiland = drywint = 0
test goldm = iron =  silv = zinc = oilres = 0 
				
local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
esttab using "`path'/Results/TableC4.tex", ///
	replace star(* 0.10 ** 0.05 *** 0.01) se r2 	
	
*------------------------------------------------------------------------------*
*| Table C5.A: Pairwise Correlations of EFW and other measures
*------------------------------------------------------------------------------*

pwcorr efw_colonizer /// HIEL 
	rule_colonizer /// VDEM: v2x_rule
	jucon_colonizer /// VDEM: v2x_jucon
	polyarchy_colonizer /// VDEM: v2x_polyarchy
	libdem_colonizer // VDEM: v2x_libdem


*------------------------------------------------------------------------------*
*| Table C5.B: Marginal Effect of Economic Freedom
*------------------------------------------------------------------------------*

* Get residuals 
reg efw_colonizer rule_colonizer, vce(robust)
predict resid_ruleoflaw if e(sample), resid

qui reg efw_colonizer jucon_colonizer, vce(robust)
predict resid_constraints if e(sample), resid

qui reg efw_colonizer polyarchy_colonizer, vce(robust)
predict resid_polyarchy if e(sample), resid

qui reg efw_colonizer libdem_colonizer, vce(robust)
predict resid_libdem if e(sample), resid

qui reg efw_colonize polyarchy_colonizer libdem_colonizer rule_colonizer ///
	jucon_colonizer, vce(robust)
predict resid_all if e(sample), resid

* Estimate results using residuals

foreach v in ruleoflaw constraints polyarchy libdem all {
	
eststo clear 
	
*---Column 1: Base Sample	
eststo:reg avg_efw resid_`v', cluster(colonizer)

*---Column 2: Contrlling for Location
eststo:reg avg_efw resid_`v' america africa asia lat_abst landlock island, ///
	cluster(colonizer) 

*---Column 3: Controlling for pre-colonial characteristics
eststo: reg avg_efw resid_`v' america africa asia lat_abst landlock island ///
 ruggedness logem4 lpd1500s humid* temp* steplow  deslow stepmid desmid drystep ///
 hiland drywint goldm iron silv zinc oilres i.colonizer, cluster(colonizer)
				
*---Column 4: Including legal origins
eststo:reg avg_efw resid_`v' america africa asia lat_abst landlock island ///
ruggedness logem4 lpd1500s humid* temp* steplow  deslow ///
				stepmid desmid  drystep hiland drywint goldm iron silv zinc ///
				oilres legor_fr legor_uk i.colonizer, cluster(colonizer) 

local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
esttab using "`path'/Results/TableC5-`v'.tex", ///
	replace star(* 0.10 ** 0.05 *** 0.01) se r2 	
}
