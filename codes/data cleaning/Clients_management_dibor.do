/*******************************************************************************************
									TRAITEMENT DE LA BASE CLIENT

******************************************************************************************/
clear all

*Importation de la base
import excel "D:\APHRC\APHRC\Codes_FP_Dibor\Dibor's Part\Clients\QUESTIONNAIRE CLIENTE PF_WIDE.xlsx", firstrow

* Supprimer les variables
drop gpsAltitude gpsAccuracy obs fin instanceID formdef_version ///
     SubmissionDate start end today deviceid subscriberid simid ///
     devicephonenum equipe enqueteur gpsLatitude gpsLongitude  

* Vérifier les variables restantes
describe

*******************************LABELISATION DES VARIABLES ***************


label variable s1_1 "Nom de la région"
label variable s1_3 "Nom du district"
label variable s1_5 "Type de lieu"
label variable s200a "Ce client sort-il du service de consultation (SC) ou de l'hospitalisation (SH) de la maternité ?"
label variable s200b_1 "Le client a reçu le service de Planification Familiale"
label variable s200b_2 "Le client a reçu le service de Consultations prénatales"
label variable s200b_3 "Le client a reçu le service de Complications grossesse"
label variable s200b_4 "Le client a reçu le service Accouchement"
label variable s200b_5 "Le client a reçu le service de Consultations postnatales"
label variable s200b_6 "Le client a reçu le service de Survie de l'enfant"
label variable s200b_7 "Le client a reçu le service Pesée/Vaccination des enfants"
label variable s200b_8 "Le client a reçu un Autre service"
label variable Z "Veuillez préciser l'(les) autre(s) service(s) reçu(s)"
label variable s3_1 "Sexe du client"
label variable s3_2 "Age du client"
label variable s3_3_A "Pouvez-vous lire ?"
label variable s3_3_B "Pouvez-vous écrire ?"
label variable s3_3_C "Pouvez-vous lire et écrire ?"
label variable s3_4 "Quel est le niveau scolaire le plus élevé que vous avez atteint ?"
label variable s3_5 "Quelle est votre situation professionnelle actuelle ?"
label variable s3_6 "Quelle est votre situation matrimoniale actuelle ?"
label variable s3_7 "Quel est votre milieu de résidence, urbain ou rural ?"
label variable s3_8 "Quelle est la distance entre votre domicile et la structure sanitaire (dans laquelle nous nous trouvons) ?"
label variable s3_9 "Quel type de transport avez-vous utilisé pour venir ici à cette structure sanitaire ?"
label variable s3_9_1 "Veuillez préciser le type de transport"
label variable s3_10 "Quel type de transport utilisez-vous habituellement pour venir à cette structure sanitaire ?"
label variable s3_10_1 "Veuillez préciser le type de transport"
label variable s3_11 "Quel est le temps de trajet moyen avec le ${produitb_label} entre votre domicile et la structure sanitaire ?"
label variable s4_2 "A quelle heure êtes-vous arrivé à la structure sanitaire aujourd'hui ?"
label variable s4_3 "A quelle heure avez-vous vu le prestataire (médecin/infirmière/conseiller) ?"
label variable s4_5 "A quelle heure êtes-vous arrivé à la structure sanitaire le jour de l'admission ?"
label variable s4_6 "Quand avez-vous été admis à la structure sanitaire ?"
label variable s4_7_A "Raison du retard: Défaut de disponibilité de lut"
label variable s4_7_B "Raison du retard: Défaut de personnel"
label variable s4_7_C "Raison du retard: Longues formalités et travail sur papier"
label variable s4_7_D "Raison du retard: Attitude décontractée du personnel"
label variable s4_7_E "Raison du retard: Retard dans la mobilisation de l'argent"
label variable s4_7_F "Raison du retard: Retard de prise de décision familiale"
label variable s4_7_X "Raison du retard: Autres"
label variable s4_7_aut "Préciser autre"
label variable s4_8 "Combien de jours avez-vous été admis dans cette structure sanitaire ?"
label variable s4_9 "Une civière et/ou une chaise roulante étaient-elles disponibles dans la structure sanitaire pour vous transférer ?"
label variable s4_10 "Avez-vous été orienté vers cette structure sanitaire par un prestataire d'une autre structure ?"
label variable s4_11 "Le prestataire vous a-t-il donné ou prescrit des médicaments à prendre le temps d'être admis ici ?"
label variable s4_12 "Puis-je voir tous les médicaments administrés et toutes les ordonnances qui ont été délivrées ?"
label variable s4_13 "Vous a-t-on clairement indiqué la quantité de chaque médicament à prendre et pendant combien de temps ?"
label variable s4_14 "Avez-vous payé une somme quelconque pour les services reçus dans la structure sanitaire ?"
label variable s4_15 "Combien avez-vous payé pour ces services ?"
label variable s4_16 "Avez-vous une fois utilisé quelque chose ou essayé un quelconque moyen pour retarder ou éviter une grossesse ?"
label variable s4_17_A "A utilisé Pilules pour retarder ou éviter la grossesse"
label variable s4_17_B "A utilisé Injectable pour retarder ou éviter la grossesse"
label variable s4_17_C "A utilisé Préservatif masculin pour retarder ou éviter la grossesse"
label variable s4_17_D "A utilisé Préservatif féminin pour retarder ou éviter la grossesse"
label variable s4_17_E "A utilisé Contraception d'urgence pour retarder ou éviter la grossesse"
label variable s4_17_F "A utilisé DIU pour retarder ou éviter la grossesse"
label variable s4_17_G "A utilisé Implants pour retarder ou éviter la grossesse"
label variable s4_17_H "A utilisé Stérilisation féminine pour retarder ou éviter la grossesse"
label variable s4_17_I "A utilisé Stérilisation masculine pour retarder ou éviter la grossesse"
label variable s4_17_J "A utilisé Allaitement maternel Exclusif pour retarder ou éviter la grossesse"
label variable s4_17_X "A utilisé Autre pour retarder ou éviter la grossesse"
label variable s4_17_1 "Veuillez préciser ce que vous avez utilisé"
label variable s4_18 "Quel est le principal service de planification familiale pour lequel vous êtes venu(e) à la structure sanitaire ?"
label variable s4_18_1 "Veuillez préciser le service"
label variable s4_19a "Etes-vous entrain d'avoir (avez-vous eu) des problèmes avec la méthode actuelle ?"
label variable s4_19b_A "Problème avec la méthode actuelle: Saignements vaginaux irréguliers"
label variable s4_19b_B "Problème avec la méthode actuelle: Nausées"
label variable s4_19b_C "Problème avec la méthode actuelle: Maux de tête"
label variable s4_19b_D "Problème avec la méthode actuelle: Ballonnement"
label variable s4_19b_E "Problème avec la méthode actuelle: Changements de la peau"
label variable s4_19b_F "Problème avec la méthode actuelle: Sauts d'humeur"
label variable s4_19b_X "Autres"
label variable s4_19b_1 "Veuillez préciser le(les) autre(s) problème(s)"
label variable s4_21 "Avant de venir dans cet établissement, utilisiez-vous (ou votre partenaire utilisait-il) une méthode quelconque pour éviter une grossesse ?"
label variable s4_22 "Quelle méthode utilisiez-vous/votre partenaire (la dernière) avant de venir dans ce centre ?"
label variable s4_22_ "Préciser autre"
label variable s4_24 "Avez-vous pensé, vous ou votre partenaire, à utiliser une méthode particulière avant de venir dans ce centre ?"
label variable s4_25_A "Méthode à laquelle vous pensiez, vous ou votre partenaire: Pilules"
label variable s4_25_B "Méthode à laquelle vous pensiez, vous ou votre partenaire: Injectable"
label variable s4_25_C "Méthode à laquelle vous pensiez, vous ou votre partenaire: Préservatif masculin"
label variable s4_25_D "Méthode à laquelle vous pensiez, vous ou votre partenaire: Préservatif féminin"
label variable s4_25_E "Méthode à laquelle vous pensiez, vous ou votre partenaire: Contraception d'urgence"
label variable s4_25_F "Méthode à laquelle vous pensiez, vous ou votre partenaire: DIU"
label variable s4_25_G "Méthode à laquelle vous pensiez, vous ou votre partenaire: Implants"
label variable s4_25_H "Méthode à laquelle vous pensiez, vous ou votre partenaire: Stérilisation féminine"
label variable s4_25_I "Méthode à laquelle vous pensiez, vous ou votre partenaire: Stérilisation masculine"
label variable s4_25_J "Méthode à laquelle vous pensiez, vous ou votre partenaire: Allaitement maternel exclusif"
label variable s4_25_X "Méthode à laquelle vous pensiez, vous ou votre partenaire: Autre"
label variable s4_27 "Avez-vous/votre partenaire pensé à changer de méthode avant de venir dans cette structure d'accueil ?"
label variable s4_28 "Aviez-vous/votre partenaire, une méthode de planification familiale particulière à l'esprit avant de venir à la structure sanitaire aujourd'hui ?"
label variable s4_29_A "Méthode à laquelle vous avez envisagé de changer : Pilules"
label variable s4_29_B "Méthode à laquelle vous avez envisagé de changer : Injectable"
label variable s4_29_C "Méthode à laquelle vous avez envisagé de changer : Préservatif masculin"
label variable s4_29_D "Méthode à laquelle vous avez envisagé de changer : Préservatif féminin"
label variable s4_29_E "Méthode à laquelle vous avez envisagé de changer : Contraception d'urgence"
label variable s4_29_F "Méthode à laquelle vous avez envisagé de changer : DIU"
label variable s4_29_G "Méthode à laquelle vous avez envisagé de changer : Implants"
label variable s4_29_H "Méthode à laquelle vous avez envisagé de changer : Stérilisation masculine"
label variable s4_29_I "Méthode à laquelle vous avez envisagé de changer : Stérilisation féminine"
label variable s4_29_J "Méthode à laquelle vous avez envisagé de changer : Allaitement maternel exclusif"
label variable s4_29_X "Méthode à laquelle vous avez envisagé de changer : Autre"
label variable s4_29_ "Préciser autre"
label variable s4_30_1 "Méthode de PF reçue aujourd'hui, ou méthode sur laquelle vous avez obtenu une ordonnance ou référence: Pilules"
label variable s4_30_2 "Méthode de PF reçue aujourd'hui, ou méthode sur laquelle vous avez obtenu une ordonnance ou référence: Injectables"
label variable s4_30_3 "Méthode de PF reçue aujourd'hui, ou méthode sur laquelle vous avez obtenu une ordonnance ou référence: Préservatif masculin"
label variable s4_30_4 "Méthode de PF reçue aujourd'hui, ou méthode sur laquelle vous avez obtenu une ordonnance ou référence: Préservatif féminin"
label variable s4_30_5 "Méthode de PF reçue aujourd'hui, ou méthode sur laquelle vous avez obtenu une ordonnance ou référence: Contraception d'urgence"
label variable s4_30_6 "Méthode de PF reçue aujourd'hui, ou méthode sur laquelle vous avez obtenu une ordonnance ou référence: DIU"
label variable s4_30_7 "Méthode de PF reçue aujourd'hui, ou méthode sur laquelle vous avez obtenu une ordonnance ou référence: Implants"
label variable s4_30_8 "Méthode de PF reçue aujourd'hui, ou méthode sur laquelle vous avez obtenu une ordonnance ou référence: Pilules"
label variable s4_30_9 "Méthode de PF reçue aujourd'hui, ou méthode sur laquelle vous avez obtenu une ordonnance ou référence: Stérilisation masculine"
label variable s4_30_10 "Méthode de PF reçue aujourd'hui, ou méthode sur laquelle vous avez obtenu une ordonnance ou référence: Stérilisation féminine"
label variable s4_30_11 "Méthode de PF reçue aujourd'hui, ou méthode sur laquelle vous avez obtenu une ordonnance ou référence: Allaitement maternel exclusif"
label variable s4_30_11_other "Méthode de PF reçue aujourd'hui, ou méthode sur laquelle vous avez obtenu une ordonnance ou référence: Autre"
label variable s4_32_A "Raison qui vous ont amené à recevoir ou à prescrire des méthodes de PF différentes de celles initialement envisagé par vous/votre partenaire: Méthode non disponible dans la structure"
label variable s4_32_B "Raison qui vous ont amené à recevoir ou à prescrire des méthodes de PF différentes de celles initialement envisagé par vous/votre partenaire: La structure sanitaire ne fournit pas la méthode"
label variable s4_32_C "Raison qui vous ont amené à recevoir ou à prescrire des méthodes de PF différentes de celles initialement envisagé par vous/votre partenaire: Prestataire de santé l'a suggéré"
label variable s4_32_D "Raison qui vous ont amené à recevoir ou à prescrire des méthodes de PF différentes de celles initialement envisagé par vous/votre partenaire: Inaptitude médicale"
label variable s4_32_X "Raison qui vous ont amené à recevoir ou à prescrire des méthodes de PF différentes de celles initialement envisagé par vous/votre partenaire: Autre"
label variable s4_32_autre "Préciser autre"
label variable s4_34_A "Raisons pour lesquelles vous n'avez pas reçus les services de planning familial dont vous aviez besoin : Service non disponible"
label variable s4_34_B "Raisons pour lesquelles vous n'avez pas reçus les services de planning familial dont vous aviez besoin : Le prestataire n'était pas disponible"
label variable s4_34_C "Raisons pour lesquelles vous n'avez pas reçus les services de planning familial dont vous aviez besoin : N'a pas trouvé le prestataire suffisamment compétent"
label variable s4_34_D "Raisons pour lesquelles vous n'avez pas reçus les services de planning familial dont vous aviez besoin : Orienté vers un autre établissement"
label variable s4_34_E "Raisons pour lesquelles vous n'avez pas reçus les services de planning familial dont vous aviez besoin : N'avait pas d'argent pour payer"
label variable s4_34_F "Raisons pour lesquelles vous n'avez pas reçus les services de planning familial dont vous aviez besoin : Temps d'attente trop long"
label variable s4_34_G "Raisons pour lesquelles vous n'avez pas reçus les services de planning familial dont vous aviez besoin : Appelé à une autre date"
label variable s4_34_H "Raisons pour lesquelles vous n'avez pas reçus les services de planning familial dont vous aviez besoin : Pas de femme prestataire"
label variable s4_34_X "Raisons pour lesquelles vous n'avez pas reçus les services de planning familial dont vous aviez besoin : Autre"
label variable s4_34_ "Préciser autre"
label variable s4_35 "Quel a été le résultat de cette visite ?"
label variable s4_35_1 "Veuillez préciser le résultat de la visite"
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




