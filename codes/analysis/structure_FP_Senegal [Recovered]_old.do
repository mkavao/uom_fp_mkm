clear



import excel "C:\Users\asandie\Desktop\Data_FP_Senegal\eps.xlsx", sheet("Sheet 1") firstrow clear
save eps.dta, replace

import excel "C:\Users\asandie\Desktop\Data_FP_Senegal\centresante.xlsx", sheet("Sheet 1") firstrow clear
save centresante.dta, replace

import excel "C:\Users\asandie\Desktop\Data_FP_Senegal\postesante.xlsx", sheet("Sheet 1") firstrow clear
save postesante.dta, replace

import excel "C:\Users\asandie\Desktop\Data_FP_Senegal\casesante.xlsx", sheet("Sheet 1") firstrow clear
save casesante.dta, replace

import excel "C:\Users\asandie\Desktop\Data_FP_Senegal\clinique.xlsx", sheet("Sheet 1") firstrow clear
save clinique.dta, replace



append using "C:\Users\asandie\Desktop\Data_FP_Senegal\casesante.dta", force


append using "C:\Users\asandie\Desktop\Data_FP_Senegal\postesante.dta", force


append using "C:\Users\asandie\Desktop\Data_FP_Senegal\centresante.dta", force


append using "C:\Users\asandie\Desktop\Data_FP_Senegal\eps.dta", force

save master_string, replace

export excel using "master_file_string", sheetreplace firstrow(variables)

clear

 import excel "C:\Users\asandie\Desktop\Data_FP_Senegal\master_file_string_bon.xlsx", sheet("Sheet1") firstrow

label define hf_type 1 "eps" 2 "centre sante" 3 "poste sante" 4 "case de santé" 5 "clinique"
label values hf_type hf_type


***** *** SECTION 3 : INFRASTRUCTURE GÉNÉRALE


label var s3_1_1_1	"301A. L'EPS dispose t-il d'une salle d'attente avec des sièges ?"
label var s3_1_2_1	"301B. L'EPS dispose t-il de toilettes pour hommes avec eau courante dans la salle d'attente ?"
label var s3_1_3_1	"301C. L'EPS dispose t-il de toilettes pour femmes avec eau courante dans la salle d'attente ?"
label var s3_1_4_1	   "301D. L'EPS dispose t-il de dispositif de lavage des mains ?"
label var s3_1_5_1	"301E. L'EPS dispose t-il d'eau potable ?"
label var s3_1_6_1	"301F. L'EPS dispose t-il d'alimentation en électricité ?"
label var s3_1_8_1	"301G. L'EPS dispose t-il de laboratoire ?"
label var s3_1_8_1a	"301H. L'EPS dispose t-il de service d'imagerie ?"
label var s3_1_9_1	"301I. L'EPS dispose t-il de salle d'opération (salle opératoire) ?"
label var s3_1_10_1	"301J. L'EPS dispose t-il de pharmacies ?"
label var s3_1_11_1	"301K. L'EPS dispose t-il de panneaux de signalisation pour orientation ?"
label var s3_1_12_1	"301L. L'EPS dispose t-il des rampes pour personnes handicapées ?"
label var s3_1_13_1	"301M. L'EPS dispose t-il de salle de collecte des déchets biomédicaux ?"
label var s3_1_14_1	"301N. L'EPS dispose t-il de parking automobile ?"



label define s3_1_1_1 1 "Oui" 2 "Non"
label val    s3_1_1_1 s3_1_1_1 

label define s3_1_2_1	1 "Oui" 2 "Non"
label val    s3_1_2_1	s3_1_2_1	

label define s3_1_3_1 1 "Oui" 2 "Non"
label val    s3_1_3_1 s3_1_3_1

label define s3_1_4_1 1 "Oui" 2 "Non"
label val    s3_1_4_1 s3_1_3_1

label define s3_1_5_1 1 "Oui" 2 "Non"
label val    s3_1_5_1 s3_1_5_1	

label define s3_1_6_1 1 "Oui" 2 "Non"
label val    s3_1_6_1 s3_1_6_1

label define s3_1_8_1 1 "Oui" 2 "Non"
label val    s3_1_8_1 s3_1_8_1

label define s3_1_8_1a 1 "Oui" 2 "Non"
label val    s3_1_8_1a s3_1_8_1a

label define s3_1_9_1 1 "Oui" 2 "Non"
label val    s3_1_9_1 s3_1_9_1

label define s3_1_10_1 1 "Oui" 2 "Non"
label val    s3_1_10_1 s3_1_10_1

label define s3_1_11_1 1 "Oui" 2 "Non"
label val    s3_1_11_1 s3_1_11_1


label define s3_1_12_1 1 "Oui" 2 "Non"
label val    s3_1_12_1 s3_1_12_1


label define s3_1_14_1 1 "Oui" 2 "Non"
label val    s3_1_14_1 s3_1_14_1


tabout  s3_1_1_1 hf_type  using "table_dhs.xls", append c(col) npos(both) nlab(Number) 
tabout  s3_1_2_1 hf_type  using "table_dhs.xls", append c(col) npos(both) nlab(Number) ///
h1(information_général) f(1.0) h3(nil) per show(none) style(tab) 
tabout  s3_1_3_1 hf_type  using "table_dhs.xls", append c(col) npos(both) nlab(Number) ///
h1(information_général) f(1.0) h3(nil) per show(none) style(tab) 
tabout  s3_1_4_1 hf_type  using "table_dhs.xls", append c(col) npos(both) nlab(Number) ///
h1(information_général) f(1.0) h3(nil) per show(none) style(tab) 
tabout  s3_1_5_1  hf_type  using "table_dhs.xls", append c(col) npos(both) nlab(Number) ///
h1(information_général) f(1.0) h3(nil) per show(none) style(tab) 
tabout  s3_1_6_1 hf_type  using "table_dhs.xls", append c(col) npos(both) nlab(Number) ///
h1(information_général) f(1.0) h3(nil) per show(none) style(tab) 
tabout  s3_1_8_1 hf_type  using "table_dhs.xls", append c(col) npos(both) nlab(Number) ///
h1(information_général) f(1.0) h3(nil) per show(none) style(tab) 
tabout  s3_1_8_1a hf_type  using "table_dhs.xls", append c(col) npos(both) nlab(Number) ///
h1(information_général) f(1.0) h3(nil) per show(none) style(tab) 
tabout  s3_1_9_1 hf_type  using "table_dhs.xls", append c(col) npos(both) nlab(Number) ///
h1(information_général) f(1.0) h3(nil) per show(none) style(tab) 
tabout  s3_1_10_1 hf_type  using "table_dhs.xls", append c(col) npos(both) nlab(Number) ///
h1(information_général) f(1.0) h3(nil) per show(none) style(tab) 
tabout  s3_1_11_1 hf_type  using "table_dhs.xls", append c(col) npos(both) nlab(Number) ///
h1(information_général) f(1.0) h3(nil) per show(none) style(tab) 
tabout  s3_1_12_1 hf_type  using "table_dhs.xls", append c(col) npos(both) nlab(Number) ///
h1(information_général) f(1.0) h3(nil) per show(none) style(tab) 
tabout  s3_1_13_1 hf_type  using "table_dhs.xls", append c(col) npos(both) nlab(Number) ///
h1(information_général) f(1.0) h3(nil) per show(none) style(tab) 
tabout  s3_1_14_1 hf_type  using "table_dhs.xls", append c(col) npos(both) nlab(Number) ///
h1(information_général) f(1.0) h3(nil) per show(none) style(tab) 



******************   Visite de la salle d'accouchement et enregistrement sur la base de l'observation **************


label var s3_2_1	"Toilettes fonctionnelles avec eau courante et chasse d'eau"
label var s3_2_2	"Zone de triage et d'examen "
label var s3_2_3	"Salle de travail réservée aux infirmiers/sage-femme d'état"
label var s3_2_4	"Salle de garde pour les médecins"
label var s3_2_55	"Salle de garde pour les infirmiers/sage-femme d'état"
label var s3_2_5	"Zone de soins aux nouveau-nés"
label var s3_2_6	"Zone de stockage médical"
label var s3_2_7	"Vestiaires"
label var s3_2_8	"Lavabo médical"
label var s3_2_9	"Zone de décontamination" 



label define s3_2_1 1 "Oui" 2 "Non"
label val    s3_2_1 s3_2_1

label define s3_2_2 1 "Oui" 2 "Non"
label val    s3_2_2 s3_2_2 

label define  s3_2_3 1 "Oui" 2 "Non"
label val     s3_2_3  s3_2_3

label define s3_2_4 1 "Oui" 2 "Non"
label val    s3_2_4 s3_2_4

label define s3_2_5 1 "Oui" 2 "Non"
label val    s3_2_5 s3_2_5

label define s3_2_55 1 "Oui" 2 "Non"
label val   s3_2_55 s3_2_55

label define s3_2_6 1 "Oui" 2 "Non"
label val    s3_2_6 s3_2_6

label define s3_2_7 1 "Oui" 2 "Non"
label val    s3_2_7 s3_2_7

label define s3_2_8  1 "Oui" 2 "Non"
label val    s3_2_8 s3_2_8

label define s3_2_9  1 "Oui" 2 "Non"
label val    s3_2_9 s3_2_9



tabout  s3_2_1 hf_type  using "table_dhs.xls", append c(col) npos(both) nlab(Number) ///
h1(salle_accouchement) f(1.0) h3(nil) per show(none) style(tab) 
tabout  s3_2_2  hf_type  using "table_dhs.xls", append c(col) npos(both) nlab(Number) ///
h1(salle_accouchement) f(1.0) h3(nil) per show(none) style(tab) 
tabout  s3_2_3 hf_type  using "table_dhs.xls", append c(col) npos(both) nlab(Number) ///
h1(salle_accouchement) f(1.0) h3(nil) per show(none) style(tab) 
tabout  s3_2_4 hf_type  using "table_dhs.xls", append c(col) npos(both) nlab(Number) ///
h1(salle_accouchement) f(1.0) h3(nil) per show(none) style(tab) 
tabout  s3_2_55  hf_type  using "table_dhs.xls", append c(col) npos(both) nlab(Number) ///
h1(salle_accouchement) f(1.0) h3(nil) per show(none) style(tab)
tabout  s3_2_5  hf_type  using "table_dhs.xls", append c(col) npos(both) nlab(Number) ///
h1(salle_accouchement) f(1.0) h3(nil) per show(none) style(tab)
tabout  s3_2_6  hf_type  using "table_dhs.xls", append c(col) npos(both) nlab(Number) ///
h1(salle_accouchement) f(1.0) h3(nil) per show(none) style(tab)
tabout  s3_2_7  hf_type  using "table_dhs.xls", append c(col) npos(both) nlab(Number) ///
h1(salle_accouchement) f(1.0) h3(nil) per show(none) style(tab)
tabout  s3_2_8  hf_type  using "table_dhs.xls", append c(col) npos(both) nlab(Number) ///
h1(salle_accouchement) f(1.0) h3(nil) per show(none) style(tab)
tabout  s3_2_9  hf_type  using "table_dhs.xls", append c(col) npos(both) nlab(Number) ///
h1(salle_accouchement) f(1.0) h3(nil) per show(none) style(tab)




*************************************************** Labelling ***********
 label var end " Heure de fin "
