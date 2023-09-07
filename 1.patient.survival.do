// -------------------------------------------
// Patient survival /death
// -------------------------------------------

*Date of mortality*
egen death_dt = rowmin( pers_ssa_death_dt pers_optn_death_dt pers_restrict_death_dt tfl_death_dt)
label var death_dt "Date of death"
****A time metric taking administrative censoring into consideration****
gen t1=death_dt
replace t1=mdy(03,04,2015) if death_dt>mdy(03,04,2015)  // modify according to study time frame
label var t1 "Time metric for Death"
****Mortality, only those happened before the end of F/U****
gen death=inrange(death_dt,rec_tx_dt,t1)
label var death "All-cause mortality"
label define death 0 "Alive" 1 "Dead"
label values death death

//DEATH DATE
//when using candidate data set only
egen death_dt=rowmin(pers_ssa_death_dt pers_optn_death_dt pers_restrict_death_dt tfl_death_dt)
replace death_dt=can_rem_dt if can_rem_dt<death_dt &
inlist(can_rem_cd,8)
//died (8)

*WAITLIST MORTALITY candidate data
egen death_dt=rowmin(pers_ssa_death_dt pers_optn_death_dt pers_restrict_death_dt tfl_death_dt)
replace death_dt=can_rem_dt if can_rem_dt<death_dt &
inlist(can_rem_cd,8,13,5)  //8-died; 13-deterioration; 5- medically unsuitable
replace death_dt=. if can_rem_cd<death_dt & inlist(can_rem_cd,4,15,21,14,22,18,19) //4-DDTx; 15-LDTx; 21
//censor if removal is for tx
//discuss with your mentor
