*initialize Stata
clear all
set more off
set mem 100m

cd "C:\Users\asandie\Desktop\structure_dm\Clean_data\Poste de santé"
use "C:\Users\asandie\Desktop\structure_dm\raw_data\Case de santé\QUESTIONNAIRE CASE DE SANTE.dta"

destring _all,replace
compress

*dropping ineligible EPS
*drop if inlist(s1_6,11,1)
*drop variables which are not useful
drop equipe enqueteur s1_8 s1_9 s1_10  setofs4_1_1

rename  nom_structure nom_structure_affil
rename s2_2 nom_structure

*this informtion is available when merging with the sub-tables
*drop s4_1_2_1 s4_1_2_2 s4_1_2_2_1 s4_1_2_2_2 s4_1_2_2_3 s4_1_2_2_4 s4_1_2_2_5 s4_1_2_2_6 s4_1_2_2_7 s4_1_2_2_8 s4_1_2_2_9 s4_1_2_2_10 s4_1_2_2_11 personnel_2_count setofpersonnel_2

*drop the two health facilities which were not eligible


lab def yesno 0 Non 1 Oui -5 missing -9 na, modify

lab def ouinon 2 Non 1 Oui -5 missing -9 na, modify

lab def regulierement 1 "Régulièrement" 2 "Occasionnellement" 3 "Pas du tout" -5 "missing" -9 "na", modify


lab def dispo_indisp 1 "Disponible et fonctionnel" 2  "Disponible mais pas fonctionnel"  3 "Indisponible" -5 "missing" -9 "na"

	
lab def frequence 1 "Quotidien" 2  "Hebdomadaire"  3 "Tous les quinze jours" 4 "Mensuel" 5 "Pas du tout" -5 "missing" -9 "na"

*drop if inlist(s1_6,.,.) //get the code for the two facilities

*renaming variables to conform with the questionaire numbering

*rena s1_11 s2_1
*rena s1_12 s2_2
*rena s1_13 s2_3


*********** SECTION 3 : INFRASTRUCTURE GÉNÉRALE 

*** 301	L'EPS dispose-t-il des éléments suivants ?

ren s3_1_1_1 s3_1a
ren s3_1_2_1 s3_1b
ren s3_1_4_1 s3_1d
ren s3_1_5_1 s3_1e
ren s3_1_6_1 s3_1f

tab1 s3_1?,m


ren s3_2_1 s3_2_1_acc
ren s3_2_2 s3_2a




tab1 s3_2?,m

* check the naming they need to be the same as what is in the questionaire [the questionaire also need to be same as what is in the survey CTO]
ren s3_3_1  s3_3a 
ren s3_3_2  s3_3b
ren s3_3_3  s3_3c
ren s3_3_4  s3_3d
ren s3_3_6  s3_3e
ren s3_3_7  s3_3f
ren s3_3_8  s3_3g
ren s3_3_9  s3_3h
ren s3_3_10  s3_3i
ren s3_3_11  s3_3j
ren s3_3_12  s3_3k
ren s3_3_13  s3_3l
ren s3_3_14  s3_3m
ren s3_3_15  s3_3n
ren s3_3_16  s3_3o
ren s3_3_17  s3_3p
ren s3_3_18  s3_3q
ren s3_3_19  s3_3r
ren s3_3_20  s3_3s
ren s3_3_21  s3_3t
ren s3_3_22  s3_3u
ren s3_3_23  s3_3v
ren s3_3_24  s3_3w
ren s3_3_25  s3_3x
ren s3_3_26  s3_3y
ren s3_3_27  s3_3z
ren s3_3_28  s3_3aa
ren s3_3_29  s3_3ab

ren s3_3_30  s3_3ac
ren s3_3_31  s3_3ad
ren s3_3_32  s3_3ae
ren s3_3_33  s3_3af
ren s3_3_34  s3_3ag
ren s3_3_35  s3_3ah
ren s3_3_36  s3_3ai
ren s3_3_37  s3_3aj
ren s3_3_38  s3_3ak
ren s3_3_39  s3_3al
ren s3_3_40  s3_3am
ren s3_3_41  s3_3an
ren s3_3_42  s3_3ao
ren s3_3_43  s3_3ap
ren s3_3_44  s3_3aq
ren s3_3_45  s3_3ar
ren s3_3_46  s3_3as
ren s3_3_47  s3_3at
ren s3_3_48  s3_3au
ren s3_3_49  s3_3av
ren s3_3_50  s3_3aw
ren s3_3_51  s3_3ax
ren s3_3_52  s3_3ay
ren s3_3_53  s3_3az
ren s3_3_54  s3_3ba
ren s3_3_55  s3_3bb
ren s3_3_56 s3_3bc

