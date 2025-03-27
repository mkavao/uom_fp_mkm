*initialize Stata
clear all
set more off
set mem 100m
cd "F:\Dropbox_APHRC\Dropbox\FP-Project-APHRC-UM\Atelier_FP\Data\clean"
use "F:\Dropbox_APHRC\Dropbox\FP-Project-APHRC-UM\Atelier_FP\Data\raw\centre_sante_main_long_raw.dta"

destring _all,replace
compress
ren nom_structure s1_6
ren autre_structure s1_6b

*dropping ineligible EPS
*drop if inlist(s1_6,11,1)
*drop variables which are not useful
drop equipe enqueteur s1_8 s1_9 s1_10 v34 v45


*this informtion is available when merging with the sub-tables
drop s4_1_2_1 s4_1_2_2  personnel_count setofpersonnel

*drop the two health facilities which were not eligible
**

lab def yesno 0 non 1 oui -5 missing -9 na,modify

drop if inlist(s1_6,.,.) //get the code for the two facilities


*renaming variables to conform with the questionaire numbering
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
ren s3_2_55 s3_2e
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
ren s3_3_7  s3_3g //different numbering on qsn
ren s3_3_8  s3_3h
ren s3_3_9  s3_3f
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

ren s3_3_57 s3_3bd
ren s3_3_58 s3_3be

drop v103
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

drop v117 v110
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
drop v147

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
ren s3_5_54 s3_5b_30 // not in part A
ren s3_5_55 s3_5b_31 //
ren s3_5_56 s3_5b_23
ren s3_5_57 s3_5b_24
ren s3_5_58 s3_5b_25
ren s3_5_59 s3_5b_26
ren s3_5_60 s3_5b_27
ren s3_5_61 s3_5b_28
ren s3_5_62 s3_5b_32 // not in A
ren s3_5_63 s3_5b_33 // not in A
ren s3_5_64 s3_5b_29

tab1 s3_5b_? s3_5b_??,m

drop v176 v187 v196 v207

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


