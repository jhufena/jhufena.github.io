// -----------------------------------
// Recipient HCV
// -----------------------------------
This assumes rec_hcv_stat==. as HCV negative. Don't do this if HCV is an important variable in your stud
gen rec_hcv=rec_hcv_stat=="P" //rec_hcv_stat: recipient HCV serostatus
replace rec_hcv=1 if inlist(can_dgn, ///
    4104,4106,4204,4206,4216,4593),1,0) if !missing(can_dgn)
replace hcv=1 if inlist(can_dgn2, ///
    4104,4106,4204,4206,4216,4593) & !missing(can_dgn2)
2. HCV as exposure
    gen rec_hcv=cond(rec_hcv_stat=="P",1,cond(rec_hcv_stat=="N",0,.))
replace rec_hcv=1 if inlist(can_dgn, ///
        4104,4106,4204,4206,4216,4593),1,0) if !missing(can_dgn)
replace rec_hcv=1 if inlist(can_dgn2, ///
        4104,4106,4204,4206,4216,4593) & !missing(can_dgn2)
label var rec_hcv "Recipient HCV pos,binary"
label define rec_hcv 0 "HCV neg" 1 "HCV pos"
label values rec_hcv rec_hcv
