* Évaluation de base de la planification familiale au Sénégal 
* 	Questionnaire pour l'entretien avec les infirmiers et sages-femmes.
*	Outputs: SUIVI DES INDICATEURS

* initialize Stata

clear all
clear matrix
set linesize 220
set maxvar 32767
set more off


* Définir le répertoire de travail
*cd "C:\Users\rndachi\Desktop\Indicateurs prestataires"
cd "F:\Dropbox_APHRC\Dropbox\FP-Project-APHRC-UM\Atelier_FP\Codes"

* Charger les données
use "F:\Dropbox_APHRC\Dropbox\FP-Project-APHRC-UM\Atelier_FP\Data\Donnees_ucad\BDD ISF_13janvier2024", clear


****Connaissance des contraceptifs****
recode S2_23_1  (1=1 Oui)(2 .=0 Non), gen(DIU)
recode S2_23_2  (1=1 Oui)(2 .=0 Non), gen(Injectables)
recode S2_23_3  (1=1 Oui)(2 .=0 Non), gen(Preservatif_M)
recode S2_23_4  (1=1 Oui)(2 .=0 Non), gen(Preservatif_F)
recode S2_23_5  (1=1 Oui)(2 .=0 Non), gen(Contraception_Urg)
recode S2_23_6  (1=1 Oui)(2 .=0 Non), gen(Pilules)
recode S2_23_7  (1=1 Oui)(2 .=0 Non), gen(Implants)
recode S2_23_8  (1=1 Oui)(2 .=0 Non), gen(Sterilisation_F)
recode S2_23_9  (1=1 Oui)(2 .=0 Non), gen(Sterilisation_M)
recode S2_23_10 (1=1 Oui)(2 .=0 Non), gen(Allaitement_Exclu)

lab var DIU "Awareness of the IUD"
lab var Injectables "Awareness of Injectables"
lab var Preservatif_M "Awareness of the male condom"
lab var Preservatif_F "Awareness of the female condom"
lab var Contraception_Urg "Awareness of Emergency Contraception"
lab var Pilules "Awareness of Pills"
lab var Implants "Awareness of Implants"
lab var Sterilisation_F "Awareness of female sterilization"
lab var Sterilisation_M "Awareness of male sterilization"
lab var Allaitement_Exclu "Awareness of Exclusive breastfeeding"

* LES INDICATEURS PLANIFICATION FAMILIALE */

*******INDICATEUR 1. Pourcentage de prestataires ayant une connaissance correcte
*******de chaque méthode de PF qu'ils fournissent actuellement

				*************
				***  DIU  ***

 foreach var of var S3_11_1 S3_11_2 S3_11_3 S3_11_4 S3_11_5 S3_11_6 S3_11_7 S3_11_8 S3_11_10 S3_11_11 S3_11_12 S3_11_13 S3_11_14 S3_11_15 S3_11_16 S3_11_17 {
 gen Know`var'DIU = `var'
 }

 foreach var of var S3_16_2 S3_16_3 S3_16_5 S3_16_6 S3_16_7 S3_16_9 S3_16_11 S3_16_12 S3_16_13 S3_16_15 S3_16_16 S3_16_17 S3_16_18 S3_16_19 S3_16_20 {
 gen Know`var'DIU =1 if `var'==1
 replace Know`var'DIU =0 if `var'==2 | `var'==3
}

 foreach var of var S3_16_1 S3_16_4 S3_16_8 S3_16_10 S3_16_14 {
 gen Know`var'DIU =0 if `var'==1 | `var'==3
 replace Know`var'DIU =1 if `var'==2
 }

 *Construction de la variable connaissance correcte de la méthode DIU
*Elle consiste à respecter au moins 80%, 70% ou 60% des 36 questions liées au DIU
egen 		Score_con_DIU 	=  rsum(*DIU)
local total_connaissance_DIU = 36  // Nombre total de questions utilisées
gen 		DIU_correct80 = (Score_con_DIU >= `=round(0.80 * `total_connaissance_DIU')')
replace 	DIU_correct80 =. if Score_con_DIU==0 | S2_22_1 !=1
label var	DIU_correct80 "Correct knowledge of DIU method at 80%"

gen 		DIU_correct70 = (Score_con_DIU >= `=round(0.70 * `total_connaissance_DIU')')
replace 	DIU_correct70 =. if Score_con_DIU==0 | S2_22_1 !=1
label var 	DIU_correct70 "Correct knowledge of DIU method at 70%"

gen 		DIU_correct60 = (Score_con_DIU >= `=round(0.60 * `total_connaissance_DIU')')
replace 	DIU_correct60 =. if Score_con_DIU==0 | S2_22_1 !=1
label var 	DIU_correct60 "Correct knowledge of DIU method at 60%"

sum Score_con_DIU		
gen Score_con_DIU_N=((Score_con_DIU-r(min))/(r(max)-r(min)))*10
label var Score_con_DIU_N "Score de la connaissance correcte du DIU"

***  INJECTABLE  ***			
foreach var of var S3_28_1  S3_28_3 S3_28_4 S3_28_7 S3_28_8 S3_28_9 S3_28_11 S3_28_13 S3_28_16 S3_28_17 S3_28_18 S3_28_19 S3_28_20 S3_28_21 {
 gen Know`var'INJECTABLE =1 if `var'==1
 replace Know`var'INJECTABLE =0 if `var'==2 | `var'==3
}

 foreach var of var S3_28_2 S3_28_5 S3_28_6 S3_28_10 S3_28_12 S3_28_14 S3_28_15 {
 gen Know`var'INJECTABLE =0 if `var'==1 | `var'==3
 replace Know`var'INJECTABLE =1 if `var'==2
 }

*Construction de la variable connaissance correcte de la méthode INJECTABLE
*Elle consiste à respecter au moins 80%, 70% ou 60% des 21 questions liées
*aux INJECTABLES

egen 		Score_con_INJECTABLE 	=  rsum(*INJECTABLE)
local total_connaissance_INJECTABLE = 21  // Nombre total de questions utilisées
gen 		INJECTABLE_correct80 = (Score_con_INJECTABLE >= `=round(0.80 * `total_connaissance_INJECTABLE')')
replace 	INJECTABLE_correct80 =. if Score_con_INJECTABLE==0 | S2_22_2 !=1
label var 	INJECTABLE_correct80 "Correct knowledge of INJECTABLE method at 80%"

gen 		INJECTABLE_correct70 = (Score_con_INJECTABLE >= `=round(0.70 * `total_connaissance_INJECTABLE')')
replace 	INJECTABLE_correct70 =. if Score_con_INJECTABLE==0 | S2_22_2 !=1
label var 	INJECTABLE_correct70 "Correct knowledge of INJECTABLE method at 70%"

gen 		INJECTABLE_correct60 = (Score_con_INJECTABLE >= `=round(0.60 * `total_connaissance_INJECTABLE')')
replace 	INJECTABLE_correct60 =. if Score_con_INJECTABLE==0 | S2_22_2 !=1
label var 	INJECTABLE_correct60 "Correct knowledge of INJECTABLE method at 60%"				
	
sum Score_con_INJECTABLE
gen Score_con_INJECTABLE_N=((Score_con_INJECTABLE-r(min))/(r(max)-r(min)))*10
label var Score_con_INJECTABLE_N "Score de la connaissance correcte de l'injectable"
	
				******************
				***  IMPLANTS  ***
				
 foreach var of var S3_39_1 S3_39_2 S3_39_3 S3_39_4 S3_39_5 S3_39_6 S3_39_7 {
 gen Know`var'IMPLANTS = `var'
}
				
foreach var of var S3_41_1 S3_41_2 S3_41_4 S3_41_5 S3_41_8 S3_41_9 S3_41_11 S3_41_12 S3_41_13 S3_41_14 S3_41_15 S3_41_16 S3_41_17 {
 gen Know`var'IMPLANTS =1 if `var'==1
 replace Know`var'IMPLANTS =0 if `var'==2 | `var'==3
}

 foreach var of var S3_41_3 S3_41_6 S3_41_7 S3_41_10 S3_41_18 {
 gen Know`var'IMPLANTS =0 if `var'==1 | `var'==3
 replace Know`var'IMPLANTS =1 if `var'==2
}

		*Construction de la variable connaissance correcte de la méthode IMPLANTS
		*Elle consiste à respecter au moins 80%, 70% ou 60% des 36 questions liées
		*aux IMPLANTS
egen 		Score_con_IMPLANTS 	=  rsum(*IMPLANTS)
local total_connaissance_IMPLANTS = 25  // Nombre total de questions utilisées
gen 		IMPLANTS_correct80 = (Score_con_IMPLANTS >= `=round(0.80 * `total_connaissance_IMPLANTS')')
replace 	IMPLANTS_correct80 =. if Score_con_IMPLANTS==0 | S2_22_7 !=1
label var 	IMPLANTS_correct80 "Correct knowledge of IMPLANTS method at 80"

gen 		IMPLANTS_correct70 = (Score_con_IMPLANTS >= `=round(0.70 * `total_connaissance_IMPLANTS')')
replace 	IMPLANTS_correct70 =. if Score_con_IMPLANTS==0 | S2_22_7 !=1
label var 	IMPLANTS_correct70 "Correct knowledge of IMPLANTS method at 70"

gen 		IMPLANTS_correct60 = (Score_con_IMPLANTS >= `=round(0.60 * `total_connaissance_IMPLANTS')')
replace 	IMPLANTS_correct60 =. if Score_con_IMPLANTS==0 | S2_22_7 !=1
label var 	IMPLANTS_correct60 "Correct knowledge of IMPLANTS method at 60"

sum Score_con_IMPLANTS
gen Score_con_IMPLANTS_N=((Score_con_IMPLANTS-r(min))/(r(max)-r(min)))*10
label var Score_con_IMPLANTS_N "Score de la connaissance correcte de l'implant"
		
		
				********************************
				***  STERILISATION FEMININE  ***
				********************************
 foreach var of var S3_47_1 S3_47_2 S3_47_3 S3_47_4 S3_47_5 S3_47_6 S3_47_7 S3_47_8 S3_47_10 S3_47_11 S3_47_12 S3_47_13 S3_47_14 S3_47_15 S3_47_16 S3_47_17 S3_47_18 S3_47_19 S3_48_1 S3_48_2 S3_48_3 S3_48_4 S3_48_5 S3_48_6 S3_48_7 S3_48_8 S3_48_10 S3_48_11 S3_48_12 S3_48_13 S3_48_14 S3_50_1 S3_50_2 S3_50_3 S3_50_4 S3_50_5 S3_50_6 S3_50_7 S3_50_8 S3_50_10 S3_50_11 S3_50_12 S3_50_13 S3_50_14 S3_50_15 S3_50_16 S3_50_17 S3_50_18 S3_50_19 S3_50_20 S3_50_21 S3_50_22 S3_50_23 {
 gen Know`var'STERILFEM = `var'
}
				
foreach var of var S3_58_1 S3_58_3 S3_58_4 S3_58_5 S3_58_6 S3_58_9 S3_58_11 S3_58_12 S3_58_13 S3_58_15 S3_58_16 S3_58_17 S3_58_18 {

 gen Know`var'STERILFEM =1 if `var'==1
 replace Know`var'STERILFEM =0 if `var'==2 | `var'==3
 
}


 foreach var of var S3_58_2 S3_58_7 S3_58_8 S3_58_10 S3_58_14 {

 gen Know`var'STERILFEM =0 if `var'==1 | `var'==3
 replace Know`var'STERILFEM =1 if `var'==2
 
}
				
				
				
		*Construction de la variable connaissance correcte de la méthode de
		*STERILISATION FEMININE. Elle consiste à respecter au moins 80%, 70% 
		*ou 60% des 36 questions liées à la STERILISATION FEMININE

		
egen 		Score_con_STERILFEM 	=  rsum(*STERILFEM)
local total_connaissance_STERILFEM = 71  // Nombre total de questions utilisées
gen 		STERILFEM_correct80 = (Score_con_STERILFEM >= `=round(0.80 * `total_connaissance_STERILFEM')')
replace 	STERILFEM_correct80 =. if Score_con_STERILFEM==0 | S2_22_8 !=1
label var 	STERILFEM_correct80 "Correct knowledge of STERILISATION FEMININE method at 80%"

gen 		STERILFEM_correct70 = (Score_con_STERILFEM >= `=round(0.70 * `total_connaissance_STERILFEM')')
replace 	STERILFEM_correct70 =. if Score_con_STERILFEM==0 | S2_22_8 !=1
label var 	STERILFEM_correct70 "Correct knowledge of STERILISATION FEMININE method at 70%"

gen 		STERILFEM_correct60 = (Score_con_STERILFEM >= `=round(0.60 * `total_connaissance_STERILFEM')')
replace 	STERILFEM_correct60 =. if Score_con_STERILFEM==0 | S2_22_8 !=1
label var 	STERILFEM_correct60 "Correct knowledge of STERILISATION FEMININE method at 60%"

sum Score_con_STERILFEM
gen Score_con_STERILFEM_N=((Score_con_STERILFEM-r(min))/(r(max)-r(min)))*10		
label var Score_con_STERILFEM_N "Score de la connaissance correcte de la Sterilisation feminine"


		
				*********************************
				***  STERILISATION MASCULINE  ***
				*********************************



				
 foreach var of var S3_64_1 S3_64_2 S3_64_3 S3_64_4 S3_64_5 S3_64_6 S3_64_7 S3_64_8 S3_64_10 S3_64_11 S3_64_12 S3_64_13 S3_64_14 S3_64_15 S3_64_16 {

 gen Know`var'STERILMAS = `var'
 
}

				
foreach var of var S3_74_2 S3_74_3 S3_74_7 {

 gen Know`var'STERILMAS =1 if `var'==1
 replace Know`var'STERILMAS =0 if `var'==2 | `var'==3
 
}


 foreach var of var S3_74_1 S3_74_4 S3_74_5 S3_74_6 S3_74_8 {

 gen Know`var'STERILMAS =0 if `var'==1 | `var'==3
 replace Know`var'STERILMAS =1 if `var'==2
 
}
				
				
				
		*Construction de la variable connaissance correcte de la méthode de
		*STERILISATION FEMININE. Elle consiste à respecter au moins 80%, 70% 
		*ou 60% des 23 questions liées à la STERILISATION MASCULINE

		
egen 		Score_con_STERILMAS	=  rsum(*STERILMAS)
local total_connaissance_STERILMAS = 23  // Nombre total de questions utilisées
gen 		STERILMAS_correct80 = (Score_con_STERILMAS >= `=round(0.80 * `total_connaissance_STERILMAS')')
replace 	STERILMAS_correct80 =. if Score_con_STERILMAS==0 | S2_22_9 !=1
label var 	STERILMAS_correct80 "Correct knowledge of STERILISATION MASCULINE method at 80%"

gen 		STERILMAS_correct70 = (Score_con_STERILMAS >= `=round(0.70 * `total_connaissance_STERILMAS')')
replace 	STERILMAS_correct70 =. if Score_con_STERILMAS==0 | S2_22_9 !=1
label var 	STERILMAS_correct70 "Correct knowledge of STERILISATION MASCULINE method at 70%"				
				
gen 		STERILMAS_correct60 = (Score_con_STERILMAS >= `=round(0.60 * `total_connaissance_STERILMAS')')
replace 	STERILMAS_correct60 =. if Score_con_STERILMAS==0 | S2_22_9 !=1
label var 	STERILMAS_correct60 "Correct knowledge of STERILISATION MASCULINE method at 60%"

sum Score_con_STERILMAS
gen Score_con_STERILMAS_N=((Score_con_STERILMAS-r(min))/(r(max)-r(min)))*10		
label var Score_con_STERILMAS_N "Score de la connaissance correcte de la Sterilisation masculine"

*******INDICATEUR 2.	Pourcentage de prestataires ayant déclaré des pratiques 
*******correctes de pré-procédures pour chaque méthode de PF qu'ils fournissent
*******actuellement
				
				*************
				***  DIU  ***
				
 foreach var of var S3_2_1 S3_2_2 S3_2_3 S3_2_4 S3_2_5 S3_2_6 S3_2_7 S3_2_8 S3_3_1 S3_3_2 S3_3_3 S3_3_4 S3_3_5 S3_3_6 S3_3_7 S3_4_1 S3_4_2 S3_4_3 S3_4_4 S3_4_5 S3_4_6 S3_4_7 S3_6_1 S3_6_2 S3_6_3 S3_7_1 S3_7_2 S3_7_3 S3_7_4 S3_7_5 S3_7_6 S3_7_7 S3_7_8 S3_7_10 S3_7_11 S3_7_12 S3_7_13 S3_7_14 S3_8_1 S3_8_2 S3_8_3 S3_8_4 S3_8_5 S3_8_6 S3_8_7 S3_8_8 S3_8_10 S3_8_11 S3_8_12 S3_9_1 S3_9_2 S3_9_3 S3_10_1 S3_10_2 S3_10_3 {

 gen Do`var'DIU_pre = `var'
 
}

			
				
		*Construction de la variable pratique correcte preprocédure de la DIU.
		*Elle consiste à respecter au moins 80%, 70% ou 60% des 55 questions liées
		*à la pratique de la DIU

		
egen 		Score_pra_DIU_pre	=  rsum(*DIU_pre)
local total_pratique_DIU_pre = 55  // Nombre total de questions utilisées
gen 		DIU_pre_correct80 = (Score_pra_DIU_pre >= `=round(0.80 * `total_pratique_DIU_pre')')
replace 	DIU_pre_correct80 =. if Score_pra_DIU_pre==0 | S2_22_1 !=1
label var 	DIU_pre_correct80 "Correct pre-procedure practice for the DIU at 80%"

gen 		DIU_pre_correct70 = (Score_pra_DIU_pre >= `=round(0.70 * `total_pratique_DIU_pre')')
replace 	DIU_pre_correct70 =. if Score_pra_DIU_pre==0 | S2_22_1 !=1
label var 	DIU_pre_correct70 "Correct pre-procedure practice for the DIU at 70%"

gen 		DIU_pre_correct60 = (Score_pra_DIU_pre >= `=round(0.60 * `total_pratique_DIU_pre')')
replace 	DIU_pre_correct60 =. if Score_pra_DIU_pre==0 | S2_22_1 !=1
label var 	DIU_pre_correct60 "Correct pre-procedure practice for the DIU at 60%"
						
sum Score_pra_DIU_pre
gen Score_pra_DIU_pre_N=((Score_pra_DIU_pre-r(min))/(r(max)-r(min)))*10		
label var Score_pra_DIU_pre_N "Score de la pratique correcte preprocedure du DIU"
						
				
				********************
				***  INJECTABLE  ***
				********************		
				


				
 foreach var of var S3_18_1 S3_18_2 S3_18_3 S3_18_4 S3_18_5 S3_18_6 S3_18_7 S3_18_8 S3_19_1 S3_19_2 S3_19_3 S3_19_4 S3_19_5 S3_19_6 S3_19_7 S3_21_1 S3_21_2 S3_21_3 S3_22_1 S3_22_2 S3_22_3 S3_22_4 S3_22_5 S3_22_6 S3_22_7 S3_22_8 S3_22_10 S3_22_11 S3_23_1 S3_23_2 S3_23_3 S3_23_4 S3_23_5 S3_23_6 S3_23_7 S3_23_8 S3_23_10 S3_23_11 S3_23_12 S3_23_13 S3_23_14 S3_23_15 S3_24_1 S3_24_2 S3_25_1 S3_25_2 S3_25_3 S3_25_4 S3_25_5 S3_25_6 S3_25_7 S3_25_8 S3_25_10 S3_25_11 {

 gen Do`var'INJECT_pre = `var'
 
}

			
				
		*Construction de la variable pratique correcte preprocédure de la INJECTABLE.
		*Elle consiste à respecter au moins 80%, 70% ou 60% des 54 questions liées à la
		*pratique de la INJECTABLE

		
egen 		Score_pra_INJECT_pre	=  rsum(*INJECT_pre)
local total_pratique_INJECT_pre = 54  // Nombre total de questions utilisées
gen 		INJECT_pre_correct80 = (Score_pra_INJECT_pre >= `=round(0.80 * `total_pratique_INJECT_pre')')
replace 	INJECT_pre_correct80 =. if Score_pra_INJECT_pre==0 | S2_22_2 !=1
label var 	INJECT_pre_correct80 "Correct pre-procedure practice for the INJECTABLE at 80%"

gen 		INJECT_pre_correct70 = (Score_pra_INJECT_pre >= `=round(0.70 * `total_pratique_INJECT_pre')')
replace 	INJECT_pre_correct70 =. if Score_pra_INJECT_pre==0 | S2_22_2 !=1
label var 	INJECT_pre_correct70 "Correct pre-procedure practice for the INJECTABLE at 70%"

gen 		INJECT_pre_correct60 = (Score_pra_INJECT_pre >= `=round(0.60 * `total_pratique_INJECT_pre')')
replace 	INJECT_pre_correct60 =. if Score_pra_INJECT_pre==0 | S2_22_2 !=1
label var 	INJECT_pre_correct60 "Correct pre-procedure practice for the INJECTABLE at 60%"

sum Score_pra_INJECT_pre
gen Score_pra_INJECT_pre_N=((Score_pra_INJECT_pre-r(min))/(r(max)-r(min)))*10		
label var Score_pra_INJECT_pre_N "Score de la pratique correcte preprocedure de l'injectable"
								
					
				
				******************
				***  IMPLANTS  ***
				******************				


				
 foreach var of var S3_30_1 S3_30_2 S3_30_3 S3_30_4 S3_30_5 S3_30_6 S3_30_7 S3_30_8 S3_31_1 S3_31_2 S3_31_3 S3_31_4 S3_31_5 S3_31_6 S3_31_7 S3_32_1 S3_32_2 S3_32_3 S3_32_4 S3_32_5 S3_32_6 S3_32_7 S3_33_1 S3_33_2 S3_33_3 S3_34_1 S3_34_2 S3_34_3 S3_34_4 S3_34_5 S3_34_6 S3_34_7 S3_34_8 S3_35_1 S3_35_2 S3_35_3 S3_35_4 S3_35_5 S3_35_6 S3_35_7 S3_35_8 S3_35_10 S3_35_11 S3_35_12 S3_35_13 S3_36_1 S3_36_2 {

 gen Do`var'IMPLANTS_pre = `var'
 
}

			
				
		*Construction de la variable pratique correcte preprocédure de l'IMPLANTS.
		*Elle consiste à respecter au moins 80%, 70% ou 60% des 47 questions liées à la
		*pratique de l'IMPLANTS

		
egen 		Score_pra_IMPLANTS_pre	=  rsum(*IMPLANTS_pre)
local total_pratique_IMPLANTS_pre = 47  // Nombre total de questions utilisées
gen 		IMPLANTS_pre_correct80 = (Score_pra_IMPLANTS_pre >= `=round(0.80 * `total_pratique_IMPLANTS_pre')')
replace 	IMPLANTS_pre_correct80 =. if Score_pra_IMPLANTS_pre==0 | S2_22_7 !=1
label var	IMPLANTS_pre_correct80 "Correct pre-procedure practice for the IMPLANTS at 80%"
				
gen 		IMPLANTS_pre_correct70 = (Score_pra_IMPLANTS_pre >= `=round(0.70 * `total_pratique_IMPLANTS_pre')')
replace 	IMPLANTS_pre_correct70 =. if Score_pra_IMPLANTS_pre==0 | S2_22_7 !=1
label var	IMPLANTS_pre_correct70 "Correct pre-procedure practice for the IMPLANTS at 70%"

gen 		IMPLANTS_pre_correct60 = (Score_pra_IMPLANTS_pre >= `=round(0.60 * `total_pratique_IMPLANTS_pre')')
replace 	IMPLANTS_pre_correct60 =. if Score_pra_IMPLANTS_pre==0 | S2_22_7 !=1
label var	IMPLANTS_pre_correct60 "Correct pre-procedure practice for the IMPLANTS at 60%"				
			
sum Score_pra_IMPLANTS_pre
gen Score_pra_IMPLANTS_pre_N=((Score_pra_IMPLANTS_pre-r(min))/(r(max)-r(min)))*10
label var Score_pra_IMPLANTS_pre_N "Score de la pratique correcte preprocedure de l'implants"
			
					

				********************************
				***  STERILISATION FEMININE  ***
				********************************				

				
 foreach var of var S3_43_1 S3_43_2 S3_43_3 S3_43_4 S3_43_5 S3_43_6 S3_43_7 S3_43_8 S3_44_1 S3_44_2 S3_44_3 S3_44_4 S3_44_5 S3_44_6 S3_44_7 S3_45_1 S3_45_2 S3_45_3 S3_45_4 S3_45_5 S3_45_6 S3_45_7 S3_46_1 S3_46_2 S3_46_3 S3_49_1 S3_49_2 S3_49_3 S3_49_4 S3_49_5 S3_49_6 S3_49_7 S3_49_8 S3_49_10 S3_49_11 S3_49_12 S3_49_13 S3_49_14 S3_51_1 S3_51_2 S3_51_3 {

 gen Do`var'STERILFEM_pre = `var'
 
}

			
				
		*Construction de la variable pratique correcte preprocédure de la 
		*STERILISATION FEMININE. Elle consiste à respecter au moins 80%, 70% ou 60% des
		*41 questions liées à la pratique de la STERILISATION FEMININE

		
egen 		Score_pra_STERILFEM_pre	=  rsum(*STERILFEM_pre)
local total_pratique_STERILFEM_pre = 41 // Nombre total de questions utilisées
gen 		STERILFEM_pre_correct80 = (Score_pra_STERILFEM_pre >= `=round(0.80 * `total_pratique_STERILFEM_pre')')
replace 	STERILFEM_pre_correct80 =. if Score_pra_STERILFEM_pre==0 | S2_22_8 !=1
label var 	STERILFEM_pre_correct80 "Correct pre-procedure practice for the STERILISATION FEMININE at 80%"
								
gen 		STERILFEM_pre_correct70 = (Score_pra_STERILFEM_pre >= `=round(0.70 * `total_pratique_STERILFEM_pre')')
replace 	STERILFEM_pre_correct70 =. if Score_pra_STERILFEM_pre==0 | S2_22_8 !=1
label var 	STERILFEM_pre_correct70 "Correct pre-procedure practice for the STERILISATION FEMININE at 70%"

gen 		STERILFEM_pre_correct60 = (Score_pra_STERILFEM_pre >= `=round(0.60 * `total_pratique_STERILFEM_pre')')
replace 	STERILFEM_pre_correct60 =. if Score_pra_STERILFEM_pre==0 | S2_22_8 !=1
label var 	STERILFEM_pre_correct60 "Correct pre-procedure practice for the STERILISATION FEMININE at 60%"				

sum Score_pra_STERILFEM_pre
gen Score_pra_STERILFEM_pre_N=((Score_pra_STERILFEM_pre-r(min))/(r(max)-r(min)))*10		
label var Score_pra_STERILFEM_pre_N "Score de la pratique correcte preprocedure de la stérilisation feminine"
								
				
				
				********************************
				***  STERILISATION MASCULINE  ***
				********************************					

				
				
 foreach var of var S3_60_1 S3_60_2 S3_60_3 S3_60_4 S3_60_5 S3_60_6 S3_60_7 S3_60_8 S3_61_1 S3_61_2 S3_61_3 S3_61_4 S3_61_5 S3_62_1 S3_62_2 S3_62_3 S3_62_4 S3_62_5 S3_62_6 S3_63_1 S3_63_2 S3_63_3 S3_63_4 S3_63_5 S3_63_6 S3_63_7 S3_64_1 S3_64_2 S3_64_3 S3_64_4 S3_64_5 S3_64_6 S3_64_7 S3_64_8 S3_64_10 S3_64_11 S3_64_12 S3_64_13 S3_64_14 S3_64_15 S3_64_16 {

 gen Do`var'STERILMAS_pre = `var'
 
}

			
				
		*Construction de la variable pratique correcte preprocédure de la 
		*STERILISATION MASCULINE. Elle consiste à respecter au moins 80%, 70% ou 60% des
		*41 questions liées à la pratique de la STERILISATION MASCULINE

		
egen 		Score_pra_STERILMAS_pre	=  rsum(*STERILMAS_pre)
local total_pratique_STERILMAS_pre = 41 // Nombre total de questions utilisées
gen 		STERILMAS_pre_correct80 = (Score_pra_STERILMAS_pre >= `=round(0.80 * `total_pratique_STERILMAS_pre')')
replace 	STERILMAS_pre_correct80 =. if Score_pra_STERILMAS_pre==0 | S2_22_9 !=1
label var 	STERILMAS_pre_correct80 "Correct pre-procedure practice for the STERILISATION MASCULINE at 80%"
								
gen 		STERILMAS_pre_correct70 = (Score_pra_STERILMAS_pre >= `=round(0.70 * `total_pratique_STERILMAS_pre')')
replace 	STERILMAS_pre_correct70 =. if Score_pra_STERILMAS_pre==0 | S2_22_9 !=1
label var 	STERILMAS_pre_correct70 "Correct pre-procedure practice for the STERILISATION MASCULINE at 70%"

gen 		STERILMAS_pre_correct60 = (Score_pra_STERILMAS_pre >= `=round(0.60 * `total_pratique_STERILMAS_pre')')
replace 	STERILMAS_pre_correct60 =. if Score_pra_STERILMAS_pre==0 | S2_22_9 !=1
label var 	STERILMAS_pre_correct60 "Correct pre-procedure practice for the STERILISATION MASCULINE at 60%"			
			
sum Score_pra_STERILMAS_pre
gen Score_pra_STERILMAS_pre_N=((Score_pra_STERILMAS_pre-r(min))/(r(max)-r(min)))*10		
label var Score_pra_STERILMAS_pre_N "Score de la pratique correcte preprocedure de la stérilisation masculine"
			
			


*******INDICATEUR 3. Pourcentage de prestataires ayant une connaissance correcte
*******des procédures post-procédure, y compris le conseil et l'assistance pour
*******chaque méthode de PF qu'ils fournissent actuellement

				
				
				
								
				*************
				***  DIU  ***
				*************


			
				
 foreach var of var S3_13_1 S3_13_2 S3_13_3 S3_13_4 S3_13_5 S3_13_6 S3_13_7 S3_14_1 S3_14_2 S3_14_3 S3_14_4 {

 gen Do`var'DIU_post = `var'
 
}

			
				
		*Construction de la variable connaissance correcte des procédures
		*post-procédure de la DIU. Elle consiste à respecter au moins 80%, 70% ou 60% des
		*11 questions liées à la pratique postprocédure de la DIU

		
egen 		Score_pra_DIU_post	=  rsum(*DIU_post)
local total_pratique_DIU_post = 11 // Nombre total de questions utilisées
gen 		DIU_post_correct80 = (Score_pra_DIU_post >= `=round(0.80 * `total_pratique_DIU_post')')
replace 	DIU_post_correct80 =. if Score_pra_DIU_post==0 | S2_22_1 !=1
label var 	DIU_post_correct80 "Correct knowledge of post-procedural practices for DIU method at 80%"				
				
gen 		DIU_post_correct70 = (Score_pra_DIU_post >= `=round(0.70 * `total_pratique_DIU_post')')
replace 	DIU_post_correct70 =. if Score_pra_DIU_post==0 | S2_22_1 !=1
label var 	DIU_post_correct70 "Correct knowledge of post-procedural practices for DIU method at 70%"

gen 		DIU_post_correct60 = (Score_pra_DIU_post >= `=round(0.60 * `total_pratique_DIU_post')')
replace 	DIU_post_correct60 =. if Score_pra_DIU_post==0 | S2_22_1 !=1
label var 	DIU_post_correct60 "Correct knowledge of post-procedural practices for DIU method at 60%"

sum Score_pra_DIU_post
gen Score_pra_DIU_post_N=((Score_pra_DIU_post-r(min))/(r(max)-r(min)))*10		
label var Score_pra_DIU_post_N "Score de la connaissance correcte postprocedure du DIU"


				
				
				
				********************
				***  INJECTABLE  ***
				********************
				
				
		
				
 foreach var of var S3_26_1 S3_26_2 S3_26_3 S3_26_4 S3_26_5 S3_26_6 S3_26_7 S3_26_8 S3_27_1 S3_27_2 S3_27_3 S3_27_4 S3_27_5 {

 gen Do`var'INJECT_post = `var'
 
}

			
				
		*Construction de la variable connaissance correcte des procédures
		*post-procédure de l'INJECTABLE. Elle consiste à respecter au moins 80%, 70% ou 60% des
		*13 questions liées à la pratique postprocédure de l'INJECTABLE

		
egen 		Score_pra_INJECT_post	=  rsum(*INJECT_post)
local total_pratique_INJECT_post = 13 // Nombre total de questions utilisées
gen 		INJECT_post_correct80 = (Score_pra_INJECT_post >= `=round(0.80 * `total_pratique_INJECT_post')')
replace 	INJECT_post_correct80 =. if Score_pra_INJECT_post==0 | S2_22_2 !=1
label var 	INJECT_post_correct80 "Correct knowledge of post-procedural practices for INJECTABLE method at 80%"				
				
gen 		INJECT_post_correct70 = (Score_pra_INJECT_post >= `=round(0.70 * `total_pratique_INJECT_post')')
replace 	INJECT_post_correct70 =. if Score_pra_INJECT_post==0 | S2_22_2 !=1
label var 	INJECT_post_correct70 "Correct knowledge of post-procedural practices for INJECTABLE method at 70%"

gen 		INJECT_post_correct60 = (Score_pra_INJECT_post >= `=round(0.60 * `total_pratique_INJECT_post')')
replace 	INJECT_post_correct60 =. if Score_pra_INJECT_post==0 | S2_22_2 !=1
label var 	INJECT_post_correct60 "Correct knowledge of post-procedural practices for INJECTABLE method at 60%"			
		
sum Score_pra_INJECT_post
gen Score_pra_INJECT_post_N=((Score_pra_INJECT_post-r(min))/(r(max)-r(min)))*10		
label var Score_pra_INJECT_post_N "Score de la connaissance correcte postprocedure des Injectables"


		
		
				******************
				***  IMPLANTS  ***
				******************				

				
		
				
 foreach var of var S3_37_1 S3_37_2 S3_37_3 S3_37_4 S3_37_5 S3_37_6 S3_37_7 S3_37_8 S3_37_10 S3_37_11 S3_37_12 S3_39_1 S3_39_2 S3_39_3 S3_39_4 S3_39_5 S3_39_6 S3_39_7 S3_40_1 S3_40_2 S3_40_3 S3_40_4 S3_40_5 {

 gen Do`var'IMPLANTS_post = `var'
 
}

			
				
		*Construction de la variable connaissance correcte des procédures
		*post-procédure de l'IMPLANTS. Elle consiste à respecter au moins 80%, 70% ou 60% des
		*13 questions liées à la pratique postprocédure de l'IMPLANTS

		
egen 		Score_pra_IMPLANTS_post	=  rsum(*IMPLANTS_post)
local total_pratique_IMPLANTS_post = 13 // Nombre total de questions utilisées
gen 		IMPLANTS_post_correct80 = (Score_pra_IMPLANTS_post >= `=round(0.80 * `total_pratique_IMPLANTS_post')')
replace 	IMPLANTS_post_correct80 =. if Score_pra_IMPLANTS_post==0 | S2_22_7 !=1
label var 	IMPLANTS_post_correct80 "Correct knowledge of post-procedural practices for IMPLANTS method at 80%"				
				
gen 		IMPLANTS_post_correct70 = (Score_pra_IMPLANTS_post >= `=round(0.70 * `total_pratique_IMPLANTS_post')')
replace 	IMPLANTS_post_correct70 =. if Score_pra_IMPLANTS_post==0 | S2_22_7 !=1
label var 	IMPLANTS_post_correct70 "Correct knowledge of post-procedural practices for IMPLANTS method at 70%"	

gen 		IMPLANTS_post_correct60 = (Score_pra_IMPLANTS_post >= `=round(0.60 * `total_pratique_IMPLANTS_post')')
replace 	IMPLANTS_post_correct60 =. if Score_pra_IMPLANTS_post==0 | S2_22_7 !=1
label var 	IMPLANTS_post_correct60 "Correct knowledge of post-procedural practices for IMPLANTS method at 60%"			

