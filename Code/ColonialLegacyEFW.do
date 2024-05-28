* PATHS

cd "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy/"


import excel "Data/colonies.xlsx", sheet("Sheet1") firstrow clear

merge 1:1 country_code using "Data/AJRRevFortune.dta"

drop _merge ISO_Code_2 Countries ISO_Code_3 closest
drop if _n>128

drop if efw==.

rename independence year_independence
rename time_indep time_indep_interim
rename avg_efw efw_colonizer 
rename efw avg_efw

gen time_indep = 2000-year_independence
gen lag_efw = efw_year - year_independence
gen centuries = time_total/100
gen diff = efw_year - year_independence
gen delta_efw = efw_2019 - efw_indep

replace simultaneous = 0 if simultaneous ==.
replace time_total = time_total - simultaneous

gen multiple = 0
replace multiple = 1 if ncolonizers > 1

encode main, gen(long_colonizer) /* Longest */
encode main, gen(colonizer) 

* Countries with indep since 1940 and that gained EFW score within 10 years
gen late = 0
replace late = 1 if diff < 10 & year_independence >= 1940


* Adjusting missing continents 

gen miss=1 if  asia!=1 & america!=1  & africa!=1

replace africa=1 if country=="Democratic Republic of the Congo" ///
		| country=="Equatorial Guinea" | country=="S�o Tom� e Pr�ncipe" ///
		| country=="Seychelles"

replace asia=1 if country=="Brunei Darussalam" | country=="Cambodia" ///
				| country=="Thailand" | country=="Timor-Leste" | country == "Cyprus" ///
				| (miss==1 & wb_region=="Middle East & North Africa") ///
				| country == "Bhutan"
				
replace america=1 if country=="Antigua and Barbuda"

replace island=1 if country=="Bahrain" | country=="Cyprus" | ///
		country=="Seychelles" | country=="Timor-Leste"
		
replace island=0 if island==.


foreach k in africa america asia{
	replace `k'=0 if `k'==.
}

gen continent = ""
replace continent = "Africa" if africa==1 
replace continent = "America" if america==1
replace continent = "Asia" if asia==1
replace continent = "Oceania" if africa!=1 & america!=1 & asia!=1
encode continent, gen(region)

/*
1 = Belgium
2 = Britain
3 = France
4 = Germany
5 = Italy
6 = Netherlands
7 = Portugal
8 = Spain
*/

* Adjustment of main colonizer following Acemoglu et al. (2001, 2002)
*replace colonizer=1 if f_belg==1
replace colonizer=2 if f_belg==0 & f_french==0 & f_germ==0 & f_italy==0 ///
		& f_dutch==0 & f_pothco==0 & f_spain==0
replace colonizer=3 if f_french==1
replace colonizer=4 if f_germ==1
replace colonizer=5 if f_italy==1
replace colonizer=6 if f_dutch==1
replace colonizer=7 if f_pothco==1
replace colonizer=8 if f_spain==1

* Errors in Acemoglu (coded as Portuguese)
replace colonizer=6 if country=="Suriname"
replace colonizer=8 if country=="Philippines"



* Macbook Air
save "Data/ColonialEFW.dta", replace

* Clean data, start here.
use "Data/ColonialEFW.dta", clear


* Table 1: Summary Statistics 
sum time_total year_independence avg_efw efw_std efw_2019 delta_efw 
sum time_total year_independence efw_indep efw_std efw_2019 delta_efw if late==1


* Table 2: List of Colonies by Colonizer
bysort colonizer: tab country


* Table 3: Economic Freedom of Colonizer

eststo clear 

*---Column 1: Base Sample	
eststo:reg avg_efw efw_colonizer, vce(robust) 

*---Column 2: Identity of Colonizer
eststo: reg avg_efw efw_colonizer if first>=1850, vce(robust)

*---Column 3: No Africa
eststo:reg avg_efw efw_colonizer if africa!=1, vce(robust)
	
*---Column 4: No Americas
eststo:reg avg_efw efw_colonizer if america!=1, vce(robust)

*---Column 5: With continent dummies
eststo:reg avg_efw efw_colonizer america africa asia, vce(robust)

*---Column 6: Without neo-Europes
eststo: reg avg_efw efw_colonizer if rich4!=1, vce(robust)

*---Column 7: Controlling for latitude 
eststo:reg avg_efw efw_colonizer lat_abst landlock island, vce(robust)

*---Column 8: Controlling for timing
eststo: reg avg_efw efw_colonizer first year_independence, vce(robust)

*---Column 9: Multiple Colonizers 
eststo: reg avg_efw efw_colonizer multiple, vce(robust)

