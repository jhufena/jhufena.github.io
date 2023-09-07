// -----------------------------------
// Duration of pre-KT dialysis
// -----------------------------------
*Preemptive*
gen rec_preemptive=0*(rec_pretx_dial=="Y")+1*(rec_pretx_dial=="N")
replace rec_preemptive=. if inlist(rec_pretx_dial,"U","")
label var rec_preemptive "Preemptive Tx"
label define rec_preemptive 0 "Tx after dialysis" 1 "Premptive Tx"
label values rec_preemptive rec_preemptive
.
*Continous (based on time)*
gen rec_dial_con=(rec_tx_dt-rec_dial_dt)/365.25
replace rec_dial_con=. if rec_dial_con<0
replace rec_dial_con=0 if rec_preemptive==1
// Some folks had rec_dial_con but preemptive=1. We need to account for that
replace rec_dial_con=. if rec_dial_con>rec_age
label var rec_dial_con "Time on dialysis pre-tx,in years"
*Categorical*

gen rec_dial4=0*(rec_premptive==1)+1*(rec_dial_con<=2)+2*(rec_dial_con>2 & rec_dial_con<=6)+3*(rec_dial_
replace rec_dial4=. if rec_dial_con==.
label var rec_dial4 "Time on dialysis pre-KTx,categorical"
label define rec_dial4 0 "Preemptive" 1  "<=2yr including preemptive" 2 "(2-6]" 3 ">6yr"
label values rec_dial4 rec_dial4
*******
//start with the transplant recipients
use E:\data\srtr1407\stata\kipa\tx_ki, clear
keep px_id pers_id org_ty rec_tx_dt *death*dt rec_age_at_tx can_diab can_abo can_gender can_race tfl_gra
append using E:\data\srtr1407\stata\kipa\tx_kp, keep(px_id pers_id org_ty rec_tx_dt *death*dt rec_age_at
drop if org_ty=="PA"
//years of prior dialysis / transplant
merge 1:1 px_id using E:\data\srtr1407\stata\kipa\cand, keepusing(can_dial_dt)
drop if _merge==2
drop _merge
gen origin_dt=rec_tx_dt
assert !mi(origin_dt)
gen date=origin_dt
gen kf = min(rec_tx_dt, rec_dial_dt, pers_esrd_first_dial_dt,can_dial_dt)
bys pers_id: egen kfail = min(kf)
gen years_rrt = origin_dt - kfail
replace years_rrt=0 if years_rrt<0 | mi(years_rrt)
//merge with transplant dataset based on px_id; obtain time to graft failure
preserve
tempfile years_kt
//correct failaure date from the two dataset
replace tfl_graft_dt=tfl_graft_dt_ki if mi(tfl_graft_dt)
replace pers_retx=pers_retxki if mi(pers_retx)
gen gfail_dt=min(tfl_graft_dt,rec_esrd_fail_dt,rec_esrd_grf_fail_dt,pers_retx,rec_fail_dt,rec_resum_main
keep pers_id rec_tx_dt gfail_dt
//graft failed before transplant date is regarded as 0 transplant day
replace gfail_dt = rec_tx_dt if gfail_dt < rec_tx_dt
//modify graft failure date by next transplant
sort pers_id rec_tx_dt
by pers_id: replace gfail_dt=min(gfail_dt,rec_tx_dt[_n+1])
by pers_id: gen tx_n=_n
sum tx_n
local n=r(max
reshape wide rec_tx_dt gfail_dt, i(pers_id) j(tx_n)
keep pers_id rec_tx_dt1-rec_tx_dt`n' gfail_dt1-gfail_dt`n'
duplicates drop
isid pers_id
save `years_kt', replace
restore
merge m:1 pers_id using `years_kt'
assert _merge==3
drop _merge
//accumulate previous transplant days
gen years_kt=0


forvalues j= 1/`n' {
                    quietly replace years_kt=years_kt+min(gfail_dt`j',origin_dt)-rec_tx_dt`j' if origin_
}
replace years_rrt=0 if mi(years_rrt) | years_rrt<0
assert years_rrt>=years_kt
isid px_id
keep px_id years_rrt years_kt
gen years_dial=years_rrt-years_kt
******
