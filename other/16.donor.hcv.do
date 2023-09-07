
// -----------------------------------
// Donor HCV
// -----------------------------------
1. This code assumes don_anti_hcv==. as HCV(-). Don't do this if HCV is an important variable in your st
gen don_hcv=don_anti_hcv=="P"
label var don_hcv "Donor HCV Ab"
label define don_hcv 0 "Neg/I" 1 "Pos"
label values don_hcv don_hcv
2. When Donor HCV is crucial part of analysis do not assume missing is HCV negative
global srtrdir="/dcs01/igm/segevlab/data/srtr1509/public"
local ddfile="$srtrdir/donor_deceased.dta"
use `ddfile',clear  //Separate file for live donor. Need to do some merging after this
gen don_hcv=.
replace don_hcv=1 if don_anti_hcv=="P"
4
replace don_hcv=0 if don_anti_hcv=="N"
label var don_hcv "Donor HCV Ab"
label define don_hcv 0 "Neg/I" 1 "Pos"
label values don_hcv don_hcv
