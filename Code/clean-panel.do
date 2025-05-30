* PATHS

cd "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy/"

import excel "Data/colonies-panel.xlsx", sheet("Sheet1") firstrow clear

merge m:1 country_code using "Data/AJRRevFortune.dta"

rename independence year_independence
rename time_indep time_indep_interim

gen time = year - year_indep

gen time_indep = 2000-year_independence
*gen lag_efw = efw_year - year_independence
gen centuries = time_total/100
gen diff = efw_indep_year - year_independence
*gen delta_efw = efw_2019 - efw_indep
gen gap = 2019 - year_independence
gen postwar = (year_independence > 1945)

replace simultaneous = 0 if simultaneous ==.
replace time_total = time_total - simultaneous

gen multiple = 0
replace multiple = 1 if ncolonizers > 1

encode main, gen(long_colonizer) /* Longest */
encode main, gen(colonizer) 
encode first_hiel_colonizer, gen(first_colonizer)
encode indep_from, gen(colonizer_indep)

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

* Colonizer dummies
tabulate colonizer, generate(colonizer_dummy)

* interaction
gen hiel_indep_time = hiel_indep*time

* Macbook Air
save "Data/ColonialEFW_Panel.dta", replace
