
// -----------------------------------
// kidney disease etiology
// -----------------------------------
HTN, GN, DM, PKD, Other
gen dgn = 0 // other
// DM
replace dgn = 1 if inlist(can_dgn, 3011, 3012, 3038, 3039, 3069, 3070, 3071)
// HTN
replace dgn = 2 if can_dgn == 3040
// PKD
replace dgn = 3 if can_dgn == 3008
// FSGS
replace dgn = 4 if can_dgn == 3006
// GN
replace dgn = 5 if can_dgn == 3001 | can_dgn == 3041
// IGA
replace dgn = 6 if can_dgn == 3004
2.
gen rec_dx4=3
replace rec_dx4=0 if inlist(rec_dgn,3000,3001,3002,3003,3004,3005,3006,3016,3018,3024,3029,3031,3033,303
18
replace rec_dx4=1 if inlist(rec_dgn,3011,3012,3038,3039,3069,3070,3071)
replace rec_dx4=2 if rec_dgn==3040
replace rec_dx4=. if rec_dgn==.
label var rec_dx4 "Recipient's Dx,4 categories"
label define rec_dx4 0 "Glomerulonephritis" 1 "DMN" 2 "HTN" 3 "Everything else"
label values rec_dx4 rec_dx4

recode can_dgn (3011 3012 3039 3069 3070 3071 = 1 "dgn-DM") ///
    (3034 3040 3051 = 2 "dgn-htn") ///
    (3008 = 3 "dgn-PKD") ///
    (3050 3053 3055 3066  ///
    999 3007 3009 3010 3013 3014 3015 3017 3020 3021 3022 3023 3025 3026 ///
        3027 3028 3030 3032 3036 3044 3045 3046 3047 3048 3049 3052 3056 ///
        3057 3058 3059 3060 3063 = 4 "dgn-oth") ///
    (* = 0 "dgn-glomerular"), gen(can_dgn2)
drop can_dgn
rename can_dgn2 can_dgn

// Right now it's essentially the same thing as option 2 but this gives you convenience if you want t
/* Cause of ESRD */
gen cause=0
replace cause=1 if can_dgn==3000
replace cause=1 if can_dgn==3001
replace cause=1 if can_dgn==3002
replace cause=1 if can_dgn==3003
replace cause=1 if can_dgn==3004
replace cause=1 if can_dgn==3005
replace cause=1 if can_dgn==3006
replace cause=1 if can_dgn==3016
replace cause=1 if can_dgn==3018
replace cause=1 if can_dgn==3024
replace cause=1 if can_dgn==3029
replace cause=1 if can_dgn==3031
replace cause=1 if can_dgn==3033
replace cause=1 if can_dgn==3035
replace cause=1 if can_dgn==3041
replace cause=1 if can_dgn==3042
replace cause=1 if can_dgn==3043
replace cause=1 if can_dgn==3054
replace cause=1 if can_dgn==3067
replace cause=2 if can_dgn==3011
replace cause=2 if can_dgn==3012
replace cause=2 if can_dgn==3038
replace cause=2 if can_dgn==3039
replace cause=2 if can_dgn==3069
replace cause=2 if can_dgn==3070
replace cause=2 if can_dgn==3071
replace cause=3 if can_dgn==3008
replace cause=4 if can_dgn==3040
replace cause=5 if can_dgn==3019
replace cause=5 if can_dgn==3034
replace cause=5 if can_dgn==3050
replace cause=5 if can_dgn==3051
replace cause=5 if can_dgn==3053
replace cause=5 if can_dgn==3055


replace cause=6 if can_dgn==3010
replace cause=6 if can_dgn==3014
replace cause=6 if can_dgn==3015
replace cause=6 if can_dgn==3025
replace cause=6 if can_dgn==3028
replace cause=6 if can_dgn==3036
replace cause=6 if can_dgn==3052
replace cause=6 if can_dgn==3061
replace cause=7 if can_dgn==3007
replace cause=7 if can_dgn==3009
replace cause=7 if can_dgn==3013
replace cause=7 if can_dgn==3017
replace cause=7 if can_dgn==3026
replace cause=7 if can_dgn==3027
replace cause=7 if can_dgn==3030
replace cause=7 if can_dgn==3044
replace cause=7 if can_dgn==3045
replace cause=7 if can_dgn==3046
replace cause=7 if can_dgn==3047
replace cause=7 if can_dgn==3048
replace cause=7 if can_dgn==3049
replace cause=7 if can_dgn==3057
replace cause=7 if can_dgn==3059
replace cause=7 if can_dgn==3060
replace cause=7 if can_dgn==3063
replace cause=8 if can_dgn==3020
replace cause=8 if can_dgn==3021
replace cause=8 if can_dgn==3022
replace cause=8 if can_dgn==3023
replace cause=8 if can_dgn==3058
replace cause=9 if can_dgn==3037
replace cause=10 if !inlist(cause,1,2,4)
label define cause 1 "GN" 2 "DM" 4 "HTN" 10 "Others"
label values cause cause
