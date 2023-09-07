// -----------------------------------
// MELD: INR, Serum CR, bilirubin, dialysis within past week
// -----------------------------------
//MELD AT TX (BIOLOGIC)
  gen byte meld=can_last_srtr_lab_meld - 6200 ///
        if inrange(can_last_srtr_lab_meld, 6206, 6240)
  replace meld=41 if inlist(can_last_srtr_lab_meld, 3010, 6011, 6012) //*urgent*
  replace meld=6 if can_last_srtr_lab_meld ==3020 //"non-urgent*
//MELD AT LISTING (BIOLOGIC)
  gen byte meld_listing=can_init_srtr_lab_meld - 6200 ///
            if inrange(can_init_srtr_lab_meld,6206, 6240)

//anoxia
// CVA/stroke
replace meld_listing=41 if inlist(can_init_srtr_lab_meld, 3010, 6011, 6012) //*urgent*
  replace meld_listing=6 if can_init_srtr_lab_meld ==3020 //"non-urgent*
*MELD AT TX (ALLOCATION)
// status 1A,1B treated as 41
  gen byte meld=can_last_stat - 6200 ///
        if inrange(can_last_stat,6206, 6240)
  replace meld=41 if inlist(can_last_stat, 3010, 6011, 6012) //*urgent*
  replace meld=6 if can_last_stat ==3020 //"non-urgent*
  tab can_last_stat if missing(meld) //make sure these are all inactive
// if inactive (6999) but transplanted (?) or you want to include inactive time on waitlist then replace
// There is an OPTN version! sensitivity analysis
//MELD AT LISTING (ALLOCATION)
  gen byte meld_listing=can_init_stat - 6200 ///
            if inrange(can_init_stat,6206, 6240)
  replace meld_listing=41 if inlist(can_init_stat, 3010, 6011, 6012) //*urgent*
  replace meld_listing=6 if can_init_stat ==3020 //"non-urgent*
  tab can_init_stat if missing(meld_listing) //make sure these are all inactive
//time-varying MELD AT LISTING (ALLOCATION) (stathist.dta)
    gen byte ameld=canhx_stat_cd - 6200 ///
    if inrange(canhx_stat_cd,6206, 6240)
    replace ameld=41 if inlist(canhx_stat_cd, 3010, 6011, 6010, 6012) //*urgent*
    replace ameld=6 if canhx_stat_cd ==3020 //"non-urgent*
    replace ameld = 40 if canhx_stat_cd>6240 & canhx_stat_cd<=6282
    replace ameld=99 if canhx_stat_cd ==6999
    replace ameld = 6 if canhx_stat_cd<6206 & canhx_stat_cd>=6188
