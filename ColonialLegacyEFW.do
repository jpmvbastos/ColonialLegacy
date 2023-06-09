import excel "/Users/joamacha/Library/CloudStorage/OneDrive-TexasTechUniversity/Personal/Projects/Code/GitHub/ColonialLegacy/colonies.xlsx", sheet("Sheet1") firstrow clear


rename independence year_independence
gen time_indep = 2000-year_independence


foreach k in belgium britain france germany italy netherlands portugal spain {
	
	gen `k' = 0
	replace `k' = 1 if time_`k' > 0
	drop if time_`k' < 0
}

