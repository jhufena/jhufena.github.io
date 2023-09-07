
// -----------------------------------
// PRA (Panel Reactive Antibody)
// -----------------------------------

****SRTR****
gen rec_peak_pra_con_srtr=can_last_srtr_peak_pra
label var rec_peak_pra_con_srtr "Peak PRA continuous, per SRTR"
*Peak PRA continuous,manually calculated*
egen rec_peak_pra_con_recode=rowmax(rec_pra_most_recent can_last_srtr_peak_pra can_last_alloc_pra can_la
label var rec_peak_pra_con_recode "Peak PRA continuous, manually recoded"
****Highly sensitized, 80% cut off****
gen rec_pra80=(rec_peak_pra_con_recode>80)
replace rec_pra80=. if missing(rec_peak_pra_con_recode)
label var rec_pra80 "Recipient recoded peak PRA>80%"
label define rec_pra80 0 "No" 1 "Yes"
label values rec_pra80 rec_pra80
