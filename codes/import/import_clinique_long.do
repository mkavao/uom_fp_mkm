* import_clinique_corr.do
*
* 	Imports and aggregates "QUESTIONNAIRE CLINIQUE PRIVEE" (ID: clinique_corr) data.
*
*	Inputs:  "F:/Dropbox_APHRC/Dropbox/FP-Project-APHRC-UM/Atelier_FP/Data/raw/QUESTIONNAIRE CLINIQUE PRIVEE.csv"
*	Outputs: "F:/Dropbox_APHRC/Dropbox/FP-Project-APHRC-UM/Atelier_FP/Data/raw/QUESTIONNAIRE CLINIQUE PRIVEE.dta"
*
*	Output by SurveyCTO March 26, 2025 5:39 PM.

* initialize Stata
clear all
set more off
set mem 100m

* initialize workflow-specific parameters
*	Set overwrite_old_data to 1 if you use the review and correction
*	workflow and allow un-approving of submissions. If you do this,
*	incoming data will overwrite old data, so you won't want to make
*	changes to data in your local .dta file (such changes can be
*	overwritten with each new import).
local overwrite_old_data 0

* initialize form-specific parameters
local csvfile "F:/Dropbox_APHRC/Dropbox/FP-Project-APHRC-UM/Atelier_FP/Data/raw/QUESTIONNAIRE CLINIQUE PRIVEE.csv"
local dtafile "F:/Dropbox_APHRC/Dropbox/FP-Project-APHRC-UM/Atelier_FP/Data/raw/clinic_main_long_raw.dta"
local corrfile "F:/Dropbox_APHRC/Dropbox/FP-Project-APHRC-UM/Atelier_FP/Data/raw/QUESTIONNAIRE CLINIQUE PRIVEE_corrections.csv"
local note_fields1 ""
local text_fields1 "s1_4 s1_8 s1_10 s4_1_2 personnel_count servi_smni s_cpn s5_5_cpn s5_5_cpn_autre s_acc s5_5_acc s5_5_acc_autre s_pnat s5_5_pnat s5_5_pnat_autre s_nne s5_5_nne s5_5_nne_autre s_avo s5_5_avo"
local text_fields2 "s5_5_avo_autre s_inf s5_5_sinf s5_5_sinf_autre s5_10 s5_10_autre s5_10a s5_10_autrea s5_10b s5_10_autreb s5_10c s5_10_autrec s5_10e s5_10_autree s5_10f s5_10_autref s5_10g s5_10_autreg s5_10h"
local text_fields3 "s5_10_autreh s5_10j s5_10_autrej s5_10k s5_10_autrek s5_10l s5_10_autrel s6_2 s6_2_1 s6_19 s6_20 s6_19a s6_20a s6_19b s6_20b s6_19c s6_20c s6_19d s6_20d s6_19e s6_20e s6_19f s6_20f s6_19g s6_20g"
local text_fields4 "s6_19h s6_20h s6_19i s6_20i s6_19j s6_20j obs instanceid"
local date_fields1 "today"
local datetime_fields1 "submissiondate start end"

disp
disp "Starting import of: `csvfile'"
disp

* import data from primary .csv file
insheet using "`csvfile'", names clear

* drop extra table-list columns
cap drop reserved_name_for_field_*
cap drop generated_table_list_lab*

