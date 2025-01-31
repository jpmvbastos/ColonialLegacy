*--- Table C : Sensitivity Analysis 

ssc install regsensitivity

local path 

use "`path'/ColonialEFW.dta", clear

log using "`path'/sensitivity-log.smcl'"

**** TABLE 3

global w1 "america africa asia lat_abst landlock island"

global model3 "ruggedness logem4 lpd1500s humid* temp* steplow  deslow stepmid desmid drystep hiland drywint goldm iron silv zinc oilres i.colonizer"

global model4 "ruggedness logem4 lpd1500s humid* temp* steplow  deslow stepmid desmid  drystep hiland drywint goldm iron silv zinc oilres legor_fr legor_uk i.colonizer"


* Rybar = Rxbar, c=1
regsensitivity breakdown avg_efw efw_colonizer $w1 $model3, rybar(=rxbar) ///
	compare($w1) 
	
regsensitivity breakdown avg_efw efw_colonizer $w1 $model4, rybar(=rxbar) ///
	compare($w1) 
	
ereturn clear
clear results
clear mata 
clear matrix 
clear ado

**** TABLE 4 - Timing and Alternative Measures

global baseline "ruggedness lpd1500s"

gen postwar_int = postwar*hiel_indep


* Rybar = Rxbar, c=1
regsensitivity breakdown avg_efw postwar $w1 $baseline i.colonizer_indep, compare($w1) ///  Column 4
	rybar(=rxbar) 
regsensitivity breakdown avg_efw postwar_int $w1 $baseline i.colonizer_indep, compare($w1) /// Column 5
	rybar(=rxbar) 
	
memory 
ereturn clear
clear results
clear mata 
clear matrix 
clear ado
memory
	
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

** Rybar = Rxbar, c=1

* Avg. HIEL
regsensitivity breakdown avg_efw efw_colonizer euro_share $w1 $baseline, compare($w1) ///  Column 2
	rybar(=rxbar) 
	
* Euro Share
regsensitivity breakdown avg_efw euro_share efw_colonizer $w1 $baseline, compare($w1) ///  Column 2
	rybar(=rxbar) 
	

memory 
ereturn clear
clear results
clear mata 
clear matrix 
clear ado
memory

* Panel B: Share Euro

** Rybar = Rxbar, c=1

* Avg. HIEL
regsensitivity breakdown avg_efw efw_colonizer share_euro $w1 $baseline, compare($w1) ///  Column 2
	rybar(=rxbar) 
	
regsensitivity breakdown avg_efw efw_colonizer share_euro $w1 $model4, compare($w1) ///  Column 3
	rybar(=rxbar) 
	
regsensitivity breakdown avg_efw efw_colonizer share_euro hiel_share_euro $w1 $baseline, compare($w1) ///  Column 5
	rybar(=rxbar) 
	
regsensitivity breakdown avg_efw efw_colonizer share_euro hiel_share_euro $w1 $model4, compare($w1) ///  Column 6
	rybar(=rxbar) 
	
memory 
ereturn clear
clear results
clear mata 
clear matrix 
clear ado
memory

* Euro Origins 
	
regsensitivity breakdown avg_efw share_euro efw_colonizer hiel_share_euro $w1 $model4, compare($w1) ///  Column 6
	rybar(=rxbar) 
	
* Avg. HIEL X Euro Origins 
	
regsensitivity breakdown avg_efw hiel_share_euro share_euro efw_colonizer $w1 $model4, compare($w1) ///  Column 6
	rybar(=rxbar) 
	
memory 
ereturn clear
clear results
clear mata 
clear matrix 
clear ado
memory

* Panel C: Share Euro 2  

** Rybar = Rxbar, c=1

* Avg. HIEL
regsensitivity breakdown avg_efw efw_colonizer share_euro2 $w1 $baseline, compare($w1) ///  Column 2
	rybar(=rxbar) 
	
regsensitivity breakdown avg_efw efw_colonizer share_euro2 $w1 $model4, compare($w1) ///  Column 3
	rybar(=rxbar) 
	
regsensitivity breakdown avg_efw efw_colonizer share_euro2 hiel_share_euro2 $w1 $baseline, compare($w1) ///  Column 5
	rybar(=rxbar) 
	
regsensitivity breakdown avg_efw efw_colonizer share_euro2 hiel_share_euro2 $w1 $model4, compare($w1) ///  Column 6
	rybar(=rxbar) 
	
memory 
ereturn clear
clear results
clear mata 
clear matrix 
clear ado
memory	

* Euro Origins 
	
regsensitivity breakdown avg_efw share_euro2 efw_colonizer hiel_share_euro2 $w1 $model4, compare($w1) ///  Column 6
	rybar(=rxbar) 
	
* Avg. HIEL X Euro Origins 
	
regsensitivity breakdown avg_efw hiel_share_euro2 share_euro2 efw_colonizer $w1 $model4, compare($w1) ///  Column 6
	rybar(=rxbar) 
	
memory 
ereturn clear
clear results
clear mata 
clear matrix 
clear ado
memory

*** Table 6:

use  "`path'/ColonialEFW_Panel.dta", clear
use  "Data/ColonialEFW_Panel.dta", clear

global full_indep "year america africa asia lat_abst landlock island humid* temp* steplow  deslow stepmid desmid  drystep hiland drywint goldm iron silv zinc ruggedness logem4 lpd1500s legor_uk legor_fr i.year i.colonizer_indep"

global full_avg "year america africa asia lat_abst landlock island humid* temp* steplow  deslow stepmid desmid  drystep hiland drywint goldm iron silv zinc ruggedness logem4 lpd1500s legor_uk legor_fr i.year i.colonizer"

global baseline_panel "year ruggedness logem4 lpd1500s i.year"

gen indep_time = hiel_indep * time
gen avg_time = efw_colonizer* time

memory 
ereturn clear
clear results
clear mata 
clear matrix 
clear ado
memory


** Rybar = Rxbar, c=1

* Column 3

* HIEL Indep
regsensitivity breakdown efw hiel_indep indep_time time $full_indep ///
	if year >= year_independence, compare($w1) ///
	rybar(=rxbar) 

* HIEL Indep X Years since Indep  
regsensitivity breakdown efw indep_time hiel_indep time $full_indep ///
	if year>=year_indep, compare($w1) ///
	rybar(=rxbar) 
	


memory 
ereturn clear
clear results
clear mata 
clear matrix 
clear ado
memory

* Column 5

* HIEL Indep
regsensitivity breakdown efw efw_colonizer avg_time time $baseline_panel $w1 ///
	if year >= year_independence, ///
	compare($w1) ///
	rybar(=rxbar) 
	
* HIEL Indep X Years since Indep  
regsensitivity breakdown efw avg_time efw_colonizer time $baseline_panel $w1 ///
	if year >= year_independence, ///
	compare($w1) ///
	rybar(=rxbar) 
	
memory 
ereturn clear
clear results
clear mata 
clear matrix 
clear ado
memory


* Column 6 
	
* Avg. HIEL
regsensitivity breakdown efw efw_colonizer avg_time time $full_avg ///
	if year >= year_independence, compare($w1) ///
	rybar(=rxbar) 
	
	

* Avg. HIEL X Years since Indep  
regsensitivity breakdown efw avg_time efw_colonizer time $full_avg ///
	if year>=year_indep, compare($w1) ///
	rybar(=rxbar) 
memory 
ereturn clear
clear results
clear mata 
clear matrix 
clear ado
memory


log close 
