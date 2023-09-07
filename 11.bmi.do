// -----------------------------------
// BMI
// -----------------------------------

gen rec_ht=rec_hgt_cm
replace rec_ht=can_hgt_cm if rec_ht==.
label var rec_ht "Recipient's ht in cm"
gen rec_wt=rec_wgt_kg
replace rec_wt=can_wgt_kg if rec_wt==.
label var rec_wt "Recipient's wt in kg"
*EDA showed that there were recipients with ht<50cm or wt<25kg, spurious*
replace rec_ht=. if rec_ht<50
replace rec_wt=. if rec_wt<25
gen rec_bmi2=rec_wt/((rec_ht/100)^2)
replace rec_bmi2=rec_bmi if rec_bmi2==.
drop rec_bmi
rename rec_bmi2 rec_bmi
label var rec_bmi "Recipient's BMI @ Tx"
**After data checking, decided to convert BMI<14 & BMI>50 to missing**
**CHECK WITH YOUR MENTOR in terms of how you define the "WEIRD" BMI value cut-off!!**
**See bmi_check.do (by Allan) for detail**
replace rec_bmi=. if rec_bmi<14 | (rec_bmi>50 & rec_bmi!=.)
3
*BMI categorical*
gen rec_bmi3=0*(rec_bmi<=25)+1*(rec_bmi>25 & rec_bmi<=30)+2*(rec_bmi>30)
replace rec_bmi3=. if rec_bmi==.
label var rec_bmi3 "Recipient's BMI, 3 categories"
label define rec_bmi3 0 "<=25" 1 "(25-30]" 2 ">30"
label values rec_bmi3 rec_bmi3
