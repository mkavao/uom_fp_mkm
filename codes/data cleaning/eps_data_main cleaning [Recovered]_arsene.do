*initialize Stata
clear all
set more off
set mem 100m

cd "C:\Users\asandie\Desktop\structure_dm\Clean_data"
use "C:\Users\asandie\Desktop\structure_dm\raw_data\EPS\QUESTIONNAIRE EPS.dta"

destring _all,replace
compress
ren nom_structure s1_6

*dropping ineligible EPS
drop if inlist(s1_6,11,1)
*drop variables which are not useful
drop equipe enqueteur s1_8 s1_9 s1_10 v43 v99 v106 v143 v113 v180 v222 v233 v242 v253 v258 v266 v316

*this informtion is available when merging with the sub-tables
drop s4_1_2_1 s4_1_2_1_1 s4_1_2_1_2 s4_1_2_1_3 s4_1_2_1_4 s4_1_2_1_5 s4_1_2_1_6 s4_1_2_1_7 s4_1_2_1_8 s4_1_2_1_9 s4_1_2_1_10 s4_1_2_1_11 personnel_1_count setofpersonnel_1 s4_1_2_2 s4_1_2_2_1 s4_1_2_2_2 s4_1_2_2_3 s4_1_2_2_4 s4_1_2_2_5 s4_1_2_2_6 s4_1_2_2_7 s4_1_2_2_8 s4_1_2_2_9 s4_1_2_2_10 s4_1_2_2_11 personnel_2_count setofpersonnel_2

*drop the two health facilities which were not eligible


lab def yesno 0 Non 1 Oui -5 missing -9 na, modify

lab def ouinon 2 Non 1 Oui -5 missing -9 na, modify

lab def regulierement 1 "Régulièrement" 2 "Occasionnellement" 3 "Pas du tout" -5 "missing" -9 "na", modify


lab def dispo_indisp 1 "Disponible et fonctionnel" 2  "Disponible mais pas fonctionnel"  3 "Indisponible" -5 "missing" -9 "na"

	
lab def frequence 1 "Quotidien" 2  "Hebdomadaire"  3 "Tous les quinze jours" 4 "Mensuel" 5 "Pas du tout" -5 "missing" -9 "na"

drop if inlist(s1_6,.,.) //get the code for the two facilities

*renaming variables to conform with the questionaire numbering

rena s1_11 s2_1
rena s1_12 s2_2
rena s1_13 s2_3


*********** SECTION 3 : INFRASTRUCTURE GÉNÉRALE 

*** 301	L'EPS dispose-t-il des éléments suivants ?

ren s3_1_1_1 s3_1a
ren s3_1_2_1 s3_1b
ren s3_1_3_1 s3_1c
ren s3_1_4_1 s3_1d
ren s3_1_5_1 s3_1e
ren s3_1_6_1 s3_1f
ren s3_1_8_1 s3_1g
ren s3_1_8_1a s3_1h
ren s3_1_9_1 s3_1i
ren s3_1_10_1 s3_1j
ren s3_1_11_1 s3_1k
ren s3_1_12_1 s3_1l
ren s3_1_13_1 s3_1m
ren s3_1_14_1 s3_1n

tab1 s3_1?,m


ren s3_2_1 s3_2a
ren s3_2_2 s3_2b
ren s3_2_3 s3_2c
ren s3_2_4 s3_2d

ren s3_2_55 s3_2e // to confirm the name from the final tool
ren s3_2_5 s3_2f
ren s3_2_6 s3_2g
ren s3_2_7 s3_2h
ren s3_2_8 s3_2i
ren s3_2_9 s3_2j


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

ren s3_4_1_1 s3_4ia
ren s3_4_1_2 s3_4ib
ren s3_4_1_3 s3_4ic
ren s3_4_1_4 s3_4id
ren s3_4_1_5 s3_4ie
ren s3_4_1_6 s3_4if
*pedi
*label for the variables need to be updated to capture pedi information

ren s3_4_1_1a s3_4iia
ren s3_4_1_2a s3_4iib
ren s3_4_1_3a s3_4iic
ren s3_4_1_4a s3_4iid
ren s3_4_1_5a s3_4iie
ren s3_4_1_6a s3_4iif

*question 3.5
*a
ren s3_5_1  s3_5a_1
ren s3_5_2  s3_5a_2
ren s3_5_3  s3_5a_3
ren s3_5_4  s3_5a_4
ren s3_5_5  s3_5a_5
ren s3_5_6  s3_5a_6
ren s3_5_7  s3_5a_7
ren s3_5_8  s3_5a_8
ren s3_5_9  s3_5a_9
ren s3_5_10 s3_5a_10
ren s3_5_11 s3_5a_11
ren s3_5_12 s3_5a_12
ren s3_5_13 s3_5a_13
ren s3_5_14 s3_5a_14
ren s3_5_15 s3_5a_15
ren s3_5_16 s3_5a_16
ren s3_5_17 s3_5a_17
ren s3_5_18 s3_5a_18
ren s3_5_19 s3_5a_19
ren s3_5_20 s3_5a_20
ren s3_5_21 s3_5a_21
ren s3_5_22 s3_5a_22
ren s3_5_23 s3_5a_23
ren s3_5_24 s3_5a_24
ren s3_5_25 s3_5a_25
ren s3_5_26 s3_5a_26
ren s3_5_27 s3_5a_27
ren s3_5_28 s3_5a_28
ren s3_5_29 s3_5a_29

