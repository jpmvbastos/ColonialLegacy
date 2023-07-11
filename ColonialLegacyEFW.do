import excel "/Users/joamacha/Library/CloudStorage/OneDrive-TexasTechUniversity/Personal/Projects/Code/GitHub/ColonialLegacy/colonies.xlsx", sheet("Sheet1") firstrow clear

merge 1:1 country_code using "/Users/joamacha/Library/CloudStorage/OneDrive-TexasTechUniversity/Personal/Projects/Code/GitHub/ColonialLegacy/AJRRevFortune.dta"

drop Year ISO_Code_2 Countries ISO_Code_3 closest

rename independence year_independence
rename time_indep time_indep_interim
gen time_indep = 2000-year_independence


gen diff = efw_year - year_independence
gen delta_efw = efw_2019 - efw_indep

replace simultaneous = 0 if simultaneous ==.

replace time_total = time_total - simultaneous

gen multiple = 0
replace multiple = 1 if ncolonizers > 1

drop colonizer
encode main, gen(colonizer)

/*
gen main_colonizer = ""
replace main_colonizer = "Netherlands" if time_netherlands==1 & ncolonizers==1
replace main_colonizer = "Belgium" if col_belgium == 1 & ncolonizers==1
replace main_colonizer = "Italy" if col_italy == 1 & ncolonizers==1
replace main_colonizer = "Britain" if col_britain == 1 & ncolonizers==1
replace main_colonizer = "Portugal" if col_portugal == 1 & ncolonizers==1
replace main_colonizer = "Spain" if col_spain == 1 & ncolonizers==1
replace main_colonizer = "Germany" if col_germany == 1 & ncolonizers==1
replace main_colonizer = "France" if col_france==1  & ncolonizers==1

*/

foreach k in belgium britain france germany italy netherlands portugal spain {
	
	gen `k' = 0
	replace `k' = 1 if time_`k' > 0
	drop if time_`k' < 0
}


foreach k in britain france spain {
	reg efw time_`k' if col_`k'==1
}

eststo clear

*---Column 1: Base Sample	
eststo:reg efw time_total 

*---Column 2: Identity of Colonizer
eststo:reg efw time_total i.colonizer 

*---Column 2: No Africa
eststo:reg efw time_total i.colonizer if africa!=1
	
*---Column 3: No Americas
eststo:reg efw time_total  i.colonizer if america!=1

*---Column 5: With continent dummies
eststo:reg efw time_total  i.colonizer  america africa asia

*---Column 6: Without neo-Europes
eststo:reg efw time_total  i.colonizer if rich4!=1

*---Column 7: Controlling for latitude 
eststo:reg efw time_total  i.colonizer  lat_abst landlock

*---Column 8: Controlling for climate 
eststo: reg efw time_total  i.colonizer  humid* temp* steplow  deslow stepmid desmid  drystep hiland drywint

*---Column 9: Controlling for natural resources 
eststo: reg efw time_total i.colonizer  goldm iron silv zinc oilres

C
