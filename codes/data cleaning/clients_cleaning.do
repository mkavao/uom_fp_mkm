/*******************************************************************************************
									TRAITEMENT DE LA BASE CLIENT

******************************************************************************************/
*initialize Stata
clear all
set more off
set mem 100m
cd "F:\Dropbox_APHRC\Dropbox\FP-Project-APHRC-UM\Atelier_FP\Data\clean"
use "F:\Dropbox_APHRC\Dropbox\FP-Project-APHRC-UM\Atelier_FP\Data\raw\client_data_long_raw.dta"

destring _all,replace
compress
lab def yesno 0 non 1 oui -5 missing -9 na,modify

* Supprimer les variables
drop obs fin formdef_version start end today deviceid subscriberid simid devicephonenum equipe enqueteur   

ren nom_structure s1_6
ren autre_structure s1_6b

ren s200a s2_1
drop  s200b 

ren s200b_1 s2_2a
ren s200b_2 s2_2b
ren s200b_3 s2_2c
ren s200b_4 s2_2d
ren s200b_5 s2_2e
ren s200b_6 s2_2f
ren s200b_7 s2_2g
ren s200b_8 s2_2h
ren v26 s2_2h_aut

label variable s2_2a "Le client a reçu le service de Planification Familiale"
label variable s2_2b "Le client a reçu le service de Consultations prénatales"
label variable s2_2c "Le client a reçu le service de Complications grossesse"
label variable s2_2d "Le client a reçu le service Accouchement"
label variable s2_2e "Le client a reçu le service de Consultations postnatales"
label variable s2_2f "Le client a reçu le service de Survie de l'enfant"
label variable s2_2g "Le client a reçu le service Pesée/Vaccination des enfants"
label variable s2_2h "Le client a reçu un Autre service"
label variable s2_2h_aut "Autre service specify"



label variable s3_1 "Sexe du client"
label variable s3_2 "Age du client"

drop s3_3
ren s3_3_a s3_3a
ren s3_3_b s3_3b
ren s3_3_c s3_3c

label variable s3_3a "Pouvez-vous lire?"
label variable s3_3b "Pouvez-vous écrire?"
label variable s3_3c "Pouvez-vous lire et écrire?"

label variable s3_4 "Quel est le niveau scolaire le plus élevé que vous avez atteint?"
label variable s3_5 "Quelle est votre situation professionnelle actuelle ?"
label variable s3_6 "Quelle est votre situation matrimoniale actuelle ?"
label variable s3_7 "Quel est votre milieu de résidence, urbain ou rural ?"
label variable s3_8 "Quelle est la distance entre votre domicile et la structure sanitaire (dans laquelle nous nous trouvons) ?"
label variable s3_9 "Quel type de transport avez-vous utilisé pour venir ici à cette structure sanitaire ?"
label variable s3_9_1 "Veuillez préciser le type de transport"

ren s3_9_1 s3_9aut

label variable s3_10 "Quel type de transport utilisez-vous habituellement pour venir à cette structure sanitaire ?"
label variable s3_10_1 "Veuillez préciser le type de transport"

ren s3_10_1 s3_10aut
drop produitb_label

label variable s3_11 "Quel est le temps de trajet moyen avec le ${produitb_label} entre votre domicile et la structure sanitaire ?"


label variable s4_2 "A quelle heure êtes-vous arrivé à la structure sanitaire aujourd'hui ?"
label variable s4_3 "A quelle heure avez-vous vu le prestataire (médecin/infirmière/conseiller) ?"


label variable s4_5 "A quelle heure êtes-vous arrivé à la structure sanitaire le jour de l'admission ?"
label variable s4_6 "Quand avez-vous été admis à la structure sanitaire ?"

drop s4_7

ren s4_7_a s4_7a
ren s4_7_b s4_7b
ren s4_7_c s4_7c
ren s4_7_d s4_7d
ren s4_7_e s4_7e
ren s4_7_f s4_7f
ren s4_7_x s4_7x
ren s4_7_aut s4_7x_aut

label variable s4_7a "Raison du retard: Défaut de disponibilité de lut"
label variable s4_7b "Raison du retard: Défaut de personnel"
label variable s4_7c "Raison du retard: Longues formalités et travail sur papier"
label variable s4_7d "Raison du retard: Attitude décontractée du personnel"
label variable s4_7e "Raison du retard: Retard dans la mobilisation de l'argent"
label variable s4_7f "Raison du retard: Retard de prise de décision familiale"
label variable s4_7x "Raison du retard: Autres"
label variable s4_7x_aut "Préciser autre"

