
cd "G:\Mon Drive\APHRC\Database_v1_label"
use "BDD MEDECIN_17122024.dta", clear

****************************************************************

bysort I1 I2 I3 I3b I4 equipe s1_8 s1_9 S2_1 S2_2 S2_3 : gen dup_tag = cond(_n == 1, 0, 1)

tab dup_tag

drop if dup_tag == 1


****************************************************************

replace S2_14_1  = 4 if S2_14_1a  == "Ce sont les sages femmes qui s’en occupe"
replace S2_14_1  = 4 if S2_14_1a  == "Ce sont les SFE qui le font"
replace S2_14_1  = 4 if S2_14_1a  == "C'est le domaine de la sage femme"
replace S2_14_1  = 4 if S2_14_1a  == "C'est le rôle des sages femmes"
replace S2_14_1  = 4 if S2_14_1a  == "C'est pour les sages femmes"
replace S2_14_1  = 4 if S2_14_1a  == "Elle est en médecine"
replace S2_14_1  = 4 if S2_14_1a  == "Je suis pédiatre"
replace S2_14_1  = 4 if S2_14_1a  == "Le service est geré par les Sage femme"
replace S2_14_1  = 4 if S2_14_1a  == "Le service réservé à la maternité"
replace S2_14_1  = 4 if S2_14_1a  == "N’est pas affecté à la maternité"
replace S2_14_1  = 4 if S2_14_1a  == "N'intervient pas à la maternité,il y a un médecin complétant qui s'occupe de ça"
replace S2_14_1  = 4 if S2_14_1a  == "On a un gynecologue"
replace S2_14_1  = 5 if S2_14_1a  == "Pas de formation"
replace S2_14_1  = 5 if S2_14_1a  == "Pas formé"
replace S2_14_1  = 5 if S2_14_1a  == "Pas mon domaine"
replace S2_14_1  = 4 if S2_14_1a  == "Pédiatrie"
replace S2_14_1  = 4 if S2_14_1a  == "Pédiatrie"
replace S2_14_1  = 4 if S2_14_1a  == "Personnel"
replace S2_14_1  = 4 if S2_14_1a  == "Personnel disponible"
replace S2_14_1  = 4 if S2_14_1a  == "Personnel qualifié"
replace S2_14_1  = 4 if S2_14_1a  == "Sage femme"
replace S2_14_1  = 4 if S2_14_1a  == "Servi comme médecin généraliste aux urgences"
replace S2_14_1  = 4 if S2_14_1a  == "Service médecine"
replace S2_14_1  = 4 if S2_14_1a  == "Y’avait les spécialistes a coté"


label define S2_14_1 0 "Service non disponible" 4 "Ne travaille pas dans ce service" 5 "Non formé pour ce service", add

recode S2_14_1 (6 = 0)

replace S2_14_1a = "" if S2_14_1 != 6

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

********************************************************************

replace S2_14_4  = 5 if S2_14_4a  == "Besoin de recyclage"
replace S2_14_4  = 4 if S2_14_4a  == "Ce sont les sages femmes qui le font"
replace S2_14_4  = 4 if S2_14_4a  == "Ce sont les sages femmes qui s’en chargent"
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

******************************************************************

replace S2_27_4  = 4 if S2_27a_4  == "Pas eu l'occasion de le faire"
replace S2_27_4  = 4 if S2_27a_4  == "Orienter sage femme"
replace S2_27_4  = 5 if S2_27a_4  == "Formation en cours"
replace S2_27_4  = 4 if S2_27a_4  == "Fournit par les sages femmes"
replace S2_27_4  = 4 if S2_27a_4  == "On suggère patientes d'aller vers les sages-Femmes mais on intervient au cas grave"
replace S2_27_4  = 4 if S2_27a_4  == "Pas de clients"

label define S2_27_4 0 "Service non disponible" 4 "Ne travaille pas dans ce service" 5 "Non formé pour ce service", add

replace S2_27a_4 = "" if S2_27_4 != 6 

