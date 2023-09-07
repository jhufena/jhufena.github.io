// -----------------------------------
// CIT (cold ischemia time/ cold ischemic time)
// -----------------------------------
*Continuous-per hour*
rename rec_cold_isch_tm rec_cit
replace rec_cit=. if rec_cit==99
label var rec_cit "CIT-continuous"
*Define categorical CIT based on distribution*
gen rec_cit3=0*(rec_cit<=12)+1*(rec_cit>12 & rec_cit<=24)+2*(rec_cit>24)
replace rec_cit3=. if missing(rec_cit)
label var rec_cit3 "CIT, 3 categories"
label define rec_cit3 0 "<=12hr" 1 "(12,24]hr" 2 ">24hr"
label values rec_cit3 rec_cit3
