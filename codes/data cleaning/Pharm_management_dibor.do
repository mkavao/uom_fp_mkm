**************************************************************** PRELIMINAIRES ****************************************************************************
                                                                ***************
* Nettoyage et préparation de l'environnement de travail
clear all
clear matrix

* Paramétrage de l'affichage
set linesize 220
set maxvar 32000
set more off


cd "D:\APHRC\APHRC\Codes_FP_Dibor\Dibor's Part\Pharmacies"

import excel "QUESTIONNAIRE PHARMACIE_WIDE.xlsx", sheet("data") firstrow


drop SubmissionDate starttime endtime equipe enqueteur pharm_name uius locationLatitude locationLongitude locationAltitude locationAccuracy instanceID formdef_version KEY quart_name


* Vérification des doublons
duplicates report


* Suppression des doublons
duplicates drop

*Correction des incohérences

rename (q564_4 q564_5) (q564_3 q564_4)

if q610_1_1==3 replace q610_1_1=2
if q610_1_2==3 replace q610_1_1=2
if q610_1_3==3 replace q610_1_1=2
if q610_1_4==3 replace q610_1_1=2
if q610_1_5==3 replace q610_1_1=2
if q610_1_6==3 replace q610_1_1=2
if q610_1_7==3 replace q610_1_1=2
if q610_1_8==3 replace q610_1_1=2
if q610_1_9==3 replace q610_1_1=2
if q610_1_10==3 replace q610_1_1=2
if q610_1_11==3 replace q610_1_1=2


*Labélisation des variables
label variable region_name "Nom de la région"
label variable s1_3 "Veuillez choisir le district sanitaire"
label variable lieu_type "Type de lieu"
label variable q201 "Êtes-vous le propriétaire de cette pharmacie / dépôt de médicaments ? 
label variable q202 "Quel est votre rôle ou votre position dans la gestion de cette pharmacie / dépôt de médicaments ?"
label variable q202b "Précisez votre rôle"
label variable q203 "Êtes-vous responsable de la gestion quotidienne de la pharmacie / dépôt de médicaments ?"
label variable q204 "Depuis quand (date approximative) possédez-vous ou travaillez-vous dans cette pharmacie / dépôt de médicaments ?"
label variable q205 "Sexe du répondant "
label variable q206 "Quel est le plus haut niveau d'éducation que vous avez atteint ?"
label variable q207 "En vous incluant (ainsi que le propriétaire), combien de personnes travaillent régulièrement dans cette pharmacie / dépôt de médicaments ? "
label variable q207a "Combien de femmes font partie du personnel permanent ?"
label variable q207b "Combien d'hommes font partie du personnel permanent ?"
label variable q208 "Combien de personnes travaillant régulièrement dans cette pharmacie /dépôt de médicaments, y compris le propriétaire, ont une qualification dans le domaine de la santé (pharmacie, vendeur d'officine…)?"
label variable q209a "Combien de ces employés sont des femmes ?"
label variable q209b "Combien de ces employés sont des hommes ?"
label variable q210a "Combien de pharmaciens sont des femmes ?"
label variable q210b "Combien de pharmaciens sont des hommes ?"
label variable q211 "Avez-vous, vous-même ou l'un de vos collaborateurs, reçu une formation sur des sujets liés à la planification familiale ?"
label variable q211a "Combien d'employés ont reçu une formation en planification familiale ?"
label variable q212 "Cette pharmacie / dépôt de médicaments est-elle supervisée par un pharmacien agréé ?"
label variable q213a "Combien de jours dans la semaine normale, cette pharmacie est-elle ouverte ?"
label variable q213b "Combien de jours dans la semaine de garde, cette pharmacie est-elle ouverte ?"
label variable q214a "Cette pharmacie offre-t-elle des services 24 heures sur 24 et 7 jours sur 7 en semaine normale ?"
label variable q214b "Cette pharmacie offre-t-elle des services 24 heures sur 24 et 7 jours sur 7 en semaine de garde ?"
label variable q215a "Quels sont les horaires d'ouverture de cette pharmacie / droguerie au cours d'une semaine normale ?"
label variable q215b "Quels sont les horaires d'ouverture de cette pharmacie / droguerie en semaine de garde ?"
label variable q216 "Cette pharmacie / dépôt de médicaments est-elle affiliée à une formation sanitaire ? "
label variable q217 "La formation sanitaire à laquelle elle est affiliée offre-t-elle des services de planification familiale ?"
label variable q218 "Est ce que vous / cette pharmacie / ce dépôt de médicaments oriente les clients vers l'établissement affiliée pour une consultation / administration de services de planification familiale ?"
label variable q219 "Quelle est la distance entre votre pharmacie / dépôt de médicaments et l'établissement de santé auquel elle est affiliée?"
*label variable q220a "Dispositif intra-utérin"
label variable q220a_1 "Ce point de vente vend des services de suivi aux clients pour la méthode Dispositif intra-utérin"
label variable q220a_2 "Ce point de vente prescrit des services de suivi aux clients pour la méthode Dispositif intra-utérin"
label variable q220a_3 "Ce point de vente conseille des services de suivi aux clients pour la méthode Dispositif intra-utérin"
label variable q220a_4 "Ce point de vente oriente des services de suivi aux clients pour la méthode Dispositif intra-utérin"
label variable q220a_5 "Ce point de vente fournit des services de suivi aux clients pour la méthode Dispositif intra-utérin"
label variable q220a_6 "NA_DIU"
label variable q220b "Injectables"
label variable q220b_1 "Ce point de vente vend des services de suivi aux clients pour la méthode Injectables"
label variable q220b_2 "Ce point de vente prescrit des services de suivi aux clients pour la méthode Injectables"
label variable q220b_3 "Ce point de vente conseille des services de suivi aux clients pour la méthode Injectables"
label variable q220b_4 "Ce point de vente oriente des services de suivi aux clients pour la méthode Injectables"
label variable q220b_5 "Ce point de vente fournit des services de suivi aux clients pour la méthode Injectables"
label variable q220b_6 "NA_Injectables"
label variable q220c "Préservatifs (Masculin)"
label variable q220c_1 "Ce point de vente vend des services de suivi aux clients pour la méthode Préservatifs (Masculin)"
label variable q220c_2 "Ce point de vente prescrit des services de suivi aux clients pour la méthode Préservatifs (Masculin)"
label variable q220c_3 "Ce point de vente conseille des services de suivi aux clients pour la méthode Préservatifs (Masculin)"
label variable q220c_4 "Ce point de vente oriente des services de suivi aux clients pour la méthode Préservatifs (Masculin)"
label variable q220c_5 "Ce point de vente fournit des services de suivi aux clients pour la méthode Préservatifs (Masculin)"
label variable q220c_6 "NA_Préservatifs (Masculin)"
label variable q220d "Préservatifs (Féminin)"
label variable q220d_1 "Ce point de vente vend des services de suivi aux clients pour la méthode Préservatifs (Féminin)"
label variable q220d_2 "Ce point de vente prescrit des services de suivi aux clients pour la méthode Préservatifs (Féminin)"
label variable q220d_3 "Ce point de vente conseille des services de suivi aux clients pour la méthode Préservatifs (Féminin)"
label variable q220d_4 "Ce point de vente oriente des services de suivi aux clients pour la méthode Préservatifs (Féminin)"
label variable q220d_5 "Ce point de vente fournit des services de suivi aux clients pour la méthode Préservatifs (Féminin)"
label variable q220d_6 "NA_Préservatifs (Féminin)"
label variable q220e "Contraception d’urgence"

label variable q220e_1 "Ce point de vente vend des services de suivi aux clients pour la méthode Contraception d'urgence"
label variable q220e_2 "Ce point de vente prescrit des services de suivi aux clients pour la méthode Contraception d'urgence"
label variable q220e_3 "Ce point de vente conseille des services de suivi aux clients pour la méthode Contraception d'urgence"
label variable q220e_4 "Ce point de vente oriente des services de suivi aux clients pour la méthode Contraception d'urgence"
label variable q220e_5 "Ce point de vente fournit des services de suivi aux clients pour la méthode Contraception d'urgence"
label variable q220e_6 "NA_Contraception d'urgence"
label variable q220f "Pilules"
label variable q220f_1 "Ce point de vente vend des services de suivi aux clients pour la méthode Pilules"
label variable q220f_2 "Ce point de vente prescrit des services de suivi aux clients pour la méthode Pilules"
label variable q220f_3 "Ce point de vente conseille des services de suivi aux clients pour la méthode Pilules"
label variable q220f_4 "Ce point de vente oriente des services de suivi aux clients pour la méthode Pilules"
label variable q220f_5 "Ce point de vente fournit des services de suivi aux clients pour la méthode Pilules"
label variable q220g "Implants"
label variable q220g_1 "Ce point de vente vend des services de suivi aux clients pour la méthode Implants"
label variable q220g_2 "Ce point de vente prescrit des services de suivi aux clients pour la méthode Implants"
label variable q220g_3 "Ce point de vente conseille des services de suivi aux clients pour la méthode Implants"
label variable q220g_4 "Ce point de vente oriente des services de suivi aux clients pour la méthode Implants"
label variable q220g_5 "Ce point de vente fournit des services de suivi aux clients pour la méthode Implants"
label variable q220g_6 "NA_Implants"
label variable q220h "Stérilisation féminine (Ligature des trompes)"
label variable q220h_1 "Ce point de vente vend des services de suivi aux clients pour la méthode Stérilisation féminine"
label variable q220h_2 "Ce point de vente prescrit des services de suivi aux clients pour la méthode Stérilisation féminine"
label variable q220h_3 "Ce point de vente conseille des services de suivi aux clients pour la méthode Stérilisation féminine"
label variable q220h_4 "Ce point de vente oriente des services de suivi aux clients pour la méthode Stérilisation féminine"
label variable q220h_5 "Ce point de vente fournit des services de suivi aux clients pour la méthode Stérilisation féminine"
label variable q220h_6 "NA_Stérilisation féminine"
label variable q220i "Stérilisation masculine (Vasectomie)"


label variable q220i_1 "Ce point de vente vend des services de suivi aux clients pour la méthode Stérilisation masculine"
label variable q220i_2 "Ce point de vente prescrit des services de suivi aux clients pour la méthode Stérilisation masculine"
label variable q220i_3 "Ce point de vente conseille des services de suivi aux clients pour la méthode Stérilisation masculine"
label variable q220i_4 "Ce point de vente oriente des services de suivi aux clients pour la méthode Stérilisation masculine"
label variable q220i_5 "Ce point de vente fournit des services de suivi aux clients pour la méthode Stérilisation masculine"
label variable q220j "Allaitement maternel exclusif (MAMA)"

