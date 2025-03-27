* Évaluation de base de la planification familiale au Sénégal 
*
* 	Questionnaire pour l'entretien avec les infirmiers et sages-femmes.
*
*	Outputs: SUIVI DES INDICATEURS
*


* initialize Stata

clear all
clear matrix
set linesize 220
set maxvar 32000
set more off



cd "C:\Users\rndachi\Desktop\Indicateurs prestataires"

sysuse "BDD ISF_13janvier2024"


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

lab var DIU "Knowledge of the DIU"
lab var Injectables "Knowledge of Injectables"
lab var Preservatif_M "Knowledge of the male condom"
lab var Preservatif_F "Knowledge of the female condom"
lab var Contraception_Urg "Knowledge of Emergency Contraception"
lab var Pilules "Knowledge of Pills"
lab var Implants "Knowledge of Implants"
lab var Sterilisation_F "Knowledge of female sterilization"
lab var Sterilisation_M "Knowledge of male sterilization"
lab var Allaitement_Exclu "Knowledge of Exclusive breastfeeding"



 



				/* LES INDICATEURS PLANIFICATION FAMILIALE */
				
				



*******INDICATEUR 1. Pourcentage de prestataires ayant une connaissance correcte
*******de chaque méthode de PF qu'ils fournissent actuellement

 


				*************
				***  DIU  ***
				*************


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
		*Elle consiste à respecter au moins 80% des 36 questions liées au DIU

egen 		Score_con_DIU 	=  rsum(*DIU)
local total_connaissance_DIU = 36  // Nombre total de questions utilisées
gen DIU_correct = (Score_con_DIU >= `=round(0.80 * `total_connaissance_DIU')')
replace 	DIU_correct =. if Score_con_DIU==0 | S2_22_1 !=1
label var 	DIU_correct "Correct knowledge of DIU method"




				********************
				***  INJECTABLE  ***
				********************

				
foreach var of var S3_28_1  S3_28_3 S3_28_4 S3_28_7 S3_28_8 S3_28_9 S3_28_11 S3_28_13 S3_28_16 S3_28_17 S3_28_18 S3_28_19 S3_28_20 S3_28_21 {

 gen Know`var'INJECTABLE =1 if `var'==1
 replace Know`var'INJECTABLE =0 if `var'==2 | `var'==3
 
}


 foreach var of var S3_28_2 S3_28_5 S3_28_6 S3_28_10 S3_28_12 S3_28_14 S3_28_15 {

 gen Know`var'INJECTABLE =0 if `var'==1 | `var'==3
 replace Know`var'INJECTABLE =1 if `var'==2
 
}


		*Construction de la variable connaissance correcte de la méthode INJECTABLE
		*Elle consiste à respecter au moins 80% des 21 questions liées au INJECTABLE


egen 		Score_con_INJECTABLE 	=  rsum(*INJECTABLE)
local total_connaissance_INJECTABLE = 21  // Nombre total de questions utilisées
gen INJECTABLE_correct = (Score_con_INJECTABLE >= `=round(0.80 * `total_connaissance_INJECTABLE')')
replace 	INJECTABLE_correct =. if Score_con_INJECTABLE==0 | S2_22_2 !=1
label var 	INJECTABLE_correct "Correct knowledge of INJECTABLE method"
				
	

				******************
				***  IMPLANTS  ***
				******************


				
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
		*Elle consiste à respecter au moins 80% des 36 questions liées au IMPLANTS


egen 		Score_con_IMPLANTS 	=  rsum(*IMPLANTS)
local total_connaissance_IMPLANTS = 25  // Nombre total de questions utilisées
gen IMPLANTS_correct = (Score_con_IMPLANTS >= `=round(0.80 * `total_connaissance_IMPLANTS')')
replace 	IMPLANTS_correct =. if Score_con_IMPLANTS==0 | S2_22_7 !=1
label var 	IMPLANTS_correct "Correct knowledge of IMPLANTS method"


		

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
		*STERILISATION FEMININE. Elle consiste à respecter au moins 80% des
		*36 questions liées à la STERILISATION FEMININE

		
egen 		Score_con_STERILFEM 	=  rsum(*STERILFEM)
local total_connaissance_STERILFEM = 71  // Nombre total de questions utilisées
gen STERILFEM_correct = (Score_con_STERILFEM >= `=round(0.80 * `total_connaissance_STERILFEM')')
replace 	STERILFEM_correct =. if Score_con_STERILFEM==0 | S2_22_8 !=1
label var 	STERILFEM_correct "Correct knowledge of STERILISATION FEMININE method"


		
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
		*STERILISATION FEMININE. Elle consiste à respecter au moins 80% des
		*23 questions liées à la STERILISATION MASCULINE

		
egen 		Score_con_STERILMAS	=  rsum(*STERILMAS)
local total_connaissance_STERILMAS = 23  // Nombre total de questions utilisées
gen STERILMAS_correct = (Score_con_STERILMAS >= `=round(0.80 * `total_connaissance_STERILMAS')')
replace 	STERILMAS_correct =. if Score_con_STERILMAS==0 | S2_22_9 !=1
label var 	STERILMAS_correct "Correct knowledge of STERILISATION MASCULINE method"

				
				
		
	
	

*******INDICATEUR 2.	Pourcentage de prestataires ayant déclaré des pratiques *******correctes de pré-procédures pour chaque méthode de PF qu'ils fournissent
*******actuellement

 				
				
				*************
				***  DIU  ***
				*************				


				
 foreach var of var S3_2_1 S3_2_2 S3_2_3 S3_2_4 S3_2_5 S3_2_6 S3_2_7 S3_2_8 S3_3_1 S3_3_2 S3_3_3 S3_3_4 S3_3_5 S3_3_6 S3_3_7 S3_4_1 S3_4_2 S3_4_3 S3_4_4 S3_4_5 S3_4_6 S3_4_7 S3_6_1 S3_6_2 S3_6_3 S3_7_1 S3_7_2 S3_7_3 S3_7_4 S3_7_5 S3_7_6 S3_7_7 S3_7_8 S3_7_10 S3_7_11 S3_7_12 S3_7_13 S3_7_14 S3_8_1 S3_8_2 S3_8_3 S3_8_4 S3_8_5 S3_8_6 S3_8_7 S3_8_8 S3_8_10 S3_8_11 S3_8_12 S3_9_1 S3_9_2 S3_9_3 S3_10_1 S3_10_2 S3_10_3 {

 gen Do`var'DIU_pre = `var'
 
}

			
				
		*Construction de la variable pratique correcte preprocédure de la DIU.
		*Elle consiste à respecter au moins 80% des 55 questions liées à la
		*pratique de la DIU

		
egen 		Score_pra_DIU_pre	=  rsum(*DIU_pre)
local total_pratique_DIU_pre = 55  // Nombre total de questions utilisées
gen DIU_pre_correct = (Score_pra_DIU_pre >= `=round(0.80 * `total_pratique_DIU_pre')')
replace 	DIU_pre_correct =. if Score_pra_DIU_pre==0 | S2_22_1 !=1
label var 	DIU_pre_correct "Correct pre-procedure practice for the DIU"

				
						
		
						
				
				********************
				***  INJECTABLE  ***
				********************		
				


				
 foreach var of var S3_18_1 S3_18_2 S3_18_3 S3_18_4 S3_18_5 S3_18_6 S3_18_7 S3_18_8 S3_19_1 S3_19_2 S3_19_3 S3_19_4 S3_19_5 S3_19_6 S3_19_7 S3_21_1 S3_21_2 S3_21_3 S3_22_1 S3_22_2 S3_22_3 S3_22_4 S3_22_5 S3_22_6 S3_22_7 S3_22_8 S3_22_10 S3_22_11 S3_23_1 S3_23_2 S3_23_3 S3_23_4 S3_23_5 S3_23_6 S3_23_7 S3_23_8 S3_23_10 S3_23_11 S3_23_12 S3_23_13 S3_23_14 S3_23_15 S3_24_1 S3_24_2 S3_25_1 S3_25_2 S3_25_3 S3_25_4 S3_25_5 S3_25_6 S3_25_7 S3_25_8 S3_25_10 S3_25_11 {

 gen Do`var'INJECT_pre = `var'
 
}

			
				
		*Construction de la variable pratique correcte preprocédure de la INJECTABLE.
		*Elle consiste à respecter au moins 80% des 54 questions liées à la
		*pratique de la INJECTABLE

		
egen 		Score_pra_INJECT_pre	=  rsum(*INJECT_pre)
local total_pratique_INJECT_pre = 54  // Nombre total de questions utilisées
gen INJECT_pre_correct = (Score_pra_INJECT_pre >= `=round(0.80 * `total_pratique_INJECT_pre')')
replace 	INJECT_pre_correct =. if Score_pra_INJECT_pre==0 | S2_22_2 !=1
label var 	INJECT_pre_correct "Correct pre-procedure practice for the INJECTABLE"

								
					
				
				******************
				***  IMPLANTS  ***
				******************				


				
 foreach var of var S3_30_1 S3_30_2 S3_30_3 S3_30_4 S3_30_5 S3_30_6 S3_30_7 S3_30_8 S3_31_1 S3_31_2 S3_31_3 S3_31_4 S3_31_5 S3_31_6 S3_31_7 S3_32_1 S3_32_2 S3_32_3 S3_32_4 S3_32_5 S3_32_6 S3_32_7 S3_33_1 S3_33_2 S3_33_3 S3_34_1 S3_34_2 S3_34_3 S3_34_4 S3_34_5 S3_34_6 S3_34_7 S3_34_8 S3_35_1 S3_35_2 S3_35_3 S3_35_4 S3_35_5 S3_35_6 S3_35_7 S3_35_8 S3_35_10 S3_35_11 S3_35_12 S3_35_13 S3_36_1 S3_36_2 {

 gen Do`var'IMPLANTS_pre = `var'
 
}

			
				
		*Construction de la variable pratique correcte preprocédure de l'IMPLANTS.
		*Elle consiste à respecter au moins 80% des 47 questions liées à la
		*pratique de l'IMPLANTS

		
egen 		Score_pra_IMPLANTS_pre	=  rsum(*IMPLANTS_pre)
local total_pratique_IMPLANTS_pre = 47  // Nombre total de questions utilisées
gen IMPLANTS_pre_correct = (Score_pra_IMPLANTS_pre >= `=round(0.80 * `total_pratique_IMPLANTS_pre')')
replace 	IMPLANTS_pre_correct =. if Score_pra_IMPLANTS_pre==0 | S2_22_7 !=1
label var 	IMPLANTS_pre_correct "Correct pre-procedure practice for the IMPLANTS"
				
				
			
				

				********************************
				***  STERILISATION FEMININE  ***
				********************************				

				
 foreach var of var S3_43_1 S3_43_2 S3_43_3 S3_43_4 S3_43_5 S3_43_6 S3_43_7 S3_43_8 S3_44_1 S3_44_2 S3_44_3 S3_44_4 S3_44_5 S3_44_6 S3_44_7 S3_45_1 S3_45_2 S3_45_3 S3_45_4 S3_45_5 S3_45_6 S3_45_7 S3_46_1 S3_46_2 S3_46_3 S3_49_1 S3_49_2 S3_49_3 S3_49_4 S3_49_5 S3_49_6 S3_49_7 S3_49_8 S3_49_10 S3_49_11 S3_49_12 S3_49_13 S3_49_14 S3_51_1 S3_51_2 S3_51_3 {

 gen Do`var'STERILFEM_pre = `var'
 
}

			
				
		*Construction de la variable pratique correcte preprocédure de la 
		*STERILISATION FEMININE. Elle consiste à respecter au moins 80% des
		*41 questions liées à la pratique de la STERILISATION FEMININE

		