local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
esttab using "`path'/Results/Table3.tex", replace star(* 0.10 ** 0.05 *** 0.01) se r2 

* Table 4: Length of Colonial Rule 
eststo clear

*---Column 1: Base Sample	
eststo: reg avg_efw centuries, vce(robust) 

*---Column 2: Identity of Colonizer
eststo: reg avg_efw centuries i.colonizer, vce(robust)

*---Column 3: No Africa
eststo: reg avg_efw centuries i.colonizer if africa!=1, vce(robust)
	
*---Column 4: No Americas
eststo:reg avg_efw centuries  i.colonizer if america!=1, vce(robust)

*---Column 5: With continent dummies
eststo:reg avg_efw centuries  i.colonizer  america africa asia, vce(robust)

*---Column 6: Without neo-Europes
eststo: reg avg_efw centuries  i.colonizer if rich4!=1, vce(robust)

*---Column 7: Controlling for latitude 
eststo:reg avg_efw centuries  i.colonizer  lat_abst landlock island, vce(robust)

*---Column 8: Controlling for climate 
eststo: reg avg_efw centuries  i.colonizer  humid* temp* steplow  deslow ///
				stepmid desmid  drystep hiland drywint, vce(robust)

test  humid1 = humid2 = humid3 = humid4 = 0
test  temp1 = temp2 =temp3 = temp4 = temp5 = 0  
test steplow = deslow = stepmid = desmid = drystep = hiland = drywint = 0 

*---Column 9: Controlling for natural resources 
eststo: reg avg_efw centuries i.colonizer  goldm iron silv zinc oilres, vce(robust)

test goldm = iron =  silv = zinc = oilres = 0

local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
esttab using "`path'/Results/Table4.tex", replace star(* 0.10 ** 0.05 *** 0.01) se r2 

* Note on Columns (3) and (4)

* Results become significant if I remove Neo-Europes or Neo-Europes+Singapore

reg avg_efw centuries i.colonizer if africa!=1 & rich4==0, vce(robust)
reg avg_efw centuries i.colonizer if america!=1 & rich4==0, vce(robust)


************** LATE INDEPENDENCY SAMPLE (late==1) *******************

* Table 5: Economic Freedom of Colonizer

eststo clear 

*---Column 1: Base Sample	
eststo:reg efw_indep efw_colonizer if late==1, vce(robust) 

*---Column 2: Post-1850
eststo: reg efw_indep efw_colonizer if first>=1850 & late==1, vce(robust)

*---Column 3: No Africa
eststo:reg efw_indep efw_colonizer if africa!=1 & late==1, vce(robust)
	
*---Column 4: No Americas
eststo:reg efw_indep efw_colonizer if america!=1 & late==1, vce(robust)

*---Column 5: With continent dummies
eststo:reg efw_indep efw_colonizer america africa asia if late==1, vce(robust)

*---Column 6: Controlling for latitude 
eststo:reg efw_indep efw_colonizer lat_abst landlock island if late==1, vce(robust)

*---Column 7: Controlling for timing
eststo: reg efw_indep efw_colonizer first year_independence if late==1, vce(robust)

*---Column 8: Multiple Colonizers 
eststo: reg efw_indep efw_colonizer multiple if late==1, vce(robust)

local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
esttab using "`path'/Results/Table5.tex", replace star(* 0.10 ** 0.05 *** 0.01) se r2



* Table 6: Length of Colonial Rule

eststo clear

*---Column 1: Base Sample	
eststo: reg efw_indep centuries if late==1, vce(robust)

*---Column 2: Identity of Colonizer
eststo: reg efw_indep centuries i.colonizer if late==1, vce(robust)

*---Column 2: No Africa
eststo: reg efw_indep centuries i.colonizer if africa!=1 & late==1, vce(robust)
	
*---Column 3: No Americas
eststo: reg efw_indep centuries  i.colonizer if america!=1 & late==1, vce(robust)

*---Column 5: With continent dummies
eststo:reg efw_indep centuries  i.colonizer america africa asia if late==1, vce(robust)

*---Column 6: Controlling for Gap
eststo:reg efw_indep centuries  i.colonizer year_independence if late==1, vce(robust)

*---Column 7: Controlling for latitude 
eststo:reg efw_indep centuries  i.colonizer lat_abst landlock island if late==1, vce(robust)

*---Column 8: Controlling for climate 
eststo: reg efw_indep centuries  i.colonizer  humid* temp* steplow  /// 
		deslow stepmid desmid  drystep hiland drywint if late==1, vce(robust)
