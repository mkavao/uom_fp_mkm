* import_clients_corr.do
*
* 	Imports and aggregates "QUESTIONNAIRE CLIENTE PF" (ID: clients_corr) data.
*
*	Inputs:  "F:/Dropbox_APHRC/Dropbox/FP-Project-APHRC-UM/Atelier_FP/Data/raw/QUESTIONNAIRE CLIENTE PF.csv"
*	Outputs: "F:/Dropbox_APHRC/Dropbox/FP-Project-APHRC-UM/Atelier_FP/Data/raw/QUESTIONNAIRE CLIENTE PF.dta"
*
*	Output by SurveyCTO March 26, 2025 8:20 AM.

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
local csvfile "F:/Dropbox_APHRC/Dropbox/FP-Project-APHRC-UM/Atelier_FP/Data/raw/QUESTIONNAIRE CLIENTE PF.csv"
local dtafile "F:/Dropbox_APHRC/Dropbox/FP-Project-APHRC-UM/Atelier_FP/Data/raw/client_data_long_raw.dta"
local corrfile "F:/Dropbox_APHRC/Dropbox/FP-Project-APHRC-UM/Atelier_FP/Data/raw/QUESTIONNAIRE CLIENTE PF_corrections.csv"
local note_fields1 ""
local text_fields1 "deviceid subscriberid simid devicephonenum autre_structure s200b s200b_1 s3_3 s3_9_1 s3_10_1 produitb_label s4_7 s4_7_aut s4_17 s4_17_1 s4_18_1 s4_19b s4_19b_1 s4_22 s4_22_ s4_25 s4_29 s4_29_"
local text_fields2 "s4_30_11_other s4_32 s4_32_autre s4_34 s4_34_ s4_35 s4_35_1 s4_72 obs instanceid"
local date_fields1 "today"
local datetime_fields1 "submissiondate start end fin"

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

	label variable equipe "Choisir l'équipe"
	note equipe: "Choisir l'équipe"
	label define equipe 1 "Equipe 1" 2 "Equipe 2" 3 "Equipe 3" 4 "Equipe 4" 5 "Equipe 5" 6 "Equipe 6" 7 "Equipe 7" 8 "Equipe 8" 9 "Equipe 9" 10 "Equipe 10" 11 "Equipe 11" 12 "Equipe 12" 13 "Equipe 13" 14 "Equipe 14" 15 "Equipe 15" 16 "Equipe 16" 17 "Equipe 17" 18 "Equipe 18" 19 "Equipe 19" 20 "Equipe 20" 21 "Equipe 21"
	label values equipe equipe

	label variable enqueteur "Nom de l'enquêteur"
	note enqueteur: "Nom de l'enquêteur"
	label define enqueteur 1 "Fleur Kona" 2 "Maimouna Yaye Pode Faye" 3 "Malick Ndiongue" 4 "Catherine Mendy" 5 "Mamadou Yacine Diallo Diallo" 6 "Yacine Sall Koumba Boulingui" 7 "Maty Leye" 8 "Fatoumata Binta Bah" 9 "Awa Diouf" 10 "Madicke Diop" 11 "Arona Diagne" 12 "Mame Salane Thiongane" 13 "Débo Diop" 14 "Ndeye Aby Gaye" 15 "Papa amadou Dieye" 16 "Younousse Chérif Goudiaby" 17 "Marieme Boye" 18 "Ibrahima Thiam" 19 "Ahmed Sene" 20 "Mame Gnagna Diagne Kane" 21 "Latyr Diagne" 22 "Sokhna Beye" 23 "Abdoul Khadre Djeylani Gueye" 24 "Bah Fall" 25 "Ndeye Mareme Diop" 26 "Ousmane Mbengue" 27 "Amadou Gueye" 28 "Momar Diop" 29 "Serigne Sow" 30 "Christophe Diouf" 31 "Maimouna Kane" 32 "Tabasky Diouf" 33 "Ndeye Anna Thiam" 34 "Youssou Diallo" 35 "Abdourahmane Niang" 36 "Mame Diarra Bousso Ndao" 37 "Omar Cisse" 38 "Coumba Kane" 39 "Yacine Sall" 40 "Mamadou Mar" 41 "Nayèdio Ba" 42 "Mame Bousso Faye" 43 "Rokhaya Gueye" 44 "Ousmane Samba Gaye" 45 "Ibrahima Diarra" 46 "Khardiata Kane" 47 "Idrissa Gaye" 48 "Mafoudya Camara" 49 "Mouhamed Fall" 50 "Pape Amadou Diop" 51 "Diarra Ndoye" 52 "Bintou Ly" 53 "Mame Mossane Biram Sarr" 54 "Adama Diaw" 55 "Maty Sarr" 56 "Mouhamadou Moustapha Ba" 57 "Serigne saliou Ngom" 58 "Aminata Harouna Dieng" 59 "Aminata Sall Diéye" 60 "Sophie Faye" 61 "Bintou Gueye" 62 "Louise Taky bonang" 63 "Salimata Diallo" 64 "Adama Ba" 65 "Mamour Diop" 66 "Ndeye Ouleye Sarr" 67 "Djiby Diouf" 68 "Madicke Gaye" 69 "Mouhamadou Sy" 70 "Sokhna Diaité" 71 "Mbaye Ndoye" 72 "Moussa Kane" 73 "Cheikh Ndao" 74 "Yaya Balde" 75 "Cheikh Modou Falilou Faye" 76 "Seydina Ousseynou Wade" 77 "Khadim Diouf" 78 "Awa Ndiaye" 79 "Dieynaba Tall" 80 "Souleymane Diol" 81 "Lamine Diop" 82 "Gnima Diedhiou" 83 "Clara Sadio" 84 "Fatoumata Diémé"
	label values enqueteur enqueteur

	label variable nom_structure "106. Nom de la structure sanitaire"
	note nom_structure: "106. Nom de la structure sanitaire"
	label define nom_structure 1 "CS Gaspard Camara" 2 "CS Grand Dakar" 3 "CS HLM" 4 "CS Hann Mer" 5 "CS Liberté 6 (Mamadou DIOP)" 6 "CS Mariste" 7 "EPS Hopital de Fann" 18 "CS Abdoul Aziz SY Dabakh" 19 "CS Camberene" 20 "CS Nabil Choucair" 21 "CS SAMU Municipal Grand Yoff" 22 "EPS Hoggy" 35 "CS Annette Mbaye Derneville" 36 "CS Municipal de Ouakam" 37 "CS Ngor" 38 "CS Philippe Senghor" 39 "EPS Hôpital Militaire de Ouakam (Hmo)" 47 "CS Cheikh Ahmadou Bamba Mbacke" 48 "CS Colobane" 49 "CS Elisabeth Diouf" 50 "CS Keur Yaye Sylvie" 51 "CS Plateau" 52 "EPS Institut Hygiene Sociale" 53 "EPS Hopital Abass Ndao" 54 "EPS Hopital Principal" 62 "CS Diamniadio" 63 "CS Ndiaye Diouf" 64 "EPS Hôpital d'Enfant Diamniadio" 77 "CS Wakhinane" 78 "EPS Dalal Jamm" 79 "EPS Roi Baudoin" 90 "CS Keur Massar" 99 "CS Khadim Rassoul" 100 "EPS Pikine" 101 "EPS Psychiatrique de Thiaroye" 116 "CS Dominique" 129 "CS Polyclinique" 130 "CS SOCOCIM" 131 "EPS Youssou Mbargane Diop" 144 "CS Sangalkam" 160 "CS yeumbeul" 170 "CS Bambey" 202 "CS Diourbel" 203 "CS Ndindy" 204 "EPS Lubke de Diourbel" 225 "CS Mbacke" 249 "CS Darou Marnane" 250 "CS Darou Tanzil" 251 "CS Keur Niang" 252 "CS Saïdyl Badawi" 253 "CS Serigne Mbacke Madina" 254 "CS Serigne Saliou Mbacke" 255 "EPS Ndamatou" 256 "EPS Cheikh Ahmadoul Khadim" 257 "EPS Matlaboul Fawzayni" 286 "Cs Diakhao" 301 "CS Dioffior" 317 "CS Fatick" 318 "CS prive Dal Xel de Fatick" 319 "EPS de Fatick" 343 "CS Foundiougne" 344 "CS Niodior" 355 "CS Gossas" 369 "CS Niakhar" 382 "CS Passy" 398 "CS Sokone" 425 "CS de Mbirkilane" 444 "PS Ngodiba" 445 "CS de Kaffrine" 446 "EPS Thierno Birahim Ndao" 475 "CS Koungheul" 508 "CS Malem Hodar" 532 "CS Guinguineo" 558 "PS Sibassor" 559 "CS Kasnack" 560 "EPS El hadji Ibrahima NIASS de Kaolack" 590 "CS Ndoffane" 615 "CS Nioro" 616 "CS Wack Ngouna" 657 "CS Kedougou" 658 "CS Ndormi" 659 "EPS Amath Dansokho" 675 "CS Salemata" 685 "CS Saraya" 708 "CS Kolda" 709 "EPS Kolda" 751 "CS Medina Yoro Foulah" 775 "CS Medina gounass" 776 "CS Velingara" 808 "CS Dahra" 828 "CS Darou Mousty" 829 "CS Mbacke Kadior" 848 "CS Gueoul" 849 "CS Kebemer" 866 "CS Keur Momar SARR" 880 "CS Coki" 892 "CS Linguere" 893 "EPS Linguere" 907 "CS Louga" 908 "EPS Amadou Sakhir Mbaye de Louga" 927 "CS Sakal" 941 "CS Hamady Ounare" 942 "CS Kanel" 943 "CS Waounde" 989 "CS Matam" 990 "EPS Régional de Matam" 991 "EPS de Ouroussogui" 1019 "CS Ranerou" 1037 "CS Thilogne" 1038 "EPS AGNAM" 1056 "CS Dagana" 1069 "CS Aere Lao" 1070 "CS Cascas" 1071 "CS Galoya" 1072 "CS Pete" 1106 "CS Podor" 1107 "CS Thile Boubacar" 1108 "EPS de NDioum" 1146 "CS Richard Toll" 1147 "CS Ross Bethio" 1148 "CSS" 1149 "EPS Richard Toll" 1171 "CS Mpal" 1172 "CS Saint - Louis" 1173 "DPS Yonou Ndoub" 1174 "EPS de Saint Louis" 1192 "CS Bounkiling" 1219 "CS Goudomp" 1220 "CS Samine" 1236 "CS Bambaly" 1237 "CS Sedhiou" 1238 "EPS Sedhiou" 1260 "CS Bakel" 1284 "CS Dianké Makha" 1305 "CS Goudiry" 1328 "CS Kidira" 1352 "CS Koumpentoum" 1375 "CS Maka" 1388 "CS Tambacounda" 1389 "EPS Tambacounda" 1418 "CS Joal" 1427 "CS Khombole" 1448 "CS Mbour" 1449 "EPS Mbour" 1484 "CS Mekhe" 1514 "CS Popenguine" 1525 "CS Pout" 1536 "CS Thiadiaye" 1551 "CS 10ème de THIES" 1552 "CS Keur Mame El Hadji" 1553 "EPS Amadou S Dieuguene" 1586 "PS Randoulene" 1587 "CS Tivaouane" 1588 "EPS ABDOU AZIZ SY" 1618 "CS Bignona" 1654 "CS Diouloulou" 1676 "CS Oussouye" 1691 "CS Thionck Essyl" 1705 "CS Ziguinchor" 1706 "EPS CHR ZIGUINCHOR" 1707 "EPS Hopital de la Paix" 2001 "Ajouter une nouvelle structure" 2002 "Ajouter une nouvelle structure" 2003 "Ajouter une nouvelle structure" 2004 "Ajouter une nouvelle structure" 2005 "Ajouter une nouvelle structure" 2006 "Ajouter une nouvelle structure" 2007 "Ajouter une nouvelle structure" 2008 "Ajouter une nouvelle structure" 2009 "Ajouter une nouvelle structure" 2010 "Ajouter une nouvelle structure" 2011 "Ajouter une nouvelle structure" 2012 "Ajouter une nouvelle structure" 2013 "Ajouter une nouvelle structure" 2014 "Ajouter une nouvelle structure" 2015 "Ajouter une nouvelle structure" 2016 "Ajouter une nouvelle structure" 2017 "Ajouter une nouvelle structure" 2018 "Ajouter une nouvelle structure" 2019 "Ajouter une nouvelle structure" 2020 "Ajouter une nouvelle structure" 2021 "Ajouter une nouvelle structure" 2022 "Ajouter une nouvelle structure" 2023 "Ajouter une nouvelle structure" 2024 "Ajouter une nouvelle structure" 2025 "Ajouter une nouvelle structure" 2026 "Ajouter une nouvelle structure" 2027 "Ajouter une nouvelle structure" 2028 "Ajouter une nouvelle structure" 2029 "Ajouter une nouvelle structure" 2030 "Ajouter une nouvelle structure" 2031 "Ajouter une nouvelle structure" 2032 "Ajouter une nouvelle structure" 2033 "Ajouter une nouvelle structure" 2034 "Ajouter une nouvelle structure" 2035 "Ajouter une nouvelle structure" 2036 "Ajouter une nouvelle structure" 2037 "Ajouter une nouvelle structure" 2038 "Ajouter une nouvelle structure" 2039 "Ajouter une nouvelle structure" 2040 "Ajouter une nouvelle structure" 2041 "Ajouter une nouvelle structure" 2042 "Ajouter une nouvelle structure" 2043 "Ajouter une nouvelle structure" 2044 "Ajouter une nouvelle structure" 2045 "Ajouter une nouvelle structure" 2046 "Ajouter une nouvelle structure" 2047 "Ajouter une nouvelle structure" 2048 "Ajouter une nouvelle structure" 2049 "Ajouter une nouvelle structure" 2050 "Ajouter une nouvelle structure" 2051 "Ajouter une nouvelle structure" 2052 "Ajouter une nouvelle structure" 2053 "Ajouter une nouvelle structure" 2054 "Ajouter une nouvelle structure" 2055 "Ajouter une nouvelle structure" 2056 "Ajouter une nouvelle structure" 2057 "Ajouter une nouvelle structure" 2058 "Ajouter une nouvelle structure" 2059 "Ajouter une nouvelle structure" 2060 "Ajouter une nouvelle structure" 2061 "Ajouter une nouvelle structure" 2062 "Ajouter une nouvelle structure" 2063 "Ajouter une nouvelle structure" 2064 "Ajouter une nouvelle structure" 2065 "Ajouter une nouvelle structure" 2066 "Ajouter une nouvelle structure" 2067 "Ajouter une nouvelle structure" 2068 "Ajouter une nouvelle structure" 2069 "Ajouter une nouvelle structure" 2070 "Ajouter une nouvelle structure" 2071 "Ajouter une nouvelle structure" 2072 "Ajouter une nouvelle structure" 2073 "Ajouter une nouvelle structure" 2074 "Ajouter une nouvelle structure" 2075 "Ajouter une nouvelle structure" 2076 "Ajouter une nouvelle structure" 2077 "Ajouter une nouvelle structure" 2078 "Ajouter une nouvelle structure" 2079 "Ajouter une nouvelle structure"
	label values nom_structure nom_structure

	label variable autre_structure "Nouvelle structure"
	note autre_structure: "Nouvelle structure"

	label variable s1_5 "105. Type de lieu"
	note s1_5: "105. Type de lieu"
	label define s1_5 1 "Rural" 2 "Urbain"
	label values s1_5 s1_5

	label variable s200a "200a. Ce client sort-il du service de consultation (SC) ou de l’hospitalisation "
	note s200a: "200a. Ce client sort-il du service de consultation (SC) ou de l’hospitalisation (SH) de la maternité ?"
	label define s200a 1 "SC" 2 "SH"
	label values s200a s200a

	label variable s200b "200b. Quel(s) est(sont) le(les) service(s) qu’il a reçu ?"
	note s200b: "200b. Quel(s) est(sont) le(les) service(s) qu’il a reçu ?"

	label variable s200b_1 "Veuillez préciser l'(les) autre(s) service(s) reçu(s)"
	note s200b_1: "Veuillez préciser l'(les) autre(s) service(s) reçu(s)"

	label variable s3_1 "301. Sexe du client ?"
	note s3_1: "301. Sexe du client ?"
	label define s3_1 1 "Homme" 2 "Femme"
	label values s3_1 s3_1

	label variable s3_2 "302. Quel âge avez-vous (répondant) ?"
	note s3_2: "302. Quel âge avez-vous (répondant) ?"

	label variable s3_3 "303. Pouvez-vous lire et écrire ?"
	note s3_3: "303. Pouvez-vous lire et écrire ?"

	label variable s3_4 "304. Quel est le niveau scolaire le plus élevé que vous avez atteint ?"
	note s3_4: "304. Quel est le niveau scolaire le plus élevé que vous avez atteint ?"
	label define s3_4 1 "Primaire" 2 "Collège" 3 "Lycée" 4 "Supérieur" 0 "N'a jamais fréquenté l'école"
	label values s3_4 s3_4

	label variable s3_5 "305. Quelle est votre situation professionnelle actuelle ?"
	note s3_5: "305. Quelle est votre situation professionnelle actuelle ?"
	label define s3_5 1 "Emploi rémunéré (Salarié/AGR)" 2 "Sans emploi" 3 "Chômage" 4 "Retraité" 5 "Elève/Etudiant"
	label values s3_5 s3_5

	label variable s3_6 "306. Quelle est votre situation matrimoniale actuelle ?"
	note s3_6: "306. Quelle est votre situation matrimoniale actuelle ?"
	label define s3_6 1 "Marié ( e)" 2 "Veuf(ve)" 3 "Divorcé(e)" 4 "Séparé( e)" 5 "Célibataire" 6 "Union libre"
	label values s3_6 s3_6

	label variable s3_7 "307. Quel est votre milieu de résidence, urbain ou rural ?"
	note s3_7: "307. Quel est votre milieu de résidence, urbain ou rural ?"
	label define s3_7 1 "Urbain" 2 "Rural"
	label values s3_7 s3_7

	label variable s3_8 "308. Quelle est la distance entre votre domicile et la structure sanitaire (dans"
	note s3_8: "308. Quelle est la distance entre votre domicile et la structure sanitaire (dans laquelle nous nous trouvons) ?"

	label variable s3_9 "309. Quel type de transport avez-vous utilisé pour venir ici à cette structure s"
	note s3_9: "309. Quel type de transport avez-vous utilisé pour venir ici à cette structure sanitaire ?"
	label define s3_9 1 "Transport public" 2 "Véhicule privé" 3 "Ambulance gouvernementale" 4 "Marche" 5 "Pas constant/dépend de la situation" 6 "Autres (Précisez)"
	label values s3_9 s3_9

	label variable s3_9_1 "Veuillez préciser le type de transport"
	note s3_9_1: "Veuillez préciser le type de transport"

	label variable s3_10 "310. Quel type de transport utilisez-vous habituellement pour venir à cette stru"
	note s3_10: "310. Quel type de transport utilisez-vous habituellement pour venir à cette structure sanitaire ?"
	label define s3_10 1 "Transport public" 2 "Véhicule privé" 3 "Ambulance gouvernementale" 4 "Marche" 5 "Pas constant / dépend de la situation" 6 "Autres (Précisez)"
	label values s3_10 s3_10

	label variable s3_10_1 "Veuillez préciser le type de transport"
	note s3_10_1: "Veuillez préciser le type de transport"

	label variable s3_11 "311. Quel est le temps de trajet moyen avec le \${produitb_label} entre votre do"
	note s3_11: "311. Quel est le temps de trajet moyen avec le \${produitb_label} entre votre domicile et la structure sanitaire ?"

	label variable s4_2 "402. A quelle heure êtes-vous arrivé à la structure sanitaire aujourd’hui ?"
	note s4_2: "402. A quelle heure êtes-vous arrivé à la structure sanitaire aujourd’hui ?"

	label variable s4_3 "403. A quelle heure avez-vous vu le prestataire (médecin/infirmière/conseiller) "
	note s4_3: "403. A quelle heure avez-vous vu le prestataire (médecin/infirmière/conseiller) ?"

	label variable s4_5 "405. A quelle heure êtes-vous arrivé à la structure sanitaire le jour de l’admis"
	note s4_5: "405. A quelle heure êtes-vous arrivé à la structure sanitaire le jour de l’admission ?"

	label variable s4_6 "406. Quand avez-vous été admis à la structure sanitaire ?"
	note s4_6: "406. Quand avez-vous été admis à la structure sanitaire ?"
	label define s4_6 1 "Immédiatement" 2 "Le même jour" 3 "Le jour suivant" 4 "Après deux jours ou plus"
	label values s4_6 s4_6

	label variable s4_7 "407. Quelles ont été les raisons du retard de votre admission dans la structure "
	note s4_7: "407. Quelles ont été les raisons du retard de votre admission dans la structure sanitaire ?"

	label variable s4_7_aut "Veuillez préciser"
	note s4_7_aut: "Veuillez préciser"

	label variable s4_8 "408. Combien de jours avez-vous été admis dans cette structure sanitaire ?"
	note s4_8: "408. Combien de jours avez-vous été admis dans cette structure sanitaire ?"

	label variable s4_9 "409. Une civière et/ou une chaise roulante étaient-elles disponibles dans la str"
	note s4_9: "409. Une civière et/ou une chaise roulante étaient-elles disponibles dans la structure sanitaire pour vous transférer ?"
	label define s4_9 1 "Oui" 2 "Non" 8 "Ne sais pas"
	label values s4_9 s4_9

	label variable s4_10 "410. Avez-vous été orienté vers cette structure sanitaire par un prestataire d’u"
	note s4_10: "410. Avez-vous été orienté vers cette structure sanitaire par un prestataire d’une autre structure ?"
	label define s4_10 1 "Oui" 2 "Non" 8 "Ne sais pas"
	label values s4_10 s4_10

	label variable s4_11 "411. Le prestataire vous a-t-il donné ou prescript des médicaments à prendre le "
	note s4_11: "411. Le prestataire vous a-t-il donné ou prescript des médicaments à prendre le temps d’être admis ici ?"
	label define s4_11 1 "Oui, il m’a donné des médicaments" 2 "Oui, il m’a donné une ordonnance" 3 "Il m’a donné une ordonnance et des médicaments" 4 "Non"
	label values s4_11 s4_11

	label variable s4_12 "412. Puis-je voir tous les médicaments administrés et toutes les ordonnances qui"
	note s4_12: "412. Puis-je voir tous les médicaments administrés et toutes les ordonnances qui ont été délivrées ?"
	label define s4_12 1 "Possède tous les médicaments" 2 "Prend des médicaments" 3 "Médicaments non présentés, n'a que des prescriptions"
	label values s4_12 s4_12

	label variable s4_13 "413. Vous a-t-on clairement indiqué la quantité de chaque médicament à prendre e"
	note s4_13: "413. Vous a-t-on clairement indiqué la quantité de chaque médicament à prendre et pendant combien de temps ?"
	label define s4_13 1 "Oui" 2 "Non" 8 "Ne sais pas"
	label values s4_13 s4_13

	label variable s4_14 "414. Avez-vous payé une somme quelconque pour les services reçus dans la structu"
	note s4_14: "414. Avez-vous payé une somme quelconque pour les services reçus dans la structure sanitaire ?"
	label define s4_14 1 "Oui" 2 "Non" 8 "Ne sais pas"
	label values s4_14 s4_14

	label variable s4_15 "415. Combien avez-vous payé pour ces services ?"
	note s4_15: "415. Combien avez-vous payé pour ces services ?"

	label variable s4_16 "416. Avez-vous une fois utilisé quelque chose ou essayé un quelconque moyen pour"
	note s4_16: "416. Avez-vous une fois utilisé quelque chose ou essayé un quelconque moyen pour retarder ou éviter une grossesse ?"
	label define s4_16 1 "Oui" 2 "Non" 8 "Ne sais pas"
	label values s4_16 s4_16

	label variable s4_17 "417. Qu’avez-vous utilisé ou fait pour retarder ou éviter la grossesse ?"
	note s4_17: "417. Qu’avez-vous utilisé ou fait pour retarder ou éviter la grossesse ?"

	label variable s4_17_1 "Veuillez préciser ce que vous avez utilisé"
	note s4_17_1: "Veuillez préciser ce que vous avez utilisé"

	label variable s4_18 "418. Quel est le principal service de planification familiale pour lequel vous ê"
	note s4_18: "418. Quel est le principal service de planification familiale pour lequel vous êtes venu(e) à la structure sanitaire ?"
	label define s4_18 1 "Adopter une méthode de PF" 2 "Changer de méthode" 3 "Mettre fin à la PF" 4 "Trouver des solutions aux effets secondaires de la méthode actuelle" 5 "Obtenir des informations sur une méthode PF" 6 "Autres (Précisez)"
	label values s4_18 s4_18

	label variable s4_18_1 "Veuillez préciser le service"
	note s4_18_1: "Veuillez préciser le service"

	label variable s4_19a "419a. Etes-vous entrain d’avoir (avez-vous eu) des problèmes avec la méthode act"
	note s4_19a: "419a. Etes-vous entrain d’avoir (avez-vous eu) des problèmes avec la méthode actuelle ?"
	label define s4_19a 1 "Oui" 2 "Non"
	label values s4_19a s4_19a

	label variable s4_19b "419b. Quels problèmes êtes-vous en train d’avoir (avez-vous eu) avec la méthode "
	note s4_19b: "419b. Quels problèmes êtes-vous en train d’avoir (avez-vous eu) avec la méthode actuelle ?"

	label variable s4_19b_1 "Veuillez préciser le(les) autre(s) problème(s)"
	note s4_19b_1: "Veuillez préciser le(les) autre(s) problème(s)"

	label variable s4_21 "421. Avant de venir dans cet établissement, utilisiez-vous (ou votre partenaire "
	note s4_21: "421. Avant de venir dans cet établissement, utilisiez-vous (ou votre partenaire utilisait-il) une méthode quelconque pour éviter une grossesse ?"
	label define s4_21 1 "Oui" 2 "Non"
	label values s4_21 s4_21

	label variable s4_22 "422. Quelle méthode utilisiez-vous/votre partenaire (la dernière) avant de venir"
	note s4_22: "422. Quelle méthode utilisiez-vous/votre partenaire (la dernière) avant de venir dans ce centre ?"

	label variable s4_22_ "Préciser autre"
	note s4_22_: "Préciser autre"

	label variable s4_24 "424. Avez-vous pensé, vous ou votre partenaire, à utiliser une méthode particuli"
	note s4_24: "424. Avez-vous pensé, vous ou votre partenaire, à utiliser une méthode particulière avant de venir dans ce centre ?"
	label define s4_24 1 "Oui" 2 "Non"
	label values s4_24 s4_24

	label variable s4_25 "425. A quelle(s) méthode(s) pensiez-vous, vous ou votre partenaire ?"
	note s4_25: "425. A quelle(s) méthode(s) pensiez-vous, vous ou votre partenaire ?"

	label variable s4_27 "427. Avez-vous/votre partenaire pensé à changer de méthode avant de venir dans c"
	note s4_27: "427. Avez-vous/votre partenaire pensé à changer de méthode avant de venir dans cette structure d’accueil ?"
	label define s4_27 1 "Oui" 2 "Non"
	label values s4_27 s4_27

	label variable s4_28 "428. Aviez-vous/votre partenaire, une méthode de planification familiale particu"
	note s4_28: "428. Aviez-vous/votre partenaire, une méthode de planification familiale particulière à l’esprit avant de venir à la structure sanitaire aujourd’hui ?"
	label define s4_28 1 "Oui" 2 "Non"
	label values s4_28 s4_28

	label variable s4_29 "429. Quelle(s) méthode(s) avez-vous envisagé de changer ?"
	note s4_29: "429. Quelle(s) méthode(s) avez-vous envisagé de changer ?"

	label variable s4_29_ "Préciser autre"
	note s4_29_: "Préciser autre"

	label variable s4_30_1 "Pilules"
	note s4_30_1: "Pilules"
	label define s4_30_1 1 "Reçu" 2 "Prescrit/Référé pour prescription" 3 "Ni reçu, ni prescrit"
	label values s4_30_1 s4_30_1

	label variable s4_30_2 "Injectables"
	note s4_30_2: "Injectables"
	label define s4_30_2 1 "Reçu" 2 "Prescrit/Référé pour prescription" 3 "Ni reçu, ni prescrit"
	label values s4_30_2 s4_30_2

	label variable s4_30_3 "Préservatif masculin"
	note s4_30_3: "Préservatif masculin"
	label define s4_30_3 1 "Reçu" 2 "Prescrit/Référé pour prescription" 3 "Ni reçu, ni prescrit"
	label values s4_30_3 s4_30_3

	label variable s4_30_4 "Préservatif féminin"
	note s4_30_4: "Préservatif féminin"
	label define s4_30_4 1 "Reçu" 2 "Prescrit/Référé pour prescription" 3 "Ni reçu, ni prescrit"
	label values s4_30_4 s4_30_4

	label variable s4_30_5 "Contraception d’urgence"
	note s4_30_5: "Contraception d’urgence"
	label define s4_30_5 1 "Reçu" 2 "Prescrit/Référé pour prescription" 3 "Ni reçu, ni prescrit"
	label values s4_30_5 s4_30_5

	label variable s4_30_6 "DIU"
	note s4_30_6: "DIU"
	label define s4_30_6 1 "Reçu" 2 "Prescrit/Référé pour prescription" 3 "Ni reçu, ni prescrit"
	label values s4_30_6 s4_30_6

	label variable s4_30_7 "Stérilisation féminine (Ligature des trompes)"
	note s4_30_7: "Stérilisation féminine (Ligature des trompes)"
	label define s4_30_7 1 "Reçu" 2 "Prescrit/Référé pour prescription" 3 "Ni reçu, ni prescrit"
	label values s4_30_7 s4_30_7

	label variable s4_30_8 "Stérilisation masculine/ Vasectomie"
	note s4_30_8: "Stérilisation masculine/ Vasectomie"
	label define s4_30_8 1 "Reçu" 2 "Prescrit/Référé pour prescription" 3 "Ni reçu, ni prescrit"
	label values s4_30_8 s4_30_8

	label variable s4_30_9 "Allaitement maternel exclusif (MAMA)"
	note s4_30_9: "Allaitement maternel exclusif (MAMA)"
	label define s4_30_9 1 "Reçu" 2 "Prescrit/Référé pour prescription" 3 "Ni reçu, ni prescrit"
	label values s4_30_9 s4_30_9

	label variable s4_30_10 "implant"
	note s4_30_10: "implant"
	label define s4_30_10 1 "Reçu" 2 "Prescrit/Référé pour prescription" 3 "Ni reçu, ni prescrit"
	label values s4_30_10 s4_30_10

	label variable s4_30_11 "Autre"
	note s4_30_11: "Autre"
	label define s4_30_11 1 "Reçu" 2 "Prescrit/Référé pour prescription" 3 "Ni reçu, ni prescrit"
	label values s4_30_11 s4_30_11

	label variable s4_30_11_other "Préciser autre"
	note s4_30_11_other: "Préciser autre"

	label variable s4_32 "432. Quelles sont les raisons qui vous ont amené à recevoir ou à prescrire des m"
	note s4_32: "432. Quelles sont les raisons qui vous ont amené à recevoir ou à prescrire des méthodes de planification familiale différentes de celles initialement envisagés par vous/votre partenaire ?"

	label variable s4_32_autre "Préciser autre raisons"
	note s4_32_autre: "Préciser autre raisons"

	label variable s4_34 "434. Quelles sont les raisons pour lesquelles vous n’avez pas reçus les services"
	note s4_34: "434. Quelles sont les raisons pour lesquelles vous n’avez pas reçus les services de planning familial dont vous aviez besoin ?"

	label variable s4_34_ "Préciser autre"
	note s4_34_: "Préciser autre"

	label variable s4_35 "435. Quel a été le résultat de cette visite ?"
	note s4_35: "435. Quel a été le résultat de cette visite ?"

	label variable s4_35_1 "Veuillez préciser le résultat de la visite"
	note s4_35_1: "Veuillez préciser le résultat de la visite"

	label variable s4_37 "437. Vous a-t-il demandé si vous souhaitiez avoir un autre enfant ?"
	note s4_37: "437. Vous a-t-il demandé si vous souhaitiez avoir un autre enfant ?"
	label define s4_37 1 "Oui" 2 "Non" 8 "Ne sais pas"
	label values s4_37 s4_37

	label variable s4_38 "438. Vous a-t-il interrogé sur le moment où vous souhaiteriez avoir un autre enf"
	note s4_38: "438. Vous a-t-il interrogé sur le moment où vous souhaiteriez avoir un autre enfant ?"
	label define s4_38 1 "Oui" 2 "Non" 8 "Ne sais pas"
	label values s4_38 s4_38

	label variable s4_39 "439. Vous a-t-il demandé votre dernière expérience sur l’utilisation des méthode"
	note s4_39: "439. Vous a-t-il demandé votre dernière expérience sur l’utilisation des méthodes de planification familiale ?"
	label define s4_39 1 "Oui" 2 "Non" 8 "Ne sais pas"
	label values s4_39 s4_39

	label variable s4_40 "440. Vous a-t-il demandé si vous aviez une quelconque méthode en tête avant de v"
	note s4_40: "440. Vous a-t-il demandé si vous aviez une quelconque méthode en tête avant de venir à la structure sanitaire ?"
	label define s4_40 1 "Oui" 2 "Non" 8 "Ne sais pas"
	label values s4_40 s4_40

	label variable s4_41 "441. Vous a-t-il demandé votre préférence en matière de méthode de planification"
	note s4_41: "441. Vous a-t-il demandé votre préférence en matière de méthode de planification familiale ?"
	label define s4_41 1 "Oui" 2 "Non" 8 "Ne sais pas"
	label values s4_41 s4_41

	label variable s4_42 "442. Vous a-t-il fourni des informations sur différentes méthodes de planificati"
	note s4_42: "442. Vous a-t-il fourni des informations sur différentes méthodes de planification familiale ?"
	label define s4_42 1 "Oui" 2 "Non" 8 "Ne sais pas"
	label values s4_42 s4_42

	label variable s4_43 "443. Vous a-t-il parlé de la méthode de PF que vous avez choisi ?"
	note s4_43: "443. Vous a-t-il parlé de la méthode de PF que vous avez choisi ?"
	label define s4_43 1 "Oui" 2 "Non" 8 "Ne sais pas"
	label values s4_43 s4_43

	label variable s4_44 "444. Vous a-t-il parlé du mode de fonctionnement de la méthode que vous avez cho"
	note s4_44: "444. Vous a-t-il parlé du mode de fonctionnement de la méthode que vous avez choisi ?"
	label define s4_44 1 "Oui" 2 "Non" 8 "Ne sais pas"
	label values s4_44 s4_44

	label variable s4_45 "445. Vous a-t-il parlé des possibles effets secondaires de la méthode que vous a"
	note s4_45: "445. Vous a-t-il parlé des possibles effets secondaires de la méthode que vous avez choisie ?"
	label define s4_45 1 "Oui" 2 "Non" 8 "Ne sais pas"
	label values s4_45 s4_45

	label variable s4_46 "446. Vous a-t-il parlé de ce que vous devez faire quand vous noterez des effets "
	note s4_46: "446. Vous a-t-il parlé de ce que vous devez faire quand vous noterez des effets secondaires ou des problèmes par rapport à la méthode que vous avez choisie ?"
	label define s4_46 1 "Oui" 2 "Non" 8 "Ne sais pas"
	label values s4_46 s4_46

	label variable s4_47 "447. Vous a-t-il parlé des signes d’alerte de la méthode vous avez choisie ?"
	note s4_47: "447. Vous a-t-il parlé des signes d’alerte de la méthode vous avez choisie ?"
	label define s4_47 1 "Oui" 2 "Non" 8 "Ne sais pas"
	label values s4_47 s4_47

	label variable s4_48 "448. Vous a-t-il dit quand revenir au centre de santé pour une visite de suivi ?"
	note s4_48: "448. Vous a-t-il dit quand revenir au centre de santé pour une visite de suivi ?"
	label define s4_48 1 "Oui" 2 "Non" 8 "Ne sais pas"
	label values s4_48 s4_48

	label variable s4_49 "449. Vous a-t-il remis une carte de rendez-vous pour la visite de suivi ?"
	note s4_49: "449. Vous a-t-il remis une carte de rendez-vous pour la visite de suivi ?"
	label define s4_49 1 "Oui" 2 "Non" 8 "Ne sais pas"
	label values s4_49 s4_49

	label variable s4_50 "450. Vous a-t-il parlé d’autres sources auprès desquelles vous pouviez obtenir d"
	note s4_50: "450. Vous a-t-il parlé d’autres sources auprès desquelles vous pouviez obtenir des produits de planification familiale ?"
	label define s4_50 1 "Oui" 2 "Non" 8 "Ne sais pas"
	label values s4_50 s4_50

	label variable s4_51 "451. Vous a-t-il parlé de la possibilité de changer de méthode de planification "
	note s4_51: "451. Vous a-t-il parlé de la possibilité de changer de méthode de planification familiale si celle choisit ne vous convient plus ?"
	label define s4_51 1 "Oui" 2 "Non" 8 "Ne sais pas"
	label values s4_51 s4_51

	label variable s4_52 "452. Vous a-t-il fourni des informations tout en encourageant fortement une méth"
	note s4_52: "452. Vous a-t-il fourni des informations tout en encourageant fortement une méthode ?"
	label define s4_52 1 "Oui" 2 "Non" 8 "Ne sais pas"
	label values s4_52 s4_52

	label variable s4_53 "453. Vous a-t-il fournit des méthodes qui protègent contre le VIH/SIDA et des au"
	note s4_53: "453. Vous a-t-il fournit des méthodes qui protègent contre le VIH/SIDA et des autres IST ?"
	label define s4_53 1 "Oui" 2 "Non" 8 "Ne sais pas"
	label values s4_53 s4_53

	label variable s4_54 "454. Le prestataire vous-a-t-il permis de poser des questions ?"
	note s4_54: "454. Le prestataire vous-a-t-il permis de poser des questions ?"
	label define s4_54 1 "Oui" 2 "Non" 8 "Ne sais pas"
	label values s4_54 s4_54

	label variable s4_55 "455. Le prestataire a-t-il répondu à toutes vos questions pour vous satisfaire ?"
	note s4_55: "455. Le prestataire a-t-il répondu à toutes vos questions pour vous satisfaire ?"
	label define s4_55 1 "Oui" 2 "Non" 8 "Ne sais pas"
	label values s4_55 s4_55

	label variable s4_56 "456. Durant votre visite, pouvez-vous dire que vous avez été bien traité par le "
	note s4_56: "456. Durant votre visite, pouvez-vous dire que vous avez été bien traité par le prestataire ?"
	label define s4_56 1 "Oui" 2 "Non" 8 "Ne sais pas"
	label values s4_56 s4_56

	label variable s4_57 "457. Comment appréciez-vous les informations que vous avez reçu à propos de la m"
	note s4_57: "457. Comment appréciez-vous les informations que vous avez reçu à propos de la méthode de planification familiale que vous avez choisie par rapport à ce que vous souhaitiez ?"
	label define s4_57 1 "J'ai reçu toutes les informations" 2 "J'ai reçu la plupart des informations" 3 "J'ai reçu peu d'informations" 4 "Je n'ai pas reçu les informations" 8 "Ne sais pas/ne peut pas s’en rappeler"
	label values s4_57 s4_57

	label variable s4_58 "458. Le prestataire, vous a-t-il recommandé une méthode plutôt qu’une autre ? Si"
	note s4_58: "458. Le prestataire, vous a-t-il recommandé une méthode plutôt qu’une autre ? Si Oui, diriez-vous tout le temps, la plupart du temps ou quelques fois ?"
	label define s4_58 1 "Oui, tout le temps" 2 "Oui, la plupart du temps" 3 "Oui, quelques fois" 4 "Non, jamais" 8 "Ne sais pas/Ne peut pas s'en rappeler"
	label values s4_58 s4_58

	label variable s4_59 "459. Avez-vous le sentiment d’être à l’abri des regards pendant votre entretien "
	note s4_59: "459. Avez-vous le sentiment d’être à l’abri des regards pendant votre entretien avec le prestataire et qu’aucun autre client ou patient de la structure sanitaire ne pouvait vous voir pendant votre consultation (comme lors d’un examen physique) ? SI Oui, diriez-vous tout le temps, la plupart du temps ou quelques fois ?"
	label define s4_59 1 "Oui, tout le temps" 2 "Oui, la plupart du temps" 3 "Oui, quelques fois" 4 "Non, jamais" 8 "Ne sais pas/Ne s’en rappelle pas"
	label values s4_59 s4_59

	label variable s4_60 "460. Vous sentiez-vous capable de discuter de vos problèmes avec les médecins, l"
	note s4_60: "460. Vous sentiez-vous capable de discuter de vos problèmes avec les médecins, les infirmières ou d'autres prestataires, sans que d'autres personnes non impliquées dans vos soins n'entendent vos conversations ? Si Oui, diriez-vous tout le temps, la plupart du temps ou quelques fois"
	label define s4_60 1 "Oui, tout le temps" 2 "Oui, la plupart du temps" 3 "Oui, quelques fois" 4 "Non, jamais" 8 "Ne sais pas/Ne s’en rappelle pas"
	label values s4_60 s4_60

	label variable s4_61 "461. Pensez-vous que les informations personnelles que vous avez partagé avec le"
	note s4_61: "461. Pensez-vous que les informations personnelles que vous avez partagé avec le prestataire seront confidentielles ? SI Oui, Diriez-vous tout le temps, la plupart du temps ou quelques fois ?"
	label define s4_61 1 "Oui, tout le temps" 2 "Oui, la plupart du temps" 3 "Oui, quelques fois" 4 "Non, jamais" 8 "Ne sais pas/Ne s’en rappelle pas"
	label values s4_61 s4_61

	label variable s4_62 "462. Sentez-vous que le médecin, l’infirmier ou les autres membres du personnel "
	note s4_62: "462. Sentez-vous que le médecin, l’infirmier ou les autres membres du personnel vous ont traité avec respect ? Si Oui, diriez-vous tout le temps, la plupart du temps ou quelques fois ?"
	label define s4_62 1 "Oui, tout le temps" 2 "Oui, la plupart du temps" 3 "Oui, quelques fois" 4 "Non, jamais" 8 "Ne sais pas/Ne s’en rappelle pas"
	label values s4_62 s4_62

	label variable s4_63 "463. Sentez-vous que le médecin, l’infirmier ou les autres membres du personnel "
	note s4_63: "463. Sentez-vous que le médecin, l’infirmier ou les autres membres du personnel vous ont traité d’une manière amicale ? Si Oui, diriez-vous tout le temps, la plupart du temps ou quelques fois ?"
	label define s4_63 1 "Oui, tout le temps" 2 "Oui, la plupart du temps" 3 "Oui, quelques fois" 4 "Non, jamais" 8 "Ne sais pas/Ne s’en rappelle pas"
	label values s4_63 s4_63

	label variable s4_64 "464. Pensez-vous que l’environnement de la structure sanitaire y compris les toi"
	note s4_64: "464. Pensez-vous que l’environnement de la structure sanitaire y compris les toilettes sont propres ? Si Oui, diriez-vous tout le temps, la plupart du temps ou quelques fois ?"
	label define s4_64 1 "Oui, tout le temps" 2 "Oui, la plupart du temps" 3 "Oui, quelques fois" 4 "Non, jamais" 8 "Ne sais pas/Ne s’en rappelle pas"
	label values s4_64 s4_64

	label variable s4_65 "465. Comment s’est déroulée l’expérience concernant les dispositions prises dans"
	note s4_65: "465. Comment s’est déroulée l’expérience concernant les dispositions prises dans la structure sanitaire pendant l’attente d’un service ? Par exemple, la disposition des sièges, l’ordre des appels, etc."
	label define s4_65 1 "Très bien" 2 "Bien" 3 "Mauvaise" 4 "Très mauvaise" 8 "Ne peut rien dire"
	label values s4_65 s4_65

	label variable s4_66 "466. Avez-vous eu le sentiment de pouvoir poser toutes vos questions aux médecin"
	note s4_66: "466. Avez-vous eu le sentiment de pouvoir poser toutes vos questions aux médecins, aux infirmières ou aux autres membres du personnel de la structure sanitaire ? SI Oui, diriez-vous tout le temps, la plupart du temps ou quelques fois ?"
	label define s4_66 1 "Oui, tout le temps" 2 "Oui, la plupart du temps" 3 "Oui, quelques fois" 4 "Non, jamais" 8 "Ne sais pas/Ne s’en rappelle pas" 9 "Non applicable"
	label values s4_66 s4_66

	label variable s4_67 "467. Avez-vous eu l’impression que les médecins, les infirmières ou les autres m"
	note s4_67: "467. Avez-vous eu l’impression que les médecins, les infirmières ou les autres membres du personnel de la structure sanitaire vous ont fait participer aux décisions concernant vos soins ? Si Oui, diriez-vous tout le temps, la plupart du temps ou quelques fois ?"
	label define s4_67 1 "Oui, tout le temps" 2 "Oui, la plupart du temps" 3 "Oui, quelques fois" 4 "Non, jamais" 8 "Ne sais pas / Ne s’en rappelle pas" 9 "Non applicable"
	label values s4_67 s4_67

	label variable s4_68 "468. Diriez-vous que vous avez été traité différemment en raison d’une caractéri"
	note s4_68: "468. Diriez-vous que vous avez été traité différemment en raison d’une caractéristique personnelle, comme votre âge, votre situation matrimoniale, le nombre de vos enfants, votre éducation, votre fortune, ou quelque chose de ce genre ? SI Oui, diriez-vous tout le temps, la plupart du temps ou quelques fois ?"
	label define s4_68 1 "Oui, tout le temps" 2 "Oui, la plupart du temps" 3 "Oui, quelques fois" 4 "Non, jamais" 8 "Ne sais pas/Ne s’en rappelle pas"
	label values s4_68 s4_68

	label variable s4_69 "469. Avez-vous eu l’impression d’être traité brutalement ? Par exemple, avez- vo"
	note s4_69: "469. Avez-vous eu l’impression d’être traité brutalement ? Par exemple, avez- vous été poussé, battu, giflé, pincé, contraint physiquement ou bâillonné, ou maltraité physiquement d’une autre manière ? SI Oui, diriez-vous tout le temps, la plupart du temps ou quelques fois ?"
	label define s4_69 1 "Oui, tout le temps" 2 "Oui, la plupart du temps" 3 "Oui, quelques fois" 4 "Non, jamais" 8 "Ne sais pas/Ne s’en rappelle pas"
	label values s4_69 s4_69

	label variable s4_70 "470. Avez-vous eu l’impression que les médecins, les infirmières ou les autres p"
	note s4_70: "470. Avez-vous eu l’impression que les médecins, les infirmières ou les autres prestataires de soins de santé vous ont-ils, crié dessus, vous ont grondé, vous ont insulté, menacé ou vous ont parlé grossièrement ? SI Oui, diriez-vous tout le temps, la plupart du temps ou quelques fois?"
	label define s4_70 1 "Oui, tout le temps" 2 "Oui, la plupart du temps" 3 "Oui, quelques fois" 4 "Non, jamais" 8 "Ne sais pas/Ne s’en rappelle pas"
	label values s4_70 s4_70

	label variable s4_71 "471. Compte tenu de votre expérience d’aujourd’hui, diriez-vous que vous êtes en"
	note s4_71: "471. Compte tenu de votre expérience d’aujourd’hui, diriez-vous que vous êtes entièrement satisfait, partiellement satisfait ou pas du tout satisfait des services de services de planning familial fournis ?"
	label define s4_71 1 "Oui, entièrement satisfait" 2 "Oui, partiellement satisfait" 3 "Pas du tout satisfait" 8 "Ne peut rien dire"
	label values s4_71 s4_71

	label variable s4_72 "472. Quelles sont les raisons de cette insatisfaction ?"
	note s4_72: "472. Quelles sont les raisons de cette insatisfaction ?"

	label variable s4_73 "473. Si nécessaire, reviendrez-vous à l’avenir dans cette structure sanitaire po"
	note s4_73: "473. Si nécessaire, reviendrez-vous à l’avenir dans cette structure sanitaire pour des services de planification familiale ?"
	label define s4_73 1 "Oui" 2 "Non" 8 "Ne peut rien dire"
	label values s4_73 s4_73

	label variable s4_75 "475. Le temps d’attente pour consulter un prestataire dans cette structure sanit"
	note s4_75: "475. Le temps d’attente pour consulter un prestataire dans cette structure sanitaire a-t-il été un problème ? SI Oui, diriez-vous qu’il s’agit d’un problème majeur ou mineur ?"
	label define s4_75 1 "Oui, a posé un problème majeur" 2 "Oui, a posé un problème mineur" 3 "Non, ne pose pas de problème" 8 "Ne sais pas"
	label values s4_75 s4_75

	label variable s4_76 "476. Les heures d’ouverture et de fermeture de la structure sanitaire ont-elles "
	note s4_76: "476. Les heures d’ouverture et de fermeture de la structure sanitaire ont-elles posé problème ? SI Oui, diriez-vous qu’il s’agit d’un problème majeur ou mineur ?"
	label define s4_76 1 "Oui, a posé un problème majeur" 2 "Oui, a posé un problème mineur" 3 "Non, ne pose pas de problème" 8 "Ne sais pas"
	label values s4_76 s4_76

	label variable s4_77 "477. Le nombre de jours pendant lesquels les services sont disponibles dans cett"
	note s4_77: "477. Le nombre de jours pendant lesquels les services sont disponibles dans cette structure sanitaire vous a-t-il posé un problème ? SI Oui, diriez-vous qu’il s’agit d’un problème majeur ou mineur ?"
	label define s4_77 1 "Oui, a posé un problème majeur" 2 "Oui, a posé un problème mineur" 3 "Non, ne pose pas de problème" 8 "Ne sais pas"
	label values s4_77 s4_77

	label variable s4_78 "478. Les coûts des services de planification familiale de cette structure sanita"
	note s4_78: "478. Les coûts des services de planification familiale de cette structure sanitaire vous-a-t-il posé problème ? SI Oui, diriez-vous qu’il s’agit d’un problème majeur ou mineur ?"
	label define s4_78 1 "Oui, a posé un problème majeur" 2 "Oui, a posé un problème mineur" 3 "Non, ne pose pas de problème" 8 "Ne sais pas"
	label values s4_78 s4_78

	label variable s4_79 "479. S’agit-il de la structure sanitaire offrant des services de planification f"
	note s4_79: "479. S’agit-il de la structure sanitaire offrant des services de planification familiale la plus proche de votre domicile ?"
	label define s4_79 1 "Oui" 2 "Non" 8 "Ne sais pas"
	label values s4_79 s4_79

	label variable s4_80 "480. Quelle est la principale raison pour laquelle vous ne vous êtes pas rendu d"
	note s4_80: "480. Quelle est la principale raison pour laquelle vous ne vous êtes pas rendu dans la structure sanitaire le plus proche de votre domicile ?"
	label define s4_80 1 "Calendrier des services n'est pas adapté" 2 "Mauvaise réputation" 3 "N'aime pas le personnel" 4 "Mauvaise qualité des soins" 5 "Cherté des prestations" 6 "Défaut de médicaments" 7 "J'ai été référé ici" 8 "Service non proposé" 9 "Mauvais accueil" 96 "Autres" 98 "Ne sait pas"
	label values s4_80 s4_80

	label variable gpslatitude "Coordonnées GPS de la structure sanitaire (latitude)"
	note gpslatitude: "Coordonnées GPS de la structure sanitaire (latitude)"

	label variable gpslongitude "Coordonnées GPS de la structure sanitaire (longitude)"
	note gpslongitude: "Coordonnées GPS de la structure sanitaire (longitude)"

	label variable gpsaltitude "Coordonnées GPS de la structure sanitaire (altitude)"
	note gpsaltitude: "Coordonnées GPS de la structure sanitaire (altitude)"

	label variable gpsaccuracy "Coordonnées GPS de la structure sanitaire (accuracy)"
	note gpsaccuracy: "Coordonnées GPS de la structure sanitaire (accuracy)"

	label variable obs "OBSERVATIONS DE L’ENQUETEUR"
	note obs: "OBSERVATIONS DE L’ENQUETEUR"

	label variable fin "Heure de fin de l'entretien"
	note fin: "Heure de fin de l'entretien"






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
*   Corrections file path and filename:  F:/Dropbox_APHRC/Dropbox/FP-Project-APHRC-UM/Atelier_FP/Data/raw/QUESTIONNAIRE CLIENTE PF_corrections.csv
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