tab1 s3_5a_? s3_5a_??,m

ren s3_5_33 s3_5b_1
ren s3_5_35 s3_5b_3
ren s3_5_37 s3_5b_6
ren s3_5_38 s3_5b_7
ren s3_5_42 s3_5b_11
ren s3_5_43 s3_5b_12
ren s3_5_44 s3_5b_13
ren s3_5_45 s3_5b_14
ren s3_5_46 s3_5b_15
ren s3_5_47 s3_5b_16
ren s3_5_48 s3_5b_17
ren s3_5_49 s3_5b_18
ren s3_5_50 s3_5b_19
ren s3_5_51 s3_5b_20
ren s3_5_52 s3_5b_21
ren s3_5_53 s3_5b_22
ren s3_5_54 s3_5b_30 //not in part A
ren s3_5_55 s3_5b_31 //
ren s3_5_56 s3_5b_23
ren s3_5_57 s3_5b_24
ren s3_5_58 s3_5b_25
ren s3_5_59 s3_5b_26
ren s3_5_60 s3_5b_27
ren s3_5_61 s3_5b_28
ren s3_5_62 s3_5b_32 //not in A
ren s3_5_63 s3_5b_33 // not in A
ren s3_5_64 s3_5b_29

tab1 s3_5b_? s3_5b_??,m


ren s3_122 s3_14

ren s3_14_1 s3_14a
ren s3_14_2 s3_14b
ren s3_14_3 s3_14c
ren s3_14_4 s3_14d
ren s3_14_5 s3_14e
ren s3_14_6 s3_14f
ren s3_14_7 s3_14g
ren s3_14_8 s3_14h
ren s3_14_9 s3_14i
ren s3_14_10 s3_14j
ren s3_14_11 s3_14k
ren s3_14_12 s3_14l
ren s3_14_13 s3_14m
ren s3_14_14 s3_14n
ren s3_14_15 s3_14o
ren s3_14_16 s3_14p
ren s3_14_17 s3_14q
ren s3_14_18 s3_14r
ren s3_14_19 s3_14s
ren s3_14_20 s3_14t
ren s3_14_21 s3_14u
ren s3_14_22 s3_14v
ren s3_14_23 s3_14w
ren s3_14_24 s3_14x
ren s3_14_25 s3_14y
ren s3_14_26 s3_14z
ren s3_14_27 s3_14aa
ren s3_14_28 s3_14ab
ren s3_14_29 s3_14ac
ren s3_14_30 s3_14ad
ren s3_14_31 s3_14ae
ren s3_14_32 s3_14af
ren s3_14_33 s3_14ag
ren s3_14_34 s3_14ah
ren s3_14_35 s3_14ai
ren s3_14_36 s3_14aj
ren s3_14_37 s3_14ak
ren s3_14_38 s3_14al
ren s3_14_39 s3_14am
ren s3_14_40 s3_14an





foreach var of var   s3_7 s3_8 s3_9 s3_10 s3_11 s3_12 s3_13 s3_14 s3_14a s3_14b s3_14c s3_14d s3_14e s3_14f s3_14g s3_14h s3_14i s3_14j s3_14k s3_14l s3_14m s3_14n s3_14o s3_14p s3_14q s3_14r s3_14s s3_14t s3_14u s3_14v s3_14w s3_14x s3_14y s3_14z s3_14aa s3_14ab s3_14ac s3_14ad s3_14ae s3_14af s3_14ag s3_14ah s3_14ai s3_14aj s3_14ak s3_14al s3_14am s3_14an {
	replace `var' = -9 if s3_6==2
}

label values s3_7 s3_8 s3_9 s3_10 s3_11 s3_12 s3_13 s3_14 ouinon

label values s3_14a s3_14b s3_14c s3_14d s3_14e s3_14f s3_14g s3_14h s3_14i s3_14j s3_14k s3_14l s3_14m s3_14n s3_14o s3_14p s3_14q s3_14r s3_14s s3_14t s3_14u s3_14v s3_14w s3_14x s3_14y s3_14z s3_14aa s3_14ab s3_14ac s3_14ad s3_14ae s3_14af s3_14ag s3_14ah s3_14ai s3_14aj s3_14ak s3_14al s3_14am s3_14an dispo_indisp

ren s3_16_1 s3_16a
ren s3_16_2 s3_16b
ren s3_16_3 s3_16c
ren s3_16_4 s3_16d
ren s3_16_5 s3_16e
ren s3_16_6 s3_16f
ren s3_16_7 s3_16g
ren s3_16_8 s3_16h
ren s3_16_9 s3_16i
ren s3_16_10 s3_16j

ren s3_17_1 s3_17a
ren s3_17_2 s3_17b
ren s3_17_3 s3_17c
ren s3_17_4 s3_17d
ren s3_17_5 s3_17e
ren s3_17_6 s3_17f
ren s3_17_7 s3_17g
ren s3_17_8 s3_17h

ren s3_18_1 s3_18a
ren s3_18_2 s3_18b
ren s3_18_3 s3_18c
ren s3_18_4 s3_18d
ren s3_18_5 s3_18e
ren s3_18_6 s3_18f
ren s3_18_7 s3_18g
ren s3_18_8 s3_18h
ren s3_18_9 s3_18i
ren s3_18_10 s3_18j

ren s3_18_11 s3_18k
ren s3_18_12 s3_18l
ren s3_18_13 s3_18m

ren s3_20_1 s3_20a
ren s3_20_2 s3_20b
ren s3_20_3 s3_20c
ren s3_20_4 s3_20d
ren s3_20_5 s3_20e
ren s3_20_6 s3_20f
ren s3_20_7 s3_20g



foreach var of var   s3_20a s3_20b s3_20c s3_20d s3_20e s3_20f s3_20g {
	replace `var' = -9 if s3_19==2
}

