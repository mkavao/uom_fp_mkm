
*Traitement des données Médecin et Gynécologue


* initialize Stata

clear all
clear matrix
set linesize 220
set maxvar 32767
set more off


* Définir le répertoire de travail

cd "C:\Users\rndachi\Dropbox\FP-Project-APHRC-UM\Atelier_FP\Data\raw"

* Charger les données brutes
use "doctor_raw_data", clear

****************************************************************

*Supprimer les doublons
bysort I1 I2 I3 I3b I4 equipe s1_8 s1_9 S2_1 S2_2 S2_3 : gen dup_tag = cond(_n == 1, 0, 1)

tab dup_tag

drop if dup_tag == 1

*Supprimer les variables inutiles
drop SubmissionDate start today deviceid obs end instanceID formdef_version KEY





************************************** SECTION 1
                                      ***********
					
rename s1_7 p1_7
rename s1_8 p1_8
rename s1_9 p1_9


************************************** SECTION 2
                                      ***********

rename S2_1 p2_1                                  
rename S2_2 p2_2                                  
rename S2_3 p2_3                                  

****************************************************************

*Le temps passé au poste se trouve supérieur au temps passé dans la structure pour certains individus. Ramener le temps passé au poste au niveau du temps passé dans la structure pour tous ces individus.
compare S2_5_1 S2_4_1
replace S2_4_1 = S2_5_1 if S2_4_1 > S2_5_1 & S2_4==1 & S2_5==1
compare S2_5_2 S2_4_2
replace S2_4_2 = S2_5_2 if S2_4_2 > S2_5_2 & S2_4==2 & S2_5==2

replace S2_4_1 = -9 if S2_4==2
replace S2_4_1 = -5 if S2_4==3

replace S2_4_2 = -9 if S2_4==1
replace S2_4_2 = -5 if S2_4==3

rename S2_4   p2_4
rename S2_4_1 p2_4a
rename S2_4_2 p2_4b
rename S2_5   p2_5
rename S2_5_1 p2_5a
rename S2_5_2 p2_5b

rename S2_5a  p2_5aut 
rename S2_6   p2_6
rename S2_6_1 p2_6a

*Le temps depuis lequel le prestataire fourni les services de SMNI dans la structure se trouve supérieur au temps depuis lequel il fourni ces services pour certains individus. Ramener le temps depuis lequel les services SMNI sont fourni au niveau du temps qu'il le fait au niveau de la structure
compare S2_8_1 S2_10_1
replace S2_8_1 = S2_10_1 if S2_8_1 < S2_10_1 & S2_8==1 & S2_10==1
compare S2_8_2 S2_10_2
replace S2_8_2 = S2_10_2 if S2_8_2 < S2_10_2 & S2_8==2 & S2_10==2

replace  S2_8=-9 if  S2_7==2
replace S2_8_1 = -9 if S2_8==2 | S2_8==-9
replace S2_8_2 = -9 if S2_8==1 | S2_8==-9

replace  S2_9=-9 if  S2_7==2
replace  S2_10=-9 if  S2_9==2 | S2_9==-9
replace S2_10_1 = -9 if S2_10==2 | S2_10==-9
replace S2_10_2 = -9 if S2_10==1 | S2_10==-9

rename S2_7    p2_7
rename S2_8    p2_8
rename S2_8_1  p2_8a
rename S2_8_2  p2_8b
rename S2_9    p2_9
rename S2_10   p2_10
rename S2_10_1 p2_10a
rename S2_10_2 p2_10b

***************************************************************************

replace S2_14_1  = 4 if S2_14_1a  == "Ce sont les sages femmes qui s'en occupe"
replace S2_14_1  = 4 if S2_14_1a  == "Ce sont les SFE qui le font"
replace S2_14_1  = 4 if S2_14_1a  == "C'est le domaine de la sage femme"
replace S2_14_1  = 4 if S2_14_1a  == "C'est le rôle des sages femmes"
replace S2_14_1  = 4 if S2_14_1a  == "C'est pour les sages femmes"
replace S2_14_1  = 4 if S2_14_1a  == "Elle est en médecine"
replace S2_14_1  = 4 if S2_14_1a  == "Je suis pédiatre"
replace S2_14_1  = 4 if S2_14_1a  == "Le service est geré par les Sage femme"
replace S2_14_1  = 4 if S2_14_1a  == "Le service réservé à la maternité"
replace S2_14_1  = 4 if S2_14_1a  == "N'est pas affecté à la maternité"
replace S2_14_1  = 4 if S2_14_1a  == "On a un gynecologue"
replace S2_14_1  = 5 if S2_14_1a  == "Pas de formation"

label define S2_14_1 0 "Service non disponible" 4 "Ne travaille pas dans ce service" 5 "Non formé pour ce service", add

recode S2_14_1 (6 = 0)

replace S2_14_1a = "" if S2_14_1 != 6

drop S2_14_1a
drop S2_15_1
label var S2_15_1_1 "Formation en cours d'emploi"
label var S2_15_1_2 "Formation de remise à niveau"
label var S2_15_1_3 "Mentorat"
label var S2_15_1_4 "Aucune"

foreach var of varlist S2_15_1_1 S2_15_1_2 S2_15_1_3 S2_15_1_4 {
    label define `var' 0 "Non" 1 "Oui", modify
    label values `var' `var'
}

replace S2_12_1=-9 if p2_9==-9 | p2_9==2
replace S2_13_1=-9 if S2_12_1==-9 | S2_12_1==2
replace S2_14_1=-9 if S2_14_1==.



replace S2_15_1_1=-9 if p2_9==-9 | p2_9==2
replace S2_15_1_2=-9 if p2_9==-9 | p2_9==2
replace S2_15_1_3=-9 if p2_9==-9 | p2_9==2
replace S2_15_1_4=-9 if p2_9==-9 | p2_9==2

replace S2_16_1=-9 if S2_15_1_4==1 | S2_15_1_4==.

rename S2_12_1  p2_12a
rename S2_13_1  p2_13a
rename S2_14_1  p2_14a
rename S2_15_1_1 p2_15aa
rename S2_15_1_2 p2_15ab
rename S2_15_1_3 p2_15ac
rename S2_15_1_4 p2_15ad
rename S2_16_1  p2_16a






**********************************************************************

replace S2_14_2  = 4 if S2_14_2a  == "C'est le domaine de la sage femme"
replace S2_14_2  = 4 if S2_14_2a  == "C'est le rôle des sages femmes"
replace S2_14_2  = 4 if S2_14_2a  == "C'est pas dans mes domaines"
replace S2_14_2  = 4 if S2_14_2a  == "C'est pour les sages femmes"
replace S2_14_2  = 4 if S2_14_2a  == "Gynécologue"
replace S2_14_2  = 4 if S2_14_2a  == "Je n'intervient pas à la maternité. Il y a un autre médecin compétent SOU qui s'en charge"
replace S2_14_2  = 4 if S2_14_2a  == "Je suis pédiatre"
replace S2_14_2  = 4 if S2_14_2a  == "Parceque il y'a des sages-femmes"
replace S2_14_2  = 5 if S2_14_2a  == "Pas de formation"
replace S2_14_2  = 4 if S2_14_2a  == "Pas mon domaine"
replace S2_14_2  = 4 if S2_14_2a  == "Pédiatrie"
replace S2_14_2  = 4 if S2_14_2a  == "Pédiatrie"
replace S2_14_2  = 4 if S2_14_2a  == "Personnel disponible"
replace S2_14_2  = 4 if S2_14_2a  == "Personnel qualifié"
replace S2_14_2  = 4 if S2_14_2a  == "Préfère referer"
replace S2_14_2  = 4 if S2_14_2a  == "Réservé à la maternité"
replace S2_14_2  = 4 if S2_14_2a  == "Servi plus dans la consultation générale"
replace S2_14_2  = 4 if S2_14_2a  == "Service médecine"
replace S2_14_2  = 4 if S2_14_2a  == "SFE"
replace S2_14_2  = 4 if S2_14_2a  == "Specialiste à coté"

label define S2_14_2 0 "Service non disponible" 4 "Ne travaille pas dans ce service" 5 "Non formé pour ce service", add

replace S2_14_2a = "" if S2_14_2 != 6

recode S2_14_2 (6 = 0)

drop S2_14_2a
drop S2_15_2
label var S2_15_2_1 "Formation en cours d'emploi"
label var S2_15_2_2 "Formation de remise à niveau"
label var S2_15_2_3 "Mentorat"
label var S2_15_2_4 "Aucune"

replace S2_12_2=-9 if p2_9==-9 | p2_9==2
replace S2_13_2=-9 if S2_12_2==-9 | S2_12_2==2
replace S2_14_2=-9 if S2_14_2==.


replace S2_15_2_1=-9 if p2_9==-9 | p2_9==2
replace S2_15_2_2=-9 if p2_9==-9 | p2_9==2
replace S2_15_2_3=-9 if p2_9==-9 | p2_9==2
replace S2_15_2_4=-9 if p2_9==-9 | p2_9==2

foreach var of var S2_15_2_1 S2_15_2_2 S2_15_2_3 S2_15_2_4 {
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
}

replace S2_16_2=-9 if S2_15_2_4==1 | S2_15_2_4==.

rename S2_12_2	 p2_12b
rename S2_13_2 	 p2_13b
rename S2_14_2 	 p2_14b
rename S2_15_2_1 p2_15ba
rename S2_15_2_2 p2_15bb
rename S2_15_2_3 p2_15bc
rename S2_15_2_4 p2_15bd
rename S2_16_2	 p2_16b

*****************************************************************

replace S2_14_3  = 4 if S2_14_3a  == "Domaine de la sage femme"
replace S2_14_3  = 0 if S2_14_3a  == "N'est pas disponible dans le service"
replace S2_14_3  = 0 if S2_14_3a  == "Parceque ici on ne peut pas transfuser et souvent les clients sont transférés"
replace S2_14_3  = 0 if S2_14_3a  == "Pas centre de transfusion ,on réfere"
replace S2_14_3  = 5 if S2_14_3a  == "Pas de formation"
replace S2_14_3  = 5 if S2_14_3a  == "Pas d'information sur le fer"
replace S2_14_3  = 4 if S2_14_3a  == "Personnel qualifié"
replace S2_14_3  = 4 if S2_14_3a  == "Référé chez le gynécologue"
replace S2_14_3  = 0 if S2_14_3a  == "Référence EPS"
replace S2_14_3  = 4 if S2_14_3a  == "SFE"

label define S2_14_3 0 "Service non disponible" 4 "Ne travaille pas dans ce service" 5 "Non formé pour ce service", add

replace S2_14_3a = "" if S2_14_3 != 6

recode S2_14_3 (6 = 0)

drop S2_14_3a
drop S2_15_3
label var S2_15_3_1 "Formation en cours d'emploi"
label var S2_15_3_2 "Formation de remise à niveau"
label var S2_15_3_3 "Mentorat"
label var S2_15_3_4 "Aucune"

replace S2_12_3=-9 if p2_9==-9 | p2_9==2
replace S2_13_3=-9 if S2_12_3==-9 | S2_12_3==2
replace S2_14_3=-9 if S2_14_3==.


replace S2_15_3_1=-9 if p2_9==-9 | p2_9==2
replace S2_15_3_2=-9 if p2_9==-9 | p2_9==2
replace S2_15_3_3=-9 if p2_9==-9 | p2_9==2
replace S2_15_3_4=-9 if p2_9==-9 | p2_9==2

foreach var of var S2_15_3_1 S2_15_3_2 S2_15_3_3 S2_15_3_4 {
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
}

replace S2_16_3=-9 if S2_15_3_4==1 | S2_15_3_4==.

rename S2_12_3	 p2_12c
rename S2_13_3 	 p2_13c
rename S2_14_3 	 p2_14c
rename S2_15_3_1 p2_15ca
rename S2_15_3_2 p2_15cb
rename S2_15_3_3 p2_15cc
rename S2_15_3_4 p2_15cd
rename S2_16_3	 p2_16c





********************************************************************

replace S2_14_4  = 5 if S2_14_4a  == "Besoin de recyclage"
replace S2_14_4  = 4 if S2_14_4a  == "Ce sont les sages femmes qui le font"
replace S2_14_4  = 4 if S2_14_4a  == "Ce sont les sages femmes qui s'en chargent"
replace S2_14_4  = 4 if S2_14_4a  == "C'est fait par les sages femmes"
replace S2_14_4  = 4 if S2_14_4a  == "C'est le rôle des sages femmes"
replace S2_14_4  = 4 if S2_14_4a  == "Domaine de la sage femme"
replace S2_14_4  = 4 if S2_14_4a  == "Gérer par la Sage-femme"
replace S2_14_4  = 4 if S2_14_4a  == "Je n'intervient pas à la maternité, il y a un autre médecin compétent SOU qui s'en charge"
replace S2_14_4  = 4 if S2_14_4a  == "Les sage femme qui gère"
replace S2_14_4  = 4 if S2_14_4a  == "Ne fais pas d'accouchement"
replace S2_14_4  = 4 if S2_14_4a  == "Non concerné"
replace S2_14_4  = 4 if S2_14_4a  == "On n'est en médecine générale c'est la maternité qui gère"
replace S2_14_4  = 4 if S2_14_4a  == "Pas affecté à la maternité"
replace S2_14_4  = 5 if S2_14_4a  == "Pas de formation"
replace S2_14_4  = 5 if S2_14_4a  == "Pas encore formé sur le nouveau partogramme de L'OMS"
replace S2_14_4  = 4 if S2_14_4a  == "Pas été dans une situation de le faire"
replace S2_14_4  = 5 if S2_14_4a  == "Pas formé"
replace S2_14_4  = 4 if S2_14_4a  == "Pédiatrie"
replace S2_14_4  = 4 if S2_14_4a  == "Pédiatrie"
replace S2_14_4  = 4 if S2_14_4a  == "Personnel disponible"
replace S2_14_4  = 4 if S2_14_4a  == "Personnel qualifié"
replace S2_14_4  = 4 if S2_14_4a  == "Personnel qualifié"
replace S2_14_4  = 4 if S2_14_4a  == "Personnel qualifié (SFE)"
replace S2_14_4  = 4 if S2_14_4a  == "Réservée aux sages femmes"
replace S2_14_4  = 4 if S2_14_4a  == "Sage femme"
replace S2_14_4  = 4 if S2_14_4a  == "Sage-femme"
replace S2_14_4  = 4 if S2_14_4a  == "Servi plus aux urgences"
replace S2_14_4  = 4 if S2_14_4a  == "Service médecine"
replace S2_14_4  = 4 if S2_14_4a  == "SFE"
replace S2_14_4  = 4 if S2_14_4a  == "SFE qui gère ça"
replace S2_14_4  = 4 if S2_14_4a  == "Specialiste"
replace S2_14_4  = 4 if S2_14_4a  == "Travail de la sage femme"
replace S2_14_4  = 4 if S2_14_4a  == "Travail des SFE"

label define S2_14_4 0 "Service non disponible" 4 "Ne travaille pas dans ce service" 5 "Non formé pour ce service", add

replace S2_14_4a = "" if S2_14_4 != 6

recode S2_14_4 (6 = 0)

drop S2_14_4a
drop S2_15_4
label var S2_15_4_1 "Formation en cours d'emploi"
label var S2_15_4_2 "Formation de remise à niveau"
label var S2_15_4_3 "Mentorat"
label var S2_15_4_4 "Aucune"

replace S2_12_4=-9 if p2_9==-9 | p2_9==2
replace S2_13_4=-9 if S2_12_4==-9 | S2_12_4==2
replace S2_14_4=-9 if S2_14_4==.


replace S2_15_4_1=-9 if p2_9==-9 | p2_9==2
replace S2_15_4_2=-9 if p2_9==-9 | p2_9==2
replace S2_15_4_3=-9 if p2_9==-9 | p2_9==2
replace S2_15_4_4=-9 if p2_9==-9 | p2_9==2

foreach var of var S2_15_4_1 S2_15_4_2 S2_15_4_3 S2_15_4_4 {
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
}

replace S2_16_4=-9 if p2_15cd==1 | p2_15cd==.

rename S2_12_4	 p2_12d
rename S2_13_4 	 p2_13d
rename S2_14_4 	 p2_14d
rename S2_15_4_1 p2_15da
rename S2_15_4_2 p2_15db
rename S2_15_4_3 p2_15dc
rename S2_15_4_4 p2_15dd
rename S2_16_4	 p2_16d




*****************************************************************************


replace S2_18_1=-9 if S2_18==2
replace S2_18_2=-9 if S2_18==1



*le temps de fourniture de pf dans la structure se trouve supérieur au temps de fourniture pour certains individus. ramener le temps de fourniture dans la structure au temps de fourniture global pour tous ces individus.
compare S2_18_1 S2_20_1
replace S2_18_1 = S2_20_1 if S2_20_1 > S2_18_1 & S2_18==1 & S2_20==1

compare S2_18_2 S2_20_2
replace S2_18_2 = S2_20_2 if S2_20_2 > S2_18_2 & S2_18==2 & S2_20==2


replace S2_20=-9 if S2_19==2
replace S2_20_1=-9 if S2_19==2 |S2_20==2
replace S2_20_2=-9 if S2_19==2 |S2_20==1


rename S2_17 	p2_17
rename S2_18 	p2_18
rename S2_18_1 	p2_18a
rename S2_18_2 	p2_18b
rename S2_19 	p2_19
rename S2_20 	p2_20
rename S2_20_1 	p2_20a
rename S2_20_2 	p2_20b
rename S2_21_1 	p2_21a
rename S2_21_2 	p2_21b
rename S2_21_3 	p2_21c
rename S2_21_4 	p2_21d
rename S2_21_5	p2_21e



*****************************************************************************


drop S2_22

foreach var of var S2_22_1 S2_22_2 S2_22_3 S2_22_4 S2_22_5 S2_22_6 S2_22_7 S2_22_8 S2_22_9 S2_22_10 {
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
}


********************************************************************

replace S2_27_1  = 4 if S2_27a_1  == "C gérer pas la sage femme"
replace S2_27_1  = 4 if S2_27a_1  == "Gérer au niveau de la maternité"
replace S2_27_1  = 4 if S2_27a_1  == "L'occasion ne sais pas présenter"
replace S2_27_1  = 4 if S2_27a_1  == "On suggère aux clientes d'aller vers les sages-Femmes....on intervient au cas grave"
replace S2_27_1  = 4 if S2_27a_1  == "Orienter Sage femme"
replace S2_27_1  = 5 if S2_27a_1  == "Pas de formation"
replace S2_27_1  = 4 if S2_27a_1  == "Pas d'occasion de le faire"
replace S2_27_1  = 4 if S2_27a_1  == "Services aux Sage femme"
replace S2_27_1  = 4 if S2_27a_1  == "Urgentiste"

label define S2_27_1 0 "Service non disponible" 4 "Ne travaille pas dans ce service" 5 "Non formé pour ce service", add

replace S2_27a_1 = "" if S2_27_1 != 6

replace S2_25_1=-9 if S2_24_1==2
replace S2_26_1=-5 if S2_26_1>=99
replace S2_26_1=-9 if S2_24_1==2 | S2_25_1==2



********************************************************************


drop S2_28_1


label var S2_28_1_1 "Formation dans le service"
label var S2_28_2_1 "Formation de remise à niveau"
label var S2_28_3_1 "Mentorat"
label var S2_28_4_1 "Aucun"




foreach var of var S2_28_1_1 S2_28_2_1 S2_28_3_1 S2_28_4_1 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
}




rename S2_23_1 		p2_23a
rename S2_24_1 		p2_24a
rename S2_25_1 		p2_25a
rename S2_26_1 		p2_26a
rename S2_27_1 		p2_27a
rename S2_27a_1 	p2_27a_1
rename S2_28_1_1 	p2_28aa
rename S2_28_2_1 	p2_28ba
rename S2_28_3_1 	p2_28ca
rename S2_28_4_1 	p2_28da
rename S2_29_1		p2_29a



*****************************************************************

replace S2_27_2  = 4 if S2_27a_2  == "Fournit par les sages femmes"
replace S2_27_2  = 4 if S2_27a_2  == "Gérer par la sage-femme"
replace S2_27_2  = 4 if S2_27a_2  == "Méthode fournie par la sage-femme"
replace S2_27_2  = 4 if S2_27a_2  == "On suggère les clientes d'aller vers les sages-Femmes mais on intervient s'il y'a un cas grave"
replace S2_27_2  = 4 if S2_27a_2  == "Orientation vers les Sages femmes"
replace S2_27_2  = 4 if S2_27a_2  == "Orienter sage femme"
replace S2_27_2  = 4 if S2_27a_2  == "Pas eu l'occasion"
replace S2_27_2  = 4 if S2_27a_2  == "Pas eu l'occasion de le faire"
replace S2_27_2  = 4 if S2_27a_2  == "Services pour Sage femme"

label define S2_27_2 0 "Service non disponible" 4 "Ne travaille pas dans ce service" 5 "Non formé pour ce service", add

replace S2_27a_2 = "" if S2_27_2 != 6 

replace S2_27_2 = 0 in 73

replace S2_27_2 = 0 in 98

replace S2_27_2 = 0 in 159

replace S2_25_2=-9 if S2_24_2==2
replace S2_26_2=-5 if S2_26_2>=99
replace S2_26_2=-9 if S2_24_2==2 | S2_25_2==2



********************************************************************


drop S2_28_2


label var S2_28_1_2 "Formation dans le service"
label var S2_28_2_2 "Formation de remise à niveau"
label var S2_28_3_2 "Mentorat"
label var S2_28_4_2 "Aucun"



foreach var of var S2_28_1_2 S2_28_2_2 S2_28_3_2 S2_28_4_2 {
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
}




rename S2_23_2 		p2_23b
rename S2_24_2 		p2_24b
rename S2_25_2 		p2_25b
rename S2_26_2 		p2_26b
rename S2_27_2 		p2_27b
rename S2_27a_2 	p2_27a_2
rename S2_28_1_2 	p2_28ab
rename S2_28_2_2 	p2_28bb
rename S2_28_3_2 	p2_28cb
rename S2_28_4_2 	p2_28db
rename S2_29_2		p2_29b



*****************************************************************
replace S2_27_3  = 4 if S2_27a_3  == "C'est la Sage femme qui le fait"
replace S2_27_3  = 4 if S2_27a_3  == "Fourni par la sage-femme"
replace S2_27_3  = 4 if S2_27a_3  == "Fournit par les sages femmes"
replace S2_27_3  = 4 if S2_27a_3  == "Gérer par la maternité"
replace S2_27_3  = 4 if S2_27a_3  == "L'occasion ne sais pas présenter"
replace S2_27_3  = 2 if S2_27a_3  == "Pas de clients"
replace S2_27_3  = 4 if S2_27a_3  == "Service géré par la sage-femme"

label define S2_27_3 0 "Service non disponible" 4 "Ne travaille pas dans ce service" 5 "Non formé pour ce service", add

replace S2_27a_3 = "" if S2_27_3 != 6 

replace S2_27_3 = 0 in 73

replace S2_27_3 = 0 in 98

replace S2_25_3=-9 if S2_24_3==2
replace S2_26_3=-5 if S2_26_3>=99
replace S2_26_3=-9 if S2_24_3==2 | S2_25_3==2



********************************************************************


drop S2_28_3


label var S2_28_1_3 "Formation dans le service"
label var S2_28_2_3 "Formation de remise à niveau"
label var S2_28_3_3 "Mentorat"
label var S2_28_4_3 "Aucun"



foreach var of var S2_28_1_3 S2_28_2_3 S2_28_3_3 S2_28_4_3 {
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
}




rename S2_23_3 		p2_23c
rename S2_24_3 		p2_24c
rename S2_25_3 		p2_25c
rename S2_26_3 		p2_26c
rename S2_27_3 		p2_27c
rename S2_27a_3 	p2_27a_3
rename S2_28_1_3 	p2_28ac
rename S2_28_2_3 	p2_28bc
rename S2_28_3_3 	p2_28cc
rename S2_28_4_3 	p2_28dc
rename S2_29_3		p2_29c



******************************************************************

replace S2_27_4  = 4 if S2_27a_4  == "Pas eu l'occasion de le faire"
replace S2_27_4  = 4 if S2_27a_4  == "Orienter sage femme"
replace S2_27_4  = 5 if S2_27a_4  == "Formation en cours"
replace S2_27_4  = 4 if S2_27a_4  == "Fournit par les sages femmes"
replace S2_27_4  = 4 if S2_27a_4  == "On suggère patientes d'aller vers les sages-Femmes mais on intervient au cas grave"
replace S2_27_4  = 4 if S2_27a_4  == "Pas de clients"

label define S2_27_4 0 "Service non disponible" 4 "Ne travaille pas dans ce service" 5 "Non formé pour ce service", add

replace S2_27a_4 = "" if S2_27_4 != 6

replace S2_25_4=-9 if S2_24_4==2
replace S2_26_4=-5 if S2_26_4>=99
replace S2_26_4=-9 if S2_24_4==2 | S2_25_4==2


********************************************************************


drop S2_28_4


label var S2_28_1_4 "Formation dans le service"
label var S2_28_2_4 "Formation de remise à niveau"
label var S2_28_3_4 "Mentorat"
label var S2_28_4_4 "Aucun"



foreach var of var S2_28_1_4 S2_28_2_4 S2_28_3_4 S2_28_4_4 {
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
}




rename S2_23_4 		p2_23d
rename S2_24_4 		p2_24d
rename S2_25_4 		p2_25d
rename S2_26_4 		p2_26d
rename S2_27_4 		p2_27d
rename S2_27a_4 	p2_27a_4
rename S2_28_1_4 	p2_28ad
rename S2_28_2_4 	p2_28bd
rename S2_28_3_4 	p2_28cd
rename S2_28_4_4 	p2_28dd
rename S2_29_4		p2_29d


*******************************************************************

replace S2_27_5  = 4 if S2_27a_5  == "C'est la sage qui le fait"
replace S2_27_5  = 4 if S2_27a_5  == "Méthode fournie par la sage-femme"
replace S2_27_5  = 4 if S2_27a_5  == "On suggère les patientes d'aller vers les sages-Femmes mais on intervient au cas grave"
replace S2_27_5  = 4 if S2_27a_5  == "Services maternité"
replace S2_27_5  = 5 if S2_27a_5  == "Toujours en formation"