label variable q220i_6 "NA_Stérilisation masculine"
label variable q220j_1 "Ce point de vente vend des services de suivi aux clients pour la méthode Allaitement maternel exclusif"
label variable q220j_2 "Ce point de vente prescrit des services de suivi aux clients pour la méthode Allaitement maternel exclusif"
label variable q220j_3 "Ce point de vente conseille des services de suivi aux clients pour la méthode Allaitement maternel exclusif"
label variable q220j_4 "Ce point de vente oriente des services de suivi aux clients pour la méthode Allaitement maternel exclusif"
label variable q220j_5 "Ce point de vente fournit des services de suivi aux clients pour la méthode Allaitement maternel exclusif"
label variable q220j_6 "NA_Allaitement maternel exclusif"
label variable q221a "Au cours du dernier mois écoulé, combien de clients ont bénéficié de Dispositif intra-utérin"
label variable q221b "Au cours du dernier mois écoulé, combien de clients ont bénéficié de Injectables"
label variable q221c "Au cours du dernier mois écoulé, combien de clients ont bénéficié de Préservatifs (Masculin)"
label variable q221d "Au cours du dernier mois écoulé, combien de clients ont bénéficié de Préservatifs (Féminin)"
label variable q221e "Au cours du dernier mois écoulé, combien de clients ont bénéficié de Contraception d'urgence"
label variable q221f "Au cours du dernier mois écoulé, combien de clients ont bénéficié de Pilules"
label variable q221g "Au cours du dernier mois écoulé, combien de clients ont bénéficié de Implants"
label variable q221h "Au cours du dernier mois écoulé, combien de clients ont bénéficié de Stérilisation féminine (Ligature des trompes)"
label variable q221i "Au cours du dernier mois écoulé, combien de clients ont bénéficié de Stérilisation masculine (Vasectomie)"
label variable q221j "Au cours du dernier mois écoulé, combien de clients ont bénéficié de Allaitement maternel exclusif (MAMA)"
label variable q222 "Votre pharmacie / dépôt de médicaments facture-t-elle des frais à vos clients pour la prescription de méthodes de planifications familiales ?"
label variable q223 "Quel est le coût de la prescription de méthodes de planification familiale dans votre pharmacie / dépôt de médicaments ?"
label variable q224 "Cette pharmacie / dépôt de médicaments administre-t-elle également des produits injectables/des implants aux clients ?"
label variable q225 "Votre pharmacie / dépôt de médicaments facture-t-elle des frais à vos clients pour l'administration des produits injectables?"
label variable q226 "Quel est le coût de l'administration des produits injectables dans votre pharmacie ou votre dépôt de médicaments ?"
label variable q227 "Votre pharmacie / dépôt de médicaments facture-t-elle des frais à vos clients pour la pose d'implant ?"
label variable q228 "Quel est le montant des frais de pose d'implants appliqués dans votre pharmacie ou - dépôt de médicaments ? "
label variable q301 "Votre pharmacie ou dépôt de médicaments a-t-il stocké ou vendu des DIU au cours des 12 derniers mois ?"
label variable q302 "Combien d'unités (pièces) de DIU votre pharmacie ou dépôt de médicaments a-t-il actuellement en stock ? "
label variable q303 "Au cours du mois passé, combien de DIU votre pharmacie ou dépôt de médicaments a-t-il vendu ?"
label variable q304 "Votre pharmacie / dépôt de médicaments a-t-il connu une rupture de stock du DIU au cours des 12 derniers mois ?"
label variable q305 "Quelle a été la durée de la rupture de stock au cours des 12 derniers mois ?"
label variable q306 "Au cours des trois derniers mois, combien d'incidents se sont produits lorsqu'une cliente est venue acheter un DIU, mais qu'il n'était pas disponible ?"
label variable q307 "Qu'aviez-vous fait lorsque les DIU n'étaient pas disponibles à un moment ?"
label variable q307other "Précisez ce que vous avez fait lorsque les DIU n'étaient pas disponibles ?"
label variable q308 "Est ce que votre pharmacie / dépôt de médicaments a stocké ou vendu des pilules durant les 12 derniers mois ?"
label variable q309 "Combien d'unités de pilules cette pharmacie / dépôt de médicaments a-t-elle actuellement en stock ?"
label variable q310 "Durant le mois passé, combien d'unités de pilules votre pharmacie / dépôt de médicaments a-t-il vendu ?"
label variable q311 "Au cours des 12 derniers mois, votre pharmacie / dépôt de médicaments a-t-il connu des ruptures de stock de pilules ?"
label variable q312 "Quelle a été la durée de la rupture de stock au cours des 12 derniers mois ?"
label variable q313 "Au cours des trois derniers mois, combien d'incidents se sont produits lorsqu'un client est venu acheter des pilules, mais que celles-ci n'étaient pas disponibles ?  "
label variable q314 "Qu'aviez-vous fait lorsque les pilules n'étaient pas disponibles dans le point de vente et que les clients en demandaient ?"
label variable q314_other "Précisez ce que vous avez fait d'autre lorsque les pilules n'étaient pas disponibles au point de vente et que les clients les demandaient."
label variable q315 "Votre pharmacie / dépôt de médicaments a-t-il stocké / vendu des préservatifs masculins au cours des 12 derniers mois ?"
label variable q316 "Combien d'unités de préservatifs masculins votre pharmacie /  dépôt de médicaments a-t-il actuellement en stock ?"
label variable q317 "Durant le mois passé, combien d'unités (paquets) de préservatifs masculins votre pharmacie / dépôt de médicaments a-t-il vendu ?"
label variable q318 "Au cours des 12 derniers mois, votre pharmacie / dépôt de médicaments a-t-elle connu des ruptures de préservatifs masculins ?"
label variable q319 "Quelle a été la durée de la rupture de stock au cours des 12 derniers mois ?"
label variable q320 "Au cours des 3 derniers mois, combien d'incidents se sont produits lorsqu'un client est venu acheter de préservatifs masculins, mais qu'il n'était pas disponible ?  "
label variable q321 "Qu'aviez-vous fait lorsque les préservatifs masculins n'étaient pas disponibles dans le point de vente et que les clients en demandaient ?"
label variable q321other "Précisez quelle autre mesure vous avez prise lorsque les préservatifs masculins n'étaient pas disponibles au point de vente et que les clients en demandaient ?"
label variable q322 "Votre pharmacie / dépôt de medicaments a-t-il stocké / vendu des préservatifs féminins au cours des 12 derniers mois ?"
label variable q323 "Combien d'unités de préservatifs féminins votre pharmacie /  dépôt de médicaments a-t-il actuellement en stock ?"
label variable q324 "Durant le mois passé, combien d'unités de préservatifs féminins votre pharmacie /  dépôt de médicaments a-t-il vendu ? "
label variable q325 "Au cours des 12 derniers mois, votre pharmacie /  dépôt de médicaments a-t-il connu des ruptures de préservatifs féminins ?"
label variable q326 "Quelle a été la durée de la rupture de stock au cours des 12 derniers mois ?"
label variable q327 "Au cours des 3 derniers mois, combien d'incidents se sont produits lorsqu'un client est venu acheter de préservatifs féminins, mais qu'il n'était pas disponible ?  "
label variable q328 "Qu'aviez-vous fait lorsque les préservatifs féminins n'étaient pas disponibles dans le point de vente et que les clients en demandaient ?"
label variable q328other "Veuillez préciser"
label variable q329 "Votre pharmacie / dépôt de medicaments a-t-elle stocké / vendu des contraceptions injectables au cours des 12 derniers mois ?"
label variable q330 "Combien d'unités (doses) de contraception injectable votre pharmacie /  dépôt de médicaments a-t-elle actuellement en stock ?"
label variable q331 "Durant le mois passé, combien d'unités (doses) de contraception injectable votre pharmacie /  dépôt de médicaments a-t-elle vendu ?"
label variable q332 "Au cours des 12 derniers mois, votre pharmacie /  dépôt de médicaments a-t-elle connu des ruptures d'injectable ?"
label variable q333 "Quelle a été la durée de la rupture de stock au cours des 12 derniers mois ?"
label variable q334 "Au cours des 3 derniers mois, combien d'incidents se sont produits lorsqu'un client est venu acheter des contraceptions injectables mais qu'il n'était pas disponible ?  "
label variable q335 "Qu'aviez-vous fait lorsque les contraceptions injectables de vente n'étaient pas disponibles et que les clients en demandaient ?"
label variable q335other "Autre action que vous avez faite"
label variable q336 "Votre pharmacie / dépôt de medicaments a-t-elle stocké / vendu des implants au cours des 12 derniers mois ?"
label variable q337 "Combien d'unités (pièces) des implants votre pharmacie /  dépôt de médicaments a-t-elle actuellement en stock ?"
label variable q338 "Durant le mois passé, combien d'unités (pièces) d'implants votre pharmacie /  dépôt de médicaments a-t-elle vendu ?"
label variable q339 "Au cours des 12 derniers mois, votre pharmacie /  dépôt de médicaments a-t-elle connu des ruptures d'implants ?"
label variable q340 "Quelle a été la durée de la rupture de stock au cours des 12 derniers mois ?"
label variable q341 "Au cours des 3 derniers mois, combien d'incidents se sont produits lorsqu'un client est venu acheter des implants, mais qu'il n'était pas disponible ?  "
label variable q342 "Qu'aviez-vous fait lorsque les implants de vente n'étaient pas disponibles et que les clients en demandaient ?"
label variable q342other "Autre action que vous avez faite"
label variable q343 "Votre pharmacie /  dépôt de médicaments a-t-il stocké ou vendu la contraception d'urgence au cours des 12 derniers mois ?"
label variable q344 "Combien d'unités de contraception d'urgence votre pharmacie  /  dépôt de médicaments a-t-elle actuellement en stock ?"
label variable q345 "Au cours du mois passé, combien d'unités de contraception d'urgence votre pharmacie /  dépôt de médicaments a-t-elle vendu ?"
label variable q346 "Votre pharmacie /  dépôt de médicaments a-t-elle connu des ruptures de stock de contraception d'urgence au cours des 12 derniers mois ?"
label variable q347 "Quelle a été la durée de la rupture de stock au cours des 12 derniers mois ?"
label variable q348 "Au cours des 3 derniers mois, combien d'incidents se sont produits lorsqu'un client est venu acheter une contraception d'urgence, mais qu'ils n'étaient pas disponibles ?  "
label variable q349 "Qu'aviez-vous fait lorsque la contraception d'urgence n'était pas disponible à un moment ?"
label variable q349other "Autre action que vous avez faite"
label variable q401 "Quelles sont les trois méthodes de planification familiale les plus fréquemment demandées par les clients de votre commune ?"
label variable q401_1 "Méthode de PF le plus fréquemment demandées par les clients de votre commune: DIU"
label variable q401_2 "Méthode de PF le plus fréquemment demandées par les clients de votre commune: Injectables"
label variable q401_3 "Méthode de PF le plus fréquemment demandées par les clients de votre commune: Préservatifs (Masculin)"
label variable q401_4 "Méthode de PF le plus fréquemment demandées par les clients de votre commune: Préservatifs (Féminin)"
label variable q401_5 "Méthode de PF le plus fréquemment demandées par les clients de votre commune: Contraception d'urgence"
label variable q401_6 "Méthode de PF le plus fréquemment demandées par les clients de votre commune: Pilules"
label variable q401_7 "Méthode de PF le plus fréquemment demandées par les clients de votre commune: Implants"
label variable q401_8 "Méthode de PF le plus fréquemment demandées par les clients de votre commune: Stérilisation féminine" 
label variable q401_9 "Méthode de PF le plus fréquemment demandées par les clients de votre commune: Stérilisation masculine"
label variable q401_10 "Méthode de PF le plus fréquemment demandées par les clients de votre commune: Allaitement Maternel Exclusif"
label variable q401a "Rang pour DIU"
label variable q401b "Rang pour Injectables"
label variable q401c "Rang pour Préservatifs (Masculin)"
label variable q401d "Rang pour Préservatifs (Féminin)"
label variable q401e "Rang pour Contraception d'urgence"
label variable q401f "Rang pour Pilules"
label variable q401g "Rang pour Implants"
label variable q401h "Rang pour Stérilisation féminine"
rename Q401i q401i
label variable q401i "Rang pour Stérilisation masculine"
label variable q401j "Rang pour Allaitement maternel exclusif"
label variable q402 "Comment décidez-vous des contraceptifs que vous suggérerez aux clients s'ils vous le demandent ?"
label variable q402_1 "Décision: Selon l'objectif (espacement/limitation)"
label variable q402_2 "Décision: Selon le choix (hormonal/non-hormonal)"
label variable q402_3 "Décision: Selon le nombre d'enfants qu'ils ont déjà"
label variable q402_4 "Décision: Selon le pouvoir d'achat"
label variable q402_5 "Décision: Selon la disponibilité de stock "
label variable q402_96 "Décision: Autres"
label variable q402_98 "Décision: NSP"
label variable q402_other "Autre décision"
label variable q403 "En moyenne, combien de clients cette pharmacie  /  dépôt de médicaments sert-il chaque mois pour des méthodes de planification familiale ?"
label variable q404a "Quel type de clients vient habituellement chercher dans votre pharmacie les services et produits de planification familiale comme le DIU ?"
label variable q404a_1 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme le DIU : Hommes <=20 ans (adolesents et jeunes) "
label variable q404a_2 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme le DIU : Hommes >20 ans (adultes) "
label variable q404a_3 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme le DIU : Femmes <=20 ans (adolesents et jeunes) "
label variable q404a_4 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme le DIU : Femmes >20 ans (adultes) "
label variable q404a_5 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme le DIU : Ne vend pas le produit "
label variable q404b "Quel type de clients vient habituellement chercher dans votre pharmacie les services et produits de planification familiale comme les Injectables ?"
label variable q404b_1 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme les Injectables : Hommes <=20 ans (adolesents et jeunes) "
label variable q404b_2 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme les Injectables : Hommes >20 ans (adultes) "
label variable q404b_3 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme les Injectables : Femmes <=20 ans (adolesents et jeunes) "
label variable q404b_4 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme les Injectables : Femmes >20 ans (adultes) "
label variable q404b_5 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme les Injectables : Ne vend pas le produit "
label variable q404c "Quel type de clients vient habituellement chercher dans votre pharmacie les services et produits de planification familiale comme les Préservatifs (Masculin) ?"
label variable q404c_1 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme les Préservatifs (Masculin) : Hommes <=20 ans (adolesents et jeunes) "
label variable q404c_2 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme les Préservatifs (Masculin) : Hommes >20 ans (adultes) "
label variable q404c_3 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme les Préservatifs (Masculin) : Femmes <=20 ans (adolesents et jeunes) "
label variable q404c_4 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme les Préservatifs (Masculin) : Femmes >20 ans (adultes) "
label variable q404c_5 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme les les Préservatifs (Masculin) : Ne vend pas le produit "
label variable q404d "Quel type de clients vient habituellement chercher dans votre pharmacie les services et produits de planification familiale comme les Préservatifs (féminin) ?"
label variable q404d_1 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme les Préservatifs (féminin) : Hommes <=20 ans (adolesents et jeunes) "
label variable q404d_2 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme les Préservatifs (féminin) : Hommes >20 ans (adultes) "
label variable q404d_3 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme les Préservatifs (féminin) : Femmes <=20 ans (adolesents et jeunes) "
label variable q404d_4 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme les Préservatifs (féminin) : Femmes >20 ans (adultes) "
label variable q404d_5 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme les Préservatifs (féminin) : Ne vend pas le produit "
label variable q404e "Quel type de clients vient habituellement chercher dans votre pharmacie les services et produits de planification familiale comme la Contraception d'urgence ?"
label variable q404e_1 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme la Contraception d'urgence : Hommes <=20 ans (adolesents et jeunes) "
label variable q404e_2 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme la Contraception d'urgence : Hommes >20 ans (adultes) "
label variable q404e_3 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme la Contraception d'urgence : Femmes <=20 ans (adolesents et jeunes) "
label variable q404e_4 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme la Contraception d'urgence : Femmes >20 ans (adultes) "
label variable q404e_5 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme la Contraception d'urgence : Ne vend pas le produit "
label variable q404f "Quel type de clients vient habituellement chercher dans votre pharmacie les services et produits de planification familiale comme les Pilules ?"
label variable q404f_1 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme les Pilules : Hommes <=20 ans (adolesents et jeunes) "
label variable q404f_2 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme les Pilules : Hommes >20 ans (adultes) "
label variable q404f_3 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme les Pilules : Femmes <=20 ans (adolesents et jeunes) "
label variable q404f_4 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme les Pilules : Femmes >20 ans (adultes) "
label variable q404f_5 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme les Pilules: Ne vend pas le produit "
label variable q404g "Quel type de clients vient habituellement chercher dans votre pharmacie les services et produits de planification familiale comme les Implants ?"
label variable q404g_1 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme les Implants : Hommes <=20 ans (adolesents et jeunes) "
label variable q404g_2 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme les Implants : Hommes >20 ans (adultes) "
label variable q404g_3 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme les Implants : Femmes <=20 ans (adolesents et jeunes) "
label variable q404g_4 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme les Implants : Femmes >20 ans (adultes) "
label variable q404g_5 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme les Implants: Ne vend pas le produit "
label variable q404h "Quel type de clients vient habituellement chercher dans votre pharmacie les services et produits de planification familiale comme la Stérilisation féminine ?"
label variable q404h_1 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme la Stérilisation féminine : Hommes <=20 ans (adolescents et jeunes) "
label variable q404h_2 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme la Stérilisation féminine : Hommes >20 ans (adultes) "
label variable q404h_3 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme la Stérilisation féminine : Femmes <=20 ans (adolesents et jeunes) "
label variable q404h_4 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme la Stérilisation féminine : Femmes >20 ans (adultes) "
label variable q404h_5 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme la Stérilisation féminine: Ne vend pas le produit "
label variable q404i "Quel type de clients vient habituellement chercher dans votre pharmacie les services et produits de planification familiale comme la Stérilisation masculine ? "
label variable q404i_1 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme la Stérilisation masculine : Hommes <=20 ans (adolescents et jeunes) "
label variable q404i_2 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme la Stérilisation masculine : Hommes >20 ans (adultes) "
label variable q404i_3 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme la Stérilisation masculine : Femmes <=20 ans (adolesents et jeunes) "
label variable q404i_4 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme la Stérilisation masculine : Femmes >20 ans (adultes) "
label variable q404i_5 "type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme la Stérilisation masculine: Ne vend pas le produit "
label variable q404j "Quel type de clients vient habituellement chercher dans votre pharmacie les services et produits de planification familiale comme l'Allaitement maternel exclusif ? "
label variable q404j_1 "Type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme l'Allaitement maternel exclusif : Hommes <=20 ans (adolescents et jeunes) "
label variable q404j_2 "Type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme l'Allaitement maternel exclusif : Hommes >20 ans (adultes) "
label variable q404j_3 "Type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme l'Allaitement maternel exclusif : Femmes <=20 ans (adolesents et jeunes) "
label variable q404j_4 "Type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme l'Allaitement maternel exclusif : Femmes >20 ans (adultes) "
label variable q404j_5 "Type de clients qui viennent habituellement chercher dans votre pharmacie les services et produits de planification familiale comme l'Allaitement maternel exclusif: Ne vend pas le produit "
label variable q405 "Cette pharmacie /  dépôt de médicaments propose-t-elle également des pilules abortives ?"
label variable q406 "Au cours des 12 derniers mois, votre pharmacie /  dépôt de médicaments a-t-elle stocké ou vendu des pilules abortives ?"
label variable q407 "Combien d'unités (bandes) de pilules abortives médicales votre pharmacie /  dépôt de médicaments a-t-elle actuellement en stock ?"
label variable q408 "Au cours du mois écoulé, combien d'unités de pilules médicales abortives avez-vous vendu ?"
label variable q409 "Au cours des 12 derniers mois y a-t-il eu des ruptures de stock de pilules abortives ?"
label variable q410 "Quelle a été la durée de la rupture de stock au cours des 12 derniers mois ?"
label variable q411 "Au cours des 3 derniers mois, combien d'incidents se sont produits lorsqu'une cliente est venue acheter des pilules abortives à des fins médicales, mais qu'elles n'étaient pas disponibles"
label variable q412 "Qu'aviez-vous fait lorsque les pilules médicales abortives n'étaient pas disponibles à un moment donné ?"
label variable q412other "Autre action que vous avez faite"
label variable q413 "Au cours du mois écoulé, combien de clientes se sont présentées à la pharmacie /  dépôt de médicaments pour demander des pilules abortives ?"
label variable q414 "Comment décidez-vous de la pilule abortive médicale que vous suggérerez à vos clients ?"
label variable q414_1 "Façon de décider: Les clients viennent pour une marque particulière"
label variable q414_2 "Façon de décider: Choix selon le pouvoir d'achat"
label variable q414_3 "Façon de décider: Choix selon l'âge de gestation"
label variable q414_4 "Façon de décider: Choix selon de l'âge de la femme"
label variable q414_5 "Façon de décider: Choix selon le contenu du stock"
label variable q414_96 "Façon de décider: Autres"
label variable q414other "Veuillez préciser"
label variable q415 "Quels types de clients achètent généralement les pilules abortives dans votre pharmacie ?"
label variable q415_1 "types de clients achètent généralement les pilules abortives dans votre pharmacie: Hommes <=20 ans (adolesents et jeunes)"
label variable q415_2 "Types de clients achètent généralement les pilules abortives dans votre pharmacie: Hommes >20 ans (adultes)"
label variable q415_3 "Types de clients achètent généralement les pilules abortives dans votre pharmacie: Femmes <=20 ans (adolesents et jeunes)"
label variable q415_4 "Types de clients achètent généralement les pilules abortives dans votre pharmacie: Femmes >20 ans (adultes)"
label variable q415_5 "Types de clients achètent généralement les pilules abortives dans votre pharmacie: Ne vend pas le produit"
label variable q415other "Veuillez préciser le type de client"
label variable q501 "Selon vous, quel est l'âge approprié pour qu'une femme tombe enceinte pour la première fois ?"
label variable q502 "Selon vous, quels sont les avantages pour la santé d'une femme si elle tombe enceinte à l'âge approprié que vous avez mentionné ?"
label variable q502_1 "Avantages pour la santé d'une femme si elle tombe enceinte à l'âge approprié que vous avez mentionné: Risque réduit de complications de la grossesse "
label variable q502_2 "Avantages pour la santé d'une femme si elle tombe enceinte à l'âge approprié que vous avez mentionné: Risque réduit d'avortement provoqué"
label variable q502_3 "Avantages pour la santé d'une femme si elle tombe enceinte à l'âge approprié que vous avez mentionné: Risque réduit de fausse couche"
label variable q502_4 "Avantages pour la santé d'une femme si elle tombe enceinte à l'âge approprié que vous avez mentionné: Meilleur état nutritionnel"
label variable q502_5 "Avantages pour la santé d'une femme si elle tombe enceinte à l'âge approprié que vous avez mentionné: Risque réduit d'anémie"
label variable q502_6 "Avantages pour la santé d'une femme si elle tombe enceinte à l'âge approprié que vous avez mentionné: Meilleure santé physique"
label variable q502_7 "Avantages pour la santé d'une femme si elle tombe enceinte à l'âge approprié que vous avez mentionné: Meilleure santé mentale"
label variable q502_96 "Avantages pour la santé d'une femme si elle tombe enceinte à l'âge approprié que vous avez mentionné: Autre"
label variable q502_98 "Avantages pour la santé d'une femme si elle tombe enceinte à l'âge approprié que vous avez mentionné: Ne sait pas"
label variable q502_other "Veuillez préciser les autres avantages"
label variable q503 "Selon vous, quel devrait être l'espacement minimum entre deux naissances consécutives ?"
label variable q504 "Selon vous, quels sont les bénéfices de l'espacement des naissances pour une femme ? "
label variable q504_1 "Bénéfices de l'espacement des naissances pour une femme: Risque réduit de complications de la grossesse"
label variable q504_2 "Bénéfices de l'espacement des naissances pour une femme: Risque réduit de décès maternel"
label variable q504_3 "Bénéfices de l'espacement des naissances pour une femme: Risque réduit d'avortement provoqué"
label variable q504_4 "Bénéfices de l'espacement des naissances pour une femme: Risque réduit de fausse couche"
label variable q504_5 "Bénéfices de l'espacement des naissances pour une femme: Risque réduit d'anémie"
label variable q504_6 "Bénéfices de l'espacement des naissances pour une femme: Permet deux années d'allaitement comme recommandées"
label variable q504_96 "Bénéfices de l'espacement des naissances pour une femme: Autre"
label variable q504_98 "Bénéfices de l'espacement des naissances pour une femme: Ne sait pas"
label variable q504_other "Veuillez préciser les autres bénéfices"
label variable q505 "Selon vous, quel(s) avantage(s) sanitaire(s) un enfant aura-t-il si les naissances sont espacées ?"
label variable q505_1 "Avantage(s) sanitaire(s) un enfant aura-t-il si les naissances sont espacées: Risque réduit de décès néonatal"
label variable q505_2 "Avantage(s) sanitaire(s) un enfant aura-t-il si les naissances sont espacées: Meilleure croissance"
label variable q505_3 "Avantage(s) sanitaire(s) un enfant aura-t-il si les naissances sont espacées: Meilleur état nutritionnel"
label variable q505_4 "Avantage(s) sanitaire(s) un enfant aura-t-il si les naissances sont espacées: Diminution de l'incidence de l'anémie"
label variable q505_5 "Avantage(s) sanitaire(s) un enfant aura-t-il si les naissances sont espacées: Meilleure chance de survie"
label variable q505_6 "Avantage(s) sanitaire(s) un enfant aura-t-il si les naissances sont espacées: Meilleure attention de la part de la mère"
label variable q505_7 "Avantage(s) sanitaire(s) un enfant aura-t-il si les naissances sont espacées: Risque réduit de décès néonatal"
label variable q505_96 "Avantage(s) sanitaire(s) un enfant aura-t-il si les naissances sont espacées: Autre"
label variable q505_98 "Avantage(s) sanitaire(s) un enfant aura-t-il si les naissances sont espacées: Ne sait pas"
label variable q505_other "Autre avantage"
label variable q506 "Selon vous, combien de temps une femme doit-elle attendre après un avortement spontané ou provoqué pour retomber enceinte ?"
label variable q507 "Selon vous, quels sont les avantages pour les femmes d'attendre au lieu de tomber enceinte immédiatement ?"
label variable q507_1 "Avantages pour les femmes d'attendre au lieu de tomber enceinte immédiatement: Risque réduit de complications de la grossesse"
label variable q507_2 "Avantages pour les femmes d'attendre au lieu de tomber enceinte immédiatement: Risque réduit de décès maternels"
label variable q507_3 "Avantages pour les femmes d'attendre au lieu de tomber enceinte immédiatement: Diminution du risque de fausses couches"
label variable q507_4 "Avantages pour les femmes d'attendre au lieu de tomber enceinte immédiatement: Risque réduit d'anémie (faiblesse)"
label variable q507_96 "Avantages pour les femmes d'attendre au lieu de tomber enceinte immédiatement: Autre"
label variable q507_98 "Avantages pour les femmes d'attendre au lieu de tomber enceinte immédiatement: Ne sait pas"
label variable q507_other "Autre avantage"
label variable q508 "Que dites-vous de l'assertion suivante « une femme a plus de chances de tomber enceinte si elle a des rapports sexuels à certains jours de son cycle menstruel ». Est-elle vraie ou fausse ?"
label variable q509 "Quels sont les jours du cycle menstruel où les chances de tomber enceinte sont les plus élevées ?"
label variable q610 "Quelles sont les méthodes dont vous avez entendu parler "
label variable q610_1 "Méthodes dont vous avez entendu parler: DIU"
label variable q610_2 "Méthodes dont vous avez entendu parler: Injectables"
label variable q610_3 "Méthodes dont vous avez entendu parler: Préservatifs (Féminin)"
label variable q610_4 "Méthodes dont vous avez entendu parler: Préservatifs (Masculin)"
label variable q610_5"Méthodes dont vous avez entendu parler: Contraception d'urgence"
label variable q610_6 "Méthodes dont vous avez entendu parler: Pilules"
label variable q610_7 "Méthodes dont vous avez entendu parler: Implants"
label variable q610_8 "Méthodes dont vous avez entendu parler: Stérilisation féminine"
label variable q610_9 "Méthodes dont vous avez entendu parler: Stérilisation masculine"
label variable q610_10 "Méthodes dont vous avez entendu parler: Allaitement maternel exclusif"
label variable q610_11 "Méthodes dont vous avez entendu parler: Méthode des jours fixes"
label variable q610_12 "Méthodes dont vous avez entendu parler: Aucune"
label variable q610_1_1 "Bien vrai que vous avez cité certaines méthodes, est ce que vous n'avait pas aussi entendu parler du  DIU"
label variable q610_1_2 "Bien vrai que vous avez cité certaines méthodes, est ce que vous n'avait pas aussi entendu parler des Injectables"
label variable q610_1_3 "Bien vrai que vous avez cité certaines méthodes, est ce que vous n'avait pas aussi entendu parler des Préservatifs (Féminin)"
label variable q610_1_4 "Bien vrai que vous avez cité certaines méthodes, est ce que vous n'avait pas aussi entendu parler des Préservatifs (Masculin)"
label variable q610_1_5 "Bien vrai que vous avez cité certaines méthodes, est ce que vous n'avait pas aussi entendu parler de la Contraception d'urgence"
label variable q610_1_6 "Bien vrai que vous avez cité certaines méthodes, est ce que vous n'avait pas aussi entendu parler des Pilules"
label variable q610_1_7 "Bien vrai que vous avez cité certaines méthodes, est ce que vous n'avait pas aussi entendu parler des Implants"
label variable q610_1_8 "Bien vrai que vous avez cité certaines méthodes, est ce que vous n'avait pas aussi entendu parler de la Stérilisation féminine"
label variable q610_1_9 "Bien vrai que vous avez cité certaines méthodes, est ce que vous n'avait pas aussi entendu parler de la Stérilisation masculine"
label variable q610_1_10 "Bien vrai que vous avez cité certaines méthodes, est ce que vous n'avait pas aussi entendu parler de l'Allaitement maternel exclusif"
label variable q610_1_11 "Bien vrai que vous avez cité certaines méthodes, est ce que vous n'avait pas aussi entendu parler de la Méthode des jours fixes"
label variable q511 "Vous avez dit que vous-avez entendu parler de DIU. Quels sont les avantages d'utiliser ces méthodes ?"
label variable q511_1 "Avantage d'utiliser la méthode DIU: C'est efficace"
label variable q511_2 "Avantage d'utiliser la méthode DIU: C'est réversible"
label variable q511_3 "Avantage d'utiliser la méthode DIU: C'est immédiatement reversible sans retard dans le retour à la fertilité"
label variable q511_4 "Avantage d'utiliser la méthode DIU: Seul le suivi initial est nécessaire"
label variable q511_5 "Avantage d'utiliser la méthode DIU: N'interfère pas avec les rapports sexuels"
label variable q511_6 "Avantage d'utiliser la méthode DIU: Pas d'effets sur la production de lait maternel"
label variable q511_7 "Avantage d'utiliser la méthode DIU: Il n'est pas necessaire d'acheter des fournitures"
label variable q511_8 "Avantage d'utiliser la méthode DIU: Peut servir de méthode contraceptive d'urgence lorsqu'il est inséré dans les cinq jours suivant un rapport sexuel non protégé"
label variable q511_9 "Avantage d'utiliser la méthode DIU: C'est une méthode à long terme (5/10 ans)"
label variable q511_10 "Avantage d'utiliser la méthode DIU: Peut être utilisé comme méthode de limitation"
label variable q511_11 "Avantage d'utiliser la méthode DIU: Risque d'effets secondaires plus faible que les autres méthodes réversibles"
label variable q511_96 "Avantage d'utiliser la méthode DIU: Autre"
label variable q511_other "Autre avantage"
label variable q512 "Quels sont les problèmes auxquels les clients font face lors de l'utilisation de DIU ?"
label variable q512_1 "Problèmes auxquels les clients font face lors de l'utilisation de DIU: Faiblesse"
label variable q512_2 "Problèmes auxquels les clients font face lors de l'utilisation de DIU: Echec de la méthode (grossesse)"
label variable q512_3 "Problèmes auxquels les clients font face lors de l'utilisation de DIU: Augmentation du risque d'infection"
label variable q512_4 "Problèmes auxquels les clients font face lors de l'utilisation de DIU: Réduction des sensations/ plaisir des rapports sexuels "
label variable q512_5 "Problèmes auxquels les clients font face lors de l'utilisation de DIU: Gene lors des rapports sexuels"
label variable q512_6 "Problèmes auxquels les clients font face lors de l'utilisation de DIU: Malformations génitales chez le futur bébé"
label variable q512_7 "Problèmes auxquels les clients font face lors de l'utilisation de DIU: Infertilité"
label variable q512_8 "Problèmes auxquels les clients font face lors de l'utilisation de DIU: Saignements excessifs"
label variable q512_9 "Problèmes auxquels les clients font face lors de l'utilisation de DIU: Douleurs abdominales"
label variable q512_10 "Problèmes auxquels les clients font face lors de l'utilisation de DIU: Douleurs abdominales"
label variable q512_96 "Problèmes auxquels les clients font face lors de l'utilisation de DIU: Autre"
label variable q512_98 "Problèmes auxquels les clients font face lors de l'utilisation de DIU: Ne sait pas"
label variable q512_other "Autre problème"
label variable q513 "Quels sont les états de santé et les situations dans lesquels une femme ne devrait pas utiliser de DIU ?"
label variable q513_1 "Etats de santé et les situations dans lesquels une femme ne devrait pas utiliser de DIU: Femme n'étant jamais tombé enceinte"
label variable q513_2 "Etats de santé et les situations dans lesquels une femme ne devrait pas utiliser de DIU: Femme très anémiée"
label variable q513_3 "Etats de santé et les situations dans lesquels une femme ne devrait pas utiliser de DIU: Femme avec des risques d'obtenir des IST"
label variable q513_4 "Etats de santé et les situations dans lesquels une femme ne devrait pas utiliser de DIU: Infections dans les trompes"
label variable q513_5 "Etats de santé et les situations dans lesquels une femme ne devrait pas utiliser de DIU: Infections utérines"
label variable q513_6 "Etats de santé et les situations dans lesquels une femme ne devrait pas utiliser de DIU: Infection après avoir donné naissance"
label variable q513_7 "Etats de santé et les situations dans lesquels une femme ne devrait pas utiliser de DIU: Grossesse tubaire en cours "
label variable q513_8 "Etats de santé et les situations dans lesquels une femme ne devrait pas utiliser de DIU: Femmes qui se plaignent de saignements et de douleurs pendant les règles "
label variable q513_9 "Etats de santé et les situations dans lesquels une femme ne devrait pas utiliser de DIU: Femmes ayant beaucoup d'enfants"
label variable q513_10 "Etats de santé et les situations dans lesquels une femme ne devrait pas utiliser de DIU: Femme ayant bénéficié d'une césarienne"
label variable q513_96 "Etats de santé et les situations dans lesquels une femme ne devrait pas utiliser de DIU: Autre"
label variable q513_98 "Etats de santé et les situations dans lesquels une femme ne devrait pas utiliser de DIU: Ne sait pas"
label variable q513_other "Autre état"
label variable q514 "Selon vous, cette méthode est-elle adaptée pour retarder la première naissance ?"
label variable q515 "Selon vous, cette méthode est-elle adaptée au maintien de l'intervalle entre deux naissances ?"
label variable q516 "Pensez-vous que les légers saignements après l'insertion de DIU sont normaux ?"
label variable q517 "Selon vous, quel est le moment le plus recommandé pour insérer à une femme un DIU ?"
label variable q517_1 "Selon vous, le moment le plus recommandé pour insérer à une femme un DIU est: Dans les 12 premiers jours du cycle menstruel"
label variable q517_2 "Selon vous, le moment le plus recommandé pour insérer à une femme un DIU est: Dans les 48 heures suivant l'accouchement"
label variable q517_3 "Selon vous, le moment le plus recommandé pour insérer à une femme un DIU est: Après six semaines suivant l'accouchement"
label variable q517_4 "Selon vous, le moment le plus recommandé pour insérer à une femme un DIU est: Dans les 12 jours suivant une interruption de grossesse"
label variable q517_96 "Selon vous, le moment le plus recommandé pour insérer à une femme un DIU est: Autre"
label variable q517_98 "Selon vous, le moment le plus recommandé pour insérer à une femme un DIU est: Ne sait pas"
label variable q517_other "Autre moment"
label variable q518 "Selon vous, qui peut insérer un DIU ?"
label variable q518_1 "Selon vous, tout médecin peut insérer un DIU"
label variable q518_2 "Selon vous, les gynécologues peuvent insérer un DIU"
label variable q518_3 "Selon vous, les sages-femmes peuvent insérer un DIU"
label variable q518_4 "Selon vous, toute infirmière donnée peut insérer un DIU"
label variable q518_5 "Selon vous, les ASC peuvent insérer un DIU"
label variable q518_6 "Selon vous, les matrones peuvent insérer un DIU"
label variable q518_96 "Selon vous, qui peut insérer un DIU: Autre"
label variable q518_98 "Selon vous, qui peut insérer un DIU: Ne sait pas"
label variable q518_other "Autre"
label variable q519 "Que dites-vous à une femme pour verifier si le DIU est en place ?"
label variable q519_1 "Que dites-vous à une femme pour verifier si le DIU est en place : Se laver les mains"
label variable q519_2 "Que dites-vous à une femme pour verifier si le DIU est en place : S'accroupir et palper le fil avec ses doigts"
label variable q519_3 "Que dites-vous à une femme pour verifier si le DIU est en place : Retirer le doigt et se laver les mains à nouveau"
label variable q519_96 "Que dites-vous à une femme pour verifier si le DIU est en place : Autre"
label variable q519_98 "Que dites-vous à une femme pour verifier si le DIU est en place : Ne sait pas"
label variable q519_other "Autre à dire"
label variable q520 "Pouvez-vous nous dire la fréquence d'utilisation des pilules "
label variable q521 "Quels sont les problémes auxquels les femmes peuvent faire face durant / après la prise d'une pilule?"
label variable q521_1 "Problèmes auxquels les femmes peuvent faire face durant / après la prise d'une pilule: Réduction de la production de lait"
label variable q521_2 "Problèmes auxquels les femmes peuvent faire face durant / après la prise d'une pilule: Réduction de la capacité de travail"
label variable q521_3 "Problèmes auxquels les femmes peuvent faire face durant / après la prise d'une pilule: Nausées"
label variable q521_4 "Problèmes auxquels les femmes peuvent faire face durant / après la prise d'une pilule: Maux de tête"
label variable q521_5 "Problèmes auxquels les femmes peuvent faire face durant / après la prise d'une pilule: Gonflement des jambes"
label variable q521_6 "Problèmes auxquels les femmes peuvent faire face durant / après la prise d'une pilule: Changements durant les règles"
label variable q521_7 "Problèmes auxquels les femmes peuvent faire face durant / après la prise d'une pilule: Faiblesse"
label variable q521_8 "Problèmes auxquels les femmes peuvent faire face durant / après la prise d'une pilule: Ballonnement/acidité"
label variable q521_9 "Problèmes auxquels les femmes peuvent faire face durant / après la prise d'une pilule: Prise de poids"
label variable q521_10 "Problèmes auxquels les femmes peuvent faire face durant / après la prise d'une pilule: Perte de poids"
label variable q521_11 "Problèmes auxquels les femmes peuvent faire face durant / après la prise d'une pilule: Aucun problème"
label variable q521_96 "Problèmes auxquels les femmes peuvent faire face durant / après la prise d'une pilule: Autre"
label variable q521_98 "Problèmes auxquels les femmes peuvent faire face durant / après la prise d'une pilule: Ne sait pas"
label variable q521_other "Autre problème"
label variable q522 "Quelles sont les situations sanitaires pour lesquelles la prise de pilules chez la femme pourrait être dangeureuse ?"
label variable q522_1 "Situations sanitaires pour lesquelles la prise de pilules chez la femme pourrait être dangereuse: Femme avec jaunisse"
label variable q522_2 "Situations sanitaires pour lesquelles la prise de pilules chez la femme pourrait être dangereuse: Femme ayant eu un accident vasculaire cérébral"
label variable q522_3 "Situations sanitaires pour lesquelles la prise de pilules chez la femme pourrait être dangereuse: Femme paralysée"
label variable q522_4 "Situations sanitaires pour lesquelles la prise de pilules chez la femme pourrait être dangereuse: Femme souffrant d'une maladie cardiaque"
label variable q522_5 "Situations sanitaires pour lesquelles la prise de pilules chez la femme pourrait être dangereuse: Femme souffrant d'une hypertension artérielle"
label variable q522_96 "Situations sanitaires pour lesquelles la prise de pilules chez la femme pourrait être dangereuse: Autre (Précisez)"
label variable q522_98 "Situations sanitaires pour lesquelles la prise de pilules chez la femme pourrait être dangereuse: Ne sait pas"
label variable q522_other "Autre situation"
label variable q523 "Pensez-vous que les pilules peuvent être conseillées à la femme qui allaite ?"
label variable q524 "A votre avis, quand est ce qu'une femme doit commencer à prendre la pilule après ses règles ?"
label variable q524_other "Autre période"
label variable q525 "Pour être efficace, quand est-ce que les préservatifs doivent être utilisés ?"
label variable q525_other "Autre moment"
label variable q526 "Combien de fois peut-on utiliser un préservatif lors d'un rapport sexuel ?"
label variable q527 "Quels sont les avantages d'utiliser un préservatif ? "
label variable q527_1 "Avantages d'utiliser un préservatif: Prévenir la grossesse"
label variable q527_2 "Avantages d'utiliser un préservatif: Sécurité contre les infections sexuelles"
label variable q527_3 "Avantages d'utiliser un préservatif: Prévenir le VIH"
label variable q527_4 "Avantages d'utiliser un préservatif: Facilement disponible"
label variable q527_5 "Avantages d'utiliser un préservatif: Méthode la moins chère"
label variable q527_6 "Avantages d'utiliser un préservatif: Facile à utiliser"
label variable q527_96 "Avantages d'utiliser un préservatif: Autre"
label variable q527_98 "Avantages d'utiliser un préservatif: Ne sait pas"
label variable q527_other "Autre avantage"
label variable q528 "Quels sont les problémes auxquels un client peut faire face lors de l'utilisation d'un préservatif ?"
label variable q528_1 "Problèmes auxquels un client peut faire face lors de l'utilisation d'un préservatif:Réduction du plaisir sexuel"
label variable q528_2 "Problèmes auxquels un client peut faire face lors de l'utilisation d'un préservatif: Allergie"
label variable q528_3 "Problèmes auxquels un client peut faire face lors de l'utilisation d'un préservatif: Échec de la méthode"
label variable q528_4 "Problèmes auxquels un client peut faire face lors de l'utilisation d'un préservatif: Affectent les règles"
label variable q528_5 "Problèmes auxquels un client peut faire face lors de l'utilisation d'un préservatif: Problème d'élimination de l'utilisation des préservatifs"
label variable q528_6 "Problèmes auxquels un client peut faire face lors de l'utilisation d'un préservatif: Aucun problème"
label variable q528_96 "Problèmes auxquels un client peut faire face lors de l'utilisation d'un préservatif: Autre"
label variable q528_98 "Problèmes auxquels un client peut faire face lors de l'utilisation d'un préservatif: Ne sait pas"
label variable q528_other "Autre problème"
label variable q529 "Selon vous, cette méthode est-elle adaptée pour retarder la première naissance ?"
label variable q530 "Selon vous, cette méthode est-elle adaptée au maintien de l'intervalle entre deux naissances ?"
label variable q531 "Selon vous, cette méthode est-elle adaptée pour la limitation des naissances ?"
label variable q532 "Supposons qu'une femme souhaite utiliser un produit injectable. Selon vous, quand doit-elle prendre sa première dose de produit injectable ?"
label variable q532_1 "Supposons qu'une femme souhaite utiliser un produit injectable. Selon vous, quand doit-elle prendre sa première dose de produit injectable : Dans les sept premiers jours du cycle menstruel"
label variable q532_2 "Supposons qu'une femme souhaite utiliser un produit injectable. Selon vous, quand doit-elle prendre sa première dose de produit injectable : Dans les sept premiers jours suivant l'avortement"
label variable q532_3 "Supposons qu'une femme souhaite utiliser un produit injectable. Selon vous, quand doit-elle prendre sa première dose de produit injectable : Après six semaines d'accouchement (si elle allaite)"
label variable q532_4 "Supposons qu'une femme souhaite utiliser un produit injectable. Selon vous, quand doit-elle prendre sa première dose de produit injectable : Immédiatement après l'accouchement (si elle n'allaite pas)"
label variable q532_96 "Supposons qu'une femme souhaite utiliser un produit injectable. Selon vous, quand doit-elle prendre sa première dose de produit injectable : Autre"
label variable q532_98 "Supposons qu'une femme souhaite utiliser un produit injectable. Selon vous, quand doit-elle prendre sa première dose de produit injectable : Ne sait pas"
label variable q532_other "Autre moment"
label variable q533 "Selon vous, quels sont les bénéfices d'utiliser des contraceptifs injectables ou pourquoi une femme devrait utiliser cette méthode ?"
label variable q533_1 "Selon vous, quels sont les bénéfices d'utiliser des contraceptifs injectables ou pourquoi une femme devrait utiliser cette méthode : Très efficace et sûr"
label variable q533_2 "Selon vous, quels sont les bénéfices d'utiliser des contraceptifs injectables ou pourquoi une femme devrait utiliser cette méthode : Pratique et facile à utiliser"
label variable q533_3 "Selon vous, quels sont les bénéfices d'utiliser des contraceptifs injectables ou pourquoi une femme devrait utiliser cette méthode : Agit pendant 3 mois avec un délai de grâce d'un mois"
label variable q533_4 "Selon vous, quels sont les bénéfices d'utiliser des contraceptifs injectables ou pourquoi une femme devrait utiliser cette méthode : Complètement réversible"
label variable q533_5 "Selon vous, quels sont les bénéfices d'utiliser des contraceptifs injectables ou pourquoi une femme devrait utiliser cette méthode : Méthode privée et confidentielle"
label variable q533_6 "Selon vous, quels sont les bénéfices d'utiliser des contraceptifs injectables ou pourquoi une femme devrait utiliser cette méthode : N'interfère pas avec les rapports sexuels"
label variable q533_7 "Selon vous, quels sont les bénéfices d'utiliser des contraceptifs injectables ou pourquoi une femme devrait utiliser cette méthode : Convient aux femmes qui allaitent"
label variable q533_8 "Selon vous, quels sont les bénéfices d'utiliser des contraceptifs injectables ou pourquoi une femme devrait utiliser cette méthode : Utile pour le post-partum immédiat (chez les femmes qui n'allaitent pas)"
label variable q533_9 "Selon vous, quels sont les bénéfices d'utiliser des contraceptifs injectables ou pourquoi une femme devrait utiliser cette méthode : Utilisable après l'avortement"
label variable q533_10 "Selon vous, quels sont les bénéfices d'utiliser des contraceptifs injectables ou pourquoi une femme devrait utiliser cette méthode : Utilisable à tout âge"
label variable q533_11 "Selon vous, quels sont les bénéfices d'utiliser des contraceptifs injectables ou pourquoi une femme devrait utiliser cette méthode : Utilisable pour les femmes de parité faible"
label variable q533_12 "Selon vous, quels sont les bénéfices d'utiliser des contraceptifs injectables ou pourquoi une femme devrait utiliser cette méthode : Réduit les crampes menstruelles"
label variable q533_13 "Selon vous, quels sont les bénéfices d'utiliser des contraceptifs injectables ou pourquoi une femme devrait utiliser cette méthode : Réduit le risque du cancer de l'ovaire et de l'utérus"
label variable q533_96 "Selon vous, quels sont les bénéfices d'utiliser des contraceptifs injectables ou pourquoi une femme devrait utiliser cette méthode : Autre (Précisez)"
label variable q533_98 "Selon vous, quels sont les bénéfices d'utiliser des contraceptifs injectables ou pourquoi une femme devrait utiliser cette méthode : Ne sais pas"
label variable q533_other "Autre bénéfice"
label variable q534 "Quels sont les problèmes auxquels un client peut faire face après qu'on lui ait administré un injectable ?"
label variable q534_1 "Problèmes auxquels un client peut faire face après qu'on lui ait administré un injectable : Maux de tête"
label variable q534_2 "Problèmes auxquels un client peut faire face après qu'on lui ait administré un injectable : Menstrues irrégulières"
label variable q534_3 "Problèmes auxquels un client peut faire face après qu'on lui ait administré un injectable : Saignements irréguliers"
label variable q534_4 "Problèmes auxquels un client peut faire face après qu'on lui ait administré un injectable : Saignement prolongé pendant les règles"
label variable q534_5 "Problèmes auxquels un client peut faire face après qu'on lui ait administré un injectable : Saignements abondants pendant les règles"
label variable q534_6 "Problèmes auxquels un client peut faire face après qu'on lui ait administré un injectable : Aménorrhée"
label variable q534_7 "Problèmes auxquels un client peut faire face après qu'on lui ait administré un injectable : Prise de poids"
label variable q534_8 "Problèmes auxquels un client peut faire face après qu'on lui ait administré un injectable : Perte blanche"
label variable q534_9 "Problèmes auxquels un client peut faire face après qu'on lui ait administré un injectable :Aucun problème"
label variable q534_96 "Problèmes auxquels un client peut faire face après qu'on lui ait administré un injectable : Autre (Préciser)"
label variable q534_98 "Problèmes auxquels un client peut faire face après qu'on lui ait administré un injectable : Ne sais pas"
label variable q534_other "Autre problème"
label variable q535 "Selon vous, cette méthode est-elle adaptée pour retarder la première naissance ?"
label variable q536 "Selon vous, cette méthode est-elle adaptée au maintien de l'intervalle entre deux naissances ?"
label variable q537 "Selon vous, cette méthode est-elle adaptée pour la limitation des naissances ?"
label variable q538 "Après la première prise de contraceptif injectable, quand la dose suivante doit-elle être administrée ?"
label variable q539 "Selon vous, quels sont les bénéfices d'utiliser des implants ou pourquoi une femme devrait utiliser cette méthode ?"
label variable q539_1 "Selon vous, quels sont les bénéfices d'utiliser des implants ou pourquoi une femme devrait utiliser cette méthode : Efficace et sûr"
label variable q539_2 "Selon vous, quels sont les bénéfices d'utiliser des implants ou pourquoi une femme devrait utiliser cette méthode : Pratique et facile à utiliser"
label variable q539_3 "Selon vous, quels sont les bénéfices d'utiliser des implants ou pourquoi une femme devrait utiliser cette méthode : Ne nécessite pas de dosage quotidien ou mensuel"
label variable q539_4 "Selon vous, quels sont les bénéfices d'utiliser des implants ou pourquoi une femme devrait utiliser cette méthode : Complètement réversible"
label variable q539_5 "Selon vous, quels sont les bénéfices d'utiliser des implants ou pourquoi une femme devrait utiliser cette méthode : Une méthode privée et confidentielle"
label variable q539_6 "Selon vous, quels sont les bénéfices d'utiliser des implants ou pourquoi une femme devrait utiliser cette méthode : N'interfère pas avec les rapports sexuels"
label variable q539_96 "Selon vous, quels sont les bénéfices d'utiliser des implants ou pourquoi une femme devrait utiliser cette méthode : Autre (Préciser)"
label variable q539_98 "Selon vous, quels sont les bénéfices d'utiliser des implants ou pourquoi une femme devrait utiliser cette méthode : Ne sais pas"
label variable q539_other "Autrebénéfice" 
label variable q540 "Quels sont les problèmes auxquels un client peut faire face après qu'on lui ait inséré un implant ?"
label variable q540_1 "Problèmes auxquels un client peut faire face après qu'on lui ait inséré un implant : Menstruations irrégulières"
label variable q540_2 "Problèmes auxquels un client peut faire face après qu'on lui ait inséré un implant : Saignements irréguliers"
label variable q540_3 "Problèmes auxquels un client peut faire face après qu'on lui ait inséré un implant : Saignements prolongés durant les règles"
label variable q540_4 "Problèmes auxquels un client peut faire face après qu'on lui ait inséré un implant : Saignements abondants pendant les règles"
label variable q540_5 "Problèmes auxquels un client peut faire face après qu'on lui ait inséré un implant : Aménorrhée"
label variable q540_6 "Problèmes auxquels un client peut faire face après qu'on lui ait inséré un implant : Douleur abdominale"
label variable q540_7 "Problèmes auxquels un client peut faire face après qu'on lui ait inséré un implant : Changement de poids"
label variable q540_8 "Problèmes auxquels un client peut faire face après qu'on lui ait inséré un implant : Sensibilité des seins"
label variable q540_9 "Problèmes auxquels un client peut faire face après qu'on lui ait inséré un implant : Aucun problème"
label variable q540_96 "Problèmes auxquels un client peut faire face après qu'on lui ait inséré un implant : Autre (Préciser)"
label variable q540_98 "Problèmes auxquels un client peut faire face après qu'on lui ait inséré un implant : Ne sais pas"
label variable q540_other "Autre problème"
label variable q541 "Quelle est la durée de la période d'efficacité des implants dans la prévention de la grossesse ?"
label variable q541_other "Autre durée"
label variable q542 "Savez-vous où les implants doivent être insérés ?"
label variable q542_other " Autre lieu"
label variable q543 "Selon vous, qui peut effectuer la pose d'implants ?"
label variable q543_1 "Selon vous, qui peut effectuer la pose d'implants : Tout médecin"
label variable q543_2 "Selon vous, qui peut effectuer la pose d'implants : Gynécologue"
label variable q543_3 "Selon vous, qui peut effectuer la pose d'implants : Sages-femmes"
label variable q543_4 "Selon vous, qui peut effectuer la pose d'implants : Infirmière formée"
label variable q543_5 "Selon vous, qui peut effectuer la pose d'implants : ASC"
label variable q543_6 "Selon vous, qui peut effectuer la pose d'implants : Matrone"
label variable q543_96 "Selon vous, qui peut effectuer la pose d'implants : Autre (Précisez)"
label variable q543_98 "Selon vous, qui peut effectuer la pose d'implants : Ne sais pas"
label variable q543_other "Autre personne"
label variable q544 "Selon vous, cette méthode est-elle adaptée pour retarder la première naissance ?"
label variable q545 "Selon vous, cette méthode est-elle adaptée au maintien de l'intervalle entre deux naissances ?"
label variable q546 "Selon vous, cette méthode est-elle adaptée pour la limitation des naissances ?"
label variable q547 "Savez-vous que la contraception d'urgence peut être prise peu de temps après un rapport sexuel non protégé ?"
label variable q548 "Quel est le nombre d'heures maximal après un rapport sexuel non protégé, pour qu'une contraception d'urgence (CU) puisse être prise ?"
label variable q549 "Pensez-vous qu'une CU peut avoir été efficace bien que la femme soit tombée enceinte ?"
label variable q550 "Pensez-vous que la CU peut être utilisée comme une méthode de contraception régulière ?"
label variable q551 "Selon vous, cette méthode est-elle adaptée pour retarder la première naissance ?"
label variable q552 "Selon vous, cette méthode est-elle adaptée au maintien de l'intervalle entre deux naissances ?"
label variable q553 "Selon vous, cette méthode est-elle adaptée pour la limitation des naissances ?"
label variable q554 "Selon vous, quels sont les bénéfices d'adopter la sterilisation féminine ou pourquoi une femme devrait utiliser cette méthode ?"
label variable q554_1 "Selon vous, quels sont les bénéfices d'adopter la stérilisation féminine ou pourquoi une femme devrait utiliser cette méthode : Procédure unique"
label variable q554_2 "Selon vous, quels sont les bénéfices d'adopter la stérilisation féminine ou pourquoi une femme devrait utiliser cette méthode : Aucune autre méthode ne sera nécessaire"
label variable q554_3 "Selon vous, quels sont les bénéfices d'adopter la stérilisation féminine ou pourquoi une femme devrait utiliser cette méthode : Définitive (plus d'enfant)"
label variable q554_4 "Selon vous, quels sont les bénéfices d'adopter la stérilisation féminine ou pourquoi une femme devrait utiliser cette méthode : Procédure simple"
label variable q554_5 "Selon vous, quels sont les bénéfices d'adopter la stérilisation féminine ou pourquoi une femme devrait utiliser cette méthode : Facilement disponible"
label variable q554_6 "Selon vous, quels sont les bénéfices d'adopter la stérilisation féminine ou pourquoi une femme devrait utiliser cette méthode : Pas d'avantages"
label variable q554_96 "Selon vous, quels sont les bénéfices d'adopter la stérilisation féminine ou pourquoi une femme devrait utiliser cette méthode : Autres"
label variable q554_98 "Selon vous, quels sont les bénéfices d'adopter la stérilisation féminine ou pourquoi une femme devrait utiliser cette méthode : Ne sais pas"
label variable q554_other "Autre bénéfice"
label variable q555 "Quels sont les problèmes auxquels un client peut faire face pendant ou après une sterilisation feminine, y compris la procedure post-partum / post avortement "
label variable q555_1 "Problèmes auxquels un client peut faire face pendant ou après une stérilisation féminine, y compris la procédure post-partum / post-avortement : Saignement du site chirurgical"
label variable q555_2 "Problèmes auxquels un client peut faire face pendant ou après une stérilisation féminine, y compris la procédure post-partum / post-avortement : Saignement vaginal"
label variable q555_3 "Problèmes auxquels un client peut faire face pendant ou après une stérilisation féminine, y compris la procédure post-partum / post-avortement : Infection"
label variable q555_4 "Problèmes auxquels un client peut faire face pendant ou après une stérilisation féminine, y compris la procédure post-partum / post-avortement : Écoulement de pus de la plaie"
label variable q555_5 "Problèmes auxquels un client peut faire face pendant ou après une stérilisation féminine, y compris la procédure post-partum / post-avortement : Déhiscence de la plaie"
label variable q555_6 "Problèmes auxquels un client peut faire face pendant ou après une stérilisation féminine, y compris la procédure post-partum / post-avortement : Échec de la méthode"
label variable q555_7 "Problèmes auxquels un client peut faire face pendant ou après une stérilisation féminine, y compris la procédure post-partum / post-avortement : Gonflement abdominal"
label variable q555_8 "Problèmes auxquels un client peut faire face pendant ou après une stérilisation féminine, y compris la procédure post-partum / post-avortement : Lésion/perforation intestinale"
label variable q555_9 "Problèmes auxquels un client peut faire face pendant ou après une stérilisation féminine, y compris la procédure post-partum / post-avortement : Lésions de la vessie"
label variable q555_10 "Problèmes auxquels un client peut faire face pendant ou après une stérilisation féminine, y compris la procédure post-partum / post-avortement : Fièvre"
label variable q555_11 "Problèmes auxquels un client peut faire face pendant ou après une stérilisation féminine, y compris la procédure post-partum / post-avortement : Vomissement"
label variable q555_12 "Problèmes auxquels un client peut faire face pendant ou après une stérilisation féminine, y compris la procédure post-partum / post-avortement : Aucun problème"
label variable q555_96 "Problèmes auxquels un client peut faire face pendant ou après une stérilisation féminine, y compris la procédure post-partum / post-avortement : Autre (Préciser)"
label variable q555_98 "Problèmes auxquels un client peut faire face pendant ou après une stérilisation féminine, y compris la procédure post-partum / post-avortement : Ne sais pas"
label variable q555_other "Autre problème"
label variable q556 "Selon vous, cette méthode est-t-elle adaptée pour la limitation des naissances ?"
label variable q557 "Selon vous, quels sont les bénéfices d'adopter la sterilisation masculine ou pourquoi un homme devrait utiliser cette méthode ?"
label variable q557_1 "Selon vous, quels sont les bénéfices d'adopter la stérilisation masculine ou pourquoi un homme devrait utiliser cette méthode: Procédure unique"
label variable q557_2 "Selon vous, quels sont les bénéfices d'adopter la stérilisation masculine ou pourquoi un homme devrait utiliser cette méthode: Aucune autre contraception n'est nécessaire"
label variable q557_3 "Selon vous, quels sont les bénéfices d'adopter la stérilisation masculine ou pourquoi un homme devrait utiliser cette méthode: Plus d'enfants après utilisation"
label variable q557_4 "Selon vous, quels sont les bénéfices d'adopter la stérilisation masculine ou pourquoi un homme devrait utiliser cette méthode: Procédure simple"
label variable q557_5 "Selon vous, quels sont les bénéfices d'adopter la stérilisation masculine ou pourquoi un homme devrait utiliser cette méthode: Facilement disponible"
label variable q557_6 "Selon vous, quels sont les bénéfices d'adopter la stérilisation masculine ou pourquoi un homme devrait utiliser cette méthode: Pas d'avantages"
label variable q557_96 "Selon vous, quels sont les bénéfices d'adopter la stérilisation masculine ou pourquoi un homme devrait utiliser cette méthode: Autre (Précisez)"
label variable q557_98 "Selon vous, quels sont les bénéfices d'adopter la stérilisation masculine ou pourquoi un homme devrait utiliser cette méthode: Ne sais pas"
label variable q557_other "Autre bénéfice" 
label variable q558 "Quels sont les problèmes auxquels un client peut faire face pendant ou après une stérilisation masculine"
label variable q558_1 "Problèmes auxquels un client peut faire face pendant ou après une stérilisation masculine: Réduit le plaisir sexuel"
label variable q558_2 "Problèmes auxquels un client peut faire face pendant ou après une stérilisation masculine: Réduit la capacité de travail"
label variable q558_3 "Problèmes auxquels un client peut faire face pendant ou après une stérilisation masculine: Échec de la méthode"
label variable q558_4 "Problèmes auxquels un client peut faire face pendant ou après une stérilisation masculine: Faiblesse"
label variable q558_5 "Problèmes auxquels un client peut faire face pendant ou après une stérilisation masculine: Gain de poids"
label variable q558_6 "Problèmes auxquels un client peut faire face pendant ou après une stérilisation masculine: Gastrite/acidité"
label variable q558_7 "Problèmes auxquels un client peut faire face pendant ou après une stérilisation masculine: Ballonnements"
label variable q558_8 "Problèmes auxquels un client peut faire face pendant ou après une stérilisation masculine: Aucun problème"
label variable q558_96 "Problèmes auxquels un client peut faire face pendant ou après une stérilisation masculine: Autre"
label variable q558_98 "Problèmes auxquels un client peut faire face pendant ou après une stérilisation masculine: Ne sais pas"
label variable q558_other "Autre problème"
label variable q559 "Selon vous, cette méthode est-t-elle adaptée pour la limitation des naissances ?"
label variable q560 "Selon vous, pourquoi est-il important pour les femmes et les couples d'utiliser des méthodes de contraception ?"
label variable q560_1 "Selon vous, pourquoi est-il important pour les femmes et les couples d'utiliser des méthodes de contraception: Limiter la taille des familles"
label variable q560_2 "Selon vous, pourquoi est-il important pour les femmes et les couples d'utiliser des méthodes de contraception: Espacer les naissances"
label variable q560_3 "Selon vous, pourquoi est-il important pour les femmes et les couples d'utiliser des méthodes de contraception: Prévenir les grossesses non désirées"
label variable q560_4 "Selon vous, pourquoi est-il important pour les femmes et les couples d'utiliser des méthodes de contraception: Prévenir les avortements"
label variable q560_5 "Selon vous, pourquoi est-il important pour les femmes et les couples d'utiliser des méthodes de contraception: Diminution du risque de décès maternels"
label variable q560_6 "Selon vous, pourquoi est-il important pour les femmes et les couples d'utiliser des méthodes de contraception: Diminution du risque de décès néonatals"
label variable q560_7 "Selon vous, pourquoi est-il important pour les femmes et les couples d'utiliser des méthodes de contraception: Diminution du risque d'accouchement prématuré"
label variable q560_8 "Selon vous, pourquoi est-il important pour les femmes et les couples d'utiliser des méthodes de contraception: Risque réduit de faible poids à la naissance"
label variable q560_9 "Selon vous, pourquoi est-il important pour les femmes et les couples d'utiliser des méthodes de contraception: Risque plus faible d'avoir un enfant de petite taille pour l'âge gestationnel"
label variable q560_10 "Selon vous, pourquoi est-il important pour les femmes et les couples d'utiliser des méthodes de contraception: Avantages financiers"
label variable q560_11 "Selon vous, pourquoi est-il important pour les femmes et les couples d'utiliser des méthodes de contraception: Mieux élever les enfants"
label variable q560_12 "Selon vous, pourquoi est-il important pour les femmes et les couples d'utiliser des méthodes de contraception: Garantir les droits reproductifs des femmes"
label variable q560_96 "Selon vous, pourquoi est-il important pour les femmes et les couples d'utiliser des méthodes de contraception: Autres (Préciser)"
label variable q560_other "Autre importance"
label variable q561a "Il est important de parler des méthodes de contraception, quel que soit le sexe. "
label variable q561b "Les informations sur la planification familiale ne devraient être données qu'aux personnes qui en font explicitement la demande."
label variable q561c "Des conseils en matière de PF devraient être fournis aux garçons et aux filles non mariées. "
label variable q561d "L'utilisation de méthodes contraceptives est importante pour les femmes / hommes en âge de procréer."
label variable q561e "Les connaissances en matière de planification familiale augmenteront les relations sexuelles pré-maritales."
label variable q561f "Les contraceptifs affectent le désir sexuel du partenaire."
label variable q561g "Les méthodes contraceptives ont un impact négatif sur la pratique de la religion. "
label variable q561h "Les contraceptifs affectent les activités quotidiennes des femmes."
label variable q561i "L'éducation à la planification familiale devrait être incluse dans le programme des établissements d'enseignement."
label variable q562 "Si une femme / un homme / un couple vient dans votre pharmacie /  dépôt de médicaments pour des services de PF, les informez-vous de toutes les méthodes appropriées disponibles dans le panier de leur choix ?"
label variable q563 "Selon vous, qui devrait être conseillé en matière de planification familiale ?"
label variable q563_1 "Selon vous, qui devrait être conseillé en matière de planification familiale: Toutes les femmes en âge de procréer"
label variable q563_2 "Selon vous, qui devrait être conseillé en matière de planification familiale: Tous les hommes sexuellement actifs"
label variable q563_3 "Selon vous, qui devrait être conseillé en matière de planification familiale: Garçons adolescents"
label variable q563_4 "Selon vous, qui devrait être conseillé en matière de planification familiale: Femmes enceintes venues pour des soins prénatals"
label variable q563_5 "Selon vous, qui devrait être conseillé en matière de planification familiale: Femme venue pour un avortement"
label variable q563_6 "Selon vous, qui devrait être conseillé en matière de planification familiale: Femme venue accoucher"
label variable q563_7 "Selon vous, qui devrait être conseillé en matière de planification familiale: Femme en post-partum pendant son séjour dans l'établissement"
label variable q563_8 "Selon vous, qui devrait être conseillé en matière de planification familiale: Femme venue faire vacciner son enfant"
label variable q563_9 "Selon vous, qui devrait être conseillé en matière de planification familiale: Femme ayant 2 enfants ou plus"
label variable q563_10 "Selon vous, qui devrait être conseillé en matière de planification familiale: Femme ayant une grossesse à haut risque (HRP)"
label variable q563_11 "Selon vous, qui devrait être conseillé en matière de planification familiale: Femme anémique en période prénatale et post-partum"
label variable q563_12 "Selon vous, qui devrait être conseillé en matière de planification familiale: Ne fournit pas de conseils"
label variable q563_96 "Selon vous, qui devrait être conseillé en matière de planification familiale: Autres"
label variable q563_other "Autre personne"
label variable q564 "Avant de vendre les pilules  / CU, quel conseil donnez-vous généralement au client ?"
label variable q564_1 "Avant de vendre les pilules / CU, quel conseil donnez-vous généralement au client: Dosage"
label variable q564_2 "Avant de vendre les pilules / CU, quel conseil donnez-vous généralement au client: Conseils en cas d'oubli du dosage des pilules"
label variable q564_3 "Avant de vendre les pilules / CU, quel conseil donnez-vous généralement au client: Conseils sur ce qu'il faut attendre après la prise des pilules"
label variable q564_4 "Avant de vendre les pilules / CU, quel conseil donnez-vous généralement au client: Rien"
label variable q564_96 "Avant de vendre les pilules / CU, quel conseil donnez-vous généralement au client: Autre (préciser)"
label variable q564_other "Autre conseil"
label variable q565 "Avant de vendre les injectables / implants, quels conseils donnez-vous généralement au client ?"
label variable q565_1 "Avant de vendre les injectables / implants, quels conseils donnez-vous généralement au client : Quand le faire administrer/insérer"
label variable q565_2 "Avant de vendre les injectables / implants, quels conseils donnez-vous généralement au client : Où l'administrer/insérer"
label variable q565_3 "Avant de vendre les injectables / implants, quels conseils donnez-vous généralement au client : Durée d'efficacité"
label variable q565_4 "Avant de vendre les injectables / implants, quels conseils donnez-vous généralement au client : À quoi s'attendre après avoir reçu l'injectable/implant"
label variable q565_5 "Avant de vendre les injectables / implants, quels conseils donnez-vous généralement au client : Rien"
label variable q565_96 "Avant de vendre les injectables / implants, quels conseils donnez-vous généralement au client : Autre"
label variable q565_other "Autre conseil"
label variable q566 "Conseillez-vous les clients sur les effets secondaires associés aux contraceptifs ?"
label variable q567 "Quels sont les obstacles auxquels vous êtes confronté(e) lorsque vous fournissez des services de conseil en matière de planification familiale ?"
label variable q567_1 "Obstacles auxquels vous êtes confronté(e) lorsque vous fournissez des services de conseil en matière de planification familiale : Le client hésite à parler"
label variable q567_2 "Obstacles auxquels vous êtes confronté(e) lorsque vous fournissez des services de conseil en matière de planification familiale : La cliente hésite à parler devant d'autres clients"
label variable q567_3 "Obstacles auxquels vous êtes confronté(e) lorsque vous fournissez des services de conseil en matière de planification familiale : Le client n'aime pas utiliser de méthodes contraceptives"
label variable q567_4 "Obstacles auxquels vous êtes confronté(e) lorsque vous fournissez des services de conseil en matière de planification familiale : Le/la client(e) tient son/sa partenaire pour responsable de la décision d'utiliser un moyen de contraception"
label variable q567_5 "Obstacles auxquels vous êtes confronté(e) lorsque vous fournissez des services de conseil en matière de planification familiale : Rien"
label variable q567_96 "Obstacles auxquels vous êtes confronté(e) lorsque vous fournissez des services de conseil en matière de planification familiale : Autre (préciser)" 
label variable q567_other "Autre obstacle"
label variable q568 "Indiquez-vous à la cliente où se rendre en cas de complications après l'utilisation des contraceptifs ?"
label variable q569 "Où leur conseillez-vous de se rendre s'ils présentent des complications après avoir consommé des pilules / CU ?"
label variable q569_1 "Où leur conseillez-vous de se rendre s'ils présentent des complications après avoir consommé des pilules / CU : Revenez à nous"
label variable q569_2 "Où leur conseillez-vous de se rendre s'ils présentent des complications après avoir consommé des pilules / CU : Consulter à l'hôpital"
label variable q569_3 "Où leur conseillez-vous de se rendre s'ils présentent des complications après avoir consommé des pilules / CU : Consulter au centre de santé"
label variable q569_4 "Où leur conseillez-vous de se rendre s'ils présentent des complications après avoir consommé des pilules / CU : Consulter au poste de santé"
label variable q569_5 "Où leur conseillez-vous de se rendre s'ils présentent des complications après avoir consommé des pilules / CU : Consulter le Médecin privé/établissement de santé le plus proche"
label variable q569_96 "Où leur conseillez-vous de se rendre s'ils présentent des complications après avoir consommé des pilules / CU : Autre (préciser)"
label variable q569_other "Autre lieu"
label variable q570 "Où leur conseillez-vous de se rendre en cas de complications après l'administration d'un produit injectable ou d'un implant ?"
label variable q570_1 "Où leur conseillez-vous de se rendre en cas de complications après l'administration d'un produit injectable ou d'un implant : Revenez à nous"
label variable q570_2 "Où leur conseillez-vous de se rendre en cas de complications après l'administration d'un produit injectable ou d'un implant : Consulter à l'hôpital"
label variable q570_3 "Où leur conseillez-vous de se rendre en cas de complications après l'administration d'un produit injectable ou d'un implant : Consulter au centre de santé"
label variable q570_4 "Où leur conseillez-vous de se rendre en cas de complications après l'administration d'un produit injectable ou d'un implant : Consulter au poste de santé"
label variable q570_5 "Où leur conseillez-vous de se rendre en cas de complications après l'administration d'un produit injectable ou d'un implant : Consulter le Médecin privé/établissement de santé le plus proche"
label variable q570_96 "Où leur conseillez-vous de se rendre en cas de complications après l'administration d'un produit injectable ou d'un implant : Autre (préciser)"
label variable q570_other "Autre lieu "


