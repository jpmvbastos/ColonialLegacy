* PATHS

* Mac Office
local path "/Users/joamacha/Library/CloudStorage/OneDrive-TexasTechUniversity/Personal/Projects/Code/GitHub/ColonialLegacy"

* Macbook Air
local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"

import excel "`path'/Data/colonies.xlsx", sheet("Sheet1") firstrow clear

merge 1:1 country_code using "`path'/Data/AJRRevFortune.dta"

drop _merge Year ISO_Code_2 Countries ISO_Code_3 closest
drop if _n>128

rename independence year_independence
rename time_indep time_indep_interim
gen time_indep = 2000-year_independence
gen lag_efw = efw_year - year_independence

gen centuries = time_total/100

gen diff = efw_year - year_independence
gen delta_efw = efw_2019 - efw_indep

replace simultaneous = 0 if simultaneous ==.
replace time_total = time_total - simultaneous


* Adjusting missing continents 

gen miss=1 if  asia!=1 & america!=1  & africa!=1

replace africa=1 if country=="Democratic Republic of the Congo" ///
		| country=="Equatorial Guinea" | country=="S�o Tom� e Pr�ncipe" ///
		| country=="Seychelles"

replace asia=1 if country=="Brunei Darussalam" | country=="Cambodia" ///
				| country=="Thailand" | country=="Timor-Leste" | country == "Cyprus" ///
				| (miss==1 & WorldBankRegion=="Middle East & North Africa") ///
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

gen multiple = 0
replace multiple = 1 if ncolonizers > 1

drop colonizer
encode main, gen(long_colonizer) /* Longest */
encode main, gen(colonizer) 

drop if efw==.

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
local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
save "`path'/Data/ColonialEFW.dta", replace


local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
use "`path'/Data/ColonialEFW.dta"


* Summary Statistics (Table 1)

sum time_total year_independence efw efw_std efw_2019 delta_efw 
sum time_total year_independence efw efw_std efw_2019 delta_efw if late==1


* Main Results (Table 2)
eststo clear

*---Column 1: Base Sample	
eststo:reg efw centuries, vce(robust) 

*---Column 2: Identity of Colonizer
eststo: reg efw centuries i.colonizer, vce(robust)

*---Column 2: No Africa
eststo:reg efw centuries i.colonizer if africa!=1, vce(robust)
	
*---Column 3: No Americas
eststo:reg efw centuries  i.colonizer if america!=1, vce(robust)

*---Column 5: With continent dummies
eststo:reg efw centuries  i.colonizer  america africa asia, vce(robust)

*---Column 6: Without neo-Europes
eststo:reg efw centuries  i.colonizer if rich4!=1, vce(robust)

*---Column 7: Controlling for latitude 
eststo:reg efw centuries  i.colonizer  lat_abst landlock island, vce(robust)

*---Column 8: Controlling for climate 
eststo: reg efw centuries  i.colonizer  humid* temp* steplow  deslow ///
				stepmid desmid  drystep hiland drywint, vce(robust)

test  humid1 = humid2 = humid3 = humid4 = 0
test  temp1 = temp2 =temp3 = temp4 = temp5 = 0  
test steplow = deslow = stepmid = desmid = drystep = hiland = drywint = 0 

*---Column 9: Controlling for natural resources 
eststo: reg efw centuries i.colonizer  goldm iron silv zinc oilres, vce(robust)
test goldm = iron =  silv = zinc = oilres = 0

local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
esttab using "`path'/Results/Table2.tex", replace star(* 0.10 ** 0.05 *** 0.01) se r2 

* LATE INDEPENDENCY SAMPLE (late==1)

eststo clear

*---Column 1: Base Sample	
eststo:reg efw_indep centuries if late==1, vce(robust)

*---Column 2: Identity of Colonizer
eststo:reg efw_indep centuries i.colonizer if late==1, vce(robust)

*---Column 2: No Africa
eststo:reg efw_indep centuries i.colonizer if africa!=1 & late==1, vce(robust)
	
*---Column 3: No Americas
eststo:reg efw_indep centuries  i.colonizer if america!=1 & late==1, vce(robust)

*---Column 5: With continent dummies
eststo:reg efw_indep centuries  i.colonizer  america africa asia if late==1, vce(robust)

*---Column 6: Controlling for Gap
eststo:reg efw_indep centuries  i.colonizer year_independence if late==1, vce(robust)

*---Column 7: Controlling for latitude 
eststo:reg efw_indep centuries  i.colonizer lat_abst landlock island if late==1, vce(robust)

*---Column 8: Controlling for climate 
*eststo: 
reg efw_indep centuries  i.colonizer  humid* temp* steplow  /// 
		deslow stepmid desmid  drystep hiland drywint if late==1, vce(robust)
test  humid1 = humid2 = humid3 = humid4 = 0
test  temp1 = temp2 =temp3 = temp4 = temp5 = 0  
test steplow = deslow = stepmid = desmid = drystep = hiland = drywint = 0 

*---Column 9: Controlling for natural resources 
*eststo: 
reg efw_indep centuries i.colonizer  goldm iron silv zinc oilres if late==1, vce(robust)
test goldm = iron =  silv = zinc = oilres = 0

local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
esttab using "`path'/Results/Table3.tex", replace star(* 0.10 ** 0.05 *** 0.01) se r2 


**** Standard Deviation and Delta EFW results

*---Column 1: Base Sample	
reg std centuries, vce(robust) 

*---Column 2: Identity of Colonizer
reg std centuries i.colonizer, vce(robust)

*---Column 3: With continent dummies
reg std centuries  i.colonizer  america africa asia, vce(robust)

*---Column 4: Without neo-Europes
reg std centuries  i.colonizer if rich4!=1, vce(robust)

*---Columnd 5: Controlling for multiple colonizers
reg std centuries multiple i.colonizer, vce(robust)



******* APPENDIX A ****** 
**** Data Description ***

* Summary Statistics (Table A1)

bysort colonizer: sum time_total year_independence efw 
sum time_total year_independence efw if efw!=.

eststo clear

*---Table 4 - By Area of EFW
eststo: reg efw centuries i.colonizer, vce(robust) 
eststo: reg Area1 centuries i.colonizer, vce(robust) 
eststo: reg Area2 centuries i.colonizer, vce(robust) 
eststo: reg Area3 centuries i.colonizer, vce(robust) 
eststo: reg Area4 centuries i.colonizer, vce(robust) 
eststo: reg Area5 centuries i.colonizer, vce(robust) 
eststo: reg std centuries i.colonizer, vce(robust) 

local path "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy"
esttab using "`path'/Results/Table4.tex", replace star(* 0.10 ** 0.05 *** 0.01) se r2 


************ APPENDIX B *************
****** OTHER ROBUSTNESS CHECKS ******






