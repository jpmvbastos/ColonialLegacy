** Clean Giuliano and Nunn data

use "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy/Data/Ancestral_Characteristics_Database_Baseline_Version_1_1.dta"

keep isocode v97*

gen share_euro = v97_grp4 / (1-v97_grp1)

drop v97*

rename isocode country_code

save "/Users/jpmvbastos/Documents/GitHub/ColonialLegacy/Data/share-euro-giuliano-nunn.dta", replace