foreach var of var s3_16a s3_16b s3_16c	s3_16d s3_16e s3_16f s3_16g	s3_16h s3_16i s3_16j s3_17a	s3_17b s3_17c s3_17d s3_17e	s3_17f s3_17g s3_17h s3_18a	s3_18b s3_18c s3_18d s3_18e s3_18f s3_18g	s3_18h	s3_18i	s3_18j	s3_18k	s3_18l	s3_18m {
	replace `var'=-9 if s3_15==2
}


*servi_smni  - to be renamed properly after consulting with Arsene
*to be checked how the question is frame in the final tool - who was interviewed?
drop servi_smni s_cpn s_acc s_pnat

drop  s4_1_2 s4_1_2_3 s4_1_2_4 s4_1_2_5 s4_1_2_6 s4_1_2_7 s4_1_2_8 s4_1_2_9 s4_1_2_10 s4_1_2_11 
ren s501 s5_1
// ren servi_smni_1 s5_1A
// ren servi_smni_2 s5_1B
// ren servi_smni_3 s5_1C
// ren servi_smni_4 s5_1D
// ren servi_smni_5 s5_1E
// ren servi_smni_6 s5_1F
drop servi_smni*
rename s_cpn_* s5_1A_* 


lab var s5_1A_a "CPN service: Enregistrement"
lab var s5_1A_b "CPN service: Examen physique"
lab var s5_1A_c "CPN service: Prise de poids"
lab var s5_1A_d "CPN service: Mesure de la tension artérielle"
lab var s5_1A_e "CPN service: Examen de l'abdomen"
lab var s5_1A_f "CPN service: Traitement des signes de danger"
lab var s5_1A_g "CPN service: Supplémentation en fer acide folique"
lab var s5_1A_h "CPN service: Réalisation d'un test d'hémoglobines"
lab var s5_1A_i "CPN service: Recherche d'albumine dans les urines"
lab var s5_1A_j "CPN service: Recherche de sucre dans les urines"
lab var s5_1A_k "CPN service: Test de grossesse"
lab var s5_1A_l "CPN service: Vaccination contre le tétanos "
lab var s5_1A_m "CPN service: Groupage sanguin"
lab var s5_1A_n "CPN service: Détermination du facteur Rhésus"
lab var s5_1A_o "CPN service: Test de dépistage de la syphilis effectué"
lab var s5_1A_p "CPN service: Test de dépistage du VIH effectué"
lab var s5_1A_q "CPN service: Prélévement vaginal effectué"
lab var s5_1A_r "CPN service: Déparasitage"
lab var s5_1A_s "CPN service: Prise en charge des complications de la grossesse"
lab var s5_1A_t "CPN service: Prise en charge de l'anémie sévère"
lab var s5_1A_u "CPN service: Conseils en nutrition"
lab var s5_1A_v "CPN service: Conseils de préparation à l'accouchement"
lab var s5_1A_w "Conseils sur l'avortement sécurisé"
lab var s5_1A_x "CPN service: Conseils en PF"
lab var s5_1A_y "CPN service: Conseils sur l'accouchement  en structure sanitaire"

ren s5_2_cpn   s5_2A
ren s5_3_cpn   s5_3A
ren s5_3_cpna  s5_3Aa
ren s5_4_cpn   s5_4A
ren s5_4_cpna  s5_4Aa
ren s5_5_cpn   s5_5A
ren s5_5_cpn_1 s5_5A1
ren s5_5_cpn_2 s5_5A2
ren s5_5_cpn_3 s5_5A3
ren s5_5_cpn_4 s5_5A4
ren s5_5_cpn_5 s5_5A5
ren s5_5_cpn_autre s5_5A5other

lab var s5_5A1 "Raissons CPN: Pas de prestataires formés"
lab var s5_5A2 "Raissons CPN: fournitures non disponibles"
lab var s5_5A3 "Raissons CPN: infrastructure non disponible"
lab var s5_5A4 "Raissons CPN: Le client ne veut pas"
lab var s5_5A5 "Raissons CPN: Autres (précisez)"
drop s5_5A

replace s5_3A=-9 if s5_2A==3
replace s5_3Aa	=-9 if s5_2A==3
replace s5_4A	=-9 if s5_2A==3
replace s5_4Aa=-9 if s5_2A==3


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
rename s_acc_15 s5_1B_p 
*rename s_acc_16 s5_1B_p 

lab var s5_1B_a "D'accouchement service: Accouchement normal"
lab var s5_1B_b "D'accouchement service: Utilisation du partogramme"
lab var s5_1B_c "D'accouchement service: Gestion active de la troisième phase du travail (GATPA)"
lab var s5_1B_d "D'accouchement service: Prise en charge de l'éclampsie"
lab var s5_1B_e "D'accouchement service: Prise en charge de la pré-éclampsie"
lab var s5_1B_f "D'accouchement service: Prise en charge de l'HPP"
lab var s5_1B_g "D'accouchement service: Accouchement assisté (ventouse/forceps)"
lab var s5_1B_h "D'accouchement service: Épisiotomie et suture Déchirure cervicale"
lab var s5_1B_i "D'accouchement service: Antibiotiques IM/IV"
lab var s5_1B_j "D'accouchement service: Furosémide IV"
lab var s5_1B_k "D'accouchement service: Sulfate de magnésium injectable"
lab var s5_1B_l "D'accouchement service: Tocolytiques pour le travail prématuré"
lab var s5_1B_m "D'accouchement service: Stéroïdes pour le travail prématuré"
lab var s5_1B_n "D'accouchement service: Retrait manuel du placenta"
*lab var s5_1B_o "D'accouchement service: Transfusion sanguine"
lab var s5_1B_p "D'accouchement service: Césarienne"

	
ren s5_2_acc   s5_2B
ren s5_3_acc   s5_3B
ren s5_3_acca  s5_3Ba
ren s5_4_acc1   s5_4B
ren s5_4_acc2  s5_4Ba
ren s5_5_acc   s5_5B
ren s5_5_acc_1 s5_5B1
ren s5_5_acc_2 s5_5B2
ren s5_5_acc_3 s5_5B3
ren s5_5_acc_4 s5_5B4
ren s5_5_acc_5 s5_5B5
ren s5_5_acc_autre s5_5B5other

lab var s5_5B1 "Raissons D'accouchement : Pas de prestataires formés"
lab var s5_5B2 "Raissons D'accouchement : fournitures non disponibles"
lab var s5_5B3 "Raissons D'accouchement : infrastructure non disponible"
lab var s5_5B4 "Raissons D'accouchement : Le client ne veut pas"
lab var s5_5B5 "Raissons D'accouchement : Autres (précisez)"
drop s5_5B

replace s5_3B=-9 if s5_2B==3
replace s5_3Ba	=-9 if s5_2B==3
replace s5_4B	=-9 if s5_2B==3
replace s5_4Ba=-9 if s5_2B==3

rename s_pnat_1 s5_1C_a 
rename s_pnat_2 s5_1C_b 
rename s_pnat_3 s5_1C_c 
rename s_pnat_4 s5_1C_d 
rename s_pnat_5 s5_1C_e 

lab var s5_1C_a "Postnatal services: Utilisation systématique d'utérotoniques"
lab var s5_1C_b "Postnatal services: Estimation de la perte de sang"
lab var s5_1C_c "Postnatal services: Massage utérin en cas d'hémorragie grave"
lab var s5_1C_d "Postnatal services: Mise en place immédiate de l'allaitement"
lab var s5_1C_e "Postnatal services: Prise en charge des complications du post-partum précoce"


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

lab var s5_5C1 "Raissons Postnatal: Pas de prestataires formés"
lab var s5_5C2 "Raissons Postnatal: fournitures non disponibles"
lab var s5_5C3 "Raissons Postnatal: infrastructure non disponible"
lab var s5_5C4 "Raissons Postnatal: Le client ne veut pas"
lab var s5_5C5 "Raissons Postnatal: Autres (précisez)"
drop s5_5C

replace s5_3C=-9 if s5_2C==3
replace s5_4C	=-9 if s5_2C==3


rename s_nne_1 s5_1D_a 
rename s_nne_2 s5_1D_b 
rename s_nne_3 s5_1D_c 
rename s_nne_4 s5_1D_d 
rename s_nne_5 s5_1D_e 
rename s_nne_6 s5_1D_f 
rename s_nne_7 s5_1D_g 
rename s_nne_8 s5_1D_h 
rename s_nne_9 s5_1D_i 

lab var s5_1D_a "Essential services: Réanimation néonatale"
lab var s5_1D_b "Essential services: Corticostéroïdes anténatals pour la mère"
lab var s5_1D_c "Essential services: Vitamine K pour les prématurés"
lab var s5_1D_d "Essential services: Pesée du nouveau-né"
lab var s5_1D_e "Essential services: Soins du cordon propre"
lab var s5_1D_f "Essential services: Vaccination au jour zéro (HEB0, BCG et VPO)"
lab var s5_1D_g "Essential services: Emollients / collyres"
lab var s5_1D_h "update tool" //Arsene to update the questionaire and label
lab var s5_1D_i "update too" //Arsene to update the questionaire

* h and i missing in the questionaire

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

lab var s5_5D1 "Raissons Essential: Pas de prestataires formés"
lab var s5_5D2 "Raissons Essential: fournitures non disponibles"
lab var s5_5D3 "Raissons Essential: infrastructure non disponible"
lab var s5_5D4 "Raissons Essential: Le client ne veut pas"
lab var s5_5D5 "Raissons Essential: Autres (précisez)"



 drop s5_5D

replace s5_3D=-9 if s5_2D==3
replace s5_4D	=-9 if s5_2D==3

*rename s_avo_1 s5_1E_a 
rename s_avo_1 s5_1E_b 
rename s_avo_2 s5_1E_c 

*lab var s5_1E_a "Santé de l'enfant services: D & C (dilatation et curetage)"
lab var s5_1E_b "Santé de l'enfant services: MVA (aspiration manuelle sous vide)"
lab var s5_1E_c "Santé de l'enfant services: Prise en charge des complications de l'avortement"

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
lab var s5_5E1 "Raissons Santé de l'enfant services: Pas de prestataires formés"
lab var s5_5E2 "Raissons Santé de l'enfant services: fournitures non disponibles"
lab var s5_5E3 "Raissons Santé de l'enfant services: infrastructure non disponible"
lab var s5_5E4 "Raissons Santé de l'enfant services: Le client ne veut pas"
lab var s5_5E5 "Raissons Santé de l'enfant services: Autres (précisez)"
drop s5_5E

replace s5_3E=-9 if s5_2E==3
replace s5_4E	=-9 if s5_2E==3


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



lab var s5_1F_a "Néonatals services: Utilisation de la fiche de croissance pour l'enregistrement du poids"
lab var s5_1F_b "Néonatals services: Immunisation des enfants"
lab var s5_1F_c "Néonatals services: Prise en charge de la pneumonie"
lab var s5_1F_d "Néonatals services: Antibiotiques pour les infections respiratoires aiguës"
lab var s5_1F_e "Néonatals services: Prise en charge de la déshydratation/diarrhée"
lab var s5_1F_f "Néonatals services: Mesure du poids"
lab var s5_1F_g "Néonatals services: Mesure de la taille"
lab var s5_1F_h "Néonatals services: Prise en charge des nouveau-nés malades"
lab var s5_1F_i "Néonatals services: Prise en charge des nouveau-nés atteints d'un faible poids de naissance"
lab var s5_1F_j "Néonatals services: Prise en charge des nouveau-nés prématurés"
lab var s5_1F_k "Néonatals services: Dépistage des anomalies congénitales"
lab var s5_1F_l "Néonatals services: Alimentation par voie nasogastrique"
lab var s5_1F_m "Néonatals services: Stabilisation du nourrisson malade"
lab var s5_1F_n "Soins en cas d'hyperbilirubinémie"


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

lab var s5_5F1 "Raissons Néonatals services: Pas de prestataires formés"
lab var s5_5F2 "Raissons Néonatals services: fournitures non disponibles"
lab var s5_5F3 "Raissons Néonatals services: infrastructure non disponible"
lab var s5_5F4 "Raissons Néonatals services: Le client ne veut pas"
lab var s5_5F5 "Raissons Néonatals services: Autres (précisez)"
drop s5_5F
*
replace s5_3F=-9 if s5_2F==3
replace s5_4F	=-9 if s5_2F==3


foreach var of var s5_1A_a	s5_1A_b	s5_1A_c	s5_1A_d	s5_1A_e	s5_1A_f	s5_1A_g	s5_1A_h	s5_1A_i	s5_1A_j	s5_1A_k	s5_1A_l	s5_1A_m	s5_1A_n	s5_1A_o	s5_1A_p	s5_1A_q	s5_1A_r	s5_1A_s	s5_1A_t	s5_1A_u	s5_1A_v	s5_1A_w	s5_1A_x	s5_1A_y	s5_2A	s5_3A	s5_3Aa	s5_4A	s5_4Aa	s5_5A1	s5_5A2	s5_5A3	s5_5A4	s5_5A5	s5_1B_a	s5_1B_b	s5_1B_c	s5_1B_d	s5_1B_e	s5_1B_f	s5_1B_g	s5_1B_h	s5_1B_i	s5_1B_j	s5_1B_k	s5_1B_l	s5_1B_m	s5_1B_n	/*s5_1B_o*/	s5_1B_p	s5_2B	s5_3B	s5_3Ba	s5_4B	s5_4Ba	s5_5B1	s5_5B2	s5_5B3	s5_5B4	s5_5B5	s5_1C_a	s5_1C_b	s5_1C_c	s5_1C_d	s5_1C_e	s5_2C	s5_3C	s5_4C	s5_5C1	s5_5C2	s5_5C3	s5_5C4	s5_5C5	s5_1D_a	s5_1D_b	s5_1D_c	s5_1D_d	s5_1D_e	s5_1D_f	s5_1D_g	s5_1D_h	s5_1D_i	s5_2D	s5_3D	s5_4D	s5_5D1	s5_5D2	s5_5D3	s5_5D4	s5_5D5	/*s5_1E_a*/	s5_1E_b	s5_1E_c	s5_2E	s5_3E	s5_4E	s5_5E1	s5_5E2	s5_5E3	s5_5E4	s5_5E5	s5_1F_a	s5_1F_b	s5_1F_c	s5_1F_d	s5_1F_e	s5_1F_f	s5_1F_g	s5_1F_h	s5_1F_i	s5_1F_j	s5_1F_k	s5_1F_l	s5_1F_m	s5_1F_n	s5_2F	s5_3F	s5_4F	s5_5F1	s5_5F2	s5_5F3	s5_5F4	s5_5F5 {
	replace `var'=-9 if s5_1!=1
}

