// -------------------------------------------
// transplant date
// -------------------------------------------
//If you only deal with Tx recipients but not candidates, just think about tx_dt

//for waitlist removals and transplant rates when using candidate.dta sets
gen tx_dt= rec_tx_dt
replace tx_dt =can_rem_dt if inlist(can_rem_cd,4)
//if estimating DD transplant rates
replace tx_dt =can_rem_dt if inlist(can_rem_cd,4,18,19,21,22)
replace tx_dt = . if inlist(can_rem_cd,14,15)
//to censor live donors
replace tx_dt = . if can_rem_cd==15