label values s3_20a s3_20b s3_20c s3_20d s3_20e s3_20f s3_20g ouinon


ren s3_21_1 s3_21a
ren s3_21_2 s3_21b
ren s3_21_3 s3_21c
ren s3_21_4 s3_21d
ren s3_21_5 s3_21e
ren s3_21_6 s3_21f
ren s3_21_7 s3_21g
ren s3_21_8 s3_21h
ren s3_21_9 s3_21i
ren s3_21_10 s3_21j

ren s3_21_11 s3_21k
ren s3_21_12 s3_21l
ren s3_21_13 s3_21m
ren s3_21_14 s3_21n
ren s3_21_15 s3_21o
ren s3_21_16 s3_21p
ren s3_21_17 s3_21q
ren s3_21_18 s3_21r
ren s3_21_19 s3_21s
ren s3_21_20 s3_21t

ren s3_21_21 s3_21u
ren s3_21_22 s3_21v
ren s3_21_23 s3_21w
ren s3_21_24 s3_21x
ren s3_21_25 s3_21y
ren s3_21_26 s3_21z
ren s3_21_27 s3_21aa
ren s3_21_28 s3_21ab
ren s3_21_29 s3_21ac
ren s3_21_30 s3_21ad
ren s3_21_31 s3_21ae
ren s3_21_32 s3_21af
ren s3_21_33 s3_21ag
ren s3_21_34 s3_21ah
ren s3_21_35 s3_21ai
ren s3_21_36 s3_21aj
ren s3_21_37 s3_21ak
ren s3_21_38 s3_21al
ren s3_21_39 s3_21am
ren s3_21_40 s3_21an
ren s3_21_41 s3_21ao
ren s3_21_42 s3_21ap
ren s3_21_43 s3_21aq
ren s3_21_44 s3_21ar
ren s3_21_45 s3_21as
ren s3_21_46 s3_21at
ren s3_21_47 s3_21au
ren s3_21_48 s3_21av
ren s3_21_49 s3_21aw


ren s3_22_1 s3_22a 
ren s3_22_2  s3_22b
ren s3_22_3  s3_22c
ren s3_22_4  s3_22d
ren s3_22_5  s3_22e
ren s3_22_6  s3_22f
ren s3_22_7  s3_22g
ren s3_22_8  s3_22h
ren s3_22_9  s3_22i
ren s3_22_10  s3_22j
ren s3_22_11  s3_22k
ren s3_22_12  s3_22l
ren s3_22_13  s3_22m
ren s3_22_14  s3_22n
ren s3_22_15  s3_22o
ren s3_22_16  s3_22p
ren s3_22_17  s3_22q
ren s3_22_18  s3_22r
ren s3_22_19  s3_22s
ren s3_22_20  s3_22t
ren s3_22_21  s3_22u
ren s3_22_22  s3_22v
ren s3_22_23  s3_22w
ren s3_22_24  s3_22x


