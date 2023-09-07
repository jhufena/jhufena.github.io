// -------------------------------------------
// Serum Creatinine ascertainment
// -------------------------------------------

// link to donor_deceased.dta
// ideally want to ascertain terminal serum creatinine of donor before donation

// tx_ki, if missing(don_creat), fill in from donor_deceased don_creat
// don_creat, don_max_creat

// untested: needs work!!!
gen serum_cr = don_creat
merge m:1 donor_id using donor_deceased, keepusing(don_creat? don_max etc..)
replace serum_cr = (don_creat? don_max etc..) if missing(serum_cr)

// donor scr variables from donor_deceased
don_creat don_peak_serum_creat don_final_serum_creat don_alloc_ecd_serum_creat don_max_creat
