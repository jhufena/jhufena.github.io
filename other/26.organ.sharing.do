// -----------------------------------
// Organ Sharing
// need to merge with srtr1407/../institutions.dta
// -----------------------------------
// untested code
gen local = 0
gen regional = 0
gen national = 0
// must merge to institutions.dta
// to get rec_region, don_region
// other race (not white or black)
replace local = 1 if !(don_org_shared)
replace regional = 1 if (don_org_shared == 1) & (rec_region == don_region)
replace national = 1 if !(local) & !(regional)
