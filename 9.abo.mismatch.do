
// -------------------------------------------
// ABO mismatch
// -------------------------------------------
gen aboi=0
replace aboi=1 if (inlist(don_abo, "A", "A1", "A2", "B", "AB", "A1B", "A2B") & can_abo=="O") | ///
                  (inlist(don_abo, "B", "AB", "A1B", "A2B") & inlist(can_abo, "A", "A1", "A2")) | ///
                  (inlist(don_abo, "A", "A1", "A2", "AB", "A1B", "A2B") & can_abo=="B")
replace aboi=. if don_abo=="UNK" | can_abo=="UNK"
label var aboi "ABO incompatibility"
label define aboi 0 "N" 1 "Y"
label values aboi aboi
gen compatible = 0
    replace compatible = 1 if inlist(don_abo,"A") & inlist(can_abo,"A","A1","A1B","A2","A2B","AB")
    replace compatible = 1 if inlist(don_abo,"A1") & inlist(can_abo,"A","A1","A1B","A2","A2B","AB")
    replace compatible = 1 if inlist(don_abo,"A1B") & inlist(can_abo,"A1B","A2B","AB")
    replace compatible = 1 if inlist(don_abo,"A2") & inlist(can_abo,"A","A1","A1B","A2","A2B","AB")
    replace compatible = 1 if inlist(don_abo,"A2B") & inlist(can_abo,"A1B","A2B","AB")
    replace compatible = 1 if inlist(don_abo,"AB") & inlist(can_abo,"A1B","A2B","AB")
    replace compatible = 1 if inlist(don_abo,"B") & inlist(can_abo,"A1B","A2B","AB","B")
    replace compatible = 1 if inlist(don_abo,"O") & inlist(can_abo,"A","A1","A1B","A2","A2B","AB","O","B
    label var compatible "Compatible Groups"
//A2 incompatible, population & variable [pyc]
keep if inlist(can_abo, "O", "B")  // only those transplanted with O or B
// drop all the truly incompatible
tab don_abo can_abo, m
drop if can_abo=="O" & regexm(don_abo, "B")  // candidates O + donor with any B, incompatible
drop if regexm(don_abo, "A1")  // considered incompatible for both O and B candidates
drop if don_abo=="UNK"
drop if inlist(don_abo, "A", "AB")  // incompatible for both O and B candidates
tab don_abo can_abo, m
gen byte a2i = ///
    (can_abo=="O" & don_abo=="A2") | ///

(can_abo=="B" & inlist(don_abo, "A2", "A2B"))
    lab var a2i "A2 incompatibility indicator"
    capture lab drop a2i
    lab def a2i 0 "Compatible O & B recipient" 1 "A2 incompatible (A2 to O/B; or A2B to B)"
    lab val a2i a2i
// A2 incompatible
gen incompatible = 0
replace incompatible = 1 if inlist(don_abo,"A2") & inlist(can_abo,"B","O")
replace incompatible = 2 if inlist(don_abo,"A2B") & inlist(can_abo,"B")
label var incompatible "A2 Incompatible Groups"
label define incompatible 0 "Not" 1 "A2 to B or O recipient" 2 "A2B to B recipient"
label val incompatible incompatible