label define S2_27_5 0 "Service non disponible" 4 "Ne travaille pas dans ce service" 5 "Non formé pour ce service", add

replace S2_27a_5 = "" if S2_27_5 != 6 

recode S2_27_5 (6 = 0)

replace S2_25_5=-9 if S2_24_5==2
replace S2_26_5=-5 if S2_26_5>=99
replace S2_26_5=-9 if S2_24_5==2 | S2_25_5==2


********************************************************************


drop S2_28_5


label var S2_28_1_5 "Formation dans le service"
label var S2_28_2_5 "Formation de remise à niveau"
label var S2_28_3_5 "Mentorat"
label var S2_28_4_5 "Aucun"



foreach var of var S2_28_1_5 S2_28_2_5 S2_28_3_5 S2_28_4_5 {
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
}


rename S2_23_5 		p2_23e
rename S2_24_5 		p2_24e
rename S2_25_5 		p2_25e
rename S2_26_5 		p2_26e
rename S2_27_5 		p2_27e
rename S2_27a_5 	p2_27a_5
rename S2_28_1_5 	p2_28ae
rename S2_28_2_5 	p2_28be
rename S2_28_3_5 	p2_28ce
rename S2_28_4_5 	p2_28de
rename S2_29_5		p2_29e


******************************************************************
replace S2_27_6  = 4 if S2_27a_6  == "Fournit par les sages femmes"
replace S2_27_6  = 4 if S2_27a_6  == "On suggère aux clientes d'aller vers les sages-Femmes mais on intervient au cas grave"
replace S2_27_6  = 4 if S2_27a_6  == "Sage-femme"
replace S2_27_6  = 4 if S2_27a_6  == "Services de maternité"

label define S2_27_6 0 "Service non disponible" 4 "Ne travaille pas dans ce service" 5 "Non formé pour ce service", add

replace S2_27a_6 = "" if S2_27_6 != 6 

recode S2_27_6 (6 = 0)

replace S2_25_6=-9 if S2_24_6==2
replace S2_26_6=-5 if S2_26_6>=99
replace S2_26_6=-9 if S2_24_6==2 | S2_25_6==2


********************************************************************


drop S2_28_6


label var S2_28_1_6 "Formation dans le service"
label var S2_28_2_6 "Formation de remise à niveau"
label var S2_28_3_6 "Mentorat"
label var S2_28_4_6 "Aucun"



foreach var of var S2_28_1_6 S2_28_2_6 S2_28_3_6 S2_28_4_6 {
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
}



rename S2_23_6 		p2_23f
rename S2_24_6 		p2_24f
rename S2_25_6 		p2_25f
rename S2_26_6 		p2_26f
rename S2_27_6 		p2_27f
rename S2_27a_6 	p2_27a_6
rename S2_28_1_6 	p2_28af
rename S2_28_2_6 	p2_28bf
rename S2_28_3_6 	p2_28cf
rename S2_28_4_6 	p2_28df
rename S2_29_6		p2_29f



********************************************************************
replace S2_27_7  = 4 if S2_27a_7  == "Fournit par les sages femmes"
replace S2_27_7  = 4 if S2_27a_7  == "Orientation vers les sages femmes"
replace S2_27_7  = 4 if S2_27a_7  == "Services pour les sages femmes"

label define S2_27_7 0 "Service non disponible" 4 "Ne travaille pas dans ce service" 5 "Non formé pour ce service", add

replace S2_27a_7 = "" if S2_27_7 != 6 

recode S2_27_7 (6 = 0)


replace S2_25_7=-9 if S2_24_7==2
replace S2_26_7=-5 if S2_26_7>=99
replace S2_26_7=-9 if S2_24_7==2 | S2_25_7==2


********************************************************************


drop S2_28_7


label var S2_28_1_7 "Formation dans le service"
label var S2_28_2_7 "Formation de remise à niveau"
label var S2_28_3_7 "Mentorat"
label var S2_28_4_7 "Aucun"



foreach var of var S2_28_1_7 S2_28_2_7 S2_28_3_7 S2_28_4_7 {
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
}



rename S2_23_7 		p2_23g
rename S2_24_7 		p2_24g
rename S2_25_7 		p2_25g
rename S2_26_7 		p2_26g
rename S2_27_7 		p2_27g
rename S2_27a_7 	p2_27a_7
rename S2_28_1_7 	p2_28ag
rename S2_28_2_7 	p2_28bg
rename S2_28_3_7 	p2_28cg
rename S2_28_4_7 	p2_28dg
rename S2_29_7		p2_29g




********************************************************************


replace S2_25_8=-9 if S2_24_8==2
replace S2_26_8=-5 if S2_26_8>=99
replace S2_26_8=-9 if S2_24_8==2 | S2_25_8==2


drop S2_28_8


label var S2_28_1_8 "Formation dans le service"
label var S2_28_2_8 "Formation de remise à niveau"
label var S2_28_3_8 "Mentorat"
label var S2_28_4_8 "Aucun"



foreach var of var S2_28_1_8 S2_28_2_8 S2_28_3_8 S2_28_4_8 {
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
}



rename S2_23_8 		p2_23h
rename S2_24_8 		p2_24h
rename S2_25_8 		p2_25h
rename S2_26_8 		p2_26h
rename S2_27_8 		p2_27h
rename S2_27a_8 	p2_27a_8
rename S2_28_1_8 	p2_28ah
rename S2_28_2_8 	p2_28bh
rename S2_28_3_8 	p2_28ch
rename S2_28_4_8 	p2_28dh
rename S2_29_8		p2_29h




********************************************************************

replace S2_25_9=-9 if S2_24_9==2
replace S2_26_9=-5 if S2_26_9>=99
replace S2_26_9=-9 if S2_24_9==2 | S2_25_9==2

drop S2_28_9


label var S2_28_1_9 "Formation dans le service"
label var S2_28_2_9 "Formation de remise à niveau"
label var S2_28_3_9 "Mentorat"
label var S2_28_4_9 "Aucun"



foreach var of var S2_28_1_9 S2_28_2_9 S2_28_3_9 S2_28_4_9 {
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
}



rename S2_23_9 		p2_23i
rename S2_24_9 		p2_24i
rename S2_25_9 		p2_25i
rename S2_26_9 		p2_26i
rename S2_27_9 		p2_27i
rename S2_27a_9 	p2_27a_9
rename S2_28_1_9 	p2_28ai
rename S2_28_2_9 	p2_28bi
rename S2_28_3_9 	p2_28ci
rename S2_28_4_9 	p2_28di
rename S2_29_9		p2_29i




********************************************************************


replace S2_25_10=-9 if S2_24_10==2
replace S2_26_10=-5 if S2_26_10>=99
replace S2_26_10=-9 if S2_24_10==2 | S2_25_10==2


drop S2_28_10


label var S2_28_1_10 "Formation dans le service"
label var S2_28_2_10 "Formation de remise à niveau"
label var S2_28_3_10 "Mentorat"
label var S2_28_4_10 "Aucun"



foreach var of var S2_28_1_10 S2_28_2_10 S2_28_3_10 S2_28_4_10 {
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
}



rename S2_23_10 	p2_23j
rename S2_24_10 	p2_24j
rename S2_25_10 	p2_25j
rename S2_26_10 	p2_26j
rename S2_27_10		p2_27j
rename S2_27a_10 	p2_27a_10
rename S2_28_1_10 	p2_28aj
rename S2_28_2_10 	p2_28bj
rename S2_28_3_10 	p2_28cj
rename S2_28_4_10 	p2_28dj
rename S2_29_10		p2_29j







label var  S2_22_1 	"DIU"
label var  S2_22_2 	"Injectables"
label var  S2_22_3 	"Préservatif masculin"
label var  S2_22_4 	"Préservatif féminin"
label var  S2_22_5 	"Contraception d'urgence"
label var  S2_22_6 	"Pilules"
label var  S2_22_7 	"Implants"
label var  S2_22_8 	"Stérilisation féminine"
label var  S2_22_9 	"Stérilisation masculine"
label var  S2_22_10 "Allaitement maternel exclusif"


rename S2_22_1 	p2_22a
rename S2_22_2 	p2_22b
rename S2_22_3 	p2_22c
rename S2_22_4 	p2_22d
rename S2_22_5 	p2_22e
rename S2_22_6 	p2_22f
rename S2_22_7 	p2_22g
rename S2_22_8 	p2_22h
rename S2_22_9 	p2_22i
rename S2_22_10	p2_22j






************************************** SECTION 3
									  ***********



drop S3_2


*Création d'une modalité supplémentaire (10) à partir des éléments précisés pour "Autres"
gen S3_2_10 = 0 if S3_2_1 != . 

order S3_2_10, after(S3_2_8)

label var S3_2_10 "302. Informations sociodémographiques/liées à la fécondité - Adresse"

replace S3_2_10  = 1 if S3_2a  == "Adresse"
replace S3_2_10  = 1 if S3_2a  == "Adresse"
replace S3_2_10  = 1 if S3_2a  == "Adresse et numéro de téléphone, ethnie"
replace S3_2_10  = 1 if S3_2a  == "Adresse exacte"
replace S3_2_10  = 1 if S3_2a  == "Adresse exacte"
replace S3_2_10  = 1 if S3_2a  == "Adresse exacte, statut sérologique"
replace S3_2_10  = 1 if S3_2a  == "Adresse téléphone"
replace S3_2_10  = 1 if S3_2a  == "Adresse, téléphone"
replace S3_2_9  = 1 if S3_2a  == "Jamais posé"
replace S3_2_10  = 1 if S3_2a  == "Lieu de résidence  et niveau de vie"
replace S3_2_6  = 1 if S3_2a  == "Nombre de gestité"
replace S3_2_9  = 1 if S3_2a  == "Sage femme qui prenait les infos"
replace S3_2_10  = 1 if S3_2a  == "Terrain "

replace S3_2_96 = 0 if S3_2_10 == 1

replace S3_2_96 = 0 if S3_2a  == "Nombre de gestité"

replace S3_2_96 = 0 if S3_2a  == "Sage femme qui prenait les infos"

replace S3_2_96 = 0 if S3_2a  == "Jamais posé"

replace S3_2a   = "" if S3_2_10 == 1

replace S3_2a   = "" if S3_2a  == "Nombre de gestité"

replace S3_2a   = "" if S3_2a  == "Sage femme qui prenait les infos"

replace S3_2a   = "" if S3_2a  == "Jamais posé"


rename S3_2_1	p3_2a
rename S3_2_2	p3_2b
rename S3_2_3	p3_2c
rename S3_2_4	p3_2d
rename S3_2_5	p3_2e
rename S3_2_6	p3_2f
rename S3_2_7	p3_2g
rename S3_2_8	p3_2h
rename S3_2_9	p3_2y
rename S3_2_10	p3_2i
rename S3_2_96	p3_2x
rename S3_2a	p3_2aut


label var p3_2a  "Age"
label var p3_2b  "Situation matrimoniale"
label var p3_2c  "Profession"
label var p3_2d  "Religion"
label var p3_2e  "Niveau d'éducation"
label var p3_2f  "Nombre d'enfants vivants"
label var p3_2g  "Age de l'enfant le plus jeune"
label var p3_2h  "Désir d'un enfant supplémentaire"
label var p3_2i  "Adresse"
label var p3_2y  "Ne recueille aucune information"
label var p3_2x  "Autres (préciser)"
label var p3_2aut   "Préciser"


foreach var of var p3_2? {
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
}


foreach x in a b c d e f g h i y x {
	
	foreach var of var p3_2`x' {
		replace `var' = -9 if p2_22a == 0 | p2_17 == 2
	
	}
}


*******************************************************************

drop S3_3


* Redeployer les "Autres (à préciser)"

replace S3_3_9  = 1  if S3_3a  == "Sage femme qui prenait les infos"
replace S3_3_9  = 1  if S3_3a  == "Ne pose pas de DIU"

replace S3_3_96 = 0  if S3_3a  == "Sage femme qui prenait les infos"
replace S3_3_96 = 0  if S3_3a  == "Ne pose pas de DIU"

replace S3_3a  	= "" if S3_3a  == "Sage femme qui prenait les infos"
replace S3_3a  	= "" if S3_3a  == "Ne pose pas de DIU"

rename S3_3_1 	p3_3a
rename S3_3_2 	p3_3b
rename S3_3_3 	p3_3c
rename S3_3_4 	p3_3d
rename S3_3_5 	p3_3e
rename S3_3_6 	p3_3f
rename S3_3_7 	p3_3g
rename S3_3_96 	p3_3x
rename S3_3_9 	p3_3y
rename S3_3a    p3_3aut

label var p3_3a "Date des dernières règles"
label var p3_3b "Durée du cycle menstruel"
label var p3_3c "Durée des règles"
label var p3_3d "Quantité de flux"
label var p3_3e "Règles douloureuses"
label var p3_3f "Régularité des règles"
label var p3_3g "Saignements entre les règles"
label var p3_3x "Autres (préciser)"
label var p3_3y "Ne recueille aucune information"
label var p3_3aut "Préciser"

foreach var of var p3_3? {
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
}


foreach x in a b c d e f g y x {
	
	foreach var of var p3_3`x' {
		replace `var' = -9 if p2_22a == 0 | p2_17 == 2
	
	}
}





*******************************************************************

drop S3_4



replace S3_4_9  = 1  if S3_4a  == "Sage femme qui prenait les infos"
replace S3_4_9  = 1  if S3_4a  == "Ne pose pas de DIU"

replace S3_4_96 = 0	 if S3_4a  == "Sage femme qui prenait les infos"
replace S3_4_96 = 0  if S3_4a  == "Ne pose pas de DIU"

replace S3_4a	= "" if S3_4a  == "Sage femme qui prenait les infos"
replace S3_4a  	= "" if S3_4a  == "Ne pose pas de DIU"



rename S3_4_1  p3_4a
rename S3_4_2  p3_4b
rename S3_4_3  p3_4c
rename S3_4_4  p3_4d
rename S3_4_5  p3_4e
rename S3_4_6  p3_4f
rename S3_4_7  p3_4g
rename S3_4_96 p3_4x
rename S3_4_9  p3_4y
rename S3_4a   p3_4aut

label var p3_4a "État actuel de la grossesse"
label var p3_4b "Nombre de naissances vivantes"
label var p3_4c "Nombre d'accouchements normaux"
label var p3_4d "Nombre d'accouchements par césarienne"
label var p3_4e "Nombre d'avortements"
label var p3_4f "Date du dernier accouchement/avortement"
label var p3_4g "Antécédents de grossesse anormale"
label var p3_4x "Autres (préciser)"
label var p3_4y "Ne recueille aucune information"
label var p3_4aut "Préciser"


foreach var of var p3_4? {
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
}


foreach x in a b c d e f g x y {
	
	foreach var of var p3_4`x' {
		replace `var' = -9 if p2_22a == 0 | p2_17 == 2
	
	}
}



*******************************************************************************


replace S3_5 = -9 if p2_22a == 0 | p2_17 == 2

rename S3_5 p3_5




*******************************************************************

replace S3_6_9  = 1 if S3_6a  == "Sage femme qui prenait les infos"
replace S3_6_1  = 1 if S3_6a  == "Si connaissance de la contraception et laquelle"
replace S3_6_1  = 1 if S3_6a  == "Si elle a une fois utilisé le DIU"
replace S3_6_1  = 1 if S3_6a  == "Durée"
replace S3_6_1  = 1 if S3_6a  == "Effet secondaire , prise de poids"
replace S3_6_1  = 1 if S3_6a  == "Si elle est sous contraceptive"


replace S3_6_96  = 0 if S3_6a  == "Sage femme qui prenait les infos"
replace S3_6_96  = 0 if S3_6a  == "Si connaissance de la contraception et laquelle"
replace S3_6_96  = 0 if S3_6a  == "Si elle a une fois utilisé le DIU"
replace S3_6_96  = 0 if S3_6a  == "Durée"
replace S3_6_96  = 0 if S3_6a  == "Effet secondaire , prise de poids"
replace S3_6_96  = 0 if S3_6a  == "Si elle est sous contraceptive"


replace S3_6a  = "" if S3_6a  == "Sage femme qui prenait les infos"
replace S3_6a  = "" if S3_6a  == "Si connaissance de la contraception et laquelle"
replace S3_6a  = "" if S3_6a  == "Si elle a une fois utilisé le DIU"
replace S3_6a  = "" if S3_6a  == "Durée"
replace S3_6a  = "" if S3_6a  == "Effet secondaire , prise de poids"
replace S3_6a  = "" if S3_6a  == "Si elle est sous contraceptive"


drop S3_6


foreach var of var S3_6_1 S3_6_2 S3_6_3 S3_6_96 S3_6_9 {
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
}


rename S3_6_1 	p3_6a
rename S3_6_2 	p3_6b
rename S3_6_3 	p3_6c
rename S3_6_96 	p3_6x
rename S3_6_9	p3_6o
rename S3_6a    p3_6aut


foreach x in a b c x o {
	
	foreach var of var p3_6`x' {
		replace `var' = -9 if p2_22a == 0 | p2_17 == 2
	
	}
}



*******************************************************************

replace S3_7_1  = 1 if S3_7a  == "Asmathique,HTA,diabète"
replace S3_7_1  = 1 if S3_7a  == "Diabète, hypertension, hrp"
replace S3_7_1  = 1 if S3_7a  == "Endométriose,Activités a risque, facteur de risque cardiovasculaire , anémie , drépanocytose"
replace S3_7_1  = 1 if S3_7a  == "Fertilité"
replace S3_7_1  = 1 if S3_7a  == "Hta diabète anémie drepanocytose"
replace S3_7_1  = 1 if S3_7a  == "Infertilité"
replace S3_7_1  = 1 if S3_7a  == "Multipartenariat"
replace S3_7_1  = 1 if S3_7a  == "Multipartenariat, pathologies gynécologie, infections"
replace S3_7_2  = 1 if S3_7a  == "Myomectomie"
replace S3_7_9  = 1 if S3_7a  == "Sage femme qui prenait les infos"


replace S3_7_96  = 0 if S3_7a  == "Asmathique,HTA,diabète"
replace S3_7_96  = 0 if S3_7a  == "Diabète, hypertension, hrp"
replace S3_7_96  = 0 if S3_7a  == "Endométriose,Activités a risque, facteur de risque cardiovasculaire , anémie , drépanocytose"
replace S3_7_96  = 0 if S3_7a  == "Fertilité"
replace S3_7_96  = 0 if S3_7a  == "Hta diabète anémie drepanocytose"
replace S3_7_96  = 0 if S3_7a  == "Infertilité"
replace S3_7_96  = 0 if S3_7a  == "Multipartenariat"
replace S3_7_96  = 0 if S3_7a  == "Multipartenariat, pathologies gynécologie, infections"
replace S3_7_96  = 0 if S3_7a  == "Myomectomie"
replace S3_7_96  = 0 if S3_7a  == "Sage femme qui prenait les infos"


replace S3_7a  = "" if S3_7a  == "Asmathique,HTA,diabète"
replace S3_7a  = "" if S3_7a  == "Diabète, hypertension, hrp"
replace S3_7a  = "" if S3_7a  == "Endométriose,Activités a risque, facteur de risque cardiovasculaire , anémie , drépanocytose"
replace S3_7a  = "" if S3_7a  == "Fertilité"
replace S3_7a  = "" if S3_7a  == "Hta diabète anémie drepanocytose"
replace S3_7a  = "" if S3_7a  == "Infertilité"
replace S3_7a  = "" if S3_7a  == "Multipartenariat"
replace S3_7a  = "" if S3_7a  == "Multipartenariat, pathologies gynécologie, infections"
replace S3_7a  = "" if S3_7a  == "Myomectomie"
replace S3_7a  = "" if S3_7a  == "Sage femme qui prenait les infos"



drop S3_7 



foreach var of var S3_7_1 S3_7_2 S3_7_3 S3_7_4 S3_7_5 S3_7_6 S3_7_7 S3_7_8 S3_7_14 S3_7_10 S3_7_11 S3_7_12 S3_7_13 S3_7_96 S3_7_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S3_7_1 	p3_7a
rename S3_7_2 	p3_7b
rename S3_7_3 	p3_7c
rename S3_7_4 	p3_7d
rename S3_7_5 	p3_7e
rename S3_7_6 	p3_7f
rename S3_7_7 	p3_7g
rename S3_7_8 	p3_7h
rename S3_7_14 	p3_7i
rename S3_7_10 	p3_7j
rename S3_7_11 	p3_7k
rename S3_7_12 	p3_7l
rename S3_7_13 	p3_7m
rename S3_7_96 	p3_7x
rename S3_7_9	p3_7o
rename S3_7a    p3_7aut




foreach x in a b c d e f g h i j k l m x o {
	
	foreach var of var p3_7`x' {
		replace `var' = -9 if p2_22a == 0 | p2_17 == 2
	
	}
}



********************************************************************

drop S3_8 



foreach var of var S3_8_1 S3_8_2 S3_8_3 S3_8_4 S3_8_5 S3_8_6 S3_8_7 S3_8_8 S3_8_12 S3_8_10 S3_8_11 S3_8_96 S3_8_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}



rename S3_8_1 	p3_8a
rename S3_8_2 	p3_8b
rename S3_8_3 	p3_8c
rename S3_8_4 	p3_8d
rename S3_8_5 	p3_8e
rename S3_8_6 	p3_8f
rename S3_8_7 	p3_8g
rename S3_8_8 	p3_8h
rename S3_8_12 	p3_8i
rename S3_8_10 	p3_8j
rename S3_8_11 	p3_8k
rename S3_8_96 	p3_8x
rename S3_8_9	p3_8o
rename S3_8a    p3_8aut


foreach x in a b c d e f g h i j k x o {
	
	foreach var of var p3_8`x' {
		replace `var' = -9 if p2_22a == 0 | p2_17 == 2
	
	}
}



*********************************************************************


drop S3_9 



foreach var of var S3_9_1 S3_9_2 S3_9_3 S3_9_96 S3_9_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S3_9_1 	p3_9a
rename S3_9_2 	p3_9b
rename S3_9_3 	p3_9c
rename S3_9_96 	p3_9x
rename S3_9_9	p3_9y
rename S3_9a    p3_9aut


foreach x in a b c x y {
	
	foreach var of var p3_9`x' {
		replace `var' = -9 if p2_22a == 0 | p2_17 == 2
	
	}
}




********************************************************************

gen S3_10_4 = 0 if S3_10_1 != . 
order S3_10_4, after(S3_10_3) 
label var S3_10_4 "Prélèvement vaginal"


replace S3_10_4  = 1 if S3_10a  == "Faire un prélèvement vaginal"
replace S3_10_4  = 1 if S3_10a  == "Le prélèvement vaginal ou le frottis"
replace S3_10_4  = 1 if S3_10a  == "Prélèvement vaginal"
replace S3_10_4  = 1 if S3_10a  == "Prélèvement vaginal"
replace S3_10_4  = 1 if S3_10a  == "Prélèvement vaginal"
replace S3_10_4  = 1 if S3_10a  == "PV,"


replace S3_10a  = "" if S3_10a  == "Faire un prélèvement vaginal"
replace S3_10a  = "" if S3_10a  == "Le prélèvement vaginal ou le frottis"
replace S3_10a  = "" if S3_10a  == "Prélèvement vaginal"
replace S3_10a  = "" if S3_10a  == "Prélèvement vaginal"
replace S3_10a  = "" if S3_10a  == "Prélèvement vaginal"
replace S3_10a  = "" if S3_10a  == "PV,"



drop S3_10 


foreach var of var S3_10_1 S3_10_2 S3_10_3 S3_10_4 S3_10_96 S3_10_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}

rename S3_10_1 	p3_10a
rename S3_10_2 	p3_10b
rename S3_10_3 	p3_10c
rename S3_10_4 	p3_10d
rename S3_10_96 p3_10x
rename S3_10_9	p3_10o
rename S3_10a   p3_10aut


foreach x in a b c d x o {
	
	foreach var of var p3_10`x' {
		replace `var' = -9 if p2_22a == 0 | p2_17 == 2
	
	}
}



********************************************************************

replace S3_11_9  = 1 if S3_11a  == "Sage femme qui prenait les infos"
replace S3_11_15  = 1 if S3_11a  == "3 césarienne de suite"
replace S3_11_2  = 1 if S3_11a  == "Amenhorre"
replace S3_11_13  = 1 if S3_11a  == "Col pathologie Morphologie bicorne Difficulter de poser "
replace S3_11_7  = 1 if S3_11a  == "Fibrome sous muqueux,utérus multicicatriciel"
replace S3_11_6  = 1 if S3_11a  == "Infections"
replace S3_11_7  = 1 if S3_11a  == "Notion de Fibrome , infections"
replace S3_11_1  = 1 if S3_11a  == "Per partum"
replace S3_11_6  = 1 if S3_11a  == "Toutes infestation vaginale"
replace S3_11_9  = 1 if S3_11a  == "Y,en a pas"


replace S3_11_96  = 0 if S3_11a  == "Sage femme qui prenait les infos"
replace S3_11_96  = 0 if S3_11a  == "3 césarienne de suite"
replace S3_11_96  = 0 if S3_11a  == "Amenhorre"
replace S3_11_96  = 0 if S3_11a  == "Col pathologie Morphologie bicorne Difficulter de poser "
replace S3_11_96  = 0 if S3_11a  == "Fibrome sous muqueux,utérus multicicatriciel"
replace S3_11_96  = 0 if S3_11a  == "Infections"
replace S3_11_96  = 0 if S3_11a  == "Notion de Fibrome , infections"
replace S3_11_96  = 0 if S3_11a  == "Per partum"
replace S3_11_96  = 0 if S3_11a  == "Toutes infestation vaginale"
replace S3_11_96  = 0 if S3_11a  == "Y,en a pas"