*******************************************************************

replace S2_27_5  = 4 if S2_27a_5  == "C'est la sage qui le fait"
replace S2_27_5  = 4 if S2_27a_5  == "Méthode fournie par la sage-femme"
replace S2_27_5  = 4 if S2_27a_5  == "On suggère les patientes d'aller vers les sages-Femmes mais on intervient au cas grave"
replace S2_27_5  = 4 if S2_27a_5  == "Services maternité"
replace S2_27_5  = 5 if S2_27a_5  == "Toujours en formation"

label define S2_27_5 0 "Service non disponible" 4 "Ne travaille pas dans ce service" 5 "Non formé pour ce service", add

replace S2_27a_5 = "" if S2_27_5 != 6 

recode S2_27_5 (6 = 0)

******************************************************************
replace S2_27_6  = 4 if S2_27a_6  == "Fournit par les sages femmes"
replace S2_27_6  = 4 if S2_27a_6  == "On suggère aux clientes d'aller vers les sages-Femmes mais on intervient au cas grave"
replace S2_27_6  = 4 if S2_27a_6  == "Sage-femme"
replace S2_27_6  = 4 if S2_27a_6  == "Services de maternité"

label define S2_27_6 0 "Service non disponible" 4 "Ne travaille pas dans ce service" 5 "Non formé pour ce service", add

replace S2_27a_6 = "" if S2_27_6 != 6 

recode S2_27_6 (6 = 0)

********************************************************************
replace S2_27_7  = 4 if S2_27a_7  == "Fournit par les sages femmes"
replace S2_27_7  = 4 if S2_27a_7  == "Orientation vers les sages femmes"
replace S2_27_7  = 4 if S2_27a_7  == "Services pour les sages femmes"

label define S2_27_7 0 "Service non disponible" 4 "Ne travaille pas dans ce service" 5 "Non formé pour ce service", add

replace S2_27a_7 = "" if S2_27_7 != 6 

recode S2_27_7 (6 = 0)

*******************************************************************
gen S3_2_10 = 0 if S3_2_1 != . 

order S3_2_10, after(S3_2_9)

label var S3_2_10 "302. Quelles informations sociodémographiques/liées à la fécondité collectez -vo"

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

*******************************************************************

replace S3_3_9  = 1 if S3_3a  == "Sage femme qui prenait les infos"
replace S3_3_9  = 1 if S3_3a  == "Ne pose pas de DIU"

replace S3_3_96  = 0 if S3_3a  == "Sage femme qui prenait les infos"
replace S3_3_96  = 0 if S3_3a  == "Ne pose pas de DIU"

*******************************************************************

replace S3_4_9  = 1 if S3_4a  == "Sage femme qui prenait les infos"
replace S3_4_9  = 1 if S3_4a  == "Ne pose pas de DIU"

replace S3_4_96  = 0 if S3_4a  == "Sage femme qui prenait les infos"
replace S3_4_96  = 0 if S3_4a  == "Ne pose pas de DIU"

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

********************************************************************

gen S3_10_4 = 0 if S3_10_1 != . 

gen S3_10_5 = 0 if S3_10_1 != . 

order S3_10_4 S3_10_5, after(S3_10_3) 

label var S3_10_4 "310. Selon vous, quels examens de laboratoire prescrivez-vous à une cliente avan"

label var S3_10_5 "310. Selon vous, quels examens de laboratoire prescrivez-vous à une cliente avan"

replace S3_10_5  = 1 if S3_10a  == "Bilan standard à faire si l'insertion se fait perdre césarienne"
replace S3_10_4  = 1 if S3_10a  == "Faire un prélèvement vaginal"
replace S3_10_4  = 1 if S3_10a  == "Le prélèvement vaginal ou le frottis"
replace S3_10_5  = 1 if S3_10a  == "NFS,CRP,bilan hépatique et renal"
replace S3_10_4  = 1 if S3_10a  == "Prélèvement vaginal"
replace S3_10_4  = 1 if S3_10a  == "Prélèvement vaginal"
replace S3_10_4  = 1 if S3_10a  == "Prélèvement vaginal"
replace S3_10_5  = 1 if S3_10a  == "PV,"

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