**Correction des anomalies

replace q222=2 if q223==0
replace q225=2 if q226==0
replace q227=2 if q228==0
replace q314=4 if q314_other=="Les orienter vers le poste de santé" | q314_other=="Orientation" 
replace q335=4 if q335other=="Les orienter vers le poste de santé"
replace q403=998 if q403==9998
replace q403=999 if q403==1000
replace q512_3=1 if q512_other=="Pas de protection contre les IST"
replace q513_10=1 if q513_other=="Une femme qui a subi la césarienne"
replace q513_5=1 if q513_other=="Pathologie qui atteint l'utérus" | q513_other=="Cancer col de l'utérus" | q513_other=="En cas de pathologies au niveau du col"
replace q518_1=1 if q518_other=="Médecin" | q518_other=="Médecin formé"
replace q519_2=1 if q519_other=="Toucher"
replace q521_4=1 if q521_other=="Oubli, acnée,maux de tête"
replace q521_9=1 if q521_other=="Prise de poidsRetard de regles"
replace q521_6=1 if q521_other=="Prise de poidsRetard de regles" | q521_other=="Irrégularités du cycle"
replace q521_4=1 if q521_other=="Sêfale"
replace q522_5=1 if q522_other=="Hypotension et hypertendu"
replace q525=1 if q525_other=="Avant un rapport sexuel" | q525_other=="Pendant les rapports"
replace q527_4=1 if q527_other=="Gratuit au niveau du poste" | q527_other=="Gratuité" 
replace q527_2=1 if q527_other=="Prévention des IST"
replace q527_1=1 if q527_other=="Grossesse non desiree"
replace q528_3=1 if q528_other=="Déchirure" | q528_other=="Déchirure du préservatif" | q528_other=="Détérioration Lors du rapport sexuel" | q528_other=="La qualité" | q528_other=="La taille" | q528_other=="Le préservatif peut se déchirer" | q528_other=="Que ça se fissure" | q528_other=="Rupture" | q528_other=="Rupture de préservatif" | q528_other=="Ne sait pas l utiliser, peut se déchirer"
replace q528_2=1 if q528_other=="Irritation"
replace q533_98=1 if q533_other=="Aucun"
replace q539_2=1 if q539_other=="Moin gênant"
replace q539_1=1 if q539_other=="Sa longue durée" | q539_other=="Durée d'action" | q539_other=="Moins d'effets secondaires"
replace q540_98=1 if q540_other=="Ne sait pas"
replace q542=1 if q542_other=="Au niveau du bras"
replace q569_5=1 if q569_other=="Au niveau du district le plus pret" | q569_other=="Structure sanitaire la plus proche"


