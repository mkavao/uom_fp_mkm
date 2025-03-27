**************************************************************** PRELIMINAIRES ****************************************************************************
                                                                ***************
* Nettoyage et préparation de l'environnement de travail
clear all
clear matrix

* Paramétrage de l'affichage
set linesize 220
set maxvar 32000
set more off

* Importation de la base
cd "D:\APHRC\APHRC\Codes_FP_Dibor\Dibor's Part\CHW"


use CHW_clean.dta








                                                      **************************** 
										              *       INDICATEUR 1       *
													  ****************************
													  
/*
INDICATOR 1:  % of CHWs who are trained as per the national guidelines					   
								  
       Numérateur : Nombre d'ASC ayant suivi des modules de formation comme recommandé par les directives nationales 
	   Dénominateur: Nombre total d'ASC							 										  
*/	



gen not_trained = (a5_01==4)
gen trained_guid = (a5_04b>=a5_04a) if not_trained==0
gen not_trained_guid= (a5_04b<a5_04a) if not_trained==0



* Définir les variables et le fichier de sortie
putexcel set "Indicators.xlsx", sheet("Trained_CHW") modify
global var1 "not_trained trained_guid not_trained_guid "

* Ajouter le titre du tableau
putexcel A1 = "Table 4.2.1.1. % of CHWs who are trained in FP as per the national guidelines"

* Ajouter les en-têtes des colonnes
putexcel A2 = "Indicators" B2 = "Effectifs" C2 = "Proportions (%)" D2 = "Total"

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




/*
INDICATOR 2: % of CHWs with correct knowledge of each FP method										   
								  
       Numérateur : Nombre total d'ASC avec une connaissance correcte des méthodes de PF
	   Dénominateur: Nombre total d'ASC							 											  
*/		


* Créer des variables binaires pour chaque bonne réponse en fonction des conditions spécifiées	

*------ DIU

gen score_Q611 = Q611_A + Q611_B + Q611_C + Q611_D + Q611_E + Q611_F + Q611_G + Q611_H + Q611_I + Q611_J + Q611_K  // Avantages les avantages d'utiliser un DIU (11)

gen score_Q612 = Q612_A + Q612_B + Q612_C + Q612_D + Q612_E + Q612_F + Q612_G + Q612_H + Q612_I  // Sait les problèmes avec l'utilisation du DIU (9)

gen score_Q613 = Q613_A + Q613_B + Q613_C + Q613_D + Q613_E + Q613_F + Q613_G + Q613_H + Q613_I + Q613_J  // Sait les états de santé où on ne doit pas utiliser DIU (10)

gen score_Q618 = Q618_B + Q618_C + Q618_D  // Seuls les Gynéco, SF et infirmières formées peuvent insérer un DIU ()

gen score_Q619 = Q619_A + Q619_B + Q619_C  

gen score_DIU= score_Q611 + score_Q612 + score_Q613 + Q616 + Q617 + score_Q618 + score_Q619

gen score_80DIU = (score_DIU>=)

*---------- Pills

gen score_Q621 = Q621_A + Q621_B + Q621_C + Q621_D + Q621_E + Q621_F + Q621_G + Q621_H + Q621_I + Q621_J + Q621_K // Sait les problèmes avec la prise de pilules

gen score_Q622 = Q622_A + Q622_B + Q622_C + Q622_D + Q622_E // Sait les situations où la pilule peut être dangereuse

gen score_pills = Q620 + score_Q621 + score_Q622 + Q623 + Q624_B

*--------- Condoms


gen score_Q625 = (Q625 == 1)   // Les préservatifs doivent être utilisés à chaque rapport sexuel

gen score_Q626 = (Q626 == 3)   // Le nombre de fois qu'on peut utiliser un préservatif lors d'un rapport

gen score_Q627 = Q627_A + Q627_B + Q627_C + Q627_D + Q627_E + Q627_F // Sait les avantages d'utiliser un préservatif

gen score_Q628 =  Q628_A + Q628_B + Q628_C + Q628_D + Q628_E // Sait les problème liés à l'utilisation d'un préservatif

gen score_condom = score_Q625 + score_Q626 + score_Q627 + score_Q628

*---------- Injectables
gen score_Q632 = (!inlist(Q632,98 , 99)) // Sait les  moments pour la première dose d'injectable

gen score_Q633 = Q633_A + Q633_B + Q633_C + Q633_D + Q633_E + Q633_F + Q633_G + Q633_H + Q633_I + Q633_J + Q633_K + Q633_L + Q633_M // Sait les avantages de l'injectable