lab val s5_1A_a	s5_1A_b	s5_1A_c	s5_1A_d	s5_1A_e	s5_1A_f	s5_1A_g	s5_1A_h	s5_1A_i	s5_1A_j	s5_1A_k	s5_1A_l	s5_1A_m	s5_1A_n	s5_1A_o	s5_1A_p	s5_1A_q	s5_1A_r	s5_1A_s	s5_1A_t	s5_1A_u	s5_1A_v	s5_1A_w	s5_1A_x	s5_1A_y s5_5?1	s5_5?2	s5_5?3	s5_5?4	s5_5?5 s5_1B_a	s5_1B_b	s5_1B_c	s5_1B_d	s5_1B_e	s5_1B_f	s5_1B_g	s5_1B_h	s5_1B_i	s5_1B_j	s5_1B_k	s5_1B_l	s5_1B_m	s5_1B_n	/*s5_1B_o*/	s5_1B_p s5_1C_a	s5_1C_b	s5_1C_c	s5_1C_d	s5_1C_e s5_1D_a	s5_1D_b	s5_1D_c	s5_1D_d	s5_1D_e	s5_1D_f	s5_1D_g	s5_1D_h	s5_1D_i /*s5_1E_a*/	s5_1E_b	s5_1E_c s5_1F_a	s5_1F_b	s5_1F_c	s5_1F_d	s5_1F_e	s5_1F_f	s5_1F_g	s5_1F_h	s5_1F_i	s5_1F_j	s5_1F_k	s5_1F_l	s5_1F_m	s5_1F_n yesno