*Définition des étiquettes

* Définir les étiquettes pour chaque type de variable

label define region_lab 1 "DAKAR" 2 "DIOURBEL" 3 "FATICK" 4 "KAFFRINE" 5 "KAOLACK" 6 "KEDOUGOU" 7 "KOLDA" 8 "LOUGA" 9 "MATAM" 10 "SAINT-LOUIS" 11 "SEDHIOU" 12 "TAMBACOUNDA" 13 "THIES" 14 "ZIGUINCHOR"

label define yesno 1 "Oui" 2 "Non"

label define sex 1 "Masculin (M)" 2 "Féminin (F)"

label define education 1 "CFEE" 2 "BFEM" 3 "Baccalauréat" 4 "Licence" 5 "Master" 6 "Doctorat" 96 "Autres"

replace q202 = 96 if q202 == 3
label define role 1 "Pharmacien" 2 "Vendeur" 96 "Autre (Préciser)"

label define lieu_type 1 "Rural" 2 "Urbain"

label define inject 1 "Injectables" 2 "Implants" 3 "Les deux" 4 "Aucune de ces méthodes"

label define stockout 1 "Moins d'un mois" 2 "1-3 mois" 3 "4-6 mois" 4 "Plus de 6 mois"

label define stockout_3 1 "Jamais" 2 "Rarement (moins d'une fois par mois)" 3 "Parfois (2 - 3 fois par mois)" 4 "Souvent (plus de 3 fois par mois)"