test  humid1 = humid2 = humid3 = humid4 = 0
test  temp1 = temp2 =temp3 = temp4 = temp5 = 0  
test steplow = deslow = stepmid = desmid = drystep = hiland = drywint = 0 

*---Column 9: Controlling for natural resources 
eststo: reg efw_indep centuries i.colonizer  goldm iron silv zinc oilres if late==1, vce(robust)
test goldm = iron =  silv = zinc = oilres = 0

local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
esttab using "`path'/Results/Table6.tex", replace star(* 0.10 ** 0.05 *** 0.01) se r2 


** Note: dropping the colonizer fixed effects makes 6 and 7 significant
* column 8 at p=0.108 and column 9 at 0.001


******* APPENDIX A ****** 
**** Data Description ***

* Summary Statistics (Table A1)

bysort colonizer: sum time_total year_independence efw 
sum time_total year_independence efw if efw!=.


************ APPENDIX B *************
****** OTHER ROBUSTNESS CHECKS ******

*---Table B1 - By Area of EFW: Economic Freedom of Colonizer
eststo clear
eststo:reg Area1 efw_colonizer, vce(robust) 
eststo:reg Area2 efw_colonizer, vce(robust) 
eststo:reg Area3 efw_colonizer, vce(robust) 
eststo:reg Area4 efw_colonizer, vce(robust) 
eststo:reg Area5 efw_colonizer, vce(robust) 
eststo:reg std efw_colonizer, vce(robust) 
eststo:reg avg_efw efw_colonizer, vce(robust)
local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
esttab using "`path'/Results/TableB1.tex", replace star(* 0.10 ** 0.05 *** 0.01) se r2 


*---Table B2 - By Area of EFW: Centuries
eststo clear
eststo: reg Area1 centuries i.colonizer, vce(robust) 
eststo: reg Area2 centuries i.colonizer, vce(robust) 
eststo: reg Area3 centuries i.colonizer, vce(robust) 
eststo: reg Area4 centuries i.colonizer, vce(robust) 
eststo: reg Area5 centuries i.colonizer, vce(robust) 
eststo: reg std centuries i.colonizer, vce(robust) 
eststo: reg avg_efw centuries i.colonizer, vce(robust) 

local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
esttab using "`path'/Results/TableB2.tex", replace star(* 0.10 ** 0.05 *** 0.01) se r2 



*---Table B3 - Controlling for pre-colonial population density
eststo clear
*---Column 1: Base Sample	
eststo:reg avg_efw efw_colonizer lpd1500s, vce(robust) 

*---Column 2: Base Sample	
eststo:reg efw_indep efw_colonizer lpd1500s if late==1, vce(robust) 

*---Column 3: Identity of Colonizer
eststo: reg avg_efw centuries i.colonizer lpd1500s, vce(robust)

*---Column 4: Identity of Colonizer
eststo: reg efw_indep centuries i.colonizer lpd1500s if late==1, vce(robust)

*---Column 5: Both
eststo: reg avg_efw efw_colonizer centuries, vce(robust)

*---Column 6: Both
eststo: reg avg_efw c.efw_colonizer##c.centuries, vce(robust)

local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
esttab using "`path'/Results/TableB3.tex", replace star(* 0.10 ** 0.05 *** 0.01) se r2 



*---Table B4 - Longest Robustness Check: Length of colonial rule

eststo clear

*---Column 1: Base Sample	
eststo: reg efw_indep centuries if late==1, vce(robust)

*---Column 2: Identity of Colonizer
eststo: reg efw_indep centuries i.longest if late==1, vce(robust)

*---Column 2: No Africa
eststo: reg efw_indep centuries i.longest if africa!=1 & late==1, vce(robust)
	
*---Column 3: No Americas
eststo: reg efw_indep centuries  i.longest if america!=1 & late==1, vce(robust)

*---Column 5: With continent dummies
eststo:reg efw_indep centuries  i.longest america africa asia if late==1, vce(robust)

*---Column 6: Controlling for Gap
eststo:reg efw_indep centuries  i.longest year_independence if late==1, vce(robust)

*---Column 7: Controlling for latitude 
eststo:reg efw_indep centuries  i.longest lat_abst landlock island if late==1, vce(robust)

*---Column 8: Controlling for climate 
eststo: reg efw_indep centuries  i.longest  humid* temp* steplow  /// 
		deslow stepmid desmid  drystep hiland drywint if late==1, vce(robust)
test  humid1 = humid2 = humid3 = humid4 = 0
test  temp1 = temp2 =temp3 = temp4 = temp5 = 0  
test steplow = deslow = stepmid = desmid = drystep = hiland = drywint = 0 

