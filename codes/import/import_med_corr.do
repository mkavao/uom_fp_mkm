* import_med_corr.do
*
* 	Imports and aggregates "QUESTIONNAIRE MEDECIN" (ID: med_corr) data.
*
*	Inputs:  "C:/Users/pkaberia/Dropbox/FP PROJECT/Data management/case de sante/QUESTIONNAIRE MEDECIN_WIDE.csv"
*	Outputs: "C:/Users/pkaberia/Dropbox/FP PROJECT/Data management/case de sante/QUESTIONNAIRE MEDECIN.dta"
*
*	Output by SurveyCTO February 13, 2025 12:31 PM.

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
local csvfile "C:/Users/pkaberia/Downloads/QUESTIONNAIRE MEDECIN_WIDE.csv"
local dtafile "C:/Users/pkaberia/Downloads/QUESTIONNAIRE MEDECIN.dta"
local corrfile "C:/Users/pkaberia/Dropbox/FP PROJECT/Data management/case de sante/QUESTIONNAIRE MEDECIN_corrections.csv"
local note_fields1 ""
local text_fields1 "deviceid i3b s1_8 s2_6_1 s2_14_1a s2_15_1 s2_14_2a s2_15_2 s2_14_3a s2_15_3 s2_14_4a s2_15_4 s2_22 methods_repeat_count numero_pf_* code_pf_* method_label_* s2_27a_* s2_28_* s3_2 s3_2a s3_3 s3_3a s3_4"
local text_fields2 "s3_4a s3_6 s3_6a s3_7 s3_7a s3_8 s3_8a s3_9 s3_9a s3_10 s3_10a s3_11 s3_11a s3_12a s3_13 s3_13a s3_14 s3_14a s3_15 s3_15a s3_18 s3_18a s3_19 s3_19a s3_21 s3_21a s3_22 s3_22a s3_23 s3_23a s3_24 s3_24a"
local text_fields3 "s3_25 s3_25a s3_26 s3_26a s3_27 s3_27a s3_30 s3_30a s3_31 s3_31a s3_32 s3_32a s3_33 s3_33a s3_34 s3_34a s3_35 s3_35a s3_36 s3_36a s3_37 s3_37a s3_39 s3_39a s3_40 s3_40a s3_43 s3_43a s3_44 s3_44a s3_45"
local text_fields4 "s3_45a s3_46 s3_46a s3_47 s3_47a s3_48 s3_48a s3_49 s3_49a s3_50 s3_50a s3_51 s3_51a s3_52a s3_53 s3_53a s3_54 s3_54a s3_56 s3_56a s3_57 s3_57a s3_58a s3_60 s3_60a s3_61 s3_61a s3_62 s3_62a s3_63"
local text_fields5 "s3_63a s3_64 s3_64a s3_67 s3_67a s3_68 s3_68a s3_70 s3_70a s3_71 s3_71a s3_73 s3_73a s4_9a s4_11a s5_1 s5_1a s5_2 s5_2a s5_4a s5_5a s5_6a s5_8a s5_16a s5_20 s5_20a s5_21a s5_23a s5_24 s5_24a s5_25a"
local text_fields6 "s5_28 s5_28a s5_29 s5_29a s5_31a s5_32a s5_33 s5_33a s5_35 s5_35a s5_36 s5_36a s5_37 s5_37a s5_38 s5_38a s5_39 s5_39a s5_40 s5_40a s5_42 s5_42a s5_43 s5_43a s5_44a s5_45 s5_45a s5_46 s5_46a s5_47"
local text_fields7 "s5_47a s5_48 s5_48a s5_49 s5_49a s5_50a s5_53 s5_53a s5_54a s5_56 s5_56a s5_57 s5_57a s5_58a s5_60 s5_60a s5_61 s5_61a s5_62 s5_62a s5_64a s5_65a s5_66 s5_66a s5_67 s5_67a s5_68a s5_71a s5_72 s5_72a"
local text_fields8 "s5_73 s5_73a s5_74 s5_74a s5_78 s5_78a s5_79a s5_80a s5_82 s5_82a s5_84 s5_84a s5_85a s5_86 s5_86a s5_87 s5_87a s5_88a s5_89 s5_89a s5_90 s5_90a s5_91 s5_91a s5_93a s5_94 s5_94a s5_95a obs instanceid"
local date_fields1 "today"
local datetime_fields1 "submissiondate start s1_7 end"

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


	label variable i1 "101. Nom de la région"
	note i1: "101. Nom de la région"
	label define i1 1 "DAKAR" 2 "DIOURBEL" 3 "FATICK" 4 "KAFFRINE" 5 "KAOLACK" 6 "KEDOUGOU" 7 "KOLDA" 8 "LOUGA" 9 "MATAM" 10 "SAINT-LOUIS" 11 "SEDHIOU" 12 "TAMBACOUNDA" 13 "THIES" 14 "ZIGUINCHOR"
	label values i1 i1

	label variable i2 "102. Nom du district"
	note i2: "102. Nom du district"
	label define i2 1 "DAKAR CENTRE" 2 "DAKAR NORD" 3 "DAKAR OUEST" 4 "DAKAR SUD" 5 "DIAMNIADIO" 6 "GUEDIAWAYE" 7 "KEUR MASSAR" 8 "MBAO" 9 "PIKINE" 10 "RUFISQUE" 11 "SANGALKAM" 12 "YEUMBEUL" 13 "BAMBEY" 14 "DIOURBEL" 15 "MBACKE" 16 "TOUBA" 17 "DIAKHAO" 18 "DIOFFIOR" 19 "FATICK" 20 "FOUNDIOUGNE" 21 "GOSSAS" 22 "NIAKHAR" 23 "PASSY" 24 "SOKONE" 25 "BIRKELANE" 26 "KAFFRINE" 27 "KOUNGHEUL" 28 "MALEM HODAR" 29 "GUINGUINEO" 30 "KAOLACK" 31 "NDOFFANE" 32 "NIORO" 33 "KEDOUGOU" 34 "SALEMATA" 35 "SARAYA" 36 "KOLDA" 37 "MEDINA YORO FOULAH" 38 "VELINGARA" 39 "DAHRA" 40 "DAROU-MOUSTY" 41 "KEBEMER" 42 "KEUR MOMAR SARR" 43 "KOKI" 44 "LINGUERE" 45 "LOUGA" 46 "SAKAL" 47 "KANEL" 48 "MATAM" 49 "RANEROU" 50 "THILOGNE" 51 "DAGANA" 52 "PETE" 53 "PODOR" 54 "RICHARD TOLL" 55 "SAINT-LOUIS" 56 "BOUNKILING" 57 "GOUDOMP" 58 "SEDHIOU" 59 "BAKEL" 60 "DIANKHE MAKHAN" 61 "GOUDIRY" 62 "KIDIRA" 63 "KOUMPENTOUM" 64 "MAKACOLIBANTANG" 65 "TAMBACOUNDA" 66 "JOAL-FADIOUTH" 67 "KHOMBOLE" 68 "MBOUR" 69 "MEKHE" 70 "POPENGUINE" 71 "POUT" 72 "THIADIAYE" 73 "THIES" 74 "TIVAOUANE" 75 "BIGNONA" 76 "DIOULOULOU" 77 "OUSSOUYE" 78 "THIONCK-ESSYL" 79 "ZIGUINCHOR"
	label values i2 i2

	label variable i3 "103. Nom de la structure"
	note i3: "103. Nom de la structure"
	label define i3 1 "CS Gaspard Camara" 2 "CS Grand Dakar" 3 "CS HLM" 4 "CS Hann Mer" 5 "CS Liberté 6 (Mamadou DIOP)" 6 "CS Mariste" 7 "EPS Hopital de Fann" 18 "CS Abdoul Aziz SY Dabakh" 19 "CS Camberene" 20 "CS Nabil Choucair" 21 "CS SAMU Municipal Grand Yoff" 22 "EPS Hoggy" 35 "CS Annette Mbaye Derneville" 36 "CS Municipal de Ouakam" 37 "CS Ngor" 38 "CS Philippe Senghor" 39 "EPS Hôpital Militaire de Ouakam (Hmo)" 47 "CS Cheikh Ahmadou Bamba Mbacke" 48 "CS Colobane" 49 "CS Elisabeth Diouf" 50 "CS Keur Yaye Sylvie" 51 "CS Plateau" 52 "EPS Institut Hygiene Sociale" 53 "EPS Hopital Abass Ndao" 54 "EPS Hopital Principal" 55 "INFIRMERIE HOPITAL DE LA GENDARMERIE ( Ex Gendarmerie Colobane)" 62 "CS Diamniadio" 63 "CS Ndiaye Diouf" 64 "EPS Hôpital d'Enfant Diamniadio" 77 "CS Wakhinane" 78 "EPS Dalal Jamm" 79 "EPS Roi Baudoin" 90 "CS Keur Massar" 99 "CS Khadim Rassoul" 100 "EPS Pikine" 101 "EPS Psychiatrique de Thiaroye" 116 "CS Dominique" 129 "CS Polyclinique" 130 "CS SOCOCIM" 131 "EPS Youssou Mbargane Diop" 144 "CS Sangalkam" 160 "CS yeumbeul" 170 "CS Bambey" 202 "CS Diourbel" 203 "CS Ndindy" 204 "EPS Lubke de Diourbel" 225 "CS Mbacke" 249 "CS Darou Marnane" 250 "CS Darou Tanzil" 251 "CS Keur Niang" 252 "CS Saïdyl Badawi" 253 "CS Serigne Mbacke Madina" 254 "CS Serigne Saliou Mbacke" 255 "EPS Ndamatou" 256 "EPS Cheikh Ahmadoul Khadim" 257 "EPS Matlaboul Fawzayni" 286 "Cs Diakhao" 301 "CS Dioffior" 317 "CS Fatick" 318 "CS prive Dal Xel de Fatick" 319 "EPS de Fatick" 343 "CS Foundiougne" 344 "CS Niodior" 355 "CS Gossas" 369 "CS Niakhar" 382 "CS Passy" 398 "CS Sokone" 425 "CS de Mbirkilane" 445 "CS de Kaffrine" 446 "EPS Thierno Birahim Ndao" 475 "CS Koungheul" 508 "CS Malem Hodar" 532 "CS Guinguineo" 559 "CS Kasnack" 560 "EPS El hadji Ibrahima NIASS de Kaolack" 590 "CS Ndoffane" 615 "CS Nioro" 616 "CS Wack Ngouna" 657 "CS Kedougou" 658 "CS Ndormi" 659 "EPS Amath Dansokho" 675 "CS Salemata" 685 "CS Saraya" 708 "CS Kolda" 709 "EPS Kolda" 751 "CS Medina Yoro Foulah" 775 "CS Medina gounass" 776 "CS Velingara" 808 "CS Dahra" 828 "CS Darou Mousty" 829 "CS Mbacke Kadior" 848 "CS Gueoul" 849 "CS Kebemer" 866 "CS Keur Momar SARR" 880 "CS Coki" 892 "CS Linguere" 893 "EPS Linguere" 907 "CS Louga" 908 "EPS Amadou Sakhir Mbaye de Louga" 927 "CS Sakal" 941 "CS Hamady Ounare" 942 "CS Kanel" 943 "CS Waounde" 989 "CS Matam" 990 "EPS Régional de Matam" 991 "EPS de Ouroussogui" 1019 "CS Ranerou" 1037 "CS Thilogne" 1038 "EPS AGNAM" 1056 "CS Dagana" 1069 "CS Aere Lao" 1070 "CS Cascas" 1071 "CS Galoya" 1072 "CS Pete" 1106 "CS Podor" 1107 "CS Thile Boubacar" 1108 "EPS de NDioum" 1146 "CS Richard Toll" 1147 "CS Ross Bethio" 1148 "CSS" 1149 "EPS Richard Toll" 1171 "CS Mpal" 1172 "CS Saint - Louis" 1174 "EPS de Saint Louis" 1192 "CS Bounkiling" 1219 "CS Goudomp" 1220 "CS Samine" 1236 "CS Bambaly" 1237 "CS Sedhiou" 1238 "EPS Sedhiou" 1260 "CS Bakel" 1284 "CS Dianké Makha" 1305 "CS Goudiry" 1328 "CS Kidira" 1352 "CS Koumpentoum" 1375 "CS Maka" 1388 "CS Tambacounda" 1389 "EPS Tambacounda" 1418 "CS Joal" 1427 "CS Khombole" 1448 "CS Mbour" 1449 "EPS Mbour" 1484 "CS Mekhe" 1514 "CS Popenguine" 1525 "CS Pout" 1536 "CS Thiadiaye" 1551 "CS 10ème de THIES" 1552 "CS Keur Mame El Hadji" 1553 "EPS Amadou S Dieuguene" 1587 "CS Tivaouane" 1588 "EPS ABDOU AZIZ SY" 1618 "CS Bignona" 1654 "CS Diouloulou" 1676 "CS Oussouye" 1691 "CS Thionck Essyl" 1705 "CS Ziguinchor" 1706 "EPS CHR ZIGUINCHOR" 1707 "EPS Hopital de la Paix" 2001 "Ajouter une nouvelle structure" 2002 "Ajouter une nouvelle structure" 2003 "Ajouter une nouvelle structure" 2004 "Ajouter une nouvelle structure" 2005 "Ajouter une nouvelle structure" 2006 "Ajouter une nouvelle structure" 2007 "Ajouter une nouvelle structure" 2008 "Ajouter une nouvelle structure" 2009 "Ajouter une nouvelle structure" 2010 "Ajouter une nouvelle structure" 2011 "Ajouter une nouvelle structure" 2012 "Ajouter une nouvelle structure" 2013 "Ajouter une nouvelle structure" 2014 "Ajouter une nouvelle structure" 2015 "Ajouter une nouvelle structure" 2016 "Ajouter une nouvelle structure" 2017 "Ajouter une nouvelle structure" 2018 "Ajouter une nouvelle structure" 2019 "Ajouter une nouvelle structure" 2020 "Ajouter une nouvelle structure" 2021 "Ajouter une nouvelle structure" 2022 "Ajouter une nouvelle structure" 2023 "Ajouter une nouvelle structure" 2024 "Ajouter une nouvelle structure" 2025 "Ajouter une nouvelle structure" 2026 "Ajouter une nouvelle structure" 2027 "Ajouter une nouvelle structure" 2028 "Ajouter une nouvelle structure" 2029 "Ajouter une nouvelle structure" 2030 "Ajouter une nouvelle structure" 2031 "Ajouter une nouvelle structure" 2032 "Ajouter une nouvelle structure" 2033 "Ajouter une nouvelle structure" 2034 "Ajouter une nouvelle structure" 2035 "Ajouter une nouvelle structure" 2036 "Ajouter une nouvelle structure" 2037 "Ajouter une nouvelle structure" 2038 "Ajouter une nouvelle structure" 2039 "Ajouter une nouvelle structure" 2040 "Ajouter une nouvelle structure" 2041 "Ajouter une nouvelle structure" 2042 "Ajouter une nouvelle structure" 2043 "Ajouter une nouvelle structure" 2044 "Ajouter une nouvelle structure" 2045 "Ajouter une nouvelle structure" 2046 "Ajouter une nouvelle structure" 2047 "Ajouter une nouvelle structure" 2048 "Ajouter une nouvelle structure" 2049 "Ajouter une nouvelle structure" 2050 "Ajouter une nouvelle structure" 2051 "Ajouter une nouvelle structure" 2052 "Ajouter une nouvelle structure" 2053 "Ajouter une nouvelle structure" 2054 "Ajouter une nouvelle structure" 2055 "Ajouter une nouvelle structure" 2056 "Ajouter une nouvelle structure" 2057 "Ajouter une nouvelle structure" 2058 "Ajouter une nouvelle structure" 2059 "Ajouter une nouvelle structure" 2060 "Ajouter une nouvelle structure" 2061 "Ajouter une nouvelle structure" 2062 "Ajouter une nouvelle structure" 2063 "Ajouter une nouvelle structure" 2064 "Ajouter une nouvelle structure" 2065 "Ajouter une nouvelle structure" 2066 "Ajouter une nouvelle structure" 2067 "Ajouter une nouvelle structure" 2068 "Ajouter une nouvelle structure" 2069 "Ajouter une nouvelle structure" 2070 "Ajouter une nouvelle structure" 2071 "Ajouter une nouvelle structure" 2072 "Ajouter une nouvelle structure" 2073 "Ajouter une nouvelle structure" 2074 "Ajouter une nouvelle structure" 2075 "Ajouter une nouvelle structure" 2076 "Ajouter une nouvelle structure" 2077 "Ajouter une nouvelle structure" 2078 "Ajouter une nouvelle structure" 2079 "Ajouter une nouvelle structure"
	label values i3 i3

	label variable i3b "Nouvelle structure"
	note i3b: "Nouvelle structure"

	label variable i4 "104. Type de structure"
	note i4: "104. Type de structure"
	label define i4 1 "EPS" 2 "CS"
	label values i4 i4

	label variable i4_1 "104. Quel type de EPS ?"
	note i4_1: "104. Quel type de EPS ?"
	label define i4_1 1 "EPS1" 2 "EPS2" 3 "EPS3"
	label values i4_1 i4_1

	label variable i4_2 "104. Quel type de CS ?"
	note i4_2: "104. Quel type de CS ?"
	label define i4_2 1 "CS1" 2 "CS2"
	label values i4_2 i4_2

	label variable i5 "105. Type d'emplacement"
	note i5: "105. Type d'emplacement"
	label define i5 1 "Rural" 2 "Urbain"
	label values i5 i5

	label variable equipe "Choisir l'équipe"
	note equipe: "Choisir l'équipe"
	label define equipe 1 "Equipe 1" 2 "Equipe 2" 3 "Equipe 3" 4 "Equipe 4" 5 "Equipe 5" 6 "Equipe 6" 7 "Equipe 7" 8 "Equipe 8" 9 "Equipe 9" 10 "Equipe 10" 11 "Equipe 11" 12 "Equipe 12" 13 "Equipe 13" 14 "Equipe 14" 15 "Equipe 15" 16 "Equipe 16" 17 "Equipe 17" 18 "Equipe 18" 19 "Equipe 19" 20 "Equipe 20" 21 "Equipe 21"
	label values equipe equipe

	label variable enqueteur "Nom de l'enquêteur"
	note enqueteur: "Nom de l'enquêteur"
	label define enqueteur 1 "Fleur Kona" 2 "Maimouna Yaye Pode Faye" 3 "Malick Ndiongue" 4 "Catherine Mendy" 5 "Mamadou Yacine Diallo Diallo" 6 "Yacine Sall Koumba Boulingui" 7 "Maty Leye" 8 "Fatoumata Binta Bah" 9 "Awa Diouf" 10 "Madicke Diop" 11 "Arona Diagne" 12 "Mame Salane Thiongane" 13 "Débo Diop" 14 "Ndeye Aby Gaye" 15 "Papa amadou Dieye" 16 "Younousse Chérif Goudiaby" 17 "Marieme Boye" 18 "Ibrahima Thiam" 19 "Ahmed Sene" 20 "Mame Gnagna Diagne Kane" 21 "Latyr Diagne" 22 "Sokhna Beye" 23 "Abdoul Khadre Djeylani Gueye" 24 "Bah Fall" 25 "Ndeye Mareme Diop" 26 "Ousmane Mbengue" 27 "Amadou Gueye" 28 "Momar Diop" 29 "Serigne Sow" 30 "Christophe Diouf" 31 "Maimouna Kane" 32 "Tabasky Diouf" 33 "Ndeye Anna Thiam" 34 "Youssou Diallo" 35 "Abdourahmane Niang" 36 "Mame Diarra Bousso Ndao" 37 "Omar Cisse" 38 "Coumba Kane" 39 "Yacine Sall" 40 "Mamadou Mar" 41 "Nayèdio Ba" 42 "Mame Bousso FAYE" 43 "Rokhaya Gueye" 44 "Ousmane Samba Gaye" 45 "Ibrahima Diarra" 46 "Khardiata Kane" 47 "Idrissa Gaye" 48 "Mafoudya Camara" 49 "Mouhamed Fall" 50 "Pape Amadou Diop" 51 "Diarra Ndoye" 52 "Bintou Ly" 53 "Mame Mossane Biram Sarr" 54 "Adama Diaw" 55 "Maty Sarr" 56 "Mouhamadou Moustapha Ba" 57 "Serigne saliou Ngom" 58 "Mbaye Ndoye" 59 "Aminata Sall Diéye" 60 "Sophie Faye" 61 "Bintou Gueye" 62 "Louise Taky bonang" 63 "Salimata Diallo" 64 "Adama Ba" 65 "Mamour Diop" 66 "Ndeye Ouleye Sarr" 67 "Djiby Diouf" 68 "Madicke Gaye" 69 "Mouhamadou Sy" 70 "Sokhna Diaité" 71 "Aminata Harouna Diagne" 72 "Moussa Kane" 73 "Cheikh Ndao" 74 "Yaya Balde" 75 "Cheikh Modou Falilou Faye" 76 "Setigne Ousseynou Wade" 77 "Khadim Diouf" 78 "Awa Ndiaye" 79 "Dieynaba Tall" 80 "Souleymane Diol" 81 "Lamine Diop" 82 "Gnima Diedhiou" 83 "Clara Sadio" 84 "Fatoumata Diémé"
	label values enqueteur enqueteur

	label variable s1_7 "106. Date de début de l'interview"
	note s1_7: "106. Date de début de l'interview"

	label variable s1_8 "Prénom et nom du prestataire"
	note s1_8: "Prénom et nom du prestataire"

	label variable s1_9 "Numéro téléphone du prestataire"
	note s1_9: "Numéro téléphone du prestataire"

	label variable s2_1 "201. Sexe du répondant"
	note s2_1: "201. Sexe du répondant"
	label define s2_1 1 "Masculin" 2 "Féminin"
	label values s2_1 s2_1

	label variable s2_2 "202. Quel âge aviez-vous à votre dernier anniversaire ?"
	note s2_2: "202. Quel âge aviez-vous à votre dernier anniversaire ?"

	label variable s2_3 "203. Quel est votre catégorie socio-professionnelle ?"
	note s2_3: "203. Quel est votre catégorie socio-professionnelle ?"
	label define s2_3 1 "Médecin gynécologue" 2 "Médecin d'une autre spécialité" 3 "Médecin non spécialisé" 4 "Interne des hôpitaux" 5 "Médecin stagiaire"
	label values s2_3 s2_3

	label variable s2_4 "204. Depuis quand occupez-vous le poste actuel ?"
	note s2_4: "204. Depuis quand occupez-vous le poste actuel ?"
	label define s2_4 1 "Année" 2 "Mois" 3 "Préfére ne pas répondre"
	label values s2_4 s2_4

	label variable s2_4_1 "Mettre le nombre d'années"
	note s2_4_1: "Mettre le nombre d'années"

	label variable s2_4_2 "Mettre le nombre de mois"
	note s2_4_2: "Mettre le nombre de mois"

	label variable s2_5 "205. Depuis quand travaillez-vous dans cette formation sanitaire ?"
	note s2_5: "205. Depuis quand travaillez-vous dans cette formation sanitaire ?"
	label define s2_5 1 "Année" 2 "Mois" 3 "Préfére ne pas répondre"
	label values s2_5 s2_5

	label variable s2_5_1 "Mettre le nombre d'années"
	note s2_5_1: "Mettre le nombre d'années"

	label variable s2_5_2 "Mettre le nombre de mois"
	note s2_5_2: "Mettre le nombre de mois"

	label variable s2_5a "205a. En dehors de cette structure sanitaire, travaillez-vous/fournissez-vous ég"
	note s2_5a: "205a. En dehors de cette structure sanitaire, travaillez-vous/fournissez-vous également des services de santé dans une autre structure sanitaire ?"
	label define s2_5a 1 "Oui, une autre structure sanitaire publique" 2 "Oui, une autre structure sanitaire /clinique privée" 3 "Non"
	label values s2_5a s2_5a

	label variable s2_6 "206. Quel est le plus haut diplôme obtenu ?"
	note s2_6: "206. Quel est le plus haut diplôme obtenu ?"
	label define s2_6 1 "Doctorat" 2 "DES" 4 "Autre (préciser)"
	label values s2_6 s2_6

	label variable s2_6_1 "206a. Veuillez précisez l'autre diplôme obtenu"
	note s2_6_1: "206a. Veuillez précisez l'autre diplôme obtenu"

	label variable s2_7 "207. Pendant votre période de service, avez-vous déjà fourni des services de SMN"
	note s2_7: "207. Pendant votre période de service, avez-vous déjà fourni des services de SMNI ?"
	label define s2_7 1 "Oui" 2 "Non"
	label values s2_7 s2_7

	label variable s2_8 "208. Depuis quand fournissez-vous des services de SMNI ?"
	note s2_8: "208. Depuis quand fournissez-vous des services de SMNI ?"
	label define s2_8 1 "Année" 2 "Mois" 3 "Préfére ne pas répondre"
	label values s2_8 s2_8

	label variable s2_8_1 "Mettre le nombre d'années"
	note s2_8_1: "Mettre le nombre d'années"

	label variable s2_8_2 "Mettre le nombre de mois"
	note s2_8_2: "Mettre le nombre de mois"

	label variable s2_9 "209. Avez-vous déjà fourni des services de SMNI dans cette structure sanitaire ?"
	note s2_9: "209. Avez-vous déjà fourni des services de SMNI dans cette structure sanitaire ?"
	label define s2_9 1 "Oui" 2 "Non"
	label values s2_9 s2_9

	label variable s2_10 "210. Depuis quand fournissez-vous des services de SMNI dans cette structure sani"
	note s2_10: "210. Depuis quand fournissez-vous des services de SMNI dans cette structure sanitaire ?"
	label define s2_10 1 "Année" 2 "Mois" 3 "Préfére ne pas répondre"
	label values s2_10 s2_10

	label variable s2_10_1 "Mettre le nombre d'années"
	note s2_10_1: "Mettre le nombre d'années"

	label variable s2_10_2 "Mettre le nombre de mois"
	note s2_10_2: "Mettre le nombre de mois"

	label variable s2_12_1 "212a. Avez-vous déjà fourni des services de préparation à l’accouchement et prép"
	note s2_12_1: "212a. Avez-vous déjà fourni des services de préparation à l’accouchement et préparation aux complications ?"
	label define s2_12_1 1 "Oui" 2 "Non"
	label values s2_12_1 s2_12_1

	label variable s2_13_1 "213a. Au cours des 12 derniers mois, avez-vous déjà fourni des services de prépa"
	note s2_13_1: "213a. Au cours des 12 derniers mois, avez-vous déjà fourni des services de préparation à l’accouchement et préparation aux complications ?"
	label define s2_13_1 1 "Oui" 2 "Non"
	label values s2_13_1 s2_13_1

	label variable s2_14_1 "214a. Quelle est la raison pour laquelle vous ne fournissez pas de service de pr"
	note s2_14_1: "214a. Quelle est la raison pour laquelle vous ne fournissez pas de service de préparation à l’accouchement et préparation aux complications ?"
	label define s2_14_1 1 "Pas confiant" 2 "Aucun client" 3 "Pas intéressé" 6 "Autre"
	label values s2_14_1 s2_14_1

	label variable s2_14_1a "Autre à préciser"
	note s2_14_1a: "Autre à préciser"

	label variable s2_15_1 "215a. Avez-vous bénéficié d'une formation en cours d'emploi, d'une formation de "
	note s2_15_1: "215a. Avez-vous bénéficié d'une formation en cours d'emploi, d'une formation de remise à niveau, d'un mentorat (sur site/hors site) dans la préparation à l’accouchement et préparation aux complications ?"

	label variable s2_16_1 "216a. La formation, la formation continue, la formation de recyclage, le mentora"
	note s2_16_1: "216a. La formation, la formation continue, la formation de recyclage, le mentorat ont-ils eu lieu au cours des 24 derniers mois ou il y a plus de 24 mois ?"
	label define s2_16_1 1 "Oui, au cours des 24 derniers mois" 2 "Oui, il y a plus de 24 mois"
	label values s2_16_1 s2_16_1

	label variable s2_12_2 "212b. Avez-vous déjà fourni des services de détection des grossesses à haut risq"
	note s2_12_2: "212b. Avez-vous déjà fourni des services de détection des grossesses à haut risque et orientation appropriée ?"
	label define s2_12_2 1 "Oui" 2 "Non"
	label values s2_12_2 s2_12_2

	label variable s2_13_2 "213b. Au cours des 12 derniers mois, avez-vous déjà fourni des services de détec"
	note s2_13_2: "213b. Au cours des 12 derniers mois, avez-vous déjà fourni des services de détection des grossesses à haut risque et orientation appropriée ?"
	label define s2_13_2 1 "Oui" 2 "Non"
	label values s2_13_2 s2_13_2

	label variable s2_14_2 "214b. Quelle est la raison pour laquelle vous ne fournissez pas de service de dé"
	note s2_14_2: "214b. Quelle est la raison pour laquelle vous ne fournissez pas de service de détection des grossesses à haut risque et orientation appropriée ?"
	label define s2_14_2 1 "Pas confiant" 2 "Aucun client" 3 "Pas intéressé" 6 "Autre"
	label values s2_14_2 s2_14_2

	label variable s2_14_2a "Autre à préciser"
	note s2_14_2a: "Autre à préciser"

	label variable s2_15_2 "215b. Avez-vous bénéficié d'une formation en cours d'emploi, d'une formation de "
	note s2_15_2: "215b. Avez-vous bénéficié d'une formation en cours d'emploi, d'une formation de remise à niveau, d'un mentorat (sur site/hors site) dans la détection des grossesses à haut risque et orientation appropriée ?"

	label variable s2_16_2 "216b. La formation, la formation continue, la formation de recyclage, le mentora"
	note s2_16_2: "216b. La formation, la formation continue, la formation de recyclage, le mentorat ont-ils eu lieu au cours des 24 derniers mois ou il y a plus de 24 mois ?"
	label define s2_16_2 1 "Oui, au cours des 24 derniers mois" 2 "Oui, il y a plus de 24 mois"
	label values s2_16_2 s2_16_2

	label variable s2_12_3 "212c. Avez-vous déjà fourni des services de prise en charge de l'anémie sévère a"
	note s2_12_3: "212c. Avez-vous déjà fourni des services de prise en charge de l'anémie sévère avec du fer saccharose ?"
	label define s2_12_3 1 "Oui" 2 "Non"
	label values s2_12_3 s2_12_3

	label variable s2_13_3 "213c. Au cours des 12 derniers mois, avez-vous déjà fourni des services de prise"
	note s2_13_3: "213c. Au cours des 12 derniers mois, avez-vous déjà fourni des services de prise en charge de l'anémie sévère avec du fer saccharose ?"
	label define s2_13_3 1 "Oui" 2 "Non"
	label values s2_13_3 s2_13_3

	label variable s2_14_3 "214c. Quelle est la raison pour laquelle vous ne fournissez pas de service de pr"
	note s2_14_3: "214c. Quelle est la raison pour laquelle vous ne fournissez pas de service de prise en charge de l'anémie sévère avec du fer saccharose ?"
	label define s2_14_3 1 "Pas confiant" 2 "Aucun client" 3 "Pas intéressé" 6 "Autre"
	label values s2_14_3 s2_14_3

	label variable s2_14_3a "Autre à préciser"
	note s2_14_3a: "Autre à préciser"

	label variable s2_15_3 "215c. Avez-vous bénéficié d'une formation en cours d'emploi, d'une formation de "
	note s2_15_3: "215c. Avez-vous bénéficié d'une formation en cours d'emploi, d'une formation de remise à niveau, d'un mentorat (sur site/hors site) dans la prise en charge de l'anémie sévère avec du fer saccharose ?"

	label variable s2_16_3 "216c. La formation, la formation continue, la formation de recyclage, le mentora"
	note s2_16_3: "216c. La formation, la formation continue, la formation de recyclage, le mentorat ont-ils eu lieu au cours des 24 derniers mois ou il y a plus de 24 mois ?"
	label define s2_16_3 1 "Oui, au cours des 24 derniers mois" 2 "Oui, il y a plus de 24 mois"
	label values s2_16_3 s2_16_3

	label variable s2_12_4 "212d. Avez-vous déjà fourni des services de partogramme ?"
	note s2_12_4: "212d. Avez-vous déjà fourni des services de partogramme ?"
	label define s2_12_4 1 "Oui" 2 "Non"
	label values s2_12_4 s2_12_4

	label variable s2_13_4 "213d. Au cours des 12 derniers mois, avez-vous déjà fourni des services de parto"
	note s2_13_4: "213d. Au cours des 12 derniers mois, avez-vous déjà fourni des services de partogramme ?"
	label define s2_13_4 1 "Oui" 2 "Non"
	label values s2_13_4 s2_13_4

	label variable s2_14_4 "214d. Quelle est la raison pour laquelle vous ne fournissez pas de partogramme ?"
	note s2_14_4: "214d. Quelle est la raison pour laquelle vous ne fournissez pas de partogramme ?"
	label define s2_14_4 1 "Pas confiant" 2 "Aucun client" 3 "Pas intéressé" 6 "Autre"
	label values s2_14_4 s2_14_4

	label variable s2_14_4a "Autre à préciser"
	note s2_14_4a: "Autre à préciser"

	label variable s2_15_4 "215d. Avez-vous bénéficié d'une formation en cours d'emploi, d'une formation de "
	note s2_15_4: "215d. Avez-vous bénéficié d'une formation en cours d'emploi, d'une formation de remise à niveau, d'un mentorat (sur site/hors site) dans le partogramme ?"

	label variable s2_16_4 "216d. La formation, la formation continue, la formation de recyclage, le mentora"
	note s2_16_4: "216d. La formation, la formation continue, la formation de recyclage, le mentorat ont-ils eu lieu au cours des 24 derniers mois ou il y a plus de 24 mois ?"
	label define s2_16_4 1 "Oui, au cours des 24 derniers mois" 2 "Oui, il y a plus de 24 mois"
	label values s2_16_4 s2_16_4

	label variable s2_17 "217. Au cours de votre période de service, avez-vous déjà fourni des services de"
	note s2_17: "217. Au cours de votre période de service, avez-vous déjà fourni des services de planning familial ?"
	label define s2_17 1 "Oui" 2 "Non"
	label values s2_17 s2_17

	label variable s2_18 "218. Depuis quand fournissez-vous des services de planification familiale ?"
	note s2_18: "218. Depuis quand fournissez-vous des services de planification familiale ?"
	label define s2_18 1 "Année" 2 "Mois" 3 "Préfére ne pas répondre"
	label values s2_18 s2_18

	label variable s2_18_1 "Mettre le nombre d'années"
	note s2_18_1: "Mettre le nombre d'années"

	label variable s2_18_2 "Mettre le nombre de mois"
	note s2_18_2: "Mettre le nombre de mois"

	label variable s2_19 "219. Avez-vous déjà fourni des services de planification familiale dans cette st"
	note s2_19: "219. Avez-vous déjà fourni des services de planification familiale dans cette structure sanitaire ?"
	label define s2_19 1 "Oui" 2 "Non"
	label values s2_19 s2_19

	label variable s2_20 "220. Depuis quand fournissez-vous des services de planification familiale dans c"
	note s2_20: "220. Depuis quand fournissez-vous des services de planification familiale dans cette structure sanitaire ?"
	label define s2_20 1 "Année" 2 "Mois" 3 "Préfére ne pas répondre"
	label values s2_20 s2_20

	label variable s2_20_1 "Mettre le nombre d'années"
	note s2_20_1: "Mettre le nombre d'années"

	label variable s2_20_2 "Mettre le nombre de mois"
	note s2_20_2: "Mettre le nombre de mois"

	label variable s2_21_1 "221a. Avez-vous bénéficié d'une formation en cours d'emploi ou d'une formation d"
	note s2_21_1: "221a. Avez-vous bénéficié d'une formation en cours d'emploi ou d'une formation de remise à niveau sur les conseils généraux en matière de planification familiale ?"
	label define s2_21_1 1 "Oui, au cours des 24 derniers mois" 2 "Oui, il y a plus de 24 mois" 3 "Non"
	label values s2_21_1 s2_21_1

	label variable s2_21_2 "221b. Avez-vous bénéficié d'une formation en cours d'emploi ou d'une formation d"
	note s2_21_2: "221b. Avez-vous bénéficié d'une formation en cours d'emploi ou d'une formation de remise à niveau sur les conseils sur les effets secondaires de la planification familiale et comment les gérer ?"
	label define s2_21_2 1 "Oui, au cours des 24 derniers mois" 2 "Oui, il y a plus de 24 mois" 3 "Non"
	label values s2_21_2 s2_21_2

	label variable s2_21_3 "221c. Avez-vous bénéficié d'une formation en cours d'emploi ou d'une formation d"
	note s2_21_3: "221c. Avez-vous bénéficié d'une formation en cours d'emploi ou d'une formation de remise à niveau sur la planification familiale pour les personnes séropositives ?"
	label define s2_21_3 1 "Oui, au cours des 24 derniers mois" 2 "Oui, il y a plus de 24 mois" 3 "Non"
	label values s2_21_3 s2_21_3

	label variable s2_21_4 "221d. Avez-vous bénéficié d'une formation en cours d'emploi ou d'une formation d"
	note s2_21_4: "221d. Avez-vous bénéficié d'une formation en cours d'emploi ou d'une formation de remise à niveau sur les conseils en planification familiale post-partum ?"
	label define s2_21_4 1 "Oui, au cours des 24 derniers mois" 2 "Oui, il y a plus de 24 mois" 3 "Non"
	label values s2_21_4 s2_21_4

	label variable s2_21_5 "221e. Avez-vous bénéficié d'une formation en cours d'emploi ou d'une formation d"
	note s2_21_5: "221e. Avez-vous bénéficié d'une formation en cours d'emploi ou d'une formation de remise à niveau sur les conseils en planification familiale après un avortement ?"
	label define s2_21_5 1 "Oui, au cours des 24 derniers mois" 2 "Oui, il y a plus de 24 mois" 3 "Non"
	label values s2_21_5 s2_21_5

	label variable s2_22 "Quelles sont les services de planification familiale que vous proposez ?"
	note s2_22: "Quelles sont les services de planification familiale que vous proposez ?"

	label variable s3_2 "302. Quelles informations sociodémographiques/liées à la fécondité collectez -vo"
	note s3_2: "302. Quelles informations sociodémographiques/liées à la fécondité collectez -vous auprès des nouveaux clients qui visitent l'établissement pour un DIU?"

	label variable s3_2a "302a. Précisez l'autre information collectée"
	note s3_2a: "302a. Précisez l'autre information collectée"

	label variable s3_3 "303. Quels antécédents menstruels recueillez-vous auprès des nouvelles clientes "
	note s3_3: "303. Quels antécédents menstruels recueillez-vous auprès des nouvelles clientes qui visitent la structure sanitaire pour un DIU?"

	label variable s3_3a "303a. Précisez l'autre information collectée"
	note s3_3a: "303a. Précisez l'autre information collectée"

	label variable s3_4 "304. Quels antécédents obstétricaux recueillez-vous auprès des nouvelles cliente"
	note s3_4: "304. Quels antécédents obstétricaux recueillez-vous auprès des nouvelles clientes qui visitent la structure sanitaire pour un DIU?"

	label variable s3_4a "303a. Précisez l'autre information collectée"
	note s3_4a: "303a. Précisez l'autre information collectée"

	label variable s3_5 "305. Recueillez -vous des informations sur l’état actuel de l’allaitement ?"
	note s3_5: "305. Recueillez -vous des informations sur l’état actuel de l’allaitement ?"
	label define s3_5 1 "Oui" 2 "Non"
	label values s3_5 s3_5

	label variable s3_6 "306. Quels antécédents contraceptifs recueillez-vous auprès des nouvelles client"
	note s3_6: "306. Quels antécédents contraceptifs recueillez-vous auprès des nouvelles clientes qui visitent la structure sanitaire pour un DIU ?"

	label variable s3_6a "306a. Preciser l'autre antécédant contraceptif recueilli auprès des clients."
	note s3_6a: "306a. Preciser l'autre antécédant contraceptif recueilli auprès des clients."

	label variable s3_7 "307. Quels antécédents reproductifs, sexuels et médico-chirurgicaux recueillez-v"
	note s3_7: "307. Quels antécédents reproductifs, sexuels et médico-chirurgicaux recueillez-vous auprès des nouvelles clientes qui visitent la structure sanitaire pour un DIU ?"

	label variable s3_7a "307a. Précisez l'autre antécédant reproductif, sexuel et médico-chirurgical recu"
	note s3_7a: "307a. Précisez l'autre antécédant reproductif, sexuel et médico-chirurgical recueilli."

	label variable s3_8 "308. Quelles informations fournissez-vous aux femmes avant d’adopter le DIU ?"
	note s3_8: "308. Quelles informations fournissez-vous aux femmes avant d’adopter le DIU ?"

	label variable s3_8a "308. Précisez autre information fournie avant l'adoption du DIU"
	note s3_8a: "308. Précisez autre information fournie avant l'adoption du DIU"

	label variable s3_9 "309. Selon vous, quels bilans cliniques effectuez-vous avant la mise en place d’"
	note s3_9: "309. Selon vous, quels bilans cliniques effectuez-vous avant la mise en place d’un DIU ?"

	label variable s3_9a "309a Précisez autre bilan clinique effectué."
	note s3_9a: "309a Précisez autre bilan clinique effectué."

	label variable s3_10 "310. Selon vous, quels examens de laboratoire prescrivez-vous à une cliente avan"
	note s3_10: "310. Selon vous, quels examens de laboratoire prescrivez-vous à une cliente avant d'insérer un DIU ?"

	label variable s3_10a "310a Précisez autre examen laboratoire à prescrire."
	note s3_10a: "310a Précisez autre examen laboratoire à prescrire."

	label variable s3_11 "311. Dans quelles conditions le personnel infirmier ne doit-il pas insérer de DI"
	note s3_11: "311. Dans quelles conditions le personnel infirmier ne doit-il pas insérer de DIU et doit-il plutôt référer à un médecin généraliste ou à un spécialiste ?"

	label variable s3_11a "311a Précisez autre condition de non insertion de DIU et de réferement à un méde"
	note s3_11a: "311a Précisez autre condition de non insertion de DIU et de réferement à un médecin généraliste ou à un spécialiste."

	label variable s3_12 "312. Pendant combien de temps gardez-vous une cliente à l'établissement après l'"
	note s3_12: "312. Pendant combien de temps gardez-vous une cliente à l'établissement après l'insertion d'un DIU ?"
	label define s3_12 1 "Libérer immédiatement" 2 "Moins d'une heure" 3 "Séjour d'une nuit requis" 96 "Autre (préciser)" 9 "Ne pas savoir"
	label values s3_12 s3_12

	label variable s3_12a "312a. Précisez autre durée de garde d'une patiente après insertion DIU."
	note s3_12a: "312a. Précisez autre durée de garde d'une patiente après insertion DIU."

	label variable s3_13 "313. Quelles instructions donnez-vous aux clientes DIU avant leur sortie ?"
	note s3_13: "313. Quelles instructions donnez-vous aux clientes DIU avant leur sortie ?"

	label variable s3_13a "313a Précisez autre instruction donnée avant la sortie."
	note s3_13a: "313a Précisez autre instruction donnée avant la sortie."

	label variable s3_14 "314. Quels sont les effets secondaires de l’utilisation du DIU dont vous informe"
	note s3_14: "314. Quels sont les effets secondaires de l’utilisation du DIU dont vous informez les clients ?"

	label variable s3_14a "314a Précisez autre effet secondaire informé aux clientes."
	note s3_14a: "314a Précisez autre effet secondaire informé aux clientes."

	label variable s3_15 "315. De quel mécanisme de suivi disposez-vous/la structure sanitaire dispose-t-e"
	note s3_15: "315. De quel mécanisme de suivi disposez-vous/la structure sanitaire dispose-t-elle, c'est-à-dire comment vous/la structure sanitaire assurez-vous que les clients DIU reçoivent des services de suivi à l'heure prévue ?"

	label variable s3_15a "315a. Précisez autre mécanisme de suivi de la structure."
	note s3_15a: "315a. Précisez autre mécanisme de suivi de la structure."

	label variable s3_16_1 "A. La période post-placentaire immédiate est le meilleur moment pour que la femm"
	note s3_16_1: "A. La période post-placentaire immédiate est le meilleur moment pour que la femme puisse se faire insérer un DIU."
	label define s3_16_1 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_16_1 s3_16_1

	label variable s3_16_2 "B. Une femme dont le diabète est contrôlé peut se faire insérer un DIU."
	note s3_16_2: "B. Une femme dont le diabète est contrôlé peut se faire insérer un DIU."
	label define s3_16_2 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_16_2 s3_16_2

	label variable s3_16_3 "C. Les DIU peuvent être insérés en toute sécurité chez un client atteint d'IST."
	note s3_16_3: "C. Les DIU peuvent être insérés en toute sécurité chez un client atteint d'IST."
	label define s3_16_3 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_16_3 s3_16_3

	label variable s3_16_4 "D. Les DIU ne peuvent pas être administrés aux clients souffrant d'anémie sévère"
	note s3_16_4: "D. Les DIU ne peuvent pas être administrés aux clients souffrant d'anémie sévère."
	label define s3_16_4 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_16_4 s3_16_4

	label variable s3_16_5 "E. Il est possible d'administrer un DIU à une femme atteinte du VIH/SIDA."
	note s3_16_5: "E. Il est possible d'administrer un DIU à une femme atteinte du VIH/SIDA."
	label define s3_16_5 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_16_5 s3_16_5

	label variable s3_16_6 "F. Une femme peut avoir un DIU inséré à tout moment dans les 12 jours suivant le"
	note s3_16_6: "F. Une femme peut avoir un DIU inséré à tout moment dans les 12 jours suivant le début des saignements menstruels."
	label define s3_16_6 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_16_6 s3_16_6

	label variable s3_16_7 "G. Des légers saignements entre les périodes menstruelles sont fréquents au cour"
	note s3_16_7: "G. Des légers saignements entre les périodes menstruelles sont fréquents au cours des 3 à 6 premiers mois d'utilisation du DIU. Ce n’est pas nocif et ils diminuent généralement avec le temps."
	label define s3_16_7 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_16_7 s3_16_7

	label variable s3_16_8 "H. Le DIU ne doit être supprimé qu'après le début du traitement de la salpingite"
	note s3_16_8: "H. Le DIU ne doit être supprimé qu'après le début du traitement de la salpingite si l'utilisateur souhaite le supprimer.Une visite de suivi après les premières règles ou 3 à 6 semaines après l'insertion d'un DIU est suffisante."
	label define s3_16_8 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_16_8 s3_16_8

	label variable s3_16_9 "I. Le DIU peut être utilisé comme contraception d’urgence dans les cinq jours su"
	note s3_16_9: "I. Le DIU peut être utilisé comme contraception d’urgence dans les cinq jours suivant un rapport sexuel non protégé."
	label define s3_16_9 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_16_9 s3_16_9

	label variable s3_16_10 "J. Une femme peut avoir un DIU inséré dans les 12 premiers jours après un avorte"
	note s3_16_10: "J. Une femme peut avoir un DIU inséré dans les 12 premiers jours après un avortement chirurgical."
	label define s3_16_10 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_16_10 s3_16_10

	label variable s3_16_11 "K. Une femme peut avoir un DIU inséré après 15 jours d’avortement médicamenteux "
	note s3_16_11: "K. Une femme peut avoir un DIU inséré après 15 jours d’avortement médicamenteux (en s’assurant que la cavité utérine est vide)."
	label define s3_16_11 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_16_11 s3_16_11

	label variable s3_16_12 "L. Les femmes atteintes de fibrome sous-muqueux peuvent se faire insérer un DIU."
	note s3_16_12: "L. Les femmes atteintes de fibrome sous-muqueux peuvent se faire insérer un DIU."
	label define s3_16_12 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_16_12 s3_16_12

	label variable s3_16_13 "M. Les femmes dont le partenaire a des antécédents d'écoulement pénien peuvent s"
	note s3_16_13: "M. Les femmes dont le partenaire a des antécédents d'écoulement pénien peuvent se faire insérer un DIU."
	label define s3_16_13 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_16_13 s3_16_13

	label variable s3_16_14 "N. La cliente doit contacter le prestataire si les saignements menstruels sont a"
	note s3_16_14: "N. La cliente doit contacter le prestataire si les saignements menstruels sont augmentés de deux fois en quantité et/ou en deux fois en durée après l'insertion d'un DIU."
	label define s3_16_14 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_16_14 s3_16_14

	label variable s3_16_15 "O. La mesure de la longueur de l'utérus est une étape critique dans la procédure"
	note s3_16_15: "O. La mesure de la longueur de l'utérus est une étape critique dans la procédure d'insertion du DIU."
	label define s3_16_15 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_16_15 s3_16_15

	label variable s3_16_16 "P. Le ruban mètre doit être utilisé pour mesurer la longueur de l’utérus lors de"
	note s3_16_16: "P. Le ruban mètre doit être utilisé pour mesurer la longueur de l’utérus lors de l’insertion d’un DIU."
	label define s3_16_16 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_16_16 s3_16_16

	label variable s3_16_17 "Q. Après un avortement chirurgical, il est recommandé l’application d'un antisep"
	note s3_16_17: "Q. Après un avortement chirurgical, il est recommandé l’application d'un antiseptique approprié (par exemple, povidone iodée ou chlohexidine) deux fois ou plus sur le col et le vagin en commençant par le canal cervical avant l'insertion de DIU."
	label define s3_16_17 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_16_17 s3_16_17

	label variable s3_16_18 "R. Le chargement du DIU sans contact empêche l'introduction d'une infection pend"
	note s3_16_18: "R. Le chargement du DIU sans contact empêche l'introduction d'une infection pendant la procédure d'insertion."
	label define s3_16_18 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_16_18 s3_16_18

	label variable s3_16_19 "S. Le diagramme OMS pour les critères d’éligibilité est utilisé pour vérifier l’"
	note s3_16_19: "S. Le diagramme OMS pour les critères d’éligibilité est utilisé pour vérifier l’éligibilité de la cliente à l‘administration d’un DIU."
	label define s3_16_19 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_16_19 s3_16_19

	label variable s3_16_20 "T. Certains DIU sont approuvés pour 10 ans d’utilisation après insertion."
	note s3_16_20: "T. Certains DIU sont approuvés pour 10 ans d’utilisation après insertion."
	label define s3_16_20 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_16_20 s3_16_20

	label variable s3_16_a "316a. Scénario : FATOU, une femme de 32 ans, envisage d'utiliser un dispositif i"
	note s3_16_a: "316a. Scénario : FATOU, une femme de 32 ans, envisage d'utiliser un dispositif intra-utérin (DIU) pour une contraception à long terme. De quoi l'infirmière devrait-elle informer Sarah concernant le dispositif intra-utérin (DIU) ?"
	label define s3_16_a 1 "Son efficacité uniquement pour les femmes nullipares" 2 "La nécessité de remplacements fréquents" 3 "Le risque d'infertilité après ablation" 4 "Sa haute efficacité et son faible entretien"
	label values s3_16_a s3_16_a

	label variable s3_18 "318. Quelles informations sociodémographiques/liées à la fertilité collectez-vou"
	note s3_18: "318. Quelles informations sociodémographiques/liées à la fertilité collectez-vous auprès des nouveles clientes qui visitent la structure sanitaire pour recevoir des injectables ?"

	label variable s3_18a "318a. Préciser autre information collectée."
	note s3_18a: "318a. Préciser autre information collectée."

	label variable s3_19 "319. Quels antécédents obstétricaux recueillez-vous auprès des nouvelles cliente"
	note s3_19: "319. Quels antécédents obstétricaux recueillez-vous auprès des nouvelles clientes qui visitent la structure sanitaire pour Injectable ?"

	label variable s3_19a "319a. Préciser autre antécédant obstétricaux recueilli auprés des clientes"
	note s3_19a: "319a. Préciser autre antécédant obstétricaux recueilli auprés des clientes"

	label variable s3_20 "320. Collectez-vous des informations sur l’état actuel de l’allaitement ?"
	note s3_20: "320. Collectez-vous des informations sur l’état actuel de l’allaitement ?"
	label define s3_20 1 "Oui" 2 "Non"
	label values s3_20 s3_20

	label variable s3_21 "321. Quels antécédents contraceptifs recueillez-vous auprès des nouvelles client"
	note s3_21: "321. Quels antécédents contraceptifs recueillez-vous auprès des nouvelles clientes qui visitent la structure sanitaire pour recevoir un injectable ?"

	label variable s3_21a "321a. Préciser autre antécédant contraceptif recueilli auprés des clientes avant"
	note s3_21a: "321a. Préciser autre antécédant contraceptif recueilli auprés des clientes avant un injectable"

	label variable s3_22 "322. Quels antécédents menstruels recueillez-vous auprès des nouvelles clientes "
	note s3_22: "322. Quels antécédents menstruels recueillez-vous auprès des nouvelles clientes qui visitent la structure sanitaire pour obtenir des injectables ?"

	label variable s3_22a "322a. Préciser autre antécédant mentruel recueilli auprés des clientes avant un "
	note s3_22a: "322a. Préciser autre antécédant mentruel recueilli auprés des clientes avant un injectable"

	label variable s3_23 "323. Quels antécédents médicaux recueillez-vous auprès des nouveles clientes qui"
	note s3_23: "323. Quels antécédents médicaux recueillez-vous auprès des nouveles clientes qui visitent la structure sanitaire pour recevoir des injectables ?"

	label variable s3_23a "323a. Préciser autre antécédant médical recueilli auprés des clientes avant un i"
	note s3_23a: "323a. Préciser autre antécédant médical recueilli auprés des clientes avant un injectable"

	label variable s3_24 "324. Quels examens faites-vous avant de donner des injectables ?"
	note s3_24: "324. Quels examens faites-vous avant de donner des injectables ?"

	label variable s3_24a "324a. Préciser autre examen médical effectué par clientes avant un injectable"
	note s3_24a: "324a. Préciser autre examen médical effectué par clientes avant un injectable"

	label variable s3_25 "325. Quelles informations donnez-vous aux clientes avant de lui administrer des "
	note s3_25: "325. Quelles informations donnez-vous aux clientes avant de lui administrer des injectables ?"

	label variable s3_25a "325a. Préciser autre information donnée aux clientes avant un injectable"
	note s3_25a: "325a. Préciser autre information donnée aux clientes avant un injectable"

	label variable s3_26 "326. Quels conseils donnez-vous à une femme après la prise d'un Contraceptif inj"
	note s3_26: "326. Quels conseils donnez-vous à une femme après la prise d'un Contraceptif injectable ?"

	label variable s3_26a "326a. Préciser autre conseil donné aux clientes avant un injectable"
	note s3_26a: "326a. Préciser autre conseil donné aux clientes avant un injectable"

	label variable s3_27 "327. De quel mécanisme de suivi disposez-vous/l'établissement dispose-t-il, c'es"
	note s3_27: "327. De quel mécanisme de suivi disposez-vous/l'établissement dispose-t-il, c'est-à-dire comment vous/l'établissement assurez-vous que les clientes des contraceptifs injectables reçoivent des services de suivi à l'heure prévue ?"

	label variable s3_27a "327a. Préciser autre mécanisme de suivi pour la réception d'injection au moment "
	note s3_27a: "327a. Préciser autre mécanisme de suivi pour la réception d'injection au moment prévu"

	label variable s3_28_1 "A. L’injectable bénéficie d’un délai de grâce d’un mois après la date d’échéance"
	note s3_28_1: "A. L’injectable bénéficie d’un délai de grâce d’un mois après la date d’échéance."
	label define s3_28_1 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_28_1 s3_28_1

	label variable s3_28_2 "B. Un examen pelvien est requis avant l’administration d’Injectable."
	note s3_28_2: "B. Un examen pelvien est requis avant l’administration d’Injectable."
	label define s3_28_2 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_28_2 s3_28_2

	label variable s3_28_3 "C. L’injectable peut être administré immédiatement ou dans les sept jours suivan"
	note s3_28_3: "C. L’injectable peut être administré immédiatement ou dans les sept jours suivant un avortement chirurgical."
	label define s3_28_3 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_28_3 s3_28_3

	label variable s3_28_4 "D. L’injectable peut être administré après 45 ans."
	note s3_28_4: "D. L’injectable peut être administré après 45 ans."
	label define s3_28_4 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_28_4 s3_28_4

	label variable s3_28_5 "E. Le retour à la fertilité après l'arrêt du DMPA injectable prend 12 mois après"
	note s3_28_5: "E. Le retour à la fertilité après l'arrêt du DMPA injectable prend 12 mois après la dernière injection."
	label define s3_28_5 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_28_5 s3_28_5

	label variable s3_28_6 "F. L’injectable protège du VIH et des IST."
	note s3_28_6: "F. L’injectable protège du VIH et des IST."
	label define s3_28_6 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_28_6 s3_28_6

	label variable s3_28_7 "G. Si l'injectable est administré au-delà du 7ème jour du cycle menstruel, les p"
	note s3_28_7: "G. Si l'injectable est administré au-delà du 7ème jour du cycle menstruel, les préservatifs doivent être conseillés comme solution de secours pendant une semaine."
	label define s3_28_7 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_28_7 s3_28_7

	label variable s3_28_8 "H. La méthode injectable peut être administrée par voie sous-cutanée."
	note s3_28_8: "H. La méthode injectable peut être administrée par voie sous-cutanée."
	label define s3_28_8 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_28_8 s3_28_8

	label variable s3_28_9 "I. Il est recommandé de reprendre le poids et la TA à chaque dose ultérieure."
	note s3_28_9: "I. Il est recommandé de reprendre le poids et la TA à chaque dose ultérieure."
	label define s3_28_9 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_28_9 s3_28_9

	label variable s3_28_10 "J. L’injection injectable doit être réfrigérée."
	note s3_28_10: "J. L’injection injectable doit être réfrigérée."
	label define s3_28_10 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_28_10 s3_28_10

	label variable s3_28_11 "K. L’hygiène des mains doit se faire après l'administration."
	note s3_28_11: "K. L’hygiène des mains doit se faire après l'administration."
	label define s3_28_11 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_28_11 s3_28_11

	label variable s3_28_12 "L. L'injectable peut être administré aux clientes atteintes d'un cancer du sein."
	note s3_28_12: "L. L'injectable peut être administré aux clientes atteintes d'un cancer du sein."
	label define s3_28_12 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_28_12 s3_28_12

	label variable s3_28_13 "M. L'injectable peut être administré aux clientes atteintes d'un cancer du col d"
	note s3_28_13: "M. L'injectable peut être administré aux clientes atteintes d'un cancer du col de l'utérus."
	label define s3_28_13 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_28_13 s3_28_13

	label variable s3_28_14 "N. L'injectable peut être administré aux clients dont la TA est > 160/100 mm Hg."
	note s3_28_14: "N. L'injectable peut être administré aux clients dont la TA est > 160/100 mm Hg."
	label define s3_28_14 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_28_14 s3_28_14

	label variable s3_28_15 "O. L'injectable a un effet sur la densité minérale osseuse."
	note s3_28_15: "O. L'injectable a un effet sur la densité minérale osseuse."
	label define s3_28_15 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_28_15 s3_28_15

	label variable s3_28_16 "P. Le traitement injectable peut être commencé immédiatement si la femme allaite"
	note s3_28_16: "P. Le traitement injectable peut être commencé immédiatement si la femme allaite."
	label define s3_28_16 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_28_16 s3_28_16

	label variable s3_28_17 "Q. L’injectable provoque des saignements intermenstruels ou une ménorragie."
	note s3_28_17: "Q. L’injectable provoque des saignements intermenstruels ou une ménorragie."
	label define s3_28_17 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_28_17 s3_28_17

	label variable s3_28_18 "R. L’injectable provoque une prise de poids."
	note s3_28_18: "R. L’injectable provoque une prise de poids."
	label define s3_28_18 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_28_18 s3_28_18

	label variable s3_28_19 "S. Si le saignement est deux fois plus long et deux fois plus abondant, une inte"
	note s3_28_19: "S. Si le saignement est deux fois plus long et deux fois plus abondant, une intervention médicale lourde est nécessaire."
	label define s3_28_19 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_28_19 s3_28_19

	label variable s3_28_20 "T. Les aiguilles après utilisation doivent être jetées dans la poubelle."
	note s3_28_20: "T. Les aiguilles après utilisation doivent être jetées dans la poubelle."
	label define s3_28_20 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_28_20 s3_28_20

	label variable s3_28_21 "U. Le recapuchonnage de l'aiguille usagée devrait être obligatoire."
	note s3_28_21: "U. Le recapuchonnage de l'aiguille usagée devrait être obligatoire."
	label define s3_28_21 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_28_21 s3_28_21

	label variable s3_30 "330. Quelles informations sociodémographiques/liées à la fertilité collectez-vou"
	note s3_30: "330. Quelles informations sociodémographiques/liées à la fertilité collectez-vous auprès des nouveles clientes qui visitent l'établissement pour des implants ?"

	label variable s3_30a "330a. Préciser autre information recueilli auprés des clientes."
	note s3_30a: "330a. Préciser autre information recueilli auprés des clientes."

	label variable s3_31 "331. Quels antécédents menstruels recueillez-vous auprès des nouvelles clientes "
	note s3_31: "331. Quels antécédents menstruels recueillez-vous auprès des nouvelles clientes qui visitent la structure sanitaire pour des implants ?"

	label variable s3_31a "331a. Préciser autre antécédant menstruel recueilli auprés des clientes."
	note s3_31a: "331a. Préciser autre antécédant menstruel recueilli auprés des clientes."

	label variable s3_32 "332. Quels antécédents obstétricaux recueillez-vous auprès des nouvelles cliente"
	note s3_32: "332. Quels antécédents obstétricaux recueillez-vous auprès des nouvelles clientes qui visitent l'établissement pour des implants ?"

	label variable s3_32a "332a. Préciser autre antécédant obstétrical recueilli auprés des clientes."
	note s3_32a: "332a. Préciser autre antécédant obstétrical recueilli auprés des clientes."

	label variable s3_33 "333. Quelles sont les informations relatives aux antécédents contraceptifs que v"
	note s3_33: "333. Quelles sont les informations relatives aux antécédents contraceptifs que vous recueillez auprès des nouvelles clientes qui visitent l'établissement pour des implants ?"

	label variable s3_33a "333a. Préciser autre information relative aux antécédants contraceptifs recueill"
	note s3_33a: "333a. Préciser autre information relative aux antécédants contraceptifs recueillie auprés des clientes."

	label variable s3_34 "334. Quels antécédents médicaux recueillez-vous auprès des nouvelles clientes qu"
	note s3_34: "334. Quels antécédents médicaux recueillez-vous auprès des nouvelles clientes qui visitent la structure sanitaire pour des implants ?"

	label variable s3_34a "334a. Préciser autre antécédant médical recueillie auprés des clientes."
	note s3_34a: "334a. Préciser autre antécédant médical recueillie auprés des clientes."

	label variable s3_35 "335. Quelles informations donnez-vous à la cliente avant de poser des implants ?"
	note s3_35: "335. Quelles informations donnez-vous à la cliente avant de poser des implants ?"

	label variable s3_35a "335a. Préciser autre information donnée avant de poser l'implant ."
	note s3_35a: "335a. Préciser autre information donnée avant de poser l'implant ."

	label variable s3_36 "336. Quels examens faites-vous avant de poser des implants ?"
	note s3_36: "336. Quels examens faites-vous avant de poser des implants ?"

	label variable s3_36a "336a. Préciser autre examen réalisé avant de poser l'implant ."
	note s3_36a: "336a. Préciser autre examen réalisé avant de poser l'implant ."

	label variable s3_37 "337. Quelles instructions et conseils donnez-vous à une femme après la réception"
	note s3_37: "337. Quelles instructions et conseils donnez-vous à une femme après la réception d’implants ?"

	label variable s3_37a "337a. Préciser autre instruction et conseil donnés après la réception de l'impla"
	note s3_37a: "337a. Préciser autre instruction et conseil donnés après la réception de l'implant ."

	label variable s3_38 "338. Informez-vous les clients des complications possibles après la pose de l'im"
	note s3_38: "338. Informez-vous les clients des complications possibles après la pose de l'implant ?"
	label define s3_38 1 "Oui" 2 "Non"
	label values s3_38 s3_38

	label variable s3_39 "339. Quelles sont les complications possibles pour lesquelles la cliente doit re"
	note s3_39: "339. Quelles sont les complications possibles pour lesquelles la cliente doit retourner immédiatement à l'établissement ?"

	label variable s3_39a "339a. Préciser autre complication pouvant entrainer un retour à l'établissement."
	note s3_39a: "339a. Préciser autre complication pouvant entrainer un retour à l'établissement."

	label variable s3_40 "340. Quelles instructions et conseils donnez-vous à une femme après le retrait d"
	note s3_40: "340. Quelles instructions et conseils donnez-vous à une femme après le retrait des implants ? D'autres questions ?"

	label variable s3_40a "340a. Préciser autre instruction et conseils."
	note s3_40a: "340a. Préciser autre instruction et conseils."

	label variable s3_41_1 "A. Les implants offrent une protection de 3 à 5 ans contre une grossesse non dés"
	note s3_41_1: "A. Les implants offrent une protection de 3 à 5 ans contre une grossesse non désirée selon le type d'implant."
	label define s3_41_1 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_41_1 s3_41_1

	label variable s3_41_2 "B. L'implant doit être inséré sous la peau du bras non dominant."
	note s3_41_2: "B. L'implant doit être inséré sous la peau du bras non dominant."
	label define s3_41_2 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_41_2 s3_41_2

	label variable s3_41_3 "C. Le retour à la fertilité après le retrait de l'implant prend 12 mois."
	note s3_41_3: "C. Le retour à la fertilité après le retrait de l'implant prend 12 mois."
	label define s3_41_3 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_41_3 s3_41_3

	label variable s3_41_4 "D. L'implant ne peut pas être inséré chez une femme présentant une rupture prolo"
	note s3_41_4: "D. L'implant ne peut pas être inséré chez une femme présentant une rupture prolongée de la membrane."
	label define s3_41_4 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_41_4 s3_41_4

	label variable s3_41_5 "E. L'implant peut être donné à une femme après une Hémorragie du postpartum."
	note s3_41_5: "E. L'implant peut être donné à une femme après une Hémorragie du postpartum."
	label define s3_41_5 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_41_5 s3_41_5

	label variable s3_41_6 "F. L'implant devient efficace en 48 heures après l'insertion."
	note s3_41_6: "F. L'implant devient efficace en 48 heures après l'insertion."
	label define s3_41_6 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_41_6 s3_41_6

	label variable s3_41_7 "G. L'implant a un effet sur la densité minérale osseuse."
	note s3_41_7: "G. L'implant a un effet sur la densité minérale osseuse."
	label define s3_41_7 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_41_7 s3_41_7

	label variable s3_41_8 "H. L'implant doit être retiré par un prestataire de soins de santé qualifié."
	note s3_41_8: "H. L'implant doit être retiré par un prestataire de soins de santé qualifié."
	label define s3_41_8 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_41_8 s3_41_8

	label variable s3_41_9 "I. Les implants font partie des méthodes les plus efficaces et ont une action pr"
	note s3_41_9: "I. Les implants font partie des méthodes les plus efficaces et ont une action prolongée."
	label define s3_41_9 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_41_9 s3_41_9

	label variable s3_41_10 "J. Les implants ne doivent pas être insérés chez une femme qui allaite un bébé d"
	note s3_41_10: "J. Les implants ne doivent pas être insérés chez une femme qui allaite un bébé de moins de 6 semaines."
	label define s3_41_10 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_41_10 s3_41_10

	label variable s3_41_11 "K. Les implants ne doivent pas être insérés si une femme souffre d’une maladie g"
	note s3_41_11: "K. Les implants ne doivent pas être insérés si une femme souffre d’une maladie grave, d’une infection ou d’une tumeur dans le foie."
	label define s3_41_11 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_41_11 s3_41_11

	label variable s3_41_12 "L. Les implants ne doivent pas être insérés chez une femme atteinte d'un cancer "
	note s3_41_12: "L. Les implants ne doivent pas être insérés chez une femme atteinte d'un cancer du sein ."
	label define s3_41_12 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_41_12 s3_41_12

	label variable s3_41_13 "M. Les implants ne doivent pas être insérés chez une femme qui présente actuelle"
	note s3_41_13: "M. Les implants ne doivent pas être insérés chez une femme qui présente actuellement un caillot sanguin dans les veines profondes des jambes ou des poumons."
	label define s3_41_13 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_41_13 s3_41_13

	label variable s3_41_14 "N. Les implants ne se déplacent pas vers d’autres parties du corps."
	note s3_41_14: "N. Les implants ne se déplacent pas vers d’autres parties du corps."
	label define s3_41_14 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_41_14 s3_41_14

	label variable s3_41_15 "O. Une femme qui a choisi des implants doit être informée de ce qui se passe lor"
	note s3_41_15: "O. Une femme qui a choisi des implants doit être informée de ce qui se passe lors de l'insertion."
	label define s3_41_15 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_41_15 s3_41_15

	label variable s3_41_16 "P. La tige retirée et les articles contaminés (compresse, coton et autres articl"
	note s3_41_16: "P. La tige retirée et les articles contaminés (compresse, coton et autres articles) doivent être jetés dans la poubelle ."
	label define s3_41_16 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_41_16 s3_41_16

	label variable s3_41_17 "Q. Le client doit être orienté vers un établissement supérieur si la tige n'est "
	note s3_41_17: "Q. Le client doit être orienté vers un établissement supérieur si la tige n'est pas palpable ou palpable profondément."
	label define s3_41_17 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_41_17 s3_41_17

	label variable s3_41_18 "R. L'implant peut être localisé par radiographie bidimensionnelle."
	note s3_41_18: "R. L'implant peut être localisé par radiographie bidimensionnelle."
	label define s3_41_18 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_41_18 s3_41_18

	label variable s3_41a "341a. Scénario : Jessica, une femme de 28 ans, se présente à la clinique pour la"
	note s3_41a: "341a. Scénario : Jessica, une femme de 28 ans, se présente à la clinique pour la pose d'un implant contraceptif. Question : Quelle est l’étape cruciale que l’infirmière doit franchir avant d’insérer l’implant contraceptif ?"
	label define s3_41a 1 "Sauter la séance de conseil car la procédure est simple" 2 "Interroger le patient sur toute allergie ou réaction aux implants précédents" 3 "Planifier l'insertion sans vérifier l'identité du patient" 4 "Fournir l’implant sans expliquer les effets secondaires potentiels"
	label values s3_41a s3_41a

	label variable s3_43 "343. Quelles informations sociodémographiques/liées à la fertilité collectez-vou"
	note s3_43: "343. Quelles informations sociodémographiques/liées à la fertilité collectez-vous auprès des nouvelles clientes qui visitent l'établissement de stérilisation féminine ?"

	label variable s3_43a "343a. Préciser autre information socio démographique collectée."
	note s3_43a: "343a. Préciser autre information socio démographique collectée."

	label variable s3_44 "344. Quels sont les antécédents menstruels que vous recueillez auprès des nouvel"
	note s3_44: "344. Quels sont les antécédents menstruels que vous recueillez auprès des nouvelles clientes qui visitent la structure sanitaire pour une stérilisation ?"

	label variable s3_44a "344a. Préciser autre antécédant menstruel recueilli auprès des clientes."
	note s3_44a: "344a. Préciser autre antécédant menstruel recueilli auprès des clientes."

	label variable s3_45 "345. Quels antécédents obstétricaux recueillez-vous auprès des nouvelles cliente"
	note s3_45: "345. Quels antécédents obstétricaux recueillez-vous auprès des nouvelles clientes qui visitent l'établissement pour une stérilisation ?"

	label variable s3_45a "345a. Préciser autre antécédant obstétrical recueilli auprès des clientes."
	note s3_45a: "345a. Préciser autre antécédant obstétrical recueilli auprès des clientes."

	label variable s3_46 "346. Quelles informations relatives aux antécédents contraceptifs collectez-vous"
	note s3_46: "346. Quelles informations relatives aux antécédents contraceptifs collectez-vous auprès des nouvelles clientes qui visitent la structure sanitaire pour des stérilisation ?"

	label variable s3_46a "346a. Préciser autre antécédant contraceptif recueilli auprès des clientes."
	note s3_46a: "346a. Préciser autre antécédant contraceptif recueilli auprès des clientes."

	label variable s3_47 "347. Quelles sont les conditions médicales qui nécessitent une approche prudente"
	note s3_47: "347. Quelles sont les conditions médicales qui nécessitent une approche prudente de la chirurgie dans un contexte de routine ?"

	label variable s3_47a "347a. Préciser autre condition médicale nécessitant une approche prudente de la "
	note s3_47a: "347a. Préciser autre condition médicale nécessitant une approche prudente de la chirurgie."

	label variable s3_48 "348. Dans quelles conditions médicales la stérilisation féminine doit-elle être "
	note s3_48: "348. Dans quelles conditions médicales la stérilisation féminine doit-elle être effectuée par un chirurgien expérimenté dans un établissement disposant d'une anesthésie générale et d'une assistance médicale ?"

	label variable s3_48a "348a. Préciser autre condition médicale de la réalisation de la stérilisation."
	note s3_48a: "348a. Préciser autre condition médicale de la réalisation de la stérilisation."

	label variable s3_49 "349. Quelles informations fournissez-vous à la cliente avant l’opération de stér"
	note s3_49: "349. Quelles informations fournissez-vous à la cliente avant l’opération de stérilisation ?"

	label variable s3_49a "349a. Préciser autre information fournie avant la stérilisation."
	note s3_49a: "349a. Préciser autre information fournie avant la stérilisation."

	label variable s3_50 "350. Selon vous, quel bilan clinique faut-il réaliser avant la stérilisation fém"
	note s3_50: "350. Selon vous, quel bilan clinique faut-il réaliser avant la stérilisation féminine ?"

	label variable s3_50a "350a. Préciser autre information fournie avant la stérilisation."
	note s3_50a: "350a. Préciser autre information fournie avant la stérilisation."

	label variable s3_51 "351. Selon vous, quels examens de laboratoire prescrivez-vous à la cliente avant"
	note s3_51: "351. Selon vous, quels examens de laboratoire prescrivez-vous à la cliente avant la stérilisation féminine ?"

	label variable s3_51a "351a. Préciser autre examen de laboratoire prescrit avant la stérilisation."
	note s3_51a: "351a. Préciser autre examen de laboratoire prescrit avant la stérilisation."

	label variable s3_52 "352. Combien de temps une cliente doit-elle rester dans la structure sanitaire a"
	note s3_52: "352. Combien de temps une cliente doit-elle rester dans la structure sanitaire après une stérilisation féminine ?"
	label define s3_52 1 "Moins de quatre heures" 2 "4 à 6 heures" 3 "7 à 9 heures" 4 "Plus de 9 heures" 96 "Autres (préciser)"
	label values s3_52 s3_52

	label variable s3_52a "352a. Préciser autre durée d'observation dans la structure après stérilisation."
	note s3_52a: "352a. Préciser autre durée d'observation dans la structure après stérilisation."

	label variable s3_53 "353. Quels examens post-procéduraux effectuez-vous avant de renvoyer une cliente"
	note s3_53: "353. Quels examens post-procéduraux effectuez-vous avant de renvoyer une cliente stérilisée ?"

	label variable s3_53a "353a. Préciser autre examen post-procédural effectué avant de renvoyer la client"
	note s3_53a: "353a. Préciser autre examen post-procédural effectué avant de renvoyer la cliente ."

	label variable s3_54 "354. Quelles instructions donnez-vous aux clientes avant leur sortie de la struc"
	note s3_54: "354. Quelles instructions donnez-vous aux clientes avant leur sortie de la structure sanitaire ?"

	label variable s3_54a "354a. Préciser autre instruction donnée aux clientes avant la sortie."
	note s3_54a: "354a. Préciser autre instruction donnée aux clientes avant la sortie."

	label variable s3_55 "355. Informez-vous les clientes des complications possibles qu'elles pourraient "
	note s3_55: "355. Informez-vous les clientes des complications possibles qu'elles pourraient rencontrer après la stérilisation ?"
	label define s3_55 1 "Oui" 2 "Non"
	label values s3_55 s3_55

	label variable s3_56 "356. Quelles sont les complications possibles sur lesquelles vous vous informez "
	note s3_56: "356. Quelles sont les complications possibles sur lesquelles vous vous informez ?"

	label variable s3_56a "356a. Préciser autre complication possible connue."
	note s3_56a: "356a. Préciser autre complication possible connue."

	label variable s3_57 "357. Quel est le mécanisme de suivi dont vous disposez ou dont l'établissement d"
	note s3_57: "357. Quel est le mécanisme de suivi dont vous disposez ou dont l'établissement dispose, c'est-à-dire comment veillez-vous à ce que les femmes stérilisées bénéficient des services de suivi à la date prévue ?"

	label variable s3_57a "357a. Préciser autre mécanisme de suivi de l'établissement pour le respect des d"
	note s3_57a: "357a. Préciser autre mécanisme de suivi de l'établissement pour le respect des délais."

	label variable s3_58_1 "A. La période post-partum est le meilleur moment pour que la femme se fasse stér"
	note s3_58_1: "A. La période post-partum est le meilleur moment pour que la femme se fasse stériliser."
	label define s3_58_1 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_58_1 s3_58_1

	label variable s3_58_2 "B. La stérilisation féminine ne doit pas être associée à un avortement chirurgic"
	note s3_58_2: "B. La stérilisation féminine ne doit pas être associée à un avortement chirurgical."
	label define s3_58_2 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_58_2 s3_58_2

	label variable s3_58_3 "C. La stérilisation ne peut pas être pratiquée sur les femmes dont le taux d'hém"
	note s3_58_3: "C. La stérilisation ne peut pas être pratiquée sur les femmes dont le taux d'hémoglobine est inférieur à 7 g/dL."
	label define s3_58_3 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_58_3 s3_58_3

	label variable s3_58_4 "D. Il est acceptable d'effectuer une stérilisation sur une cliente atteinte d’un"
	note s3_58_4: "D. Il est acceptable d'effectuer une stérilisation sur une cliente atteinte d’une IST."
	label define s3_58_4 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_58_4 s3_58_4

	label variable s3_58_5 "E. Le dépistage du VIH est obligatoire avant de procéder à la stérilisation."
	note s3_58_5: "E. Le dépistage du VIH est obligatoire avant de procéder à la stérilisation."
	label define s3_58_5 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_58_5 s3_58_5

	label variable s3_58_6 "F. La présence d'anesthésistes est nécessaire pour la procédure de stérilisation"
	note s3_58_6: "F. La présence d'anesthésistes est nécessaire pour la procédure de stérilisation."
	label define s3_58_6 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_58_6 s3_58_6

	label variable s3_58_7 "G. La présence d'un membre de la famille auprès de la femme est nécessaire pour "
	note s3_58_7: "G. La présence d'un membre de la famille auprès de la femme est nécessaire pour la stérilisation."
	label define s3_58_7 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_58_7 s3_58_7

	label variable s3_58_8 "H. Le consentement du mari est obligatoire pour que les femmes puissent se faire"
	note s3_58_8: "H. Le consentement du mari est obligatoire pour que les femmes puissent se faire stériliser."
	label define s3_58_8 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_58_8 s3_58_8

	label variable s3_58_9 "I. Une nuitée est requise pour la stérilisation par laparoscopie."
	note s3_58_9: "I. Une nuitée est requise pour la stérilisation par laparoscopie."
	label define s3_58_9 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_58_9 s3_58_9

	label variable s3_58_10 "J. La procédure de stérilisation doit être différée chez les femmes ayant une Hb"
	note s3_58_10: "J. La procédure de stérilisation doit être différée chez les femmes ayant une Hb > 7 g/dl."
	label define s3_58_10 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_58_10 s3_58_10

	label variable s3_58_11 "K. La procédure de stérilisation doit être différée chez une femme qui est entre"
	note s3_58_11: "K. La procédure de stérilisation doit être différée chez une femme qui est entre 8 et 42 de post-partum."
	label define s3_58_11 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_58_11 s3_58_11

	label variable s3_58_12 "L. La procédure de stérilisation ne doit pas être différée chez une femme ayant "
	note s3_58_12: "L. La procédure de stérilisation ne doit pas être différée chez une femme ayant eu une grossesse avec une éclampsie ou une pré-éclampsie sévère."
	label define s3_58_12 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_58_12 s3_58_12

	label variable s3_58_13 "M. La procédure de stérilisation ne doit pas être différée chez une femme attein"
	note s3_58_13: "M. La procédure de stérilisation ne doit pas être différée chez une femme atteinte d'une maladie trophoblastique hamaligne."
	label define s3_58_13 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_58_13 s3_58_13

	label variable s3_58_14 "N. La procédure de stérilisation ne doit pas être différée chez une femme présen"
	note s3_58_14: "N. La procédure de stérilisation ne doit pas être différée chez une femme présentant actuellement une cervicite purulente, une chlamydia ou une gonorrhée."
	label define s3_58_14 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_58_14 s3_58_14

	label variable s3_58_15 "O. La procédure de stérilisation doit être abandonnée chez une femme souffrant a"
	note s3_58_15: "O. La procédure de stérilisation doit être abandonnée chez une femme souffrant actuellement d'une maladie de la vésicule biliaire."
	label define s3_58_15 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_58_15 s3_58_15

	label variable s3_58_16 "P. L'approche sous-ombilicale est appropriée dans la stérilisation post-partum."
	note s3_58_16: "P. L'approche sous-ombilicale est appropriée dans la stérilisation post-partum."
	label define s3_58_16 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_58_16 s3_58_16

	label variable s3_58_17 "Q. L'identification de la trompe lors d'une intervention par mini-tour doit être"
	note s3_58_17: "Q. L'identification de la trompe lors d'une intervention par mini-tour doit être effectuée avec une pince babcock."
	label define s3_58_17 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_58_17 s3_58_17

	label variable s3_58_18 "R. Il existe un risque de blessure d'une vessie pleine pendant l'intervention."
	note s3_58_18: "R. Il existe un risque de blessure d'une vessie pleine pendant l'intervention."
	label define s3_58_18 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_58_18 s3_58_18

	label variable s3_58a "s358a. Scénario : Soukey, une femme de 40 ans, exprime son intérêt pour la contr"
	note s3_58a: "s358a. Scénario : Soukey, une femme de 40 ans, exprime son intérêt pour la contraception permanente. Question : Quelles informations l’infirmiére doit-elle fournir à Lisa sur la stérilisation ?"

	label variable s3_60 "360. Quelles informations sociodémographiques/liées à la fécondité recueillez -v"
	note s3_60: "360. Quelles informations sociodémographiques/liées à la fécondité recueillez -vous auprès des nouveaux clients qui visitent la structure sanitaire pour une stérilisation masculine ?"

	label variable s3_60a "360a. Préciser autre information collectée auprès des clients."
	note s3_60a: "360a. Préciser autre information collectée auprès des clients."

	label variable s3_61 "361. Lorsqu'un nouvelle cliente se présente pour une stérilisation masculine, qu"
	note s3_61: "361. Lorsqu'un nouvelle cliente se présente pour une stérilisation masculine, quels sont les antécédents reproductifs que vous recueillez auprès de lui ?"

	label variable s3_61a "361a. Préciser autre antécédent reproductif recueilli auprès des clients."
	note s3_61a: "361a. Préciser autre antécédent reproductif recueilli auprès des clients."

	label variable s3_62 "362. Quels sont les antécédents médicaux que vous recueillez auprès des nouveaux"
	note s3_62: "362. Quels sont les antécédents médicaux que vous recueillez auprès des nouveaux clients qui se rendent à l'établissement pour une stérilisation masculine ?"

	label variable s3_62a "362a. Préciser autre antécédent médical recueilli auprès des clients pour une st"
	note s3_62a: "362a. Préciser autre antécédent médical recueilli auprès des clients pour une stérilisation."

	label variable s3_63 "363. Quels sont les examens cliniques que vous effectuez avant une procédure de "
	note s3_63: "363. Quels sont les examens cliniques que vous effectuez avant une procédure de stérilisation masculine ?"

	label variable s3_63a "363a. Préciser autre examen clinique effectué par les clients pour une stérilisa"
	note s3_63a: "363a. Préciser autre examen clinique effectué par les clients pour une stérilisation."

	label variable s3_64 "364. Quelles sont les informations à partager avec le client avant de procéder à"
	note s3_64: "364. Quelles sont les informations à partager avec le client avant de procéder à une stérilisation masculine ?"

	label variable s3_64a "364a. Préciser autre information à partager avec les clients pour une stérilisat"
	note s3_64a: "364a. Préciser autre information à partager avec les clients pour une stérilisation."

	label variable s3_65 "365. Quels examens de laboratoire prescrivez-vous au client avant la procédure d"
	note s3_65: "365. Quels examens de laboratoire prescrivez-vous au client avant la procédure de stérilisation masculine ?"
	label define s3_65 1 "Analyse d'urine pour le sucre et l'albumine" 96 "Autres (préciser)" 9 "Ne prescrivez rien"
	label values s3_65 s3_65

	label variable s3_66 "366. Combien de temps gardez-vous le client dans l'établissement après l'opérati"
	note s3_66: "366. Combien de temps gardez-vous le client dans l'établissement après l'opération ?"
	label define s3_66 1 "Moins de 30 minutes" 2 "30 - 45 minutes" 3 "45 min à 1h" 4 "Plus d'1 heure" 9 "Je ne sais pas"
	label values s3_66 s3_66

	label variable s3_67 "367. Quels sont les examens que vous effectuez avant de laisser sortir le client"
	note s3_67: "367. Quels sont les examens que vous effectuez avant de laisser sortir le client de la stérilisation masculine ?"

	label variable s3_67a "367a. Préciser autre examen à faire avant de libérer le client."
	note s3_67a: "367a. Préciser autre examen à faire avant de libérer le client."

	label variable s3_68 "368. Quelles instructions donnez-vous aux clients avant leur sortie ?"
	note s3_68: "368. Quelles instructions donnez-vous aux clients avant leur sortie ?"

	label variable s3_68a "368a. Préciser autre instruction à donner avant de libérer le client."
	note s3_68a: "368a. Préciser autre instruction à donner avant de libérer le client."

	label variable s3_69 "369. Informez-vous les clients des complications postopératoires de la stérilisa"
	note s3_69: "369. Informez-vous les clients des complications postopératoires de la stérilisation masculine ?"
	label define s3_69 1 "Oui" 2 "Non"
	label values s3_69 s3_69

	label variable s3_70 "370. Quelles sont les complications possibles dont vous les informez ?"
	note s3_70: "370. Quelles sont les complications possibles dont vous les informez ?"

	label variable s3_70a "370a. Préciser autre complication informé aux clients."
	note s3_70a: "370a. Préciser autre complication informé aux clients."

	label variable s3_71 "371. Quels sont les problèmes de santé auxquels le client peut être confronté pe"
	note s3_71: "371. Quels sont les problèmes de santé auxquels le client peut être confronté pendant/après la procédure de stérilisation masculine ?"

	label variable s3_71a "371a. Préciser autre problème de santé confronté par le client avant/après la st"
	note s3_71a: "371a. Préciser autre problème de santé confronté par le client avant/après la stérilisation."

	label variable s3_72 "372. Selon vous, cette méthode de stérilisation masculine protège-t-elle du VIH "
	note s3_72: "372. Selon vous, cette méthode de stérilisation masculine protège-t-elle du VIH et des IST ?"
	label define s3_72 1 "Oui" 2 "Non" 8 "Ne sait pas"
	label values s3_72 s3_72

	label variable s3_73 "373. Quel est le mécanisme de suivi dont vous disposez ou dont l'établissement d"
	note s3_73: "373. Quel est le mécanisme de suivi dont vous disposez ou dont l'établissement dispose, c'est-à-dire comment veillez-vous ou comment l'établissement veille-t-il à ce que les personnes ayant subi une stérilisation masculine bénéficient des services de suivi à la date prévue ?"

	label variable s3_73a "373a. Préciser autre mécanisme de suivi de l'établissement pour le respect des d"
	note s3_73a: "373a. Préciser autre mécanisme de suivi de l'établissement pour le respect des délais."

	label variable s3_74_1 "A. Si le client présente un IST, la stérilisation masculine de ce client peut êt"
	note s3_74_1: "A. Si le client présente un IST, la stérilisation masculine de ce client peut être effectuée immédiatement."
	label define s3_74_1 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_74_1 s3_74_1

	label variable s3_74_2 "B. Le dépistage du VIH est obligatoire avant de procéder à la stérilisation masc"
	note s3_74_2: "B. Le dépistage du VIH est obligatoire avant de procéder à la stérilisation masculine."
	label define s3_74_2 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_74_2 s3_74_2

	label variable s3_74_3 "C. La présence d'anesthésistes est nécessaire pour la procédure de stérilisation"
	note s3_74_3: "C. La présence d'anesthésistes est nécessaire pour la procédure de stérilisation masculine."
	label define s3_74_3 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_74_3 s3_74_3

	label variable s3_74_4 "D. La présence d'un membre de la famille avec les hommes est nécessaire pour la "
	note s3_74_4: "D. La présence d'un membre de la famille avec les hommes est nécessaire pour la stérilisation masculine."
	label define s3_74_4 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_74_4 s3_74_4

	label variable s3_74_5 "E. Le consentement de l'épouse est obligatoire pour qu'un homme puisse subir une"
	note s3_74_5: "E. Le consentement de l'épouse est obligatoire pour qu'un homme puisse subir une stérilisation masculine."
	label define s3_74_5 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_74_5 s3_74_5

	label variable s3_74_6 "F. Une nuitée est requise pour la stérilisation masculine."
	note s3_74_6: "F. Une nuitée est requise pour la stérilisation masculine."
	label define s3_74_6 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_74_6 s3_74_6

	label variable s3_74_7 "G. La stérilisation masculine n'est considérée comme réussie qu'après que l'anal"
	note s3_74_7: "G. La stérilisation masculine n'est considérée comme réussie qu'après que l'analyse du sperme montre un nombre nul de spermatozoïdes."
	label define s3_74_7 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_74_7 s3_74_7

	label variable s3_74_8 "H. Le préservatif doit être utilisé pour chaque acte sexuel pendant trois à six "
	note s3_74_8: "H. Le préservatif doit être utilisé pour chaque acte sexuel pendant trois à six mois après la stérilisation masculine."
	label define s3_74_8 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s3_74_8 s3_74_8

	label variable s4_1_1 "A. Les services de planification familiale doivent être accessibles à tous, quel"
	note s4_1_1: "A. Les services de planification familiale doivent être accessibles à tous, quel que soit leur statut socio-économique."
	label define s4_1_1 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_1_1 s4_1_1

	label variable s4_1_2 "B. La planification familiale est une composante essentielle des soins de santé "
	note s4_1_2: "B. La planification familiale est une composante essentielle des soins de santé complets."
	label define s4_1_2 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_1_2 s4_1_2

	label variable s4_1_3 "C. La planification familiale contribue à améliorer les résultats en matière de "
	note s4_1_3: "C. La planification familiale contribue à améliorer les résultats en matière de santé maternelle et infantile."
	label define s4_1_3 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_1_3 s4_1_3

	label variable s4_1_4 "D. Les services de planification familiale devraient inclure des conseils sur un"
	note s4_1_4: "D. Les services de planification familiale devraient inclure des conseils sur un large éventail de méthodes contraceptives."
	label define s4_1_4 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_1_4 s4_1_4

	label variable s4_1_5 "E. La promotion de la planification familiale peut contribuer à réduire la pauvr"
	note s4_1_5: "E. La promotion de la planification familiale peut contribuer à réduire la pauvreté et à promouvoir le développement économique."
	label define s4_1_5 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_1_5 s4_1_5

	label variable s4_1_6 "F. Les services complets de planification familiale devraient inclure une éducat"
	note s4_1_6: "F. Les services complets de planification familiale devraient inclure une éducation et des conseils sur la santé reproductive et le bien-être sexuel."
	label define s4_1_6 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_1_6 s4_1_6

	label variable s4_1_7 "G. L' amélioration de l'accès à un large éventail d'options contraceptives peut "
	note s4_1_7: "G. L' amélioration de l'accès à un large éventail d'options contraceptives peut aider les individus et les couples à faire des choix éclairés concernant leur avenir reproductif."
	label define s4_1_7 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_1_7 s4_1_7

	label variable s4_1_8 "H. Il est important que les prestataires de soins de santé encouragent une commu"
	note s4_1_8: "H. Il est important que les prestataires de soins de santé encouragent une communication ouverte entre les partenaires concernant les décisions en matière de planification familiale."
	label define s4_1_8 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_1_8 s4_1_8

	label variable s4_1_9 "I. Les partenaires masculins devraient également être informés de leur rôle dans"
	note s4_1_9: "I. Les partenaires masculins devraient également être informés de leur rôle dans la prise de décision en matière de planification familiale."
	label define s4_1_9 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_1_9 s4_1_9

	label variable s4_1_10 "J. Les services de planification familiale doivent être inclusifs et accessibles"
	note s4_1_10: "J. Les services de planification familiale doivent être inclusifs et accessibles à tous, quel que soit leur état civil."
	label define s4_1_10 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_1_10 s4_1_10

	label variable s4_1_11 "K. Il est important de discuter du retour à la fertilité chez les femmes en post"
	note s4_1_11: "K. Il est important de discuter du retour à la fertilité chez les femmes en post-partum."
	label define s4_1_11 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_1_11 s4_1_11

	label variable s4_1_12 "L. Il est important de discuter du retour à la fertilité chez les femmes après u"
	note s4_1_12: "L. Il est important de discuter du retour à la fertilité chez les femmes après un avortement."
	label define s4_1_12 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_1_12 s4_1_12

	label variable s4_3_1 "A. Les dispositifs intra-utérins (DIU) devraient être accessibles à toutes les f"
	note s4_3_1: "A. Les dispositifs intra-utérins (DIU) devraient être accessibles à toutes les femmes qui souhaitent une contraception à long terme, quel que soit leur âge."
	label define s4_3_1 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_3_1 s4_3_1

	label variable s4_3_2 "B. Des DIU peuvent être fournis aux femmes célibataires"
	note s4_3_2: "B. Des DIU peuvent être fournis aux femmes célibataires"
	label define s4_3_2 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_3_2 s4_3_2

	label variable s4_3_3 "C. Des DIU peuvent être fournis aux femmes qui ont reconstitué leur famille"
	note s4_3_3: "C. Des DIU peuvent être fournis aux femmes qui ont reconstitué leur famille"
	label define s4_3_3 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_3_3 s4_3_3

	label variable s4_3_4 "D. Des DIU peuvent être fournis aux femmes nullipares"
	note s4_3_4: "D. Des DIU peuvent être fournis aux femmes nullipares"
	label define s4_3_4 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_3_4 s4_3_4

	label variable s4_3_5 "E. Le DIU a un impact négatif sur la fertilité future"
	note s4_3_5: "E. Le DIU a un impact négatif sur la fertilité future"
	label define s4_3_5 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_3_5 s4_3_5

	label variable s4_3_6 "F. Les femmes présentant des effets secondaires/des changements menstruels liés "
	note s4_3_6: "F. Les femmes présentant des effets secondaires/des changements menstruels liés à l'utilisation du DIU devraient passer À à une autre méthode."
	label define s4_3_6 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_3_6 s4_3_6

	label variable s4_3_7 "G. Le consentement du conjoint est obligatoire avant la fourniture de cette méth"
	note s4_3_7: "G. Le consentement du conjoint est obligatoire avant la fourniture de cette méthode."
	label define s4_3_7 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_3_7 s4_3_7

	label variable s4_3_8 "H. Les prestataires de soins de santé doivent aborder les idées fausses et les p"
	note s4_3_8: "H. Les prestataires de soins de santé doivent aborder les idées fausses et les préoccupations courantes concernant les dispositifs intra-utérins (DIU) lors des séances de conseil."
	label define s4_3_8 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_3_8 s4_3_8

	label variable s4_3_9 "I. Les dispositifs intra-utérins (DIU) devraient être promus comme option contra"
	note s4_3_9: "I. Les dispositifs intra-utérins (DIU) devraient être promus comme option contraceptive de première intention pour les personnes recherchant une contraception à long terme très efficace."
	label define s4_3_9 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_3_9 s4_3_9

	label variable s4_3_10 "J. Le prestataire est la personne la mieux placée pour décider de la méthode que"
	note s4_3_10: "J. Le prestataire est la personne la mieux placée pour décider de la méthode que le client doit utiliser."
	label define s4_3_10 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_3_10 s4_3_10

	label variable s4_3_11 "K. Une femme qui est certaine de vouloir un espacement prolongé entre les enfant"
	note s4_3_11: "K. Une femme qui est certaine de vouloir un espacement prolongé entre les enfants est une bonne candidate pour le DIU."
	label define s4_3_11 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_3_11 s4_3_11

	label variable s4_5_1 "A. Les contraceptifs injectables devraient être accessibles à toutes les femmes "
	note s4_5_1: "A. Les contraceptifs injectables devraient être accessibles à toutes les femmes qui souhaitent une contraception à long terme, quel que soit leur âge."
	label define s4_5_1 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_5_1 s4_5_1

	label variable s4_5_2 "B. Les contraceptifs injectables peuvent être fourni aux femmes célibataires."
	note s4_5_2: "B. Les contraceptifs injectables peuvent être fourni aux femmes célibataires."
	label define s4_5_2 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_5_2 s4_5_2

	label variable s4_5_3 "C. Les contraceptifs injectables doivent être offert aux femmes qui ont reconsti"
	note s4_5_3: "C. Les contraceptifs injectables doivent être offert aux femmes qui ont reconstitué leur famille."
	label define s4_5_3 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_5_3 s4_5_3

	label variable s4_5_4 "D. Les contraceptifs injectables doivent être proposé aux femmes nullipares."
	note s4_5_4: "D. Les contraceptifs injectables doivent être proposé aux femmes nullipares."
	label define s4_5_4 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_5_4 s4_5_4

	label variable s4_5_5 "E. Les injectables ont un impact négatif sur la fertilité future."
	note s4_5_5: "E. Les injectables ont un impact négatif sur la fertilité future."
	label define s4_5_5 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_5_5 s4_5_5

	label variable s4_5_6 "F. Les femmes ayant des changements menstruels suite à l’utilisation de produits"
	note s4_5_6: "F. Les femmes ayant des changements menstruels suite à l’utilisation de produits injectables devraient passer à une autre méthode."
	label define s4_5_6 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_5_6 s4_5_6

	label variable s4_5_7 "G. Le consentement du conjoint est obligatoire avant la fourniture de cette méth"
	note s4_5_7: "G. Le consentement du conjoint est obligatoire avant la fourniture de cette méthode."
	label define s4_5_7 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_5_7 s4_5_7

	label variable s4_5_8 "H. Les prestataires de soins de santé doivent aborder les idées fausses et les p"
	note s4_5_8: "H. Les prestataires de soins de santé doivent aborder les idées fausses et les préoccupations courantes concernant les contraceptifs injectables lors des séances de conseil."
	label define s4_5_8 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_5_8 s4_5_8

	label variable s4_5_9 "I. Les contraceptifs injectables doivent être encouragés comme option contracept"
	note s4_5_9: "I. Les contraceptifs injectables doivent être encouragés comme option contraceptive de première intention pour les personnes recherchant une contraception à long terme très efficace."
	label define s4_5_9 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_5_9 s4_5_9

	label variable s4_5_10 "J. Fournir une formation et une éducation aux patients sur les techniques d'auto"
	note s4_5_10: "J. Fournir une formation et une éducation aux patients sur les techniques d'auto-administration des contraceptifs injectables, telles que les sites et les horaires d'injection appropriés"
	label define s4_5_10 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_5_10 s4_5_10

	label variable s4_7_1 "A. Les implants devraient être accessibles à toutes les femmes qui souhaitent un"
	note s4_7_1: "A. Les implants devraient être accessibles à toutes les femmes qui souhaitent une contraception à long terme, quel que soit leur âge."
	label define s4_7_1 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_7_1 s4_7_1

	label variable s4_7_2 "B. Des implants peuvent être fournis aux femmes célibataires."
	note s4_7_2: "B. Des implants peuvent être fournis aux femmes célibataires."
	label define s4_7_2 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_7_2 s4_7_2

	label variable s4_7_3 "C. Des implants peuvent être fournis aux femmes qui ont reconstitué leur famille"
	note s4_7_3: "C. Des implants peuvent être fournis aux femmes qui ont reconstitué leur famille."
	label define s4_7_3 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_7_3 s4_7_3

	label variable s4_7_4 "D. Des implants peuvent être fournis aux femmes nullipares."
	note s4_7_4: "D. Des implants peuvent être fournis aux femmes nullipares."
	label define s4_7_4 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_7_4 s4_7_4

	label variable s4_7_5 "E. Les implants ont un impact négatif sur la fertilité future."
	note s4_7_5: "E. Les implants ont un impact négatif sur la fertilité future."
	label define s4_7_5 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_7_5 s4_7_5

	label variable s4_7_6 "F. Les femmes ayant des changements menstruels suite à l'utilisation d'implants "
	note s4_7_6: "F. Les femmes ayant des changements menstruels suite à l'utilisation d'implants devraient passer à une autre méthode."
	label define s4_7_6 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_7_6 s4_7_6

	label variable s4_7_7 "G. Le consentement du conjoint est obligatoire avant la fourniture de cette méth"
	note s4_7_7: "G. Le consentement du conjoint est obligatoire avant la fourniture de cette méthode"
	label define s4_7_7 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_7_7 s4_7_7

	label variable s4_7_8 "H. Les prestataires de soins de santé doivent aborder les idées fausses et les p"
	note s4_7_8: "H. Les prestataires de soins de santé doivent aborder les idées fausses et les préoccupations courantes concernant les implants lors des séances de conseil."
	label define s4_7_8 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_7_8 s4_7_8

	label variable s4_7_9 "I. Les implants doivent être encouragés comme option contraceptive de première i"
	note s4_7_9: "I. Les implants doivent être encouragés comme option contraceptive de première intention pour les personnes recherchant une contraception à long terme très efficace."
	label define s4_7_9 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_7_9 s4_7_9

	label variable s4_7_10 "J. Fournir une formation et une éducation aux patients sur les techniques d'auto"
	note s4_7_10: "J. Fournir une formation et une éducation aux patients sur les techniques d'autogestion des implants contraceptifs, telles que la vérification de la présence de l'implant"
	label define s4_7_10 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_7_10 s4_7_10

	label variable s4_9_1 "A. La pilule peut-elle être fournie aux femmes célibataires ?"
	note s4_9_1: "A. La pilule peut-elle être fournie aux femmes célibataires ?"
	label define s4_9_1 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_9_1 s4_9_1

	label variable s4_9_2 "B. La pilule peut-elle être fournie aux femmes qui ont reconstitué leur famille "
	note s4_9_2: "B. La pilule peut-elle être fournie aux femmes qui ont reconstitué leur famille ?"
	label define s4_9_2 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_9_2 s4_9_2

	label variable s4_9_3 "C. La pilule peut-elle être fournie aux femmes nullipares ?"
	note s4_9_3: "C. La pilule peut-elle être fournie aux femmes nullipares ?"
	label define s4_9_3 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_9_3 s4_9_3

	label variable s4_9_4 "D. Le consentement du conjoint est-il obligatoire avant la mise à disposition de"
	note s4_9_4: "D. Le consentement du conjoint est-il obligatoire avant la mise à disposition de cette méthode ?"
	label define s4_9_4 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_9_4 s4_9_4

	label variable s4_9_5 "E. La pilule devrait-elle être facilement accessible aux individus comme moyen d"
	note s4_9_5: "E. La pilule devrait-elle être facilement accessible aux individus comme moyen de prévenir les grossesses non désirées ?"
	label define s4_9_5 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_9_5 s4_9_5

	label variable s4_9_6 "F. Il est important de fournir des conseils sur l'utilisation correcte et les ef"
	note s4_9_6: "F. Il est important de fournir des conseils sur l'utilisation correcte et les effets secondaires potentiels de la pilule."
	label define s4_9_6 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_9_6 s4_9_6

	label variable s4_9a "409a. Scénario : Une femme de 30 ans nommée Maria se voit prescrire des pilules "
	note s4_9a: "409a. Scénario : Une femme de 30 ans nommée Maria se voit prescrire des pilules contraceptives à des fins de contraception. Elle se soucie d'oublier de les prendre quotidiennement. Question : Comment l'infirmière devrait-elle répondre aux inquiétudes de Maria concernant le fait de ne pas oublier de prendre ses pilules contraceptives ?"

	label variable s4_11_1 "A. La CU peut être fournie aux femmes célibataires."
	note s4_11_1: "A. La CU peut être fournie aux femmes célibataires."
	label define s4_11_1 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_11_1 s4_11_1

	label variable s4_11_2 "B. La CU peut être fournie aux femmes nullipares."
	note s4_11_2: "B. La CU peut être fournie aux femmes nullipares."
	label define s4_11_2 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_11_2 s4_11_2

	label variable s4_11_3 "C. Le consentement du conjoint est obligatoire avant la fourniture de la CU."
	note s4_11_3: "C. Le consentement du conjoint est obligatoire avant la fourniture de la CU."
	label define s4_11_3 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_11_3 s4_11_3

	label variable s4_11_4 "D. L'utilisation répétée de la CU, en particulier chez les adolescents, favorise"
	note s4_11_4: "D. L'utilisation répétée de la CU, en particulier chez les adolescents, favorisera la promiscuité."
	label define s4_11_4 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_11_4 s4_11_4

	label variable s4_11_5 "E. La CU devrait être facilement accessible aux individus comme moyen de préveni"
	note s4_11_5: "E. La CU devrait être facilement accessible aux individus comme moyen de prévenir les grossesses non désirées."
	label define s4_11_5 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_11_5 s4_11_5

	label variable s4_11_6 "F. Il est important de fournir des conseils sur l'utilisation correcte et les ef"
	note s4_11_6: "F. Il est important de fournir des conseils sur l'utilisation correcte et les effets secondaires potentiels de la CU."
	label define s4_11_6 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_11_6 s4_11_6

	label variable s4_11a "411a. Scénario : Emily, une étudiante de 19 ans, se présente à la clinique pour "
	note s4_11a: "411a. Scénario : Emily, une étudiante de 19 ans, se présente à la clinique pour demander une contraception d'urgence après qu'un préservatif s'est brisé lors d'un rapport sexuel avec son partenaire. Question : Quelles informations l'infirmière doit-elle fournir à Emily lors de la consultation de contraception d'urgence ?"

	label variable s4_13_1 "A. Un préservatif peut être fourni aux femmes célibataires."
	note s4_13_1: "A. Un préservatif peut être fourni aux femmes célibataires."
	label define s4_13_1 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_13_1 s4_13_1

	label variable s4_13_2 "B. Un préservatif peut être fourni aux femmes nullipares."
	note s4_13_2: "B. Un préservatif peut être fourni aux femmes nullipares."
	label define s4_13_2 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_13_2 s4_13_2

	label variable s4_13_3 "C. La mise à disposition du préservatif pour les adolescents favorisera la promi"
	note s4_13_3: "C. La mise à disposition du préservatif pour les adolescents favorisera la promiscuité."
	label define s4_13_3 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_13_3 s4_13_3

	label variable s4_13_4 "D. Les préservatifs sont le meilleur contraceptif pour les adolescents."
	note s4_13_4: "D. Les préservatifs sont le meilleur contraceptif pour les adolescents."
	label define s4_13_4 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_13_4 s4_13_4

	label variable s4_13_5 "E. Les préservatifs devraient être promus comme méthode à double usage pour prév"
	note s4_13_5: "E. Les préservatifs devraient être promus comme méthode à double usage pour prévenir à la fois les grossesses non désirées et les infections sexuellement transmissibles (IST)."
	label define s4_13_5 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_13_5 s4_13_5

	label variable s4_13a "413a. Scénario : Ndeye, une femme de 22 ans, souhaite en savoir plus sur les mét"
	note s4_13a: "413a. Scénario : Ndeye, une femme de 22 ans, souhaite en savoir plus sur les méthodes de contraception barrière. Question : Quelle méthode l’infirmière peut-elle recommander à Ndeye comme méthode de contraception barrière ?"
	label define s4_13a 1 "Pilules contraceptives" 2 "Préservatifs" 3 "Dispositifs intra-utérins (DIU)" 4 "Contraceptifs injectables"
	label values s4_13a s4_13a

	label variable s4_15_1 "A. Les prestataires de soins de santé doivent garantir un consentement éclairé e"
	note s4_15_1: "A. Les prestataires de soins de santé doivent garantir un consentement éclairé et fournir des conseils complets avant de procéder à des procédures de stérilisation féminine."
	label define s4_15_1 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_15_1 s4_15_1

	label variable s4_15_2 "B. Le consentement du conjoint est obligatoire avant de procéder à la stérilisat"
	note s4_15_2: "B. Le consentement du conjoint est obligatoire avant de procéder à la stérilisation féminine"
	label define s4_15_2 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_15_2 s4_15_2

	label variable s4_15_3 "C. Les services de stérilisation féminine devraient être proposés aux femmes qui"
	note s4_15_3: "C. Les services de stérilisation féminine devraient être proposés aux femmes qui ont atteint la taille de famille souhaitée ou qui ne souhaitent pas avoir d'enfants."
	label define s4_15_3 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_15_3 s4_15_3

	label variable s4_15_4 "D. Les services de stérilisation féminine devraient être proposés aux femmes qui"
	note s4_15_4: "D. Les services de stérilisation féminine devraient être proposés aux femmes qui ont atteint la taille de famille souhaitée dans la période post-partum immédiate."
	label define s4_15_4 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_15_4 s4_15_4

	label variable s4_15_5 "E. Les services de stérilisation féminine doivent être déterminés en fonction du"
	note s4_15_5: "E. Les services de stérilisation féminine doivent être déterminés en fonction du sexe des enfants vivants."
	label define s4_15_5 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_15_5 s4_15_5

	label variable s4_15_6 "F. La stérilisation féminine ne devrait pas être proposée aux femmes n'ayant qu'"
	note s4_15_6: "F. La stérilisation féminine ne devrait pas être proposée aux femmes n'ayant qu'un seul enfant."
	label define s4_15_6 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_15_6 s4_15_6

	label variable s4_15_7 "G. La stérilisation féminine ne devrait pas être proposée aux jeunes femmes qui "
	note s4_15_7: "G. La stérilisation féminine ne devrait pas être proposée aux jeunes femmes qui n’ont pas de fils."
	label define s4_15_7 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_15_7 s4_15_7

	label variable s4_15_8 "H. Il est de la responsabilité des femmes d'adopter une méthode de planification"
	note s4_15_8: "H. Il est de la responsabilité des femmes d'adopter une méthode de planification familiale."
	label define s4_15_8 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_15_8 s4_15_8

	label variable s4_15_9 "I. Le prestataire est la personne la mieux placée pour décider si une cliente do"
	note s4_15_9: "I. Le prestataire est la personne la mieux placée pour décider si une cliente doit subir une stérilisation féminine."
	label define s4_15_9 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_15_9 s4_15_9

	label variable s4_17_1 "A. La vasectomie sans scalpel (VNS) devrait-elle être promue comme option contra"
	note s4_17_1: "A. La vasectomie sans scalpel (VNS) devrait-elle être promue comme option contraceptive de première intention pour les personnes recherchant une contraception à long terme ?"
	label define s4_17_1 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_17_1 s4_17_1

	label variable s4_17_2 "B. Les hommes s'affaiblissent après la vasectomie"
	note s4_17_2: "B. Les hommes s'affaiblissent après la vasectomie"
	label define s4_17_2 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_17_2 s4_17_2

	label variable s4_17_3 "C. La vasectomie provoque l'impuissance chez les hommes"
	note s4_17_3: "C. La vasectomie provoque l'impuissance chez les hommes"
	label define s4_17_3 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_17_3 s4_17_3

	label variable s4_17_4 "D. Les hommes ne devraient pas subir de vasectomie car la planification familial"
	note s4_17_4: "D. Les hommes ne devraient pas subir de vasectomie car la planification familiale relève uniquement de la responsabilité des femmes."
	label define s4_17_4 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_17_4 s4_17_4

	label variable s4_17_5 "E. Les informations personnelles d'une personne subissant une stérilisation doiv"
	note s4_17_5: "E. Les informations personnelles d'une personne subissant une stérilisation doivent rester confidentielles."
	label define s4_17_5 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_17_5 s4_17_5

	label variable s5_1 "501. Quels sont les signes de danger pour lesquels une femme enceinte doit être "
	note s5_1: "501. Quels sont les signes de danger pour lesquels une femme enceinte doit être évaluée à son arrivée pour l'accouchement ?"

	label variable s5_1a "501a. Préciser autre signe de danger à évaluer chez la femme enceinte à son arri"
	note s5_1a: "501a. Préciser autre signe de danger à évaluer chez la femme enceinte à son arrivée pour l'accouchement"

	label variable s5_2 "502. En quoi consiste une évaluation initiale rapide ?"
	note s5_2: "502. En quoi consiste une évaluation initiale rapide ?"

	label variable s5_2a "502a. Préciser autre évaluation initiale rapide"
	note s5_2a: "502a. Préciser autre évaluation initiale rapide"

	label variable s5_3 "503. L'échographie du troisième trimestre est la meilleure pour calculer l'âge g"
	note s5_3: "503. L'échographie du troisième trimestre est la meilleure pour calculer l'âge gestationnel. Cette déclaration est vraie ou fausse?"
	label define s5_3 1 "Vrai" 2 "Faux" 8 "Je ne sais pas"
	label values s5_3 s5_3

	label variable s5_4 "504. Quel est le traitement de l’anémie maternelle très sévère (Hb < 7,0 g/dl) ?"
	note s5_4: "504. Quel est le traitement de l’anémie maternelle très sévère (Hb < 7,0 g/dl) ?"
	label define s5_4 1 "Transfusion sanguine" 96 "Autre [préciser]" 8 "Je ne sais pas"
	label values s5_4 s5_4

	label variable s5_4a "504a. Préciser autre traitement contre l'anémie"
	note s5_4a: "504a. Préciser autre traitement contre l'anémie"

	label variable s5_5 "505. Quelle est la dose appropriée pour l’administration de fer-saccharose S?"
	note s5_5: "505. Quelle est la dose appropriée pour l’administration de fer-saccharose S?"
	label define s5_5 1 "Une dose de 200 mg dans 100 ml de solution saline normale tous les deux jours" 96 "Autre [préciser]" 8 "Je ne sais pas"
	label values s5_5 s5_5

	label variable s5_5a "505a. Préciser autre dose appropriée"
	note s5_5a: "505a. Préciser autre dose appropriée"

	label variable s5_6 "506. Quelle est la voie d’administration du fer saccharose ?"
	note s5_6: "506. Quelle est la voie d’administration du fer saccharose ?"
	label define s5_6 1 "Perfusion Intraveineuse" 2 "Voie orale" 96 "Autre [préciser]" 8 "Je ne sais pas"
	label values s5_6 s5_6

	label variable s5_6a "506a. Préciser autre voie d'administration"
	note s5_6a: "506a. Préciser autre voie d'administration"

	label variable s5_7 "507. Le fer oral doit être interrompu au cours de l'administration de fer saccha"
	note s5_7: "507. Le fer oral doit être interrompu au cours de l'administration de fer saccharose. Cette déclaration est-elle vraie ou fausse?"
	label define s5_7 1 "Vrai" 2 "Faux" 8 "Je ne sais pas"
	label values s5_7 s5_7

	label variable s5_8 "508. Quelle est la dose maximale de fer saccharose pouvant être administrée à un"
	note s5_8: "508. Quelle est la dose maximale de fer saccharose pouvant être administrée à une femme anémique en doses fractionnées ?"
	label define s5_8 1 "1000 mg" 2 "2000 mg" 96 "Autre [préciser]" 8 "Je ne sais pas"
	label values s5_8 s5_8

	label variable s5_8a "508a. Préciser autre dose maximale administrée"
	note s5_8a: "508a. Préciser autre dose maximale administrée"

	label variable s5_9 "509. Le fer saccharose nécessite une dose test pour vérifier l’allergie.Cette dé"
	note s5_9: "509. Le fer saccharose nécessite une dose test pour vérifier l’allergie.Cette déclaration est-elle vraie ou fausse?"
	label define s5_9 1 "Vrai" 2 "Faux" 8 "Je ne sais pas"
	label values s5_9 s5_9

	label variable s5_10 "510. Le fer saccharose peut être administré à la femme enceinte (Hb jusqu'à 9 g "
	note s5_10: "510. Le fer saccharose peut être administré à la femme enceinte (Hb jusqu'à 9 g %) après 32 semaines de grossesse. Cette déclaration est-elle vraie ou fausse?"
	label define s5_10 1 "Vrai" 2 "Faux" 8 "Je ne sais pas"
	label values s5_10 s5_10

	label variable s5_11 "511. La transfusion sanguine est meilleure que la transfusion d’hématocytes en c"
	note s5_11: "511. La transfusion sanguine est meilleure que la transfusion d’hématocytes en cas d’anémie très sévère. Cette déclaration est-elle vraie ou fausse?"
	label define s5_11 1 "Vrai" 2 "Faux" 8 "Je ne sais pas"
	label values s5_11 s5_11

	label variable s5_12 "512. Le fer saccharose peut être prescrit aux femmes postnatales souffrant d'ané"
	note s5_12: "512. Le fer saccharose peut être prescrit aux femmes postnatales souffrant d'anémie sévère avant leur sortie. Cette déclaration est-elle vraie ou fausse?"
	label define s5_12 1 "Vrai" 2 "Faux" 8 "Je ne sais pas"
	label values s5_12 s5_12

	label variable s5_13 "513. Nous pouvons attendre 2 heures pour un accouchement normal une fois que le "
	note s5_13: "513. Nous pouvons attendre 2 heures pour un accouchement normal une fois que le partogramme franchit la ligne d'action. Cette déclaration est-elle vraie ou fausse?"
	label define s5_13 1 "Vrai" 2 "Faux" 8 "Je ne sais pas"
	label values s5_13 s5_13

	label variable s5_14 "514. La seule façon de résoudre un cas de travail dystocique est la césarienne. "
	note s5_14: "514. La seule façon de résoudre un cas de travail dystocique est la césarienne. Cette déclaration est-elle vraie ou fausse?"
	label define s5_14 1 "Vrai" 2 "Faux" 8 "Je ne sais pas"
	label values s5_14 s5_14

	label variable s5_15 "515. La disproportion céphalo-pelvienne est synonyme de dystocie. Cette déclarat"
	note s5_15: "515. La disproportion céphalo-pelvienne est synonyme de dystocie. Cette déclaration est-elle vraie ou fausse?"
	label define s5_15 1 "Vrai" 2 "Faux" 8 "Je ne sais pas"
	label values s5_15 s5_15

	label variable s5_16 "516. Quelle est la complication maternelle la plus courante de la dystocie ?"
	note s5_16: "516. Quelle est la complication maternelle la plus courante de la dystocie ?"
	label define s5_16 1 "Utérus rompu" 96 "Autre [préciser]" 8 "Je ne sais pas"
	label values s5_16 s5_16

	label variable s5_16a "5016a. Préciser autre complication maternelle plus courante"
	note s5_16a: "5016a. Préciser autre complication maternelle plus courante"

	label variable s5_17 "517. Un travail prolongé, quelle qu'en soit la raison, peut être délivré par une"
	note s5_17: "517. Un travail prolongé, quelle qu'en soit la raison, peut être délivré par une augmentation avec de l'ocytocine.Cette déclaration est-elle vraie ou fausse?"
	label define s5_17 1 "Vrai" 2 "Faux" 8 "Je ne sais pas"
	label values s5_17 s5_17

	label variable s5_18 "518. Une disproportion céphalo-pelvienne ne peut pas survenir chez les femmes mu"
	note s5_18: "518. Une disproportion céphalo-pelvienne ne peut pas survenir chez les femmes multipares. Cette déclaration est-elle vraie ou fausse?"
	label define s5_18 1 "Vrai" 2 "Faux" 8 "Je ne sais pas"
	label values s5_18 s5_18

	label variable s5_19 "519. Le traitement de l'hypertension gestationnelle ne doit être instauré que lo"
	note s5_19: "519. Le traitement de l'hypertension gestationnelle ne doit être instauré que lorsque la tension artérielle diastolique est de 100 mmHg ou plus ?"
	label define s5_19 1 "Vrai" 2 "Faux" 8 "Je ne sais pas"
	label values s5_19 s5_19

	label variable s5_20 "520. Quel est le traitement de l'hypertension gestationnelle (TA diastolique <11"
	note s5_20: "520. Quel est le traitement de l'hypertension gestationnelle (TA diastolique <110 mmHg) ?"

	label variable s5_20a "520a. Préciser autre traitement"
	note s5_20a: "520a. Préciser autre traitement"

	label variable s5_21 "521. Quelle est la voie appropriée pour administrer Tab. Nifédipine ?"
	note s5_21: "521. Quelle est la voie appropriée pour administrer Tab. Nifédipine ?"
	label define s5_21 1 "Oralement" 96 "Autre [préciser]" 8 "Je ne sais pas"
	label values s5_21 s5_21

	label variable s5_21a "521a. Préciser autre voie appropriée"
	note s5_21a: "521a. Préciser autre voie appropriée"

	label variable s5_23 "523. Quelle est la voie et la dose appropriées pour administrer Labétalol ? (TA "
	note s5_23: "523. Quelle est la voie et la dose appropriées pour administrer Labétalol ? (TA diastolique > 110 mmHg) ?"
	label define s5_23 1 "Bolus IV (dose 20 mg)" 96 "Autre [préciser]" 8 "Je ne sais pas"
	label values s5_23 s5_23

	label variable s5_23a "523a. Préciser autre voie et dose appropriées"
	note s5_23a: "523a. Préciser autre voie et dose appropriées"

	label variable s5_24 "524. Quels sont les signes/symptômes d’une pré-éclampsie sévère ?"
	note s5_24: "524. Quels sont les signes/symptômes d’une pré-éclampsie sévère ?"

	label variable s5_24a "524a. Préciser autre signe ou symptômes"
	note s5_24a: "524a. Préciser autre signe ou symptômes"

	label variable s5_25 "525. Quel est le traitement principal de la pré-éclampsie sévère ?"
	note s5_25: "525. Quel est le traitement principal de la pré-éclampsie sévère ?"
	label define s5_25 1 "Inj Sulfate de Magnésium 50 % p/v 5 g avec 1 ml de Xylocaïne 2 % IM profonde dan" 96 "Autre [préciser]" 8 "Je ne sais pas"
	label values s5_25 s5_25

	label variable s5_25a "525a. Préciser autre traitement principal"
	note s5_25a: "525a. Préciser autre traitement principal"

	label variable s5_26 "526. Une femme enceinte souffrant de pré-éclampsie sévère et dont le fœtus est v"
	note s5_26: "526. Une femme enceinte souffrant de pré-éclampsie sévère et dont le fœtus est vivant entre 24 et 34 semaines doit recevoir des injections. Dexaméthasone 6 mg avant l'accouchement. Cette déclaration est-elle vraie ou fausse?"
	label define s5_26 1 "Vrai" 2 "Faux" 8 "Je ne sais pas"
	label values s5_26 s5_26

	label variable s5_27 "527. Une femme enceinte souffrant de pré-éclampsie sévère doit accoucher dans le"
	note s5_27: "527. Une femme enceinte souffrant de pré-éclampsie sévère doit accoucher dans les 24 heures. Cette déclaration est vraie ou fausse?"
	label define s5_27 1 "Vrai" 2 "Faux" 8 "Je ne sais pas"
	label values s5_27 s5_27

	label variable s5_28 "528. Quels sont les composants (médicaments) de la prise en charge de l'éclampsi"
	note s5_28: "528. Quels sont les composants (médicaments) de la prise en charge de l'éclampsie ?"

	label variable s5_28a "528a. Préciser autre composant de la prise en charge"
	note s5_28a: "528a. Préciser autre composant de la prise en charge"

	label variable s5_29 "529. Quels sont les signes de toxicité du sulfate de magnésium ?"
	note s5_29: "529. Quels sont les signes de toxicité du sulfate de magnésium ?"

	label variable s5_29a "529a. Préciser autre signe de la toxicité"
	note s5_29a: "529a. Préciser autre signe de la toxicité"

	label variable s5_30 "530. inject Antidote. Le gluconate de calcium doit être administré aux cas de pr"
	note s5_30: "530. inject Antidote. Le gluconate de calcium doit être administré aux cas de pré-éclampsie/éclampsie sévère qui sont sous injection. Traitement au sulfate de magnésium lorsque leur fréquence respiratoire devient <16/min. Cette déclaration est vraie ou fausse?"
	label define s5_30 1 "Vrai" 2 "Faux" 8 "Je ne sais pas"
	label values s5_30 s5_30

	label variable s5_31 "531. En cas de toxicité du MgSO4, quelle est la dose appropriée de gluconate de "
	note s5_31: "531. En cas de toxicité du MgSO4, quelle est la dose appropriée de gluconate de calcium injectable ?"
	label define s5_31 1 "Solution à 10 %, 1 g IV lente 10 minutes" 96 "Autre [préciser]" 8 "Je ne sais pas"
	label values s5_31 s5_31

	label variable s5_31a "531a. Préciser autre dose appoprié"
	note s5_31a: "531a. Préciser autre dose appoprié"

	label variable s5_32 "532. Qu'est-ce qu'une dose supplémentaire de MgSO4 ?"
	note s5_32: "532. Qu'est-ce qu'une dose supplémentaire de MgSO4 ?"
	label define s5_32 1 "2 g de MgSO4 à 20 % IV lente si les convulsions réapparaissent dans les 30 minut" 96 "Autre [préciser]" 8 "Je ne sais pas"
	label values s5_32 s5_32

	label variable s5_32a "532a. Préciser autre dose appoprié"
	note s5_32a: "532a. Préciser autre dose appoprié"

	label variable s5_33 "533. Quels sont les signes d’une rupture de l’utérus ?"
	note s5_33: "533. Quels sont les signes d’une rupture de l’utérus ?"

	label variable s5_33a "533a. Préciser autre signe de rupture"
	note s5_33a: "533a. Préciser autre signe de rupture"

	label variable s5_34 "534. Le saignement du placenta praevia est indolore, frais et rouge. Cette décla"
	note s5_34: "534. Le saignement du placenta praevia est indolore, frais et rouge. Cette déclaration est vraie ou fausse ?"
	label define s5_34 1 "Vrai" 2 "Faux" 8 "Je ne sais pas"
	label values s5_34 s5_34

	label variable s5_35 "535. Quelles sont les étapes de la prise en charge d’un cas d’hémorragie antepar"
	note s5_35: "535. Quelles sont les étapes de la prise en charge d’un cas d’hémorragie antepartum chez une femme enceinte ?"

	label variable s5_35a "535a. Préciser autre étape de prise en charge"
	note s5_35a: "535a. Préciser autre étape de prise en charge"

	label variable s5_36 "536. Quels sont les antibiotiques à administrer pour la prise en charge du sepsi"
	note s5_36: "536. Quels sont les antibiotiques à administrer pour la prise en charge du sepsis puerpérale ?"

	label variable s5_36a "536a. Préciser autre antibiotique"
	note s5_36a: "536a. Préciser autre antibiotique"

	label variable s5_37 "537. Comment diagnostique-t-on le travail prématuré ?"
	note s5_37: "537. Comment diagnostique-t-on le travail prématuré ?"

	label variable s5_37a "537a. Préciser autre façon de diagnostiquer"
	note s5_37a: "537a. Préciser autre façon de diagnostiquer"

	label variable s5_38 "538. Quel doit être l’âge gestationnel pour administrer des corticostéroïdes pré"
	note s5_38: "538. Quel doit être l’âge gestationnel pour administrer des corticostéroïdes prénatals ?"

	label variable s5_38a "538a. Préciser autre façon de diagnostiquer"
	note s5_38a: "538a. Préciser autre façon de diagnostiquer"

	label variable s5_39 "539. Selon vous quel est le rôle du tocolytique ?"
	note s5_39: "539. Selon vous quel est le rôle du tocolytique ?"

	label variable s5_39a "539a. Préciser autre rôle du tocolytique"
	note s5_39a: "539a. Préciser autre rôle du tocolytique"

	label variable s5_40 "540. Quelle est la prise en charge de la chorioamnionite ?"
	note s5_40: "540. Quelle est la prise en charge de la chorioamnionite ?"

	label variable s5_40a "540a. Préciser autre prise en charge"
	note s5_40a: "540a. Préciser autre prise en charge"

	label variable s5_41 "541. Un examen vaginal doit être effectué pour confirmer la rupture des membrane"
	note s5_41: "541. Un examen vaginal doit être effectué pour confirmer la rupture des membranes avant le travail . Cette déclaration est-elle vraie ou fausse ?"
	label define s5_41 1 "Vrai" 2 "Faux" 9 "Je ne sais pas"
	label values s5_41 s5_41

	label variable s5_42 "542. Quelles sont les étapes de prise en charge avant la référence en cas de rup"
	note s5_42: "542. Quelles sont les étapes de prise en charge avant la référence en cas de rupture des membranes avant le travail lors d'une grossesse à terme ?"

	label variable s5_42a "542a. Préciser autre étape de prise en charge"
	note s5_42a: "542a. Préciser autre étape de prise en charge"

	label variable s5_43 "543. Quelles sont les étapes de prise en charge de la rupture prématurée des mem"
	note s5_43: "543. Quelles sont les étapes de prise en charge de la rupture prématurée des membranes avant le travail sans fièvre ?"

	label variable s5_43a "543a. Préciser autre étape de prise en charge"
	note s5_43a: "543a. Préciser autre étape de prise en charge"

	label variable s5_44 "Quelle est la dose appropriée d’érythromycine ?"
	note s5_44: "Quelle est la dose appropriée d’érythromycine ?"
	label define s5_44 1 "Dose 250 mg 6 heures" 96 "Autre [préciser]" 9 "Je ne sais pas"
	label values s5_44 s5_44

	label variable s5_44a "544a. Préciser autre dose appropriée"
	note s5_44a: "544a. Préciser autre dose appropriée"

	label variable s5_45 "545. Quelles sont les étapes de prise en charge d’un cas d’Hémorragie Postpartum"
	note s5_45: "545. Quelles sont les étapes de prise en charge d’un cas d’Hémorragie Postpartum ?"

	label variable s5_45a "545a. Préciser autre étape de la prise en charge"
	note s5_45a: "545a. Préciser autre étape de la prise en charge"

	label variable s5_46 "546. Quelles sutures peuvent être appliquées chirurgicalement sur l’utérus en ca"
	note s5_46: "546. Quelles sutures peuvent être appliquées chirurgicalement sur l’utérus en cas Hémorragie Postpartum atonique réfractaire ?"

	label variable s5_46a "546a. Préciser autre suture à appliquer"
	note s5_46a: "546a. Préciser autre suture à appliquer"

	label variable s5_47 "547. Quels médicaments utérotoniques doivent être conservés au réfrigérateur ?"
	note s5_47: "547. Quels médicaments utérotoniques doivent être conservés au réfrigérateur ?"

	label variable s5_47a "547a. Préciser autre médicament utérotoniques"
	note s5_47a: "547a. Préciser autre médicament utérotoniques"

	label variable s5_48 "548. Quelles sont les contre-indications à l’utilisation d’Inj Ergometrine pour "
	note s5_48: "548. Quelles sont les contre-indications à l’utilisation d’Inj Ergometrine pour l’Hémorragie Postpartum ?"

	label variable s5_48a "548a. Préciser autre contre - indication"
	note s5_48a: "548a. Préciser autre contre - indication"

	label variable s5_49 "549. Quelles sont les contre-indications à l’utilisation d’Injection Carboprost "
	note s5_49: "549. Quelles sont les contre-indications à l’utilisation d’Injection Carboprost dans l’Hémorragie Postpartum ?"

	label variable s5_49a "549a. Préciser autre contre - indication"
	note s5_49a: "549a. Préciser autre contre - indication"

	label variable s5_50 "550. Quel degré de déchirure périnéale nécessite toujours une réparation ?"
	note s5_50: "550. Quel degré de déchirure périnéale nécessite toujours une réparation ?"
	label define s5_50 1 "3 ème et 4 ème degré" 96 "Autre [préciser]" 9 "Je ne sais pas"
	label values s5_50 s5_50

	label variable s5_50a "550a. Préciser autre degré de déchirure"
	note s5_50a: "550a. Préciser autre degré de déchirure"

	label variable s5_51 "551. Le placenta retenu ne doit être retiré que sous anesthésie. Cette déclarati"
	note s5_51: "551. Le placenta retenu ne doit être retiré que sous anesthésie. Cette déclaration est vraie ou fausse ?"
	label define s5_51 1 "Vrai" 7 "Faux" 9 "Je ne sais pas"
	label values s5_51 s5_51

	label variable s5_52 "552. Un goutte-à-goutte d'ocytocine doit être débuté en cas d'inversion utérine "
	note s5_52: "552. Un goutte-à-goutte d'ocytocine doit être débuté en cas d'inversion utérine avant le repositionnement en OT. Cette déclaration est vraie ou fausse?"
	label define s5_52 1 "Vrai" 7 "Faux" 9 "Je ne sais pas"
	label values s5_52 s5_52

	label variable s5_53 "553. Comment gérer le cas de rétention de tissus placentaires à l’intérieur de l"
	note s5_53: "553. Comment gérer le cas de rétention de tissus placentaires à l’intérieur de l’utérus ?"

	label variable s5_53a "553a. Préciser autre méthode de gestion de cas de rétention"
	note s5_53a: "553a. Préciser autre méthode de gestion de cas de rétention"

	label variable s5_54 "554. Quand dit-on que le placenta est retenu ?"
	note s5_54: "554. Quand dit-on que le placenta est retenu ?"
	label define s5_54 1 "Lorsqu'il n'est pas accouché plus de 30 minutes après l'accouchement du bébé" 7 "Autre [préciser]" 9 "Je ne sais pas"
	label values s5_54 s5_54

	label variable s5_54a "554a. Préciser autre méthode de gestion de cas de rétention"
	note s5_54a: "554a. Préciser autre méthode de gestion de cas de rétention"

	label variable s5_55 "555. Un compactage vaginal doit être réalisé pour les cas d' Hémorragie Postpart"
	note s5_55: "555. Un compactage vaginal doit être réalisé pour les cas d' Hémorragie Postpartum atonique référés au centre supérieur. Cette déclaration est-elle vraie ou fausse?"
	label define s5_55 1 "Vrai" 7 "Faux" 9 "Je ne sais pas"
	label values s5_55 s5_55

	label variable s5_56 "556. Quelles informations sont tracées toutes les 30 minutes sur le partogramme "
	note s5_56: "556. Quelles informations sont tracées toutes les 30 minutes sur le partogramme ?"

	label variable s5_56a "556a. Préciser autre information traçées"
	note s5_56a: "556a. Préciser autre information traçées"

	label variable s5_57 "557. Quelles informations sont tracées toutes les 4 heures sur le partogramme ?"
	note s5_57: "557. Quelles informations sont tracées toutes les 4 heures sur le partogramme ?"

	label variable s5_57a "557a. Préciser autre information traçées"
	note s5_57a: "557a. Préciser autre information traçées"

	label variable s5_58 "558. Comment identifierez-vous un cas de travail prolongé à partir des lectures "
	note s5_58: "558. Comment identifierez-vous un cas de travail prolongé à partir des lectures du partogramme ?"
	label define s5_58 1 "Ligne de dilatation cervicale tracée traversant la ligne d'alerte" 96 "Autre [préciser]" 9 "Je ne sais pas"
	label values s5_58 s5_58

	label variable s5_58a "558a. Préciser autre"
	note s5_58a: "558a. Préciser autre"

	label variable s5_59 "559. L'épisiotomie est obligatoire pour tous les accouchements primipares. Cette"
	note s5_59: "559. L'épisiotomie est obligatoire pour tous les accouchements primipares. Cette déclaration est-elle vraie ou fausse?"
	label define s5_59 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s5_59 s5_59

	label variable s5_60 "560. Quelles sont les contre-indications au déclenchement du travail ?"
	note s5_60: "560. Quelles sont les contre-indications au déclenchement du travail ?"

	label variable s5_60a "560a. Préciser autre contre-indications"
	note s5_60a: "560a. Préciser autre contre-indications"

	label variable s5_61 "561. Quelles sont les composantes du score de Bishop ?"
	note s5_61: "561. Quelles sont les composantes du score de Bishop ?"

	label variable s5_61a "561a. Préciser autre contre-indications"
	note s5_61a: "561a. Préciser autre contre-indications"

	label variable s5_62 "562. Comment peut-on réaliser une maturation cervicale pré-induction ?"
	note s5_62: "562. Comment peut-on réaliser une maturation cervicale pré-induction ?"

	label variable s5_62a "562a. Préciser autre contre-indications"
	note s5_62a: "562a. Préciser autre contre-indications"

	label variable s5_63 "563. Le meilleur médicament pour l’augmentation médicale est l’ocytocine en gout"
	note s5_63: "563. Le meilleur médicament pour l’augmentation médicale est l’ocytocine en goutte à goutte. Cette déclaration est-elle vraie ou fausse?"
	label define s5_63 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s5_63 s5_63

	label variable s5_64 "564. Qu'est-ce qu'une bonne contraction ?"
	note s5_64: "564. Qu'est-ce qu'une bonne contraction ?"
	label define s5_64 1 "contractions en 10 minutes chacune durant plus de 40 secondes" 96 "Autre [préciser]" 9 "Je ne sais pas"
	label values s5_64 s5_64

	label variable s5_64a "564a. Préciser autre"
	note s5_64a: "564a. Préciser autre"

	label variable s5_65 "565. Quelle est la dose initiale d'ocytocine pour le déclenchement/l'augmentatio"
	note s5_65: "565. Quelle est la dose initiale d'ocytocine pour le déclenchement/l'augmentation du travail ?"
	label define s5_65 1 "UI dans 500 ml de Ringer Lactate ou de solution saline normale" 96 "Autre [préciser]" 9 "Je ne sais pas"
	label values s5_65 s5_65

	label variable s5_65a "565a. Préciser autre"
	note s5_65a: "565a. Préciser autre"

	label variable s5_66 "566. Dans quel cas faut-il pratiquer une épisiotomie ?"
	note s5_66: "566. Dans quel cas faut-il pratiquer une épisiotomie ?"

	label variable s5_66a "566a. Préciser autre cas de pratique de l'épisitomie"
	note s5_66a: "566a. Préciser autre cas de pratique de l'épisitomie"

	label variable s5_67 "567. Quand faut-il pratiquer l’épisiotomie ?"
	note s5_67: "567. Quand faut-il pratiquer l’épisiotomie ?"

	label variable s5_67a "567a. Préciser autre cas de pratique de l'épisitomie"
	note s5_67a: "567a. Préciser autre cas de pratique de l'épisitomie"

	label variable s5_68 "568. Quelle est la concentration de la nignocaïne/xycolaïne utilisée pour l'épis"
	note s5_68: "568. Quelle est la concentration de la nignocaïne/xycolaïne utilisée pour l'épisiotomie ?"
	label define s5_68 1 "0.01" 96 "Autre [préciser]" 9 "Je ne sais pas"
	label values s5_68 s5_68

	label variable s5_68a "568a. Préciser autre"
	note s5_68a: "568a. Préciser autre"

	label variable s5_69 "569. Les sutures polyglycoliques sont préférées au catgut chromé pour leur résis"
	note s5_69: "569. Les sutures polyglycoliques sont préférées au catgut chromé pour leur résistance à la traction pour la réparation par épisiotomie. Cette déclaration est vraie ou fausse?"
	label define s5_69 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s5_69 s5_69

	label variable s5_70 "570. Le fil de suture pour la réparation par épisiotomie doit être 2-0. Cette dé"
	note s5_70: "570. Le fil de suture pour la réparation par épisiotomie doit être 2-0. Cette déclaration est vraie ou fausse ?"
	label define s5_70 1 "Vrai" 2 "Faux" 3 "Ne sait pas"
	label values s5_70 s5_70

	label variable s5_71 "571. Par où doit commencer la réparation d’une épisiotomie ?"
	note s5_71: "571. Par où doit commencer la réparation d’une épisiotomie ?"
	label define s5_71 1 "1 cm au dessus du sommet" 96 "Autre [préciser]" 9 "Je ne sais pas"
	label values s5_71 s5_71

	label variable s5_71a "571a. Préciser autre"
	note s5_71a: "571a. Préciser autre"

	label variable s5_72 "572. Quelles sont les indications d’un accouchement par forceps ?"
	note s5_72: "572. Quelles sont les indications d’un accouchement par forceps ?"

	label variable s5_72a "572a. Préciser autre indication d'un accouchement"
	note s5_72a: "572a. Préciser autre indication d'un accouchement"

	label variable s5_73 "573. Quelles sont les conditions préalables à l'utilisation des forceps de sorti"
	note s5_73: "573. Quelles sont les conditions préalables à l'utilisation des forceps de sortie ?"

	label variable s5_73a "573a. Préciser autre condition préalable"
	note s5_73a: "573a. Préciser autre condition préalable"

	label variable s5_74 "574. Quels sont les signes d’un échec des forceps ?"
	note s5_74: "574. Quels sont les signes d’un échec des forceps ?"

	label variable s5_74a "574a. Préciser autre signe d'un échec"
	note s5_74a: "574a. Préciser autre signe d'un échec"

	label variable s5_75 "575. L’échec des forceps est une indication de césarienne. Cette déclaration est"
	note s5_75: "575. L’échec des forceps est une indication de césarienne. Cette déclaration est-elle vraie ou fausse?"
	label define s5_75 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s5_75 s5_75

	label variable s5_76 "576. Un consentement écrit doit être obtenu avant l'application des forceps. Cet"
	note s5_76: "576. Un consentement écrit doit être obtenu avant l'application des forceps. Cette déclaration est vraie ou fausse?"
	label define s5_76 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s5_76 s5_76

	label variable s5_77 "577. Le céphalhématome après forceps ne nécessite qu'une observation et disparaî"
	note s5_77: "577. Le céphalhématome après forceps ne nécessite qu'une observation et disparaît généralement en 3 à 4 semaines. Cette déclaration est-elle vraie ou fausse?"
	label define s5_77 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s5_77 s5_77

	label variable s5_78 "578. Quelles sont les contre-indications à l’extraction par ventouse ?"
	note s5_78: "578. Quelles sont les contre-indications à l’extraction par ventouse ?"

	label variable s5_78a "578a. Préciser autre contre-indication"
	note s5_78a: "578a. Préciser autre contre-indication"

	label variable s5_79 "579. Par où placer le centre de la coupelle de la ventouse ?"
	note s5_79: "579. Par où placer le centre de la coupelle de la ventouse ?"
	label define s5_79 1 "Au point de flexion et 3 cm en avant de la fontanelle postérieure." 96 "Autre [préciser]" 9 "Je ne sais pas"
	label values s5_79 s5_79

	label variable s5_79a "579a. Préciser autre"
	note s5_79a: "579a. Préciser autre"

	label variable s5_80 "580. Quelle doit être la pression de vide maximale ?"
	note s5_80: "580. Quelle doit être la pression de vide maximale ?"
	label define s5_80 1 "0,8 kg/cm²" 96 "Autre [préciser]" 9 "Je ne sais pas"
	label values s5_80 s5_80

	label variable s5_80a "580a. Préciser autre"
	note s5_80a: "580a. Préciser autre"

	label variable s5_81 "581. Le méconium n'est pas un signe de souffrance fœtale lors d'un accouchement "
	note s5_81: "581. Le méconium n'est pas un signe de souffrance fœtale lors d'un accouchement par le siège. Cette déclaration est vraie ou fausse?"
	label define s5_81 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s5_81 s5_81

	label variable s5_82 "582. Quelles sont les indications de la césarienne en cas de siège ?"
	note s5_82: "582. Quelles sont les indications de la césarienne en cas de siège ?"

	label variable s5_82a "582a. Préciser autre indication de la césarienne"
	note s5_82a: "582a. Préciser autre indication de la césarienne"

	label variable s5_83 "583. Tous les fœtus en position transverse doivent être délivrés par césarienne,"
	note s5_83: "583. Tous les fœtus en position transverse doivent être délivrés par césarienne, que le fœtus soit vivant ou mort. Cette déclaration est vraie ou fausse ?"
	label define s5_83 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s5_83 s5_83

	label variable s5_84 "584. Quels sont les facteurs de risque de la dystocie de l’épaule ?"
	note s5_84: "584. Quels sont les facteurs de risque de la dystocie de l’épaule ?"

	label variable s5_84a "584a. Préciser autre facteur de risque de la dystocie"
	note s5_84a: "584a. Préciser autre facteur de risque de la dystocie"

	label variable s5_85 "585. Quelle est la manœuvre courante en cas de dystocie de l’épaule ?"
	note s5_85: "585. Quelle est la manœuvre courante en cas de dystocie de l’épaule ?"
	label define s5_85 1 "Manœuvre de Mc Robert" 96 "Autre [préciser]" 9 "Je ne sais pas"
	label values s5_85 s5_85

	label variable s5_85a "585a. Préciser autre facteur de risque de la dystocie"
	note s5_85a: "585a. Préciser autre facteur de risque de la dystocie"

	label variable s5_86 "586. Quelles sont les composantes des soins essentiels au nouveau-né ?"
	note s5_86: "586. Quelles sont les composantes des soins essentiels au nouveau-né ?"

	label variable s5_86a "586a. Préciser autre composante de soins"
	note s5_86a: "586a. Préciser autre composante de soins"

	label variable s5_87 "587. Pouvez-vous me dire quelles mesures vous prendriez immédiatement si le nouv"
	note s5_87: "587. Pouvez-vous me dire quelles mesures vous prendriez immédiatement si le nouveau-né ne respire pas ou ne pleure pas à la naissance ?"

	label variable s5_87a "587a. Préciser autre mesure à prendre"
	note s5_87a: "587a. Préciser autre mesure à prendre"

	label variable s5_88 "588. Pouvez-vous me dire les étapes que vous suivriez si le nouveau-né ne respir"
	note s5_88: "588. Pouvez-vous me dire les étapes que vous suivriez si le nouveau-né ne respire pas / ne pleure pas après 30 secondes de suivi des étapes ci-dessus ?"
	label define s5_88 1 "Fournir une ventilation avec sac et masque" 96 "Autre [préciser]" 9 "Je ne sais pas"
	label values s5_88 s5_88

	label variable s5_88a "588a. Préciser autre"
	note s5_88a: "588a. Préciser autre"

	label variable s5_89 "589. Pourquoi l’asphyxie à la naissance se produit-elle ?"
	note s5_89: "589. Pourquoi l’asphyxie à la naissance se produit-elle ?"

	label variable s5_89a "589a. Préciser autre raison de l'asphyxie"
	note s5_89a: "589a. Préciser autre raison de l'asphyxie"

	label variable s5_90 "590. Quels sont les facteurs intrapartum pouvant conduire à une asphyxie du nouv"
	note s5_90: "590. Quels sont les facteurs intrapartum pouvant conduire à une asphyxie du nouveau-né ?"

	label variable s5_90a "590a. Préciser autre facteurs intrapartum"
	note s5_90a: "590a. Préciser autre facteurs intrapartum"

	label variable s5_91 "591. Comment gérer un bébé prématuré ?"
	note s5_91: "591. Comment gérer un bébé prématuré ?"

	label variable s5_91a "591a. Préciser autremoyen de gestion d'un prématuré"
	note s5_91a: "591a. Préciser autremoyen de gestion d'un prématuré"

	label variable s5_92 "592. L'épuisement, les pleurs et l'impuissance sont normaux pendant la période p"
	note s5_92: "592. L'épuisement, les pleurs et l'impuissance sont normaux pendant la période post-partum et ne nécessitent pas d'attention particulière. Cette déclaration est vraie ou fausse?"
	label define s5_92 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s5_92 s5_92

	label variable s5_93 "593. Quel est l’antibiotique le plus efficace contre la mammite ?"
	note s5_93: "593. Quel est l’antibiotique le plus efficace contre la mammite ?"
	label define s5_93 1 "Cp Ampicilline 500 mg 4 fois par jour ou Tab" 2 "Érythromycine 250 mg trois fois par jour" 96 "Autre [préciser]" 9 "Je ne sais pas"
	label values s5_93 s5_93

	label variable s5_93a "593a. Préciser autre"
	note s5_93a: "593a. Préciser autre"

	label variable s5_94 "594. Quel est le signe que le bébé tète correctement ?"
	note s5_94: "594. Quel est le signe que le bébé tète correctement ?"

	label variable s5_94a "594a. Préciser autre signe"
	note s5_94a: "594a. Préciser autre signe"

	label variable s5_95 "595. Quel doit être le poids minimum du bébé pour commencer les soins de la Mère"
	note s5_95: "595. Quel doit être le poids minimum du bébé pour commencer les soins de la Mère Kangourou ?"
	label define s5_95 1 "Moins de 2 500 g" 96 "Autre [préciser]" 9 "Je ne sais pas"
	label values s5_95 s5_95

	label variable s5_95a "595a. Préciser autre signe"
	note s5_95a: "595a. Préciser autre signe"

	label variable s6_1_1 "A. Il est important de garantir la confidentialité des femmes pendant les examen"
	note s6_1_1: "A. Il est important de garantir la confidentialité des femmes pendant les examens et les procédures, ainsi que de protéger la confidentialité de leurs informations médicales."
	label define s6_1_1 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s6_1_1 s6_1_1

	label variable s6_1_2 "B. Les femmes devraient être autorisées à avoir un compagnon choisi (tel qu'un p"
	note s6_1_2: "B. Les femmes devraient être autorisées à avoir un compagnon choisi (tel qu'un partenaire, un membre de la famille ou une accompagnant) présent pendant le travail et l'accouchement pour fournir un soutien émotionnel et un plaidoyer."
	label define s6_1_2 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s6_1_2 s6_1_2

	label variable s6_1_3 "C. Les interventions médicales inutiles, telles que les épisiotomies de routine,"
	note s6_1_3: "C. Les interventions médicales inutiles, telles que les épisiotomies de routine, la surveillance fœtale continue et les césariennes électives, doivent être évitées à moins d'être médicalement justifiées et avec un consentement éclairé."
	label define s6_1_3 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s6_1_3 s6_1_3

	label variable s6_1_4 "D. Les femmes doivent être informées de tous les examens et procédures."
	note s6_1_4: "D. Les femmes doivent être informées de tous les examens et procédures."
	label define s6_1_4 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s6_1_4 s6_1_4

	label variable s6_1_5 "E. Les femmes ne devraient pas être soumises à des violences physiques ou verbal"
	note s6_1_5: "E. Les femmes ne devraient pas être soumises à des violences physiques ou verbales."
	label define s6_1_5 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s6_1_5 s6_1_5

	label variable s6_1_6 "F. Une pression utérine doit être appliquée si la mère est épuisée et incapable "
	note s6_1_6: "F. Une pression utérine doit être appliquée si la mère est épuisée et incapable de pousser le bébé vers l'extérieur."
	label define s6_1_6 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s6_1_6 s6_1_6

	label variable s6_1_7 "G. Une augmentation de l'injection d'ocytocine doit être effectuée dans tous les"
	note s6_1_7: "G. Une augmentation de l'injection d'ocytocine doit être effectuée dans tous les cas au cours de la phase 1 du travail."
	label define s6_1_7 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s6_1_7 s6_1_7

	label variable obs "OBSERVATIONS DES INTERVIEWERS"
	note obs: "OBSERVATIONS DES INTERVIEWERS"



	capture {
		foreach rgvar of varlist s2_23_* {
			label variable `rgvar' "223. Connaissez-vous la méthode \${method_label} ?"
			note `rgvar': "223. Connaissez-vous la méthode \${method_label} ?"
			label define `rgvar' 1 "Oui" 2 "Non"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist s2_24_* {
			label variable `rgvar' "224. Avez-vous déjà fourni un service/une assistance sur \${method_label} ?"
			note `rgvar': "224. Avez-vous déjà fourni un service/une assistance sur \${method_label} ?"
			label define `rgvar' 1 "Oui" 2 "Non"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist s2_25_* {
			label variable `rgvar' "225. Au cours des 12 derniers mois, avez-vous fourni un service/une aide sur \${"
			note `rgvar': "225. Au cours des 12 derniers mois, avez-vous fourni un service/une aide sur \${method_label} ?"
			label define `rgvar' 1 "Oui" 2 "Non"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist s2_26_* {
			label variable `rgvar' "226. Au cours du dernier mois, combien de clients avez-vous servi/assisté sur \$"
			note `rgvar': "226. Au cours du dernier mois, combien de clients avez-vous servi/assisté sur \${method_label} ?"
		}
	}

	capture {
		foreach rgvar of varlist s2_27_* {
			label variable `rgvar' "227. Quelle est la raison pour laquelle vous ne fournissez pas le service de \${"
			note `rgvar': "227. Quelle est la raison pour laquelle vous ne fournissez pas le service de \${method_label} ?"
			label define `rgvar' 1 "Pas confiant" 2 "Aucun client" 3 "Pas intéressé" 6 "Autre"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist s2_27a_* {
			label variable `rgvar' "Autre à préciser"
			note `rgvar': "Autre à préciser"
		}
	}

	capture {
		foreach rgvar of varlist s2_28_* {
			label variable `rgvar' "228. Avez-vous reçu une formation continue, une formation de remise à niveau, un"
			note `rgvar': "228. Avez-vous reçu une formation continue, une formation de remise à niveau, un mentorat (sur site/hors site) pour la méthode : \${method_label} ?"
		}
	}

	capture {
		foreach rgvar of varlist s2_29_* {
			label variable `rgvar' "229. La formation, la formation continue, la formation de remise à niveau, le me"
			note `rgvar': "229. La formation, la formation continue, la formation de remise à niveau, le mentorat ont-ils eu lieu au cours des 24 derniers mois ou il y a plus de 24 mois ?"
			label define `rgvar' 1 "Oui, au cours des 24 derniers mois" 2 "Oui, il y a plus de 24 mois"
			label values `rgvar' `rgvar'
		}
	}




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
*   Corrections file path and filename:  C:/Users/pkaberia/Dropbox/FP PROJECT/Data management/case de sante/QUESTIONNAIRE MEDECIN_corrections.csv
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