*Gyna
*label for the variables need to be updated to capture gyna/obs information

/*
ren s3_4_1_1 s3_4ia
ren s3_4_1_2 s3_4ib
ren s3_4_1_3 s3_4ic
*/



*question 3.5
*a
/*
ren s3_5_2  s3_5a_2
ren s3_5_3  s3_5a_3
ren s3_5_4  s3_5a_4
ren s3_5_5  s3_5a_6
ren s3_5_6  s3_5a_7
ren s3_5_7  s3_5a_8
ren s3_5_8  s3_5a_9
ren s3_5_10 s3_5a_11
ren s3_5_11 s3_5a_12
ren s3_5_12 s3_5a_13
ren s3_5_13 s3_5a_14
ren s3_5_14 s3_5a_15
ren s3_5_15 s3_5a_16
ren s3_5_16 s3_5a_17
ren s3_5_17 s3_5a_18
ren s3_5_17a s3_5a_18a
ren s3_5_18 s3_5a_19
ren s3_5_19 s3_5a_20
ren s3_5_20 s3_5a_21
ren s3_5_21 s3_5a_22
ren s3_5_24 s3_5a_23
ren s3_5_25 s3_5a_24
ren s3_5_27 s3_5a_25
ren s3_5_28 s3_5a_26
ren s3_5_29 s3_5a_27
ren s3_5_30 s3_5a_28
ren s3_5_33 s3_5a_29


tab1 s3_5a_? s3_5a_??,m

*/


 

*servi_smni  - to be renamed properly after consulting with Arsene
*to be checked how the question is frame in the final tool - who was interviewed?
drop servi_smni s_cpn s_acc s_pnat
ren s501 s5_1
ren servi_smni_1 s5_1A
ren servi_smni_2 s5_1B
ren servi_smni_3 s5_1C
ren servi_smni_4 s5_1D
ren servi_smni_5 s5_1F


rename s_cpn_* s5_1A_* 

foreach var of var s5_1A s5_1B s5_1C s5_1D s5_1F s5_1A_a s5_1A_b s5_1A_c s5_1A_d s5_1A_e s5_1A_f s5_1A_g s5_1A_h s5_1A_i s5_1A_j s5_1A_k s5_1A_l s5_1A_m s5_1A_n {
	replace `var' = -9 if s5_1==2
}

lab val s5_1A s5_1B s5_1C s5_1D s5_1F  s5_1A_a s5_1A_b s5_1A_c s5_1A_d s5_1A_e s5_1A_f s5_1A_g s5_1A_h s5_1A_i s5_1A_j s5_1A_k s5_1A_l s5_1A_m s5_1A_n   yesno

ren s5_2_cpn   s5_2A
ren s5_3_cpn   s5_3Aa
ren s5_4_cpn   s5_4Aa
ren s5_5_cpn   s5_5A
ren s5_5_cpn_1 s5_5A1
ren s5_5_cpn_2 s5_5A2
ren s5_5_cpn_3 s5_5A3
ren s5_5_cpn_4 s5_5A4
ren s5_5_cpn_5 s5_5A5
ren s5_5_cpn_autre s5_5A5other


foreach var of var s5_2A s5_3Aa  s5_4Aa s5_5A s5_5A1 s5_5A2 s5_5A3 s5_5A4 s5_5A5   {
	replace `var' = -9 if s5_1==2
}

tostring s5_5A5other, replace
replace s5_5A5other = "na" if s5_1==2 | s5_5A5!=1


replace s5_2A = -9 if s5_1==2 
label values s5_2A regulierement

foreach var of var  s5_3Aa  s5_4Aa  {
	replace `var' = -9 if s5_2A == 3 
}

foreach var of var  s5_5A s5_5A1 s5_5A2 s5_5A3 s5_5A4 s5_5A5  {
	replace `var' = -9 if s5_2A != 3 
}


