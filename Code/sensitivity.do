*--- Table C : Sensitivity Analysis 
cd "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy/"
use "Data/ColonialEFW.dta", clear

log using "Results/Review/sensitivity.smcl", replace 


**** TABLE 3

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
	
	
**** TABLE 4 - Timing and Alternative Measures

global baseline "ruggedness lpd1500s"

gen postwar_int = postwar*hiel_indep

* Oster (2019)
* Postwar 
regsensitivity breakdown avg_efw postwar $w1 $baseline i.colonizer_indep, compare($w1) ///  Column 4
	oster rlong(1.3, relative) 
* HIEL Indep. X Postwar
regsensitivity breakdown avg_efw postwar_int postwar hiel_indep $w1 $baseline /// Column 5
	i.colonizer_indep, compare($w1) oster rlong(1.3, relative) 
	
*-- DMP (2022)
* 1) Rybar = + inf, c=(0.25, 0.5, 0.75, 1)
regsensitivity breakdown avg_efw postwar $w1 $baseline i.colonizer_indep, cbar(0.25(0.25)1) /// Column 4
	compare($w1) 
regsensitivity breakdown avg_efw postwar_int postwar hiel_indep $w1 $baseline /// Column 5
	i.colonizer_indep, cbar(0.25(0.25)1) compare($w1) 
	
	
**** TABLE 5 - Euro Settlers / Origins

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
regsensitivity breakdown avg_efw efw_colonizer euro_share $w1 $baseline, compare($w1) ///  Column 2
	oster rlong(1.3, relative) 
	
* Euro Share
regsensitivity breakdown avg_efw euro_share efw_colonizer $w1 $baseline, compare($w1) ///  Column 2
	oster rlong(1.3, relative) 
	
	
*-- DMP (2022)
* 1) Rybar = + inf, c=(0.25, 0.5, 0.75, 1)

* Avg. HIEL
regsensitivity breakdown avg_efw efw_colonizer euro_share $w1 $baseline, compare($w1) ///  Column 2
	 cbar(0.25(0.25)1) 
	
* Euro Share
regsensitivity breakdown avg_efw euro_share efw_colonizer $w1 $baseline, compare($w1) ///  Column 2
	 cbar(0.25(0.25)1)

	 
* Panel B: Share Euro

** Oster (2019)

* Avg. HIEL
regsensitivity breakdown avg_efw efw_colonizer share_euro $w1 $baseline, compare($w1) ///  Column 2
	oster rlong(1.3, relative) 
	
regsensitivity breakdown avg_efw efw_colonizer share_euro $w1 $model4, compare($w1) ///  Column 3
	oster rlong(1.3, relative) 
	
regsensitivity breakdown avg_efw efw_colonizer share_euro hiel_share_euro $w1 $baseline, compare($w1) ///  Column 5
	oster rlong(1.3, relative) 
	
regsensitivity breakdown avg_efw efw_colonizer share_euro hiel_share_euro $w1 $model4, compare($w1) ///  Column 6
	oster rlong(1.3, relative) 
	
* Euro Origins 	
regsensitivity breakdown avg_efw share_euro efw_colonizer hiel_share_euro $w1 $model4, compare($w1) ///  Column 6
	oster rlong(1.3, relative) 
	
* Avg. HIEL X Euro Origins 
	
regsensitivity breakdown avg_efw hiel_share_euro share_euro efw_colonizer $w1 $model4, compare($w1) ///  Column 6
	oster rlong(1.3, relative) 
	
	
*-- DMP (2022)
* 1) Rybar = + inf, c=(0.25, 0.5, 0.75, 1)

* Avg. HIEL
regsensitivity breakdown avg_efw efw_colonizer share_euro $w1 $baseline, compare($w1) ///  Column 2
	 cbar(0.25(0.25)1) 
	
regsensitivity breakdown avg_efw efw_colonizer share_euro $w1 $model4, compare($w1) ///  Column 3
	 cbar(0.25(0.25)1) 
	 
regsensitivity breakdown avg_efw efw_colonizer share_euro hiel_share_euro $w1 $baseline, compare($w1) ///  Column 5
	cbar(0.25(0.25)1) 
	
regsensitivity breakdown avg_efw efw_colonizer share_euro hiel_share_euro $w1 $model4, compare($w1) ///  Column 6
	cbar(0.25(0.25)1) 
	
* Euro Origins 
	
regsensitivity breakdown avg_efw share_euro efw_colonizer hiel_share_euro $w1 $model4, compare($w1) ///  Column 6
	cbar(0.25(0.25)1) 
	
* Avg. HIEL X Euro Origins 
	
regsensitivity breakdown avg_efw hiel_share_euro share_euro efw_colonizer $w1 $model4, compare($w1) ///  Column 6
	cbar(0.25(0.25)1)  
	
	
* Panel C: Share Euro 2  

** Oster (2019)

* Avg. HIEL
regsensitivity breakdown avg_efw efw_colonizer share_euro2 $w1 $baseline, compare($w1) ///  Column 2
	oster rlong(1.3, relative) 
	
