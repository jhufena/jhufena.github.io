// -----------------------------------
// 1-yr acute rejection
// -----------------------------------
1. Simple version (need to re-test)
use txf_ki.dta, clear
gen fu_time=tfl_px_stat_dt-rec_tx_dt
gen within1yr=(inlist(tfl_fol_cd,3,6,10)|inlist(tfl_fol_cd, 800,801, 998, 999)) & fu_time<366
// within1yr==1 if (1) the data was from 3, 6, 12 months post-KT or (2) death, gloss or ltfu records tha
keep if within1yr==1
gen ar_bin = cond(inrange(tfl_acute_rej_episode, 1, 2), 1, 0) if tfl_acute_rej_episode !=998 & !missing(
gen ar_biopsy=(tfl_acute_rej_biopsy_confirmed==2)
tab ar_bin ar_biopsy
gen ar_treat=.
replace ar_treat=1 if tfl_rej_treat=="Y"
replace ar_treat=0 if tfl_rej_treat=="N"
gen ar_bin_fail=.
replace ar_bin_fail=1 if tfl_fail_rej_acute=="Y"
replace ar_bin_fail=0 if tfl_fail_rej_acute=="N"
gen ar_any=max(ar_bin, ar_biopsy, ar_treat, ar_bin_fail)
collapse (max) ar_any* ar_biopsy (first) rec_tx_dt, by(trr_id)
** ar_biopsy is only if year(rec_tx_dt)>=2004 and may be if ar_any==0.
compress
tempfile ar
save `ar'
global srtrdir="/dcs01/igm/segevlab/data/srtr1509/public"
local rejfile="$srtrdir/txf_ki.dta"
use `rejfile', clear
keep if rec_tx_ty==1   //this code is only for DDKT

gen fu_time=tfl_px_stat_dt-rec_tx_dt
gen m6=((inlist(tfl_fol_cd,3,6)|(inlist(tfl_fol_cd, 800, 998, 999)) & fu_time<183))
gen within1yr=((inlist(tfl_fol_cd,3,6,10)|(inlist(tfl_fol_cd, 800,801, 998, 999)) & fu_time<366))
// within1yr==1 if (1) the data was from 3, 6, 12 months post-KT or (2) death, gloss or ltfu happened wi
gen m24=((inlist(tfl_fol_cd,3,6,10,20)|(inlist(tfl_fol_cd, 800, 801,998, 999)) & fu_time<731))
***Clinical***
rename tfl_acute_rej_episode ar
gen ar_bin= cond(inrange(ar, 1, 2), 1, 0) if ar !=998 & !missing(ar)
replace ar_bin=. if ar==998 | ar==.
***Biopsy***
gen ar_bx=tfl_acute_rej_biopsy_confirmed==2
replace ar_bx=0 if tfl_acute_rej_biopsy_confirmed==3
replace ar_bx=. if tfl_acute_rej_biopsy_confirmed==1 | tfl_acute_rej_biopsy_confirmed==998 | tfl_acute_r
gen ar_bx2=ar_bx
replace ar_bx2=0 if ar_bin==0 & ar_bx2==.
replace ar_bx2=1 if ar_bin==1 & ar_bx2==.
rename tfl_rej_treat ar_treat
replace ar_treat = "1" if ar_treat=="Y"
replace ar_treat = "0" if ar_treat=="N"
replace ar_treat = "" if ar_treat=="U"
destring ar_treat, replace
gen ar_bin_treat=(ar_bin==1 | ar_treat==1)
replace ar_bin_treat=. if ar_bin==. & ar_treat==.
saveold $hcvdir/temp0 ,replace
***Within 6 months***
use $hcvdir/temp0 ,clear
collapse (max) ar_bin_treat ar_bx ar_bx2 ar_bin, by(trr_id m6)
keep if m6==1
drop m6
rename ar_bin ar_bin_6m
rename ar_bx ar_bx_6m
rename ar_bx2 ar_bx2_6m
rename ar_bin_treat ar_bin_treat_6m
label var ar_bin_6m "AR in 6 months, binary"
label define ar_bin_6m 0 "N" 1 "Y"
label values ar_bin_6m ar_bin_6m
label var ar_bx_6m "AR by Bx in 6 months"
label define ar_bx_6m 0 "N" 1 "Y"
label values ar_bx_6m ar_bx_6m
label var ar_bx2_6m "AR by Bx 6 months(missing values filled in by ar_bin)"


label define ar_bx2_6m 0 "N" 1 "Y"
label values ar_bx2_6m ar_bx2_6m
label var ar_bin_treat_6m "AR clinically diagnosed or treated in 6 months"
label define ar_bin_treat_6m 0 "No" 1 "Yes"
label values ar_bin_treat_6m ar_bin_treat_6m
saveold $hcvdir/temp1 ,replace
***Within 1 year***
use $hcvdir/temp0 ,clear
collapse (max) ar_bin_treat ar_bx ar_bx2 ar_bin, by(trr_id within1yr)
keep if within1yr==1
drop within1yr
rename ar_bin ar_bin_1y
rename ar_bx ar_bx_1y
rename ar_bx2 ar_bx2_1y
rename ar_bin_treat ar_bin_treat_1y
label var ar_bin_1y "AR during 1st year, binary"
label define ar_bin_1y 0 "N" 1 "Y"
label values ar_bin_1y ar_bin_1y
label var ar_bx_1y "AR by Bx during 1st year"
label define ar_bx_1y 0 "N" 1 "Y"
label values ar_bx_1y ar_bx_1y
label var ar_bx2_1y "AR by Bx 1st year (missing values filled in by ar_bin0)"
label define ar_bx2_1y 0 "N" 1 "Y"
label values ar_bx2_1y ar_bx2_1y
label var ar_bin_treat_1y "AR clinically diagnosed or treated in 1st year"
label define ar_bin_treat_1y 0 "No" 1 "Yes"
label values ar_bin_treat_1y ar_bin_treat_1y
saveold $hcvdir/temp2 ,replace
***Within 2 years***
use $hcvdir/temp0 ,clear
collapse (max) ar_bin_treat ar_bx ar_bx2 ar_bin, by(trr_id m24)
keep if m24==1
drop m24
rename ar_bin ar_bin_2y
rename ar_bx ar_bx_2y
rename ar_bx2 ar_bx2_2y
rename ar_bin_treat ar_bin_treat_2y
label var ar_bin_2y "AR in 2 years, binary"
label define ar_bin_2y 0 "N" 1 "Y"
label values ar_bin_2y ar_bin_2y


label var ar_bx_2y "AR by Bx in 2 years"
label define ar_bx_2y 0 "N" 1 "Y"
label values ar_bx_2y ar_bx_2y
label var ar_bx2_2y "AR by Bx 2 yearss(missing values filled in by ar_bin)"
label define ar_bx2_2y 0 "N" 1 "Y"
label values ar_bx2_2y ar_bx2_2y
label var ar_bin_treat_2y "AR clinically diagnosed or treated in 2 years"
label define ar_bin_treat_2y 0 "No" 1 "Yes"
label values ar_bin_treat_2y ar_bin_treat_2y
saveold $hcvdir/temp3 ,replace
***Clinical AR outcome for the entire F/U period***
use $hcvdir/temp0 ,clear
collapse (max) ar_bin_treat ar_bx ar_bx2 ar_bin, by(trr_id)
rename ar_bin ar_bin_ever
label var ar_bin_ever "AR binary(ever)"
label define ar_bin_ever 0 "N" 1 "Y"
label values ar_bin_ever ar_bin_ever
rename ar_bx ar_bx_ever
label var ar_bx_ever "AR by Bx(ever)"
label define ar_bx_ever 0 "N" 1 "Y"
label values ar_bx_ever ar_bx_ever
rename ar_bx2 ar_bx2_ever
label var ar_bx2_ever "AR by Bx(ever,adjusted by ar_bin)"
label define ar_bx2_ever 0 "N" 1 "Y"
label values ar_bx2_ever ar_bx2_ever
rename ar_bin_treat ar_bin_treat_ever
label var ar_bin_treat_ever "AR ever diagnosed or treated"
label define ar_bin_treat_ever 0 "N" 1 "Y"
label values ar_bin_treat_ever ar_bin_treat_ever
saveold $hcvdir/temp4 ,replace
****Merging AR variables****
use $hcvdir/temp4 ,clear
merge 1:1 trr_id using $hcvdir/temp1 ,keep(master match) nogen
merge 1:1 trr_id using $hcvdir/temp2 ,keep(master match) nogen
merge 1:1 trr_id using $hcvdir/temp3 ,keep(master match) nogen