********************************************************************

gen S3_13_8 = 0 if S3_13_1 != . 

order S3_13_8, after (S3_13_7)

label var S3_13_8 "313. Quelles instructions donnez-vous aux clientes DIU avant leur sortie ? : Effet"

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

********************************************************************

gen S3_14_5 = 0 if S3_14_1 != .

order S3_14_5, after(S3_14_4)

label var S3_14_5 "314. Quels sont les effets secondaires de l’utilisation du DIU dont vous informe"

label value S3_14_5 S3_14_4

replace S3_14_2  = 1 if S3_14a  == "Douleur des seins au moment des règles"
replace S3_14_2  = 1 if S3_14a  == "Douleurs pelvienne  le Diu peut se perdre"
replace S3_14_1  = 1 if S3_14a  == "Dysménorrhée"
replace S3_14_5  = 1 if S3_14a  == "Gêne chez le partenaire"
replace S3_14_2  = 1 if S3_14a  == "La douleur"
replace S3_14_1  = 1 if S3_14a  == "Menometrorragie"
replace S3_14_9  = 1 if S3_14a  == "Ne sait pas"
replace S3_14_9  = 1 if S3_14a  == "Sage femme"
replace S3_14_1  = 1 if S3_14a  == "Saignements anormaux ,perception du fil"
replace S3_14_5  = 1 if S3_14a  == "Sensation désagréable au cours des rapports"
replace S3_14_1  = 1 if S3_14a  == "Spotting"


replace S3_14_96  = 0 if S3_14a  == "Douleur des seins au moment des règles"
replace S3_14_96  = 0 if S3_14a  == "Douleurs pelvienne  le Diu peut se perdre"
replace S3_14_96  = 0 if S3_14a  == "Dysménorrhée"
replace S3_14_96  = 0 if S3_14a  == "Gêne chez le partenaire"
replace S3_14_96  = 0 if S3_14a  == "La douleur"
replace S3_14_96  = 0 if S3_14a  == "Menometrorragie"
replace S3_14_96  = 0 if S3_14a  == "Ne sait pas"
replace S3_14_96  = 0 if S3_14a  == "Sage femme"
replace S3_14_96  = 0 if S3_14a  == "Saignements anormaux ,perception du fil"
replace S3_14_96  = 0 if S3_14a  == "Sensation désagréable au cours des rapports"
replace S3_14_96  = 0 if S3_14a  == "Spotting"

*****************************************************************

gen S3_15_5 = 0 if S3_15_1 != . 

order S3_15_5, after(S3_15_4)

label var S3_15_5 "315. De quel mécanisme de suivi disposez-vous/la structure sanitaire dispose-t-e"

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

********************************************************************

gen S3_18_10 = 0 if S3_18_1 != . 

order S3_18_10, after(S3_18_8)

label var S3_18_10 "318. Quelles informations sociodémographiques/liées à la fertilité collectez-vou"

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
 
********************************************************************


replace S3_21_9  = 1 if S3_21a  == "Sage femme qui prenait les infos"
replace S3_21_1  = 1 if S3_21a  == "Si connaissance de la contraception et laquelle"
replace S3_21_1  = 1 if S3_21a  == "Si elle a une fois utilisé injectable"

replace S3_21_96  = 0 if S3_21a  == "Sage femme qui prenait les infos"
replace S3_21_96  = 0  if S3_21a  == "Si connaissance de la contraception et laquelle"
replace S3_21_96  = 0  if S3_21a  == "Si elle a une fois utilisé injectable"

********************************************************************

gen S3_24_3 = 0 if S3_24_1 != . 

label var S3_24_3 "324. Quels examens faites-vous avant de donner des injectables ?: Examen gynécologie"

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

********************************************************************

