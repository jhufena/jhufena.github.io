
// -----------------------------------
// insurance
// -----------------------------------
gen insurance = 2 //"Other"
replace insurance = 1 if rec_primary_pay == 1 | rec_primary_pay == 8
// private (1) & self-pay (8)
replace insurance = 0 if (rec_primary_pay >=2 & rec_primary_pay <= 7) | rec_primary_pay == 13 | rec_prim
replace insurance=. if missing(rec_primary_pay)
label define insurance 0 "Public" 1 "Private" 2 "Other"
label values insurance insurance