rename (s5_7c s5_8c s5_9c s5_10c s5_10c_1 s5_10c_2 s5_10c_3 s5_10c_4 s5_10c_5 s5_10_autrec) (s5_7d s5_8d s5_9d s5_10d s5_10d_1 s5_10d_2 s5_10d_3 s5_10d_4 s5_10d_5 s5_10_autred)
rename (s5_7b s5_8b s5_9b s5_10b s5_10b_1 s5_10b_2 s5_10b_3 s5_10b_4 s5_10b_5 s5_10_autreb) (s5_7c s5_8c s5_9c s5_10c s5_10c_1 s5_10c_2 s5_10c_3 s5_10c_4 s5_10c_5 s5_10_autrec)
rename (s5_7a s5_8a s5_9a s5_10a s5_10a_1 s5_10a_2 s5_10a_3 s5_10a_4 s5_10a_5 s5_10_autrea) (s5_7b s5_8b s5_9b s5_10b s5_10b_1 s5_10b_2 s5_10b_3 s5_10b_4 s5_10b_5 s5_10_autreb)
rename (s5_7 s5_8 s5_9 s5_10 s5_10_1 s5_10_2 s5_10_3 s5_10_4 s5_10_5 s5_10_autre)           (s5_7a s5_8a s5_9a s5_10a s5_10a_1 s5_10a_2 s5_10a_3 s5_10a_4 s5_10a_5 s5_10_autrea)