***********************Identification des vraies valeurs manquantes********
**************Les vraies valeurs manquantes sont remplacées par  -5**********************
*Pour identifer les vraies valeurs manquantes nous avons utilisé le questionnaire XLS_form pour capter tous les sauts

replace s3_4 = -5 if s3_3_C != 1
replace s3_9_1= "-5" if s3_9 == 6
replace s3_10_1= "-5" if s3_10 == 6

replace s3_4 = -5 if s3_3_C == 1


replace s4_2 = -5 if s200a != 1
replace s4_3 = -5 if s200a != 1
replace s4_5 = -5 if s200a != 2
replace s4_6 = -5 if s200a != 2

replace s4_7_A = -5 if s200a!=2 | s4_6!=3 & s4_6!=4
replace s4_7_B = -5 if s200a!=2 | s4_6!=3 & s4_6!=4
replace s4_7_C = -5 if s200a!=2 | s4_6!=3 & s4_6!=4
replace s4_7_D = -5 if s200a!=2 | s4_6!=3 & s4_6!=4

replace s4_7_E = -5 if s200a!=2 | s4_6!=3 & s4_6!=4
replace s4_7_F = -5 if s200a!=2 | s4_6!=3 & s4_6!=4
replace s4_7_X = -5 if s200a!=2 | s4_6!=3 & s4_6!=4