sum Score_pra_IMPLANTS_post
gen Score_pra_IMPLANTS_post_N=((Score_pra_IMPLANTS_post-r(min))/(r(max)-r(min)))*10
label var Score_pra_IMPLANTS_post_N "Score de la connaissance correcte postprocedure des Implants"


				
				********************************
				***  STERILISATION FEMININE  ***
				********************************				

				
		
				
 foreach var of var S3_53_1 S3_53_2 S3_53_3 S3_53_4 S3_54_1 S3_54_2 S3_54_3 S3_54_4 S3_54_5 S3_54_6 S3_54_7 S3_54_8 S3_54_10 S3_54_11 S3_56_1 S3_56_2 S3_56_3 S3_56_4 S3_56_5 S3_56_6 S3_56_7 S3_56_8 {

 gen Do`var'STERILFEM_post = `var'
 
}

			
				
		*Construction de la variable connaissance correcte des procédures
		*post-procédure de la STERILISATION FEMININE . Elle consiste à 
		*respecter au moins 80%, 70% ou 60% des 22 questions liées à la pratique 
		*postprocédure de la STERILISATION FEMININE 

		
egen 		Score_pra_STERILFEM_post	=  rsum(*STERILFEM_post)
local total_pratique_STERILFEM_post = 22 // Nombre total de questions utilisées
gen 		STERILFEM_post_correct80 = (Score_pra_STERILFEM_post >= `=round(0.80 * `total_pratique_STERILFEM_post')')
replace 	STERILFEM_post_correct80 =. if Score_pra_STERILFEM_post==0 | S2_22_8 !=1
label var 	STERILFEM_post_correct80 "Correct knowledge of post-procedural practices for STERILISATION FEMININE method at 80%"				
					
gen 		STERILFEM_post_correct70 = (Score_pra_STERILFEM_post >= `=round(0.70 * `total_pratique_STERILFEM_post')')
replace 	STERILFEM_post_correct70 =. if Score_pra_STERILFEM_post==0 | S2_22_8 !=1
label var 	STERILFEM_post_correct70 "Correct knowledge of post-procedural practices for STERILISATION FEMININE method at 70%"	

gen 		STERILFEM_post_correct60 = (Score_pra_STERILFEM_post >= `=round(0.60 * `total_pratique_STERILFEM_post')')
replace 	STERILFEM_post_correct60 =. if Score_pra_STERILFEM_post==0 | S2_22_8 !=1
label var 	STERILFEM_post_correct60 "Correct knowledge of post-procedural practices for STERILISATION FEMININE method at 60%"
				
sum Score_pra_STERILFEM_post
gen Score_pra_STERILFEM_post_N=((Score_pra_STERILFEM_post-r(min))/(r(max)-r(min)))*10
label var Score_pra_STERILFEM_post_N "Score de la connaissance correcte postprocedure de stérilisation féminine"

				
				
				*********************************
				***  STERILISATION MASCULINE  ***
				*********************************					
				
				
				
 foreach var of var S3_67_1 S3_67_2 S3_68_1 S3_68_2 S3_68_3 S3_68_4 S3_68_5 S3_68_6 S3_68_7 S3_68_8 S3_68_10 S3_68_11 S3_68_12 S3_68_13 S3_68_14 S3_70_1 S3_70_2 S3_70_3 S3_70_4 S3_70_5 S3_70_6 S3_73_1 S3_73_2 S3_73_3 S3_73_4 {

 gen Do`var'STERILMAS_post = `var'
 
}

			
				
		*Construction de la variable connaissance correcte des procédures
		*post-procédure de la STERILISATION MASCULINE. Elle consiste à 
		*respecter au moins 80%, 70% ou 60% des 25 questions liées à la pratique 
		*postprocédure de la STERILISATION MASCULINE 

		
egen 		Score_pra_STERILMAS_post	=  rsum(*STERILMAS_post)
local total_pratique_STERILMAS_post = 25 // Nombre total de questions utilisées
gen 		STERILMAS_post_correct80 = (Score_pra_STERILMAS_post >= `=round(0.80 * `total_pratique_STERILMAS_post')')
replace 	STERILMAS_post_correct80 =. if Score_pra_STERILMAS_post==0 | S2_22_9 !=1
label var 	STERILMAS_post_correct80 "Correct knowledge of post-procedural practices for STERILISATION MASCULINE method at 80%"					
				
gen 		STERILMAS_post_correct70 = (Score_pra_STERILMAS_post >= `=round(0.70 * `total_pratique_STERILMAS_post')')
replace 	STERILMAS_post_correct70 =. if Score_pra_STERILMAS_post==0 | S2_22_9 !=1
label var 	STERILMAS_post_correct70 "Correct knowledge of post-procedural practices for STERILISATION MASCULINE method at 70%"	

gen 		STERILMAS_post_correct60 = (Score_pra_STERILMAS_post >= `=round(0.60 * `total_pratique_STERILMAS_post')')
replace 	STERILMAS_post_correct60 =. if Score_pra_STERILMAS_post==0 | S2_22_9 !=1
label var 	STERILMAS_post_correct60 "Correct knowledge of post-procedural practices for STERILISATION MASCULINE method at 60%"						

sum Score_pra_STERILMAS_post
gen Score_pra_STERILMAS_post_N=((Score_pra_STERILFEM_post-r(min))/(r(max)-r(min)))*10		
label var Score_pra_STERILMAS_post_N "Score de la connaissance correcte postprocedure de stérilisation féminine"

			
				

*******INDICATEUR 4. Pourcentage de prestataires ayant une attitude favorable
*******à l'égard du PF en général et à l'égard de chaque méthode de PF qu'ils
*******fournissent actuellement
		
				

				
				*********************************
				***  PLANIFICATION FAMILIALE  ***
				*********************************
				
				
				
				
 foreach var of var S4_1_1 S4_1_2 S4_1_3 S4_1_4 S4_1_5 S4_1_6 S4_1_7 S4_1_8 S4_1_9 S4_1_10 S4_1_11 S4_1_12 {

 gen 	 Attitude`var'PF = 	(`var'<= 2)
 replace Attitude`var'PF =. if `var'== .
 
}				
				
				
		*Construction de la variable L'attitude favorable à l'égard de la
		*PF. Elle revient à avoir une opignon positive sur au moins 80%, 70% ou 60% des
		*12 questions liées à la perception de la PF		
				
				

egen 		Score_Attitude_PF	=  rsum(*PF)
local total_Attitude_PF = 12 // Nombre total de questions utilisées
gen 		Favorable_PF80 = (Score_Attitude_PF >= `=round(0.80 * `total_Attitude_PF')')
replace 	Favorable_PF80 =. if Score_Attitude_PF==0 | S2_17 !=1
label var 	Favorable_PF80 "Favourable attitude to FP at 80%"

gen 		Favorable_PF70 = (Score_Attitude_PF >= `=round(0.70 * `total_Attitude_PF')')
replace 	Favorable_PF70 =. if Score_Attitude_PF==0 | S2_17 !=1
label var 	Favorable_PF70 "Favourable attitude to FP at 70%"

gen 		Favorable_PF60 = (Score_Attitude_PF >= `=round(0.60 * `total_Attitude_PF')')
replace 	Favorable_PF60 =. if Score_Attitude_PF==0 | S2_17 !=1
label var 	Favorable_PF60 "Favourable attitude to FP at 60%"
	
sum Score_Attitude_PF
gen Score_Attitude_PF_N=((Score_Attitude_PF-r(min))/(r(max)-r(min)))*10		
label var Score_Attitude_PF_N "Score de l'attitude favorable à l'égard de la PF"
	
				
				
				*************
				***  DIU  ***
				*************

				
				
 foreach var of var S4_3_1 S4_3_2 S4_3_3 S4_3_4 S4_3_5 S4_3_6 S4_3_7 S4_3_8 S4_3_9 S4_3_10 S4_3_11 S4_3_12 {

 gen 	 Attitude`var'DIU = 	(`var'<= 2)
 replace Attitude`var'DIU =. if `var'== .
 
}				
				
				
		*Construction de la variable L'attitude favorable à l'égard de la
		*DIU. Elle revient à avoir une opignon positive sur au moins 80%, 70% ou 60% des
		*12 questions liées à la perception de la DIU		
				
				

egen 		Score_Attitude_DIU	=  rsum(*DIU)
local total_Attitude_DIU = 12 // Nombre total de questions utilisées
gen 		Favorable_DIU80 = (Score_Attitude_DIU >= `=round(0.80 * `total_Attitude_DIU')')
replace 	Favorable_DIU80=. if Score_Attitude_DIU==0 | S2_22_1 !=1
label var 	Favorable_DIU80 "Favourable attitude to DIU at 80%"

gen 		Favorable_DIU70 = (Score_Attitude_DIU >= `=round(0.70 * `total_Attitude_DIU')')
replace 	Favorable_DIU70=. if Score_Attitude_DIU==0 | S2_22_1 !=1
label var 	Favorable_DIU70 "Favourable attitude to DIU at 70%"

gen 		Favorable_DIU60 = (Score_Attitude_DIU >= `=round(0.60 * `total_Attitude_DIU')')
replace 	Favorable_DIU60=. if Score_Attitude_DIU==0 | S2_22_1 !=1
label var 	Favorable_DIU60 "Favourable attitude to DIU at 60%"				

sum Score_Attitude_DIU
gen Score_Attitude_DIU_N=((Score_Attitude_DIU-r(min))/(r(max)-r(min)))*10
label var Score_Attitude_DIU_N "Score de l'attitude favorable à l'égard de la DIU"
				
				
				
				*********************
				***  INJECTABLES  ***
				*********************
				
			
				
 foreach var of var S4_5_1 S4_5_2 S4_5_3 S4_5_4 S4_5_5 S4_5_6 S4_5_7 S4_5_8 S4_5_9 S4_5_10 {

 gen 	 Attitude`var'INJECTABLES = 	(`var'<= 2)
 replace Attitude`var'INJECTABLES =. if `var'== .
 
}				
				
				
		*Construction de la variable L'attitude favorable à l'égard de la
		*INJECTABLES. Elle revient à avoir une opignon positive sur au moins 80%, 70% ou 60%
		*des 12 questions liées à la perception de la INJECTABLES		
				
				

egen 		Score_Attitude_INJECTABLES	=  rsum(*INJECTABLES)
local total_Attitude_INJECTABLES = 10 // Nombre total de questions utilisées
gen 		Favorable_INJECTABLES80 = (Score_Attitude_INJECTABLES >= `=round(0.80 * `total_Attitude_INJECTABLES')')
replace 	Favorable_INJECTABLES80 =. if Score_Attitude_INJECTABLES==0 | S2_22_2 !=1
label var 	Favorable_INJECTABLES80 "Favourable attitude to INJECTABLES at 80%"

gen 		Favorable_INJECTABLES70 = (Score_Attitude_INJECTABLES >= `=round(0.70 * `total_Attitude_INJECTABLES')')
replace 	Favorable_INJECTABLES70 =. if Score_Attitude_INJECTABLES==0 | S2_22_2 !=1
label var 	Favorable_INJECTABLES70 "Favourable attitude to INJECTABLES at 70%"

gen 		Favorable_INJECTABLES60 = (Score_Attitude_INJECTABLES >= `=round(0.60 * `total_Attitude_INJECTABLES')')
replace 	Favorable_INJECTABLES60 =. if Score_Attitude_INJECTABLES==0 | S2_22_2 !=1
label var 	Favorable_INJECTABLES60 "Favourable attitude to INJECTABLES at 60%"				

sum Score_Attitude_INJECTABLES
gen Score_Attitude_INJECTABLES_N=((Score_Attitude_INJECTABLES-r(min))/(r(max)-r(min)))*10
label var Score_Attitude_INJECTABLES_N "Score de l'attitude favorable à l'égard des Injectables"
								
		
				
				******************
				***  IMPLANTS  ***
				******************
				
				
				
 foreach var of var S4_7_1 S4_7_2 S4_7_3 S4_7_4 S4_7_5 S4_7_6 S4_7_7 S4_7_8 S4_7_9 S4_7_10 {

 gen 	 Attitude`var'IMPLANTS = 	(`var'<= 2)
 replace Attitude`var'IMPLANTS =. if `var'== .
 
}				
				
				
		*Construction de la variable L'attitude favorable à l'égard de la
		*IMPLANTS. Elle revient à avoir une opignon positive sur au moins 80%, 70% ou 60%
		*des 12 questions liées à la perception de la IMPLANTS		
				
				

egen 		Score_Attitude_IMPLANTS	=  rsum(*IMPLANTS)
local total_Attitude_IMPLANTS = 10 // Nombre total de questions utilisées
gen 		Favorable_IMPLANTS80 = (Score_Attitude_IMPLANTS >= `=round(0.80 * `total_Attitude_IMPLANTS')')
replace 	Favorable_IMPLANTS80 =. if Score_Attitude_IMPLANTS==0 | S2_22_7 !=1
label var 	Favorable_IMPLANTS80 "Favourable attitude to IMPLANTS at 80%"

gen 		Favorable_IMPLANTS70 = (Score_Attitude_IMPLANTS >= `=round(0.70 * `total_Attitude_IMPLANTS')')
replace 	Favorable_IMPLANTS70 =. if Score_Attitude_IMPLANTS==0 | S2_22_7 !=1
label var 	Favorable_IMPLANTS70 "Favourable attitude to IMPLANTS at 70%"

gen 		Favorable_IMPLANTS60 = (Score_Attitude_IMPLANTS >= `=round(0.80 * `total_Attitude_IMPLANTS')')
replace 	Favorable_IMPLANTS60 =. if Score_Attitude_IMPLANTS==0 | S2_22_7 !=1
label var 	Favorable_IMPLANTS60 "Favourable attitude to IMPLANTS at 60%"

sum Score_Attitude_IMPLANTS
gen Score_Attitude_IMPLANTS_N=((Score_Attitude_IMPLANTS-r(min))/(r(max)-r(min)))*10		
label var Score_Attitude_IMPLANTS_N "Score de l'attitude favorable à l'égard des Implants"




				*****************
				***  PILULE  ***
				*****************
	
				
				
 foreach var of var S4_9_1 S4_9_2 S4_9_3 S4_9_4 S4_9_5 S4_9_6 {

 gen 	 Attitude`var'PILULE = 	(`var'<= 2)
 replace Attitude`var'PILULE =. if `var'== .
 
}				
				
				
		*Construction de la variable L'attitude favorable à l'égard de la
		*PILULE. Elle revient à avoir une opignon positive sur au moins 80%, 70% ou 60%
		*des 12 questions liées à la perception de la PILULE		
				
				

egen 	Score_Attitude_PILULE	=  rsum(*PILULE)
local total_Attitude_PILULE 	= 6 // Nombre total de questions utilisées
gen 		Favorable_PILULE80 	= (Score_Attitude_PILULE >= `=round(0.80 * `total_Attitude_PILULE')')
replace 	Favorable_PILULE80 	=. if Score_Attitude_PILULE==0 | S2_22_6 !=1
label var 	Favorable_PILULE80 "Favourable attitude to PILULE at 80%"

gen 		Favorable_PILULE70 	= (Score_Attitude_PILULE >= `=round(0.70 * `total_Attitude_PILULE')')
replace 	Favorable_PILULE70 	=. if Score_Attitude_PILULE==0 | S2_22_6 !=1
label var 	Favorable_PILULE70 "Favourable attitude to PILULE at 70%"							
				
gen 		Favorable_PILULE60 	= (Score_Attitude_PILULE >= `=round(0.60 * `total_Attitude_PILULE')')
replace 	Favorable_PILULE60 	=. if Score_Attitude_PILULE==0 | S2_22_6 !=1
label var 	Favorable_PILULE60 "Favourable attitude to PILULE at 60%"

sum Score_Attitude_PILULE
gen Score_Attitude_PILULE_N=((Score_Attitude_PILULE-r(min))/(r(max)-r(min)))*10		
label var Score_Attitude_PILULE_N "Score de l'attitude favorable à l'égard de la pilule"

				
				
				
				*********************************
				***  CONTRACEPTION D'URGENCE  ***
				*********************************
				
				
				
 foreach var of var S4_11_1 S4_11_2 S4_11_3 S4_11_4 S4_11_5 S4_11_6 {

 gen 	 Attitude`var'CONTRACEPURG = 	(`var'<= 2)
 replace Attitude`var'CONTRACEPURG =. if `var'== .
 
}				
				
				
		*Construction de la variable L'attitude favorable à l'égard de la
		*CONTRACEPTION D'URGENCE. Elle revient à avoir une opignon positive
		*sur au moins 80%, 70% ou 60% des 12 questions liées à la perception de la
		*CONTRACEPTION D'URGENCE		
				
				

egen 		Score_Attitude_CONTRACEPURG	=  rsum(*CONTRACEPURG)
local total_Attitude_CONTRACEPURG = 6 // Nombre total de questions utilisées
gen 		Favorable_CONTRACEPURG80 = (Score_Attitude_CONTRACEPURG >= `=round(0.80 * `total_Attitude_CONTRACEPURG')')
replace 	Favorable_CONTRACEPURG80 =. if Score_Attitude_CONTRACEPURG==0 | S2_22_5 !=1
label var	Favorable_CONTRACEPURG80 "Favourable attitude to CONTRACEPTION D'URGENCE at 80%"

gen 		Favorable_CONTRACEPURG70 = (Score_Attitude_CONTRACEPURG >= `=round(0.70 * `total_Attitude_CONTRACEPURG')')
replace 	Favorable_CONTRACEPURG70 =. if Score_Attitude_CONTRACEPURG==0 | S2_22_5 !=1
label var	Favorable_CONTRACEPURG70 "Favourable attitude to CONTRACEPTION D'URGENCE at 70%"

gen 		Favorable_CONTRACEPURG60 = (Score_Attitude_CONTRACEPURG >= `=round(0.60 * `total_Attitude_CONTRACEPURG')')
replace 	Favorable_CONTRACEPURG60 =. if Score_Attitude_CONTRACEPURG==0 | S2_22_5 !=1
label var	Favorable_CONTRACEPURG60 "Favourable attitude to CONTRACEPTION D'URGENCE at 60%"											

sum Score_Attitude_CONTRACEPURG
gen Score_Attitude_CONTRACEPURG_N=((Score_Attitude_CONTRACEPURG-r(min))/(r(max)-r(min)))*10
label var Score_Attitude_CONTRACEPURG_N "Score de l'attitude favorable à l'égard de la contraception d'urgence"

							
				
				*****************************
				***  PRESERVATIF FEMININ  ***
				*****************************
					
				
				
 foreach var of var S4_13_1 S4_13_2 S4_13_3 S4_13_4 S4_13_5 {

 gen 	 Attitude`var'PRESERVATFEM = 	(`var'<= 2)
 replace Attitude`var'PRESERVATFEM =. if `var'== .
 
}				
				
				
		*Construction de la variable L'attitude favorable à l'égard de la
		*PRESERVATIF FEMININ. Elle revient à avoir une opignon positive
		*sur au moins 80%, 70% ou 60% des 12 questions liées à la perception de la
		*PRESERVATIF FEMININ		
				
				

egen 		Score_Attitude_PRESERVATFEM	=  rsum(*PRESERVATFEM)
local total_Attitude_PRESERVATFEM = 5 // Nombre total de questions utilisées
gen 		Favorable_PRESERVATFEM80 = (Score_Attitude_PRESERVATFEM >= `=round(0.80 * `total_Attitude_PRESERVATFEM')')
replace 	Favorable_PRESERVATFEM80 =. if Score_Attitude_PRESERVATFEM==0 | S2_22_4 !=1
label var	Favorable_PRESERVATFEM80 "Favourable attitude to PRESERVATIF FEMININ at 80%"

gen 		Favorable_PRESERVATFEM70 = (Score_Attitude_PRESERVATFEM >= `=round(0.70 * `total_Attitude_PRESERVATFEM')')
replace 	Favorable_PRESERVATFEM70 =. if Score_Attitude_PRESERVATFEM==0 | S2_22_4 !=1
label var	Favorable_PRESERVATFEM70 "Favourable attitude to PRESERVATIF FEMININ at 70%"

gen 		Favorable_PRESERVATFEM60 = (Score_Attitude_PRESERVATFEM >= `=round(0.60 * `total_Attitude_PRESERVATFEM')')
replace 	Favorable_PRESERVATFEM60 =. if Score_Attitude_PRESERVATFEM==0 | S2_22_4 !=1
label var	Favorable_PRESERVATFEM60 "Favourable attitude to PRESERVATIF FEMININ at 60%"

sum Score_Attitude_PRESERVATFEM
gen Score_Attitude_PRESERVATFEM_N=((Score_Attitude_PRESERVATFEM-r(min))/(r(max)-r(min)))*10
label var Score_Attitude_PRESERVATFEM_N "Score de l'attitude favorable à l'égard du préservatif féminin"

																					
				
								
				********************************
				***  STERILISATION FEMININE  ***
				********************************
				
				

				
 foreach var of var S4_15_1 S4_15_2 S4_15_3 S4_15_4 S4_15_5 S4_15_6 S4_15_7 S4_15_8 S4_15_9 {

 gen 	 Attitude`var'STERILISFEM = 	(`var'<= 2)
 replace Attitude`var'STERILISFEM =. if `var'== .
 
}				
				
				
		*Construction de la variable L'attitude favorable à l'égard de la
		*STERILISATION FEMININE. Elle revient à avoir une opignon positive
		*sur au moins 80%, 70% ou 60% des 12 questions liées à la perception de la
		*STERILISATION FEMININE				
				

egen 		Score_Attitude_STERILISFEM	=  rsum(*STERILISFEM)
local total_Attitude_STERILISFEM = 9 // Nombre total de questions utilisées
gen 		Favorable_STERILISFEM80 = (Score_Attitude_STERILISFEM >= `=round(0.80 * `total_Attitude_STERILISFEM')')
replace 	Favorable_STERILISFEM80 =. if Score_Attitude_STERILISFEM==0 | S2_22_8 !=1
label var	Favorable_STERILISFEM80 "Favourable attitude to STERILISATION FEMININE at 80%"

gen 		Favorable_STERILISFEM70 = (Score_Attitude_STERILISFEM >= `=round(0.70 * `total_Attitude_STERILISFEM')')
replace 	Favorable_STERILISFEM70 =. if Score_Attitude_STERILISFEM==0 | S2_22_8 !=1
label var	Favorable_STERILISFEM70 "Favourable attitude to STERILISATION FEMININE at 70%"

gen 		Favorable_STERILISFEM60 = (Score_Attitude_STERILISFEM >= `=round(0.60 * `total_Attitude_STERILISFEM')')
replace 	Favorable_STERILISFEM60 =. if Score_Attitude_STERILISFEM==0 | S2_22_8 !=1
label var	Favorable_STERILISFEM60 "Favourable attitude to STERILISATION FEMININE at 60%"													

sum Score_Attitude_STERILISFEM
gen Score_Attitude_STERILISFEM_N=((Score_Attitude_PRESERVATFEM-r(min))/(r(max)-r(min)))*10		
label var Score_Attitude_STERILISFEM_N "Score de l'attitude favorable à l'égard de la stérilisation féminine"

	
																
				
				*********************************
				***  STERILISATION MASCULINE  ***
				*********************************
				
				
				
 foreach var of var S4_17_1 S4_17_2 S4_17_3 S4_17_4 S4_17_5 {

 gen 	 Attitude`var'STERILISMAS = 	(`var'<= 2)
 replace Attitude`var'STERILISMAS =. if `var'== .
 
}				
				
				
		*Construction de la variable L'attitude favorable à l'égard de la
		*STERILISATION MASCULINE. Elle revient à avoir une opignon positive
		*sur au moins 80%, 70% ou 60% des 12 questions liées à la perception de la
		*STERILISATION MASCULINE		
				
				

egen 		Score_Attitude_STERILISMAS	=  rsum(*STERILISMAS)
local total_Attitude_STERILISMAS = 5 // Nombre total de questions utilisées
gen 		Favorable_STERILISMAS80 = (Score_Attitude_STERILISMAS >= `=round(0.80 * `total_Attitude_STERILISMAS')')
replace 	Favorable_STERILISMAS80 =. if Score_Attitude_STERILISMAS==0 | S2_22_9 !=1
label var	Favorable_STERILISMAS80 "Favourable attitude to STERILISATION MASCULINE at 80%"

gen 		Favorable_STERILISMAS70 = (Score_Attitude_STERILISMAS >= `=round(0.70 * `total_Attitude_STERILISMAS')')
replace 	Favorable_STERILISMAS70 =. if Score_Attitude_STERILISMAS==0 | S2_22_9 !=1
label var	Favorable_STERILISMAS70 "Favourable attitude to STERILISATION MASCULINE at 70%"

gen 		Favorable_STERILISMAS60 = (Score_Attitude_STERILISMAS >= `=round(0.60 * `total_Attitude_STERILISMAS')')
replace 	Favorable_STERILISMAS60 =. if Score_Attitude_STERILISMAS==0 | S2_22_9 !=1
label var	Favorable_STERILISMAS60 "Favourable attitude to STERILISATION MASCULINE at 60%"																

sum Score_Attitude_STERILISMAS
gen Score_Attitude_STERILISMAS_N=((Score_Attitude_STERILISMAS-r(min))/(r(max)-r(min)))*10
label var Score_Attitude_STERILISMAS_N "Score de l'attitude favorable à l'égard de la stérilisation féminine"




*******INDICATEUR 5. Pourcentage de prestataires ayant reçu une formation sur 
*******les services PF

		
		
		
 foreach var of var S2_28_1_1 S2_28_2_1 S2_28_3_1 S2_28_1_2 S2_28_2_2 S2_28_3_2 S2_28_1_3 S2_28_2_3 S2_28_3_3 S2_28_1_4 S2_28_2_4 S2_28_3_4 S2_28_1_5 S2_28_2_5 S2_28_3_5 S2_28_1_6 S2_28_2_6 S2_28_3_6 S2_28_1_7 S2_28_2_7 S2_28_3_7 S2_28_1_8 S2_28_2_8 S2_28_3_8 S2_28_1_9 S2_28_2_9 S2_28_3_9 S2_28_1_10 S2_28_2_10 S2_28_3_10 {

 gen 	 Format`var' = 	(`var'== 1)
 replace Format`var' = 0 if `var'== .
 
}		
		
		
		
			
			
				*************
				***  DIU  ***
				*************			
			
gen 	Formation_DIU = 1 if FormatS2_28_1_1 == 1 | FormatS2_28_2_1 == 1 | FormatS2_28_3_1 == 1
replace Formation_DIU = 0 if FormatS2_28_1_1 == 0 & FormatS2_28_2_1 == 0 & FormatS2_28_3_1 == 0
label var Formation_DIU "Has received DIU training"			
			
			
			
			
				*********************
				***  INJECTABLES  ***
				*********************	
				
			
gen 	Formation_INJECT = 1 if FormatS2_28_1_2 == 1 | FormatS2_28_2_2 == 1 | FormatS2_28_3_2 == 1			
replace	Formation_INJECT = 0 if FormatS2_28_1_2 == 0 & FormatS2_28_2_2 == 0 & FormatS2_28_3_2 == 0			
label var Formation_INJECT "Has received INJECTABLES training"

			
			
				******************************
				***  PRESERVATIF MASCULIN  ***
				******************************
				
				
gen 	Formation_PRESERMAS = 1 if FormatS2_28_1_3 == 1 | FormatS2_28_2_3 == 1 | FormatS2_28_3_3 == 1
replace Formation_PRESERMAS = 0 if FormatS2_28_1_3 == 0 & FormatS2_28_2_3 == 0 & FormatS2_28_3_3 == 0
label var Formation_PRESERMAS "Has received MALE CONDOM training"				
				
				
				*****************************
				***  PRESERVATIF FEMININ  ***
				*****************************				
				
gen 	Formation_PRESERFEM = 1 if FormatS2_28_1_4 == 1 | FormatS2_28_2_4 == 1 | FormatS2_28_3_4 == 1				
replace Formation_PRESERFEM = 0 if FormatS2_28_1_4 == 0 & FormatS2_28_2_4 == 0 & FormatS2_28_3_4 == 0					
label var Formation_PRESERFEM "Has received FEMALE CONDOM training"				
				
				
				
				********************************
				***  CONTRACEPTIF D'URGENCE  ***
				********************************
				
	
gen 	Formation_CONTRACURG = 1 if FormatS2_28_1_5==1 | FormatS2_28_2_5==1 | FormatS2_28_3_5==1				
replace Formation_CONTRACURG = 0 if FormatS2_28_1_5==0 & FormatS2_28_2_5==0 & FormatS2_28_3_5==0					
label var Formation_CONTRACURG "Has received EMERGENCY CONTRACEPTIVE training"
				
				
				
				*****************
				***  PILULES  ***
				*****************				
				

gen 	Formation_PILLS = 1 if FormatS2_28_1_6==1 | FormatS2_28_2_6==1 | FormatS2_28_3_6==1
replace Formation_PILLS = 0 if FormatS2_28_1_6==0 & FormatS2_28_2_6==0 & FormatS2_28_3_6==0
label var Formation_PILLS "Has received PILLS training"
				
			
			
				******************
				***  IMPLANTS  ***
				******************
				
				
gen 	Formation_IMPLANTS = 1 if FormatS2_28_1_7==1 | FormatS2_28_2_7==1 | FormatS2_28_3_7==1
replace Formation_IMPLANTS = 0 if FormatS2_28_1_7==0 & FormatS2_28_2_7==0 & FormatS2_28_3_7==0
label var Formation_IMPLANTS "Has received IMPLANTS training"
				
				
				
				********************************
				***  STERILISATION FEMININE  ***
				********************************
				

gen 	Formation_STERILIZFEM = 1 if FormatS2_28_1_8==1 | FormatS2_28_2_8==1 | FormatS2_28_3_8==1
replace Formation_STERILIZFEM = 0 if FormatS2_28_1_8==0 & FormatS2_28_2_8==0 & FormatS2_28_3_8==0
label var Formation_STERILIZFEM "Has received FEMALE STERILIZATION training"
				
				
				
				*********************************
				***  STERILISATION MASCULINE  ***
				*********************************				
				
				
gen 	Formation_STERILIZMAS = 1 if FormatS2_28_1_9==1 | FormatS2_28_2_9==1 | FormatS2_28_3_9==1
replace Formation_STERILIZMAS = 0 if FormatS2_28_1_9==0 & FormatS2_28_2_9==0 & FormatS2_28_3_9==0
label var Formation_STERILIZMAS "Has received MALE STERILIZATION training"
				
				
				
				**********************************************
				***  ALLAITEMENT MATERNEL EXCLUSIF (MAMA)  ***
				**********************************************
				
				
gen 	Formation_MATEXCLU = 1 if FormatS2_28_1_10==1 | FormatS2_28_2_10==1 | FormatS2_28_3_10==1
replace Formation_MATEXCLU = 0 if FormatS2_28_1_10==0 & FormatS2_28_2_10==0 & FormatS2_28_3_10==0
label var Formation_MATEXCLU "Has received EXCLUSIVE BREASTFEEDING training"
				
				
			
			
			
			
				
				
				
				
				/* LES INDICATEURS SMNI */
				
				
				
				
				
				

*******INDICATEUR 1. Pourcentage de prestataires ayant une connaissance correcte
*******des services de SMNI

								
				
				
				*************************
				***  ANTE-NATAL CARE  ***
				*************************			
			
							

 foreach var of var S6_01_A S6_01_B S6_01_C S6_01_D S6_01_E S6_01_F S6_01_G S6_01_H S6_01_I S6_01_J S6_01_K S6_02_A S6_02_B S6_02_C S6_02_D S6_02_E S6_02_F S6_05_A S6_05_B S6_05_C S6_05_D S6_05_E S6_05_F S6_05_G S6_05_H S6_05_I S6_05_J S6_05_K S6_05_L S6_15_A S6_15_B S6_15_C S6_17_A S6_17_B S6_18_A S6_18_B S6_19_A S6_19_B S6_19_C S6_19_D S6_19_E S6_19_F S6_19_G S6_22_A S6_22_B S6_22_C S6_22_D S6_22_E S6_22_F S6_22_G S6_23_A S6_23_B S6_23_C S6_31_1 S6_32_A S6_32_B S6_37_A S6_37_B S6_38_A S6_38_B S6_38_C {

 gen `var'ANTENATAL = `var'

}

 foreach var of var S6_03 S6_04 S6_16 S6_24 S6_36 {

 gen 	 `var'ANTENATAL = `var'
 replace `var'ANTENATAL =0 if `var'!=1
 replace `var'ANTENATAL =. if `var'==.

}				
				
				
		*Construction de la variable connaissance correcte des services des
		*soins prénatales. Elle revient à connaitre au moins 80%, 70% ou 60% des actes
		*et les interventions transcrit par les 66 questions liées aux soins
		*prénatales
				
	

egen 		Score_Con_ANTENATAL	=  rsum(*ANTENATAL)
local total_Con_ANTENATAL = 66 // Nombre total de questions utilisées
gen 		Con_ANTENATAL80 = (Score_Con_ANTENATAL >= `=round(0.80 * `total_Con_ANTENATAL')')
replace 	Con_ANTENATAL80 =. if Score_Con_ANTENATAL==0
label var	Con_ANTENATAL80 "Correct knowledge of antenatal care services at 80%"

gen 		Con_ANTENATAL70 = (Score_Con_ANTENATAL >= `=round(0.70 * `total_Con_ANTENATAL')')
replace 	Con_ANTENATAL70 =. if Score_Con_ANTENATAL==0
label var	Con_ANTENATAL70 "Correct knowledge of antenatal care services at 70%"

gen 		Con_ANTENATAL60 = (Score_Con_ANTENATAL >= `=round(0.60 * `total_Con_ANTENATAL')')
replace 	Con_ANTENATAL60 =. if Score_Con_ANTENATAL==0
label var	Con_ANTENATAL60 "Correct knowledge of antenatal care services at 60%"																

sum Score_Con_ANTENATAL
gen Score_Con_ANTENATAL_N=((Score_Con_ANTENATAL-r(min))/(r(max)-r(min)))*10		
label var Score_Con_ANTENATAL_N "Score de connaissance correcte des soins prénatales"



				
				*****************************************
				***  MATERNAL CARE/DELIVERY SERVICES  ***
				*****************************************


				
							

 foreach var of var S6_06_A S6_06_B S6_06_C S6_06_D S6_06_E S6_06_F S6_06_G S6_06_H S6_06_I S6_07_A S6_07_B S6_07_C S6_07_D S6_07_E S6_08_A S6_08_B S6_08_C S6_08_D S6_08_E S6_08_F S6_08_G S6_08_H S6_08_I S6_12_A S6_12_B S6_12_C S6_12_D S6_12_E S6_12_F S6_14_A S6_14_B S6_14_C S6_14_D S6_14_E S6_14_F S6_25_A S6_25_B S6_25_C S6_26_A S6_26_B S6_26_C S6_26_D S6_26_E S6_26_F S6_39_A S6_39_B S6_39_C S6_40_A S6_40_B S6_40_C S6_40_D S6_40_E S6_41_A S6_41_B S6_41_C S6_41_D S6_41_E S6_41_F S6_41_G S6_41_H S6_41_I S6_42_A S6_42_B S6_42_C S6_42_D S6_42_E S6_42_F S6_43_A S6_43_B S6_46_A S6_46_B S6_46_C S6_46_D S6_47_A S6_48_A S6_48_B S6_48_C S6_48_D S6_49_A S6_49_B S6_51_1 S6_52_1 S6_54_1 {

 gen `var'maternal = `var'

}

 foreach var of var S6_27 S6_28 S6_29 S6_45 S6_50 S6_53 {

 gen 	 `var'maternal = `var'
 replace `var'maternal =0 if `var'!=1
 replace `var'maternal =. if `var'==.

}				
				
				
		*Construction de la variable connaissance correcte des services des
		*soins prénatales. Elle revient à connaitre au moins 80%, 70% ou 60% des actes
		*et les interventions transcrit par les 66 questions liées aux soins
		*prénatales
				
	

egen 		Score_Con_maternal	=  rsum(*maternal)
local total_Con_maternal = 89 // Nombre total de questions utilisées
gen 		Con_maternal80 = (Score_Con_maternal >= `=round(0.80 * `total_Con_maternal')')
replace 	Con_maternal80 =. if Score_Con_maternal==0
label var	Con_maternal80 "Correct knowledge of Maternal care/delivery services at 80%"