rename (s5_7j s5_8j s5_9j s5_10j s5_10j_1 s5_10j_2 s5_10j_3 s5_10j_4 s5_10j_5 s5_10_autrej) (s5_7i s5_8i s5_9i s5_10i s5_10i_1 s5_10i_2 s5_10i_3 s5_10i_4 s5_10i_5 s5_10_autrei)

rename (s5_7k s5_8k s5_9k s5_10k s5_10k_1 s5_10k_2 s5_10k_3 s5_10k_4 s5_10k_5 s5_10_autrek) (s5_7j s5_8j s5_9j s5_10j s5_10j_1 s5_10j_2 s5_10j_3 s5_10j_4 s5_10j_5 s5_10_autrej)
rename (s5_7l s5_8l s5_9l s5_10l s5_10l_1 s5_10l_2 s5_10l_3 s5_10l_4 s5_10l_5 s5_10_autrel) (s5_7k s5_8k s5_9k s5_10k s5_10k_1 s5_10k_2 s5_10k_3 s5_10k_4 s5_10k_5 s5_10_autrek)

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
*ren s5_13_12 s5_13l
*ren s5_13_13 s5_13m
*ren s5_13_14 s5_13n
*ren s5_13_15 s5_13o
*ren s5_13_16 s5_13p
*ren s5_13_17 s5_13q
*ren s5_13_18 s5_13r
*ren s5_13_19 s5_13s
*ren s5_13_20 s5_13t