foreach var of var s3_21a s3_21b s3_21c s3_21d s3_21e s3_21f s3_21g s3_21h s3_21i s3_21j s3_21k s3_21l s3_21m s3_21n s3_21o s3_21p s3_21q s3_21r s3_21s s3_21t s3_21u s3_21v s3_21w s3_21x s3_21y s3_21z s3_21aa s3_21ab s3_21ac s3_21ad s3_21ae s3_21af s3_21ag s3_21ah s3_21ai s3_21aj s3_21ak s3_21al s3_21am s3_21an s3_21ao s3_21ap s3_21aq s3_21ar s3_21as s3_21at s3_21au s3_21av s3_21aw s3_22a  s3_22b s3_22c s3_22d s3_22e s3_22f s3_22g s3_22h s3_22i s3_22j s3_22k s3_22l s3_22m s3_22n s3_22o s3_22p s3_22q s3_22r s3_22s s3_22t s3_22u s3_22v s3_22w s3_22x {
	replace `var' = -9 if s3_19==2
}

label values s3_21a s3_21b s3_21c s3_21d s3_21e s3_21f s3_21g s3_21h s3_21i s3_21j s3_21k s3_21l s3_21m s3_21n s3_21o s3_21p s3_21q s3_21r s3_21s s3_21t s3_21u s3_21v s3_21w s3_21x s3_21y s3_21z s3_21aa s3_21ab s3_21ac s3_21ad s3_21ae s3_21af s3_21ag s3_21ah s3_21ai s3_21aj s3_21ak s3_21al s3_21am s3_21an s3_21ao s3_21ap s3_21aq s3_21ar s3_21as s3_21at s3_21au s3_21av s3_21aw s3_22a  s3_22b s3_22c s3_22d s3_22e s3_22f s3_22g s3_22h s3_22i s3_22j s3_22k s3_22l s3_22m s3_22n s3_22o s3_22p s3_22q s3_22r s3_22s s3_22t s3_22u s3_22v s3_22w s3_22x dispo_indisp
 
 
 

*servi_smni  - to be renamed properly after consulting with Arsene
*to be checked how the question is frame in the final tool - who was interviewed?
drop servi_smni s_cpn s_acc s_pnat
ren s501 s5_1
ren servi_smni_1 s5_1A
ren servi_smni_2 s5_1B
ren servi_smni_3 s5_1C
ren servi_smni_4 s5_1D
ren servi_smni_5 s5_1E
ren servi_smni_6 s5_1F

rename s_cpn_* s5_1A_* 

foreach var of var s5_1A s5_1B s5_1C s5_1D s5_1E s5_1F s5_1A_a s5_1A_b s5_1A_c s5_1A_d s5_1A_e s5_1A_f s5_1A_g s5_1A_h s5_1A_i s5_1A_j s5_1A_k s5_1A_l s5_1A_m s5_1A_n s5_1A_o s5_1A_p s5_1A_q s5_1A_r s5_1A_s s5_1A_t s5_1A_u s5_1A_v s5_1A_w s5_1A_x s5_1A_y  {
	replace `var' = -9 if s5_1==2
}

lab val s5_1A s5_1B s5_1C s5_1D s5_1E s5_1F s5_1A_a s5_1A_b s5_1A_c s5_1A_d s5_1A_e s5_1A_f s5_1A_g s5_1A_h s5_1A_i s5_1A_j s5_1A_k s5_1A_l s5_1A_m s5_1A_n s5_1A_o s5_1A_p s5_1A_q s5_1A_r s5_1A_s s5_1A_t s5_1A_u s5_1A_v s5_1A_w s5_1A_x s5_1A_y yesno

ren s5_2_cpn   s5_2A
ren s5_3_cpn   s5_3Aa
ren s5_3_cpna  s5_3Ab
ren s5_4_cpn   s5_4Aa
ren s5_4_cpna  s5_4Ab
ren s5_5_cpn   s5_5A
ren s5_5_cpn_1 s5_5A1
ren s5_5_cpn_2 s5_5A2
ren s5_5_cpn_3 s5_5A3
ren s5_5_cpn_4 s5_5A4
ren s5_5_cpn_5 s5_5A5
ren s5_5_cpn_autre s5_5A5other


foreach var of var s5_2A s5_3Aa s5_3Ab s5_4Aa s5_4Ab s5_5A s5_5A1 s5_5A2 s5_5A3 s5_5A4 s5_5A5   {
	replace `var' = -9 if s5_1==2
}

tostring s5_5A5other, replace
replace s5_5A5other = "na" if s5_1==2 | s5_5A5!=1


replace s5_2A = -9 if s5_1==2 
label values s5_2A regulierement

foreach var of var  s5_3Aa s5_3Ab s5_4Aa s5_4Ab {
	replace `var' = -9 if s5_2A == 3 
}

foreach var of var  s5_5A s5_5A1 s5_5A2 s5_5A3 s5_5A4 s5_5A5  {
	replace `var' = -9 if s5_2A != 3 
}


label values s5_3Aa s5_3Ab ouinon

label values s5_5A s5_5A1 s5_5A2 s5_5A3 s5_5A4 s5_5A5 yesno

replace s5_4Aa =-9 if s5_3Aa !=2
replace s5_4Ab =-9 if s5_3Ab !=2


rename s_acc_1 s5_1B_a 
rename s_acc_2 s5_1B_b 
rename s_acc_3 s5_1B_c 
rename s_acc_4 s5_1B_d 
rename s_acc_5 s5_1B_e 
rename s_acc_6 s5_1B_f 
rename s_acc_7 s5_1B_g 
rename s_acc_8 s5_1B_h 
rename s_acc_9 s5_1B_i 
rename s_acc_10 s5_1B_j 
rename s_acc_11 s5_1B_k 
rename s_acc_12 s5_1B_l 
rename s_acc_13 s5_1B_m 
rename s_acc_14 s5_1B_n 
rename s_acc_15 s5_1B_o 
rename s_acc_16 s5_1B_p 

ren s5_2_acc   s5_2B
ren s5_3_acc   s5_3Ba
ren s5_3_acca  s5_3Bb
ren s5_4_acc1  s5_4Ba
ren s5_4_acc2  s5_4Bb
ren s5_5_acc   s5_5B
ren s5_5_acc_1 s5_5B1
ren s5_5_acc_2 s5_5B2
ren s5_5_acc_3 s5_5B3
ren s5_5_acc_4 s5_5B4
ren s5_5_acc_5 s5_5B5
ren s5_5_acc_autre s5_5B5other


tostring s5_5B5other, replace
replace s5_5B5other = "na" if s5_1B==2 | s5_5B5!=1


foreach var of var s5_1B_a s5_1B_b s5_1B_c s5_1B_d s5_1B_e s5_1B_f s5_1B_g s5_1B_h s5_1B_i s5_1B_j s5_1B_k s5_1B_l s5_1B_m s5_1B_n s5_1B_o s5_1B_p s5_5B1 s5_5B2 s5_5B3 s5_5B4 s5_5B5  {
	replace `var' = -9 if s5_1B !=1 
}