label var enqueteur " Nom de l'enquêteur "
label var equipe " Veuilllez choisir votre équipe  "
label var s1_1 " 101. Nom de la région "
label var s1_10 " 110. Mail de la structure ou du responsable de la structure "
label var s1_11 " 111. Estimation de la population polarisée par l'EPS "
label var s1_12 " Est-ce que la structure dispose d'un service de gynécologie-obstrétique ou maternité ? "
label var s1_13 " Est-ce que la structure dispose d'un service de pédiatrie ? "
label var s1_3 " 103. Nom du district "
label var s1_4 " 104. Nom du quartier "
label var s1_7 " 107. Autorité de gestion / Propriété "
label var s1_8 " 108. Nom du responsable de la structure "
label var s1_9 " 109. Numéro de téléphone de la structure ou du responsable de la structure "
label var s3_1_1_1 " 301A. L'EPS dispose t-il d'une salle d'attente avec des sièges ? "
label var s3_1_10_1 " 301J. L'EPS dispose t-il de pharmacies ? "
label var s3_1_11_1 " 301K. L'EPS dispose t-il de panneaux de signalisation pour orientation ? "
label var s3_1_12_1 " 301L. L'EPS dispose t-il des rampes pour personnes handicapées ? "
label var s3_1_13_1 " 301M. L'EPS dispose t-il de salle de collecte des déchets biomédicaux ? "
label var s3_1_14_1 " 301N. L'EPS dispose t-il de parking automobile ? "
label var s3_1_2_1 " 301B. L'EPS dispose t-il de toilettes pour hommes avec eau courante dans la salle d'attente ? "
label var s3_1_3_1 " 301C. L'EPS dispose t-il de toilettes pour femmes avec eau courante dans la salle d'attente ? "
label var s3_1_4_1 " 301D. L'EPS dispose t-il de dispositif de lavage des mains ? "
label var s3_1_5_1 " 301E. L'EPS dispose t-il d'eau potable ? "
label var s3_1_6_1 " 301F. L'EPS dispose t-il d'alimentation en électricité ? "
label var s3_1_8_1 " 301G. L'EPS dispose t-il de laboratoire ? "
label var s3_1_8_1a " 301H. L'EPS dispose t-il de service d'imagerie ? "
label var s3_1_9_1 " 301I. L'EPS dispose t-il de salle d'opération (salle opératoire) ? "
label var s3_10 " 310. Disponibilité d'un vestiaire pour les infirmières ? "
label var s3_11 " 311. Disponibilité d'une buanderie ? "
label var s3_12 " 312. Disponibilité d'une salle de garde pour les infirmiers ? "
label var s3_122 " 312. Disponibilité d'une salle de garde pour les médecins ? "
label var s3_13 " 313. Disponibilité d'une zone de stockage des médicaments ? "
label var S3_14_1 " Moniteur multipara (écran de surveillance des constantes  "
label var S3_14_10 " Bandelettes de glucomètre  "
label var S3_14_11 " Équipement fonctionnel de soins intensifs pour la réanimation  "
label var S3_14_12 " Pompe à microperfusion avec set  "
label var S3_14_13 " Kit de réanimation pour bébé  "
label var S3_14_14 " Bouteille d'oxygène avec détendeur et masque  "
label var S3_14_15 " Cagoule à oxygène "
label var S3_14_16 " Machine d'aspiration  "
label var S3_14_17 " Appareil de photothérapie  "
label var S3_14_18 " Réchauffeurs radiants - commandés par servomoteur avec oxygène et aspiration  "
label var S3_14_19 " Équipement de transport néonatal  "
label var S3_14_2 " Thermomètre "
label var S3_14_20 " Thermomètre numérique  "
label var S3_14_21 " Débitmètre pour source d'oxygène, avec graduations en ml  "
label var S3_14_22 " Humidificateur  "
label var S3_14_23 " Appareil pédiatrique d'administration d'oxygène (tubes de connexion et masque/angles nasaux)  "
label var S3_14_24 " Masques et canules de taille néonatale  "
label var S3_14_25 " Pince nasale  "
label var S3_14_26 " Pièce d'aspiration du mucus  "
label var S3_14_27 " Sonde d'alimentation  "
label var S3_14_28 " Réfrigérateur  "
label var S3_14_29 " Chariot de réanimation avec plateau d'urgence "
label var S3_14_3 " Balance  "
label var S3_14_30 " Lavage des mains à l'eau courante au point d'utilisation  "
label var S3_14_31 " Robinets actionnés par le coude   "
label var S3_14_32 " Lavabo large et profond pour éviter les éclaboussures et la rétention d'eau "
label var S3_14_33 " Savon antiseptique avec porte-savon/antiseptique liquide avec distributeur  "
label var S3_14_34 " Produit de friction pour les mains à base d'alcool  "
label var S3_14_35 " Affichage des instructions relatives au lavage des mains au point d'utilisation  "
label var S3_14_36 " Équipement de protection individuelle (EPI)  "
label var S3_14_37 " Désinfectant "
label var S3_14_38 " Agents de nettoyage  "
label var S3_14_39 " Poubelles à code couleur au point de production des déchets  "
label var S3_14_4 " Oxymètre de pouls "
label var S3_14_40 " Sacs en plastique au point de production des déchets  "
label var S3_14_5 " Stéthoscope pédiatrique "
label var S3_14_6 " Infantomètre "
label var S3_14_7 " Ruban de mesure "
label var S3_14_8 " Fluxmètre "
label var S3_14_9 " Glucomètre  "
label var s3_15 " 315. L'EPS dispose-t-il d'un laboratoire ? "
label var S3_16_1 " Eau courante avec robinet normal "
label var S3_16_10 " Bilirubinomètre "
label var S3_16_2 " Eau courante avec robinet coudé "
label var S3_16_3 " Stérilisateur d'instruments "
label var S3_16_4 " Destructeur d'aiguilles/coupe-embouts "
label var S3_16_5 " Réfrigérateur "
label var S3_16_6 " Hémoglobinomètre "
label var S3_16_7 " Microscope binoculaire/monoculaire "
label var S3_16_8 " Test d'électrolytes (ionogramme) "
label var S3_16_9 " Glucomètre/ Dextrogyre "
label var s3_17_1 " Savon "
label var s3_17_2 " Gants utilitaires "
label var s3_17_3 " Gants de chirurgie/d'examen "
label var s3_17_4 " Bacs en plastique couverts pour la décontamination "
label var s3_17_5 " Poubelles à déchets biomédicaux jaunes (Déchets tranchants et piquants) "
label var s3_17_6 " Poubelles pour déchets biomédicaux-Rouge (Déchets anatomiques) "
label var s3_17_7 " Poubelles pour déchets biomédicaux - noires (Déchets domestiques) "
label var s3_17_8 " Boîte en carton bleu pour les ampoules et les flacons en verre mis au rebut "
label var s3_18_1 " Hématologie "
label var s3_18_10 " Test VDRL  "
label var s3_18_11 " Radiographie "
label var s3_18_12 " Echographie  "
label var s3_18_13 " Scanner  "
label var s3_18_2 " Analyse d'urine "
label var s3_18_3 " Analyse des selles "
label var s3_18_4 " Glycémie "
label var s3_18_5 " Urée sanguine "
label var s3_18_6 " Créatinine sanguine "
label var s3_18_7 " Test de grossesse  "
label var s3_18_8 " Test Widal "
label var s3_18_9 " Test ELISA pour le VIH  "
label var s3_19 " 319. L'EPS dispose-t-il d'une salle d'opération pour les chirurgies non urgentes et/ou les chirurgies d'urgence ? "
label var s3_2_1 " Toilettes fonctionnelles avec eau courante et chasse d'eau  "
label var s3_2_2 " Zone de triage et d'examen  "
label var s3_2_3 " Salle de travail réservée aux infirmiers/sage-femme d'état "
label var s3_2_4 " Salle de garde pour les médecins  "
label var s3_2_5 " Zone de soins aux nouveau-nés  "
label var s3_2_55 " Salle de garde pour les infirmiers/sage-femme d'état "
label var s3_2_6 " Zone de stockage médical  "
label var s3_2_7 " Vestiaires  "
label var s3_2_8 " Lavabo médical "
label var s3_2_9 " Zone de décontamination  "
label var s3_20_1 " Zone d'attente pour le personnel soignant "
label var s3_20_2 " Zone de protection délimitée "
label var s3_20_3 " Zone propre délimitée  "
label var s3_20_4 " Zone stérile délimitée  "
label var s3_20_5 " Zone d'élimination délimitée  "
label var s3_20_6 " Salle préopératoire  "
label var s3_20_7 " Salle postopératoire  "
label var s3_21_1 " Alimentation électrique avec groupe électrogène "
label var s3_21_10 " Chariot à instruments "
label var s3_21_11 " Instrument de mesure de la tension artérielle "
label var s3_21_12 " Stéthoscope "
label var s3_21_13 " Chauffage de la pièce "
label var s3_21_14 " Climatiseur (AC) "
label var s3_21_15 " Support à perfusion "
label var s3_21_16 " Table d'opération "
label var s3_21_17 " Bouteille d'oxygène avec détendeur et masque "
label var s3_21_18 " Moniteur cardiaque "
label var s3_21_19 " Oxymètre de pouls                               "
label var s3_21_2 " Toilettes avec eau courante "
label var s3_21_20 " Matériel de diathermie                               "
label var s3_21_21 " Plateau/chariot de médicaments et d'équipements d'urgence         "
label var s3_21_22 " Stérilisateur à haute pression / Autoclave "
label var s3_21_23 " Voies aériennes oropharyngées (canule adulte)                         "
label var s3_21_24 " Tubes endotrachéaux (taille adulte)                         "
label var s3_21_25 " Laryngoscope avec lames pour adultes                       "
label var s3_21_26 " Masques de protection                                  "
label var s3_21_27 " Kit d'aiguilles spinales SS 4 2                              "
label var s3_21_28 " Appareil d'anesthésie                               "
label var s3_21_29 " Appareil de Boyles                                "
label var s3_21_3 " Robinet lave-mains près de la table opératoire pour le nettoyage "
label var s3_21_30 " Bouteille de protoxyde d'azote                             "
label var s3_21_31 " Vaporisateur d'halothane / d'isoflurane / d'enflurane    "
label var s3_21_32 " Kit de stérilisation (Eau de décontamination chloré) "
label var s3_21_33 " Kit de stérilisation (Autoclave de table) "
label var s3_21_34 " Kit D & C (kit avortement : Dilatation) "
label var s3_21_35 " Kit D & C (kit avortement : AMIU ou AEIU) "
label var s3_21_36 " Kit LSCS (Césarienne) "
label var s3_21_37 " Table de réanimation "
label var s3_21_38 " Seringue et canule MVA  (Aspiration Manuelle à Vide) "
label var s3_21_39 " Lavage des mains à l'eau courante au point d'utilisation  "
label var s3_21_4 " Source de lumière de secours "
label var s3_21_40 " Robinets actionnés par le coude   "
label var s3_21_41 " Lavabo large et profond pour éviter les éclaboussures et la rétention d'eau "
label var s3_21_42 " Savon antiseptique avec porte-savon/antiseptique liquide avec distributeur "
label var s3_21_43 " Produit de friction pour les mains à base d'alcool  "
label var s3_21_44 " Affichage des instructions relatives au lavage des mains au point d'utilisation  "
label var s3_21_45 " Équipement de protection individuelle (EPI) "
label var s3_21_46 " Désinfectant  "
label var s3_21_47 " Agents de nettoyage  "
label var s3_21_48 " Poubelles à code couleur au point de production des déchets  "
label var s3_21_49 " Sacs en plastique au point de production des déchets "
label var s3_21_5 " Table d'ergothérapie fonctionnelle en position de Trendelenburg "
label var s3_21_6 " Table d'ergothérapie simple dont l'extrémité inférieure est surélevée par des briques ou tout autre moyen "
label var s3_21_7 " Marche pied "
label var s3_21_8 " Tapis de Kelly "
label var s3_21_9 " Projecteur fonctionnel / lampe sans ombre "
label var s3_22_1 " Boîte blanche antiperforation pour les objets métalliques pointus (aiguilles/lames) "
label var s3_22_10 " Pince de Cheattle "
label var s3_22_11 " Porte-pinces de Cheattle (acier inoxydable) "
label var s3_22_12 " Bac couvert pour la décontamination "
label var s3_22_13 " Récipient de glutaraldéhyde (plastique/acier avec couvercle) "
label var s3_22_14 " Plateau en acier inoxydable avec couvercle pour les autres instruments "
label var s3_22_15 " Drap chirurgical / drap de coupe "
label var s3_22_16 " Tampons de coton (localement on fabrique des tampons de compresses, ou de coton emballé avec des compresses) "
label var s3_22_17 " Antiseptiques (bétadine/savlon, alcool pour les mains) "
label var s3_22_18 " Gants de taille 6 /7 et 7/8 "
label var s3_22_19 " Seringue, 5 ml "
label var s3_22_2 " Boîte en carton pour les ampoules et les flacons en verre mis au rebut "
label var s3_22_20 " Aiguille, longueur 1,5 pouce 24-G, 26 G "
label var s3_22_21 " Solutions d'iodophore à 5 "
label var s3_22_22 " Bandage suspenseur "
label var s3_22_23 " Matériel de pansement (Pansement, ciseaux, bétadine, alcool…) "
label var s3_22_24 " Morceaux de gaze "
label var s3_22_3 " Poubelles biomédicales jaunes  "
label var s3_22_4 " Poubelles biomédicales-Rouge  "
label var s3_22_5 " Bacs à déchets biomédicaux - Noirs  "
label var s3_22_6 " Bac à médicaments d'urgence "
label var s3_22_7 " Horloge fonctionnelle "
label var s3_22_8 " Tambour - Linge (autoclavé) "
label var s3_22_9 " Tambour - Gaze de coton (autoclavé) "
label var s3_3_1 " Table d'accouchement "
label var s3_3_10 " Médicaments d'urgence dans le plateau/chariot de l'équipement (antibiotique) "
label var s3_3_11 " Médicaments d'urgence dans le plateau/chariot de l'équipement (antalgiques) "
label var s3_3_12 " Médicaments d'urgence dans le plateau/chariot de l'équipement (acide tranexamique ou exacyl) "
label var s3_3_13 " Médicaments d'urgence dans le plateau/chariot de l'équipement (sulfate de magnésium) "
label var s3_3_14 " Médicaments d'urgence dans le plateau/chariot de l'équipement (nifédipine) "
label var s3_3_15 " Médicaments d'urgence dans le plateau/chariot de l'équipement (corticostéroide) "
label var s3_3_16 " Kit d'accouchement normal  (pince de Kocher) "
label var s3_3_17 " Kit d'accouchement normal  (ciseau pour cordon ombilical) "
label var s3_3_18 " Kit d'accouchement normal  (clamp de bar) "
label var s3_3_19 " Kit d'accouchement normal  (pince à rompre) "
label var s3_3_2 " Lampe/éclairage réglable     "
label var s3_3_20 " Kit d'accouchement normal  (compresses stériles) "
label var s3_3_21 " Kit d'accouchement normal  (gants stériles) "
label var s3_3_22 " Kit d'accouchement normal             "
label var s3_3_23 " Pince à forceps "
label var s3_3_24 " Ventouse "
label var s3_3_25 " Pince à coeur    "
label var s3_3_26 " Plateau réniforme (Haricots)  "
label var s3_3_27 " Seringue et canule AMIU (Aspiration manuelle intra-utérine)      "
label var s3_3_28 " Tambour    "
label var s3_3_29 " Ciseaux à cordon               "
label var s3_3_3 " Bouteille d'oxygène avec régulateur et masque  "
label var s3_3_30 " Pinces à cordon             "
label var s3_3_31 " Clamp de Bar                 "
label var s3_3_32 " Supports à perfusion               "
label var s3_3_33 " Kits de perfusion intraveineuse                 "
label var s3_3_34 " Sonde urinaire            "
label var s3_3_35 " Cotons et compresses stérilisés       "
label var s3_3_36 " Stérilisateur à haute pression / Autoclave   "
label var s3_3_37 " Kit de suture  (pince) "
label var s3_3_38 " Kit de suture  (porte aiguille) "
label var s3_3_39 " Kit de suture  (ciseaux) "
label var s3_3_4 " Aspirateur manuelle intra-utérine (AMIU)  "
label var s3_3_40 " Kit de suture  (lames) "
label var s3_3_41 " Kit de suture  (fils) "
label var s3_3_42 " Kit de suture  (compresses stériles) "
label var s3_3_43 " Kit de suture  (gants stériles) "
label var s3_3_44 " Kit de suture  (bétadine) "
label var s3_3_45 " Kit de test de grossesse urinaire              "
label var s3_3_46 " Lavage des mains à l'eau courante au point d'utilisation   "
label var s3_3_47 " Robinets actionnés par le coude  "
label var s3_3_48 " Lavabo large et profond pour éviter les éclaboussures et la rétention d'eau  "
label var s3_3_49 " Savon antiseptique avec porte-savon/antiseptique liquide avec distributeur    "
label var s3_3_50 " Produit de friction pour les mains à base d'alcool    "
label var s3_3_51 " Affichage des instructions relatives au lavage des mains au point d'utilisation   "
label var s3_3_52 " Équipement de protection individuelle (EPI)    "
label var s3_3_53 " Désinfectant    "
label var s3_3_54 " Produits de nettoyage  "
label var s3_3_55 " Poubelles à code couleur au point de production des déchets   "
label var s3_3_56 " Sacs en plastique au point de production des déchets  "
label var s3_3_6 " Ampoule d'aspiration ou pingouin "
label var s3_3_7 " Fœtoscope/Doppler  "
label var s3_3_8 " Stéthoscope Pinard  "
label var s3_3_9 " Médicaments d'urgence dans le plateau/chariot de l'équipement (antispasmodique) "
label var s3_4_1_1 " Services d'hospitalisation "
label var s3_4_1_1a " Services d'hospitalisation "
label var s3_4_1_2 " Toilettes fonctionnelles avec eau courante et chasse d'eau dans le service "
label var s3_4_1_2a " Toilettes fonctionnelles avec eau courante et chasse d'eau dans le service "
label var s3_4_1_3 " Aire de lavage des mains et de bain séparée pour les patients et les visiteurs "
label var s3_4_1_3a " Aire de lavage des mains et de bain séparée pour les patients et les visiteurs "
label var s3_4_1_4 " Zone d'attente ombragée pour les accompagnateurs des patients "
label var s3_4_1_4a " Zone d'attente ombragée pour les accompagnateurs des patients "
label var s3_4_1_5 " Salle de travail réservées aux infirmières "
label var s3_4_1_5a " Salle de travail réservées aux infirmières "
label var s3_4_1_6 " Salle de décontamination "
label var s3_4_1_6a " Salle de décontamination "
label var s3_5_1 " Mobilier "
label var s3_5_10 " Écarteur de paroi vaginale antérieure  "
label var s3_5_11 " Oxygène à canalisation centrale/concentrateur/cylindre  "
label var s3_5_12 " Débitmètre pour la source d'oxygène, avec graduations en ml  "
label var s3_5_13 " Humidificateur/Climatisation  "
label var s3_5_14 " Appareil d'administration d'oxygène pour adultes/enfants (tubes de raccordement et masque)  "
label var s3_5_15 " Appareil d'administration d'oxygène pour adultes/enfants (pinces nasales) communément appelé lunettes nasale "
label var s3_5_16 " Aspirateur  "
label var s3_5_17 " Réfrigérateur  "
label var s3_5_18 " Chariot de réanimation avec plateau d'urgence  "
label var s3_5_19 " Équipement pour la prévention standard des infections courantes  "
label var s3_5_2 " Tensiomètre "
label var s3_5_20 " Support à perfusion (potence)  "
label var s3_5_21 " Dispositif électrique pour les équipements comme l'aspirateur  "
label var s3_5_22 " Poste de soins infirmiers  "
label var s3_5_23 " Stéthoscope pédiatrique  "
label var s3_5_24 " Oxymètre de pouls  "
label var s3_5_25 " Torche  "
label var s3_5_26 " Nébuliseur  "
label var s3_5_27 " Masque avec chambre d'inhalation  "
label var s3_5_28 " Masques de protection Nouveau-né  "
label var s3_5_29 " Masques de protection Adulte  "
label var s3_5_3 " Thermomètre  "
label var s3_5_33 " Mobilier "
label var s3_5_35 " Thermomètre  "
label var s3_5_37 " Balance nourisson  "
label var s3_5_38 " Balance adulte  "
label var s3_5_4 " Fœtoscope/Doppler  "
label var s3_5_42 " Oxygène à canalisation centrale/concentrateur/cylindre  "
label var s3_5_43 " Débitmètre pour la source d'oxygène, avec graduations en ml  "
label var s3_5_44 " Humidificateur/Climatisation  "
label var s3_5_45 " Appareil d'administration d'oxygène pour adultes/enfants (tubes de raccordement et masque)  "
label var s3_5_46 " Appareil d'administration d'oxygène pour adultes/enfants (pinces nasales)  "
label var s3_5_47 " Aspirateur  "
label var s3_5_48 " Réfrigérateur  "
label var s3_5_49 " Chariot de réanimation avec plateau d'urgence  "
label var s3_5_5 " Stéthoscope Pinard  "
label var s3_5_50 " Équipement pour la prévention standard des infections courantes  "
label var s3_5_51 " Support à perfusion (potence)  "
label var s3_5_52 " Dispositif électrique pour les équipements comme l'aspirateur  "
label var s3_5_53 " Poste de soins infirmiers  "
label var s3_5_54 " Stadiomètre pour la hauteur  "
label var s3_5_55 " Infantomètre pour la longueur  "
label var s3_5_56 " Stéthoscope pédiatrique  "
label var s3_5_57 " Oxymètre de pouls  "
label var s3_5_58 " Torche  "
label var s3_5_59 " Nébuliseur  "
label var s3_5_6 " Balance nourisson  "
label var s3_5_60 " Masque avec chambre d'inhalation  "
label var s3_5_61 " Masques de protection Nouveau-né  "
label var s3_5_62 " Masques de protection Nourrisson  "
label var s3_5_63 " Masques de protection Enfant  "
label var s3_5_64 " Masques de protection Adulte  "
label var s3_5_7 " Balance adulte  "
label var s3_5_8 " Stéthoscope adulte/enfant  "
label var s3_5_9 " Spéculum  "
label var s3_6 " 306. L'établissement dispose-t-il d'une unité de soins intensifs pour nouveau-né malade ? "
label var s3_7 " 307. L'unité de soins intensifs dispose-t-elle d'une zone propre pour le mélange des fluides intraveineux et des médicaments/zone de préparation des fluides ? "
label var s3_8 " 308. L'unité de soins intensifs dispose-t-elle d'une zone réservée à la mère pour l'extraction du lait maternel/l'allaitement ? "
label var s3_9 " 309. L'unité de soins intensifs dispose-t-elle d'un espace réservé à l'unité de centre de gestion principal ? "
label var s5_10 " 510A. Raisons de la non-disponibilité de la pilule "
label var s5_10_autre " Préciser autre raison de la non disponibilité de la pilule "
label var s5_10_autrea " Préciser autre raison de la non disponibilité de l'injectable "
label var s5_10_autreb " Préciser autre raison de la non disponibilité du préservatif masculin "
label var s5_10_autrec " Préciser autre raison de la non disponibilité du préservatif féminin "
label var s5_10_autree " Préciser autre raison de la non disponibilité de la contraception d'urgence "
label var s5_10_autref " Préciser autre raison de la non disponibilité du DIU "
label var s5_10_autreg " Préciser autre raison de la non disponibilité de l'implant "
label var s5_10_autreh " Préciser autre raison de la non disponibilité de la stérilisation féminine (Ligature des trompes) "
label var s5_10_autrej " Préciser autre raison de la non disponibilité de la stérilisation masculine/vasectomie "
label var s5_10_autrek " Préciser autre raison de la non disponibilité de l'allaitement maternel exclusif (MAMA) "
label var s5_10_autrel " Préciser autre raison de la non disponibilité de la méthode des jours fixes (MJF) "
label var s5_10a " 510B. Raisons de la non-disponibilité de l'injectable "
label var s5_10b " 510C. Raisons de la non-disponibilité du préservatif masculin "
label var s5_10c " 510D. Raisons de la non-disponibilité du préservatif féminin "
label var s5_10e " 510E. Raisons de la non-disponibilité de la contraception d'urgence "
label var s5_10f " 510F. Raisons de la non-disponibilité du DIU "
label var s5_10g " 510G. Raisons de la non-disponibilité de l'implant "
label var s5_10h " 510H. Raisons de la non-disponibilité de la stérilisation féminine (Ligature des trompes) "
label var s5_10j " 510I. Raisons de la non-disponibilité de la stérilisation masculine/Vasectomie "
label var s5_10k " 510J. Raisons de la non-disponibilité de l'allaitement maternel exclusif (MAMA) "
label var s5_10l " 510K. Raisons de la non-disponibilité de la méthode des jours fixes (MJF) "
label var s5_11 " 511. Cet EPS offre-t-elle des services de planification familiale de proximité ? "
label var s5_12 " 512. Quelle est la fréquence des services de PF de proximité organisés par cet EPS ? "
label var s5_13_1 " Mise en place DIU "
label var s5_13_10 " Implants "
label var s5_13_11 " Retrait des implants "
label var s5_13_12 " Diaphragme "
label var s5_13_13 " Mousse/gelée "
label var s5_13_14 " Méthode des jours fixes (MJF) "
label var s5_13_15 " Pilule contraceptive d'urgence "
label var s5_13_16 " Stérilisation par laparoscopie  "
label var s5_13_17 " Stérilisation par mini laparotomie (féminine) "
label var s5_13_18 " Stérilisation post-partum "
label var s5_13_19 " Stérilisation post-avortement "
label var s5_13_2 " PA (Post-Partum) DIU "
label var s5_13_20 " Stérilisation masculine - VSB (VASECTOMIE SANS BISTOURI)  "
label var s5_13_3 " PP (Post-Placenta) DIU "
label var s5_13_4 " Retrait du DIU "
label var s5_13_5 " Pilule contraceptive orale "
label var s5_13_6 " Préservatifs (masculins) "
label var s5_13_7 " Préservatifs (féminins) "
label var s5_13_8 " Injectable-Depo Provera "
label var s5_13_9 " Injectable-Sayana Press "
label var s5_2_acc " 502. A quelle fréquence ces services d'accouchement sont-ils fournis ? "
label var s5_2_avo " 502. A quelle fréquence ce service post-avortement est-il fourni ? "
label var s5_2_cpn " 502. A quelle fréquence les CPN sont-elles fournies ? "
label var s5_2_nne " 502. A quelle fréquence ces services essentiels aux nouveau-nés sont-ils fournis ? "
label var s5_2_pnat " 502. A quelle fréquence ce service postnatal est-il fourni ? "
label var s5_2_sinf " 502. A quelle fréquence ces services de santé néonatales et infantiles sont-ils fournis ? "
label var s5_3_acc " 503a. Ce service d'accouchement (accouchement par voie basse : Ticket + Kit d'accouchement + Episiotomie) est-il fourni gratuitement ? "
label var s5_3_acca " 503b. Ce service d'accouchement (accouchement par césarienne) est-il fourni gratuitement ? "
label var s5_3_avo " 503. Ce service post-avortement est-il fourni gratuitement ? "
label var s5_3_cpn " 503a. Le ticket de CPN est-il fourni gratuitement ? "
label var s5_3_cpna " 503b. Les services paracliniques disponibles (CPN) sont-ils fourni gratuitement ? "
label var s5_3_nne " 503. Ces services essentiels aux nouveau-nés est-il fourni gratuitement ? "
label var s5_3_pnat " 503. Ce service postnatal est-il fourni gratuitement ? "
label var s5_3_sinf " 503. Ces services de santé infantiles est-il fourni gratuitement ? "
label var s5_4_acc1 " 504a. Combien cela coûte-t-il par unité (accouchement par voie basse) ? "
label var s5_4_acc2 " 504b. Combien cela coûte-t-il par unité (accouchement par césarienne) ? "
label var s5_4_avo " 504. Combien cela coûte-t-il par unité ? "
label var s5_4_cpn " 504a. Combien cela coûte-t-il par unité (le ticket de CPN) ? "
label var s5_4_cpna " 504b. Combien cela coûte-t-il dans l'ensemble (les services paracliniques disponibles) ? "
label var s5_4_nne " 504. Combien cela coûte-t-il par unité ? "
label var s5_4_pnat " 504. Combien cela coûte-t-il par unité ? "
label var s5_4_sinf " 504. Combien cela coûte-t-il par unité ? "
label var s5_5_acc " 505. Raisons de la non-disponibilité du service d'accouchement "
label var s5_5_acc_autre " Préciser autre raison de la non disponibilité du service d'accouchement "
label var s5_5_avo " 505. Raisons de la non-disponibilité du service post-avortement "
label var s5_5_avo_autre " Préciser autre raison de la non disponibilité du service post-avortement "
label var s5_5_cpn " 505. Raisons de la non-disponibilité du service de CPN "
label var s5_5_cpn_autre " Préciser autre raison de la non disponibilité du service de CPN "
label var s5_5_nne " 505. Raisons de la non-disponibilité des services essentiels aux nouveau-nés "
label var s5_5_nne_autre " Préciser autre raison de la non disponibilité des services essentiels aux nouveau-nés "
label var s5_5_pnat " 505. Raisons de la non-disponibilité du service postnatal "
label var s5_5_pnat_autre " Préciser autre raison de la non disponibilité du service postnatal "
label var s5_5_sinf " 505. Raisons de la non-disponibilité des services de santé néonatales et infantiles "
label var s5_5_sinf_autre " Préciser autre raison de la non disponibilité des services de santé néonatales et infantiles "
label var s5_7 " 507A. A quelle fréquence La pilule est-il fourni ? "
label var s5_7a " 507B. A quelle fréquence l'injectable est-il fourni ? "
label var s5_7b " 507C. A quelle fréquence le préservatif masculin est-il fourni ? "
label var s5_7c " 507D. A quelle fréquence le préservatif féminin est-il fourni ? "
label var s5_7e " 507E. A quelle fréquence la contraception d'urgence est-il fourni ? "
label var s5_7f " 507F. A quelle fréquence le DIU est-il fourni ? "
label var s5_7g " 507G. A quelle fréquence l'implant est-il fourni ? "
label var s5_7h " 507H. A quelle fréquence la stérilisation féminine (Ligature des trompes) est-il fourni ? "
label var s5_7j " 507I. A quelle fréquence la stérilisation masculine/Vasectomie est-il fourni ? "
label var s5_7k " 507J. A quelle fréquence l'allaitement maternel exclusif (MAMA) est-il fourni ? "
label var s5_7l " 507K. A quelle fréquence la méthode des jours fixes (MJF) est-il fourni ? "
label var s5_8 " 508A. La pilule est-il fournie gratuitement ? "
label var s5_8a " 508B. L'injectable est-il fournie gratuitement ? "
label var s5_8b " 508C. Le préservatif masculin est-il fournie gratuitement ? "
label var s5_8c " 508D. Le préservatif féminin est-il fournie gratuitement ? "
label var s5_8e " 508E. La contraception d'urgence est-il fournie gratuitement ? "
label var s5_8f " 508F. Le DIU est-il fournie gratuitement ? "
label var s5_8g " 508G. L'implant est-il fournie gratuitement ? "
label var s5_8h " 508H. La stérilisation féminine (Ligature des trompes) est-il fournie gratuitement ? "
label var s5_8j " 508I. La stérilisation masculine/vasectomie est-il fournie gratuitement ? "
label var s5_8k " 508J. L'allaitement maternel exclusif (MAMA) est-il fournie gratuitement ? "
label var s5_8l " 508K. La méthode des jours fixes (MJF) est-il fournie gratuitement ? "
label var s5_9 " 509A. Combien cela coûte-t-il par unité ? "
label var s5_9a " 509B. Combien cela coûte-t-il par unité ? "
label var s5_9b " 509C. Combien cela coûte-t-il par unité ? "
label var s5_9c " 509D. Combien cela coûte-t-il par unité ? "
label var s5_9e " 509E. Combien cela coûte-t-il par unité ? "
label var s5_9f " 509F. Combien cela coûte-t-il par unité ? "
label var s5_9g " 509G. Combien cela coûte-t-il par unité ? "
label var s5_9h " 509H. Combien cela coûte-t-il par unité ? "
label var s5_9j " 509I. Combien cela coûte-t-il par unité ? "
label var s5_9k " 509J. Combien cela coûte-t-il par unité ? "
label var s5_9l " 509K. Combien cela coûte-t-il par unité ? "
label var s501 " 501. Est-ce que cet EPS propose un service de SMNI ?  "
label var s506 " 506. L'EPS propose-t-il des services de planification familiale sur place ? "
label var s506a " 506a. Combien coûte le ticket de consultation PF ? "
label var s6_11_1 " Aiguille de Veress "
label var s6_11_10 " Chargeur d'anneaux de falope "
label var s6_11_11 " Anneau de falope "
label var s6_11_12 " Pince à dissection dentée "
label var s6_11_13 " Bistouri avec lame n° 11 "
label var s6_11_14 " Spéculum vaginal de Sim "
label var s6_11_15 " Sonde utérine "
label var s6_11_16 " Élévateur d'utérus "
label var s6_11_17 " Vulsellum "
label var s6_11_18 " Ciseaux droits "
label var s6_11_19 " Porte-aiguille "
label var s6_11_2 " Source lumineuse pour le laparoscope "
label var s6_11_20 " Pince à éponge "
label var s6_11_21 " Suture Catgut, 0 ou 00 "
label var s6_11_3 " Ampoule de rechange pour la source lumineuse "
label var s6_11_4 " Source lumineuse d'urgence pour le laparoscope "
label var s6_11_5 " Câble à fibres optiques "
label var s6_11_6 " Trocart avec canule "
label var s6_11_7 " Laparoscope opératoire ou laparocateur "
label var s6_11_8 " Bouteille de gaz carbonique "
label var s6_11_9 " Appareil d'insufflation du pneumopéritoine "
label var s6_12 " 612. Combien de kits complets de stérilisation féminine (LAP) sont disponibles dans la structure ? "
label var s6_14_1 " Drap chirurgical (serviette avec trou central) "
label var s6_14_2 " Petit bol en acier inoxydable "
label var s6_14_3 " Porte-éponge "
label var s6_14_4 " Plateau chirurgical avec couvercle (petit) "
label var s6_14_5 " Ciseaux Metazenbaum "
label var s6_14_6 " Pince à anneau de fixation du canal extra-cutané "
label var s6_14_7 " Pince à dissection vasculaire "
label var s6_14_8 " Suture non absorbable (soie 2-0) "
label var s6_14_9 " Solutions d'iodophore à 5 %. "
label var s6_15 " 615. Combien de kits complets de VSB (VASECTOMIE SANS BISTOURI) sont disponibles dans la structure sanitaire ? "
label var s6_18 " 618A. Depuis combien de semaines ce préservatif masculin n'est pas/n'a pas été disponible dans la structure sanitaire ? "
label var s6_18a " 618B. Depuis combien de semaines ce préservatif féminin n'est pas/n'a pas été disponible dans la structure sanitaire ? "
label var s6_18b " 618C. Depuis combien de semaines ce pilule contraceptive d'urgence n'est pas/n'a pas été disponible dans la structure sanitaire ? "
label var s6_18c " 618D. Depuis combien de semaines ce Injectable-Depo Provera n'est pas/n'a pas été disponible dans la structure sanitaire ? "
label var s6_18d " 618E. Depuis combien de semaines ce Injectable - Sayana Press n'est pas/n'a pas été disponible dans la structure sanitaire ? "
label var s6_18e " 618F. Depuis combien de semaines ce Implants n'est pas/n'a pas été disponible dans la structure sanitaire ? "
label var s6_18f " 618G. Depuis combien de semaines ce Pilule contraceptive orale n'est pas/n'a pas été disponible dans la structure sanitaire ? "
label var s6_18g " 618H. Depuis combien de semaines ce Pilules à base de progestérone uniquement n'est pas/n'a pas été disponible dans la structure sanitaire ? "
label var s6_18h " 618I. Depuis combien de semaines ce DIU n'est pas disponible/n'a pas été dans la structure sanitaire ? "
label var s6_18i " 618J. Depuis combien de semaines ce Anneaux tubulaires n'est pas/n'a pas été disponible dans la structure sanitaire ? "
label var s6_18j " 618K. Depuis combien de semaines ce Kits de test de grossesse n'est pas/n'a pas été disponible dans la structure sanitaire ? "
label var s6_19 " 619A. Raisons de la non-disponibilité  "
label var s6_19a " 619B. Raisons de la non-disponibilité  "
label var s6_19b " 619C. Raisons de la non-disponibilité  "
label var s6_19c " 619D. Raisons de la non-disponibilité  "
label var s6_19d " 619E. Raisons de la non-disponibilité  "
label var s6_19e " 619F. Raisons de la non-disponibilité  "
label var s6_19f " 619G. Raisons de la non-disponibilité  "
label var s6_19g " 619H. Raisons de la non-disponibilité  "
label var s6_19h " 619I. Raisons de la non-disponibilité  "
label var s6_19i " 619J. Raisons de la non-disponibilité  "
label var s6_19j " 619K. Raisons de la non-disponibilité  "
label var s6_2 " 602. Cette structure sanitaire dispose-t-elle d'un lieu d'insertion/de retrait des DIU ? "
label var s6_2_1 " Veuillez préciser le lieu "
label var s6_20 " Veuillez préciser la raison "
label var s6_20_1 " Fer et acide folique comprimé "
label var s6_20_10 " Méthylergométrine Comprimés "
label var s6_20_11 " Misoprostol comprimé/ Prostodine Injectable"
label var s6_20_12 " Sulfate de magnésium Injectable                           "
label var s6_20_13 " Bétaméthasone / Dexaméthasone Injectable "
label var s6_20_14 " Nifédipine / comprimés                               "
label var s6_20_15 " Hydralazine Injectable                 "
label var s6_20_16 " Diazepam Injectable"
label var s6_20_17 " Amoxycilline Comprimés                                 "
label var s6_20_18 " Amoxycilline Injectable                                 "
label var s6_20_19 " Ampicilline Comprimés                                "
label var s6_20_2 " Fer et acide folique injectable "
label var s6_20_20 " Ampicilline Injectable                              "
label var s6_20_21 " Tinidazole Comprimés"
label var s6_20_22 " Cloxacilline Comprimés                                "
label var s6_20_23 " Erythromycine Comprimés"
label var s6_20_24 " Gentamycine Injectable"
label var s6_20_25 " Métronidazole Comprimé "
label var s6_20_26 " Métronidazole Injectable"
label var s6_20_27 " Albendazole /Mebendazole Injectable"
label var s6_20_28 " Albendazole Sirop"
label var s6_20_29 " Dicyclomine Comprimés"
label var s6_20_3 " Sulfate de zinc                                  "
label var s6_20_30 " Paracétamol / Diclofénac (Voveran) Comprimés  "
label var s6_20_31 " Ibuprofène Comprimés                                  "
label var s6_20_32 " Paracetamol / Diclofenac Sodium (Voveran) Injectable"
label var s6_20_33 " Pommade ophtalmique au chloramphénicol"
label var s6_20_34 " Adrénaline Injectable"
label var s6_20_35 " Amikacine Injectable"
label var s6_20_36 " Xylocaïne / Lidocaïne / Linocaïne Injectable"
label var s6_20_37 " Sensorcaine Injectable"
label var s6_20_38 " Phénobarbital Injectable"
label var s6_20_39 " Phénytoïne Injectable"
label var s6_20_4 " Fer et acide folique sirop                                    "
label var s6_20_40 " Ceftriaxone sodique Injectable"
label var s6_20_41 " Cefotoxamine  Injectable"
label var s6_20_42 " Promethazine HCL Injectable"
label var s6_20_43 " Chlorure de sodium Injectable"
label var s6_20_44 " Gluconate de calcium Injectable"
label var s6_20_45 " Drotaverine Injectable"
label var s6_20_46 " Atropine Sulphate Injectable"
label var s6_20_47 " Ethamsylate  Injectable"
label var s6_20_48 " Fortwin Injectable"
label var s6_20_49 " Frusemide Injectable"
label var s6_20_5 " Vitamine A sirop"
label var s6_20_50 " Bromure de Vecoronium Injectable"
label var s6_20_51 " Pentanol de sodium Injectable"
label var s6_20_52 " Etophylline+Théophylline Injectable"
label var s6_20_53 " Demperidon goutte"
label var s6_20_54 " Bicarbonate de sodium Injectable"
label var s6_20_55 " Pommade à l'iode de povidone"
label var s6_20_56 " SRO en sachets                                "
label var s6_20_57 " Lactate de Ringer / NS / DNS (500 ml)                      "
label var s6_20_58 " Ampoules de dextrose 10 % ou 25                           "
label var s6_20_59 " Névirapine Comprimés                                 "
label var s6_20_6 " Fer Sucrose Injectable                 "
label var s6_20_60 " Névirapine Sirop             "
label var s6_20_61 " Bupivacaine Injectable                              "
label var s6_20_62 " Thitone (Pentothal) / Kétamine / Propofol Injectable "
label var s6_20_63 " Isoflurane / Enflurane / Halothane                         "
label var s6_20_64 " Colloïdes (Hemaccel /Venofundin)                        "
label var s6_20_65 " Isolyte P (fluides IV pédiatriques)                            "
label var s6_20_66 " Vaccin antitétanique injectable                                "
label var s6_20_67 " Vaccin BCG injectable                                "
label var s6_20_68 " Vaccin oral contre la polio (VPO)                                                                                           "
label var s6_20_69 " Vaccin Penta                                "
label var s6_20_7 " Oxytocine injectables (Syntocinon / Pitocin)                          "
label var s6_20_70 " Vaccin HEB0 "
label var s6_20_71 " Vaccin PNEUMO "
label var s6_20_72 " Vaccin Rotavirus "
label var s6_20_73 " Vaccin contre la rougeole Injectable"
label var s6_20_74 " Vit A Injectable"
label var s6_20_75 " Vit K Injectable"
label var s6_20_76 " Préservatifs"
label var s6_20_77 " Pilules contraceptives orales (OCP, Mala D.)  "
label var s6_20_78 " Contraceptifs injectables                "
label var s6_20_79 " DIU (cuivre T)                                "
label var s6_20_8 " Hyoscine Butyl Bromide Injectable                   "
label var s6_20_80 " Sondes urétrales                                "
label var s6_20_81 " Canules IV                                     "
label var s6_20_82 " Seringues jetables/AD                            "
label var s6_20_83 " Gants jetables                               "
label var s6_20_84 " Bandelettes d'albumine/sucre urinaire                             "
label var s6_20_85 " Kits de test de grossesse urinaire                             "
label var s6_20_86 " Coton absorbant                       "
label var s6_20_87 " Gaze absorbante                         "
label var s6_20_88 " Serviettes hygiéniques                         "
label var s6_20_89 " Gants chirurgicaux                           "
label var s6_20_9 " Methergine/ Methylergometrine Injectable                      "
label var s6_20_90 " Spiritueux chirurgicaux                           "
label var s6_20_91 " Ruban chirurgical                            "
label var s6_20_92 " Solution d'iode povidone                        "
label var s6_20_93 " Réactifs pour les anticorps ABO et Rh           "
label var s6_20_94 " Kits de test VIH"
label var s6_20_95 " Carnet de santé de la mère et du nouveau-né                                  "
label var s6_20_96 " Cartes de vaccination pour les moins de 5 ans                            "
label var s6_20_97 " Graphiques Partograph/guide de soins pour l'accouchement           "
label var s6_20a " Veuillez préciser la raison "
label var s6_20b " Veuillez préciser la raison "
label var s6_20c " Veuillez préciser la raison "
label var s6_20d " Veuillez préciser la raison "
label var s6_20e " Veuillez préciser la raison "
label var s6_20f " Veuillez préciser la raison "
label var s6_20g " Veuillez préciser la raison "
label var s6_20h " Veuillez préciser la raison "
label var s6_20i " Veuillez préciser la raison "
label var s6_20j " Veuillez préciser la raison "

