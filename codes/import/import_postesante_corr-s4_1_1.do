* import_postesante_corr-s4_1_1.do
*
* 	Imports and aggregates "QUESTIONNAIRE POSTE DE SANTE-s4_1_1" (ID: postesante_corr) data.
*
*	Inputs:  "C:/Users/asandie/Desktop/structure_dm/raw_data/Poste de santé/QUESTIONNAIRE POSTE DE SANTE-s4_1_1.csv"
*	Outputs: "C:/Users/asandie/Desktop/structure_dm/raw_data/Poste de santé/QUESTIONNAIRE POSTE DE SANTE-s4_1_1.dta"
*
*	Output by SurveyCTO March 10, 2025 8:13 AM.

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
local csvfile "C:/Users/asandie/Desktop/structure_dm/raw_data/Poste de santé/QUESTIONNAIRE POSTE DE SANTE-s4_1_1.csv"
local dtafile "C:/Users/asandie/Desktop/structure_dm/raw_data/Poste de santé/QUESTIONNAIRE POSTE DE SANTE-s4_1_1.dta"
local corrfile "C:/Users/asandie/Desktop/structure_dm/raw_data/Poste de santé/QUESTIONNAIRE POSTE DE SANTE-s4_1_1_corrections.csv"
local note_fields1 ""
local text_fields1 "s4_1_5au s4_1_6 s4_1_8 s4_1_9 s4_1_11 s4_1_12au"
local date_fields1 ""
local datetime_fields1 ""

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



	* label variables
	label variable key "Unique submission ID"
	cap label variable submissiondate "Date/time submitted"
	cap label variable formdef_version "Form version used on device"
	cap label variable review_status "Review status"
	cap label variable review_comments "Comments made during review"
	cap label variable review_corrections "Corrections made during review"


	label variable s4_1_2 "1. Désignation du personnel autorisé"
	note s4_1_2: "1. Désignation du personnel autorisé"
	label define s4_1_2 1 "Infirmier/Infirmière" 2 "Assistant infirmier" 3 "Sage-femmes" 4 "ASC"
	label values s4_1_2 s4_1_2

	label variable s4_1_3 "2. Ce poste est-il actuellement vacant ?"
	note s4_1_3: "2. Ce poste est-il actuellement vacant ?"
	label define s4_1_3 1 "Oui" 2 "Non"
	label values s4_1_3 s4_1_3

	label variable s4_1_4 "3. Quel est son sexe ?"
	note s4_1_4: "3. Quel est son sexe ?"
	label define s4_1_4 1 "Homme" 2 "Femme"
	label values s4_1_4 s4_1_4

	label variable s4_1_5 "4. Quel est son niveau d'études ?"
	note s4_1_5: "4. Quel est son niveau d'études ?"
	label define s4_1_5 0 "Aucun niveau" 1 "primaire" 2 "secondaire" 3 "baccaulauréat" 4 "licence" 5 "maîtrise" 6 "master" 7 "doctorat" 8 "doctorat avec spécialisation (DES)" 9 "autres"
	label values s4_1_5 s4_1_5

	label variable s4_1_5au "Veuillez préciser le niveau d'études"
	note s4_1_5au: "Veuillez préciser le niveau d'études"

	label variable s4_1_6 "5. Cette personne a-t-elle reçu une formation complémentaire sur le PF ?"
	note s4_1_6: "5. Cette personne a-t-elle reçu une formation complémentaire sur le PF ?"

	label variable s4_1_7 "6. Cette personne fournit-elle actuellement des services de PF ?"
	note s4_1_7: "6. Cette personne fournit-elle actuellement des services de PF ?"
	label define s4_1_7 1 "Oui" 2 "Non"
	label values s4_1_7 s4_1_7

	label variable s4_1_8 "7. Quelles sont les méthodes qu'il/elle propose ?"
	note s4_1_8: "7. Quelles sont les méthodes qu'il/elle propose ?"

	label variable s4_1_9 "8. Cette personne a-t-elle reçu une formation supplémentaire sur la SMNI ?"
	note s4_1_9: "8. Cette personne a-t-elle reçu une formation supplémentaire sur la SMNI ?"

	label variable s4_1_10 "9. Cette personne fournit-elle actuellement un service de SMNI ?"
	note s4_1_10: "9. Cette personne fournit-elle actuellement un service de SMNI ?"
	label define s4_1_10 1 "Oui" 2 "Non"
	label values s4_1_10 s4_1_10

	label variable s4_1_11 "10. Quels sont les services de SMNI qu'il/elle fournit ?"
	note s4_1_11: "10. Quels sont les services de SMNI qu'il/elle fournit ?"

	label variable s4_1_12 "11. Pourquoi le poste est-il actuellement vacant ?"
	note s4_1_12: "11. Pourquoi le poste est-il actuellement vacant ?"
	label define s4_1_12 1 "Non recruté/nommé" 2 "En détachement dans une autre sanitaire de santé" 3 "En congé/poursuivant des études supérieures ou une formation pendant plus de 6 m" 4 "Absent du travail" 5 "Autre"
	label values s4_1_12 s4_1_12

	label variable s4_1_12au "Veuillez préciser le motif"
	note s4_1_12au: "Veuillez préciser le motif"

	label variable s4_1_13 "12. Depuis combien de temps ce poste est-il vacant ?"
	note s4_1_13: "12. Depuis combien de temps ce poste est-il vacant ?"






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
*   Corrections file path and filename:  C:/Users/asandie/Desktop/structure_dm/raw_data/Poste de santé/QUESTIONNAIRE POSTE DE SANTE-s4_1_1_corrections.csv
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
