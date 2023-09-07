
// -----------------------------------
// EPTS
// -----------------------------------
//see https://optn.transplant.hrsa.gov/media/1511/guide_to_calculating_interpreting_epts.pdf

gen epts_age25 = max(rec_age_at-25, 0)
//NOTE: not clear how to ascertain post-listing incident DM
gen rec_dm = inrange(can_diab_ty, 2, 5) if inrange(can_diab_ty, 1, 5)
replace rec_dm = inlist(can_diab, 2, 3) if can_diab<=3 & missing(rec_dm)
//NOTE: this is for EPTS as of date of transplant
gen rrt_y = (rec_tx_dt-rec_dial_dt)/365.25
gen byte rec_prev_tx = (rec_prev_ki==1 | rec_prev_li==1 | rec_prev_hr==1 ///
    | rec_prev_lu==1 | rec_prev_pa==1)

gen raw_epts = ///
    0.047*epts_age25 + ///
   -0.015*rec_dm*epts_age25 + ///
    0.398*rec_prev_tx + ///
   -0.237*rec_dm*rec_prev_tx + ///
    0.315*log(rrt_y+1) + ///
    0.130*(rrt_y==0) + ///
   -0.348*rec_dm*(rrt_y==0) + ///
    1.262*rec_dm
sum raw_epts, detail
count if missing(raw_epts)
assert r(N)<100
local N_EPTS = _N-r(N)
sort raw_epts
gen rec_epts = _n/`N_EPTS' if !missing(raw_epts)