label variable s4_8 "Combien de jours avez-vous été admis dans cette structure sanitaire ?"
label variable s4_9 "Une civière et/ou une chaise roulante étaient-elles disponibles dans la structure sanitaire pour vous transférer ?"
label variable s4_10 "Avez-vous été orienté vers cette structure sanitaire par un prestataire d'une autre structure ?"
label variable s4_11 "Le prestataire vous a-t-il donné ou prescrit des médicaments à prendre le temps d'être admis ici ?"
label variable s4_12 "Puis-je voir tous les médicaments administrés et toutes les ordonnances qui ont été délivrées ?"
label variable s4_13 "Vous a-t-on clairement indiqué la quantité de chaque médicament à prendre et pendant combien de temps ?"
label variable s4_14 "Avez-vous payé une somme quelconque pour les services reçus dans la structure sanitaire ?"
label variable s4_15 "Combien avez-vous payé pour ces services ?"
label variable s4_16 "Avez-vous une fois utilisé quelque chose ou essayé un quelconque moyen pour retarder ou éviter une grossesse ?"

drop s4_17

ren s4_17_a s4_17a 
ren s4_17_b s4_17b
ren s4_17_c s4_17c
ren s4_17_d s4_17d
ren s4_17_e s4_17e
ren s4_17_f s4_17f
ren s4_17_g s4_17g
ren s4_17_h s4_17h
ren s4_17_i s4_17i
ren s4_17_j s4_17j
ren s4_17_x s4_17x
ren s4_17_1 s4_17x_aut


label variable s4_17a "A utilisé Pilules pour retarder ou éviter la grossesse"
label variable s4_17b "A utilisé Injectable pour retarder ou éviter la grossesse"
label variable s4_17c "A utilisé Préservatif masculin pour retarder ou éviter la grossesse"
label variable s4_17d "A utilisé Préservatif féminin pour retarder ou éviter la grossesse"
label variable s4_17e "A utilisé Contraception d'urgence pour retarder ou éviter la grossesse"
label variable s4_17f "A utilisé DIU pour retarder ou éviter la grossesse"
label variable s4_17g "A utilisé Implants pour retarder ou éviter la grossesse"
label variable s4_17h "A utilisé Stérilisation féminine pour retarder ou éviter la grossesse"
label variable s4_17i "A utilisé Stérilisation masculine pour retarder ou éviter la grossesse"
label variable s4_17j "A utilisé Allaitement maternel Exclusif pour retarder ou éviter la grossesse"
label variable s4_17x "A utilisé Autre pour retarder ou éviter la grossesse"
label variable s4_17x_aut "Veuillez préciser ce que vous avez utilisé"


label variable s4_18 "Quel est le principal service de planification familiale pour lequel vous êtes venu(e) à la structure sanitaire ?"
label variable s4_18_1 "Veuillez préciser le service"
ren s4_18_1 s4_18aut

label variable s4_19a "Etes-vous entrain d'avoir (avez-vous eu) des problèmes avec la méthode actuelle ?"

drop s4_19b

ren s4_19b_a s4_19b1
ren s4_19b_b s4_19b2
ren s4_19b_c s4_19b3
ren s4_19b_d s4_19b4
ren s4_19b_e s4_19b5
ren s4_19b_f s4_19b6
ren s4_19b_x s4_19b7
ren s4_19b_1 s4_19b7aut


label variable s4_19b1 "Problème avec la méthode actuelle: Saignements vaginaux irréguliers"
label variable s4_19b2 "Problème avec la méthode actuelle: Nausées"
label variable s4_19b3 "Problème avec la méthode actuelle: Maux de tête"
label variable s4_19b4 "Problème avec la méthode actuelle: Ballonnement"
label variable s4_19b5 "Problème avec la méthode actuelle: Changements de la peau"
label variable s4_19b6 "Problème avec la méthode actuelle: Sauts d'humeur"
label variable s4_19b7 "Autres"
label variable s4_19b7aut "Veuillez préciser le(les) autre(s) problème(s)"

