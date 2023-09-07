// -----------------------------------
// DRI
// -----------------------------------
//you can exclude rec_tx_procedure_ty/sharing/CIT to calculate "adjusted DRI" (pre-tx DRI)
gen log_dri = ///
0.154*(inrange(don_age, 40, 49)) + ///
0.274*(inrange(don_age, 50, 59)) + ///
0.424*(inrange(don_age, 60, 69)) + ///
0.501*(inrange(don_age, 70, 99)) + ///
0.079*(don_cad_don_cod==1) + ///
0.145*(don_cad_don_cod==2) + ///
0.184*(!inlist(don_cad_don_cod, 1, 2, 3)) + ///  // not Anoxia (1), CVA/stroke (2) , or trauma (3)
0.176*(don_race==16) + ///
    0.126*(!inlist(don_race, 8, 16)) + ///
    0.411*(don_non_hr_beat=="Y") + ///
    0.066*((170-don_hgt_cm)/10) +  ///
    0.422*(rec_tx_procedure_ty != 701) + ///
    0.105*(regional_share) + ///
    0.244*(national_share)+ ///
    0.010*(rec_cold_isch_tm)
gen don_dri = exp(log_dri)