label define stockout_action 1 "Demander au client de revenir plus tard" 2 "S’arranger quelque part et lui fournir" 3 "Renvoyer le client dans une autre officine" 4 "Renvoyer le client dans un établissement public" 5 "Proposé et vendu une autre méthode" 6 "Renvoyer simplement le client" 96 "Autres (Préciser)"

label define fp_methods 1 "DUI" 2 "Injectables" 3 "Préservatifs (Masculin)" 4 "Préservatifs (Féminin)" 5 "Contraception d’urgence" 6 "Pilules" 7 "Implants" 8 "Stérilisation féminine" 9 "Stérilisation masculine" 10 "Allaitement maternel exclusif"

label define contraceptives 1 "Selon l’objectif (espacement/limitation)" 2 "Selon le choix (hormonal/non-hormonal)" 3 "Selon le nombre d’enfants qu’ils ont déjà" 4 "Selon le pouvoir d’achat" 5 "Selon la disponibilité de stock" 96 "Autres (Précisez)" 98 "Ne sais pas"

label define customer 1 "Hommes <=20 ans (adolesents et jeunes)" 2 "Hommes >20 ans (adultes)" 3 "Femmes <=20 ans (adolesents et jeunes)" 4 "Femmes >20 ans (adultes)" 5 "Ne vend pas le produit"