label values s5_3Aa ouinon

label values s5_5A s5_5A1 s5_5A2 s5_5A3 s5_5A4 s5_5A5 yesno

replace s5_4Aa =-9 if s5_3Aa !=2



rename s_acc_1 s5_1B_a 
rename s_acc_2 s5_1B_b 


 
*rename s_acc_16  

ren s5_2_acc   s5_2B
ren s5_3_acc   s5_3Ba


ren s5_4_acc  s5_4Ba


ren s5_5_acc   s5_5B
ren s5_5_acc_1 s5_5B1
ren s5_5_acc_2 s5_5B2
ren s5_5_acc_3 s5_5B3
ren s5_5_acc_4 s5_5B4
ren s5_5_acc_5 s5_5B5
ren s5_5_acc_autre s5_5B5other


tostring s5_5B5other, replace
replace s5_5B5other = "na" if s5_1B==2 | s5_5B5!=1


foreach var of var s5_1B_a s5_1B_b    s5_5B1 s5_5B2 s5_5B3 s5_5B4 s5_5B5  {
	replace `var' = -9 if s5_1B !=1 
}

lab val  s5_1B_a s5_1B_b  s5_5B1 s5_5B2 s5_5B3 s5_5B4 s5_5B5 yesno

replace s5_2B = -9 if s5_1B !=1

lab val s5_2B regulierement


foreach var of var  s5_3Ba  s5_4Ba  {
	replace `var' = -9 if s5_2B == 3 | s5_2B == -9
}


foreach var of var  s5_5B s5_5B1 s5_5B2 s5_5B3 s5_5B4 s5_5B5 {
	replace `var' = -9 if s5_2B != 3 
}
 

label values s5_3Ba ouinon

*label values s5_5B1 s5_5B2 s5_5B3 s5_5B4 s5_5B5 ouinon

replace s5_4Ba =-9 if s5_3Ba !=2


drop s5_5B



rename s_pnat_1 s5_1C_a 
rename s_pnat_2 s5_1C_b 
rename s_pnat_3 s5_1C_c 
rename s_pnat_4 s5_1C_d 
rename s_pnat_5 s5_1C_e 

ren s5_2_pnat   s5_2C
ren s5_3_pnat   s5_3C
ren s5_4_pnat   s5_4C
ren s5_5_pnat   s5_5C
ren s5_5_pnat_1 s5_5C1
ren s5_5_pnat_2 s5_5C2
ren s5_5_pnat_3 s5_5C3
ren s5_5_pnat_4 s5_5C4
ren s5_5_pnat_5 s5_5C5
ren s5_5_pnat_autre s5_5C5other


tostring s5_5C5other, replace
replace  s5_5C5other = "na" if s5_1C==2 | s5_5C5!=1


foreach var of var s5_1C_a s5_1C_b s5_1C_c s5_1C_d s5_1C_e s5_5C1 s5_5C2 s5_5C3 s5_5C4 s5_5C5 {
	replace `var' = -9 if s5_1C !=1 
}

lab val  s5_1C_a s5_1C_b s5_1C_c s5_1C_d s5_1C_e s5_5C1 s5_5C2 s5_5C3 s5_5C4 s5_5C5 yesno

replace s5_2C = -9 if s5_1C !=1

lab val s5_2C regulierement


replace s5_3C = -9 if s5_2C == 3 | s5_2C == -9



foreach var of var  s5_5C1 s5_5C2 s5_5C3 s5_5C4 s5_5C5  {
	replace `var' = -9 if s5_2C != 3 
}
 

label values s5_3C ouinon

*label values s5_5C1 s5_5C2 s5_5C3 s5_5C4 s5_5C5 ouinon

replace s5_4C =-9 if s5_3C !=2

drop s5_5C

rename s_nne_1 s5_1D_a 
rename s_nne_2 s5_1D_b 
rename s_nne_3 s5_1D_c
rename s_nne_5 s5_1D_e 
rename s_nne_6 s5_1D_f 
rename s_nne_7 s5_1D_g 


ren s5_2_nne   s5_2D
ren s5_3_nne   s5_3D
ren s5_4_nne   s5_4D
ren s5_5_nne   s5_5D
ren s5_5_nne_1 s5_5D1
ren s5_5_nne_2 s5_5D2
ren s5_5_nne_3 s5_5D3
ren s5_5_nne_4 s5_5D4
ren s5_5_nne_5 s5_5D5
ren s5_5_nne_autre s5_5D5other

drop s_nne

tostring s5_5D5other, replace
replace s5_5D5other = "na" if s5_1D==2 | s5_5D5!=1


foreach var of var  s5_1D_a s5_1D_b s5_1D_c  s5_1D_e s5_1D_f s5_1D_g  s5_5D1 s5_5D2 s5_5D3 s5_5D4 s5_2D s5_3D s5_4D s5_5D5  {
	replace `var' = -9 if s5_1D !=1 
}

