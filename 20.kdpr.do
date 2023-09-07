
// -----------------------------------
// KDRI/ KDPI
// -----------------------------------
//be mindful of time period when using this (can be odd to explore KDPI before it was adopted)
//this use the reference year 2013, ref year can be changed
//truncate serum creatinine and height at some extreme value and can replace htn with mean of previous y
<https://optn.transplant.hrsa.gov/ContentDocuments/Guide_to_Calculating_Interpreting_KDPI.pdf>

//AM: define path and reference year instead of hard-coding
global DATA /dcs01/igm/segevlab/data/srtr1903/public
global REF_Y 2018  //reference year for KDPI calculation
//keep recovered kidneys
use don_disposition donor_id don_org using $DATA/donor_disposition.dta,clear
keep if inlist(don_org,"LKI","RKI","EKI")
keep if inlist(don_disposition,5,6)
isid donor_id don_org
merge m:1 donor_id using $DATA/donor_deceased.dta,keep(match)
drop _merge
keep *id* *_dt* don_age *hgt* *wgt* *race*  ///
     don_hist_h* *diab* don_cad* *creat* *hcv* *hr* don_cad
duplicates drop
isid donor_id
//kdri
    gen age40 = don_age-40
    gen age18 = don_age-18
    replace age18 = 0 if don_age>=18
    gen age50 = don_age-50
    replace age50 = 0 if don_age<=50
    gen hgt170 = don_hgt_cm-170
    gen wgt80 = (don_wgt_kg-80)/5
    replace wgt80 = 0 if don_wgt_kg >=80
    gen aa = cond(don_race==16,1,0)
    gen hyp = cond(inrange(don_hist_hyp,2,5),1,0)
    gen diab = cond(inrange(don_hist_diab,2,5),1,0)
    gen cva = cond(don_cad_don==2,1,0)
    gen creat= don_creat
        replace creat= don_max_creat if creat==. & don_max_creat!=.
        replace creat=don_peak_ if creat==. & don_peak_!=.
        codebook creat
    //replace creat=8 if creat>8 & !mi(creat)
//SZ: creatinine should be capped at 8
    gen creat1 = creat-1
    gen creat1_5 = creat-1.5
    replace creat1_5 = 0 if creat <=1.5
    gen hcv=cond(don_anti_hcv=="P",1,0)


gen dcd = cond(don_non_hr_beat=="Y",1,0)
gen logkdri =
0.0128 * (age40)       ///
-0.0194 * (age18)      ///
+0.0107 * (age50)      ///
///
-0.0464 * (hgt170)/10  ///
-0.0199 * (wgt80)
///
+0.1790 * aa
///
+0.1260 * hyp
+0.1300 * diab
+0.0881 * cva
///
+0.2200 * (creat1)
-0.2090 * (creat1_5)
+0.2400 * (hcv)
+0.1330 * dcd
/// ///
/// /// ///
/// ///
///
gen y = year(don_recov_dt)
//AM: you don't really need to exponentiate
gen kdri = exp(logkdri)
sum kdri if y ==$REF_Y,det
local median r(p50)
gen kdri_med = kdri/`median'
hist kdri_med
drop if kdri==.
egen rank =rank(kdri_med) if y==$REF_Y
    sort y
    sort rank
bys y: gen total = _N if y==$REF_Y
sort rank
gen pctile=rank/total
gen kdpi = pctile*100
hist kdpi,freq
sort kdri
replace kdpi=kdpi[_n-1] if kdpi==.
gsort -kdri
replace kdpi=kdpi[_n-1] if kdpi==.
keep donor_id kdri kdpi logkdri don_recov_dt
capt drop _merge
save kdpi_id.dta,replace