replace s4_7_aut = "-5" if s4_7_X !=1

replace s4_8 = -5	if s200a!=2
replace s4_9 =-5 if s200a!=2
replace s4_10 =-5 if s200a!=2
replace s4_11 =-5	if s200a!=2

replace s4_12 =-5 if  s200a!=2 | s4_11==4
replace s4_13 =-5 if s200a!= 2 | s4_11==4
replace s4_15 =-5 if s4_14!=1

replace s4_17_A =-5 if s4_16!=1
replace s4_17_B =-5 if s4_16!=1
replace s4_17_C =-5 if s4_16!=1
replace s4_17_D =-5 if s4_16!=1
replace s4_17_E =-5 if s4_16!=1
replace s4_17_F =-5 if s4_16!=1
replace s4_17_G =-5 if s4_16!=1
replace s4_17_H =-5 if s4_16!=1
replace s4_17_I =-5 if s4_16!=1
replace s4_17_J =-5 if s4_16!=1
replace s4_17_X =-5 if s4_16!=1

replace s4_19a = -5 if s4_18 !=2 & s4_18 !=3 & s4_18 !=4


replace s4_18_1 = "-5" if s4_18!= 6

replace s4_19b_1 = "-5" if s4_19b_X != 1

**Imputation de toutes variables commençant par s4_19b_