lab val  s5_1D_a s5_1D_b s5_1D_c s5_1D_e s5_1D_f s5_1D_g s5_5D1 s5_5D2 s5_5D3 s5_5D4 s5_5D5 yesno

replace s5_2D = -9 if s5_1D !=1

lab val s5_2D regulierement


replace s5_3D = -9 if s5_2D == 3 | s5_2D == -9



foreach var of var  s5_5D1 s5_5D2 s5_5D3 s5_5D4 s5_5D5 {
	replace `var' = -9 if s5_2D != 3 
}
 

label values s5_3D ouinon

*label values s5_5D1 s5_5D2 s5_5D3 s5_5D4 s5_5D5 ouinon

replace s5_4D =-9 if s5_3D !=2

drop s5_5D


rename s_inf_1 s5_1F_a 
rename s_inf_2 s5_1F_b 
rename s_inf_3 s5_1F_c 
rename s_inf_4 s5_1F_d 
rename s_inf_5 s5_1F_e 
rename s_inf_6 s5_1F_f 
rename s_inf_7 s5_1F_g 
rename s_inf_8 s5_1F_h 
rename s_inf_9 s5_1F_i 
rename s_inf_10 s5_1F_j 
rename s_inf_11 s5_1F_k 
rename s_inf_12 s5_1F_l 
rename s_inf_13 s5_1F_m 
rename s_inf_14 s5_1F_n 

ren s5_2_sinf   s5_2F
ren s5_3_sinf   s5_3F
ren s5_4_sinf   s5_4F
ren s5_5_sinf   s5_5F
ren s5_5_sinf_1 s5_5F1
ren s5_5_sinf_2 s5_5F2
ren s5_5_sinf_3 s5_5F3
ren s5_5_sinf_4 s5_5F4
ren s5_5_sinf_5 s5_5F5
ren s5_5_sinf_autre s5_5F5other

drop s_inf

tostring s5_5F5other, replace
replace s5_5F5other = "na" if s5_1F==2 | s5_5F5!=1

foreach var of var  s5_1F_a s5_1F_b s5_1F_c s5_1F_d s5_1F_e s5_1F_f s5_1F_g s5_1F_h s5_1F_i s5_1F_j s5_1F_k s5_1F_l s5_1F_m s5_1F_n s5_5F1 s5_5F2 s5_5F3 s5_5F4 s5_5F5 {
	replace `var' = -9 if s5_1F!=1 
}

lab val   s5_1F_a s5_1F_b s5_1F_c s5_1F_d s5_1F_e s5_1F_f s5_1F_g s5_1F_h s5_1F_i s5_1F_j s5_1F_k s5_1F_l s5_1F_m s5_1F_n s5_5F1 s5_5F2 s5_5F3 s5_5F4 s5_5F5 yesno

replace s5_2F = -9 if s5_1F !=1

lab val s5_2F regulierement


replace s5_3F = -9 if s5_2F == 3 | s5_2F == -9


