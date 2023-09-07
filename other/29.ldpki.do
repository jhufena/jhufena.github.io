*LKDPI or LD KDPI

// -------------------------------------------
// Calculate LKDPI
// -------------------------------------------
// m2m?
gen m2m = 0
replace m2m = 1 if (don_fem == 0 & can_fem == 0)
// MIN of DRWR and 0.9
gen drwr = don_wgt_kg / rec_wgt_kg
replace drwr = 0.9 if drwr > 0.9 & !missing(drwr)
sum don_bp_preop_syst, detail
gen sbp = don_bp_preop_syst
tab don_hist_cigarette

gen smok = don_hist_cigarette == "Y"
// are they ABO incompatible?
tab don_abo can_abo
capture drop aboi
gen aboi = .
replace aboi = inlist(don_abo, "A", "A1", "A2") & inlist(can_abo, "B", "O") | ///
               inlist(don_abo, "A1B", "A2B", "AB") & inlist(can_abo, "A", "A1","A2","B","O") | ///
               inlist(don_abo, "B") & inlist(can_abo, "A", "A1", "A2","O")
tab aboi
capture drop lkdpi
// calculate lkdpi
gen lkdpi = -11.3 ///
    + 1.85 *  dage50_spline ///
    - 0.381 * ld_egfr_preop ///
    + 1.17 *  don_bmi ///
    + 22.34 * don_black ///
    + 14.33 * smok ///
    + 0.44 *  sbp ///
    - 21.68 * m2m ///
    + 27.30 * aboi ///fol_age
    - 10.61 * !don_related ///
    + 8.57  * rec_b_mm_equiv_tx ///
    + 8.26 *  rec_dr_mm_equiv_tx ///
    -50.87 *  drwr
sum lkdpi, detail
//// LDKT, version 2 (Based on the above version; defines all variables needed.)
global srtrdir "~/foo/bar"
use $srtrdir/tx_ki, clear
keep if don_ty=="L"
merge 1:1 donor_id using $srtrdir/donor_live, keep(master match)
// Age spline
gen dage50_spline = (don_age-50)*(don_age>50)
// Sex
gen don_female = don_gender=="F"
gen can_female = can_gender=="F"
// Race
gen don_black = don_race==16
// CKD epi equation for eGFR
gen ld_male = don_gender=="M"
30

gen k = cond(ld_male, 0.9, 0.7)
gen a = cond(ld_male, -0.411, -0.329)
gen egfr = 141 * ///
    (min(don_ki_creat_preop/k, 1))^a * ///
    (max(don_ki_creat_preop/k, 1))^(-1.209) * ///
    0.993^fol_age * ///
    cond(ld_male, 1, 1.018) * ///
    cond(don_black, 1.159, 1) ///
    if !missing(don_ki_creat_preop)
sum egfr, detail
rename egfr ld_egfr_preop
// Donor BMI (20191017: why can_wgt_kg???)
gen don_bmi = can_wgt_kg/(don_hgt_cm/100)^2
// donor related
gen don_related = inlist(don_relationship_ty, 1,2,3,4,5,6)
// m2m?
gen m2m = 0
replace m2m = 1 if (don_female == 0 & can_female == 0)
// MIN of DRWR and 0.9
gen drwr = don_wgt_kg / rec_wgt_kg
replace drwr = 0.9 if drwr > 0.9 & !missing(drwr)
sum don_bp_preop_syst, detail
gen sbp = don_bp_preop_syst
tab don_hist_cigarette
gen smok = don_hist_cigarette == "Y"
// are they ABO incompatible?
tab don_abo can_abo
capture drop aboi
gen aboi = .
replace aboi = inlist(don_abo, "A", "A1", "A2") & inlist(can_abo, "B", "O") | inlist(don_abo, "A1B", "A2
tab aboi
capture drop lkdpi
// calculate lkdpi
gen lkdpi = -11.3 + 1.85 *  dage50_spline - 0.381 * ld_egfr_preop + 1.17 *  don_bmi + 22.34 * don_black
sum lkdpi, detail