* continue only if there's at least one row of data to import
if _N>0 {
	* drop note fields (since they don't contain any real data)
	forvalues i = 1/100 {
		if "`note_fields`i''" ~= "" {
			drop `note_fields`i''
		}
	}
	
	* format date and date/time fields
	forvalues i = 1/100 {
		if "`datetime_fields`i''" ~= "" {
			foreach dtvarlist in `datetime_fields`i'' {
				cap unab dtvarlist : `dtvarlist'
				if _rc==0 {
					foreach dtvar in `dtvarlist' {
						tempvar tempdtvar
						rename `dtvar' `tempdtvar'
						gen double `dtvar'=.
						cap replace `dtvar'=clock(`tempdtvar',"MDYhms",2025)
						* automatically try without seconds, just in case
						cap replace `dtvar'=clock(`tempdtvar',"MDYhm",2025) if `dtvar'==. & `tempdtvar'~=""
						format %tc `dtvar'
						drop `tempdtvar'
					}
				}
			}
		}
		if "`date_fields`i''" ~= "" {
			foreach dtvarlist in `date_fields`i'' {
				cap unab dtvarlist : `dtvarlist'
				if _rc==0 {
					foreach dtvar in `dtvarlist' {
						tempvar tempdtvar
						rename `dtvar' `tempdtvar'
						gen double `dtvar'=.
						cap replace `dtvar'=date(`tempdtvar',"MDY",2025)
						format %td `dtvar'
						drop `tempdtvar'
					}
				}
			}
		}
	}

	* ensure that text fields are always imported as strings (with "" for missing values)
	* (note that we treat "calculate" fields as text; you can destring later if you wish)
	tempvar ismissingvar
	quietly: gen `ismissingvar'=.
	forvalues i = 1/100 {
		if "`text_fields`i''" ~= "" {
			foreach svarlist in `text_fields`i'' {
				cap unab svarlist : `svarlist'
				if _rc==0 {
					foreach stringvar in `svarlist' {
						quietly: replace `ismissingvar'=.
						quietly: cap replace `ismissingvar'=1 if `stringvar'==.
						cap tostring `stringvar', format(%100.0g) replace
						cap replace `stringvar'="" if `ismissingvar'==1
					}
				}
			}
		}
	}
	quietly: drop `ismissingvar'


	* consolidate unique ID into "key" variable
	replace key=instanceid if key==""
	drop instanceid


	* label variables
	label variable key "Unique submission ID"
	cap label variable submissiondate "Date/time submitted"
	cap label variable formdef_version "Form version used on device"
	cap label variable review_status "Review status"
	cap label variable review_comments "Comments made during review"
	cap label variable review_corrections "Corrections made during review"


	label variable s1_1 "101. Nom de la région"
	note s1_1: "101. Nom de la région"
	label define s1_1 1 "DAKAR" 2 "DIOURBEL" 3 "FATICK" 4 "KAFFRINE" 5 "KAOLACK" 6 "KEDOUGOU" 7 "KOLDA" 8 "LOUGA" 9 "MATAM" 10 "SAINT-LOUIS" 11 "SEDHIOU" 12 "TAMBACOUNDA" 13 "THIES" 14 "ZIGUINCHOR"
	label values s1_1 s1_1

	label variable s1_3 "103. Nom du district"
	note s1_3: "103. Nom du district"
	label define s1_3 1 "DAKAR CENTRE" 2 "DAKAR NORD" 3 "DAKAR OUEST" 4 "DAKAR SUD" 5 "DIAMNIADIO" 6 "GUEDIAWAYE" 7 "KEUR MASSAR" 8 "MBAO" 9 "PIKINE" 10 "RUFISQUE" 11 "SANGALKAM" 12 "YEUMBEUL" 13 "BAMBEY" 14 "DIOURBEL" 15 "MBACKE" 16 "TOUBA" 17 "DIAKHAO" 18 "DIOFFIOR" 19 "FATICK" 20 "FOUNDIOUGNE" 21 "GOSSAS" 22 "NIAKHAR" 23 "PASSY" 24 "SOKONE" 25 "BIRKELANE" 26 "KAFFRINE" 27 "KOUNGHEUL" 28 "MALEM HODAR" 29 "GUINGUINEO" 30 "KAOLACK" 31 "NDOFFANE" 32 "NIORO" 33 "KEDOUGOU" 34 "SALEMATA" 35 "SARAYA" 36 "KOLDA" 37 "MEDINA YORO FOULAH" 38 "VELINGARA" 39 "DAHRA" 40 "DAROU-MOUSTY" 41 "KEBEMER" 42 "KEUR MOMAR SARR" 43 "KOKI" 44 "LINGUERE" 45 "LOUGA" 46 "SAKAL" 47 "KANEL" 48 "MATAM" 49 "RANEROU" 50 "THILOGNE" 51 "DAGANA" 52 "PETE" 53 "PODOR" 54 "RICHARD TOLL" 55 "SAINT-LOUIS" 56 "BOUNKILING" 57 "GOUDOMP" 58 "SEDHIOU" 59 "BAKEL" 60 "DIANKHE MAKHAN" 61 "GOUDIRY" 62 "KIDIRA" 63 "KOUMPENTOUM" 64 "MAKACOLIBANTANG" 65 "TAMBACOUNDA" 66 "JOAL-FADIOUTH" 67 "KHOMBOLE" 68 "MBOUR" 69 "MEKHE" 70 "POPENGUINE" 71 "POUT" 72 "THIADIAYE" 73 "THIES" 74 "TIVAOUANE" 75 "BIGNONA" 76 "DIOULOULOU" 77 "OUSSOUYE" 78 "THIONCK-ESSYL" 79 "ZIGUINCHOR"
	label values s1_3 s1_3

	label variable equipe "Veuilllez choisir votre équipe"
	note equipe: "Veuilllez choisir votre équipe"
	label define equipe 1 "Equipe 1" 2 "Equipe 2" 3 "Equipe 3" 4 "Equipe 4" 5 "Equipe 5" 6 "Equipe 6" 7 "Equipe 7" 8 "Equipe 8" 9 "Equipe 9" 10 "Equipe 10" 11 "Equipe 11" 12 "Equipe 12" 13 "Equipe 13" 14 "Equipe 14" 15 "Equipe 15" 16 "Equipe 16" 17 "Equipe 17" 18 "Equipe 18" 19 "Equipe 19" 20 "Equipe 20" 21 "Equipe 21"
	label values equipe equipe

	label variable enqueteur "Nom de l'enquêteur"
	note enqueteur: "Nom de l'enquêteur"
	label define enqueteur 1 "Fleur Kona" 2 "Maimouna Yaye Pode Faye" 3 "Malick Ndiongue" 4 "Catherine Mendy" 5 "Mamadou Yacine Diallo Diallo" 6 "Yacine Sall Koumba Boulingui" 7 "Maty Leye" 8 "Fatoumata Binta Bah" 9 "Awa Diouf" 10 "Madicke Diop" 11 "Arona Diagne" 12 "Mame Salane Thiongane" 13 "Débo Diop" 14 "Ndeye Aby Gaye" 15 "Papa amadou Dieye" 16 "Younousse Chérif Goudiaby" 17 "Marieme Boye" 18 "Ibrahima Thiam" 19 "Ahmed Sene" 20 "Mame Gnagna Diagne Kane" 21 "Latyr Diagne" 22 "Sokhna Beye" 23 "Abdoul Khadre Djeylani Gueye" 24 "Bah Fall" 25 "Ndeye Mareme Diop" 26 "Ousmane Mbengue" 27 "Amadou Gueye" 28 "Momar Diop" 29 "Serigne Sow" 30 "Christophe Diouf" 31 "Maimouna Kane" 32 "Tabasky Diouf" 33 "Ndeye Anna Thiam" 34 "Youssou Diallo" 35 "Abdourahmane Niang" 36 "Mame Diarra Bousso Ndao" 37 "Omar Cisse" 38 "Coumba Kane" 39 "Yacine Sall" 40 "Mamadou Mar" 41 "Nayèdio Ba" 42 "Mame Bousso Faye" 43 "Rokhaya Gueye" 44 "Ousmane Samba Gaye" 45 "Ibrahima Diarra" 46 "Khardiata Kane" 47 "Idrissa Gaye" 48 "Mafoudya Camara" 49 "Mouhamed Fall" 50 "Pape Amadou Diop" 51 "Diarra Ndoye" 52 "Bintou Ly" 53 "Mame Mossane Biram Sarr" 54 "Adama Diaw" 55 "Maty Sarr" 56 "Mouhamadou Moustapha Ba" 57 "Serigne saliou Ngom" 58 "Aminata Harouna Dieng" 59 "Aminata Sall Diéye" 60 "Sophie Faye" 61 "Bintou Gueye" 62 "Louise Taky bonang" 63 "Salimata Diallo" 64 "Adama Ba" 65 "Mamour Diop" 66 "Ndeye Ouleye Sarr" 67 "Djiby Diouf" 68 "Madicke Gaye" 69 "Mouhamadou Sy" 70 "Sokhna Diaité" 71 "Mbaye Ndoye" 72 "Moussa Kane" 73 "Cheikh Ndao" 74 "Yaya Balde" 75 "Cheikh Modou Falilou Faye" 76 "Seydina Ousseynou Wade" 77 "Khadim Diouf" 78 "Awa Ndiaye" 79 "Dieynaba Tall" 80 "Souleymane Diol" 81 "Lamine Diop" 82 "Gnima Diedhiou" 83 "Clara Sadio" 84 "Fatoumata Diémé"
	label values enqueteur enqueteur

	label variable nom_structure "106. Nom de la structure sanitaire"
	note nom_structure: "106. Nom de la structure sanitaire"
	label define nom_structure 1 "CLINIQUE CROIX BLEUE" 2 "CLINIQUE JABOOT" 3 "CLINIQUE MEDICAL KEUR MARIE" 4 "CLINIQUE NEST" 5 "CLINIQUE OPHTALMOLOGIE NURLU GOZ" 6 "CLINIQUE YA SALAM" 7 "CENTRE MEDICAL CLEO" 8 "CLINIQUE ALMADI" 9 "CLINIQUE LA PROVIDENCE" 10 "CLINIQUE OASIS" 11 "CLINIQUE SODA" 12 "CLINIQUE BELLE VUE" 13 "CLINIQUE CASAHOUS" 14 "CLINIQUE NAT" 15 "CLINIQUE NIANG" 16 "PLATEAU MEDICAL SERIGNE SALIOU MBACKE" 17 "CLINIQUE DE L'AMITIE" 18 "CLINIQUE YA_SIN" 19 "PLATEAU MEDICAL NEST" 20 "CLINIQUE DU GOLF" 21 "CLINIQUE MAME ASTA" 22 "CLINIQUE SOKHNA KHOUDIA LO" 23 "CLINIQUE THIERNO KANDJI" 24 "CLINIQUE EL HADJI IBRAHIMA NIASS DIT TOUNKAFA" 25 "CLINIQUE CHEIKHOUL KHADIM" 26 "CLINIQUE MISMA" 27 "CLINIQUE KELEBANA" 28 "CLINIQUE RASSOUL" 29 "CLINIQUE NABOU" 30 "POLYCLINIQUE LOUIS PASTEUR" 31 "CLINIQUE PRIVE ELY MANEL FALL" 32 "CLINIQUE MIXTE MOUHAMADOU FADEL MBACKE ROUTE DE MBACKE" 33 "CLINIQUE CHEIKH IBRA FALL" 34 "CLINIQUE MATLA BOU CHIFAY" 35 "CLINIQUE TAYSIROU ASSIR" 36 "CLINIQUE DU LYCEE" 37 "CLINIQUE JABOOT MU SELAMI" 38 "CLINIQUE LAMP FALL" 39 "CLINIQUE SARR" 40 "CLINIQUE TIDIANE BODIANE" 41 "CLINIQUE MEDICAL RADIOLOGISUE ET ACCOUCHEMENT" 42 "CLINIQUE DAROU SALAM" 43 "CLINIQUE MAGOU" 44 "CLINIQUE MATLABOUL CHIFAI" 45 "PLATEAU MEDICAL SEYDINA ALIOUNE" 46 "CLINIQUE EL HADJ ADAMA WADE" 47 "CLINIQUE NDIAYE" 48 "CLINIQUE DIAMILA" 49 "PLATEAU MEDICAL FAMA" 50 "PLATEAU MEDICAL DE LA PETITE COTE" 51 "CABINET MEDICAL YASSALAM" 52 "CLINIQUE GYNECOLOGIQUE EMMAUS" 53 "CLINIQUE ADJA OUMI" 54 "CLINIQUE BILLBASSI" 55 "CLINIQUE DE LA PETITE COTE ADAM" 56 "CLINIQUE DU LITTORAL" 57 "CABINET MEDICAL RADIYA" 58 "CLINIQUE BIO CONSULT" 59 "CLINIQUE CONCEPTION" 60 "CLINIQUE FOULO" 61 "CLINIQUE LA SAGESSE" 62 "CLINIQUE SARR" 63 "CLINIQUE GYNECOLOGIQUE LA JOANNE" 64 "AcDev" 65 "ADEMAS" 66 "ENDA Santé" 67 "Marie Stop International" 68 "African Ressources Center (ARC)" 69 "SANSAS/Solthis"
	label values nom_structure nom_structure

	label variable s1_4 "104. Nom du quartier"
	note s1_4: "104. Nom du quartier"

	label variable s1_7 "107. Autorité de gestion / Propriété"
	note s1_7: "107. Autorité de gestion / Propriété"
	label define s1_7 1 "Public" 2 "Privé"
	label values s1_7 s1_7

	label variable s1_8 "108. Nom du responsable de la structure"
	note s1_8: "108. Nom du responsable de la structure"

	label variable s1_9 "109. Numéro de téléphone de la structure ou du responsable de la structure"
	note s1_9: "109. Numéro de téléphone de la structure ou du responsable de la structure"

	label variable s1_10 "110. Mail de la structure ou du responsable de la structure"
	note s1_10: "110. Mail de la structure ou du responsable de la structure"

	label variable s2_1 "201. Estimation de la population polarisée par la structure"
	note s2_1: "201. Estimation de la population polarisée par la structure"

	label variable s2_3 "202. La structure propose-t-il des services ambulatoires, des services hospitali"
	note s2_3: "202. La structure propose-t-il des services ambulatoires, des services hospitaliers ou les deux ?"
	label define s2_3 1 "Soins ambulatoires uniquement" 2 "Hospitalisation et soins ambulatoires"
	label values s2_3 s2_3

	label variable s3_1_1_1 "301A. Le structure dispose t-il d'une salle d'attente avec des sièges ?"
	note s3_1_1_1: "301A. Le structure dispose t-il d'une salle d'attente avec des sièges ?"
	label define s3_1_1_1 1 "Oui" 2 "Non"
	label values s3_1_1_1 s3_1_1_1

	label variable s3_1_2_1 "301B. Le structure dispose t-il de toilettes pour hommes avec eau courante dans "
	note s3_1_2_1: "301B. Le structure dispose t-il de toilettes pour hommes avec eau courante dans la salle d'attente ?"
	label define s3_1_2_1 1 "Oui" 2 "Non"
	label values s3_1_2_1 s3_1_2_1

	label variable s3_1_3_1 "301C. Le structure dispose t-il de toilettes pour femmes avec eau courante dans "
	note s3_1_3_1: "301C. Le structure dispose t-il de toilettes pour femmes avec eau courante dans la salle d'attente ?"
	label define s3_1_3_1 1 "Oui" 2 "Non"
	label values s3_1_3_1 s3_1_3_1

	label variable s3_1_4_1 "301D. Le structure dispose t-il de dispositif de lavage des mains ?"
	note s3_1_4_1: "301D. Le structure dispose t-il de dispositif de lavage des mains ?"
	label define s3_1_4_1 1 "Oui" 2 "Non"
	label values s3_1_4_1 s3_1_4_1

	label variable s3_1_5_1 "301E. Le structure dispose t-il d'eau potable ?"
	note s3_1_5_1: "301E. Le structure dispose t-il d'eau potable ?"
	label define s3_1_5_1 1 "Oui" 2 "Non"
	label values s3_1_5_1 s3_1_5_1

	label variable s3_1_6_1 "301F. Le structure dispose t-il d'alimentation en électricité ?"
	note s3_1_6_1: "301F. Le structure dispose t-il d'alimentation en électricité ?"
	label define s3_1_6_1 1 "Oui" 2 "Non"
	label values s3_1_6_1 s3_1_6_1

	label variable s3_1_8_1 "301G. Le structure dispose t-il de laboratoire ?"
	note s3_1_8_1: "301G. Le structure dispose t-il de laboratoire ?"
	label define s3_1_8_1 1 "Oui" 2 "Non"
	label values s3_1_8_1 s3_1_8_1

	label variable s3_1_8_1a "301H. Le structure dispose t-il de service d'imagerie ?"
	note s3_1_8_1a: "301H. Le structure dispose t-il de service d'imagerie ?"
	label define s3_1_8_1a 1 "Oui" 2 "Non"
	label values s3_1_8_1a s3_1_8_1a

	label variable s3_1_9_1 "301I. Le structure dispose t-il de salle d'opération (salle opératoire) ?"
	note s3_1_9_1: "301I. Le structure dispose t-il de salle d'opération (salle opératoire) ?"
	label define s3_1_9_1 1 "Oui" 2 "Non"
	label values s3_1_9_1 s3_1_9_1

	label variable s3_1_10_1 "301J. Le structure dispose t-il de pharmacies ?"
	note s3_1_10_1: "301J. Le structure dispose t-il de pharmacies ?"
	label define s3_1_10_1 1 "Oui" 2 "Non"
	label values s3_1_10_1 s3_1_10_1

	label variable s3_1_11_1 "301K. Le structure dispose t-il de panneaux de signalisation pour orientation ?"
	note s3_1_11_1: "301K. Le structure dispose t-il de panneaux de signalisation pour orientation ?"
	label define s3_1_11_1 1 "Oui" 2 "Non"
	label values s3_1_11_1 s3_1_11_1

	label variable s3_1_12_1 "301L. Le structure dispose t-il des rampes pour personnes handicapées ?"
	note s3_1_12_1: "301L. Le structure dispose t-il des rampes pour personnes handicapées ?"
	label define s3_1_12_1 1 "Oui" 2 "Non"
	label values s3_1_12_1 s3_1_12_1

	label variable s3_1_13_1 "301M. Le structure dispose t-il de salle de collecte des déchets biomédicaux ?"
	note s3_1_13_1: "301M. Le structure dispose t-il de salle de collecte des déchets biomédicaux ?"
	label define s3_1_13_1 1 "Oui" 2 "Non"
	label values s3_1_13_1 s3_1_13_1

	label variable s3_1_14_1 "301N. Le structure dispose t-il de parking automobile ?"
	note s3_1_14_1: "301N. Le structure dispose t-il de parking automobile ?"
	label define s3_1_14_1 1 "Oui" 2 "Non"
	label values s3_1_14_1 s3_1_14_1

	label variable s3_2_1 "Toilettes fonctionnelles avec eau courante et chasse d'eau"
	note s3_2_1: "Toilettes fonctionnelles avec eau courante et chasse d'eau"
	label define s3_2_1 1 "Oui" 2 "Non"
	label values s3_2_1 s3_2_1

	label variable s3_2_2 "Zone de triage et d'examen"
	note s3_2_2: "Zone de triage et d'examen"
	label define s3_2_2 1 "Oui" 2 "Non"
	label values s3_2_2 s3_2_2

	label variable s3_2_3 "Salle de travail réservée aux infirmiers/sage-femme d'état"
	note s3_2_3: "Salle de travail réservée aux infirmiers/sage-femme d'état"
	label define s3_2_3 1 "Oui" 2 "Non"
	label values s3_2_3 s3_2_3

	label variable s3_2_4 "Salle de garde pour les médecins"
	note s3_2_4: "Salle de garde pour les médecins"
	label define s3_2_4 1 "Oui" 2 "Non"
	label values s3_2_4 s3_2_4

	label variable s3_2_55 "Salle de garde pour les infirmiers/sage-femme d'état"
	note s3_2_55: "Salle de garde pour les infirmiers/sage-femme d'état"
	label define s3_2_55 1 "Oui" 2 "Non"
	label values s3_2_55 s3_2_55

	label variable s3_2_5 "Zone de soins aux nouveau-nés"
	note s3_2_5: "Zone de soins aux nouveau-nés"
	label define s3_2_5 1 "Oui" 2 "Non"
	label values s3_2_5 s3_2_5

	label variable s3_2_6 "Zone de stockage médical"
	note s3_2_6: "Zone de stockage médical"
	label define s3_2_6 1 "Oui" 2 "Non"
	label values s3_2_6 s3_2_6

	label variable s3_2_7 "Vestiaires"
	note s3_2_7: "Vestiaires"
	label define s3_2_7 1 "Oui" 2 "Non"
	label values s3_2_7 s3_2_7

	label variable s3_2_8 "Lavabo médical"
	note s3_2_8: "Lavabo médical"
	label define s3_2_8 1 "Oui" 2 "Non"
	label values s3_2_8 s3_2_8

	label variable s3_2_9 "Zone de décontamination"
	note s3_2_9: "Zone de décontamination"
	label define s3_2_9 1 "Oui" 2 "Non"
	label values s3_2_9 s3_2_9

	label variable s3_3_1 "Table d'accouchement"
	note s3_3_1: "Table d'accouchement"
	label define s3_3_1 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_1 s3_3_1

	label variable s3_3_2 "Lampe/éclairage réglable"
	note s3_3_2: "Lampe/éclairage réglable"
	label define s3_3_2 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_2 s3_3_2

	label variable s3_3_3 "Bouteille d'oxygène avec régulateur et masque"
	note s3_3_3: "Bouteille d'oxygène avec régulateur et masque"
	label define s3_3_3 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_3 s3_3_3

	label variable s3_3_4 "Aspirateur manuelle intra-utérine (AMIU)"
	note s3_3_4: "Aspirateur manuelle intra-utérine (AMIU)"
	label define s3_3_4 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_4 s3_3_4

	label variable s3_3_6 "Ampoule d'aspiration ou pingouin"
	note s3_3_6: "Ampoule d'aspiration ou pingouin"
	label define s3_3_6 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_6 s3_3_6

	label variable s3_3_7 "Fœtoscope/Doppler"
	note s3_3_7: "Fœtoscope/Doppler"
	label define s3_3_7 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_7 s3_3_7

	label variable s3_3_8 "Stéthoscope Pinard"
	note s3_3_8: "Stéthoscope Pinard"
	label define s3_3_8 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_8 s3_3_8

	label variable s3_3_9 "Médicaments d'urgence dans le plateau/chariot de l'équipement (antispasmodique)"
	note s3_3_9: "Médicaments d'urgence dans le plateau/chariot de l'équipement (antispasmodique)"
	label define s3_3_9 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_9 s3_3_9

	label variable s3_3_10 "Médicaments d'urgence dans le plateau/chariot de l'équipement (antibiotique)"
	note s3_3_10: "Médicaments d'urgence dans le plateau/chariot de l'équipement (antibiotique)"
	label define s3_3_10 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_10 s3_3_10

	label variable s3_3_11 "Médicaments d'urgence dans le plateau/chariot de l'équipement (antalgiques)"
	note s3_3_11: "Médicaments d'urgence dans le plateau/chariot de l'équipement (antalgiques)"
	label define s3_3_11 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_11 s3_3_11

	label variable s3_3_12 "Médicaments d'urgence dans le plateau/chariot de l'équipement (acide tranexamiqu"
	note s3_3_12: "Médicaments d'urgence dans le plateau/chariot de l'équipement (acide tranexamique ou exacyl)"
	label define s3_3_12 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_12 s3_3_12

	label variable s3_3_13 "Médicaments d'urgence dans le plateau/chariot de l'équipement (sulfate de magnés"
	note s3_3_13: "Médicaments d'urgence dans le plateau/chariot de l'équipement (sulfate de magnésium)"
	label define s3_3_13 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_13 s3_3_13

	label variable s3_3_14 "Médicaments d'urgence dans le plateau/chariot de l'équipement (nifédipine)"
	note s3_3_14: "Médicaments d'urgence dans le plateau/chariot de l'équipement (nifédipine)"
	label define s3_3_14 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_14 s3_3_14

	label variable s3_3_15 "Médicaments d'urgence dans le plateau/chariot de l'équipement (corticostéroide)"
	note s3_3_15: "Médicaments d'urgence dans le plateau/chariot de l'équipement (corticostéroide)"
	label define s3_3_15 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_15 s3_3_15

	label variable s3_3_16 "Equipement adapté pour accouchement à style libre"
	note s3_3_16: "Equipement adapté pour accouchement à style libre"
	label define s3_3_16 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_16 s3_3_16

	label variable s3_3_17 "Kit d'accouchement normal (pince de Kocher)"
	note s3_3_17: "Kit d'accouchement normal (pince de Kocher)"
	label define s3_3_17 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_17 s3_3_17

	label variable s3_3_18 "Kit d'accouchement normal (ciseau pour cordon ombilical)"
	note s3_3_18: "Kit d'accouchement normal (ciseau pour cordon ombilical)"
	label define s3_3_18 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_18 s3_3_18

	label variable s3_3_19 "Kit d'accouchement normal (clamp de bar)"
	note s3_3_19: "Kit d'accouchement normal (clamp de bar)"
	label define s3_3_19 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_19 s3_3_19

	label variable s3_3_20 "Kit d'accouchement normal (pince à rompre)"
	note s3_3_20: "Kit d'accouchement normal (pince à rompre)"
	label define s3_3_20 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_20 s3_3_20

	label variable s3_3_21 "Kit d'accouchement normal (compresses stériles)"
	note s3_3_21: "Kit d'accouchement normal (compresses stériles)"
	label define s3_3_21 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_21 s3_3_21

	label variable s3_3_22 "Kit d'accouchement normal (gants stériles)"
	note s3_3_22: "Kit d'accouchement normal (gants stériles)"
	label define s3_3_22 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_22 s3_3_22

	label variable s3_3_23 "Kit d'accouchement normal"
	note s3_3_23: "Kit d'accouchement normal"
	label define s3_3_23 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_23 s3_3_23

	label variable s3_3_24 "Pince à forceps"
	note s3_3_24: "Pince à forceps"
	label define s3_3_24 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_24 s3_3_24

	label variable s3_3_25 "Ventouse"
	note s3_3_25: "Ventouse"
	label define s3_3_25 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_25 s3_3_25

	label variable s3_3_26 "Pince à coeur"
	note s3_3_26: "Pince à coeur"
	label define s3_3_26 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_26 s3_3_26

	label variable s3_3_27 "Plateau réniforme (Haricots)"
	note s3_3_27: "Plateau réniforme (Haricots)"
	label define s3_3_27 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_27 s3_3_27

	label variable s3_3_28 "Seringue et canule AMIU (Aspiration manuelle intra-utérine)"
	note s3_3_28: "Seringue et canule AMIU (Aspiration manuelle intra-utérine)"
	label define s3_3_28 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_28 s3_3_28

	label variable s3_3_29 "Foetoscope/Doppler"
	note s3_3_29: "Foetoscope/Doppler"
	label define s3_3_29 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_29 s3_3_29

	label variable s3_3_30 "Tambour"
	note s3_3_30: "Tambour"
	label define s3_3_30 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_30 s3_3_30

	label variable s3_3_31 "Ciseaux à cordon"
	note s3_3_31: "Ciseaux à cordon"
	label define s3_3_31 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_31 s3_3_31

	label variable s3_3_32 "Pinces à cordon"
	note s3_3_32: "Pinces à cordon"
	label define s3_3_32 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_32 s3_3_32

	label variable s3_3_33 "Clamp de Bar"
	note s3_3_33: "Clamp de Bar"
	label define s3_3_33 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_33 s3_3_33

	label variable s3_3_34 "Supports à perfusion"
	note s3_3_34: "Supports à perfusion"
	label define s3_3_34 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_34 s3_3_34

	label variable s3_3_35 "Kits de perfusion intraveineuse"
	note s3_3_35: "Kits de perfusion intraveineuse"
	label define s3_3_35 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_35 s3_3_35

	label variable s3_3_36 "Sonde urinaire"
	note s3_3_36: "Sonde urinaire"
	label define s3_3_36 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_36 s3_3_36

	label variable s3_3_37 "Cotons et compresses stérilisés"
	note s3_3_37: "Cotons et compresses stérilisés"
	label define s3_3_37 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_37 s3_3_37

	label variable s3_3_38 "Stérilisateur à haute pression / Autoclave"
	note s3_3_38: "Stérilisateur à haute pression / Autoclave"
	label define s3_3_38 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_38 s3_3_38

	label variable s3_3_39 "Kit de suture (pince)"
	note s3_3_39: "Kit de suture (pince)"
	label define s3_3_39 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_39 s3_3_39

	label variable s3_3_40 "Kit de suture (porte aiguille)"
	note s3_3_40: "Kit de suture (porte aiguille)"
	label define s3_3_40 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_40 s3_3_40

	label variable s3_3_41 "Kit de suture (ciseaux)"
	note s3_3_41: "Kit de suture (ciseaux)"
	label define s3_3_41 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_41 s3_3_41

	label variable s3_3_42 "Kit de suture (lames)"
	note s3_3_42: "Kit de suture (lames)"
	label define s3_3_42 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_42 s3_3_42

	label variable s3_3_43 "Kit de suture (fils)"
	note s3_3_43: "Kit de suture (fils)"
	label define s3_3_43 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_43 s3_3_43

	label variable s3_3_44 "Kit de suture (compresses stériles)"
	note s3_3_44: "Kit de suture (compresses stériles)"
	label define s3_3_44 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_44 s3_3_44

	label variable s3_3_45 "Kit de suture (gants stériles)"
	note s3_3_45: "Kit de suture (gants stériles)"
	label define s3_3_45 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_45 s3_3_45

	label variable s3_3_46 "Kit de suture (bétadine)"
	note s3_3_46: "Kit de suture (bétadine)"
	label define s3_3_46 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_46 s3_3_46

	label variable s3_3_47 "Kit de test de grossesse urinaire"
	note s3_3_47: "Kit de test de grossesse urinaire"
	label define s3_3_47 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_47 s3_3_47

	label variable s3_3_48 "Lavage des mains à l'eau courante au point d'utilisation"
	note s3_3_48: "Lavage des mains à l'eau courante au point d'utilisation"
	label define s3_3_48 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_48 s3_3_48

	label variable s3_3_49 "Robinets actionnés par le coude"
	note s3_3_49: "Robinets actionnés par le coude"
	label define s3_3_49 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_49 s3_3_49

	label variable s3_3_50 "Lavabo large et profond pour éviter les éclaboussures et la rétention d'eau"
	note s3_3_50: "Lavabo large et profond pour éviter les éclaboussures et la rétention d'eau"
	label define s3_3_50 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_50 s3_3_50

	label variable s3_3_51 "Savon antiseptique avec porte-savon/antiseptique liquide avec distributeur"
	note s3_3_51: "Savon antiseptique avec porte-savon/antiseptique liquide avec distributeur"
	label define s3_3_51 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_51 s3_3_51

	label variable s3_3_52 "Produit de friction pour les mains à base d'alcool"
	note s3_3_52: "Produit de friction pour les mains à base d'alcool"
	label define s3_3_52 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_52 s3_3_52

	label variable s3_3_53 "Affichage des instructions relatives au lavage des mains au point d'utilisation"
	note s3_3_53: "Affichage des instructions relatives au lavage des mains au point d'utilisation"
	label define s3_3_53 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_53 s3_3_53

	label variable s3_3_54 "Équipement de protection individuelle (EPI)"
	note s3_3_54: "Équipement de protection individuelle (EPI)"
	label define s3_3_54 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_54 s3_3_54

	label variable s3_3_55 "Désinfectant"
	note s3_3_55: "Désinfectant"
	label define s3_3_55 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_55 s3_3_55

	label variable s3_3_56 "Produits de nettoyage"
	note s3_3_56: "Produits de nettoyage"
	label define s3_3_56 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_56 s3_3_56

	label variable s3_3_57 "Poubelles à code couleur au point de production des déchets"
	note s3_3_57: "Poubelles à code couleur au point de production des déchets"
	label define s3_3_57 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_57 s3_3_57

	label variable s3_3_58 "Sacs en plastique au point de production des déchets"
	note s3_3_58: "Sacs en plastique au point de production des déchets"
	label define s3_3_58 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_3_58 s3_3_58

	label variable s3_4_1_1 "Services d’hospitalisation"
	note s3_4_1_1: "Services d’hospitalisation"
	label define s3_4_1_1 1 "Oui" 2 "Non"
	label values s3_4_1_1 s3_4_1_1

	label variable s3_4_1_2 "Toilettes fonctionnelles avec eau courante et chasse d'eau dans le service"
	note s3_4_1_2: "Toilettes fonctionnelles avec eau courante et chasse d'eau dans le service"
	label define s3_4_1_2 1 "Oui" 2 "Non"
	label values s3_4_1_2 s3_4_1_2

	label variable s3_4_1_3 "Aire de lavage des mains et de bain séparée pour les patients et les visiteurs"
	note s3_4_1_3: "Aire de lavage des mains et de bain séparée pour les patients et les visiteurs"
	label define s3_4_1_3 1 "Oui" 2 "Non"
	label values s3_4_1_3 s3_4_1_3

	label variable s3_4_1_4 "Zone d'attente ombragée pour les accompagnateurs des patients"
	note s3_4_1_4: "Zone d'attente ombragée pour les accompagnateurs des patients"
	label define s3_4_1_4 1 "Oui" 2 "Non"
	label values s3_4_1_4 s3_4_1_4

	label variable s3_4_1_5 "Salle de travail réservées aux infirmières"
	note s3_4_1_5: "Salle de travail réservées aux infirmières"
	label define s3_4_1_5 1 "Oui" 2 "Non"
	label values s3_4_1_5 s3_4_1_5

	label variable s3_4_1_6 "Salle de décontamination"
	note s3_4_1_6: "Salle de décontamination"
	label define s3_4_1_6 1 "Oui" 2 "Non"
	label values s3_4_1_6 s3_4_1_6

	label variable s3_4_1_1a "Services d’hospitalisation"
	note s3_4_1_1a: "Services d’hospitalisation"
	label define s3_4_1_1a 1 "Oui" 2 "Non"
	label values s3_4_1_1a s3_4_1_1a

	label variable s3_4_1_2a "Toilettes fonctionnelles avec eau courante et chasse d'eau dans le service"
	note s3_4_1_2a: "Toilettes fonctionnelles avec eau courante et chasse d'eau dans le service"
	label define s3_4_1_2a 1 "Oui" 2 "Non"
	label values s3_4_1_2a s3_4_1_2a

	label variable s3_4_1_3a "Aire de lavage des mains et de bain séparée pour les patients et les visiteurs"
	note s3_4_1_3a: "Aire de lavage des mains et de bain séparée pour les patients et les visiteurs"
	label define s3_4_1_3a 1 "Oui" 2 "Non"
	label values s3_4_1_3a s3_4_1_3a

	label variable s3_4_1_4a "Zone d'attente ombragée pour les accompagnateurs des patients"
	note s3_4_1_4a: "Zone d'attente ombragée pour les accompagnateurs des patients"
	label define s3_4_1_4a 1 "Oui" 2 "Non"
	label values s3_4_1_4a s3_4_1_4a

	label variable s3_4_1_5a "Salle de travail réservées aux infirmières"
	note s3_4_1_5a: "Salle de travail réservées aux infirmières"
	label define s3_4_1_5a 1 "Oui" 2 "Non"
	label values s3_4_1_5a s3_4_1_5a

	label variable s3_4_1_6a "Salle de décontamination"
	note s3_4_1_6a: "Salle de décontamination"
	label define s3_4_1_6a 1 "Oui" 2 "Non"
	label values s3_4_1_6a s3_4_1_6a

	label variable s3_5_1 "Mobilier"
	note s3_5_1: "Mobilier"
	label define s3_5_1 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_1 s3_5_1

	label variable s3_5_2 "Tensiomètre"
	note s3_5_2: "Tensiomètre"
	label define s3_5_2 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_2 s3_5_2

	label variable s3_5_3 "Thermomètre"
	note s3_5_3: "Thermomètre"
	label define s3_5_3 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_3 s3_5_3

	label variable s3_5_4 "Fœtoscope/Doppler"
	note s3_5_4: "Fœtoscope/Doppler"
	label define s3_5_4 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_4 s3_5_4

	label variable s3_5_5 "Stéthoscope Pinard"
	note s3_5_5: "Stéthoscope Pinard"
	label define s3_5_5 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_5 s3_5_5

	label variable s3_5_6 "Balance nourisson"
	note s3_5_6: "Balance nourisson"
	label define s3_5_6 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_6 s3_5_6

	label variable s3_5_7 "Balance adulte"
	note s3_5_7: "Balance adulte"
	label define s3_5_7 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_7 s3_5_7

	label variable s3_5_8 "Stéthoscope adulte/enfant"
	note s3_5_8: "Stéthoscope adulte/enfant"
	label define s3_5_8 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_8 s3_5_8

	label variable s3_5_9 "Spéculum"
	note s3_5_9: "Spéculum"
	label define s3_5_9 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_9 s3_5_9

	label variable s3_5_10 "Écarteur de paroi vaginale antérieure"
	note s3_5_10: "Écarteur de paroi vaginale antérieure"
	label define s3_5_10 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_10 s3_5_10

	label variable s3_5_11 "Oxygène à canalisation centrale/concentrateur/cylindre"
	note s3_5_11: "Oxygène à canalisation centrale/concentrateur/cylindre"
	label define s3_5_11 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_11 s3_5_11

	label variable s3_5_12 "Débitmètre pour la source d'oxygène, avec graduations en ml"
	note s3_5_12: "Débitmètre pour la source d'oxygène, avec graduations en ml"
	label define s3_5_12 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_12 s3_5_12

	label variable s3_5_13 "Humidificateur/Climatisation"
	note s3_5_13: "Humidificateur/Climatisation"
	label define s3_5_13 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_13 s3_5_13

	label variable s3_5_14 "Appareil d'administration d'oxygène pour adultes/enfants (tubes de raccordement "
	note s3_5_14: "Appareil d'administration d'oxygène pour adultes/enfants (tubes de raccordement et masque)"
	label define s3_5_14 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_14 s3_5_14

	label variable s3_5_15 "Appareil d'administration d'oxygène pour adultes/enfants (pinces nasales) commun"
	note s3_5_15: "Appareil d'administration d'oxygène pour adultes/enfants (pinces nasales) communément appelé lunettes nasale"
	label define s3_5_15 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_15 s3_5_15

	label variable s3_5_16 "Aspirateur"
	note s3_5_16: "Aspirateur"
	label define s3_5_16 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_16 s3_5_16

	label variable s3_5_17 "Réfrigérateur"
	note s3_5_17: "Réfrigérateur"
	label define s3_5_17 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_17 s3_5_17

	label variable s3_5_18 "Chariot de réanimation avec plateau d'urgence"
	note s3_5_18: "Chariot de réanimation avec plateau d'urgence"
	label define s3_5_18 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_18 s3_5_18

	label variable s3_5_19 "Équipement pour la prévention standard des infections courantes"
	note s3_5_19: "Équipement pour la prévention standard des infections courantes"
	label define s3_5_19 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_19 s3_5_19

	label variable s3_5_20 "Support à perfusion (potence)"
	note s3_5_20: "Support à perfusion (potence)"
	label define s3_5_20 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_20 s3_5_20

	label variable s3_5_21 "Dispositif électrique pour les équipements comme l'aspirateur"
	note s3_5_21: "Dispositif électrique pour les équipements comme l'aspirateur"
	label define s3_5_21 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_21 s3_5_21

	label variable s3_5_22 "Poste de soins infirmiers"
	note s3_5_22: "Poste de soins infirmiers"
	label define s3_5_22 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_22 s3_5_22

	label variable s3_5_23 "Stéthoscope pédiatrique"
	note s3_5_23: "Stéthoscope pédiatrique"
	label define s3_5_23 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_23 s3_5_23

	label variable s3_5_24 "Oxymètre de pouls"
	note s3_5_24: "Oxymètre de pouls"
	label define s3_5_24 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_24 s3_5_24

	label variable s3_5_25 "Torche"
	note s3_5_25: "Torche"
	label define s3_5_25 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_25 s3_5_25

	label variable s3_5_26 "Nébuliseur"
	note s3_5_26: "Nébuliseur"
	label define s3_5_26 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_26 s3_5_26

	label variable s3_5_27 "Masque avec chambre d’inhalation"
	note s3_5_27: "Masque avec chambre d’inhalation"
	label define s3_5_27 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_27 s3_5_27

	label variable s3_5_28 "Masques de protection Nouveau-né"
	note s3_5_28: "Masques de protection Nouveau-né"
	label define s3_5_28 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_28 s3_5_28

	label variable s3_5_29 "Masques de protection Adulte"
	note s3_5_29: "Masques de protection Adulte"
	label define s3_5_29 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_29 s3_5_29

	label variable s3_5_33 "Mobilier"
	note s3_5_33: "Mobilier"
	label define s3_5_33 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_33 s3_5_33

	label variable s3_5_35 "Thermomètre"
	note s3_5_35: "Thermomètre"
	label define s3_5_35 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_35 s3_5_35

	label variable s3_5_37 "Balance nourisson"
	note s3_5_37: "Balance nourisson"
	label define s3_5_37 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_37 s3_5_37

	label variable s3_5_38 "Balance adulte"
	note s3_5_38: "Balance adulte"
	label define s3_5_38 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_38 s3_5_38

	label variable s3_5_42 "Oxygène à canalisation centrale/concentrateur/cylindre"
	note s3_5_42: "Oxygène à canalisation centrale/concentrateur/cylindre"
	label define s3_5_42 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_42 s3_5_42

	label variable s3_5_43 "Débitmètre pour la source d'oxygène, avec graduations en ml"
	note s3_5_43: "Débitmètre pour la source d'oxygène, avec graduations en ml"
	label define s3_5_43 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_43 s3_5_43

	label variable s3_5_44 "Humidificateur/Climatisation"
	note s3_5_44: "Humidificateur/Climatisation"
	label define s3_5_44 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_44 s3_5_44

	label variable s3_5_45 "Appareil d'administration d'oxygène pour adultes/enfants (tubes de raccordement "
	note s3_5_45: "Appareil d'administration d'oxygène pour adultes/enfants (tubes de raccordement et masque)"
	label define s3_5_45 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_45 s3_5_45

	label variable s3_5_46 "Appareil d'administration d'oxygène pour adultes/enfants (pinces nasales)"
	note s3_5_46: "Appareil d'administration d'oxygène pour adultes/enfants (pinces nasales)"
	label define s3_5_46 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_46 s3_5_46

	label variable s3_5_47 "Aspirateur"
	note s3_5_47: "Aspirateur"
	label define s3_5_47 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_47 s3_5_47

	label variable s3_5_48 "Réfrigérateur"
	note s3_5_48: "Réfrigérateur"
	label define s3_5_48 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_48 s3_5_48

	label variable s3_5_49 "Chariot de réanimation avec plateau d'urgence"
	note s3_5_49: "Chariot de réanimation avec plateau d'urgence"
	label define s3_5_49 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_49 s3_5_49

	label variable s3_5_50 "Équipement pour la prévention standard des infections courantes"
	note s3_5_50: "Équipement pour la prévention standard des infections courantes"
	label define s3_5_50 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_50 s3_5_50

	label variable s3_5_51 "Support à perfusion (potence)"
	note s3_5_51: "Support à perfusion (potence)"
	label define s3_5_51 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_51 s3_5_51

	label variable s3_5_52 "Dispositif électrique pour les équipements comme l'aspirateur"
	note s3_5_52: "Dispositif électrique pour les équipements comme l'aspirateur"
	label define s3_5_52 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_52 s3_5_52

	label variable s3_5_53 "Poste de soins infirmiers"
	note s3_5_53: "Poste de soins infirmiers"
	label define s3_5_53 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_53 s3_5_53

	label variable s3_5_54 "Stadiomètre pour la hauteur"
	note s3_5_54: "Stadiomètre pour la hauteur"
	label define s3_5_54 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_54 s3_5_54

	label variable s3_5_55 "Infantomètre pour la longueur"
	note s3_5_55: "Infantomètre pour la longueur"
	label define s3_5_55 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_55 s3_5_55

	label variable s3_5_56 "Stéthoscope pédiatrique"
	note s3_5_56: "Stéthoscope pédiatrique"
	label define s3_5_56 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_56 s3_5_56

	label variable s3_5_57 "Oxymètre de pouls"
	note s3_5_57: "Oxymètre de pouls"
	label define s3_5_57 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_57 s3_5_57

	label variable s3_5_58 "Torche"
	note s3_5_58: "Torche"
	label define s3_5_58 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_58 s3_5_58

	label variable s3_5_59 "Nébuliseur"
	note s3_5_59: "Nébuliseur"
	label define s3_5_59 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_59 s3_5_59

	label variable s3_5_60 "Masque avec chambre d’inhalation"
	note s3_5_60: "Masque avec chambre d’inhalation"
	label define s3_5_60 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_60 s3_5_60

	label variable s3_5_61 "Masques de protection Nouveau-né"
	note s3_5_61: "Masques de protection Nouveau-né"
	label define s3_5_61 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_61 s3_5_61

	label variable s3_5_62 "Masques de protection Nourrisson"
	note s3_5_62: "Masques de protection Nourrisson"
	label define s3_5_62 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_62 s3_5_62

	label variable s3_5_63 "Masques de protection Enfant"
	note s3_5_63: "Masques de protection Enfant"
	label define s3_5_63 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_63 s3_5_63

	label variable s3_5_64 "Masques de protection Adulte"
	note s3_5_64: "Masques de protection Adulte"
	label define s3_5_64 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_64 s3_5_64

	label variable s3_15 "306. La structure dispose-t-il d'un laboratoire ?"
	note s3_15: "306. La structure dispose-t-il d'un laboratoire ?"
	label define s3_15 1 "Oui" 2 "Non"
	label values s3_15 s3_15

	label variable s3_16_1 "Eau courante avec robinet normal"
	note s3_16_1: "Eau courante avec robinet normal"
	label define s3_16_1 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_16_1 s3_16_1

	label variable s3_16_2 "Eau courante avec robinet coudé"
	note s3_16_2: "Eau courante avec robinet coudé"
	label define s3_16_2 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_16_2 s3_16_2

	label variable s3_16_3 "Stérilisateur d’instruments"
	note s3_16_3: "Stérilisateur d’instruments"
	label define s3_16_3 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_16_3 s3_16_3

	label variable s3_16_4 "Destructeur d'aiguilles/coupe-embouts"
	note s3_16_4: "Destructeur d'aiguilles/coupe-embouts"
	label define s3_16_4 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_16_4 s3_16_4

	label variable s3_16_5 "Réfrigérateur"
	note s3_16_5: "Réfrigérateur"
	label define s3_16_5 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_16_5 s3_16_5

	label variable s3_16_6 "Hémoglobinomètre"
	note s3_16_6: "Hémoglobinomètre"
	label define s3_16_6 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_16_6 s3_16_6

	label variable s3_16_7 "Microscope binoculaire/monoculaire"
	note s3_16_7: "Microscope binoculaire/monoculaire"
	label define s3_16_7 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_16_7 s3_16_7

	label variable s3_16_8 "Test d'électrolytes (ionogramme)"
	note s3_16_8: "Test d'électrolytes (ionogramme)"
	label define s3_16_8 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_16_8 s3_16_8

	label variable s3_16_9 "Glucomètre/ Dextrogyre"
	note s3_16_9: "Glucomètre/ Dextrogyre"
	label define s3_16_9 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_16_9 s3_16_9

	label variable s3_16_10 "Bilirubinomètre"
	note s3_16_10: "Bilirubinomètre"
	label define s3_16_10 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_16_10 s3_16_10

	label variable s3_17_1 "Savon"
	note s3_17_1: "Savon"
	label define s3_17_1 1 "Disponible" 2 "Indisponible"
	label values s3_17_1 s3_17_1

	label variable s3_17_2 "Gants utilitaires"
	note s3_17_2: "Gants utilitaires"
	label define s3_17_2 1 "Disponible" 2 "Indisponible"
	label values s3_17_2 s3_17_2

	label variable s3_17_3 "Gants de chirurgie/d'examen"
	note s3_17_3: "Gants de chirurgie/d'examen"
	label define s3_17_3 1 "Disponible" 2 "Indisponible"
	label values s3_17_3 s3_17_3

	label variable s3_17_4 "Bacs en plastique couverts pour la décontamination"
	note s3_17_4: "Bacs en plastique couverts pour la décontamination"
	label define s3_17_4 1 "Disponible" 2 "Indisponible"
	label values s3_17_4 s3_17_4

	label variable s3_17_5 "Poubelles à déchets biomédicaux jaunes (Déchets tranchants et piquants)"
	note s3_17_5: "Poubelles à déchets biomédicaux jaunes (Déchets tranchants et piquants)"
	label define s3_17_5 1 "Disponible" 2 "Indisponible"
	label values s3_17_5 s3_17_5

	label variable s3_17_6 "Poubelles pour déchets biomédicaux-Rouge (Déchets anatomiques)"
	note s3_17_6: "Poubelles pour déchets biomédicaux-Rouge (Déchets anatomiques)"
	label define s3_17_6 1 "Disponible" 2 "Indisponible"
	label values s3_17_6 s3_17_6

	label variable s3_17_7 "Poubelles pour déchets biomédicaux - noires (Déchets domestiques)"
	note s3_17_7: "Poubelles pour déchets biomédicaux - noires (Déchets domestiques)"
	label define s3_17_7 1 "Disponible" 2 "Indisponible"
	label values s3_17_7 s3_17_7

	label variable s3_17_8 "Boîte en carton bleu pour les ampoules et les flacons en verre mis au rebut"
	note s3_17_8: "Boîte en carton bleu pour les ampoules et les flacons en verre mis au rebut"
	label define s3_17_8 1 "Disponible" 2 "Indisponible"
	label values s3_17_8 s3_17_8

	label variable s3_18_1 "Hématologie"
	note s3_18_1: "Hématologie"
	label define s3_18_1 1 "Oui" 2 "Non"
	label values s3_18_1 s3_18_1

	label variable s3_18_2 "Analyse d'urine"
	note s3_18_2: "Analyse d'urine"
	label define s3_18_2 1 "Oui" 2 "Non"
	label values s3_18_2 s3_18_2

	label variable s3_18_3 "Analyse des selles"
	note s3_18_3: "Analyse des selles"
	label define s3_18_3 1 "Oui" 2 "Non"
	label values s3_18_3 s3_18_3

	label variable s3_18_4 "Glycémie"
	note s3_18_4: "Glycémie"
	label define s3_18_4 1 "Oui" 2 "Non"
	label values s3_18_4 s3_18_4

	label variable s3_18_5 "Urée sanguine"
	note s3_18_5: "Urée sanguine"
	label define s3_18_5 1 "Oui" 2 "Non"
	label values s3_18_5 s3_18_5

	label variable s3_18_6 "Créatinine sanguine"
	note s3_18_6: "Créatinine sanguine"
	label define s3_18_6 1 "Oui" 2 "Non"
	label values s3_18_6 s3_18_6

	label variable s3_18_7 "Test de grossesse"
	note s3_18_7: "Test de grossesse"
	label define s3_18_7 1 "Oui" 2 "Non"
	label values s3_18_7 s3_18_7

	label variable s3_18_8 "Test Widal"
	note s3_18_8: "Test Widal"
	label define s3_18_8 1 "Oui" 2 "Non"
	label values s3_18_8 s3_18_8

	label variable s3_18_9 "Test ELISA pour le VIH"
	note s3_18_9: "Test ELISA pour le VIH"
	label define s3_18_9 1 "Oui" 2 "Non"
	label values s3_18_9 s3_18_9

	label variable s3_18_10 "Test VDRL"
	note s3_18_10: "Test VDRL"
	label define s3_18_10 1 "Oui" 2 "Non"
	label values s3_18_10 s3_18_10

	label variable s3_18_11 "Radiographie"
	note s3_18_11: "Radiographie"
	label define s3_18_11 1 "Oui" 2 "Non"
	label values s3_18_11 s3_18_11

	label variable s3_18_12 "Echographie"
	note s3_18_12: "Echographie"
	label define s3_18_12 1 "Oui" 2 "Non"
	label values s3_18_12 s3_18_12

	label variable s3_18_13 "Scanner"
	note s3_18_13: "Scanner"
	label define s3_18_13 1 "Oui" 2 "Non"
	label values s3_18_13 s3_18_13

	label variable s4_1_2 "Quels profils sont autorisés dans la structure ?"
	note s4_1_2: "Quels profils sont autorisés dans la structure ?"

	label variable s501 "501. Est-ce que cette structure propose un service de SMNI ?"
	note s501: "501. Est-ce que cette structure propose un service de SMNI ?"
	label define s501 1 "Oui" 2 "Non"
	label values s501 s501

	label variable servi_smni "1. Quels sont les services de SMNI qu'il propose ?"
	note servi_smni: "1. Quels sont les services de SMNI qu'il propose ?"

	label variable s_cpn "Quels sont les services de CPN que cette structure propose ?"
	note s_cpn: "Quels sont les services de CPN que cette structure propose ?"

	label variable s5_2_cpn "502. A quelle fréquence les CPN sont-elles fournies ?"
	note s5_2_cpn: "502. A quelle fréquence les CPN sont-elles fournies ?"
	label define s5_2_cpn 1 "Régulièrement" 2 "Occasionnellement" 3 "Pas du tout"
	label values s5_2_cpn s5_2_cpn

	label variable s5_3_cpn "503a. Le ticket de CPN est-il fourni gratuitement ?"
	note s5_3_cpn: "503a. Le ticket de CPN est-il fourni gratuitement ?"
	label define s5_3_cpn 1 "Oui" 2 "Non"
	label values s5_3_cpn s5_3_cpn

	label variable s5_3_cpna "503b. Les services paracliniques disponibles (CPN) sont-ils fourni gratuitement "
	note s5_3_cpna: "503b. Les services paracliniques disponibles (CPN) sont-ils fourni gratuitement ?"
	label define s5_3_cpna 1 "Oui" 2 "Non"
	label values s5_3_cpna s5_3_cpna

	label variable s5_4_cpn "504a. Combien cela coûte-t-il par unité (le ticket de CPN) ?"
	note s5_4_cpn: "504a. Combien cela coûte-t-il par unité (le ticket de CPN) ?"

	label variable s5_4_cpna "504b. Combien cela coûte-t-il dans l'ensemble (les services paracliniques dispon"
	note s5_4_cpna: "504b. Combien cela coûte-t-il dans l'ensemble (les services paracliniques disponibles) ?"

	label variable s5_5_cpn "505. Raisons de la non-disponibilité du service de CPN"
	note s5_5_cpn: "505. Raisons de la non-disponibilité du service de CPN"

	label variable s5_5_cpn_autre "Préciser autre raison de la non disponibilité du service de CPN"
	note s5_5_cpn_autre: "Préciser autre raison de la non disponibilité du service de CPN"

	label variable s_acc "Est-ce que cette structure propose les services d'accouchement suivants ?"
	note s_acc: "Est-ce que cette structure propose les services d'accouchement suivants ?"

	label variable s5_2_acc "502. A quelle fréquence ces services d'accouchement sont-ils fournis ?"
	note s5_2_acc: "502. A quelle fréquence ces services d'accouchement sont-ils fournis ?"
	label define s5_2_acc 1 "Régulièrement" 2 "Occasionnellement" 3 "Pas du tout"
	label values s5_2_acc s5_2_acc

	label variable s5_3_acc "503a. Ce service d'accouchement (accouchement normal : Ticket + Kit d'accoucheme"
	note s5_3_acc: "503a. Ce service d'accouchement (accouchement normal : Ticket + Kit d'accouchement + Episiotomie) est-il fourni gratuitement ?"
	label define s5_3_acc 1 "Oui" 2 "Non"
	label values s5_3_acc s5_3_acc

	label variable s5_3_acca "503b. Ce service d'accouchement (accouchement par césarienne) est-il fourni grat"
	note s5_3_acca: "503b. Ce service d'accouchement (accouchement par césarienne) est-il fourni gratuitement ?"
	label define s5_3_acca 1 "Oui" 2 "Non"
	label values s5_3_acca s5_3_acca

	label variable s5_4_acc1 "504a. Combien cela coûte-t-il par unité (accouchement par voie basse) ?"
	note s5_4_acc1: "504a. Combien cela coûte-t-il par unité (accouchement par voie basse) ?"

	label variable s5_4_acc2 "504b. Combien cela coûte-t-il par unité (accouchement par césarienne) ?"
	note s5_4_acc2: "504b. Combien cela coûte-t-il par unité (accouchement par césarienne) ?"

	label variable s5_5_acc "505. Raisons de la non-disponibilité du service d'accouchement"
	note s5_5_acc: "505. Raisons de la non-disponibilité du service d'accouchement"

	label variable s5_5_acc_autre "Préciser autre raison de la non disponibilité du service d'accouchement"
	note s5_5_acc_autre: "Préciser autre raison de la non disponibilité du service d'accouchement"

	label variable s_pnat "Est-ce que cette structure propose les services postnatals suivants ?"
	note s_pnat: "Est-ce que cette structure propose les services postnatals suivants ?"

	label variable s5_2_pnat "502. A quelle fréquence ce service postnatal est-il fourni ?"
	note s5_2_pnat: "502. A quelle fréquence ce service postnatal est-il fourni ?"
	label define s5_2_pnat 1 "Régulièrement" 2 "Occasionnellement" 3 "Pas du tout"
	label values s5_2_pnat s5_2_pnat

	label variable s5_3_pnat "503. Ce service postnatal est-il fourni gratuitement ?"
	note s5_3_pnat: "503. Ce service postnatal est-il fourni gratuitement ?"
	label define s5_3_pnat 1 "Oui" 2 "Non"
	label values s5_3_pnat s5_3_pnat

	label variable s5_4_pnat "504. Combien cela coûte-t-il par unité ?"
	note s5_4_pnat: "504. Combien cela coûte-t-il par unité ?"

	label variable s5_5_pnat "505. Raisons de la non-disponibilité du service postnatal"
	note s5_5_pnat: "505. Raisons de la non-disponibilité du service postnatal"

	label variable s5_5_pnat_autre "Préciser autre raison de la non disponibilité du service postnatal"
	note s5_5_pnat_autre: "Préciser autre raison de la non disponibilité du service postnatal"

	label variable s_nne "Est-ce que cette structure propose les services essentiels aux nouveau-nés suiva"
	note s_nne: "Est-ce que cette structure propose les services essentiels aux nouveau-nés suivants ?"

	label variable s5_2_nne "502. A quelle fréquence ces services essentiels aux nouveau-nés est-il fourni ?"
	note s5_2_nne: "502. A quelle fréquence ces services essentiels aux nouveau-nés est-il fourni ?"
	label define s5_2_nne 1 "Régulièrement" 2 "Occasionnellement" 3 "Pas du tout"
	label values s5_2_nne s5_2_nne

	label variable s5_3_nne "503. Ces services essentiels aux nouveau-nés est-il fourni gratuitement ?"
	note s5_3_nne: "503. Ces services essentiels aux nouveau-nés est-il fourni gratuitement ?"
	label define s5_3_nne 1 "Oui" 2 "Non"
	label values s5_3_nne s5_3_nne

	label variable s5_4_nne "504. Combien cela coûte-t-il par unité ?"
	note s5_4_nne: "504. Combien cela coûte-t-il par unité ?"

	label variable s5_5_nne "505. Raisons de la non-disponibilité des services essentiels aux nouveau-nés"
	note s5_5_nne: "505. Raisons de la non-disponibilité des services essentiels aux nouveau-nés"

	label variable s5_5_nne_autre "Préciser autre raison de la non disponibilité des services essentiels aux nouvea"
	note s5_5_nne_autre: "Préciser autre raison de la non disponibilité des services essentiels aux nouveau-nés"

	label variable s_avo "Est-ce que cette structure propose les services post-avortement suivants ?"
	note s_avo: "Est-ce que cette structure propose les services post-avortement suivants ?"

	label variable s5_2_avo "502. A quelle fréquence ce service post-avortement est-il fourni ?"
	note s5_2_avo: "502. A quelle fréquence ce service post-avortement est-il fourni ?"
	label define s5_2_avo 1 "Régulièrement" 2 "Occasionnellement" 3 "Pas du tout"
	label values s5_2_avo s5_2_avo

	label variable s5_3_avo "503. Ce service post-avortement est-il fourni gratuitement ?"
	note s5_3_avo: "503. Ce service post-avortement est-il fourni gratuitement ?"
	label define s5_3_avo 1 "Oui" 2 "Non"
	label values s5_3_avo s5_3_avo

	label variable s5_4_avo "504. Combien cela coûte-t-il par unité ?"
	note s5_4_avo: "504. Combien cela coûte-t-il par unité ?"

	label variable s5_5_avo "505. Raisons de la non-disponibilité du service post-avortement"
	note s5_5_avo: "505. Raisons de la non-disponibilité du service post-avortement"

	label variable s5_5_avo_autre "Préciser autre raison de la non disponibilité du service post-avortement"
	note s5_5_avo_autre: "Préciser autre raison de la non disponibilité du service post-avortement"

	label variable s_inf "Est-ce que cette structure propose les services de santé néonatales et infantile"
	note s_inf: "Est-ce que cette structure propose les services de santé néonatales et infantiles ?"

	label variable s5_2_sinf "502. A quelle fréquence ces services de santé néonatales et infantiles sont-ils "
	note s5_2_sinf: "502. A quelle fréquence ces services de santé néonatales et infantiles sont-ils fournis ?"
	label define s5_2_sinf 1 "Régulièrement" 2 "Occasionnellement" 3 "Pas du tout"
	label values s5_2_sinf s5_2_sinf

	label variable s5_3_sinf "503. Ces services de santé infantiles est-il fourni gratuitement ?"
	note s5_3_sinf: "503. Ces services de santé infantiles est-il fourni gratuitement ?"
	label define s5_3_sinf 1 "Oui" 2 "Non"
	label values s5_3_sinf s5_3_sinf

	label variable s5_4_sinf "504. Combien cela coûte-t-il par unité ?"
	note s5_4_sinf: "504. Combien cela coûte-t-il par unité ?"

	label variable s5_5_sinf "505. Raisons de la non-disponibilité des services de santé néonatales et infanti"
	note s5_5_sinf: "505. Raisons de la non-disponibilité des services de santé néonatales et infantiles"

	label variable s5_5_sinf_autre "Préciser autre raison de la non disponibilité des services de santé néonatales e"
	note s5_5_sinf_autre: "Préciser autre raison de la non disponibilité des services de santé néonatales et infantiles"

	label variable s506 "506. La structure propose-t-il des services de planification familiale sur place"
	note s506: "506. La structure propose-t-il des services de planification familiale sur place ?"
	label define s506 1 "Oui" 2 "Non"
	label values s506 s506

	label variable s506a "506a. Combien coûte le ticket de consultation PF ?"
	note s506a: "506a. Combien coûte le ticket de consultation PF ?"

	label variable s5_7 "507A. A quelle fréquence La pilule est-il fourni ?"
	note s5_7: "507A. A quelle fréquence La pilule est-il fourni ?"
	label define s5_7 1 "Quotidien" 2 "Hebdomadaire" 3 "Tous les quinze jours" 4 "Mensuel" 5 "Pas du tout"
	label values s5_7 s5_7

	label variable s5_8 "508A. La pilule est-il fournie gratuitement ?"
	note s5_8: "508A. La pilule est-il fournie gratuitement ?"
	label define s5_8 1 "Oui" 2 "Non"
	label values s5_8 s5_8

	label variable s5_9 "509A. Combien cela coûte-t-il par unité ?"
	note s5_9: "509A. Combien cela coûte-t-il par unité ?"

	label variable s5_10 "510A. Raisons de la non-disponibilité de la pilule"
	note s5_10: "510A. Raisons de la non-disponibilité de la pilule"

	label variable s5_10_autre "Préciser autre raison de la non disponibilité de la pilule"
	note s5_10_autre: "Préciser autre raison de la non disponibilité de la pilule"

	label variable s5_7a "507B. A quelle fréquence l'injectable est-il fourni ?"
	note s5_7a: "507B. A quelle fréquence l'injectable est-il fourni ?"
	label define s5_7a 1 "Quotidien" 2 "Hebdomadaire" 3 "Tous les quinze jours" 4 "Mensuel" 5 "Pas du tout"
	label values s5_7a s5_7a

	label variable s5_8a "508B. L'injectable est-il fournie gratuitement ?"
	note s5_8a: "508B. L'injectable est-il fournie gratuitement ?"
	label define s5_8a 1 "Oui" 2 "Non"
	label values s5_8a s5_8a

	label variable s5_9a "509B. Combien cela coûte-t-il par unité ?"
	note s5_9a: "509B. Combien cela coûte-t-il par unité ?"

	label variable s5_10a "510B. Raisons de la non-disponibilité de l'injectable"
	note s5_10a: "510B. Raisons de la non-disponibilité de l'injectable"

	label variable s5_10_autrea "Préciser autre raison de la non disponibilité de l'injectable"
	note s5_10_autrea: "Préciser autre raison de la non disponibilité de l'injectable"

	label variable s5_7b "507C. A quelle fréquence le préservatif masculin est-il fourni ?"
	note s5_7b: "507C. A quelle fréquence le préservatif masculin est-il fourni ?"
	label define s5_7b 1 "Quotidien" 2 "Hebdomadaire" 3 "Tous les quinze jours" 4 "Mensuel" 5 "Pas du tout"
	label values s5_7b s5_7b

	label variable s5_8b "508C. Le préservatif masculin est-il fournie gratuitement ?"
	note s5_8b: "508C. Le préservatif masculin est-il fournie gratuitement ?"
	label define s5_8b 1 "Oui" 2 "Non"
	label values s5_8b s5_8b

	label variable s5_9b "509C. Combien cela coûte-t-il par unité ?"
	note s5_9b: "509C. Combien cela coûte-t-il par unité ?"

	label variable s5_10b "510C. Raisons de la non-disponibilité du préservatif masculin"
	note s5_10b: "510C. Raisons de la non-disponibilité du préservatif masculin"

	label variable s5_10_autreb "Préciser autre raison de la non disponibilité du préservatif masculin"
	note s5_10_autreb: "Préciser autre raison de la non disponibilité du préservatif masculin"

	label variable s5_7c "507D. A quelle fréquence le préservatif féminin est-il fourni ?"
	note s5_7c: "507D. A quelle fréquence le préservatif féminin est-il fourni ?"
	label define s5_7c 1 "Quotidien" 2 "Hebdomadaire" 3 "Tous les quinze jours" 4 "Mensuel" 5 "Pas du tout"
	label values s5_7c s5_7c

	label variable s5_8c "508D. Le préservatif féminin est-il fournie gratuitement ?"
	note s5_8c: "508D. Le préservatif féminin est-il fournie gratuitement ?"
	label define s5_8c 1 "Oui" 2 "Non"
	label values s5_8c s5_8c

	label variable s5_9c "509D. Combien cela coûte-t-il par unité ?"
	note s5_9c: "509D. Combien cela coûte-t-il par unité ?"

	label variable s5_10c "510D. Raisons de la non-disponibilité du préservatif féminin"
	note s5_10c: "510D. Raisons de la non-disponibilité du préservatif féminin"

	label variable s5_10_autrec "Préciser autre raison de la non disponibilité du préservatif féminin"
	note s5_10_autrec: "Préciser autre raison de la non disponibilité du préservatif féminin"

	label variable s5_7e "507E. A quelle fréquence la contraception d'urgence est-il fourni ?"
	note s5_7e: "507E. A quelle fréquence la contraception d'urgence est-il fourni ?"
	label define s5_7e 1 "Quotidien" 2 "Hebdomadaire" 3 "Tous les quinze jours" 4 "Mensuel" 5 "Pas du tout"
	label values s5_7e s5_7e

	label variable s5_8e "508E. La contraception d'urgence est-il fournie gratuitement ?"
	note s5_8e: "508E. La contraception d'urgence est-il fournie gratuitement ?"
	label define s5_8e 1 "Oui" 2 "Non"
	label values s5_8e s5_8e

	label variable s5_9e "509E. Combien cela coûte-t-il par unité ?"
	note s5_9e: "509E. Combien cela coûte-t-il par unité ?"

	label variable s5_10e "510E. Raisons de la non-disponibilité de la contraception d'urgence"
	note s5_10e: "510E. Raisons de la non-disponibilité de la contraception d'urgence"

	label variable s5_10_autree "Préciser autre raison de la non disponibilité de la contraception d'urgence"
	note s5_10_autree: "Préciser autre raison de la non disponibilité de la contraception d'urgence"

	label variable s5_7f "507F. A quelle fréquence le DIU est-il fourni ?"
	note s5_7f: "507F. A quelle fréquence le DIU est-il fourni ?"
	label define s5_7f 1 "Quotidien" 2 "Hebdomadaire" 3 "Tous les quinze jours" 4 "Mensuel" 5 "Pas du tout"
	label values s5_7f s5_7f

	label variable s5_8f "508F. Le DIU est-il fournie gratuitement ?"
	note s5_8f: "508F. Le DIU est-il fournie gratuitement ?"
	label define s5_8f 1 "Oui" 2 "Non"
	label values s5_8f s5_8f

	label variable s5_9f "509F. Combien cela coûte-t-il par unité ?"
	note s5_9f: "509F. Combien cela coûte-t-il par unité ?"

	label variable s5_10f "510F. Raisons de la non-disponibilité du DIU"
	note s5_10f: "510F. Raisons de la non-disponibilité du DIU"

	label variable s5_10_autref "Préciser autre raison de la non disponibilité du DIU"
	note s5_10_autref: "Préciser autre raison de la non disponibilité du DIU"

	label variable s5_7g "507G. A quelle fréquence l'implant est-il fourni ?"
	note s5_7g: "507G. A quelle fréquence l'implant est-il fourni ?"
	label define s5_7g 1 "Quotidien" 2 "Hebdomadaire" 3 "Tous les quinze jours" 4 "Mensuel" 5 "Pas du tout"
	label values s5_7g s5_7g

	label variable s5_8g "508G. L'implant est-il fournie gratuitement ?"
	note s5_8g: "508G. L'implant est-il fournie gratuitement ?"
	label define s5_8g 1 "Oui" 2 "Non"
	label values s5_8g s5_8g

	label variable s5_9g "509G. Combien cela coûte-t-il par unité ?"
	note s5_9g: "509G. Combien cela coûte-t-il par unité ?"

	label variable s5_10g "510G. Raisons de la non-disponibilité de l'implant"
	note s5_10g: "510G. Raisons de la non-disponibilité de l'implant"

	label variable s5_10_autreg "Préciser autre raison de la non disponibilité de l'implant"
	note s5_10_autreg: "Préciser autre raison de la non disponibilité de l'implant"

	label variable s5_7h "507H. A quelle fréquence la stérilisation féminine (Ligature des trompes) est-il"
	note s5_7h: "507H. A quelle fréquence la stérilisation féminine (Ligature des trompes) est-il fourni ?"
	label define s5_7h 1 "Quotidien" 2 "Hebdomadaire" 3 "Tous les quinze jours" 4 "Mensuel" 5 "Pas du tout"
	label values s5_7h s5_7h

	label variable s5_8h "508H. La stérilisation féminine (Ligature des trompes) est-il fournie gratuiteme"
	note s5_8h: "508H. La stérilisation féminine (Ligature des trompes) est-il fournie gratuitement ?"
	label define s5_8h 1 "Oui" 2 "Non"
	label values s5_8h s5_8h

	label variable s5_9h "509H. Combien cela coûte-t-il par unité ?"
	note s5_9h: "509H. Combien cela coûte-t-il par unité ?"

	label variable s5_10h "510H. Raisons de la non-disponibilité de la stérilisation féminine (Ligature des"
	note s5_10h: "510H. Raisons de la non-disponibilité de la stérilisation féminine (Ligature des trompes)"

	label variable s5_10_autreh "Préciser autre raison de la non disponibilité de la stérilisation féminine (Liga"
	note s5_10_autreh: "Préciser autre raison de la non disponibilité de la stérilisation féminine (Ligature des trompes)"

	label variable s5_7j "507I. A quelle fréquence la stérilisation masculine/Vasectomie est-il fourni ?"
	note s5_7j: "507I. A quelle fréquence la stérilisation masculine/Vasectomie est-il fourni ?"
	label define s5_7j 1 "Quotidien" 2 "Hebdomadaire" 3 "Tous les quinze jours" 4 "Mensuel" 5 "Pas du tout"
	label values s5_7j s5_7j

	label variable s5_8j "508I. La stérilisation masculine/vasectomie est-il fournie gratuitement ?"
	note s5_8j: "508I. La stérilisation masculine/vasectomie est-il fournie gratuitement ?"
	label define s5_8j 1 "Oui" 2 "Non"
	label values s5_8j s5_8j

	label variable s5_9j "509I. Combien cela coûte-t-il par unité ?"
	note s5_9j: "509I. Combien cela coûte-t-il par unité ?"

	label variable s5_10j "510I. Raisons de la non-disponibilité de la stérilisation masculine/Vasectomie"
	note s5_10j: "510I. Raisons de la non-disponibilité de la stérilisation masculine/Vasectomie"

	label variable s5_10_autrej "Préciser autre raison de la non disponibilité de la stérilisation masculine/vase"
	note s5_10_autrej: "Préciser autre raison de la non disponibilité de la stérilisation masculine/vasectomie"

	label variable s5_7k "507J. A quelle fréquence l'allaitement maternel exclusif (MAMA) est-il fourni ?"
	note s5_7k: "507J. A quelle fréquence l'allaitement maternel exclusif (MAMA) est-il fourni ?"
	label define s5_7k 1 "Quotidien" 2 "Hebdomadaire" 3 "Tous les quinze jours" 4 "Mensuel" 5 "Pas du tout"
	label values s5_7k s5_7k

	label variable s5_8k "508J. L'allaitement maternel exclusif (MAMA) est-il fournie gratuitement ?"
	note s5_8k: "508J. L'allaitement maternel exclusif (MAMA) est-il fournie gratuitement ?"
	label define s5_8k 1 "Oui" 2 "Non"
	label values s5_8k s5_8k

	label variable s5_9k "509J. Combien cela coûte-t-il par unité ?"
	note s5_9k: "509J. Combien cela coûte-t-il par unité ?"

	label variable s5_10k "510J. Raisons de la non-disponibilité de l'allaitement maternel exclusif (MAMA)"
	note s5_10k: "510J. Raisons de la non-disponibilité de l'allaitement maternel exclusif (MAMA)"

	label variable s5_10_autrek "Préciser autre raison de la non disponibilité de l'allaitement maternel exclusif"
	note s5_10_autrek: "Préciser autre raison de la non disponibilité de l'allaitement maternel exclusif (MAMA)"

	label variable s5_7l "507K. A quelle fréquence la méthode des jours fixes (MJF) est-il fourni ?"
	note s5_7l: "507K. A quelle fréquence la méthode des jours fixes (MJF) est-il fourni ?"
	label define s5_7l 1 "Quotidien" 2 "Hebdomadaire" 3 "Tous les quinze jours" 4 "Mensuel" 5 "Pas du tout"
	label values s5_7l s5_7l

	label variable s5_8l "508K. La méthode des jours fixes (MJF) est-il fournie gratuitement ?"
	note s5_8l: "508K. La méthode des jours fixes (MJF) est-il fournie gratuitement ?"
	label define s5_8l 1 "Oui" 2 "Non"
	label values s5_8l s5_8l

	label variable s5_9l "509K. Combien cela coûte-t-il par unité ?"
	note s5_9l: "509K. Combien cela coûte-t-il par unité ?"

	label variable s5_10l "510K. Raisons de la non-disponibilité de la méthode des jours fixes (MJF)"
	note s5_10l: "510K. Raisons de la non-disponibilité de la méthode des jours fixes (MJF)"

	label variable s5_10_autrel "Préciser autre raison de la non disponibilité de la méthode des jours fixes (MJF"
	note s5_10_autrel: "Préciser autre raison de la non disponibilité de la méthode des jours fixes (MJF)"

	label variable s5_11 "511. Cette structure offre-t-elle des services de planification familiale de pro"
	note s5_11: "511. Cette structure offre-t-elle des services de planification familiale de proximité ?"
	label define s5_11 1 "Oui" 2 "Non"
	label values s5_11 s5_11

	label variable s5_12 "512. Quelle est la fréquence des services de PF de proximité organisés par cette"
	note s5_12: "512. Quelle est la fréquence des services de PF de proximité organisés par cette structure ?"
	label define s5_12 1 "Quotidien" 2 "Hebdomadaire" 3 "Tous les quinze jours" 4 "Mensuel" 5 "Très rarement"
	label values s5_12 s5_12

	label variable s5_13_1 "Pilules"
	note s5_13_1: "Pilules"
	label define s5_13_1 1 "Oui" 2 "Non"
	label values s5_13_1 s5_13_1

	label variable s5_13_2 "Injectable"
	note s5_13_2: "Injectable"
	label define s5_13_2 1 "Oui" 2 "Non"
	label values s5_13_2 s5_13_2

	label variable s5_13_3 "Préservatif masculin"
	note s5_13_3: "Préservatif masculin"
	label define s5_13_3 1 "Oui" 2 "Non"
	label values s5_13_3 s5_13_3

	label variable s5_13_4 "Préservatif féminin"
	note s5_13_4: "Préservatif féminin"
	label define s5_13_4 1 "Oui" 2 "Non"
	label values s5_13_4 s5_13_4

	label variable s5_13_5 "Contraception d’urgence"
	note s5_13_5: "Contraception d’urgence"
	label define s5_13_5 1 "Oui" 2 "Non"
	label values s5_13_5 s5_13_5

	label variable s5_13_6 "DIU"
	note s5_13_6: "DIU"
	label define s5_13_6 1 "Oui" 2 "Non"
	label values s5_13_6 s5_13_6

	label variable s5_13_7 "Implant"
	note s5_13_7: "Implant"
	label define s5_13_7 1 "Oui" 2 "Non"
	label values s5_13_7 s5_13_7

	label variable s5_13_8 "Stérilisation féminine (Ligature des trompes)"
	note s5_13_8: "Stérilisation féminine (Ligature des trompes)"
	label define s5_13_8 1 "Oui" 2 "Non"
	label values s5_13_8 s5_13_8

	label variable s5_13_9 "Stérilisation masculine/ Vasectomie"
	note s5_13_9: "Stérilisation masculine/ Vasectomie"
	label define s5_13_9 1 "Oui" 2 "Non"
	label values s5_13_9 s5_13_9

	label variable s5_13_10 "Allaitement maternel exclusif (MAMA)"
	note s5_13_10: "Allaitement maternel exclusif (MAMA)"
	label define s5_13_10 1 "Oui" 2 "Non"
	label values s5_13_10 s5_13_10

	label variable s5_13_11 "Méthode des Jours Fixes (MJF)"
	note s5_13_11: "Méthode des Jours Fixes (MJF)"
	label define s5_13_11 1 "Oui" 2 "Non"
	label values s5_13_11 s5_13_11

	label variable s6_2 "602. Cette structure sanitaire dispose-t-elle d'un lieu d'insertion/de retrait d"
	note s6_2: "602. Cette structure sanitaire dispose-t-elle d'un lieu d'insertion/de retrait des DIU ?"

	label variable s6_2_1 "Veuillez préciser le lieu"
	note s6_2_1: "Veuillez préciser le lieu"

	label variable s6_3_11 "Plateau en acier inoxydable avec couvercle"
	note s6_3_11: "Plateau en acier inoxydable avec couvercle"
	label define s6_3_11 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_11 s6_3_11

	label variable s6_3_12 "Petit bol pour la solution antiseptique"
	note s6_3_12: "Petit bol pour la solution antiseptique"
	label define s6_3_12 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_12 s6_3_12

	label variable s6_3_13 "Plateau réniforme (Haricots)"
	note s6_3_13: "Plateau réniforme (Haricots)"
	label define s6_3_13 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_13 s6_3_13

	label variable s6_3_14 "Spéculum vaginal de Sim ou de Cusco - grand, moyen, petit"
	note s6_3_14: "Spéculum vaginal de Sim ou de Cusco - grand, moyen, petit"
	label define s6_3_14 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_14 s6_3_14

	label variable s6_3_15 "Écarteur de paroi vaginale antérieure (si le spéculum de Sim est utilisé)"
	note s6_3_15: "Écarteur de paroi vaginale antérieure (si le spéculum de Sim est utilisé)"
	label define s6_3_15 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_15 s6_3_15

	label variable s6_3_16 "Pince à compresse"
	note s6_3_16: "Pince à compresse"
	label define s6_3_16 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_16 s6_3_16

	label variable s6_3_17 "Pince à vulsellum courbée/tenaculum"
	note s6_3_17: "Pince à vulsellum courbée/tenaculum"
	label define s6_3_17 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_17 s6_3_17

	label variable s6_3_18 "Sonde uterine"
	note s6_3_18: "Sonde uterine"
	label define s6_3_18 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_18 s6_3_18

	label variable s6_3_19 "Ciseaux de Mayo"
	note s6_3_19: "Ciseaux de Mayo"
	label define s6_3_19 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_19 s6_3_19

	label variable s6_3_20 "Pince droite pour artère longue (pour le retrait du DIU)"
	note s6_3_20: "Pince droite pour artère longue (pour le retrait du DIU)"
	label define s6_3_20 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_20 s6_3_20

	label variable s6_3_21 "Pince à artère moyenne"
	note s6_3_21: "Pince à artère moyenne"
	label define s6_3_21 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_21 s6_3_21

	label variable s6_3_22 "Cotons-tiges"
	note s6_3_22: "Cotons-tiges"
	label define s6_3_22 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_22 s6_3_22

	label variable s6_3_23 "Porte-compresse"
	note s6_3_23: "Porte-compresse"
	label define s6_3_23 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_23 s6_3_23

	label variable s6_3_24 "Spéculum de Sim"
	note s6_3_24: "Spéculum de Sim"
	label define s6_3_24 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_24 s6_3_24

	label variable s6_3_266 "Plateau en acier inoxydable avec couvercle"
	note s6_3_266: "Plateau en acier inoxydable avec couvercle"
	label define s6_3_266 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_266 s6_3_266

	label variable s6_3_277 "Petit bol pour la solution antiseptique"
	note s6_3_277: "Petit bol pour la solution antiseptique"
	label define s6_3_277 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_277 s6_3_277

	label variable s6_3_288 "Plateau réniforme (Haricots)"
	note s6_3_288: "Plateau réniforme (Haricots)"
	label define s6_3_288 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_288 s6_3_288

	label variable s6_3_299 "Spéculum vaginal de Sim ou de Cusco - grand, moyen, petit"
	note s6_3_299: "Spéculum vaginal de Sim ou de Cusco - grand, moyen, petit"
	label define s6_3_299 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_299 s6_3_299

	label variable s6_3_300 "Écarteur de paroi vaginale antérieure (si le spéculum de Sim est utilisé)"
	note s6_3_300: "Écarteur de paroi vaginale antérieure (si le spéculum de Sim est utilisé)"
	label define s6_3_300 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_300 s6_3_300

	label variable s6_3_301 "Pince à compresse"
	note s6_3_301: "Pince à compresse"
	label define s6_3_301 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_301 s6_3_301

	label variable s6_3_302 "Pince à vulsellum courbée/tenaculum"
	note s6_3_302: "Pince à vulsellum courbée/tenaculum"
	label define s6_3_302 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_302 s6_3_302

	label variable s6_3_303 "Sonde uterine"
	note s6_3_303: "Sonde uterine"
	label define s6_3_303 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_303 s6_3_303

	label variable s6_3_304 "Ciseaux de Mayo"
	note s6_3_304: "Ciseaux de Mayo"
	label define s6_3_304 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_304 s6_3_304

	label variable s6_3_305 "Pince droite pour artère longue (pour le retrait du DIU)"
	note s6_3_305: "Pince droite pour artère longue (pour le retrait du DIU)"
	label define s6_3_305 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_305 s6_3_305

	label variable s6_3_306 "Pince à artère moyenne"
	note s6_3_306: "Pince à artère moyenne"
	label define s6_3_306 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_306 s6_3_306

	label variable s6_3_307 "Cotons-tiges"
	note s6_3_307: "Cotons-tiges"
	label define s6_3_307 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_307 s6_3_307

	label variable s6_3_308 "Porte-compresse"
	note s6_3_308: "Porte-compresse"
	label define s6_3_308 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_308 s6_3_308

	label variable s6_3_309 "Spéculum de Sim"
	note s6_3_309: "Spéculum de Sim"
	label define s6_3_309 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_309 s6_3_309

	label variable s6_3_26 "Plateau en acier inoxydable avec couvercle"
	note s6_3_26: "Plateau en acier inoxydable avec couvercle"
	label define s6_3_26 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_26 s6_3_26

	label variable s6_3_27 "Petit bol pour la solution antiseptique"
	note s6_3_27: "Petit bol pour la solution antiseptique"
	label define s6_3_27 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_27 s6_3_27

	label variable s6_3_28 "Plateau réniforme (Haricots)"
	note s6_3_28: "Plateau réniforme (Haricots)"
	label define s6_3_28 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_28 s6_3_28

	label variable s6_3_29 "Spéculum vaginal de Sim ou de Cusco - grand, moyen, petit"
	note s6_3_29: "Spéculum vaginal de Sim ou de Cusco - grand, moyen, petit"
	label define s6_3_29 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_29 s6_3_29

	label variable s6_3_30 "Écarteur de paroi vaginale antérieure (si le spéculum de Sim est utilisé)"
	note s6_3_30: "Écarteur de paroi vaginale antérieure (si le spéculum de Sim est utilisé)"
	label define s6_3_30 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_30 s6_3_30

	label variable s6_3_31 "Pince à compresse"
	note s6_3_31: "Pince à compresse"
	label define s6_3_31 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_31 s6_3_31

	label variable s6_3_32 "Pince à vulsellum courbée/tenaculum"
	note s6_3_32: "Pince à vulsellum courbée/tenaculum"
	label define s6_3_32 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_32 s6_3_32

	label variable s6_3_33 "Sonde uterine"
	note s6_3_33: "Sonde uterine"
	label define s6_3_33 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_33 s6_3_33

	label variable s6_3_34 "Ciseaux de Mayo"
	note s6_3_34: "Ciseaux de Mayo"
	label define s6_3_34 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_34 s6_3_34

	label variable s6_3_35 "Pince droite pour artère longue (pour le retrait du DIU)"
	note s6_3_35: "Pince droite pour artère longue (pour le retrait du DIU)"
	label define s6_3_35 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_35 s6_3_35

	label variable s6_3_36 "Pince à artère moyenne"
	note s6_3_36: "Pince à artère moyenne"
	label define s6_3_36 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_36 s6_3_36

	label variable s6_3_37 "Cotons-tiges"
	note s6_3_37: "Cotons-tiges"
	label define s6_3_37 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_37 s6_3_37

	label variable s6_3_38 "Porte-compresse"
	note s6_3_38: "Porte-compresse"
	label define s6_3_38 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_38 s6_3_38

	label variable s6_3_39 "Spéculum de Sim"
	note s6_3_39: "Spéculum de Sim"
	label define s6_3_39 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_39 s6_3_39

	label variable s6_3_40 "Plateau en acier inoxydable avec couvercle"
	note s6_3_40: "Plateau en acier inoxydable avec couvercle"
	label define s6_3_40 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_40 s6_3_40

	label variable s6_3_41 "Petit bol pour la solution antiseptique"
	note s6_3_41: "Petit bol pour la solution antiseptique"
	label define s6_3_41 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_41 s6_3_41

	label variable s6_3_42 "Plateau réniforme (Haricots)"
	note s6_3_42: "Plateau réniforme (Haricots)"
	label define s6_3_42 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_42 s6_3_42

	label variable s6_3_43 "Spéculum vaginal de Sim ou de Cusco - grand, moyen, petit"
	note s6_3_43: "Spéculum vaginal de Sim ou de Cusco - grand, moyen, petit"
	label define s6_3_43 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_43 s6_3_43

	label variable s6_3_44 "Écarteur de paroi vaginale antérieure (si le spéculum de Sim est utilisé)"
	note s6_3_44: "Écarteur de paroi vaginale antérieure (si le spéculum de Sim est utilisé)"
	label define s6_3_44 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_44 s6_3_44

	label variable s6_3_45 "Pince à compresse"
	note s6_3_45: "Pince à compresse"
	label define s6_3_45 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_45 s6_3_45

	label variable s6_3_46 "Pince à vulsellum courbée/tenaculum"
	note s6_3_46: "Pince à vulsellum courbée/tenaculum"
	label define s6_3_46 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_46 s6_3_46

	label variable s6_3_47 "Sonde uterine"
	note s6_3_47: "Sonde uterine"
	label define s6_3_47 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_47 s6_3_47

	label variable s6_3_48 "Ciseaux de Mayo"
	note s6_3_48: "Ciseaux de Mayo"
	label define s6_3_48 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_48 s6_3_48

	label variable s6_3_49 "Pince droite pour artère longue (pour le retrait du DIU)"
	note s6_3_49: "Pince droite pour artère longue (pour le retrait du DIU)"
	label define s6_3_49 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_49 s6_3_49

	label variable s6_3_50 "Pince à artère moyenne"
	note s6_3_50: "Pince à artère moyenne"
	label define s6_3_50 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_50 s6_3_50

	label variable s6_3_51 "Cotons-tiges"
	note s6_3_51: "Cotons-tiges"
	label define s6_3_51 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_51 s6_3_51

	label variable s6_3_52 "Porte-compresse"
	note s6_3_52: "Porte-compresse"
	label define s6_3_52 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_52 s6_3_52

	label variable s6_3_53 "Spéculum de Sim"
	note s6_3_53: "Spéculum de Sim"
	label define s6_3_53 1 "Disponible et fonctionnel" 2 "Disponible mais non fonctionnel" 3 "Indisponible"
	label values s6_3_53 s6_3_53

	label variable s6_4_11 "604.a. Le coton-tige stérile sec est-il disponibles et fonctionnels dans la sall"
	note s6_4_11: "604.a. Le coton-tige stérile sec est-il disponibles et fonctionnels dans la salle de travail ?"
	label define s6_4_11 1 "Disponible" 2 "Indisponible"
	label values s6_4_11 s6_4_11

	label variable s6_4_12 "604.b. Les gants (gants chirurgicaux stériles/désinfectés à haut niveau ou gants"
	note s6_4_12: "604.b. Les gants (gants chirurgicaux stériles/désinfectés à haut niveau ou gants d'examen) sont-ils disponibles et fonctionnels dans la salle de travail ?"
	label define s6_4_12 1 "Disponible" 2 "Indisponible"
	label values s6_4_12 s6_4_12

	label variable s6_4_21 "604.a. Le coton-tige stérile sec est-il disponibles et fonctionnels dans le coin"
	note s6_4_21: "604.a. Le coton-tige stérile sec est-il disponibles et fonctionnels dans le coin PF/DIU ?"
	label define s6_4_21 1 "Disponible" 2 "Indisponible"
	label values s6_4_21 s6_4_21

	label variable s6_4_22 "604.b. Les gants (gants chirurgicaux stériles/désinfectés à haut niveau ou gants"
	note s6_4_22: "604.b. Les gants (gants chirurgicaux stériles/désinfectés à haut niveau ou gants d'examen) sont-ils disponibles et fonctionnels dans le coin PF/DIU ?"
	label define s6_4_22 1 "Disponible" 2 "Indisponible"
	label values s6_4_22 s6_4_22

	label variable s6_7 "607A. Ce préservatif masculin est-il disponible ?"
	note s6_7: "607A. Ce préservatif masculin est-il disponible ?"
	label define s6_7 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_7 s6_7

	label variable s6_8 "608A. Ce préservatif masculin a-t-il été en rupture de stock au cours des trois "
	note s6_8: "608A. Ce préservatif masculin a-t-il été en rupture de stock au cours des trois derniers mois ?"
	label define s6_8 1 "Oui" 2 "Non"
	label values s6_8 s6_8

	label variable s6_18 "609A. Depuis combien de semaines ce préservatif masculin n'est pas/n'a pas été d"
	note s6_18: "609A. Depuis combien de semaines ce préservatif masculin n'est pas/n'a pas été disponible dans la structure sanitaire ?"

	label variable s6_19 "610A. Raisons de la non-disponibilité"
	note s6_19: "610A. Raisons de la non-disponibilité"

	label variable s6_20 "Veuillez préciser la raison"
	note s6_20: "Veuillez préciser la raison"

	label variable s6_7a "607B. Ce préservatif féminin est-il disponible ?"
	note s6_7a: "607B. Ce préservatif féminin est-il disponible ?"
	label define s6_7a 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_7a s6_7a

	label variable s6_8a "608B. Ce préservatif féminin a-t-il été en rupture de stock au cours des trois d"
	note s6_8a: "608B. Ce préservatif féminin a-t-il été en rupture de stock au cours des trois derniers mois ?"
	label define s6_8a 1 "Oui" 2 "Non"
	label values s6_8a s6_8a

	label variable s6_18a "609B. Depuis combien de semaines ce préservatif féminin n'est pas/n'a pas été di"
	note s6_18a: "609B. Depuis combien de semaines ce préservatif féminin n'est pas/n'a pas été disponible dans la structure sanitaire ?"

	label variable s6_19a "610B. Raisons de la non-disponibilité"
	note s6_19a: "610B. Raisons de la non-disponibilité"

	label variable s6_20a "Veuillez préciser la raison"
	note s6_20a: "Veuillez préciser la raison"

	label variable s6_7b "607C. Ce pilule contraceptive d'urgence est-il disponible ?"
	note s6_7b: "607C. Ce pilule contraceptive d'urgence est-il disponible ?"
	label define s6_7b 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_7b s6_7b

	label variable s6_8b "608C. Ce pilule contraceptive d'urgence a-t-il été en rupture de stock au cours "
	note s6_8b: "608C. Ce pilule contraceptive d'urgence a-t-il été en rupture de stock au cours des trois derniers mois ?"
	label define s6_8b 1 "Oui" 2 "Non"
	label values s6_8b s6_8b

	label variable s6_18b "609C. Depuis combien de semaines ce pilule contraceptive d'urgence n'est pas/n'a"
	note s6_18b: "609C. Depuis combien de semaines ce pilule contraceptive d'urgence n'est pas/n'a pas été disponible dans la structure sanitaire ?"

	label variable s6_19b "610C. Raisons de la non-disponibilité"
	note s6_19b: "610C. Raisons de la non-disponibilité"

	label variable s6_20b "Veuillez préciser la raison"
	note s6_20b: "Veuillez préciser la raison"

	label variable s6_7c "607D. Ce Injectable-Depo Provera est-il disponible ?"
	note s6_7c: "607D. Ce Injectable-Depo Provera est-il disponible ?"
	label define s6_7c 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_7c s6_7c

	label variable s6_8c "608D. Ce Injectable-Depo Provera a-t-il été en rupture de stock au cours des tro"
	note s6_8c: "608D. Ce Injectable-Depo Provera a-t-il été en rupture de stock au cours des trois derniers mois ?"
	label define s6_8c 1 "Oui" 2 "Non"
	label values s6_8c s6_8c

	label variable s6_18c "609D. Depuis combien de semaines ce Injectable-Depo Provera n'est pas/n'a pas ét"
	note s6_18c: "609D. Depuis combien de semaines ce Injectable-Depo Provera n'est pas/n'a pas été disponible dans la structure sanitaire ?"

	label variable s6_19c "610D. Raisons de la non-disponibilité"
	note s6_19c: "610D. Raisons de la non-disponibilité"

	label variable s6_20c "Veuillez préciser la raison"
	note s6_20c: "Veuillez préciser la raison"

	label variable s6_7d "607E. Ce Injectable - Sayana Press est-il disponible ?"
	note s6_7d: "607E. Ce Injectable - Sayana Press est-il disponible ?"
	label define s6_7d 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_7d s6_7d

	label variable s6_8d "608E. Ce Injectable - Sayana Press a-t-il été en rupture de stock au cours des t"
	note s6_8d: "608E. Ce Injectable - Sayana Press a-t-il été en rupture de stock au cours des trois derniers mois ?"
	label define s6_8d 1 "Oui" 2 "Non"
	label values s6_8d s6_8d

	label variable s6_18d "609E. Depuis combien de semaines ce Injectable - Sayana Press n'est pas/n'a pas "
	note s6_18d: "609E. Depuis combien de semaines ce Injectable - Sayana Press n'est pas/n'a pas été disponible dans la structure sanitaire ?"

	label variable s6_19d "610E. Raisons de la non-disponibilité"
	note s6_19d: "610E. Raisons de la non-disponibilité"

	label variable s6_20d "Veuillez préciser la raison"
	note s6_20d: "Veuillez préciser la raison"

	label variable s6_7e "607F. Ce Implants est-il disponible ?"
	note s6_7e: "607F. Ce Implants est-il disponible ?"
	label define s6_7e 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_7e s6_7e

	label variable s6_8e "608F. Ce Implants a-t-il été en rupture de stock au cours des trois derniers moi"
	note s6_8e: "608F. Ce Implants a-t-il été en rupture de stock au cours des trois derniers mois ?"
	label define s6_8e 1 "Oui" 2 "Non"
	label values s6_8e s6_8e

	label variable s6_18e "609F. Depuis combien de semaines ce Implants n'est pas/n'a pas été disponible da"
	note s6_18e: "609F. Depuis combien de semaines ce Implants n'est pas/n'a pas été disponible dans la structure sanitaire ?"

	label variable s6_19e "610F. Raisons de la non-disponibilité"
	note s6_19e: "610F. Raisons de la non-disponibilité"

	label variable s6_20e "Veuillez préciser la raison"
	note s6_20e: "Veuillez préciser la raison"

	label variable s6_7f "607G. Ce Pilule contraceptive orale est-il disponible ?"
	note s6_7f: "607G. Ce Pilule contraceptive orale est-il disponible ?"
	label define s6_7f 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_7f s6_7f

	label variable s6_8f "608G. Ce Pilule contraceptive orale a-t-il été en rupture de stock au cours des "
	note s6_8f: "608G. Ce Pilule contraceptive orale a-t-il été en rupture de stock au cours des trois derniers mois ?"
	label define s6_8f 1 "Oui" 2 "Non"
	label values s6_8f s6_8f

	label variable s6_18f "609G. Depuis combien de semaines ce Pilule contraceptive orale n'est pas/n'a pas"
	note s6_18f: "609G. Depuis combien de semaines ce Pilule contraceptive orale n'est pas/n'a pas été disponible dans la structure sanitaire ?"

	label variable s6_19f "610G. Raisons de la non-disponibilité"
	note s6_19f: "610G. Raisons de la non-disponibilité"

	label variable s6_20f "Veuillez préciser la raison"
	note s6_20f: "Veuillez préciser la raison"

	label variable s6_7g "607H. Ce Pilules à base de progestérone uniquement est-il disponible ?"
	note s6_7g: "607H. Ce Pilules à base de progestérone uniquement est-il disponible ?"
	label define s6_7g 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_7g s6_7g

	label variable s6_8g "608H. Ce Pilules à base de progestérone uniquement a-t-il été en rupture de stoc"
	note s6_8g: "608H. Ce Pilules à base de progestérone uniquement a-t-il été en rupture de stock au cours des trois derniers mois ?"
	label define s6_8g 1 "Oui" 2 "Non"
	label values s6_8g s6_8g

	label variable s6_18g "609H. Depuis combien de semaines ce Pilules à base de progestérone uniquement n'"
	note s6_18g: "609H. Depuis combien de semaines ce Pilules à base de progestérone uniquement n'est pas/n'a pas été disponible dans la structure sanitaire ?"

	label variable s6_19g "610H. Raisons de la non-disponibilité"
	note s6_19g: "610H. Raisons de la non-disponibilité"

	label variable s6_20g "Veuillez préciser la raison"
	note s6_20g: "Veuillez préciser la raison"

	label variable s6_7h "607I. Ce DIU est-il disponible ?"
	note s6_7h: "607I. Ce DIU est-il disponible ?"
	label define s6_7h 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_7h s6_7h

	label variable s6_8h "608I. Ce DIU a-t-il été en rupture de stock au cours des trois derniers mois ?"
	note s6_8h: "608I. Ce DIU a-t-il été en rupture de stock au cours des trois derniers mois ?"
	label define s6_8h 1 "Oui" 2 "Non"
	label values s6_8h s6_8h

	label variable s6_18h "609I. Depuis combien de semaines ce DIU n'est pas/n'a pas été disponible dans la"
	note s6_18h: "609I. Depuis combien de semaines ce DIU n'est pas/n'a pas été disponible dans la structure sanitaire ?"

	label variable s6_19h "610I. Raisons de la non-disponibilité"
	note s6_19h: "610I. Raisons de la non-disponibilité"

	label variable s6_20h "Veuillez préciser la raison"
	note s6_20h: "Veuillez préciser la raison"

	label variable s6_5 "605. Combien de kits complets de DIU sont disponibles dans la structure sanitair"
	note s6_5: "605. Combien de kits complets de DIU sont disponibles dans la structure sanitaire ?"

	label variable s6_7i "607J. Ce Anneaux tubulaires est-il disponible ?"
	note s6_7i: "607J. Ce Anneaux tubulaires est-il disponible ?"
	label define s6_7i 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_7i s6_7i

	label variable s6_8i "608J. Ce Anneaux tubulaires a-t-il été en rupture de stock au cours des trois de"
	note s6_8i: "608J. Ce Anneaux tubulaires a-t-il été en rupture de stock au cours des trois derniers mois ?"
	label define s6_8i 1 "Oui" 2 "Non"
	label values s6_8i s6_8i

	label variable s6_18i "609J. Depuis combien de semaines ce Anneaux tubulaires n'est pas/n'a pas été dis"
	note s6_18i: "609J. Depuis combien de semaines ce Anneaux tubulaires n'est pas/n'a pas été disponible dans la structure sanitaire ?"

	label variable s6_19i "610J. Raisons de la non-disponibilité"
	note s6_19i: "610J. Raisons de la non-disponibilité"

	label variable s6_20i "Veuillez préciser la raison"
	note s6_20i: "Veuillez préciser la raison"

	label variable s6_7j "607K. Ce Kits de test de grossesse est-il disponible ?"
	note s6_7j: "607K. Ce Kits de test de grossesse est-il disponible ?"
	label define s6_7j 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_7j s6_7j

	label variable s6_8j "608K. Ce Kits de test de grossesse a-t-il été en rupture de stock au cours des t"
	note s6_8j: "608K. Ce Kits de test de grossesse a-t-il été en rupture de stock au cours des trois derniers mois ?"
	label define s6_8j 1 "Oui" 2 "Non"
	label values s6_8j s6_8j

	label variable s6_18j "609K. Depuis combien de semaines ce Kits de test de grossesse n'est pas/n'a pas "
	note s6_18j: "609K. Depuis combien de semaines ce Kits de test de grossesse n'est pas/n'a pas été disponible dans la structure sanitaire ?"

	label variable s6_19j "610K. Raisons de la non-disponibilité"
	note s6_19j: "610K. Raisons de la non-disponibilité"

	label variable s6_20j "Veuillez préciser la raison"
	note s6_20j: "Veuillez préciser la raison"

	label variable s6_20_1 "Fer et acide folique comprimé"
	note s6_20_1: "Fer et acide folique comprimé"
	label define s6_20_1 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_1 s6_20_1

	label variable s6_20_2 "Fer et acide folique injectable"
	note s6_20_2: "Fer et acide folique injectable"
	label define s6_20_2 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_2 s6_20_2

	label variable s6_20_3 "Sulfate de zinc"
	note s6_20_3: "Sulfate de zinc"
	label define s6_20_3 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_3 s6_20_3

	label variable s6_20_4 "Fer et acide folique sirop"
	note s6_20_4: "Fer et acide folique sirop"
	label define s6_20_4 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_4 s6_20_4

	label variable s6_20_5 "Vitamine A sirop"
	note s6_20_5: "Vitamine A sirop"
	label define s6_20_5 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_5 s6_20_5

	label variable s6_20_6 "Fer Saccharose Injectable"
	note s6_20_6: "Fer Saccharose Injectable"
	label define s6_20_6 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_6 s6_20_6

	label variable s6_20_7 "Oxytocine injectables (Syntocinon / Pitocin)"
	note s6_20_7: "Oxytocine injectables (Syntocinon / Pitocin)"
	label define s6_20_7 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_7 s6_20_7

	label variable s6_20_8 "Hyoscine Butyl Bromide Injectable"
	note s6_20_8: "Hyoscine Butyl Bromide Injectable"
	label define s6_20_8 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_8 s6_20_8

	label variable s6_20_9 "Methergine/ Methylergometrine Injectable"
	note s6_20_9: "Methergine/ Methylergometrine Injectable"
	label define s6_20_9 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_9 s6_20_9

	label variable s6_20_10 "Méthylergométrine Comprimés"
	note s6_20_10: "Méthylergométrine Comprimés"
	label define s6_20_10 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_10 s6_20_10

	label variable s6_20_11 "Misoprostol comprimé/ Prostodine Injectable"
	note s6_20_11: "Misoprostol comprimé/ Prostodine Injectable"
	label define s6_20_11 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_11 s6_20_11

	label variable s6_20_12 "Sulfate de magnésium Injectable"
	note s6_20_12: "Sulfate de magnésium Injectable"
	label define s6_20_12 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_12 s6_20_12

	label variable s6_20_13 "Bétaméthasone / Dexaméthasone Injectable"
	note s6_20_13: "Bétaméthasone / Dexaméthasone Injectable"
	label define s6_20_13 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_13 s6_20_13

	label variable s6_20_14 "Nifédipine / comprimés"
	note s6_20_14: "Nifédipine / comprimés"
	label define s6_20_14 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_14 s6_20_14

	label variable s6_20_15 "Hydralazine Injectable"
	note s6_20_15: "Hydralazine Injectable"
	label define s6_20_15 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_15 s6_20_15

	label variable s6_20_16 "Diazepam Injectable"
	note s6_20_16: "Diazepam Injectable"
	label define s6_20_16 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_16 s6_20_16

	label variable s6_20_17 "Amoxycilline Comprimés"
	note s6_20_17: "Amoxycilline Comprimés"
	label define s6_20_17 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_17 s6_20_17

	label variable s6_20_18 "Amoxycilline Injectable"
	note s6_20_18: "Amoxycilline Injectable"
	label define s6_20_18 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_18 s6_20_18

	label variable s6_20_19 "Ampicilline Comprimés"
	note s6_20_19: "Ampicilline Comprimés"
	label define s6_20_19 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_19 s6_20_19

	label variable s6_20_20 "Ampicilline Injectable"
	note s6_20_20: "Ampicilline Injectable"
	label define s6_20_20 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_20 s6_20_20

	label variable s6_20_21 "Tinidazole Comprimés"
	note s6_20_21: "Tinidazole Comprimés"
	label define s6_20_21 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_21 s6_20_21

	label variable s6_20_22 "Cloxacilline Comprimés"
	note s6_20_22: "Cloxacilline Comprimés"
	label define s6_20_22 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_22 s6_20_22

	label variable s6_20_23 "Erythromycine Comprimés"
	note s6_20_23: "Erythromycine Comprimés"
	label define s6_20_23 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_23 s6_20_23

	label variable s6_20_24 "Gentamycine Injectable"
	note s6_20_24: "Gentamycine Injectable"
	label define s6_20_24 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_24 s6_20_24

	label variable s6_20_25 "Métronidazole Comprimés"
	note s6_20_25: "Métronidazole Comprimés"
	label define s6_20_25 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_25 s6_20_25

	label variable s6_20_26 "Métronidazole Injectable"
	note s6_20_26: "Métronidazole Injectable"
	label define s6_20_26 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_26 s6_20_26

	label variable s6_20_27 "Albendazole /Mebendazole Injectable"
	note s6_20_27: "Albendazole /Mebendazole Injectable"
	label define s6_20_27 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_27 s6_20_27

	label variable s6_20_28 "Albendazole Sirop"
	note s6_20_28: "Albendazole Sirop"
	label define s6_20_28 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_28 s6_20_28

	label variable s6_20_29 "Dicyclomine Comprimés"
	note s6_20_29: "Dicyclomine Comprimés"
	label define s6_20_29 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_29 s6_20_29

	label variable s6_20_30 "Paracétamol / Diclofénac (Voveran) Comprimés"
	note s6_20_30: "Paracétamol / Diclofénac (Voveran) Comprimés"
	label define s6_20_30 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_30 s6_20_30

	label variable s6_20_31 "Ibuprofène Comprimés"
	note s6_20_31: "Ibuprofène Comprimés"
	label define s6_20_31 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_31 s6_20_31

	label variable s6_20_32 "Paracetamol / Diclofenac Sodium (Voveran) Injectable"
	note s6_20_32: "Paracetamol / Diclofenac Sodium (Voveran) Injectable"
	label define s6_20_32 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_32 s6_20_32

	label variable s6_20_33 "Pommade ophtalmique au chloramphénicol"
	note s6_20_33: "Pommade ophtalmique au chloramphénicol"
	label define s6_20_33 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_33 s6_20_33

	label variable s6_20_34 "Adrénaline Injectable"
	note s6_20_34: "Adrénaline Injectable"
	label define s6_20_34 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_34 s6_20_34

	label variable s6_20_35 "Amikacine Injectable"
	note s6_20_35: "Amikacine Injectable"
	label define s6_20_35 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_35 s6_20_35

	label variable s6_20_36 "Xylocaïne / Lidocaïne / Linocaïne Injectable"
	note s6_20_36: "Xylocaïne / Lidocaïne / Linocaïne Injectable"
	label define s6_20_36 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_36 s6_20_36

	label variable s6_20_37 "Sensorcaine Injectable"
	note s6_20_37: "Sensorcaine Injectable"
	label define s6_20_37 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_37 s6_20_37

	label variable s6_20_38 "Phénobarbital Injectable"
	note s6_20_38: "Phénobarbital Injectable"
	label define s6_20_38 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_38 s6_20_38

	label variable s6_20_39 "Phénytoïne Injectable"
	note s6_20_39: "Phénytoïne Injectable"
	label define s6_20_39 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_39 s6_20_39

	label variable s6_20_40 "Ceftriaxone sodique Injectable"
	note s6_20_40: "Ceftriaxone sodique Injectable"
	label define s6_20_40 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_40 s6_20_40

	label variable s6_20_41 "Cefotoxamine Injectable"
	note s6_20_41: "Cefotoxamine Injectable"
	label define s6_20_41 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_41 s6_20_41

	label variable s6_20_42 "Promethazine HCL Injectable"
	note s6_20_42: "Promethazine HCL Injectable"
	label define s6_20_42 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_42 s6_20_42

	label variable s6_20_43 "Chlorure de sodium Injectable"
	note s6_20_43: "Chlorure de sodium Injectable"
	label define s6_20_43 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_43 s6_20_43

	label variable s6_20_44 "Gluconate de calcium Injectable"
	note s6_20_44: "Gluconate de calcium Injectable"
	label define s6_20_44 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_44 s6_20_44

	label variable s6_20_45 "Drotaverine Injectable"
	note s6_20_45: "Drotaverine Injectable"
	label define s6_20_45 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_45 s6_20_45

	label variable s6_20_46 "Atropine Sulphate Injectable"
	note s6_20_46: "Atropine Sulphate Injectable"
	label define s6_20_46 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_46 s6_20_46

	label variable s6_20_47 "Ethamsylate Injectable"
	note s6_20_47: "Ethamsylate Injectable"
	label define s6_20_47 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_47 s6_20_47

	label variable s6_20_48 "Fortwin Injectable"
	note s6_20_48: "Fortwin Injectable"
	label define s6_20_48 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_48 s6_20_48

	label variable s6_20_49 "Furosemide Injectable"
	note s6_20_49: "Furosemide Injectable"
	label define s6_20_49 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_49 s6_20_49

	label variable s6_20_50 "Bromure de Vecoronium Injectable"
	note s6_20_50: "Bromure de Vecoronium Injectable"
	label define s6_20_50 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_50 s6_20_50

	label variable s6_20_51 "Pentanolol de sodium Injectable"
	note s6_20_51: "Pentanolol de sodium Injectable"
	label define s6_20_51 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_51 s6_20_51

	label variable s6_20_52 "Inj Etophylline+Théophylline"
	note s6_20_52: "Inj Etophylline+Théophylline"
	label define s6_20_52 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_52 s6_20_52

	label variable s6_20_53 "Demperidon goutte"
	note s6_20_53: "Demperidon goutte"
	label define s6_20_53 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_53 s6_20_53

	label variable s6_20_54 "Bicarbonate de sodium Injectable"
	note s6_20_54: "Bicarbonate de sodium Injectable"
	label define s6_20_54 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_54 s6_20_54

	label variable s6_20_55 "Pommade à l'iode de povidone"
	note s6_20_55: "Pommade à l'iode de povidone"
	label define s6_20_55 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_55 s6_20_55

	label variable s6_20_56 "SRO en sachets"
	note s6_20_56: "SRO en sachets"
	label define s6_20_56 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_56 s6_20_56

	label variable s6_20_57 "Ringer Lactate / NS / DNS (500 ml)"
	note s6_20_57: "Ringer Lactate / NS / DNS (500 ml)"
	label define s6_20_57 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_57 s6_20_57

	label variable s6_20_58 "Ampoules de Glucose 10 % ou 30%"
	note s6_20_58: "Ampoules de Glucose 10 % ou 30%"
	label define s6_20_58 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_58 s6_20_58

	label variable s6_20_59 "Névirapine Comprimés"
	note s6_20_59: "Névirapine Comprimés"
	label define s6_20_59 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_59 s6_20_59

	label variable s6_20_60 "Névirapine Sirop"
	note s6_20_60: "Névirapine Sirop"
	label define s6_20_60 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_60 s6_20_60

	label variable s6_20_61 "Bupivacaine Injectable"
	note s6_20_61: "Bupivacaine Injectable"
	label define s6_20_61 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_61 s6_20_61

	label variable s6_20_62 "Thiopentone (Pentothal) / Kétamine / Propofol Injectable"
	note s6_20_62: "Thiopentone (Pentothal) / Kétamine / Propofol Injectable"
	label define s6_20_62 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_62 s6_20_62

	label variable s6_20_63 "Isoflurane / Enflurane / Halothane"
	note s6_20_63: "Isoflurane / Enflurane / Halothane"
	label define s6_20_63 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_63 s6_20_63

	label variable s6_20_64 "Colloïdes (Haemacel /Venofundin)"
	note s6_20_64: "Colloïdes (Haemacel /Venofundin)"
	label define s6_20_64 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_64 s6_20_64

	label variable s6_20_65 "Isolyte P (fluides IV pédiatriques)"
	note s6_20_65: "Isolyte P (fluides IV pédiatriques)"
	label define s6_20_65 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_65 s6_20_65

	label variable s6_20_66 "Vaccin antitétanique injectable"
	note s6_20_66: "Vaccin antitétanique injectable"
	label define s6_20_66 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_66 s6_20_66

	label variable s6_20_67 "Vaccin BCG injectable"
	note s6_20_67: "Vaccin BCG injectable"
	label define s6_20_67 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_67 s6_20_67

	label variable s6_20_68 "Vaccin oral contre la polio (VPO)"
	note s6_20_68: "Vaccin oral contre la polio (VPO)"
	label define s6_20_68 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_68 s6_20_68

	label variable s6_20_69 "Vaccin Penta"
	note s6_20_69: "Vaccin Penta"
	label define s6_20_69 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_69 s6_20_69

	label variable s6_20_70 "Vaccin contre la rougeole Injectable"
	note s6_20_70: "Vaccin contre la rougeole Injectable"
	label define s6_20_70 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_70 s6_20_70

	label variable s6_20_71 "Vit A Injectable"
	note s6_20_71: "Vit A Injectable"
	label define s6_20_71 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_71 s6_20_71

	label variable s6_20_72 "Vit K Injectable"
	note s6_20_72: "Vit K Injectable"
	label define s6_20_72 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_72 s6_20_72

	label variable s6_20_73 "Préservatifs"
	note s6_20_73: "Préservatifs"
	label define s6_20_73 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_73 s6_20_73

	label variable s6_20_74 "Pilules contraceptives orales (OCP, Mala D.)"
	note s6_20_74: "Pilules contraceptives orales (OCP, Mala D.)"
	label define s6_20_74 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_74 s6_20_74

	label variable s6_20_75 "Contraceptifs injectables"
	note s6_20_75: "Contraceptifs injectables"
	label define s6_20_75 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_75 s6_20_75

	label variable s6_20_76 "DIU (cuivre T)"
	note s6_20_76: "DIU (cuivre T)"
	label define s6_20_76 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_76 s6_20_76

	label variable s6_20_77 "Sondes urinaires"
	note s6_20_77: "Sondes urinaires"
	label define s6_20_77 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_77 s6_20_77

	label variable s6_20_78 "Canules IV"
	note s6_20_78: "Canules IV"
	label define s6_20_78 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_78 s6_20_78

	label variable s6_20_79 "Seringues jetables"
	note s6_20_79: "Seringues jetables"
	label define s6_20_79 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_79 s6_20_79

	label variable s6_20_80 "Gants jetables"
	note s6_20_80: "Gants jetables"
	label define s6_20_80 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_80 s6_20_80

	label variable s6_20_81 "Bandelettes d'albumine/sucre urinaire"
	note s6_20_81: "Bandelettes d'albumine/sucre urinaire"
	label define s6_20_81 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_81 s6_20_81

	label variable s6_20_82 "Kits de test de grossesse urinaire"
	note s6_20_82: "Kits de test de grossesse urinaire"
	label define s6_20_82 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_82 s6_20_82

	label variable s6_20_83 "Coton absorbant"
	note s6_20_83: "Coton absorbant"
	label define s6_20_83 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_83 s6_20_83

	label variable s6_20_84 "Compresse absorbante"
	note s6_20_84: "Compresse absorbante"
	label define s6_20_84 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_84 s6_20_84

	label variable s6_20_85 "Serviettes hygiéniques"
	note s6_20_85: "Serviettes hygiéniques"
	label define s6_20_85 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_85 s6_20_85

	label variable s6_20_86 "Gants chirurgicaux"
	note s6_20_86: "Gants chirurgicaux"
	label define s6_20_86 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_86 s6_20_86

	label variable s6_20_87 "Alcool"
	note s6_20_87: "Alcool"
	label define s6_20_87 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_87 s6_20_87

	label variable s6_20_88 "Ruban chirurgical"
	note s6_20_88: "Ruban chirurgical"
	label define s6_20_88 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_88 s6_20_88

	label variable s6_20_89 "Solution d'iode povidone"
	note s6_20_89: "Solution d'iode povidone"
	label define s6_20_89 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_89 s6_20_89

	label variable s6_20_90 "Réactifs pour les anticorps ABO et Rh"
	note s6_20_90: "Réactifs pour les anticorps ABO et Rh"
	label define s6_20_90 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_90 s6_20_90

	label variable s6_20_91 "Kits de test VIH"
	note s6_20_91: "Kits de test VIH"
	label define s6_20_91 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_91 s6_20_91

	label variable s6_20_92 "Carnet de santé de la mère et du nouveau-né"
	note s6_20_92: "Carnet de santé de la mère et du nouveau-né"
	label define s6_20_92 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_92 s6_20_92

	label variable s6_20_93 "Cartes de vaccination pour les moins de 5 ans"
	note s6_20_93: "Cartes de vaccination pour les moins de 5 ans"
	label define s6_20_93 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_93 s6_20_93

	label variable s6_20_94 "Graphiques Partogramme/guide de soins pour l'accouchement"
	note s6_20_94: "Graphiques Partogramme/guide de soins pour l'accouchement"
	label define s6_20_94 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_94 s6_20_94

	label variable s7_1 "701. La structure dispose-t-il d'un espace privé pour les conseils en matière de"
	note s7_1: "701. La structure dispose-t-il d'un espace privé pour les conseils en matière de PF ?"
	label define s7_1 1 "Oui" 2 "Non"
	label values s7_1 s7_1

	label variable s7_2 "702. Un conseiller en PF est-il disponible ?"
	note s7_2: "702. Un conseiller en PF est-il disponible ?"
	label define s7_2 1 "Oui" 2 "Non"
	label values s7_2 s7_2

	label variable s7_3 "703. Le conseil en PF est-il dispensé par une autre personne que le conseiller ?"
	note s7_3: "703. Le conseil en PF est-il dispensé par une autre personne que le conseiller ?"
	label define s7_3 1 "Oui" 2 "Non"
	label values s7_3 s7_3

	label variable s7_4 "704. Les femmes atteintes du VIH/SIDA bénéficient-elles de conseils en matière d"
	note s7_4: "704. Les femmes atteintes du VIH/SIDA bénéficient-elles de conseils en matière de PF dans le cadre de la prévention de la transmission mère-enfant (PTME) ?"
	label define s7_4 1 "Oui" 2 "Non"
	label values s7_4 s7_4

	label variable s7_5 "705. La structure offre-t-elle des conseils en matière de PF aux adolescents ?"
	note s7_5: "705. La structure offre-t-elle des conseils en matière de PF aux adolescents ?"
	label define s7_5 1 "Oui" 2 "Non"
	label values s7_5 s7_5

	label variable s7_6_1 "Panneaux d’orientation"
	note s7_6_1: "Panneaux d’orientation"
	label define s7_6_1 1 "Disponible" 2 "Indisponible"
	label values s7_6_1 s7_6_1

	label variable s7_6_2 "Paravent médical"
	note s7_6_2: "Paravent médical"
	label define s7_6_2 1 "Disponible" 2 "Indisponible"
	label values s7_6_2 s7_6_2

	label variable s7_6_3 "Armoire d’arrangement"
	note s7_6_3: "Armoire d’arrangement"
	label define s7_6_3 1 "Disponible" 2 "Indisponible"
	label values s7_6_3 s7_6_3

	label variable s7_6_4 "Table"
	note s7_6_4: "Table"
	label define s7_6_4 1 "Disponible" 2 "Indisponible"
	label values s7_6_4 s7_6_4

	label variable s7_6_5 "Chaise"
	note s7_6_5: "Chaise"
	label define s7_6_5 1 "Disponible" 2 "Indisponible"
	label values s7_6_5 s7_6_5

	label variable s7_6_6 "Registre des dossiers des clients"
	note s7_6_6: "Registre des dossiers des clients"
	label define s7_6_6 1 "Disponible" 2 "Indisponible"
	label values s7_6_6 s7_6_6

	label variable s7_6_7 "Stock de pilules contraceptives oraux"
	note s7_6_7: "Stock de pilules contraceptives oraux"
	label define s7_6_7 1 "Disponible" 2 "Indisponible"
	label values s7_6_7 s7_6_7

	label variable s7_6_8 "Stock de pilules contraceptives d’urgence"
	note s7_6_8: "Stock de pilules contraceptives d’urgence"
	label define s7_6_8 1 "Disponible" 2 "Indisponible"
	label values s7_6_8 s7_6_8

	label variable s7_6_9 "Stock de préservatifs (masculins)"
	note s7_6_9: "Stock de préservatifs (masculins)"
	label define s7_6_9 1 "Disponible" 2 "Indisponible"
	label values s7_6_9 s7_6_9

	label variable s7_6_10 "Stock de préservatifs (féminins)"
	note s7_6_10: "Stock de préservatifs (féminins)"
	label define s7_6_10 1 "Disponible" 2 "Indisponible"
	label values s7_6_10 s7_6_10

	label variable s7_7_1 "Échantillons de pilules OCP pour démonstration"
	note s7_7_1: "Échantillons de pilules OCP pour démonstration"
	label define s7_7_1 1 "Disponible" 2 "Indisponible"
	label values s7_7_1 s7_7_1

	label variable s7_7_2 "Échantillons de DIU pour démonstration"
	note s7_7_2: "Échantillons de DIU pour démonstration"
	label define s7_7_2 1 "Disponible" 2 "Indisponible"
	label values s7_7_2 s7_7_2

	label variable s7_7_3 "Échantillons de préservatifs pour démonstration"
	note s7_7_3: "Échantillons de préservatifs pour démonstration"
	label define s7_7_3 1 "Disponible" 2 "Indisponible"
	label values s7_7_3 s7_7_3

	label variable s7_7_4 "Modèle de pénis pour démonstration"
	note s7_7_4: "Modèle de pénis pour démonstration"
	label define s7_7_4 1 "Disponible" 2 "Indisponible"
	label values s7_7_4 s7_7_4

	label variable s7_7_5 "Boite à image pour le conseil"
	note s7_7_5: "Boite à image pour le conseil"
	label define s7_7_5 1 "Disponible" 2 "Indisponible"
	label values s7_7_5 s7_7_5

	label variable s7_8_1 "DIU"
	note s7_8_1: "DIU"
	label define s7_8_1 1 "Disponible" 2 "Indisponible"
	label values s7_8_1 s7_8_1

	label variable s7_8_2 "Préservatif"
	note s7_8_2: "Préservatif"
	label define s7_8_2 1 "Disponible" 2 "Indisponible"
	label values s7_8_2 s7_8_2

	label variable s7_8_5 "Contraceptifs injectables"
	note s7_8_5: "Contraceptifs injectables"
	label define s7_8_5 1 "Disponible" 2 "Indisponible"
	label values s7_8_5 s7_8_5

	label variable s7_8_6 "Implants"
	note s7_8_6: "Implants"
	label define s7_8_6 1 "Disponible" 2 "Indisponible"
	label values s7_8_6 s7_8_6

	label variable s7_8_7 "Pilules Contraceptives Orales"
	note s7_8_7: "Pilules Contraceptives Orales"
	label define s7_8_7 1 "Disponible" 2 "Indisponible"
	label values s7_8_7 s7_8_7

	label variable gpslatitude "Coordonnées GPS de la structure (latitude)"
	note gpslatitude: "Coordonnées GPS de la structure (latitude)"

	label variable gpslongitude "Coordonnées GPS de la structure (longitude)"
	note gpslongitude: "Coordonnées GPS de la structure (longitude)"

	label variable gpsaltitude "Coordonnées GPS de la structure (altitude)"
	note gpsaltitude: "Coordonnées GPS de la structure (altitude)"

	label variable gpsaccuracy "Coordonnées GPS de la structure (accuracy)"
	note gpsaccuracy: "Coordonnées GPS de la structure (accuracy)"

	label variable obs "Observations générales/Remarques"
	note obs: "Observations générales/Remarques"






	* append old, previously-imported data (if any)
	cap confirm file "`dtafile'"
	if _rc == 0 {
		* mark all new data before merging with old data
		gen new_data_row=1
		
		* pull in old data
		append using "`dtafile'"
		
		* drop duplicates in favor of old, previously-imported data if overwrite_old_data is 0
		* (alternatively drop in favor of new data if overwrite_old_data is 1)
		sort key
		by key: gen num_for_key = _N
		drop if num_for_key > 1 & ((`overwrite_old_data' == 0 & new_data_row == 1) | (`overwrite_old_data' == 1 & new_data_row ~= 1))
		drop num_for_key

		* drop new-data flag
		drop new_data_row
	}
	
	* save data to Stata format
	save "`dtafile'", replace

	* show codebook and notes
	codebook
	notes list
}

disp
disp "Finished import of: `csvfile'"
disp

* OPTIONAL: LOCALLY-APPLIED STATA CORRECTIONS
*
* Rather than using SurveyCTO's review and correction workflow, the code below can apply a list of corrections
* listed in a local .csv file. Feel free to use, ignore, or delete this code.
*
*   Corrections file path and filename:  F:/Dropbox_APHRC/Dropbox/FP-Project-APHRC-UM/Atelier_FP/Data/raw/QUESTIONNAIRE CLINIQUE PRIVEE_corrections.csv
*
*   Corrections file columns (in order): key, fieldname, value, notes

capture confirm file "`corrfile'"
if _rc==0 {
	disp
	disp "Starting application of corrections in: `corrfile'"
	disp

	* save primary data in memory
	preserve

	* load corrections
	insheet using "`corrfile'", names clear
	
	if _N>0 {
		* number all rows (with +1 offset so that it matches row numbers in Excel)
		gen rownum=_n+1
		
		* drop notes field (for information only)
		drop notes
		
		* make sure that all values are in string format to start
		gen origvalue=value
		tostring value, format(%100.0g) replace
		cap replace value="" if origvalue==.
		drop origvalue
		replace value=trim(value)
		
		* correct field names to match Stata field names (lowercase, drop -'s and .'s)
		replace fieldname=lower(subinstr(subinstr(fieldname,"-","",.),".","",.))
		
		* format date and date/time fields (taking account of possible wildcards for repeat groups)
		forvalues i = 1/100 {
			if "`datetime_fields`i''" ~= "" {
				foreach dtvar in `datetime_fields`i'' {
					* skip fields that aren't yet in the data
					cap unab dtvarignore : `dtvar'
					if _rc==0 {
						gen origvalue=value
						replace value=string(clock(value,"MDYhms",2025),"%25.0g") if strmatch(fieldname,"`dtvar'")
						* allow for cases where seconds haven't been specified
						replace value=string(clock(origvalue,"MDYhm",2025),"%25.0g") if strmatch(fieldname,"`dtvar'") & value=="." & origvalue~="."
						drop origvalue
					}
				}
			}
			if "`date_fields`i''" ~= "" {
				foreach dtvar in `date_fields`i'' {
					* skip fields that aren't yet in the data
					cap unab dtvarignore : `dtvar'
					if _rc==0 {
						replace value=string(clock(value,"MDY",2025),"%25.0g") if strmatch(fieldname,"`dtvar'")
					}
				}
			}
		}

		* write out a temp file with the commands necessary to apply each correction
		tempfile tempdo
		file open dofile using "`tempdo'", write replace
		local N = _N
		forvalues i = 1/`N' {
			local fieldnameval=fieldname[`i']
			local valueval=value[`i']
			local keyval=key[`i']
			local rownumval=rownum[`i']
			file write dofile `"cap replace `fieldnameval'="`valueval'" if key=="`keyval'""' _n
			file write dofile `"if _rc ~= 0 {"' _n
			if "`valueval'" == "" {
				file write dofile _tab `"cap replace `fieldnameval'=. if key=="`keyval'""' _n
			}
			else {
				file write dofile _tab `"cap replace `fieldnameval'=`valueval' if key=="`keyval'""' _n
			}
			file write dofile _tab `"if _rc ~= 0 {"' _n
			file write dofile _tab _tab `"disp"' _n
			file write dofile _tab _tab `"disp "CAN'T APPLY CORRECTION IN ROW #`rownumval'""' _n
			file write dofile _tab _tab `"disp"' _n
			file write dofile _tab `"}"' _n
			file write dofile `"}"' _n
		}
		file close dofile
	
		* restore primary data
		restore
		
		* execute the .do file to actually apply all corrections
		do "`tempdo'"

		* re-save data
		save "`dtafile'", replace
	}
	else {
		* restore primary data		
		restore
	}

	disp
	disp "Finished applying corrections in: `corrfile'"
	disp
}


* launch .do files to process repeat groups

do "F:\Dropbox_APHRC\Dropbox\FP-Project-APHRC-UM\Atelier_FP\codes\import\import_clinique-section_41-personnel.do"