foreach var of var  s5_5F1 s5_5F2 s5_5F3 s5_5F4 s5_5F5  {
	replace `var' = -9 if s5_2F != 3 
}
 
label values s5_3F ouinon

*label values s5_5E1 s5_5E2 s5_5E3 s5_5E4 s5_5E5 ouinon

replace s5_4F =-9 if s5_3F !=2

drop s5_5F

*

*

rename (s5_7c s5_8c s5_9c s5_10c s5_10c_1 s5_10c_2 s5_10c_3 s5_10c_4 s5_10c_5 s5_10_autrec) (s5_7d s5_8d s5_9d s5_10d s5_10d_1 s5_10d_2 s5_10d_3 s5_10d_4 s5_10d_5 s5_10_autred)

rename (s5_7b s5_8b s5_9b s5_10b s5_10b_1 s5_10b_2 s5_10b_3 s5_10b_4 s5_10b_5 s5_10_autreb) (s5_7c s5_8c s5_9c s5_10c s5_10c_1 s5_10c_2 s5_10c_3 s5_10c_4 s5_10c_5 s5_10_autrec)


rename (s5_7a s5_8a s5_9a s5_10a s5_10a_1 s5_10a_2 s5_10a_3 s5_10a_4 s5_10a_5 s5_10_autrea) (s5_7b s5_8b s5_9b s5_10b s5_10b_1 s5_10b_2 s5_10b_3 s5_10b_4 s5_10b_5 s5_10_autreb)

rename (s5_7 s5_8 s5_9 s5_10 s5_10_1 s5_10_2 s5_10_3 s5_10_4 s5_10_5 s5_10_autre)           (s5_7a s5_8a s5_9a s5_10a s5_10a_1 s5_10a_2 s5_10a_3 s5_10a_4 s5_10a_5 s5_10_autrea)


rename (s5_7k s5_8k s5_9k s5_10k s5_10k_1 s5_10k_2 s5_10k_3 s5_10k_4 s5_10k_5 s5_10_autrek) (s5_7j s5_8j s5_9j s5_10j s5_10j_1 s5_10j_2 s5_10j_3 s5_10j_4 s5_10j_5 s5_10_autrej)

rename (s5_7l s5_8l s5_9l s5_10l s5_10l_1 s5_10l_2 s5_10l_3 s5_10l_4 s5_10l_5 s5_10_autrel) (s5_7k s5_8k s5_9k s5_10k s5_10k_1 s5_10k_2 s5_10k_3 s5_10k_4 s5_10k_5 s5_10_autrek)

lab val s5_7a s5_7b s5_7c s5_7d s5_7k frequence
 
 
ren s506 s5_6
ren s506a s5_6a // not in the questionaire

ta s5_7a,m
ta s5_8a,m
tab1 s5_10a*,m

drop s5_10?

lab val s5_10?_? yesno

replace s5_6a = -9 if s5_6==2

foreach var of var s5_7? {
	replace `var' = -9 if s5_6==2
}

foreach x in a b c d e j k  {
foreach var of var s5_8`x' s5_9`x' {
	replace `var' = -9 if s5_7`x'==5|s5_6==2
}
}

foreach x in a b c d e j k  {
foreach var of var s5_9`x' {
	replace `var' = -9 if s5_8`x'==1
}
}

foreach x in a b c d e j k  {
foreach var of var s5_10`x'* {
	replace `var' = -9 if s5_7`x'!=5
}
}






*600
*drop s6_2 v660

*ren v659 s6_2_4autre
/*
foreach var of var  s6_3_?? {
	replace `var' = -9 if inlist(s5_7a,5,-9)&inlist(s5_7b,5,-9)&inlist(s5_7c,5,-9)&inlist(s5_7d,5,-9)
	replace `var' = -5 if (!inlist(s5_7a,5,-9)|!inlist(s5_7b,5,-9)|!inlist(s5_7c,5,-9)|!inlist(s5_7d,5,-9))&`var'==.
}


			
*603

ren s6_3_11 s6_3trav_a
ren s6_3_12 s6_3trav_b
ren s6_3_13 s6_3trav_c
ren s6_3_14 s6_3trav_d
ren s6_3_15 s6_3trav_e
ren s6_3_16 s6_3trav_f
ren s6_3_17 s6_3trav_g
ren s6_3_18 s6_3trav_h
ren s6_3_19 s6_3trav_i
ren s6_3_20 s6_3trav_j
ren s6_3_21 s6_3trav_k
ren s6_3_22 s6_3trav_l
ren s6_3_23 s6_3trav_m
ren s6_3_24 s6_3trav_n


*drop v675 v690 v705

ren s6_4_11 s6_4a1
ren s6_4_12 s6_4b1


*drop v726


foreach var of var  s6_3trav_? s6_4a1  s6_4b1  s6_5 {
	replace `var' = -9 if inlist(s5_7a,5,-9)&inlist(s5_7b,5,-9)&inlist(s5_7c,5,-9)&inlist(s5_7d,5,-9)
	replace `var' = -5 if (!inlist(s5_7a,5,-9)|!inlist(s5_7b,5,-9)|!inlist(s5_7c,5,-9)|!inlist(s5_7d,5,-9))&inlist(`var',.,999,9999)
}
*/

