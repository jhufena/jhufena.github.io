// -----------------------------------
// HLA mismatch
// -----------------------------------



// Some notes
rec_mm_equiv_tx is less complete than rec_mm_equiv_cur.
rec_mm_equiv_tx<=rec_mm_equiv_cur

//Continuous HLA is not a continuous concept

rename rec_mm_equiv_tx rec_hla_mis

*Binary-0 yes/no*
gen rec_hla0mis = (rec_hla_mis==0)
replace rec_hla0mis=. if rec_hla_mis==.
label var rec_hla0mis "HLA 100% matched"
label define rec_hla0mis 0 "HLA<100% matched" 1 "HLA100% matched"
label values rec_hla0mis rec_hla0mis

// HLA mismatch level (new SRTR way)
// ascertain A (0,1,2 mismatch or missing), AND DR (0,1,2 mismatch, or missing)
// DR and A is in graft survival, and A in pt-survival (SRTR models, 2015)
// untested code

gen hla_A = .
gen hla_DR = .

replace hla_A = 0 if rec_a_mm_equiv_tx == 0
replace hla_A = 1 if rec_a_mm_equiv_tx == 1
replace hla_A = 2 if rec_a_mm_equiv_tx == 2

replace hla_DR = 0 if rec_dr_mm_equiv_tx == 0
replace hla_DR = 1 if rec_dr_mm_equiv_tx == 1
replace hla_DR = 2 if rec_dr_mm_equiv_tx == 2


//HLA mismatch level (old SRTR way)
gen hla = .
 // 0 mismatch
replace hla=0 if rec_dr_mm_equiv_tx == 0 & rec_b_mm_equiv_tx == 0 & rec_a_mm_equiv_tx == 0
// A/B mismatch
replace hla=1 if rec_dr_mm_equiv_tx == 0 & mi(hla)
// one DR mismatch
replace hla=2 if rec_dr_mm_equiv_tx == 1
// two DR mismatch
replace hla=3 if (rec_dr_mm_equiv_tx == 2 | rec_a_mm_equiv_tx != 0 | rec_b_mm_equiv_tx != 0 | rec_dr_mm_equiv_tx != 0) & mi(hla)

assert !mi(hla)