lab val  s5_1B_a s5_1B_b s5_1B_c s5_1B_d s5_1B_e s5_1B_f s5_1B_g s5_1B_h s5_1B_i s5_1B_j s5_1B_k s5_1B_l s5_1B_m s5_1B_n s5_1B_o s5_1B_p s5_5B1 s5_5B2 s5_5B3 s5_5B4 s5_5B5 yesno

replace s5_2B = -9 if s5_1B !=1

lab val s5_2B regulierement


foreach var of var  s5_3Ba s5_3Bb s5_4Ba s5_4Bb  {
	replace `var' = -9 if s5_2B == 3 | s5_2B == -9
}


foreach var of var  s5_5B s5_5B1 s5_5B2 s5_5B3 s5_5B4 s5_5B5 {
	replace `var' = -9 if s5_2B != 3 
}
 

label values s5_3Ba s5_3Bb ouinon

*label values s5_5B1 s5_5B2 s5_5B3 s5_5B4 s5_5B5 ouinon

replace s5_4Ba =-9 if s5_3Ba !=2
replace s5_4Bb =-9 if s5_3Bb !=2

replace  s5_3Bb = -5 if  s5_3Bb == .

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
rename s_nne_4 s5_1D_d 
rename s_nne_5 s5_1D_e 
rename s_nne_6 s5_1D_f 
rename s_nne_7 s5_1D_g 
rename s_nne_8 s5_1D_h 
rename s_nne_9 s50_1D_i 

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


foreach var of var  s5_1D_a s5_1D_b s5_1D_c s5_1D_d s5_1D_e s5_1D_f s5_1D_g s5_1D_h s50_1D_i s5_5D1 s5_5D2 s5_5D3 s5_5D4 s5_2D s5_3D s5_4D s5_5D5  {
	replace `var' = -9 if s5_1D !=1 
}

lab val  s5_1D_a s5_1D_b s5_1D_c s5_1D_d s5_1D_e s5_1D_f s5_1D_g s5_1D_h s50_1D_i s5_5D1 s5_5D2 s5_5D3 s5_5D4 s5_5D5 yesno

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


rename s_avo_1 s5_1E_a 
rename s_avo_2 s5_1E_b 
rename s_avo_3 s5_1E_c 

ren s5_2_avo   s5_2E
ren s5_3_avo   s5_3E
ren s5_4_avo   s5_4E
ren s5_5_avo   s5_5E
ren s5_5_avo_1 s5_5E1
ren s5_5_avo_2 s5_5E2
ren s5_5_avo_3 s5_5E3
ren s5_5_avo_4 s5_5E4
ren s5_5_avo_5 s5_5E5
ren s5_5_avo_autre s5_5E5other

drop s_avo


tostring s5_5E5other, replace
replace s5_5E5other = "na" if s5_1E==2 | s5_5E5!=1


foreach var of var  s5_1E_a s5_1E_b s5_1E_c s5_2E s5_3E s5_4E s5_5E1 s5_5E2 s5_5E3 s5_5E4 s5_5E5 {
	replace `var' = -9 if s5_1E!=1 
}

lab val    s5_1E_a s5_1E_b s5_1E_c s5_5E1 s5_5E2 s5_5E3 s5_5E4 s5_5E5 yesno

replace s5_2E = -9 if s5_1E !=1

lab val s5_2E regulierement


replace s5_3E = -9 if s5_2E == 3 | s5_2E == -9