label define customer2 1 "Hommes <=20 ans (adolesents et jeunes)" 2 "Hommes >20 ans (adultes)" 3 "Femmes <=20 ans (adolesents et jeunes)" 4 "Femmes >20 ans (adultes)" 5 "Aucun"

label define pill_decision 1 "Les clients viennent pour une marque particulière" 2 "Choix selon le pouvoir d’achat" 3 "Choix selon l’âge de gestation" 4 "Choix selon de l’âge de la femme" 5 "Choix selon le contenu du stock" 96 "Autres (Précisez)"

label define age_benefits 1 "Risque réduit de complications de la grossesse" 2 "Risque réduit d’avortement provoqué" 3 "Risque réduit de fausse couche" 4 "Meilleur état nutritionnel" 5 "Risque réduit d’anémie" 6 "Meilleure santé physique" 7 "Meilleure santé mentale" 96 "Autre (Précisez)" 98 "Ne sais pas"

label define spacing_benefits 1 "Risque réduit de complications de la grossesse" 2 "Risque réduit de décès maternel" 3 "Risque réduit d’avortement provoqué" 4 "Risque réduit de fausse couche" 5 "Risque réduit d’anémie" 6 "Permet deux années d’allaitement comme recommandées" 96 "Autre (Précisez)" 98 "Ne sais pas"