label var end "Heure de fin"
label var enqueteur "Nom de l'enquêteur"
label var equipe "Veuillez choisir votre équipe"
label var s1_1 "101. Nom de la région"
label var s1_10 "110. Mail de la structure ou du responsable de la structure"
label var s1_11 "111. Estimation de la population polarisée par l'EPS"
label var s1_12 "Est-ce que la structure dispose d'un service de gynécologie-obstétrique ou maternité ?"
label var s1_13 "Est-ce que la structure dispose d'un service de pédiatrie ?"
label var s1_3 "103. Nom du district"
label var s1_4 "104. Nom du quartier"
label var s1_7 "107. Autorité de gestion / Propriété"
label var s1_8 "108. Nom du responsable de la structure"
label var s1_9 "109. Numéro de téléphone de la structure ou du responsable de la structure"
label var s6_3_11 "Plateau en acier inoxydable avec couvercle"
label var s6_3_12 "Petit bol pour la solution antiseptique"
label var s6_3_13 "Plateau réniforme (Haricots)"
label var s6_3_14 "Spéculum vaginal de Sim ou de Cusco - grand, moyen, petit"
label var s6_3_15 "Écarteur de paroi vaginale antérieure (si le spéculum de Sim est utilisé)"
label var s6_3_16 "Pince à compresse"
label var s6_3_17 "Pince à vulsellum courbée/tenaculum"
label var s6_3_18 "Sonde utérine"
label var s6_3_19 "Ciseaux de Mayo"
label var s6_3_20 "Pince droite pour artère longue (pour le retrait du DIU)"
label var s6_3_21 "Pince à artère moyenne"
label var s6_3_22 "Cotons-tiges"
label var s6_3_23 "Porte-compresse"
label var s6_3_24 "Spéculum de Sim"
label var start "Heure de début"
label var today "Date du jour"