drop v487

foreach var of var s5_12 s5_13* {
	replace `var' = -9 if s5_11==2
}



*600
drop s6_2 v505
ren s6_2_1 s6_2a
ren s6_2_2 s6_2b
ren s6_2_3 s6_2c
ren s6_2_4 s6_2d
			

ren v504 s6_2d_aut


foreach var of var  s6_2a s6_2b s6_2c s6_2d {
	replace `var' = -9 if inlist(s5_7f,5,-9)
	replace `var' = -5 if (!inlist(s5_7f,5,-9))&`var'==.
}


lab val s6_2a s6_2b s6_2c s6_2d yesno
			
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

foreach var of var s6_3trav_? {
	replace `var' = -9 if s6_2a==0
}

drop v520 v535 v550

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

foreach var of var s6_3coin_? {
	replace `var' = -9 if s6_2b==0
}

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

foreach var of var s6_3both_? {
	replace `var' = -9 if s6_2c==0
}

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

foreach var of var s6_3other_? {
	replace `var' = -9 if s6_2d==0
}

ren s6_4_11 s6_4a1
ren s6_4_12 s6_4b1
ren s6_4_21 s6_4a2
ren s6_4_22 s6_4b2

*not in the questionaire
ren s6_4_21a s6_4a2other // check the correct naming
ren s6_4_22a s6_4b2other

* s6_5 s6_6 missing on the database
* s6_7 and s6_8 contains information on s6_16 and s6_17

* s6_7 and s6_8 609 610 repeated in the questionaire, the later s6_7 and s6_8 should be s6_16 and s6_17 respectively - renamed

rename (s6_7 s6_8 s6_7a s6_8a s6_7b s6_8b s6_7c s6_8c s6_7d s6_8d s6_7e s6_8e s6_7f s6_8f s6_7g s6_8g s6_7h s6_8h s6_7i s6_8i s6_7j s6_8j ) (s6_16a s6_17a s6_16b s6_17b s6_16c s6_17c s6_16d s6_17d s6_16e s6_17e s6_16f s6_17f s6_16g s6_17g s6_16h s6_17h s6_16i s6_17i s6_16j s6_17j s6_16k s6_17k)


/*ren s6_8_1 s6_8a
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
ren s6_8_26 s6_8z*/

/*ren s6_11_1 s6_11a
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
ren s6_11_21 s6_11u*/


/*ren s6_14_1 s6_14a
ren s6_14_2 s6_14b
ren s6_14_3 s6_14c
ren s6_14_4 s6_14d
ren s6_14_5 s6_14e
ren s6_14_6 s6_14f
ren s6_14_7 s6_14g
ren s6_14_8 s6_14h
ren s6_14_9 s6_14i*/

drop s6_19 s6_19?

