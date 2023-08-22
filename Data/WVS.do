 use "/Users/joamacha/Downloads/WVS_TimeSeries_4_0.dta", clear



collapse (mean) E127 E204 B016 E120 E057 E069_61 E059 E017  S002VS S022 S023 A005 A101 A168 A173 E032 E036, by (COUNTRY_ALPHA)


rename A005 import_work
rename A101 part_union
rename A168 advantageofyou
rename A173 freedom_choice_control
rename B016 trad_growth
rename E017 more_individual
rename E032 freedom_equality
rename E036 private_state_own
rename E057 econ_system_change
rename E059 more_freedom
rename E069_61 trustWTO
rename E120 dem_econ_badly
rename E127 freemarkets
rename E204 market_reform

foreach k in freemarkets market_reform trad_growth dem_econ_badly econ_system_change trustWTO more_freedom more_individual S002VS S022 S023 import_work part_union advantageofyou freedom_choice_control freedom_equality private_state_own {
	
	replace `k' = . if `k'==-4
	
}

export excel using "/Users/joamacha/Library/CloudStorage/OneDrive-TexasTechUniversity/Personal/Projects/Code/GitHub/ColonialLegacy/WVS", firstrow(variables) replace