label var s6_3_11 "Plateau en acier inoxydable avec couvercle"
label var s6_3_12 "Petit bol pour la solution antiseptique"
label var s6_3_13 "Plateau réniforme (Haricots)"
label var s6_3_14 "Spéculum vaginal de Sim ou de Cusco - grand, moyen, petit"
label var s6_3_15 "Écarteur de paroi vaginale antérieure (si le spéculum de Sim est utilisé)"
label var s6_3_16 "Pince à compresse"
label var s6_3_17 "Pince à vulsellum courbée/tenaculum"
label var s6_3_18 "Sonde uterine"
label var s6_3_19 "Ciseaux de Mayo"
label var s6_3_20 "Pince droite pour artère longue (pour le retrait du DIU)"
label var s6_3_21 "Pince à artère moyenne"
label var s6_3_22 "Cotons-tiges"
label var s6_3_23 "Porte-compresse"
label var s6_3_24 "Spéculum de Sim"
label var s6_3_26 "Plateau en acier inoxydable avec couvercle"
label var s6_3_266 "Plateau en acier inoxydable avec couvercle"
label var s6_3_27 "Petit bol pour la solution antiseptique"
label var s6_3_277 "Petit bol pour la solution antiseptique"
label var s6_3_28 "Plateau réniforme (Haricots)"
label var s6_3_288 "Plateau réniforme (Haricots)"
label var s6_3_29 "Spéculum vaginal de Sim ou de Cusco - grand, moyen, petit"
label var s6_3_299 "Spéculum vaginal de Sim ou de Cusco - grand, moyen, petit"
label var s6_3_30 "Écarteur de paroi vaginale antérieure (si le spéculum de Sim est utilisé)"
label var s6_3_300 "Écarteur de paroi vaginale antérieure (si le spéculum de Sim est utilisé)"
label var s6_3_301 "Pince à compresse"
label var s6_3_302 "Pince à vulsellum courbée/tenaculum"
label var s6_3_303 "Sonde uterine"
label var s6_3_304 "Ciseaux de Mayo"
label var s6_3_305 "Pince droite pour artère longue (pour le retrait du DIU)"
label var s6_3_306 "Pince à artère moyenne"
label var s6_3_307 "Cotons-tiges"
label var s6_3_308 "Porte-compresse"
label var s6_3_309 "Spéculum de Sim"
label var s6_3_31 "Pince à compresse"
label var s6_3_32 "Pince à vulsellum courbée/tenaculum"
label var s6_3_33 "Sonde uterine"
label var s6_3_34 "Ciseaux de Mayo"
label var s6_3_35 "Pince droite pour artère longue (pour le retrait du DIU)"
label var s6_3_36 "Pince à artère moyenne"
label var s6_3_37 "Cotons-tiges"
label var s6_3_38 "Porte-compresse"
label var s6_3_39 "Spéculum de Sim"
label var s6_3_40 "Plateau en acier inoxydable avec couvercle"
label var s6_3_41 "Petit bol pour la solution antiseptique"
label var s6_3_42 "Plateau réniforme (Haricots)"
label var s6_3_43 "Spéculum vaginal de Sim ou de Cusco - grand, moyen, petit"
label var s6_3_44 "Écarteur de paroi vaginale antérieure (si le spéculum de Sim est utilisé)"
label var s6_3_45 "Pince à compresse"
label var s6_3_46 "Pince à vulsellum courbée/tenaculum"
label var s6_3_47 "Sonde uterine"
label var s6_3_48 "Ciseaux de Mayo"
label var s6_3_49 "Pince droite pour artère longue (pour le retrait du DIU)"
label var s6_3_50 "Pince à artère moyenne"
label var s6_3_51 "Cotons-tiges"
label var s6_3_52 "Porte-compresse"
label var s6_3_53 "Spéculum de Sim"


label var s6_4_11 " 604.a. Le coton-tige stérile sec est-il disponibles et fonctionnels dans la salle de travail ? "
label var s6_4_12 " 604.b. Les gants (gants chirurgicaux stériles/désinfectés à haut niveau ou gants d'examen) sont-ils disponibles et fonctionnels dans la salle de travail ? "
label var s6_4_21 " 604.a. Le coton-tige stérile sec est-il disponibles et fonctionnels dans le coin PF/DIU ? "
label var s6_4_21a " 604.a. Le coton-tige stérile sec est-il disponibles et fonctionnels dans l'autre lieu ? "
label var s6_4_22 " 604.b. Les gants (gants chirurgicaux stériles/désinfectés à haut niveau ou gants d'examen) sont-ils disponibles et fonctionnels dans le coin PF/DIU ? "
label var s6_4_22a " 604.b. Les gants (gants chirurgicaux stériles/désinfectés à haut niveau ou gants d'examen) sont-ils disponibles et fonctionnels dans l'autre lieu ? "
label var s6_5 " 605. Combien de kits complets de DIU sont disponibles dans la structure sanitaire ? "
label var s6_7 " 616A. Ce préservatif masculin est-il disponible ?  "
label var s6_7a " 616B. Ce préservatif féminin est-il disponible ?  "
label var s6_7b " 616C. Ce pilule contraceptive d'urgence est-il disponible ?  "
label var s6_7c " 616D. Ce Injectable-Depo Provera est-il disponible ?  "
label var s6_7d " 616E. Ce Injectable - Sayana Press est-il disponible ?  "
label var s6_7e " 616F. Ce Implants est-il disponible ?  "
label var s6_7f " 616G. Ce Pilule contraceptive orale est-il disponible ?  "
label var s6_7g " 616H. Ce Pilules à base de progestérone uniquement est-il disponible ?  "
label var s6_7h " 616I. Ce DIU est-il disponible ?  "
label var s6_7i " 616J. Ce Anneaux tubulaires est-il disponible ?  "
label var s6_7j " 616K. Ce Kits de test de grossesse est-il disponible ?  "
label var s6_8 " 617A. Ce préservatif masculin a-t-il été en rupture de stock au cours des trois derniers mois ? "
label var s6_8_1 " Pince à éponge "
label var s6_8_10 " Porte-aiguille "
label var s6_8_11 " Ciseaux droits "
label var s6_8_12 " Ciseaux courbes "
label var s6_8_13 " Pince de Babcock (taille moyenne) "
label var s6_8_14 " Petite pince de Langenbeck (abdominale à angle droit) "
label var s6_8_15 " Pince à dissection dentée "
label var s6_8_16 " Pince à dissection non dentée "
label var s6_8_17 " Élévateur d'utérus (pour la procédure d'intervalle) "
label var s6_8_18 " Spéculum vaginal, moyen de Sim "
label var s6_8_19 " Petit bol en acier inoxydable "
label var s6_8_2 " Drap chirurgical (serviette avec trou central) "
label var s6_8_20 " Vulsellum "
label var s6_8_21 " Crochet tubaire "
label var s6_8_22 " Catgut chromique en « O "
label var s6_8_23 " Petite aiguille courbe à corps rond "
label var s6_8_24 " Petite aiguille coupante "
label var s6_8_25 " Matériel de suture non absorbable "
label var s6_8_26 " Plateau rénal en acier inoxydable "
label var s6_8_3 " Seringue, 10 cc "
label var s6_8_4 " Aiguille, 22G, 1V2 "
label var s6_8_5 " Bistouri "
label var s6_8_6 " Lame de bistouri taille 15 "
label var s6_8_7 " Pince d'Allis "
label var s6_8_8 " Pince pour artères moyennes droite "
label var s6_8_9 " Pince pour artères moyennes courbée "
label var s6_8a " 617B. Ce préservatif féminin a-t-il été en rupture de stock au cours des trois derniers mois ? "
label var s6_8b " 617C. Ce pilule contraceptive d'urgence a-t-il été en rupture de stock au cours des trois derniers mois ? "
label var s6_8c " 617D. Ce Injectable-Depo Provera a-t-il été en rupture de stock au cours des trois derniers mois ? "
label var s6_8d " 617E. Ce Injectable - Sayana Press a-t-il été en rupture de stock au cours des trois derniers mois ? "
label var s6_8e " 617F. Ce Implants a-t-il été en rupture de stock au cours des trois derniers mois ? "
label var s6_8f " 617G. Ce Pilule contraceptive orale a-t-il été en rupture de stock au cours des trois derniers mois ? "
label var s6_8g " 617H. Ce Pilules à base de progestérone uniquement a-t-il été en rupture de stock au cours des trois derniers mois ? "
label var s6_8h " 617I. Ce DIU a-t-il été en rupture de stock au cours des trois derniers mois ? "
label var s6_8i " 617J. Ce Anneaux tubulaires a-t-il été en rupture de stock au cours des trois derniers mois ? "
label var s6_8j " 617K. Ce Kits de test de grossesse a-t-il été en rupture de stock au cours des trois derniers mois ? "
label var S6_9 " 609. Combien de kits complets de Mini Lap sont disponibles dans l'établissement ? "
label var s7_1 " 701. Cet EPS dispose-t-il d'un espace privé pour les conseils en matière de PF ? "
label var s7_2 " 702. Un conseiller en PF est-il disponible ? "
label var s7_3 " 703. Le conseil en PF est-il dispensé par une autre personne que le conseiller ?  "
label var s7_4 " 704. Les femmes atteintes du VIH/SIDA bénéficient-elles de conseils en matière de PF dans le cadre de la prévention de la transmission mère-enfant (PTME) ? "
label var s7_5 " 705. Cet EPS offre-t-elle des conseils en matière de PF aux adolescents ? "
label var s7_6_1 " Panneaux d'orientation "
label var s7_6_10 " Stock de préservatifs (féminins) "
label var s7_6_2 " Paravent médical "
label var s7_6_3 " Armoire d'arrangement "
label var s7_6_4 " Table "
label var s7_6_5 " Chaise "
label var s7_6_6 " Registre des dossiers des clients "
label var s7_6_7 " Stock de pilules contraceptives oraux "
label var s7_6_8 " Stock de pilules contraceptives d'urgence "
label var s7_6_9 " Stock de préservatifs (masculins) "
label var s7_7_1 " Échantillons de pilules OCP pour démonstration "
label var s7_7_2 " Échantillons de DIU pour démonstration "
label var s7_7_3 " Échantillons de préservatifs pour démonstration "
label var s7_7_4 " Modèle de pénis pour démonstration "
label var s7_7_5 " Boite à image pour le conseil "
label var s7_7_6 " Roue MEC (Ordinogramme) "
label var s7_8_1 " DIU "
label var s7_8_2 " Préservatif "
label var s7_8_3 " Planning familial post-avortement "
label var s7_8_4 " Planning familial post-partum "
label var s7_8_5 " Contraceptifs injectables "
label var s7_8_6 " Implants "
label var s7_8_7 " Pilules Contraceptives Orales "
label var s7_8_8 " Stérilisation féminine "
label var s7_8_9 " Stérilisation masculine "
label var start " Heure de début "
label var today " Date du jour "



