// -----------------------------------
// Immunosuppression/ Induction
// induction - before transplant or on day, you get shots
// with goal to deactive T or B cells
// maintenance: start AFTER transplant that you carry on for life
// relevant to transplant outcomes
// includes substantial additions by Mary-Grace Bowring
// -----------------------------------



global srtrdir="/dcs01/igm/segevlab/data/srtr1509/public"
local isfile="$srtrdir/immuno.dta"


use `isfile',clear

****Induction****
tempvar is_induct00 is_induct11

gen `is_induct00'=(rec_drug_induction==1 & inlist(rec_drug_cd,16,-1,14,41,15,50))
gen `is_induct11'=(rec_drug_induction==1 & inlist(rec_drug_cd,42,43,52))

forvalues n=0/1 {

    replace `is_induct`n'`n''=. if rec_drug_induction==. | rec_drug_cd==.
	bys trr_id: egen is_induct`n'=max(`is_induct`n'`n'')

}


label var is_induct0 "1-Induction(depleting)"
label var is_induct1 "1-Induction(non-depleting)"
	 
			 
****Maintenance****
tempvar is_steroid_withdraw0
gen `is_steroid_withdraw0'=1
replace `is_steroid_withdraw0'=0 if rec_drug_maint==1 & inlist(rec_drug_cd,1,49)
replace `is_steroid_withdraw0'=. if missing(rec_drug_maint) | missing(rec_drug_cd)
bys trr_id: egen is_steroid_withdraw=min(`is_steroid_withdraw0')
				
collapse (max)  is_induct0 is_induct1 ///
                is_steroid_withdraw,by(trr_id) 
				
gen is_induct_other=(is_induct0==0 & is_induct1==0)
label var is_induct_other "1-Anything else besides depleting or non-depleting"			

tabstat is_induct0 is_induct1 is_induct_other ///
        is_steroid_withdraw,statistics(mean)
		
tab is_induct0 is_induct1,m

**************************************************************************************
** This do-file transforms the SRTR immunosuppression dataset so that it can be linked to tx_ki dataset using trr_id.

/** v3 update
- separated non-rabbit ATG from "thymo" as nratg
*/

/* Classification of the drugs:
1. Induction: OKT3, thymoglobulin (rabbit only), non-rabbit anti-thymocyte glubline (ALG, Atgam, NRATG/NRATS), Daclizumab, Basiliximab, Alemtuzumab, Rituximab.
2. Maintanence
	1) Steroids (Istedoid)
	2) CNI (Icni): Cyclosporin(including Neoral), Tacrolimus
	3) Anti-metabolites (Iantimeta): MMF(including Myfortic), mTOR(Sirolimus and Everolimus), Azathioprine  
3. Everything else is dumped. 	  */

local ver="1903"
global srtrdir "/dcs01/igm/segevlab/data/srtr`ver'/public"
global LOCAL /users/syu/016_dataset/001_steroid_rejection
	
set more off
use $srtrdir/immuno.dta, clear
cd "/users/syu/016_dataset/001_steroid_rejection"
	
// Generate indicators
gen Iokt3=inlist(rec_drug_cd, 16)
gen Ithymo=inlist(rec_drug_cd, 41)
gen Inratg=inlist(rec_drug_cd, -1 ,14, 15)
gen Idaclizumab=inlist(rec_drug_cd, 42)
gen Ibasiliximab=inlist(rec_drug_cd, 43)
gen Irituximab=inlist(rec_drug_cd, 52)
gen Ialemtuzumab=inlist(rec_drug_cd,50)
gen Isteroid=inlist(rec_drug_cd,1,2,49) /// WAW: I added in code 2 for methylpred as steroid induction. 
gen Icyclosporin=inlist(rec_drug_cd,3,4,-2,44,46,48)
gen Itacro=inlist(rec_drug_cd,5,53,54,59) ///	WAW: I added in code 59 for envarsus XR. 
gen Immf=inlist(rec_drug_cd,9,47,55,57)	/// WAW: I added in code 57 for generic myfortic. 
gen Imtor=inlist(rec_drug_cd,6,45)
gen Iaza=inlist(rec_drug_cd,8)

gen	Iinduction_steroid=inlist(rec_drug_cd,2)	
///	WAW: although high dose steroids (nearly always methlypred) are not considered induction per se, they are almost always given up front. 
///	WAW: for ESW work, this seems important to note as may be an mediator of the effects of later ESW. 

gen Iinduction=(Iokt3+ Ithymo+ Inratg+Idaclizumab+Ibasiliximab+ Irituximab+ Ialemtuzumab)>0
gen Icni=(Icyclosporin+Itacro)>0
gen Iantimeta=(Immf+Iaza)>0	/// WAW: I generally refer to aza/mmf only when I talk about antimetabolites, while mtor is an "antiproliferative". So i took mtor out of here.

// Create a list of trr_ids that has any information on this dataset
preserve
keep trr_id
duplicates drop
save imsup_all_v3, replace
restore

** But IS data for the most recent cohort is NOT comprehensive. Consider censoring everyone in the last year or something.

// See if they make clinical sense
drop if rec_drug_induction + rec_drug_maint + rec_drug_anti_rej ==0
drop if Iinduction & (rec_drug_induction + rec_drug_anti_rej) == 0

// Export
preserve
collapse (max) I* if rec_drug_induction, by(trr_id)
save imsup_ind, replace
restore

preserve
collapse (max) I* if rec_drug_maint, by(trr_id)
save imsup_maint, replace
restore

preserve
collapse (max) I* if rec_drug_anti_rej, by(trr_id)
save imsup_anti_rej, replace
restore

*** Also get the number of days for induction
preserve
keep if inlist(rec_drug_cd,16,-1,14,41,15,42,43,52,50)
keep if rec_drug_induction
replace rec_drug_cd=100 if rec_drug_cd==-1 //values need to be positive to reshape

keep trr_id rec_drug_cd rec_drug_days
reshape wide rec_drug_days, i(trr_id) j(rec_drug_cd)
mvencode _all, mv(0) override  //force the missing data to 0 

gen days_atg=rec_drug_days41
gen days_nratg=rec_drug_days100+rec_drug_days14+rec_drug_days15
gen days_il2=rec_drug_days42+rec_drug_days43
gen days_alm=rec_drug_days50
gen days_ritux=rec_drug_days52
gen days_okt3=rec_drug_days16

drop rec_drug_days*
compress
save imsup_days, replace
restore


foreach c in ind maint anti_rej {
	use imsup_`c', clear
	foreach v of varlist I* {
		rename `v' `v'_`c'
	}
	save imsup_`c', replace
}

// Lump all of them up into imsup_all_v3 dataset
use imsup_all_v3, clear
merge 1:1 trr_id using imsup_ind, nogen
merge 1:1 trr_id using imsup_maint, nogen
merge 1:1 trr_id using imsup_anti_rej, nogen
merge 1:1 trr_id using imsup_days, nogen

mvencode _all, mv(0) override
save "$LOCAL/imsup_all_`ver'", replace

// If _ever indicators are needed:  
/*
foreach drugname in Iokt3 Ithymo Inratg Idaclizumab Ibasiliximab Irituximab Ialemtuzumab Isteroid Icyclosporin Itacro Immf Imtor Iaza Iinduction Icni Iantimeta {
	egen `drugname'_ever=rowmax(`drugname'*)
}
save imsup_all_v3, replace
*/