label variable s4_21 "Avant de venir dans cet établissement, utilisiez-vous (ou votre partenaire utilisait-il) une méthode quelconque pour éviter une grossesse ?"
label variable s4_22 "Quelle méthode utilisiez-vous/votre partenaire (la dernière) avant de venir dans ce centre ?"
label variable s4_22_ "Préciser autre"
ren s4_22_ s4_22aut

label variable s4_24 "Avez-vous pensé, vous ou votre partenaire, à utiliser une méthode particulière avant de venir dans ce centre ?"
drop s4_25

ren s4_25_? s4_25?

label variable s4_25a "Méthode à laquelle vous pensiez, vous ou votre partenaire: Pilules"
label variable s4_25b "Méthode à laquelle vous pensiez, vous ou votre partenaire: Injectable"
label variable s4_25c "Méthode à laquelle vous pensiez, vous ou votre partenaire: Préservatif masculin"
label variable s4_25d "Méthode à laquelle vous pensiez, vous ou votre partenaire: Préservatif féminin"
label variable s4_25e "Méthode à laquelle vous pensiez, vous ou votre partenaire: Contraception d'urgence"
label variable s4_25f "Méthode à laquelle vous pensiez, vous ou votre partenaire: DIU"
label variable s4_25g "Méthode à laquelle vous pensiez, vous ou votre partenaire: Implants"
label variable s4_25h "Méthode à laquelle vous pensiez, vous ou votre partenaire: Stérilisation féminine"
label variable s4_25i "Méthode à laquelle vous pensiez, vous ou votre partenaire: Stérilisation masculine"
label variable s4_25j "Méthode à laquelle vous pensiez, vous ou votre partenaire: Allaitement maternel exclusif"
label variable s4_25x "Méthode à laquelle vous pensiez, vous ou votre partenaire: Autre"

label variable s4_27 "Avez-vous/votre partenaire pensé à changer de méthode avant de venir dans cette structure d'accueil ?"


label variable s4_28 "Aviez-vous/votre partenaire, une méthode de planification familiale particulière à l'esprit avant de venir à la structure sanitaire aujourd'hui ?"

drop s4_29

ren s4_29_? s4_29?
ren s4_29_ s4_29x_aut

label variable s4_29a "Méthode à laquelle vous avez envisagé de changer : Pilules"
label variable s4_29b "Méthode à laquelle vous avez envisagé de changer : Injectable"
label variable s4_29c "Méthode à laquelle vous avez envisagé de changer : Préservatif masculin"
label variable s4_29d "Méthode à laquelle vous avez envisagé de changer : Préservatif féminin"
label variable s4_29e "Méthode à laquelle vous avez envisagé de changer : Contraception d'urgence"
label variable s4_29f "Méthode à laquelle vous avez envisagé de changer : DIU"
label variable s4_29g "Méthode à laquelle vous avez envisagé de changer : Implants"
label variable s4_29h "Méthode à laquelle vous avez envisagé de changer : Stérilisation masculine"
label variable s4_29i "Méthode à laquelle vous avez envisagé de changer : Stérilisation féminine"
label variable s4_29j "Méthode à laquelle vous avez envisagé de changer : Allaitement maternel exclusif"
label variable s4_29x "Méthode à laquelle vous avez envisagé de changer : Autre"
label variable s4_29x_aut "Préciser autre"

ren s4_30_1 s4_30a
ren s4_30_2 s4_30b
ren s4_30_3 s4_30c
ren s4_30_4 s4_30d
ren s4_30_5 s4_30e
ren s4_30_6 s4_30f
ren s4_30_7 s4_30g
ren s4_30_8 s4_30h
ren s4_30_9 s4_30i
ren s4_30_10 s4_30j
ren s4_30_11 s4_30x
ren s4_30_11_other s4_30x_aut