egen 		Score_pra_STERILFEM_pre	=  rsum(*STERILFEM_pre)
local total_pratique_STERILFEM_pre = 41 // Nombre total de questions utilisées
gen STERILFEM_pre_correct = (Score_pra_STERILFEM_pre >= `=round(0.80 * `total_pratique_STERILFEM_pre')')
replace 	STERILFEM_pre_correct =. if Score_pra_STERILFEM_pre==0 | S2_22_8 !=1
label var 	STERILFEM_pre_correct "Correct pre-procedure practice for the STERILISATION FEMININE"
								
				
								
				
				
				********************************
				***  STERILISATION MASCULINE  ***
				********************************					

				
				
 foreach var of var S3_60_1 S3_60_2 S3_60_3 S3_60_4 S3_60_5 S3_60_6 S3_60_7 S3_60_8 S3_61_1 S3_61_2 S3_61_3 S3_61_4 S3_61_5 S3_62_1 S3_62_2 S3_62_3 S3_62_4 S3_62_5 S3_62_6 S3_63_1 S3_63_2 S3_63_3 S3_63_4 S3_63_5 S3_63_6 S3_63_7 S3_64_1 S3_64_2 S3_64_3 S3_64_4 S3_64_5 S3_64_6 S3_64_7 S3_64_8 S3_64_10 S3_64_11 S3_64_12 S3_64_13 S3_64_14 S3_64_15 S3_64_16 {

 gen Do`var'STERILMAS_pre = `var'
 
}

			
				
		*Construction de la variable pratique correcte preprocédure de la 
		*STERILISATION MASCULINE. Elle consiste à respecter au moins 80% des
		*41 questions liées à la pratique de la STERILISATION MASCULINE

		
egen 		Score_pra_STERILMAS_pre	=  rsum(*STERILMAS_pre)
local total_pratique_STERILMAS_pre = 41 // Nombre total de questions utilisées
gen STERILMAS_pre_correct = (Score_pra_STERILMAS_pre >= `=round(0.80 * `total_pratique_STERILMAS_pre')')
replace 	STERILMAS_pre_correct =. if Score_pra_STERILMAS_pre==0 | S2_22_9 !=1
label var 	STERILMAS_pre_correct "Correct pre-procedure practice for the STERILISATION MASCULINE"
								
			
			
			
			


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
		*post-procédure de la DIU. Elle consiste à respecter au moins 80% des
		*11 questions liées à la pratique postprocédure de la DIU

		
egen 		Score_pra_DIU_post	=  rsum(*DIU_post)
local total_pratique_DIU_post = 11 // Nombre total de questions utilisées
gen DIU_post_correct = (Score_pra_DIU_post >= `=round(0.80 * `total_pratique_DIU_post')')
replace 	DIU_post_correct =. if Score_pra_DIU_post==0 | S2_22_1 !=1
label var 	DIU_post_correct "Correct knowledge of post-procedural practices for DIU method"				
				
				
				
				
				********************
				***  INJECTABLE  ***
				********************
				
				
		
				
 foreach var of var S3_26_1 S3_26_2 S3_26_3 S3_26_4 S3_26_5 S3_26_6 S3_26_7 S3_26_8 S3_27_1 S3_27_2 S3_27_3 S3_27_4 S3_27_5 {

 gen Do`var'INJECT_post = `var'
 
}

			
				
		*Construction de la variable connaissance correcte des procédures
		*post-procédure de l'INJECTABLE. Elle consiste à respecter au moins 80% des
		*13 questions liées à la pratique postprocédure de l'INJECTABLE

		
egen 		Score_pra_INJECT_post	=  rsum(*INJECT_post)
local total_pratique_INJECT_post = 13 // Nombre total de questions utilisées
gen INJECT_post_correct = (Score_pra_INJECT_post >= `=round(0.80 * `total_pratique_INJECT_post')')
replace 	INJECT_post_correct =. if Score_pra_INJECT_post==0 | S2_22_2 !=1
label var 	INJECT_post_correct "Correct knowledge of post-procedural practices for INJECTABLE method"				
				
		
		
		
		
				******************
				***  IMPLANTS  ***
				******************				

				
		
				
 foreach var of var S3_37_1 S3_37_2 S3_37_3 S3_37_4 S3_37_5 S3_37_6 S3_37_7 S3_37_8 S3_37_10 S3_37_11 S3_37_12 S3_39_1 S3_39_2 S3_39_3 S3_39_4 S3_39_5 S3_39_6 S3_39_7 S3_40_1 S3_40_2 S3_40_3 S3_40_4 S3_40_5 {

 gen Do`var'IMPLANTS_post = `var'
 
}

			
				
		*Construction de la variable connaissance correcte des procédures
		*post-procédure de l'IMPLANTS. Elle consiste à respecter au moins 80% des
		*13 questions liées à la pratique postprocédure de l'IMPLANTS

		
egen 		Score_pra_IMPLANTS_post	=  rsum(*IMPLANTS_post)
local total_pratique_IMPLANTS_post = 13 // Nombre total de questions utilisées
gen IMPLANTS_post_correct = (Score_pra_IMPLANTS_post >= `=round(0.80 * `total_pratique_IMPLANTS_post')')
replace 	IMPLANTS_post_correct =. if Score_pra_IMPLANTS_post==0 | S2_22_7 !=1
label var 	IMPLANTS_post_correct "Correct knowledge of post-procedural practices for IMPLANTS method"				
				
		

				
				********************************
				***  STERILISATION FEMININE  ***
				********************************				

				
		
				
 foreach var of var S3_53_1 S3_53_2 S3_53_3 S3_53_4 S3_54_1 S3_54_2 S3_54_3 S3_54_4 S3_54_5 S3_54_6 S3_54_7 S3_54_8 S3_54_10 S3_54_11 S3_56_1 S3_56_2 S3_56_3 S3_56_4 S3_56_5 S3_56_6 S3_56_7 S3_56_8 {

 gen Do`var'STERILFEM_post = `var'
 
}

			
				
		*Construction de la variable connaissance correcte des procédures
		*post-procédure de la STERILISATION FEMININE . Elle consiste à 
		*respecter au moins 80% des 22 questions liées à la pratique 
		*postprocédure de la STERILISATION FEMININE 

		
egen 		Score_pra_STERILFEM_post	=  rsum(*STERILFEM_post)
local total_pratique_STERILFEM_post = 22 // Nombre total de questions utilisées
gen STERILFEM_post_correct = (Score_pra_STERILFEM_post >= `=round(0.80 * `total_pratique_STERILFEM_post')')
replace 	STERILFEM_post_correct =. if Score_pra_STERILFEM_post==0 | S2_22_8 !=1
label var 	STERILFEM_post_correct "Correct knowledge of post-procedural practices for STERILISATION FEMININE method"				
					
										
				
				
				
				*********************************
				***  STERILISATION MASCULINE  ***
				*********************************					
				
				
				
 foreach var of var S3_67_1 S3_67_2 S3_68_1 S3_68_2 S3_68_3 S3_68_4 S3_68_5 S3_68_6 S3_68_7 S3_68_8 S3_68_10 S3_68_11 S3_68_12 S3_68_13 S3_68_14 S3_70_1 S3_70_2 S3_70_3 S3_70_4 S3_70_5 S3_70_6 S3_73_1 S3_73_2 S3_73_3 S3_73_4 {

 gen Do`var'STERILMAS_post = `var'
 
}

			
				
		*Construction de la variable connaissance correcte des procédures
		*post-procédure de la STERILISATION MASCULINE. Elle consiste à 
		*respecter au moins 80% des 25 questions liées à la pratique 
		*postprocédure de la STERILISATION MASCULINE 

		
egen 		Score_pra_STERILMAS_post	=  rsum(*STERILMAS_post)
local total_pratique_STERILMAS_post = 25 // Nombre total de questions utilisées
gen STERILMAS_post_correct = (Score_pra_STERILMAS_post >= `=round(0.80 * `total_pratique_STERILMAS_post')')
replace 	STERILMAS_post_correct =. if Score_pra_STERILMAS_post==0 | S2_22_9 !=1
label var 	STERILMAS_post_correct "Correct knowledge of post-procedural practices for STERILISATION MASCULINE method"					
				
					
				
				

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
		*PF. Elle revient à avoir une opignon positive sur au moins 25% des
		*12 questions liées à la perception de la PF		
				
				

egen 		Score_Attitude_PF	=  rsum(*PF)
local total_Attitude_PF = 12 // Nombre total de questions utilisées
gen Favorable_PF = (Score_Attitude_PF >= `=round(0.80 * `total_Attitude_PF')')
replace 	Favorable_PF =. if Score_Attitude_PF==0 | S2_17 !=1
label var 	Favorable_PF "Favourable attitude to FP"



	
				
				
				*************
				***  DIU  ***
				*************

				
				
 foreach var of var S4_3_1 S4_3_2 S4_3_3 S4_3_4 S4_3_5 S4_3_6 S4_3_7 S4_3_8 S4_3_9 S4_3_10 S4_3_11 S4_3_12 {

 gen 	 Attitude`var'DIU = 	(`var'<= 2)
 replace Attitude`var'DIU =. if `var'== .
 
}				
				
				
		*Construction de la variable L'attitude favorable à l'égard de la
		*DIU. Elle revient à avoir une opignon positive sur au moins 25% des
		*12 questions liées à la perception de la DIU		
				
				

egen 		Score_Attitude_DIU	=  rsum(*DIU)
local total_Attitude_DIU = 12 // Nombre total de questions utilisées
gen Favorable_DIU = (Score_Attitude_DIU >= `=round(0.80 * `total_Attitude_DIU')')
replace 	Favorable_DIU =. if Score_Attitude_DIU==0 | S2_22_1 !=1
label var 	Favorable_DIU "Favourable attitude to DIU"

				
				
				
				
				*********************
				***  INJECTABLES  ***
				*********************
				
			
				
 foreach var of var S4_5_1 S4_5_2 S4_5_3 S4_5_4 S4_5_5 S4_5_6 S4_5_7 S4_5_8 S4_5_9 S4_5_10 {

 gen 	 Attitude`var'INJECTABLES = 	(`var'<= 2)
 replace Attitude`var'INJECTABLES =. if `var'== .
 
}				
				
				
		*Construction de la variable L'attitude favorable à l'égard de la
		*INJECTABLES. Elle revient à avoir une opignon positive sur au moins
		*25% des 12 questions liées à la perception de la INJECTABLES		
				
				

egen 		Score_Attitude_INJECTABLES	=  rsum(*INJECTABLES)
local total_Attitude_INJECTABLES = 10 // Nombre total de questions utilisées
gen Favorable_INJECTABLES = (Score_Attitude_INJECTABLES >= `=round(0.80 * `total_Attitude_INJECTABLES')')
replace 	Favorable_INJECTABLES =. if Score_Attitude_INJECTABLES==0 | S2_22_2 !=1
label var 	Favorable_INJECTABLES "Favourable attitude to INJECTABLES"

				
								
		
				
				******************
				***  IMPLANTS  ***
				******************
				
				
				
 foreach var of var S4_7_1 S4_7_2 S4_7_3 S4_7_4 S4_7_5 S4_7_6 S4_7_7 S4_7_8 S4_7_9 S4_7_10 {

 gen 	 Attitude`var'IMPLANTS = 	(`var'<= 2)
 replace Attitude`var'IMPLANTS =. if `var'== .
 
}				
				
				
		*Construction de la variable L'attitude favorable à l'égard de la
		*IMPLANTS. Elle revient à avoir une opignon positive sur au moins
		*25% des 12 questions liées à la perception de la IMPLANTS		
				
				

egen 		Score_Attitude_IMPLANTS	=  rsum(*IMPLANTS)
local total_Attitude_IMPLANTS = 10 // Nombre total de questions utilisées
gen Favorable_IMPLANTS = (Score_Attitude_IMPLANTS >= `=round(0.80 * `total_Attitude_IMPLANTS')')
replace 	Favorable_IMPLANTS =. if Score_Attitude_IMPLANTS==0 | S2_22_7 !=1
label var 	Favorable_IMPLANTS "Favourable attitude to IMPLANTS"

				
				
				
				*****************
				***  PILULE  ***
				*****************
	
				
				
 foreach var of var S4_9_1 S4_9_2 S4_9_3 S4_9_4 S4_9_5 S4_9_6 {

 gen 	 Attitude`var'PILULE = 	(`var'<= 2)
 replace Attitude`var'PILULE =. if `var'== .
 
}				
				
				
		*Construction de la variable L'attitude favorable à l'égard de la
		*PILULE. Elle revient à avoir une opignon positive sur au moins
		*25% des 12 questions liées à la perception de la PILULE		
				
				

