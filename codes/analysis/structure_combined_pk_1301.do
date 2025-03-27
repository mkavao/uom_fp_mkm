/*Preamble
This code merges the datasets each level, appends the datasets of the various health facilities: EPS, Poste de sante, Case de sante, into one dataset of health facilities.
The variable 'facility_type' has been used together with the facility_name, region and  district to uniquely identify facilities and merge/ append them.
When analysing for variables applicable to a specific facility level, factor in that and filter the data accordingly.


*Notes
- The variable on residence (Urban/Rural) not in the data
-

*/
* initialize Stata

clear all
clear matrix
set linesize 220
set maxvar 32000
set more off

cd "C:\Users\pkaberia\Dropbox\FP PROJECT\UoM FP Analysis 2025"
*import excel "C:\Users\pkaberia\Dropbox\FP PROJECT\UoM FP Analysis 2025\data\raw data_IUCAD\eps_iucad.xlsx", firstrow clear
*sa "C:\Users\pkaberia\Dropbox\FP PROJECT\UoM FP Analysis 2025\data\raw data_IUCAD\eps_iucad.dta", replace

****************EPS*************

*Importing EPS structures dataset
use "data\raw data_IUCAD\\EPS\eps_iucad.dta", clear
drop if _n==1
//Renaming variables for ease of reference
rename (s1_1 s1_3 nom_structure) (region district facility_name)
gen facility_type = "EPS"
label variable facility_type "Facility type"
label variable facility_type "Facility type"
replace facility_name = trim(lower(facility_name))
replace region = trim(lower(region))
replace district = trim(lower(district))
drop s1_7 //This variable (107. Autorité de gestion / Propriété) has no data across the tools 
tempfile eps_data
save `eps_data'

****************Poste de sante*************
*Importing POSTE structure data 
import excel "data\raw data_IUCAD\Poste de sante\BDD POSTE DE SANTE.xlsx" , firstrow clear
rename (Nomdudistrict Nomdelarégion Nomdelastructuresanitai FN HE) ( district region facility_name prix_postnatal prix_neonatal)
gen facility_type = "poste"
order facility_type, after(facility_name)
label variable facility_type "Facility type"
replace facility_name = trim(lower(facility_name))
replace region = trim(lower(region))
replace district = trim(lower(district))
destring BCombiencelacoûtetilpa, replace ignore("")
destring KY, replace ignore("")
drop formdef_version AutoritédegestionPropr FE KP LU HLastérilisationféminine ILastérilisationmasculine
tempfile poste_data
save `poste_data'


****************Center de sante*************
*Importing Center structure data 
import excel "data\raw data_IUCAD\Center de sante\BDD CENTRE DE SANTE_FINAL_07_01_2025.xlsx" , firstrow clear
rename (Nomdudistrict Nomdelarégion Nomdelastructuresanitai LM ML) ( district region facility_name prix_postpartum prix_neonatal)
gen facility_type = "center"
order facility_type, after(facility_name)
label variable facility_type "Facility type"
replace facility_name = trim(lower(facility_name))
replace region = trim(lower(region))
replace district = trim(lower(district))
destring BCombiencelacoûtetilpa, replace ignore("")
tostring AR DL EP FE, replace
drop formdef_version AutoritédegestionPropr FS GD GX Raisonsdelanondisponibi IP IQ IR JQ JR JS JT JU JV JW KK KL KM LE LF LG LT MS ARaisonsdelanondisponib BRaisonsdelanondisponib GRaisonsdelanondisponib MZ NA NB NC ND NE NJ NK NL NM NN NO PC PH PI PJ PK PL PM DE bCombiencelacoûtetilpa SK SZ TO YQ ACM ACX ADD
tempfile center_data
save `center_data'


****************Clinique privee*************
*Importing Center structure data 
import excel "data\raw data_IUCAD\Clinique privee\BDD CLINIQUE PRIVEE.xlsx" , firstrow clear
rename (Nomdudistrict Nomdelarégion Nomdelastructuresanitai KY) ( district region facility_name prix_newbon_essentials)
gen facility_type = "clinique"
order facility_type, after(facility_name)
label variable facility_type "Facility type"
replace facility_name = trim(lower(facility_name))
replace region = trim(lower(region))
replace district = trim(lower(district))
*destring BCombiencelacoûtetilpa, replace ignore("")
*Dropping unnecessary/empty columns
drop formdef_version AutoritédegestionPropr DK EO FR GC GL GW Raisonsdelanondisponibi IO IP IQ IR  bCombiencelacoûtetilpa AF AQ CW DD IS JN JP JQ JR JS JT JU JV KF KG KH KI KJ  KK KL KZ LA LB LC LD LE LF PB QP RU SJ SY TN  YC YM YN ACJ ACU ADA 
 
tempfile clinique_data
save `clinique_data'


*Merging the two datasets
use `eps_data', clear

* Appending Poste de sante dataset
append using `poste_data'

* Append the Center de sante dataset
append using `center_data'

* Append the Clinique privee dataset
append using `clinique_data'

* Save the combined dataset
save "data\clean data\Merged_structure.dta", replace

* Inspect the combined dataset
order facility_type, after(facility_name)
list facility_name facility_type region district if _n <= 10
tab facility_type
count if facility_type == "EPS" //35 facilties
count if facility_type == "center" // 121 facilities
count if facility_type == "poste" // 1,566 facilities
count if facility_type == "clinique" // 68 facilities

*Dropping unnecessary columns (to be added as cleaning continues)
de v99 v106 v113 v143 v180 v222 v233 v242 v253 v1423 v1450 v1465 v1480 v1495 v1516 v1544 v1567 v1689 v1792 v1803 v1810 reserved_name_for_field_list_lab QI AG CX RD RV RC //Confirming the columns have no data and are part of the metadata
drop submission_date start end today equipe enqueteur s1_8 s1_9 s1_10 v99 v106 v113 v143 v180 v222 v233 v242 v253 v1423 v1450 v1465 v1480 v1495 v1516 v1544 v1567 v1689 v1792 v1803 v1810 reserved_name_for_field_list_lab QI AG CX RD RV RC

save "data\clean data\Merged_structure.dta", replace




