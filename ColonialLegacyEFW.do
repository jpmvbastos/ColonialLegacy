import excel "/Users/joamacha/Library/CloudStorage/OneDrive-TexasTechUniversity/Personal/Projects/Code/GitHub/ColonialLegacy/colonies.xlsx", sheet("Sheet1") firstrow clear

drop if time_britain<0

rename time_belgian time_belgium

foreach k in belgium britain france germany italy netherlands portugal spain {
	
	gen `k' = 0
	replace `k' = 1 if time_`k' > 0
	
}

foreach k in belgium britain france germany italy netherlands portugal spain {
	
	summarize time_`k' if time_`k' > 0
	
}
