*initialize Stata
clear all
set more off
set mem 100m

cd "C:\Users\asandie\Desktop\structure_dm\Clean_data\Clinique"

use "C:\Users\asandie\Desktop\structure_dm\raw_data\Clinique\QUESTIONNAIRE CLINIQUE PRIVEE-section_41-personnel.dta"

destring _all,replace
compress

*drop variables which are not useful
drop numerob_produitf  s4_1_8  s4_1_11 setofpersonnel key produitb_labelg


lab def yesno 0 non 1 yes -5 missing -9 na, modify

* drop if inlist(s1_6,.,.) //get the code for the two facilities

*renaming variables to conform with the questionaire numbering


rena  codeb_produitf s4_1_1
rena  s4_1_3_0 s4_1_2
rena  s4_1_3_1 s4_1_3
rena  s4_1_4a s4_1_4a
rena  s4_1_4b s4_1_4b


 ren s4_1_6a s4_1_5a_1 
 ren s4_1_6b s4_1_5b_1 
 
 
 ren  s4_1_7a s4_1_7a_1 
 ren  s4_1_7b s4_1_7b_1
 
 

ren s4_1_8_a s4_1_7a
ren s4_1_8_b s4_1_7b
ren s4_1_8_c s4_1_7c
ren s4_1_8_d s4_1_7d 
ren s4_1_8_e s4_1_7e
ren s4_1_8_f s4_1_7f
ren s4_1_8_g s4_1_7g
ren s4_1_8_h s4_1_7h
ren s4_1_8_i s4_1_7i
ren s4_1_8_j s4_1_7j
ren s4_1_8_k s4_1_7k


ren s4_1_9a s4_1_8a
ren s4_1_9b s4_1_8b
 
 
ren s4_1_10a s4_1_9a
ren s4_1_10b s4_1_9b



ren s4_1_11_a s4_1_10a
ren s4_1_11_b s4_1_10b
ren s4_1_11_c s4_1_10c
ren s4_1_11_d s4_1_10d
ren s4_1_11_e s4_1_10e
ren s4_1_11_f s4_1_10f
ren s4_1_11_g s4_1_10g

ren s4_1_11_2 s4_1_11a
ren s4_1_11_3 s4_1_11b

ren s4_1_12_1 s4_1_12_1
ren s4_1_12_2 s4_1_12_2
ren s4_1_12_3 s4_1_12_3
ren s4_1_12_4 s4_1_12_4
ren s4_1_12_5 s4_1_12_5

ren s4_1_12au s4_1_12oth
 
 
ren s4_1_13 s4_1_13

drop  s4_1_2

save "C:\Users\asandie\Desktop\structure_dm\Clean_data\Clinique\clinique_rh.dta",replace