label define spacing_benefits_child 1 "Risque réduit de décès néonatal" 2 "Meilleure croissance" 3 "Meilleur état nutritionnel" 4 "Diminution de l’incidence de l’anémie" 5 "Meilleure chance de survie" 6 "Meilleure attention de la part de la mère" 7 "Risque réduit de décès néonatal" 96 "Autre (Précisez)" 98 "Ne sais pas"

label define advantage_waiting 1 "Risque réduit de complications de la grossesse" 2 "Risque réduit de décès maternels" 3 "Diminution du risque de fausses couches" 4 "Risque réduit d’anémie (faiblesse)" 96 "Autre (Précisez)" 98 "Ne sait pas"

label define true_false 1 "Vraie" 2 "Fausse" 98 "Ne sais pas"

label define incitation 1 "Oui après incitation" 2 "Non après incitation"

label define preg_likely 1 "7 jours avant le début des règles" 2 "Jusqu’à 7 jours après le début des règles" 3 "Du 8e au 20e jour après la menstruation" 98 "Ne sais pas"

label define iud_advantage 1 "C’est efficace" 2 "C’est réversible" 3 "C’est immédiatement reversible sans retard dans le retour à la fertilité" 4 "Seul le suivi initial est nécessaire" 5 "N’interfère pas avec les rapports sexuels" 6 "Pas d’effets sur la production de lait maternel" 7 "Il n’est pas necessaire d’acheter des fournitures" 8 "Peut servir de méthode contraceptive d’urgence lorsqu’il est inséré dans les cinq jours suivant un rapport sexuel non protégé" 9 "C’est une méthode à long terme (5/10 ans)" 10 "Peut être utilisé comme méthode de limitation" 11 "Risque d'effets secondaires plus faible que les autres méthodes réversibles" 96 "Autre (Précisez)"

label define dui_problem 1 "Faiblesse" 2 "Echec de la méthode (grossesse)" 3 "Augmentation du risque d’infection" 4 "Réduction des sensations/ plaisir des rapports sexuels" 5 "Gene lors des rapports sexuels" 6 "Malformations génitales chez le futur bébé" 7 "Infertilité" 8 "Saignements excessifs" 9 "Douleurs abdominales" 96 "Autre (Préciser)" 10 "Ne cause aucun problème" 98 "Ne sais pas"

label define no_dui 1 "Femme n’étant jamais tombé enceinte" 2 "Femme très anémiée" 3 "Femme avec des risques d’obtenir des IST" 4 "Infections dans les trompes" 5 "Infections utérines" 6 "Infection après avoir donné naissance" 7 "Grossesse tubaire en cours" 8 "Femmes qui se plaignent de saignements et de douleurs pendant les règles" 9 "Femmes ayant beaucoup d’enfants" 10 "Femme ayant bénéficié d’une césarienne" 96 "Autre (Précisez)" 98 "Ne sais pas"

label define yes_no2 1 "Oui" 2 "Non" 98 "Ne sais pas"

label define dui_insertion 1 "Dans les 12 premiers jours du cycle menstruel" 2 "Dans les 48 heures suivant l'accouchement" 3 "Après six semaines suivant l'accouchement" 4 "Dans les 12 jours suivant une interruption de grossesse" 96 "Autre (Précisez)" 98 "Ne sais pas"

label define dui_insertor 1 "Tout médecin" 2 "Gynécologue" 3 "Sages-femmes" 4 "Infirmière formée" 5 "ASC" 6 "Matrone" 96 "Autre (Précisez)" 98 "Ne sais pas"

label define dui_check 1 "Se laver les mains" 2 "S’accroupir et palper le fil avec ses doigts" 3 "Retirer le doigt et se laver les mains à nouveau" 96 "Autre (Précisez)" 98 "Ne sais pas"

label define pill_days 1 "Chaque jour" 2 "Chaque semaine" 3 "Les deux" 98 "Ne sais pas"

label define pill_effects 1 "Réduction de la production de lait" 2 "Réduction de la capacité de travail" 3 "Nausées" 4 "Maux de tête" 5 "Gonflement des jambes" 6 "Changements durant les règles" 7 "Faiblesse" 8 "Ballonnement/acidité" 9 "Prise de poids" 10 "Perte de poids" 11 "Aucun problème" 96 "Autre (Précisez)" 98 "Ne sais pas"

label define no_pill 1 "Femme avec jaunisse" 2 "Femme ayant eu un accident vasculaire cérébral" 3 "Femme paralysée" 4 "Femme souffrant d’une maladie cardiaque" 5 "Femme souffrant d’une hypertension artérielle" 96 "Autre (Préciser)" 98 "Ne sais pas"

label define pill_start 1 "Premier jour du cycle menstruel" 2 "Dans les cinq jours suivant le début du cycle menstruel" 3 "Dernier jour du cycle menstruel" 4 "À tout moment" 96 "Autre (Précisez)" 98 "Ne sais pas"

label define condom_use 1 "À chaque rapport sexuel" 96 "Autre réponse" 98 "Ne sais pas"

label define condom_times 1 "Une fois" 2 "Deux fois" 3 "Plus de deux fois" 98 "Ne sais pas"

label define condom_adv 1 "Prévenir la grossesse" 2 "Sécurité contre les infections sexuelles" 3 "Prévenir le VIH" 4 "Facilement disponible" 5 "Méthode la moins chère" 6 "Facile à utiliser" 96 "Autre (Préciser)" 98 "Ne sais pas"

label define condom_problem 1 "Réduction du plaisir sexuel" 2 "Allergie" 3 "Échec de la méthode" 4 "Affectent les règles" 5 "Problème d’élimination de l’utilisation des préservatifs" 96 "Autre (Précisez)" 6 "Aucun problème" 98 "Ne sais pas"

label define injectable_start 1 "Dans les sept premiers jours du cycle menstruel" 2 "Dans les sept premiers jours suivant l’avortement" 3 "Après six semaines d’accouchement (si elle allaite)" 4 "Immédiatement après l’accouchement (si elle n’allaite pas)" 96 "Autre (Préciser)" 98 "Ne sais pas"

label define injectable_adv 1 "Très efficace et sûr" 2 "Pratique et facile à utiliser" 3 "Agit pendant 3 mois avec un délai de grâce d’un mois" 4 "Complètement réversible" 5 "Méthode privée et confidentielle" 6 "N’interfère pas avec les rapports sexuels" 7 "Convient aux femmes qui allaitent" 8 "Utile pour le post-partum immédiat (chez les femmes qui n’allaitent pas)" 9 "Utilisable après l’avortement" 10 "Utilisable à tout âge" 11 "Utilisable pour les femmes de parité faible" 12 "Réduit les crampes menstruelles" 13 "Réduit le risque du cancer de l’ovaire et de l’utérus" 96 "Autre (Précisez)" 98 "Ne sais pas"

label define injectable_problem 1 "Maux de tête" 2 "Menstrues irrégulières" 3 "Saignements irréguliers" 4 "Saignement prolongé pendant les règles" 5 "Saignements abondants pendant les règles" 6 "Aménorrhée" 7 "Prise de poids" 8 "Perte blanche" 96 "Autre (Préciser)" 9 "Aucun problème" 98 "Ne sais pas"

label define implant_adv 1 "Efficace et sûr" 2 "Pratique et facile à utiliser" 3 "Ne necessite pas de dosage quotidien ou mensuel" 4 "Complètement réversible" 5 "Une méthode privée et confidentielle" 6 "N’interfère pas avec les rapports sexuels" 96 "Autre (Préciser)" 98 "Ne sais pas"

label define implant_problem 1 "Menstruations irrégulières" 2 "Saignements irréguliers" 3 "Saignements prolongés durant les règles" 4 "Saignements abondants pendant les règles" 5 "Aménorrhée" 6 "Douleur abdominale" 7 "Changement de poids" 8 "Sensibilité des seins" 96 "Autre (Préciser)" 9 "Aucun problème" 98 "Ne sais pas"

label define implant_period 1 "3-5 ans" 96 "Autres réponses" 98 "Ne sais pas"

label define implant_position 1 "Partie supérieure du bras" 96 "Autres réponses" 98 "Ne sais pas"

label define implant_insertor 1 "Tout médecin" 2 "Gynécologue" 3 "Sages-femmes" 4 "Infirmière formée" 5 "ASC" 6 "Matrone" 96 "Autre (Précisez)" 98 "Ne sais pas"

label define f_sterile_benefit 1 "Procédure unique" 2 "Aucune autre méthode ne sera nécessaire" 3 "Définitive (plus d’enfant)" 4 "Procédure simple" 5 "Facilement disponible" 96 "Autre (Préciser)" 6 "Pas d’avantages" 98 "Ne sais pas"

label define f_sterile_problem 1 "Saignement du site chirurgical" 2 "Saignement vaginal" 3 "Infection" 4 "Écoulement de pus de la plaie" 5 "Déhiscence de la plaie" 6 "Échec de la méthode" 7 "Gonflement abdominal" 8 "Lésion/perforation intestinale" 9 "Lésions de la vessie" 10 "Fièvre" 11 "Vomissement" 96 "Autre (Préciser)" 12 "Aucun problème" 98 "Ne sais pas"

label define m_sterile_benefit 1 "Procédure unique" 2 "Aucune autre contraception n’est nécessaire" 3 "Plus d’enfants après utilisation" 4 "Procédure simple" 5 "Facilement disponible" 96 "Autre (Précisez)" 6 "Pas d’avantages" 98 "Ne sais pas"

label define m_sterile_problem 1 "Réduit le plaisir sexuel" 2 "Réduit la capacité de travail" 3 "Échec de la méthode" 4 "Faiblesse" 5 "Gain de poids" 6 "Gastrite/acidité" 7 "Ballonnements" 96 "Autre (Préciser)" 8 "Aucun problème" 98 "Ne sais pas"

label define fp_importance 1 "Limiter la taille des familles" 2 "Espacer les naissances" 3 "Prévenir les grossesses non désirées" 4 "Prévenir les avortements" 5 "Diminution du risque de décès maternels" 6 "Diminution du risque de décès néonatals" 7 "Diminution du risque d’accouchement prématuré" 8 "Risque réduit de faible poids à la naissance" 9 "Risque plus faible d’avoir un enfant de petite taille pour l’âge gestationnel" 10 "Avantages financiers" 11 "Mieux élever les enfants" 12 "Garantir les droits reproductifs des femmes" 96 "Autres (Préciser)"

label define fp_opinion 1 "Pas du tout d’accord" 2 "Pas d’accord" 3 "Neutre" 4 "D’accord" 5 "Tout à fait d’accord"