************************  DISPONIBILITÉ DES SERVICES DE PF************



label var s506	"506. L'EPS propose-t-il des services de planification familiale sur place ?"
label var s506a	"506a. Combien coûte le ticket de consultation PF ?"


label define s506 1 "Oui" 2 "Non"
label val    s506 s506

replace s506a = . if s506a == 9999


label var s5_7	"507A. A quelle fréquence La pilule est-il fourni ?"
label var s5_8	"508A. La pilule est-il fournie gratuitement ?"
label var s5_9	"509A. Combien cela coûte-t-il par unité ?"
label var s5_10	"510A. Raisons de la non-disponibilité de La pilule"

label define s5_7    1 "Quotidien" 2 "Hebdomadaire" 3 "Tous les quinze jours" 4 "Mensuel" 5 "Pas du tout"
label val    s5_7 s5_7



label var s5_7a	   "507B. A quelle fréquence l'injectable est-il fourni ?"
label var s5_8a	   "508B. L'injectable est-il fournie gratuitement ?"
label var s5_9a	   "509B. Combien cela coûte-t-il par unité ?"
label var s5_10a   "510B. Raisons de la non-disponibilité de l'injectable"


label define s5_7a 1 "Quotidien" 2 "Hebdomadaire" 3 "Tous les quinze jours" 4 "Mensuel" 5 "Pas du tout"
label val  s5_7a s5_7a	   


label var s5_7b	 "507C. A quelle fréquence le préservatif masculin est-il fourni ?"
label var s5_8b	 "508C. Le préservatif masculin est-il fournie gratuitement ?"
label var s5_9b	 "509C. Combien cela coûte-t-il par unité ?"
label var s5_10b "510C. Raisons de la non-disponibilité du préservatif masculin"

label define s5_7b 1 "Quotidien" 2 "Hebdomadaire" 3 "Tous les quinze jours" 4 "Mensuel" 5 "Pas du tout"
label val  s5_7b s5_7b

label var  s5_7c	"507D. A quelle fréquence le préservatif féminin est-il fourni ?"
label var  s5_8c	"508D. Le préservatif féminin est-il fournie gratuitement ?"
label var  s5_9c	"509D. Combien cela coûte-t-il par unité ?"
label var  s5_10c	"510D. Raisons de la non-disponibilité du préservatif féminin"


label define s5_7c 1 "Quotidien" 2 "Hebdomadaire" 3 "Tous les quinze jours" 4 "Mensuel" 5 "Pas du tout"
label val s5_7c s5_7c


label var s5_7e	"507E. A quelle fréquence la contraception d'urgence est-il fourni ?"
label var s5_8e	"508E. La contraception d'urgence est-il fournie gratuitement ?"
label var s5_9e	"509E. Combien cela coûte-t-il par unité ?"
label var s5_10e	"510E. Raisons de la non-disponibilité de la contraception d'urgence"


label define s5_7e 1 "Quotidien" 2 "Hebdomadaire" 3 "Tous les quinze jours" 4 "Mensuel" 5 "Pas du tout"
label val s5_7e s5_7e


label var s5_7f	  "507F. A quelle fréquence le DIU est-il fourni ?"
label var s5_8f	  "508F. Le DIU est-il fournie gratuitement ?"
label var s5_9f	  "509F. Combien cela coûte-t-il par unité ?"
label var s5_10f  "510F. Raisons de la non-disponibilité du DIU"


label define s5_7f 1 "Quotidien" 2 "Hebdomadaire" 3 "Tous les quinze jours" 4 "Mensuel" 5 "Pas du tout"
label val s5_7f s5_7f



label var s5_7g	"507G. A quelle fréquence l'implant est-il fourni ?"
label var s5_8g	"508G. L'implant est-il fournie gratuitement ?"
label var s5_9g	"509G. Combien cela coûte-t-il par unité ?"
label var s5_10g "510G. Raisons de la non-disponibilité de l'implant"


label define s5_7g 1 "Quotidien" 2 "Hebdomadaire" 3 "Tous les quinze jours" 4 "Mensuel" 5 "Pas du tout"
label val s5_7g s5_7g



label var s5_7h	  "507H. A quelle fréquence la stérilisation féminine (Ligature des trompes) est-il fourni ?"
label var s5_8h	  "508H. La stérilisation féminine (Ligature des trompes) est-il fournie gratuitement ?"
label var s5_9h	  "509H. Combien cela coûte-t-il par unité ?"
label var s5_10h  "510H. Raisons de la non-disponibilité de la stérilisation féminine (Ligature des trompes)"


label define s5_7h 1 "Quotidien" 2 "Hebdomadaire" 3 "Tous les quinze jours" 4 "Mensuel" 5 "Pas du tout"
label val s5_7h s5_7h



label var s5_7j	    "507I. A quelle fréquence la stérilisation masculine/Vasectomie est-il fourni ?"
label var s5_8j	    "508I. La stérilisation masculine/vasectomie est-il fournie gratuitement ?"
label var s5_9j	    "509I. Combien cela coûte-t-il par unité ?"
label var s5_10j	"510I. Raisons de la non-disponibilité de la stérilisation masculine/Vasectomie"


label define s5_7j 1 "Quotidien" 2 "Hebdomadaire" 3 "Tous les quinze jours" 4 "Mensuel" 5 "Pas du tout"
label val s5_7j	 s5_7j	



label var s5_7k	"507J. A quelle fréquence l'allaitement maternel exclusif (MAMA) est-il fourni ?"
label var s5_8k	"508J. L'allaitement maternel exclusif (MAMA) est-il fournie gratuitement ?"
label var s5_9k	"509J. Combien cela coûte-t-il par unité ?"
label var  s5_10k	"510J. Raisons de la non-disponibilité de l'allaitement maternel exclusif (MAMA)"



label define s5_7k  1 "Quotidien" 2 "Hebdomadaire" 3 "Tous les quinze jours" 4 "Mensuel" 5 "Pas du tout"
label val s5_7k s5_7k



label var s5_7l	  "507K. A quelle fréquence la méthode des jours fixes (MJF) est-il fourni ?"
label var s5_8l	  "508K. La méthode des jours fixes (MJF) est-il fournie gratuitement ?"
label var s5_9l	  "509K. Combien cela coûte-t-il par unité ?"
label var s5_10l   "510K. Raisons de la non-disponibilité de la méthode des jours fixes (MJF)"


label define s5_7l 1 "Quotidien" 2 "Hebdomadaire" 3 "Tous les quinze jours" 4 "Mensuel" 5 "Pas du tout"
label val s5_7l	 s5_7l	

************************* Cascade of availability


******************************** Pillule ********************
**** Providing 
gen  pillule_indisp=0
replace pillule_indisp = 1 if s5_7!=5
replace pillule_indisp = 0 if s5_7==.
label define pillule_indisp 1 "Pilule disponible" 0 "Pilule non-disponible"
label val pillule_indisp  pillule_indisp 

**** In stock
label define s6_7f 1	"En stock et observé" 2	"En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
label values s6_7f s6_7f

label define s6_7g 1	"En stock et observé" 2	"En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
label values s6_7g s6_7g

gen  pillule_stock=0
replace pillule_stock = 1 if (s6_7f == 1 | s6_7f == 2)|(s6_7g == 1 | s6_7g == 2)&pillule_indisp == 1
replace pillule_stock = 0 if (s6_7f==.) & (s6_7g==.)
label define pillule_stock 1 "Pilule stock" 0 "Pilule not in stock"
label val pillule_stock pillule_stock


tabout  pillule_indisp hf_type  using "table_provision_availability.xls", append c(col) npos(both) nlab(Number) ///
h1() f(1.0) h3(nil) per show(none) style(tab) 
 
tabout   pillule_stock  hf_type  using "table_provision_availability.xls", append c(col) npos(both) nlab(Number) 



******************************** Injectable ********************
**** Providing 

gen  injectable_indisp=0
replace injectable_indisp = 1 if  s5_7a!=5
replace injectable_indisp= 0 if  s5_7a ==.
label define injectable_indisp 1 "Injectable disponible" 0 "Injectable non-disponible"
label val injectable_indisp  injectable_indisp 


**** In stock
label define s6_7c 1	"En stock et observé" 2	"En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
label values s6_7c s6_7c

label define s6_7d 1	"En stock et observé" 2	"En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
label values s6_7d s6_7d

gen  injectable_stock=0
replace injectable_stock = 1 if (s6_7c == 1 | s6_7c == 2)|(s6_7d == 1 | s6_7d == 2)& injectable_indisp==1
replace injectable_stock = 0 if (s6_7c==.) & (s6_7d ==.)
label define injectable_stock 1 "Injectable stock" 0 "Injectable not in stock"
label val injectable_stock injectable_stock


tabout  injectable_indisp hf_type  using "table_provision_availability.xls", append c(col) npos(both) nlab(Number) ///
h1() f(1.0) h3(nil) per show(none) style(tab) 
 
tabout   injectable_stock  hf_type  using "table_provision_availability.xls", append c(col) npos(both) nlab(Number)



******************************** condom_M ********************
**** Providing 

gen  condom_M_indisp=0
replace condom_M_indisp = 1 if  s5_7b!=5
replace condom_M_indisp= 0  if  s5_7b ==.
label define condom_M_indisp  1 "Condom_M disponible" 0 "Condom_M non-disponible"
label val condom_M_indisp condom_M_indisp


**** In stock
label define s6_7 1	"En stock et observé" 2	"En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
label values s6_7 s6_7

gen  condom_M_stock=0
replace condom_M_stock = 1 if (s6_7 == 1 | s6_7 == 2)&condom_M_indisp==1
replace condom_M_stock = 0 if (s6_7==.) 
label define condom_M_stock 1 "condom_M stock" 0 "condom_M not in stock"
label val condom_M_stock condom_M_stock

tabout  condom_M_indisp hf_type  using "table_provision_availability.xls", append c(col) npos(both) nlab(Number) ///
h1() f(1.0) h3(nil) per show(none) style(tab) 
 
tabout  condom_M_stock  hf_type  using "table_provision_availability.xls", append c(col) npos(both) nlab(Number)

******************************** condom_F ********************
**** Providing 

gen  condom_F_indisp=0
replace condom_F_indisp = 1 if  s5_7c!=5
replace condom_F_indisp= 0  if  s5_7c ==.
label define condom_F_indisp  1 "Condom_F disponible" 0 "Condom_M non-disponible"
label val condom_F_indisp condom_F_indisp


**** In stock
label define s6_7a 1	"En stock et observé" 2	"En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
label values s6_7a s6_7a

gen  condom_F_stock=0
replace condom_F_stock = 1 if (s6_7a == 1 | s6_7a == 2)&condom_F_indisp==1
replace condom_F_stock = 0 if (s6_7a==.) 
label define condom_F_stock 1 "condom_F stock" 0 "condom_F not in stock"
label val condom_F_stock condom_F_stock


tabout  condom_F_indisp hf_type  using "table_provision_availability.xls", append c(col) npos(both) nlab(Number) ///
h1() f(1.0) h3(nil) per show(none) style(tab) 
 
tabout  condom_F_stock  hf_type  using "table_provision_availability.xls", append c(col) npos(both) nlab(Number)


******************************emergencypills ********************
**** Providing 

gen  emergencypills_indisp=0
replace emergencypills_indisp = 1 if  s5_7e!=5
replace emergencypills_indisp= 0  if  s5_7e ==.
label define emergencypills_indisp  1 "emergencypills disponible" 0 "emergencypills non-disponible"
label val emergencypills_indisp emergencypills_indisp


**** In stock
label define s6_7b 1	"En stock et observé" 2	"En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
label values s6_7b s6_7b

gen  emergencypills_stock=0
replace emergencypills_stock = 1 if (s6_7b == 1 | s6_7b == 2)&emergencypills_indisp==1
replace emergencypills_stock = 0 if (s6_7b==.) 
label define emergencypills_stock 1 "emergencypills stock" 0 "emergencypills not in stock"
label val emergencypills_stock emergencypills_stock 

tabout  emergencypills_indisp hf_type  using "table_provision_availability.xls", append c(col) npos(both) nlab(Number) ///
h1() f(1.0) h3(nil) per show(none) style(tab) 
 
tabout  emergencypills_stock  hf_type  using "table_provision_availability.xls", append c(col) npos(both) nlab(Number)

******************************IUD ********************
**** Providing 

gen  dui_indisp=0
replace dui_indisp = 1 if  s5_7f!=5
replace dui_indisp = 0  if  s5_7f ==.
label define dui_indisp  1 "dui disponible" 0 "dui non-disponible"
label val dui_indisp dui_indisp


**** In stock
label define s6_7h 1	"En stock et observé" 2	"En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
label values s6_7h s6_7h

gen  dui_stock=0
replace dui_stock = 1 if (s6_7h == 1 | s6_7h == 2)& dui_indisp==1
replace dui_stock = 0 if (s6_7h==.) 
label define dui_stock   1 "dui stock" 0 "dui not in stock"
label val dui_stock  dui_stock 

**** All items available