gen 		Con_maternal70 = (Score_Con_maternal >= `=round(0.70 * `total_Con_maternal')')
replace 	Con_maternal70 =. if Score_Con_maternal==0
label var	Con_maternal70 "Correct knowledge of Maternal care/delivery services at 70%"																
				
gen 		Con_maternal60 = (Score_Con_maternal >= `=round(0.60 * `total_Con_maternal')')
replace 	Con_maternal60 =. if Score_Con_maternal==0
label var	Con_maternal60 "Correct knowledge of Maternal care/delivery services at 60%"				
				
sum Score_Con_maternal
gen Score_Con_maternal_N=((Score_Con_maternal-r(min))/(r(max)-r(min)))*10
label var Score_Con_maternal_N "Score de connaissance correcte des soins maternels/accouchement"
				
				

				
				************************
				***  POSTNATAL CARE  ***
				************************


				
							

 foreach var of var S6_55_A S6_55_B S6_55_C S6_55_D S6_55_E S6_56_A S6_56_B S6_56_C S6_56_D S6_56_E S6_61_A S6_61_B S6_61_C S6_61_D S6_61_E S6_61_F S6_61_G S6_64_A S6_64_B S6_64_C S6_64_D S6_64_E S6_64_F S6_65_1 S6_67_1 S6_68_A S6_68_B S6_68_C S6_69_A S6_69_B S6_69_C S6_69_D S6_69_E S6_69_F S6_69_G S6_69_H S6_69_je S6_69_J S6_69_K S6_70_A S6_70_B S6_70_C S6_73_A S6_73_B S6_73_C S6_73_D S6_73_E S6_73_F S6_74_A S6_74_B S6_74_C S6_74_D S6_74_E S6_76_A S6_76_B S6_76_C S6_76_D S6_77_A S6_77_B S6_77_C S6_77_D S6_78_A S6_78_B S6_78_C S6_78_D S6_80_A S6_80_B S6_82_A S6_82_B S6_82_C S6_82_D S6_82_E {

 gen `var'POSTNATAL = `var'

}

 foreach var of var S6_62 S6_63 S6_72 {

 gen 	 `var'POSTNATAL = `var'
 replace `var'POSTNATAL =0 if `var'!=1
 replace `var'POSTNATAL =. if `var'==.

}				
				
				
		*Construction de la variable connaissance correcte des services des
		*soins prénatales. Elle revient à connaitre au moins 80%, 70% ou 60% des actes
		*et les interventions transcrit par les 66 questions liées aux soins
		*prénatales
				
	

egen 		Score_Con_POSTNATAL	=  rsum(*POSTNATAL)
local total_Con_POSTNATAL = 75 // Nombre total de questions utilisées
gen 		Con_POSTNATAL80 = (Score_Con_POSTNATAL >= `=round(0.80 * `total_Con_POSTNATAL')')
replace 	Con_POSTNATAL80 =. if Score_Con_POSTNATAL==0
label var 	Con_POSTNATAL80 "Correct knowledge of POSTNATAL services at 80%"

gen 		Con_POSTNATAL70 = (Score_Con_POSTNATAL >= `=round(0.70 * `total_Con_POSTNATAL')')
replace 	Con_POSTNATAL70 =. if Score_Con_POSTNATAL==0
label var 	Con_POSTNATAL70 "Correct knowledge of POSTNATAL services at 70%"

gen 		Con_POSTNATAL60 = (Score_Con_POSTNATAL >= `=round(0.60 * `total_Con_POSTNATAL')')
replace 	Con_POSTNATAL60 =. if Score_Con_POSTNATAL==0
label var 	Con_POSTNATAL60 "Correct knowledge of POSTNATAL services at 60%"													

sum Score_Con_POSTNATAL
gen Score_Con_POSTNATAL_N=((Score_Con_POSTNATAL-r(min))/(r(max)-r(min)))*10
label var Score_Con_POSTNATAL_N "Score de connaissance correcte des soins postnatals"
				



*******INDICATEUR 2. Pourcentage de prestataires ayant une attitude favorable à
*******l'égard des soins maternels respectueux		
				
	
														
				
				
				
 foreach var of var S6_84a S6_84b S6_84c S6_84d S6_84e S6_84f S6_84g {

 gen 	 Attitude`var'SMNI = 	(`var'<= 2)
 replace Attitude`var'SMNI =. if `var'== .
 
}				
				
				
		*Construction de la variable L'attitude favorable à l'égard des soins
		*maternels respectueux. Elle revient à avoir une bonne opinion sur au
		*moins 80%, 70% ou 60% des 7 questions liées à la perception de la SMIN
				
				

egen 		Score_Attitude_SMNI	=  rsum(*SMNI)
local total_Attitude_SMNI = 7 // Nombre total de questions utilisées
gen 		Favorable_SMNI80 = (Score_Attitude_SMNI >= `=round(0.80 * `total_Attitude_SMNI')')
replace 	Favorable_SMNI80 =. if AttitudeS6_84aSMNI==. | AttitudeS6_84bSMNI==. | AttitudeS6_84cSMNI==. | AttitudeS6_84dSMNI==. | AttitudeS6_84eSMNI==. | AttitudeS6_84fSMNI==. | AttitudeS6_84gSMNI==.
label var	Favorable_SMNI80 "Positive attitude towards respectful maternal care at 80%"

gen 		Favorable_SMNI70 = (Score_Attitude_SMNI >= `=round(0.70 * `total_Attitude_SMNI')')
replace 	Favorable_SMNI70 =. if AttitudeS6_84aSMNI==. | AttitudeS6_84bSMNI==. | AttitudeS6_84cSMNI==. | AttitudeS6_84dSMNI==. | AttitudeS6_84eSMNI==. | AttitudeS6_84fSMNI==. | AttitudeS6_84gSMNI==.
label var	Favorable_SMNI70 "Positive attitude towards respectful maternal care at 70%"

gen 		Favorable_SMNI60 = (Score_Attitude_SMNI >= `=round(0.60 * `total_Attitude_SMNI')')
replace 	Favorable_SMNI60 =. if AttitudeS6_84aSMNI==. | AttitudeS6_84bSMNI==. | AttitudeS6_84cSMNI==. | AttitudeS6_84dSMNI==. | AttitudeS6_84eSMNI==. | AttitudeS6_84fSMNI==. | AttitudeS6_84gSMNI==.
label var	Favorable_SMNI60 "Positive attitude towards respectful maternal care at 60%"

sum Score_Attitude_SMNI
gen Score_Attitude_SMNI_N=((Score_Attitude_SMNI-r(min))/(r(max)-r(min)))*10		
label var Score_Attitude_SMNI_N "Score de l'attitude favorable à l'égard des soins maternels respectueux"




*******INDICATEUR 3. Pourcentage de prestataires ayant reçu une formation sur 
*******les services SMNI		
		
		

		
				**************************************
				***  PREPARATION A L'ACCOUCHEMENT  ***
				**************************************			

				
				
recode S2_15_1(1 2 3=1 Yes)(4 .=0 Non), gen(Accouchement)
label var Accouchement "Has received training in childbirth preparation and preparation for complications"
						
			
			
				************************************************
				***  DETECTION DES GROSSESSES A GROS RISQUE  ***
				************************************************
				
				
				
recode S2_15_2(1 2 3=1 Yes)(4 .=0 Non), gen(Grossesse)
label var Grossesse "Has received training in the detection of high-risk pregnancies and appropriate referral"

			
			
				*************************************
				***  PRISE EN CHARGE DE L'ANEMIE  ***
				*************************************
				
				

recode S2_15_3(1 2 3=1 Yes)(4 .=0 Non), gen(Anemie)
label var Anemie "Trained in the management of severe anemia with sucrose iron"
			
				
				
				*****************************
				***  PARTOGRAMME  ***
				*****************************				
				

recode S2_15_4(1 2 3=1 Yes)(4 .=0 Non), gen(Partogramme)
label var Partogramme "Has received Partogram training"









*********************CONSTRUCTION DES VARIABLES DE STRATIFICATIONS


*REGION																
gen 	Region	=	"DAKAR" 		if I1== 1
replace Region	=	"DIOURBEL" 		if I1== 2
replace Region	=	"FATICK" 		if I1== 3
replace Region	=	"KAFFRINE" 		if I1== 4
replace Region	=	"KAOLACK" 		if I1== 5
replace Region	=	"KEDOUGOU" 		if I1== 6
replace Region	=	"KOLDA" 		if I1== 7
replace Region	=	"LOUGA" 		if I1== 8
replace Region	=	"MATAM" 		if I1== 9
replace Region	=	"SAINTLOUIS" 	if I1== 10
replace Region	=	"SEDHIOU" 		if I1== 11
replace Region	=	"TAMBACOUNDA" 	if I1== 12
replace Region	=	"THIES" 		if I1== 13
replace Region	=	"ZIGUINCHOR" 	if I1== 14


tab Region, gen(Region)
rename Region1 	DAKAR
rename Region2 	DIOURBEL
rename Region3 	FATICK
rename Region4 	KAFFRINE
rename Region5 	KAOLACK
rename Region6 	KEDOUGOU
rename Region7 	KOLDA
rename Region8 	LOUGA
rename Region9 	MATAM
rename Region10 SAINTLOUIS
rename Region11 SEDHIOU
rename Region12 TAMBACOUNDA
rename Region13 THIES
rename Region14 ZIGUINCHOR


rename Region region



*TYPE DE STRUCTURE
gen 	Structure	= "Hospital" 		if I4==1
replace Structure	= "HealthCenter" 	if I4==2
replace Structure	= "HealthPost" 	if I4==3
tab Structure, gen(Structure)
rename Structure1 Hospital
rename Structure2 HealthCenter
rename Structure3 HealthPost

*MILIEU //Milieu de résidence
gen 	Place	= "Rural" 	if I5==1
replace Place	= "Urban" 	if I5==2
tab Place, gen(Place)
rename Place1 Rural
rename Place2 Urban

*SEXE


recode S2_3 (1 3 5 96=1 "Nurse")(2 4=2 "Midwife"), gen(Categorie)

// replace Categorie = 1	if S2_3a=="Médecin"
// replace Categorie = 1	if S2_3a=="Assistante"
// replace Categorie = 1	if S2_3a=="Aide infirmier"
// replace Categorie = 1	if S2_3a=="Agent sanitaire"
// replace Categorie = 1	if S2_3a=="Aide infirmiere"
// replace Categorie = 1	if S2_3a=="Aide infirmière"
// replace Categorie = 1	if S2_3a=="Infirmière breveté"
// replace Categorie = 1	if S2_3a=="Assistant Infirmier"
// replace Categorie = 1	if S2_3a=="Assistant infirmièr"
// replace Categorie = 1	if S2_3a=="Assistant infirmier"
// replace Categorie = 1	if S2_3a=="Infirmiere brevetée"
// replace Categorie = 1	if S2_3a=="Assistant infirmière"
// replace Categorie = 1	if S2_3a=="ASSISTANTE INFIRMIER"
// replace Categorie = 1	if S2_3a=="Assistante infirmièr"
// replace Categorie = 1	if S2_3a=="Assistante infirmier"
// replace Categorie = 1	if S2_3a=="Assistante d infimier"
// replace Categorie = 1	if S2_3a=="Assistante infirmiere"
// replace Categorie = 1	if S2_3a=="Assistante Infirmière"
// replace Categorie = 1	if S2_3a=="Assistante infirmière"
// replace Categorie = 1	if S2_3a=="Assistante  infirmière"
// replace Categorie = 1	if S2_3a=="Infirmier communautaire"
// replace Categorie = 1	if S2_3a=="Technicienne supérieure"
replace Categorie = 2	if S2_3a=="Sage femme communautaire"
// replace Categorie = 1	if S2_3a=="Assistant infirmier d Etat"
// replace Categorie = 1	if S2_3a=="Assistant infirmier d état"
// replace Categorie = 1	if S2_3a=="Assistant infirmier d'état"
// replace Categorie = 1	if S2_3a=="Assistant infirmièr d'état"
// replace Categorie = 1	if S2_3a=="Assistant infirmiere d'Etat"
// replace Categorie = 1	if S2_3a=="Assistant infirmière d'état"
// replace Categorie = 1	if S2_3a=="Assistante infirmier d'état"
// replace Categorie = 1	if S2_3a=="Assistante infirmière d'etat"
// replace Categorie = 1	if S2_3a=="Assistante Infirmière d'état"
// replace Categorie = 1	if S2_3a=="Assistante infirmière d'état"
// replace Categorie = 1	if S2_3a=="Assistant infirmier diplômé d'état"
// replace Categorie = 1	if S2_3a=="Assistant infirmiere d'Etat"
// replace Categorie = 1	if S2_3a=="96"
// replace Categorie = 1	if S2_3==96


ta Categorie, m



encode Structure,gen(hftype)

lab var Score_Attitude_INJECTABLES_N  "Attitude towards Injectables"

****
* Define your binary variables

local scores_vars " Score_Attitude_INJECTABLES_N " // Replace with your variable names

* Initialize Excel file
putexcel set "Attitude_practice.xlsx", sheet("Sheet12") replace

*Structure Categorie

/
collapse (percent) DIU_pre_correct70 INJECT_pre_correct70 IMPLANTS_pre_correct70 STERILFEM_pre_correct70,by(hftype Cate)
/
*attitude
collapse (mean) Score_Attitude_PF_N	Score_Attitude_DIU_N Score_Attitude_INJECTABLES_N Score_Attitude_IMPLANTS_N	Score_Attitude_PILULE_N	Score_Attitude_CONTRACEPURG_N Score_Attitude_PRESERVATFEM_N	Score_Attitude_STERILISFEM_N	Score_Attitude_STERILISMAS_N Score_Attitude_SMNI_N ,by(hftype Cate)

* Write headers
putexcel A1:d1 = "Attitude and Practice",bold merge hcenter border(bottom)
putexcel A2 = "Provider" B2 = "EPS"  c2 = "CS" d2 = "PS",bold border(bottom,double)

* Calculate proportions and export to Excel
local row = 3 // Start writing from row 2
foreach var of local score_vars {
    summarize `var' if hftype==1   
    local mean1 = r(mean)*1 // Store the mean

     summarize `var' if hftype==2
     local mean2 = r(mean)*1 // Store the mean
	
     summarize `var' if hftype==3
     local mean3 = r(mean)*1  // Store the mean
	 
     * Get variable label (or name if label is empty)
    local varlabel : variable label `var'
     if "`varlabel'" == "" local varlabel "`var'"
    
    * Write results to Excel
    putexcel A`row' = "`varlabel'" ,bold // Write variable name/label
    putexcel B`row' = `mean1', nformat(10.0) // Write proportion (3 decimal places)
    putexcel c`row' = `mean2', nformat(10.0) // Write proportion (3 decimal places)
    putexcel d`row' = `mean3', nformat(10.0) // Write proportion (3 decimal places)
    
    local ++row // Move to the next row
}







here

***********************PRODUCTION DES TABLEAUX SUR FORMATS EXCEL

			***CONNAISSANCE DES METHODES***
			
			
	****National
			
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("PF KNOWLEDGE") modify

* Définir les variables (indicateurs de la connaissance des méthodes de PF)
global var1 "DIU Injectables Preservatif_M Preservatif_F Contraception_Urg Pilules Implants Sterilisation_F Sterilisation_M Allaitement_Exclu"

* Ajouter le titre du tableau
putexcel A1 = "Table 1: Knowledge of family planning methods at the national level"

* Ajouter les en-têtes des colonnes
putexcel A2 = "Indicators" B2 = "Counts (Effectifs)" C2 = "Proportions (%)" D2 = "Total"

* Initialiser une ligne pour écrire les données
local row = 3