foreach var of varlist s4_19b_* {
    * Vérifier si la variable est numérique
    capture confirm numeric variable `var'
    if !_rc {
        replace `var' = -5 if s4_18 !=2 & s4_18 !=3 & s4_18 !=4 & s4_19a !=1
    }
    * Sinon, vérifier si la variable est textuelle
    else {
        replace `var' = "-5" if s4_18 !=2 & s4_18 !=3 & s4_18 !=4 & s4_19a !=1
    }
}

replace s4_21 = -5 if s4_16!=1

replace s4_22 = "-5" if s4_16!=1 | s4_21!=1  

replace s4_22_="-5" if s4_22!="X"

* s4_24
replace s4_24 = -5 if s4_21 != 2

* s4_25
replace s4_25 = "-5" if s4_21 != 2 | s4_24 != 1

replace s4_25_A = -5 if s4_21 != 2 | s4_24 != 1
replace s4_25_B = -5 if s4_21 != 2 | s4_24 != 1
replace s4_25_C = -5 if s4_21 != 2 | s4_24 != 1
replace s4_25_D = -5 if s4_21 != 2 | s4_24 != 1
replace s4_25_E = -5 if s4_21 != 2 | s4_24 != 1
replace s4_25_F = -5 if s4_21 != 2 | s4_24 != 1
replace s4_25_G = -5 if s4_21 != 2 | s4_24 != 1
replace s4_25_H = -5 if s4_21 != 2 | s4_24 != 1
replace s4_25_I = -5 if s4_21 != 2 | s4_24 != 1
replace s4_25_J = -5 if s4_21 != 2 | s4_24 != 1
replace s4_25_X = -5 if s4_21 != 2 | s4_24 != 1

* s4_27
replace s4_27 = -5 if s4_21 != 1

* s4_28
replace s4_28 = -5 if s4_21 != 1 | s4_27 != 1

* s4_29
*replace s4_29 = "-5" if s4_21 != 1 | s4_28 != 1
replace s4_29_A = -5 if s4_21 != 1 | s4_28 != 1
replace s4_29_B = -5 if s4_21 != 1 | s4_28 != 1
replace s4_29_C = -5 if s4_21 != 1 | s4_28 != 1
replace s4_29_D = -5 if s4_21 != 1 | s4_28 != 1
replace s4_29_E = -5 if s4_21 != 1 | s4_28 != 1
replace s4_29_F = -5 if s4_21 != 1 | s4_28 != 1
replace s4_29_G = -5 if s4_21 != 1 | s4_28 != 1
replace s4_29_H = -5 if s4_21 != 1 | s4_28 != 1
replace s4_29_I = -5 if s4_21 != 1 | s4_28 != 1
replace s4_29_J = -5 if s4_21 != 1 | s4_28 != 1
replace s4_29_X = -5 if s4_21 != 1 | s4_28 != 1

* s4_29_
replace s4_29_ = "-5" if s4_29_X != 1

* s4_30_11_other
replace s4_30_11_other = "-5" if s4_30_11 != 1

* s4_32
replace s4_32 = "-5" if s4_27 != 1
replace s4_32_A = -5 if s4_27 != 1
replace s4_32_B = -5 if s4_27 != 1
replace s4_32_C = -5 if s4_27 != 1
replace s4_32_D = -5 if s4_27 != 1
replace s4_32_X = -5 if s4_27 != 1

* s4_32_autre
replace s4_32_autre = "-5" if s4_32_X != 1

* s4_34
replace s4_34 = "-5" if s4_27 != 1

replace s4_34_A = -5 if s4_27 != 1
replace s4_34_B = -5 if s4_27 != 1
replace s4_34_C = -5 if s4_27 != 1
replace s4_34_D = -5 if s4_27 != 1
replace s4_34_E = -5 if s4_27 != 1
replace s4_34_F = -5 if s4_27 != 1
replace s4_34_G = -5 if s4_27 != 1
replace s4_34_H = -5 if s4_27 != 1
replace s4_34_X = -5 if s4_27 != 1

* s4_34_
replace s4_34_ = "-5" if s4_34_X != 1

  * s4_35_1
replace s4_35_1 = "-5" if s4_35 != "X"

* s4_55
replace s4_55 = -5 if s4_54 != 1

* s4_72
replace s4_72 = "-5" if s4_71 != 2 & s4_71 != 3

* s4_80
replace s4_80 = -5 if s4_79 != 2

*Définir les libellés des modalités pour chaque variable

* Remplacer les modalités Autres/ Autres(à préciser) par 96
* Remplacer les modalités Je ne sais pas par 98


replace s4_35="96"  if s4_35=="X"

replace s4_72="1"  if s4_72=="A"
replace s4_72="2"  if s4_72=="B"
replace s4_72="3"  if s4_72=="C"
replace s4_72="4"  if s4_72=="D"
replace s4_72="96"  if s4_72=="X"

replace s4_22="1"  if s4_22=="A"
replace s4_22="2"  if s4_22=="B"
replace s4_22="3"  if s4_22=="C"
replace s4_22="4"  if s4_22=="D"
replace s4_22="5"  if s4_22=="E"
replace s4_22="6"  if s4_22=="F"
replace s4_22="7"  if s4_22=="G"
replace s4_22="8"  if s4_22=="H"
replace s4_22="9"  if s4_22=="I"
replace s4_22="10"  if s4_22=="J"
replace s4_22="96"  if s4_22=="X"

replace s4_22="96"  if s4_72=="X"

*Les valeurs manquantes reflètent des sauts, elles sont alors remplaçées toutes par -5

foreach var of varlist _all {
    * Vérifier si la variable est numérique
    capture confirm numeric variable `var'
    if !_rc {
        * Remplacer les valeurs manquantes par -5 pour les variables numériques
        replace `var' = -5 if missing(`var')
    }
    * Sinon, vérifier si la variable est textuelle
    else {
        * Remplacer les valeurs manquantes par "-5" pour les variables textuelles
        replace `var' = "-5" if missing(`var')
    }
}

*Conversion des variables s4_18 s4_35 s4_46 s4_42 en numérique
destring s4_18 s4_22 s4_35 s4_46 s4_42 s200b s4_72 , replace


* s1_1 (Nom de la région)
label define s1_1 1 "DAKAR" 2 "DIOURBEL" 3 "FATICK" 4 "KAFFRINE" 5 "KAOLACK" 6 "KEDOUGOU" 7 "KOLDA" 8 "LOUGA" 9 "MATAM" 10 "SAINT-LOUIS" 11 "SEDHIOU" 12 "TAMBACOUNDA" 13 "THIES" 14 "ZIGUINCHOR"
label values s1_1 s1_1

* s1_3 (Nom du district)

label define s1_3 1 "DAKAR CENTRE" 2 "DAKAR NORD" 3 "DAKAR OUEST" 4 "DAKAR SUD" 5 "DIAMNIADIO" 6 "GUEDIAWAYE" 7 "KEUR MASSAR" 8 "MBAO" 9 "PIKINE" 10 "RUFISQUE" 11 "SANGALKAM" 12 "YEUMBEUL" 13 "BAMBEY" 14 "DIOURBEL" 15 "MBACKE" 16 "TOUBA" 17 "DIAKHAO" 18 "DIOFFIOR" 19 "FATICK" 20 "FOUNDIOUGNE" 21 "GOSSAS" 22 "NIAKHAR" 23 "PASSY" 24 "SOKONE" 25 "BIRKELANE" 26 "KAFFRINE" 27 "KOUNGHEUL" 28 "MALEM HODAR" 29 "GUINGUINEO" 30 "KAOLACK" 31 "NDOFFANE" 32 "NIORO" 33 "KEDOUGOU" 34 "SALEMATA" 35 "SARAYA" 36 "KOLDA" 37 "MEDINA YORO FOULAH" 38 "VELINGARA" 39 "DAHRA" 40 "DAROU-MOUSTY" 41 "KEBEMER" 42 "KEUR MOMAR SARR" 43 "KOKI" 44 "LINGUERE" 45 "LOUGA" 46 "SAKAL" 47 "KANEL" 48 "MATAM" 49 "RANEROU" 50 "THILOGNE" 51 "DAGANA" 52 "PETE" 53 "PODOR" 54 "RICHARD TOLL" 55 "SAINT-LOUIS" 56 "BOUNKILING" 57 "GOUDOMP" 58 "SEDHIOU" 59 "BAKEL" 60 "DIANKHE MAKHAN" 61 "GOUDIRY" 62 "KIDIRA" 63 "KOUMPENTOUM" 64 "MAKACOLIBANTANG" 65 "TAMBACOUNDA" 66 "JOAL-FADIOUTH" 67 "KHOMBOLE" 68 "MBOUR" 69 "MEKHE" 70 "POPENGUINE" 71 "POUT" 72 "THIADIAYE" 73 "THIES" 74 "TIVAOUANE" 75 "BIGNONA" 76 "DIOULOULOU" 77 "OUSSOUYE" 78 "THIONCK-ESSYL" 79 "ZIGUINCHOR"
label values s1_3 s1_3

* s1_5 (Type de lieu)
label define s1_5 1 "Rural" 2 "Urbain"
label values s1_5 s1_5

* s200a (Service de consultation ou hospitalisation)
label define s200a 1 "SC (Service de consultation)" 2 "SH (Hospitalisation)"
label values s200a s200a

* s200b (Services reçus)
* Créer un label "oui_non"
label define oui_non 1 "Oui" 0 "Non"

* Appliquer le label "oui_non" à chaque variable issue de s200b_1
drop s200b
label values s200b_1 oui_non
label values s200b_2 oui_non
label values s200b_3 oui_non
label values s200b_4 oui_non
label values s200b_5 oui_non
label values s200b_6 oui_non
label values s200b_7 oui_non
label values s200b_8 oui_non

