// -------------------------------------------
// ascertain primary non-function
// -------------------------------------------
// this is PNF for patients who survive at least 90 days
// CAUTION: anyone who doesn't survive to 90 days, they are dropped
//90 days and 1 week shown- ask your mentor re: the appropriate measure
//determine gfail_dt appropriately (death censored, not all-cause)
//Option 1 works fine if you are just excluding PNF folks. If PNF is a covariate, then, what is now code
gen byte pnf = (gfail_dt - rec_tx_dt <= 90) // doesn't need to be dgf=="Y"
replace pnf = . if death_dt < gfail_dt & death_dt-rec_tx_dt <= 90

/*Defined as "the lack of kidney graft function recovery and
permanent need of dialysis since the first week of transplant surgery
(Jayaram, Clin Transplantation, 2012)*/
gen pnf=(gfail_dt-rec_tx_dt<=7)
replace pnf=. if gfail_dt==. | rec_tx_dt==.
label var pnf "Permanent non-functioning"
label define pnf 0 "No PNF" 1 "PNF"
label values pnf pnf
