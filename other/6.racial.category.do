// -----------------------------------
// Racial category- donor & recipient similar
// -----------------------------------

gen rec_race3=0
replace rec_race3=1*(can_race==16)+2*(can_race==2000)
replace rec_race3=. if missing(can_race)
label var rec_race3 "Recipient's race"
label define rec_race3 0 "Non-AA,non-Hispanic" 1 "AA" 2 "Hispanic"
label values rec_race3 rec_race3

gen can_race_simple=.
replace can_race_simple=1 if can_race==8
replace can_race_simple=2 if can_race==16
replace can_race_simple=3 if can_race==2000
replace can_race_simple=4 if !inlist(can_race,8,16,2000) & can_race!=.
label variable can_race_simple "Patient/s simplified race"
label define can_race_simple 1 "White" 2 "African American" 3 "Hispanic/Latino" 4 "Other/multi-racial"
label values can_race_simple can_race_simple