* s6_6 missing on the database
* s6_7 and s6_8 contains information on s6_16 and s6_17

* s6_7 and s6_8 609 610 repeated in the questionaire, the later s6_7 and s6_8 should be s6_16 and s6_17 respectively - renamed

rename (s6_7 s6_8 s6_7a s6_8a s6_7b s6_8b s6_7c s6_8c s6_7d s6_8d s6_7f s6_8f  s6_7j s6_8j )(s6_16a s6_17a s6_16b s6_17b s6_16c s6_17c s6_16d s6_17d s6_16e s6_17e s6_16g s6_17g s6_16k s6_17k)

/*
ren s6_8_1 s6_8a
ren s6_8_2 s6_8b
ren s6_8_3 s6_8c
ren s6_8_4 s6_8d
ren s6_8_5 s6_8e
ren s6_8_6 s6_8f
ren s6_8_7 s6_8g
ren s6_8_8 s6_8h
ren s6_8_9 s6_8i
ren s6_8_10 s6_8j
ren s6_8_11 s6_8k
ren s6_8_12 s6_8l
ren s6_8_13 s6_8m
ren s6_8_14 s6_8n
ren s6_8_15 s6_8o
ren s6_8_16 s6_8p
ren s6_8_17 s6_8q
ren s6_8_18 s6_8r
ren s6_8_19 s6_8s
ren s6_8_20 s6_8t
ren s6_8_21 s6_8u
ren s6_8_22 s6_8v
ren s6_8_23 s6_8w
ren s6_8_24 s6_8x
ren s6_8_25 s6_8y
ren s6_8_26 s6_8z
*/
*drop v754


/*
ren s6_11_1 s6_11a
ren s6_11_2 s6_11b
ren s6_11_3 s6_11c
ren s6_11_4 s6_11d
ren s6_11_5 s6_11e
ren s6_11_6 s6_11f
ren s6_11_7 s6_11g
ren s6_11_8 s6_11h
ren s6_11_9 s6_11i
ren s6_11_10 s6_11j
ren s6_11_11 s6_11k
ren s6_11_12 s6_11l
ren s6_11_13 s6_11m
ren s6_11_14 s6_11n
ren s6_11_15 s6_11o
ren s6_11_16 s6_11p
ren s6_11_17 s6_11q
ren s6_11_18 s6_11r
ren s6_11_19 s6_11s
ren s6_11_20 s6_11t
ren s6_11_21 s6_11u
*/
*drop v777 v1002
/*
ren s6_14_1 s6_14a
ren s6_14_2 s6_14b
ren s6_14_3 s6_14c
ren s6_14_4 s6_14d
ren s6_14_5 s6_14e
ren s6_14_6 s6_14f
ren s6_14_7 s6_14g
ren s6_14_8 s6_14h
ren s6_14_9 s6_14i
*/
drop s6_19 s6_19?

rename (s6_18j s6_19j_1 s6_19j_2 s6_19j_3 s6_19j_4 s6_19j_5 s6_20j) (s6_18k s6_19k_1 s6_19k_2 s6_19k_3 s6_19k_4 s6_19k_5 s6_20k)




rename (s6_18f s6_19f_1 s6_19f_2 s6_19f_3 s6_19f_4 s6_19f_5 s6_20f) (s6_18g s6_19g_1 s6_19g_2 s6_19g_3 s6_19g_4 s6_19g_5 s6_20g)



rename (s6_18d s6_19d_1 s6_19d_2 s6_19d_3 s6_19d_4 s6_19d_5 s6_20d) (s6_18e s6_19e_1 s6_19e_2 s6_19e_3 s6_19e_4 s6_19e_5 s6_20e)

rename (s6_18c s6_19c_1 s6_19c_2 s6_19c_3 s6_19c_4 s6_19c_5 s6_20c) (s6_18d s6_19d_1 s6_19d_2 s6_19d_3 s6_19d_4 s6_19d_5 s6_20d)

