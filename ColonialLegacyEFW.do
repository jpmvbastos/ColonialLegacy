import excel "/Users/joamacha/Library/CloudStorage/OneDrive-TexasTechUniversity/Personal/Projects/Code/GitHub/ColonialLegacy/colonies.xlsx", sheet("Sheet1") firstrow clear

merge 1:1 country_code using "/Users/joamacha/Library/CloudStorage/OneDrive-TexasTechUniversity/Personal/Projects/Code/GitHub/ColonialLegacy/AJRRevFortune.dta"


rename independence year_independence
gen time_indep = 2000-year_independence


foreach k in belgium britain france germany italy netherlands portugal spain {
	
	gen `k' = 0
	replace `k' = 1 if time_`k' > 0
	drop if time_`k' < 0
}


foreach k in britain france spain {
	reg efw time_`k' if col_`k'==1
}

*---Column 1: Base Sample	
reg logpgp95 lpd1500s 

*---Column 2: No Africa
reg logpgp95 lpd1500s if africa!=1
	
*---Column 3: No Americas
reg logpgp95 lpd1500s if america!=1
	
*---Column 4: Just Americas
reg logpgp95 lpd1500s if america==1

*---Column 5: With continent dummies
reg logpgp95 lpd1500s america africa asia

*---Column 6: Without neo-Europes
reg logpgp95 lpd1500s if rich4!=1

*---Column 7: Controlling for latitude 
reg logpgp95 lpd1500s  lat_abst

*---Column 8: Controlling for climate 
reg logpgp95 lpd1500s  humid* temp* steplow  deslow stepmid desmid  drystep hiland drywint