rename (s6_18j s6_19j_1 s6_19j_2 s6_19j_3 s6_19j_4 s6_19j_5 s6_20j) (s6_18k s6_19k_1 s6_19k_2 s6_19k_3 s6_19k_4 s6_19k_5 s6_19k_5_autr)
rename (s6_18i s6_19i_1 s6_19i_2 s6_19i_3 s6_19i_4 s6_19i_5 s6_20i) (s6_18j s6_19j_1 s6_19j_2 s6_19j_3 s6_19j_4 s6_19j_5 s6_19j_5_autr)
rename (s6_18h s6_19h_1 s6_19h_2 s6_19h_3 s6_19h_4 s6_19h_5 s6_20h) (s6_18i s6_19i_1 s6_19i_2 s6_19i_3 s6_19i_4 s6_19i_5 s6_19i_5_autr)
rename (s6_18g s6_19g_1 s6_19g_2 s6_19g_3 s6_19g_4 s6_19g_5 s6_20g) (s6_18h s6_19h_1 s6_19h_2 s6_19h_3 s6_19h_4 s6_19h_5 s6_19h_5_autr)
rename (s6_18f s6_19f_1 s6_19f_2 s6_19f_3 s6_19f_4 s6_19f_5 s6_20f) (s6_18g s6_19g_1 s6_19g_2 s6_19g_3 s6_19g_4 s6_19g_5 s6_19g_5_autr)
rename (s6_18e s6_19e_1 s6_19e_2 s6_19e_3 s6_19e_4 s6_19e_5 s6_20e) (s6_18f s6_19f_1 s6_19f_2 s6_19f_3 s6_19f_4 s6_19f_5 s6_19f_5_autr)
rename (s6_18d s6_19d_1 s6_19d_2 s6_19d_3 s6_19d_4 s6_19d_5 s6_20d) (s6_18e s6_19e_1 s6_19e_2 s6_19e_3 s6_19e_4 s6_19e_5 s6_19e_5_autr)
rename (s6_18c s6_19c_1 s6_19c_2 s6_19c_3 s6_19c_4 s6_19c_5 s6_20c) (s6_18d s6_19d_1 s6_19d_2 s6_19d_3 s6_19d_4 s6_19d_5 s6_19d_5_autr)
rename (s6_18b s6_19b_1 s6_19b_2 s6_19b_3 s6_19b_4 s6_19b_5 s6_20b) (s6_18c s6_19c_1 s6_19c_2 s6_19c_3 s6_19c_4 s6_19c_5 s6_19c_5_autr)
rename (s6_18a s6_19a_1 s6_19a_2 s6_19a_3 s6_19a_4 s6_19a_5 s6_20a) (s6_18b s6_19b_1 s6_19b_2 s6_19b_3 s6_19b_4 s6_19b_5 s6_19b_5_autr)
rename (s6_18 s6_19_1 s6_19_2 s6_19_3 s6_19_4 s6_19_5 s6_20)        (s6_18a s6_19a_1 s6_19a_2 s6_19a_3 s6_19a_4 s6_19a_5 s6_19a_5_autr)

drop v682


local alphabet "a b c d e f g h i j k l m n o p q r s t u v w x y z "
local alphabet " `alphabet' aa ab ac ad ae af ag ah ai aj ak al am an ao ap aq ar as at au av aw ax ay az "
local alphabet " `alphabet' ba bb bc bd be bf bg bh bi bj bk bl bm bn bo bp bq br bs bt bu bv bw bx by bz "
local alphabet " `alphabet' ca cb cc cd ce cf cg ch ci cj ck cl cm cn co cp"

* Loop through and rename variables from var1 to var100
forval i = 1/94 {
    local newname : word `i' of `alphabet'
    rename s6_20_`i' s6_20`newname'
}

drop v782 v793

local alphabet "a b c d e f g h i j "

* Loop through and rename variables from var1 to var100
forval i = 1/10 {
    local newname : word `i' of `alphabet'
    rename s7_6_`i' s7_6`newname'
}

ren s7_7_1 s7_7a
ren s7_7_2 s7_7b
ren s7_7_3 s7_7c
ren s7_7_4 s7_7d
ren s7_7_5 s7_7e


ren s7_8_1 s7_8a
ren s7_8_2 s7_8b
*ren s7_8_3 s7_8c
*ren s7_8_4 s7_8d
ren s7_8_5 s7_8e
ren s7_8_6 s7_8f
ren s7_8_7 s7_8g
*ren s7_8_8 s7_8h
*ren s7_8_9 s7_8i

drop v799


*changing the string variables to all upper case
replace s1_4=upper(s1_4) 


*replace s1_7 with EPS for appending later with other files
replace s1_7=2 if s1_7==.

lab def structure 1 EPS 2 CS,modify
lab val s1_7 structure

*SECTION 8 MISSING FROM THE DATABASE

****************************************
*LABEL ALL THE VARIABLES APPROPRIATELY