* Créer une table temporaire pour stocker les données des proportions
tempname prop_table
postfile `prop_table' str50 Indicator double Proportion using prop_data.dta, replace

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var1 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Calculer les effectifs et proportions
    tabulate `var', matcell(freq_`var') matrow(rnames_`var')

    * Vérifier si des données existent pour la modalité "1"
    if `=rowsof(freq_`var')' > 1 {
        * Calculer le total des effectifs pour les proportions
        scalar total_effectifs = 0
        forval i = 1/`=rowsof(freq_`var')' {
            scalar total_effectifs = total_effectifs + freq_`var'[`i', 1]
        }

        * Récupérer les données pour la modalité "1"
        local count1 = freq_`var'[2, 1]
        scalar proportion1 = (`count1' / total_effectifs) * 100

        * Formatage des proportions à 2 décimales
        local proportion_formatted : display %9.2f proportion1

        * Ajouter les données au fichier Excel
        putexcel A`row' = "`label'"
        putexcel B`row' = `count1'
        putexcel C`row' = "`proportion_formatted'"
        putexcel D`row' = total_effectifs

        * Stocker les données pour le graphique
        post `prop_table' ("`label'") (proportion1)

        * Passer à la ligne suivante
        local row = `row' + 1
    }
}

preserve

* Fermer le fichier temporaire
postclose `prop_table'

* Charger les données des proportions pour générer le graphique
use prop_data.dta, clear

* Générer un graphique en barres des proportions (horizontales)
graph hbar (asis) Proportion, over(Indicator, sort(1) descending) ///
    bar(1, color(blue)) ///
    title("Proportion of Family Planning Knowledge") ///
    ytitle("Proportion (%)") ///
    blabel(bar, format(%9.1f)) ///
    graphregion(margin(zero)) plotregion(margin(small)) // Réduction des marges

* Exporter le graphique en image PNG avec une taille réduite
graph export "PF_Knowledge_Graph.png", width(600) height(400) replace

* Insérer le graphique dans Excel avec une taille réduite
putexcel G1 = image("PF_Knowledge_Graph.png")

restore
	
****Région
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("PF KNOWLEDGE") modify

* Définir les variables d'analyse
global var1 "DIU Injectables Preservatif_M Preservatif_F Contraception_Urg Pilules Implants Sterilisation_F Sterilisation_M Allaitement_Exclu"
global regions "DAKAR DIOURBEL FATICK KAFFRINE KAOLACK KEDOUGOU KOLDA LOUGA MATAM SAINTLOUIS SEDHIOU TAMBACOUNDA THIES ZIGUINCHOR"

* Ajouter le titre du tableau
putexcel A15 = "Table 2: Knowledge of family planning methods by region"

* Ajouter les en-têtes des colonnes (régions)
putexcel A16 = "Indicators"

* Définir une fonction rclass pour convertir un nombre en lettre de colonne Excel
cap program drop num2col
program define num2col, rclass
    args colnum
    if `colnum' <= 26 {
        return local colname = char(64 + `colnum') // A-Z
    }
    else {
        return local colname = char(64 + int((`colnum' - 1) / 26)) + char(65 + mod((`colnum' - 1), 26)) // AA, AB, etc.
    }
end

* Initialiser la première colonne pour les régions (B = colonne 2)
local col = 2

foreach region in $regions {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la région
    putexcel `count_col_letter'16 = "`region' - Counts"
    putexcel `prop_col_letter'16 = "`region' - Proportions"
    putexcel `total_col_letter'16 = "`region' - Total"

    * Incrémenter de 3 pour passer à la prochaine région
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 17
local row = 17

* Créer un fichier temporaire pour stocker les proportions pour le graphique
tempname graph_data
postfile `graph_data' str50 Indicator str50 Region double Proportion using prop_graph.dta, replace

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var1 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les régions
    local col = 2  // Colonne de départ pour les effectifs des régions (B)

    * Boucler sur chaque région
    foreach region in $regions {
        * Filtrer les données pour la région actuelle
        preserve
        keep if region == "`region'"
        tabulate `var', matcell(freq_`var') matrow(rnames_`var')

        * Définir les valeurs par défaut (si aucune donnée)
        local count1 = "0"
        local proportion_formatted = "0"
        local total_effectifs = "0"

        * Vérifier si des données existent pour la modalité "1"
        if `=rowsof(freq_`var')' > 1 {
            * Calculer le total des effectifs pour toutes les modalités
            scalar total_effectifs = 0
            forval i = 1/`=rowsof(freq_`var')' {
                scalar total_effectifs = total_effectifs + freq_`var'[`i', 1]
            }

            * Récupérer les données pour la modalité "1"
            local count1 = freq_`var'[2, 1]
            scalar proportion1 = (`count1' / total_effectifs) * 100

            * Formatage des proportions à 2 décimales
            local proportion_formatted : display %9.2f proportion1

            * Vérifier si le total doit être inséré ou laissé avec "0"
            if total_effectifs > 0 {
                local total_effectifs_display = total_effectifs
            }
            else {
                local total_effectifs_display = "0"
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)
        
        num2col `=`col' + 1'
        local prop_col_letter = r(colname)
        
        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs ou un tiret "-" si vide
        putexcel `count_col_letter'`row' = "`count1'"
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = "`total_effectifs_display'"

        * Stocker les données pour le graphique si elles existent
        if "`count1'" != "-" {
            post `graph_data' ("`label'") ("`region'") (proportion1)
        }

        restore
        local col = `col' + 3  // Passer à la prochaine région (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}

	
		****Structures

* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("PF KNOWLEDGE") modify

* Définir les variables d'analyse
global var1 "DIU Injectables Preservatif_M Preservatif_F Contraception_Urg Pilules Implants Sterilisation_F Sterilisation_M Allaitement_Exclu"
global structures "Hospital HealthCenter HealthPost"  // Liste des structures de santé

* Ajouter le titre du tableau à partir de la ligne 30
putexcel A30 = "Table 3: Knowledge of family planning methods by structure of health facilities"

* Ajouter les en-têtes des colonnes (structures)
putexcel A31 = "Indicators"

* Initialiser la colonne pour les structures (B = colonne 2)
local col = 2

foreach structure in $structures {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la structure
    putexcel `count_col_letter'31 = "`structure' - Counts"
    putexcel `prop_col_letter'31 = "`structure' - Proportions (%)"
    putexcel `total_col_letter'31 = "`structure' - Total"

    * Incrémenter de 3 pour passer à la structure suivante
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 32
local row = 32

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var1 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les structures
    local col = 2  // Colonne de départ pour les structures (B)

    * Boucler sur chaque structure
    foreach structure in $structures {
        * Filtrer les données pour la structure actuelle
        preserve
        keep if Structure == "`structure'"
        tabulate `var', matcell(freq_`var') matrow(rnames_`var')

        * Définir les valeurs par défaut (si aucune donnée)
        local count1 = "0"
        local proportion_formatted = "0"
        local total_effectifs = "0"

        * Vérifier si des données existent pour la modalité "1"
        if `=rowsof(freq_`var')' > 1 {
            * Calculer le total des effectifs pour toutes les modalités
            scalar total_effectifs = 0
            forval i = 1/`=rowsof(freq_`var')' {
                scalar total_effectifs = total_effectifs + freq_`var'[`i', 1]
            }

            * Récupérer les données pour la modalité "1"
            local count1 = freq_`var'[2, 1]
            scalar proportion1 = (`count1' / total_effectifs) * 100

            * Formatage des proportions à 2 décimales
            local proportion_formatted : display %9.2f proportion1

            * Vérifier si le total doit être inséré ou laissé avec "0"
            if total_effectifs > 0 {
                local total_effectifs_display = total_effectifs
            }
            else {
                local total_effectifs_display = "0"
            }
        }

        * Définir les colonnes pour les effectifs, proportions et total
        num2col `col'
        local count_col_letter = r(colname)

        num2col `=`col' + 1'
        local prop_col_letter = r(colname)

        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs ou un tiret "-" si vide
        putexcel `count_col_letter'`row' = "`count1'"
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = "`total_effectifs_display'"

        restore
        local col = `col' + 3  // Passer à la structure suivante
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	
	
	
	
	****Place of residence

	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("PF KNOWLEDGE") modify

* Définir les variables d'analyse
global var1 "DIU Injectables Preservatif_M Preservatif_F Contraception_Urg Pilules Implants Sterilisation_F Sterilisation_M Allaitement_Exclu"
global places "Rural Urban"  // Liste des lieux

* Ajouter le titre du tableau à partir de la ligne 45
putexcel A45 = "Table 4: Knowledge of family planning methods by place (Rural, Urban)"

* Ajouter les en-têtes des colonnes (places)
putexcel A46 = "Indicators"

* Initialiser la colonne pour les lieux (B = colonne 2)
local col = 2

foreach place in $places {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour le lieu
    putexcel `count_col_letter'46 = "`place' - Counts"
    putexcel `prop_col_letter'46 = "`place' - Proportions (%)"
    putexcel `total_col_letter'46 = "`place' - Total"

    * Incrémenter de 3 pour passer au prochain lieu
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 47
local row = 47

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var1 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les lieux
    local col = 2  // Colonne de départ pour les lieux (B)

    * Boucler sur chaque lieu
    foreach place in $places {
        * Filtrer les données pour le lieu actuel
        preserve
        keep if Place == "`place'"  // Assurez-vous que la variable Place contient "Rural" ou "Urban"
        tabulate `var', matcell(freq_`var') matrow(rnames_`var')

        * Définir les valeurs par défaut (si aucune donnée)
        local count1 = "0"
        local proportion1 = "0"
        local total_effectifs = "0"

        * Vérifier si des données existent pour la modalité "1"
        if `=rowsof(freq_`var')' > 1 {
            * Calculer le total des effectifs pour toutes les modalités
            scalar total_effectifs = 0
            forval i = 1/`=rowsof(freq_`var')' {
                scalar total_effectifs = total_effectifs + freq_`var'[`i', 1]
            }

            * Récupérer les données pour la modalité "1"
            local count1 = freq_`var'[2, 1]
            scalar proportion1 = (`count1' / total_effectifs) * 100

            * Formatage des proportions à 2 décimales
            local proportion_formatted : display %9.2f proportion1

            * Vérifier si le total doit être inséré ou laissé avec "0"
            if total_effectifs > 0 {
                local total_effectifs_display = total_effectifs
            }
            else {
                local total_effectifs_display = "0"
            }
        }

        * Définir les colonnes pour les effectifs, proportions et total
        num2col `col'
        local count_col_letter = r(colname)

        num2col `=`col' + 1'
        local prop_col_letter = r(colname)

        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs ou un tiret "-" si vide
        putexcel `count_col_letter'`row' = "`count1'"
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = "`total_effectifs_display'"

        restore
        local col = `col' + 3  // Passer au lieu suivant
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	
	


			***CONNAISSANCE CORRECTE A 80%***		
			
	****National
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("PF CORRECT KNOWLEDGE (80%)") modify

* Définir les variables (indicateurs de la connaissance des méthodes de PF)
global var2 "DIU_correct80 INJECTABLE_correct80 IMPLANTS_correct80 STERILFEM_correct80 STERILMAS_correct80"

* Ajouter le titre du tableau
putexcel A1 = "Table 1: Correct knowledge of family planning methods at the national level"

* Ajouter les en-têtes des colonnes
putexcel A2 = "Indicators" B2 = "Counts (Effectifs)" C2 = "Proportions (%)" D2 = "Total"

* Initialiser une ligne pour écrire les données
local row = 3

* Créer une table temporaire pour stocker les données des proportions
tempname prop_table
postfile `prop_table' str50 Indicator double Proportion using prop_data.dta, replace

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Calculer les effectifs et proportions
    tabulate `var', matcell(freq_`var') matrow(rnames_`var')

    * Initialiser les valeurs par défaut
    local count1 = 0
    scalar proportion1 = 0
    scalar total_effectifs = 0

    * Calculer le total des effectifs (même s'il n'y a qu'une seule modalité)
    forval i = 1/`=rowsof(freq_`var')' {
        scalar total_effectifs = total_effectifs + freq_`var'[`i', 1]
    }

    * Vérifier si la modalité "1" existe
    local modalite1_exists = 0
    forval i = 1/`=rowsof(rnames_`var')' {
        if rnames_`var'[`i', 1] == 1 {
            local modalite1_exists = 1
            local count1 = freq_`var'[`i', 1]
            scalar proportion1 = (`count1' / total_effectifs) * 100
        }
    }

    * Si la modalité "1" n'existe pas, la proportion est 0
    if `modalite1_exists' == 0 {
        scalar proportion1 = 0
    }

    * Formatage des proportions à 2 décimales
    local proportion_formatted : display %9.2f proportion1

    * Ajouter les données au fichier Excel
    putexcel A`row' = "`label'"
    putexcel B`row' = `count1'
    putexcel C`row' = "`proportion_formatted'"
    putexcel D`row' = total_effectifs

    * Stocker les données pour le graphique
    post `prop_table' ("`label'") (proportion1)

    * Passer à la ligne suivante
    local row = `row' + 1
}

preserve

* Fermer le fichier temporaire
postclose `prop_table'

* Charger les données des proportions pour générer le graphique
use prop_data.dta, clear

* Générer un graphique en barres des proportions (horizontales)
graph hbar (asis) Proportion, over(Indicator, sort(1) descending) ///
    bar(1, color(blue)) ///
    title("Proportion of Family Planning Knowledge") ///
    ytitle("Proportion (%)") ///
    blabel(bar, format(%9.1f)) ///
    graphregion(margin(zero)) plotregion(margin(small)) // Réduction des marges

* Exporter le graphique en image PNG avec une taille réduite
graph export "PF_Knowledge_Graph1.png", width(600) height(400) replace

* Insérer le graphique dans Excel avec une taille réduite
putexcel G1 = image("PF_Knowledge_Graph1.png")

restore	


	
	****Région
	
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("PF CORRECT KNOWLEDGE (80%)") modify

* Définir les variables d'analyse
global var2 "DIU_correct80 INJECTABLE_correct80 IMPLANTS_correct80 STERILFEM_correct80 STERILMAS_correct80"
global regions "DAKAR DIOURBEL FATICK KAFFRINE KAOLACK KEDOUGOU KOLDA LOUGA MATAM SAINTLOUIS SEDHIOU TAMBACOUNDA THIES ZIGUINCHOR"

* Ajouter le titre du tableau
putexcel A15 = "Table 2: Correct knowledge of family planning methods by region"

* Ajouter les en-têtes des colonnes (régions)
putexcel A16 = "Indicators"

* Initialiser la première colonne pour les régions (B = colonne 2)
local col = 2

foreach region in $regions {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la région
    putexcel `count_col_letter'16 = "`region' - Counts"
    putexcel `prop_col_letter'16 = "`region' - Proportions"
    putexcel `total_col_letter'16 = "`region' - Total"

    * Incrémenter de 3 pour passer à la prochaine région
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 17
local row = 17

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les régions
    local col = 2  // Colonne de départ pour les effectifs des régions (B)

    * Boucler sur chaque région
    foreach region in $regions {
        * Filtrer les données pour la région actuelle
        preserve
        keep if region == "`region'"
        
        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)
        
        num2col `=`col' + 1'
        local prop_col_letter = r(colname)
        
        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer à la prochaine région (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	
	
	

	
	****Structures	

	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("PF CORRECT KNOWLEDGE (80%)") modify

* Définir les variables d'analyse
global var2 "DIU_correct80 INJECTABLE_correct80 IMPLANTS_correct80 STERILFEM_correct80 STERILMAS_correct80"
global structures "Hospital HealthCenter HealthPost"  // Liste des structures de santé

* Ajouter le titre du tableau à partir de la ligne 30
putexcel A30 = "Table 3: Correct knowledge of family planning methods by structure of health facilities"

* Ajouter les en-têtes des colonnes (structures)
putexcel A31 = "Indicators"

* Initialiser la première colonne pour les structures (B = colonne 2)
local col = 2

foreach structure in $structures {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la structure
    putexcel `count_col_letter'31 = "`structure' - Counts"
    putexcel `prop_col_letter'31 = "`structure' - Proportions (%)"
    putexcel `total_col_letter'31 = "`structure' - Total"

    * Incrémenter de 3 pour passer à la structure suivante
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 32
local row = 32

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les structures
    local col = 2  // Colonne de départ pour les structures (B)

    * Boucler sur chaque structure
    foreach structure in $structures {
        * Filtrer les données pour la structure actuelle
        preserve
        keep if Structure == "`structure'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)
        
        num2col `=`col' + 1'
        local prop_col_letter = r(colname)
        
        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer à la prochaine structure (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}

	
	
	****Place of residence
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("PF CORRECT KNOWLEDGE (80%)") modify

* Définir les variables d'analyse
global var2 "DIU_correct80 INJECTABLE_correct80 IMPLANTS_correct80 STERILFEM_correct80 STERILMAS_correct80"
global places "Rural Urban"  // Liste des lieux

* Ajouter le titre du tableau à partir de la ligne 30
putexcel A45 = "Table 3: Correct knowledge of family planning methods by place (Rural, Urban)"

* Ajouter les en-têtes des colonnes (lieux)
putexcel A46 = "Indicators"

* Initialiser la première colonne pour les lieux (B = colonne 2)
local col = 2

foreach place in $places {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour chaque lieu
    putexcel `count_col_letter'46 = "`place' - Counts"
    putexcel `prop_col_letter'46 = "`place' - Proportions (%)"
    putexcel `total_col_letter'46 = "`place' - Total"

    * Incrémenter de 3 pour passer au prochain lieu
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 47
local row = 47

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les lieux
    local col = 2  // Colonne de départ pour les lieux (B)

    * Boucler sur chaque lieu
    foreach place in $places {
        * Filtrer les données pour le lieu actuel
        preserve
        keep if Place == "`place'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)

        num2col `=`col' + 1'
        local prop_col_letter = r(colname)

        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer au prochain lieu (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	
	
	
	
	
	
	
	
	
	
			***CONNAISSANCE CORRECTE A 70%***		


			
			
			
	****National
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("PF CORRECT KNOWLEDGE (70%)") modify

* Définir les variables (indicateurs de la connaissance des méthodes de PF)
global var2 "DIU_correct70 INJECTABLE_correct70 IMPLANTS_correct70 STERILFEM_correct70 STERILMAS_correct70"

* Ajouter le titre du tableau
putexcel A1 = "Table 1: Correct knowledge of family planning methods at the national level"

* Ajouter les en-têtes des colonnes
putexcel A2 = "Indicators" B2 = "Counts (Effectifs)" C2 = "Proportions (%)" D2 = "Total"

* Initialiser une ligne pour écrire les données
local row = 3

* Créer une table temporaire pour stocker les données des proportions
tempname prop_table
postfile `prop_table' str50 Indicator double Proportion using prop_data.dta, replace

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Calculer les effectifs et proportions
    tabulate `var', matcell(freq_`var') matrow(rnames_`var')

    * Initialiser les valeurs par défaut
    local count1 = 0
    scalar proportion1 = 0
    scalar total_effectifs = 0

    * Calculer le total des effectifs (même s'il n'y a qu'une seule modalité)
    forval i = 1/`=rowsof(freq_`var')' {
        scalar total_effectifs = total_effectifs + freq_`var'[`i', 1]
    }

    * Vérifier si la modalité "1" existe
    local modalite1_exists = 0
    forval i = 1/`=rowsof(rnames_`var')' {
        if rnames_`var'[`i', 1] == 1 {
            local modalite1_exists = 1
            local count1 = freq_`var'[`i', 1]
            scalar proportion1 = (`count1' / total_effectifs) * 100
        }
    }

    * Si la modalité "1" n'existe pas, la proportion est 0
    if `modalite1_exists' == 0 {
        scalar proportion1 = 0
    }

    * Formatage des proportions à 2 décimales
    local proportion_formatted : display %9.2f proportion1

    * Ajouter les données au fichier Excel
    putexcel A`row' = "`label'"
    putexcel B`row' = `count1'
    putexcel C`row' = "`proportion_formatted'"
    putexcel D`row' = total_effectifs

    * Stocker les données pour le graphique
    post `prop_table' ("`label'") (proportion1)

    * Passer à la ligne suivante
    local row = `row' + 1
}

preserve

* Fermer le fichier temporaire
postclose `prop_table'

* Charger les données des proportions pour générer le graphique
use prop_data.dta, clear

* Générer un graphique en barres des proportions (horizontales)
graph hbar (asis) Proportion, over(Indicator, sort(1) descending) ///
    bar(1, color(blue)) ///
    title("Proportion of Family Planning Knowledge") ///
    ytitle("Proportion (%)") ///
    blabel(bar, format(%9.1f)) ///
    graphregion(margin(zero)) plotregion(margin(small)) // Réduction des marges

* Exporter le graphique en image PNG avec une taille réduite
graph export "PF_Knowledge_Graph1.png", width(600) height(400) replace

* Insérer le graphique dans Excel avec une taille réduite
putexcel G1 = image("PF_Knowledge_Graph1.png")

restore	


	
	****Région
	
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("PF CORRECT KNOWLEDGE (70%)") modify

* Définir les variables d'analyse
global var2 "DIU_correct70 INJECTABLE_correct70 IMPLANTS_correct70 STERILFEM_correct70 STERILMAS_correct70"
global regions "DAKAR DIOURBEL FATICK KAFFRINE KAOLACK KEDOUGOU KOLDA LOUGA MATAM SAINTLOUIS SEDHIOU TAMBACOUNDA THIES ZIGUINCHOR"

* Ajouter le titre du tableau
putexcel A15 = "Table 2: Correct knowledge of family planning methods by region"

* Ajouter les en-têtes des colonnes (régions)
putexcel A16 = "Indicators"

* Initialiser la première colonne pour les régions (B = colonne 2)
local col = 2

foreach region in $regions {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la région
    putexcel `count_col_letter'16 = "`region' - Counts"
    putexcel `prop_col_letter'16 = "`region' - Proportions"
    putexcel `total_col_letter'16 = "`region' - Total"

    * Incrémenter de 3 pour passer à la prochaine région
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 17
local row = 17

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les régions
    local col = 2  // Colonne de départ pour les effectifs des régions (B)

    * Boucler sur chaque région
    foreach region in $regions {
        * Filtrer les données pour la région actuelle
        preserve
        keep if region == "`region'"
        
        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)
        
        num2col `=`col' + 1'
        local prop_col_letter = r(colname)
        
        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer à la prochaine région (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	
	
	

	
	****Structures	

	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("PF CORRECT KNOWLEDGE (70%)") modify

* Définir les variables d'analyse
global var2 "DIU_correct70 INJECTABLE_correct70 IMPLANTS_correct70 STERILFEM_correct70 STERILMAS_correct70"
global structures "Hospital HealthCenter HealthPost"  // Liste des structures de santé

* Ajouter le titre du tableau à partir de la ligne 30
putexcel A30 = "Table 3: Correct knowledge of family planning methods by structure of health facilities"

* Ajouter les en-têtes des colonnes (structures)
putexcel A31 = "Indicators"

* Initialiser la première colonne pour les structures (B = colonne 2)
local col = 2

foreach structure in $structures {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la structure
    putexcel `count_col_letter'31 = "`structure' - Counts"
    putexcel `prop_col_letter'31 = "`structure' - Proportions (%)"
    putexcel `total_col_letter'31 = "`structure' - Total"

    * Incrémenter de 3 pour passer à la structure suivante
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 32
local row = 32

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les structures
    local col = 2  // Colonne de départ pour les structures (B)

    * Boucler sur chaque structure
    foreach structure in $structures {
        * Filtrer les données pour la structure actuelle
        preserve
        keep if Structure == "`structure'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)
        
        num2col `=`col' + 1'
        local prop_col_letter = r(colname)
        
        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer à la prochaine structure (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}

	
	
	****Place of residence
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("PF CORRECT KNOWLEDGE (70%)") modify

* Définir les variables d'analyse
global var2 "DIU_correct70 INJECTABLE_correct70 IMPLANTS_correct70 STERILFEM_correct70 STERILMAS_correct70"
global places "Rural Urban"  // Liste des lieux

* Ajouter le titre du tableau à partir de la ligne 30
putexcel A45 = "Table 3: Correct knowledge of family planning methods by place (Rural, Urban)"

* Ajouter les en-têtes des colonnes (lieux)
putexcel A46 = "Indicators"

* Initialiser la première colonne pour les lieux (B = colonne 2)
local col = 2

foreach place in $places {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour chaque lieu
    putexcel `count_col_letter'46 = "`place' - Counts"
    putexcel `prop_col_letter'46 = "`place' - Proportions (%)"
    putexcel `total_col_letter'46 = "`place' - Total"

    * Incrémenter de 3 pour passer au prochain lieu
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 47
local row = 47

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les lieux
    local col = 2  // Colonne de départ pour les lieux (B)

    * Boucler sur chaque lieu
    foreach place in $places {
        * Filtrer les données pour le lieu actuel
        preserve
        keep if Place == "`place'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)

        num2col `=`col' + 1'
        local prop_col_letter = r(colname)

        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer au prochain lieu (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	
	
	
				
			
			
			
			
			
			
			***CONNAISSANCE CORRECTE A 60%***		
			
			
				
			
	****National
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("PF CORRECT KNOWLEDGE (60%)") modify

* Définir les variables (indicateurs de la connaissance des méthodes de PF)
global var2 "DIU_correct60 INJECTABLE_correct60 IMPLANTS_correct60 STERILFEM_correct60 STERILMAS_correct60"

* Ajouter le titre du tableau
putexcel A1 = "Table 1: Correct knowledge of family planning methods at the national level"

* Ajouter les en-têtes des colonnes
putexcel A2 = "Indicators" B2 = "Counts (Effectifs)" C2 = "Proportions (%)" D2 = "Total"

* Initialiser une ligne pour écrire les données
local row = 3

* Créer une table temporaire pour stocker les données des proportions
tempname prop_table
postfile `prop_table' str50 Indicator double Proportion using prop_data.dta, replace

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Calculer les effectifs et proportions
    tabulate `var', matcell(freq_`var') matrow(rnames_`var')

    * Initialiser les valeurs par défaut
    local count1 = 0
    scalar proportion1 = 0
    scalar total_effectifs = 0

    * Calculer le total des effectifs (même s'il n'y a qu'une seule modalité)
    forval i = 1/`=rowsof(freq_`var')' {
        scalar total_effectifs = total_effectifs + freq_`var'[`i', 1]
    }

    * Vérifier si la modalité "1" existe
    local modalite1_exists = 0
    forval i = 1/`=rowsof(rnames_`var')' {
        if rnames_`var'[`i', 1] == 1 {
            local modalite1_exists = 1
            local count1 = freq_`var'[`i', 1]
            scalar proportion1 = (`count1' / total_effectifs) * 100
        }
    }

    * Si la modalité "1" n'existe pas, la proportion est 0
    if `modalite1_exists' == 0 {
        scalar proportion1 = 0
    }

    * Formatage des proportions à 2 décimales
    local proportion_formatted : display %9.2f proportion1

    * Ajouter les données au fichier Excel
    putexcel A`row' = "`label'"
    putexcel B`row' = `count1'
    putexcel C`row' = "`proportion_formatted'"
    putexcel D`row' = total_effectifs

    * Stocker les données pour le graphique
    post `prop_table' ("`label'") (proportion1)

    * Passer à la ligne suivante
    local row = `row' + 1
}

preserve

* Fermer le fichier temporaire
postclose `prop_table'

* Charger les données des proportions pour générer le graphique
use prop_data.dta, clear

* Générer un graphique en barres des proportions (horizontales)
graph hbar (asis) Proportion, over(Indicator, sort(1) descending) ///
    bar(1, color(blue)) ///
    title("Proportion of Family Planning Knowledge") ///
    ytitle("Proportion (%)") ///
    blabel(bar, format(%9.1f)) ///
    graphregion(margin(zero)) plotregion(margin(small)) // Réduction des marges

* Exporter le graphique en image PNG avec une taille réduite
graph export "PF_Knowledge_Graph1.png", width(600) height(400) replace

* Insérer le graphique dans Excel avec une taille réduite
putexcel G1 = image("PF_Knowledge_Graph1.png")

restore	


	
	****Région
	
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("PF CORRECT KNOWLEDGE (60%)") modify

* Définir les variables d'analyse
global var2 "DIU_correct60 INJECTABLE_correct60 IMPLANTS_correct60 STERILFEM_correct60 STERILMAS_correct60"
global regions "DAKAR DIOURBEL FATICK KAFFRINE KAOLACK KEDOUGOU KOLDA LOUGA MATAM SAINTLOUIS SEDHIOU TAMBACOUNDA THIES ZIGUINCHOR"

* Ajouter le titre du tableau
putexcel A15 = "Table 2: Correct knowledge of family planning methods by region"

* Ajouter les en-têtes des colonnes (régions)
putexcel A16 = "Indicators"

* Initialiser la première colonne pour les régions (B = colonne 2)
local col = 2

foreach region in $regions {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la région
    putexcel `count_col_letter'16 = "`region' - Counts"
    putexcel `prop_col_letter'16 = "`region' - Proportions"
    putexcel `total_col_letter'16 = "`region' - Total"

    * Incrémenter de 3 pour passer à la prochaine région
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 17
local row = 17

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les régions
    local col = 2  // Colonne de départ pour les effectifs des régions (B)

    * Boucler sur chaque région
    foreach region in $regions {
        * Filtrer les données pour la région actuelle
        preserve
        keep if region == "`region'"
        
        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)
        
        num2col `=`col' + 1'
        local prop_col_letter = r(colname)
        
        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer à la prochaine région (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	
	
	

	
	****Structures	

	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("PF CORRECT KNOWLEDGE (60%)") modify

* Définir les variables d'analyse
global var2 "DIU_correct60 INJECTABLE_correct60 IMPLANTS_correct60 STERILFEM_correct60 STERILMAS_correct60"
global structures "Hospital HealthCenter HealthPost"  // Liste des structures de santé

* Ajouter le titre du tableau à partir de la ligne 30
putexcel A30 = "Table 3: Correct knowledge of family planning methods by structure of health facilities"

* Ajouter les en-têtes des colonnes (structures)
putexcel A31 = "Indicators"

* Initialiser la première colonne pour les structures (B = colonne 2)
local col = 2

foreach structure in $structures {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la structure
    putexcel `count_col_letter'31 = "`structure' - Counts"
    putexcel `prop_col_letter'31 = "`structure' - Proportions (%)"
    putexcel `total_col_letter'31 = "`structure' - Total"

    * Incrémenter de 3 pour passer à la structure suivante
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 32
local row = 32

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les structures
    local col = 2  // Colonne de départ pour les structures (B)

    * Boucler sur chaque structure
    foreach structure in $structures {
        * Filtrer les données pour la structure actuelle
        preserve
        keep if Structure == "`structure'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)
        
        num2col `=`col' + 1'
        local prop_col_letter = r(colname)
        
        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer à la prochaine structure (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}

	
	
	****Place of residence
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("PF CORRECT KNOWLEDGE (60%)") modify

* Définir les variables d'analyse
global var2 "DIU_correct60 INJECTABLE_correct60 IMPLANTS_correct60 STERILFEM_correct60 STERILMAS_correct60"
global places "Rural Urban"  // Liste des lieux

* Ajouter le titre du tableau à partir de la ligne 30
putexcel A45 = "Table 3: Correct knowledge of family planning methods by place (Rural, Urban)"

* Ajouter les en-têtes des colonnes (lieux)
putexcel A46 = "Indicators"

* Initialiser la première colonne pour les lieux (B = colonne 2)
local col = 2

foreach place in $places {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour chaque lieu
    putexcel `count_col_letter'46 = "`place' - Counts"
    putexcel `prop_col_letter'46 = "`place' - Proportions (%)"
    putexcel `total_col_letter'46 = "`place' - Total"

    * Incrémenter de 3 pour passer au prochain lieu
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 47
local row = 47

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les lieux
    local col = 2  // Colonne de départ pour les lieux (B)

    * Boucler sur chaque lieu
    foreach place in $places {
        * Filtrer les données pour le lieu actuel
        preserve
        keep if Place == "`place'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)

        num2col `=`col' + 1'
        local prop_col_letter = r(colname)

        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer au prochain lieu (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	
	
	
				
			***CONNAISSANCE CORRECTE (SCORE NORMALISE)
			
			
			
	****National

	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("SCORE OF CORRECT KNOWLEDGE") modify

* Définir les variables des scores à analyser
global var2 "Score_con_DIU_N Score_con_INJECTABLE_N Score_con_IMPLANTS_N Score_con_STERILFEM_N Score_con_STERILMAS_N"

* Ajouter le titre du tableau
putexcel A1 = "Table 1: Average scores of correct knowledge of family planning methods"

* Ajouter les en-têtes des colonnes
putexcel A2 = "Indicators" B2 = "Mean Score" C2 = "Standard Deviation" D2 = "Number of Observations"

* Initialiser une ligne pour écrire les données
local row = 3

* Créer une table temporaire pour stocker les données pour le graphique
tempname graph_data
postfile `graph_data' str50 Indicator double Mean double Std_Dev double N using prop_graph.dta, replace

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Calculer la moyenne, l'écart-type et le nombre d'observations
    quietly summarize `var'

    local mean_score = r(mean)
    local std_dev = r(sd)
    local num_obs = r(N)

    * Formatage des valeurs pour Excel
    local mean_formatted : display %9.2f `mean_score'
    local std_dev_formatted : display %9.2f `std_dev'

    * Ajouter les données au fichier Excel
    putexcel A`row' = "`label'"
    putexcel B`row' = `mean_formatted'
    putexcel C`row' = `std_dev_formatted'
    putexcel D`row' = `num_obs'

    * Stocker les données pour le graphique
    post `graph_data' ("`label'") (`mean_score') (`std_dev') (`num_obs')

    * Passer à la ligne suivante
    local row = `row' + 1
}

preserve

* Fermer le fichier temporaire
postclose `graph_data'

* Charger les données pour générer le Bar Chart
use prop_graph.dta, clear

* Vérifier si les données existent avant d'afficher le graphique
count if !missing(Mean)
if r(N) == 0 {
    display "Aucune donnée disponible pour le graphique."
    exit
}

* Générer un `bar chart` pour les moyennes des scores
graph hbar (mean) Mean, over(Indicator, sort(1) descending) ///
    bar(1, color(blue)) ///
    title("Average Scores of Correct Knowledge by Indicator") ///
    ytitle("Mean Score") ///
    blabel(bar, format(%9.2f)) ///
    graphregion(margin(zero)) plotregion(margin(small)) // Réduction des marges

* Exporter le graphique en image PNG avec une taille réduite
graph export "PF_Knowledge_Graph_Bar.png", width(600) height(400) replace

* Insérer le graphique dans Excel sous la table
local graph_row = `row' + 2  // Position du graphique après le tableau
putexcel I1 = image("PF_Knowledge_Graph_Bar.png")

restore	

* Message de confirmation
display "Les résultats et le graphique Bar Chart ont été exportés dans 'NURSES&MIDWIVES.xlsx' !"	


	
	****Région
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("SCORE OF CORRECT KNOWLEDGE") modify

* Définir les variables des scores à analyser
global var2 "Score_con_DIU_N Score_con_INJECTABLE_N Score_con_IMPLANTS_N Score_con_STERILFEM_N Score_con_STERILMAS_N"
global regions "DAKAR DIOURBEL FATICK KAFFRINE KAOLACK KEDOUGOU KOLDA LOUGA MATAM SAINTLOUIS SEDHIOU TAMBACOUNDA THIES ZIGUINCHOR"

* Ajouter le titre du tableau
putexcel A15 = "Table 2: Average scores of correct knowledge of family planning methods by region"

* Ajouter les en-têtes des colonnes (régions)
putexcel A16 = "Indicators"

* Initialiser la première colonne pour les régions (B = colonne 2)
local col = 2

foreach region in $regions {
    * Définir les colonnes pour Moyenne, Écart-type et Nombre d'observations
    num2col `col'
    local mean_col_letter = r(colname)

    num2col `=`col' + 1'
    local std_col_letter = r(colname)

    num2col `=`col' + 2'
    local n_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la région
    putexcel `mean_col_letter'16 = "`region' - Mean Score"
    putexcel `std_col_letter'16 = "`region' - Std Dev"
    putexcel `n_col_letter'16 = "`region' - N"

    * Incrémenter de 3 pour passer à la prochaine région
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 17
local row = 17

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les régions
    local col = 2  // Colonne de départ pour les régions (B)

    * Boucler sur chaque région
    foreach region in $regions {
        * Filtrer les données pour la région actuelle
        preserve
        keep if region == "`region'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" aux valeurs
            local mean_score = 0
            local std_dev = 0
            local num_obs = 0
        }
        else {
            * Calculer la moyenne, l'écart-type et le nombre d'observations
            quietly summarize `var'

            local mean_score = r(mean)
            local std_dev = r(sd)
            local num_obs = r(N)
        }

        * Formatage des valeurs pour Excel
        local mean_formatted : display %9.2f `mean_score'
        local std_dev_formatted : display %9.2f `std_dev'

        * Définir les colonnes pour les scores
        num2col `col'
        local mean_col_letter = r(colname)

        num2col `=`col' + 1'
        local std_col_letter = r(colname)

        num2col `=`col' + 2'
        local n_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `mean_col_letter'`row' = `mean_formatted'
        putexcel `std_col_letter'`row' = "`std_dev_formatted'"
        putexcel `n_col_letter'`row' = `num_obs'

        restore
        local col = `col' + 3  // Passer à la prochaine région
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}

	
	
	****Structures	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("SCORE OF CORRECT KNOWLEDGE") modify

* Définir les variables des scores à analyser
global var2 "Score_con_DIU_N Score_con_INJECTABLE_N Score_con_IMPLANTS_N Score_con_STERILFEM_N Score_con_STERILMAS_N"
global structures "Hospital HealthCenter HealthPost"  // Liste des structures de santé

* Ajouter le titre du tableau
putexcel A35 = "Table 2: Average scores of correct knowledge of family planning methods by structure"

* Ajouter les en-têtes des colonnes (structures)
putexcel A36 = "Indicators"

* Initialiser la première colonne pour les structures (B = colonne 2)
local col = 2

foreach structure in $structures {
    * Définir les colonnes pour Moyenne, Écart-type et Nombre d'observations
    num2col `col'
    local mean_col_letter = r(colname)

    num2col `=`col' + 1'
    local std_col_letter = r(colname)

    num2col `=`col' + 2'
    local n_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la structure
    putexcel `mean_col_letter'36 = "`structure' - Mean Score"
    putexcel `std_col_letter'36 = "`structure' - Std Dev"
    putexcel `n_col_letter'36 = "`structure' - N"

    * Incrémenter de 3 pour passer à la prochaine structure
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 37
local row = 37

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les structures
    local col = 2  // Colonne de départ pour les structures (B)

    * Boucler sur chaque structure
    foreach structure in $structures {
        * Filtrer les données pour la structure actuelle
        preserve
        keep if Structure == "`structure'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" aux valeurs
            local mean_score = 0
            local std_dev = 0
            local num_obs = 0
        }
        else {
            * Calculer la moyenne, l'écart-type et le nombre d'observations
            quietly summarize `var'

            local mean_score = r(mean)
            local std_dev = r(sd)
            local num_obs = r(N)
        }

        * Formatage des valeurs pour Excel
        local mean_formatted : display %9.2f `mean_score'
        local std_dev_formatted : display %9.2f `std_dev'

        * Définir les colonnes pour les scores
        num2col `col'
        local mean_col_letter = r(colname)

        num2col `=`col' + 1'
        local std_col_letter = r(colname)

        num2col `=`col' + 2'
        local n_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `mean_col_letter'`row' = `mean_formatted'
        putexcel `std_col_letter'`row' = "`std_dev_formatted'"
        putexcel `n_col_letter'`row' = `num_obs'

        restore
        local col = `col' + 3  // Passer à la prochaine structure
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	
	
	
	
	****Place of residence
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("SCORE OF CORRECT KNOWLEDGE") modify

* Définir les variables des scores à analyser
global var2 "Score_con_DIU_N Score_con_INJECTABLE_N Score_con_IMPLANTS_N Score_con_STERILFEM_N Score_con_STERILMAS_N"
global places "Rural Urban"  // Liste des lieux de résidence

* Ajouter le titre du tableau
putexcel A45 = "Table 2: Average scores of correct knowledge of family planning methods by place (Rural, Urban)"

* Ajouter les en-têtes des colonnes (lieux)
putexcel A46 = "Indicators"

* Initialiser la première colonne pour les lieux (B = colonne 2)
local col = 2

foreach place in $places {
    * Définir les colonnes pour Moyenne, Écart-type et Nombre d'observations
    num2col `col'
    local mean_col_letter = r(colname)

    num2col `=`col' + 1'
    local std_col_letter = r(colname)

    num2col `=`col' + 2'
    local n_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour le lieu de résidence
    putexcel `mean_col_letter'46 = "`place' - Mean Score"
    putexcel `std_col_letter'46 = "`place' - Std Dev"
    putexcel `n_col_letter'46 = "`place' - N"

    * Incrémenter de 3 pour passer au prochain lieu
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 47
local row = 47

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les lieux de résidence
    local col = 2  // Colonne de départ pour les lieux (B)

    * Boucler sur chaque lieu
    foreach place in $places {
        * Filtrer les données pour le lieu actuel
        preserve
        keep if Place == "`place'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" aux valeurs
            local mean_score = 0
            local std_dev = 0
            local num_obs = 0
        }
        else {
            * Calculer la moyenne, l'écart-type et le nombre d'observations
            quietly summarize `var'

            local mean_score = r(mean)
            local std_dev = r(sd)
            local num_obs = r(N)
        }

        * Formatage des valeurs pour Excel
        local mean_formatted : display %9.2f `mean_score'
        local std_dev_formatted : display %9.2f `std_dev'

        * Définir les colonnes pour les scores
        num2col `col'
        local mean_col_letter = r(colname)

        num2col `=`col' + 1'
        local std_col_letter = r(colname)

        num2col `=`col' + 2'
        local n_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `mean_col_letter'`row' = `mean_formatted'
        putexcel `std_col_letter'`row' = "`std_dev_formatted'"
        putexcel `n_col_letter'`row' = `num_obs'

        restore
        local col = `col' + 3  // Passer au prochain lieu
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}			
			

	
			
			
			
			
			
			***CONNAISSANCE CORRECTE PRE-PROCEDURE A 80%***
					
			
	****National
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("PREPROCEDURE (80%)") modify

* Définir les variables (indicateurs de la connaissance des méthodes de PF)
global var2 "DIU_pre_correct80 INJECT_pre_correct80 IMPLANTS_pre_correct80 STERILFEM_pre_correct80 STERILMAS_pre_correct80"

* Ajouter le titre du tableau
putexcel A1 = "Table 1: Pre-procedure correct knowledge of family planning methods at the national level (80%)"

* Ajouter les en-têtes des colonnes
putexcel A2 = "Indicators" B2 = "Counts (Effectifs)" C2 = "Proportions (%)" D2 = "Total"

* Initialiser une ligne pour écrire les données
local row = 3

* Créer une table temporaire pour stocker les données des proportions
tempname prop_table
postfile `prop_table' str50 Indicator double Proportion using prop_data.dta, replace

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Calculer les effectifs et proportions
    tabulate `var', matcell(freq_`var') matrow(rnames_`var')

    * Initialiser les valeurs par défaut
    local count1 = 0
    scalar proportion1 = 0
    scalar total_effectifs = 0

    * Calculer le total des effectifs (même s'il n'y a qu'une seule modalité)
    forval i = 1/`=rowsof(freq_`var')' {
        scalar total_effectifs = total_effectifs + freq_`var'[`i', 1]
    }

    * Vérifier si la modalité "1" existe
    local modalite1_exists = 0
    forval i = 1/`=rowsof(rnames_`var')' {
        if rnames_`var'[`i', 1] == 1 {
            local modalite1_exists = 1
            local count1 = freq_`var'[`i', 1]
            scalar proportion1 = (`count1' / total_effectifs) * 100
        }
    }

    * Si la modalité "1" n'existe pas, la proportion est 0
    if `modalite1_exists' == 0 {
        scalar proportion1 = 0
    }

    * Formatage des proportions à 2 décimales
    local proportion_formatted : display %9.2f proportion1

    * Ajouter les données au fichier Excel
    putexcel A`row' = "`label'"
    putexcel B`row' = `count1'
    putexcel C`row' = "`proportion_formatted'"
    putexcel D`row' = total_effectifs

    * Stocker les données pour le graphique
    post `prop_table' ("`label'") (proportion1)

    * Passer à la ligne suivante
    local row = `row' + 1
}






/*preserve

* Fermer le fichier temporaire
postclose `prop_table'

* Charger les données des proportions pour générer le graphique
use prop_data.dta, clear

* Générer un graphique en barres des proportions (horizontales)
graph hbar (asis) Proportion, over(Indicator, sort(1) descending) ///
    bar(1, color(blue)) ///
    title("Proportion of Family Planning Knowledge") ///
    ytitle("Proportion (%)") ///
    blabel(bar, format(%9.1f)) ///
    graphregion(margin(zero)) plotregion(margin(small)) // Réduction des marges

* Exporter le graphique en image PNG avec une taille réduite
graph export "PF_Knowledge_Graph1.png", width(600) height(400) replace

* Insérer le graphique dans Excel avec une taille réduite
putexcel G1 = image("PF_Knowledge_Graph1.png")

restore	
*/

	
	****Région
	
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("PREPROCEDURE (80%)") modify

* Définir les variables d'analyse
global var2 "DIU_pre_correct80 INJECT_pre_correct80 IMPLANTS_pre_correct80 STERILFEM_pre_correct80 STERILMAS_pre_correct80"
global regions "DAKAR DIOURBEL FATICK KAFFRINE KAOLACK KEDOUGOU KOLDA LOUGA MATAM SAINTLOUIS SEDHIOU TAMBACOUNDA THIES ZIGUINCHOR"

* Ajouter le titre du tableau
putexcel A15 = "Table 2: Pre-procedure correct knowledge of family planning methods by region (80%)"

* Ajouter les en-têtes des colonnes (régions)
putexcel A16 = "Indicators"

* Initialiser la première colonne pour les régions (B = colonne 2)
local col = 2

foreach region in $regions {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la région
    putexcel `count_col_letter'16 = "`region' - Counts"
    putexcel `prop_col_letter'16 = "`region' - Proportions"
    putexcel `total_col_letter'16 = "`region' - Total"

    * Incrémenter de 3 pour passer à la prochaine région
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 17
local row = 17

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les régions
    local col = 2  // Colonne de départ pour les effectifs des régions (B)

    * Boucler sur chaque région
    foreach region in $regions {
        * Filtrer les données pour la région actuelle
        preserve
        keep if region == "`region'"
        
        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)
        
        num2col `=`col' + 1'
        local prop_col_letter = r(colname)
        
        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer à la prochaine région (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	
	
	

	
	****Structures	

	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("PREPROCEDURE (80%)") modify

* Définir les variables d'analyse
global var2 "DIU_pre_correct80 INJECT_pre_correct80 IMPLANTS_pre_correct80 STERILFEM_pre_correct80 STERILMAS_pre_correct80"
global structures "Hospital HealthCenter HealthPost"  // Liste des structures de santé

* Ajouter le titre du tableau à partir de la ligne 30
putexcel A30 = "Table 3: Pre-procedure correct knowledge of family planning methods by structure of health facilities (80%)"

* Ajouter les en-têtes des colonnes (structures)
putexcel A31 = "Indicators"

* Initialiser la première colonne pour les structures (B = colonne 2)
local col = 2

foreach structure in $structures {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la structure
    putexcel `count_col_letter'31 = "`structure' - Counts"
    putexcel `prop_col_letter'31 = "`structure' - Proportions (%)"
    putexcel `total_col_letter'31 = "`structure' - Total"

    * Incrémenter de 3 pour passer à la structure suivante
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 32
local row = 32

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les structures
    local col = 2  // Colonne de départ pour les structures (B)

    * Boucler sur chaque structure
    foreach structure in $structures {
        * Filtrer les données pour la structure actuelle
        preserve
        keep if Structure == "`structure'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)
        
        num2col `=`col' + 1'
        local prop_col_letter = r(colname)
        
        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer à la prochaine structure (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}

	
	
	****Place of residence
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("PREPROCEDURE (80%)") modify

* Définir les variables d'analyse
global var2 "DIU_pre_correct80 INJECT_pre_correct80 IMPLANTS_pre_correct80 STERILFEM_pre_correct80 STERILMAS_pre_correct80"
global places "Rural Urban"  // Liste des lieux

* Ajouter le titre du tableau à partir de la ligne 30
putexcel A45 = "Table 3: Pre-procedure correct knowledge of family planning methods by place (80%)"

* Ajouter les en-têtes des colonnes (lieux)
putexcel A46 = "Indicators"

* Initialiser la première colonne pour les lieux (B = colonne 2)
local col = 2

foreach place in $places {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour chaque lieu
    putexcel `count_col_letter'46 = "`place' - Counts"
    putexcel `prop_col_letter'46 = "`place' - Proportions (%)"
    putexcel `total_col_letter'46 = "`place' - Total"

    * Incrémenter de 3 pour passer au prochain lieu
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 47
local row = 47

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les lieux
    local col = 2  // Colonne de départ pour les lieux (B)

    * Boucler sur chaque lieu
    foreach place in $places {
        * Filtrer les données pour le lieu actuel
        preserve
        keep if Place == "`place'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)

        num2col `=`col' + 1'
        local prop_col_letter = r(colname)

        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer au prochain lieu (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	
	
	
	
	
	
			***CONNAISSANCE CORRECTE PRE-PROCEDURE A 70%***		
		
			
	****National
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("PREPROCEDURE (70%)") modify

* Définir les variables (indicateurs de la connaissance des méthodes de PF)
global var2 "DIU_pre_correct70 INJECT_pre_correct70 IMPLANTS_pre_correct70 STERILFEM_pre_correct70 STERILMAS_pre_correct70"

* Ajouter le titre du tableau
putexcel A1 = "Table 1: Pre-procedure correct knowledge of family planning methods at the national level (70%)"

* Ajouter les en-têtes des colonnes
putexcel A2 = "Indicators" B2 = "Counts (Effectifs)" C2 = "Proportions (%)" D2 = "Total"

* Initialiser une ligne pour écrire les données
local row = 3

* Créer une table temporaire pour stocker les données des proportions
tempname prop_table
postfile `prop_table' str50 Indicator double Proportion using prop_data.dta, replace

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Calculer les effectifs et proportions
    tabulate `var', matcell(freq_`var') matrow(rnames_`var')

    * Initialiser les valeurs par défaut
    local count1 = 0
    scalar proportion1 = 0
    scalar total_effectifs = 0

    * Calculer le total des effectifs (même s'il n'y a qu'une seule modalité)
    forval i = 1/`=rowsof(freq_`var')' {
        scalar total_effectifs = total_effectifs + freq_`var'[`i', 1]
    }

    * Vérifier si la modalité "1" existe
    local modalite1_exists = 0
    forval i = 1/`=rowsof(rnames_`var')' {
        if rnames_`var'[`i', 1] == 1 {
            local modalite1_exists = 1
            local count1 = freq_`var'[`i', 1]
            scalar proportion1 = (`count1' / total_effectifs) * 100
        }
    }

    * Si la modalité "1" n'existe pas, la proportion est 0
    if `modalite1_exists' == 0 {
        scalar proportion1 = 0
    }

    * Formatage des proportions à 2 décimales
    local proportion_formatted : display %9.2f proportion1

    * Ajouter les données au fichier Excel
    putexcel A`row' = "`label'"
    putexcel B`row' = `count1'
    putexcel C`row' = "`proportion_formatted'"
    putexcel D`row' = total_effectifs

    * Stocker les données pour le graphique
    post `prop_table' ("`label'") (proportion1)

    * Passer à la ligne suivante
    local row = `row' + 1
}

/*preserve

* Fermer le fichier temporaire
postclose `prop_table'

* Charger les données des proportions pour générer le graphique
use prop_data.dta, clear

* Générer un graphique en barres des proportions (horizontales)
graph hbar (asis) Proportion, over(Indicator, sort(1) descending) ///
    bar(1, color(blue)) ///
    title("Proportion of Family Planning Knowledge") ///
    ytitle("Proportion (%)") ///
    blabel(bar, format(%9.1f)) ///
    graphregion(margin(zero)) plotregion(margin(small)) // Réduction des marges

* Exporter le graphique en image PNG avec une taille réduite
graph export "PF_Knowledge_Graph1.png", width(600) height(400) replace

* Insérer le graphique dans Excel avec une taille réduite
putexcel G1 = image("PF_Knowledge_Graph1.png")

restore	
*/

	
	****Région
	
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("PREPROCEDURE (70%)") modify

* Définir les variables d'analyse
global var2 "DIU_pre_correct70 INJECT_pre_correct70 IMPLANTS_pre_correct70 STERILFEM_pre_correct70 STERILMAS_pre_correct70"
global regions "DAKAR DIOURBEL FATICK KAFFRINE KAOLACK KEDOUGOU KOLDA LOUGA MATAM SAINTLOUIS SEDHIOU TAMBACOUNDA THIES ZIGUINCHOR"

* Ajouter le titre du tableau
putexcel A15 = "Table 2: Pre-procedure correct knowledge of family planning methods by region (70%)"

* Ajouter les en-têtes des colonnes (régions)
putexcel A16 = "Indicators"

* Initialiser la première colonne pour les régions (B = colonne 2)
local col = 2

foreach region in $regions {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la région
    putexcel `count_col_letter'16 = "`region' - Counts"
    putexcel `prop_col_letter'16 = "`region' - Proportions"
    putexcel `total_col_letter'16 = "`region' - Total"

    * Incrémenter de 3 pour passer à la prochaine région
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 17
local row = 17

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les régions
    local col = 2  // Colonne de départ pour les effectifs des régions (B)

    * Boucler sur chaque région
    foreach region in $regions {
        * Filtrer les données pour la région actuelle
        preserve
        keep if region == "`region'"
        
        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)
        
        num2col `=`col' + 1'
        local prop_col_letter = r(colname)
        
        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer à la prochaine région (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	
	
	

	
	****Structures	

	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("PREPROCEDURE (70%)") modify

* Définir les variables d'analyse
global var2 "DIU_pre_correct70 INJECT_pre_correct70 IMPLANTS_pre_correct70 STERILFEM_pre_correct70 STERILMAS_pre_correct70"
global structures "Hospital HealthCenter HealthPost"  // Liste des structures de santé

* Ajouter le titre du tableau à partir de la ligne 30
putexcel A30 = "Table 3: Pre-procedure correct knowledge of family planning methods by structure of health facilities (70%)"

* Ajouter les en-têtes des colonnes (structures)
putexcel A31 = "Indicators"

* Initialiser la première colonne pour les structures (B = colonne 2)
local col = 2

foreach structure in $structures {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la structure
    putexcel `count_col_letter'31 = "`structure' - Counts"
    putexcel `prop_col_letter'31 = "`structure' - Proportions (%)"
    putexcel `total_col_letter'31 = "`structure' - Total"

    * Incrémenter de 3 pour passer à la structure suivante
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 32
local row = 32

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les structures
    local col = 2  // Colonne de départ pour les structures (B)

    * Boucler sur chaque structure
    foreach structure in $structures {
        * Filtrer les données pour la structure actuelle
        preserve
        keep if Structure == "`structure'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)
        
        num2col `=`col' + 1'
        local prop_col_letter = r(colname)
        
        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer à la prochaine structure (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}

	
	
	****Place of residence
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("PREPROCEDURE (70%)") modify

* Définir les variables d'analyse
global var2 "DIU_pre_correct70 INJECT_pre_correct70 IMPLANTS_pre_correct70 STERILFEM_pre_correct70 STERILMAS_pre_correct70"
global places "Rural Urban"  // Liste des lieux

* Ajouter le titre du tableau à partir de la ligne 30
putexcel A45 = "Table 3: Pre-procedure correct knowledge of family planning methods by place (70%)"

* Ajouter les en-têtes des colonnes (lieux)
putexcel A46 = "Indicators"

* Initialiser la première colonne pour les lieux (B = colonne 2)
local col = 2

foreach place in $places {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour chaque lieu
    putexcel `count_col_letter'46 = "`place' - Counts"
    putexcel `prop_col_letter'46 = "`place' - Proportions (%)"
    putexcel `total_col_letter'46 = "`place' - Total"

    * Incrémenter de 3 pour passer au prochain lieu
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 47
local row = 47

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les lieux
    local col = 2  // Colonne de départ pour les lieux (B)

    * Boucler sur chaque lieu
    foreach place in $places {
        * Filtrer les données pour le lieu actuel
        preserve
        keep if Place == "`place'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)

        num2col `=`col' + 1'
        local prop_col_letter = r(colname)

        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer au prochain lieu (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	
	
	
					
			
			
			
			***CONNAISSANCE CORRECTE PRE-PROCEDURE A 60%***		
			
				
			
	****National
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("PREPROCEDURE (60%)") modify

* Définir les variables (indicateurs de la connaissance des méthodes de PF)
global var2 "DIU_pre_correct60 INJECT_pre_correct60 IMPLANTS_pre_correct60 STERILFEM_pre_correct60 STERILMAS_pre_correct60"

* Ajouter le titre du tableau
putexcel A1 = "Table 1: Pre-procedure correct knowledge of family planning methods at the national level (60%)"

* Ajouter les en-têtes des colonnes
putexcel A2 = "Indicators" B2 = "Counts (Effectifs)" C2 = "Proportions (%)" D2 = "Total"

* Initialiser une ligne pour écrire les données
local row = 3

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Calculer les effectifs et proportions
    tabulate `var', matcell(freq_`var') matrow(rnames_`var')

    * Initialiser les valeurs par défaut
    local count1 = 0
    local total_effectifs = 0
    local proportion_formatted = "0.00"

    * Vérifier si des données existent
    if `=rowsof(freq_`var')' > 0 {
        * Calculer le total des effectifs (même s'il n'y a qu'une seule modalité)
        forval i = 1/`=rowsof(freq_`var')' {
            local total_effectifs = `total_effectifs' + freq_`var'[`i', 1]
        }

        * Vérifier si la modalité "1" existe
        forval i = 1/`=rowsof(rnames_`var')' {
            if rnames_`var'[`i', 1] == 1 {
                local count1 = freq_`var'[`i', 1]
                local proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f `proportion1'
            }
        }
    }

    * Ajouter les données au fichier Excel
    putexcel A`row' = "`label'"
    putexcel B`row' = `count1'
    putexcel C`row' = "`proportion_formatted'"
    putexcel D`row' = `total_effectifs'

    * Passer à la ligne suivante
    local row = `row' + 1
}


	
	****Région
	
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("PREPROCEDURE (60%)") modify

* Définir les variables d'analyse
global var2 "DIU_pre_correct60 INJECT_pre_correct60 IMPLANTS_pre_correct60 STERILFEM_pre_correct60 STERILMAS_pre_correct60"
global regions "DAKAR DIOURBEL FATICK KAFFRINE KAOLACK KEDOUGOU KOLDA LOUGA MATAM SAINTLOUIS SEDHIOU TAMBACOUNDA THIES ZIGUINCHOR"

* Ajouter le titre du tableau
putexcel A15 = "Table 2: Pre-procedure correct knowledge of family planning methods by region (60%)"

* Ajouter les en-têtes des colonnes (régions)
putexcel A16 = "Indicators"

* Initialiser la première colonne pour les régions (B = colonne 2)
local col = 2

foreach region in $regions {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la région
    putexcel `count_col_letter'16 = "`region' - Counts"
    putexcel `prop_col_letter'16 = "`region' - Proportions"
    putexcel `total_col_letter'16 = "`region' - Total"

    * Incrémenter de 3 pour passer à la prochaine région
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 17
local row = 17

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les régions
    local col = 2  // Colonne de départ pour les effectifs des régions (B)

    * Boucler sur chaque région
    foreach region in $regions {
        * Filtrer les données pour la région actuelle
        preserve
        keep if region == "`region'"
        
        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)
        
        num2col `=`col' + 1'
        local prop_col_letter = r(colname)
        
        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer à la prochaine région (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	
	
	

	
	****Structures	

	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("PREPROCEDURE (60%)") modify

* Définir les variables d'analyse
global var2 "DIU_pre_correct60 INJECT_pre_correct60 IMPLANTS_pre_correct60 STERILFEM_pre_correct60 STERILMAS_pre_correct60"
global structures "Hospital HealthCenter HealthPost"  // Liste des structures de santé

* Ajouter le titre du tableau à partir de la ligne 30
putexcel A30 = "Table 3: Pre-procedure correct knowledge of family planning methods by structure of health facilities (60%)"

* Ajouter les en-têtes des colonnes (structures)
putexcel A31 = "Indicators"

* Initialiser la première colonne pour les structures (B = colonne 2)
local col = 2

foreach structure in $structures {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la structure
    putexcel `count_col_letter'31 = "`structure' - Counts"
    putexcel `prop_col_letter'31 = "`structure' - Proportions (%)"
    putexcel `total_col_letter'31 = "`structure' - Total"

    * Incrémenter de 3 pour passer à la structure suivante
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 32
local row = 32

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les structures
    local col = 2  // Colonne de départ pour les structures (B)

    * Boucler sur chaque structure
    foreach structure in $structures {
        * Filtrer les données pour la structure actuelle
        preserve
        keep if Structure == "`structure'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)
        
        num2col `=`col' + 1'
        local prop_col_letter = r(colname)
        
        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer à la prochaine structure (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}

	
	
	****Place of residence
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("PREPROCEDURE (60%)") modify

* Définir les variables d'analyse
global var2 "DIU_pre_correct60 INJECT_pre_correct60 IMPLANTS_pre_correct60 STERILFEM_pre_correct60 STERILMAS_pre_correct60"
global places "Rural Urban"  // Liste des lieux

* Ajouter le titre du tableau à partir de la ligne 30
putexcel A45 = "Table 3: Pre-procedure correct knowledge of family planning methods by place (60%)"

* Ajouter les en-têtes des colonnes (lieux)
putexcel A46 = "Indicators"

* Initialiser la première colonne pour les lieux (B = colonne 2)
local col = 2

foreach place in $places {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour chaque lieu
    putexcel `count_col_letter'46 = "`place' - Counts"
    putexcel `prop_col_letter'46 = "`place' - Proportions (%)"
    putexcel `total_col_letter'46 = "`place' - Total"

    * Incrémenter de 3 pour passer au prochain lieu
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 47
local row = 47

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les lieux
    local col = 2  // Colonne de départ pour les lieux (B)

    * Boucler sur chaque lieu
    foreach place in $places {
        * Filtrer les données pour le lieu actuel
        preserve
        keep if Place == "`place'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)

        num2col `=`col' + 1'
        local prop_col_letter = r(colname)

        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer au prochain lieu (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	
	
	
				
			***CONNAISSANCE CORRECTE PRE-PROCEDURE (SCORE NORMALISE)
			
			
			
	****National

	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("SCORE OF PREPROCEDURE") modify

* Définir les variables des scores à analyser
global var2 "Score_pra_DIU_pre_N Score_pra_INJECT_pre_N Score_pra_IMPLANTS_pre_N Score_pra_STERILFEM_pre_N Score_pra_STERILMAS_pre_N"

* Ajouter le titre du tableau
putexcel A1 = "Table 1: Average scores of correct knowledge of family planning methods at National level"

* Ajouter les en-têtes des colonnes
putexcel A2 = "Indicators" B2 = "Mean Score" C2 = "Standard Deviation" D2 = "Number of Observations"

* Initialiser une ligne pour écrire les données
local row = 3

* Créer une table temporaire pour stocker les données pour le graphique
tempname graph_data
postfile `graph_data' str50 Indicator double Mean double Std_Dev double N using prop_graph.dta, replace

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Calculer la moyenne, l'écart-type et le nombre d'observations
    quietly summarize `var'

    local mean_score = r(mean)
    local std_dev = r(sd)
    local num_obs = r(N)

    * Formatage des valeurs pour Excel
    local mean_formatted : display %9.2f `mean_score'
    local std_dev_formatted : display %9.2f `std_dev'

    * Ajouter les données au fichier Excel
    putexcel A`row' = "`label'"
    putexcel B`row' = `mean_formatted'
    putexcel C`row' = `std_dev_formatted'
    putexcel D`row' = `num_obs'

    * Stocker les données pour le graphique
    post `graph_data' ("`label'") (`mean_score') (`std_dev') (`num_obs')

    * Passer à la ligne suivante
    local row = `row' + 1
}

preserve

* Fermer le fichier temporaire
postclose `graph_data'

* Charger les données pour générer le Bar Chart
use prop_graph.dta, clear

* Vérifier si les données existent avant d'afficher le graphique
count if !missing(Mean)
if r(N) == 0 {
    display "Aucune donnée disponible pour le graphique."
    exit
}

* Générer un `bar chart` pour les moyennes des scores
graph hbar (mean) Mean, over(Indicator, sort(1) descending) ///
    bar(1, color(blue)) ///
    title("Average Scores of Correct Knowledge by Indicator") ///
    ytitle("Mean Score") ///
    blabel(bar, format(%9.2f)) ///
    graphregion(margin(zero)) plotregion(margin(small)) // Réduction des marges

* Exporter le graphique en image PNG avec une taille réduite
graph export "PF_Knowledge_Graph_Bar.png", width(600) height(400) replace

* Insérer le graphique dans Excel sous la table
local graph_row = `row' + 2  // Position du graphique après le tableau
putexcel I1 = image("PF_Knowledge_Graph_Bar.png")

restore	

* Message de confirmation
display "Les résultats et le graphique Bar Chart ont été exportés dans 'NURSES&MIDWIVES.xlsx' !"	


	
	****Région
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("SCORE OF PREPROCEDURE") modify

* Définir les variables des scores à analyser
global var2 "Score_pra_DIU_pre_N Score_pra_INJECT_pre_N Score_pra_IMPLANTS_pre_N Score_pra_STERILFEM_pre_N Score_pra_STERILMAS_pre_N"
global regions "DAKAR DIOURBEL FATICK KAFFRINE KAOLACK KEDOUGOU KOLDA LOUGA MATAM SAINTLOUIS SEDHIOU TAMBACOUNDA THIES ZIGUINCHOR"

* Ajouter le titre du tableau
putexcel A15 = "Table 2: Average scores of correct knowledge of family planning methods by region"

* Ajouter les en-têtes des colonnes (régions)
putexcel A16 = "Indicators"

* Initialiser la première colonne pour les régions (B = colonne 2)
local col = 2

foreach region in $regions {
    * Définir les colonnes pour Moyenne, Écart-type et Nombre d'observations
    num2col `col'
    local mean_col_letter = r(colname)

    num2col `=`col' + 1'
    local std_col_letter = r(colname)

    num2col `=`col' + 2'
    local n_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la région
    putexcel `mean_col_letter'16 = "`region' - Mean Score"
    putexcel `std_col_letter'16 = "`region' - Std Dev"
    putexcel `n_col_letter'16 = "`region' - N"

    * Incrémenter de 3 pour passer à la prochaine région
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 17
local row = 17

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les régions
    local col = 2  // Colonne de départ pour les régions (B)

    * Boucler sur chaque région
    foreach region in $regions {
        * Filtrer les données pour la région actuelle
        preserve
        keep if region == "`region'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" aux valeurs
            local mean_score = 0
            local std_dev = 0
            local num_obs = 0
        }
        else {
            * Calculer la moyenne, l'écart-type et le nombre d'observations
            quietly summarize `var'

            local mean_score = r(mean)
            local std_dev = r(sd)
            local num_obs = r(N)
        }

        * Formatage des valeurs pour Excel
        local mean_formatted : display %9.2f `mean_score'
        local std_dev_formatted : display %9.2f `std_dev'

        * Définir les colonnes pour les scores
        num2col `col'
        local mean_col_letter = r(colname)

        num2col `=`col' + 1'
        local std_col_letter = r(colname)

        num2col `=`col' + 2'
        local n_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `mean_col_letter'`row' = `mean_formatted'
        putexcel `std_col_letter'`row' = "`std_dev_formatted'"
        putexcel `n_col_letter'`row' = `num_obs'

        restore
        local col = `col' + 3  // Passer à la prochaine région
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}

	
	
	****Structures	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("SCORE OF PREPROCEDURE") modify

* Définir les variables des scores à analyser
global var2 "Score_pra_DIU_pre_N Score_pra_INJECT_pre_N Score_pra_IMPLANTS_pre_N Score_pra_STERILFEM_pre_N Score_pra_STERILMAS_pre_N"
global structures "Hospital HealthCenter HealthPost"  // Liste des structures de santé

* Ajouter le titre du tableau
putexcel A35 = "Table 2: Average scores of correct knowledge of family planning methods by structure"

* Ajouter les en-têtes des colonnes (structures)
putexcel A36 = "Indicators"

* Initialiser la première colonne pour les structures (B = colonne 2)
local col = 2

foreach structure in $structures {
    * Définir les colonnes pour Moyenne, Écart-type et Nombre d'observations
    num2col `col'
    local mean_col_letter = r(colname)

    num2col `=`col' + 1'
    local std_col_letter = r(colname)

    num2col `=`col' + 2'
    local n_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la structure
    putexcel `mean_col_letter'36 = "`structure' - Mean Score"
    putexcel `std_col_letter'36 = "`structure' - Std Dev"
    putexcel `n_col_letter'36 = "`structure' - N"

    * Incrémenter de 3 pour passer à la prochaine structure
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 37
local row = 37

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les structures
    local col = 2  // Colonne de départ pour les structures (B)

    * Boucler sur chaque structure
    foreach structure in $structures {
        * Filtrer les données pour la structure actuelle
        preserve
        keep if Structure == "`structure'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" aux valeurs
            local mean_score = 0
            local std_dev = 0
            local num_obs = 0
        }
        else {
            * Calculer la moyenne, l'écart-type et le nombre d'observations
            quietly summarize `var'

            local mean_score = r(mean)
            local std_dev = r(sd)
            local num_obs = r(N)
        }

        * Formatage des valeurs pour Excel
        local mean_formatted : display %9.2f `mean_score'
        local std_dev_formatted : display %9.2f `std_dev'

        * Définir les colonnes pour les scores
        num2col `col'
        local mean_col_letter = r(colname)

        num2col `=`col' + 1'
        local std_col_letter = r(colname)

        num2col `=`col' + 2'
        local n_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `mean_col_letter'`row' = `mean_formatted'
        putexcel `std_col_letter'`row' = "`std_dev_formatted'"
        putexcel `n_col_letter'`row' = `num_obs'

        restore
        local col = `col' + 3  // Passer à la prochaine structure
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	
	
	
	
	****Place of residence
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("SCORE OF PREPROCEDURE") modify

* Définir les variables des scores à analyser
global var2 "Score_pra_DIU_pre_N Score_pra_INJECT_pre_N Score_pra_IMPLANTS_pre_N Score_pra_STERILFEM_pre_N Score_pra_STERILMAS_pre_N"
global places "Rural Urban"  // Liste des lieux de résidence

* Ajouter le titre du tableau
putexcel A45 = "Table 2: Average scores of correct knowledge of family planning methods by place (Rural, Urban)"

* Ajouter les en-têtes des colonnes (lieux)
putexcel A46 = "Indicators"

* Initialiser la première colonne pour les lieux (B = colonne 2)
local col = 2

foreach place in $places {
    * Définir les colonnes pour Moyenne, Écart-type et Nombre d'observations
    num2col `col'
    local mean_col_letter = r(colname)

    num2col `=`col' + 1'
    local std_col_letter = r(colname)

    num2col `=`col' + 2'
    local n_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour le lieu de résidence
    putexcel `mean_col_letter'46 = "`place' - Mean Score"
    putexcel `std_col_letter'46 = "`place' - Std Dev"
    putexcel `n_col_letter'46 = "`place' - N"

    * Incrémenter de 3 pour passer au prochain lieu
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 47
local row = 47

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les lieux de résidence
    local col = 2  // Colonne de départ pour les lieux (B)

    * Boucler sur chaque lieu
    foreach place in $places {
        * Filtrer les données pour le lieu actuel
        preserve
        keep if Place == "`place'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" aux valeurs
            local mean_score = 0
            local std_dev = 0
            local num_obs = 0
        }
        else {
            * Calculer la moyenne, l'écart-type et le nombre d'observations
            quietly summarize `var'

            local mean_score = r(mean)
            local std_dev = r(sd)
            local num_obs = r(N)
        }

        * Formatage des valeurs pour Excel
        local mean_formatted : display %9.2f `mean_score'
        local std_dev_formatted : display %9.2f `std_dev'

        * Définir les colonnes pour les scores
        num2col `col'
        local mean_col_letter = r(colname)

        num2col `=`col' + 1'
        local std_col_letter = r(colname)

        num2col `=`col' + 2'
        local n_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `mean_col_letter'`row' = `mean_formatted'
        putexcel `std_col_letter'`row' = "`std_dev_formatted'"
        putexcel `n_col_letter'`row' = `num_obs'

        restore
        local col = `col' + 3  // Passer au prochain lieu
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}			
			
			

		
	

			***CONNAISSANCE CORRECTE POST-PROCEDURE A 80%***
		
	
			
	****National
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("POSTPROCEDURE (80%)") modify

* Définir les variables (indicateurs de la connaissance des méthodes de PF)
global var2 "DIU_post_correct80 INJECT_post_correct80 IMPLANTS_post_correct80 STERILFEM_post_correct80 STERILMAS_post_correct80"

* Ajouter le titre du tableau
putexcel A1 = "Table 1: Post-procedure correct knowledge of family planning methods at the national level (80%)"

* Ajouter les en-têtes des colonnes
putexcel A2 = "Indicators" B2 = "Counts (Effectifs)" C2 = "Proportions (%)" D2 = "Total"

* Initialiser une ligne pour écrire les données
local row = 3

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Calculer les effectifs et proportions
    tabulate `var', matcell(freq_`var') matrow(rnames_`var')

    * Initialiser les valeurs par défaut
    local count1 = 0
    local total_effectifs = 0
    local proportion_formatted = "0.00"

    * Vérifier si des données existent
    if `=rowsof(freq_`var')' > 0 {
        * Calculer le total des effectifs (même s'il n'y a qu'une seule modalité)
        forval i = 1/`=rowsof(freq_`var')' {
            local total_effectifs = `total_effectifs' + freq_`var'[`i', 1]
        }

        * Vérifier si la modalité "1" existe
        forval i = 1/`=rowsof(rnames_`var')' {
            if rnames_`var'[`i', 1] == 1 {
                local count1 = freq_`var'[`i', 1]
                local proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f `proportion1'
            }
        }
    }

    * Ajouter les données au fichier Excel
    putexcel A`row' = "`label'"
    putexcel B`row' = `count1'
    putexcel C`row' = "`proportion_formatted'"
    putexcel D`row' = `total_effectifs'

    * Passer à la ligne suivante
    local row = `row' + 1
}


	
	****Région
	
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("POSTPROCEDURE (80%)") modify

* Définir les variables d'analyse
global var2 "DIU_post_correct80 INJECT_post_correct80 IMPLANTS_post_correct80 STERILFEM_post_correct80 STERILMAS_post_correct80"
global regions "DAKAR DIOURBEL FATICK KAFFRINE KAOLACK KEDOUGOU KOLDA LOUGA MATAM SAINTLOUIS SEDHIOU TAMBACOUNDA THIES ZIGUINCHOR"

* Ajouter le titre du tableau
putexcel A15 = "Table 2: Post-procedure correct knowledge of family planning methods by region (80%)"

* Ajouter les en-têtes des colonnes (régions)
putexcel A16 = "Indicators"

* Initialiser la première colonne pour les régions (B = colonne 2)
local col = 2

foreach region in $regions {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la région
    putexcel `count_col_letter'16 = "`region' - Counts"
    putexcel `prop_col_letter'16 = "`region' - Proportions"
    putexcel `total_col_letter'16 = "`region' - Total"

    * Incrémenter de 3 pour passer à la prochaine région
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 17
local row = 17

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les régions
    local col = 2  // Colonne de départ pour les effectifs des régions (B)

    * Boucler sur chaque région
    foreach region in $regions {
        * Filtrer les données pour la région actuelle
        preserve
        keep if region == "`region'"
        
        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)
        
        num2col `=`col' + 1'
        local prop_col_letter = r(colname)
        
        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer à la prochaine région (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	
	
	

	
	****Structures	

	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("POSTPROCEDURE (80%)") modify

* Définir les variables d'analyse
global var2 "DIU_post_correct80 INJECT_post_correct80 IMPLANTS_post_correct80 STERILFEM_post_correct80 STERILMAS_post_correct80"
global structures "Hospital HealthCenter HealthPost"  // Liste des structures de santé

* Ajouter le titre du tableau à partir de la ligne 30
putexcel A30 = "Table 3: Post-procedure correct knowledge of family planning methods by structure of health facilities (80%)"

* Ajouter les en-têtes des colonnes (structures)
putexcel A31 = "Indicators"

* Initialiser la première colonne pour les structures (B = colonne 2)
local col = 2

foreach structure in $structures {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la structure
    putexcel `count_col_letter'31 = "`structure' - Counts"
    putexcel `prop_col_letter'31 = "`structure' - Proportions (%)"
    putexcel `total_col_letter'31 = "`structure' - Total"

    * Incrémenter de 3 pour passer à la structure suivante
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 32
local row = 32

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les structures
    local col = 2  // Colonne de départ pour les structures (B)

    * Boucler sur chaque structure
    foreach structure in $structures {
        * Filtrer les données pour la structure actuelle
        preserve
        keep if Structure == "`structure'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)
        
        num2col `=`col' + 1'
        local prop_col_letter = r(colname)
        
        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer à la prochaine structure (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}

	
	
	****Place of residence
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("POSTPROCEDURE (80%)") modify

* Définir les variables d'analyse
global var2 "DIU_post_correct80 INJECT_post_correct80 IMPLANTS_post_correct80 STERILFEM_post_correct80 STERILMAS_post_correct80"
global places "Rural Urban"  // Liste des lieux

* Ajouter le titre du tableau à partir de la ligne 30
putexcel A45 = "Table 3: Post-procedure correct knowledge of family planning methods by place (80%)"

* Ajouter les en-têtes des colonnes (lieux)
putexcel A46 = "Indicators"

* Initialiser la première colonne pour les lieux (B = colonne 2)
local col = 2

foreach place in $places {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour chaque lieu
    putexcel `count_col_letter'46 = "`place' - Counts"
    putexcel `prop_col_letter'46 = "`place' - Proportions (%)"
    putexcel `total_col_letter'46 = "`place' - Total"

    * Incrémenter de 3 pour passer au prochain lieu
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 47
local row = 47

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les lieux
    local col = 2  // Colonne de départ pour les lieux (B)

    * Boucler sur chaque lieu
    foreach place in $places {
        * Filtrer les données pour le lieu actuel
        preserve
        keep if Place == "`place'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)

        num2col `=`col' + 1'
        local prop_col_letter = r(colname)

        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer au prochain lieu (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	
	
	
	
	
	
			***CONNAISSANCE CORRECTE PRE-PROCEDURE A 70%***		
		
			
	****National
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("POSTPROCEDURE (70%)") modify

* Définir les variables (indicateurs de la connaissance des méthodes de PF)
global var2 "DIU_post_correct70 INJECT_post_correct70 IMPLANTS_post_correct70 STERILFEM_post_correct70 STERILMAS_post_correct70"

* Ajouter le titre du tableau
putexcel A1 = "Table 1: Post-procedure correct knowledge of family planning methods at the national level (70%)"

* Ajouter les en-têtes des colonnes
putexcel A2 = "Indicators" B2 = "Counts (Effectifs)" C2 = "Proportions (%)" D2 = "Total"

* Initialiser une ligne pour écrire les données
local row = 3

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Vérifier s'il y a des observations valides pour cette variable
    count if !missing(`var')
    if r(N) == 0 {
        * Si aucune donnée n'existe, attribuer "0" aux valeurs
        local count1 = 0
        local total_effectifs = 0
        local proportion_formatted = "0.00"
    }
    else {
        * Calculer les effectifs et proportions
        tabulate `var', matcell(freq_`var') matrow(rnames_`var')

        * Initialiser les valeurs par défaut
        local count1 = 0
        local total_effectifs = 0
        local proportion_formatted = "0.00"

        * Calculer le total des effectifs (même s'il n'y a qu'une seule modalité)
        forval i = 1/`=rowsof(freq_`var')' {
            local total_effectifs = `total_effectifs' + freq_`var'[`i', 1]
        }

        * Vérifier si la modalité "1" existe et calculer la proportion
        forval i = 1/`=rowsof(rnames_`var')' {
            if rnames_`var'[`i', 1] == 1 {
                local count1 = freq_`var'[`i', 1]
                local proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f `proportion1'
            }
        }
    }

    * Ajouter les données au fichier Excel
    putexcel A`row' = "`label'"
    putexcel B`row' = `count1'
    putexcel C`row' = "`proportion_formatted'"
    putexcel D`row' = `total_effectifs'

    * Passer à la ligne suivante
    local row = `row' + 1
}



	
	****Région
	
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("POSTPROCEDURE (70%)") modify

* Définir les variables d'analyse
global var2 "DIU_post_correct70 INJECT_post_correct70 IMPLANTS_post_correct70 STERILFEM_post_correct70 STERILMAS_post_correct70"
global regions "DAKAR DIOURBEL FATICK KAFFRINE KAOLACK KEDOUGOU KOLDA LOUGA MATAM SAINTLOUIS SEDHIOU TAMBACOUNDA THIES ZIGUINCHOR"

* Ajouter le titre du tableau
putexcel A15 = "Table 2: Post-procedure correct knowledge of family planning methods by region (70%)"

* Ajouter les en-têtes des colonnes (régions)
putexcel A16 = "Indicators"

* Initialiser la première colonne pour les régions (B = colonne 2)
local col = 2

foreach region in $regions {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la région
    putexcel `count_col_letter'16 = "`region' - Counts"
    putexcel `prop_col_letter'16 = "`region' - Proportions"
    putexcel `total_col_letter'16 = "`region' - Total"

    * Incrémenter de 3 pour passer à la prochaine région
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 17
local row = 17

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les régions
    local col = 2  // Colonne de départ pour les effectifs des régions (B)

    * Boucler sur chaque région
    foreach region in $regions {
        * Filtrer les données pour la région actuelle
        preserve
        keep if region == "`region'"
        
        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)
        
        num2col `=`col' + 1'
        local prop_col_letter = r(colname)
        
        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer à la prochaine région (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	
	
	

	
	****Structures	

	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("POSTPROCEDURE (70%)") modify

* Définir les variables d'analyse
global var2 "DIU_post_correct70 INJECT_post_correct70 IMPLANTS_post_correct70 STERILFEM_post_correct70 STERILMAS_post_correct70"
global structures "Hospital HealthCenter HealthPost"  // Liste des structures de santé

* Ajouter le titre du tableau à partir de la ligne 30
putexcel A30 = "Table 3: Post-procedure correct knowledge of family planning methods by structure of health facilities (70%)"

* Ajouter les en-têtes des colonnes (structures)
putexcel A31 = "Indicators"

* Initialiser la première colonne pour les structures (B = colonne 2)
local col = 2

foreach structure in $structures {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la structure
    putexcel `count_col_letter'31 = "`structure' - Counts"
    putexcel `prop_col_letter'31 = "`structure' - Proportions (%)"
    putexcel `total_col_letter'31 = "`structure' - Total"

    * Incrémenter de 3 pour passer à la structure suivante
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 32
local row = 32

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les structures
    local col = 2  // Colonne de départ pour les structures (B)

    * Boucler sur chaque structure
    foreach structure in $structures {
        * Filtrer les données pour la structure actuelle
        preserve
        keep if Structure == "`structure'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)
        
        num2col `=`col' + 1'
        local prop_col_letter = r(colname)
        
        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer à la prochaine structure (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}

	
	
	****Place of residence
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("POSTPROCEDURE (70%)") modify

* Définir les variables d'analyse
global var2 "DIU_post_correct70 INJECT_post_correct70 IMPLANTS_post_correct70 STERILFEM_post_correct70 STERILMAS_post_correct70"
global places "Rural Urban"  // Liste des lieux

* Ajouter le titre du tableau à partir de la ligne 30
putexcel A45 = "Table 3: Post-procedure correct knowledge of family planning methods by place (70%)"

* Ajouter les en-têtes des colonnes (lieux)
putexcel A46 = "Indicators"

* Initialiser la première colonne pour les lieux (B = colonne 2)
local col = 2

foreach place in $places {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour chaque lieu
    putexcel `count_col_letter'46 = "`place' - Counts"
    putexcel `prop_col_letter'46 = "`place' - Proportions (%)"
    putexcel `total_col_letter'46 = "`place' - Total"

    * Incrémenter de 3 pour passer au prochain lieu
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 47
local row = 47

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les lieux
    local col = 2  // Colonne de départ pour les lieux (B)

    * Boucler sur chaque lieu
    foreach place in $places {
        * Filtrer les données pour le lieu actuel
        preserve
        keep if Place == "`place'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)

        num2col `=`col' + 1'
        local prop_col_letter = r(colname)

        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer au prochain lieu (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	
	
	
					
			
			
			
			***CONNAISSANCE CORRECTE PRE-PROCEDURE A 60%***		
			
				
			
	****National
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("POSTPROCEDURE (60%)") modify

* Définir les variables (indicateurs de la connaissance des méthodes de PF)
global var2 "DIU_post_correct60 INJECT_post_correct60 IMPLANTS_post_correct60 STERILFEM_post_correct60 STERILMAS_post_correct60"

* Ajouter le titre du tableau
putexcel A1 = "Table 1: Post-procedure correct knowledge of family planning methods at the national level (60%)"

* Ajouter les en-têtes des colonnes
putexcel A2 = "Indicators" B2 = "Counts (Effectifs)" C2 = "Proportions (%)" D2 = "Total"

* Initialiser une ligne pour écrire les données
local row = 3

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Vérifier s'il y a des observations valides pour cette variable
    count if !missing(`var')
    if r(N) == 0 {
        * Si aucune donnée n'existe, attribuer "0" aux valeurs
        local count1 = 0
        local total_effectifs = 0
        local proportion_formatted = "0.00"
    }
    else {
        * Calculer les effectifs et proportions
        tabulate `var', matcell(freq_`var') matrow(rnames_`var')

        * Initialiser les valeurs par défaut
        local count1 = 0
        local total_effectifs = 0
        local proportion_formatted = "0.00"

        * Calculer le total des effectifs (même s'il n'y a qu'une seule modalité)
        forval i = 1/`=rowsof(freq_`var')' {
            local total_effectifs = `total_effectifs' + freq_`var'[`i', 1]
        }

        * Vérifier si la modalité "1" existe et calculer la proportion
        forval i = 1/`=rowsof(rnames_`var')' {
            if rnames_`var'[`i', 1] == 1 {
                local count1 = freq_`var'[`i', 1]
                local proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f `proportion1'
            }
        }
    }

    * Ajouter les données au fichier Excel
    putexcel A`row' = "`label'"
    putexcel B`row' = `count1'
    putexcel C`row' = "`proportion_formatted'"
    putexcel D`row' = `total_effectifs'

    * Passer à la ligne suivante
    local row = `row' + 1
}

	
	****Région
	
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("POSTPROCEDURE (60%)") modify

* Définir les variables d'analyse
global var2 "DIU_post_correct60 INJECT_post_correct60 IMPLANTS_post_correct60 STERILFEM_post_correct60 STERILMAS_post_correct60"
global regions "DAKAR DIOURBEL FATICK KAFFRINE KAOLACK KEDOUGOU KOLDA LOUGA MATAM SAINTLOUIS SEDHIOU TAMBACOUNDA THIES ZIGUINCHOR"

* Ajouter le titre du tableau
putexcel A15 = "Table 2: Post-procedure correct knowledge of family planning methods by region (60%)"

* Ajouter les en-têtes des colonnes (régions)
putexcel A16 = "Indicators"

* Initialiser la première colonne pour les régions (B = colonne 2)
local col = 2

foreach region in $regions {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la région
    putexcel `count_col_letter'16 = "`region' - Counts"
    putexcel `prop_col_letter'16 = "`region' - Proportions"
    putexcel `total_col_letter'16 = "`region' - Total"

    * Incrémenter de 3 pour passer à la prochaine région
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 17
local row = 17

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les régions
    local col = 2  // Colonne de départ pour les effectifs des régions (B)

    * Boucler sur chaque région
    foreach region in $regions {
        * Filtrer les données pour la région actuelle
        preserve
        keep if region == "`region'"
        
        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)
        
        num2col `=`col' + 1'
        local prop_col_letter = r(colname)
        
        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer à la prochaine région (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	
	
	

	
	****Structures	

	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("POSTPROCEDURE (60%)") modify

* Définir les variables d'analyse
global var2 "DIU_post_correct60 INJECT_post_correct60 IMPLANTS_post_correct60 STERILFEM_post_correct60 STERILMAS_post_correct60"
global structures "Hospital HealthCenter HealthPost"  // Liste des structures de santé

* Ajouter le titre du tableau à partir de la ligne 30
putexcel A30 = "Table 3: Post-procedure correct knowledge of family planning methods by structure of health facilities (60%)"

* Ajouter les en-têtes des colonnes (structures)
putexcel A31 = "Indicators"

* Initialiser la première colonne pour les structures (B = colonne 2)
local col = 2

foreach structure in $structures {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la structure
    putexcel `count_col_letter'31 = "`structure' - Counts"
    putexcel `prop_col_letter'31 = "`structure' - Proportions (%)"
    putexcel `total_col_letter'31 = "`structure' - Total"

    * Incrémenter de 3 pour passer à la structure suivante
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 32
local row = 32

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les structures
    local col = 2  // Colonne de départ pour les structures (B)

    * Boucler sur chaque structure
    foreach structure in $structures {
        * Filtrer les données pour la structure actuelle
        preserve
        keep if Structure == "`structure'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)
        
        num2col `=`col' + 1'
        local prop_col_letter = r(colname)
        
        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer à la prochaine structure (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}

	
	
	****Place of residence
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("POSTPROCEDURE (60%)") modify

* Définir les variables d'analyse
global var2 "DIU_post_correct60 INJECT_post_correct60 IMPLANTS_post_correct60 STERILFEM_post_correct60 STERILMAS_post_correct60"
global places "Rural Urban"  // Liste des lieux

* Ajouter le titre du tableau à partir de la ligne 30
putexcel A45 = "Table 3: Post-procedure correct knowledge of family planning methods by place (60%)"

* Ajouter les en-têtes des colonnes (lieux)
putexcel A46 = "Indicators"

* Initialiser la première colonne pour les lieux (B = colonne 2)
local col = 2

foreach place in $places {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour chaque lieu
    putexcel `count_col_letter'46 = "`place' - Counts"
    putexcel `prop_col_letter'46 = "`place' - Proportions (%)"
    putexcel `total_col_letter'46 = "`place' - Total"

    * Incrémenter de 3 pour passer au prochain lieu
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 47
local row = 47

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les lieux
    local col = 2  // Colonne de départ pour les lieux (B)

    * Boucler sur chaque lieu
    foreach place in $places {
        * Filtrer les données pour le lieu actuel
        preserve
        keep if Place == "`place'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)

        num2col `=`col' + 1'
        local prop_col_letter = r(colname)

        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer au prochain lieu (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	
	
	
				
			***CONNAISSANCE CORRECTE PRE-PROCEDURE (SCORE NORMALISE)
			
			
			
	****National

	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("SCORE OF POSTPROCEDURE") modify

* Définir les variables des scores à analyser
global var2 "Score_pra_DIU_post_N Score_pra_INJECT_post_N Score_pra_IMPLANTS_post_N Score_pra_STERILFEM_post_N Score_pra_STERILMAS_post_N"

* Ajouter le titre du tableau
putexcel A1 = "Table 1: Average scores of postprocedure correct knowledge of family planning methods at National level"

* Ajouter les en-têtes des colonnes
putexcel A2 = "Indicators" B2 = "Mean Score" C2 = "Standard Deviation" D2 = "Number of Observations"

* Initialiser une ligne pour écrire les données
local row = 3

* Créer une table temporaire pour stocker les données pour le graphique
tempname graph_data
postfile `graph_data' str50 Indicator double Mean double Std_Dev double N using prop_graph.dta, replace

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Calculer la moyenne, l'écart-type et le nombre d'observations
    quietly summarize `var'

    local mean_score = r(mean)
    local std_dev = r(sd)
    local num_obs = r(N)

    * Formatage des valeurs pour Excel
    local mean_formatted : display %9.2f `mean_score'
    local std_dev_formatted : display %9.2f `std_dev'

    * Ajouter les données au fichier Excel
    putexcel A`row' = "`label'"
    putexcel B`row' = `mean_formatted'
    putexcel C`row' = `std_dev_formatted'
    putexcel D`row' = `num_obs'

    * Stocker les données pour le graphique
    post `graph_data' ("`label'") (`mean_score') (`std_dev') (`num_obs')

    * Passer à la ligne suivante
    local row = `row' + 1
}

preserve

* Fermer le fichier temporaire
postclose `graph_data'

* Charger les données pour générer le Bar Chart
use prop_graph.dta, clear

* Vérifier si les données existent avant d'afficher le graphique
count if !missing(Mean)
if r(N) == 0 {
    display "Aucune donnée disponible pour le graphique."
    exit
}

* Générer un `bar chart` pour les moyennes des scores
graph hbar (mean) Mean, over(Indicator, sort(1) descending) ///
    bar(1, color(blue)) ///
    title("Average Scores of Correct Knowledge by Indicator") ///
    ytitle("Mean Score") ///
    blabel(bar, format(%9.2f)) ///
    graphregion(margin(zero)) plotregion(margin(small)) // Réduction des marges

* Exporter le graphique en image PNG avec une taille réduite
graph export "PF_Knowledge_Graph_Bar.png", width(600) height(400) replace

* Insérer le graphique dans Excel sous la table
local graph_row = `row' + 2  // Position du graphique après le tableau
putexcel I1 = image("PF_Knowledge_Graph_Bar.png")

restore	

* Message de confirmation
display "Les résultats et le graphique Bar Chart ont été exportés dans 'NURSES&MIDWIVES.xlsx' !"	


	
	****Région
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("SCORE OF POSTPROCEDURE") modify

* Définir les variables des scores à analyser
global var2 "Score_pra_DIU_post_N Score_pra_INJECT_post_N Score_pra_IMPLANTS_post_N Score_pra_STERILFEM_post_N Score_pra_STERILMAS_post_N"
global regions "DAKAR DIOURBEL FATICK KAFFRINE KAOLACK KEDOUGOU KOLDA LOUGA MATAM SAINTLOUIS SEDHIOU TAMBACOUNDA THIES ZIGUINCHOR"

* Ajouter le titre du tableau
putexcel A15 = "Table 2: Average scores of postprocedure correct knowledge of family planning methods by region"

* Ajouter les en-têtes des colonnes (régions)
putexcel A16 = "Indicators"

* Initialiser la première colonne pour les régions (B = colonne 2)
local col = 2

foreach region in $regions {
    * Définir les colonnes pour Moyenne, Écart-type et Nombre d'observations
    num2col `col'
    local mean_col_letter = r(colname)

    num2col `=`col' + 1'
    local std_col_letter = r(colname)

    num2col `=`col' + 2'
    local n_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la région
    putexcel `mean_col_letter'16 = "`region' - Mean Score"
    putexcel `std_col_letter'16 = "`region' - Std Dev"
    putexcel `n_col_letter'16 = "`region' - N"

    * Incrémenter de 3 pour passer à la prochaine région
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 17
local row = 17

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les régions
    local col = 2  // Colonne de départ pour les régions (B)

    * Boucler sur chaque région
    foreach region in $regions {
        * Filtrer les données pour la région actuelle
        preserve
        keep if region == "`region'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" aux valeurs
            local mean_score = 0
            local std_dev = 0
            local num_obs = 0
        }
        else {
            * Calculer la moyenne, l'écart-type et le nombre d'observations
            quietly summarize `var'

            local mean_score = r(mean)
            local std_dev = r(sd)
            local num_obs = r(N)
        }

        * Formatage des valeurs pour Excel
        local mean_formatted : display %9.2f `mean_score'
        local std_dev_formatted : display %9.2f `std_dev'

        * Définir les colonnes pour les scores
        num2col `col'
        local mean_col_letter = r(colname)

        num2col `=`col' + 1'
        local std_col_letter = r(colname)

        num2col `=`col' + 2'
        local n_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `mean_col_letter'`row' = `mean_formatted'
        putexcel `std_col_letter'`row' = "`std_dev_formatted'"
        putexcel `n_col_letter'`row' = `num_obs'

        restore
        local col = `col' + 3  // Passer à la prochaine région
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}

	
	
	****Structures	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("SCORE OF POSTPROCEDURE") modify

* Définir les variables des scores à analyser
global var2 "Score_pra_DIU_post_N Score_pra_INJECT_post_N Score_pra_IMPLANTS_post_N Score_pra_STERILFEM_post_N Score_pra_STERILMAS_post_N"
global structures "Hospital HealthCenter HealthPost"  // Liste des structures de santé

* Ajouter le titre du tableau
putexcel A35 = "Table 2: Average scores of postprocedure correct knowledge of family planning methods by structure"

* Ajouter les en-têtes des colonnes (structures)
putexcel A36 = "Indicators"

* Initialiser la première colonne pour les structures (B = colonne 2)
local col = 2

foreach structure in $structures {
    * Définir les colonnes pour Moyenne, Écart-type et Nombre d'observations
    num2col `col'
    local mean_col_letter = r(colname)

    num2col `=`col' + 1'
    local std_col_letter = r(colname)

    num2col `=`col' + 2'
    local n_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la structure
    putexcel `mean_col_letter'36 = "`structure' - Mean Score"
    putexcel `std_col_letter'36 = "`structure' - Std Dev"
    putexcel `n_col_letter'36 = "`structure' - N"

    * Incrémenter de 3 pour passer à la prochaine structure
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 37
local row = 37

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les structures
    local col = 2  // Colonne de départ pour les structures (B)

    * Boucler sur chaque structure
    foreach structure in $structures {
        * Filtrer les données pour la structure actuelle
        preserve
        keep if Structure == "`structure'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" aux valeurs
            local mean_score = 0
            local std_dev = 0
            local num_obs = 0
        }
        else {
            * Calculer la moyenne, l'écart-type et le nombre d'observations
            quietly summarize `var'

            local mean_score = r(mean)
            local std_dev = r(sd)
            local num_obs = r(N)
        }

        * Formatage des valeurs pour Excel
        local mean_formatted : display %9.2f `mean_score'
        local std_dev_formatted : display %9.2f `std_dev'

        * Définir les colonnes pour les scores
        num2col `col'
        local mean_col_letter = r(colname)

        num2col `=`col' + 1'
        local std_col_letter = r(colname)

        num2col `=`col' + 2'
        local n_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `mean_col_letter'`row' = `mean_formatted'
        putexcel `std_col_letter'`row' = "`std_dev_formatted'"
        putexcel `n_col_letter'`row' = `num_obs'

        restore
        local col = `col' + 3  // Passer à la prochaine structure
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	
	
	
	
	****Place of residence
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("SCORE OF POSTPROCEDURE") modify

* Définir les variables des scores à analyser
global var2 "Score_pra_DIU_post_N Score_pra_INJECT_post_N Score_pra_IMPLANTS_post_N Score_pra_STERILFEM_post_N Score_pra_STERILMAS_post_N"
global places "Rural Urban"  // Liste des lieux de résidence

* Ajouter le titre du tableau
putexcel A45 = "Table 2: Average scores of postprocedure correct knowledge of family planning methods by place (Rural, Urban)"

* Ajouter les en-têtes des colonnes (lieux)
putexcel A46 = "Indicators"

* Initialiser la première colonne pour les lieux (B = colonne 2)
local col = 2

foreach place in $places {
    * Définir les colonnes pour Moyenne, Écart-type et Nombre d'observations
    num2col `col'
    local mean_col_letter = r(colname)

    num2col `=`col' + 1'
    local std_col_letter = r(colname)

    num2col `=`col' + 2'
    local n_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour le lieu de résidence
    putexcel `mean_col_letter'46 = "`place' - Mean Score"
    putexcel `std_col_letter'46 = "`place' - Std Dev"
    putexcel `n_col_letter'46 = "`place' - N"

    * Incrémenter de 3 pour passer au prochain lieu
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 47
local row = 47

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les lieux de résidence
    local col = 2  // Colonne de départ pour les lieux (B)

    * Boucler sur chaque lieu
    foreach place in $places {
        * Filtrer les données pour le lieu actuel
        preserve
        keep if Place == "`place'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" aux valeurs
            local mean_score = 0
            local std_dev = 0
            local num_obs = 0
        }
        else {
            * Calculer la moyenne, l'écart-type et le nombre d'observations
            quietly summarize `var'

            local mean_score = r(mean)
            local std_dev = r(sd)
            local num_obs = r(N)
        }

        * Formatage des valeurs pour Excel
        local mean_formatted : display %9.2f `mean_score'
        local std_dev_formatted : display %9.2f `std_dev'

        * Définir les colonnes pour les scores
        num2col `col'
        local mean_col_letter = r(colname)

        num2col `=`col' + 1'
        local std_col_letter = r(colname)

        num2col `=`col' + 2'
        local n_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `mean_col_letter'`row' = `mean_formatted'
        putexcel `std_col_letter'`row' = "`std_dev_formatted'"
        putexcel `n_col_letter'`row' = `num_obs'

        restore
        local col = `col' + 3  // Passer au prochain lieu
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}			

	
	
	

			***ATTITUDE FAVORABLE A 80%***
	
			
	
			
	****National
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("ATTITUDE FAVORABLE (80%)") modify

* Définir les variables (indicateurs de la connaissance des méthodes de PF)
global var2 "Favorable_PF80 Favorable_DIU80 Favorable_INJECTABLES80 Favorable_IMPLANTS80 Favorable_PILULE80 Favorable_CONTRACEPURG80 Favorable_PRESERVATFEM80 Favorable_STERILISFEM80 Favorable_STERILISMAS80"

* Ajouter le titre du tableau
putexcel A1 = "Table 1: Favorable attitude of family planning methods at the national level (80%)"

* Ajouter les en-têtes des colonnes
putexcel A2 = "Indicators" B2 = "Counts (Effectifs)" C2 = "Proportions (%)" D2 = "Total"

* Initialiser une ligne pour écrire les données
local row = 3

* Créer une table temporaire pour stocker les données des proportions
tempname prop_table
postfile `prop_table' str50 Indicator double Proportion using prop_data.dta, replace

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Calculer les effectifs et proportions
    tabulate `var', matcell(freq_`var') matrow(rnames_`var')

    * Initialiser les valeurs par défaut
    local count1 = 0
    scalar proportion1 = 0
    scalar total_effectifs = 0

    * Calculer le total des effectifs (même s'il n'y a qu'une seule modalité)
    forval i = 1/`=rowsof(freq_`var')' {
        scalar total_effectifs = total_effectifs + freq_`var'[`i', 1]
    }

    * Vérifier si la modalité "1" existe
    local modalite1_exists = 0
    forval i = 1/`=rowsof(rnames_`var')' {
        if rnames_`var'[`i', 1] == 1 {
            local modalite1_exists = 1
            local count1 = freq_`var'[`i', 1]
            scalar proportion1 = (`count1' / total_effectifs) * 100
        }
    }

    * Si la modalité "1" n'existe pas, la proportion est 0
    if `modalite1_exists' == 0 {
        scalar proportion1 = 0
    }

    * Formatage des proportions à 2 décimales
    local proportion_formatted : display %9.2f proportion1

    * Ajouter les données au fichier Excel
    putexcel A`row' = "`label'"
    putexcel B`row' = `count1'
    putexcel C`row' = "`proportion_formatted'"
    putexcel D`row' = total_effectifs

    * Stocker les données pour le graphique
    post `prop_table' ("`label'") (proportion1)

    * Passer à la ligne suivante
    local row = `row' + 1
}

preserve

* Fermer le fichier temporaire
postclose `prop_table'

* Charger les données des proportions pour générer le graphique
use prop_data.dta, clear

* Générer un graphique en barres des proportions (horizontales)
graph hbar (asis) Proportion, over(Indicator, sort(1) descending) ///
    bar(1, color(blue)) ///
    title("Proportion of Family Planning Knowledge") ///
    ytitle("Proportion (%)") ///
    blabel(bar, format(%9.1f)) ///
    graphregion(margin(zero)) plotregion(margin(small)) // Réduction des marges

* Exporter le graphique en image PNG avec une taille réduite
graph export "PF_Knowledge_Graph1.png", width(600) height(400) replace

* Insérer le graphique dans Excel avec une taille réduite
putexcel G1 = image("PF_Knowledge_Graph1.png")

restore	


	
	****Région
	
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("ATTITUDE FAVORABLE (80%)") modify

* Définir les variables d'analyse
global var2 "Favorable_PF80 Favorable_DIU80 Favorable_INJECTABLES80 Favorable_IMPLANTS80 Favorable_PILULE80 Favorable_CONTRACEPURG80 Favorable_PRESERVATFEM80 Favorable_STERILISFEM80 Favorable_STERILISMAS80"
global regions "DAKAR DIOURBEL FATICK KAFFRINE KAOLACK KEDOUGOU KOLDA LOUGA MATAM SAINTLOUIS SEDHIOU TAMBACOUNDA THIES ZIGUINCHOR"

* Ajouter le titre du tableau
putexcel A15 = "Table 2: Favorable attitude of family planning methods by region (80%)"

* Ajouter les en-têtes des colonnes (régions)
putexcel A16 = "Indicators"

* Initialiser la première colonne pour les régions (B = colonne 2)
local col = 2

foreach region in $regions {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la région
    putexcel `count_col_letter'16 = "`region' - Counts"
    putexcel `prop_col_letter'16 = "`region' - Proportions"
    putexcel `total_col_letter'16 = "`region' - Total"

    * Incrémenter de 3 pour passer à la prochaine région
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 17
local row = 17

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les régions
    local col = 2  // Colonne de départ pour les effectifs des régions (B)

    * Boucler sur chaque région
    foreach region in $regions {
        * Filtrer les données pour la région actuelle
        preserve
        keep if region == "`region'"
        
        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)
        
        num2col `=`col' + 1'
        local prop_col_letter = r(colname)
        
        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer à la prochaine région (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	
	
	

	
	****Structures	

	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("ATTITUDE FAVORABLE (80%)") modify

* Définir les variables d'analyse
global var2 "Favorable_PF80 Favorable_DIU80 Favorable_INJECTABLES80 Favorable_IMPLANTS80 Favorable_PILULE80 Favorable_CONTRACEPURG80 Favorable_PRESERVATFEM80 Favorable_STERILISFEM80 Favorable_STERILISMAS80"
global structures "Hospital HealthCenter HealthPost"  // Liste des structures de santé

* Ajouter le titre du tableau à partir de la ligne 30
putexcel A30 = "Table 3: Favorable attitude of family planning methods by structure of health facilities (80%)"

* Ajouter les en-têtes des colonnes (structures)
putexcel A31 = "Indicators"

* Initialiser la première colonne pour les structures (B = colonne 2)
local col = 2

foreach structure in $structures {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la structure
    putexcel `count_col_letter'31 = "`structure' - Counts"
    putexcel `prop_col_letter'31 = "`structure' - Proportions (%)"
    putexcel `total_col_letter'31 = "`structure' - Total"

    * Incrémenter de 3 pour passer à la structure suivante
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 32
local row = 32

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les structures
    local col = 2  // Colonne de départ pour les structures (B)

    * Boucler sur chaque structure
    foreach structure in $structures {
        * Filtrer les données pour la structure actuelle
        preserve
        keep if Structure == "`structure'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)
        
        num2col `=`col' + 1'
        local prop_col_letter = r(colname)
        
        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer à la prochaine structure (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}

	
	
	****Place of residence
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("ATTITUDE FAVORABLE (80%)") modify

* Définir les variables d'analyse
global var2 "Favorable_PF80 Favorable_DIU80 Favorable_INJECTABLES80 Favorable_IMPLANTS80 Favorable_PILULE80 Favorable_CONTRACEPURG80 Favorable_PRESERVATFEM80 Favorable_STERILISFEM80 Favorable_STERILISMAS80"
global places "Rural Urban"  // Liste des lieux

* Ajouter le titre du tableau à partir de la ligne 30
putexcel A45 = "Table 3: Favorable attitude of family planning methods by place (80%)"

* Ajouter les en-têtes des colonnes (lieux)
putexcel A46 = "Indicators"

* Initialiser la première colonne pour les lieux (B = colonne 2)
local col = 2

foreach place in $places {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour chaque lieu
    putexcel `count_col_letter'46 = "`place' - Counts"
    putexcel `prop_col_letter'46 = "`place' - Proportions (%)"
    putexcel `total_col_letter'46 = "`place' - Total"

    * Incrémenter de 3 pour passer au prochain lieu
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 47
local row = 47

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les lieux
    local col = 2  // Colonne de départ pour les lieux (B)

    * Boucler sur chaque lieu
    foreach place in $places {
        * Filtrer les données pour le lieu actuel
        preserve
        keep if Place == "`place'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)

        num2col `=`col' + 1'
        local prop_col_letter = r(colname)

        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer au prochain lieu (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	
	
	
	
	
	
			***ATTITUDE FAVORABLE A 70%***		
		
			
	****National
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("ATTITUDE FAVORABLE (70%)") modify

* Définir les variables (indicateurs de la connaissance des méthodes de PF)
global var2 "Favorable_PF70 Favorable_DIU70 Favorable_INJECTABLES70 Favorable_IMPLANTS70 Favorable_PILULE70 Favorable_CONTRACEPURG70 Favorable_PRESERVATFEM70 Favorable_STERILISFEM70 Favorable_STERILISMAS70"

* Ajouter le titre du tableau
putexcel A1 = "Table 1: Favorable attitude of family planning methods at the national level (70%)"

* Ajouter les en-têtes des colonnes
putexcel A2 = "Indicators" B2 = "Counts (Effectifs)" C2 = "Proportions (%)" D2 = "Total"

* Initialiser une ligne pour écrire les données
local row = 3

* Créer une table temporaire pour stocker les données des proportions
tempname prop_table
postfile `prop_table' str50 Indicator double Proportion using prop_data.dta, replace

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Calculer les effectifs et proportions
    tabulate `var', matcell(freq_`var') matrow(rnames_`var')

    * Initialiser les valeurs par défaut
    local count1 = 0
    scalar proportion1 = 0
    scalar total_effectifs = 0

    * Calculer le total des effectifs (même s'il n'y a qu'une seule modalité)
    forval i = 1/`=rowsof(freq_`var')' {
        scalar total_effectifs = total_effectifs + freq_`var'[`i', 1]
    }

    * Vérifier si la modalité "1" existe
    local modalite1_exists = 0
    forval i = 1/`=rowsof(rnames_`var')' {
        if rnames_`var'[`i', 1] == 1 {
            local modalite1_exists = 1
            local count1 = freq_`var'[`i', 1]
            scalar proportion1 = (`count1' / total_effectifs) * 100
        }
    }

    * Si la modalité "1" n'existe pas, la proportion est 0
    if `modalite1_exists' == 0 {
        scalar proportion1 = 0
    }

    * Formatage des proportions à 2 décimales
    local proportion_formatted : display %9.2f proportion1

    * Ajouter les données au fichier Excel
    putexcel A`row' = "`label'"
    putexcel B`row' = `count1'
    putexcel C`row' = "`proportion_formatted'"
    putexcel D`row' = total_effectifs

    * Stocker les données pour le graphique
    post `prop_table' ("`label'") (proportion1)

    * Passer à la ligne suivante
    local row = `row' + 1
}

preserve

* Fermer le fichier temporaire
postclose `prop_table'

* Charger les données des proportions pour générer le graphique
use prop_data.dta, clear

* Générer un graphique en barres des proportions (horizontales)
graph hbar (asis) Proportion, over(Indicator, sort(1) descending) ///
    bar(1, color(blue)) ///
    title("Proportion of Family Planning Knowledge") ///
    ytitle("Proportion (%)") ///
    blabel(bar, format(%9.1f)) ///
    graphregion(margin(zero)) plotregion(margin(small)) // Réduction des marges

* Exporter le graphique en image PNG avec une taille réduite
graph export "PF_Knowledge_Graph1.png", width(600) height(400) replace

* Insérer le graphique dans Excel avec une taille réduite
putexcel G1 = image("PF_Knowledge_Graph1.png")

restore	


	
	****Région
	
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("ATTITUDE FAVORABLE (70%)") modify

* Définir les variables d'analyse
global var2 "Favorable_PF70 Favorable_DIU70 Favorable_INJECTABLES70 Favorable_IMPLANTS70 Favorable_PILULE70 Favorable_CONTRACEPURG70 Favorable_PRESERVATFEM70 Favorable_STERILISFEM70 Favorable_STERILISMAS70"
global regions "DAKAR DIOURBEL FATICK KAFFRINE KAOLACK KEDOUGOU KOLDA LOUGA MATAM SAINTLOUIS SEDHIOU TAMBACOUNDA THIES ZIGUINCHOR"

* Ajouter le titre du tableau
putexcel A15 = "Table 2: Favorable attitude of family planning methods by region (70%)"

* Ajouter les en-têtes des colonnes (régions)
putexcel A16 = "Indicators"

* Initialiser la première colonne pour les régions (B = colonne 2)
local col = 2

foreach region in $regions {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la région
    putexcel `count_col_letter'16 = "`region' - Counts"
    putexcel `prop_col_letter'16 = "`region' - Proportions"
    putexcel `total_col_letter'16 = "`region' - Total"

    * Incrémenter de 3 pour passer à la prochaine région
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 17
local row = 17

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les régions
    local col = 2  // Colonne de départ pour les effectifs des régions (B)

    * Boucler sur chaque région
    foreach region in $regions {
        * Filtrer les données pour la région actuelle
        preserve
        keep if region == "`region'"
        
        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)
        
        num2col `=`col' + 1'
        local prop_col_letter = r(colname)
        
        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer à la prochaine région (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	
	
	

	
	****Structures	

	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("ATTITUDE FAVORABLE (70%)") modify

* Définir les variables d'analyse
global var2 "Favorable_PF70 Favorable_DIU70 Favorable_INJECTABLES70 Favorable_IMPLANTS70 Favorable_PILULE70 Favorable_CONTRACEPURG70 Favorable_PRESERVATFEM70 Favorable_STERILISFEM70 Favorable_STERILISMAS70"
global structures "Hospital HealthCenter HealthPost"  // Liste des structures de santé

* Ajouter le titre du tableau à partir de la ligne 30
putexcel A30 = "Table 3: Favorable attitude of family planning methods by structure of health facilities (70%)"

* Ajouter les en-têtes des colonnes (structures)
putexcel A31 = "Indicators"

* Initialiser la première colonne pour les structures (B = colonne 2)
local col = 2

foreach structure in $structures {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la structure
    putexcel `count_col_letter'31 = "`structure' - Counts"
    putexcel `prop_col_letter'31 = "`structure' - Proportions (%)"
    putexcel `total_col_letter'31 = "`structure' - Total"

    * Incrémenter de 3 pour passer à la structure suivante
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 32
local row = 32

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les structures
    local col = 2  // Colonne de départ pour les structures (B)

    * Boucler sur chaque structure
    foreach structure in $structures {
        * Filtrer les données pour la structure actuelle
        preserve
        keep if Structure == "`structure'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)
        
        num2col `=`col' + 1'
        local prop_col_letter = r(colname)
        
        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer à la prochaine structure (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}

	
	
	****Place of residence
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("ATTITUDE FAVORABLE (70%)") modify

* Définir les variables d'analyse
global var2 "Favorable_PF70 Favorable_DIU70 Favorable_INJECTABLES70 Favorable_IMPLANTS70 Favorable_PILULE70 Favorable_CONTRACEPURG70 Favorable_PRESERVATFEM70 Favorable_STERILISFEM70 Favorable_STERILISMAS70"
global places "Rural Urban"  // Liste des lieux

* Ajouter le titre du tableau à partir de la ligne 30
putexcel A45 = "Table 3: Favorable attitude of family planning methods by place (70%)"

* Ajouter les en-têtes des colonnes (lieux)
putexcel A46 = "Indicators"

* Initialiser la première colonne pour les lieux (B = colonne 2)
local col = 2

foreach place in $places {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour chaque lieu
    putexcel `count_col_letter'46 = "`place' - Counts"
    putexcel `prop_col_letter'46 = "`place' - Proportions (%)"
    putexcel `total_col_letter'46 = "`place' - Total"

    * Incrémenter de 3 pour passer au prochain lieu
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 47
local row = 47

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les lieux
    local col = 2  // Colonne de départ pour les lieux (B)

    * Boucler sur chaque lieu
    foreach place in $places {
        * Filtrer les données pour le lieu actuel
        preserve
        keep if Place == "`place'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)

        num2col `=`col' + 1'
        local prop_col_letter = r(colname)

        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer au prochain lieu (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	
	
	
					
			
			
			
			***ATTITUDE FAVORABLE A 60%***		
			
				
			
	****National
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("ATTITUDE FAVORABLE (60%)") modify

* Définir les variables (indicateurs de la connaissance des méthodes de PF)
global var2 "Favorable_PF60 Favorable_DIU60 Favorable_INJECTABLES60 Favorable_IMPLANTS60 Favorable_PILULE60 Favorable_CONTRACEPURG60 Favorable_PRESERVATFEM60 Favorable_STERILISFEM60 Favorable_STERILISMAS60"

* Ajouter le titre du tableau
putexcel A1 = "Table 1: Favorable attitude of family planning methods at the national level (60%)"

* Ajouter les en-têtes des colonnes
putexcel A2 = "Indicators" B2 = "Counts (Effectifs)" C2 = "Proportions (%)" D2 = "Total"

* Initialiser une ligne pour écrire les données
local row = 3

* Créer une table temporaire pour stocker les données des proportions
tempname prop_table
postfile `prop_table' str50 Indicator double Proportion using prop_data.dta, replace

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Calculer les effectifs et proportions
    tabulate `var', matcell(freq_`var') matrow(rnames_`var')

    * Initialiser les valeurs par défaut
    local count1 = 0
    scalar proportion1 = 0
    scalar total_effectifs = 0

    * Calculer le total des effectifs (même s'il n'y a qu'une seule modalité)
    forval i = 1/`=rowsof(freq_`var')' {
        scalar total_effectifs = total_effectifs + freq_`var'[`i', 1]
    }

    * Vérifier si la modalité "1" existe
    local modalite1_exists = 0
    forval i = 1/`=rowsof(rnames_`var')' {
        if rnames_`var'[`i', 1] == 1 {
            local modalite1_exists = 1
            local count1 = freq_`var'[`i', 1]
            scalar proportion1 = (`count1' / total_effectifs) * 100
        }
    }

    * Si la modalité "1" n'existe pas, la proportion est 0
    if `modalite1_exists' == 0 {
        scalar proportion1 = 0
    }

    * Formatage des proportions à 2 décimales
    local proportion_formatted : display %9.2f proportion1

    * Ajouter les données au fichier Excel
    putexcel A`row' = "`label'"
    putexcel B`row' = `count1'
    putexcel C`row' = "`proportion_formatted'"
    putexcel D`row' = total_effectifs

    * Stocker les données pour le graphique
    post `prop_table' ("`label'") (proportion1)

    * Passer à la ligne suivante
    local row = `row' + 1
}

preserve

* Fermer le fichier temporaire
postclose `prop_table'

* Charger les données des proportions pour générer le graphique
use prop_data.dta, clear

* Générer un graphique en barres des proportions (horizontales)
graph hbar (asis) Proportion, over(Indicator, sort(1) descending) ///
    bar(1, color(blue)) ///
    title("Proportion of Family Planning Knowledge") ///
    ytitle("Proportion (%)") ///
    blabel(bar, format(%9.1f)) ///
    graphregion(margin(zero)) plotregion(margin(small)) // Réduction des marges

* Exporter le graphique en image PNG avec une taille réduite
graph export "PF_Knowledge_Graph1.png", width(600) height(400) replace

* Insérer le graphique dans Excel avec une taille réduite
putexcel G1 = image("PF_Knowledge_Graph1.png")

restore	


	
	****Région
	
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("ATTITUDE FAVORABLE (60%)") modify

* Définir les variables d'analyse
global var2 "Favorable_PF60 Favorable_DIU60 Favorable_INJECTABLES60 Favorable_IMPLANTS60 Favorable_PILULE60 Favorable_CONTRACEPURG60 Favorable_PRESERVATFEM60 Favorable_STERILISFEM60 Favorable_STERILISMAS60"
global regions "DAKAR DIOURBEL FATICK KAFFRINE KAOLACK KEDOUGOU KOLDA LOUGA MATAM SAINTLOUIS SEDHIOU TAMBACOUNDA THIES ZIGUINCHOR"

* Ajouter le titre du tableau
putexcel A15 = "Table 2: Favorable attitude of family planning methods by region (60%)"

* Ajouter les en-têtes des colonnes (régions)
putexcel A16 = "Indicators"

* Initialiser la première colonne pour les régions (B = colonne 2)
local col = 2

foreach region in $regions {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la région
    putexcel `count_col_letter'16 = "`region' - Counts"
    putexcel `prop_col_letter'16 = "`region' - Proportions"
    putexcel `total_col_letter'16 = "`region' - Total"

    * Incrémenter de 3 pour passer à la prochaine région
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 17
local row = 17

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les régions
    local col = 2  // Colonne de départ pour les effectifs des régions (B)

    * Boucler sur chaque région
    foreach region in $regions {
        * Filtrer les données pour la région actuelle
        preserve
        keep if region == "`region'"
        
        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)
        
        num2col `=`col' + 1'
        local prop_col_letter = r(colname)
        
        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer à la prochaine région (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	
	
	

	
	****Structures	

	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("ATTITUDE FAVORABLE (60%)") modify

* Définir les variables d'analyse
global var2 "Favorable_PF60 Favorable_DIU60 Favorable_INJECTABLES60 Favorable_IMPLANTS60 Favorable_PILULE60 Favorable_CONTRACEPURG60 Favorable_PRESERVATFEM60 Favorable_STERILISFEM60 Favorable_STERILISMAS60"
global structures "Hospital HealthCenter HealthPost"  // Liste des structures de santé

* Ajouter le titre du tableau à partir de la ligne 30
putexcel A30 = "Table 3: Favorable attitude of family planning methods by structure of health facilities (60%)"

* Ajouter les en-têtes des colonnes (structures)
putexcel A31 = "Indicators"

* Initialiser la première colonne pour les structures (B = colonne 2)
local col = 2

foreach structure in $structures {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la structure
    putexcel `count_col_letter'31 = "`structure' - Counts"
    putexcel `prop_col_letter'31 = "`structure' - Proportions (%)"
    putexcel `total_col_letter'31 = "`structure' - Total"

    * Incrémenter de 3 pour passer à la structure suivante
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 32
local row = 32

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les structures
    local col = 2  // Colonne de départ pour les structures (B)

    * Boucler sur chaque structure
    foreach structure in $structures {
        * Filtrer les données pour la structure actuelle
        preserve
        keep if Structure == "`structure'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)
        
        num2col `=`col' + 1'
        local prop_col_letter = r(colname)
        
        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer à la prochaine structure (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}

	
	
	****Place of residence
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("ATTITUDE FAVORABLE (60%)") modify

* Définir les variables d'analyse
global var2 "Favorable_PF60 Favorable_DIU60 Favorable_INJECTABLES60 Favorable_IMPLANTS60 Favorable_PILULE60 Favorable_CONTRACEPURG60 Favorable_PRESERVATFEM60 Favorable_STERILISFEM60 Favorable_STERILISMAS60"
global places "Rural Urban"  // Liste des lieux

* Ajouter le titre du tableau à partir de la ligne 30
putexcel A45 = "Table 3: Favorable attitude of family planning methods by place (60%)"

* Ajouter les en-têtes des colonnes (lieux)
putexcel A46 = "Indicators"

* Initialiser la première colonne pour les lieux (B = colonne 2)
local col = 2

foreach place in $places {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour chaque lieu
    putexcel `count_col_letter'46 = "`place' - Counts"
    putexcel `prop_col_letter'46 = "`place' - Proportions (%)"
    putexcel `total_col_letter'46 = "`place' - Total"

    * Incrémenter de 3 pour passer au prochain lieu
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 47
local row = 47

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les lieux
    local col = 2  // Colonne de départ pour les lieux (B)

    * Boucler sur chaque lieu
    foreach place in $places {
        * Filtrer les données pour le lieu actuel
        preserve
        keep if Place == "`place'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)

        num2col `=`col' + 1'
        local prop_col_letter = r(colname)

        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer au prochain lieu (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	
	
	
				
			***ATTITUDE FAVORABLE (SCORE NORMALISE)
			
			
			
	****National

	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("SCORE ATTITUDE FAVORABLE") modify

* Définir les variables des scores à analyser
global var2 "Score_Attitude_PF_N Score_Attitude_DIU_N Score_Attitude_INJECTABLES_N Score_Attitude_IMPLANTS_N Score_Attitude_PILULE_N Score_Attitude_CONTRACEPURG_N Score_Attitude_PRESERVATFEM_N Score_Attitude_STERILISFEM_N Score_Attitude_STERILISMAS_N"

* Ajouter le titre du tableau
putexcel A1 = "Table 1: Average scores of Favorable attitude of family planning methods at National level"

* Ajouter les en-têtes des colonnes
putexcel A2 = "Indicators" B2 = "Mean Score" C2 = "Standard Deviation" D2 = "Number of Observations"

* Initialiser une ligne pour écrire les données
local row = 3

* Créer une table temporaire pour stocker les données pour le graphique
tempname graph_data
postfile `graph_data' str50 Indicator double Mean double Std_Dev double N using prop_graph.dta, replace

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Calculer la moyenne, l'écart-type et le nombre d'observations
    quietly summarize `var'

    local mean_score = r(mean)
    local std_dev = r(sd)
    local num_obs = r(N)

    * Formatage des valeurs pour Excel
    local mean_formatted : display %9.2f `mean_score'
    local std_dev_formatted : display %9.2f `std_dev'

    * Ajouter les données au fichier Excel
    putexcel A`row' = "`label'"
    putexcel B`row' = `mean_formatted'
    putexcel C`row' = `std_dev_formatted'
    putexcel D`row' = `num_obs'

    * Stocker les données pour le graphique
    post `graph_data' ("`label'") (`mean_score') (`std_dev') (`num_obs')

    * Passer à la ligne suivante
    local row = `row' + 1
}

preserve

* Fermer le fichier temporaire
postclose `graph_data'

* Charger les données pour générer le Bar Chart
use prop_graph.dta, clear

* Vérifier si les données existent avant d'afficher le graphique
count if !missing(Mean)
if r(N) == 0 {
    display "Aucune donnée disponible pour le graphique."
    exit
}

* Générer un `bar chart` pour les moyennes des scores
graph hbar (mean) Mean, over(Indicator, sort(1) descending) ///
    bar(1, color(blue)) ///
    title("Average Scores of Correct Knowledge by Indicator") ///
    ytitle("Mean Score") ///
    blabel(bar, format(%9.2f)) ///
    graphregion(margin(zero)) plotregion(margin(small)) // Réduction des marges

* Exporter le graphique en image PNG avec une taille réduite
graph export "PF_Knowledge_Graph_Bar.png", width(600) height(400) replace

* Insérer le graphique dans Excel sous la table
local graph_row = `row' + 2  // Position du graphique après le tableau
putexcel I1 = image("PF_Knowledge_Graph_Bar.png")

restore	

* Message de confirmation
display "Les résultats et le graphique Bar Chart ont été exportés dans 'NURSES&MIDWIVES.xlsx' !"	


	
	****Région
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("SCORE ATTITUDE FAVORABLE") modify

* Définir les variables des scores à analyser
global var2 "Score_Attitude_PF_N Score_Attitude_DIU_N Score_Attitude_INJECTABLES_N Score_Attitude_IMPLANTS_N Score_Attitude_PILULE_N Score_Attitude_CONTRACEPURG_N Score_Attitude_PRESERVATFEM_N Score_Attitude_STERILISFEM_N Score_Attitude_STERILISMAS_N"
global regions "DAKAR DIOURBEL FATICK KAFFRINE KAOLACK KEDOUGOU KOLDA LOUGA MATAM SAINTLOUIS SEDHIOU TAMBACOUNDA THIES ZIGUINCHOR"

* Ajouter le titre du tableau
putexcel A15 = "Table 2: Average scores of Favorable attitude of family planning methods by region"

* Ajouter les en-têtes des colonnes (régions)
putexcel A16 = "Indicators"

* Initialiser la première colonne pour les régions (B = colonne 2)
local col = 2

foreach region in $regions {
    * Définir les colonnes pour Moyenne, Écart-type et Nombre d'observations
    num2col `col'
    local mean_col_letter = r(colname)

    num2col `=`col' + 1'
    local std_col_letter = r(colname)

    num2col `=`col' + 2'
    local n_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la région
    putexcel `mean_col_letter'16 = "`region' - Mean Score"
    putexcel `std_col_letter'16 = "`region' - Std Dev"
    putexcel `n_col_letter'16 = "`region' - N"

    * Incrémenter de 3 pour passer à la prochaine région
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 17
local row = 17

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les régions
    local col = 2  // Colonne de départ pour les régions (B)

    * Boucler sur chaque région
    foreach region in $regions {
        * Filtrer les données pour la région actuelle
        preserve
        keep if region == "`region'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" aux valeurs
            local mean_score = 0
            local std_dev = 0
            local num_obs = 0
        }
        else {
            * Calculer la moyenne, l'écart-type et le nombre d'observations
            quietly summarize `var'

            local mean_score = r(mean)
            local std_dev = r(sd)
            local num_obs = r(N)
        }

        * Formatage des valeurs pour Excel
        local mean_formatted : display %9.2f `mean_score'
        local std_dev_formatted : display %9.2f `std_dev'

        * Définir les colonnes pour les scores
        num2col `col'
        local mean_col_letter = r(colname)

        num2col `=`col' + 1'
        local std_col_letter = r(colname)

        num2col `=`col' + 2'
        local n_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `mean_col_letter'`row' = `mean_formatted'
        putexcel `std_col_letter'`row' = "`std_dev_formatted'"
        putexcel `n_col_letter'`row' = `num_obs'

        restore
        local col = `col' + 3  // Passer à la prochaine région
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}

	
	
	****Structures	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("SCORE ATTITUDE FAVORABLE") modify

* Définir les variables des scores à analyser
global var2 "Score_Attitude_PF_N Score_Attitude_DIU_N Score_Attitude_INJECTABLES_N Score_Attitude_IMPLANTS_N Score_Attitude_PILULE_N Score_Attitude_CONTRACEPURG_N Score_Attitude_PRESERVATFEM_N Score_Attitude_STERILISFEM_N Score_Attitude_STERILISMAS_N"
global structures "Hospital HealthCenter HealthPost"  // Liste des structures de santé

* Ajouter le titre du tableau
putexcel A35 = "Table 2: Average scores of Favorable attitude of family planning methods by structure"

* Ajouter les en-têtes des colonnes (structures)
putexcel A36 = "Indicators"

* Initialiser la première colonne pour les structures (B = colonne 2)
local col = 2

foreach structure in $structures {
    * Définir les colonnes pour Moyenne, Écart-type et Nombre d'observations
    num2col `col'
    local mean_col_letter = r(colname)

    num2col `=`col' + 1'
    local std_col_letter = r(colname)

    num2col `=`col' + 2'
    local n_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la structure
    putexcel `mean_col_letter'36 = "`structure' - Mean Score"
    putexcel `std_col_letter'36 = "`structure' - Std Dev"
    putexcel `n_col_letter'36 = "`structure' - N"

    * Incrémenter de 3 pour passer à la prochaine structure
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 37
local row = 37

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les structures
    local col = 2  // Colonne de départ pour les structures (B)

    * Boucler sur chaque structure
    foreach structure in $structures {
        * Filtrer les données pour la structure actuelle
        preserve
        keep if Structure == "`structure'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" aux valeurs
            local mean_score = 0
            local std_dev = 0
            local num_obs = 0
        }
        else {
            * Calculer la moyenne, l'écart-type et le nombre d'observations
            quietly summarize `var'

            local mean_score = r(mean)
            local std_dev = r(sd)
            local num_obs = r(N)
        }

        * Formatage des valeurs pour Excel
        local mean_formatted : display %9.2f `mean_score'
        local std_dev_formatted : display %9.2f `std_dev'

        * Définir les colonnes pour les scores
        num2col `col'
        local mean_col_letter = r(colname)

        num2col `=`col' + 1'
        local std_col_letter = r(colname)

        num2col `=`col' + 2'
        local n_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `mean_col_letter'`row' = `mean_formatted'
        putexcel `std_col_letter'`row' = "`std_dev_formatted'"
        putexcel `n_col_letter'`row' = `num_obs'

        restore
        local col = `col' + 3  // Passer à la prochaine structure
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	
	
	
	
	****Place of residence
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("SCORE ATTITUDE FAVORABLE") modify

* Définir les variables des scores à analyser
global var2 "Score_Attitude_PF_N Score_Attitude_DIU_N Score_Attitude_INJECTABLES_N Score_Attitude_IMPLANTS_N Score_Attitude_PILULE_N Score_Attitude_CONTRACEPURG_N Score_Attitude_PRESERVATFEM_N Score_Attitude_STERILISFEM_N Score_Attitude_STERILISMAS_N"
global places "Rural Urban"  // Liste des lieux de résidence

* Ajouter le titre du tableau
putexcel A45 = "Table 2: Average scores of Favorable attitude of family planning methods by place (Rural, Urban)"

* Ajouter les en-têtes des colonnes (lieux)
putexcel A46 = "Indicators"

* Initialiser la première colonne pour les lieux (B = colonne 2)
local col = 2

foreach place in $places {
    * Définir les colonnes pour Moyenne, Écart-type et Nombre d'observations
    num2col `col'
    local mean_col_letter = r(colname)

    num2col `=`col' + 1'
    local std_col_letter = r(colname)

    num2col `=`col' + 2'
    local n_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour le lieu de résidence
    putexcel `mean_col_letter'46 = "`place' - Mean Score"
    putexcel `std_col_letter'46 = "`place' - Std Dev"
    putexcel `n_col_letter'46 = "`place' - N"

    * Incrémenter de 3 pour passer au prochain lieu
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 47
local row = 47

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les lieux de résidence
    local col = 2  // Colonne de départ pour les lieux (B)

    * Boucler sur chaque lieu
    foreach place in $places {
        * Filtrer les données pour le lieu actuel
        preserve
        keep if Place == "`place'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" aux valeurs
            local mean_score = 0
            local std_dev = 0
            local num_obs = 0
        }
        else {
            * Calculer la moyenne, l'écart-type et le nombre d'observations
            quietly summarize `var'

            local mean_score = r(mean)
            local std_dev = r(sd)
            local num_obs = r(N)
        }

        * Formatage des valeurs pour Excel
        local mean_formatted : display %9.2f `mean_score'
        local std_dev_formatted : display %9.2f `std_dev'

        * Définir les colonnes pour les scores
        num2col `col'
        local mean_col_letter = r(colname)

        num2col `=`col' + 1'
        local std_col_letter = r(colname)

        num2col `=`col' + 2'
        local n_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `mean_col_letter'`row' = `mean_formatted'
        putexcel `std_col_letter'`row' = "`std_dev_formatted'"
        putexcel `n_col_letter'`row' = `num_obs'

        restore
        local col = `col' + 3  // Passer au prochain lieu
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}			
			
				
		
			
			
			***FORMATION EN PF	
		
		
			
			
	****National

	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("FORMATION EN PF") modify

* Définir les variables des scores à analyser
global var2 "Formation_DIU Formation_INJECT Formation_PRESERMAS Formation_PRESERFEM Formation_CONTRACURG Formation_PILLS Formation_IMPLANTS Formation_STERILIZFEM Formation_STERILIZMAS Formation_MATEXCLU"

* Ajouter le titre du tableau
putexcel A1 = "Table 1: Training of family planning methods at National level"

* Ajouter les en-têtes des colonnes
putexcel A2 = "Indicators" B2 = "Mean Score" C2 = "Standard Deviation" D2 = "Number of Observations"

* Initialiser une ligne pour écrire les données
local row = 3

* Créer une table temporaire pour stocker les données pour le graphique
tempname graph_data
postfile `graph_data' str50 Indicator double Mean double Std_Dev double N using prop_graph.dta, replace

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Calculer la moyenne, l'écart-type et le nombre d'observations
    quietly summarize `var'

    local mean_score = r(mean)
    local std_dev = r(sd)
    local num_obs = r(N)

    * Formatage des valeurs pour Excel
    local mean_formatted : display %9.2f `mean_score'
    local std_dev_formatted : display %9.2f `std_dev'

    * Ajouter les données au fichier Excel
    putexcel A`row' = "`label'"
    putexcel B`row' = `mean_formatted'
    putexcel C`row' = `std_dev_formatted'
    putexcel D`row' = `num_obs'

    * Stocker les données pour le graphique
    post `graph_data' ("`label'") (`mean_score') (`std_dev') (`num_obs')

    * Passer à la ligne suivante
    local row = `row' + 1
}

preserve

* Fermer le fichier temporaire
postclose `graph_data'

* Charger les données pour générer le Bar Chart
use prop_graph.dta, clear

* Vérifier si les données existent avant d'afficher le graphique
count if !missing(Mean)
if r(N) == 0 {
    display "Aucune donnée disponible pour le graphique."
    exit
}

* Générer un `bar chart` pour les moyennes des scores
graph bar (mean) Mean, over(Indicator, sort(1) descending) ///
    bar(1, color(blue)) ///
    title("Average Scores of Correct Knowledge by Indicator") ///
    ytitle("Mean Score") ///
    blabel(bar, format(%9.2f)) ///
    graphregion(margin(zero)) plotregion(margin(small)) // Réduction des marges

* Exporter le graphique en image PNG avec une taille réduite
graph export "PF_Knowledge_Graph_Bar.png", width(600) height(400) replace

* Insérer le graphique dans Excel sous la table
local graph_row = `row' + 2  // Position du graphique après le tableau
putexcel I1 = image("PF_Knowledge_Graph_Bar.png")

restore	

* Message de confirmation
display "Les résultats et le graphique Bar Chart ont été exportés dans 'NURSES&MIDWIVES.xlsx' !"	


	
	****Région
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("FORMATION EN PF") modify

* Définir les variables des scores à analyser
global var2 "Formation_DIU Formation_INJECT Formation_PRESERMAS Formation_PRESERFEM Formation_CONTRACURG Formation_PILLS Formation_IMPLANTS Formation_STERILIZFEM Formation_STERILIZMAS Formation_MATEXCLU"
global regions "DAKAR DIOURBEL FATICK KAFFRINE KAOLACK KEDOUGOU KOLDA LOUGA MATAM SAINTLOUIS SEDHIOU TAMBACOUNDA THIES ZIGUINCHOR"

* Ajouter le titre du tableau
putexcel A15 = "Table 2: Training of family planning methods by region"

* Ajouter les en-têtes des colonnes (régions)
putexcel A16 = "Indicators"

* Initialiser la première colonne pour les régions (B = colonne 2)
local col = 2

foreach region in $regions {
    * Définir les colonnes pour Moyenne, Écart-type et Nombre d'observations
    num2col `col'
    local mean_col_letter = r(colname)

    num2col `=`col' + 1'
    local std_col_letter = r(colname)

    num2col `=`col' + 2'
    local n_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la région
    putexcel `mean_col_letter'16 = "`region' - Mean Score"
    putexcel `std_col_letter'16 = "`region' - Std Dev"
    putexcel `n_col_letter'16 = "`region' - N"

    * Incrémenter de 3 pour passer à la prochaine région
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 17
local row = 17

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les régions
    local col = 2  // Colonne de départ pour les régions (B)

    * Boucler sur chaque région
    foreach region in $regions {
        * Filtrer les données pour la région actuelle
        preserve
        keep if region == "`region'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" aux valeurs
            local mean_score = 0
            local std_dev = 0
            local num_obs = 0
        }
        else {
            * Calculer la moyenne, l'écart-type et le nombre d'observations
            quietly summarize `var'

            local mean_score = r(mean)
            local std_dev = r(sd)
            local num_obs = r(N)
        }

        * Formatage des valeurs pour Excel
        local mean_formatted : display %9.2f `mean_score'
        local std_dev_formatted : display %9.2f `std_dev'

        * Définir les colonnes pour les scores
        num2col `col'
        local mean_col_letter = r(colname)

        num2col `=`col' + 1'
        local std_col_letter = r(colname)

        num2col `=`col' + 2'
        local n_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `mean_col_letter'`row' = `mean_formatted'
        putexcel `std_col_letter'`row' = "`std_dev_formatted'"
        putexcel `n_col_letter'`row' = `num_obs'

        restore
        local col = `col' + 3  // Passer à la prochaine région
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}

	
	
	****Structures	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("FORMATION EN PF") modify

* Définir les variables des scores à analyser
global var2 "Formation_DIU Formation_INJECT Formation_PRESERMAS Formation_PRESERFEM Formation_CONTRACURG Formation_PILLS Formation_IMPLANTS Formation_STERILIZFEM Formation_STERILIZMAS Formation_MATEXCLU"
global structures "Hospital HealthCenter HealthPost"  // Liste des structures de santé

* Ajouter le titre du tableau
putexcel A35 = "Table 2: Training of family planning methods by structure"

* Ajouter les en-têtes des colonnes (structures)
putexcel A36 = "Indicators"

* Initialiser la première colonne pour les structures (B = colonne 2)
local col = 2

foreach structure in $structures {
    * Définir les colonnes pour Moyenne, Écart-type et Nombre d'observations
    num2col `col'
    local mean_col_letter = r(colname)

    num2col `=`col' + 1'
    local std_col_letter = r(colname)

    num2col `=`col' + 2'
    local n_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la structure
    putexcel `mean_col_letter'36 = "`structure' - Mean Score"
    putexcel `std_col_letter'36 = "`structure' - Std Dev"
    putexcel `n_col_letter'36 = "`structure' - N"

    * Incrémenter de 3 pour passer à la prochaine structure
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 37
local row = 37

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les structures
    local col = 2  // Colonne de départ pour les structures (B)

    * Boucler sur chaque structure
    foreach structure in $structures {
        * Filtrer les données pour la structure actuelle
        preserve
        keep if Structure == "`structure'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" aux valeurs
            local mean_score = 0
            local std_dev = 0
            local num_obs = 0
        }
        else {
            * Calculer la moyenne, l'écart-type et le nombre d'observations
            quietly summarize `var'

            local mean_score = r(mean)
            local std_dev = r(sd)
            local num_obs = r(N)
        }

        * Formatage des valeurs pour Excel
        local mean_formatted : display %9.2f `mean_score'
        local std_dev_formatted : display %9.2f `std_dev'

        * Définir les colonnes pour les scores
        num2col `col'
        local mean_col_letter = r(colname)

        num2col `=`col' + 1'
        local std_col_letter = r(colname)

        num2col `=`col' + 2'
        local n_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `mean_col_letter'`row' = `mean_formatted'
        putexcel `std_col_letter'`row' = "`std_dev_formatted'"
        putexcel `n_col_letter'`row' = `num_obs'

        restore
        local col = `col' + 3  // Passer à la prochaine structure
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	
	
	
	
	****Place of residence
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("FORMATION EN PF") modify

* Définir les variables des scores à analyser
global var2 "Formation_DIU Formation_INJECT Formation_PRESERMAS Formation_PRESERFEM Formation_CONTRACURG Formation_PILLS Formation_IMPLANTS Formation_STERILIZFEM Formation_STERILIZMAS Formation_MATEXCLU"
global places "Rural Urban"  // Liste des lieux de résidence

* Ajouter le titre du tableau
putexcel A55 = "Table 2: Training of family planning methods by place (Rural, Urban)"

* Ajouter les en-têtes des colonnes (lieux)
putexcel A56 = "Indicators"

* Initialiser la première colonne pour les lieux (B = colonne 2)
local col = 2

foreach place in $places {
    * Définir les colonnes pour Moyenne, Écart-type et Nombre d'observations
    num2col `col'
    local mean_col_letter = r(colname)

    num2col `=`col' + 1'
    local std_col_letter = r(colname)

    num2col `=`col' + 2'
    local n_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour le lieu de résidence
    putexcel `mean_col_letter'56 = "`place' - Mean Score"
    putexcel `std_col_letter'56 = "`place' - Std Dev"
    putexcel `n_col_letter'56 = "`place' - N"

    * Incrémenter de 3 pour passer au prochain lieu
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 57
local row = 57

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les lieux de résidence
    local col = 2  // Colonne de départ pour les lieux (B)

    * Boucler sur chaque lieu
    foreach place in $places {
        * Filtrer les données pour le lieu actuel
        preserve
        keep if Place == "`place'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" aux valeurs
            local mean_score = 0
            local std_dev = 0
            local num_obs = 0
        }
        else {
            * Calculer la moyenne, l'écart-type et le nombre d'observations
            quietly summarize `var'

            local mean_score = r(mean)
            local std_dev = r(sd)
            local num_obs = r(N)
        }

        * Formatage des valeurs pour Excel
        local mean_formatted : display %9.2f `mean_score'
        local std_dev_formatted : display %9.2f `std_dev'

        * Définir les colonnes pour les scores
        num2col `col'
        local mean_col_letter = r(colname)

        num2col `=`col' + 1'
        local std_col_letter = r(colname)

        num2col `=`col' + 2'
        local n_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `mean_col_letter'`row' = `mean_formatted'
        putexcel `std_col_letter'`row' = "`std_dev_formatted'"
        putexcel `n_col_letter'`row' = `num_obs'

        restore
        local col = `col' + 3  // Passer au prochain lieu
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}			
			
			

				

		
		
		
	
			

			***SMNI CONNAISSANCE CORRECTE (80%)***
					

		
			
	****National
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("MNCH CORRECT KNOWLEDGE (80%)") modify

* Définir les variables (indicateurs de la connaissance des méthodes de PF)
global var2 "Con_ANTENATAL80 Con_maternal80 Con_POSTNATAL80"

* Ajouter le titre du tableau
putexcel A1 = "Table 1: Correct knowledge of MNCH at the national level (80%)"

* Ajouter les en-têtes des colonnes
putexcel A2 = "Indicators" B2 = "Counts (Effectifs)" C2 = "Proportions (%)" D2 = "Total"

* Initialiser une ligne pour écrire les données
local row = 3

* Créer une table temporaire pour stocker les données des proportions
tempname prop_table
postfile `prop_table' str50 Indicator double Proportion using prop_data.dta, replace

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Calculer les effectifs et proportions
    tabulate `var', matcell(freq_`var') matrow(rnames_`var')

    * Initialiser les valeurs par défaut
    local count1 = 0
    scalar proportion1 = 0
    scalar total_effectifs = 0

    * Calculer le total des effectifs (même s'il n'y a qu'une seule modalité)
    forval i = 1/`=rowsof(freq_`var')' {
        scalar total_effectifs = total_effectifs + freq_`var'[`i', 1]
    }

    * Vérifier si la modalité "1" existe
    local modalite1_exists = 0
    forval i = 1/`=rowsof(rnames_`var')' {
        if rnames_`var'[`i', 1] == 1 {
            local modalite1_exists = 1
            local count1 = freq_`var'[`i', 1]
            scalar proportion1 = (`count1' / total_effectifs) * 100
        }
    }

    * Si la modalité "1" n'existe pas, la proportion est 0
    if `modalite1_exists' == 0 {
        scalar proportion1 = 0
    }

    * Formatage des proportions à 2 décimales
    local proportion_formatted : display %9.2f proportion1

    * Ajouter les données au fichier Excel
    putexcel A`row' = "`label'"
    putexcel B`row' = `count1'
    putexcel C`row' = "`proportion_formatted'"
    putexcel D`row' = total_effectifs

    * Stocker les données pour le graphique
    post `prop_table' ("`label'") (proportion1)

    * Passer à la ligne suivante
    local row = `row' + 1
}

preserve

* Fermer le fichier temporaire
postclose `prop_table'

* Charger les données des proportions pour générer le graphique
use prop_data.dta, clear

* Générer un graphique en barres des proportions (horizontales)
graph hbar (asis) Proportion, over(Indicator, sort(1) descending) ///
    bar(1, color(blue)) ///
    title("Proportion of Family Planning Knowledge") ///
    ytitle("Proportion (%)") ///
    blabel(bar, format(%9.1f)) ///
    graphregion(margin(zero)) plotregion(margin(small)) // Réduction des marges

* Exporter le graphique en image PNG avec une taille réduite
graph export "PF_Knowledge_Graph1.png", width(600) height(400) replace

* Insérer le graphique dans Excel avec une taille réduite
putexcel G1 = image("PF_Knowledge_Graph1.png")

restore	


	
	****Région
	
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("MNCH CORRECT KNOWLEDGE (80%)") modify

* Définir les variables d'analyse
global var2 "Con_ANTENATAL80 Con_maternal80 Con_POSTNATAL80"
global regions "DAKAR DIOURBEL FATICK KAFFRINE KAOLACK KEDOUGOU KOLDA LOUGA MATAM SAINTLOUIS SEDHIOU TAMBACOUNDA THIES ZIGUINCHOR"

* Ajouter le titre du tableau
putexcel A15 = "Table 2: Correct knowledge of MNCH by region (80%)"

* Ajouter les en-têtes des colonnes (régions)
putexcel A16 = "Indicators"

* Initialiser la première colonne pour les régions (B = colonne 2)
local col = 2

foreach region in $regions {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la région
    putexcel `count_col_letter'16 = "`region' - Counts"
    putexcel `prop_col_letter'16 = "`region' - Proportions"
    putexcel `total_col_letter'16 = "`region' - Total"

    * Incrémenter de 3 pour passer à la prochaine région
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 17
local row = 17

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les régions
    local col = 2  // Colonne de départ pour les effectifs des régions (B)

    * Boucler sur chaque région
    foreach region in $regions {
        * Filtrer les données pour la région actuelle
        preserve
        keep if region == "`region'"
        
        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)
        
        num2col `=`col' + 1'
        local prop_col_letter = r(colname)
        
        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer à la prochaine région (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	
	
	

	
	****Structures	

	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("MNCH CORRECT KNOWLEDGE (80%)") modify

* Définir les variables d'analyse
global var2 "Con_ANTENATAL80 Con_maternal80 Con_POSTNATAL80"
global structures "Hospital HealthCenter HealthPost"  // Liste des structures de santé

* Ajouter le titre du tableau à partir de la ligne 30
putexcel A30 = "Table 3: Correct knowledge of MNCH by structure of health facilities (80%)"

* Ajouter les en-têtes des colonnes (structures)
putexcel A31 = "Indicators"

* Initialiser la première colonne pour les structures (B = colonne 2)
local col = 2

foreach structure in $structures {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la structure
    putexcel `count_col_letter'31 = "`structure' - Counts"
    putexcel `prop_col_letter'31 = "`structure' - Proportions (%)"
    putexcel `total_col_letter'31 = "`structure' - Total"

    * Incrémenter de 3 pour passer à la structure suivante
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 32
local row = 32

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les structures
    local col = 2  // Colonne de départ pour les structures (B)

    * Boucler sur chaque structure
    foreach structure in $structures {
        * Filtrer les données pour la structure actuelle
        preserve
        keep if Structure == "`structure'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)
        
        num2col `=`col' + 1'
        local prop_col_letter = r(colname)
        
        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer à la prochaine structure (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}

	
	
	****Place of residence
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("MNCH CORRECT KNOWLEDGE (80%)") modify

* Définir les variables d'analyse
global var2 "Con_ANTENATAL80 Con_maternal80 Con_POSTNATAL80"
global places "Rural Urban"  // Liste des lieux

* Ajouter le titre du tableau à partir de la ligne 30
putexcel A45 = "Table 3: Correct knowledge of MNCH by place (80%)"

* Ajouter les en-têtes des colonnes (lieux)
putexcel A46 = "Indicators"

* Initialiser la première colonne pour les lieux (B = colonne 2)
local col = 2

foreach place in $places {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour chaque lieu
    putexcel `count_col_letter'46 = "`place' - Counts"
    putexcel `prop_col_letter'46 = "`place' - Proportions (%)"
    putexcel `total_col_letter'46 = "`place' - Total"

    * Incrémenter de 3 pour passer au prochain lieu
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 47
local row = 47

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les lieux
    local col = 2  // Colonne de départ pour les lieux (B)

    * Boucler sur chaque lieu
    foreach place in $places {
        * Filtrer les données pour le lieu actuel
        preserve
        keep if Place == "`place'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)

        num2col `=`col' + 1'
        local prop_col_letter = r(colname)

        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer au prochain lieu (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	
	
	
	
	
	
	
	
	
	
			***CONNAISSANCE CORRECTE A 70%***		


			
			
			
	****National
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("MNCH CORRECT KNOWLEDGE (70%)") modify

* Définir les variables (indicateurs de la connaissance des méthodes de PF)
global var2 "Con_ANTENATAL70 Con_maternal70 Con_POSTNATAL70"

* Ajouter le titre du tableau
putexcel A1 = "Table 1: Correct knowledge of MNCH at the national level (70%)"

* Ajouter les en-têtes des colonnes
putexcel A2 = "Indicators" B2 = "Counts (Effectifs)" C2 = "Proportions (%)" D2 = "Total"

* Initialiser une ligne pour écrire les données
local row = 3

* Créer une table temporaire pour stocker les données des proportions
tempname prop_table
postfile `prop_table' str50 Indicator double Proportion using prop_data.dta, replace

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Calculer les effectifs et proportions
    tabulate `var', matcell(freq_`var') matrow(rnames_`var')

    * Initialiser les valeurs par défaut
    local count1 = 0
    scalar proportion1 = 0
    scalar total_effectifs = 0

    * Calculer le total des effectifs (même s'il n'y a qu'une seule modalité)
    forval i = 1/`=rowsof(freq_`var')' {
        scalar total_effectifs = total_effectifs + freq_`var'[`i', 1]
    }

    * Vérifier si la modalité "1" existe
    local modalite1_exists = 0
    forval i = 1/`=rowsof(rnames_`var')' {
        if rnames_`var'[`i', 1] == 1 {
            local modalite1_exists = 1
            local count1 = freq_`var'[`i', 1]
            scalar proportion1 = (`count1' / total_effectifs) * 100
        }
    }

    * Si la modalité "1" n'existe pas, la proportion est 0
    if `modalite1_exists' == 0 {
        scalar proportion1 = 0
    }

    * Formatage des proportions à 2 décimales
    local proportion_formatted : display %9.2f proportion1

    * Ajouter les données au fichier Excel
    putexcel A`row' = "`label'"
    putexcel B`row' = `count1'
    putexcel C`row' = "`proportion_formatted'"
    putexcel D`row' = total_effectifs

    * Stocker les données pour le graphique
    post `prop_table' ("`label'") (proportion1)

    * Passer à la ligne suivante
    local row = `row' + 1
}

preserve

* Fermer le fichier temporaire
postclose `prop_table'

* Charger les données des proportions pour générer le graphique
use prop_data.dta, clear

* Générer un graphique en barres des proportions (horizontales)
graph hbar (asis) Proportion, over(Indicator, sort(1) descending) ///
    bar(1, color(blue)) ///
    title("Proportion of Family Planning Knowledge") ///
    ytitle("Proportion (%)") ///
    blabel(bar, format(%9.1f)) ///
    graphregion(margin(zero)) plotregion(margin(small)) // Réduction des marges

* Exporter le graphique en image PNG avec une taille réduite
graph export "PF_Knowledge_Graph1.png", width(600) height(400) replace

* Insérer le graphique dans Excel avec une taille réduite
putexcel G1 = image("PF_Knowledge_Graph1.png")

restore	


	
	****Région
	
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("MNCH CORRECT KNOWLEDGE (70%)") modify

* Définir les variables d'analyse
global var2 "Con_ANTENATAL70 Con_maternal70 Con_POSTNATAL70"
global regions "DAKAR DIOURBEL FATICK KAFFRINE KAOLACK KEDOUGOU KOLDA LOUGA MATAM SAINTLOUIS SEDHIOU TAMBACOUNDA THIES ZIGUINCHOR"

* Ajouter le titre du tableau
putexcel A15 = "Table 2: Correct knowledge of MNCH by region (70%)"

* Ajouter les en-têtes des colonnes (régions)
putexcel A16 = "Indicators"

* Initialiser la première colonne pour les régions (B = colonne 2)
local col = 2

foreach region in $regions {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la région
    putexcel `count_col_letter'16 = "`region' - Counts"
    putexcel `prop_col_letter'16 = "`region' - Proportions"
    putexcel `total_col_letter'16 = "`region' - Total"

    * Incrémenter de 3 pour passer à la prochaine région
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 17
local row = 17

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les régions
    local col = 2  // Colonne de départ pour les effectifs des régions (B)

    * Boucler sur chaque région
    foreach region in $regions {
        * Filtrer les données pour la région actuelle
        preserve
        keep if region == "`region'"
        
        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)
        
        num2col `=`col' + 1'
        local prop_col_letter = r(colname)
        
        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer à la prochaine région (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	
	
	

	
	****Structures	

	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("MNCH CORRECT KNOWLEDGE (70%)") modify

* Définir les variables d'analyse
global var2 "Con_ANTENATAL70 Con_maternal70 Con_POSTNATAL70"
global structures "Hospital HealthCenter HealthPost"  // Liste des structures de santé

* Ajouter le titre du tableau à partir de la ligne 30
putexcel A30 = "Table 3: Correct knowledge of MNCH by structure of health facilities (70%)"

* Ajouter les en-têtes des colonnes (structures)
putexcel A31 = "Indicators"

* Initialiser la première colonne pour les structures (B = colonne 2)
local col = 2

foreach structure in $structures {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la structure
    putexcel `count_col_letter'31 = "`structure' - Counts"
    putexcel `prop_col_letter'31 = "`structure' - Proportions (%)"
    putexcel `total_col_letter'31 = "`structure' - Total"

    * Incrémenter de 3 pour passer à la structure suivante
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 32
local row = 32

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les structures
    local col = 2  // Colonne de départ pour les structures (B)

    * Boucler sur chaque structure
    foreach structure in $structures {
        * Filtrer les données pour la structure actuelle
        preserve
        keep if Structure == "`structure'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)
        
        num2col `=`col' + 1'
        local prop_col_letter = r(colname)
        
        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer à la prochaine structure (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}

	
	
	****Place of residence
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("MNCH CORRECT KNOWLEDGE (70%)") modify

* Définir les variables d'analyse
global var2 "Con_ANTENATAL70 Con_maternal70 Con_POSTNATAL70"
global places "Rural Urban"  // Liste des lieux

* Ajouter le titre du tableau à partir de la ligne 30
putexcel A45 = "Table 3: Correct knowledge of MNCH by place (70%)"

* Ajouter les en-têtes des colonnes (lieux)
putexcel A46 = "Indicators"

* Initialiser la première colonne pour les lieux (B = colonne 2)
local col = 2

foreach place in $places {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour chaque lieu
    putexcel `count_col_letter'46 = "`place' - Counts"
    putexcel `prop_col_letter'46 = "`place' - Proportions (%)"
    putexcel `total_col_letter'46 = "`place' - Total"

    * Incrémenter de 3 pour passer au prochain lieu
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 47
local row = 47

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les lieux
    local col = 2  // Colonne de départ pour les lieux (B)

    * Boucler sur chaque lieu
    foreach place in $places {
        * Filtrer les données pour le lieu actuel
        preserve
        keep if Place == "`place'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)

        num2col `=`col' + 1'
        local prop_col_letter = r(colname)

        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer au prochain lieu (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	
	
	
				
			
			
			
			
			
			
			***CONNAISSANCE CORRECTE A 60%***		
			
			
				
			
	****National
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("MNCH CORRECT KNOWLEDGE (60%)") modify

* Définir les variables (indicateurs de la connaissance des méthodes de PF)
global var2 "Con_ANTENATAL60 Con_maternal60 Con_POSTNATAL60"

* Ajouter le titre du tableau
putexcel A1 = "Table 1: Correct knowledge of MNCH at the national level (60%)"

* Ajouter les en-têtes des colonnes
putexcel A2 = "Indicators" B2 = "Counts (Effectifs)" C2 = "Proportions (%)" D2 = "Total"

* Initialiser une ligne pour écrire les données
local row = 3

* Créer une table temporaire pour stocker les données des proportions
tempname prop_table
postfile `prop_table' str50 Indicator double Proportion using prop_data.dta, replace

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Calculer les effectifs et proportions
    tabulate `var', matcell(freq_`var') matrow(rnames_`var')

    * Initialiser les valeurs par défaut
    local count1 = 0
    scalar proportion1 = 0
    scalar total_effectifs = 0

    * Calculer le total des effectifs (même s'il n'y a qu'une seule modalité)
    forval i = 1/`=rowsof(freq_`var')' {
        scalar total_effectifs = total_effectifs + freq_`var'[`i', 1]
    }

    * Vérifier si la modalité "1" existe
    local modalite1_exists = 0
    forval i = 1/`=rowsof(rnames_`var')' {
        if rnames_`var'[`i', 1] == 1 {
            local modalite1_exists = 1
            local count1 = freq_`var'[`i', 1]
            scalar proportion1 = (`count1' / total_effectifs) * 100
        }
    }

    * Si la modalité "1" n'existe pas, la proportion est 0
    if `modalite1_exists' == 0 {
        scalar proportion1 = 0
    }

    * Formatage des proportions à 2 décimales
    local proportion_formatted : display %9.2f proportion1

    * Ajouter les données au fichier Excel
    putexcel A`row' = "`label'"
    putexcel B`row' = `count1'
    putexcel C`row' = "`proportion_formatted'"
    putexcel D`row' = total_effectifs

    * Stocker les données pour le graphique
    post `prop_table' ("`label'") (proportion1)

    * Passer à la ligne suivante
    local row = `row' + 1
}

preserve

* Fermer le fichier temporaire
postclose `prop_table'

* Charger les données des proportions pour générer le graphique
use prop_data.dta, clear

* Générer un graphique en barres des proportions (horizontales)
graph hbar (asis) Proportion, over(Indicator, sort(1) descending) ///
    bar(1, color(blue)) ///
    title("Proportion of Family Planning Knowledge") ///
    ytitle("Proportion (%)") ///
    blabel(bar, format(%9.1f)) ///
    graphregion(margin(zero)) plotregion(margin(small)) // Réduction des marges

* Exporter le graphique en image PNG avec une taille réduite
graph export "PF_Knowledge_Graph1.png", width(600) height(400) replace

* Insérer le graphique dans Excel avec une taille réduite
putexcel G1 = image("PF_Knowledge_Graph1.png")

restore	


	
	****Région
	
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("MNCH CORRECT KNOWLEDGE (60%)") modify

* Définir les variables d'analyse
global var2 "Con_ANTENATAL60 Con_maternal60 Con_POSTNATAL60"
global regions "DAKAR DIOURBEL FATICK KAFFRINE KAOLACK KEDOUGOU KOLDA LOUGA MATAM SAINTLOUIS SEDHIOU TAMBACOUNDA THIES ZIGUINCHOR"

* Ajouter le titre du tableau
putexcel A15 = "Table 2: Correct knowledge of MNCH by region (60%)"

* Ajouter les en-têtes des colonnes (régions)
putexcel A16 = "Indicators"

* Initialiser la première colonne pour les régions (B = colonne 2)
local col = 2

foreach region in $regions {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la région
    putexcel `count_col_letter'16 = "`region' - Counts"
    putexcel `prop_col_letter'16 = "`region' - Proportions"
    putexcel `total_col_letter'16 = "`region' - Total"

    * Incrémenter de 3 pour passer à la prochaine région
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 17
local row = 17

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les régions
    local col = 2  // Colonne de départ pour les effectifs des régions (B)

    * Boucler sur chaque région
    foreach region in $regions {
        * Filtrer les données pour la région actuelle
        preserve
        keep if region == "`region'"
        
        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)
        
        num2col `=`col' + 1'
        local prop_col_letter = r(colname)
        
        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer à la prochaine région (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	
	
	

	
	****Structures	

	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("MNCH CORRECT KNOWLEDGE (60%)") modify

* Définir les variables d'analyse
global var2 "Con_ANTENATAL60 Con_maternal60 Con_POSTNATAL60"
global structures "Hospital HealthCenter HealthPost"  // Liste des structures de santé

* Ajouter le titre du tableau à partir de la ligne 30
putexcel A30 = "Table 3: Correct knowledge of MNCH by structure of health facilities (60%)"

* Ajouter les en-têtes des colonnes (structures)
putexcel A31 = "Indicators"

* Initialiser la première colonne pour les structures (B = colonne 2)
local col = 2

foreach structure in $structures {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la structure
    putexcel `count_col_letter'31 = "`structure' - Counts"
    putexcel `prop_col_letter'31 = "`structure' - Proportions (%)"
    putexcel `total_col_letter'31 = "`structure' - Total"

    * Incrémenter de 3 pour passer à la structure suivante
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 32
local row = 32

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les structures
    local col = 2  // Colonne de départ pour les structures (B)

    * Boucler sur chaque structure
    foreach structure in $structures {
        * Filtrer les données pour la structure actuelle
        preserve
        keep if Structure == "`structure'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)
        
        num2col `=`col' + 1'
        local prop_col_letter = r(colname)
        
        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer à la prochaine structure (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}

	
	
	****Place of residence
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("MNCH CORRECT KNOWLEDGE (60%)") modify

* Définir les variables d'analyse
global var2 "Con_ANTENATAL60 Con_maternal60 Con_POSTNATAL60"
global places "Rural Urban"  // Liste des lieux

* Ajouter le titre du tableau à partir de la ligne 30
putexcel A45 = "Table 3: Correct knowledge of MNCH by place (60%)"

* Ajouter les en-têtes des colonnes (lieux)
putexcel A46 = "Indicators"

* Initialiser la première colonne pour les lieux (B = colonne 2)
local col = 2

foreach place in $places {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour chaque lieu
    putexcel `count_col_letter'46 = "`place' - Counts"
    putexcel `prop_col_letter'46 = "`place' - Proportions (%)"
    putexcel `total_col_letter'46 = "`place' - Total"

    * Incrémenter de 3 pour passer au prochain lieu
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 47
local row = 47

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les lieux
    local col = 2  // Colonne de départ pour les lieux (B)

    * Boucler sur chaque lieu
    foreach place in $places {
        * Filtrer les données pour le lieu actuel
        preserve
        keep if Place == "`place'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)

        num2col `=`col' + 1'
        local prop_col_letter = r(colname)

        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer au prochain lieu (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	
	
	
				
			***CONNAISSANCE CORRECTE (SCORE NORMALISE)
			
			
			
	****National

	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("SCORE OF MNCH KNOWLEDGE") modify

* Définir les variables des scores à analyser
global var2 "Score_Con_ANTENATAL_N Score_Con_maternal_N Score_Con_POSTNATAL_N"

* Ajouter le titre du tableau
putexcel A1 = "Table 1: Average scores of correct knowledge of MNCH"

* Ajouter les en-têtes des colonnes
putexcel A2 = "Indicators" B2 = "Mean Score" C2 = "Standard Deviation" D2 = "Number of Observations"

* Initialiser une ligne pour écrire les données
local row = 3

* Créer une table temporaire pour stocker les données pour le graphique
tempname graph_data
postfile `graph_data' str50 Indicator double Mean double Std_Dev double N using prop_graph.dta, replace

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Calculer la moyenne, l'écart-type et le nombre d'observations
    quietly summarize `var'

    local mean_score = r(mean)
    local std_dev = r(sd)
    local num_obs = r(N)

    * Formatage des valeurs pour Excel
    local mean_formatted : display %9.2f `mean_score'
    local std_dev_formatted : display %9.2f `std_dev'

    * Ajouter les données au fichier Excel
    putexcel A`row' = "`label'"
    putexcel B`row' = `mean_formatted'
    putexcel C`row' = `std_dev_formatted'
    putexcel D`row' = `num_obs'

    * Stocker les données pour le graphique
    post `graph_data' ("`label'") (`mean_score') (`std_dev') (`num_obs')

    * Passer à la ligne suivante
    local row = `row' + 1
}

preserve

* Fermer le fichier temporaire
postclose `graph_data'

* Charger les données pour générer le Bar Chart
use prop_graph.dta, clear

* Vérifier si les données existent avant d'afficher le graphique
count if !missing(Mean)
if r(N) == 0 {
    display "Aucune donnée disponible pour le graphique."
    exit
}

* Générer un `bar chart` pour les moyennes des scores
graph hbar (mean) Mean, over(Indicator, sort(1) descending) ///
    bar(1, color(blue)) ///
    title("Average Scores of Correct Knowledge by Indicator") ///
    ytitle("Mean Score") ///
    blabel(bar, format(%9.2f)) ///
    graphregion(margin(zero)) plotregion(margin(small)) // Réduction des marges

* Exporter le graphique en image PNG avec une taille réduite
graph export "PF_Knowledge_Graph_Bar.png", width(600) height(400) replace

* Insérer le graphique dans Excel sous la table
local graph_row = `row' + 2  // Position du graphique après le tableau
putexcel I1 = image("PF_Knowledge_Graph_Bar.png")

restore	

* Message de confirmation
display "Les résultats et le graphique Bar Chart ont été exportés dans 'NURSES&MIDWIVES.xlsx' !"	


	
	****Région
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("SCORE OF MNCH KNOWLEDGE") modify

* Définir les variables des scores à analyser
global var2 "Score_Con_ANTENATAL_N Score_Con_maternal_N Score_Con_POSTNATAL_N"
global regions "DAKAR DIOURBEL FATICK KAFFRINE KAOLACK KEDOUGOU KOLDA LOUGA MATAM SAINTLOUIS SEDHIOU TAMBACOUNDA THIES ZIGUINCHOR"

* Ajouter le titre du tableau
putexcel A15 = "Table 2: Average scores of correct knowledge of MNCH by region"

* Ajouter les en-têtes des colonnes (régions)
putexcel A16 = "Indicators"

* Initialiser la première colonne pour les régions (B = colonne 2)
local col = 2

foreach region in $regions {
    * Définir les colonnes pour Moyenne, Écart-type et Nombre d'observations
    num2col `col'
    local mean_col_letter = r(colname)

    num2col `=`col' + 1'
    local std_col_letter = r(colname)

    num2col `=`col' + 2'
    local n_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la région
    putexcel `mean_col_letter'16 = "`region' - Mean Score"
    putexcel `std_col_letter'16 = "`region' - Std Dev"
    putexcel `n_col_letter'16 = "`region' - N"

    * Incrémenter de 3 pour passer à la prochaine région
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 17
local row = 17

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les régions
    local col = 2  // Colonne de départ pour les régions (B)

    * Boucler sur chaque région
    foreach region in $regions {
        * Filtrer les données pour la région actuelle
        preserve
        keep if region == "`region'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" aux valeurs
            local mean_score = 0
            local std_dev = 0
            local num_obs = 0
        }
        else {
            * Calculer la moyenne, l'écart-type et le nombre d'observations
            quietly summarize `var'

            local mean_score = r(mean)
            local std_dev = r(sd)
            local num_obs = r(N)
        }

        * Formatage des valeurs pour Excel
        local mean_formatted : display %9.2f `mean_score'
        local std_dev_formatted : display %9.2f `std_dev'

        * Définir les colonnes pour les scores
        num2col `col'
        local mean_col_letter = r(colname)

        num2col `=`col' + 1'
        local std_col_letter = r(colname)

        num2col `=`col' + 2'
        local n_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `mean_col_letter'`row' = `mean_formatted'
        putexcel `std_col_letter'`row' = "`std_dev_formatted'"
        putexcel `n_col_letter'`row' = `num_obs'

        restore
        local col = `col' + 3  // Passer à la prochaine région
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}

	
	
	****Structures	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("SCORE OF MNCH KNOWLEDGE") modify

* Définir les variables des scores à analyser
global var2 "Score_Con_ANTENATAL_N Score_Con_maternal_N Score_Con_POSTNATAL_N"
global structures "Hospital HealthCenter HealthPost"  // Liste des structures de santé

* Ajouter le titre du tableau
putexcel A35 = "Table 2: Average scores of correct knowledge of MNCH by structure"

* Ajouter les en-têtes des colonnes (structures)
putexcel A36 = "Indicators"

* Initialiser la première colonne pour les structures (B = colonne 2)
local col = 2

foreach structure in $structures {
    * Définir les colonnes pour Moyenne, Écart-type et Nombre d'observations
    num2col `col'
    local mean_col_letter = r(colname)

    num2col `=`col' + 1'
    local std_col_letter = r(colname)

    num2col `=`col' + 2'
    local n_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la structure
    putexcel `mean_col_letter'36 = "`structure' - Mean Score"
    putexcel `std_col_letter'36 = "`structure' - Std Dev"
    putexcel `n_col_letter'36 = "`structure' - N"

    * Incrémenter de 3 pour passer à la prochaine structure
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 37
local row = 37

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les structures
    local col = 2  // Colonne de départ pour les structures (B)

    * Boucler sur chaque structure
    foreach structure in $structures {
        * Filtrer les données pour la structure actuelle
        preserve
        keep if Structure == "`structure'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" aux valeurs
            local mean_score = 0
            local std_dev = 0
            local num_obs = 0
        }
        else {
            * Calculer la moyenne, l'écart-type et le nombre d'observations
            quietly summarize `var'

            local mean_score = r(mean)
            local std_dev = r(sd)
            local num_obs = r(N)
        }

        * Formatage des valeurs pour Excel
        local mean_formatted : display %9.2f `mean_score'
        local std_dev_formatted : display %9.2f `std_dev'

        * Définir les colonnes pour les scores
        num2col `col'
        local mean_col_letter = r(colname)

        num2col `=`col' + 1'
        local std_col_letter = r(colname)

        num2col `=`col' + 2'
        local n_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `mean_col_letter'`row' = `mean_formatted'
        putexcel `std_col_letter'`row' = "`std_dev_formatted'"
        putexcel `n_col_letter'`row' = `num_obs'

        restore
        local col = `col' + 3  // Passer à la prochaine structure
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	
	
	
	
	****Place of residence
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("SCORE OF MNCH KNOWLEDGE") modify

* Définir les variables des scores à analyser
global var2 "Score_Con_ANTENATAL_N Score_Con_maternal_N Score_Con_POSTNATAL_N"
global places "Rural Urban"  // Liste des lieux de résidence

* Ajouter le titre du tableau
putexcel A45 = "Table 2: Average scores of correct knowledge of MNCH by place (Rural, Urban)"

* Ajouter les en-têtes des colonnes (lieux)
putexcel A46 = "Indicators"

* Initialiser la première colonne pour les lieux (B = colonne 2)
local col = 2

foreach place in $places {
    * Définir les colonnes pour Moyenne, Écart-type et Nombre d'observations
    num2col `col'
    local mean_col_letter = r(colname)

    num2col `=`col' + 1'
    local std_col_letter = r(colname)

    num2col `=`col' + 2'
    local n_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour le lieu de résidence
    putexcel `mean_col_letter'46 = "`place' - Mean Score"
    putexcel `std_col_letter'46 = "`place' - Std Dev"
    putexcel `n_col_letter'46 = "`place' - N"

    * Incrémenter de 3 pour passer au prochain lieu
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 47
local row = 47

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les lieux de résidence
    local col = 2  // Colonne de départ pour les lieux (B)

    * Boucler sur chaque lieu
    foreach place in $places {
        * Filtrer les données pour le lieu actuel
        preserve
        keep if Place == "`place'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" aux valeurs
            local mean_score = 0
            local std_dev = 0
            local num_obs = 0
        }
        else {
            * Calculer la moyenne, l'écart-type et le nombre d'observations
            quietly summarize `var'

            local mean_score = r(mean)
            local std_dev = r(sd)
            local num_obs = r(N)
        }

        * Formatage des valeurs pour Excel
        local mean_formatted : display %9.2f `mean_score'
        local std_dev_formatted : display %9.2f `std_dev'

        * Définir les colonnes pour les scores
        num2col `col'
        local mean_col_letter = r(colname)

        num2col `=`col' + 1'
        local std_col_letter = r(colname)

        num2col `=`col' + 2'
        local n_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `mean_col_letter'`row' = `mean_formatted'
        putexcel `std_col_letter'`row' = "`std_dev_formatted'"
        putexcel `n_col_letter'`row' = `num_obs'

        restore
        local col = `col' + 3  // Passer au prochain lieu
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}			
			
					
					
					
					
		
			

			***SMNI ATTITUDE FAVORABLE***			
			
				
			
	****National
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("MNCH FAVORABLE ATTITUDE") modify

* Définir les variables (indicateurs de l'attitude favorable envers la SMNI)
global var2 "Favorable_SMNI80 Favorable_SMNI70 Favorable_SMNI60"

* Ajouter le titre du tableau
putexcel A1 = "Table 1: MNCH favorable attitude at the national level"

* Ajouter les en-têtes des colonnes
putexcel A2 = "Indicators" B2 = "Counts (Effectifs)" C2 = "Proportions (%)" D2 = "Total"

* Initialiser une ligne pour écrire les données
local row = 3

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Vérifier s'il y a des observations valides pour cette variable
    count if !missing(`var')
    if r(N) == 0 {
        * Si aucune donnée n'existe, attribuer "0" aux valeurs
        local count1 = 0
        local total_effectifs = 0
        local proportion_formatted = "0.00"
    }
    else {
        * Calculer les effectifs et proportions
        tabulate `var', matcell(freq_`var') matrow(rnames_`var')

        * Initialiser les valeurs par défaut
        local count1 = 0
        local total_effectifs = 0
        local proportion_formatted = "0.00"

        * Calculer le total des effectifs (même s'il n'y a qu'une seule modalité)
        forval i = 1/`=rowsof(freq_`var')' {
            local total_effectifs = `total_effectifs' + freq_`var'[`i', 1]
        }

        * Vérifier si la modalité "1" existe et calculer la proportion
        forval i = 1/`=rowsof(rnames_`var')' {
            if rnames_`var'[`i', 1] == 1 {
                local count1 = freq_`var'[`i', 1]
                local proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f `proportion1'
            }
        }
    }

    * Ajouter les données au fichier Excel
    putexcel A`row' = "`label'"
    putexcel B`row' = `count1'
    putexcel C`row' = "`proportion_formatted'"
    putexcel D`row' = `total_effectifs'

    * Passer à la ligne suivante
    local row = `row' + 1
}


	
	****Région
	
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("MNCH FAVORABLE ATTITUDE") modify

* Définir les variables d'analyse
global var2 "Favorable_SMNI80 Favorable_SMNI70 Favorable_SMNI60"
global regions "DAKAR DIOURBEL FATICK KAFFRINE KAOLACK KEDOUGOU KOLDA LOUGA MATAM SAINTLOUIS SEDHIOU TAMBACOUNDA THIES ZIGUINCHOR"

* Ajouter le titre du tableau
putexcel A15 = "Table 2: MNCH favorable attitude by region"

* Ajouter les en-têtes des colonnes (régions)
putexcel A16 = "Indicators"

* Initialiser la première colonne pour les régions (B = colonne 2)
local col = 2

foreach region in $regions {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la région
    putexcel `count_col_letter'16 = "`region' - Counts"
    putexcel `prop_col_letter'16 = "`region' - Proportions"
    putexcel `total_col_letter'16 = "`region' - Total"

    * Incrémenter de 3 pour passer à la prochaine région
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 17
local row = 17

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les régions
    local col = 2  // Colonne de départ pour les effectifs des régions (B)

    * Boucler sur chaque région
    foreach region in $regions {
        * Filtrer les données pour la région actuelle
        preserve
        keep if region == "`region'"
        
        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)
        
        num2col `=`col' + 1'
        local prop_col_letter = r(colname)
        
        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer à la prochaine région (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	
	
	

	
	****Structures	

	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("MNCH FAVORABLE ATTITUDE") modify

* Définir les variables d'analyse
global var2 "Favorable_SMNI80 Favorable_SMNI70 Favorable_SMNI60"
global structures "Hospital HealthCenter HealthPost"  // Liste des structures de santé

* Ajouter le titre du tableau à partir de la ligne 30
putexcel A30 = "Table 3: MNCH favorable attitude by structure of health facilities"

* Ajouter les en-têtes des colonnes (structures)
putexcel A31 = "Indicators"

* Initialiser la première colonne pour les structures (B = colonne 2)
local col = 2

foreach structure in $structures {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la structure
    putexcel `count_col_letter'31 = "`structure' - Counts"
    putexcel `prop_col_letter'31 = "`structure' - Proportions (%)"
    putexcel `total_col_letter'31 = "`structure' - Total"

    * Incrémenter de 3 pour passer à la structure suivante
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 32
local row = 32

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les structures
    local col = 2  // Colonne de départ pour les structures (B)

    * Boucler sur chaque structure
    foreach structure in $structures {
        * Filtrer les données pour la structure actuelle
        preserve
        keep if Structure == "`structure'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)
        
        num2col `=`col' + 1'
        local prop_col_letter = r(colname)
        
        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer à la prochaine structure (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}

	
	
	****Place of residence
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("MNCH FAVORABLE ATTITUDE") modify

* Définir les variables d'analyse
global var2 "Favorable_SMNI80 Favorable_SMNI70 Favorable_SMNI60"
global places "Rural Urban"  // Liste des lieux

* Ajouter le titre du tableau à partir de la ligne 30
putexcel A45 = "Table 3: MNCH favorable attitude by place"

* Ajouter les en-têtes des colonnes (lieux)
putexcel A46 = "Indicators"

* Initialiser la première colonne pour les lieux (B = colonne 2)
local col = 2

foreach place in $places {
    * Définir les colonnes pour les effectifs, proportions et total
    num2col `col'
    local count_col_letter = r(colname)

    num2col `=`col' + 1'
    local prop_col_letter = r(colname)

    num2col `=`col' + 2'
    local total_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour chaque lieu
    putexcel `count_col_letter'46 = "`place' - Counts"
    putexcel `prop_col_letter'46 = "`place' - Proportions (%)"
    putexcel `total_col_letter'46 = "`place' - Total"

    * Incrémenter de 3 pour passer au prochain lieu
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 47
local row = 47

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les lieux
    local col = 2  // Colonne de départ pour les lieux (B)

    * Boucler sur chaque lieu
    foreach place in $places {
        * Filtrer les données pour le lieu actuel
        preserve
        keep if Place == "`place'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" au total, effectifs et proportion
            local count1 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0
        }
        else {
            * Tabulation pour obtenir les effectifs des modalités 0 et 1
            tabulate `var', matcell(freq_`var') matrow(rnames_`var')

            * Initialiser les valeurs par défaut
            local count1 = 0
            local count0 = 0
            local proportion_formatted = "0.00"
            local total_effectifs = 0

            * Vérifier la présence des modalités "0" et "1"
            forval i = 1/`=rowsof(freq_`var')' {
                if rnames_`var'[`i',1] == 0 {
                    local count0 = freq_`var'[`i', 1]
                }
                if rnames_`var'[`i',1] == 1 {
                    local count1 = freq_`var'[`i', 1]
                }
            }

            * Calcul du total correct
            local total_effectifs = `count0' + `count1'

            * Calcul de la proportion si le total est non nul
            if `total_effectifs' > 0 {
                scalar proportion1 = (`count1' / `total_effectifs') * 100
                local proportion_formatted : display %9.2f proportion1
            }
        }

        * Définir les colonnes pour les effectifs, total et proportions
        num2col `col'
        local count_col_letter = r(colname)

        num2col `=`col' + 1'
        local prop_col_letter = r(colname)

        num2col `=`col' + 2'
        local total_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `count_col_letter'`row' = `count1'
        putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        putexcel `total_col_letter'`row' = `total_effectifs'

        restore
        local col = `col' + 3  // Passer au prochain lieu (trois colonnes plus loin)
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	
	
	
				
			***MNCH FAVORABLE ATTITUDE (SCORE NORMALISE)
			
			
			
	****National

	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("SCORE MNCH FAVORABLE ATTITUDE") modify

* Définir l'indicateur unique
local var "Score_Attitude_SMNI_N"

* Ajouter le titre du tableau
putexcel A1 = "Table 1: Average score of MNCH favorable attitude"

* Ajouter les en-têtes des colonnes
putexcel A2 = "Indicator" B2 = "Mean Score" C2 = "Standard Deviation" D2 = "Number of Observations"

* Initialiser la ligne pour écrire les données
local row = 3

* Récupérer le label de la variable
local label : variable label `var'
if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

* Vérifier s'il y a des observations pour cet indicateur
count if !missing(`var')
if r(N) == 0 {
    * Si aucune donnée n'existe, attribuer "0" aux valeurs
    local mean_score = 0
    local std_dev = 0
    local num_obs = 0
} 
else {
    * Calculer la moyenne, l'écart-type et le nombre d'observations
    quietly summarize `var'

    local mean_score = r(mean)
    local std_dev = r(sd)
    local num_obs = r(N)
}

* Formatage des valeurs pour Excel
local mean_formatted : display %9.2f `mean_score'
local std_dev_formatted : display %9.2f `std_dev'

* Ajouter les données au fichier Excel
putexcel A`row' = "`label'"
putexcel B`row' = `mean_formatted'
putexcel C`row' = `std_dev_formatted'
putexcel D`row' = `num_obs'





	
	****Région
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("SCORE MNCH FAVORABLE ATTITUDE") modify

* Définir l'indicateur unique
local var "Score_Attitude_SMNI_N"

* Définir les régions
global regions "DAKAR DIOURBEL FATICK KAFFRINE KAOLACK KEDOUGOU KOLDA LOUGA MATAM SAINTLOUIS SEDHIOU TAMBACOUNDA THIES ZIGUINCHOR"

* Ajouter le titre du tableau
putexcel A15 = "Table 2: Average score of MNCH favorable attitude by region"

* Ajouter les en-têtes des colonnes (Moyenne, Écart-type, Effectifs)
putexcel A16 = "Region" B16 = "Mean Score" C16 = "Std Dev" D16 = "N"

* Initialiser la ligne pour écrire les données (régions) à partir de la ligne 17
local row = 17

* Boucler sur chaque région pour calculer les statistiques
foreach region in $regions {
    * Vérifier que la variable "region" existe dans la base de données
    capture confirm variable region
    if _rc == 0 {
        * Filtrer les données pour la région actuelle
        preserve
        keep if region == "`region'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" aux valeurs
            local mean_score = 0
            local std_dev = 0
            local num_obs = 0
        }
        else {
            * Calculer la moyenne, l'écart-type et le nombre d'observations
            quietly summarize `var'

            local mean_score = r(mean)
            local std_dev = r(sd)
            local num_obs = r(N)
        }

        * Formatage des valeurs pour Excel
        local mean_formatted : display %9.2f `mean_score'
        local std_dev_formatted : display %9.2f `std_dev'

        * Ajouter les valeurs dans le tableau
        putexcel A`row' = "`region'"
        putexcel B`row' = `mean_formatted'
        putexcel C`row' = `std_dev_formatted'
        putexcel D`row' = `num_obs'

        restore
    }
    * Passer à la ligne suivante
    local row = `row' + 1
}



	
	****Structures	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("SCORE MNCH FAVORABLE ATTITUDE") modify

* Définir l'indicateur unique
local var "Score_Attitude_SMNI_N"

* Définir les structures de santé
global structures "Hospital HealthCenter HealthPost"

* Ajouter le titre du tableau
putexcel A35 = "Table 2: Average score of MNCH favorable attitude by structure"

* Ajouter les en-têtes des colonnes (Moyenne, Écart-type, Effectifs)
putexcel A36 = "Structure" B36 = "Mean Score" C36 = "Std Dev" D36 = "N"

* Initialiser la ligne pour écrire les données (structures) à partir de la ligne 37
local row = 37

* Boucler sur chaque structure pour calculer les statistiques
foreach structure in $structures {
    * Vérifier que la variable "Structure" existe dans la base de données
    capture confirm variable Structure
    if _rc == 0 {
        * Filtrer les données pour la structure actuelle
        preserve
        keep if Structure == "`structure'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" aux valeurs
            local mean_score = 0
            local std_dev = 0
            local num_obs = 0
        }
        else {
            * Calculer la moyenne, l'écart-type et le nombre d'observations
            quietly summarize `var'

            local mean_score = r(mean)
            local std_dev = r(sd)
            local num_obs = r(N)
        }

        * Formatage des valeurs pour Excel
        local mean_formatted : display %9.2f `mean_score'
        local std_dev_formatted : display %9.2f `std_dev'

        * Ajouter les valeurs dans le tableau
        putexcel A`row' = "`structure'"
        putexcel B`row' = `mean_formatted'
        putexcel C`row' = `std_dev_formatted'
        putexcel D`row' = `num_obs'

        restore
    }
    * Passer à la ligne suivante
    local row = `row' + 1
}
	
	
	****Place of residence
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("SCORE MNCH FAVORABLE ATTITUDE") modify

* Définir l'indicateur unique
local var "Score_Attitude_SMNI_N"

* Définir les lieux de résidence
global places "Rural Urban"

* Ajouter le titre du tableau
putexcel A45 = "Table 2: Average score of MNCH favorable attitude by place (Rural, Urban)"

* Ajouter les en-têtes des colonnes (Moyenne, Écart-type, Effectifs)
putexcel A46 = "Place" B46 = "Mean Score" C46 = "Std Dev" D46 = "N"

* Initialiser la ligne pour écrire les données (places) à partir de la ligne 47
local row = 47

* Boucler sur chaque lieu de résidence pour calculer les statistiques
foreach place in $places {
    * Vérifier que la variable "Place" existe dans la base de données
    capture confirm variable Place
    if _rc == 0 {
        * Filtrer les données pour le lieu actuel
        preserve
        keep if Place == "`place'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" aux valeurs
            local mean_score = 0
            local std_dev = 0
            local num_obs = 0
        }
        else {
            * Calculer la moyenne, l'écart-type et le nombre d'observations
            quietly summarize `var'

            local mean_score = r(mean)
            local std_dev = r(sd)
            local num_obs = r(N)
        }

        * Formatage des valeurs pour Excel
        local mean_formatted : display %9.2f `mean_score'
        local std_dev_formatted : display %9.2f `std_dev'

        * Ajouter les valeurs dans le tableau
        putexcel A`row' = "`place'"
        putexcel B`row' = `mean_formatted'
        putexcel C`row' = `std_dev_formatted'
        putexcel D`row' = `num_obs'

        restore
    }
    * Passer à la ligne suivante
    local row = `row' + 1
}
						
			
			
			
	
			
	
				
				
			***FORMATION SMNI***
									
			
			
	****National

	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("FORMATION EN MNCH") modify

* Définir les variables des scores à analyser
global var2 "Accouchement Grossesse Anemie Partogramme"

* Ajouter le titre du tableau
putexcel A1 = "Table 1: Training of MNCH at National level"

* Ajouter les en-têtes des colonnes
putexcel A2 = "Indicators" B2 = "Mean Score" C2 = "Standard Deviation" D2 = "Number of Observations"

* Initialiser une ligne pour écrire les données
local row = 3

* Créer une table temporaire pour stocker les données pour le graphique
tempname graph_data
postfile `graph_data' str50 Indicator double Mean double Std_Dev double N using prop_graph.dta, replace

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Calculer la moyenne, l'écart-type et le nombre d'observations
    quietly summarize `var'

    local mean_score = r(mean)
    local std_dev = r(sd)
    local num_obs = r(N)

    * Formatage des valeurs pour Excel
    local mean_formatted : display %9.2f `mean_score'
    local std_dev_formatted : display %9.2f `std_dev'

    * Ajouter les données au fichier Excel
    putexcel A`row' = "`label'"
    putexcel B`row' = `mean_formatted'
    putexcel C`row' = `std_dev_formatted'
    putexcel D`row' = `num_obs'

    * Stocker les données pour le graphique
    post `graph_data' ("`label'") (`mean_score') (`std_dev') (`num_obs')

    * Passer à la ligne suivante
    local row = `row' + 1
}

preserve

* Fermer le fichier temporaire
postclose `graph_data'

* Charger les données pour générer le Bar Chart
use prop_graph.dta, clear

* Vérifier si les données existent avant d'afficher le graphique
count if !missing(Mean)
if r(N) == 0 {
    display "Aucune donnée disponible pour le graphique."
    exit
}

* Générer un `bar chart` pour les moyennes des scores
graph bar (mean) Mean, over(Indicator, sort(1) descending) ///
    bar(1, color(blue)) ///
    title("Average Scores of Correct Knowledge by Indicator") ///
    ytitle("Mean Score") ///
    blabel(bar, format(%9.2f)) ///
    graphregion(margin(zero)) plotregion(margin(small)) // Réduction des marges

* Exporter le graphique en image PNG avec une taille réduite
graph export "PF_Knowledge_Graph_Bar.png", width(600) height(400) replace

* Insérer le graphique dans Excel sous la table
local graph_row = `row' + 2  // Position du graphique après le tableau
putexcel I1 = image("PF_Knowledge_Graph_Bar.png")

restore	

* Message de confirmation
display "Les résultats et le graphique Bar Chart ont été exportés dans 'NURSES&MIDWIVES.xlsx' !"	


	
	****Région
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("FORMATION EN MNCH") modify

* Définir les variables des scores à analyser
global var2 "Accouchement Grossesse Anemie Partogramme"
global regions "DAKAR DIOURBEL FATICK KAFFRINE KAOLACK KEDOUGOU KOLDA LOUGA MATAM SAINTLOUIS SEDHIOU TAMBACOUNDA THIES ZIGUINCHOR"

* Ajouter le titre du tableau
putexcel A15 = "Table 2: Training of MNCH by region"

* Ajouter les en-têtes des colonnes (régions)
putexcel A16 = "Indicators"

* Initialiser la première colonne pour les régions (B = colonne 2)
local col = 2

foreach region in $regions {
    * Définir les colonnes pour Moyenne, Écart-type et Nombre d'observations
    num2col `col'
    local mean_col_letter = r(colname)

    num2col `=`col' + 1'
    local std_col_letter = r(colname)

    num2col `=`col' + 2'
    local n_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la région
    putexcel `mean_col_letter'16 = "`region' - Mean Score"
    putexcel `std_col_letter'16 = "`region' - Std Dev"
    putexcel `n_col_letter'16 = "`region' - N"

    * Incrémenter de 3 pour passer à la prochaine région
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 17
local row = 17

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les régions
    local col = 2  // Colonne de départ pour les régions (B)

    * Boucler sur chaque région
    foreach region in $regions {
        * Filtrer les données pour la région actuelle
        preserve
        keep if region == "`region'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" aux valeurs
            local mean_score = 0
            local std_dev = 0
            local num_obs = 0
        }
        else {
            * Calculer la moyenne, l'écart-type et le nombre d'observations
            quietly summarize `var'

            local mean_score = r(mean)
            local std_dev = r(sd)
            local num_obs = r(N)
        }

        * Formatage des valeurs pour Excel
        local mean_formatted : display %9.2f `mean_score'
        local std_dev_formatted : display %9.2f `std_dev'

        * Définir les colonnes pour les scores
        num2col `col'
        local mean_col_letter = r(colname)

        num2col `=`col' + 1'
        local std_col_letter = r(colname)

        num2col `=`col' + 2'
        local n_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `mean_col_letter'`row' = `mean_formatted'
        putexcel `std_col_letter'`row' = "`std_dev_formatted'"
        putexcel `n_col_letter'`row' = `num_obs'

        restore
        local col = `col' + 3  // Passer à la prochaine région
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}

	
	
	****Structures	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("FORMATION EN MNCH") modify

* Définir les variables des scores à analyser
global var2 "Accouchement Grossesse Anemie Partogramme"
global structures "Hospital HealthCenter HealthPost"  // Liste des structures de santé

* Ajouter le titre du tableau
putexcel A35 = "Table 2: Training of MNCH by structure"

* Ajouter les en-têtes des colonnes (structures)
putexcel A36 = "Indicators"

* Initialiser la première colonne pour les structures (B = colonne 2)
local col = 2

foreach structure in $structures {
    * Définir les colonnes pour Moyenne, Écart-type et Nombre d'observations
    num2col `col'
    local mean_col_letter = r(colname)

    num2col `=`col' + 1'
    local std_col_letter = r(colname)

    num2col `=`col' + 2'
    local n_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour la structure
    putexcel `mean_col_letter'36 = "`structure' - Mean Score"
    putexcel `std_col_letter'36 = "`structure' - Std Dev"
    putexcel `n_col_letter'36 = "`structure' - N"

    * Incrémenter de 3 pour passer à la prochaine structure
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 37
local row = 37

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les structures
    local col = 2  // Colonne de départ pour les structures (B)

    * Boucler sur chaque structure
    foreach structure in $structures {
        * Filtrer les données pour la structure actuelle
        preserve
        keep if Structure == "`structure'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" aux valeurs
            local mean_score = 0
            local std_dev = 0
            local num_obs = 0
        }
        else {
            * Calculer la moyenne, l'écart-type et le nombre d'observations
            quietly summarize `var'

            local mean_score = r(mean)
            local std_dev = r(sd)
            local num_obs = r(N)
        }

        * Formatage des valeurs pour Excel
        local mean_formatted : display %9.2f `mean_score'
        local std_dev_formatted : display %9.2f `std_dev'

        * Définir les colonnes pour les scores
        num2col `col'
        local mean_col_letter = r(colname)

        num2col `=`col' + 1'
        local std_col_letter = r(colname)

        num2col `=`col' + 2'
        local n_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `mean_col_letter'`row' = `mean_formatted'
        putexcel `std_col_letter'`row' = "`std_dev_formatted'"
        putexcel `n_col_letter'`row' = `num_obs'

        restore
        local col = `col' + 3  // Passer à la prochaine structure
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	
	
	
	
	****Place of residence
	
	
* Définir le fichier Excel et la feuille
putexcel set "NURSES&MIDWIVES.xlsx", sheet("FORMATION EN MNCH") modify

* Définir les variables des scores à analyser
global var2 "Accouchement Grossesse Anemie Partogramme"
global places "Rural Urban"  // Liste des lieux de résidence

* Ajouter le titre du tableau
putexcel A45 = "Table 2: Training of MNCH by place (Rural, Urban)"

* Ajouter les en-têtes des colonnes (lieux)
putexcel A46 = "Indicators"

* Initialiser la première colonne pour les lieux (B = colonne 2)
local col = 2

foreach place in $places {
    * Définir les colonnes pour Moyenne, Écart-type et Nombre d'observations
    num2col `col'
    local mean_col_letter = r(colname)

    num2col `=`col' + 1'
    local std_col_letter = r(colname)

    num2col `=`col' + 2'
    local n_col_letter = r(colname)

    * Ajouter les en-têtes des colonnes pour le lieu de résidence
    putexcel `mean_col_letter'46 = "`place' - Mean Score"
    putexcel `std_col_letter'46 = "`place' - Std Dev"
    putexcel `n_col_letter'46 = "`place' - N"

    * Incrémenter de 3 pour passer au prochain lieu
    local col = `col' + 3
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 47
local row = 47

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"

    * Ajouter le label de l'indicateur dans la colonne A
    putexcel A`row' = "`label'"

    * Initialiser la colonne pour les lieux de résidence
    local col = 2  // Colonne de départ pour les lieux (B)

    * Boucler sur chaque lieu
    foreach place in $places {
        * Filtrer les données pour le lieu actuel
        preserve
        keep if Place == "`place'"

        * Vérifier s'il y a des observations pour cet indicateur
        count if !missing(`var')
        if r(N) == 0 {
            * Si aucune donnée n'existe, attribuer "0" aux valeurs
            local mean_score = 0
            local std_dev = 0
            local num_obs = 0
        }
        else {
            * Calculer la moyenne, l'écart-type et le nombre d'observations
            quietly summarize `var'

            local mean_score = r(mean)
            local std_dev = r(sd)
            local num_obs = r(N)
        }

        * Formatage des valeurs pour Excel
        local mean_formatted : display %9.2f `mean_score'
        local std_dev_formatted : display %9.2f `std_dev'

        * Définir les colonnes pour les scores
        num2col `col'
        local mean_col_letter = r(colname)

        num2col `=`col' + 1'
        local std_col_letter = r(colname)

        num2col `=`col' + 2'
        local n_col_letter = r(colname)

        * Ajouter les valeurs dans le tableau
        putexcel `mean_col_letter'`row' = `mean_formatted'
        putexcel `std_col_letter'`row' = "`std_dev_formatted'"
        putexcel `n_col_letter'`row' = `num_obs'

        restore
        local col = `col' + 3  // Passer au prochain lieu
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}			
			
			
* Fermer le fichier après l'écriture
putexcel save

* Affichage du message de fin
display "Le fichier Excel a été mis à jour avec succès."

							
			

					