replace S3_25_7  = 1 if S3_25a  == "Risques hausse de tension artérielle et risques obésité"
replace S3_25_9  = 1 if S3_25a  == "Sage femme qui prenait les infos"


replace S3_25_96  = 0 if S3_25a  == "Risques hausse de tension artérielle et risques obésité"
replace S3_25_96  = 0 if S3_25a  == "Sage femme qui prenait les infos"

********************************************************************

gen S3_27_6 = 0 if S3_27_1 != . 

label var S3_27_6 "327. De quel mécanisme de suivi disposez-vous/l'établissement dispose-t-il, c'es"

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

********************************************************************

gen S3_30_10 = 0 if S3_30_1 != . 

label var S3_30_10 "330. Quelles informations sociodémographiques/liées à la fertilité collectez-vou"

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

********************************************************************

replace S3_33_1  = 1 if S3_33a  == "Les complications liés aux méthodes déjà subi"
replace S3_33_9  = 1 if S3_33a  == "Sage femme qui prenait les infos"
replace S3_33_1  = 1 if S3_33a  == "Si connaissance de la planification familiale et laquelle"
replace S3_33_1  = 1 if S3_33a  == "Si elle a une fois utilisé l'implant"


replace S3_33_96  = 0 if S3_33a  == "Les complications liés aux méthodes déjà subi"
replace S3_33_96  = 0 if S3_33a  == "Sage femme qui prenait les infos"
replace S3_33_96  = 0 if S3_33a  == "Si connaissance de la planification familiale et laquelle"
replace S3_33_96  = 0 if S3_33a  == "Si elle a une fois utilisé l'implant"

********************************************************************
gen S3_34_10 = 0 if S3_34_1 != . 

label var S3_34_10 "334. Quels antécédents médicaux recueillez-vous auprès des nouvelles clientes qu"

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

********************************************************************

gen S3_36_3 = 0 if S3_36_1 != 0

order S3_36_3, after(S3_36_2)

label var S3_36_3 "336. Quels examens faites-vous avant de poser des implants ?: Examen gynécologique?"

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


****************************************************************
gen S3_43_10 = 0 if S3_43_1 != 0

order S3_43_10, after(S3_43_8)

label var S3_43_10 "343. Quelles informations sociodémographiques/liées à la fertilité collectez-vous : adresse et/ou numéro de téléphone"

label value S3_43_10 S3_43_1

replace S3_43_10  = 1 if S3_43a  == "Adresse exacte"
replace S3_43_10  = 1 if S3_43a  == "Téléphone adresse"
replace S3_43_10  = 1 if S3_43a  == "Téléphone, adresse, ethnie"
replace S3_43_10  = 1 if S3_43a  == "Adresse exacte"



replace S3_43_96  = 0 if S3_43a  == "Adresse exacte"
replace S3_43_96  = 0 if S3_43a  == "Téléphone adresse"
replace S3_43_96  = 0 if S3_43a  == "Téléphone, adresse, ethnie"
replace S3_43_96  = 0 if S3_43a  == "Adresse exacte"

********************************************************************
gen S3_51_4 = 0 if S3_51_1 != 0

order S3_51_4, after(S3_51_3)

label var S3_51_4 "351. Selon vous, quels examens de laboratoire prescrivez-vous à la cliente avant : Bilan sanguin"

label value S3_51_4 S3_51_1

replace S3_51_4  = 1 if S3_51a  == "Bilan pré op ,TP,TCK,GSRH"
replace S3_51_4  = 1 if S3_51a  == "Crase sanguine,GSRH"
replace S3_51_4  = 1 if S3_51a  == "TP tck"
replace S3_51_4  = 1 if S3_51a  == "TP TCK GSRH"


replace S3_51_96  = 0 if S3_51a  == "Bilan pré op ,TP,TCK,GSRH"
replace S3_51_96  = 0 if S3_51a  == "Crase sanguine,GSRH"
replace S3_51_96  = 0 if S3_51a  == "TP tck"
replace S3_51_96  = 0 if S3_51a  == "TP TCK GSRH"

******************************************************************