replace S3_11a  = "" if S3_11a  == "Sage femme qui prenait les infos"
replace S3_11a  = "" if S3_11a  == "3 césarienne de suite"
replace S3_11a  = "" if S3_11a  == "Amenhorre"
replace S3_11a  = "" if S3_11a  == "Col pathologie Morphologie bicorne Difficulter de poser "
replace S3_11a  = "" if S3_11a  == "Fibrome sous muqueux,utérus multicicatriciel"
replace S3_11a  = "" if S3_11a  == "Infections"
replace S3_11a  = "" if S3_11a  == "Notion de Fibrome , infections"
replace S3_11a  = "" if S3_11a  == "Per partum"
replace S3_11a  = "" if S3_11a  == "Toutes infestation vaginale"
replace S3_11a  = "" if S3_11a  == "Y,en a pas"


drop S3_11


foreach var of var S3_11_1 S3_11_2 S3_11_3 S3_11_4 S3_11_5 S3_11_6 S3_11_7 S3_11_8 S3_11_17 S3_11_10 S3_11_11 S3_11_12 S3_11_13 S3_11_14 S3_11_15 S3_11_16 S3_11_96 S3_11_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}

rename S3_11_1 	p3_11a
rename S3_11_2 	p3_11b
rename S3_11_3 	p3_11c
rename S3_11_4 	p3_11d
rename S3_11_5 	p3_11e
rename S3_11_6 	p3_11f
rename S3_11_7 	p3_11g
rename S3_11_8 	p3_11h
rename S3_11_17 p3_11i
rename S3_11_10 p3_11j
rename S3_11_11 p3_11k
rename S3_11_12 p3_11l
rename S3_11_13 p3_11m
rename S3_11_14 p3_11n
rename S3_11_15 p3_11o
rename S3_11_16 p3_11p
rename S3_11_96 p3_11x
rename S3_11_9	p3_11z
rename S3_11a   p3_11aut


foreach x in a b c d e f g h i j k l m n o p x z {
	
	foreach var of var p3_11`x' {
		replace `var' = -9 if p2_22a == 0 | p2_17 == 2
	
	}
}


********************************************************************


replace S3_12 = -9 if p2_22a == 0 | p2_17 == 2

rename S3_12 p3_12
rename S3_12a  p3_12aut

********************************************************************

gen S3_13_8 = 0 if S3_13_1 != . 

order S3_13_8, after (S3_13_7)

label var S3_13_8 "Effets secondaires"

label value S3_13_8 S3_13_7

replace S3_13_8  = 1 if S3_13a  == "Anémie"
replace S3_13_8  = 1 if S3_13a  == "Effets secondaires, RV"
replace S3_13_8  = 1 if S3_13a  == "Les effet secondaire et un rendez vous"
replace S3_13_8  = 1 if S3_13a  == "Les effets secondaires"
replace S3_13_7  = 1 if S3_13a  == "Respect des rendez-vous,"
replace S3_13_9  = 1 if S3_13a  == "Sage femme"
replace S3_13_4  = 1 if S3_13a  == "Saignements pas dangereux"
replace S3_13_3  = 1 if S3_13a  == "Sensation de gêne pelvienne"
replace S3_13_3  = 1 if S3_13a  == "Une sensation de gêne pour le mari et elle peut revenir"
replace S3_13_7  = 1 if S3_13a  == "Venir au Rendez-vous et les respectes "


replace S3_13_96  = 0 if S3_13a  == "Anémie"
replace S3_13_96  = 0 if S3_13a  == "Effets secondaires, RV"
replace S3_13_96  = 0 if S3_13a  == "Les effet secondaire et un rendez vous"
replace S3_13_96  = 0 if S3_13a  == "Les effets secondaires"
replace S3_13_96  = 0 if S3_13a  == "Respect des rendez-vous,"
replace S3_13_96  = 0 if S3_13a  == "Sage femme"
replace S3_13_96  = 0 if S3_13a  == "Saignements pas dangereux"
replace S3_13_96  = 0 if S3_13a  == "Sensation de gêne pelvienne"
replace S3_13_96  = 0 if S3_13a  == "Une sensation de gêne pour le mari et elle peut revenir"
replace S3_13_96  = 0 if S3_13a  == "Venir au Rendez-vous et les respectes"


replace S3_13a  = "" if S3_13a  == "Anémie"
replace S3_13a  = "" if S3_13a  == "Effets secondaires, RV"
replace S3_13a  = "" if S3_13a  == "Les effet secondaire et un rendez vous"
replace S3_13a  = "" if S3_13a  == "Les effets secondaires"
replace S3_13a  = "" if S3_13a  == "Respect des rendez-vous,"
replace S3_13a  = "" if S3_13a  == "Sage femme"
replace S3_13a  = "" if S3_13a  == "Saignements pas dangereux"
replace S3_13a  = "" if S3_13a  == "Sensation de gêne pelvienne"
replace S3_13a  = "" if S3_13a  == "Une sensation de gêne pour le mari et elle peut revenir"
replace S3_13a  = "" if S3_13a  == "Venir au Rendez-vous et les respectes"

drop S3_13

foreach var of var S3_13_1 S3_13_2 S3_13_3 S3_13_4 S3_13_5 S3_13_6 S3_13_7 S3_13_8 S3_13_96 S3_13_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}

rename S3_13_1 	p3_13a
rename S3_13_2 	p3_13b
rename S3_13_3 	p3_13c
rename S3_13_4 	p3_13d
rename S3_13_5 	p3_13e
rename S3_13_6 	p3_13f
rename S3_13_7 	p3_13g
rename S3_13_8 	p3_13h
rename S3_13_96 p3_13x
rename S3_13_9	p3_13o
rename S3_13a   p3_13aut


foreach x in a b c d e f g h x o {
	
	foreach var of var p3_13`x' {
		replace `var' = -9 if p2_22a == 0 | p2_17 == 2
	
	}
}



********************************************************************


replace S3_14_2  = 1 if S3_14a  == "Douleur des seins au moment des règles"
replace S3_14_2  = 1 if S3_14a  == "Douleurs pelvienne  le Diu peut se perdre"
replace S3_14_1  = 1 if S3_14a  == "Dysménorrhée"
replace S3_14_2  = 1 if S3_14a  == "La douleur"
replace S3_14_1  = 1 if S3_14a  == "Menometrorragie"
replace S3_14_9  = 1 if S3_14a  == "Ne sait pas"
replace S3_14_9  = 1 if S3_14a  == "Sage femme"
replace S3_14_1  = 1 if S3_14a  == "Saignements anormaux ,perception du fil"
replace S3_14_1  = 1 if S3_14a  == "Spotting"


replace S3_14_96  = 0 if S3_14a  == "Douleur des seins au moment des règles"
replace S3_14_96  = 0 if S3_14a  == "Douleurs pelvienne  le Diu peut se perdre"
replace S3_14_96  = 0 if S3_14a  == "Dysménorrhée"
replace S3_14_96  = 0 if S3_14a  == "La douleur"
replace S3_14_96  = 0 if S3_14a  == "Menometrorragie"
replace S3_14_96  = 0 if S3_14a  == "Ne sait pas"
replace S3_14_96  = 0 if S3_14a  == "Sage femme"
replace S3_14_96  = 0 if S3_14a  == "Saignements anormaux ,perception du fil"
replace S3_14_96  = 0 if S3_14a  == "Spotting"


replace S3_14a  = "" if S3_14a  == "Douleur des seins au moment des règles"
replace S3_14a  = "" if S3_14a  == "Douleurs pelvienne  le Diu peut se perdre"
replace S3_14a  = "" if S3_14a  == "Dysménorrhée"
replace S3_14a  = "" if S3_14a  == "La douleur"
replace S3_14a  = "" if S3_14a  == "Menometrorragie"
replace S3_14a  = "" if S3_14a  == "Ne sait pas"
replace S3_14a  = "" if S3_14a  == "Sage femme"
replace S3_14a  = "" if S3_14a  == "Saignements anormaux ,perception du fil"
replace S3_14a  = "" if S3_14a  == "Spotting"


drop S3_14


foreach var of var S3_14_1 S3_14_2 S3_14_3 S3_14_4 S3_14_96 S3_14_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}

rename S3_14_1 	p3_14a
rename S3_14_2 	p3_14b
rename S3_14_3 	p3_14c
rename S3_14_4 	p3_14d
rename S3_14_96 p3_14x
rename S3_14_9	p3_14o
rename S3_14a   p3_14aut


foreach x in a b c d x o {
	
	foreach var of var p3_14`x' {
		replace `var' = -9 if p2_22a == 0 | p2_17 == 2
	
	}
}





*****************************************************************


label var S3_15_1 "Des appels téléphoniques sont effectués pour rappeler aux clients date de suivi"
label var S3_15_2 "Les ASC se rendent à domicile pour une visite de suivi"
label var S3_15_3 "Les ASC rappellent aux clients les date de suivi"
label var S3_15_4 "Inscrire la date de suivi sur la carte de rendez-vous"


gen S3_15_5 = 0 if S3_15_1 != . 

order S3_15_5, after(S3_15_4)

label var S3_15_5 "Carnet de rendez-vous"

label value S3_15_5 S3_15_4

replace S3_15_5  = 1 if S3_15a  == "Carnet"
replace S3_15_5  = 1 if S3_15a  == "Carnet de rendez-vous"
replace S3_15_5  = 1 if S3_15a  == "Carte de rendez vous"
replace S3_15_5  = 1 if S3_15a  == "Carte de rendez vous"
replace S3_15_5  = 1 if S3_15a  == "Carte de rendez vous"
replace S3_15_5  = 1 if S3_15a  == "Carte de rendez-vous"
replace S3_15_5  = 1 if S3_15a  == "Carte de rendez-vous"
replace S3_15_5  = 1 if S3_15a  == "Carte de rendez-vous"
replace S3_15_5  = 1 if S3_15a  == "Carte de suivi"
replace S3_15_5  = 1 if S3_15a  == "Carte de visite"
replace S3_15_5  = 1 if S3_15a  == "Carte de visite"
replace S3_15_5  = 1 if S3_15a  == "Carte rendez-vous"
replace S3_15_5  = 1 if S3_15a  == "Carte rendez-vous"
replace S3_15_5  = 1 if S3_15a  == "Cartes de rendez vous"
replace S3_15_5  = 1 if S3_15a  == "Chaque client à sa carte de rendez-vous"
replace S3_15_5  = 1 if S3_15a  == "Il y a des cartes avec le numéro de dossier et la date du rendez-vous"
replace S3_15_5  = 1 if S3_15a  == "Inscrire la date de suivi dans la carte de rendez-vous"
replace S3_15_5  = 1 if S3_15a  == "Rendez vous avec une carte de suivi"
replace S3_15_5  = 1 if S3_15a  == "Viennent en rv"


replace S3_15_96  = 0 if S3_15a  == "Carnet"
replace S3_15_96  = 0 if S3_15a  == "Carnet de rendez-vous"
replace S3_15_96  = 0 if S3_15a  == "Carte de rendez vous"
replace S3_15_96  = 0 if S3_15a  == "Carte de rendez vous"
replace S3_15_96  = 0 if S3_15a  == "Carte de rendez vous"
replace S3_15_96  = 0 if S3_15a  == "Carte de rendez-vous"
replace S3_15_96  = 0 if S3_15a  == "Carte de rendez-vous"
replace S3_15_96  = 0 if S3_15a  == "Carte de rendez-vous"
replace S3_15_96  = 0 if S3_15a  == "Carte de suivi"
replace S3_15_96  = 0 if S3_15a  == "Carte de visite"
replace S3_15_96  = 0 if S3_15a  == "Carte de visite"
replace S3_15_96  = 0 if S3_15a  == "Carte rendez-vous"
replace S3_15_96  = 0 if S3_15a  == "Carte rendez-vous"
replace S3_15_96  = 0 if S3_15a  == "Cartes de rendez vous"
replace S3_15_96  = 0 if S3_15a  == "Chaque client à sa carte de rendez-vous"
replace S3_15_96  = 0 if S3_15a  == "Il y a des cartes avec le numéro de dossier et la date du rendez-vous"
replace S3_15_96  = 0 if S3_15a  == "Inscrire la date de suivi dans la carte de rendez-vous"
replace S3_15_96  = 0 if S3_15a  == "Rendez vous avec une carte de suivi"
replace S3_15_96  = 0 if S3_15a  == "Viennent en rv"


replace S3_15a  = "" if S3_15a  == "Carnet"
replace S3_15a  = "" if S3_15a  == "Carnet de rendez-vous"
replace S3_15a  = "" if S3_15a  == "Carte de rendez vous"
replace S3_15a  = "" if S3_15a  == "Carte de rendez vous"
replace S3_15a  = "" if S3_15a  == "Carte de rendez vous"
replace S3_15a  = "" if S3_15a  == "Carte de rendez-vous"
replace S3_15a  = "" if S3_15a  == "Carte de rendez-vous"
replace S3_15a  = "" if S3_15a  == "Carte de rendez-vous"
replace S3_15a  = "" if S3_15a  == "Carte de suivi"
replace S3_15a  = "" if S3_15a  == "Carte de visite"
replace S3_15a  = "" if S3_15a  == "Carte de visite"
replace S3_15a  = "" if S3_15a  == "Carte rendez-vous"
replace S3_15a  = "" if S3_15a  == "Carte rendez-vous"
replace S3_15a  = "" if S3_15a  == "Cartes de rendez vous"
replace S3_15a  = "" if S3_15a  == "Chaque client à sa carte de rendez-vous"
replace S3_15a  = "" if S3_15a  == "Il y a des cartes avec le numéro de dossier et la date du rendez-vous"
replace S3_15a  = "" if S3_15a  == "Inscrire la date de suivi dans la carte de rendez-vous"
replace S3_15a  = "" if S3_15a  == "Rendez vous avec une carte de suivi"
replace S3_15a  = "" if S3_15a  == "Viennent en rv"


drop S3_15



foreach var of var S3_15_1 S3_15_2 S3_15_3 S3_15_4 S3_15_5 S3_15_96 S3_15_9 S3_15_99 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S3_15_1 	p3_15a
rename S3_15_2 	p3_15b
rename S3_15_3 	p3_15c
rename S3_15_4 	p3_15d
rename S3_15_5 	p3_15e
rename S3_15_96 p3_15x
rename S3_15_9 	p3_15o
rename S3_15_99	p3_15z
rename S3_15a   p3_15aut

foreach x in a b c d e x o z {
	
	foreach var of var p3_15`x' {
		replace `var' = -9 if p2_22a == 0 | p2_17 == 2
	
	}
}



***********************************************************************