foreach var of var  s5_5E1 s5_5E2 s5_5E3 s5_5E4 s5_5E5 {
	replace `var' = -9 if s5_2E != 3 
}
 
label values s5_3E ouinon

*label values s5_5E1 s5_5E2 s5_5E3 s5_5E4 s5_5E5 ouinon

replace s5_4E =-9 if s5_3E !=2

drop s5_5E

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

rename (s5_7c s5_8c s5_9c s5_10c s5_10c_1 s5_10c_2 s5_10c_3 s5_10c_4 s5_10c_5 s5_10_autrec) (s5_7d s5_8d s5_9d s5_10d s5_10d_1 s5_10d_2 s5_10d_3 s5_10d_4 s5_10d_5 s5_10_autred)

rename (s5_7b s5_8b s5_9b s5_10b s5_10b_1 s5_10b_2 s5_10b_3 s5_10b_4 s5_10b_5 s5_10_autreb) (s5_7c s5_8c s5_9c s5_10c s5_10c_1 s5_10c_2 s5_10c_3 s5_10c_4 s5_10c_5 s5_10_autrec)


rename (s5_7a s5_8a s5_9a s5_10a s5_10a_1 s5_10a_2 s5_10a_3 s5_10a_4 s5_10a_5 s5_10_autrea) (s5_7b s5_8b s5_9b s5_10b s5_10b_1 s5_10b_2 s5_10b_3 s5_10b_4 s5_10b_5 s5_10_autreb)

rename (s5_7 s5_8 s5_9 s5_10 s5_10_1 s5_10_2 s5_10_3 s5_10_4 s5_10_5 s5_10_autre)           (s5_7a s5_8a s5_9a s5_10a s5_10a_1 s5_10a_2 s5_10a_3 s5_10a_4 s5_10a_5 s5_10_autrea)

rename (s5_7j s5_8j s5_9j s5_10j s5_10j_1 s5_10j_2 s5_10j_3 s5_10j_4 s5_10j_5 s5_10_autrej) (s5_7i s5_8i s5_9i s5_10i s5_10i_1 s5_10i_2 s5_10i_3 s5_10i_4 s5_10i_5 s5_10_autrei)

rename (s5_7k s5_8k s5_9k s5_10k s5_10k_1 s5_10k_2 s5_10k_3 s5_10k_4 s5_10k_5 s5_10_autrek) (s5_7j s5_8j s5_9j s5_10j s5_10j_1 s5_10j_2 s5_10j_3 s5_10j_4 s5_10j_5 s5_10_autrej)

rename (s5_7l s5_8l s5_9l s5_10l s5_10l_1 s5_10l_2 s5_10l_3 s5_10l_4 s5_10l_5 s5_10_autrel) (s5_7k s5_8k s5_9k s5_10k s5_10k_1 s5_10k_2 s5_10k_3 s5_10k_4 s5_10k_5 s5_10_autrek)

lab val s5_7a s5_7b s5_7c s5_7d s5_7i s5_7j s5_7k frequence
 
 
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

foreach x in a b c d e f g h i j k  {
foreach var of var s5_8`x' s5_9`x' {
	replace `var' = -9 if s5_7`x'==5|s5_6==2
}
}

foreach x in a b c d e f g h i j k  {
foreach var of var s5_9`x' {
	replace `var' = -9 if s5_8`x'==1
}
}

foreach x in a b c d e f g h i j k  {
foreach var of var s5_10`x'* {
	replace `var' = -9 if s5_7`x'!=5
}
}


*511 - 513

ren s5_13_1 s5_13a
ren s5_13_2 s5_13b
ren s5_13_3 s5_13c
ren s5_13_4 s5_13d
ren s5_13_5 s5_13e
ren s5_13_6 s5_13f
ren s5_13_7 s5_13g
ren s5_13_8 s5_13h
ren s5_13_9 s5_13i
ren s5_13_10 s5_13j
ren s5_13_11 s5_13k
ren s5_13_12 s5_13l
ren s5_13_13 s5_13m
ren s5_13_14 s5_13n
ren s5_13_15 s5_13o
ren s5_13_16 s5_13p
ren s5_13_17 s5_13q
ren s5_13_18 s5_13r
ren s5_13_19 s5_13s
ren s5_13_20 s5_13t

drop v633

foreach var of var s5_12 s5_13* {
	replace `var' = -9 if s5_11==2
}



*600
drop s6_2 v660

ren v659 s6_2_4autre

foreach var of var  s6_2_? {
	replace `var' = -9 if inlist(s5_7a,5,-9)&inlist(s5_7b,5,-9)&inlist(s5_7c,5,-9)&inlist(s5_7d,5,-9)
	replace `var' = -5 if (!inlist(s5_7a,5,-9)|!inlist(s5_7b,5,-9)|!inlist(s5_7c,5,-9)|!inlist(s5_7d,5,-9))&`var'==.
}

lab val s6_2_1	s6_2_2	s6_2_3	s6_2_4 yesno
			
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


ren s6_3_266 s6_3coin_a
ren s6_3_277 s6_3coin_b
ren s6_3_288 s6_3coin_c
ren s6_3_299 s6_3coin_d
ren s6_3_300 s6_3coin_e
ren s6_3_301 s6_3coin_f
ren s6_3_302 s6_3coin_g
ren s6_3_303 s6_3coin_h
ren s6_3_304 s6_3coin_i
ren s6_3_305 s6_3coin_j
ren s6_3_306 s6_3coin_k
ren s6_3_307 s6_3coin_l
ren s6_3_308 s6_3coin_m
ren s6_3_309 s6_3coin_n

*not in the questionaire
ren s6_3_26 s6_3both_a
ren s6_3_27 s6_3both_b
ren s6_3_28 s6_3both_c
ren s6_3_29 s6_3both_d
ren s6_3_30 s6_3both_e
ren s6_3_31 s6_3both_f
ren s6_3_32 s6_3both_g
ren s6_3_33 s6_3both_h
ren s6_3_34 s6_3both_i
ren s6_3_35 s6_3both_j
ren s6_3_36 s6_3both_k
ren s6_3_37 s6_3both_l
ren s6_3_38 s6_3both_m
ren s6_3_39 s6_3both_n

*not in the questionaire