label define fp_counseling 1 "Toutes les femmes en âge de procréer" 2 "Tous les hommes sexuellement actifs" 3 "Garçons adolescents" 4 "Femmes enceintes venues pour des soins prénatals" 5 "Femme venue pour un avortement" 6 "Femme venue accoucher" 7 "Femme en post-partum pendant son séjour dans l'établissement" 8 "Femme venue faire vacciner son enfant" 9 "Femme ayant 2 enfants ou plus" 10 "Femme ayant une grossesse à haut risque (HRP)" 11 "Femme anémique en période prénatale et post-partum" 96 "Autres (préciser)" 12 "Ne fournit pas de conseils"

label define pills_advice 1 "Dosage" 2 "Conseils en cas d'oubli du dosage des pilules" 4 "Conseils sur ce qu'il faut attendre après la prise des pilules" 96 "Autre (préciser)" 5 "Rien"

label define inject_advice 1 "Quand le faire administrer/insérer" 2 "Où l'administrer/insérer" 3 "Durée d'efficacité" 4 "À quoi s'attendre après avoir reçu l'injectable/implant" 96 "Autre (préciser)" 5 "Rien"

label define fpcounseling_challenges 1 "Le client hésite à parler" 2 "La cliente hésite à parler devant d'autres clients" 3 "Le client n'aime pas utiliser de méthodes contraceptives" 4 "Le/la client(e) tient son/sa partenaire pour responsable de la décision d'utiliser un moyen de contraception" 96 "Autres (préciser)" 5 "Rien"

label define pills_followup 1 "Revenez à nous" 2 "Consulter à l'hôpital" 3 "Consulter au centre de santé" 4 "Consulter au poste de santé" 5 "Consulter le Médecin privé/établissement de santé le plus proche" 96 "Autre (préciser)"

label define injectable_followup 1 "Revenez à nous" 2 "Consulter à l'hôpital" 3 "Consulter au centre de santé" 4 "Consulter au poste de santé" 5 "Consulter le Médecin privé/établissement de santé le plus proche" 96 "Autre (préciser)"


*Définition d'une boucle permettant de labélisées les modalités des variables ayant OUI ou NON comme modalités

*Imputation des valeurs manquantes

foreach var of varlist _all {
    * Vérifier si la variable est numérique
    capture confirm numeric variable `var'
    if !_rc {
        * Remplacer les valeurs manquantes par 99 pour les variables numériques
        replace `var' = -9 if missing(`var')
    }
    * Sinon, vérifier si la variable est textuelle
    else {
        * Remplacer les valeurs manquantes par "99" pour les variables textuelles
        replace `var' = "-9" if missing(`var')
    }
}


* ------------------------------------------------------------------------------
* LABÉLISATION DES VARIABLES EN FONCTION DES MODALITÉS
* ------------------------------------------------------------------------------

local variables q201 q203 q211 q212 q214a q214b q216 q217 q218 q222 q225 q227 ///
               q301 q304 q308 q311 q315 q318 q322 q325 q329 q332 q336 q339 q343 q346 ///
               q405 q406 q409 q514 q515 q516 q523 q529 q530 q531 q535 q536 ///
               q537 q544 q545 q546 q547 q549 q550 q551 q552 q553 q556 q559 q562 q566 q568

* Boucle pour appliquer le label à chaque variable présentant Oui/Non comme modalités
foreach var of local variables {
    * Vérifier si la variable est de type string
    capture confirm string variable `var'
    if _rc == 0 {  // Si la variable est de type string
        * Transformer la variable en numérique
        destring `var', replace
        display "La variable `var' a été transformée en numérique."
    }
    
    * Appliquer le label si la variable est maintenant numérique
    capture confirm numeric variable `var'
    if _rc == 0 {  // Si la variable est numérique
        label values `var' yesno
    }
    else {  // Si la variable ne peut pas être transformée en numérique
        display "La variable `var' ne peut pas être transformée en numérique."
    }
}
label values region region_lab


* Variable de type `sex` (Sexe du répondant)
label values q205 sex

* Variable de type `education` (Niveau d'éducation)
label values q206 education

* Variable de type `role` (Rôle dans la pharmacie)
label values q202 role

* Variable de type `lieu_type` (Type de lieu)
label values lieu_type lieu_type

* Variable de type `inject` (Injectables/Implants)
label values q224 inject

* Variables de type `stockout` (Durée de rupture de stock)
local stockout_vars q305 q312 q319 q326 q333 q340 q347 q410
foreach var of local stockout_vars {
    label values `var' stockout
}

* Variables de type `stockout_3` (Fréquence de rupture de stock)
local stockout_3_vars q306 q313 q320 q327 q334 q341 q348 q411
foreach var of local stockout_3_vars {
    label values `var' stockout_3
}

* Variables de type `stockout_action` (Actions en cas de rupture de stock)
local stockout_action_vars q307 q314 q321 q328 q335 q342 q349 q412
foreach var of local stockout_action_vars {
    label values `var' stockout_action
}


* Variable de type `true_false` (Vrai/Faux)
label values q508 true_false

* Variable de type `preg_likely` (Jours les plus propices à la grossesse)
label values q509 preg_likely

* Variables de type `yes_no2` (Oui/Non avec "Ne sais pas")
local yes_no2_vars q514 q515 q516 q523 q529 q530 q531 q535 q536 q537 q544 q545 q546 q551 q552 q553 q556 q559
foreach var of local yes_no2_vars {
    label values `var' yes_no2
}


* Variable de type `pill_days` (Fréquence d'utilisation des pilules)
label values q520 pill_days

* Variable de type `pill_start` (Début de la prise de pilules)
label values q524 pill_start

* Variable de type `condom_use` (Utilisation des préservatifs)
label values q525 condom_use

* Variable de type `condom_times` (Nombre d'utilisations des préservatifs)
label values q526 condom_times

* Variable de type `implant_period` (Durée d'efficacité des implants)
label values q541 implant_period

* Variable de type `implant_position` (Position des implants)
label values q542 implant_position


* Variables de type `fp_opinion` (Opinions sur la planification familiale)
local fp_opinion_vars q561a q561b q561c q561d q561e q561f q561g q561h q561i
foreach var of local fp_opinion_vars {
    label values `var' fp_opinion
}

* Labélisation des variables binaires pour chaque select_multiple


* Liste des variables select_multiple et leurs modalités
local select_multiple_vars "q220a 6 q220b 6 q220c 6 q220d 6 q220e 6 q220f 6 q220g 6 q220h 6 q220i 6 q220j 6"
local select_multiple_vars "`select_multiple_vars' q401 10 q402 5"
local select_multiple_vars "`select_multiple_vars' q404a 5 q404b 5 q404c 5 q404d 5 q404e 5 q404f 5 q404g 5 q404h 5 q404i 5 q404j 5"
local select_multiple_vars "`select_multiple_vars' q414 5 q415 5 q502 7 q504 6 q505 7 q507 4"
local select_multiple_vars "`select_multiple_vars' q511 11 q512 10 q513 10 q517 4 q518 6 q519 3 q521 11 q522 5"
local select_multiple_vars "`select_multiple_vars' q527 6 q528 6 q532 4 q533 13 q534 9 q539 6 q540 9 q543 6"
local select_multiple_vars "`select_multiple_vars' q554 6 q555 12 q557 6 q558 8 q560 12 q563 12 q564 4 q565 5 q567 5 q569 5 q570 5 q610 12"

* Boucle pour labéliser toutes les variables select_multiple
local i = 1
while `i' <= wordcount("`select_multiple_vars'") {
    * Extraire le nom de la variable et le nombre de modalités
    local var : word `i' of `select_multiple_vars'
    local nb_modalites : word `=`i'+1' of `select_multiple_vars'

    * Vérifier si on a bien extrait une variable et un nombre de modalités
    if "`nb_modalites'" == "" {
        display as error "Problème avec la variable `var'. Vérifiez la liste."
        continue
    }

    * Labéliser les variables binaires
    forvalues j = 1/`nb_modalites' {
        * Vérifier si la variable binaire existe
        capture confirm variable `var'_`j'
        if !_rc {
            label define `var'_`j'_label 1 "Oui" 0 "Non", replace
            label values `var'_`j' `var'_`j'_label
        }
        else {
            display as error "La variable `var'_`j' n'existe pas."
        }
    }

    * Passer à la prochaine variable
    local i = `i' + 2
}

* Définir un label pour les modalités 0 et 1
label define oui_non 0 "Non" 1 "Oui"

foreach var of varlist q402_96 q402_98 q414_96 q502_96 q502_98 q504_96 q504_98 q505_96 q505_98 q507_96 q507_98 q511_96 q512_98 q512_96 q513_96 q513_98 q517_96 q517_98 q518_96 q518_98 q519_96 q519_98 q521_96 q521_98 q522_96 q522_98 q527_96 q527_98 q528_96 q528_98 q532_96 q532_98 q533_96 q533_98 q534_96 q534_98 q539_96 q539_98 q540_96 q540_98 q543_96 q543_98 q554_96 q554_98 q555_96 q555_98 q557_96 q557_98 q558_96 q558_98 q560_96 q563_96 q564_96 q565_96 q567_96 q569_96 q570_96 {
    label values `var' oui_non
}

* Appliquer ce label à chaque variable ayant les modalitées 1 "Oui après incitation" 2 "Non après incitation"
foreach var of varlist q610_1_1 q610_1_2 q610_1_3 q610_1_4 q610_1_5 q610_1_6 q610_1_7 q610_1_8 q610_1_9 q610_1_10 q610_1_11 {
    label values `var' incitation
}

*Renommer les variables select_multiple en ce format oNum_section_namevariable_alphabet

* Liste des variables select_multiple et leurs modalités
local select_multiple_vars "q220a 6 q220b 6 q220c 6 q220d 6 q220e 6 q220f 6 q220g 6 q220h 6 q220i 6 q220j 6"
local select_multiple_vars "`select_multiple_vars' q401 10 q402 5"
local select_multiple_vars "`select_multiple_vars' q404a 5 q404b 5 q404c 5 q404d 5 q404e 5 q404f 5 q404g 5 q404h 5 q404i 5 q404j 5"
local select_multiple_vars "`select_multiple_vars' q414 5 q415 5 q502 7 q504 6 q505 7 q507 4"
local select_multiple_vars "`select_multiple_vars' q511 11 q512 10 q513 10 q517 4 q518 6 q519 3 q521 11 q522 5"
local select_multiple_vars "`select_multiple_vars' q527 6 q528 6 q532 4 q533 13 q534 9 q539 6 q540 9 q543 6"
local select_multiple_vars "`select_multiple_vars' q554 6 q555 12 q557 6 q558 8 q560 12 q563 12 q564 4 q565 5 q567 5 q569 5 q570 5 q610 12"

* Fonction pour convertir un nombre en lettre (1 → "a", 2 → "b", etc.)
capture program drop num_to_letter
program define num_to_letter
    args num
    local letters "a b c d e f g h i j k l m n o p q r s t u v w x y z"
    local letter : word `num' of `letters'
    c_local letter `letter'
end

* Boucle pour renommer les variables
local i = 1
while `i' <= wordcount("`select_multiple_vars'") {
    * Extraire le nom de la variable et le nombre de modalités
    local var : word `i' of `select_multiple_vars'
    local nb_modalites : word `=`i'+1' of `select_multiple_vars'

    * Vérifier si on a bien extrait une variable et un nombre de modalités
    if "`nb_modalites'" == "" {
        display as error "Problème avec la variable `var'. Vérifiez la liste."
        continue
    }

    * Extraire la section et la question du nom de la variable
    local section = substr("`var'", 2, 1)  // Extraire le deuxième caractère (section)
    local question = substr("`var'", 3, .) // Extraire le reste (question)

    * Renommer les variables binaires
    forvalues j = 1/`nb_modalites' {
        * Vérifier si la variable binaire existe
        capture confirm variable `var'_`j'
        if !_rc {
            * Convertir le numéro de la modalité en lettre (1 → "a", 2 → "b", etc.)
            num_to_letter `j'
            local suffix = "`letter'"

            * Générer le nouveau nom de la variable
            local new_name = "o`section'_`question'_`suffix'"
            rename `var'_`j' `new_name'
            display "`var'_`j' renommé en `new_name'"
        }
        else {
            display as error "La variable `var'_`j' n'existe pas."
        }
    }

    * Passer à la prochaine variable
    local i = `i' + 2
}

*Renommer toutes les variables restantes

* Boucle pour renommer toutes les variables commençant par "q"
foreach var of varlist q* {
    * Extraire la section et la question
    local section = substr("`var'", 2, 1)  // Extraire le deuxième caractère (section)
    local question = substr("`var'", 3, .) // Extraire le reste (question)

    * Générer le nouveau nom de la variable
    local new_name = "o`section'_`question'"

    * Renommer la variable
    capture confirm variable `var'
    if !_rc {
        rename `var' `new_name'
        display "`var' renommé en `new_name'"
    }
    else {
        display as error "La variable `var' n'existe pas."
    }
}

rename region_name o1_1
rename s1_3 o1_2
rename lieu_type o1_7

*Enlever les 0 insignifiant dans les noms des variables
ds o*_*
foreach var of varlist _all {
    if strpos("`var'", "_") > 0 {
        local prefix = substr("`var'", 1, strpos("`var'", "_") - 1)
        local suffix = substr("`var'", strpos("`var'", "_") + 1, .)

        if regexm("`suffix'", "([0-9]+)([a-zA-Z_]*)") {
            local num = real(regexs(1))
            local letters = regexs(2)

            local new_var = "`prefix'_`num'`letters'"

            capture confirm variable `new_var'
            if _rc != 0 & "`var'" != "`new_var'" {
                rename `var' `new_var'
            }
        }
    }
}



foreach var of varlist o5*_other {
    local newname = subinstr("`var'", "_other", "autre", .)
    rename `var' `newname'
}

foreach var of varlist o3*other o4*other {
    local newname = subinstr("`var'", "other", "autre", .)
    rename `var' `newname'
}

drop o2_20a o2_20b o2_20c o2_20d o2_20e o2_20f o2_20g o2_20h o2_20i o2_20j o4_1 o4_2 o4_4a o4_4b o4_4c o4_4d o4_4e o4_4f o4_4g o4_4h o4_4i o4_4j o4_14 o4_15 o5_2 o5_4 o5_5 o5_7 o6_10 reserved_name_for_field_list_lab o5_11 o5_12 o5_13 o5_17 o5_18 o5_19 o5_21 o5_22 o5_27 o5_28 o5_32 o5_33 o5_34 o5_39 o5_40 o5_43 o5_54 o5_55 o5_57 o5_58 o5_60 o5_63 o5_64 o5_65 o5_67 o5_69 o5_70 



save Pharmacie_finaldata.dta, replace 