foreach var of var S3_16_1 S3_16_2 S3_16_3 S3_16_4 S3_16_5 S3_16_6 S3_16_7 S3_16_8 S3_16_9 S3_16_10 S3_16_11 S3_16_12 S3_16_13 S3_16_14 S3_16_15 S3_16_16 S3_16_17 S3_16_18 S3_16_19 S3_16_20 S3_16_a {
		
		replace `var' = -9 if p2_22a == 0 | p2_17 == 2
	
	}
	
	
rename S3_16_1 	p3_16a
rename S3_16_2 	p3_16b
rename S3_16_3 	p3_16c
rename S3_16_4 	p3_16d
rename S3_16_5 	p3_16e
rename S3_16_6 	p3_16f
rename S3_16_7 	p3_16g
rename S3_16_8 	p3_16h
rename S3_16_9 	p3_16i
rename S3_16_10 p3_16j
rename S3_16_11 p3_16k
rename S3_16_12 p3_16l
rename S3_16_13 p3_16m
rename S3_16_14 p3_16n
rename S3_16_15 p3_16o
rename S3_16_16 p3_16p
rename S3_16_17 p3_16q
rename S3_16_18 p3_16r
rename S3_16_19 p3_16s
rename S3_16_20 p3_16t
rename S3_16_a	p3_16aa


********************************************************************

gen S3_18_10 = 0 if S3_18_1 != . 

order S3_18_10, after(S3_18_8)

label var S3_18_10 "Adresse"

label value S3_18_10 S3_18_1

replace S3_18_10  = 1 if S3_18a  == "Adresse exacte"
replace S3_18_10  = 1 if S3_18a  == "Adresse exacte"
replace S3_18_10  = 1 if S3_18a  == "Adresse exacte, statut sérologique"
replace S3_18_10  = 1 if S3_18a  == "Adresse téléphone et ethnie"
replace S3_18_10  = 1 if S3_18a  == "Nom, prénom,"
replace S3_18_9  = 1 if S3_18a  == "Sage femme qui prenait les infos"
replace S3_18_10  = 1 if S3_18a  == "Terrain"


replace S3_18_96  = 0 if S3_18a  == "Adresse exacte"
replace S3_18_96  = 0 if S3_18a  == "Adresse exacte"
replace S3_18_96  = 0 if S3_18a  == "Adresse exacte, statut sérologique"
replace S3_18_96  = 0 if S3_18a  == "Adresse téléphone et ethnie"
replace S3_18_96  = 0 if S3_18a  == "Nom, prénom,"
replace S3_18_96  = 0 if S3_18a  == "Sage femme qui prenait les infos"
replace S3_18_96  = 0 if S3_18a  == "Terrain"

replace S3_18a  = "" if S3_18a  == "Adresse exacte"
replace S3_18a  = "" if S3_18a  == "Adresse exacte"
replace S3_18a  = "" if S3_18a  == "Adresse exacte, statut sérologique"
replace S3_18a  = "" if S3_18a  == "Adresse téléphone et ethnie"
replace S3_18a  = "" if S3_18a  == "Nom, prénom,"
replace S3_18a  = "" if S3_18a  == "Sage femme qui prenait les infos"
replace S3_18a  = "" if S3_18a  == "Terrain"


drop S3_18


foreach var of var S3_18_1 S3_18_2 S3_18_3 S3_18_4 S3_18_5 S3_18_6 S3_18_7 S3_18_8 S3_18_10 S3_18_96 S3_18_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S3_18_1 	p3_18a
rename S3_18_2 	p3_18b
rename S3_18_3 	p3_18c
rename S3_18_4 	p3_18d
rename S3_18_5 	p3_18e
rename S3_18_6 	p3_18f
rename S3_18_7 	p3_18g
rename S3_18_8 	p3_18h
rename S3_18_10 p3_18i
rename S3_18_96 p3_18x
rename S3_18_9	p3_18o
rename S3_18a   p3_18aut


foreach x in a b c d e f g h i x o {
	
	foreach var of var p3_18`x' {
		replace `var' = -9 if p2_22b == 0 | p2_17 == 2
	
	}
}



********************************************************************

drop S3_19


foreach var of var S3_19_1 S3_19_2 S3_19_3 S3_19_4 S3_19_5 S3_19_6 S3_19_7 S3_19_96 S3_19_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}

rename S3_19_1 p3_19a
rename S3_19_2 p3_19b
rename S3_19_3 p3_19c
rename S3_19_4 p3_19d
rename S3_19_5 p3_19e
rename S3_19_6 p3_19f
rename S3_19_7 p3_19g
rename S3_19_96 p3_19x
rename S3_19_9 p3_19y
rename S3_19a  p3_19aut


foreach x in a b c d e f g x y {
	
	foreach var of var p3_19`x' {
		replace `var' = -9 if p2_22b == 0 | p2_17 == 2
	
	}
}



********************************************************************


replace S3_20=-9 if p2_22b == 0 | p2_17 == 2

rename S3_20 p3_20

 
********************************************************************


replace S3_21_9  = 1 if S3_21a  == "Sage femme qui prenait les infos"
replace S3_21_1  = 1 if S3_21a  == "Si connaissance de la contraception et laquelle"
replace S3_21_1  = 1 if S3_21a  == "Si elle a une fois utilisé injectable"

replace S3_21_96  = 0 if S3_21a  == "Sage femme qui prenait les infos"
replace S3_21_96  = 0  if S3_21a  == "Si connaissance de la contraception et laquelle"
replace S3_21_96  = 0  if S3_21a  == "Si elle a une fois utilisé injectable"


replace S3_21a  = "" if S3_21a  == "Sage femme qui prenait les infos"
replace S3_21a  = ""  if S3_21a  == "Si connaissance de la contraception et laquelle"
replace S3_21a  = ""  if S3_21a  == "Si elle a une fois utilisé injectable"


drop S3_21


foreach var of var S3_21_1 S3_21_2 S3_21_3 S3_21_96 S3_21_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}

rename S3_21_1 p3_21a
rename S3_21_2 p3_21b
rename S3_21_3 p3_21c
rename S3_21_96 p3_21x
rename S3_21_9 p3_21y
rename S3_21a  p3_21aut


foreach x in a b c x y {
	
	foreach var of var p3_21`x' {
		replace `var' = -9 if p2_22b == 0 | p2_17 == 2
	
	}
}


********************************************************************


drop S3_22





foreach var of var S3_22_1 S3_22_2 S3_22_3 S3_22_4 S3_22_5 S3_22_6 S3_22_7 S3_22_8 S3_22_11 S3_22_10 S3_22_96 S3_22_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}

rename S3_22_1 p3_22a
rename S3_22_2 p3_22b
rename S3_22_3 p3_22c
rename S3_22_4 p3_22d
rename S3_22_5 p3_22e
rename S3_22_6 p3_22f
rename S3_22_7 p3_22g
rename S3_22_8 p3_22h
rename S3_22_11 p3_22i
rename S3_22_10 p3_22j
rename S3_22_96 p3_22x
rename S3_22_9 p3_22y
rename S3_22a  p3_22aut


foreach x in a b c d e f g h i j x y {
	
	foreach var of var p3_22`x' {
		replace `var' = -9 if p2_22b == 0 | p2_17 == 2
	
	}
}



********************************************************************


drop S3_23 







foreach var of var S3_23_1 S3_23_2 S3_23_3 S3_23_4 S3_23_5 S3_23_6 S3_23_7 S3_23_8 S3_23_15 S3_23_10 S3_23_11 S3_23_12 S3_23_13 S3_23_14 S3_23_96 S3_23_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}

rename S3_23_1 p3_23a
rename S3_23_2 p3_23b
rename S3_23_3 p3_23c
rename S3_23_4 p3_23d
rename S3_23_5 p3_23e
rename S3_23_6 p3_23f
rename S3_23_7 p3_23g
rename S3_23_8 p3_23h
rename S3_23_15 p3_23i
rename S3_23_10 p3_23j
rename S3_23_11 p3_23k
rename S3_23_12 p3_23l
rename S3_23_13 p3_23m
rename S3_23_14 p3_23n
rename S3_23_96 p3_23x
rename S3_23_9 p3_23y
rename S3_23a  p3_23aut


foreach x in a b c d e f g h i j k l m n x y {
	
	foreach var of var p3_23`x' {
		replace `var' = -9 if p2_22b == 0 | p2_17 == 2
	
	}
}



********************************************************************

gen S3_24_3 = 0 if S3_24_1 != . 

label var S3_24_3 "Examen gynécologie"

order S3_24_3, after(S3_24_2)

label value S3_24_3 S3_24_1

replace S3_24_3  = 1 if S3_24a  == "Examen gynécologie"
replace S3_24_3  = 1 if S3_24a  == "Examen gynécologique"
replace S3_24_3  = 1 if S3_24a  == "Examen gynécologique"
replace S3_24_3  = 1 if S3_24a  == "Examen gynécologique"
replace S3_24_3  = 1 if S3_24a  == "Examen gynécologique et physique"
replace S3_24_3  = 1 if S3_24a  == "Gynécologique"
replace S3_24_3  = 1 if S3_24a  == "Obstétrical"

replace S3_24_96  = 0 if S3_24a  == "Examen gynécologie"
replace S3_24_96  = 0 if S3_24a  == "Examen gynécologique"
replace S3_24_96  = 0 if S3_24a  == "Examen gynécologique"
replace S3_24_96  = 0 if S3_24a  == "Examen gynécologique"
replace S3_24_96  = 0 if S3_24a  == "Examen gynécologique et physique"
replace S3_24_96  = 0 if S3_24a  == "Gynécologique"
replace S3_24_96  = 0 if S3_24a  == "Obstétrical"

replace S3_24a  = "" if S3_24a  == "Examen gynécologie"
replace S3_24a  = "" if S3_24a  == "Examen gynécologique"
replace S3_24a  = "" if S3_24a  == "Examen gynécologique"
replace S3_24a  = "" if S3_24a  == "Examen gynécologique"
replace S3_24a  = "" if S3_24a  == "Examen gynécologique et physique"
replace S3_24a  = "" if S3_24a  == "Gynécologique"
replace S3_24a  = "" if S3_24a  == "Obstétrical"


drop S3_24 



foreach var of var S3_24_1 S3_24_2 S3_24_3 S3_24_96 S3_24_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}

rename S3_24_1 p3_24a
rename S3_24_2 p3_24b
rename S3_24_3 p3_24c
rename S3_24_96 p3_24x
rename S3_24_9 p3_24y
rename S3_24a  p3_24aut


foreach x in a b c x y {
	
	foreach var of var p3_24`x' {
		replace `var' = -9 if p2_22b == 0 | p2_17 == 2
	
	}
}



********************************************************************

replace S3_25_7  = 1 if S3_25a  == "Risques hausse de tension artérielle et risques obésité"
replace S3_25_9  = 1 if S3_25a  == "Sage femme qui prenait les infos"


replace S3_25_96  = 0 if S3_25a  == "Risques hausse de tension artérielle et risques obésité"
replace S3_25_96  = 0 if S3_25a  == "Sage femme qui prenait les infos"

replace S3_25a  = "" if S3_25a  == "Risques hausse de tension artérielle et risques obésité"
replace S3_25a  = "" if S3_25a  == "Sage femme qui prenait les infos"


drop S3_25

foreach var of var S3_25_1 S3_25_2 S3_25_3 S3_25_4 S3_25_5 S3_25_6 S3_25_7 S3_25_8 S3_25_11 S3_25_10 S3_25_96 S3_25_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S3_25_1 p3_25a
rename S3_25_2 p3_25b
rename S3_25_3 p3_25c
rename S3_25_4 p3_25d
rename S3_25_5 p3_25e
rename S3_25_6 p3_25f
rename S3_25_7 p3_25g
rename S3_25_8 p3_25h
rename S3_25_11 p3_25i
rename S3_25_10 p3_25j
rename S3_25_96 p3_25x
rename S3_25_9 p3_25y
rename S3_25a  p3_25aut


foreach x in a b c d e f g h i j x y {
	
	foreach var of var p3_25`x' {
		replace `var' = -9 if p2_22b == 0 | p2_17 == 2
	
	}
}


********************************************************************

drop S3_26



foreach var of var S3_26_1 S3_26_2 S3_26_3 S3_26_4 S3_26_5 S3_26_6 S3_26_7 S3_26_8 S3_26_96 S3_26_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S3_26_1 p3_26a
rename S3_26_2 p3_26b
rename S3_26_3 p3_26c
rename S3_26_4 p3_26d
rename S3_26_5 p3_26e
rename S3_26_6 p3_26f
rename S3_26_7 p3_26g
rename S3_26_8 p3_26h
rename S3_26_96 p3_26x
rename S3_26_9 p3_26z
rename S3_26a  p3_26aut


foreach x in a b c d e f g h x z {
	
	foreach var of var p3_26`x' {
		replace `var' = -9 if p2_22b == 0 | p2_17 == 2
	
	}
}



********************************************************************

gen S3_27_6 = 0 if S3_27_1 != . 

order S3_27_6, after(S3_27_5)

label value S3_27_6 S3_27_5

replace S3_27_6  = 1 if S3_27a  == "Carnet"
replace S3_27_6  = 1 if S3_27a  == "Carte de rendez vous"
replace S3_27_6  = 1 if S3_27a  == "Carte de rendez vous"
replace S3_27_6  = 1 if S3_27a  == "Carte de rendez-vous"
replace S3_27_6  = 1 if S3_27a  == "Carte de rendez-vous"
replace S3_27_6  = 1 if S3_27a  == "Carte de suivi"
replace S3_27_6  = 1 if S3_27a  == "Carte de visite"
replace S3_27_6  = 1 if S3_27a  == "Carte de visite"
replace S3_27_6  = 1 if S3_27a  == "Carte rendez-vous"
replace S3_27_6  = 1 if S3_27a  == "Carte rendez-vous"
replace S3_27_6  = 1 if S3_27a  == "Carte rendez-vous"
replace S3_27_6  = 1 if S3_27a  == "Carte rendez-vous"
replace S3_27_6  = 1 if S3_27a  == "Carte Rendez-vous"
replace S3_27_6  = 1 if S3_27a  == "Cartes de rendez-vous"
replace S3_27_6  = 1 if S3_27a  == "Date de suivi sur la carte de suivi"
replace S3_27_6  = 1 if S3_27a  == "RV"
replace S3_27_6  = 1 if S3_27a  == "Rv"
replace S3_27_6  = 1 if S3_27a  == "Suivi Fiche"

replace S3_27_96  = 0 if S3_27a  == "Carnet"
replace S3_27_96  = 0 if S3_27a  == "Carte de rendez vous"
replace S3_27_96  = 0 if S3_27a  == "Carte de rendez vous"
replace S3_27_96  = 0 if S3_27a  == "Carte de rendez-vous"
replace S3_27_96  = 0 if S3_27a  == "Carte de rendez-vous"
replace S3_27_96  = 0 if S3_27a  == "Carte de suivi"
replace S3_27_96  = 0 if S3_27a  == "Carte de visite"
replace S3_27_96  = 0 if S3_27a  == "Carte de visite"
replace S3_27_96  = 0 if S3_27a  == "Carte rendez-vous"
replace S3_27_96  = 0 if S3_27a  == "Carte rendez-vous"
replace S3_27_96  = 0 if S3_27a  == "Carte rendez-vous"
replace S3_27_96  = 0 if S3_27a  == "Carte rendez-vous"
replace S3_27_96  = 0 if S3_27a  == "Carte Rendez-vous"
replace S3_27_96  = 0 if S3_27a  == "Cartes de rendez-vous"
replace S3_27_96  = 0 if S3_27a  == "Date de suivi sur la carte de suivi"
replace S3_27_96  = 0 if S3_27a  == "RV"
replace S3_27_96  = 0 if S3_27a  == "Rv"
replace S3_27_96  = 0 if S3_27a  == "Suivi Fiche"

replace S3_27a  = "" if S3_27a  == "Carnet"
replace S3_27a  = "" if S3_27a  == "Carte de rendez vous"
replace S3_27a  = "" if S3_27a  == "Carte de rendez vous"
replace S3_27a  = "" if S3_27a  == "Carte de rendez-vous"
replace S3_27a  = "" if S3_27a  == "Carte de rendez-vous"
replace S3_27a  = "" if S3_27a  == "Carte de suivi"
replace S3_27a  = "" if S3_27a  == "Carte de visite"
replace S3_27a  = "" if S3_27a  == "Carte de visite"
replace S3_27a  = "" if S3_27a  == "Carte rendez-vous"
replace S3_27a  = "" if S3_27a  == "Carte rendez-vous"
replace S3_27a  = "" if S3_27a  == "Carte rendez-vous"
replace S3_27a  = "" if S3_27a  == "Carte rendez-vous"
replace S3_27a  = "" if S3_27a  == "Carte Rendez-vous"
replace S3_27a  = "" if S3_27a  == "Cartes de rendez-vous"
replace S3_27a  = "" if S3_27a  == "Date de suivi sur la carte de suivi"
replace S3_27a  = "" if S3_27a  == "RV"
replace S3_27a  = "" if S3_27a  == "Rv"
replace S3_27a  = "" if S3_27a  == "Suivi Fiche"


label var S3_27_1 "Des appels téléphoniques sont effectués pour rappeler aux clientes la date de la visite de suivi"
label var S3_27_2 "Les ASC se rendent à domicile pour la visite de suivi"
label var S3_27_3 "Les ASC rappellent aux clientes la date de suivi"
label var S3_27_4 "Inscrire la date de suivi sur l'ordonnance"
label var S3_27_5 "Discuter des effets secondaires éventuels"
label var S3_27_6 "Carte de visite/rendez-vous"
label var S3_27_96 "Autres (préciser)"
label var S3_27_9 "Pas de mécanisme de suivi"

drop S3_27


foreach var of var S3_27_1 S3_27_2 S3_27_3 S3_27_4 S3_27_5 S3_27_6 S3_27_96 S3_27_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S3_27_1 p3_27a
rename S3_27_2 p3_27b
rename S3_27_3 p3_27c
rename S3_27_4 p3_27d
rename S3_27_5 p3_27e
rename S3_27_6 p3_27f
rename S3_27_96 p3_27x
rename S3_27_9 p3_27y
rename S3_27a  p3_27aut


foreach x in a b c d e f x y {
	
	foreach var of var p3_27`x' {
		replace `var' = -9 if p2_22b == 0 | p2_17 == 2
	
	}
}


********************************************************************

rename S3_28_1 p3_28a
rename S3_28_2 p3_28b
rename S3_28_3 p3_28c
rename S3_28_4 p3_28d
rename S3_28_5 p3_28e
rename S3_28_6 p3_28f
rename S3_28_7 p3_28g
rename S3_28_8 p3_28h
rename S3_28_9 p3_28i
rename S3_28_10 p3_28j
rename S3_28_11 p3_28k
rename S3_28_12 p3_28l
rename S3_28_13 p3_28m
rename S3_28_14 p3_28n
rename S3_28_15 p3_28o
rename S3_28_16 p3_28p
rename S3_28_17 p3_28q
rename S3_28_18 p3_28r
rename S3_28_19 p3_28s
rename S3_28_20 p3_28t
rename S3_28_21 p3_28u



foreach x in a b c d e f g h i j k l m n o p q r s {
	
	foreach var of var p3_28`x' {
		replace `var' = -9 if p2_22b == 0 | p2_17 == 2
	
	}
}




********************************************************************

gen S3_30_10 = 0 if S3_30_1 != . 

label var S3_30_10 "Adresse"

order S3_30_10, after(S3_30_8)

label value S3_30_10 S3_30_1

replace S3_30_10  = 1 if S3_30a  == "Adresse"
replace S3_30_10  = 1 if S3_30a  == "Adresse exacte"
replace S3_30_10  = 1 if S3_30a  == "Adresse exacte"
replace S3_30_10  = 1 if S3_30a  == "Adresse Exacte, statut sérologique"
replace S3_30_10  = 1 if S3_30a  == "Adresse téléphone"
replace S3_30_10  = 1 if S3_30a  == "Adresse, téléphone"
replace S3_30_10  = 1 if S3_30a  == "Ethnie, adresse téléphone"
replace S3_30_10  = 1 if S3_30a  == "Prénom,nom,adresse,numéro,ethnie"
replace S3_30_9  = 1 if S3_30a  == "Sage femme qui prenait les infos"
replace S3_30_10  = 1 if S3_30a  == "Terrain "



replace S3_30_96  = 0 if S3_30a  == "Adresse"
replace S3_30_96  = 0 if S3_30a  == "Adresse exacte"
replace S3_30_96  = 0 if S3_30a  == "Adresse exacte"
replace S3_30_96  = 0 if S3_30a  == "Adresse Exacte, statut sérologique"
replace S3_30_96  = 0 if S3_30a  == "Adresse téléphone"
replace S3_30_96  = 0 if S3_30a  == "Adresse, téléphone"
replace S3_30_96  = 0 if S3_30a  == "Ethnie, adresse téléphone"
replace S3_30_96  = 0 if S3_30a  == "Prénom,nom,adresse,numéro,ethnie"
replace S3_30_96  = 0 if S3_30a  == "Sage femme qui prenait les infos"
replace S3_30_96  = 0 if S3_30a  == "Terrain "


replace S3_30a  = "" if S3_30a  == "Adresse"
replace S3_30a  = "" if S3_30a  == "Adresse exacte"
replace S3_30a  = "" if S3_30a  == "Adresse exacte"
replace S3_30a  = "" if S3_30a  == "Adresse Exacte, statut sérologique"
replace S3_30a  = "" if S3_30a  == "Adresse téléphone"
replace S3_30a  = "" if S3_30a  == "Adresse, téléphone"
replace S3_30a  = "" if S3_30a  == "Ethnie, adresse téléphone"
replace S3_30a  = "" if S3_30a  == "Prénom,nom,adresse,numéro,ethnie"
replace S3_30a  = "" if S3_30a  == "Sage femme qui prenait les infos"
replace S3_30a  = "" if S3_30a  == "Terrain "


drop S3_30


foreach var of var S3_30_1 S3_30_2 S3_30_3 S3_30_4 S3_30_5 S3_30_6 S3_30_7 S3_30_8 S3_30_10 S3_30_96 S3_30_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S3_30_1 p3_30a
rename S3_30_2 p3_30b
rename S3_30_3 p3_30c
rename S3_30_4 p3_30d
rename S3_30_5 p3_30e
rename S3_30_6 p3_30f
rename S3_30_7 p3_30g
rename S3_30_8 p3_30h
rename S3_30_10 p3_30i
rename S3_30_96 p3_30x
rename S3_30_9 p3_30y
rename S3_30a  p3_30aut



foreach x in a b c d e f g h i x y {
	
	foreach var of var p3_30`x' {
		replace `var' = -9 if p2_22g == 0 | p2_17 == 2
	
	}
}


********************************************************************

drop S3_31

foreach var of var S3_31_1 S3_31_2 S3_31_3 S3_31_4 S3_31_5 S3_31_6 S3_31_7 S3_31_96 S3_31_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S3_31_1 p3_31a
rename S3_31_2 p3_31b
rename S3_31_3 p3_31c
rename S3_31_4 p3_31d
rename S3_31_5 p3_31e
rename S3_31_6 p3_31f
rename S3_31_7 p3_31g
rename S3_31_96 p3_31x
rename S3_31_9 p3_31y
rename S3_31a  p3_31aut


foreach x in a b c d e f g x y {
	
	foreach var of var p3_31`x' {
		replace `var' = -9 if p2_22g == 0 | p2_17 == 2
	
	}
}


********************************************************************


drop S3_32


foreach var of var S3_32_1 S3_32_2 S3_32_3 S3_32_4 S3_32_5 S3_32_6 S3_32_7 S3_32_96 S3_32_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S3_32_1 p3_32a
rename S3_32_2 p3_32b
rename S3_32_3 p3_32c
rename S3_32_4 p3_32d
rename S3_32_5 p3_32e
rename S3_32_6 p3_32f
rename S3_32_7 p3_32g
rename S3_32_96 p3_32x
rename S3_32_9 p3_32y
rename S3_32a  p3_32aut


foreach x in a b c d e f g x y {
	
	foreach var of var p3_32`x' {
		replace `var' = -9 if p2_22g == 0 | p2_17 == 2
	
	}
}



********************************************************************

replace S3_33_1  = 1 if S3_33a  == "Les complications liés aux méthodes déjà subi"
replace S3_33_9  = 1 if S3_33a  == "Sage femme qui prenait les infos"
replace S3_33_1  = 1 if S3_33a  == "Si connaissance de la planification familiale et laquelle"
replace S3_33_1  = 1 if S3_33a  == "Si elle a une fois utilisé l'implant"

replace S3_33_96  = 0 if S3_33a  == "Les complications liés aux méthodes déjà subi"
replace S3_33_96  = 0 if S3_33a  == "Sage femme qui prenait les infos"
replace S3_33_96  = 0 if S3_33a  == "Si connaissance de la planification familiale et laquelle"
replace S3_33_96  = 0 if S3_33a  == "Si elle a une fois utilisé l'implant"

replace S3_33a  = "" if S3_33a  == "Les complications liés aux méthodes déjà subi"
replace S3_33a  = "" if S3_33a  == "Sage femme qui prenait les infos"
replace S3_33a  = "" if S3_33a  == "Si connaissance de la planification familiale et laquelle"
replace S3_33a  = "" if S3_33a  == "Si elle a une fois utilisé l'implant"


drop S3_33

foreach var of var S3_33_1 S3_33_2 S3_33_3 S3_33_96 S3_33_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S3_33_1 p3_33a
rename S3_33_2 p3_33b
rename S3_33_3 p3_33c
rename S3_33_96 p3_33x
rename S3_33_9 p3_33y
rename S3_33a  p3_33aut


foreach x in a b c x y {
	
	foreach var of var p3_33`x' {
		replace `var' = -9 if p2_22g == 0 | p2_17 == 2
	
	}
}




********************************************************************
gen S3_34_10 = 0 if S3_34_1 != . 

label var S3_34_10 "Diabète,HTA,Maladies cardiovasculaires"

label value S3_34_10 S3_34_1

order S3_34_10, after(S3_34_8)

replace S3_34_10  = 1 if S3_34a  == "HTA"
replace S3_34_1  = 1 if S3_34a  == "Cancer"
replace S3_34_10  = 1 if S3_34a  == "Diabète "
replace S3_34_10  = 1 if S3_34a  == "Diabète hta"
replace S3_34_10  = 1 if S3_34a  == "Diabète,HTA,Maladies cardiovasculaires,"
replace S3_34_10  = 1 if S3_34a  == "HTA cardiopathies"
replace S3_34_10  = 1 if S3_34a  == "HTA diabète anémie"
replace S3_34_10  = 1 if S3_34a  == "HTA, diabète"
replace S3_34_10  = 1 if S3_34a  == "Maladie cardiaque"
replace S3_34_10  = 1 if S3_34a  == "Maladies cardiovasculaires"
replace S3_34_10  = 1 if S3_34a  == "Maladies cardiovasculaires"
replace S3_34_9  = 1 if S3_34a  == "Sage femme qui prenait les infos"
replace S3_34_6  = 1 if S3_34a  == "Vaginite inexpliquée"

replace S3_34_96  = 0 if S3_34a  == "HTA"
replace S3_34_96  = 0 if S3_34a  == "Cancer"
replace S3_34_96  = 0 if S3_34a  == "Diabète "
replace S3_34_96  = 0 if S3_34a  == "Diabète hta"
replace S3_34_96  = 0 if S3_34a  == "Diabète,HTA,Maladies cardiovasculaires,"
replace S3_34_96  = 0 if S3_34a  == "HTA cardiopathies"
replace S3_34_96  = 0 if S3_34a  == "HTA diabète anémie"
replace S3_34_96  = 0 if S3_34a  == "HTA, diabète"
replace S3_34_96  = 0 if S3_34a  == "Maladie cardiaque"
replace S3_34_96  = 0 if S3_34a  == "Maladies cardiovasculaires"
replace S3_34_96  = 0 if S3_34a  == "Maladies cardiovasculaires"
replace S3_34_96  = 0 if S3_34a  == "Sage femme qui prenait les infos"
replace S3_34_96  = 0 if S3_34a  == "Vaginite inexpliquée"

replace S3_34a  = "" if S3_34a  == "HTA"
replace S3_34a  = "" if S3_34a  == "Cancer"
replace S3_34a  = "" if S3_34a  == "Diabète "
replace S3_34a  = "" if S3_34a  == "Diabète hta"
replace S3_34a  = "" if S3_34a  == "Diabète,HTA,Maladies cardiovasculaires,"
replace S3_34a  = "" if S3_34a  == "HTA cardiopathies"
replace S3_34a  = "" if S3_34a  == "HTA diabète anémie"
replace S3_34a  = "" if S3_34a  == "HTA, diabète"
replace S3_34a  = "" if S3_34a  == "Maladie cardiaque"
replace S3_34a  = "" if S3_34a  == "Maladies cardiovasculaires"
replace S3_34a  = "" if S3_34a  == "Maladies cardiovasculaires"
replace S3_34a  = "" if S3_34a  == "Sage femme qui prenait les infos"
replace S3_34a  = "" if S3_34a  == "Vaginite inexpliquée"

drop S3_34

foreach var of var S3_34_1 S3_34_2 S3_34_3 S3_34_4 S3_34_5 S3_34_6 S3_34_7 S3_34_8 S3_34_10 S3_34_96 S3_34_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S3_34_1 p3_34a
rename S3_34_2 p3_34b
rename S3_34_3 p3_34c
rename S3_34_4 p3_34d
rename S3_34_5 p3_34e
rename S3_34_6 p3_34f
rename S3_34_7 p3_34g
rename S3_34_8 p3_34h
rename S3_34_10 p3_34i
rename S3_34_96 p3_34x
rename S3_34_9 p3_34y
rename S3_34a  p3_34aut


foreach x in a b c d e f g h i x y {
	
	foreach var of var p3_34`x' {
		replace `var' = -9 if p2_22g == 0 | p2_17 == 2
	
	}
}


********************************************************************

drop S3_35


foreach var of var S3_35_1 S3_35_2 S3_35_3 S3_35_4 S3_35_5 S3_35_6 S3_35_7 S3_35_8 S3_35_13 S3_35_10 S3_35_11 S3_35_12 S3_35_96 S3_35_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S3_35_1 p3_35a
rename S3_35_2 p3_35b
rename S3_35_3 p3_35c
rename S3_35_4 p3_35d
rename S3_35_5 p3_35e
rename S3_35_6 p3_35f
rename S3_35_7 p3_35g
rename S3_35_8 p3_35h
rename S3_35_13 p3_35i
rename S3_35_10 p3_35j
rename S3_35_11 p3_35k
rename S3_35_12 p3_35l
rename S3_35_96 p3_35x
rename S3_35_9 p3_35y
rename S3_35a  p3_35aut


foreach x in a b c d e f g h i j k l x y {
	
	foreach var of var p3_35`x' {
		replace `var' = -9 if p2_22g == 0 | p2_17 == 2
	
	}
}



********************************************************************

gen S3_36_3 = 0 if S3_36_1 != 0

order S3_36_3, after(S3_36_2)

label var S3_36_3 "Examen gynécologique et les autres appareils"

label value S3_36_3 S3_36_1

replace S3_36_1  = 1 if S3_36a  == "Bilan si elle est diabétique voir cholestérol"
replace S3_36_1  = 1 if S3_36a  == "Examen général"
replace S3_36_3  = 1 if S3_36a  == "Examen gynécologique"
replace S3_36_3  = 1 if S3_36a  == "Examen gynécologique"
replace S3_36_3  = 1 if S3_36a  == "Examen gynécologique"
replace S3_36_3  = 1 if S3_36a  == "Examen gynécologique et les autres appareils"
replace S3_36_3  = 1 if S3_36a  == "Gynécologique"
replace S3_36_3  = 1 if S3_36a  == "Gynécologique"


replace S3_36_96  = 0 if S3_36a  == "Bilan si elle est diabétique voir cholestérol"
replace S3_36_96  = 0 if S3_36a  == "Examen général"
replace S3_36_96  = 0 if S3_36a  == "Examen gynécologique"
replace S3_36_96  = 0 if S3_36a  == "Examen gynécologique"
replace S3_36_96  = 0 if S3_36a  == "Examen gynécologique"
replace S3_36_96  = 0 if S3_36a  == "Examen gynécologique et les autres appareils"
replace S3_36_96  = 0 if S3_36a  == "Gynécologique"
replace S3_36_96  = 0 if S3_36a  == "Gynécologique"



drop S3_36


foreach var of var S3_36_1 S3_36_2 S3_36_3 S3_36_96 S3_36_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S3_36_1 p3_36a
rename S3_36_2 p3_36b
rename S3_36_3 p3_36c
rename S3_36_96 p3_36x
rename S3_36_9 p3_36y
rename S3_36a  p3_36aut


foreach x in a b c x y {
	
	foreach var of var p3_36`x' {
		replace `var' = -9 if p2_22g == 0 | p2_17 == 2
	
	}
}


****************************************************************


label var S3_37_1 "Rassurez-la en lui disant qu'après la disparition de l'effet de l'anesthésie locale, elle pourrait ressentir une certaine gêne ou une douleur au niveau du site d'insertion. Ce phénomène est courant et disparaîtra sans traitement"
label var S3_37_2 "Restez dans la structure sanitaire au moins 15 à 20 minutes après l'insertion des implants"
label var S3_37_3 "Gardez le site d'insertion au sec pendant 5 jours pour éviter l'infection"
label var S3_37_4 "Retirer le pansement extérieur après 2 jours et le pansement intérieur après 5 jours lorsque la plaie est cicatrisée"
label var S3_37_5 "Évitez de toucher le site d'insertion de manière répétée ou d'exercer une pression inhabituelle sur le site, y compris en portant des poids lourds, pendant 5 jours"
label var S3_37_6 "S'attendre à des changements menstruels et ne pas ne pas s'inquiéter outre mesure"
label var S3_37_7 "Si le point de ponction devient enflammé (rouge avec une chaleur accrue ou une sensibilité) ou s'il y a du pus au point de ponction, retournez au centre de santé"
label var S3_37_8 "L'implant protège la femme contre la grossesse pendant 3 ans, après quoi elle doit le faire retirer"
label var S3_37_12 "Conseiller des visites de suivi à 6 semaines et à 3 mois"
label var S3_37_10 "Assurer à la cliente qu'elle doit se rendre au centre de santé en cas de problème"
label var S3_37_11 "Expliquer les détails de la carte d'implant et toutes les informations nécessaires qui y sont inscrites"
label var S3_37_96 "Autres (préciser)"
label var S3_37_9 "Ne donne aucune instruction"


drop S3_37


foreach var of var S3_37_1 S3_37_2 S3_37_3 S3_37_4 S3_37_5 S3_37_6 S3_37_7 S3_37_8 S3_37_12 S3_37_10 S3_37_11 S3_37_96 S3_37_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S3_37_1 p3_37a
rename S3_37_2 p3_37b
rename S3_37_3 p3_37c
rename S3_37_4 p3_37d
rename S3_37_5 p3_37e
rename S3_37_6 p3_37f
rename S3_37_7 p3_37g
rename S3_37_8 p3_37h
rename S3_37_12 p3_37i
rename S3_37_10 p3_37j
rename S3_37_11 p3_37k
rename S3_37_96 p3_37x
rename S3_37_9 p3_37z
rename S3_37a  p3_37aut


foreach x in a b c d e f g h i j k x z {
	
	foreach var of var p3_37`x' {
		replace `var' = -9 if p2_22g == 0 | p2_17 == 2
	
	}
}



****************************************************************


rename S3_38 p3_38
replace p3_38 = -9 if p2_22c == 0 | p2_17 == 2


****************************************************************

drop S3_39


foreach var of var S3_39_1 S3_39_2 S3_39_3 S3_39_4 S3_39_5 S3_39_6 S3_39_7 S3_39_96 S3_39_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S3_39_1 p3_39a
rename S3_39_2 p3_39b
rename S3_39_3 p3_39c
rename S3_39_4 p3_39d
rename S3_39_5 p3_39e
rename S3_39_6 p3_39f
rename S3_39_7 p3_39g
rename S3_39_96 p3_39x
rename S3_39_9 p3_39z
rename S3_39a  p3_39aut


foreach x in a b c d e f g x z {
	
	foreach var of var p3_39`x' {
		replace `var' = -9 if p2_22g == 0 | p2_17 == 2
	
	}
}


****************************************************************


drop S3_40


foreach var of var S3_40_1 S3_40_2 S3_40_3 S3_40_4 S3_40_5 S3_40_96 S3_40_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S3_40_1 p3_40a
rename S3_40_2 p3_40b
rename S3_40_3 p3_40c
rename S3_40_4 p3_40d
rename S3_40_5 p3_40e
rename S3_40_96 p3_40x
rename S3_40_9 p3_40z
rename S3_40a  p3_40aut


foreach x in a b c d e x z {
	
	foreach var of var p3_40`x' {
		replace `var' = -9 if p2_22g == 0 | p2_17 == 2
	
	}
}



****************************************************************

foreach var of var S3_41_1 S3_41_2 S3_41_3 S3_41_4 S3_41_5 S3_41_6 S3_41_7 S3_41_8 S3_41_9 S3_41_10 S3_41_11 S3_41_12 S3_41_13 S3_41_14 S3_41_15 S3_41_16 S3_41_17 S3_41_18 S3_41a {
	
		replace `var' = -9 if p2_22g == 0 | p2_17 == 2
	
	}
	