ren s6_3_40 s6_3other_a
ren s6_3_41 s6_3other_b
ren s6_3_42 s6_3other_c
ren s6_3_43 s6_3other_d
ren s6_3_44 s6_3other_e
ren s6_3_45 s6_3other_f
ren s6_3_46 s6_3other_g
ren s6_3_47 s6_3other_h
ren s6_3_48 s6_3other_i
ren s6_3_49 s6_3other_j
ren s6_3_50 s6_3other_k
ren s6_3_51 s6_3other_l
ren s6_3_52 s6_3other_m
ren s6_3_53 s6_3other_n

drop v675 v690 v705

ren s6_4_11 s6_4a1
ren s6_4_12 s6_4b1
ren s6_4_21 s6_4a2
ren s6_4_22 s6_4b2

*not in the questionaire
ren s6_4_21a s6_4a2other // check the correct naming
ren s6_4_22a s6_4b2other

drop v726


foreach var of var  s6_3trav_? s6_3coin_? s6_3both_? s6_3other_? s6_4a1 s6_4a2 s6_4b1 s6_4b2 s6_4a2other s6_4b2other s6_5 {
	replace `var' = -9 if inlist(s5_7a,5,-9)&inlist(s5_7b,5,-9)&inlist(s5_7c,5,-9)&inlist(s5_7d,5,-9)
	replace `var' = -5 if (!inlist(s5_7a,5,-9)|!inlist(s5_7b,5,-9)|!inlist(s5_7c,5,-9)|!inlist(s5_7d,5,-9))&inlist(`var',.,999,9999)
}


* s6_6 missing on the database
* s6_7 and s6_8 contains information on s6_16 and s6_17

* s6_7 and s6_8 609 610 repeated in the questionaire, the later s6_7 and s6_8 should be s6_16 and s6_17 respectively - renamed

rename (s6_7 s6_8 s6_7a s6_8a s6_7b s6_8b s6_7c s6_8c s6_7d s6_8d s6_7e s6_8e s6_7f s6_8f s6_7g s6_8g s6_7h s6_8h s6_7i s6_8i s6_7j s6_8j ) (s6_16a s6_17a s6_16b s6_17b s6_16c s6_17c s6_16d s6_17d s6_16e s6_17e s6_16f s6_17f s6_16g s6_17g s6_16h s6_17h s6_16i s6_17i s6_16j s6_17j s6_16k s6_17k)


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

drop v754


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

drop v777 v1002

ren s6_14_1 s6_14a
ren s6_14_2 s6_14b
ren s6_14_3 s6_14c
ren s6_14_4 s6_14d
ren s6_14_5 s6_14e
ren s6_14_6 s6_14f
ren s6_14_7 s6_14g
ren s6_14_8 s6_14h
ren s6_14_9 s6_14i

drop s6_19 s6_19?

rename (s6_18j s6_19j_1 s6_19j_2 s6_19j_3 s6_19j_4 s6_19j_5 s6_20j) (s6_18k s6_19k_1 s6_19k_2 s6_19k_3 s6_19k_4 s6_19k_5 s6_20k)
rename (s6_18i s6_19i_1 s6_19i_2 s6_19i_3 s6_19i_4 s6_19i_5 s6_20i) (s6_18j s6_19j_1 s6_19j_2 s6_19j_3 s6_19j_4 s6_19j_5 s6_20j)
rename (s6_18h s6_19h_1 s6_19h_2 s6_19h_3 s6_19h_4 s6_19h_5 s6_20h) (s6_18i s6_19i_1 s6_19i_2 s6_19i_3 s6_19i_4 s6_19i_5 s6_20i)
rename (s6_18g s6_19g_1 s6_19g_2 s6_19g_3 s6_19g_4 s6_19g_5 s6_20g) (s6_18h s6_19h_1 s6_19h_2 s6_19h_3 s6_19h_4 s6_19h_5 s6_20h)
rename (s6_18f s6_19f_1 s6_19f_2 s6_19f_3 s6_19f_4 s6_19f_5 s6_20f) (s6_18g s6_19g_1 s6_19g_2 s6_19g_3 s6_19g_4 s6_19g_5 s6_20g)
rename (s6_18e s6_19e_1 s6_19e_2 s6_19e_3 s6_19e_4 s6_19e_5 s6_20e) (s6_18f s6_19f_1 s6_19f_2 s6_19f_3 s6_19f_4 s6_19f_5 s6_20f)
rename (s6_18d s6_19d_1 s6_19d_2 s6_19d_3 s6_19d_4 s6_19d_5 s6_20d) (s6_18e s6_19e_1 s6_19e_2 s6_19e_3 s6_19e_4 s6_19e_5 s6_20e)
rename (s6_18c s6_19c_1 s6_19c_2 s6_19c_3 s6_19c_4 s6_19c_5 s6_20c) (s6_18d s6_19d_1 s6_19d_2 s6_19d_3 s6_19d_4 s6_19d_5 s6_20d)
rename (s6_18b s6_19b_1 s6_19b_2 s6_19b_3 s6_19b_4 s6_19b_5 s6_20b) (s6_18c s6_19c_1 s6_19c_2 s6_19c_3 s6_19c_4 s6_19c_5 s6_20c)
rename (s6_18a s6_19a_1 s6_19a_2 s6_19a_3 s6_19a_4 s6_19a_5 s6_20a) (s6_18b s6_19b_1 s6_19b_2 s6_19b_3 s6_19b_4 s6_19b_5 s6_20b)
rename (s6_18 s6_19_1 s6_19_2 s6_19_3 s6_19_4 s6_19_5 s6_20)        (s6_18a s6_19a_1 s6_19a_2 s6_19a_3 s6_19a_4 s6_19a_5 s6_20a)

