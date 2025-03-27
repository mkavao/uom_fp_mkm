clear all
clear matrix

* Paramétrage de l'affichage
set linesize 220
set maxvar 32000
set more off


cd "D:\APHRC\APHRC\Codes_FP_Dibor\Dibor's Part\Clients"

use clients_finaldata.dta




													  **************************** 
										              *       INDICATEUR 1       *
													  ****************************
													  
													  
/*
INDICATOR 1: % of exit interview respondents who received the service/s for which they came to the facility												   
								  
       Numérateur : Nombre total de clients étant venu à la structure pour adopter une méthode et dont le résulat de la visite est "adoption d'une méthode" + Nombre de clients étant venu à la structure pour changer de méthode et dont le résultat de la visite est "changement de méthode"+ Nombre de clients étant venu à la structure pour mettre fin à la PF et dont le résultat de la visite est "cesser d'utiliser la méthode" + Nombre de clients étant venu à la structure pour trouver des solutions aux effets secondaires de leur méthode et dont le  prestataire les a parlé de ce qu'elles doivent faire quand elles noteront des effets secondaires ou des problèmes par rapport à la méthode qu'elles ont choisies + Nombre de clients étant venu pour obtenir des infos sur les méthodes de PF et dont le prestataire les a fourni des informations sur différentes méthodes de planification familiale
	   Dénominateur: Nombre total de clients ayant reçu un service de PF 											 											  
*/																  
		

* Créer une variable indiquant si le client a reçu le service pour lequel il s'est rendu à la structure

gen recu_oui=0

replace recu_oui=1 if (c4_18==1 & c4_35==5) | (c4_18==2 & c4_35==2) | (c4_18==3 & inlist(c4_35, 3 ,4)) | (c4_18==4 & c4_46==1) | (c4_18==5 & c4_42==1) 

count if (c4_18==1 & c4_35==5) 
count if (c4_18==2 & c4_35==2)
count if (c4_18==3 & inlist(c4_35, 3 ,4))
count if (c4_18==4 & c4_46==1)
count if (c4_18==5 & c4_42==1) 

* Définir les types de structure en utilisant les valeurs numériques

gen recu_eps = recu_oui if inlist(nom_structure, 7,22,39,52,53,54,64,78,79,100,101,131,204,255,256,257,319,446,560,659,709,893,908,990,991,1038,1108,1149,1174,1238,1389,1449,1553,1588,1706,1707)
 
gen recu_cs  = recu_oui if missing(recu_eps) & !missing(nom_structure)


* Compter le nombre d'observations où recu_oui == 1
count if recu_oui == 1
local recu_yes = r(N)

* Compter le nombre d'observations où s200b_1 == 1
count if s200b_1 == 1
local total_obs = r(N)

* Calculer le pourcentage
local indicator1 = (`recu_yes' / `total_obs') * 100

* Afficher le résultat
di "The % of exit interview respondents who received the service/s for which they came to the facility is : " %9.2f `indicator1' "%"
		
													  

* Définir les variables et le fichier de sortie
putexcel set "Indicators.xlsx", sheet("Clients_receive") modify
global var1 "recu_eps recu_cs recu_oui"

* Ajouter le titre du tableau
putexcel A1 = "Table 4.4.1.1 % of exit interview respondents who received the FP service methods for which they came to the facility, by HF level"

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




count if c4_56== 1
count if c4_56==1 & inlist(nom_structure, 7,22,39,52,53,54,64,78,79,100,101,131,204,255,256,257,319,446,560,659,709,893,908,990,991,1038,1108,1149,1174,1238,1389,1449,1553,1588,1706,1707)
count if c4_56==1 & missing(recu_eps) & !missing(nom_structure)  																							  
												  
												  
																							  
												  
                                                      **************************** 
										              *       INDICATEUR 2    *
													  ****************************


/* Indicator 2:  % of exit interview respondents who had positive feedback about the quality of care they received at the facility								  
		Numérateur: Nombre total de clients ayant dit aujourd'hui qu'ils sont entièrement satisfait des services de services de planning familial fournis 
		Dénominateur: Nombre total de clients ayant reçu un service de PF							 									  
*/


* Création d'une variable prenant la valeur 1 si le client dit avoir été bien traité par le prestataire

gen pos_feedback=0
replace pos_feedback=1 if c4_71==1

gen pos_eps=pos_feedback if inlist(nom_structure, 7,22,39,52,53,54,64,78,79,100,101,131,204,255,256,257,319,446,560,659,709,893,908,990,991,1038,1108,1149,1174,1238,1389,1449,1553,1588,1706,1707)
gen pos_cs=pos_feedback if missing(recu_eps) & !missing(nom_structure)

* Compter le nombre d'observations où pos_feedback == 1
count if pos_feedback == 1
local positive_feedback = r(N)

* Compter le nombre d'observations où s200b_1 == 1
count if s200b_1 == 1
local total_obs = r(N)

* Calculer le pourcentage
local indicator2 = (`positive_feedback' / `total_obs') * 100