rename S3_41_1 p3_41a
rename S3_41_2 p3_41b
rename S3_41_3 p3_41c
rename S3_41_4 p3_41d
rename S3_41_5 p3_41e
rename S3_41_6 p3_41f
rename S3_41_7 p3_41g
rename S3_41_8 p3_41h
rename S3_41_9 p3_41i
rename S3_41_10 p3_41j
rename S3_41_11 p3_41k
rename S3_41_12 p3_41l
rename S3_41_13 p3_41m
rename S3_41_14 p3_41n
rename S3_41_15 p3_41o
rename S3_41_16 p3_41p
rename S3_41_17 p3_41q
rename S3_41_18 p3_41r
rename S3_41a p3_41aa

	
****************************************************************


****************************************************************
gen S3_43_10 = 0 if S3_43_1 != 0

order S3_43_10, after(S3_43_8)

label value S3_43_10 S3_43_1

replace S3_43_10  = 1 if S3_43a  == "Adresse exacte"
replace S3_43_10  = 1 if S3_43a  == "Téléphone adresse"
replace S3_43_10  = 1 if S3_43a  == "Téléphone, adresse, ethnie"
replace S3_43_10  = 1 if S3_43a  == "Adresse exacte"

replace S3_43_96  = 0 if S3_43a  == "Adresse exacte"
replace S3_43_96  = 0 if S3_43a  == "Téléphone adresse"
replace S3_43_96  = 0 if S3_43a  == "Téléphone, adresse, ethnie"
replace S3_43_96  = 0 if S3_43a  == "Adresse exacte"

replace S3_43a  = "" if S3_43a  == "Adresse exacte"
replace S3_43a  = "" if S3_43a  == "Téléphone adresse"
replace S3_43a  = "" if S3_43a  == "Téléphone, adresse, ethnie"
replace S3_43a  = "" if S3_43a  == "Adresse exacte"


label var S3_43_1  "Âge"
label var S3_43_2  "Situation matrimoniale"
label var S3_43_3  "Profession"
label var S3_43_4  "Religion"
label var S3_43_5  "Niveau d'étude"
label var S3_43_6  "Nombre d'enfants vivants"
label var S3_43_7  "Âge de l'enfant le plus jeune"
label var S3_43_8  "Désir d'enfant supplémentaire"
label var S3_43_10 "Téléphone/adresse exacte"
label var S3_43_96 "Autres (préciser) "
label var S3_43_9  "Ne recueille aucune information"


drop S3_43


foreach var of var S3_43_1 S3_43_2 S3_43_3 S3_43_4 S3_43_5 S3_43_6 S3_43_7 S3_43_8 S3_43_10 S3_43_96 S3_43_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S3_43_1 p3_43a
rename S3_43_2 p3_43b
rename S3_43_3 p3_43c
rename S3_43_4 p3_43d
rename S3_43_5 p3_43e
rename S3_43_6 p3_43f
rename S3_43_7 p3_43g
rename S3_43_8 p3_43h
rename S3_43_10 p3_43i
rename S3_43_96 p3_43x
rename S3_43_9 p3_43y
rename S3_43a p3_43aut


foreach x in a b c d e f g h i x y {
	
	foreach var of var p3_43`x' {
		replace `var' = -9 if p2_22h == 0 | p2_17 == 2
	
	}
}



********************************************************************


drop S3_44 


foreach var of var S3_44_1 S3_44_2 S3_44_3 S3_44_4 S3_44_5 S3_44_6 S3_44_7 S3_44_96 S3_44_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}



rename S3_44_1 p3_44a
rename S3_44_2 p3_44b
rename S3_44_3 p3_44c
rename S3_44_4 p3_44d
rename S3_44_5 p3_44e
rename S3_44_6 p3_44f
rename S3_44_7 p3_44g
rename S3_44_96 p3_44x
rename S3_44_9 p3_44y
rename S3_44a p3_44aut


foreach x in a b c d e f g x y {
	
	foreach var of var p3_44`x' {
		replace `var' = -9 if p2_22h == 0 | p2_17 == 2
	
	}
}


********************************************************************

drop S3_45

foreach var of var S3_45_1 S3_45_2 S3_45_3 S3_45_4 S3_45_5 S3_45_6 S3_45_7 S3_45_96 S3_45_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S3_45_1 p3_45a
rename S3_45_2 p3_45b
rename S3_45_3 p3_45c
rename S3_45_4 p3_45d
rename S3_45_5 p3_45e
rename S3_45_6 p3_45f
rename S3_45_7 p3_45g
rename S3_45_96 p3_45x
rename S3_45_9 p3_45y
rename S3_45a p3_45aut

foreach x in a b c d e f g x y {
	
	foreach var of var p3_45`x' {
		replace `var' = -9 if p2_22h == 0 | p2_17 == 2
	
	}
}


********************************************************************


drop S3_46

foreach var of var S3_46_1 S3_46_2 S3_46_3 S3_46_96 S3_46_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}

rename S3_46_1 p3_46a
rename S3_46_2 p3_46b
rename S3_46_3 p3_46c
rename S3_46_96 p3_46x
rename S3_46_9 p3_46y
rename S3_46a p3_46aut

foreach x in a b c x y {
	
	foreach var of var p3_46`x' {
		replace `var' = -9 if p2_22h == 0 | p2_17 == 2
	
	}
}



********************************************************************


drop S3_47

foreach var of var S3_47_1 S3_47_2 S3_47_3 S3_47_4 S3_47_5 S3_47_6 S3_47_7 S3_47_8 S3_47_19 S3_47_10 S3_47_11 S3_47_12 S3_47_13 S3_47_14 S3_47_15 S3_47_16 S3_47_17 S3_47_18 S3_47_96 S3_47_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}



rename S3_47_1 p3_47a
rename S3_47_2 p3_47b
rename S3_47_3 p3_47c
rename S3_47_4 p3_47d
rename S3_47_5 p3_47e
rename S3_47_6 p3_47f
rename S3_47_7 p3_47g
rename S3_47_8 p3_47h
rename S3_47_19 p3_47i
rename S3_47_10 p3_47j
rename S3_47_11 p3_47k
rename S3_47_12 p3_47l
rename S3_47_13 p3_47m
rename S3_47_14 p3_47n
rename S3_47_15 p3_47o
rename S3_47_16 p3_47p
rename S3_47_17 p3_47q
rename S3_47_18 p3_47r
rename S3_47_96 p3_47x
rename S3_47_9 p3_47y
rename S3_47a p3_47aut


foreach x in a b c d e f g h i j k l m n o p q r x y {
	
	foreach var of var p3_47`x' {
		
		replace `var' = -9 if p2_22h == 0 | p2_17 == 2
	
	}
}





*******************************************************************

label var S3_48_1 "Tension artérielle élevée (>160/100 mm hg)"
label var S3_48_2 "Maladie cardiaque compliquée"
label var S3_48_3 "Troubles de la coagulation"
label var S3_48_4 "Maladie pulmonaire chronique"
label var S3_48_5 "Endométriose"
label var S3_48_6 "Tuberculose pelvienne"
label var S3_48_7 "Fixation de l'utérus due à une intervention chirurgicale antérieure ou à une infection"
label var S3_48_8 "Hernie de la paroi abdominale ou de l'ombilic"
label var S3_48_14 "Rupture/perforation utérine post-partum ou post-avortement"
label var S3_48_10 "Complications associées au diabète"
label var S3_48_11 "Hyperthyroïdie"
label var S3_48_12 "Cirrhose grave"
label var S3_48_13 "SIDA"
label var S3_48_96 "Autres (préciser)"
label var S3_48_9 "Ne sais pas"
label var S3_48a "Préciser"

drop S3_48

foreach var of var S3_48_1 S3_48_2 S3_48_3 S3_48_4 S3_48_5 S3_48_6 S3_48_7 S3_48_8 S3_48_14 S3_48_10 S3_48_11 S3_48_12 S3_48_13 S3_48_96 S3_48_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S3_48_1 p3_48a
rename S3_48_2 p3_48b
rename S3_48_3 p3_48c
rename S3_48_4 p3_48d
rename S3_48_5 p3_48e
rename S3_48_6 p3_48f
rename S3_48_7 p3_48g
rename S3_48_8 p3_48h
rename S3_48_14 p3_48i
rename S3_48_10 p3_48j
rename S3_48_11 p3_48k
rename S3_48_12 p3_48l
rename S3_48_13 p3_48m
rename S3_48_96 p3_48x
rename S3_48_9 p3_48y
rename S3_48a p3_48aut


foreach x in a b c d e f g h i j k l m x y {
	
	foreach var of var p3_48`x' {
		replace `var' = -9 if p2_22h == 0 | p2_17 == 2
	
	}
}


********************************************************************


drop S3_49

foreach var of var S3_49_1 S3_49_2 S3_49_3 S3_49_4 S3_49_5 S3_49_6 S3_49_7 S3_49_8 S3_49_14 S3_49_10 S3_49_11 S3_49_12 S3_49_13 S3_49_96 S3_49_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}

rename S3_49_1 p3_49a
rename S3_49_2 p3_49b
rename S3_49_3 p3_49c
rename S3_49_4 p3_49d
rename S3_49_5 p3_49e
rename S3_49_6 p3_49f
rename S3_49_7 p3_49g
rename S3_49_8 p3_49h
rename S3_49_14 p3_49i
rename S3_49_10 p3_49j
rename S3_49_11 p3_49k
rename S3_49_12 p3_49l
rename S3_49_13 p3_49m
rename S3_49_96 p3_49x
rename S3_49_9 p3_49y
rename S3_49a p3_49aut


foreach x in a b c d e f g h i j k l m x y {
	
	foreach var of var p3_49`x' {
		replace `var' = -9 if p2_22h == 0 | p2_17 == 2
	
	}
}


********************************************************************



drop S3_50

foreach var of var S3_50_1 S3_50_2 S3_50_3 S3_50_4 S3_50_5 S3_50_6 S3_50_7 S3_50_8 S3_50_23 S3_50_10 S3_50_11 S3_50_12 S3_50_13 S3_50_14 S3_50_15 S3_50_16 S3_50_17 S3_50_18 S3_50_19 S3_50_20 S3_50_21 S3_50_22 S3_50_96 S3_50_9 S3_50_99 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}

rename S3_50_1 p3_50a
rename S3_50_2 p3_50b
rename S3_50_3 p3_50c
rename S3_50_4 p3_50d
rename S3_50_5 p3_50e
rename S3_50_6 p3_50f
rename S3_50_7 p3_50g
rename S3_50_8 p3_50h
rename S3_50_23 p3_50i
rename S3_50_10 p3_50j
rename S3_50_11 p3_50k
rename S3_50_12 p3_50l
rename S3_50_13 p3_50m
rename S3_50_14 p3_50n
rename S3_50_15 p3_50o
rename S3_50_16 p3_50p
rename S3_50_17 p3_50q
rename S3_50_18 p3_50r
rename S3_50_19 p3_50s
rename S3_50_20 p3_50t
rename S3_50_21 p3_50u
rename S3_50_22 p3_50v
rename S3_50_96 p3_50x
rename S3_50_9 p3_50y
rename S3_50_99 p3_50z
rename S3_50a p3_50aut


foreach x in a b c d e f g h i j k l m n o p q r s t u v x y z {
	
	foreach var of var p3_50`x' {
		replace `var' = -9 if p2_22h == 0 | p2_17 == 2
	
	}
}




********************************************************************
gen S3_51_4 = 0 if S3_51_1 != 0 | S3_51_1 != .

order S3_51_4, after(S3_51_3)


label value S3_51_4 S3_51_1

replace S3_51_4  = 1 if S3_51a  == "Bilan pré op ,TP,TCK,GSRH"
replace S3_51_4  = 1 if S3_51a  == "Crase sanguine,GSRH"
replace S3_51_4  = 1 if S3_51a  == "TP tck"
replace S3_51_4  = 1 if S3_51a  == "TP TCK GSRH"

replace S3_51_96  = 0 if S3_51a  == "Bilan pré op ,TP,TCK,GSRH"
replace S3_51_96  = 0 if S3_51a  == "Crase sanguine,GSRH"
replace S3_51_96  = 0 if S3_51a  == "TP tck"
replace S3_51_96  = 0 if S3_51a  == "TP TCK GSRH"

replace S3_51a  = "" if S3_51a  == "Bilan pré op ,TP,TCK,GSRH"
replace S3_51a  = "" if S3_51a  == "Crase sanguine,GSRH"
replace S3_51a  = "" if S3_51a  == "TP tck"
replace S3_51a  = "" if S3_51a  == "TP TCK GSRH"

label var S3_51_1 "Analyse de sang pour l'hémoglobine"
label var S3_51_2 "Analyse d'urine pour le sucre et l'albumine"
label var S3_51_3 "Test de grossesse"
label var S3_51_4 "Bilan pré op ,TP,TCK,GSRH"
label var S3_51_96 "Autres (préciser)"
label var S3_51_9 "Ne prescrit aucun test"
label var S3_51a "Préciser"

drop S3_51

foreach var of var S3_51_1 S3_51_2 S3_51_3 S3_51_4 S3_51_96 S3_51_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}

rename S3_51_1 p3_51a
rename S3_51_2 p3_51b
rename S3_51_3 p3_51c
rename S3_51_4 p3_51d
rename S3_51_96 p3_51x
rename S3_51_9 p3_51y
rename S3_51a p3_51aut


foreach x in a b c d x y {
	
	foreach var of var p3_51`x' {
		replace `var' = -9 if p2_22h == 0 | p2_17 == 2
	
	}
}


******************************************************************

rename S3_52 p3_52
rename S3_52a p3_52aut

******************************************************************



drop S3_53

foreach var of var S3_53_1 S3_53_2 S3_53_3 S3_53_4 S3_53_96 S3_53_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}

rename S3_53_1 p3_53a
rename S3_53_2 p3_53b
rename S3_53_3 p3_53c
rename S3_53_4 p3_53d
rename S3_53_96 p3_53x
rename S3_53_9 p3_53y
rename S3_53a p3_53aut


foreach x in a b c d x y {
	
	foreach var of var p3_53`x' {
		replace `var' = -9 if p2_22h == 0 | p2_17 == 2
	
	}
}


******************************************************************

drop S3_54

foreach var of var S3_54_1 S3_54_2 S3_54_3 S3_54_4 S3_54_5 S3_54_6 S3_54_7 S3_54_8 S3_54_11 S3_54_10 S3_54_96 S3_54_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}

rename S3_54_1 p3_54a
rename S3_54_2 p3_54b
rename S3_54_3 p3_54c
rename S3_54_4 p3_54d
rename S3_54_5 p3_54e
rename S3_54_6 p3_54f
rename S3_54_7 p3_54g
rename S3_54_8 p3_54h
rename S3_54_11 p3_54i
rename S3_54_10 p3_54j
rename S3_54_96 p3_54x
rename S3_54_9 p3_54y
rename S3_54a p3_54aut


foreach x in a b c d e f g h i j x y {
	
	foreach var of var p3_54`x' {
		replace `var' = -9 if p2_22h == 0 | p2_17 == 2
	
	}
}


******************************************************************

rename S3_55 p3_55

*****************************************************************

drop S3_56

foreach var of var S3_56_1 S3_56_2 S3_56_3 S3_56_4 S3_56_5 S3_56_6 S3_56_7 S3_56_8 S3_56_96 S3_56_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}

rename S3_56_1 p3_56a
rename S3_56_2 p3_56b
rename S3_56_3 p3_56c
rename S3_56_4 p3_56d
rename S3_56_5 p3_56e
rename S3_56_6 p3_56f
rename S3_56_7 p3_56g
rename S3_56_8 p3_56h
rename S3_56_96 p3_56x
rename S3_56_9 p3_56y
rename S3_56a p3_56aut


foreach x in a b c d e f g h x y {
	
	foreach var of var p3_56`x' {
		replace `var' = -9 if p2_22h == 0 | p2_17 == 2
	
	}
}



******************************************************************

gen S3_57_5 = 0 if S3_57_1 != 0

order S3_57_5, after(S3_57_4)

label value S3_57_5 S3_57_1

replace S3_57_5  = 1 if S3_57a  == "Carte de rendez-vous"
replace S3_57_5  = 1 if S3_57a  == "Carte de rendez-vous"
replace S3_57_5  = 1 if S3_57a  == "Carte de visite"
replace S3_57_5  = 1 if S3_57a  == "Carte Rendez vous"
replace S3_57_5  = 1 if S3_57a  == "Carte rendez-vous"
replace S3_57_5  = 1 if S3_57a  == "Cartes de rendez-vous et le dossier médical du patient"
replace S3_57_5  = 1 if S3_57a  == "Inscrire dans les cartes de rendez-vous ou écrire la date dans le carnet"
replace S3_57_5  = 1 if S3_57a  == "Rendez vous"
replace S3_57_5  = 1 if S3_57a  == "Sur les cartes de rendez-vous"

replace S3_57_96  = 0 if S3_57a  == "Carte de rendez-vous"
replace S3_57_96  = 0 if S3_57a  == "Carte de rendez-vous"
replace S3_57_96  = 0 if S3_57a  == "Carte de visite"
replace S3_57_96  = 0 if S3_57a  == "Carte Rendez vous"
replace S3_57_96  = 0 if S3_57a  == "Carte rendez-vous"
replace S3_57_96  = 0 if S3_57a  == "Cartes de rendez-vous et le dossier médical du patient"
replace S3_57_96  = 0 if S3_57a  == "Inscrire dans les cartes de rendez-vous ou écrire la date dans le carnet"
replace S3_57_96  = 0 if S3_57a  == "Rendez vous"
replace S3_57_96  = 0 if S3_57a  == "Sur les cartes de rendez-vous"

replace S3_57a  = "" if S3_57a  == "Carte de rendez-vous"
replace S3_57a  = "" if S3_57a  == "Carte de rendez-vous"
replace S3_57a  = "" if S3_57a  == "Carte de visite"
replace S3_57a  = "" if S3_57a  == "Carte Rendez vous"
replace S3_57a  = "" if S3_57a  == "Carte rendez-vous"
replace S3_57a  = "" if S3_57a  == "Cartes de rendez-vous et le dossier médical du patient"
replace S3_57a  = "" if S3_57a  == "Inscrire dans les cartes de rendez-vous ou écrire la date dans le carnet"
replace S3_57a  = "" if S3_57a  == "Rendez vous"
replace S3_57a  = "" if S3_57a  == "Sur les cartes de rendez-vous"

label var S3_57_1 "Des appels téléphoniques sont effectués pour rappeler aux clientes la date de la visite de suivi"
label var S3_57_2 "Les ASC se rendent à domicile pour la visite de suivi"
label var S3_57_3 "Les ASC rappellent aux clientes la date de suivi "
label var S3_57_4 "Inscription de la date de suivi sur l'ordonnance"
label var S3_57_5 "Carte de rendez-vous"
label var S3_57_96 "Autres (à préciser)"
label var S3_57_9 "Pas de mécanisme de suivi"
label var S3_57_99 "Ne sais pas"
label var S3_57a "Préciser"

drop S3_57

foreach var of var S3_57_1 S3_57_2 S3_57_3 S3_57_4 S3_57_96 S3_57_9 S3_57_99 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}

rename S3_57_1 p3_57a
rename S3_57_2 p3_57b
rename S3_57_3 p3_57c
rename S3_57_4 p3_57d
rename S3_57_5 p3_57e
rename S3_57_96 p3_57x
rename S3_57_9 p3_57y
rename S3_57_99 p3_57z
rename S3_57a p3_57aut


foreach x in a b c d e x y z {
	
	foreach var of var p3_57`x' {
		replace `var' = -9 if p2_22h == 0 | p2_17 == 2
	
	}
}


*******************************************************************

rename S3_58_1 p3_58a
rename S3_58_2 p3_58b
rename S3_58_3 p3_58c
rename S3_58_4 p3_58d
rename S3_58_5 p3_58e
rename S3_58_6 p3_58f
rename S3_58_7 p3_58g
rename S3_58_8 p3_58h
rename S3_58_9 p3_58i
rename S3_58_10 p3_58j
rename S3_58_11 p3_58k
rename S3_58_12 p3_58l
rename S3_58_13 p3_58m
rename S3_58_14 p3_58n
rename S3_58_15 p3_58o
rename S3_58_16 p3_58p
rename S3_58_17 p3_58q
rename S3_58_18 p3_58r



foreach x in a b c d e f g h i j k l m n o p q r {
	
	foreach var of var p3_58`x' {
		replace `var' = -9 if p2_22h == 0 | p2_17 == 2
	
	}
}



*******************************************************************

drop S3_58a 

foreach var of var S3_58a_1 S3_58a_2 S3_58a_3 S3_58a_4 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}

label var S3_58a_1 "Elle est réversible avec un taux de réussite élevé"
label var S3_58a_2 "Il nécessite une intervention chirurgicale pour les hommes et les femmes"
label var S3_58a_3 "Il offre une protection contre les IST"
label var S3_58a_4 "Il convient à la contraception temporaire"

rename S3_58a_1 p3_58aa
rename S3_58a_2 p3_58ab
rename S3_58a_3 p3_58ac
rename S3_58a_4 p3_58ad



foreach x in a b c d {
	
	foreach var of var p3_58a`x' {
		replace `var' = -9 if p2_22h == 0 | p2_17 == 2
	
	}
}



*******************************************************************



drop S3_60

foreach var of var S3_60_1 S3_60_2 S3_60_3 S3_60_4 S3_60_5 S3_60_6 S3_60_7 S3_60_8 S3_60_96 S3_60_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S3_60_1 p3_60a
rename S3_60_2 p3_60b
rename S3_60_3 p3_60c
rename S3_60_4 p3_60d
rename S3_60_5 p3_60e
rename S3_60_6 p3_60f
rename S3_60_7 p3_60g
rename S3_60_8 p3_60h
rename S3_60_96 p3_60x
rename S3_60_9 p3_60y
rename S3_60a p3_60aut



foreach x in a b c d e f g h x y {
	
	foreach var of var p3_60`x' {
		replace `var' = -9 if p2_22i == 0 | p2_17 == 2
	
	}
}


*******************************************************************


drop S3_61

foreach var of var S3_61_1 S3_61_2 S3_61_3 S3_61_4 S3_61_5 S3_61_96 S3_61_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S3_61_1 p3_61a
rename S3_61_2 p3_61b
rename S3_61_3 p3_61c
rename S3_61_4 p3_61d
rename S3_61_5 p3_61e
rename S3_61_96 p3_61x
rename S3_61_9 p3_61y
rename S3_61a p3_61aut



foreach x in a b c d e x y {
	
	foreach var of var p3_61`x' {
		replace `var' = -9 if p2_22i == 0 | p2_17 == 2
	
	}
}


*******************************************************************

drop S3_62

foreach var of var S3_62_1 S3_62_2 S3_62_3 S3_62_4 S3_62_5 S3_62_6 S3_62_96 S3_62_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S3_62_1 p3_62a
rename S3_62_2 p3_62b
rename S3_62_3 p3_62c
rename S3_62_4 p3_62d
rename S3_62_5 p3_62e
rename S3_62_6 p3_62f
rename S3_62_96 p3_62x
rename S3_62_9 p3_62y
rename S3_62a p3_62aut



foreach x in a b c d e f x y {
	
	foreach var of var p3_62`x' {
		replace `var' = -9 if p2_22i == 0 | p2_17 == 2
	
	}
}


*******************************************************************

drop S3_63

foreach var of var S3_63_1 S3_63_2 S3_63_3 S3_63_4 S3_63_5 S3_63_6 S3_63_7 S3_63_96 S3_63_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S3_63_1 p3_63a
rename S3_63_2 p3_63b
rename S3_63_3 p3_63c
rename S3_63_4 p3_63d
rename S3_63_5 p3_63e
rename S3_63_6 p3_63f
rename S3_63_7 p3_63g
rename S3_63_96 p3_63x
rename S3_63_9 p3_63y
rename S3_63a p3_63aut



foreach x in a b c d e f g x y {
	
	foreach var of var p3_63`x' {
		replace `var' = -9 if p2_22i == 0 | p2_17 == 2
	
	}
}


*******************************************************************

drop S3_64

foreach var of var S3_64_1 S3_64_2 S3_64_3 S3_64_4 S3_64_5 S3_64_6 S3_64_7 S3_64_8 S3_64_16 S3_64_10 S3_64_11 S3_64_12 S3_64_13 S3_64_14 S3_64_15 S3_64_96 S3_64_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S3_64_1 p3_64a
rename S3_64_2 p3_64b
rename S3_64_3 p3_64c
rename S3_64_4 p3_64d
rename S3_64_5 p3_64e
rename S3_64_6 p3_64f
rename S3_64_7 p3_64g
rename S3_64_8 p3_64h
rename S3_64_16 p3_64i
rename S3_64_10 p3_64j
rename S3_64_11 p3_64k
rename S3_64_12 p3_64l
rename S3_64_13 p3_64m
rename S3_64_14 p3_64n
rename S3_64_15 p3_64o
rename S3_64_96 p3_64x
rename S3_64_9 p3_64y
rename S3_64a p3_64aut



foreach x in a b c d e f g h i j k l m n o x y {
	
	foreach var of var p3_64`x' {
		
		replace `var' = -9 if p2_22i == 0 | p2_17 == 2
	
	}
}


*******************************************************************

rename S3_65 p3_65
rename S3_66 p3_66

