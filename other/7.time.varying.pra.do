******
// time varying PRA for candidate (maximum PRA within period) Use for candidate time
//categories used in match run (KAS) 0, 1-9, 10-19,20-29,30-39,40-49,...80-89,90-94,95,96,97,98,99,100
//convenient cutoffs binary at 80 (SRTR-way),
// -------------------------------------------------
// Time-varying PRA history for candidate time
// from pra_hist.dta
//
// before 2009: use max of !cPRA
// 2009 - 2010: use max of all 4 PRAs
// 2011 onward: use cPRA
//
// written by Xun Luo, commentary by Eric Chow 2016
// -------------------------------------------------
use "~/srtr1603/pra_hist.dta", clear
replace canhx_cpra=round(100*canhx_cpra) // make it out of 100
// keep certain variables (3 PRA variables, and cPRA)
keep px_id     canhx_begin_dt canhx_end_dt  ///
               canhx_srtr_peak_pra canhx_cur_pra canhx_alloc_pra ///
               canhx_cpra
// because we all enjoy order in our lives
sort px_id canhx_begin_dt
// check that histories are time-contiguous and not missing
assert canhx_begin_dt == canhx_end_dt[_n-1]+1 if px_id==px_id[_n-1]
assert !mi(canhx_begin_dt)
// create a history end-date (1603 censorship)
replace canhx_end_dt = min(canhx_end_dt,td(31aug2015))
// drop if the history begins after the censor date
13
drop if canhx_begin_dt > canhx_end_dt
sort px_id canhx_begin_dt // because entropy
// use max of all 4 PRA's if 2009-2010
gen pra_all_prahx = max(canhx_srtr_peak_pra,canhx_cur_pra,canhx_alloc_pra,canhx_cpra)
gen pra_09all_prahx = pra_all_prahx
// use max of 3 PRA's if 2008 and before
replace pra_09all_prahx=max(canhx_srtr_peak_pra,canhx_cur_pra,canhx_alloc_pra) if year(canhx_begin_dt)<2
// use cPRA if 2011 and onwards
gen pra_09all_11c_prahx=pra_09all_prahx
replace pra_09all_11c_prahx=canhx_cpra if year(canhx_begin_dt)>=2011
// the patient + history should be unique
isid px_id canhx_begin_dt
// keep the px_id, history range, and composite PRA
keep px_id canhx_begin_dt canhx_end_dt pra_09all_11c_prahx
// check contiguity again
assert canhx_begin_dt == canhx_end_dt[_n-1]+1 if px_id==px_id[_n-1]
assert 1==0
// save it to file
compress
saveold pra_hist_composite, v(12) replace
// fin