regsensitivity breakdown avg_efw efw_colonizer share_euro2 $w1 $model4, compare($w1) ///  Column 3
	oster rlong(1.3, relative) 
	
regsensitivity breakdown avg_efw efw_colonizer share_euro2 hiel_share_euro2 $w1 $baseline, compare($w1) ///  Column 5
	oster rlong(1.3, relative) 
	
regsensitivity breakdown avg_efw efw_colonizer share_euro2 hiel_share_euro2 $w1 $model4, compare($w1) ///  Column 6
	oster rlong(1.3, relative) 
	
* Euro Origins 
	
regsensitivity breakdown avg_efw share_euro2 efw_colonizer hiel_share_euro2 $w1 $model4, compare($w1) ///  Column 6
	oster rlong(1.3, relative) 
	
* Avg. HIEL X Euro Origins 
	
regsensitivity breakdown avg_efw hiel_share_euro2 share_euro2 efw_colonizer $w1 $model4, compare($w1) ///  Column 6
	oster rlong(1.3, relative) 
	
	
*-- DMP (2022)
* 1) Rybar = + inf, c=(0.25, 0.5, 0.75, 1)

* Avg. HIEL
regsensitivity breakdown avg_efw efw_colonizer share_euro2 $w1 $baseline, compare($w1) ///  Column 2
	 cbar(0.25(0.25)1) 
	
regsensitivity breakdown avg_efw efw_colonizer share_euro2 $w1 $model4, compare($w1) ///  Column 3
	 cbar(0.25(0.25)1) 
	 
regsensitivity breakdown avg_efw efw_colonizer share_euro2 hiel_share_euro2 $w1 $baseline, compare($w1) ///  Column 5
	cbar(0.25(0.25)1) 
	
regsensitivity breakdown avg_efw efw_colonizer share_euro2 hiel_share_euro2 $w1 $model4, compare($w1) ///  Column 6
	cbar(0.25(0.25)1) 
	
* Euro Origins 
	
regsensitivity breakdown avg_efw share_euro2 efw_colonizer hiel_share_euro2 $w1 $model4, compare($w1) ///  Column 6
	cbar(0.25(0.25)1) 
	
* Avg. HIEL X Euro Origins 
	
regsensitivity breakdown avg_efw hiel_share_euro2 share_euro2 efw_colonizer $w1 $model4, compare($w1) ///  Column 6
	cbar(0.25(0.25)1) 
	

*** Table 6:

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


log close 

/**** TABLE 4

global w1 "america africa asia lat_abst landlock island"

global baseline "ruggedness logem4 lpd1500s"

* Oster (2019)
regsensitivity breakdown avg_efw efw_colonizer $w1 $baseline if first>=1850, compare($w1) /// 
	oster rlong(1.3, relative) 
regsensitivity breakdown avg_efw efw_colonizer $w1 $baseline if africa!=1, compare($w1) /// 
	oster rlong(1.3, relative) 
regsensitivity breakdown avg_efw efw_colonizer $w1 $baseline if america!=1, compare($w1) /// 
	oster rlong(1.3, relative) 
regsensitivity breakdown avg_efw efw_colonizer $w1 $baseline if rich4!=1, compare($w1) /// 
	oster rlong(1.3, relative) 
	
*-- DMP (2022)

* 1) Rybar = + inf, c=(0.25, 0.5, 0.75, 1)
regsensitivity breakdown avg_efw efw_colonizer $w1 $baseline if first>=1850, cbar(0.25(0.25)1) ///
	compare($w1) 
regsensitivity breakdown avg_efw efw_colonizer $w1 $baseline if africa!=1, cbar(0.25(0.25)1) ///
	compare($w1) 
regsensitivity breakdown avg_efw efw_colonizer $w1 $baseline if america!=1, cbar(0.25(0.25)1) ///
	compare($w1) 
regsensitivity breakdown avg_efw efw_colonizer $w1 $baseline if rich4!=1, cbar(0.25(0.25)1) ///
	compare($w1) 





********* RUN SEPARATELY

* Table 4

* 2) Rybar = Rxbar, c=(0.25, 0.5, 0.75, 1)
regsensitivity breakdown avg_efw efw_colonizer $w1 $baseline if first>=1850, rybar(=rxbar) ///
	compare($w1) 
regsensitivity breakdown avg_efw efw_colonizer $w1 $baseline if africa!=1, rybar(=rxbar) ///
	compare($w1) 
regsensitivity breakdown avg_efw efw_colonizer $w1 $baseline if america!=1, rybar(=rxbar) /// 
	compare($w1) 
regsensitivity breakdown avg_efw efw_colonizer $w1 $baseline if rich4!=1, rybar(=rxbar) ///
	compare($w1) 
	
	
* Table 5 

* 2) Rybar = Rxbar, c=(0.25, 0.5, 0.75, 1)
regsensitivity breakdown avg_efw postwar $w1 $baseline i.colonizer_indep, rybar(=rxbar) /// Column 4
	compare($w1) 
regsensitivity breakdown avg_efw postwar_int $w1 $baseline i.colonizer_indep, rybar(=rxbar) /// Column 5
	compare($w1) 
*/

	