*---Column 9: Controlling for natural resources 
eststo: reg efw_indep centuries i.longest  goldm iron silv zinc oilres if late==1, vce(robust)
test goldm = iron =  silv = zinc = oilres = 0

local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
esttab using "`path'/Results/TableB4.tex", replace star(* 0.10 ** 0.05 *** 0.01) se r2 




*---Table B5: Delta EFW: Robustness for Late Independence

eststo clear

* Panel A: Economic Freedom of Colonizer

*---Column 1: Base Sample	
eststo: reg delta_efw efw_colonizer if late==1, vce(robust) 

*---Column 2: Identity of Colonizer
eststo: reg delta_efw efw_colonizer multiple if late==1, vce(robust)

*---Column 3: With continent dummies
eststo: reg delta_efw efw_colonizer america africa asia if late==1, vce(robust)

local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
esttab using "`path'/Results/TableB4_A.tex", replace star(* 0.10 ** 0.05 *** 0.01) se r2 

* Panel B: Length of Colonial Rule

eststo clear

*---Column 4: Base Sample	
eststo: reg delta_efw centuries if late==1, vce(robust) 

*---Column 5: Identity of Colonizer
eststo: reg delta_efw centuries i.colonizer if late==1, vce(robust)

*---Column 6: With continent dummies
eststo: reg delta_efw centuries  i.colonizer america africa asia if late==1, vce(robust)

local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
esttab using "`path'/Results/TableB4_B.tex", replace star(* 0.10 ** 0.05 *** 0.01) se r2 



*---Table B6: Std vs. Economic Freedom of Colonizer and Length of Colonial Rule

eststo clear

*---Column 1: Base Sample	
eststo: reg std multiple, vce(robust) 

*---Column 2: Identity of Colonizer
eststo: reg std multiple i.colonizer, vce(robust)

*---Column 3: With continent dummies
eststo: reg std multiple centuries i.colonizer, vce(robust)

local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
esttab using "`path'/Results/TableB6.tex", replace star(* 0.10 ** 0.05 *** 0.01) se r2 



*--- Table B7: Determinants of Colonial Tenure

eststo clear

*--- Panel A: Dep. Variable: First

*--- Column 1: Location
eststo: reg first lat_abst landlock island america africa asia, vce(robust)

*--- Column 2: Climate and Soil
eststo: reg first  humid* temp* steplow deslow stepmid desmid ///
		drystep hiland drywint, vce(robust)
		
test  humid1 = humid2 = humid3 = humid4 = 0
test  temp1 = temp2 =temp3 = temp4 = temp5 = 0  
test steplow = deslow = stepmid = desmid = drystep = hiland = drywint = 0 
		
*--- Column 3: Natural Resources
eststo: reg first  goldm iron silv zinc oilres, vce(robust)

*--- Column 4: Population Density
eststo: reg first lpd1500s, vce(robust)


*--- Panel B: Dep. Variable: Length

*--- Column 1: Location
eststo: reg centuries lat_abst landlock island america africa asia, vce(robust)

*--- Column 2: Climate and Soil
eststo: reg centuries  humid* temp* steplow deslow stepmid desmid ///
		drystep hiland drywint, vce(robust)
test  humid1 = humid2 = humid3 = humid4 = 0
test  temp1 = temp2 =temp3 = temp4 = temp5 = 0  
test steplow = deslow = stepmid = desmid = drystep = hiland = drywint = 0 
		
*--- Column 3: Natural Resources
eststo: reg centuries  goldm iron silv zinc oilres, vce(robust)

*--- Column 4: Population Density
eststo: reg centuries lpd1500s, vce(robust)


local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
esttab using "`path'/Results/TableB5.tex", replace star(* 0.10 ** 0.05 *** 0.01) se r2 


eststo clear



* Map: EFW colonizer weights

reg avg_efw efw_colonizer, vce(robust) 
psacalc delta efw_colonizer

predict pd3

gen wts3 = (efw_colonizer-pd3)^2
egen sumwts3 = sum(wts3)
gen relwt3 = wts3/sumwts3

* Map: Centuries weights
reg avg_efw centuries i.colonizer, vce(robust)
psacalc delta centuries

predict pd4

gen wts4 = (centuries-pd4)^2
egen sumwts4 = sum(wts4)
gen relwt4 = wts4/sumwts4

export excel using "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy/Data/ColonialEFW.xlsx", firstrow(variables) replace



**** Plots

twoway (scatter avg_efw centuries, colorvar(region)) (lfit avg_efw centuries)


twoway (scatter avg_efw centuries) (lfit avg_efw centuries) if rich4!=1, by(region)
	  