foreach var of var p3_65 p3_66 {
		
		replace `var' = -9 if p2_22i == 0 | p2_17 == 2
	
	}

*******************************************************************

drop S3_67

foreach var of var S3_67_1 S3_67_2 S3_67_96 S3_67_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S3_67_1 p3_67a
rename S3_67_2 p3_67b
rename S3_67_96 p3_67x
rename S3_67_9 p3_67y
rename S3_67a p3_67aut



foreach x in a b x y {
	
	foreach var of var p3_67`x' {
		replace `var' = -9 if p2_22i == 0 | p2_17 == 2
	
	}
}


*******************************************************************

drop S3_68

foreach var of var S3_68_1 S3_68_2 S3_68_3 S3_68_4 S3_68_5 S3_68_6 S3_68_7 S3_68_8 S3_68_14 S3_68_10 S3_68_11 S3_68_12 S3_68_13 S3_68_96 S3_68_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S3_68_1 p3_68a
rename S3_68_2 p3_68b
rename S3_68_3 p3_68c
rename S3_68_4 p3_68d
rename S3_68_5 p3_68e
rename S3_68_6 p3_68f
rename S3_68_7 p3_68g
rename S3_68_8 p3_68h
rename S3_68_14 p3_68i
rename S3_68_10 p3_68j
rename S3_68_11 p3_68k
rename S3_68_12 p3_68l
rename S3_68_13 p3_68m
rename S3_68_96 p3_68x
rename S3_68_9 p3_68y
rename S3_68a p3_68aut



foreach x in a b c d e f g h i j k l m x y {
	
	foreach var of var p3_68`x' {
		replace `var' = -9 if p2_22i == 0 | p2_17 == 2
	
	}
}


*******************************************************************

rename S3_69 p3_69

replace p3_69=-9 if p2_22i == 0 | p2_17 == 2


*******************************************************************

drop S3_70

foreach var of var S3_70_1 S3_70_2 S3_70_3 S3_70_4 S3_70_5 S3_70_6 S3_70_96 S3_70_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S3_70_1 p3_70a
rename S3_70_2 p3_70b
rename S3_70_3 p3_70c
rename S3_70_4 p3_70d
rename S3_70_5 p3_70e
rename S3_70_6 p3_70f
rename S3_70_96 p3_70x
rename S3_70_9 p3_70y
rename S3_70a p3_70aut



foreach x in a b c d e f x y {
	
	foreach var of var p3_70`x' {
		replace `var' = -9 if p2_22i == 0 | p2_17 == 2 | p3_69 == 2
	
	}
}


*******************************************************************

drop S3_71

foreach var of var S3_71_1 S3_71_2 S3_71_3 S3_71_4 S3_71_96 S3_71_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S3_71_1 p3_71a
rename S3_71_2 p3_71b
rename S3_71_3 p3_71c
rename S3_71_4 p3_71d
rename S3_71_96 p3_71x
rename S3_71_9 p3_71y
rename S3_71a p3_71aut



foreach x in a b c d x y {
	
	foreach var of var p3_71`x' {
		replace `var' = -9 if p2_22i == 0 | p2_17 == 2 | p3_69 == 2
	
	}
}


*******************************************************************

rename S3_72 p3_72

replace p3_72=-9 if p2_22i == 0 | p2_17 == 2


*******************************************************************

drop S3_73

label var S3_73_1 "Des appels téléphoniques sont effectués pour rappeler aux clients la date du suivi"
label var S3_73_2 "Les ASC se rendent à domicile pour la visite de suivi"
label var S3_73_3 "Les ASC rappellent aux clients la date de suivi"
label var S3_73_4 "Inscription de la date de suivi sur l'ordonnance"
label var S3_73_96 "Autres (à préciser)"
label var S3_73_9 "Pas de mécanisme de suivi"
label var S3_73_99 "Ne sais pas"
label var S3_73a "Préciser"

foreach var of var S3_73_1 S3_73_2 S3_73_3 S3_73_4 S3_73_96 S3_73_9 S3_73_99 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S3_73_1 p3_73a
rename S3_73_2 p3_73b
rename S3_73_3 p3_73c
rename S3_73_4 p3_73d
rename S3_73_96 p3_73x
rename S3_73_9 p3_73y
rename S3_73_99 p3_73z
rename S3_73a p3_73aut


foreach x in a b c d x y z {
	
	foreach var of var p3_73`x' {
		replace `var' = -9 if p2_22i == 0 | p2_17 == 2
	
	}
}


*******************************************************************


rename S3_74_1 p3_74a
rename S3_74_2 p3_74b
rename S3_74_3 p3_74c
rename S3_74_4 p3_74d
rename S3_74_5 p3_74e
rename S3_74_6 p3_74f
rename S3_74_7 p3_74g
rename S3_74_8 p3_74h


foreach x in a b c d e f g h {
	
	foreach var of var p3_74`x' {
		replace `var' = -9 if p2_22i == 0 | p2_17 == 2
	
	}
}





************************************** SECTION 4
									  ***********



rename S4_1_1 p4_1a
rename S4_1_2 p4_1b
rename S4_1_3 p4_1c
rename S4_1_4 p4_1d
rename S4_1_5 p4_1e
rename S4_1_6 p4_1f
rename S4_1_7 p4_1g
rename S4_1_8 p4_1h
rename S4_1_9 p4_1i
rename S4_1_10 p4_1j
rename S4_1_11 p4_1k
rename S4_1_12 p4_1l

***********************************************************************

rename S4_3_1 p4_3a
rename S4_3_2 p4_3b
rename S4_3_3 p4_3c
rename S4_3_4 p4_3d
rename S4_3_5 p4_3e
rename S4_3_6 p4_3f
rename S4_3_7 p4_3g
rename S4_3_8 p4_3h
rename S4_3_9 p4_3i
rename S4_3_10 p4_3j
rename S4_3_11 p4_3k

foreach x in a b c d e f g h i j k {
	
	foreach var of var p4_3`x' {
		replace `var' = -9 if p2_22a == 0 | p2_17 == 2
	
	}
}

***********************************************************************


rename S4_5_1 p4_5a
rename S4_5_2 p4_5b
rename S4_5_3 p4_5c
rename S4_5_4 p4_5d
rename S4_5_5 p4_5e
rename S4_5_6 p4_5f
rename S4_5_7 p4_5g
rename S4_5_8 p4_5h
rename S4_5_9 p4_5i
rename S4_5_10 p4_5j

foreach x in a b c d e f g h i j {
	
	foreach var of var p4_5`x' {
		replace `var' = -9 if p2_22b == 0 | p2_17 == 2
	
	}
}


***********************************************************************

rename S4_7_1 p4_7a
rename S4_7_2 p4_7b
rename S4_7_3 p4_7c
rename S4_7_4 p4_7d
rename S4_7_5 p4_7e
rename S4_7_6 p4_7f
rename S4_7_7 p4_7g
rename S4_7_8 p4_7h
rename S4_7_9 p4_7i
rename S4_7_10 p4_7j

foreach x in a b c d e f g h i j {
	
	foreach var of var p4_7`x' {
		replace `var' = -9 if p2_22g == 0 | p2_17 == 2
	
	}
}

***********************************************************************

rename S4_9_1 p4_9a
rename S4_9_2 p4_9b
rename S4_9_3 p4_9c
rename S4_9_4 p4_9d
rename S4_9_5 p4_9e
rename S4_9_6 p4_9f

foreach x in a b c d e f {
	
	foreach var of var p4_9`x' {
		replace `var' = -9 if p2_22f == 0 | p2_17 == 2
	
	}
}



***********************************************************************

drop S4_9a 

label var S4_9a_1 "Prendre deux comprimés à la fois si elle oublie une dose"
label var S4_9a_2 "Arrêter immédiatement la pilule si elle ressent des effets secondaires"
label var S4_9a_3 "Utiliser des préservatifs comme méthode d'appoint pendant le premier mois d'utilisation de la pilule"
label var S4_9a_4 "Sauter les pilules placebo pour éviter les menstruations"

rename S4_9a_1 p4_9aa
rename S4_9a_2 p4_9ab
rename S4_9a_3 p4_9ac
rename S4_9a_4 p4_9ad

foreach x in a b c d {
	
	foreach var of var p4_9a`x' {
		
		replace `var' = -9 if p2_22f == 0 | p2_17 == 2
	
	}
}


***********************************************************************

rename S4_11_1 p4_11a
rename S4_11_2 p4_11b
rename S4_11_3 p4_11c
rename S4_11_4 p4_11d
rename S4_11_5 p4_11e
rename S4_11_6 p4_11f

foreach x in a b c d e f {
	
	foreach var of var p4_11`x' {
		replace `var' = -9 if p2_22e == 0 | p2_17 == 2
	
	}
}



***********************************************************************

drop S4_11a 

label var S4_11a_1 "Expliquer l'importance d'une contraception régulière"
label var S4_11a_2 "Évaluer le moment des rapports sexuels non protégés"
label var S4_11a_3 "Éduquer à la prévention des IST"
label var S4_11a_4 "Offrir des options de contraception à long terme"

rename S4_11a_1 p4_11aa
rename S4_11a_2 p4_11ab
rename S4_11a_3 p4_11ac
rename S4_11a_4 p4_11ad

foreach x in a b c d {
	
	foreach var of var p4_11a`x' {
		
		replace `var' = -9 if p2_22e == 0 | p2_17 == 2
	
	}
}


***********************************************************************

rename S4_13_1 p4_13a
rename S4_13_2 p4_13b
rename S4_13_3 p4_13c
rename S4_13_4 p4_13d
rename S4_13_5 p4_13e

foreach x in a b c d e {
	
	foreach var of var p4_13`x' {
		replace `var' = -9 if p2_22d == 0 | p2_17 == 2
	
	}
}

*************************************************************************


rename S4_13a p4_13aa
replace p4_13aa = -9 if p4_13aa ==.


*************************************************************************


rename S4_15_1 p4_15a
rename S4_15_2 p4_15b
rename S4_15_3 p4_15c
rename S4_15_4 p4_15d
rename S4_15_5 p4_15e
rename S4_15_6 p4_15f
rename S4_15_7 p4_15g
rename S4_15_8 p4_15h
rename S4_15_9 p4_15i

foreach x in a b c d e f g h i {
	
	foreach var of var p4_15`x' {
		replace `var' = -9 if p2_22h == 0 | p2_17 == 2
	
	}
}


************************************************************************

rename S4_17_1 p4_17a
rename S4_17_2 p4_17b
rename S4_17_3 p4_17c
rename S4_17_4 p4_17d
rename S4_17_5 p4_17e

foreach x in a b c d e {
	
	foreach var of var p4_17`x' {
		replace `var' = -9 if p2_22i == 0 | p2_17 == 2
	
	}
}



************************************************************************




************************************** SECTION 5
									  ***********

									  
									  
drop S5_1

foreach var of var S5_1_1 S5_1_2 S5_1_3 S5_1_4 S5_1_5 S5_1_6 S5_1_7 S5_1_8 S5_1_12 S5_1_10 S5_1_11 S5_1_96 S5_1_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}



rename S5_1_1 p5_1a
rename S5_1_2 p5_1b
rename S5_1_3 p5_1c
rename S5_1_4 p5_1d
rename S5_1_5 p5_1e
rename S5_1_6 p5_1f
rename S5_1_7 p5_1g
rename S5_1_8 p5_1h
rename S5_1_12 p5_1i
rename S5_1_10 p5_1j
rename S5_1_11 p5_1k
rename S5_1_96 p5_1x
rename S5_1_9 p5_1o
rename S5_1a p5_1aut
									  
									  
foreach x in a b c d e f g h i j k x o {
	
	foreach var of var p5_1`x' {
		replace `var' = -9 if p2_7 == 2
	
	}
}									  
									  
									  
*******************************************************************									  

gen S5_2_6 = 0 if  S5_2_1 != . 
gen S5_2_7 = 0 if  S5_2_1 != . 	
gen S5_2_8 = 0 if  S5_2_1 != . 



order S5_2_6 S5_2_7 S5_2_8, after(S5_2_5)

replace S5_2_7  = 1 if S5_2a  == "Poids"
replace S5_2_6  = 1 if S5_2a  == "Albuminurie ,état général"
replace S5_2_6  = 1 if S5_2a  == "Cela dépend de la conduite à tenir concernant l'urgence"
replace S5_2_6  = 1 if S5_2a  == "Conscience"
replace S5_2_6  = 1 if S5_2a  == "Conscience, TV"
replace S5_2_6  = 1 if S5_2a  == "Diagnostic très rapide"
replace S5_2_7  = 1 if S5_2a  == "Douleur atroce ,voir le degré de la dilatation,mesurer l'hauteur utérine"
replace S5_2_6  = 1 if S5_2a  == "Etat de conscience"
replace S5_2_6  = 1 if S5_2a  == "Etat général du malade"
replace S5_2_6  = 1 if S5_2a  == "Évaluer la conscience,"
replace S5_2_8  = 1 if S5_2a  == "Examen gynécologique"
replace S5_2_8  = 1 if S5_2a  == "Examen pelvien"
replace S5_2_7  = 1 if S5_2a  == "Hauteur utérine"
replace S5_2_7  = 1 if S5_2a  == "Hauteur utérine, apprécier la présentation"
replace S5_2_7  = 1 if S5_2a  == "HU"
replace S5_2_7  = 1 if S5_2a  == "HU TV"
replace S5_2_1  = 1 if S5_2a  == "La saturation de la glycémie capillaire"
replace S5_2_7  = 1 if S5_2a  == "Mesure de la hauteur utérine "
replace S5_2_8  = 1 if S5_2a  == "Ouverture col, oedème, proteinurie"
replace S5_2_8  = 1 if S5_2a  == "Paleur, vaccination, CPN, oedème"
replace S5_2_7  = 1 if S5_2a  == "Poids"
replace S5_2_7  = 1 if S5_2a  == "Poids"
replace S5_2_7  = 1 if S5_2a  == "Poids, hauteur utérine"
replace S5_2_7  = 1 if S5_2a  == "Poids, hauteur utérine"
replace S5_2_1  = 1 if S5_2a  == "Saturation "
replace S5_2_2  = 1 if S5_2a  == "Saturation, mesures de la tension, artérielle,la diirese"
replace S5_2_6  = 1 if S5_2a  == "Signe de danger"
replace S5_2_6  = 1 if S5_2a  == "Signe de déshydratation "
replace S5_2_8  = 1 if S5_2a  == "Stade du travail, dilatation"
replace S5_2_8  = 1 if S5_2a  == "TV"
replace S5_2_7  = 1 if S5_2a  == "TV, Hauteur utérine"
replace S5_2_8  = 1 if S5_2a  == "Voir si la femme commence à travailler"


replace S5_2_96  = 0 if S5_2a  == "Poids"
replace S5_2_96  = 0 if S5_2a  == "Albuminurie ,état général"
replace S5_2_96  = 0 if S5_2a  == "Cela dépend de la conduite à tenir concernant l'urgence"
replace S5_2_96  = 0 if S5_2a  == "Conscience"
replace S5_2_96  = 0 if S5_2a  == "Conscience, TV"
replace S5_2_96  = 0 if S5_2a  == "Diagnostic très rapide"
replace S5_2_96  = 0 if S5_2a  == "Douleur atroce ,voir le degré de la dilatation,mesurer l'hauteur utérine"
replace S5_2_96  = 0 if S5_2a  == "Etat de conscience"
replace S5_2_96  = 0 if S5_2a  == "Etat général du malade"
replace S5_2_96  = 0 if S5_2a  == "Évaluer la conscience,"
replace S5_2_96  = 0 if S5_2a  == "Examen gynécologique"
replace S5_2_96  = 0 if S5_2a  == "Examen pelvien"
replace S5_2_96  = 0 if S5_2a  == "Hauteur utérine"
replace S5_2_96  = 0 if S5_2a  == "Hauteur utérine, apprécier la présentation"
replace S5_2_96  = 0 if S5_2a  == "HU"
replace S5_2_96  = 0 if S5_2a  == "HU TV"
replace S5_2_96  = 0 if S5_2a  == "La saturation de la glycémie capillaire"
replace S5_2_96  = 0 if S5_2a  == "Mesure de la hauteur utérine "
replace S5_2_96  = 0 if S5_2a  == "Ouverture col, oedème, proteinurie"
replace S5_2_96  = 0 if S5_2a  == "Paleur, vaccination, CPN, oedème"
replace S5_2_96  = 0 if S5_2a  == "Poids"
replace S5_2_96  = 0 if S5_2a  == "Poids"
replace S5_2_96  = 0 if S5_2a  == "Poids, hauteur utérine"
replace S5_2_96  = 0 if S5_2a  == "Poids, hauteur utérine"
replace S5_2_96  = 0 if S5_2a  == "Saturation "
replace S5_2_96  = 0 if S5_2a  == "Saturation, mesures de la tension, artérielle,la diirese"
replace S5_2_96  = 0 if S5_2a  == "Signe de danger"
replace S5_2_96  = 0 if S5_2a  == "Signe de déshydratation "
replace S5_2_96  = 0 if S5_2a  == "Stade du travail, dilatation"
replace S5_2_96  = 0 if S5_2a  == "TV"
replace S5_2_96  = 0 if S5_2a  == "TV, Hauteur utérine"
replace S5_2_96  = 0 if S5_2a  == "Voir si la femme commence à travailler"


replace S5_2a  = "" if S5_2a  == "Poids"
replace S5_2a  = "" if S5_2a  == "Albuminurie ,état général"
replace S5_2a  = "" if S5_2a  == "Cela dépend de la conduite à tenir concernant l'urgence"
replace S5_2a  = "" if S5_2a  == "Conscience"
replace S5_2a  = "" if S5_2a  == "Conscience, TV"
replace S5_2a  = "" if S5_2a  == "Diagnostic très rapide"
replace S5_2a  = "" if S5_2a  == "Douleur atroce ,voir le degré de la dilatation,mesurer l'hauteur utérine"
replace S5_2a  = "" if S5_2a  == "Etat de conscience"
replace S5_2a  = "" if S5_2a  == "Etat général du malade"
replace S5_2a  = "" if S5_2a  == "Évaluer la conscience,"
replace S5_2a  = "" if S5_2a  == "Examen gynécologique"
replace S5_2a  = "" if S5_2a  == "Examen pelvien"
replace S5_2a  = "" if S5_2a  == "Hauteur utérine"
replace S5_2a  = "" if S5_2a  == "Hauteur utérine, apprécier la présentation"
replace S5_2a  = "" if S5_2a  == "HU"
replace S5_2a  = "" if S5_2a  == "HU TV"
replace S5_2a  = "" if S5_2a  == "La saturation de la glycémie capillaire"
replace S5_2a  = "" if S5_2a  == "Mesure de la hauteur utérine "
replace S5_2a  = "" if S5_2a  == "Ouverture col, oedème, proteinurie"
replace S5_2a  = "" if S5_2a  == "Paleur, vaccination, CPN, oedème"
replace S5_2a  = "" if S5_2a  == "Poids"
replace S5_2a  = "" if S5_2a  == "Poids"
replace S5_2a  = "" if S5_2a  == "Poids, hauteur utérine"
replace S5_2a  = "" if S5_2a  == "Poids, hauteur utérine"
replace S5_2a  = "" if S5_2a  == "Saturation "
replace S5_2a  = "" if S5_2a  == "Saturation, mesures de la tension, artérielle,la diirese"
replace S5_2a  = "" if S5_2a  == "Signe de danger"
replace S5_2a  = "" if S5_2a  == "Signe de déshydratation "
replace S5_2a  = "" if S5_2a  == "Stade du travail, dilatation"
replace S5_2a  = "" if S5_2a  == "TV"
replace S5_2a  = "" if S5_2a  == "TV, Hauteur utérine"
replace S5_2a  = "" if S5_2a  == "Voir si la femme commence à travailler"


label var S5_2_1 "Mesure du pouls maternel"
label var S5_2_2 "Mesure de la TA maternelle"
label var S5_2_3 "Mesure de la température maternelle"
label var S5_2_4 "Mesure de la fréquence respiratoire maternelle"
label var S5_2_5 "Mesure de la fréquence cardiaque fœtale"
label var S5_2_6 "État général"
label var S5_2_7 "Mesures de poids et hauteur utérine"
label var S5_2_8 "Examen clinique"
label var S5_2_96 "Autre [Préciser]"
label var S5_2_9 "Je ne sais pas "
label var S5_2a "Préciser"


drop S5_2

foreach var of var S5_2_1 S5_2_2 S5_2_3 S5_2_4 S5_2_5 S5_2_6 S5_2_7 S5_2_8 S5_2_96 S5_2_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}



rename S5_2_1 p5_2a
rename S5_2_2 p5_2b
rename S5_2_3 p5_2c
rename S5_2_4 p5_2d
rename S5_2_5 p5_2e
rename S5_2_6 p5_2f
rename S5_2_7 p5_2g
rename S5_2_8 p5_2h
rename S5_2_96 p5_2x
rename S5_2_9 p5_2o
rename S5_2a p5_2aut
									  
									  
foreach x in a b c d e f g h x o {
	
	foreach var of var p5_2`x' {
		replace `var' = -9 if p2_7 == 2
	
	}
}									  
				

********************************************************************				
				
				
rename S5_3  p5_3
rename S5_4  p5_4
rename S5_4a p5_4aut
rename S5_5  p5_5
rename S5_5a p5_5aut
rename S5_6  p5_6
rename S5_6a p5_6aut
rename S5_7  p5_7
rename S5_9  p5_9
rename S5_10 p5_10
rename S5_11 p5_11
rename S5_12 p5_12
rename S5_13 p5_13
rename S5_14 p5_14
rename S5_15 p5_15
rename S5_17 p5_17
rename S5_18 p5_18
rename S5_19 p5_19
				
				
				
foreach var of var p5_3 p5_4 p5_5 p5_6 p5_7 p5_9 p5_10 p5_11 p5_12 p5_13 p5_14 p5_15 p5_17 p5_18 p5_19 {
		
		replace `var' = -9 if p2_7 == 2
	
	}				
				



********************************************************************

replace S5_8  = 3 if S5_8a  == "100 mg"
replace S5_8  = 4 if S5_8a  == "100g maxi 200mg"
replace S5_8  = 3 if S5_8a  == "100mg"
replace S5_8  = 3 if S5_8a  == "100mg"
replace S5_8  = 4 if S5_8a  == "200mg"
replace S5_8  = 4 if S5_8a  == "200mg"
replace S5_8  = 4 if S5_8a  == "200mg/24h"
replace S5_8  = 5 if S5_8a  == "250 jusqu'à 500"
replace S5_8  = 3 if S5_8a  == "40 à 100mg/jour"
replace S5_8  = 5 if S5_8a  == "500g"
replace S5_8  = 5 if S5_8a  == "500mg"

label define S5_8 3 "100 mg" 4	"200 mg" 5	"500 mg", add

replace S5_8a  = "" if S5_8a  == "100 mg"
replace S5_8a  = "" if S5_8a  == "100g maxi 200mg"
replace S5_8a  = "" if S5_8a  == "100mg"
replace S5_8a  = "" if S5_8a  == "100mg"
replace S5_8a  = "" if S5_8a  == "200mg"
replace S5_8a  = "" if S5_8a  == "200mg"
replace S5_8a  = "" if S5_8a  == "200mg/24h"
replace S5_8a  = "" if S5_8a  == "250 jusqu'à 500"
replace S5_8a  = "" if S5_8a  == "40 à 100mg/jour"
replace S5_8a  = "" if S5_8a  == "500g"
replace S5_8a  = "" if S5_8a  == "500mg"


rename S5_8  p5_8
rename S5_8a p5_8aut

		
replace p5_8 = -9 if p2_7 == 2
	
	

********************************************************************

replace S5_16  = 2 if S5_16a  == "Souffrance fatale"
replace S5_16  = 2 if S5_16a  == "Souffrance foetale"
replace S5_16  = 2 if S5_16a  == "Souffrance fœtale"
replace S5_16  = 2 if S5_16a  == "Souffrance foetale"
replace S5_16  = 2 if S5_16a  == "Soufrance foetale aigue"
replace S5_16  = 2 if S5_16a  == "Utérus rompu,souffrance foetale"

label define S5_16 2 "Souffrance foetale", add

replace S5_16a  = "" if S5_16a  == "Souffrance fatale"
replace S5_16a  = "" if S5_16a  == "Souffrance foetale"
replace S5_16a  = "" if S5_16a  == "Souffrance fœtale"
replace S5_16a  = "" if S5_16a  == "Souffrance foetale"
replace S5_16a  = "" if S5_16a  == "Soufrance foetale aigue"
replace S5_16a  = "" if S5_16a  == "Utérus rompu,souffrance foetale"

rename S5_16  p5_16
rename S5_16a p5_16aut

		
replace p5_16 = -9 if p2_7 == 2

********************************************************************

gen S5_20_3 = 0 if S5_20_1 != . 

gen S5_20_4 = 0 if S5_20_1 != . 

gen S5_20_5 = 0 if S5_20_1 != . 

order S5_20_3 S5_20_4 S5_20_5, after(S5_20_2)



replace S5_20_3  = 1 if S5_20a  == "Abdomete"
replace S5_20_3  = 1 if S5_20a  == "Aldomet"
replace S5_20_3  = 1 if S5_20a  == "Aldomet"
replace S5_20_3  = 1 if S5_20a  == "Aldomet"
replace S5_20_3  = 1 if S5_20a  == "Aldomet"
replace S5_20_3  = 1 if S5_20a  == "Aldomet"
replace S5_20_3  = 1 if S5_20a  == "Aldomet"
replace S5_20_3  = 1 if S5_20a  == "Aldomet"
replace S5_20_3  = 1 if S5_20a  == "Aldomet"
replace S5_20_3  = 1 if S5_20a  == "Aldomet"
replace S5_20_3  = 1 if S5_20a  == "Aldomet"
replace S5_20_3  = 1 if S5_20a  == "Aldomet"
replace S5_20_3  = 1 if S5_20a  == "Aldomet"
replace S5_20_3  = 1 if S5_20a  == "Aldomet"
replace S5_20_3  = 1 if S5_20a  == "Aldomet"
replace S5_20_3  = 1 if S5_20a  == "Aldomet"
replace S5_20_3  = 1 if S5_20a  == "Aldomet "
replace S5_20_3  = 1 if S5_20a  == "Aldomet ,loxen"
replace S5_20_3  = 1 if S5_20a  == "Aldomet 500"
replace S5_20_3  = 1 if S5_20a  == "Aldomet 500mg"
replace S5_20_3  = 1 if S5_20a  == "Aldomet, nicardipine, catapressan"
replace S5_20_3  = 1 if S5_20a  == "Aldomet,loxen"
replace S5_20_3  = 1 if S5_20a  == "Aldometre 500mg"
replace S5_20_3  = 1 if S5_20a  == "Alpha methyl dopa (aldomet)"
replace S5_20_3  = 1 if S5_20a  == "L' aldomete"
replace S5_20_3  = 1 if S5_20a  == "Laldomete, la nicardipine"
replace S5_20_4  = 1 if S5_20a  == "Loxen"
replace S5_20_4  = 1 if S5_20a  == "Loxen"
replace S5_20_4  = 1 if S5_20a  == "Loxen"
replace S5_20_4  = 1 if S5_20a  == "Loxen"
replace S5_20_4  = 1 if S5_20a  == "Loxen"
replace S5_20_4  = 1 if S5_20a  == "Loxen LP 1*2/jr aldomet 500mg*3/jr"
replace S5_20_4  = 1 if S5_20a  == "Loxen ou aldomet"
replace S5_20_3  = 1 if S5_20a  == "Loxen, aldomet"
replace S5_20_3  = 1 if S5_20a  == "Methyldopa"
replace S5_20_3  = 1 if S5_20a  == "Methyldopa"
replace S5_20_3  = 1 if S5_20a  == "Methyldopa"
replace S5_20_3  = 1 if S5_20a  == "Methyldopa"
replace S5_20_3  = 1 if S5_20a  == "Methyldopa 500mg"
replace S5_20_3  = 1 if S5_20a  == "Methyldopa 500mg"
replace S5_20_3  = 1 if S5_20a  == "Methyldopa 500mg"
replace S5_20_5  = 1 if S5_20a  == "Nicadipine 20mg"
replace S5_20_5  = 1 if S5_20a  == "Nicardipine"
replace S5_20_5  = 1 if S5_20a  == "Nicardipine"
replace S5_20_5  = 1 if S5_20a  == "Nicardipine"
replace S5_20_5  = 1 if S5_20a  == "Nicardipine"
replace S5_20_5  = 1 if S5_20a  == "Nicardipine 5mg"