label variable s4_30a "Méthode de PF reçue aujourd'hui, ou méthode sur laquelle vous avez obtenu une ordonnance ou référence: Pilules"
label variable s4_30b "Méthode de PF reçue aujourd'hui, ou méthode sur laquelle vous avez obtenu une ordonnance ou référence: Injectables"
label variable s4_30c "Méthode de PF reçue aujourd'hui, ou méthode sur laquelle vous avez obtenu une ordonnance ou référence: Préservatif masculin"
label variable s4_30d "Méthode de PF reçue aujourd'hui, ou méthode sur laquelle vous avez obtenu une ordonnance ou référence: Préservatif féminin"
label variable s4_30e "Méthode de PF reçue aujourd'hui, ou méthode sur laquelle vous avez obtenu une ordonnance ou référence: Contraception d'urgence"
label variable s4_30f "Méthode de PF reçue aujourd'hui, ou méthode sur laquelle vous avez obtenu une ordonnance ou référence: DIU"
label variable s4_30g "Méthode de PF reçue aujourd'hui, ou méthode sur laquelle vous avez obtenu une ordonnance ou référence: Implants"
label variable s4_30i "Méthode de PF reçue aujourd'hui, ou méthode sur laquelle vous avez obtenu une ordonnance ou référence: Stérilisation masculine"
label variable s4_30h "Méthode de PF reçue aujourd'hui, ou méthode sur laquelle vous avez obtenu une ordonnance ou référence: Stérilisation féminine"
label variable s4_30j "Méthode de PF reçue aujourd'hui, ou méthode sur laquelle vous avez obtenu une ordonnance ou référence: Allaitement maternel exclusif"
label variable s4_30x "Méthode de PF reçue aujourd'hui, ou méthode sur laquelle vous avez obtenu une ordonnance ou référence: Autre"
lab var s4_30x_aut "Préciser autre"

drop s4_32
ren s4_32_a s4_32a
ren s4_32_b s4_32b
ren s4_32_c s4_32c
ren s4_32_d s4_32d
ren s4_32_x s4_32x
ren s4_32_autre s4_32x_autre


label variable s4_32a "Raison for change: Méthode non disponible dans la structure"
label variable s4_32b "Raison for change: La structure sanitaire ne fournit pas la méthode"
label variable s4_32c "Raison for change: Prestataire de santé l'a suggéré"
label variable s4_32d "Raison for change: Inaptitude médicale"
label variable s4_32x "Raison for change: Autre"
label variable s4_32x_autre "Préciser autre"

drop s4_34
ren s4_34_? s4_34?
ren s4_34_ s4_34x_autre

label variable s4_34a "Raisons pour lesquelles vous n'avez pas reçus les services de planning familial dont vous aviez besoin : Service non disponible"
label variable s4_34b "Raisons pour lesquelles vous n'avez pas reçus les services de planning familial dont vous aviez besoin : Le prestataire n'était pas disponible"
label variable s4_34c "Raisons pour lesquelles vous n'avez pas reçus les services de planning familial dont vous aviez besoin : N'a pas trouvé le prestataire suffisamment compétent"
label variable s4_34d "Raisons pour lesquelles vous n'avez pas reçus les services de planning familial dont vous aviez besoin : Orienté vers un autre établissement"
label variable s4_34e "Raisons pour lesquelles vous n'avez pas reçus les services de planning familial dont vous aviez besoin : N'avait pas d'argent pour payer"
label variable s4_34f "Raisons pour lesquelles vous n'avez pas reçus les services de planning familial dont vous aviez besoin : Temps d'attente trop long"
label variable s4_34g "Raisons pour lesquelles vous n'avez pas reçus les services de planning familial dont vous aviez besoin : Appelé à une autre date"
label variable s4_34h "Raisons pour lesquelles vous n'avez pas reçus les services de planning familial dont vous aviez besoin : Pas de femme prestataire"
label variable s4_34x "Raisons pour lesquelles vous n'avez pas reçus les services de planning familial dont vous aviez besoin : Autre"
label variable s4_34x_autre "Préciser autre"



label variable s4_35 "Quel a été le résultat de cette visite ?"
label variable s4_35_1 "Veuillez préciser le résultat de la visite"
ren s4_35_1 s4_35autre