gen all_iud_avail=0
replace all_iud_avail=1 if (s6_3_11==1 | s6_3_266==1| s6_3_26==1 | s6_3_40==1) & ( s6_3_12==1 | s6_3_277==1 | s6_3_27==1 | s6_3_41==1) & ( s6_3_13==1 | s6_3_288==1 | s6_3_28==1 | s6_3_42==1) & ( s6_3_14==1 | s6_3_299==1 | s6_3_29==1 | s6_3_43==1) & ( s6_3_15==1 |  s6_3_300==1 |  s6_3_30==1 |  s6_3_44==1) & (s6_3_16==1 |  s6_3_301==1 |  s6_3_31==1 |   s6_3_45==1) & ( s6_3_17==1 | s6_3_302==1 | s6_3_32==1 | s6_3_46==1) & ( s6_3_18==1 |  s6_3_303==1 |  s6_3_33==1 |  s6_3_47==1) & ( s6_3_19==1 | s6_3_304==1 | s6_3_34==1 | s6_3_48==1) & ( s6_3_20==1 |  s6_3_305==1 | s6_3_35==1 | s6_3_49==1) & ( s6_3_21==1 |  s6_3_306==1 |  s6_3_36==1 |  s6_3_50==1) & ( s6_3_22==1 |   s6_3_307==1 |   s6_3_37==1 |   s6_3_51==1) & (s6_3_23==1 | s6_3_308==1 | s6_3_38==1 | s6_3_52==1) & ( s6_3_24==1 |   s6_3_309==1 |   s6_3_39==1 |   s6_3_53==1) & (s6_4_11==1 | s6_4_21 == 1 | s6_4_21a ==1) &  (s6_4_12 == 1 | s6_4_22==1 | s6_4_22a==1)&dui_indisp==1 & dui_stock==1
*replace all_iud_avail=. if hf_type == 3 | hf_type == 4

label def all_iud_avail 0 "Not all iud item" 1 "All iud item fonctionnel"

label values all_iud_avail all_iud_avail



tabout  dui_indisp hf_type  using "table_provision_availability.xls", append c(col) npos(both) nlab(Number) ///
h1() f(1.0) h3(nil) per show(none) style(tab) 
 
tabout  dui_stock  hf_type  using "table_provision_availability.xls", append c(col) npos(both) nlab(Number)

tabout  all_iud_avail  hf_type  using "table_provision_availability.xls", append c(col) npos(both) nlab(Number)


****************************** implant ********************
**** Providing 

gen  implant_indisp=0
replace implant_indisp = 1 if  s5_7g!=5
replace implant_indisp = 0  if  s5_7g ==.
label define implant_indisp  1 "implant disponible" 0 "implant non-disponible"
label val implant_indisp implant_indisp


**** In stock
label define s6_7e 1	"En stock et observé" 2	"En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
label values s6_7e s6_7e

gen  implant_stock=0
replace implant_stock = 1 if (s6_7e == 1 | s6_7e == 2) &implant_indisp==1
replace implant_stock = 0 if (s6_7e==.) 
label define implant_stock   1 "implant stock" 0 "implant not in stock"
label val implant_stock  implant_stock 

tabout  implant_indisp hf_type  using "table_provision_availability.xls", append c(col) npos(both) nlab(Number) ///
h1() f(1.0) h3(nil) per show(none) style(tab) 
 
tabout  implant_stock hf_type  using "table_provision_availability.xls", append c(col) npos(both) nlab(Number)



****************************** sterelizationF ********************
**** Providing 

gen  sterelizationF_indisp=0
replace sterelizationF_indisp = 1 if  s5_7h!=5
replace sterelizationF_indisp = 0  if  s5_7h ==.
label define sterelizationF_indisp  1 "sterelizationF disponible" 0 "sterelizationF non-disponible"
label val sterelizationF_indisp sterelizationF_indisp

**** In stock
gen  sterelizationF_stock=0
replace sterelizationF_stock = 1 if (s6_7i == 1 | s6_7i == 2) & (sterelizationF_indisp==1)
replace sterelizationF_stock = 0 if (s6_7i == .) 
label define sterelizationF_stock   1 "sterelizationF stock" 0 "sterelizationF not in stock"
label val sterelizationF_stock  sterelizationF_stock 


***** All items 
gen all_sterelizationF_avail=0
replace all_sterelizationF_avail=1 if (s6_8_1==1 & s6_8_2==1 & s6_8_3 ==1 & s6_8_4 ==1 & s6_8_5 ==1 & s6_8_6==1 & s6_8_7==1 & s6_8_8==1 & s6_8_9==1 & s6_8_10==1 & s6_8_11==1 & s6_8_12==1 & s6_8_13==1 & s6_8_14==1 & s6_8_15==1 & s6_8_16==1 & s6_8_17==1 & s6_8_18==1 & s6_8_19==1 & s6_8_20==1 & s6_8_21==1 & s6_8_22==1 & s6_8_23==1 & s6_8_24==1 & s6_8_25==1 & s6_8_26)|(s6_11_1==1 & s6_11_2==1 & s6_11_3==1 & s6_11_4==1 & s6_11_5==1 & s6_11_6==1 & s6_11_7==1 & s6_11_8==1 & s6_11_9==1 & s6_11_10==1 & s6_11_11==1 & s6_11_12==1 & s6_11_13==1 & s6_11_14==1 & s6_11_15==1 & s6_11_16==1 & s6_11_17==1 & s6_11_18==1 & s6_11_19==1 & s6_11_20==1 & s6_11_21) & sterelizationF_indisp==1 & sterelizationF_stock==1
replace all_sterelizationF_avail=0 if sterelizationF_stock == 0 | sterelizationF_indisp==0


label define all_sterelizationF_avail   1 "all sterelizationF avail and func" 0 "not all functional"
label val all_sterelizationF_avail all_sterelizationF_avail


tabout  sterelizationF_indisp hf_type using "table_provision_availability.xls", append c(col) npos(both) nlab(Number) ///
h1() f(1.0) h3(nil) per show(none) style(tab) 
 
tabout  sterelizationF_stock  hf_type  using "table_provision_availability.xls", append c(col) npos(both) nlab(Number)

tabout all_sterelizationF_avail  hf_type  using "table_provision_availability.xls", append c(col) npos(both) nlab(Number)


****************************** sterelizationM ********************
**** Providing 

gen     sterelizationM_indisp=0
replace sterelizationM_indisp = 1 if  s5_7j!=5
replace sterelizationM_indisp = 0  if  s5_7j==.
label define sterelizationM_indisp  1 "sterelizationM disponible" 0 "sterelizationM non-disponible"
label val sterelizationM_indisp sterelizationM_indisp

gen all_sterelizationM_avail=0
replace all_sterelizationM_avail=1 if s6_14_1 ==1 & s6_14_2==1 & s6_14_3==1 & s6_14_4==1 & s6_14_5==1 & s6_14_6==1 & s6_14_7==1 & s6_14_8==1 & s6_14_9 & sterelizationM_indisp==1



label define all_sterelizationM_avail   1 "all sterelizationM avail and func" 0 "not all functional"
label val all_sterelizationM_avail all_sterelizationM_avail



tabout  sterelizationM_indisp hf_type using "table_provision_availability.xls", append c(col) npos(both) nlab(Number) ///
h1() f(1.0) h3(nil) per show(none) style(tab) 
 

tabout all_sterelizationM_avail hf_type  using "table_provision_availability.xls", append c(col) npos(both) nlab(Number)


****************************** MaMa ********************
**** Providing 

gen     mama_indisp=0
replace mama_indisp = 1 if  s5_7k!=5
replace mama_indisp = 0  if  s5_7k==.
label define mama_indisp  1 "mama disponible" 0 "mama non-disponible"
label val mama_indisp mama_indisp


tabout  mama_indisp hf_type using "table_provision_availability.xls", append c(col) npos(both) nlab(Number) ///
h1() f(1.0) h3(nil) per show(none) style(tab) 
 



****************************** MJF ********************
**** Providing 

gen     mjf_indisp=0
replace mjf_indisp = 1 if   s5_7l!=5
replace mjf_indisp = 0  if  s5_7l==.
label define mjf_indisp  1 "mjf disponible" 0 "mjf non-disponible"
label val mjf_indisp mjf_indisp


tabout   mjf_indisp hf_type using "table_provision_availability.xls", append c(col) npos(both) nlab(Number) ///
h1() f(1.0) h3(nil) per show(none) style(tab) 


************************** Avalability of mix methods *********************

/*
This reflects the percentage
of all facilities that provide FP services with at least one short-acting, one long-acting or permanent, and
one barrier or nonhormonal method. Short-acting methods include pills, injectables, or the emergency
contraceptive pill. For this category, the method must be provided and available at the time of the survey.
Long-acting and permanent methods include implants or IUDs, which the facility states are provided and
the observer notes are in stock and not expired, or male or female sterilization, which the facility states are
routinely provided. Barrier or nonhormonal methods include condom (male or female) or cycle beads for
Standard Days Method.
*/


* Short-acting methods include pills, injectables, or the emergencycontraceptive pill

gen short_acting = 0
replace short_acting = 1 if (pillule_indisp == 1 & pillule_stock == 1) | (injectable_indisp==1 & injectable_stock == 1) | (emergencypills_indisp==1 & emergencypills_stock == 1) | (pillule_indisp == 1 & pillule_stock == 1)
label define short_acting 0 "No Short_acting" 1 "Short_acting"
label values short_acting short_acting

*Long-acting and permanent methods include implants or IUDs, which the facility states are provided and the observer notes are in stock and not expired, or male or female sterilization, which the facility states are routinely provided.

gen long_acting = 0
replace long_acting = 1 if (dui_indisp == 1 & dui_stock == 1) | (implant_indisp==1 & implant_stock==1) | (sterelizationF_indisp == 1 & sterelizationF_stock == 1) | (sterelizationM_indisp == 1) 
label define long_acting 0 "No long_acting" 1 "long_acting"
label values long_acting long_acting


* Barrier or nonhormonal methods include condom (male or female) or cycle beads for Standard Days Method.

gen barrier_methods = 0
replace barrier_methods = 1 if (condom_F_indisp == 1 & condom_F_stock == 1) | (condom_M_indisp==1 & condom_M_stock == 1) | (mjf_indisp == 1) 
label define barrier_methods 0 "No barries methods" 1 "barrier methods"
label values barrier_methods barrier_methods


***Mix methods *********************************


gen mix_methods = 0
replace mix_methods  = 1 if (short_acting == 1 & long_acting == 1 & barrier_methods == 1) 
label define mix_methods  0 "No mix method" 1 "has a mix methods"
label values mix_methods  mix_methods 


tabout  short_acting  hf_type using "table_MIX.xls", append c(col) npos(both) nlab(Number) ///
h1() f(1.0) h3(nil) per show(none) style(tab) 
 
tabout  long_acting  hf_type  using "table_MIX.xls", append c(col) npos(both) nlab(Number)

tabout barrier_methods  hf_type  using "table_MIX.xls", append c(col) npos(both) nlab(Number)

tabout mix_methods  hf_type  using "table_MIX.xls", append c(col) npos(both) nlab(Number)

************ Raisons de non indisponibilité ***********

 label var s5_10_1 "Pas de prestataires formés"
 label var s5_10_2 "fournitures non disponibles"
 label var s5_10_3 "infrastructure non disponible"
 label var s5_10_4 "Le client ne veut pas"
 label var s5_10_5 "Autres"
 
label define s5_10_1 1 "oui" 2 "non"
label define s5_10_2 1 "oui" 2 "non"
label define s5_10_3 1 "oui" 2 "non"
label define s5_10_4 1 "oui" 2 "non"
label define s5_10_5 1 "oui" 2 "non"

tabout   s5_10_1 s5_10_2 s5_10_3 s5_10_4 s5_10_5 hf_type  using "table_nondisponible_reasons.xls", append c(col) npos( both) nlab(Number) ///
h1(pilule) f(1.0) h3(nil) per show(none) style(tab)



 label var s5_10a_1 "Pas de prestataires formés"
 label var s5_10a_2 "fournitures non disponibles"
 label var s5_10a_3 "infrastructure non disponible"
 label var s5_10a_4 "Le client ne veut pas"
 label var s5_10a_5 "Autres"
 
label define s5_10a_1 1 "oui" 2 "non"
label define s5_10a_2 1 "oui" 2 "non"
label define s5_10a_3 1 "oui" 2 "non"
label define s5_10a_4 1 "oui" 2 "non"
label define s5_10a_5 1 "oui" 2 "non"

tabout   s5_10a_1 s5_10a_2 s5_10a_3 s5_10a_4 s5_10a_5 hf_type  using "table_nondisponible_reasons.xls", append c(col) npos( both) nlab(Number) ///
h1(injectable) f(1.0) h3(nil) per show(none) style(tab)


label var  s5_10b_1 "Pas de prestataires formés"
 label var s5_10b_2 "fournitures non disponibles"
 label var s5_10b_3 "infrastructure non disponible"
 label var s5_10b_4 "Le client ne veut pas"
 label var s5_10b_5 "Autres"
 
label define s5_10b_1 1 "oui" 2 "non"
label define s5_10b_2 1 "oui" 2 "non"
label define s5_10b_3 1 "oui" 2 "non"
label define s5_10b_4 1 "oui" 2 "non"
label define s5_10b_5 1 "oui" 2 "non"

tabout   s5_10b_1 s5_10b_2 s5_10b_3 s5_10b_4 s5_10b_5 hf_type  using "table_nondisponible_reasons.xls", append c(col) npos( both) nlab(Number) ///
h1(condom_M) f(1.0) h3(nil) per show(none) style(tab)


label var s5_10c_1 "Pas de prestataires formés"
 label var s5_10c_2 "fournitures non disponibles"
 label var s5_10c_3 "infrastructure non disponible"
 label var s5_10c_4 "Le client ne veut pas"
 label var s5_10c_5 "Autres"
 
label define s5_10c_1 1 "oui" 2 "non"
label define s5_10c_2 1 "oui" 2 "non"
label define s5_10c_3 1 "oui" 2 "non"
label define s5_10c_4 1 "oui" 2 "non"
label define s5_10c_5 1 "oui" 2 "non"


tabout    s5_10c_1 s5_10c_2 s5_10c_3 s5_10c_4 s5_10c_5 hf_type  using "table_nondisponible_reasons.xls", append c(col) npos( both) nlab(Number) ///
h1(condom_F) f(1.0) h3(nil) per show(none) style(tab)

  
  
label var s5_10e_1 "Pas de prestataires formés"
 label var s5_10e_2 "fournitures non disponibles"
 label var s5_10e_3 "infrastructure non disponible"
 label var s5_10e_4 "Le client ne veut pas"
 label var s5_10e_5 "Autres"
 
label define s5_10e_1 1 "oui" 2 "non"
label define s5_10e_2 1 "oui" 2 "non"
label define s5_10e_3 1 "oui" 2 "non"
label define s5_10e_4 1 "oui" 2 "non"
label define s5_10e_5 1 "oui" 2 "non"

tabout    s5_10e_1 s5_10e_2 s5_10e_3 s5_10e_4 s5_10e_5 hf_type  using "table_nondisponible_reasons.xls", append c(col) npos( both) nlab(Number) ///
h1(emergencypills) f(1.0) h3(nil) per show(none) style(tab)


label var s5_10f_1 "Pas de prestataires formés"
 label var s5_10f_2 "fournitures non disponibles"
 label var s5_10f_3 "infrastructure non disponible"
 label var s5_10f_4 "Le client ne veut pas"
 label var s5_10f_5 "Autres"
 
label define s5_10f_1 1 "oui" 2 "non"
label define s5_10f_2 1 "oui" 2 "non"
label define s5_10f_3 1 "oui" 2 "non"
label define s5_10f_4 1 "oui" 2 "non"
label define s5_10f_5 1 "oui" 2 "non"

tabout    s5_10f_1 s5_10f_2 s5_10f_3 s5_10f_4 s5_10f_5 hf_type  using "table_nondisponible_reasons.xls", append c(col) npos( both) nlab(Number) ///
h1(dui) f(1.0) h3(nil) per show(none) style(tab)

     

label var s5_10g_1 "Pas de prestataires formés"
 label var s5_10g_2 "fournitures non disponibles"
 label var s5_10g_3 "infrastructure non disponible"
 label var s5_10g_4 "Le client ne veut pas"
 label var s5_10g_5 "Autres"
 
label define s5_10g_1 1 "oui" 2 "non"
label define s5_10g_2 1 "oui" 2 "non"
label define s5_10g_3 1 "oui" 2 "non"
label define s5_10g_4 1 "oui" 2 "non"
label define s5_10g_5 1 "oui" 2 "non"

tabout  s5_10g_1 s5_10g_2 s5_10g_3 s5_10g_4 s5_10g_5 hf_type  using "table_nondisponible_reasons.xls", append c(col) npos( both) nlab(Number) ///
h1(implant) f(1.0) h3(nil) per show(none) style(tab)