replace S5_20_96  = 0 if S5_20a  == "Abdomete"
replace S5_20_96  = 0 if S5_20a  == "Aldomet"
replace S5_20_96  = 0 if S5_20a  == "Aldomet"
replace S5_20_96  = 0 if S5_20a  == "Aldomet"
replace S5_20_96  = 0 if S5_20a  == "Aldomet"
replace S5_20_96  = 0 if S5_20a  == "Aldomet"
replace S5_20_96  = 0 if S5_20a  == "Aldomet"
replace S5_20_96  = 0 if S5_20a  == "Aldomet"
replace S5_20_96  = 0 if S5_20a  == "Aldomet"
replace S5_20_96  = 0 if S5_20a  == "Aldomet"
replace S5_20_96  = 0 if S5_20a  == "Aldomet"
replace S5_20_96  = 0 if S5_20a  == "Aldomet"
replace S5_20_96  = 0 if S5_20a  == "Aldomet"
replace S5_20_96  = 0 if S5_20a  == "Aldomet"
replace S5_20_96  = 0 if S5_20a  == "Aldomet"
replace S5_20_96  = 0 if S5_20a  == "Aldomet"
replace S5_20_96  = 0 if S5_20a  == "Aldomet "
replace S5_20_96  = 0 if S5_20a  == "Aldomet ,loxen"
replace S5_20_96  = 0 if S5_20a  == "Aldomet 500"
replace S5_20_96  = 0 if S5_20a  == "Aldomet 500mg"
replace S5_20_96  = 0 if S5_20a  == "Aldomet, nicardipine, catapressan"
replace S5_20_96  = 0 if S5_20a  == "Aldomet,loxen"
replace S5_20_96  = 0 if S5_20a  == "Aldometre 500mg"
replace S5_20_96  = 0 if S5_20a  == "Alpha methyl dopa (aldomet)"
replace S5_20_96  = 0 if S5_20a  == "L' aldomete"
replace S5_20_96  = 0 if S5_20a  == "Laldomete, la nicardipine"
replace S5_20_96  = 0 if S5_20a  == "Loxen"
replace S5_20_96  = 0 if S5_20a  == "Loxen"
replace S5_20_96  = 0 if S5_20a  == "Loxen"
replace S5_20_96  = 0 if S5_20a  == "Loxen"
replace S5_20_96  = 0 if S5_20a  == "Loxen"
replace S5_20_96  = 0 if S5_20a  == "Loxen LP 1*2/jr aldomet 500mg*3/jr"
replace S5_20_96  = 0 if S5_20a  == "Loxen ou aldomet"
replace S5_20_96  = 0 if S5_20a  == "Loxen, aldomet"
replace S5_20_96  = 0 if S5_20a  == "Methyldopa"
replace S5_20_96  = 0 if S5_20a  == "Methyldopa"
replace S5_20_96  = 0 if S5_20a  == "Methyldopa"
replace S5_20_96  = 0 if S5_20a  == "Methyldopa"
replace S5_20_96  = 0 if S5_20a  == "Methyldopa 500mg"
replace S5_20_96  = 0 if S5_20a  == "Methyldopa 500mg"
replace S5_20_96  = 0 if S5_20a  == "Methyldopa 500mg"
replace S5_20_96  = 0 if S5_20a  == "Nicadipine 20mg"
replace S5_20_96  = 0 if S5_20a  == "Nicardipine"
replace S5_20_96  = 0 if S5_20a  == "Nicardipine"
replace S5_20_96  = 0 if S5_20a  == "Nicardipine"
replace S5_20_96  = 0 if S5_20a  == "Nicardipine"
replace S5_20_96  = 0 if S5_20a  == "Nicardipine 5mg"


replace S5_20a  = "" if S5_20a  == "Abdomete"
replace S5_20a  = "" if S5_20a  == "Aldomet"
replace S5_20a  = "" if S5_20a  == "Aldomet"
replace S5_20a  = "" if S5_20a  == "Aldomet"
replace S5_20a  = "" if S5_20a  == "Aldomet"
replace S5_20a  = "" if S5_20a  == "Aldomet"
replace S5_20a  = "" if S5_20a  == "Aldomet"
replace S5_20a  = "" if S5_20a  == "Aldomet"
replace S5_20a  = "" if S5_20a  == "Aldomet"
replace S5_20a  = "" if S5_20a  == "Aldomet"
replace S5_20a  = "" if S5_20a  == "Aldomet"
replace S5_20a  = "" if S5_20a  == "Aldomet"
replace S5_20a  = "" if S5_20a  == "Aldomet"
replace S5_20a  = "" if S5_20a  == "Aldomet"
replace S5_20a  = "" if S5_20a  == "Aldomet"
replace S5_20a  = "" if S5_20a  == "Aldomet"
replace S5_20a  = "" if S5_20a  == "Aldomet "
replace S5_20a  = "" if S5_20a  == "Aldomet ,loxen"
replace S5_20a  = "" if S5_20a  == "Aldomet 500"
replace S5_20a  = "" if S5_20a  == "Aldomet 500mg"
replace S5_20a  = "" if S5_20a  == "Aldomet, nicardipine, catapressan"
replace S5_20a  = "" if S5_20a  == "Aldomet,loxen"
replace S5_20a  = "" if S5_20a  == "Aldometre 500mg"
replace S5_20a  = "" if S5_20a  == "Alpha methyl dopa (aldomet)"
replace S5_20a  = "" if S5_20a  == "L' aldomete"
replace S5_20a  = "" if S5_20a  == "Laldomete, la nicardipine"
replace S5_20a  = "" if S5_20a  == "Loxen"
replace S5_20a  = "" if S5_20a  == "Loxen"
replace S5_20a  = "" if S5_20a  == "Loxen"
replace S5_20a  = "" if S5_20a  == "Loxen"
replace S5_20a  = "" if S5_20a  == "Loxen"
replace S5_20a  = "" if S5_20a  == "Loxen LP 1*2/jr aldomet 500mg*3/jr"
replace S5_20a  = "" if S5_20a  == "Loxen ou aldomet"
replace S5_20a  = "" if S5_20a  == "Loxen, aldomet"
replace S5_20a  = "" if S5_20a  == "Methyldopa"
replace S5_20a  = "" if S5_20a  == "Methyldopa"
replace S5_20a  = "" if S5_20a  == "Methyldopa"
replace S5_20a  = "" if S5_20a  == "Methyldopa"
replace S5_20a  = "" if S5_20a  == "Methyldopa 500mg"
replace S5_20a  = "" if S5_20a  == "Methyldopa 500mg"
replace S5_20a  = "" if S5_20a  == "Methyldopa 500mg"
replace S5_20a  = "" if S5_20a  == "Nicadipine 20mg"
replace S5_20a  = "" if S5_20a  == "Nicardipine"
replace S5_20a  = "" if S5_20a  == "Nicardipine"
replace S5_20a  = "" if S5_20a  == "Nicardipine"
replace S5_20a  = "" if S5_20a  == "Nicardipine"
replace S5_20a  = "" if S5_20a  == "Nicardipine 5mg"


label var S5_20_1 "Comprimé Nifédipine 5-10 mg "
label var S5_20_2 "Comprimé Labétalol 100 mg "
label var S5_20_3 "Aldomet, nicardipine, catapressan"
label var S5_20_4 "Loxen LP"
label var S5_20_5 "Nicardipine"
label var S5_20_96 "Autre [Préciser]"
label var S5_20_8 "Je ne sais pas "
label var S5_20a "Préciser"


drop S5_20

foreach var of var S5_20_1 S5_20_2 S5_20_3 S5_20_4 S5_20_5 S5_20_96 S5_20_8 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}



rename S5_20_1 p5_20a
rename S5_20_2 p5_20b
rename S5_20_3 p5_20c
rename S5_20_4 p5_20d
rename S5_20_5 p5_20e
rename S5_20_96 p5_20x
rename S5_20_8 p5_20o
rename S5_20a p5_20aut
									  
									  
foreach x in a b c d e x o {
	
	foreach var of var p5_20`x' {
		replace `var' = -9 if p2_7 == 2
	
	}
}									  
				

				
******************************************************************

rename S5_21  p5_21
rename S5_21a p5_21aut
rename S5_23  p5_23
rename S5_23a p5_23aut

	
foreach var of var p5_21 p5_23 {
		
	replace `var' = -9 if p2_7 == 2
	
	}


******************************************************************


drop S5_24

foreach var of var S5_24_1 S5_24_2 S5_24_3 S5_24_4 S5_24_5 S5_24_6 S5_24_7 S5_24_96 S5_24_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}



rename S5_24_1 p5_24a
rename S5_24_2 p5_24b
rename S5_24_3 p5_24c
rename S5_24_4 p5_24d
rename S5_24_5 p5_24e
rename S5_24_6 p5_24f
rename S5_24_7 p5_24g
rename S5_24_96 p5_24x
rename S5_24_9 p5_24o
rename S5_24a p5_24aut
									  
									  
foreach x in a b c d e f g x o {
	
	foreach var of var p5_24`x' {
		replace `var' = -9 if p2_7 == 2
	
	}
}	
				

				
				
******************************************************************

rename S5_25  p5_25
rename S5_25a p5_25aut
rename S5_26  p5_26
rename S5_27  p5_27

	
foreach var of var p5_25 p5_26 p5_27 {
		
	replace `var' = -9 if p2_7 == 2
	
	}


******************************************************************


drop S5_28

foreach var of var S5_28_1 S5_28_2 S5_28_3 S5_28_4 S5_28_5 S5_28_6 S5_28_7 S5_28_96 S5_28_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}



rename S5_28_1 p5_28a
rename S5_28_2 p5_28b
rename S5_28_3 p5_28c
rename S5_28_4 p5_28d
rename S5_28_5 p5_28e
rename S5_28_6 p5_28f
rename S5_28_7 p5_28g
rename S5_28_96 p5_28x
rename S5_28_9 p5_28o
rename S5_28a  p5_28aut
									  
									  
foreach x in a b c d e f g x o {
	
	foreach var of var p5_28`x' {
		replace `var' = -9 if p2_7 == 2
	
	}
}					
				
				
				
******************************************************************


drop S5_29

foreach var of var S5_29_1 S5_29_2 S5_29_3 S5_29_96 S5_29_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}



rename S5_29_1 p5_29a
rename S5_29_2 p5_29b
rename S5_29_3 p5_29c
rename S5_29_96 p5_29x
rename S5_29_9 p5_29o
rename S5_29a p5_29aut
									  
									  
foreach x in a b c x o {
	
	foreach var of var p5_29`x' {
		replace `var' = -9 if p2_7 == 2
	
	}
}					
					
				
				
				
******************************************************************
 
rename S5_30 p5_30
rename S5_31 p5_31
rename S5_31a p5_31aut
	
foreach var of var p5_30 p5_31 {
		
	replace `var' = -9 if p2_7 == 2
	
	}


				
				
				
******************************************************************

replace S5_32  = 2 if S5_32a  == "C'est 1 g de MgSO4 à 20% en IVL dans les 30 min si les convulsions réapparaissent après la dose charge"
replace S5_32  = 2 if S5_32a  == "C'est 1g"
replace S5_32  = 2 if S5_32a  == "4g dose d'attaque puis 1g toutes les heures pendant 24h"
replace S5_32  = 2 if S5_32a  == "1g"
replace S5_32  = 2 if S5_32a  == "1g"
replace S5_32  = 2 if S5_32a  == "1g"
replace S5_32  = 2 if S5_32a  == "1g de sulfate de magnésium"
replace S5_32  = 2 if S5_32a  == "1g par 1h"
replace S5_32  = 2 if S5_32a  == "1g chaque 1h"
replace S5_32  = 2 if S5_32a  == "1g par heure après dose de charge pendant 24h"
replace S5_32  = 2 if S5_32a  == "1g par heure /24 heures"

label define S5_32 2 "1g de MgSO4", add


rename S5_32 p5_32
rename S5_32a p5_32aut

	
replace p5_32 = -9 if p2_7 == 2


******************************************************************				
				
				
drop S5_33

foreach var of var S5_33_1 S5_33_2 S5_33_3 S5_33_4 S5_33_5 S5_33_6 S5_33_96 S5_33_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}



rename S5_33_1 p5_33a
rename S5_33_2 p5_33b
rename S5_33_3 p5_33c
rename S5_33_4 p5_33d
rename S5_33_5 p5_33e
rename S5_33_6 p5_33f
rename S5_33_96 p5_33x
rename S5_33_9 p5_33o
rename S5_33a p5_33aut
									  
									  
foreach x in a b c d e f x o {
	
	foreach var of var p5_33`x' {
		replace `var' = -9 if p2_7 == 2
	
	}
}					
									

									
******************************************************************

rename S5_34 p5_34

replace p5_34 = -9 if p2_7 == 2


*******************************************************************			
				
				
drop S5_35

foreach var of var S5_35_1 S5_35_2 S5_35_3 S5_35_4 S5_35_5 S5_35_6 S5_35_7 S5_35_8 S5_35_11 S5_35_10 S5_35_96 S5_35_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}



rename S5_35_1 p5_35a
rename S5_35_2 p5_35b
rename S5_35_3 p5_35c
rename S5_35_4 p5_35d
rename S5_35_5 p5_35e
rename S5_35_6 p5_35f
rename S5_35_7 p5_35g
rename S5_35_8 p5_35h
rename S5_35_11 p5_35i
rename S5_35_10 p5_35j
rename S5_35_96 p5_35x
rename S5_35_9 p5_35o
rename S5_35a p5_35aut
									  
									  
foreach x in a b c d e f g h i j x o {
	
	foreach var of var p5_35`x' {
		replace `var' = -9 if p2_7 == 2
	
	}
}					



******************************************************************				
				
				
drop S5_36

foreach var of var S5_36_1 S5_36_2 S5_36_3 S5_36_96 S5_36_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S5_36_1 p5_36a
rename S5_36_2 p5_36b
rename S5_36_3 p5_36c
rename S5_36_96 p5_36x
rename S5_36_9 p5_36o
rename S5_36a p5_36aut
									  
									  
foreach x in a b c x o {
	
	foreach var of var p5_36`x' {
		replace `var' = -9 if p2_7 == 2
	
	}
}					
																						
******************************************************************				
				
				
drop S5_37

foreach var of var S5_37_1 S5_37_2 S5_37_96 S5_37_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S5_37_1 p5_37a
rename S5_37_2 p5_37b
rename S5_37_96 p5_37x
rename S5_37_9 p5_37o
rename S5_37a p5_37aut
									  
									  
foreach x in a b x o {
	
	foreach var of var p5_37`x' {
		replace `var' = -9 if p2_7 == 2
	
	}
}					


******************************************************************				
				
				
drop S5_38

foreach var of var S5_38_1 S5_38_96 S5_38_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S5_38_1 p5_38a
rename S5_38_96 p5_38x
rename S5_38_9 p5_38o
rename S5_38a p5_38aut
									  
									  
foreach x in a x o {
	
	foreach var of var p5_38`x' {
		replace `var' = -9 if p2_7 == 2
	
	}
}
				

******************************************************************				
				
				
drop S5_39

foreach var of var S5_39_1 S5_39_2 S5_39_96 S5_39_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S5_39_1 p5_39a
rename S5_39_2 p5_39b
rename S5_39_96 p5_39x
rename S5_39_9 p5_39o
rename S5_39a p5_39aut
									  
									  
foreach x in a b x o {
	
	foreach var of var p5_39`x' {
		replace `var' = -9 if p2_7 == 2
	
	}
}					


******************************************************************				
				
				
drop S5_40

foreach var of var S5_40_1 S5_40_96 S5_40_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S5_40_1 p5_40a
rename S5_40_96 p5_40x
rename S5_40_9 p5_40o
rename S5_40a p5_40aut
									  
									  
foreach x in a x o {
	
	foreach var of var p5_40`x' {
		replace `var' = -9 if p2_7 == 2
	
	}
}
				

******************************************************************	

rename S5_41 p5_41

replace p5_41 = -9 if p2_7 == 2


******************************************************************						

							
drop S5_42

foreach var of var S5_42_1 S5_42_2 S5_42_96 S5_42_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S5_42_1 p5_42a
rename S5_42_2 p5_42b
rename S5_42_96 p5_42x
rename S5_42_9 p5_42o
rename S5_42a p5_42aut
									  
									  
foreach x in a b x o {
	
	foreach var of var p5_42`x' {
		replace `var' = -9 if p2_7 == 2
	
	}
}					


******************************************************************						

							
drop S5_43

foreach var of var S5_43_1 S5_43_2 S5_43_3 S5_43_96 S5_43_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S5_43_1 p5_43a
rename S5_43_2 p5_43b
rename S5_43_3 p5_43c
rename S5_43_96 p5_43x
rename S5_43_9 p5_43o
rename S5_43a p5_43aut
									  
									  
foreach x in a b c x o {
	
	foreach var of var p5_43`x' {
		replace `var' = -9 if p2_7 == 2
	
	}
}		


******************************************************************

rename S5_44 p5_44
rename S5_44a p5_44aut

replace p5_44 = -9 if p2_7 == 2

******************************************************************						

							
drop S5_45

foreach var of var S5_45_1 S5_45_2 S5_45_3 S5_45_4 S5_45_5 S5_45_6 S5_45_7 S5_45_8 S5_45_11 S5_45_96 S5_45_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S5_45_1 p5_45a
rename S5_45_2 p5_45b
rename S5_45_3 p5_45c
rename S5_45_4 p5_45d
rename S5_45_5 p5_45e
rename S5_45_6 p5_45f
rename S5_45_7 p5_45g
rename S5_45_8 p5_45h
rename S5_45_11 p5_45i
rename S5_45_96 p5_45x
rename S5_45_9 p5_45o
rename S5_45a p5_45âut
									  
									  
foreach x in a b c d e f g h i x o {
	
	foreach var of var p5_45`x' {
		replace `var' = -9 if p2_7 == 2
	
	}
}		



********************************************************************


drop S5_46

foreach var of var S5_46_1 S5_46_2 S5_46_3 S5_46_96 S5_46_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S5_46_1 p5_46a
rename S5_46_2 p5_46b
rename S5_46_3 p5_46c
rename S5_46_96 p5_46x
rename S5_46_9 p5_46o
rename S5_46a p5_46aut
									  
									  
foreach x in a b c x o {
	
	foreach var of var p5_46`x' {
		replace `var' = -9 if p2_7 == 2
	
	}
}		



********************************************************************


drop S5_47

foreach var of var S5_47_1 S5_47_2 S5_47_96 S5_47_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S5_47_1 p5_47a
rename S5_47_2 p5_47b
rename S5_47_96 p5_47x
rename S5_47_9 p5_47o
rename S5_47a p5_47aut
									  
									  
foreach x in a b x o {
	
	foreach var of var p5_47`x' {
		replace `var' = -9 if p2_7 == 2
	
	}
}		


*************************************************************


drop S5_48

foreach var of var S5_48_1 S5_48_2 S5_48_3 S5_48_96 S5_48_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S5_48_1 p5_48a
rename S5_48_2 p5_48b
rename S5_48_3 p5_48c
rename S5_48_96 p5_48x
rename S5_48_9 p5_48o
rename S5_48a p5_48aut
									  
									  
foreach x in a b c x o {
	
	foreach var of var p5_48`x' {
		replace `var' = -9 if p2_7 == 2
	
	}
}		


*************************************************************


drop S5_49

foreach var of var S5_49_1 S5_49_96 S5_49_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S5_49_1 p5_49a
rename S5_49_96 p5_49x
rename S5_49_9 p5_49o
rename S5_49a p5_49aut
									  
									  
foreach x in a x o {
	
	foreach var of var p5_49`x' {
		replace `var' = -9 if p2_7 == 2
	
	}
}		



********************************************************************

replace S5_50  = 2 if S5_50a  == "2 ieme degrés"
replace S5_50  = 2 if S5_50a  == "2eme"
replace S5_50  = 2 if S5_50a  == "2eme degré"
replace S5_50  = 2 if S5_50a  == "2eme et 3eme degré"
replace S5_50  = 2 if S5_50a  == "2ieme et plus"
replace S5_50  = 2 if S5_50a  == "A partir de 2em"
replace S5_50  = 2 if S5_50a  == "A partir de 2eme degrés"
replace S5_50  = 2 if S5_50a  == "A partir du deuxième degré"
replace S5_50  = 3 if S5_50a  == "A partir du premier degré selon classification française"
replace S5_50  = 3 if S5_50a  == "A tout niveau"
replace S5_50  = 3 if S5_50a  == "Toujours repérer"
replace S5_50  = 3 if S5_50a  == "Tous"
replace S5_50  = 3 if S5_50a  == "Tous les Degré"
replace S5_50  = 3 if S5_50a  == "Tous les degrés"
replace S5_50  = 3 if S5_50a  == "Tous les degrés"
replace S5_50  = 3 if S5_50a  == "Tous les degrés"
replace S5_50  = 3 if S5_50a  == "Tout les degrés"
replace S5_50  = 3 if S5_50a  == "Tout les degrés"
replace S5_50  = 3 if S5_50a  == "Tout les degrés"
replace S5_50  = 3 if S5_50a  == "Toute les déchirures"
replace S5_50  = 3 if S5_50a  == "Toutes"
replace S5_50  = 3 if S5_50a  == "Toutes les dechirures"
replace S5_50  = 3 if S5_50a  == "Toutes les déchirures"
replace S5_50  = 3 if S5_50a  == "Toutes les déchirures"
replace S5_50  = 3 if S5_50a  == "Toutes les déchirures"
replace S5_50  = 3 if S5_50a  == "Toutes les déchirures"
replace S5_50  = 3 if S5_50a  == "Toutes les déchirures"
replace S5_50  = 3 if S5_50a  == "Toutes les déchirures"


replace S5_50a  = "" if S5_50a  == "2 ieme degrés"
replace S5_50a  = "" if S5_50a  == "2eme"
replace S5_50a  = "" if S5_50a  == "2eme degré"
replace S5_50a  = "" if S5_50a  == "2eme et 3eme degré"
replace S5_50a  = "" if S5_50a  == "2ieme et plus"
replace S5_50a  = "" if S5_50a  == "A partir de 2em"
replace S5_50a  = "" if S5_50a  == "A partir de 2eme degrés"
replace S5_50a  = "" if S5_50a  == "A partir du deuxième degré"
replace S5_50a  = "" if S5_50a  == "A partir du premier degré selon classification française"
replace S5_50a  = "" if S5_50a  == "A tout niveau"
replace S5_50a  = "" if S5_50a  == "Toujours repérer"
replace S5_50a  = "" if S5_50a  == "Tous"
replace S5_50a  = "" if S5_50a  == "Tous les Degré"
replace S5_50a  = "" if S5_50a  == "Tous les degrés"
replace S5_50a  = "" if S5_50a  == "Tous les degrés"
replace S5_50a  = "" if S5_50a  == "Tous les degrés"
replace S5_50a  = "" if S5_50a  == "Tout les degrés"
replace S5_50a  = "" if S5_50a  == "Tout les degrés"
replace S5_50a  = "" if S5_50a  == "Tout les degrés"
replace S5_50a  = "" if S5_50a  == "Toute les déchirures"
replace S5_50a  = "" if S5_50a  == "Toutes"
replace S5_50a  = "" if S5_50a  == "Toutes les dechirures"
replace S5_50a  = "" if S5_50a  == "Toutes les déchirures"
replace S5_50a  = "" if S5_50a  == "Toutes les déchirures"
replace S5_50a  = "" if S5_50a  == "Toutes les déchirures"
replace S5_50a  = "" if S5_50a  == "Toutes les déchirures"
replace S5_50a  = "" if S5_50a  == "Toutes les déchirures"
replace S5_50a  = "" if S5_50a  == "Toutes les déchirures"

label define S5_50 2 "A partir du 2 ième degré " 3 "Tous les degrès ", add



rename S5_50 p5_50
rename S5_50a p5_50aut

replace p5_50 = -9 if p2_7 == 2

*******************************************************************

rename S5_51 p5_51
rename S5_52 p5_52

replace p5_51 = -9 if p2_7 == 2
replace p5_52 = -9 if p2_7 == 2




******************************************************************
gen S5_53_5 = 0 if S5_53_1 != . 

order S5_53_5, after(S5_53_4)

label value S5_53_5 S5_53_1

replace S5_53_5  = 1 if S5_53a  == "La révision utérine"
replace S5_53_5  = 1 if S5_53a  == "On fait une révision utérine"
replace S5_53_5  = 1 if S5_53a  == "Révision uterine"
replace S5_53_5  = 1 if S5_53a  == "Révision utérine"
replace S5_53_5  = 1 if S5_53a  == "Révision utérine"
replace S5_53_5  = 1 if S5_53a  == "Révision utérine"
replace S5_53_5  = 1 if S5_53a  == "Révision utérine"
replace S5_53_5  = 1 if S5_53a  == "Révision utérine"
replace S5_53_5  = 1 if S5_53a  == "Révision utérine"
replace S5_53_5  = 1 if S5_53a  == "Révision utérine"
replace S5_53_5  = 1 if S5_53a  == "Révision utérine"
replace S5_53_5  = 1 if S5_53a  == "Révision utérine"
replace S5_53_5  = 1 if S5_53a  == "Révision utérine avec la main et un gant"
replace S5_53_5  = 1 if S5_53a  == "Révision utérine sous anesthésie"
replace S5_53_5  = 1 if S5_53a  == "Révision utérine, antibiotiques si rétention ancienne"

replace S5_53_96  = 0 if S5_53a  == "La révision utérine"
replace S5_53_96  = 0 if S5_53a  == "On fait une révision utérine"
replace S5_53_96  = 0 if S5_53a  == "Révision uterine"
replace S5_53_96  = 0 if S5_53a  == "Révision utérine"
replace S5_53_96  = 0 if S5_53a  == "Révision utérine"
replace S5_53_96  = 0 if S5_53a  == "Révision utérine"
replace S5_53_96  = 0 if S5_53a  == "Révision utérine"
replace S5_53_96  = 0 if S5_53a  == "Révision utérine"
replace S5_53_96  = 0 if S5_53a  == "Révision utérine"
replace S5_53_96  = 0 if S5_53a  == "Révision utérine"
replace S5_53_96  = 0 if S5_53a  == "Révision utérine"
replace S5_53_96  = 0 if S5_53a  == "Révision utérine"
replace S5_53_96  = 0 if S5_53a  == "Révision utérine avec la main et un gant"
replace S5_53_96  = 0 if S5_53a  == "Révision utérine sous anesthésie"
replace S5_53_96  = 0 if S5_53a  == "Révision utérine, antibiotiques si rétention ancienne"


replace S5_53a  = "" if S5_53a  == "La révision utérine"
replace S5_53a  = "" if S5_53a  == "On fait une révision utérine"
replace S5_53a  = "" if S5_53a  == "Révision uterine"
replace S5_53a  = "" if S5_53a  == "Révision utérine"
replace S5_53a  = "" if S5_53a  == "Révision utérine"
replace S5_53a  = "" if S5_53a  == "Révision utérine"
replace S5_53a  = "" if S5_53a  == "Révision utérine"
replace S5_53a  = "" if S5_53a  == "Révision utérine"
replace S5_53a  = "" if S5_53a  == "Révision utérine"
replace S5_53a  = "" if S5_53a  == "Révision utérine"
replace S5_53a  = "" if S5_53a  == "Révision utérine"
replace S5_53a  = "" if S5_53a  == "Révision utérine"
replace S5_53a  = "" if S5_53a  == "Révision utérine avec la main et un gant"
replace S5_53a  = "" if S5_53a  == "Révision utérine sous anesthésie"
replace S5_53a  = "" if S5_53a  == "Révision utérine, antibiotiques si rétention ancienne"


label var S5_53_1 "Inj. ocytocine 10 UI IM s'il n'est pas administré pendant la GATPA"
label var S5_53_2 "IV NS/RL avec 20 UI d'ocytocine injectable dans 1 L 40-60 gouttes/min "
label var S5_53_3 "Retrait des morceaux de placenta avec AMIU/Aspiration électrique intra-utérin/porte-tampon"
label var S5_53_4 "Administrer 1 dose à large spectre antibiotiques"
label var S5_53_5 "Révision utérine"
label var S5_53_96 "Autre [Préciser]"
label var S5_53_9 "Je ne sais pas"
label var S5_53a "Préciser"

drop S5_53

foreach var of var S5_53_1 S5_53_2 S5_53_3 S5_53_4 S5_53_5 S5_53_96 S5_53_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S5_53_1 p5_53a
rename S5_53_2 p5_53b
rename S5_53_3 p5_53c
rename S5_53_4 p5_53d
rename S5_53_5 p5_53e
rename S5_53_96 p5_53x
rename S5_53_9 p5_53o
rename S5_53a p5_53aut
									  
									  
foreach x in a b c d e x o {
	
	foreach var of var p5_53`x' {
		replace `var' = -9 if p2_7 == 2
	
	}
}		

******************************************************************

rename S5_54 p5_54
rename S5_54a p5_54aut
rename S5_55 p5_55

replace p5_54 = -9 if p2_7 == 2
replace p5_55 = -9 if p2_7 == 2


*******************************************************************

drop S5_56

foreach var of var S5_56_1 S5_56_2 S5_56_3 S5_56_4 S5_56_96 S5_56_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S5_56_1 p5_56a
rename S5_56_2 p5_56b
rename S5_56_3 p5_56c
rename S5_56_4 p5_56d
rename S5_56_96 p5_56x
rename S5_56_9 p5_56o
rename S5_56a p5_56aut
									  
									  
foreach x in a b c d x o {
	
	foreach var of var p5_56`x' {
		replace `var' = -9 if p2_7 == 2
	
	}
}		


*******************************************************************

drop S5_57

foreach var of var S5_57_1 S5_57_2 S5_57_96 S5_57_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S5_57_1 p5_57a
rename S5_57_2 p5_57b
rename S5_57_96 p5_57x
rename S5_57_9 p5_57o
rename S5_57a p5_57aut
									  
									  
foreach x in a b x o {
	
	foreach var of var p5_57`x' {
		replace `var' = -9 if p2_7 == 2
	
	}
}		



******************************************************************

rename S5_58 p5_58
rename S5_58a p5_58aut
rename S5_59 p5_59

replace p5_58 = -9 if p2_7 == 2
replace p5_59 = -9 if p2_7 == 2


*******************************************************************

drop S5_60

foreach var of var S5_60_1 S5_60_2 S5_60_3 S5_60_4 S5_60_5 S5_60_96 S5_60_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S5_60_1 p5_60a
rename S5_60_2 p5_60b
rename S5_60_3 p5_60c
rename S5_60_4 p5_60d
rename S5_60_5 p5_60e
rename S5_60_96 p5_60x
rename S5_60_9 p5_60o
rename S5_60a p5_60aut
									  
									  
foreach x in a b c d e x o {
	
	foreach var of var p5_60`x' {
		replace `var' = -9 if p2_7 == 2
	
	}
}		


******************************************************************

gen S5_61_6 = 0 if S5_61_1 != . 

order S5_61_6,after(S5_61_5)

label value S5_61_6 S5_61_1


replace S5_61_6  = 1 if S5_61a  == "Coherence = consitance poste = présentation"
replace S5_61_6  = 1 if S5_61a  == "Consistance "
replace S5_61_6  = 1 if S5_61a  == "Consistance "
replace S5_61_6  = 1 if S5_61a  == "Consistance du col, position du col"
replace S5_61_6  = 1 if S5_61a  == "Consistance et position"
replace S5_61_6  = 1 if S5_61a  == "Consistance et position du col"
replace S5_61_6  = 1 if S5_61a  == "Consistance, position et présentation"
replace S5_61_6  = 1 if S5_61a  == "Contractions utérine   état d'avancement du mobile foetale"
replace S5_61_5  = 1 if S5_61a  == "Degré d'ouverture , descente de la tete"
replace S5_61_6  = 1 if S5_61a  == "La consistance,"
replace S5_61_6  = 1 if S5_61a  == "Position"
replace S5_61_6  = 1 if S5_61a  == "Position"
replace S5_61_6  = 1 if S5_61a  == "Position , présentation, consistance"
replace S5_61_6  = 1 if S5_61a  == "Position col"
replace S5_61_6  = 1 if S5_61a  == "Position consistence"
replace S5_61_6  = 1 if S5_61a  == "Position du col,la présentation"
replace S5_61_6  = 1 if S5_61a  == "Position, présentation et consistance"
replace S5_61_6  = 1 if S5_61a  == "Présentation"
replace S5_61_6  = 1 if S5_61a  == "Présentation"
replace S5_61_6  = 1 if S5_61a  == "Présentation, position, consistence"


replace S5_61_96  = 0 if S5_61a  == "Coherence = consitance poste = présentation"
replace S5_61_96  = 0 if S5_61a  == "Consistance "
replace S5_61_96  = 0 if S5_61a  == "Consistance "
replace S5_61_96  = 0 if S5_61a  == "Consistance du col, position du col"
replace S5_61_96  = 0 if S5_61a  == "Consistance et position"
replace S5_61_96  = 0 if S5_61a  == "Consistance et position du col"
replace S5_61_96  = 0 if S5_61a  == "Consistance, position et présentation"
replace S5_61_96  = 0 if S5_61a  == "Contractions utérine   état d'avancement du mobile foetale"
replace S5_61_96  = 0 if S5_61a  == "Degré d'ouverture , descente de la tete"
replace S5_61_96  = 0 if S5_61a  == "La consistance,"
replace S5_61_96  = 0 if S5_61a  == "Position"
replace S5_61_96  = 0 if S5_61a  == "Position"
replace S5_61_96  = 0 if S5_61a  == "Position , présentation, consistance"
replace S5_61_96  = 0 if S5_61a  == "Position col"
replace S5_61_96  = 0 if S5_61a  == "Position consistence"
replace S5_61_96  = 0 if S5_61a  == "Position du col,la présentation"
replace S5_61_96  = 0 if S5_61a  == "Position, présentation et consistance"
replace S5_61_96  = 0 if S5_61a  == "Présentation"
replace S5_61_96  = 0 if S5_61a  == "Présentation"
replace S5_61_96  = 0 if S5_61a  == "Présentation, position, consistence"


replace S5_61a  = "" if S5_61a  == "Coherence = consitance poste = présentation"
replace S5_61a  = "" if S5_61a  == "Consistance "
replace S5_61a  = "" if S5_61a  == "Consistance "
replace S5_61a  = "" if S5_61a  == "Consistance du col, position du col"
replace S5_61a  = "" if S5_61a  == "Consistance et position"
replace S5_61a  = "" if S5_61a  == "Consistance et position du col"
replace S5_61a  = "" if S5_61a  == "Consistance, position et présentation"
replace S5_61a  = "" if S5_61a  == "Contractions utérine   état d'avancement du mobile foetale"
replace S5_61a  = "" if S5_61a  == "Degré d'ouverture , descente de la tete"
replace S5_61a  = "" if S5_61a  == "La consistance,"
replace S5_61a  = "" if S5_61a  == "Position"
replace S5_61a  = "" if S5_61a  == "Position"
replace S5_61a  = "" if S5_61a  == "Position , présentation, consistance"
replace S5_61a  = "" if S5_61a  == "Position col"
replace S5_61a  = "" if S5_61a  == "Position consistence"
replace S5_61a  = "" if S5_61a  == "Position du col,la présentation"
replace S5_61a  = "" if S5_61a  == "Position, présentation et consistance"
replace S5_61a  = "" if S5_61a  == "Présentation"
replace S5_61a  = "" if S5_61a  == "Présentation"
replace S5_61a  = "" if S5_61a  == "Présentation, position, consistence"


label var S5_61_1 "Effacement du col" 
label var S5_61_2 "Dilatation du col"
label var S5_61_3 "Cohérence"
label var S5_61_4 "Poste"
label var S5_61_5 "Descente de tête"
label var S5_61_6 "Consistance du col, position du col"
label var S5_61_96 "Autre [Préciser]"
label var S5_61_9 "Je ne sais pas"
label var S5_61a "Préciser"

drop S5_61

foreach var of var S5_61_1 S5_61_2 S5_61_3 S5_61_4 S5_61_5 S5_61_6 S5_61_96 S5_61_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S5_61_1 p5_61a
rename S5_61_2 p5_61b
rename S5_61_3 p5_61c
rename S5_61_4 p5_61d
rename S5_61_5 p5_61e
rename S5_61_6 p5_61f
rename S5_61_96 p5_61x
rename S5_61_9 p5_61o
rename S5_61a p5_61aut
									  
									  
foreach x in a b c d e f x o {
	
	foreach var of var p5_61`x' {
		replace `var' = -9 if p2_7 == 2
	
	}
}		



****************************************************************

drop S5_62

foreach var of var S5_62_1 S5_62_2 S5_62_3 S5_62_96 S5_62_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S5_62_1 p5_62a
rename S5_62_2 p5_62b
rename S5_62_3 p5_62c
rename S5_62_96 p5_62x
rename S5_62_9 p5_62o
rename S5_62a p5_62aut
									  
									  
foreach x in a b c x o {
	
	foreach var of var p5_62`x' {
		replace `var' = -9 if p2_7 == 2
	
	}
}		


***************************************************************

rename S5_63 p5_63
rename S5_64 p5_64
rename S5_64a p5_64aut
rename S5_65 p5_65
rename S5_65a p5_65aut

foreach var of var p5_63 p5_64 p5_65 {
		
		replace `var' = -9 if p2_7 == 2
	
	}


	