label variable s4_37 "Vous a-t-il demandé si vous souhaitiez avoir un autre enfant ?"
label variable s4_38 "Vous a-t-il interrogé sur le moment où vous souhaiteriez avoir un autre enfant ?"
label variable s4_39 "Vous a-t-il demandé votre dernière expérience sur l'utilisation des méthodes de planification familiale ?"
label variable s4_40 "Vous a-t-il demandé si vous aviez une quelconque méthode en tête avant de venir à la structure sanitaire ?"
label variable s4_41 "Vous a-t-il demandé votre préférence en matière de méthode de planification familiale ?"
label variable s4_42 "Vous a-t-il fourni des informations sur différentes méthodes de planification familiale ?"
label variable s4_43 "Vous a-t-il parlé de la méthode de PF que vous avez choisi ?"
label variable s4_44 "Vous a-t-il parlé du mode de fonctionnement de la méthode que vous avez choisi ?"
label variable s4_45 "Vous a-t-il parlé des possibles effets secondaires de la méthode que vous avez choisie ?"
label variable s4_46 "Vous a-t-il parlé de ce que vous devez faire quand vous noterez des effets secondaires ou des problèmes par rapport à la méthode que vous avez choisie ?"
label variable s4_47 "Vous a-t-il parlé des signes d'alerte de la méthode vous avez choisie ?"
label variable s4_48 "Vous a-t-il dit quand revenir au centre de santé pour une visite de suivi ?"
label variable s4_49 "Vous a-t-il remis une carte de rendez-vous pour la visite de suivi ?"
label variable s4_50 "Vous a-t-il parlé d'autres sources auprès desquelles vous pouviez obtenir des produits de planification familiale ?"
label variable s4_51 "Vous a-t-il parlé de la possibilité de changer de méthode de planification familiale si celle choisit ne vous convient plus ?"
label variable s4_52 "Vous a-t-il fourni des informations tout en encourageant fortement une méthode ?"
label variable s4_53 "Vous a-t-il fourni des méthodes qui protègent contre le VIH/SIDA et des autres IST ?"
label variable s4_54 "Le prestataire vous-a-t-il permis de poser des questions ?"
label variable s4_55 "Le prestataire a-t-il répondu à toutes vos questions pour vous satisfaire ?"
label variable s4_56 "Durant votre visite, pouvez-vous dire que vous avez été bien traité par le prestataire ?"
label variable s4_57 "Comment appréciez-vous les informations que vous avez reçues à propos de la méthode de planification familiale que vous avez choisie par rapport à ce que vous souhaitiez ?"
label variable s4_58 "Le prestataire, vous a-t-il recommandé une méthode plutôt qu'une autre ? Si Oui, diriez-vous tout le temps, la plupart du temps ou quelques fois ?"
label variable s4_59 "Avez-vous le sentiment d'être à l'abri des regards pendant votre entretien avec le prestataire et qu'aucun autre client ou patient de la structure sanitaire ne pouvait vous voir pendant votre consultation (comme lors d'un examen physique) ? Si Oui, diriez-vous tout le temps, la plupart du temps ou quelques fois ?"
label variable s4_60 "Vous sentiez-vous capable de discuter de vos problèmes avec les médecins, les infirmières ou d'autres prestataires, sans que d'autres personnes non impliquées dans vos soins n'entendent vos conversations ? Si Oui, diriez-vous tout le temps, la plupart du temps ou quelques fois ?"
label variable s4_61 "Pensez-vous que les informations personnelles que vous avez partagées avec le prestataire seront confidentielles ? Si Oui, diriez-vous tout le temps, la plupart du temps ou quelques fois ?"
label variable s4_62 "Sentez-vous que le médecin, l'infirmier ou les autres membres du personnel vous ont traité avec respect ? Si Oui, diriez-vous tout le temps, la plupart du temps ou quelques fois ?"
label variable s4_63 "Sentez-vous que le médecin, l'infirmier ou les autres membres du personnel vous ont traité d'une manière amicale ? Si Oui, diriez-vous tout le temps, la plupart du temps ou quelques fois ?"
label variable s4_64 "Pensez-vous que l'environnement de la structure sanitaire y compris les toilettes sont propres ? Si Oui, diriez-vous tout le temps, la plupart du temps ou quelques fois ?"
label variable s4_65 "Comment s'est déroulée l'expérience concernant les dispositions prises dans la structure sanitaire pendant l'attente d'un service ? Par exemple, la disposition des sièges, l'ordre des appels, etc."
label variable s4_66 "Avez-vous eu le sentiment de pouvoir poser toutes vos questions aux médecins, aux infirmières ou aux autres membres du personnel de la structure sanitaire ? SI Oui, diriez-vous tout le temps, la plupart du temps ou quelques fois ?"
label variable s4_67 "Avez-vous eu l'impression que les médecins, les infirmières ou les autres membres du personnel de la structure sanitaire vous ont fait participer aux décisions concernant vos soins ? Si Oui, diriez-vous tout le temps, la plupart du temps ou quelques fois ?"
label variable s4_68 "Diriez-vous que vous avez été traité différemment en raison d'une caractéristique personnelle, comme votre âge, votre situation matrimoniale, le nombre de vos enfants, votre éducation, votre fortune, ou quelque chose de ce genre ? SI Oui, diriez-vous tout le temps, la plupart du temps ou quelques fois ?"
label variable s4_69 "Avez-vous eu l'impression d'être traité brutalement ? Par exemple, avez-vous été poussé, battu, giflé, pincé, contraint physiquement ou bâillonné, ou maltraité physiquement d'une autre manière ? SI Oui, diriez-vous tout le temps, la plupart du temps ou quelques fois ?"
label variable s4_70 "Avez-vous eu l'impression que les médecins, les infirmières ou les autres prestataires de soins de santé vous ont-ils, crié dessus, vous ont grondé, vous ont insulté, menacé ou vous ont parlé grossièrement ? SI Oui, diriez-vous tout le temps, la plupart du temps ou quelques fois ?"
label variable s4_71 "Compte tenu de votre expérience d'aujourd'hui, diriez-vous que vous êtes entièrement satisfait, partiellement satisfait ou pas du tout satisfait des services de services de planning familial fournis ?"
label variable s4_72 "Quelles sont les raisons de cette insatisfaction ?"
label variable s4_73 "Si nécessaire, reviendrez-vous à l'avenir dans cette structure sanitaire pour des services de planification familiale ?"
label variable s4_75 "Le temps d'attente pour consulter un prestataire dans cette structure sanitaire a-t-il été un problème ? SI Oui, diriez-vous qu'il s'agit d'un problème majeur ou mineur ?"
label variable s4_76 "Les heures d'ouverture et de fermeture de la structure sanitaire ont-elles posé problème ? SI Oui, diriez-vous qu'il s'agit d'un problème majeur ou mineur ?"
label variable s4_77 "Le nombre de jours pendant lesquels les services sont disponibles dans cette structure sanitaire vous a-t-il posé un problème ? SI Oui, diriez-vous qu'il s'agit d'un problème majeur ou mineur ?"
label variable s4_78 "Les coûts des services de planification familiale de cette structure sanitaire vous-a-t-il posé problème ? SI Oui, diriez-vous qu'il s'agit d'un problème majeur ou mineur ?"
label variable s4_79 "S'agit-il de la structure sanitaire offrant des services de planification familiale la plus proche de votre domicile ?"
label variable s4_80 "Quelle est la principale raison pour laquelle vous ne vous êtes pas rendu dans la structure sanitaire le plus proche de votre domicile ?"