label var s5_10h_1 "Pas de prestataires formés"
 label var s5_10h_2 "fournitures non disponibles"
 label var s5_10h_3 "infrastructure non disponible"
 label var s5_10h_4 "Le client ne veut pas"
 label var s5_10h_5 "Autres"
 
label define s5_10h_1 1 "oui" 2 "non"
label define s5_10h_2 1 "oui" 2 "non"
label define s5_10h_3 1 "oui" 2 "non"
label define s5_10h_4 1 "oui" 2 "non"
label define s5_10h_5 1 "oui" 2 "non"

tabout   s5_10h_1 s5_10h_2 s5_10h_3 s5_10h_4 s5_10h_5 hf_type  using "table_nondisponible_reasons.xls", append c(col) npos( both) nlab(Number) ///
h1(sterelizationF) f(1.0) h3(nil) per show(none) style(tab)

label var s5_10j_1 "Pas de prestataires formés"
 label var s5_10j_2 "fournitures non disponibles"
 label var s5_10j_3 "infrastructure non disponible"
 label var s5_10j_4 "Le client ne veut pas"
 label var s5_10j_5 "Autres"
 
label define s5_10j_1 1 "oui" 2 "non"
label define s5_10j_2 1 "oui" 2 "non"
label define s5_10j_3 1 "oui" 2 "non"
label define s5_10j_4 1 "oui" 2 "non"
label define s5_10j_5 1 "oui" 2 "non"

tabout   s5_10j_1 s5_10j_2 s5_10j_3 s5_10j_4 s5_10j_5 hf_type  using "table_nondisponible_reasons.xls", append c(col) npos( both) nlab(Number) ///
h1(sterelizationM) f(1.0) h3(nil) per show(none) style(tab)

 
 
label var s5_10k_1 "Pas de prestataires formés"
 label var s5_10k_2 "fournitures non disponibles"
 label var s5_10k_3 "infrastructure non disponible"
 label var s5_10k_4 "Le client ne veut pas"
 label var s5_10k_5 "Autres"
 
label define s5_10k_1 1 "oui" 2 "non"
label define s5_10k_2 1 "oui" 2 "non"
label define s5_10k_3 1 "oui" 2 "non"
label define s5_10k_4 1 "oui" 2 "non"
label define s5_10k_5 1 "oui" 2 "non"


tabout   s5_10k_1 s5_10k_2 s5_10k_3 s5_10k_4 s5_10k_5 hf_type  using "table_nondisponible_reasons.xls", append c(col) npos( both) nlab(Number) ///
h1(mama) f(1.0) h3(nil) per show(none) style(tab)
 
  


label var s5_10l_1 "Pas de prestataires formés"
 label var s5_10l_2 "fournitures non disponibles"
 label var s5_10l_3 "infrastructure non disponible"
 label var s5_10l_4 "Le client ne veut pas"
 label var s5_10l_5 "Autres"
 
label define s5_10l_1 1 "oui" 2 "non"
label define s5_10l_2 1 "oui" 2 "non"
label define s5_10l_3 1 "oui" 2 "non"
label define s5_10l_4 1 "oui" 2 "non"
label define s5_10l_5 1 "oui" 2 "non"


tabout   s5_10l_1 s5_10l_2 s5_10l_3 s5_10l_4 s5_10l_5 hf_type  using "table_nondisponible_reasons.xls", append c(col) npos( both) nlab(Number) ///
h1(tubal ring) f(1.0) h3(nil) per show(none) style(tab)


************************* Disponibilité SMNI *********************
 ***********501A. Services de CPN
 label var s5_2_cpn	    "502. A quelle fréquence les CPN sont-elles fournies ?"
 label var s5_3_cpn	    "503a. Le ticket de CPN est-il fourni gratuitement ?"
 label var s5_3_cpna	"503b. Les services paracliniques disponibles (CPN) sont-ils fourni gratuitement ?"
 label var s5_4_cpn	    "504a. Combien cela coûte-t-il par unité (le ticket de CPN) ?"
 label var s5_4_cpna	"504b. Combien cela coûte-t-il dans l'ensemble (les services paracliniques disponibles) ?"
 label var s5_5_cpn	    "505. Raisons de la non-disponibilité du service de CPN"
 label var  s5_5_cpn_autre	"Préciser autre raison de la non disponibilité du service de CPN"
 
 label define s5_2_cpn 1 "Régulièrement" 2 "Occasionnellement" 3 "Pas du tout"
 label values s5_2_cpn s5_2_cpn
 
 
 
 label var	s_cpn_C 	"Prise de poids"
 label var	s_cpn_D 	"Mesure de la tension artérielle"
 label var	s_cpn_E 	"Examen de l'abdomen"
 label var	s_cpn_F 	"Traitement des signes de danger"
 label var	s_cpn_G 	"Supplémentation en fer acide folique"
 label var	s_cpn_H 	"Réalisation d'un test d'hémoglobines"
 label var	s_cpn_I 	"Recherche d'albumine dans les urines"
 label var	s_cpn_J 	"Recherche de sucre dans les urines"
 label var	s_cpn_K 	"Test de grossesse"
 label var	s_cpn_L 	"Vaccination contre le tétanos "
 label var	s_cpn_M 	"Groupage sanguin"
 label var	s_cpn_N 	"Détermination du facteur Rhésus"
 label var	s_cpn_O 	"Test de dépistage de la syphilis effectué"
 label var	s_cpn_P 	"Test de dépistage du VIH effectué"
 label var	s_cpn_Q	    "Prélévement vaginal effectué"
 label var	s_cpn_R	    "Déparasitage"
 label var	s_cpn_S	    "Prise en charge des complications de la grossesse"
 label var	s_cpn_T	    "Prise en charge de l'anémie sévère"
 label var	s_cpn_U 	"Conseils en nutrition"
 label var	s_cpn_V 	"Conseils de préparation à l'accouchement" 
 label var	s_cpn_W 	"Conseils sur l'avortement sécurisé"
 label var	s_cpn_X 	"Conseils en PF"
 label var	s_cpn_Y	    "Conseils sur l'accouchement  en structure sanitaire" 

 label define	s_cpn_C 	1 "Oui"	2 "Non"
 label define	s_cpn_D 	1 "Oui"	2 "Non"
 label define	s_cpn_E 	1 "Oui"	2 "Non"
 label define	s_cpn_F 	1 "Oui"	2 "Non"
 label define	s_cpn_G 	1 "Oui"	2 "Non"
 label define	s_cpn_H 	1 "Oui"	2 "Non"
 label define	s_cpn_I 	1 "Oui"	2 "Non"
 label define	s_cpn_J 	1 "Oui"	2 "Non"
 label define	s_cpn_K 	1 "Oui"	2 "Non"
 label define	s_cpn_L 	1 "Oui"	2 "Non"
 label define	s_cpn_M 	1 "Oui"	2 "Non"
 label define	s_cpn_N 	1 "Oui"	2 "Non"
 label define	s_cpn_O 	1 "Oui"	2 "Non"
 label define	s_cpn_P 	1 "Oui"	2 "Non"
 label define	s_cpn_Q 	1 "Oui"	2 "Non"
 label define	s_cpn_R	    1 "Oui"	2 "Non"
 label define	s_cpn_S	    1 "Oui"	2 "Non"
 label define	s_cpn_T	    1 "Oui"	2 "Non"
 label define	s_cpn_U 	1 "Oui"	2 "Non"
 label define	s_cpn_V 	1 "Oui"	2 "Non"
 label define	s_cpn_W 	1 "Oui"	2 "Non"
 label define	s_cpn_X 	1 "Oui"	2 "Non"
 label define	s_cpn_Y	    1 "Oui"	2 "Non"
 
 label val	s_cpn_C 	s_cpn_C 
label val	s_cpn_D 	s_cpn_D 
label val	s_cpn_E 	s_cpn_E 
label val	s_cpn_F 	s_cpn_F 
label val	s_cpn_G 	s_cpn_G 
label val	s_cpn_H 	s_cpn_H 
label val	s_cpn_I 	s_cpn_I 
label val	s_cpn_J 	s_cpn_J 
label val	s_cpn_K 	s_cpn_K 
label val	s_cpn_L 	s_cpn_L 
label val	s_cpn_M 	s_cpn_M 
label val	s_cpn_N 	s_cpn_N 
label val	s_cpn_O 	s_cpn_O 
label val	s_cpn_P 	s_cpn_P 
label val	s_cpn_Q	    s_cpn_Q
label val	s_cpn_R	    s_cpn_R
label val	s_cpn_S	    s_cpn_S
label val	s_cpn_T	    s_cpn_T
label val	s_cpn_U 	s_cpn_U 
label val	s_cpn_V 	s_cpn_V 
label val	s_cpn_W 	s_cpn_W 
label val	s_cpn_X 	s_cpn_X 
label val	s_cpn_Y	    s_cpn_Y

 
**************  501B. Services d'accouchement
label var s5_2_acc	"502. A quelle fréquence ces services d'accouchement sont-ils fournis ?"

label var  s5_3_acc	   "503a. Ce service d'accouchement (accouchement par voie basse : Ticket + Kit d'accouchement + Episiotomie) est-il fourni gratuitement ?"
label var  s5_3_acca	"503b. Ce service d'accouchement (accouchement par césarienne) est-il fourni gratuitement ?"
label var  s5_4_acc1	"504a. Combien cela coûte-t-il par unité (accouchement par voie basse) ?"
label var  s5_4_acc2	"504b. Combien cela coûte-t-il par unité (accouchement par césarienne) ?"
label var  s5_5_acc	    "505. Raisons de la non-disponibilité du service d'accouchement"
label var  s5_5_acc_autre	"Préciser autre raison de la non disponibilité du service d'accouchement"

 label define s5_2_acc 1 "Régulièrement" 2 "Occasionnellement" 3 "Pas du tout"
 label values s5_2_acc s5_2_acc

label var	s_acc_1 	"Accouchement normal"
label var	s_acc_2 	"Utilisation du partogramme"
label var	s_acc_3 	"Gestion active de la troisième phase du travail (GATPA)"
label var	s_acc_4 	"Prise en charge de l'éclampsie"
label var	s_acc_5 	"Prise en charge de la pré-éclampsie"
label var	s_acc_6 	"Prise en charge de l'HPP"
label var	s_acc_7  	"Accouchement assisté (ventouse/forceps)"
label var	s_acc_8 	"Épisiotomie et suture Déchirure cervicale"
label var	s_acc_9	    "Antibiotiques IM/IV"
label var	s_acc_10 	"Furosémide IV"
label var	s_acc_11 	"Sulfate de magnésium injectable"
label var	s_acc_12 	"Tocolytiques pour le travail prématuré"
label var	s_acc_13 	"Stéroïdes pour le travail prématuré"
label var	s_acc_14 	"Retrait manuel du placenta"
label var	s_acc_15 	"Transfusion sanguine"
label var	s_acc_16	"Césarienne"


lab def	s_acc_1 	1 "Oui"	2 "Non"
lab def	s_acc_2 	1 "Oui"	2 "Non"
lab def	s_acc_3 	1 "Oui"	2 "Non"
lab def	s_acc_4 	1 "Oui"	2 "Non"
lab def	s_acc_5 	1 "Oui"	2 "Non"
lab def	s_acc_6 	1 "Oui"	2 "Non"
lab def	s_acc_7  	1 "Oui"	2 "Non"
lab def	s_acc_8 	1 "Oui"	2 "Non"
lab def	s_acc_9	    1 "Oui"	2 "Non"
lab def	s_acc_10 	1 "Oui"	2 "Non"
lab def	s_acc_11 	1 "Oui"	2 "Non"
lab def	s_acc_12 	1 "Oui"	2 "Non"
lab def	s_acc_13 	1 "Oui"	2 "Non"
lab def	s_acc_14 	1 "Oui"	2 "Non"
lab def	s_acc_15 	1 "Oui"	2 "Non"
lab def	s_acc_16	1 "Oui"	2 "Non"


label val	s_acc_1 	s_acc_1 
label val	s_acc_2 	s_acc_2 
label val	s_acc_3 	s_acc_3 
label val	s_acc_4 	s_acc_4 
label val	s_acc_5 	s_acc_5 
label val	s_acc_6 	s_acc_6 
label val	s_acc_7	    s_acc_7
label val	s_acc_8 	s_acc_8 
label val	s_acc_9	    s_acc_9
label val	s_acc_10 	s_acc_10 
label val	s_acc_11 	s_acc_11 
label val	s_acc_12 	s_acc_12 
label val	s_acc_13 	s_acc_13 
label val	s_acc_14 	s_acc_14 
label val	s_acc_15 	s_acc_15 
label val	s_acc_16	s_acc_16




**************  501C. Services postnatals
label var  s5_2_pnat	"502. A quelle fréquence ce service postnatal est-il fourni ?"
label var  s5_3_pnat	"503. Ce service postnatal est-il fourni gratuitement ?"
label var  s5_4_pnat	"504. Combien cela coûte-t-il par unité ?"
label var  s5_5_pnat	"505. Raisons de la non-disponibilité du service postnatal"
label var  s5_5_pnat_autre	"Préciser autre raison de la non disponibilité du service postnatal"

 label define s5_2_pnat 1 "Régulièrement" 2 "Occasionnellement" 3 "Pas du tout"
 label values s5_2_pnat s5_2_pnat
 
lab var	 s_pnat_1	"Utilisation systématique d'utérotoniques"
lab var	 s_pnat_2 	"Estimation de la perte de sang"
lab var	 s_pnat_3 	"Massage utérin en cas d'hémorragie grave"
lab var	 s_pnat_4 	"Mise en place immédiate de l'allaitement"
lab var	 s_pnat_5	"Prise en charge des complications du post-partum précoce"

lab def 	 s_pnat_1	1 "Oui"	2 "Non"
lab def 	 s_pnat_2 	1 "Oui"	2 "Non"
lab def 	 s_pnat_3 	1 "Oui"	2 "Non"
lab def 	 s_pnat_4 	1 "Oui"	2 "Non"
lab def 	 s_pnat_5	1 "Oui"	2 "Non"


lab val	 s_pnat_1	 s_pnat_1
lab val	 s_pnat_2 	 s_pnat_2 
lab val	 s_pnat_3 	 s_pnat_3 
lab val	 s_pnat_4 	 s_pnat_4 
lab val	 s_pnat_5	 s_pnat_5





*************   501D. Services essentiels aux nouveau-nés et post-natal
label var s5_2_nne	"502. A quelle fréquence ces services essentiels aux nouveau-nés sont-ils fournis ?"
label var s5_3_nne	"503. Ces services essentiels aux nouveau-nés est-il fourni gratuitement ?"
label var s5_4_nne	"504. Combien cela coûte-t-il par unité ?"
label var s5_5_nne	"505. Raisons de la non-disponibilité des services essentiels aux nouveau-nés"
label var s5_5_nne_autre	"Préciser autre raison de la non disponibilité des services essentiels aux nouveau-nés"

 label define  s5_2_nne 1 "Régulièrement" 2 "Occasionnellement" 3 "Pas du tout"
 label values  s5_2_nne  s5_2_nne

lab var	s_nne_1 	"Réanimation néonatale"
lab var	s_nne_2 	"Corticostéroïdes anténatals pour la mère"
lab var	s_nne_3 	"Vitamine K pour les prématurés"
lab var	s_nne_4 	"Pesée du nouveau-né"
lab var	s_nne_5 	"Soins du cordon propre"
lab var	s_nne_6 	"Emollients/Collyres"
lab var	s_nne_7 	"Vaccination au jour zéro : BCG"
lab var	s_nne_8 	"Vaccination au jour zéro : VPO"
lab var	s_nne_9	    "Vaccination au jour zéro : HEBz"

lab def 	s_nne_1 	1 "Oui"	2 "Non"
lab def 	s_nne_2 	1 "Oui"	2 "Non"
lab def 	s_nne_3 	1 "Oui"	2 "Non"
lab def 	s_nne_4 	1 "Oui"	2 "Non"
lab def 	s_nne_5 	1 "Oui"	2 "Non"
lab def 	s_nne_6 	1 "Oui"	2 "Non"
lab def 	s_nne_7 	1 "Oui"	2 "Non"
lab def 	s_nne_8 	1 "Oui"	2 "Non"
lab def 	s_nne_9	    1 "Oui"	2 "Non"

