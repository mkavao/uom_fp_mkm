* import_registre_eps_corr.do
*
* 	Imports and aggregates "REGISTRE EPS" (ID: registre_eps_corr) data.
*
*	Inputs:  "C:/Users/pkaberia/Dropbox//FP-Project-APHRC-UM/Atelier_FP/Codes//REGISTRE EPS_WIDE.csv"
*	Outputs: "C:/Users/pkaberia/Dropbox//FP-Project-APHRC-UM/Atelier_FP/Data/Donnees brutes//REGISTRE EPS.dta"
*
*	Output by SurveyCTO February 14, 2025 12:30 PM.

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
local csvfile "C:/Users/pkaberia/Dropbox//FP-Project-APHRC-UM/Atelier_FP/Codes//REGISTRE EPS_WIDE.csv"
local dtafile "C:/Users/pkaberia/Dropbox//FP-Project-APHRC-UM/Atelier_FP/Data/Donnees brutes//REGISTRE EPS.dta"
local corrfile "C:/Users/pkaberia/Dropbox//FP-Project-APHRC-UM/Atelier_FP/Codes//REGISTRE EPS_corrections.csv"
local note_fields1 ""
local text_fields1 "s1_4 s1_8 s1_10 se_pf servic_se_pf_count numerob_se_pf_* codeb_se_pf_* produitb_labell_* s8_5_* s8_7 s8_7_au s9_3_1 s9_3_2 s9_3_3 s9_3_4 s9_3_5 s9_3_6 obs instanceid"
local date_fields1 "today s8_4a_* s8_4b_* s9_2_1_1 s9_2_1_2 s9_2_2_1 s9_2_2_2 s9_2_3_1 s9_2_3_2 s9_2_4_1 s9_2_4_2 s9_2_5_1 s9_2_5_2 s9_2_6_1 s9_2_6_2"
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
	label define s1_3 1 "DAKAR CENTRE" 2 "DAKAR NORD" 3 "DAKAR OUEST" 4 "DAKAR SUD" 5 "DIAMNIADIO" 6 "GUEDIAWAYE" 8 "MBAO" 10 "RUFISQUE" 14 "DIOURBEL" 16 "TOUBA" 19 "FATICK" 26 "KAFFRINE" 30 "KAOLACK" 33 "KEDOUGOU" 36 "KOLDA" 44 "LINGUERE" 45 "LOUGA" 48 "MATAM" 50 "THILOGNE" 53 "PODOR" 54 "RICHARD TOLL" 55 "SAINT-LOUIS" 58 "SEDHIOU" 65 "TAMBACOUNDA" 68 "MBOUR" 73 "THIES" 74 "TIVAOUANE" 79 "ZIGUINCHOR"
	label values s1_3 s1_3

	label variable equipe "Veuilllez choisir votre équipe"
	note equipe: "Veuilllez choisir votre équipe"
	label define equipe 1 "Equipe 1" 2 "Equipe 2" 3 "Equipe 3" 4 "Equipe 4" 5 "Equipe 5" 6 "Equipe 6" 7 "Equipe 7" 8 "Equipe 8" 9 "Equipe 9" 10 "Equipe 10" 11 "Equipe 11" 12 "Equipe 12" 13 "Equipe 13" 14 "Equipe 14" 15 "Equipe 15" 16 "Equipe 16" 17 "Equipe 17" 18 "Equipe 18" 19 "Equipe 19" 21 "Equipe 21"
	label values equipe equipe

	label variable enqueteur "Nom de l'enquêteur"
	note enqueteur: "Nom de l'enquêteur"
	label define enqueteur 1 "Fleur Kona" 2 "Maimouna Yaye Pode Faye" 3 "Malick Ndiongue" 4 "Catherine Mendy" 5 "Mamadou Yacine Diallo Diallo" 6 "Yacine Sall Koumba Boulingui" 7 "Maty Leye" 8 "Fatoumata Binta Bah" 9 "Awa Diouf" 10 "Madicke Diop" 11 "Arona Diagne" 12 "Mame Salane Thiongane" 13 "Débo Diop" 14 "Ndeye Aby Gaye" 15 "Papa amadou Dieye" 16 "Younousse Chérif Goudiaby" 17 "Marieme Boye" 18 "Ibrahima Thiam" 19 "Ahmed Sene" 20 "Mame Gnagna Diagne Kane" 21 "Latyr Diagne" 22 "Sokhna Beye" 23 "Abdoul Khadre Djeylani Gueye" 24 "Bah Fall" 25 "Ndeye Mareme Diop" 26 "Ousmane Mbengue" 27 "Amadou Gueye" 28 "Momar Diop" 29 "Serigne Sow" 30 "Christophe Diouf" 31 "Maimouna Kane" 32 "Tabasky Diouf" 33 "Ndeye Anna Thiam" 34 "Youssou Diallo" 35 "Abdourahmane Niang" 36 "Mame Diarra Bousso Ndao" 37 "Omar Cisse" 38 "Coumba Kane" 39 "Yacine Sall" 40 "Mamadou Mar" 41 "Nayèdio Ba" 42 "Mame Bousso Faye" 43 "Rokhaya Gueye" 44 "Ousmane Samba Gaye" 45 "Ibrahima Diarra" 46 "Khardiata Kane" 47 "Idrissa Gaye" 48 "Mafoudya Camara" 49 "Mouhamed Fall" 50 "Pape Amadou Diop" 51 "Diarra Ndoye" 52 "Bintou Ly" 53 "Mame Mossane Biram Sarr" 54 "Adama Diaw" 55 "Maty Sarr" 56 "Mouhamadou Moustapha Ba" 57 "Serigne saliou Ngom" 58 "Aminata Harouna Dieng" 59 "Aminata Sall Diéye" 60 "Sophie Faye" 61 "Bintou Gueye" 62 "Louise Taky bonang" 63 "Salimata Diallo" 64 "Adama Ba" 65 "Mamour Diop" 66 "Ndeye Ouleye Sarr" 67 "Djiby Diouf" 68 "Madicke Gaye" 69 "Mouhamadou Sy" 70 "Sokhna Diaité" 71 "Mbaye Ndoye" 72 "Moussa Kane" 73 "Cheikh Ndao" 74 "Yaya Balde" 75 "Cheikh Modou Falilou Faye" 76 "Seydina Ousseynou Wade" 77 "Khadim Diouf" 78 "Awa Ndiaye" 79 "Dieynaba Tall" 80 "Souleymane Diol" 81 "Lamine Diop" 82 "Gnima Diedhiou" 83 "Clara Sadio" 84 "Fatoumata Diémé"
	label values enqueteur enqueteur

	label variable nom_structure "106. Nom de la structure sanitaire"
	note nom_structure: "106. Nom de la structure sanitaire"
	label define nom_structure 1 "EPS Hopital de Fann" 2 "EPS Hoggy" 3 "EPS Hôpital Militaire de Ouakam (Hmo)" 4 "EPS Institut Hygiene Sociale" 5 "EPS Hopital Abass Ndao" 6 "EPS Hopital Principal" 7 "EPS Hôpital d'Enfant Diamniadio" 8 "EPS Dalal Jamm" 9 "EPS Roi Baudoin" 10 "EPS Pikine" 11 "EPS Psychiatrique de Thiaroye" 12 "EPS Youssou Mbargane Diop" 13 "EPS Lubke de Diourbel" 14 "EPS Ndamatou" 15 "EPS Cheikh Ahmadoul Khadim" 16 "EPS Matlaboul Fawzayni" 17 "EPS de Fatick" 18 "EPS Thierno Birahim Ndao" 19 "EPS El hadji Ibrahima NIASS de Kaolack" 20 "EPS Amath Dansokho" 21 "EPS Kolda" 22 "EPS Linguere" 23 "EPS Amadou Sakhir Mbaye de Louga" 24 "EPS Régional de Matam" 25 "EPS de Ouroussogui" 26 "EPS AGNAM" 27 "EPS de NDioum" 28 "EPS Richard Toll" 29 "EPS de Saint Louis" 30 "EPS Sedhiou" 31 "EPS Tambacounda" 32 "EPS Mbour" 33 "EPS Amadou S Dieuguene" 34 "EPS ABDOU AZIZ SY" 35 "EPS CHR ZIGUINCHOR" 36 "EPS Hopital de la Paix"
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

	label variable s1_11 "111. Estimation de la population polarisée par l'EPS"
	note s1_11: "111. Estimation de la population polarisée par l'EPS"

	label variable se_pf "Sélectionnez tous les services de PF"
	note se_pf: "Sélectionnez tous les services de PF"

	label variable s8_6 "806. Cet EPS dispose-t-elle d'un mécanisme de suivi des utilisatrices de PF ?"
	note s8_6: "806. Cet EPS dispose-t-elle d'un mécanisme de suivi des utilisatrices de PF ?"
	label define s8_6 1 "Oui" 2 "Non"
	label values s8_6 s8_6

	label variable s8_7 "807. Quel est le principal mécanisme de suivi existe-t-il pour les utilisateurs "
	note s8_7: "807. Quel est le principal mécanisme de suivi existe-t-il pour les utilisateurs de PF ?"

	label variable s8_7_au "Veuillez préciser le mécanisme de suivi"
	note s8_7_au: "Veuillez préciser le mécanisme de suivi"

	label variable s8_8_1 "Utilisatrices de DIU"
	note s8_8_1: "Utilisatrices de DIU"
	label define s8_8_1 1 "Aucun d'entre eux" 2 "Certains d'entre eux" 3 "La plupart d'entre eux" 4 "La totalité d'entre eux"
	label values s8_8_1 s8_8_1

	label variable s8_8_2 "Utilisatrices de contraceptifs oraux"
	note s8_8_2: "Utilisatrices de contraceptifs oraux"
	label define s8_8_2 1 "Aucun d'entre eux" 2 "Certains d'entre eux" 3 "La plupart d'entre eux" 4 "La totalité d'entre eux"
	label values s8_8_2 s8_8_2

	label variable s8_8_3 "Utilisatrices de produits injectables"
	note s8_8_3: "Utilisatrices de produits injectables"
	label define s8_8_3 1 "Aucun d'entre eux" 2 "Certains d'entre eux" 3 "La plupart d'entre eux" 4 "La totalité d'entre eux"
	label values s8_8_3 s8_8_3

	label variable s8_8_4 "Utilisatrices de d'implants"
	note s8_8_4: "Utilisatrices de d'implants"
	label define s8_8_4 1 "Aucun d'entre eux" 2 "Certains d'entre eux" 3 "La plupart d'entre eux" 4 "La totalité d'entre eux"
	label values s8_8_4 s8_8_4

	label variable s9_1_1 "901. Combien de femmes enceintes enregistrées pour des soins prénatals au total "
	note s9_1_1: "901. Combien de femmes enceintes enregistrées pour des soins prénatals au total ont été servis au cours du dernier mois achevé ?"

	label variable s9_2_1_1 "902. Période de début"
	note s9_2_1_1: "902. Période de début"

	label variable s9_2_1_2 "902. Période de fin"
	note s9_2_1_2: "902. Période de fin"

	label variable s9_3_1 "903. NOM du registre"
	note s9_3_1: "903. NOM du registre"

	label variable s9_1_2 "901. Combien de femmes enceintes orientées vers des centres de soins supérieurs "
	note s9_1_2: "901. Combien de femmes enceintes orientées vers des centres de soins supérieurs au total ont été servis au cours du dernier mois achevé ?"

	label variable s9_2_2_1 "902. Période de début"
	note s9_2_2_1: "902. Période de début"

	label variable s9_2_2_2 "902. Période de fin"
	note s9_2_2_2: "902. Période de fin"

	label variable s9_3_2 "903. NOM du registre"
	note s9_3_2: "903. NOM du registre"

	label variable s9_1_3 "901. Combien d'accouchements normaux réalisés au total ont été servis au cours d"
	note s9_1_3: "901. Combien d'accouchements normaux réalisés au total ont été servis au cours du dernier mois achevé ?"

	label variable s9_2_3_1 "902. Période de début"
	note s9_2_3_1: "902. Période de début"

	label variable s9_2_3_2 "902. Période de fin"
	note s9_2_3_2: "902. Période de fin"

	label variable s9_3_3 "903. NOM du registre"
	note s9_3_3: "903. NOM du registre"

	label variable s9_1_4 "901. Combien de césariennes pratiquées au total ont été servis au cours du derni"
	note s9_1_4: "901. Combien de césariennes pratiquées au total ont été servis au cours du dernier mois achevé ?"

	label variable s9_2_4_1 "902. Période de début"
	note s9_2_4_1: "902. Période de début"

	label variable s9_2_4_2 "902. Période de fin"
	note s9_2_4_2: "902. Période de fin"

	label variable s9_3_4 "903. NOM du registre"
	note s9_3_4: "903. NOM du registre"

	label variable s9_1_5 "901. Combien de naissances vivantes au total ont été servis au cours du dernier "
	note s9_1_5: "901. Combien de naissances vivantes au total ont été servis au cours du dernier mois achevé ?"

	label variable s9_2_5_1 "902. Période de début"
	note s9_2_5_1: "902. Période de début"

	label variable s9_2_5_2 "902. Période de fin"
	note s9_2_5_2: "902. Période de fin"

	label variable s9_3_5 "903. NOM du registre"
	note s9_3_5: "903. NOM du registre"

	label variable s9_1_6 "901. Combien de nourrissons ayant reçu le vaccin contre la rougeole au total ont"
	note s9_1_6: "901. Combien de nourrissons ayant reçu le vaccin contre la rougeole au total ont été servis au cours du dernier mois achevé ?"

	label variable s9_2_6_1 "902. Période de début"
	note s9_2_6_1: "902. Période de début"

	label variable s9_2_6_2 "902. Période de fin"
	note s9_2_6_2: "902. Période de fin"

	label variable s9_3_6 "903. NOM du registre"
	note s9_3_6: "903. NOM du registre"

	label variable gpslatitude "Coordonnées GPS du centre de santé (latitude)"
	note gpslatitude: "Coordonnées GPS du centre de santé (latitude)"

	label variable gpslongitude "Coordonnées GPS du centre de santé (longitude)"
	note gpslongitude: "Coordonnées GPS du centre de santé (longitude)"

	label variable gpsaltitude "Coordonnées GPS du centre de santé (altitude)"
	note gpsaltitude: "Coordonnées GPS du centre de santé (altitude)"

	label variable gpsaccuracy "Coordonnées GPS du centre de santé (accuracy)"
	note gpsaccuracy: "Coordonnées GPS du centre de santé (accuracy)"

	label variable obs "Observations générales/Remarques"
	note obs: "Observations générales/Remarques"



	capture {
		foreach rgvar of varlist s8_1_* {
			label variable `rgvar' "801. Nombre total de visites de PF (nouvelles et continues) au cours du dernier "
			note `rgvar': "801. Nombre total de visites de PF (nouvelles et continues) au cours du dernier mois achevé pour \${produitb_labell}"
		}
	}

	capture {
		foreach rgvar of varlist s8_2_* {
			label variable `rgvar' "802. Nombre de nouvelles clientes ayant reçu des services de PF au cours du dern"
			note `rgvar': "802. Nombre de nouvelles clientes ayant reçu des services de PF au cours du dernier mois achevé pour \${produitb_labell}"
		}
	}

	capture {
		foreach rgvar of varlist s8_3_* {
			label variable `rgvar' "803. Nombre total de produits de PF fournis au cours du dernier mois achevé pour"
			note `rgvar': "803. Nombre total de produits de PF fournis au cours du dernier mois achevé pour \${produitb_labell}"
		}
	}

	capture {
		foreach rgvar of varlist s8_4a_* {
			label variable `rgvar' "804. Période de début"
			note `rgvar': "804. Période de début"
		}
	}

	capture {
		foreach rgvar of varlist s8_4b_* {
			label variable `rgvar' "804. Période de fin"
			note `rgvar': "804. Période de fin"
		}
	}

	capture {
		foreach rgvar of varlist s8_5_* {
			label variable `rgvar' "805. Nom du registre pour \${produitb_labell}"
			note `rgvar': "805. Nom du registre pour \${produitb_labell}"
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
*   Corrections file path and filename:  C:/Users/pkaberia/Dropbox//FP-Project-APHRC-UM/Atelier_FP/Codes//REGISTRE EPS_corrections.csv
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