egen 		Score_Attitude_PILULE	=  rsum(*PILULE)
local total_Attitude_PILULE = 6 // Nombre total de questions utilisées
gen Favorable_PILULE = (Score_Attitude_PILULE >= `=round(0.80 * `total_Attitude_PILULE')')
replace 	Favorable_PILULE =. if Score_Attitude_PILULE==0 | S2_22_6 !=1
label var 	Favorable_PILULE "Favourable attitude to PILULE"

							
				
				
				
				*********************************
				***  CONTRACEPTION D'URGENCE  ***
				*********************************
				
				
				
 foreach var of var S4_11_1 S4_11_2 S4_11_3 S4_11_4 S4_11_5 S4_11_6 {

 gen 	 Attitude`var'CONTRACEPURG = 	(`var'<= 2)
 replace Attitude`var'CONTRACEPURG =. if `var'== .
 
}				
				
				
		*Construction de la variable L'attitude favorable à l'égard de la
		*CONTRACEPTION D'URGENCE. Elle revient à avoir une opignon positive
		*sur au moins 25% des 12 questions liées à la perception de la
		*CONTRACEPTION D'URGENCE		
				
				

egen 		Score_Attitude_CONTRACEPURG	=  rsum(*CONTRACEPURG)
local total_Attitude_CONTRACEPURG = 6 // Nombre total de questions utilisées
gen Favorable_CONTRACEPURG = (Score_Attitude_CONTRACEPURG >= `=round(0.80 * `total_Attitude_CONTRACEPURG')')
replace 	Favorable_CONTRACEPURG =. if Score_Attitude_CONTRACEPURG==0 | S2_22_5 !=1
label var 	Favorable_CONTRACEPURG "Favourable attitude to CONTRACEPTION D'URGENCE"

											
							
				
				*****************************
				***  PRESERVATIF FEMININ  ***
				*****************************
					
				
				
 foreach var of var S4_13_1 S4_13_2 S4_13_3 S4_13_4 S4_13_5 {

 gen 	 Attitude`var'PRESERVATFEM = 	(`var'<= 2)
 replace Attitude`var'PRESERVATFEM =. if `var'== .
 
}				
				
				
		*Construction de la variable L'attitude favorable à l'égard de la
		*PRESERVATIF FEMININ. Elle revient à avoir une opignon positive
		*sur au moins 25% des 12 questions liées à la perception de la
		*PRESERVATIF FEMININ		
				
				

egen 		Score_Attitude_PRESERVATFEM	=  rsum(*PRESERVATFEM)
local total_Attitude_PRESERVATFEM = 5 // Nombre total de questions utilisées
gen Favorable_PRESERVATFEM = (Score_Attitude_PRESERVATFEM >= `=round(0.80 * `total_Attitude_PRESERVATFEM')')
replace 	Favorable_PRESERVATFEM =. if Score_Attitude_PRESERVATFEM==0 | S2_22_4 !=1
label var 	Favorable_PRESERVATFEM "Favourable attitude to PRESERVATIF FEMININ"

																					
				
								
				********************************
				***  STERILISATION FEMININE  ***
				********************************
				
				

				
 foreach var of var S4_15_1 S4_15_2 S4_15_3 S4_15_4 S4_15_5 S4_15_6 S4_15_7 S4_15_8 S4_15_9 {

 gen 	 Attitude`var'STERILISFEM = 	(`var'<= 2)
 replace Attitude`var'STERILISFEM =. if `var'== .
 
}				
				
				
		*Construction de la variable L'attitude favorable à l'égard de la
		*STERILISATION FEMININE. Elle revient à avoir une opignon positive
		*sur au moins 25% des 12 questions liées à la perception de la
		*STERILISATION FEMININE		
				
				

egen 		Score_Attitude_STERILISFEM	=  rsum(*STERILISFEM)
local total_Attitude_STERILISFEM = 9 // Nombre total de questions utilisées
gen Favorable_STERILISFEM = (Score_Attitude_STERILISFEM >= `=round(0.80 * `total_Attitude_STERILISFEM')')
replace 	Favorable_STERILISFEM =. if Score_Attitude_STERILISFEM==0 | S2_22_8 !=1
label var 	Favorable_STERILISFEM "Favourable attitude to STERILISATION FEMININE"

													
	
																
				
				*********************************
				***  STERILISATION MASCULINE  ***
				*********************************
				
				
				
 foreach var of var S4_17_1 S4_17_2 S4_17_3 S4_17_4 S4_17_5 {

 gen 	 Attitude`var'STERILISMAS = 	(`var'<= 2)
 replace Attitude`var'STERILISMAS =. if `var'== .
 
}				
				
				
		*Construction de la variable L'attitude favorable à l'égard de la
		*STERILISATION MASCULINE. Elle revient à avoir une opignon positive
		*sur au moins 25% des 12 questions liées à la perception de la
		*STERILISATION MASCULINE		
				
				

egen 		Score_Attitude_STERILISMAS	=  rsum(*STERILISMAS)
local total_Attitude_STERILISMAS = 5 // Nombre total de questions utilisées
gen Favorable_STERILISMAS = (Score_Attitude_STERILISMAS >= `=round(0.80 * `total_Attitude_STERILISMAS')')
replace 	Favorable_STERILISMAS =. if Score_Attitude_STERILISMAS==0 | S2_22_9 !=1
label var 	Favorable_STERILISMAS "Favourable attitude to STERILISATION MASCULINE"

																
				
				
				
				
				
				
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
		*soins prénatales. Elle revient à connaitre au moins 80% des actes
		*et les interventions transcrit par les 66 questions liées aux soins
		*prénatales
				
	

egen 		Score_Con_ANTENATAL	=  rsum(*ANTENATAL)
local total_Con_ANTENATAL = 66 // Nombre total de questions utilisées
gen Con_ANTENATAL = (Score_Con_ANTENATAL >= `=round(0.80 * `total_Con_ANTENATAL')')
replace 	Con_ANTENATAL =. if Score_Con_ANTENATAL==0
label var 	Con_ANTENATAL "Correct knowledge of antenatal care services"

																




				
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
		*soins prénatales. Elle revient à connaitre au moins 80% des actes
		*et les interventions transcrit par les 66 questions liées aux soins
		*prénatales
				
	

egen 		Score_Con_maternal	=  rsum(*maternal)
local total_Con_maternal = 89 // Nombre total de questions utilisées
gen Con_maternal = (Score_Con_maternal >= `=round(0.80 * `total_Con_maternal')')
replace 	Con_maternal =. if Score_Con_maternal==0
label var 	Con_maternal "Correct knowledge of Maternal care/delivery services"

																
				
				
				
				
				

				
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
		*soins prénatales. Elle revient à connaitre au moins 80% des actes
		*et les interventions transcrit par les 66 questions liées aux soins
		*prénatales
				
	

egen 		Score_Con_POSTNATAL	=  rsum(*POSTNATAL)
local total_Con_POSTNATAL = 75 // Nombre total de questions utilisées
gen Con_POSTNATAL = (Score_Con_POSTNATAL >= `=round(0.80 * `total_Con_POSTNATAL')')
replace 	Con_POSTNATAL =. if Score_Con_POSTNATAL==0
label var 	Con_POSTNATAL "Correct knowledge of POSTNATAL services"

													
				

					
				
*******INDICATEUR 2. Pourcentage de prestataires ayant une attitude favorable à
*******l'égard des soins maternels respectueux		
				
	
														
				
				
				
 foreach var of var S6_84a S6_84b S6_84c S6_84d S6_84e S6_84f S6_84g {

 gen 	 Attitude`var'SMNI = 	(`var'<= 2)
 replace Attitude`var'SMNI =. if `var'== .
 
}				
				
				
		*Construction de la variable L'attitude favorable à l'égard des soins
		*maternels respectueux. Elle revient à avoir une bonne opinion sur au
		*moins 80% des 7 questions liées à la perception de la SMIN
				
				

egen 		Score_Attitude_SMNI	=  rsum(*SMNI)
local total_Attitude_SMNI = 7 // Nombre total de questions utilisées
gen Favorable_SMNI = (Score_Attitude_SMNI >= `=round(0.80 * `total_Attitude_SMNI')')
replace Favorable_SMNI=. if AttitudeS6_84aSMNI==. | AttitudeS6_84bSMNI==. | AttitudeS6_84cSMNI==. | AttitudeS6_84dSMNI==. | AttitudeS6_84eSMNI==. | AttitudeS6_84fSMNI==. | AttitudeS6_84gSMNI==.
label var 	Favorable_SMNI "Positive attitude towards respectful maternal care"






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








***********************PRODUCTION DES TABLEAUX SUR FORMATS EXCEL




			
			***CONNAISSANCE DES METHODES***
			
			****National
			
* Définir les variables et le fichier de sortie
putexcel set "NURSES&MIDWIVES.xlsx", sheet("PF KNOWLEDGE") modify
global var1 "DIU Injectables Preservatif_M Preservatif_F Contraception_Urg Pilules Implants Sterilisation_F Sterilisation_M Allaitement_Exclu"

* Ajouter le titre du tableau
putexcel A1 = "Table 1: Knowledge of family planning methods at the national level"

* Ajouter les en-têtes des colonnes
putexcel A2 = "Indicators" B2 = "Counts (Effectifs)" C2 = "Proportions (%)" D2 = "Total"

* Initialiser une ligne pour écrire les données
local row = 3

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var1 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Calculer les effectifs et proportions pour les deux modalités
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

        * Ajouter le label de l'indicateur dans la colonne "Indicators"
        putexcel A`row' = "`label'"

        * Ajouter les effectifs dans la colonne "Counts (Effectifs)"
        putexcel B`row' = `count1'

        * Ajouter les proportions dans la colonne "Proportions (%)"
        putexcel C`row' = "`proportion_formatted'"

        * Ajouter le total dans la colonne "Total"
        putexcel D`row' = total_effectifs

        * Passer à la ligne suivante
        local row = `row' + 1
    }
}

	
	****Région	
	
* Définir les variables et le fichier de sortie
putexcel set "NURSES&MIDWIVES.xlsx", sheet("PF KNOWLEDGE") modify

* Définir les variables d'analyse
global var1 "DIU Injectables Preservatif_M Preservatif_F Contraception_Urg Pilules Implants Sterilisation_F Sterilisation_M Allaitement_Exclu"
global regions "DAKAR DIOURBEL FATICK KAFFRINE KAOLACK KEDOUGOU KOLDA LOUGA MATAM SAINTLOUIS SEDHIOU TAMBACOUNDA THIES ZIGUINCHOR"

* Ajouter le titre du tableau
putexcel A15 = "Table 2: Knowledge of family planning methods by region"

* Ajouter les en-têtes des colonnes (régions)
putexcel A16 = "Indicators"
local col = 2  // Colonne de départ pour les régions (B)