rename (s6_18b s6_19b_1 s6_19b_2 s6_19b_3 s6_19b_4 s6_19b_5 s6_20b) (s6_18c s6_19c_1 s6_19c_2 s6_19c_3 s6_19c_4 s6_19c_5 s6_20c)

rename (s6_18a s6_19a_1 s6_19a_2 s6_19a_3 s6_19a_4 s6_19a_5 s6_20a) (s6_18b s6_19b_1 s6_19b_2 s6_19b_3 s6_19b_4 s6_19b_5 s6_20b)

rename (s6_18 s6_19_1 s6_19_2 s6_19_3 s6_19_4 s6_19_5 s6_20)        (s6_18a s6_19a_1 s6_19a_2 s6_19a_3 s6_19a_4 s6_19a_5 s6_20a)

*drop v899



*changing the string variables to all upper case
replace s1_4=upper(s1_4) 


*replace s1_7 with EPS for appending later with other files
drop s1_7

gen s1_7 = 4

lab def structure 4 "Case de santé",modify
lab val s1_7 structure



****************************************
*LABEL ALL THE VARIABLES APPROPRIATELY




*  s5_10a_1 s5_10a_2 s5_10a_3 s5_10a_4 s5_10a_5 s5_10b_1 s5_10b_2 s5_10b_3 s5_10b_4 s5_10b_5 s5_10c_1 s5_10c_2 s5_10c_3 s5_10c_4 s5_10c_5 s5_10d_1 s5_10d_2 s5_10d_3 s5_10d_4 s5_10d_5 s5_10e_1 s5_10e_2 s5_10e_3 s5_10e_4 s5_10e_5 s5_10f_1 s5_10f_2 s5_10f_3 s5_10f_4 s5_10f_5 s5_10g_1 s5_10g_2 s5_10g_3 s5_10g_4 s5_10g_5 s5_10h_1 s5_10h_2 s5_10h_3 s5_10h_4 s5_10h_5 s5_10i_1 s5_10i_2 s5_10i_3 s5_10i_4 s5_10i_5 s5_10j_1 s5_10j_2 s5_10j_3 s5_10j_4 s5_10j_5 s5_10k_1 s5_10k_2 s5_10k_3 s5_10k_4 s5_10k_5 s6_2_2 s6_2_3 s6_2_4 s6_2_4autre s6_19a_1 s6_19a_2 s6_19a_3 s6_19a_4 s6_19a_5 s6_19b_1 s6_19b_2 s6_19b_3 s6_19b_4 s6_19b_5 s6_19c_1 s6_19c_2 s6_19c_3 s6_19c_4 s6_19c_5 s6_19d_1 s6_19d_2 s6_19d_3 s6_19d_4 s6_19d_5 s6_19e_1 s6_19e_2 s6_19e_3 s6_19e_4 s6_19e_5 s6_19f_1 s6_19f_2 s6_19f_3 s6_19f_4 s6_19f_5 s6_19g_1 s6_19g_2 s6_19g_3 s6_19g_4 s6_19g_5 s6_19h_1 s6_19h_2 s6_19h_3 s6_19h_4 s6_19h_5 s6_19i_1 s6_19i_2 s6_19i_3 s6_19i_4 s6_19i_5 s6_19j_1 s6_19j_2 s6_19j_3 s6_19j_4 s6_19j_5 s6_19k_1 s6_19k_2 s6_19k_3 s6_19k_4 s6_19k_5



****************************************
drop today end start submissiondate formdef_version obs
order gpslatitude gpslongitude gpsaltitude gpsaccuracy

duplicates drop  nom_structure , force

save "C:\Users\asandie\Desktop\structure_dm\Clean_data\Case de santé\case_data_clean.dta",replace


rename key parent_key


duplicates drop nom_structure, force

merge 1:1 nom_structure using "C:\Users\asandie\Desktop\structure_dm\raw_data\Case de santé\REGISTRE CASE DE SANTE.dta"

drop _merge

merge m:m parent_key using "C:\Users\asandie\Desktop\structure_dm\Clean_data\Case de santé\casesante_rh.dta"

*keep if _merge==3

drop _merge

tabulate s4_1_1, gen(s4_1_1_)

save "C:\Users\asandie\Desktop\structure_dm\Clean_data\Case de santé\case_data_clean_combined.dta",replace