replace s3_4 = -9 if s3_3c == 1

aorder
order key gpslatitude gpslongitude gpsaltitude gpsaccuracy

ren key id
drop if s2_2a!=1

foreach var of var  s4_6 s4_7a	s4_7b s4_7c	s4_7d s4_7e	s4_7f s4_7x s4_8 s4_9	s4_10 s4_11	s4_12 s4_13 {
	replace `var' = -9 if s2_1!=2
}


foreach var of var  s4_7a	s4_7b s4_7c	s4_7d s4_7e	s4_7f s4_7x  {
	replace `var' = -9 if !inlist(s4_6,3,4)
}

foreach var of var  s4_12	s4_13  {
	replace `var' = -9 if inlist(s4_11,4)
}


foreach var of var  s4_15  {
	replace `var' = -9 if inlist(s4_14,2)
}
										
foreach var of var  s4_17a	s4_17b	s4_17c	s4_17d	s4_17e	s4_17f	s4_17g	s4_17h	s4_17i	s4_17j	s4_17x	  {
	replace `var' = -9 if inlist(s4_16,2)
}

foreach var of var  s4_19a	s4_19b1	s4_19b2	s4_19b3	s4_19b4	s4_19b5	s4_19b6	s4_19b7  {
	replace `var' = -9 if inlist(s4_18,1,6,5)
}

replace s4_22="1" if s4_22=="A"
replace s4_22="2" if s4_22=="B"
replace s4_22="3" if s4_22=="C"
replace s4_22="4" if s4_22=="D"
replace s4_22="5" if s4_22=="E"
replace s4_22="6" if s4_22=="F"
replace s4_22="7" if s4_22=="G"
replace s4_22="8" if s4_22=="H"
replace s4_22="9" if s4_22=="I"
replace s4_22="10" if s4_22=="J"
replace s4_22="96" if s4_22=="X"