foreach region in $regions {
    * Calculer la lettre pour les effectifs
    local count_col_letter = ""
    if `col' <= 26 {
        local count_col_letter = char(64 + `col')
    }
    else {
        local count_col_letter = char(64 + int((`col' - 1) / 26)) + char(64 + mod((`col' - 1), 26) + 1)
    }
    * Ajouter l'en-tête pour les effectifs
    putexcel `count_col_letter'16 = "`region' - Counts"

    * Calculer la lettre pour les proportions
    local prop_col_letter = ""
    if (`col' + 1) <= 26 {
        local prop_col_letter = char(64 + (`col' + 1))
    }
    else {
        local prop_col_letter = char(64 + int((`col') / 26)) + char(64 + mod((`col'), 26) + 1)
    }
    * Ajouter l'en-tête pour les proportions
    putexcel `prop_col_letter'16 = "`region' - Proportions"

    * Incrémenter de 2 pour passer aux colonnes suivantes
    local col = `col' + 2
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 17
local row = 17

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
        keep if region == "`region'"  // Assurez-vous que la variable REGION contient les noms des régions
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

            * Calculer les lettres des colonnes actuelles
            local count_col_letter = ""
            if `col' <= 26 {
                local count_col_letter = char(64 + `col')
            }
            else {
                local count_col_letter = char(64 + int((`col' - 1) / 26)) + char(64 + mod((`col' - 1), 26) + 1)
            }
            local prop_col_letter = ""
            if (`col' + 1) <= 26 {
                local prop_col_letter = char(64 + (`col' + 1))
            }
            else {
                local prop_col_letter = char(64 + int((`col') / 26)) + char(64 + mod((`col'), 26) + 1)
            }

            * Ajouter les effectifs dans la colonne des effectifs
            putexcel `count_col_letter'`row' = `count1'

            * Ajouter les proportions formatées dans la colonne des proportions
            putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        }

        restore
        local col = `col' + 2  // Passer à la prochaine paire de colonnes
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}
	
	
	
		****Structures
	

	
* Définir les variables et le fichier de sortie
putexcel set "NURSES&MIDWIVES.xlsx", sheet("PF KNOWLEDGE") modify

* Définir les variables d'analyse
global var1 "DIU Injectables Preservatif_M Preservatif_F Contraception_Urg Pilules Implants Sterilisation_F Sterilisation_M Allaitement_Exclu"
global structures "Hospital HealthCenter HealthPost"  // Liste des structures de santé

* Ajouter le titre du tableau à partir de la ligne 30
putexcel A30 = "Table 3: Knowledge of family planning methods by structure of health facilities"

* Ajouter les en-têtes des colonnes (structures)
putexcel A31 = "Indicators"
local col = 2  // Colonne de départ pour les structures (B)

foreach structure in $structures {
    * Calculer les lettres pour les colonnes des effectifs et des proportions
    local count_col_letter = ""
    if `col' <= 26 {
        local count_col_letter = char(64 + `col')
    }
    else {
        local count_col_letter = char(64 + int((`col' - 1) / 26)) + char(64 + mod((`col' - 1), 26) + 1)
    }
    putexcel `count_col_letter'31 = "`structure' - Counts"

    local prop_col_letter = ""
    if (`col' + 1) <= 26 {
        local prop_col_letter = char(64 + (`col' + 1))
    }
    else {
        local prop_col_letter = char(64 + int((`col') / 26)) + char(64 + mod((`col'), 26) + 1)
    }
    putexcel `prop_col_letter'31 = "`structure' - Proportions (%)"

    * Incrémenter de 2 pour passer aux colonnes suivantes
    local col = `col' + 2
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
        keep if Structure == "`structure'"  // Assurez-vous que la variable "Structure" contient les noms des structures
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

            * Calculer les lettres des colonnes actuelles
            local count_col_letter = ""
            if `col' <= 26 {
                local count_col_letter = char(64 + `col')
            }
            else {
                local count_col_letter = char(64 + int((`col' - 1) / 26)) + char(64 + mod((`col' - 1), 26) + 1)
            }
            local prop_col_letter = ""
            if (`col' + 1) <= 26 {
                local prop_col_letter = char(64 + (`col' + 1))
            }
            else {
                local prop_col_letter = char(64 + int((`col') / 26)) + char(64 + mod((`col'), 26) + 1)
            }

            * Ajouter les effectifs dans la colonne des effectifs
            putexcel `count_col_letter'`row' = `count1'

            * Ajouter les proportions formatées dans la colonne des proportions
            putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        }

        restore
        local col = `col' + 2  // Passer à la prochaine paire de colonnes
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	

	
	**Place of residence
	
* Définir les variables et le fichier de sortie
putexcel set "NURSES&MIDWIVES.xlsx", sheet("PF KNOWLEDGE") modify

* Définir les variables d'analyse
global var1 "DIU Injectables Preservatif_M Preservatif_F Contraception_Urg Pilules Implants Sterilisation_F Sterilisation_M Allaitement_Exclu"
global places "Rural Urban"  // Liste des lieux

* Ajouter le titre du tableau à partir de la ligne 45
putexcel A45 = "Table 4: Knowledge of family planning methods by place (Rural, Urban)"

* Ajouter les en-têtes des colonnes (places)
putexcel A46 = "Indicators"
local col = 2  // Colonne de départ pour les lieux (B)

foreach place in $places {
    * Calculer les lettres pour les colonnes des effectifs et des proportions
    local count_col_letter = ""
    if `col' <= 26 {
        local count_col_letter = char(64 + `col')
    }
    else {
        local count_col_letter = char(64 + int((`col' - 1) / 26)) + char(64 + mod((`col' - 1), 26) + 1)
    }
    putexcel `count_col_letter'46 = "`place' - Counts"

    local prop_col_letter = ""
    if (`col' + 1) <= 26 {
        local prop_col_letter = char(64 + (`col' + 1))
    }
    else {
        local prop_col_letter = char(64 + int((`col') / 26)) + char(64 + mod((`col'), 26) + 1)
    }
    putexcel `prop_col_letter'46 = "`place' - Proportions (%)"

    * Incrémenter de 2 pour passer aux colonnes suivantes
    local col = `col' + 2
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

            * Calculer les lettres des colonnes actuelles
            local count_col_letter = ""
            if `col' <= 26 {
                local count_col_letter = char(64 + `col')
            }
            else {
                local count_col_letter = char(64 + int((`col' - 1) / 26)) + char(64 + mod((`col' - 1), 26) + 1)
            }
            local prop_col_letter = ""
            if (`col' + 1) <= 26 {
                local prop_col_letter = char(64 + (`col' + 1))
            }
            else {
                local prop_col_letter = char(64 + int((`col') / 26)) + char(64 + mod((`col'), 26) + 1)
            }

            * Ajouter les effectifs dans la colonne des effectifs
            putexcel `count_col_letter'`row' = `count1'

            * Ajouter les proportions formatées dans la colonne des proportions
            putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        }

        restore
        local col = `col' + 2  // Passer à la prochaine paire de colonnes
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}
	
	



			***CONNAISSANCE CORRECTE***
			
			
			****National
			
* Définir les variables et le fichier de sortie
putexcel set "NURSES&MIDWIVES.xlsx", sheet("PF CORRECT KNOWLEDGE") modify
global var2 "DIU_correct INJECTABLE_correct IMPLANTS_correct STERILFEM_correct STERILMAS_correct"

* Ajouter le titre du tableau
putexcel A1 = "Table 1: Correct knowledge of family planning methods at the national level"

* Ajouter les en-têtes des colonnes
putexcel A2 = "Indicators" B2 = "Counts (Effectifs)" C2 = "Proportions (%)" D2 = "Total"

* Initialiser une ligne pour écrire les données
local row = 3

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var2 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Calculer les effectifs et proportions pour les deux modalités
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

        * Ajouter le label de l'indicateur dans la colonne "Indicators"
        putexcel A`row' = "`label'"

        * Ajouter les effectifs dans la colonne "Counts (Effectifs)"
        putexcel B`row' = `count1'

        * Ajouter les proportions dans la colonne "Proportions (%)"
        putexcel C`row' = "`proportion_formatted'"

        * Ajouter le total dans la colonne "Total"
        putexcel D`row' = total_effectifs

        * Passer à la ligne suivante
        local row = `row' + 1
    }
}

	
	****Région	
	
* Définir les variables et le fichier de sortie
putexcel set "NURSES&MIDWIVES.xlsx", sheet("PF CORRECT KNOWLEDGE") modify

* Définir les variables d'analyse
global var2 "DIU_correct INJECTABLE_correct IMPLANTS_correct STERILFEM_correct STERILMAS_correct"
global regions "DAKAR DIOURBEL FATICK KAFFRINE KAOLACK KEDOUGOU KOLDA LOUGA MATAM SAINTLOUIS SEDHIOU TAMBACOUNDA THIES ZIGUINCHOR"

* Ajouter le titre du tableau
putexcel A15 = "Table 2: Correct knowledge of family planning methods by region"

* Ajouter les en-têtes des colonnes (régions)
putexcel A16 = "Indicators"
local col = 2  // Colonne de départ pour les régions (B)

foreach region in $regions {
    * Calculer la lettre pour les effectifs
    local count_col_letter = ""
    if `col' <= 26 {
        local count_col_letter = char(64 + `col')
    }
    else {
        local count_col_letter = char(64 + int((`col' - 1) / 26)) + char(64 + mod((`col' - 1), 26) + 1)
    }
    * Ajouter l'en-tête pour les effectifs
    putexcel `count_col_letter'16 = "`region' - Counts"

    * Calculer la lettre pour les proportions
    local prop_col_letter = ""
    if (`col' + 1) <= 26 {
        local prop_col_letter = char(64 + (`col' + 1))
    }
    else {
        local prop_col_letter = char(64 + int((`col') / 26)) + char(64 + mod((`col'), 26) + 1)
    }
    * Ajouter l'en-tête pour les proportions
    putexcel `prop_col_letter'16 = "`region' - Proportions"

    * Incrémenter de 2 pour passer aux colonnes suivantes
    local col = `col' + 2
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
        keep if region == "`region'"  // Assurez-vous que la variable REGION contient les noms des régions
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

            * Calculer les lettres des colonnes actuelles
            local count_col_letter = ""
            if `col' <= 26 {
                local count_col_letter = char(64 + `col')
            }
            else {
                local count_col_letter = char(64 + int((`col' - 1) / 26)) + char(64 + mod((`col' - 1), 26) + 1)
            }
            local prop_col_letter = ""
            if (`col' + 1) <= 26 {
                local prop_col_letter = char(64 + (`col' + 1))
            }
            else {
                local prop_col_letter = char(64 + int((`col') / 26)) + char(64 + mod((`col'), 26) + 1)
            }

            * Ajouter les effectifs dans la colonne des effectifs
            putexcel `count_col_letter'`row' = `count1'

            * Ajouter les proportions formatées dans la colonne des proportions
            putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        }

        restore
        local col = `col' + 2  // Passer à la prochaine paire de colonnes
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}
	
	
	
		****Structures
	

	
* Définir les variables et le fichier de sortie
putexcel set "NURSES&MIDWIVES.xlsx", sheet("PF CORRECT KNOWLEDGE") modify

* Définir les variables d'analyse
global var2 "DIU_correct INJECTABLE_correct IMPLANTS_correct STERILFEM_correct STERILMAS_correct"
global structures "Hospital HealthCenter HealthPost"  // Liste des structures de santé

* Ajouter le titre du tableau à partir de la ligne 30
putexcel A30 = "Table 3: Correct knowledge of family planning methods by structure of health facilities"

* Ajouter les en-têtes des colonnes (structures)
putexcel A31 = "Indicators"
local col = 2  // Colonne de départ pour les structures (B)

foreach structure in $structures {
    * Calculer les lettres pour les colonnes des effectifs et des proportions
    local count_col_letter = ""
    if `col' <= 26 {
        local count_col_letter = char(64 + `col')
    }
    else {
        local count_col_letter = char(64 + int((`col' - 1) / 26)) + char(64 + mod((`col' - 1), 26) + 1)
    }
    putexcel `count_col_letter'31 = "`structure' - Counts"

    local prop_col_letter = ""
    if (`col' + 1) <= 26 {
        local prop_col_letter = char(64 + (`col' + 1))
    }
    else {
        local prop_col_letter = char(64 + int((`col') / 26)) + char(64 + mod((`col'), 26) + 1)
    }
    putexcel `prop_col_letter'31 = "`structure' - Proportions (%)"

    * Incrémenter de 2 pour passer aux colonnes suivantes
    local col = `col' + 2
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
        keep if Structure == "`structure'"  // Assurez-vous que la variable "Structure" contient les noms des structures
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

            * Calculer les lettres des colonnes actuelles
            local count_col_letter = ""
            if `col' <= 26 {
                local count_col_letter = char(64 + `col')
            }
            else {
                local count_col_letter = char(64 + int((`col' - 1) / 26)) + char(64 + mod((`col' - 1), 26) + 1)
            }
            local prop_col_letter = ""
            if (`col' + 1) <= 26 {
                local prop_col_letter = char(64 + (`col' + 1))
            }
            else {
                local prop_col_letter = char(64 + int((`col') / 26)) + char(64 + mod((`col'), 26) + 1)
            }

            * Ajouter les effectifs dans la colonne des effectifs
            putexcel `count_col_letter'`row' = `count1'

            * Ajouter les proportions formatées dans la colonne des proportions
            putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        }

        restore
        local col = `col' + 2  // Passer à la prochaine paire de colonnes
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	

	
	**Place of residence
	
* Définir les variables et le fichier de sortie
putexcel set "NURSES&MIDWIVES.xlsx", sheet("PF CORRECT KNOWLEDGE") modify

* Définir les variables d'analyse
global var2 "DIU_correct INJECTABLE_correct IMPLANTS_correct STERILFEM_correct STERILMAS_correct"
global places "Rural Urban"  // Liste des lieux

* Ajouter le titre du tableau à partir de la ligne 45
putexcel A45 = "Table 4: Correct knowledge of family planning methods by place (Rural, Urban)"

* Ajouter les en-têtes des colonnes (places)
putexcel A46 = "Indicators"
local col = 2  // Colonne de départ pour les lieux (B)

foreach place in $places {
    * Calculer les lettres pour les colonnes des effectifs et des proportions
    local count_col_letter = ""
    if `col' <= 26 {
        local count_col_letter = char(64 + `col')
    }
    else {
        local count_col_letter = char(64 + int((`col' - 1) / 26)) + char(64 + mod((`col' - 1), 26) + 1)
    }
    putexcel `count_col_letter'46 = "`place' - Counts"

    local prop_col_letter = ""
    if (`col' + 1) <= 26 {
        local prop_col_letter = char(64 + (`col' + 1))
    }
    else {
        local prop_col_letter = char(64 + int((`col') / 26)) + char(64 + mod((`col'), 26) + 1)
    }
    putexcel `prop_col_letter'46 = "`place' - Proportions (%)"

    * Incrémenter de 2 pour passer aux colonnes suivantes
    local col = `col' + 2
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
        keep if Place == "`place'"  // Assurez-vous que la variable Place contient "Rural" ou "Urban"
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

            * Calculer les lettres des colonnes actuelles
            local count_col_letter = ""
            if `col' <= 26 {
                local count_col_letter = char(64 + `col')
            }
            else {
                local count_col_letter = char(64 + int((`col' - 1) / 26)) + char(64 + mod((`col' - 1), 26) + 1)
            }
            local prop_col_letter = ""
            if (`col' + 1) <= 26 {
                local prop_col_letter = char(64 + (`col' + 1))
            }
            else {
                local prop_col_letter = char(64 + int((`col') / 26)) + char(64 + mod((`col'), 26) + 1)
            }

            * Ajouter les effectifs dans la colonne des effectifs
            putexcel `count_col_letter'`row' = `count1'

            * Ajouter les proportions formatées dans la colonne des proportions
            putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        }

        restore
        local col = `col' + 2  // Passer à la prochaine paire de colonnes
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}
	
	

			***CONNAISSANCE CORRECTE PRE-PROCEDURE***
			
			
			****National
			
* Définir les variables et le fichier de sortie
putexcel set "NURSES&MIDWIVES.xlsx", sheet("PREPROCEDURE") modify
global var3 "DIU_pre_correct INJECT_pre_correct IMPLANTS_pre_correct STERILFEM_pre_correct STERILMAS_pre_correct"

* Ajouter le titre du tableau
putexcel A1 = "Table 1: Pre-procedure correct knowledge of family planning methods at the national level"

* Ajouter les en-têtes des colonnes
putexcel A2 = "Indicators" B2 = "Counts (Effectifs)" C2 = "Proportions (%)" D2 = "Total"

* Initialiser une ligne pour écrire les données
local row = 3

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var3 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Calculer les effectifs et proportions pour les deux modalités
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

        * Ajouter le label de l'indicateur dans la colonne "Indicators"
        putexcel A`row' = "`label'"

        * Ajouter les effectifs dans la colonne "Counts (Effectifs)"
        putexcel B`row' = `count1'

        * Ajouter les proportions dans la colonne "Proportions (%)"
        putexcel C`row' = "`proportion_formatted'"

        * Ajouter le total dans la colonne "Total"
        putexcel D`row' = total_effectifs

        * Passer à la ligne suivante
        local row = `row' + 1
    }
}

	
	****Région	
	
* Définir les variables et le fichier de sortie
putexcel set "NURSES&MIDWIVES.xlsx", sheet("PREPROCEDURE") modify

* Définir les variables d'analyse
global var3 "DIU_pre_correct INJECT_pre_correct IMPLANTS_pre_correct STERILFEM_pre_correct STERILMAS_pre_correct"
global regions "DAKAR DIOURBEL FATICK KAFFRINE KAOLACK KEDOUGOU KOLDA LOUGA MATAM SAINTLOUIS SEDHIOU TAMBACOUNDA THIES ZIGUINCHOR"

* Ajouter le titre du tableau
putexcel A15 = "Table 2: Pre-procedure correct knowledge of family planning methods by region"

* Ajouter les en-têtes des colonnes (régions)
putexcel A16 = "Indicators"
local col = 2  // Colonne de départ pour les régions (B)

foreach region in $regions {
    * Calculer la lettre pour les effectifs
    local count_col_letter = ""
    if `col' <= 26 {
        local count_col_letter = char(64 + `col')
    }
    else {
        local count_col_letter = char(64 + int((`col' - 1) / 26)) + char(64 + mod((`col' - 1), 26) + 1)
    }
    * Ajouter l'en-tête pour les effectifs
    putexcel `count_col_letter'16 = "`region' - Counts"

    * Calculer la lettre pour les proportions
    local prop_col_letter = ""
    if (`col' + 1) <= 26 {
        local prop_col_letter = char(64 + (`col' + 1))
    }
    else {
        local prop_col_letter = char(64 + int((`col') / 26)) + char(64 + mod((`col'), 26) + 1)
    }
    * Ajouter l'en-tête pour les proportions
    putexcel `prop_col_letter'16 = "`region' - Proportions"

    * Incrémenter de 2 pour passer aux colonnes suivantes
    local col = `col' + 2
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 17
local row = 17

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var3 {
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
        keep if region == "`region'"  // Assurez-vous que la variable REGION contient les noms des régions
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

            * Calculer les lettres des colonnes actuelles
            local count_col_letter = ""
            if `col' <= 26 {
                local count_col_letter = char(64 + `col')
            }
            else {
                local count_col_letter = char(64 + int((`col' - 1) / 26)) + char(64 + mod((`col' - 1), 26) + 1)
            }
            local prop_col_letter = ""
            if (`col' + 1) <= 26 {
                local prop_col_letter = char(64 + (`col' + 1))
            }
            else {
                local prop_col_letter = char(64 + int((`col') / 26)) + char(64 + mod((`col'), 26) + 1)
            }

            * Ajouter les effectifs dans la colonne des effectifs
            putexcel `count_col_letter'`row' = `count1'

            * Ajouter les proportions formatées dans la colonne des proportions
            putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        }

        restore
        local col = `col' + 2  // Passer à la prochaine paire de colonnes
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}
	
	
	
		****Structures
	

	
* Définir les variables et le fichier de sortie
putexcel set "NURSES&MIDWIVES.xlsx", sheet("PREPROCEDURE") modify

* Définir les variables d'analyse
global var3 "DIU_pre_correct INJECT_pre_correct IMPLANTS_pre_correct STERILFEM_pre_correct STERILMAS_pre_correct"
global structures "Hospital HealthCenter HealthPost"  // Liste des structures de santé

* Ajouter le titre du tableau à partir de la ligne 30
putexcel A30 = "Table 3: Pre-procedure correct knowledge of family planning methods by structure of health facilities"

* Ajouter les en-têtes des colonnes (structures)
putexcel A31 = "Indicators"
local col = 2  // Colonne de départ pour les structures (B)

foreach structure in $structures {
    * Calculer les lettres pour les colonnes des effectifs et des proportions
    local count_col_letter = ""
    if `col' <= 26 {
        local count_col_letter = char(64 + `col')
    }
    else {
        local count_col_letter = char(64 + int((`col' - 1) / 26)) + char(64 + mod((`col' - 1), 26) + 1)
    }
    putexcel `count_col_letter'31 = "`structure' - Counts"

    local prop_col_letter = ""
    if (`col' + 1) <= 26 {
        local prop_col_letter = char(64 + (`col' + 1))
    }
    else {
        local prop_col_letter = char(64 + int((`col') / 26)) + char(64 + mod((`col'), 26) + 1)
    }
    putexcel `prop_col_letter'31 = "`structure' - Proportions (%)"

    * Incrémenter de 2 pour passer aux colonnes suivantes
    local col = `col' + 2
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 32
local row = 32

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var3 {
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
        keep if Structure == "`structure'"  // Assurez-vous que la variable "Structure" contient les noms des structures
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

            * Calculer les lettres des colonnes actuelles
            local count_col_letter = ""
            if `col' <= 26 {
                local count_col_letter = char(64 + `col')
            }
            else {
                local count_col_letter = char(64 + int((`col' - 1) / 26)) + char(64 + mod((`col' - 1), 26) + 1)
            }
            local prop_col_letter = ""
            if (`col' + 1) <= 26 {
                local prop_col_letter = char(64 + (`col' + 1))
            }
            else {
                local prop_col_letter = char(64 + int((`col') / 26)) + char(64 + mod((`col'), 26) + 1)
            }

            * Ajouter les effectifs dans la colonne des effectifs
            putexcel `count_col_letter'`row' = `count1'

            * Ajouter les proportions formatées dans la colonne des proportions
            putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        }

        restore
        local col = `col' + 2  // Passer à la prochaine paire de colonnes
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	

	
	**Place of residence
	
* Définir les variables et le fichier de sortie
putexcel set "NURSES&MIDWIVES.xlsx", sheet("PREPROCEDURE") modify

* Définir les variables d'analyse
global var3 "DIU_pre_correct INJECT_pre_correct IMPLANTS_pre_correct STERILFEM_pre_correct STERILMAS_pre_correct"
global places "Rural Urban"  // Liste des lieux

* Ajouter le titre du tableau à partir de la ligne 45
putexcel A45 = "Table 4: Pre-procedure correct knowledge of family planning methods by place (Rural, Urban)"

* Ajouter les en-têtes des colonnes (places)
putexcel A46 = "Indicators"
local col = 2  // Colonne de départ pour les lieux (B)

foreach place in $places {
    * Calculer les lettres pour les colonnes des effectifs et des proportions
    local count_col_letter = ""
    if `col' <= 26 {
        local count_col_letter = char(64 + `col')
    }
    else {
        local count_col_letter = char(64 + int((`col' - 1) / 26)) + char(64 + mod((`col' - 1), 26) + 1)
    }
    putexcel `count_col_letter'46 = "`place' - Counts"

    local prop_col_letter = ""
    if (`col' + 1) <= 26 {
        local prop_col_letter = char(64 + (`col' + 1))
    }
    else {
        local prop_col_letter = char(64 + int((`col') / 26)) + char(64 + mod((`col'), 26) + 1)
    }
    putexcel `prop_col_letter'46 = "`place' - Proportions (%)"

    * Incrémenter de 2 pour passer aux colonnes suivantes
    local col = `col' + 2
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 47
local row = 47

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var3 {
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

            * Calculer les lettres des colonnes actuelles
            local count_col_letter = ""
            if `col' <= 26 {
                local count_col_letter = char(64 + `col')
            }
            else {
                local count_col_letter = char(64 + int((`col' - 1) / 26)) + char(64 + mod((`col' - 1), 26) + 1)
            }
            local prop_col_letter = ""
            if (`col' + 1) <= 26 {
                local prop_col_letter = char(64 + (`col' + 1))
            }
            else {
                local prop_col_letter = char(64 + int((`col') / 26)) + char(64 + mod((`col'), 26) + 1)
            }

            * Ajouter les effectifs dans la colonne des effectifs
            putexcel `count_col_letter'`row' = `count1'

            * Ajouter les proportions formatées dans la colonne des proportions
            putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        }

        restore
        local col = `col' + 2  // Passer à la prochaine paire de colonnes
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}
		

			***CONNAISSANCE CORRECTE POST-PROCEDURE***
				
		
			****National
			
* Définir les variables et le fichier de sortie
putexcel set "NURSES&MIDWIVES.xlsx", sheet("POSTPROCEDURE") modify
global var4 "DIU_post_correct INJECT_post_correct IMPLANTS_post_correct STERILFEM_post_correct STERILMAS_post_correct"

* Ajouter le titre du tableau
putexcel A1 = "Table 1: Post-procedure correct knowledge of family planning methods at the national level"

* Ajouter les en-têtes des colonnes
putexcel A2 = "Indicators" B2 = "Counts (Effectifs)" C2 = "Proportions (%)" D2 = "Total"

* Initialiser une ligne pour écrire les données
local row = 3

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var4 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Calculer les effectifs et proportions pour les deux modalités
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

        * Ajouter le label de l'indicateur dans la colonne "Indicators"
        putexcel A`row' = "`label'"

        * Ajouter les effectifs dans la colonne "Counts (Effectifs)"
        putexcel B`row' = `count1'

        * Ajouter les proportions dans la colonne "Proportions (%)"
        putexcel C`row' = "`proportion_formatted'"

        * Ajouter le total dans la colonne "Total"
        putexcel D`row' = total_effectifs

        * Passer à la ligne suivante
        local row = `row' + 1
    }
}

	
	****Région	
	
* Définir les variables et le fichier de sortie
putexcel set "NURSES&MIDWIVES.xlsx", sheet("POSTPROCEDURE") modify

* Définir les variables d'analyse
global var4 "DIU_post_correct INJECT_post_correct IMPLANTS_post_correct STERILFEM_post_correct STERILMAS_post_correct"
global regions "DAKAR DIOURBEL FATICK KAFFRINE KAOLACK KEDOUGOU KOLDA LOUGA MATAM SAINTLOUIS SEDHIOU TAMBACOUNDA THIES ZIGUINCHOR"

* Ajouter le titre du tableau
putexcel A15 = "Table 2: Post-procedure correct knowledge of family planning methods by region"

* Ajouter les en-têtes des colonnes (régions)
putexcel A16 = "Indicators"
local col = 2  // Colonne de départ pour les régions (B)

foreach region in $regions {
    * Calculer la lettre pour les effectifs
    local count_col_letter = ""
    if `col' <= 26 {
        local count_col_letter = char(64 + `col')
    }
    else {
        local count_col_letter = char(64 + int((`col' - 1) / 26)) + char(64 + mod((`col' - 1), 26) + 1)
    }
    * Ajouter l'en-tête pour les effectifs
    putexcel `count_col_letter'16 = "`region' - Counts"

    * Calculer la lettre pour les proportions
    local prop_col_letter = ""
    if (`col' + 1) <= 26 {
        local prop_col_letter = char(64 + (`col' + 1))
    }
    else {
        local prop_col_letter = char(64 + int((`col') / 26)) + char(64 + mod((`col'), 26) + 1)
    }
    * Ajouter l'en-tête pour les proportions
    putexcel `prop_col_letter'16 = "`region' - Proportions"

    * Incrémenter de 2 pour passer aux colonnes suivantes
    local col = `col' + 2
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 17
local row = 17

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var4 {
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
        keep if region == "`region'"  // Assurez-vous que la variable REGION contient les noms des régions
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

            * Calculer les lettres des colonnes actuelles
            local count_col_letter = ""
            if `col' <= 26 {
                local count_col_letter = char(64 + `col')
            }
            else {
                local count_col_letter = char(64 + int((`col' - 1) / 26)) + char(64 + mod((`col' - 1), 26) + 1)
            }
            local prop_col_letter = ""
            if (`col' + 1) <= 26 {
                local prop_col_letter = char(64 + (`col' + 1))
            }
            else {
                local prop_col_letter = char(64 + int((`col') / 26)) + char(64 + mod((`col'), 26) + 1)
            }

            * Ajouter les effectifs dans la colonne des effectifs
            putexcel `count_col_letter'`row' = `count1'

            * Ajouter les proportions formatées dans la colonne des proportions
            putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        }

        restore
        local col = `col' + 2  // Passer à la prochaine paire de colonnes
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}
	
	
	
		****Structures
	

	
* Définir les variables et le fichier de sortie
putexcel set "NURSES&MIDWIVES.xlsx", sheet("POSTPROCEDURE") modify

* Définir les variables d'analyse
global var4 "DIU_post_correct INJECT_post_correct IMPLANTS_post_correct STERILFEM_post_correct STERILMAS_post_correct"
global structures "Hospital HealthCenter HealthPost"  // Liste des structures de santé

* Ajouter le titre du tableau à partir de la ligne 30
putexcel A30 = "Table 3: Post-procedure correct knowledge of family planning methods by structure of health facilities"

* Ajouter les en-têtes des colonnes (structures)
putexcel A31 = "Indicators"
local col = 2  // Colonne de départ pour les structures (B)

foreach structure in $structures {
    * Calculer les lettres pour les colonnes des effectifs et des proportions
    local count_col_letter = ""
    if `col' <= 26 {
        local count_col_letter = char(64 + `col')
    }
    else {
        local count_col_letter = char(64 + int((`col' - 1) / 26)) + char(64 + mod((`col' - 1), 26) + 1)
    }
    putexcel `count_col_letter'31 = "`structure' - Counts"

    local prop_col_letter = ""
    if (`col' + 1) <= 26 {
        local prop_col_letter = char(64 + (`col' + 1))
    }
    else {
        local prop_col_letter = char(64 + int((`col') / 26)) + char(64 + mod((`col'), 26) + 1)
    }
    putexcel `prop_col_letter'31 = "`structure' - Proportions (%)"

    * Incrémenter de 2 pour passer aux colonnes suivantes
    local col = `col' + 2
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 32
local row = 32

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var4 {
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
        keep if Structure == "`structure'"  // Assurez-vous que la variable "Structure" contient les noms des structures
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

            * Calculer les lettres des colonnes actuelles
            local count_col_letter = ""
            if `col' <= 26 {
                local count_col_letter = char(64 + `col')
            }
            else {
                local count_col_letter = char(64 + int((`col' - 1) / 26)) + char(64 + mod((`col' - 1), 26) + 1)
            }
            local prop_col_letter = ""
            if (`col' + 1) <= 26 {
                local prop_col_letter = char(64 + (`col' + 1))
            }
            else {
                local prop_col_letter = char(64 + int((`col') / 26)) + char(64 + mod((`col'), 26) + 1)
            }

            * Ajouter les effectifs dans la colonne des effectifs
            putexcel `count_col_letter'`row' = `count1'

            * Ajouter les proportions formatées dans la colonne des proportions
            putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        }

        restore
        local col = `col' + 2  // Passer à la prochaine paire de colonnes
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	

	
	**Place of residence
	
* Définir les variables et le fichier de sortie
putexcel set "NURSES&MIDWIVES.xlsx", sheet("POSTPROCEDURE") modify

* Définir les variables d'analyse
global var4 "DIU_post_correct INJECT_post_correct IMPLANTS_post_correct STERILFEM_post_correct STERILMAS_post_correct"
global places "Rural Urban"  // Liste des lieux

* Ajouter le titre du tableau à partir de la ligne 45
putexcel A45 = "Table 4: Post-procedure correct knowledge of family planning methods by place (Rural, Urban)"

* Ajouter les en-têtes des colonnes (places)
putexcel A46 = "Indicators"
local col = 2  // Colonne de départ pour les lieux (B)

foreach place in $places {
    * Calculer les lettres pour les colonnes des effectifs et des proportions
    local count_col_letter = ""
    if `col' <= 26 {
        local count_col_letter = char(64 + `col')
    }
    else {
        local count_col_letter = char(64 + int((`col' - 1) / 26)) + char(64 + mod((`col' - 1), 26) + 1)
    }
    putexcel `count_col_letter'46 = "`place' - Counts"

    local prop_col_letter = ""
    if (`col' + 1) <= 26 {
        local prop_col_letter = char(64 + (`col' + 1))
    }
    else {
        local prop_col_letter = char(64 + int((`col') / 26)) + char(64 + mod((`col'), 26) + 1)
    }
    putexcel `prop_col_letter'46 = "`place' - Proportions (%)"

    * Incrémenter de 2 pour passer aux colonnes suivantes
    local col = `col' + 2
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 47
local row = 47

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var4 {
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

            * Calculer les lettres des colonnes actuelles
            local count_col_letter = ""
            if `col' <= 26 {
                local count_col_letter = char(64 + `col')
            }
            else {
                local count_col_letter = char(64 + int((`col' - 1) / 26)) + char(64 + mod((`col' - 1), 26) + 1)
            }
            local prop_col_letter = ""
            if (`col' + 1) <= 26 {
                local prop_col_letter = char(64 + (`col' + 1))
            }
            else {
                local prop_col_letter = char(64 + int((`col') / 26)) + char(64 + mod((`col'), 26) + 1)
            }

            * Ajouter les effectifs dans la colonne des effectifs
            putexcel `count_col_letter'`row' = `count1'

            * Ajouter les proportions formatées dans la colonne des proportions
            putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        }

        restore
        local col = `col' + 2  // Passer à la prochaine paire de colonnes
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}


			***ATTITUDE FAVORABLE***

			
	****National
			
* Définir les variables et le fichier de sortie
putexcel set "NURSES&MIDWIVES.xlsx", sheet("ATTITUDE FAVORABLE") modify
global var5 "Favorable_PF Favorable_INJECTABLES Favorable_IMPLANTS Favorable_PILULE Favorable_CONTRACEPURG Favorable_PRESERVATFEM Favorable_STERILISFEM Favorable_STERILISMAS"

* Ajouter le titre du tableau
putexcel A1 = "Table 1: ATTITUDE FAVORABLE of family planning methods at the national level"

* Ajouter les en-têtes des colonnes
putexcel A2 = "Indicators" B2 = "Counts (Effectifs)" C2 = "Proportions (%)" D2 = "Total"

* Initialiser une ligne pour écrire les données
local row = 3

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var5 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Calculer les effectifs et proportions pour les deux modalités
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

        * Ajouter le label de l'indicateur dans la colonne "Indicators"
        putexcel A`row' = "`label'"

        * Ajouter les effectifs dans la colonne "Counts (Effectifs)"
        putexcel B`row' = `count1'

        * Ajouter les proportions dans la colonne "Proportions (%)"
        putexcel C`row' = "`proportion_formatted'"

        * Ajouter le total dans la colonne "Total"
        putexcel D`row' = total_effectifs

        * Passer à la ligne suivante
        local row = `row' + 1
    }
}

	
	****Région	
	
* Définir les variables et le fichier de sortie
putexcel set "NURSES&MIDWIVES.xlsx", sheet("ATTITUDE FAVORABLE") modify

* Définir les variables d'analyse
global var5 "Favorable_PF Favorable_INJECTABLES Favorable_IMPLANTS Favorable_PILULE Favorable_CONTRACEPURG Favorable_PRESERVATFEM Favorable_STERILISFEM Favorable_STERILISMAS"
global regions "DAKAR DIOURBEL FATICK KAFFRINE KAOLACK KEDOUGOU KOLDA LOUGA MATAM SAINTLOUIS SEDHIOU TAMBACOUNDA THIES ZIGUINCHOR"

* Ajouter le titre du tableau
putexcel A15 = "Table 2: ATTITUDE FAVORABLE of family planning methods by region"

* Ajouter les en-têtes des colonnes (régions)
putexcel A16 = "Indicators"
local col = 2  // Colonne de départ pour les régions (B)

foreach region in $regions {
    * Calculer la lettre pour les effectifs
    local count_col_letter = ""
    if `col' <= 26 {
        local count_col_letter = char(64 + `col')
    }
    else {
        local count_col_letter = char(64 + int((`col' - 1) / 26)) + char(64 + mod((`col' - 1), 26) + 1)
    }
    * Ajouter l'en-tête pour les effectifs
    putexcel `count_col_letter'16 = "`region' - Counts"

    * Calculer la lettre pour les proportions
    local prop_col_letter = ""
    if (`col' + 1) <= 26 {
        local prop_col_letter = char(64 + (`col' + 1))
    }
    else {
        local prop_col_letter = char(64 + int((`col') / 26)) + char(64 + mod((`col'), 26) + 1)
    }
    * Ajouter l'en-tête pour les proportions
    putexcel `prop_col_letter'16 = "`region' - Proportions"

    * Incrémenter de 2 pour passer aux colonnes suivantes
    local col = `col' + 2
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 17
local row = 17

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var5 {
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
        keep if region == "`region'"  // Assurez-vous que la variable REGION contient les noms des régions
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

            * Calculer les lettres des colonnes actuelles
            local count_col_letter = ""
            if `col' <= 26 {
                local count_col_letter = char(64 + `col')
            }
            else {
                local count_col_letter = char(64 + int((`col' - 1) / 26)) + char(64 + mod((`col' - 1), 26) + 1)
            }
            local prop_col_letter = ""
            if (`col' + 1) <= 26 {
                local prop_col_letter = char(64 + (`col' + 1))
            }
            else {
                local prop_col_letter = char(64 + int((`col') / 26)) + char(64 + mod((`col'), 26) + 1)
            }

            * Ajouter les effectifs dans la colonne des effectifs
            putexcel `count_col_letter'`row' = `count1'

            * Ajouter les proportions formatées dans la colonne des proportions
            putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        }

        restore
        local col = `col' + 2  // Passer à la prochaine paire de colonnes
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}
	
	
	
		****Structures
	

	
* Définir les variables et le fichier de sortie
putexcel set "NURSES&MIDWIVES.xlsx", sheet("ATTITUDE FAVORABLE") modify

* Définir les variables d'analyse
global var5 "Favorable_PF Favorable_INJECTABLES Favorable_IMPLANTS Favorable_PILULE Favorable_CONTRACEPURG Favorable_PRESERVATFEM Favorable_STERILISFEM Favorable_STERILISMAS"
global structures "Hospital HealthCenter HealthPost"  // Liste des structures de santé

* Ajouter le titre du tableau à partir de la ligne 30
putexcel A30 = "Table 3: ATTITUDE FAVORABLE of family planning methods by structure of health facilities"

* Ajouter les en-têtes des colonnes (structures)
putexcel A31 = "Indicators"
local col = 2  // Colonne de départ pour les structures (B)

foreach structure in $structures {
    * Calculer les lettres pour les colonnes des effectifs et des proportions
    local count_col_letter = ""
    if `col' <= 26 {
        local count_col_letter = char(64 + `col')
    }
    else {
        local count_col_letter = char(64 + int((`col' - 1) / 26)) + char(64 + mod((`col' - 1), 26) + 1)
    }
    putexcel `count_col_letter'31 = "`structure' - Counts"

    local prop_col_letter = ""
    if (`col' + 1) <= 26 {
        local prop_col_letter = char(64 + (`col' + 1))
    }
    else {
        local prop_col_letter = char(64 + int((`col') / 26)) + char(64 + mod((`col'), 26) + 1)
    }
    putexcel `prop_col_letter'31 = "`structure' - Proportions (%)"

    * Incrémenter de 2 pour passer aux colonnes suivantes
    local col = `col' + 2
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 32
local row = 32

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var5 {
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
        keep if Structure == "`structure'"  // Assurez-vous que la variable "Structure" contient les noms des structures
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

            * Calculer les lettres des colonnes actuelles
            local count_col_letter = ""
            if `col' <= 26 {
                local count_col_letter = char(64 + `col')
            }
            else {
                local count_col_letter = char(64 + int((`col' - 1) / 26)) + char(64 + mod((`col' - 1), 26) + 1)
            }
            local prop_col_letter = ""
            if (`col' + 1) <= 26 {
                local prop_col_letter = char(64 + (`col' + 1))
            }
            else {
                local prop_col_letter = char(64 + int((`col') / 26)) + char(64 + mod((`col'), 26) + 1)
            }

            * Ajouter les effectifs dans la colonne des effectifs
            putexcel `count_col_letter'`row' = `count1'

            * Ajouter les proportions formatées dans la colonne des proportions
            putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        }

        restore
        local col = `col' + 2  // Passer à la prochaine paire de colonnes
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	

	
	**Place of residence
	
* Définir les variables et le fichier de sortie
putexcel set "NURSES&MIDWIVES.xlsx", sheet("ATTITUDE FAVORABLE") modify

* Définir les variables d'analyse
global var5 "Favorable_PF Favorable_INJECTABLES Favorable_IMPLANTS Favorable_PILULE Favorable_CONTRACEPURG Favorable_PRESERVATFEM Favorable_STERILISFEM Favorable_STERILISMAS"
global places "Rural Urban"  // Liste des lieux

* Ajouter le titre du tableau à partir de la ligne 45
putexcel A45 = "Table 4: ATTITUDE FAVORABLE of family planning methods by place (Rural, Urban)"

* Ajouter les en-têtes des colonnes (places)
putexcel A46 = "Indicators"
local col = 2  // Colonne de départ pour les lieux (B)

foreach place in $places {
    * Calculer les lettres pour les colonnes des effectifs et des proportions
    local count_col_letter = ""
    if `col' <= 26 {
        local count_col_letter = char(64 + `col')
    }
    else {
        local count_col_letter = char(64 + int((`col' - 1) / 26)) + char(64 + mod((`col' - 1), 26) + 1)
    }
    putexcel `count_col_letter'46 = "`place' - Counts"

    local prop_col_letter = ""
    if (`col' + 1) <= 26 {
        local prop_col_letter = char(64 + (`col' + 1))
    }
    else {
        local prop_col_letter = char(64 + int((`col') / 26)) + char(64 + mod((`col'), 26) + 1)
    }
    putexcel `prop_col_letter'46 = "`place' - Proportions (%)"

    * Incrémenter de 2 pour passer aux colonnes suivantes
    local col = `col' + 2
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 47
local row = 47

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var5 {
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

            * Calculer les lettres des colonnes actuelles
            local count_col_letter = ""
            if `col' <= 26 {
                local count_col_letter = char(64 + `col')
            }
            else {
                local count_col_letter = char(64 + int((`col' - 1) / 26)) + char(64 + mod((`col' - 1), 26) + 1)
            }
            local prop_col_letter = ""
            if (`col' + 1) <= 26 {
                local prop_col_letter = char(64 + (`col' + 1))
            }
            else {
                local prop_col_letter = char(64 + int((`col') / 26)) + char(64 + mod((`col'), 26) + 1)
            }

            * Ajouter les effectifs dans la colonne des effectifs
            putexcel `count_col_letter'`row' = `count1'

            * Ajouter les proportions formatées dans la colonne des proportions
            putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        }

        restore
        local col = `col' + 2  // Passer à la prochaine paire de colonnes
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}
			
			


			***SMNI CONNAISSANCE CORRECTE***
			

			
	****National
			
* Définir les variables et le fichier de sortie
putexcel set "NURSES&MIDWIVES.xlsx", sheet("MNCH CORRECT KNOWLEDGE") modify
global var6 "Con_ANTENATAL Con_maternal Con_POSTNATAL"

* Ajouter le titre du tableau
putexcel A1 = "Table 1: Correct knowledge of MNCH at the national level"

* Ajouter les en-têtes des colonnes
putexcel A2 = "Indicators" B2 = "Counts (Effectifs)" C2 = "Proportions (%)" D2 = "Total"

* Initialiser une ligne pour écrire les données
local row = 3

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var6 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Calculer les effectifs et proportions pour les deux modalités
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

        * Ajouter le label de l'indicateur dans la colonne "Indicators"
        putexcel A`row' = "`label'"

        * Ajouter les effectifs dans la colonne "Counts (Effectifs)"
        putexcel B`row' = `count1'

        * Ajouter les proportions dans la colonne "Proportions (%)"
        putexcel C`row' = "`proportion_formatted'"

        * Ajouter le total dans la colonne "Total"
        putexcel D`row' = total_effectifs

        * Passer à la ligne suivante
        local row = `row' + 1
    }
}

	
	****Région	
	
* Définir les variables et le fichier de sortie
putexcel set "NURSES&MIDWIVES.xlsx", sheet("MNCH CORRECT KNOWLEDGE") modify

* Définir les variables d'analyse
global var6 "Con_ANTENATAL Con_maternal Con_POSTNATAL"
global regions "DAKAR DIOURBEL FATICK KAFFRINE KAOLACK KEDOUGOU KOLDA LOUGA MATAM SAINTLOUIS SEDHIOU TAMBACOUNDA THIES ZIGUINCHOR"

* Ajouter le titre du tableau
putexcel A15 = "Table 2: Correct knowledge of MNCH by region"

* Ajouter les en-têtes des colonnes (régions)
putexcel A16 = "Indicators"
local col = 2  // Colonne de départ pour les régions (B)

foreach region in $regions {
    * Calculer la lettre pour les effectifs
    local count_col_letter = ""
    if `col' <= 26 {
        local count_col_letter = char(64 + `col')
    }
    else {
        local count_col_letter = char(64 + int((`col' - 1) / 26)) + char(64 + mod((`col' - 1), 26) + 1)
    }
    * Ajouter l'en-tête pour les effectifs
    putexcel `count_col_letter'16 = "`region' - Counts"

    * Calculer la lettre pour les proportions
    local prop_col_letter = ""
    if (`col' + 1) <= 26 {
        local prop_col_letter = char(64 + (`col' + 1))
    }
    else {
        local prop_col_letter = char(64 + int((`col') / 26)) + char(64 + mod((`col'), 26) + 1)
    }
    * Ajouter l'en-tête pour les proportions
    putexcel `prop_col_letter'16 = "`region' - Proportions"

    * Incrémenter de 2 pour passer aux colonnes suivantes
    local col = `col' + 2
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 17
local row = 17

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var6 {
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
        keep if region == "`region'"  // Assurez-vous que la variable REGION contient les noms des régions
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

            * Calculer les lettres des colonnes actuelles
            local count_col_letter = ""
            if `col' <= 26 {
                local count_col_letter = char(64 + `col')
            }
            else {
                local count_col_letter = char(64 + int((`col' - 1) / 26)) + char(64 + mod((`col' - 1), 26) + 1)
            }
            local prop_col_letter = ""
            if (`col' + 1) <= 26 {
                local prop_col_letter = char(64 + (`col' + 1))
            }
            else {
                local prop_col_letter = char(64 + int((`col') / 26)) + char(64 + mod((`col'), 26) + 1)
            }

            * Ajouter les effectifs dans la colonne des effectifs
            putexcel `count_col_letter'`row' = `count1'

            * Ajouter les proportions formatées dans la colonne des proportions
            putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        }

        restore
        local col = `col' + 2  // Passer à la prochaine paire de colonnes
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}
	
	
	
		****Structures
	

	
* Définir les variables et le fichier de sortie
putexcel set "NURSES&MIDWIVES.xlsx", sheet("MNCH CORRECT KNOWLEDGE") modify

* Définir les variables d'analyse
global var6 "Con_ANTENATAL Con_maternal Con_POSTNATAL"
global structures "Hospital HealthCenter HealthPost"  // Liste des structures de santé

* Ajouter le titre du tableau à partir de la ligne 30
putexcel A30 = "Table 3: Correct knowledge of MNCH by structure of health facilities"

* Ajouter les en-têtes des colonnes (structures)
putexcel A31 = "Indicators"
local col = 2  // Colonne de départ pour les structures (B)

foreach structure in $structures {
    * Calculer les lettres pour les colonnes des effectifs et des proportions
    local count_col_letter = ""
    if `col' <= 26 {
        local count_col_letter = char(64 + `col')
    }
    else {
        local count_col_letter = char(64 + int((`col' - 1) / 26)) + char(64 + mod((`col' - 1), 26) + 1)
    }
    putexcel `count_col_letter'31 = "`structure' - Counts"

    local prop_col_letter = ""
    if (`col' + 1) <= 26 {
        local prop_col_letter = char(64 + (`col' + 1))
    }
    else {
        local prop_col_letter = char(64 + int((`col') / 26)) + char(64 + mod((`col'), 26) + 1)
    }
    putexcel `prop_col_letter'31 = "`structure' - Proportions (%)"

    * Incrémenter de 2 pour passer aux colonnes suivantes
    local col = `col' + 2
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 32
local row = 32

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var6 {
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
        keep if Structure == "`structure'"  // Assurez-vous que la variable "Structure" contient les noms des structures
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

            * Calculer les lettres des colonnes actuelles
            local count_col_letter = ""
            if `col' <= 26 {
                local count_col_letter = char(64 + `col')
            }
            else {
                local count_col_letter = char(64 + int((`col' - 1) / 26)) + char(64 + mod((`col' - 1), 26) + 1)
            }
            local prop_col_letter = ""
            if (`col' + 1) <= 26 {
                local prop_col_letter = char(64 + (`col' + 1))
            }
            else {
                local prop_col_letter = char(64 + int((`col') / 26)) + char(64 + mod((`col'), 26) + 1)
            }

            * Ajouter les effectifs dans la colonne des effectifs
            putexcel `count_col_letter'`row' = `count1'

            * Ajouter les proportions formatées dans la colonne des proportions
            putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        }

        restore
        local col = `col' + 2  // Passer à la prochaine paire de colonnes
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}	

	
	**Place of residence
	
* Définir les variables et le fichier de sortie
putexcel set "NURSES&MIDWIVES.xlsx", sheet("MNCH CORRECT KNOWLEDGE") modify

* Définir les variables d'analyse
global var6 "Con_ANTENATAL Con_maternal Con_POSTNATAL"
global places "Rural Urban"  // Liste des lieux

* Ajouter le titre du tableau à partir de la ligne 45
putexcel A45 = "Table 4: Correct knowledge of MNCH by place (Rural, Urban)"

* Ajouter les en-têtes des colonnes (places)
putexcel A46 = "Indicators"
local col = 2  // Colonne de départ pour les lieux (B)

foreach place in $places {
    * Calculer les lettres pour les colonnes des effectifs et des proportions
    local count_col_letter = ""
    if `col' <= 26 {
        local count_col_letter = char(64 + `col')
    }
    else {
        local count_col_letter = char(64 + int((`col' - 1) / 26)) + char(64 + mod((`col' - 1), 26) + 1)
    }
    putexcel `count_col_letter'46 = "`place' - Counts"

    local prop_col_letter = ""
    if (`col' + 1) <= 26 {
        local prop_col_letter = char(64 + (`col' + 1))
    }
    else {
        local prop_col_letter = char(64 + int((`col') / 26)) + char(64 + mod((`col'), 26) + 1)
    }
    putexcel `prop_col_letter'46 = "`place' - Proportions (%)"

    * Incrémenter de 2 pour passer aux colonnes suivantes
    local col = `col' + 2
}

* Initialiser la ligne pour écrire les données (indicateurs) à partir de la ligne 47
local row = 47

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var6 {
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

            * Calculer les lettres des colonnes actuelles
            local count_col_letter = ""
            if `col' <= 26 {
                local count_col_letter = char(64 + `col')
            }
            else {
                local count_col_letter = char(64 + int((`col' - 1) / 26)) + char(64 + mod((`col' - 1), 26) + 1)
            }
            local prop_col_letter = ""
            if (`col' + 1) <= 26 {
                local prop_col_letter = char(64 + (`col' + 1))
            }
            else {
                local prop_col_letter = char(64 + int((`col') / 26)) + char(64 + mod((`col'), 26) + 1)
            }

            * Ajouter les effectifs dans la colonne des effectifs
            putexcel `count_col_letter'`row' = `count1'

            * Ajouter les proportions formatées dans la colonne des proportions
            putexcel `prop_col_letter'`row' = "`proportion_formatted'"
        }

        restore
        local col = `col' + 2  // Passer à la prochaine paire de colonnes
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}
			


			***SMNI ATTITUDE FAVORABLE***
			
			
			
	****National
			
* Définir les variables et le fichier de sortie
putexcel set "NURSES&MIDWIVES.xlsx", sheet("MNCH FAVORABLE ATTITUDE") modify

* Indicateur unique
local var "Favorable_SMNI"  // Utilisation de `local` au lieu de `global`

* Vérifier si la variable existe dans le dataset
capture confirm variable `var'
if _rc != 0 {
    di as error "Error: Variable `var' not found in dataset."
    exit
}

* Ajouter le titre du tableau
putexcel A1 = "Table 1: MNCH favorable attitude at national level"

* Ajouter les en-têtes des colonnes
putexcel A2 = "Indicator" B2 = "Counts (Effectifs)" C2 = "Proportions (%)" D2 = "Total"

* Initialiser la ligne pour écrire les données
local row = 3

* Récupérer le label de la variable
local label : variable label `var'
if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

* Calculer les effectifs et proportions
tabulate `var', matcell(freq_var) matrow(rnames_var)

* Vérifier si des données existent pour la modalité "1"
if `=rowsof(freq_var)' > 1 {
    * Calculer le total des effectifs pour les proportions
    scalar total_effectifs = 0
    forval i = 1/`=rowsof(freq_var)' {
        scalar total_effectifs = total_effectifs + freq_var[`i', 1]
    }

    * Récupérer les données pour la modalité "1"
    local count1 = freq_var[2, 1]
    scalar proportion1 = (`count1' / total_effectifs) * 100

    * Formatage des proportions à 2 décimales
    local proportion_formatted : display %9.2f proportion1

    * Ajouter l'indicateur dans la colonne "Indicator"
    putexcel A`row' = "`label'"

    * Ajouter les effectifs dans la colonne "Counts (Effectifs)"
    putexcel B`row' = `count1'

    * Ajouter les proportions formatées dans la colonne "Proportions (%)"
    putexcel C`row' = "`proportion_formatted'"

    * Ajouter le total dans la colonne "Total"
    putexcel D`row' = total_effectifs
}
			
			
			***Region
			
			
* Définir les variables et le fichier de sortie
putexcel set "NURSES&MIDWIVES.xlsx", sheet("MNCH FAVORABLE ATTITUDE") modify

* Indicateur unique
local var "Favorable_SMNI"

* Définir les régions du Sénégal
global regions "DAKAR DIOURBEL FATICK KAFFRINE KAOLACK KEDOUGOU KOLDA LOUGA MATAM SAINTLOUIS SEDHIOU TAMBACOUNDA THIES ZIGUINCHOR"

* Vérifier si la variable existe dans le dataset
capture confirm variable `var'
if _rc != 0 {
    di as error "Error: Variable `var' not found in dataset."
    exit
}

* Ajouter le titre du tableau à partir de la ligne 10
putexcel A10 = "Table 2: MNCH favorable attitude by region"

* Ajouter les en-têtes des colonnes (régions)
putexcel A11 = "Region" B11 = "Counts (Effectifs)" C11 = "Proportions (%)" D11 = "Total"

* Initialiser la ligne pour écrire les données (démarrer à la ligne 12)
local row = 12

* Boucle sur chaque région
foreach region in $regions {
    * Affichage pour le débogage
    di "Processing region: `region'"

    * Filtrer les données pour la région actuelle
    preserve
    keep if region == "`region'"  // Assurez-vous que la variable REGION contient ces noms
    tabulate `var', matcell(freq_var) matrow(rnames_var)

    * Vérifier si des données existent pour la modalité "1"
    if `=rowsof(freq_var)' > 1 {
        * Calculer le total des effectifs pour les proportions
        scalar total_effectifs = 0
        forval i = 1/`=rowsof(freq_var)' {
            scalar total_effectifs = total_effectifs + freq_var[`i', 1]
        }

        * Vérifier si la modalité "1" existe
        if `=rowsof(freq_var)' >= 2 {
            local count1 = freq_var[2, 1]
            scalar proportion1 = (`count1' / total_effectifs) * 100
        }
        else {
            local count1 = 0
            scalar proportion1 = 0
        }

        * Formatage des proportions à 2 décimales
        local proportion_formatted : display %9.2f proportion1

        * Affichage pour le débogage
        di "Region: `region', Count (1): `count1', Proportion: `proportion_formatted'%"

        * Ajouter la région dans la colonne "Region"
        putexcel A`row' = "`region'"

        * Ajouter les effectifs dans la colonne "Counts (Effectifs)"
        putexcel B`row' = `count1'

        * Ajouter les proportions formatées dans la colonne "Proportions (%)"
        putexcel C`row' = "`proportion_formatted'"

        * Ajouter le total dans la colonne "Total"
        putexcel D`row' = total_effectifs

        * Passer à la ligne suivante
        local row = `row' + 1
    }
    else {
        di "No valid data for `var' in `region'"
    }

    restore
}
			
			
				***Structure
			
			
* Définir les variables et le fichier de sortie
putexcel set "NURSES&MIDWIVES.xlsx", sheet("MNCH FAVORABLE ATTITUDE") modify

* Indicateur unique
local var "Favorable_SMNI"

* Définir les structures de santé
global structures "Hospital HealthCenter HealthPost"  // Liste des structures

* Vérifier si la variable existe dans le dataset
capture confirm variable `var'
if _rc != 0 {
    di as error "Error: Variable `var' not found in dataset."
    exit
}

* Ajouter le titre du tableau à partir de la ligne 30
putexcel A30= "Table 3: MNCH favorable attitude by health facility type"

* Ajouter les en-têtes des colonnes (structures)
putexcel A31 = "Structure" B31 = "Counts (Effectifs)" C31 = "Proportions (%)" D31 = "Total"

* Initialiser la ligne pour écrire les données (démarrer à la ligne 27)
local row = 32

* Boucle sur chaque structure
foreach structure in $structures {
    * Affichage pour le débogage
    di "Processing structure: `structure'"

    * Filtrer les données pour la structure actuelle
    preserve
    keep if Structure == "`structure'"  // Assurez-vous que la variable "Structure" contient ces noms
    tabulate `var', matcell(freq_var) matrow(rnames_var)

    * Vérifier si des données existent pour la modalité "1"
    if `=rowsof(freq_var)' > 1 {
        * Calculer le total des effectifs pour les proportions
        scalar total_effectifs = 0
        forval i = 1/`=rowsof(freq_var)' {
            scalar total_effectifs = total_effectifs + freq_var[`i', 1]
        }

        * Vérifier si la modalité "1" existe
        if `=rowsof(freq_var)' >= 2 {
            local count1 = freq_var[2, 1]
            scalar proportion1 = (`count1' / total_effectifs) * 100
        }
        else {
            local count1 = 0
            scalar proportion1 = 0
        }

        * Formatage des proportions à 2 décimales
        local proportion_formatted : display %9.2f proportion1

        * Affichage pour le débogage
        di "Structure: `structure', Count (1): `count1', Proportion: `proportion_formatted'%" 

        * Ajouter la structure dans la colonne "Structure"
        putexcel A`row' = "`structure'"

        * Ajouter les effectifs dans la colonne "Counts (Effectifs)"
        putexcel B`row' = `count1'

        * Ajouter les proportions formatées dans la colonne "Proportions (%)"
        putexcel C`row' = "`proportion_formatted'"

        * Ajouter le total dans la colonne "Total"
        putexcel D`row' = total_effectifs

        * Passer à la ligne suivante
        local row = `row' + 1
    }
    else {
        di "No valid data for `var' in `structure'"
    }

    restore
}			
			
			
			**Place of residence
			
			
* Définir les variables et le fichier de sortie
putexcel set "NURSES&MIDWIVES.xlsx", sheet("MNCH FAVORABLE ATTITUDE") modify

* Indicateur unique
local var "Favorable_SMNI"

* Définir les lieux (Rural, Urban)
global places "Rural Urban"  // Liste des lieux

* Vérifier si la variable existe dans le dataset
capture confirm variable `var'
if _rc != 0 {
    di as error "Error: Variable `var' not found in dataset."
    exit
}

* Ajouter le titre du tableau à partir de la ligne 37
putexcel A37 = "Table 4: MNCH favorable attitude by place (Rural, Urban)"

* Ajouter les en-têtes des colonnes (Places)
putexcel A38 = "Place" B38 = "Counts (Effectifs)" C38 = "Proportions (%)" D38 = "Total"

* Initialiser la ligne pour écrire les données (démarrer à la ligne 39)
local row = 39

* Boucle sur chaque lieu
foreach place in $places {
    * Affichage pour le débogage
    di "Processing place: `place'"

    * Filtrer les données pour le lieu actuel
    preserve
    keep if Place == "`place'"  // Assurez-vous que la variable "Place" contient ces noms
    tabulate `var', matcell(freq_var) matrow(rnames_var)

    * Vérifier si des données existent pour la modalité "1"
    if `=rowsof(freq_var)' > 1 {
        * Calculer le total des effectifs pour les proportions
        scalar total_effectifs = 0
        forval i = 1/`=rowsof(freq_var)' {
            scalar total_effectifs = total_effectifs + freq_var[`i', 1]
        }

        * Vérifier si la modalité "1" existe
        if `=rowsof(freq_var)' >= 2 {
            local count1 = freq_var[2, 1]
            scalar proportion1 = (`count1' / total_effectifs) * 100
        }
        else {
            local count1 = 0
            scalar proportion1 = 0
        }

        * Formatage des proportions à 2 décimales
        local proportion_formatted : display %9.2f proportion1

        * Affichage pour le débogage
        di "Place: `place', Count (1): `count1', Proportion: `proportion_formatted'%" 

        * Ajouter le lieu dans la colonne "Place"
        putexcel A`row' = "`place'"

        * Ajouter les effectifs dans la colonne "Counts (Effectifs)"
        putexcel B`row' = `count1'

        * Ajouter les proportions formatées dans la colonne "Proportions (%)"
        putexcel C`row' = "`proportion_formatted'"

        * Ajouter le total dans la colonne "Total"
        putexcel D`row' = total_effectifs

        * Passer à la ligne suivante
        local row = `row' + 1
    }
    else {
        di "No valid data for `var' in `place'"
    }

    restore
}			
			
		
			