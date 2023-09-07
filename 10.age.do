// -----------------------------------
// Age category
// -----------------------------------
//Recipient Age Categories
    gen rec_age=0 if inrange(rec_age_at,18,44)
      replace rec_age=1 if inrange(rec_age_at,45,54)
      replace rec_age=2 if inrange(rec_age_at,55,64)
      replace rec_age=3 if inrange(rec_age_at,65,101)
        lab var rec_age "Recipient Age Categories"gen
        lab define RECAGE 0 "18-44" 1 "45-54" 2 "55-64" 3 "65+"
        lab values rec_age RECAGE
*For Below: Have to be careful of cut point if the original variable is truly continuous* [PC]
//Recipient Age Categories
gen rec_txage_cat=recode(rec_age_at_tx, 17, 34, 49, 64, 101)
        lab var rec_txage_cat "Recipient Age Categories"
    gen don_age_cat=recode(don_age, 17, 34, 49, 64, 101)
        lab var don_age_cat "Donor Age Categories"