destring s4_22,replace

lab def s4_22 1 Pilules	2 Injectable 3 "Préservatif masculin" 4 "Préservatif féminin" 5 "Contraception d'urgence" 6 DIU	7 Implants 8 "Stérilisation féminine (Ligature des trompes)" 9 "Stérilisation masculine (Vasectomie)" 10 "Allaitement maternel exclusif (MAMA)" 96 Autre, modify

lab val s4_22 s4_22
foreach var of var  s4_21  s4_22 {
	replace `var' = -9 if !inlist(s4_16,1)
}

replace s4_22=-9 if s4_21==2

foreach var of var  s4_24  s4_25a	s4_25b	s4_25c	s4_25d	s4_25e	s4_25f	s4_25g	s4_25h	s4_25i	s4_25j	s4_25x {
	replace `var' = -9 if !inlist(s4_21,2)
}

foreach var of var    s4_25a	s4_25b	s4_25c	s4_25d	s4_25e	s4_25f	s4_25g	s4_25h	s4_25i	s4_25j	s4_25x {
	replace `var' = -9 if inlist(s4_24,2)
}

foreach var of var  s4_27	s4_28	s4_29a	s4_29b	s4_29c	s4_29d	s4_29e	s4_29f	s4_29g	s4_29h	s4_29i	s4_29j	s4_29x {
	replace `var' = -9 if !inlist(s4_21,1)
}

foreach var of var  s4_28 s4_29a	s4_29b	s4_29c	s4_29d	s4_29e	s4_29f	s4_29g	s4_29h	s4_29i	s4_29j	s4_29x {
	replace `var' = -9 if inlist(s4_27,2)
}

foreach var of var   s4_29a	s4_29b	s4_29c	s4_29d	s4_29e	s4_29f	s4_29g	s4_29h	s4_29i	s4_29j	s4_29x {
	replace `var' = -9 if inlist(s4_28,2)
}

replace s4_35="96" if s4_35=="X"
destring s4_35,replace


lab def s4_35 1 "Poursuivre ou recommencez avec la même méthode" 2 "Méthode de changement" 3 "Cesser d'utiliser la méthode en raison d'un problème"	4 "Cesser d'utiliser la méthode (facultative – pas de problème)" 5 "Adopter une méthode"  6 "Décidera plus tard" 7 "Demande de revenir un autre jour"	8 "Renvoyé"	96 "Autres (Précisez)"	,modify
lab val s4_35 s4_35

replace s4_72="1" if s4_72=="A"
replace s4_72="2" if s4_72=="B"
replace s4_72="3" if s4_72=="C"
replace s4_72="4" if s4_72=="D"
replace s4_72="96" if s4_72=="X"

destring s4_72,replace

lab def s4_72 1 "Manque d'installations"	2 "Qualité médiocre du service" 3 "Mauvaise relation client-soignant" 4 "Frais trop élevée" 96 Autre, modify

lab val s4_72 s4_72

foreach var of var  s4_72  {
	replace `var' = -9 if !inlist(s4_71,2,3)
}

	replace s4_80 = -9 if !inlist(s4_79,2)



lab val s4_17a	s4_17b	s4_17c	s4_17d	s4_17e	s4_17f	s4_17g	s4_17h	s4_17i	s4_17j	s4_17x	 s4_7a	s4_7b s4_7c	s4_7d s4_7e	s4_7f s4_7x s2_2a	s2_2b	s2_2c	s2_2d	s2_2e	s2_2f	s2_2g	s2_2h s4_19b1	s4_19b2	s4_19b3	s4_19b4	s4_19b5	s4_19b6	s4_19b7   s4_25a	s4_25b	s4_25c	s4_25d	s4_25e	s4_25f	s4_25g	s4_25h	s4_25i	s4_25j	s4_25x s4_29a	s4_29b	s4_29c	s4_29d	s4_29e	s4_29f	s4_29g	s4_29h	s4_29i	s4_29j	s4_29x s4_32a s4_32b s4_32c s4_32d s4_32x s4_34a	s4_34b	s4_34c	s4_34d	s4_34e	s4_34f	s4_34g	s4_34h	s4_34x yesno

drop submissiondate
	
								
								
save "F:\Dropbox_APHRC\Dropbox\FP-Project-APHRC-UM\Atelier_FP\Data\clean\client_data_long_clean.dta",replace