gen score_Q634 = Q634_A + Q634_B + Q634_C + Q634_D + Q634_E + Q634_F + Q634_G + Q634_H // Sait les problèmes après un injectable

gen score_inj = score_Q632 + score_Q633 + score_Q634


*------------ Implants
gen score_Q639 = Q639_A + Q639_B + Q639_C + Q639_D  + Q639_E + Q639_F  // Sait les avantages d'utiliser un implant

gen score_Q640 = Q640_A + Q640_B + Q640_C + Q640_D + Q640_E + Q640_F + Q640_G + Q640_H  // Sait les problèmes avec un implant
gen score_Q641 = (Q641 == 1)   // Durée d'efficacité de l'implant (3-5 ans)
gen score_Q642 = (Q642 == 1)   // L'implant doit être inséré dans le bras supérieur

gen score_Q643 = Q643_B + Q643_C + Q643_D  // L'implant doit être posé par un gynéco, SF ou infirmière formée

gen score_impl = score_Q639 + score_Q640 + score_Q641 + score_Q642 + score_Q643



*----------- CU
gen score_Q647 = (Q647 == 1)   // La contraception d'urgence peut être prise après un rapport non protégé
gen score_Q648 = (Q648 == 72)  // Nombre d'heures maximales pour la contraception d'urgence (72h)
gen score_Q650 = (Q650 == 2)  // La CU n'est pas efficace si la femme est déjà enceinte

gen score_CU = score_Q647 + score_Q648 + score_Q650

*------------- Sterilisation fem
gen score_Q654 = Q654_A + Q654_B + Q654_C + Q654_D + Q654_E  // Sait les bénéfices de la stérilisation féminine

gen score_Q655 = Q655_A + Q655_B + Q655_C + Q655_D + Q655_E + Q655_F + Q655_G + Q655_H + Q655_I + Q655_J + Q655_K // Sait les problèmes liés à la stérilisation féminine

gen score_stefem = score_Q654 + score_Q655

*------------- Sterilisation masc
gen score_Q657 = Q657_A + Q657_B + Q657_C + Q657_D + Q657_E  // Sait les bénéfices de la stérilisation masculine

gen score_Q658 =  Q658_A + Q658_B + Q658_C + Q658_D + Q658_E  + Q658_F + Q658_G // Sait les problèmes lié à la stérilisation masculine

gen score_Q660 = Q660_A + Q660_B + Q660_C + Q660_D + Q660_E + Q660_F + Q660_G + Q660_H + Q660_I + Q660_J + Q660_K + Q660_L // Sait au moins un avantage des méthodes contraceptives

gen score_stemasc = score_Q657 + score_Q658 + score_Q660

* Définir les variables et le fichier de sortie
putexcel set "Indicators.xlsx", sheet("Conn_FP") modify
global var2 "score_DIU score_pills score_condom score_inj score_impl score_CU score_stefem score_stemasc  "

* Ajouter le titre du tableau
putexcel A1 = "Table 4.2.1.2. % of CHWs with correct knowledge of each FP methods"

* Ajouter les en-têtes des colonnes
putexcel A2 = "Indicators" B2 = "Effectifs" C2 = "Proportions (%)" D2 = "Total"

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





**************************** 
										              *       INDICATEUR 3       *
													  ****************************
													  
/*
INDICATOR 3:  % of CHWs with favorable attitude towards FP in general							   
								  
       Numérateur : Nombre total d'ASC ayant une attitude favorable à l'égard de la PF en général 
	   Dénominateur: Nombre total d'ASC							 											  
*/	



* Créer les variables binaires pour chaque attitude favorable
gen attitude_favorable_qa = inlist(a6_61, 4, 5)
gen attitude_favorable_qb = inlist(a6_62, 1, 2)
gen attitude_favorable_qc = inlist(a6_63, 4, 5)
gen attitude_favorable_qd = inlist(a6_64, 4, 5)
gen attitude_favorable_qe = inlist(a6_65, 1, 2)
gen attitude_favorable_qf = inlist(a6_66, 1, 2)
gen attitude_favorable_qg = inlist(a6_67, 1, 2)
gen attitude_favorable_qh = inlist(a6_68, 1, 2)
gen attitude_favorable_qi = inlist(a6_69, 4, 5)	


* Calculer le score global de l'attitude favorable
gen score_attitude_favorablepf = attitude_favorable_qa + attitude_favorable_qb + attitude_favorable_qc + attitude_favorable_qd + attitude_favorable_qe + attitude_favorable_qf + attitude_favorable_qg + attitude_favorable_qh + attitude_favorable_qi