drop v899

ren s7_6_1 s7_5a
ren s7_6_2 s7_5b
ren s7_6_3 s7_5c
ren s7_6_4 s7_5d
ren s7_6_5 s7_5e
ren s7_6_6 s7_5f
ren s7_6_7 s7_5g
ren s7_6_8 s7_5h
ren s7_6_9 s7_5i
ren s7_6_10 s7_5j

ren s7_7_1 s7_6a
ren s7_7_2 s7_6b
ren s7_7_3 s7_6c
ren s7_7_4 s7_6d
ren s7_7_5 s7_6e
ren s7_7_6 s7_6f

ren s7_8_1 s7_7a
ren s7_8_2 s7_7b
ren s7_8_3 s7_7c
ren s7_8_4 s7_7d
ren s7_8_5 s7_7e
ren s7_8_6 s7_7f
ren s7_8_7 s7_7g
ren s7_8_8 s7_7h
ren s7_8_9 s7_7i

drop v1013 v1020 



*changing the string variables to all upper case
replace s1_4=upper(s1_4) 


*replace s1_7 with EPS for appending later with other files
replace s1_7=1 if s1_7==.

lab def structure 1 "EPS" 2 "Centre de santé" 3 "Poste de santé" 4 "Case de santé" 5 "Clinique" ,modify

lab val s1_7 structure



****************************************
*LABEL ALL THE VARIABLES APPROPRIATELY




*  s5_10a_1 s5_10a_2 s5_10a_3 s5_10a_4 s5_10a_5 s5_10b_1 s5_10b_2 s5_10b_3 s5_10b_4 s5_10b_5 s5_10c_1 s5_10c_2 s5_10c_3 s5_10c_4 s5_10c_5 s5_10d_1 s5_10d_2 s5_10d_3 s5_10d_4 s5_10d_5 s5_10e_1 s5_10e_2 s5_10e_3 s5_10e_4 s5_10e_5 s5_10f_1 s5_10f_2 s5_10f_3 s5_10f_4 s5_10f_5 s5_10g_1 s5_10g_2 s5_10g_3 s5_10g_4 s5_10g_5 s5_10h_1 s5_10h_2 s5_10h_3 s5_10h_4 s5_10h_5 s5_10i_1 s5_10i_2 s5_10i_3 s5_10i_4 s5_10i_5 s5_10j_1 s5_10j_2 s5_10j_3 s5_10j_4 s5_10j_5 s5_10k_1 s5_10k_2 s5_10k_3 s5_10k_4 s5_10k_5 s6_2_2 s6_2_3 s6_2_4 s6_2_4autre s6_19a_1 s6_19a_2 s6_19a_3 s6_19a_4 s6_19a_5 s6_19b_1 s6_19b_2 s6_19b_3 s6_19b_4 s6_19b_5 s6_19c_1 s6_19c_2 s6_19c_3 s6_19c_4 s6_19c_5 s6_19d_1 s6_19d_2 s6_19d_3 s6_19d_4 s6_19d_5 s6_19e_1 s6_19e_2 s6_19e_3 s6_19e_4 s6_19e_5 s6_19f_1 s6_19f_2 s6_19f_3 s6_19f_4 s6_19f_5 s6_19g_1 s6_19g_2 s6_19g_3 s6_19g_4 s6_19g_5 s6_19h_1 s6_19h_2 s6_19h_3 s6_19h_4 s6_19h_5 s6_19i_1 s6_19i_2 s6_19i_3 s6_19i_4 s6_19i_5 s6_19j_1 s6_19j_2 s6_19j_3 s6_19j_4 s6_19j_5 s6_19k_1 s6_19k_2 s6_19k_3 s6_19k_4 s6_19k_5



****************************************
drop today end start submissiondate formdef_version obs
order gpslatitude gpslongitude gpsaltitude gpsaccuracy

duplicates drop  s1_6, force

save "C:\Users\asandie\Desktop\structure_dm\Clean_data\EPS\eps_data_clean.dta",replace



rename key parent_key
rename s1_6 nom_structure

decode nom_structure, gen(nom_structur)

tostring nom_structur, replace

drop nom_structure

rename nom_structur nom_structure

duplicates drop  nom_structure, force

merge 1:1 nom_structure using "C:\Users\asandie\Desktop\structure_dm\raw_data\EPS\REGISTRE EPS.dta"

drop _merge


merge 1:m parent_key using "C:\Users\asandie\Desktop\structure_dm\Clean_data\eps_rh.dta"

keep if _merge==3

drop _merge

tabulate s4_1_1, gen(s4_1_1_)

save "C:\Users\asandie\Desktop\structure_dm\Clean_data\EPS\eps_data_clean_combined.dta",replace







