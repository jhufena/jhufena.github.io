// -------------------------------------------
// Graft survival / failure GF (death censored and all-cause)
// -------------------------------------------
gen t1=death_dt
replace t1=mdy(03,04,2015) if death_dt>mdy(03,04,2015)
//modify this based on how you define your study period!
****Date for all-cause graft failure****
//Some of these dates included in the brackets are version-specific. Check the SAF dataset you work on t
// rec_esrd_grf_fail_dt & rec_esrd_fail_dt are only in Oct 14 dataset
label var acgf_dt "Date of all-cause graft failure"
//MUST ascertain death_dt prior to estimating gfail_dt
// check that death dates are post transplant
*compare death_dt tx_dt
gen acgf=inrange(acgf_dt,rec_tx_dt,t1)
label var acgf "All-cause graft failure"
label define acgf 0 "Graft functioning up to administrative censor" 1 "Graft failed or died"
label values acgf acgf
****Graft failure date for Death-censored graft failure models****
****DCGF date****
// need to censor death later (still GF if gf_dt == death_dt
gen dcgf_dt = min(tfl_graft_dt, rec_esrd_fail_dt, rec_esrd_grf_fail_dt, pers_retx, rec_fail_dt, rec_resu
// rec_esrd_grf_fail_dt & rec_esrd_fail_dt are only in 1410 dataset
label var dcgf_dt "Date of DCGF"
gen dcgf=inrange(dcgf_dt,rec_tx_dt,min(death_dt, mdy(12,31,2015)))
//Change the date according to your study period
label var dcgf "Death-censored graft failure"
label define dcgf 0 "Graft functioning" 1 "Graft failed <=death date or administrative censor"
label values dcgf dcgf
