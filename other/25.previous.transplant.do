// -------------------------------------------
// Previous solid organ Tx or previous KT-> just to show where to find it
// -------------------------------------------
*****Repeat KT variable based on SRTR can_prev_tx variable*****
rename can_prev_ki rec_repeat_kt
label var rec_repeat_kt "Repeat KT based on SRTR can_prev_tx variable"
****Previous organ transplantation****
rename can_prev_tx rec_prev_tx
label var rec_prev_tx "Previous solid organ Tx"
label define rec_prev_tx 0 "N" 1 "Y"
label values rec_prev_tx rec_prev_tx
