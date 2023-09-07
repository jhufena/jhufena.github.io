// -------------------------------------------
// ascertain DELAYED GRAFT FUNCTION
// -------------------------------------------
// Keep it in mind- if DGF is the main exposure/outcome, those with  dgf = 0 and died within the first w
// main analysis 1) adjust for pre-emptive as covariate, 2) exclude any pre-emptives (see mentor) - pre-
gen dgf=rec_first_week_dial=="Y"
replace dgf = . if rec_first_week_dial=="U" | missing(rec_first_week_dial)
