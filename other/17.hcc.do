
// -----------------------------------
// HCC
// -----------------------------------
//HCC by exception point status
    capt drop hcc
    gen hcc = canhx_meld_diff_reason_cd ==8
    replace hcc= . if canhx_meld_diff==1 | canhx_meld_diff==2 ///
    | canhx_meld_diff==5 | canhx_meld_diff==12 | ///
    canhx_meld_diff==15 | canhx_meld_diff==16
//HCC by diagnosis
    gen hcc = cond(inlist(can_dgn,4400,4401),1,0) if !mi(can_dgn)
        replace hcc = 1 if inlist(can_dgn2, 4400,4401)
        replace hcc= 1 if strpos(can_dgn_ost, "HCC")
        replace hcc= 1 if strpos(can_dgn_ost, "HEPATOCELLULAR CARCINOMA")
            replace hcc= 1 if strpos(can_dgn_ost, "HEPATOCELLULARCARCINOMA")
