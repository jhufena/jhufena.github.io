*DE-IDENTIFICATION CODE:

/* run this code on a dataset to remove identifiers, dates (less than year), geographic identifiers, or
// -------------------------------------------------
// SRTR de-identification     v1.0      Sep 14, 2016
// CAUTION: this code not guaranteed to de-identify
// data, please review with your analyst.
// * drop identifying variables *
foreach keyw in    id dt date day mrn name ssn  ///
                   address city county fips zip ///
                   tel fax email                ///
        { capture drop *`keyw'* }
// * drop date-format variables *
ds, has(format %d* %-d* %t* %-t*)
capture drop `r(varlist)'
// * no one older than 90 *
foreach var of varlist *age* {
    assert `var' < 90 }
// -------------------------------------------------
