*initialize Stata
clear all
set more off
set mem 100m

cd "C:\Users\asandie\Desktop\structure_dm\Clean_data\Poste de santé"

use "C:\Users\asandie\Desktop\structure_dm\raw_data\Poste de Santé\QUESTIONNAIRE POSTE DE SANTE-s4_1_1.dta"

destring _all,replace
compress

*drop variables which are not useful
drop  s4_1_6 s4_1_8 s4_1_9 s4_1_11 setofs4_1_1

lab def yesno 0 non 1 yes -5 missing -9 na, modify

* drop if inlist(s1_6,.,.) //get the code for the two facilities

*renaming variables to conform with the questionaire numbering

rena  s4_1_2 s4_1_1

rena  s4_1_3 s4_1_3_orig

bysort parent_key  s4_1_1 : gen  s4_1_2 = _N



bys parent_key  s4_1_1 : egen s4_1_3=total(s4_1_3_orig==1)


bys parent_key  s4_1_1 : egen s4_1_4a=total( s4_1_4==1)


bys parent_key  s4_1_1 : egen s4_1_4b=total( s4_1_4==2)

gen form_compl_pf = .

replace form_compl_pf = 0 if  s4_1_6_0 == 1

replace form_compl_pf = 1 if   s4_1_6_1 == 1 | s4_1_6_2==1 | s4_1_6_3==1 | s4_1_6_4==1 | s4_1_6_5==1 | s4_1_6_6==1 | s4_1_6_7 == 1


bys parent_key  s4_1_1 : egen s4_1_5a_1=total( form_compl_pf == 1  &s4_1_4==1)
bys parent_key  s4_1_1 : egen s4_1_5b_1=total( form_compl_pf == 1  & s4_1_4==2)


bys parent_key  s4_1_1 : egen  s4_1_7a_1 = total(s4_1_7==1 & s4_1_4==1)


bys parent_key  s4_1_1 : egen s4_1_7b_1=total(s4_1_7== 1 & s4_1_4==2)

 
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



gen s4_1_9  = .

replace s4_1_9 = 0 if  s4_1_9_0 == 1

replace s4_1_9 = 1 if s4_1_9_1 == 1 | s4_1_9_2== 1 |  s4_1_9_3== 1 |  s4_1_9_4== 1 |  s4_1_9_5== 1 |  s4_1_9_6== 1 |  s4_1_9_7== 1 |  s4_1_9_8== 1 |  s4_1_9_9== 1 |  s4_1_9_10== 1 |  s4_1_9_11== 1 |  s4_1_9_12== 1 |  s4_1_9_13== 1 |  s4_1_9_14== 1 


bys parent_key  s4_1_1 : egen  s4_1_8a = total(s4_1_9==1 & s4_1_4==1)


bys parent_key  s4_1_1 : egen s4_1_8b = total(s4_1_9== 1 & s4_1_4==2)



bys parent_key  s4_1_1 : egen   s4_1_9a = total(s4_1_10==1 & s4_1_4==1)


bys parent_key  s4_1_1 : egen   s4_1_9b = total(s4_1_10 == 1 & s4_1_4==2)
 


ren s4_1_11_a s4_1_10a
ren s4_1_11_b s4_1_10b
ren s4_1_11_c s4_1_10c
ren s4_1_11_d s4_1_10d
ren s4_1_11_e s4_1_10e
ren s4_1_11_f s4_1_10f
ren s4_1_11_g s4_1_10g

tabulate s4_1_12, generate(s4_1_12_)


ren s4_1_12au s4_1_12oth
 
 
ren s4_1_13 s4_1_13a


bys parent_key  s4_1_1 : egen   s4_1_13 = mean(s4_1_13a)


 keep parent_key  s4_1_1 s4_1_2 s4_1_2 s4_1_3 s4_1_4a s4_1_4b s4_1_5a_1 s4_1_5b_1 s4_1_7a_1 s4_1_7b_1 s4_1_7a s4_1_7b s4_1_7c s4_1_7d s4_1_7e s4_1_7f s4_1_7g s4_1_7h s4_1_7i s4_1_7j s4_1_7k s4_1_8a s4_1_8b s4_1_9a s4_1_9b  s4_1_10a s4_1_10b s4_1_10c s4_1_10d s4_1_10e s4_1_10f s4_1_10g s4_1_12_1 s4_1_12_2 s4_1_12_3 s4_1_12_4 s4_1_12_5 s4_1_12oth s4_1_13
 
egen id_unique = concat(parent_key s4_1_1)
 
duplicates drop id_unique, force

drop id_unique

recode s4_1_1 1=8 2=11 3=9 4=10 


save "C:\Users\asandie\Desktop\structure_dm\Clean_data\Poste de santé\postesante_rh.dta",replace