****************************************************************

drop S5_66

foreach var of var S5_66_1 S5_66_2 S5_66_3 S5_66_96 S5_66_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S5_66_1 p5_66a
rename S5_66_2 p5_66b
rename S5_66_3 p5_66c
rename S5_66_96 p5_66x
rename S5_66_9 p5_66o
rename S5_66a p5_66aut
									  
									  
foreach x in a b c x o {
	
	foreach var of var p5_66`x' {
		replace `var' = -9 if p2_7 == 2
	
	}
}		

	
****************************************************************

drop S5_67

foreach var of var S5_67_1 S5_67_2 S5_67_96 S5_67_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S5_67_1 p5_67a
rename S5_67_2 p5_67b
rename S5_67_96 p5_67x
rename S5_67_9 p5_67o
rename S5_67a p5_67aut
									  
									  
foreach x in a b x o {
	
	foreach var of var p5_67`x' {
		replace `var' = -9 if p2_7 == 2
	
	}
}		


	
****************************************************************

replace S5_68  = 1 if S5_68a  == "1% ou 2%"
replace S5_68  = 1 if S5_68a  == "1 à 2%"
replace S5_68  = 1 if S5_68a  == "1% 1c"
replace S5_68  = 2 if S5_68a  == "2%"
replace S5_68  = 2 if S5_68a  == "2%"
replace S5_68  = 2 if S5_68a  == "2%"
replace S5_68  = 2 if S5_68a  == "2"
replace S5_68  = 2 if S5_68a  == "2%"
replace S5_68  = 9 if S5_68a  == "Oublié"
replace S5_68  = 1 if S5_68a  == "0,1"
replace S5_68  = 1 if S5_68a  == "1pour cent"
replace S5_68  = 2 if S5_68a  == "2%"
replace S5_68  = 2 if S5_68a  == "2%"
replace S5_68  = 2 if S5_68a  == "2ml"
replace S5_68  = 2 if S5_68a  == "2%"


label define S5_68 2 "2%", add


rename S5_68 p5_68
rename S5_68a p5_68aut

replace p5_68 = -9 if p2_7 == 2


*******************************************************************

rename S5_69 p5_69
rename S5_70 p5_70
	
	
foreach var of var p5_69 p5_70 {
		replace `var' = -9 if p2_7 == 2
	
	}	
	

******************************************************************

replace S5_71  = 1 if S5_71a  == "1cm au dessous du sommet"
replace S5_71  = 2 if S5_71a  == "Après détection du point "v""
replace S5_71  = 1 if S5_71a  == "Au dessous du sommet"
replace S5_71  = 2 if S5_71a  == "Au niveau dIV"
replace S5_71  = 2 if S5_71a  == "Au niveau du v"
replace S5_71  = 2 if S5_71a  == "Au niveau du V"
replace S5_71  = 2 if S5_71a  == "Au niveau du V"
replace S5_71  = 2 if S5_71a  == "Au niveau du V"
replace S5_71  = 2 if S5_71a  == "Par le V"
replace S5_71  = 2 if S5_71a  == "Point V"
replace S5_71  = 2 if S5_71a  == "V"

replace S5_71a  = "" if S5_71a  == "1cm au dessous du sommet"
replace S5_71a  = "" if S5_71a  == "Après détection du point "v""
replace S5_71a  = "" if S5_71a  == "Au dessous du sommet"
replace S5_71a  = "" if S5_71a  == "Au niveau dIV"
replace S5_71a  = "" if S5_71a  == "Au niveau du v"
replace S5_71a  = "" if S5_71a  == "Au niveau du V"
replace S5_71a  = "" if S5_71a  == "Au niveau du V"
replace S5_71a  = "" if S5_71a  == "Au niveau du V"
replace S5_71a  = "" if S5_71a  == "Par le V"
replace S5_71a  = "" if S5_71a  == "Point V"
replace S5_71a  = "" if S5_71a  == "V"


label define S5_71 2 "Niveau V", add


rename S5_71 p5_71
rename S5_71a p5_71aut

replace p5_71 = -9 if p2_7 == 2



****************************************************************


drop S5_72

foreach var of var S5_72_1 S5_72_2 S5_72_3 S5_72_4 S5_72_96 S5_72_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S5_72_1 p5_72a
rename S5_72_2 p5_72b
rename S5_72_3 p5_72c
rename S5_72_4 p5_72d
rename S5_72_96 p5_72x
rename S5_72_9 p5_72o
rename S5_72a p5_72aut
									  
									  
foreach x in a b c d x o {
	
	foreach var of var p5_72`x' {
		replace `var' = -9 if p2_7 == 2
	
	}
}		


****************************************************************


drop S5_73

foreach var of var S5_73_1 S5_73_2 S5_73_3 S5_73_4 S5_73_5 S5_73_96 S5_73_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S5_73_1 p5_73a
rename S5_73_2 p5_73b
rename S5_73_3 p5_73c
rename S5_73_4 p5_73d
rename S5_73_5 p5_73e
rename S5_73_96 p5_73x
rename S5_73_9 p5_73o
rename S5_73a p5_73aut
									  
									  
foreach x in a b c d e x o {
	
	foreach var of var p5_73`x' {
		replace `var' = -9 if p2_7 == 2
	
	}
}		


****************************************************************


drop S5_74

foreach var of var S5_74_1 S5_74_2 S5_74_96 S5_74_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S5_74_1 p5_74a
rename S5_74_2 p5_74b
rename S5_74_96 p5_74x
rename S5_74_9 p5_74o
rename S5_74a p5_74aut
									  
									  
foreach x in a b x o {
	
	foreach var of var p5_74`x' {
		replace `var' = -9 if p2_7 == 2
	
	}
}		


****************************************************************

rename S5_75 p5_75
rename S5_76 p5_76
rename S5_77 p5_77

foreach var of var p5_75 p5_76 p5_77 {
		
		replace `var' = -9 if p2_7 == 2
	
	}


****************************************************************


drop S5_78

foreach var of var S5_78_1 S5_78_2 S5_78_3 S5_78_4 S5_78_96 S5_78_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S5_78_1 p5_78a
rename S5_78_2 p5_78b
rename S5_78_3 p5_78c
rename S5_78_4 p5_78d
rename S5_78_96 p5_78x
rename S5_78_9 p5_78o
rename S5_78a p5_78aut
									  
									  
foreach x in a b c d x o {
	
	foreach var of var p5_78`x' {
		replace `var' = -9 if p2_7 == 2
	
	}
}		



******************************************************************


rename S5_79 p5_79
rename S5_79a p5_79aut
rename S5_80 p5_80
rename S5_80a p5_80aut
rename S5_81 p5_81


foreach var of var p5_79 p5_80 p5_81 {
		
		replace `var' = -9 if p2_7 == 2
	
	}
	
	
******************************************************************


drop S5_82

foreach var of var S5_82_1 S5_82_2 S5_82_3 S5_82_4 S5_82_96 S5_82_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S5_82_1 p5_82a
rename S5_82_2 p5_82b
rename S5_82_3 p5_82c
rename S5_82_4 p5_82d
rename S5_82_96 p5_82x
rename S5_82_9 p5_82o
rename S5_82a p5_82aut
									  
									  
foreach x in a b c d x o {
	
	foreach var of var p5_82`x' {
		replace `var' = -9 if p2_7 == 2
	
	}
}		


******************************************************************

rename S5_83 p5_83

replace p5_83 = -9 if p2_7 == 2


******************************************************************


drop S5_84

foreach var of var S5_84_1 S5_84_2 S5_84_3 S5_84_4 S5_84_96 S5_84_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S5_84_1 p5_84a
rename S5_84_2 p5_84b
rename S5_84_3 p5_84c
rename S5_84_4 p5_84d
rename S5_84_96 p5_84x
rename S5_84_9 p5_84o
rename S5_84a p5_84aut
									  
									  
foreach x in a b c d x o {
	
	foreach var of var p5_84`x' {
		replace `var' = -9 if p2_7 == 2
	
	}
}		



*********************************************************************

rename S5_85  p5_85
rename S5_85a p5_85aut

replace p5_85 = -9 if p2_7 == 2


*******************************************************************


drop S5_86

foreach var of var S5_86_1 S5_86_2 S5_86_3 S5_86_4 S5_86_5 S5_86_6 S5_86_7 S5_86_96 S5_86_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S5_86_1 p5_86a
rename S5_86_2 p5_86b
rename S5_86_3 p5_86c
rename S5_86_4 p5_86d
rename S5_86_5 p5_86e
rename S5_86_6 p5_86f
rename S5_86_7 p5_86g
rename S5_86_96 p5_86x
rename S5_86_9 p5_86o
rename S5_86a p5_86aut
									  
									  
foreach x in a b c d e f g x o {
	
	foreach var of var p5_86`x' {
		replace `var' = -9 if p2_7 == 2
	
	}
}		


*******************************************************************


drop S5_87

foreach var of var S5_87_1 S5_87_2 S5_87_3 S5_87_4 S5_87_5 S5_87_6 S5_87_96 S5_87_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S5_87_1 p5_87a
rename S5_87_2 p5_87b
rename S5_87_3 p5_87c
rename S5_87_4 p5_87d
rename S5_87_5 p5_87e
rename S5_87_6 p5_87f
rename S5_87_96 p5_87x
rename S5_87_9 p5_87o
rename S5_87a p5_87aut
									  
									  
foreach x in a b c d e f x o {
	
	foreach var of var p5_87`x' {
		replace `var' = -9 if p2_7 == 2
	
	}
}		


******************************************************************

rename S5_88 p5_88
rename S5_88a p5_88aut

replace p5_88 = -9 if p2_7 == 2



**********************************************************************


drop S5_89

foreach var of var  S5_89_1 S5_89_96 S5_89_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename  S5_89_1 p5_89a
rename  S5_89_96 p5_89x
rename  S5_89_9 p5_89o
rename  S5_89a p5_89aut
									  
									  
foreach x in a x o {
	
	foreach var of var p5_89`x' {
		replace `var' = -9 if p2_7 == 2
	
	}
}		



**********************************************************************


drop S5_90

foreach var of var S5_90_1 S5_90_2 S5_90_3 S5_90_4 S5_90_5 S5_90_6 S5_90_7 S5_90_8 S5_90_12 S5_90_10 S5_90_11 S5_90_96 S5_90_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S5_90_1 p5_90a
rename S5_90_2 p5_90b
rename S5_90_3 p5_90c
rename S5_90_4 p5_90d
rename S5_90_5 p5_90e
rename S5_90_6 p5_90f
rename S5_90_7 p5_90g
rename S5_90_8 p5_90h
rename S5_90_12 p5_90i
rename S5_90_10 p5_90j
rename S5_90_11 p5_90k
rename S5_90_96 p5_90x
rename S5_90_9 p5_90o
rename S5_90a p5_90aut
									  
									  
foreach x in a b c d e f g h i j k x o {
	
	foreach var of var p5_90`x' {
		replace `var' = -9 if p2_7 == 2
	
	}
}		



**********************************************************************


drop S5_91

foreach var of var S5_91_1 S5_91_2 S5_91_3 S5_91_4 S5_91_5 S5_91_6 S5_91_7 S5_91_8 S5_91_96 S5_91_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S5_91_1 p5_91a
rename S5_91_2 p5_91b
rename S5_91_3 p5_91c
rename S5_91_4 p5_91d
rename S5_91_5 p5_91e
rename S5_91_6 p5_91f
rename S5_91_7 p5_91g
rename S5_91_8 p5_91h
rename S5_91_96 p5_91x
rename S5_91_9 p5_91o
rename S5_91a p5_91aut
									  
									  
foreach x in a b c d e f g h x o {
	
	foreach var of var p5_91`x' {
		replace `var' = -9 if p2_7 == 2
	
	}
}		



******************************************************************


rename S5_92 p5_92
rename S5_93 p5_93
rename S5_93a p5_93aut
rename S5_95 p5_95
rename S5_95a p5_95aut


foreach var of var p5_92 p5_93 p5_95 {
		replace `var' = -9 if p2_7 == 2
	
	}


	
**********************************************************************


drop S5_94

foreach var of var S5_94_1 S5_94_2 S5_94_96 S5_94_9 {
	
	label define `var' 0 "Non" 1 "Oui", modify
	label values `var' `var'
	
}


rename S5_94_1  p5_94a
rename S5_94_2  p5_94b
rename S5_94_96 p5_94x
rename S5_94_9  p5_94o
rename S5_94a   p5_94aut
									  
									  
foreach x in a b x o {
	
	foreach var of var p5_94`x' {
		replace `var' = -9 if p2_7 == 2
	
	}
}		



******************************************************************

rename s6_1_1 p6_1a
rename s6_1_2 p6_1b
rename s6_1_3 p6_1c
rename s6_1_4 p6_1d
rename s6_1_5 p6_1e
rename s6_1_6 p6_1f
rename s6_1_7 p6_1g


foreach x in a b c d e f g {
	
	foreach var of var p6_1`x' {
		replace `var' = -9 if p2_7 == 2
	
	}
}	


******************************************************************



*Enregistrement des données nettoyées
save "C:\Users\rndachi\Dropbox\FP-Project-APHRC-UM\Atelier_FP\Data\clean\doctor_clean_data.dta", replace



*Enregistrement des données anonymée

drop p1_8 p1_9

save "C:\Users\rndachi\Dropbox\FP-Project-APHRC-UM\Atelier_FP\Data\clean\doctor_clean_data_anonym.dta", replace