gen S3_57_5 = 0 if S3_57_1 != 0

order S3_57_5, after(S3_51_4)

label var S3_57_5 "357. Quel est le mécanisme de suivi dont vous disposez ou dont l'établissement d : Les clientes disposent des carnets de rendez-vous "

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

*******************************************************************

gen S5_2_6 = 0 if  S5_2_1 != . 
gen S5_2_7 = 0 if  S5_2_1 != . 	
gen S5_2_8 = 0 if  S5_2_1 != . 

label var S5_2_6	"502. En quoi consiste une évaluation initiale rapide ?: : État général"
label var S5_2_7	"502. En quoi consiste une évaluation initiale rapide ?: : Mesures de poids et hauteur utérine"
label var S5_2_8	"502. En quoi consiste une évaluation initiale rapide ?:  : Examen clinique" 


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

********************************************************************

replace S5_16  = 2 if S5_16a  == "Souffrance fatale"
replace S5_16  = 2 if S5_16a  == "Souffrance foetale"
replace S5_16  = 2 if S5_16a  == "Souffrance fœtale"
replace S5_16  = 2 if S5_16a  == "Souffrance foetale"
replace S5_16  = 2 if S5_16a  == "Soufrance foetale aigue"
replace S5_16  = 2 if S5_16a  == "Utérus rompu,souffrance foetale"

label define S5_16 2 "Souffrance foetale", add

********************************************************************

gen S5_20_3 = 0 if S5_20_1 != . 

gen S5_20_4 = 0 if S5_20_1 != . 

gen S5_20_5 = 0 if S5_20_1 != . 

order S5_20_3 S5_20_4 S5_20_5, after(S5_20_2)

label var S5_20_3 "520. Quel est le traitement de l'hypertension gestationnelle (TA diastolique <11"

label var S5_20_4 "520. Quel est le traitement de l'hypertension gestationnelle (TA diastolique <11"

label var S5_20_5 "520. Quel est le traitement de l'hypertension gestationnelle (TA diastolique <11"


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

label define S5_50 2 "A partir du 2 ième degré " 3 "Tous les degrès ", add

******************************************************************
gen S5_53_5 = 0 if S5_53_1 != . 

order S5_53_5, after(S5_53_4)

label var S5_53_5 "553. Comment gérer le cas de rétention de tissus placentaires à l’intérieur de l"

label value S5_53_5 S5_53_1

replace S5_53_5  = 2 if S5_50a  == "La révision utérine"
replace S5_53_5  = 2 if S5_50a  == "On fait une révision utérine"
replace S5_53_5  = 2 if S5_50a  == "Révision uterine"
replace S5_53_5  = 2 if S5_50a  == "Révision utérine"
replace S5_53_5  = 2 if S5_50a  == "Révision utérine"
replace S5_53_5  = 2 if S5_50a  == "Révision utérine"
replace S5_53_5  = 3 if S5_50a  == "Révision utérine"
replace S5_53_5  = 3 if S5_50a  == "Révision utérine"
replace S5_53_5  = 3 if S5_50a  == "Révision utérine"
replace S5_53_5  = 3 if S5_50a  == "Révision utérine"
replace S5_53_5  = 3 if S5_50a  == "Révision utérine"
replace S5_53_5  = 3 if S5_50a  == "Révision utérine"
replace S5_53_5  = 3 if S5_50a  == "Révision utérine avec la main et un gant"
replace S5_53_5  = 3 if S5_50a  == "Révision utérine sous anesthésie"
replace S5_53_5  = 3 if S5_50a  == "Révision utérine, antibiotiques si rétention ancienne"

******************************************************************

gen S5_61_6 = 0 if S5_61_1 != . 

order S5_61_6,after(S5_61_5)

label value S5_61_6 S5_61_1

label var S5_61_6 "561. Quelles sont les composantes du score de Bishop ?: Consistance et/ou position?"

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
replace S5_71  = 2 if S5_71a  == "V"

label define S5_71 2 "Niveau V", add

******************************************************************


