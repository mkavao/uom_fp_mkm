*initialize Stata
clear all
set more off
set mem 100m

cd "C:\Users\asandie\Desktop\structure_dm\Clean_data"
use "C:\Users\asandie\Desktop\structure_dm\raw_data\EPS\QUESTIONNAIRE EPS-section_41-personnel_1.dta"

destring _all,replace
compress
duplicates drop key, force
*drop variables which are not useful
drop numerob_produitf_1  s4_1_8_1  s4_1_11_1  s4_1_12_1 setofpersonnel_1 key produitb_labelg_1


lab def yesno 0 non 1 yes -5 missing -9 na, modify

* drop if inlist(s1_6,.,.) //get the code for the two facilities

*renaming variables to conform with the questionaire numbering


rena  codeb_produitf_1 s4_1_1
rena  s4_1_3_0 s4_1_2
rena  s4_1_3_1 s4_1_3
rena  s4_1_4a_1 s4_1_4a
rena  s4_1_4b_1 s4_1_4b


 ren s4_1_6a_1 s4_1_5a_1 
 ren s4_1_6b_1 s4_1_5b_1 
 
 
 
 
 

ren s4_1_8_1_a s4_1_7a
ren s4_1_8_1_b s4_1_7b
ren s4_1_8_1_c s4_1_7c
ren s4_1_8_1_d s4_1_7d 
ren s4_1_8_1_e s4_1_7e
ren s4_1_8_1_f s4_1_7f
ren s4_1_8_1_g s4_1_7g
ren s4_1_8_1_h s4_1_7h
ren s4_1_8_1_i s4_1_7i
ren s4_1_8_1_j s4_1_7j
ren s4_1_8_1_k s4_1_7k


ren s4_1_9a_1 s4_1_8a
ren s4_1_9b_1 s4_1_8b
 
 
ren s4_1_10a_1 s4_1_9a
ren s4_1_10b_1 s4_1_9b



ren s4_1_11_1_a s4_1_10a
ren s4_1_11_1_b s4_1_10b
ren s4_1_11_1_c s4_1_10c
ren s4_1_11_1_d s4_1_10d
ren s4_1_11_1_e s4_1_10e
ren s4_1_11_1_f s4_1_10f
ren s4_1_11_1_g s4_1_10g

ren s4_1_11_1a s4_1_11a
ren s4_1_11_1b s4_1_11b

ren s4_1_12_1_1 s4_1_12_1
ren s4_1_12_1_2 s4_1_12_2
ren s4_1_12_1_3 s4_1_12_3
ren s4_1_12_1_4 s4_1_12_4
ren s4_1_12_1_5 s4_1_12_5

ren s4_1_12au_1 s4_1_12oth
 
 
ren s4_1_13_1 s4_1_13

save "C:\Users\asandie\Desktop\structure_dm\Clean_data\eps_rh1.dta",replace


use "C:\Users\asandie\Desktop\structure_dm\raw_data\EPS\QUESTIONNAIRE EPS-section_42-personnel_2.dta"

duplicates drop key, force
drop  numerob_produitf_2 s4_1_11_2 s4_1_12_2 key  setofpersonnel_2  produitb_labelg_2


rename  codeb_produitf_2 s4_1_1
rename s4_1_3_0b s4_1_2


rename s4_1_3_2 s4_1_3

rename s4_1_4a_2 s4_1_4a
rename s4_1_4b_2 s4_1_4b

rename s4_1_9a_2 s4_1_8a
rename s4_1_9b_2 s4_1_8b


rename s4_1_10a_2 s4_1_9a
rename s4_1_10b_2 s4_1_9b

ren  s4_1_11_2_a s4_1_10a
ren  s4_1_11_2_b s4_1_10b
ren  s4_1_11_2_c s4_1_10c
ren  s4_1_11_2_d s4_1_10d
ren  s4_1_11_2_e s4_1_10e
ren  s4_1_11_2_f s4_1_10f
ren  s4_1_11_2_g s4_1_10g



ren   s4_1_12_2_1 s4_1_12_1
ren   s4_1_12_2_2 s4_1_12_2
ren   s4_1_12_2_3 s4_1_12_3
ren   s4_1_12_2_4 s4_1_12_4
ren   s4_1_12_2_5 s4_1_12_5

ren  s4_1_12au_2 s4_1_12oth
 
 
ren  s4_1_13_2 s4_1_13


save "C:\Users\asandie\Desktop\structure_dm\Clean_data\eps_rh2.dta",replace



append using "C:\Users\asandie\Desktop\structure_dm\Clean_data\eps_rh2.dta"

save "C:\Users\asandie\Desktop\structure_dm\Clean_data\eps_rh.dta",replace


