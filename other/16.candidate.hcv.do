// -----------------------------------
// Candidate HCV from Liver waitlist dgn
// -----------------------------------
//HCV among liver waitlist candidates
    gen hcv = cond(inlist(can_dgn, ///
    4104,4106,4204,4206,4216,4593),1,0) if !missing(can_dgn)
    replace hcv=1 if inlist(can_dgn2, ///
    4104,4106,4204,4206,4216,4593) & !missing(can_dgn2)
    replace hcv=1 if strpos(can_dgn_ost,"HCV")
    replace hcv=1 if strpos(can_dgn_ost,"TYPE C")
    replace hcv=1 if strpos(can_dgn_ost,"HEP C")
    replace hcv=1 if strpos(can_dgn_ost,"HEPATITIS C")
    replace hcv=1 if strpos(can_dgn_ost,"HEPATITIA C")
    replace hcv=1 if strpos(can_dgn_ost,"HAPETITIS C")
    replace hcv=1 if strpos(can_dgn_ost,"HEPATITISC")
        lab var hcv "HCV Cand. Diagnosis"