* Créer des variables pour 80% et 100% de bonnes attitudes
local total_attitude_favorable = 9  // Nombre total de questions utilisées
gen favorable_attitude_80 = (score_attitude_favorablepf >= 0.80 * `total_attitude_favorable')
gen favorable_attitude_100 = (score_attitude_favorablepf == `total_attitude_favorable')

* Compter le nombre de répondants ayant atteint 80%, et 100% de bonne attitude
* Calculer le nombre de répondants ayant atteint les seuils

* Compter le nombre d'observations pour chaque condition (bonne connaissance)
count if favorable_attitude_80 == 1
local nb_ind2_80 = r(N)

count if favorable_attitude_100 == 1
local nb_ind2_100 = r(N)

* Calculer le nombre total d'observations
local total_asc = _N


* Calculer les pourcentages pour 50%, 75%, 80%, et 100% de bonne connaissance

local indicator2_80 = (`nb_ind2_80' / `total_asc') * 100
local indicator2_100 = (`nb_ind2_100' / `total_asc') * 100

* Afficher les résultats avec deux décimales
di "The % of CHWs with 80% favorable attitude towards FP in general is : " %9.2f `indicator2_80' "%"
di "The % of CHWs with 100% favorable attitude towards FP in general is : " %9.2f `indicator2_100' "%"	

* Définir les variables et le fichier de sortie
putexcel set "Indicators.xlsx", sheet("Attitude_CHW") modify
global var3 " favorable_attitude_80 favorable_attitude_100"

* Ajouter le titre du tableau
putexcel A1 = "Table 4.2.1.1. % of CHWs who have favorable attitude towards FP in general"

* Ajouter les en-têtes des colonnes
putexcel A2 = "Indicators" B2 = "Effectifs" C2 = "Proportions (%)" D2 = "Total"

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



* Dispo matériel/utilisation

gen dispo_materiel=a4_07
replace dispo_materiel=0 if dispo_materiel==2
gen use_materiel=1 if a4_08==1 & a4_07==1
replace use_materiel=0 if use_materiel==. & a4_07==1
* Définir les variables et le fichier de sortie
putexcel set "Indicators.xlsx", sheet("materiel_CHW") modify
global var4 "dispo_materiel use_materiel"

* Ajouter le titre du tableau
putexcel A1 = "Table 4.2.1.1. % of CHWs who use materiel available in their daily work"

* Ajouter les en-têtes des colonnes
putexcel A2 = "Indicators" B2 = "Effectifs" C2 = "Proportions (%)" D2 = "Total"

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


** Accessibilité structurev santé
gen tres_acces=a3_14==1
gen qfois_acces=a3_14==2
gen pastres_acces=a3_14==3
gen pas_acces=a3_14==4

* Définir les variables et le fichier de sortie
putexcel set "Indicators.xlsx", sheet("accessibility_CHW") modify
global var5 "tres_acces qfois_acces pastres_acces pas_acces"

* Ajouter le titre du tableau
putexcel A1 = " Accessibility to health facilities"

* Ajouter les en-têtes des colonnes
putexcel A2 = "Indicators" B2 = "Effectifs" C2 = "Proportions (%)" D2 = "Total"

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


* Distance qui separe le centre de santé le plus proche et la zone de polarisation

gen distance_pol1=(a3_13<=5) // entre 0 et 5 km
gen distance_pol2=(a3_13>5 & a3_13<=10)
gen distance_pol3=(a3_13>10 & a3_13<=25)
gen distance_pol4=(a3_13>25 & a3_13<=50)
gen distance_pol5=(a3_13>50)



* Définir les variables et le fichier de sortie
putexcel set "Indicators.xlsx", sheet("distance_CHW") modify
global var6 "distance_pol1 distance_pol2 distance_pol3 distance_pol4 distance_pol5"

* Ajouter le titre du tableau
putexcel A1 = " Accessibility to health facilities"

* Ajouter les en-têtes des colonnes
putexcel A2 = "Indicators" B2 = "Effectifs" C2 = "Proportions (%)" D2 = "Total"

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





* Connaissance_attitudes

*--- Saignements DIU
 
ta a6_16 
ta a6_23 
ta a6_32  
ta a6_42 
ta a6_48
ta a6_62 
ta a6_63 
ta a6_65 
ta a6_66 
ta a6_67 
ta a6_69 
ta a6_49 
ta a6_56 
ta a6_59