* s3_1 (Sexe du client)
label define s3_1 1 "Homme" 2 "Femme"
label values s3_1 s3_1

* s3_3 (Capacité à lire et écrire)
drop s3_3
label values s3_3_A oui_non
label values s3_3_B oui_non
label values s3_3_C oui_non

* s3_4 (Niveau scolaire)
label define s3_4 1 "Primaire" 2 "Collège" 3 "Lycée" 4 "Supérieur" 0 "N'a jamais fréquenté l'école"
label values s3_4 s3_4

* s3_5 (Situation professionnelle)
label define s3_5 1 "Emploi rémunéré (Salarié/AGR)" 2 "Sans emploi" 3 "Chômage" 4 "Retraité" 5 "Elève/Etudiant"
label values s3_5 s3_5

* s3_6 (Situation matrimoniale)
label define s3_6 1 "Marié(e)" 2 "Veuf(ve)" 3 "Divorcé(e)" 4 "Séparé(e)" 5 "Célibataire" 6 "Union libre"
label values s3_6 s3_6

* s3_7 (Milieu de résidence)
label define s3_7 1 "Urbain" 2 "Rural"
label values s3_7 s3_7

* s3_9 (Type de transport utilisé)
replace s3_9 =96 if s3_9 == 6
label define s3_9 1 "Transport public" 2 "Véhicule privé" 3 "Ambulance gouvernementale" 4 "Marche" 5 "Pas constant/dépend de la situation" 96 "Autres (Précisez)"
label values s3_9 s3_9

* s3_10 (Type de transport habituel)
replace s3_10 =96 if s3_10 == 6
label define s3_10 1 "Transport public" 2 "Véhicule privé" 3 "Ambulance gouvernementale" 4 "Marche" 5 "Pas constant/dépend de la situation" 96 "Autres (Précisez)"
label values s3_10 s3_10  // Utilise les mêmes modalités que s3_9