lab val	s_nne_1 	s_nne_1 
lab val	s_nne_2 	s_nne_2 
lab val	s_nne_3 	s_nne_3 
lab val	s_nne_4 	s_nne_4 
lab val	s_nne_5 	s_nne_5 
lab val	s_nne_6 	s_nne_6 
lab val	s_nne_7 	s_nne_7 
lab val	s_nne_8 	s_nne_8 
lab val	s_nne_9	    s_nne_9
 




*********************** Services post-avortement

label var s5_2_avo	       "502. A quelle fréquence ce service post-avortement est-il fourni ?"
label var s5_3_avo	       "503. Ce service post-avortement est-il fourni gratuitement ?"
label var s5_4_avo	       "504. Combien cela coûte-t-il par unité ?"
label var s5_5_avo	       "505. Raisons de la non-disponibilité du service post-avortement"
label var s5_5_avo_autre   "Préciser autre raison de la non disponibilité du service post-avortement"

 label define   s5_2_avo 1 "Régulièrement" 2 "Occasionnellement" 3 "Pas du tout"
 label values   s5_2_avo  s5_2_avo

 
 
lab var	s_avo_1 	"D & C (dilatation et curetage)"
lab var	s_avo_2 	"MVA (aspiration manuelle sous vide)"
lab var	s_avo_3	    "Prise en charge des complications de l'avortement"


lab def 	s_avo_1 	1 "Oui"	2 "Non"
lab def 	s_avo_2 	1 "Oui"	2 "Non"
lab def 	s_avo_3	    1 "Oui"	2 "Non"

lab val	s_avo_1 	s_avo_1 
lab val	s_avo_2 	s_avo_2 
lab val	s_avo_3	  s_avo_3


********************  Services de santé néonatales et infantiles
label var s5_2_sinf	"502. A quelle fréquence ces services de santé néonatales et infantiles sont-ils fournis ?"
label var s5_3_sinf	"503. Ces services de santé infantiles est-il fourni gratuitement ?"
label var s5_4_sinf	"504. Combien cela coûte-t-il par unité ?"
label var s5_5_sinf	"505. Raisons de la non-disponibilité des services de santé néonatales et infantiles"
label var s5_5_sinf_autre	"Préciser autre raison de la non disponibilité des services de santé néonatales et infantiles"

 label define   s5_2_sinf 1 "Régulièrement" 2 "Occasionnellement" 3 "Pas du tout"
 label values  s5_2_sinf s5_2_sinf

lab var	 s_inf_1 	"Utilisation de la fiche de croissance pour l'enregistrement du poids"
lab var	 s_inf_2 	"Immunisation des enfants"
lab var	 s_inf_3 	"Prise en charge de la pneumonie"
lab var	 s_inf_4 	"Antibiotiques pour les infections respiratoires aiguës"
lab var	 s_inf_5 	"Prise en charge de la déshydratation/diarrhée"
lab var	 s_inf_6 	"Mesure du poids"
lab var	 s_inf_7	"Mesure de la taille"
lab var	 s_inf_8	"Prise en charge des nouveau-nés malades"
lab var	 s_inf_9 	"Prise en charge des nouveau-nés atteints d'un faible poids de naissance"
lab var	 s_inf_10	"Prise en charge des nouveau-nés prématurés"
lab var	 s_inf_11 	"Dépistage des anomalies congénitales chez les nouveaux nés"
lab var	 s_inf_12	"Alimentation par voie nasogastrique chez les nouveaux nés"
lab var	 s_inf_13 	"Stabilisation du nourrisson malade"
lab var	 s_inf_14	"Soins en cas d'hyperbilirubinémie (ictère) chez les nouveaux nés"

lab def	 s_inf_1 	1 "Oui"	2 "Non"
lab def	 s_inf_2 	1 "Oui"	2 "Non"
lab def	 s_inf_3 	1 "Oui"	2 "Non"
lab def	 s_inf_4 	1 "Oui"	2 "Non"
lab def	 s_inf_5 	1 "Oui"	2 "Non"
lab def	 s_inf_6 	1 "Oui"	2 "Non"
lab def	 s_inf_7	1 "Oui"	2 "Non"
lab def	 s_inf_8	1 "Oui"	2 "Non"
lab def	 s_inf_9 	1 "Oui"	2 "Non"
lab def	 s_inf_10	1 "Oui"	2 "Non"
lab def	 s_inf_11 	1 "Oui"	2 "Non"
lab def	 s_inf_12	1 "Oui"	2 "Non"
lab def	 s_inf_13 	1 "Oui"	2 "Non"
lab def	 s_inf_14	1 "Oui"	2 "Non"


lab val	 s_inf_1 	 s_inf_1 
lab val	 s_inf_2 	 s_inf_2 
lab val	 s_inf_3 	 s_inf_3 
lab val	 s_inf_4 	 s_inf_4 
lab val	 s_inf_5 	 s_inf_5 
lab val	 s_inf_6 	 s_inf_6 
lab val	 s_inf_7	 s_inf_7
lab val	 s_inf_8	 s_inf_8
lab val	 s_inf_9 	 s_inf_9 
lab val	 s_inf_10	 s_inf_10
lab val	 s_inf_11 	 s_inf_11 
lab val	 s_inf_12	 s_inf_12
lab val	 s_inf_13 	 s_inf_13 
lab val	 s_inf_14	 s_inf_14







******************************************  Non disponibilité ********************

************ CPN
gen  cpn_indisp = 1 if s5_2_cpn == 3
replace pillule_indisp = 0 if s5_2_cpn!=3 & s5_2_cpn!=.
replace pillule_indisp = . if s5_2_cpn  ==.
label define cpn_indisp 0 "cpn_disponible" 1 "cpn non-disponible"
label val cpn_indisp cpn_indisp



*** Accouchement

gen  acc_indisp = 1 if s5_2_acc == 3
replace acc_indisp = 0 if s5_2_acc!=3 & s5_2_acc!=.
replace acc_indisp = . if s5_2_acc  ==.
label define acc_indisp 0 "acc_disponible" 1 "acc non-disponible"
label val acc_indisp acc_indisp


*** Postnatal

gen  post_indisp = 1 if s5_2_pnat == 3
replace post_indisp = 0 if s5_2_pnat!=3 & s5_2_pnat!=.
replace post_indisp = . if s5_2_pnat  ==.
label define post_indisp 0 "post_disponible" 1 "post non-disponible"
label val post_indisp post_indisp



*** SESS

gen  nne_indisp = 1 if s5_2_nne == 3
replace post_indisp = 0 if s5_2_nne!=3 & s5_2_nne!=.
replace nne_indisp = . if s5_2_nne  ==.
label define nne_indisp 0 "nne_disponible" 1 "nne non-disponible"
label val nne_indisp nne_indisp

*** Avortement

gen  avor_indisp = 1 if s5_2_avo == 3
replace avor_indisp = 0 if s5_2_avo!=3 & s5_2_avo!=.
replace avor_indisp = . if s5_2_avo==.
label define avor_indisp 0 "avor_disponible" 1 "avor non-disponible"
label val avor_indisp avor_indisp


*** . Services de santé néonatales et infantiles

gen  inf_indisp = 1 if s5_2_sinf == 3
replace inf_indisp = 0 if s5_2_sinf!=3 & s5_2_sinf!=.
replace inf_indisp  = . if s5_2_sinf==.
label define inf_indisp 0 "inf_disponible" 1 "inf non-disponible"
label val inf_indisp inf_indisp



tabout    cpn_indisp acc_indisp post_indisp nne_indisp avor_indisp inf_indisp hf_type  using "table_nondisponible_SMNI.xls", append c(col) npos( both) nlab(Number) ///
h1(tubal ring) f(1.0) h3(nil) per show(none) style(tab)




***********************  Raisons  


lab var	 s5_5_cpn_1 	"Aucun personnel qualifié disponible"	
lab var	 s5_5_cpn_2	    "fournitures non disponible"
lab var	 s5_5_cpn_3 	"infrastructure non disponible"	
lab var	 s5_5_cpn_4 	"Le client ne veut pas"
lab var	 s5_5_cpn_5	    "Autres (précisez"	
			
			
lab def 	 s5_5_cpn_1 	1 "Oui"	2 "Non"
lab def 	 s5_5_cpn_2	1 "Oui"	2 "Non"
lab def 	 s5_5_cpn_3 	1 "Oui"	2 "Non"
lab def 	 s5_5_cpn_4 	1 "Oui"	2 "Non"
lab def 	 s5_5_cpn_5	1 "Oui"	2 "Non"
			
lab val	 s5_5_cpn_1 	 s5_5_cpn_1 	
lab val	 s5_5_cpn_2	 s5_5_cpn_2	
lab val	 s5_5_cpn_3 	 s5_5_cpn_3 	
lab val	 s5_5_cpn_4 	 s5_5_cpn_4 	
lab val	 s5_5_cpn_5	 s5_5_cpn_5	

/*
tabout  s5_5_cpn_1 s5_5_cpn_2 s5_5_cpn_3 s5_5_cpn_4 s5_5_cpn_5  hf_type  using "table_nondisponible_reasons_SMNI.xls", append c(col) npos( both) nlab(Number) ///
h1(CPN) f(1.0) h3(nil) per show(none) style(tab)
*/





***************** Accouchement
lab var	 s5_5_acc_1 	"Aucun personnel qualifié disponible"
lab var	 s5_5_acc_2 	"fournitures non disponibles"	
lab var	 s5_5_acc_3 	"infrastructure non disponible"	
lab var	 s5_5_acc_4 	"Le client ne veut pas"	
lab var	 s5_5_acc_5	    "Autres (précisez"	
			
			
lab def 	 s5_5_acc_1 	1 "Oui"	2 "Non"
lab def 	 s5_5_acc_2 	1 "Oui"	2 "Non"
lab def 	 s5_5_acc_3 	1 "Oui"	2 "Non"
lab def 	 s5_5_acc_4 	1 "Oui"	2 "Non"
lab def 	 s5_5_acc_5	1 "Oui"	2 "Non"
			
lab val	 s5_5_acc_1 	 s5_5_acc_1
lab val	 s5_5_acc_2 	 s5_5_acc_2
lab val	 s5_5_acc_3 	 s5_5_acc_3	
lab val	 s5_5_acc_4 	 s5_5_acc_4	
lab val	 s5_5_acc_5	     s5_5_acc_5

/*
tabout     s5_5_acc_1 s5_5_acc_2 s5_5_acc_3 s5_5_acc_4 s5_5_acc_5 hf_type  using "table_nondisponible_reasons_SMNI.xls", append c(col) npos( both) nlab(Number) ///
h1(accouchementy) f(1.0) h3(nil) per show(none) style(tab)
*/



**************** Postnatal

lab var	 s5_5_pnat_1 	"Aucun personnel qualifié disponible"	
lab var	 s5_5_pnat_2 	"fournitures non disponibles"
lab var	 s5_5_pnat_3 	"infrastructure non disponible"
lab var	 s5_5_pnat_4 	"Le client ne veut pas"
lab var	 s5_5_pnat_5	"Autres (précisez"	
			
			
lab def 	 s5_5_pnat_1 	1 "Oui"	2 "Non"
lab def 	 s5_5_pnat_2 	1 "Oui"	2 "Non"
lab def 	 s5_5_pnat_3 	1 "Oui"	2 "Non"
lab def 	 s5_5_pnat_4 	1 "Oui"	2 "Non"
lab def 	 s5_5_pnat_5	1 "Oui"	2 "Non"
			
lab val	 s5_5_pnat_1 	 s5_5_pnat_1	
lab val	 s5_5_pnat_2 	 s5_5_pnat_2
lab val	 s5_5_pnat_3 	 s5_5_pnat_3	
lab val	 s5_5_pnat_4 	 s5_5_pnat_4 	
lab val	 s5_5_pnat_5	 s5_5_pnat_5

/*
tabout   s5_5_pnat_1 s5_5_pnat_2 s5_5_pnat_3 s5_5_pnat_4 s5_5_pnat_5 hf_type  using "table_nondisponible_reasons_SMNI.xls", append c(col) npos( both) nlab(Number) ///
h1(postnatal) f(1.0) h3(nil) per show(none) style(tab)
*/

*******************  NNE


lab var	s5_5_nne_1 	"Aucun personnel qualifié disponible"	
lab var	s5_5_nne_2 	"fournitures non disponibles"
lab var	s5_5_nne_3	"infrastructure non disponible"	
lab var	s5_5_nne_4 	"Le client ne veut pas"	
lab var	s5_5_nne_5	"Autres (précisez"	
			
			
lab def 	s5_5_nne_1 	1 "Oui"	2 "Non"
lab def 	s5_5_nne_2 	1 "Oui"	2 "Non"
lab def 	s5_5_nne_3	1 "Oui"	2 "Non"
lab def 	s5_5_nne_4 	1 "Oui"	2 "Non"
lab def 	s5_5_nne_5	1 "Oui"	2 "Non"
			
lab val	s5_5_nne_1 	 s5_5_nne_1
lab val	s5_5_nne_2 	 s5_5_nne_2	
lab val	s5_5_nne_3	 s5_5_nne_3 	
lab val	s5_5_nne_4 	 s5_5_nne_4
lab val	s5_5_nne_5	 s5_5_nne_5

/*
tabout   s5_5_nne_1 s5_5_nne_2 s5_5_nne_3 s5_5_nne_4 s5_5_nne_5  hf_type  using "table_nondisponible_reasons_SMNI.xls", append c(col) npos( both) nlab(Number) ///
h1(NNE) f(1.0) h3(nil) per show(none) style(tab)
*/



************** Avortement

lab var	 s5_5_avo_1	"Aucun personnel qualifié disponible"	
lab var	 s5_5_avo_2	"fournitures non disponibles"
lab var	 s5_5_avo_3	"infrastructure non disponible"	
lab var	 s5_5_avo_4 "Le client ne veut pas"	
lab var	 s5_5_avo_5	"Autres (précisez"	
			
			
lab def 	 s5_5_avo_1	1 "Oui"	2 "Non"
lab def 	 s5_5_avo_2	1 "Oui"	2 "Non"
lab def 	 s5_5_avo_3	1 "Oui"	2 "Non"
lab def 	 s5_5_avo_4 	1 "Oui"	2 "Non"
lab def 	 s5_5_avo_5	1 "Oui"	2 "Non"
			
lab val	 s5_5_avo_1	 s5_5_avo_1 	
lab val	 s5_5_avo_2	 s5_5_avo_2	
lab val	 s5_5_avo_3	 s5_5_avo_3 	
lab val	 s5_5_avo_4  s5_5_avo_4
lab val	 s5_5_avo_5	 s5_5_avo_5


tabout     s5_5_avo_1 s5_5_avo_2 s5_5_avo_3 s5_5_avo_4 s5_5_avo_5 hf_type  using "table_nondisponible_reasons_SMNI.xls", append c(col) npos( both) nlab(Number) ///
h1(avortement) f(1.0) h3(nil) per show(none) style(tab)

 
******************** Infantile

lab var	s5_5_sinf_1 	"Aucun personnel qualifié disponible"	
lab var	 s5_5_sinf_2 	"fournitures non disponibles"	
lab var	 s5_5_sinf_3 	"infrastructure non disponible"	
lab var	 s5_5_sinf_4 	"Le client ne veut pas"	
lab var	 s5_5_sinf_5	"Autres (précisez"	
			
			
lab def 	 s5_5_sinf_1 	1 "Oui"	2 "Non"
lab def 	 s5_5_sinf_2 	1 "Oui"	2 "Non"
lab def 	 s5_5_sinf_3 	1 "Oui"	2 "Non"
lab def 	 s5_5_sinf_4 	1 "Oui"	2 "Non"
lab def 	 s5_5_sinf_5	1 "Oui"	2 "Non"
			
lab val	 s5_5_sinf_1 	s5_5_sinf_1 	
lab val	 s5_5_sinf_2 	 s5_5_sinf_2 	
lab val	 s5_5_sinf_3 	 s5_5_sinf_3 	
lab val	 s5_5_sinf_4 	 s5_5_sinf_4 	
lab val	 s5_5_sinf_5	 s5_5_sinf_5	


tabout    s5_5_sinf_1 s5_5_sinf_2 s5_5_sinf_3 s5_5_sinf_4 s5_5_sinf_5 hf_type  using "table_nondisponible_reasons_SMNI.xls", append c(col) npos( both) nlab(Number) ///
h1(Infantile) f(1.0) h3(nil) per show(none) style(tab)





