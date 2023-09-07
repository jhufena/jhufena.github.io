
// -----------------------------------
// Machine perfusion
// -----------------------------------
use $srtrdir/donor_disposition.dta, clear
keep donor_id px_id don_org
drop if px_id==.
keep if inlist(don_org,"LKI","RKI","EKI")  // drop all other organs (especially pancrease (PA))
isid px_id               // no news is good news here.
tempfile donor
saveold `donor'
use $hcvdir/hcv_ar,clear
capture drop organ
merge 1:1 px_id using `donor',keep(master match) nogen
saveold $hcvdir/hcv_ar ,replace
gen rec_which_k=0*(don_org=="LKI")+1*(don_org=="RKI")+2*(don_org=="EKI")
label var rec_which_k "Which kidney Tx"
label define rec_which_k 0 "Lt" 1 "Rt" 2 "En bloc"
label values rec_which_k rec_which_k
gen rec_pump=cond(don_lf_ki_pump=="Y",1,0,.) if rec_which_k==0
replace rec_pump=cond(don_rt_ki_pump=="Y",1,0,.) if rec_which_k==1
replace rec_pump=1 if (don_rt_ki_pump=="Y" | don_lf_ki_pump=="Y") & rec_which_k==2
replace rec_pump=. if don_rt_ki_pump=="" & don_lf_ki_pump=="" & rec_pump!=.
****Reconcile with the SRTR machine perfusion variable****
8
replace rec_pump=1 if rec_received_on_pump==1 & missing(rec_pump)
label var rec_pump "Donor kidney pumped"
label define rec_pump 0 "Cold storage" 1 "Pumped"
label values rec_pump rec_pump