* Afficher le résultat
di "The % of exit interview respondents who had positive feedback about the quality of care they received at the facility is : " %9.2f `indicator2' "%"


* Définir les variables et le fichier de sortie
putexcel set "Indicators.xlsx", sheet("Clients_feedback") modify
global var2 "pos_eps pos_cs pos_feedback "

* Ajouter le titre du tableau
putexcel A1 = "% of exit interview respondents who had positive feedback about the quality of care they received at the facility"

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


/* Indicator 3:  % of exit interview respondents who experience problems in accessing the care at the facility								  
		Numérateur: Nombre total de clients ayant eu de problèmes sur: le temps d'attente pour consulter un prestataire dans cette structure, sur les heures d'ouverture et de fermeture de le structure, sur le nombre de jours pendant lesquels les services sont disponibles, sur les coûts des services.
		
		Dénominateur: Nombre total de clients ayant reçu un service de PF							 									  
*/


* Création d'une variable binaire indiquant si le client n'a pas eu  problème d'accès aux soins dans la structure

gen acces_soins=0
replace acces_soins=1 if (c4_75==3 & c4_76==3 & c4_77==3 & c4_78==3)

* Compter le nombre d'observations où acces_soins == 1
count if acces_soins == 1
local no_problem = r(N)

* Compter le nombre d'observations où s200b_1 == 1
count if s200b_1 == 1
local total_obs = r(N)

* Calculer le pourcentage
local indicator3 = (`no_problem' / `total_obs') * 100

* Afficher le résultat
di "The % of exit interview respondents who did not experience problems in accessing the care at the facility is : " %9.2f `indicator3' "%"													  
													  

													  
													  
********************************
gen pb_acces = (inlist(c4_75, 1,2) | inlist(c4_76, 1,2) | inlist(c4_77, 1,2) | inlist(c4_78, 1,2))

gen acces_attente = pb_acces if pb_acces == 1 & inlist(c4_75, 1, 2)
gen acces_hours   = pb_acces if pb_acces == 1 & inlist(c4_76, 1, 2)
gen acces_jours   = pb_acces if pb_acces == 1 & inlist(c4_77, 1, 2)
gen acces_cout    = pb_acces if pb_acces == 1 & inlist(c4_78, 1, 2)


					  
												  
* Définir les variables et le fichier de sortie
putexcel set "Indicators.xlsx", sheet("access_feedb") modify
global var3 "pb_acces acces_attente acces_hours acces_jours acces_cout "

* Ajouter le titre du tableau
putexcel A1 = "Table 4.4.2. % of exit interview respondents who experience problems in accessing the care at the facility"

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




gen pb_acces = (inlist(c4_75, 1,2) | inlist(c4_76, 1,2) | inlist(c4_77, 1,2) | inlist(c4_78, 1,2))

gen acces_attente = (pb_acces == 1 & inlist(c4_75, 1, 2))
gen acces_hours   = (pb_acces == 1 & inlist(c4_76, 1, 2))
gen acces_jours   = (pb_acces == 1 & inlist(c4_77, 1, 2))
gen acces_cout    = (pb_acces == 1 & inlist(c4_78, 1, 2))

* Définir les variables et le fichier de sortie
putexcel set "Indicators.xlsx", sheet("access_feedb") modify
global var3 "pb_acces acces_attente acces_hours acces_jours acces_cout"

* Ajouter le titre du tableau
putexcel A1 = "Table 4.4.2. % of exit interview respondents who experience problems in accessing the care at the facility"

* Ajouter les en-têtes des colonnes
putexcel A2 = "Indicators" B2 = "Effectifs" C2 = "Proportions (%)" D2 = "Total"

* Initialiser une ligne pour écrire les données
local row = 3

* Calcul du total des personnes ayant pb_acces == 1
count if pb_acces == 1
local total_pb_acces = r(N)  // Stocke le total des personnes concernées (443)

* Boucle sur les variables pour créer des lignes par indicateur
foreach var in $var3 {
    * Récupérer le label de la variable
    local label : variable label `var'
    if "`label'" == "" local label = "`var'"  // Utiliser le nom de la variable si aucun label n'existe

    * Calculer les effectifs pour la modalité "1"
    count if `var' == 1
    local count1 = r(N)

    * Calculer la proportion en fonction du total de pb_acces
    local proportion1 = (`count1' / `total_pb_acces') * 100

    * Formatage des proportions à 2 décimales
    local proportion_formatted : display %9.2f `proportion1'

    * Ajouter le label de l'indicateur dans la colonne "Indicators"
    putexcel A`row' = "`label'"

    * Ajouter les effectifs dans la colonne "Effectifs"
    putexcel B`row' = `count1'

    * Ajouter les proportions dans la colonne "Proportions (%)"
    putexcel C`row' = "`proportion_formatted'"

    * Ajouter le total (443 pour tout sauf pb_acces)
    if "`var'" == "pb_acces" {
        putexcel D`row' = 790
    }
    else {
        putexcel D`row' = `total_pb_acces'
    }

    * Passer à la ligne suivante
    local row = `row' + 1
}
