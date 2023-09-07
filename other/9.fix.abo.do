
// -----------------------------------
// fix ABO
// -----------------------------------
// fix A1, A2 to A for bloodtype
foreach v of varlist don_abo can_abo {
    replace `v' = "AB" if inlist(`v', "A1B", "A2B")
    replace `v' = "A" if inlist(`v', "A1", "A2")
}
 encode can_abo,gen(cand_abo)
encode don_abo,gen(donor_abo) //makes them numeric with approp. value labels