* s4_6 (Moment de l'admission)
label define s4_6 1 "Immédiatement" 2 "Le même jour" 3 "Le jour suivant" 4 "Après deux jours ou plus"
label values s4_6 s4_6

* s4_7 (Raisons du retard d'admission)
label values s4_7_A oui_non
label values s4_7_B oui_non
label values s4_7_C oui_non
label values s4_7_D oui_non
label values s4_7_E oui_non
label values s4_7_F oui_non
label values s4_7_X oui_non


* s4_9 (Disponibilité de civière/chaise roulante)
replace s4_9 =98 if s4_9 == 8
label define s4_9 1 "Oui" 2 "Non" 98 "Ne sais pas"
label values s4_9 s4_9

* s4_10 (Orientation par un autre prestataire)
replace s4_10 =98 if s4_10 == 8
label define s4_10 1 "Oui" 2 "Non" 98 "Ne sais pas"
label values s4_10 s4_10

* s4_11 (Médicaments prescrits)
label define s4_11 1 "Oui, il m’a donné des médicaments" 2 "Oui, il m’a donné une ordonnance" 3 "Il m’a donné une ordonnance et des médicaments" 4 "Non"
label values s4_11 s4_11

* s4_12 (Médicaments administrés)
label define s4_12 1 "Possède tous les médicaments" 2 "Prend des médicaments" 3 "Médicaments non présentés, n'a que des prescriptions"
label values s4_12 s4_12

* s4_13 (Quantité de médicaments indiquée)
replace s4_13 =98 if s4_13 == 8
label define s4_13 1 "Oui" 2 "Non" 98 "Ne sais pas"
label values s4_13 s4_13

* s4_14 (Paiement pour les services)
replace s4_14 =98 if s4_14 == 8
label define s4_14 1 "Oui" 2 "Non" 98 "Ne sais pas"
label values s4_14 s4_14

* s4_16 (Utilisation de moyens pour éviter une grossesse)
replace s4_16 =98 if s4_16 == 8
label define s4_16 1 "Oui" 2 "Non" 98 "Ne sais pas"
label values s4_16 s4_16

* s4_17 (Méthodes utilisées pour éviter une grossesse)
drop s4_17
label values s4_17_A oui_non
label values s4_17_B oui_non
label values s4_17_C oui_non
label values s4_17_D oui_non
label values s4_17_E oui_non
label values s4_17_F oui_non
label values s4_17_G oui_non
label values s4_17_H oui_non
label values s4_17_I oui_non
label values s4_17_J oui_non
label values s4_17_X oui_non

* s4_18 (Principal service de planification familiale)
replace s4_18 =96 if s4_18 == 6
label define s4_18 1 "Adopter une méthode de PF" 2 "Changer de méthode" 3 "Mettre fin à la PF" 4 "Trouver des solutions aux effets secondaires de la méthode actuelle" 5 "Obtenir des informations sur une méthode PF" 6 "Autres (Précisez)"
label values s4_18 s4_18


* s4_19a (Problèmes avec la méthode actuelle)
label define s4_19a 1 "Oui" 2 "Non"
label values s4_19a s4_19a


* s4_19b (Problèmes spécifiques avec la méthode actuelle)
drop s4_19b
label values s4_19b_A oui_non
label values s4_19b_B oui_non
label values s4_19b_C oui_non
label values s4_19b_D oui_non
label values s4_19b_E oui_non
label values s4_19b_F oui_non
label values s4_19b_X oui_non

* s4_21 (Utilisation d'une méthode avant de venir)
label define s4_21 1 "Oui" 2 "Non"
label values s4_21 s4_21

label define s4_22 1 "Pilules" 2 "Injectable" 3 "Préservatif masculin" 4 "Préservatif féminin" 5 "Contraception d’urgence" 6 "DIU" 7 "Implants" 8 "Stérilisation féminine (Ligature des trompes)" 9 "Stérilisation masculine (Vasectomie)" 10 "Allaitement maternel exclusif (MAMA)" 96 "Autre"
label values s4_22 s4_22

* s4_24 (Pensée à utiliser une méthode avant de venir)
label define s4_24 1 "Oui" 2 "Non"
label values s4_24 s4_24

* s4_25 (Méthodes envisagées avant de venir)
drop s4_25
label values s4_25_A oui_non
label values s4_25_B oui_non
label values s4_25_C oui_non
label values s4_25_D oui_non
label values s4_25_E oui_non
label values s4_25_F oui_non
label values s4_25_G oui_non
label values s4_25_H oui_non
label values s4_25_I oui_non
label values s4_25_J oui_non
label values s4_25_X oui_non

* s4_27 (Pensée à changer de méthode avant de venir)
label define s4_27 1 "Oui" 2 "Non"
label values s4_27 s4_27

* s4_28 (Méthode de planification familiale à l'esprit)
label define s4_28 1 "Oui" 2 "Non"
label values s4_28 s4_28

* s4_29 (Méthodes envisagées de changer)
drop s4_29
label values s4_29_A oui_non
label values s4_29_B oui_non
label values s4_29_C oui_non
label values s4_29_D oui_non
label values s4_29_E oui_non
label values s4_29_F oui_non
label values s4_29_G oui_non
label values s4_29_H oui_non
label values s4_29_I oui_non
label values s4_29_J oui_non
label values s4_29_X oui_non

* s4_30 (Méthode de planification familiale reçue)
label define s4_30 1 "Reçu" 2 "Prescrit/Référé pour prescription" 3 "Ni reçu, ni prescrit"
label values s4_30_1 s4_30
label values s4_30_2 s4_30
label values s4_30_3 s4_30
label values s4_30_4 s4_30
label values s4_30_5 s4_30
label values s4_30_6 s4_30
label values s4_30_7 s4_30
label values s4_30_8 s4_30
label values s4_30_9 s4_30
label values s4_30_10 s4_30
label values s4_30_11 s4_30

* s4_32 (Raisons de changement de méthode)
drop s4_32
label values s4_32_A oui_non
label values s4_32_B oui_non
label values s4_32_C oui_non
label values s4_32_D oui_non
label values s4_32_X oui_non

* s4_34 (Raisons de non-réception des services)
drop s4_34
label values s4_34_A oui_non
label values s4_34_B oui_non
label values s4_34_C oui_non
label values s4_34_D oui_non
label values s4_34_E oui_non
label values s4_34_F oui_non
label values s4_34_G oui_non
label values s4_34_H oui_non
label values s4_34_X oui_non

* s4_35 (Résultat de la visite)
label define s4_35 1 "Poursuivre ou recommencer avec la même méthode" 2 "Méthode de changement" 3 "Cesser d’utiliser la méthode en raison d’un problème" 4 "Cesser d’utiliser la méthode (facultative – pas de problème)" 5 "Adopter une méthode" 6 "Décidera plus tard" 7 "Demande de revenir un autre jour" 8 "Renvoyé" 96 "Autres (Précisez)"
label values s4_35 s4_35
* Remplacer 8 par 98 pour les modalités ne sait pas

replace s4_37 = 98 if s4_37 == 8
replace s4_38 = 98 if s4_38 == 8
replace s4_39 = 98 if s4_39 == 8
replace s4_40 = 98 if s4_40 == 8
replace s4_41 = 98 if s4_41 == 8
replace s4_42 = 98 if s4_42 == 8
replace s4_43 = 98 if s4_43 == 8
replace s4_44 = 98 if s4_44 == 8
replace s4_45 = 98 if s4_45 == 8
replace s4_46 = 98 if s4_46 == 8
replace s4_47 = 98 if s4_47 == 8
replace s4_48 = 98 if s4_48 == 8
replace s4_49 = 98 if s4_49 == 8
replace s4_50 = 98 if s4_50 == 8
replace s4_51 = 98 if s4_51 == 8
replace s4_52 = 98 if s4_52 == 8
replace s4_53 = 98 if s4_53 == 8
replace s4_54 = 98 if s4_54 == 8
replace s4_55 = 98 if s4_55 == 8
replace s4_56 = 98 if s4_56 == 8

label define oui_non_jsp 1 "Oui" 2 "Non" 98 "Ne sais pas"

* s4_37 (Vous a-t-il demandé si vous souhaitiez avoir un autre enfant ?)
label values s4_37 oui_non_jsp

* s4_38 (Vous a-t-il interrogé sur le moment où vous souhaiteriez avoir un autre enfant ?)
label values s4_38 oui_non_jsp

* s4_39 (Vous a-t-il demandé votre dernière expérience sur l’utilisation des méthodes de planification familiale ?)
label values s4_39 oui_non_jsp

* s4_40 (Vous a-t-il demandé si vous aviez une quelconque méthode en tête avant de venir à la structure sanitaire ?)
label values s4_40 oui_non_jsp

* s4_41 (Vous a-t-il demandé votre préférence en matière de méthode de planification familiale ?)
label values s4_41 oui_non_jsp

* s4_42 (Vous a-t-il fourni des informations sur différentes méthodes de planification familiale ?)
label values s4_42 oui_non_jsp

* s4_43 (Vous a-t-il parlé de la méthode de PF que vous avez choisi ?)
label values s4_43 oui_non_jsp

* s4_44 (Vous a-t-il parlé du mode de fonctionnement de la méthode que vous avez choisi ?)
label values s4_44 oui_non_jsp

* s4_45 (Vous a-t-il parlé des possibles effets secondaires de la méthode que vous avez choisie ?)
label values s4_45 oui_non_jsp

* s4_46 (Vous a-t-il parlé de ce que vous devez faire quand vous noterez des effets secondaires ou des problèmes par rapport à la méthode que vous avez choisie ?)
label values s4_46 oui_non_jsp

* s4_47 (Vous a-t-il parlé des signes d’alerte de la méthode vous avez choisie ?)
label values s4_47 oui_non_jsp

* s4_48 (Vous a-t-il dit quand revenir au centre de santé pour une visite de suivi ?)
label values s4_48 oui_non_jsp

* s4_49 (Vous a-t-il remis une carte de rendez-vous pour la visite de suivi ?)
label values s4_49 oui_non_jsp

* s4_50 (Vous a-t-il parlé d’autres sources auprès desquelles vous pouviez obtenir des produits de planification familiale ?)
label values s4_50 oui_non_jsp

* s4_51 (Vous a-t-il parlé de la possibilité de changer de méthode de planification familiale si celle choisit ne vous convient plus ?)
label values s4_51 oui_non_jsp

* s4_52 (Vous a-t-il fourni des informations tout en encourageant fortement une méthode ?)
label values s4_52 oui_non_jsp

* s4_53 (Vous a-t-il fournit des méthodes qui protègent contre le VIH/SIDA et des autres IST ?)
label values s4_53 oui_non_jsp

* s4_54 (Le prestataire vous-a-t-il permis de poser des questions ?)
label values s4_54 oui_non_jsp

* s4_55 (Le prestataire a-t-il répondu à toutes vos questions pour vous satisfaire ?)
label values s4_55 oui_non_jsp

* s4_56 (Durant votre visite, pouvez-vous dire que vous avez été bien traité par le prestataire ?)
label values s4_56 oui_non_jsp

* s4_57 (Comment appréciez-vous les informations que vous avez reçu à propos de la méthode de planification familiale que vous avez choisie par rapport à ce que vous souhaitiez ?)
replace s4_57=98 if s4_57==8

label define s4_57 1 "J'ai reçu toutes les informations" 2 "J'ai reçu la plupart des informations" 3 "J'ai reçu peu d'informations" 4 "Je n'ai pas reçu les informations" 98 "Ne sais pas/ne peut pas s’en rappeler"
label values s4_57 s4_57

* s4_58 (Le prestataire, vous a-t-il recommandé une méthode plutôt qu’une autre ?)
replace s4_58=98 if s4_58==8

label define s4_58 1 "Oui, tout le temps" 2 "Oui, la plupart du temps" 3 "Oui, quelques fois" 4 "Non, jamais" 98 "Ne sais pas/Ne peut pas s'en rappeler"
label values s4_58 s4_58

* s4_59 (Avez-vous le sentiment d’être à l’abri des regards pendant votre entretien avec le prestataire et qu’aucun autre client ou patient de la structure sanitaire ne pouvait vous voir pendant votre consultation ?)
replace s4_59=98 if s4_59==8

label define s4_59 1 "Oui, tout le temps" 2 "Oui, la plupart du temps" 3 "Oui, quelques fois" 4 "Non, jamais" 98 "Ne sais pas/Ne s’en rappelle pas"
label values s4_59 s4_59

* s4_60 (Vous sentiez-vous capable de discuter de vos problèmes avec les médecins, les infirmières ou d'autres prestataires, sans que d'autres personnes non impliquées dans vos soins n'entendent vos conversations ?)
replace s4_60=98 if s4_60==8

label define s4_60 1 "Oui, tout le temps" 2 "Oui, la plupart du temps" 3 "Oui, quelques fois" 4 "Non, jamais" 98 "Ne sais pas/Ne s’en rappelle pas"
label values s4_60 s4_60

* s4_61 (Pensez-vous que les informations personnelles que vous avez partagé avec le prestataire seront confidentielles ?)
replace s4_61=98 if s4_61==8

label define s4_61 1 "Oui, tout le temps" 2 "Oui, la plupart du temps" 3 "Oui, quelques fois" 4 "Non, jamais" 98 "Ne sais pas/Ne s’en rappelle pas"
label values s4_61 s4_61

* s4_62 (Sentez-vous que le médecin, l’infirmier ou les autres membres du personnel vous ont traité avec respect ?)
replace s4_62=98 if s4_62==8

label define s4_62 1 "Oui, tout le temps" 2 "Oui, la plupart du temps" 3 "Oui, quelques fois" 4 "Non, jamais" 98 "Ne sais pas/Ne s’en rappelle pas"
label values s4_62 s4_62

* s4_63 (Sentez-vous que le médecin, l’infirmier ou les autres membres du personnel vous ont traité d’une manière amicale ?)
replace s4_63=98 if s4_63==8

label define s4_63 1 "Oui, tout le temps" 2 "Oui, la plupart du temps" 3 "Oui, quelques fois" 4 "Non, jamais" 98 "Ne sais pas/Ne s’en rappelle pas"
label values s4_63 s4_63

* s4_64 (Pensez-vous que l’environnement de la structure sanitaire y compris les toilettes sont propres ?)
replace s4_64=98 if s4_64==8
label define s4_64 1 "Oui, tout le temps" 2 "Oui, la plupart du temps" 3 "Oui, quelques fois" 4 "Non, jamais" 98 "Ne sais pas/Ne s’en rappelle pas"
label values s4_64 s4_64

* s4_65 (Comment s’est déroulée l’expérience concernant les dispositions prises dans la structure sanitaire pendant l’attente d’un service ?)
*Ne peut rien dire /je ne sais pas
replace s4_65=98 if s4_65==8

label define s4_65 1 "Très bien" 2 "Bien" 3 "Mauvaise" 4 "Très mauvaise" 98 "Ne peut rien dire"
label values s4_65 s4_65

* s4_66 (Avez-vous eu le sentiment de pouvoir poser toutes vos questions aux médecins, aux infirmières ou aux autres membres du personnel de la structure sanitaire ?)
replace s4_66 = -9 if s4_66==9
replace s4_66 = 98 if s4_66==8

label define s4_66 1 "Oui, tout le temps" 2 "Oui, la plupart du temps" 3 "Oui, quelques fois" 4 "Non, jamais" 8 "Ne sais pas/Ne s’en rappelle pas" -9 "Non applicable"
label values s4_66 s4_66

* s4_67 (Avez-vous eu l’impression que les médecins, les infirmières ou les autres membres du personnel de la structure sanitaire vous ont fait participer aux décisions concernant vos soins ?)
replace s4_67 = -9 if s4_67==9
replace s4_67 = 98 if s4_67==8

label define s4_67 1 "Oui, tout le temps" 2 "Oui, la plupart du temps" 3 "Oui, quelques fois" 4 "Non, jamais" 8 "Ne sais pas / Ne s’en rappelle pas" -9 "Non applicable"
label values s4_67 s4_67

* s4_68 (Diriez-vous que vous avez été traité différemment en raison d’une caractéristique personnelle, comme votre âge, votre situation matrimoniale, le nombre de vos enfants, votre éducation, votre fortune, ou quelque chose de ce genre ?)
replace s4_68 = 98 if s4_68==8

label define s4_68 1 "Oui, tout le temps" 2 "Oui, la plupart du temps" 3 "Oui, quelques fois" 4 "Non, jamais" 98 "Ne sais pas/Ne s’en rappelle pas"
label values s4_68 s4_68

* s4_69 (Avez-vous eu l’impression d’être traité brutalement ? Par exemple, avez-vous été poussé, battu, giflé, pincé, contraint physiquement ou bâillonné, ou maltraité physiquement d’une autre manière ?)
replace s4_69 = 98 if s4_69==8

label define s4_69 1 "Oui, tout le temps" 2 "Oui, la plupart du temps" 3 "Oui, quelques fois" 4 "Non, jamais" 98 "Ne sais pas/Ne s’en rappelle pas"
label values s4_69 s4_69

* s4_70 (Avez-vous eu l’impression que les médecins, les infirmières ou les autres prestataires de soins de santé vous ont-ils, crié dessus, vous ont grondé, vous ont insulté, menacé ou vous ont parlé grossièrement ?)
replace s4_70 = 98 if s4_70==8

label define s4_70 1 "Oui, tout le temps" 2 "Oui, la plupart du temps" 3 "Oui, quelques fois" 4 "Non, jamais" 98 "Ne sais pas/Ne s’en rappelle pas"
label values s4_70 s4_70

* s4_71 (Compte tenu de votre expérience d’aujourd’hui, diriez-vous que vous êtes entièrement satisfait, partiellement satisfait ou pas du tout satisfait des services de services de planning familial fournis ?)
replace s4_71 = 98 if s4_71==8

label define s4_71 1 "Oui, entièrement satisfait" 2 "Oui, partiellement satisfait" 3 "Pas du tout satisfait" 98 "Ne peut rien dire"
label values s4_71 s4_71

* s4_72 (Quelles sont les raisons de cette insatisfaction ?)

label define s4_72 1 "Manque d’installations" 2 "Qualité médiocre du service" 4 "Mauvaise relation client-soignant" 4 "Frais trop élevée" 96 "Autres (Précisez)"
label values s4_72 s4_72

* s4_73 (Si nécessaire, reviendrez-vous à l’avenir dans cette structure sanitaire pour des services de planification familiale ?)
replace s4_73 = 98 if s4_73==8

label define s4_73 1 "Oui" 2 "Non" 98 "Ne peut rien dire"
label values s4_73 s4_73

* s4_75 (Le temps d’attente pour consulter un prestataire dans cette structure sanitaire a-t-il été un problème ?)
replace s4_75 = 98 if s4_75 ==8
label define s4_75 1 "Oui, a posé un problème majeur" 2 "Oui, a posé un problème mineur" 3 "Non, ne pose pas de problème" 98 "Ne sais pas"
label values s4_75 s4_75

* s4_76 (Les heures d’ouverture et de fermeture de la structure sanitaire ont-elles posé problème 
replace s4_76 = 98 if s4_76 ==8

label define s4_76 1 "Oui, a posé un problème majeur" 2 "Oui, a posé un problème mineur" 3 "Non, ne pose pas de problème" 98 "Ne sais pas"
label values s4_76 s4_76

* s4_77 (Le nombre de jours pendant lesquels les services sont disponibles dans cette structure sanitaire vous a-t-il posé un problème ?)
replace s4_77 = 98 if s4_77 ==8

label define s4_77 1 "Oui, a posé un problème majeur" 2 "Oui, a posé un problème mineur" 3 "Non, ne pose pas de problème" 98 "Ne sais pas"
label values s4_77 s4_77

* s4_78 (Les coûts des services de planification familiale de cette structure sanitaire vous-a-t-il posé problème ?)
replace s4_78 = 98 if s4_78 ==8

label define s4_78 1 "Oui, a posé un problème majeur" 2 "Oui, a posé un problème mineur" 3 "Non, ne pose pas de problème" 98 "Ne sais pas"
label values s4_78 s4_78

* s4_79 (S’agit-il de la structure sanitaire offrant des services de planification familiale la plus proche de votre domicile ?)
replace s4_79 = 98 if s4_79 ==8

label define s4_79 1 "Oui" 2 "Non" 98 "Ne sais pas"
label values s4_79 s4_79

* s4_80 (Quelle est la principale raison pour laquelle vous ne vous êtes pas rendu dans la structure sanitaire le plus proche de votre domicile ?)
label define s4_80 1 "Calendrier des services n'est pas adapté" 2 "Mauvaise réputation" 3 "N'aime pas le personnel" 4 "Mauvaise qualité des soins" 5 "Cherté des prestations" 6 "Défaut de médicaments" 7 "J'ai été référé ici" 8 "Service non proposé" 9 "Mauvais accueil" 96 "Autres" 98 "Ne sait pas"
label values s4_80 s4_80



**Renommer les variables*****************
*Les noms des modalités des select_ultiple s'ecrivent sous la forme : cNumsection_nameVar_alphabet, Ex: s2_b_a, etc..
rename s3_9_1  s3_9_other
rename s3_10_1 s3_10_other
rename s4_18_1 s4_18_other
rename s4_17_1 s4_17_other
rename s200a s2_a
rename s200b_1 s2_b_a
rename s200b_2 s2_b_b
rename s200b_3 s2_b_c
rename s200b_4 s2_b_d
rename s200b_5 s2_b_e
rename s200b_6 s2_b_f
rename s200b_7 s2_b_g
rename s200b_8 s2_b_96
rename Z z

rename s3_3_A s3_3_a
rename s3_3_B s3_3_b
rename s3_3_C s3_3_c

rename s4_7_A s4_7_a
rename s4_7_B s4_7_b
rename s4_7_C s4_7_c
rename s4_7_D s4_7_d
rename s4_7_E s4_7_e
rename s4_7_F s4_7_f
rename s4_7_X s4_7_96
rename s4_7_aut s4_7_other

rename s4_17_A s4_17_a
rename s4_17_B s4_17_b
rename s4_17_C s4_17_c
rename s4_17_D s4_17_d
rename s4_17_E s4_17_e
rename s4_17_F s4_17_f
rename s4_17_G s4_17_g
rename s4_17_H s4_17_h
rename s4_17_I s4_17_i
rename s4_17_J s4_17_j
rename s4_17_X s4_17_96

rename s4_19b_A s4_19b_a
rename s4_19b_B s4_19b_b
rename s4_19b_C s4_19b_c
rename s4_19b_D s4_19b_d
rename s4_19b_E s4_19b_e
rename s4_19b_F s4_19b_f
rename s4_19b_X s4_19b_96
rename s4_19b_1 s4_19b_other

rename s4_22_ s4_22_other

rename s4_25_A s4_25_a
rename s4_25_B s4_25_b
rename s4_25_C s4_25_c
rename s4_25_D s4_25_d
rename s4_25_E s4_25_e
rename s4_25_F s4_25_f
rename s4_25_G s4_25_g
rename s4_25_H s4_25_h
rename s4_25_I s4_25_i
rename s4_25_J s4_25_j
rename s4_25_X s4_25_96

rename s4_29_A s4_29_a
rename s4_29_B s4_29_b
rename s4_29_C s4_29_c
rename s4_29_D s4_29_d
rename s4_29_E s4_29_e
rename s4_29_F s4_29_f
rename s4_29_G s4_29_g
rename s4_29_H s4_29_h
rename s4_29_I s4_29_i
rename s4_29_J s4_29_j
rename s4_29_X s4_29_96
rename s4_29_ s4_29_other

rename reserved_name_for_field_list_lab reserved_name_for_field_list_lab

rename s4_30_11_other s4_30_11_other

rename s4_32_A s4_32_a
rename s4_32_B s4_32_b
rename s4_32_C s4_32_c
rename s4_32_D s4_32_d
rename s4_32_X s4_32_96
rename s4_32_autre s4_32_other

rename s4_34_A s4_34_a
rename s4_34_B s4_34_b
rename s4_34_C s4_34_c
rename s4_34_D s4_34_d
rename s4_34_E s4_34_e
rename s4_34_F s4_34_f
rename s4_34_G s4_34_g
rename s4_34_H s4_34_h
rename s4_34_X s4_34_96
rename s4_34_ s4_34_other
rename s4_35_1 s4_35_other

*Renommer les variables en commençant par la lettre c pour nom
* Lister toutes les variables de la base
ds

foreach var of varlist _all {
    * Vérifier si le nom de la variable commence par "s"
    if regexm("`var'", "^s") {
        * Remplacer "s" par "c"
        local new_name = subinstr("`var'", "s", "c", 1)
        rename `var' `new_name'
        di "Variable `var' renommée en `new_name'"
    }
}


rename z c2_b_other

save Clients_finaldata.dta, replace 