*s5_1A s5_1B s5_1C s5_1D s5_1E s5_1F s5_1A_a s5_1A_b s5_1A_c s5_1A_d s5_1A_e s5_1A_f s5_1A_g s5_1A_h s5_1A_i s5_1A_j s5_1A_k s5_1A_l s5_1A_m s5_1A_n s5_1A_o s5_1A_p s5_1A_q s5_1A_r s5_1A_s s5_1A_t s5_1A_u s5_1A_v s5_1A_w s5_1A_x s5_1A_y s5_5A1 s5_5A2 s5_5A3 s5_5A4 s5_5A5 s5_1B_a s5_1B_b s5_1B_c s5_1B_d s5_1B_e s5_1B_f s5_1B_g s5_1B_h s5_1B_i s5_1B_j s5_1B_k s5_1B_l s5_1B_m s5_1B_n s5_1B_o s5_1B_p s5_5B1 s5_5B2 s5_5B3 s5_5B4 s5_5B5 s5_1C_a s5_1C_b s5_1C_c s5_1C_d s5_1C_e s5_5C1 s5_5C2 s5_5C3 s5_5C4 s5_5C5 s5_1D_a s5_1D_b s5_1D_c s5_1D_d s5_1D_e s5_1D_f s5_1D_g s5_1D_h s50_1D_i s5_5D1 s5_5D2 s5_5D3 s5_5D4 s5_5D5 s5_1E_a s5_1E_b s5_1E_c s5_5E1 s5_5E2 s5_5E3 s5_5E4 s5_5E5 s5_5E5other s5_1F_a s5_1F_b s5_1F_c s5_1F_d s5_1F_e s5_1F_f s5_1F_g s5_1F_h s5_1F_i s5_1F_j s5_1F_k s5_1F_l s5_1F_m s5_1F_n s5_5F1 s5_5F2 s5_5F3 s5_5F4 s5_5F5 s5_10a_1 s5_10a_2 s5_10a_3 s5_10a_4 s5_10a_5 s5_10b_1 s5_10b_2 s5_10b_3 s5_10b_4 s5_10b_5 s5_10c_1 s5_10c_2 s5_10c_3 s5_10c_4 s5_10c_5 s5_10d_1 s5_10d_2 s5_10d_3 s5_10d_4 s5_10d_5 s5_10e_1 s5_10e_2 s5_10e_3 s5_10e_4 s5_10e_5 s5_10f_1 s5_10f_2 s5_10f_3 s5_10f_4 s5_10f_5 s5_10g_1 s5_10g_2 s5_10g_3 s5_10g_4 s5_10g_5 s5_10h_1 s5_10h_2 s5_10h_3 s5_10h_4 s5_10h_5 s5_10i_1 s5_10i_2 s5_10i_3 s5_10i_4 s5_10i_5 s5_10j_1 s5_10j_2 s5_10j_3 s5_10j_4 s5_10j_5 s5_10k_1 s5_10k_2 s5_10k_3 s5_10k_4 s5_10k_5 s6_2_2 s6_2_3 s6_2_4 s6_2_4autre s6_19a_1 s6_19a_2 s6_19a_3 s6_19a_4 s6_19a_5 s6_19b_1 s6_19b_2 s6_19b_3 s6_19b_4 s6_19b_5 s6_19c_1 s6_19c_2 s6_19c_3 s6_19c_4 s6_19c_5 s6_19d_1 s6_19d_2 s6_19d_3 s6_19d_4 s6_19d_5 s6_19e_1 s6_19e_2 s6_19e_3 s6_19e_4 s6_19e_5 s6_19f_1 s6_19f_2 s6_19f_3 s6_19f_4 s6_19f_5 s6_19g_1 s6_19g_2 s6_19g_3 s6_19g_4 s6_19g_5 s6_19h_1 s6_19h_2 s6_19h_3 s6_19h_4 s6_19h_5 s6_19i_1 s6_19i_2 s6_19i_3 s6_19i_4 s6_19i_5 s6_19j_1 s6_19j_2 s6_19j_3 s6_19j_4 s6_19j_5 s6_19k_1 s6_19k_2 s6_19k_3 s6_19k_4 s6_19k_5

****************************************
drop today end start submissiondate formdef_version obs
order key gpslatitude gpslongitude gpsaltitude gpsaccuracy
ren key id

sort id
save "F:\Dropbox_APHRC\Dropbox\FP-Project-APHRC-UM\Atelier_FP\Data\clean\cs_data_long_clean.dta",replace


merge 1:m id using "F:\Dropbox_APHRC\Dropbox\FP-Project-APHRC-UM\Atelier_FP\Data\clean\cs_hr_all"

save "F:\Dropbox_APHRC\Dropbox\FP-Project-APHRC-UM\Atelier_FP\Data\clean\cs_data_long_clean_merged.dta",replace

