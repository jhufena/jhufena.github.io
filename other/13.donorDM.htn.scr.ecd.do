// -------------------------------------------
// Donor DM, HTN, terminal SCr>1.5, and ECD recode manually
// -------------------------------------------
// definition of ECD: The expanded criteria donor (ECD) is any donor over the age of 60, or a donor over
// antiquated, allocation by KDPI now
// Note: Just use ECD! don_expand_don_ki. Compared with manual coding, consistent
*HTN- maximize information from don_hist_hyperten and don_htn*
tempvar don_htn1
gen `don_htn1'=0*(don_hist_hyperten==1)+1*(inrange(don_hist_hyperten,2,5))
replace `don_htn1'=. if inlist(don_hist_hyperten,998,.)
egen don_htn_bi=rowmax(`don_htn1' don_htn)
label var don_htn_bi "Donor HTN, binary"
label define don_htn_bi 0 "No" 1 "Yes"
label values don_htn_bi don_htn_bi
// ****Donor died from stroke****
gen don_stroke=0*(don_cod_don_stroke==0)+1*(don_cod_don_stroke==1)
replace don_stroke=. if don_cod_don_stroke==. | don_type!=0
label var don_stroke "Donor died from stroke"
label define don_stroke 0 "Died from other reasons" 1 "Died from stroke"
label values don_stroke don_stroke
24
*DM: binary*
gen don_dm=0*(don_hist_diab==1)+1*(don_hist_diab>=2 & don_hist_diab<=5)
replace don_dm=. if inlist(don_hist_diab,.,998)
label var don_dm "Donor DM-binary"
label define don_dm 0 "No" 1 "Yes"
label values don_dm don_dm
****ECD****
***Coded by SRTR***
gen don_ecd_srtr=0*(don_expand_don_ki==0)+1*(don_expand_don_ki==1)
replace don_ecd_srtr=. if don_type!=0
label var don_ecd_srtr "ECD per SRTR"
label define don_ecd_srtr 0 "SCD" 1 "ECD"
label values don_ecd_srtr don_ecd_srtr
****Manual recoding as per Port, Transplantation 2002****
gen don_ecd_recode=.
replace don_ecd_recode=1 if don_age>=60
replace don_ecd_recode=1 if inrange(don_age,50,59) & ( ///
                            (don_stroke==1 & don_high_creat==1) |  ///
                            (don_stroke==1 & don_htn_bi==1) | ///
                            (don_high_creat==1 & don_htn_bi==1) | ///
                            (don_stroke==1 & don_high_creat==1 & don_htn_bi==1) ///
                            )
replace don_ecd_recode=0 if don_age<50 | ///
                            (inrange(don_age,50,59) & ///
                            ((don_stroke==0 & don_high_creat==0) |  ///
                            (don_stroke==0 & don_htn_bi==0) | ///
                            (don_high_creat==0 & don_htn_bi==0) | ///
                            (don_stroke==0 & don_high_creat==0 & don_htn_bi==0)) ///
                            )
label var don_ecd_recode "ECD recoded by hand"
label define don_ecd_recode 0 "No" 1 "Yes"
label values don_ecd_recode don_ecd_recode
tab don_ecd_srtr don_ecd_recode
