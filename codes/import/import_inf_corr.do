* import_inf_corr.do
*
* 	Imports and aggregates "QUESTIONNAIRE INFIRMIER & SAGE-FEMME" (ID: inf_corr) data.
*
*	Inputs:  "C:/Users/pkaberia/Dropbox//FP-Project-APHRC-UM/Atelier_FP/Codes//QUESTIONNAIRE INFIRMIER & SAGE-FEMME_WIDE.csv"
*	Outputs: "C:/Users/pkaberia/Dropbox//FP-Project-APHRC-UM/Atelier_FP/Data/Donnees brutes//QUESTIONNAIRE INFIRMIER & SAGE-FEMME.dta"
*
*	Output by SurveyCTO February 14, 2025 1:10 PM.

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
local csvfile "C:/Users/pkaberia/Dropbox//FP-Project-APHRC-UM/Atelier_FP/Codes//QUESTIONNAIRE INFIRMIER & SAGE-FEMME_WIDE.csv"
local dtafile "C:/Users/pkaberia/Dropbox//FP-Project-APHRC-UM/Atelier_FP/Data/Donnees brutes//QUESTIONNAIRE INFIRMIER & SAGE-FEMME.dta"
local corrfile "C:/Users/pkaberia/Dropbox//FP-Project-APHRC-UM/Atelier_FP/Codes//QUESTIONNAIRE INFIRMIER & SAGE-FEMME_corrections.csv"
local note_fields1 ""
local text_fields1 "deviceid i3b s2_3a s2_6_1 s2_14_1a s2_14_2a s2_14_3a s2_14_4a s2_22 methods_repeat_count numero_pf_* code_pf_* method_label_* s2_27autre_* s2_28_* s3_2 s3_2a s3_3 s3_3a s3_4 s3_4a s3_6 s3_6a s3_7"
local text_fields2 "s3_7a s3_8 s3_8a s3_9 s3_9a s3_10 s3_10a s3_11 s3_11a s3_12a s3_13 s3_13a s3_14 s3_14a s3_15 s3_15a s3_18 s3_18a s3_19 s3_19a s3_21 s3_21a s3_22 s3_22a s3_23 s3_23a s3_24 s3_24a s3_25 s3_25a s3_26"
local text_fields3 "s3_26a s3_27 s3_27a s3_30 s3_30a s3_31 s3_31a s3_32 s3_32a s3_33 s3_33a s3_34 s3_34a s3_35 s3_35a s3_36 s3_36a s3_37 s3_37a s3_39 s3_39a s3_40 s3_40a s3_43 s3_43a s3_44 s3_44a s3_45 s3_45a s3_46"
local text_fields4 "s3_46a s3_47 s3_47a s3_48 s3_48a s3_49 s3_49a s3_50 s3_50a s3_51 s3_51a s3_52a s3_53 s3_53a s3_54 s3_54a s3_56 s3_56a s3_57 s3_57a s3_58a s3_60 s3_60a s3_61 s3_61a s3_62 s3_62a s3_63 s3_63a s3_64"
local text_fields5 "s3_64a s3_67 s3_67a s3_68 s3_68a s3_70 s3_70a s3_71 s3_71a s3_73 s3_73a s4_9a s4_11a s5_1 autre_501 s5_2 autre_502 s5_3 autre_503 autre_505 autre_507 s6_01 autre_601 s6_02 autre_602 s6_05 autre_605"
local text_fields6 "s6_06 autre_606 s6_07 autre_607 s6_08 autre_608 s6_09 autre_609 s6_10 autre_610 s6_11 autre_611 s6_12 autre_612 s6_13 autre_613 s6_14 autre_614 s6_15 autre_615 s6_17 autre_617 s6_18 autre_618 s6_19"
local text_fields7 "autre_619 s6_20 autre_620 s6_21 autre_621 s6_22 autre_622 s6_23 autre_623 s6_25 autre_625 s6_26 autre_626 s6_30 autre_630 s6_31 autre_631 s6_32 autre_632 s6_33 autre_633 s6_34 autre_634 s6_35"
local text_fields8 "autre_635 s6_37 autre_637 s6_38 autre_638 s6_39 autre_639 s6_40 autre_640 s6_41 autre_641 s6_42 autre_642 s6_43 autre_643 s6_44 autre_644 s6_46 autre_646 s6_47 autre_647 s6_48 autre_648 s6_49"
local text_fields9 "autre_649 s6_51 autre_651 s6_52 autre_652 s6_54 autre_654 s6_55 autre_655 s6_56 autre_656 s6_57 autre_657 s6_58 autre_658 s6_59 autre_659 s6_60 autre_660 s6_61 autre_661 s6_64 autre_664 s6_65"
local text_fields10 "autre_665 s6_66 autre_666 s6_67 autre_667 s6_68 autre_668 s6_69 autre_669 s6_70 autre_670 autre_671 s6_73 autre_673 s6_74 autre_674 autre_675 s6_76 autre_676 s6_77 autre_677 s6_78 autre_678 s6_79"
local text_fields11 "autre_679 s6_80 autre_680 autre_681 s6_82 autre_682 s6_83 autre_683 obs instanceid"
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
	label define i3 1 "CS Gaspard Camara" 2 "CS Grand Dakar" 3 "CS HLM" 4 "CS Hann Mer" 5 "CS Liberté 6 (Mamadou DIOP)" 6 "CS Mariste" 7 "EPS Hopital de Fann" 8 "PS Bel Air" 9 "PS Bourguiba" 10 "PS Derkle" 11 "PS Fann Hock" 12 "PS Georges Lahoud" 13 "PS HLM" 14 "PS Hann Sur Mer" 15 "PS Hann Village" 16 "PS Liberte 2" 17 "PS Liberte 6" 18 "CS Abdoul Aziz SY Dabakh" 19 "CS Camberene" 20 "CS Nabil Choucair" 21 "CS SAMU Municipal Grand Yoff" 22 "EPS Hoggy" 23 "PS Camberene" 24 "PS Grand Medine" 25 "PS Grand Yoff 2" 26 "PS Grand Yoff I" 27 "PS HLM Grand Yoff" 28 "PS Khar Yalla" 29 "PS Norade" 30 "PS Unite 16" 31 "PS Unite 22" 32 "PS Unite 8" 33 "PS Unite 9" 34 "PS Unité 26" 35 "CS Annette Mbaye Derneville" 36 "CS Municipal de Ouakam" 37 "CS Ngor" 38 "CS Philippe Senghor" 39 "EPS Hôpital Militaire de Ouakam (Hmo)" 40 "PS Apecsy 1" 41 "PS Cité Avion" 42 "PS Communautaire de Tonghor" 43 "PS Diamalaye" 44 "PS Liberte 4" 45 "PS Mermoz" 46 "PS Yoff" 47 "CS Cheikh Ahmadou Bamba Mbacke" 48 "CS Colobane" 49 "CS Elisabeth Diouf" 50 "CS Keur Yaye Sylvie" 51 "CS Plateau" 52 "EPS Institut Hygiene Sociale" 53 "EPS Hopital Abass Ndao" 54 "EPS Hopital Principal" 55 "INFIRMERIE HOPITAL DE LA GENDARMERIE ( Ex Gendarmerie Colobane)" 56 "PS THIEUDEME (privé)" 57 "PS Goree" 58 "PS HLM Fass" 59 "PS Raffenel" 60 "PS Sandial" 61 "PS Service D'Hygiene" 62 "CS Diamniadio" 63 "CS Ndiaye Diouf" 64 "EPS Hôpital d'Enfant Diamniadio" 65 "PS Bargny Guedji" 66 "PS Dougar" 67 "PS Kip Carrieres" 68 "PS Missirah" 69 "PS Ndiolmane" 70 "PS Ndoukhoura Peulh" 71 "PS Ndoyénne" 72 "PS Niangal" 73 "PS Sebi Ponty" 74 "PS Sebikotane" 75 "PS Sendou" 76 "PS Yenne" 77 "CS Wakhinane" 78 "EPS Dalal Jamm" 79 "EPS Roi Baudoin" 80 "PS Daroukhane" 81 "PS Darourakhmane" 82 "PS Fith Mith" 83 "PS Golfe Sud" 84 "PS HLM Las Palmas" 85 "PS Hamo Tefess" 86 "PS Hamo V" 87 "PS Medina Gounass" 88 "PS Nimzath" 89 "PS Parcelles Assainies Unite 4" 90 "CS Keur Massar" 91 "PS Mme Fatou BA" 92 "PS Aladji Pathe" 93 "PS Boune" 94 "PS Jaxaaye" 95 "PS Keur Massar Village" 96 "PS Malika" 97 "PS Malika Sonatel" 98 "PS Parcelle Assainie Keur Massar" 99 "CS Khadim Rassoul" 100 "EPS Pikine" 101 "EPS Psychiatrique de Thiaroye" 102 "PS CAPEC" 103 "PS Diacksao" 104 "PS Diamegueune" 105 "PS Fass Mbao" 106 "PS Grand Mbao" 107 "PS Kamb" 108 "PS Mbao Gare" 109 "PS Nassroulah" 110 "PS Petit Mbao" 111 "PS Taif" 112 "PS Thiaroye Azur" 113 "PS Thiaroye Gare" 114 "PS Thiaroye Sur Mer" 115 "PS la Rochette" 116 "CS Dominique" 117 "PS Dalifort" 118 "PS Darou Khoudoss" 119 "PS Darou Salam" 120 "PS Deggo" 121 "PS Guinaw Rail Nord" 122 "PS Guinaw Rail Sud" 123 "PS Khourounar" 124 "PS Municipal 1" 125 "PS Municipal 2" 126 "PS Pepiniere" 127 "PS Santa Yalla" 128 "PS Touba Diack Sao" 129 "CS Polyclinique" 130 "CS SOCOCIM" 131 "EPS Youssou Mbargane Diop" 132 "PS Arafat" 133 "PS Dangou" 134 "PS Diokoul Kher" 135 "PS Diokoul Wague" 136 "PS Diorga" 137 "PS Fass" 138 "PS Gouye Mouride" 139 "PS HLM" 140 "PS Keury Souf" 141 "PS Nimzath" 142 "PS TACO" 143 "PS Thiawlene" 144 "CS Sangalkam" 145 "PS Apix" 146 "PS Bambilor" 147 "PS Cite Gendarmerie" 148 "PS Denes" 149 "PS Gorome" 150 "PS Gorome 2" 151 "PS Keur Ndiaye Lo" 152 "PS Kounoune" 153 "PS Lébougui 2000" 154 "PS Medina Thioub" 155 "PS Niacourab" 156 "PS Niague" 157 "PS Tawfekh" 158 "PS Tivaoune Peulh" 159 "PS Wayembam" 160 "CS yeumbeul" 161 "PS Darou Salam 6" 162 "PS Darourahmane 2" 163 "PS Gallo Dia" 164 "PS Thiaroye Miname" 165 "PS Yeumbeul Ainoumady Sotrac" 166 "PS Yeumbeul Diamalaye" 167 "PS Yeumbeul Sud" 168 "PS cheikh Sidaty FALL" 169 "PS Ndondol" 170 "CS Bambey" 171 "PS Aguiyaye" 172 "PS Baba Garage" 173 "PS Bambay Serere" 174 "PS Bambeye Serere 2" 175 "PS Batal" 176 "PS DVF" 177 "PS Dinguiraye" 178 "PS Gatte" 179 "PS Gawane" 180 "PS Gourgourène" 181 "PS Keur Madiop" 182 "PS Keur Samba Kane" 183 "PS Lambaye" 184 "PS Leona" 185 "PS Mekhe Lambaye" 186 "PS N'dangalma" 187 "PS Ndeme Meissa" 188 "PS Ndereppe" 189 "PS Ndiakalack" 190 "PS Ngogom" 191 "PS Ngoye" 192 "PS Pallene" 193 "PS Refane" 194 "PS Reomao" 195 "PS Silane" 196 "PS Sokano" 197 "PS Tawa Fall" 198 "PS Thiakhar" 199 "PS Thieppe" 200 "PS Thieytou" 201 "PS Mme Elisabeth Diouf" 202 "CS Diourbel" 203 "CS Ndindy" 204 "EPS Lubke de Diourbel" 205 "PS Cheikh Anta" 206 "PS Dankh Sene" 207 "PS Gade Escale" 208 "PS Grand Diourbel" 209 "PS Keur Ngalgou" 210 "PS Keur Ngana" 211 "PS Keur Serigne Mbaye Sarr" 212 "PS Lagnar" 213 "PS Medinatoul" 214 "PS Ndayane" 215 "PS Ndoulo" 216 "PS Patar" 217 "PS Sareme Wolof" 218 "PS Sessene" 219 "PS Taiba Moutoupha" 220 "PS Tawfekh" 221 "PS Thiobe" 222 "PS Tocky Gare" 223 "PS Toure Mbonde" 224 "PS Walalane" 225 "CS Mbacke" 226 "PS Dalla Ngabou" 227 "PS Darou Nahim" 228 "PS Darou salam" 229 "PS Dendeye Gouyegui" 230 "PS Diamaguene" 231 "PS Digane" 232 "PS Doyoly" 233 "PS Guerle" 234 "PS Kael" 235 "PS Madina" 236 "PS Mbacke Ndimb" 237 "PS Missirah" 238 "PS Municipal" 239 "PS Ndioumane Taiba" 240 "PS Nghaye" 241 "PS Sadio" 242 "PS Taiba Thekene" 243 "PS Taïf" 244 "PS Touba Fall" 245 "PS Touba Mboul Kael" 246 "PS Typ" 247 "Ps Pallene" 248 "Ps Santhie" 249 "CS Darou Marnane" 250 "CS Darou Tanzil" 251 "CS Keur Niang" 252 "CS Saïdyl Badawi" 253 "CS Serigne Mbacke Madina" 254 "CS Serigne Saliou Mbacke" 255 "EPS Ndamatou" 256 "EPS Cheikh Ahmadoul Khadim" 257 "EPS Matlaboul Fawzayni" 258 "PS Boukhatoul Moubarak" 259 "PS Darou Karim" 260 "PS Darou Khadim" 261 "PS Darou Khoudoss" 262 "PS Darou Minam" 263 "PS Darou Rahmane" 264 "PS Dialybatou" 265 "PS Gouye Mbinde" 266 "PS Guede Bousso" 267 "PS Guede Kaw" 268 "PS Heliport" 269 "PS Kaîra" 270 "PS Keur Gol" 271 "PS Khelcom" 272 "PS Madyana I" 273 "PS Madyana II" 274 "PS Mboussobe" 275 "PS Ndindy Abdou" 276 "PS Oumoul Khoura" 277 "PS Sourah" 278 "PS Thiawene" 279 "PS Tindody" 280 "PS Touba Bagdad" 281 "PS Touba Belel" 282 "PS Touba Boborel" 283 "PS Touba Bogo" 284 "PS Touba Hlm" 285 "PS Touba Lansar" 286 "Cs Diakhao" 287 "PS Boff Mballeme" 288 "PS Boof Poupouye" 289 "PS Darou Salam Rural" 290 "PS Diakhao Fermé" 291 "PS Diaoule" 292 "PS Magarite Davary" 293 "PS Marouth" 294 "PS Mbellacadiao" 295 "PS Mbouma" 296 "PS Ndiop" 297 "PS Ndiourbel Sine" 298 "PS Ndjilasseme" 299 "PS Thiare" 300 "PS Toffaye" 301 "CS Dioffior" 302 "PS Boyard" 303 "PS Djilasse Public" 304 "PS Faoye" 305 "PS Fimela" 306 "PS Loul Sessene" 307 "PS Marfafaco" 308 "PS Marlothie" 309 "PS Ndangane" 310 "PS Ndiagamba" 311 "PS Nobandane" 312 "PS Palmarin Facao" 313 "PS Palmarin Ngallou" 314 "PS Samba Dia" 315 "PS Simal" 316 "PS Soudiane" 317 "CS Fatick" 318 "CS prive Dal Xel de Fatick" 319 "EPS de Fatick" 320 "PS Bacoboeuf" 321 "PS Bicole" 322 "PS Darou Salam Urbain" 323 "PS Diarere" 324 "PS Diohine" 325 "PS Diouroup" 326 "PS Emetteur" 327 "PS Fayil" 328 "PS Gadiack" 329 "PS Mbelloghoutt" 330 "PS Mbettite" 331 "PS Mbédap" 332 "PS Ndiayendiaye" 333 "PS Ndiongolor" 334 "PS Ndiosmone" 335 "PS Ndoffonghor" 336 "PS Ndouck" 337 "PS Ngoye Mbadatt" 338 "PS Peulga Darel" 339 "PS Senghor" 340 "PS Sobene" 341 "PS Sowane" 342 "PS Tataguine" 343 "CS Foundiougne" 344 "CS Niodior" 345 "PS Baouth" 346 "PS Bassar" 347 "PS Bassoul" 348 "PS Diamniadio" 349 "PS Diogane" 350 "PS Dionewar" 351 "PS Djirnda" 352 "PS Mbam" 353 "PS Mounde" 354 "PS Soum" 355 "CS Gossas" 356 "PS Colobane" 357 "PS Darou Marnane" 358 "PS Deguerre" 359 "PS Diabel" 360 "PS Gaina Mbar" 361 "PS Mbar" 362 "PS Moure" 363 "PS Ndiene Lagane" 364 "PS Ouadiour" 365 "PS Patar Lia" 366 "PS Somb" 367 "PS Thienaba Gossas" 368 "PS Yargouye" 369 "CS Niakhar" 370 "PS Mbadatte" 371 "PS Ndiambour Sine" 372 "PS Ndoss" 373 "PS Ngayokheme" 374 "PS Ngonine" 375 "PS Patar Sine" 376 "PS Sagne" 377 "PS Sob" 378 "PS Sorokh" 379 "PS Tella" 380 "PS Toucar" 381 "PS Yenguelé" 382 "CS Passy" 383 "PS Darou Keur Mor Khoredia" 384 "PS Diagane barka" 385 "PS Diossong" 386 "PS Djilor" 387 "PS Keur Birane Khoredia" 388 "PS Lerane Coly" 389 "PS Lérane Sambou" 390 "PS Mbelane" 391 "PS Mbowene" 392 "PS Ndiassane Saloum" 393 "PS Ndiaye Ndiaye Wolof" 394 "PS Niassene" 395 "PS Sadiogo" 396 "PS Thiamene Keur Souleymane" 397 "PS Thiaméne Diogo" 398 "CS Sokone" 399 "PS Bambadalla Thiakho (CU_MILDA 2022)" 400 "PS Baria" 401 "PS Bettenty" 402 "PS Bossinkang" 403 "PS Coular Soce" 404 "PS Dassilame Soce" 405 "PS Diaglé" 406 "PS Djinack Bara" 407 "PS Karang" 408 "PS Keur Amath Seune" 409 "PS Keur Gueye Yacine" 410 "PS Keur Ousseynou Dieng (CU_MILDA 2022)" 411 "PS Keur Saloum Diane" 412 "PS Keur Samba Gueye" 413 "PS Keur Seny Gueye" 414 "PS Medina Djikoye" 415 "PS Missirah" 416 "PS Nemabah" 417 "PS Nemanding" 418 "PS Ngayene Thiebo" 419 "PS Nioro Alassane Tall" 420 "PS Pakala" 421 "PS Santamba" 422 "PS Sirmang" 423 "PS Sokone" 424 "PS Toubacouta" 425 "CS de Mbirkilane" 426 "PS Bidiam" 427 "PS Bossolel" 428 "PS Diamal" 429 "PS Keur Mbouki" 430 "PS Keur Pathè" 431 "PS Keur Sader" 432 "PS Keur Sawely" 433 "PS Koumpal" 434 "PS Mabo" 435 "PS Mbeuleup" 436 "PS Ndiayene Waly" 437 "PS Ndiognick" 438 "PS Ngouye" 439 "PS Segre Secco" 440 "PS Segregata" 441 "PS Thicatt" 442 "PS Touba Mbela" 443 "PS Weynde" 444 "PS Ngodiba" 445 "CS de Kaffrine" 446 "EPS Thierno Birahim Ndao" 447 "PS Boulel" 448 "PS Darou Salam" 449 "PS Diacksao" 450 "PS Diamagadio" 451 "PS Diamaguene" 452 "PS Diokoul Mbellboul" 453 "PS Dioumada" 454 "PS Djouth Nguel" 455 "PS Gniby" 456 "PS Goulokoum" 457 "PS Hore" 458 "PS Kaffrine II" 459 "PS Kahi" 460 "PS Kathiote" 461 "PS Keur Babou" 462 "PS Kélimane" 463 "PS Mbegue" 464 "PS Mbelbouck" 465 "PS Medinatoul Salam 2" 466 "PS Médina Taba" 467 "PS Méo Diobéne" 468 "PS Ndiaobambaly" 469 "PS Nganda" 470 "PS Nguer Mandakh" 471 "PS Pathe Thiangaye" 472 "PS Same Nguéyéne" 473 "PS Santhie Galgone" 474 "PS Sorocogne" 475 "CS Koungheul" 476 "PS Arafat" 477 "PS Coura Mouride" 478 "PS Darou Kaffat" 479 "PS Dimiskha" 480 "PS Fass Thieckene" 481 "PS Gainth Pathe" 482 "PS Ida Mouride" 483 "PS Keur Malick Marame" 484 "PS Keur Mandoumbe" 485 "PS Keur NGAYE" 486 "PS Koukoto Simong" 487 "PS Koung Koung" 488 "PS Kourdane" 489 "PS Lour Escale" 490 "PS Maka Gouye" 491 "PS Maka Yop" 492 "PS Minam" 493 "PS Missira Public" 494 "PS Ndiayene Lour" 495 "PS Ndoume" 496 "PS Ngouye Diaraf" 497 "PS Piram Manda" 498 "PS Ribot Escale" 499 "PS Saly Escale" 500 "PS Santhie Nguerane" 501 "PS Sine Matar" 502 "PS Sobel Diam Diam" 503 "PS Taif Thieckene" 504 "PS Touba Alia" 505 "PS Touba Aly Mbenda" 506 "PS Urbain" 507 "PS Urbain 2" 508 "CS Malem Hodar" 509 "PS Darou Mbané" 510 "PS Darou Minam" 511 "PS Diaga Keur Serigne" 512 "PS Diam Diam" 513 "PS Dianke Souf" 514 "PS Fass Mame Baba" 515 "PS Hodar" 516 "PS Khaîra Diaga" 517 "PS Maka Belal" 518 "PS Mbarocounda" 519 "PS Medina Sy" 520 "PS Médina Dianké" 521 "PS Ndiobene" 522 "PS Ndioté Séane" 523 "PS Ndioum Gainthie" 524 "PS Ngaba" 525 "PS Niahene" 526 "PS Paffa" 527 "PS Sagna" 528 "PS Seane" 529 "PS Tip Saloum" 530 "PS Touba Médinatoul" 531 "PS Touba Ngueyene" 532 "CS Guinguineo" 533 "PS Athiou" 534 "PS Back Samba Dior" 535 "PS Colobane Lambaye" 536 "PS Dara Mboss" 537 "PS Farabougou" 538 "PS Fass" 539 "PS Gagnick" 540 "PS Goweth Sérère" 541 "PS Kongoly" 542 "PS Mande Keur Miniane" 543 "PS Mbadakhoun" 544 "PS Mboss" 545 "PS Mboulougne" 546 "PS Ndelle" 547 "PS Ndiagne Kahone" 548 "PS Ndiago" 549 "PS Ngathie Naoude" 550 "PS Ngoloum" 551 "PS Nguekhokh" 552 "PS Nguelou" 553 "PS Ourour" 554 "PS Panal" 555 "PS Tchiky" 556 "PS Walo" 557 "PS Wardiakhal" 558 "PS Sibassor" 559 "CS Kasnack" 560 "EPS El hadji Ibrahima NIASS de Kaolack" 561 "PS Abattoirs" 562 "PS Boustane" 563 "PS Darou Ridouane" 564 "PS Dialegne" 565 "PS Diamegueune" 566 "PS Dya" 567 "PS Fass Thioffack" 568 "PS Gandiaye" 569 "PS Kabatoki" 570 "PS Kahone" 571 "PS Kanda" 572 "PS Keur Mbagne Diop" 573 "PS Koundam" 574 "PS Leona" 575 "PS Lyndiane" 576 "PS Medina Baye" 577 "PS Medina Mbaba" 578 "PS Ndiebel" 579 "PS Ndorong" 580 "PS Ngane" 581 "PS Ngothie" 582 "PS Nimzatt" 583 "PS Parcelles Assainies" 584 "PS Same" 585 "PS Sara" 586 "PS Sob2" 587 "PS Taba Ngoye" 588 "PS Thioffac" 589 "PS Thiomby" 590 "CS Ndoffane" 591 "PS Daga Sambou" 592 "PS Daga Youndoume" 593 "PS Darou Mbiteyene" 594 "PS Darou Pakathiar" 595 "PS Darou Salam" 596 "PS Djilekhar" 597 "PS Keur Aly Bassine" 598 "PS Keur Baka" 599 "PS Keur Lassana" 600 "PS Keur Serigne Bassirou" 601 "PS Keur Soce" 602 "PS Koumbal" 603 "PS Koutal" 604 "PS Kouthieye" 605 "PS Lamarame" 606 "PS Latmingue" 607 "PS Mbitéyène Abdou" 608 "PS Ndiaffate" 609 "PS Ndiedieng" 610 "PS Tawa Mboudaye" 611 "PS Thiare" 612 "PS Darou Mbapp" 613 "PS Dinguiraye" 614 "PS Falifa" 615 "CS Nioro" 616 "CS Wack Ngouna" 617 "PS Dabaly" 618 "PS Darou Khoudoss" 619 "PS Darou Salam Commune" 620 "PS Darou Salam Mouride" 621 "PS Darou Salam Nioro" 622 "PS Diamagueune" 623 "PS Fass HLM" 624 "PS Gainthes Kayes" 625 "PS Kabacoto" 626 "PS Kaymor" 627 "PS Keur Abibou Niasse" 628 "PS Keur Ale Samba" 629 "PS Keur Ayip" 630 "PS Keur Birane Ndoupy" 631 "PS Keur Cheikh Oumar TOURE" 632 "PS Keur Lahine Sakho" 633 "PS Keur Maba Diakhou" 634 "PS Keur Madiabel 1" 635 "PS Keur Madiabel 2" 636 "PS Keur Mandongo" 637 "PS Keur Moussa" 638 "PS Keur Sountou" 639 "PS Keur Tapha" 640 "PS Kohel" 641 "PS Lohène" 642 "PS Medina Sabakh" 643 "PS Missirah Walo" 644 "PS Ndiba Ndiayenne" 645 "PS Ndrame Escale" 646 "PS Ngayene Sabakh" 647 "PS Niappa Balla" 648 "PS Niassène Walo" 649 "PS Paoskoto" 650 "PS Porokhane" 651 "PS Saboya" 652 "PS Santhie Thiamène" 653 "PS Sine ngayene" 654 "PS Soucouta" 655 "PS Taiba Niassene" 656 "PS Thila Grand" 657 "CS Kedougou" 658 "CS Ndormi" 659 "EPS Amath Dansokho" 660 "PS Banda Fassi" 661 "PS Bantako" 662 "PS Dimboli" 663 "PS Dinde Felo" 664 "PS Fadiga" 665 "PS Fongolimby" 666 "PS Mako" 667 "PS Ninefescha" 668 "PS Sylla Counda" 669 "PS Tenkoto" 670 "PS Thiabedji" 671 "PS Thiabekare" 672 "PS Tomboronkoto" 673 "PS Tripano" 674 "PS de Dalaba" 675 "CS Salemata" 676 "PS Ebarack" 677 "PS Dakately" 678 "PS Dar Salam" 679 "PS Darou Ningou" 680 "PS Ethiolo" 681 "PS Kevoye" 682 "PS Nepene" 683 "PS Oubadji" 684 "PS Thiankoye" 685 "CS Saraya" 686 "PS Bambadji" 687 "PS Bembou" 688 "PS Bransan" 689 "PS Daloto" 690 "PS Diakha Macky" 691 "PS Diakha Madina" 692 "PS Diakhaba" 693 "PS Diakhaling" 694 "PS Kharakhena" 695 "PS Khossanto" 696 "PS Madina Baffe" 697 "PS Madina Sirimana" 698 "PS Mamakhono" 699 "PS Missira Dentila" 700 "PS Missira Sirimana" 701 "PS Moussala" 702 "PS Nafadji" 703 "PS Sabodola" 704 "PS Saensoutou" 705 "PS Sambrambougou" 706 "PS Saroudia" 707 "PS Wassangaran" 708 "CS Kolda" 709 "EPS Kolda" 710 "PS Anambe" 711 "PS Bagadadji" 712 "PS Bambadinka" 713 "PS Bantancountou Maounde" 714 "PS Bouna Kane" 715 "PS Coumbacara" 716 "PS Dabo" 717 "PS Darou Salam Thierno" 718 "PS Dialacoumbi" 719 "PS Dialembere" 720 "PS Diankancounda Oguel" 721 "PS Diassina" 722 "PS Dioulacolon" 723 "PS Gadapara" 724 "PS Guire Yoro Bocar" 725 "PS Hafia" 726 "PS Ibrahima Nima" 727 "PS Kampissa" 728 "PS Kossanké" 729 "PS Mampatim" 730 "PS Medina Alpha Sadou" 731 "PS Medina Cherif" 732 "PS Medina El Hadj" 733 "PS Nghocky" 734 "PS Salamata" 735 "PS Salikegne" 736 "PS Sare Bidji" 737 "PS Sare Demdayel" 738 "PS Sare Kemo" 739 "PS Sare Moussa" 740 "PS Sare Moussa Meta" 741 "PS Sare Yoba Diega" 742 "PS Saré Bilaly" 743 "PS Sikilo Est" 744 "PS Sikilo ouest" 745 "PS Tankanto Escale" 746 "PS Temento Samba" 747 "PS Thiarra" 748 "PS Thiety" 749 "PS Thiewal Lao" 750 "PS Zone lycée" 751 "CS Medina Yoro Foulah" 752 "PS Badion" 753 "PS Bourouko" 754 "PS Diakhaly" 755 "PS Dinguiraye" 756 "PS Dioulanghel Banta" 757 "PS Fafacourou" 758 "PS Firdawsi" 759 "PS Kerewane" 760 "PS Koulinto" 761 "PS Kourkour Balla" 762 "PS Linkédiang" 763 "PS Mballocounda (MYF)" 764 "PS Medina Passy" 765 "PS Médina Manda" 766 "PS Ndorna" 767 "PS Ngoudourou" 768 "PS Niaming" 769 "PS Pata" 770 "PS Santankoye" 771 "PS Sare Yoro Bouya" 772 "PS Sobouldé" 773 "PS Sourouyel" 774 "PS Touba Thieckene" 775 "CS Medina gounass" 776 "CS Velingara" 777 "PS Afia" 778 "PS Bonconto" 779 "PS Dialadiang" 780 "PS Dialakegny" 781 "PS Diaobe" 782 "PS Doubirou" 783 "PS Kabendou" 784 "PS Kalifourou" 785 "PS Kandia" 786 "PS Kandiaye" 787 "PS Kaouné" 788 "PS Kounkane" 789 "PS Linkering" 790 "PS Manda Douane" 791 "PS Mballocounda (Vélingara)" 792 "PS Medina Dianguette" 793 "PS Medina Gounass" 794 "PS Medina Marie Cisse" 795 "PS Municipal thiankan" 796 "PS Nemataba" 797 "PS Nianao" 798 "PS Ouassadou" 799 "PS Pakour" 800 "PS Paroumba" 801 "PS Payoungou" 802 "PS Sare Coly Salle" 803 "PS Saré Balla" 804 "PS Saré Nagué" 805 "PS Sinthian Koundara" 806 "PS Wadiya Toulaye" 807 "Poste Croix Rouge" 808 "CS Dahra" 809 "PS Affe" 810 "PS Boulal Nianghene" 811 "PS Communal" 812 "PS Dealy" 813 "PS Kamb" 814 "PS Mbaye Awa" 815 "PS Mbeulekhe Diane" 816 "PS Mbeyene" 817 "PS Mboulal" 818 "PS Mélakh" 819 "PS NGuenene" 820 "PS Sagata Djoloff" 821 "PS Sam Fall" 822 "PS Sine Abdou" 823 "PS Tessekere" 824 "PS Thiamene" 825 "PS Touba Boustane" 826 "PS Widou" 827 "PS Yang Yang" 828 "CS Darou Mousty" 829 "CS Mbacke Kadior" 830 "PS Arafat" 831 "PS Darou Diop" 832 "PS Darou Kosso" 833 "PS Darou Marnane" 834 "PS Darou Miname Pet" 835 "PS Darou Wahab" 836 "PS Dekheule" 837 "PS Fass Toure" 838 "PS Keur Alioune Ndiaye" 839 "PS Mbadiane" 840 "PS Ndoyene" 841 "PS Nganado" 842 "PS Sam Yabal" 843 "PS Sar Sara" 844 "PS Taysir" 845 "PS Touba Merina" 846 "PS Touba Roof" 847 "PS Yari Dakhar" 848 "CS Gueoul" 849 "CS Kebemer" 850 "PS Bandegne" 851 "PS Diamaguene" 852 "PS Diokoul" 853 "PS Kab Gaye" 854 "PS Kanene" 855 "PS Keur Amadou Yalla" 856 "PS Lompoul" 857 "PS Loro" 858 "PS Ndakhar Syll" 859 "PS Ndande" 860 "PS Ndieye" 861 "PS Ngourane" 862 "PS Pallene Ndedd" 863 "PS Sagatta Gueth" 864 "PS Thieppe" 865 "PS Thiolom" 866 "CS Keur Momar SARR" 867 "PS Boudy Sakho" 868 "PS Boyo 2" 869 "PS Gande" 870 "PS Gankette Balla" 871 "PS Gouye Mbeuth" 872 "PS Keur Maniang" 873 "PS Keur Momar Sarr" 874 "PS Loboudou" 875 "PS Loumboule Mbath" 876 "PS Mbar Toubab" 877 "PS Nayobe" 878 "PS Ndimb" 879 "PS Nguer Malal" 880 "CS Coki" 881 "PS Coki" 882 "PS Djadiorde" 883 "PS Garki Diaw" 884 "PS Guet Ardo" 885 "PS Institut Islamique de Koki" 886 "PS Keur Bassine" 887 "PS Ndiagne" 888 "PS Ndiaré Touba Ndiaye" 889 "PS Ouarack" 890 "PS Pete Warack" 891 "PS Thiamene" 892 "CS Linguere" 893 "EPS Linguere" 894 "PS Barkedji" 895 "PS DIagali" 896 "PS Darou Salam DIOP" 897 "PS Dodji" 898 "PS Dolly" 899 "PS Gassane Ndiawene" 900 "PS Kadji" 901 "PS Labgar" 902 "PS Thiargny" 903 "PS Thiel" 904 "PS Touba Kane Gassane" 905 "PS Touba Linguére" 906 "PS Warkhokh" 907 "CS Louga" 908 "EPS Amadou Sakhir Mbaye de Louga" 909 "PS Artillerie" 910 "PS Dielerlou Syll" 911 "PS Kelle Gueye" 912 "PS Keur Ndiaye" 913 "PS Keur Serigne Louga Est" 914 "PS Keur Serigne Louga Ouest" 915 "PS Keur Sérigne Louga Sud" 916 "PS MEDINA SALAM" 917 "PS MERINA SARR" 918 "PS Mbediene" 919 "PS Ndawene" 920 "PS Nguidila" 921 "PS Niomre" 922 "PS Santhiaba Sud" 923 "PS Touba Darou Salame" 924 "PS Touba Seras" 925 "PS Vesos" 926 "PS Yermande" 927 "CS Sakal" 928 "PS Darou Rahma" 929 "PS Keur Sambou" 930 "PS Leona" 931 "PS Madina Thiolom" 932 "PS Ndawass Diagne" 933 "PS Ndialakhar Samb" 934 "PS Ndieye Satoure" 935 "PS Ngadji Sarr" 936 "PS Ngueune Sarr" 937 "PS Palene Mafall" 938 "PS Potou" 939 "PS Sague Sathiel" 940 "PS Syer Peulh" 941 "CS Hamady Ounare" 942 "CS Kanel" 943 "CS Waounde" 944 "PS Aoure" 945 "PS Bokiladji" 946 "PS Bokissaboudou" 947 "PS Bow" 948 "PS Dembacani" 949 "PS Dialloubé" 950 "PS Diella" 951 "PS Dounde" 952 "PS Fadiara" 953 "PS Foumi Hara" 954 "PS Ganguel Maka" 955 "PS Ganguel Souley" 956 "PS Gaode Boffe" 957 "PS Goumal" 958 "PS Gouriki Koliabé" 959 "PS Hadabere" 960 "PS Hamady Ounare" 961 "PS Kanel" 962 "PS Lobaly" 963 "PS Namary" 964 "PS Ndendory" 965 "PS Ndiott" 966 "PS Nganno" 967 "PS Nianghana Thiedel" 968 "PS Odobere" 969 "PS Orkadiere" 970 "PS Orndolde" 971 "PS Padalal" 972 "PS Polel Diaobe" 973 "PS Semme" 974 "PS Sendou" 975 "PS Seno Palel" 976 "PS Sinthiane" 977 "PS Sinthiou Bamambe" 978 "PS Soringho" 979 "PS Tekkinguel" 980 "PS Thiagnaff" 981 "PS Thially" 982 "PS Thiempeng" 983 "PS Waounde" 984 "PS Wendou Bosseabe" 985 "PS Wourosidi" 986 "PS Yacine Lacké" 987 "PS windou nodji" 988 "PS Danthiady" 989 "CS Matam" 990 "EPS Régional de Matam" 991 "EPS de Ouroussogui" 992 "PS Boinadji" 993 "PS Bokidiawe" 994 "PS Bokidiawe 2" 995 "PS Diamel" 996 "PS Diandioly" 997 "PS Dondou" 998 "PS Doumga Ouro Alpha" 999 "PS Fété Niébé" 1000 "PS Gaol" 1001 "PS Mbakhna" 1002 "PS Mboloyel" 1003 "PS Nabadji Civol" 1004 "PS Ndoulomadji Dembe" 1005 "PS Ndouloumadji Founebe" 1006 "PS Nguidjilone" 1007 "PS Ogo" 1008 "PS Ourossogui" 1009 "PS Sadel" 1010 "PS Sedo Sebe" 1011 "PS Sinthiou Garba" 1012 "PS Soubalo" 1013 "PS Taïba" 1014 "PS Thiaréne" 1015 "PS Tiguéré" 1016 "PS Travaux Dendoudy" 1017 "PS Woudourou" 1018 "PS de la Gendarmerie" 1019 "CS Ranerou" 1020 "PS Badagore" 1021 "PS Dayane Guélodé" 1022 "PS Fourdou" 1023 "PS Katane" 1024 "PS Lougre Thioly" 1025 "PS Loumbal Samba Abdoul" 1026 "PS Mbam" 1027 "PS Mbem Mbem" 1028 "PS Naouré" 1029 "PS Oudalaye" 1030 "PS Patouki" 1031 "PS Petiel" 1032 "PS Salalatou" 1033 "PS Samba Doguel" 1034 "PS Thionokh" 1035 "PS Velingara Ferlo" 1036 "PS Younoufere" 1037 "CS Thilogne" 1038 "EPS AGNAM" 1039 "PS Agnam Civol" 1040 "PS Agnam Goly" 1041 "PS Agnam Thiodaye" 1042 "PS Agnam lidoubé" 1043 "PS Dabia Odedji" 1044 "PS Diorbivol" 1045 "PS Goudoudé Diobé" 1046 "PS Goudoudé Ndouetbé" 1047 "PS Gourel Omar LY" 1048 "PS Kobilo" 1049 "PS Loumbal Babadji" 1050 "PS Loumbi Sanarabe" 1051 "PS Mberla Bele" 1052 "PS Ndiaffane" 1053 "PS Oréfondé" 1054 "PS Saré Liou" 1055 "PS Sylla Djonto" 1056 "CS Dagana" 1057 "PS Bokhol" 1058 "PS Bouteyni" 1059 "PS Diagle" 1060 "PS Gae" 1061 "PS Guidakhar" 1062 "PS Mbane" 1063 "PS Mbilor" 1064 "PS Ndombo" 1065 "PS Niassante" 1066 "PS Santhiaba" 1067 "PS Secteur 4 Et 5" 1068 "PS Thiago" 1069 "CS Aere Lao" 1070 "CS Cascas" 1071 "CS Galoya" 1072 "CS Pete" 1073 "PS Aere Lao" 1074 "PS Barobe Wassatake" 1075 "PS Bode lao" 1076 "PS Boguel" 1077 "PS Boke Dialoube" 1078 "PS Boke Mbaybe Salsalbe" 1079 "PS Boke Namari" 1080 "PS Boke Yalalbé" 1081 "PS Boki Sarankobe" 1082 "PS Cascas" 1083 "PS Diaba" 1084 "PS Diongui" 1085 "PS Dioude Diabe" 1086 "PS Doumga Lao" 1087 "PS Dounguel" 1088 "PS Galoya" 1089 "PS Gayekadar" 1090 "PS Gollere" 1091 "PS Karaweyndou" 1092 "PS Lougue" 1093 "PS Madina Ndiathbe" 1094 "PS Mbolo Birane" 1095 "PS Mboumba" 1096 "PS Mery" 1097 "PS Ndiayene Peulh" 1098 "PS Salde" 1099 "PS Saré Maoundé" 1100 "PS Sinthiou Amadou Mairame" 1101 "PS Sioure" 1102 "PS Thioubalel" 1103 "PS Walalde" 1104 "PS Yare Lao" 1105 "PS Yawaldé Yirlabé" 1106 "CS Podor" 1107 "CS Thile Boubacar" 1108 "EPS de NDioum" 1109 "PS Alwar" 1110 "PS Belel Kelle" 1111 "PS Commune de Podor" 1112 "PS Dara Halaybe" 1113 "PS Demet" 1114 "PS Diagnoum" 1115 "PS Diamal" 1116 "PS Diambo" 1117 "PS Diattar" 1118 "PS Dimat" 1119 "PS Dodel" 1120 "PS Donaye/ Taredji" 1121 "PS Doué" 1122 "PS Fanaye" 1123 "PS Gamadji Sarre" 1124 "PS Ganina" 1125 "PS Guede Chantier" 1126 "PS Guede Village" 1127 "PS Guiya" 1128 "PS Louboudou Doué" 1129 "PS Mafré" 1130 "PS Marda" 1131 "PS Mbidi" 1132 "PS Mboyo" 1133 "PS NDIEURBA" 1134 "PS Namarel" 1135 "PS Ndiandane" 1136 "PS Ndiawara" 1137 "PS Ndiayen Pendao" 1138 "PS Ndioum" 1139 "PS Nguendar" 1140 "PS Pathe Gallo" 1141 "PS Sinthiou Dangde" 1142 "PS Tatqui" 1143 "PS Thialaga" 1144 "PS Thiangaye" 1145 "PS Toulde Galle" 1146 "CS Richard Toll" 1147 "CS Ross Bethio" 1148 "CSS" 1149 "EPS Richard Toll" 1150 "PS Debi Tiguette" 1151 "PS Diama" 1152 "PS Diawar" 1153 "PS Gallo Malick" 1154 "PS Kassack Nord" 1155 "PS Kassack Sud" 1156 "PS Khouma" 1157 "PS Mbagam" 1158 "PS Mboundoum" 1159 "PS Ndiangue - Ndiaw" 1160 "PS Ndiaténe" 1161 "PS Ndombo Alarba" 1162 "PS Ngnith" 1163 "PS Niasséne" 1164 "PS Ronkh" 1165 "PS Rosso Senegal 1" 1166 "PS Rosso Senegal 2" 1167 "PS Savoigne" 1168 "PS Taouey" 1169 "PS Thiabakh" 1170 "PS Yamane" 1171 "CS Mpal" 1172 "CS Saint - Louis" 1173 "DPS Yonou Ndoub" 1174 "EPS de Saint Louis" 1175 "PS Bango" 1176 "PS Diamaguene" 1177 "PS Fass NGOM" 1178 "PS Gandon" 1179 "PS Goxu Mbath" 1180 "PS Guet Ndar" 1181 "PS Khor" 1182 "PS Mbakhana" 1183 "PS Ngallele" 1184 "PS Nord" 1185 "PS Pikine" 1186 "PS Rao" 1187 "PS Santhiaba (Ndar Toute)" 1188 "PS Sor" 1189 "PS Sor Daga" 1190 "PS Sud" 1191 "PS Tassinere" 1192 "CS Bounkiling" 1193 "PS Bogal" 1194 "PS Bona" 1195 "PS Boudouk" 1196 "PS Diacounda Diolene" 1197 "PS Dialocounda" 1198 "PS Diambati" 1199 "PS Diaroume" 1200 "PS Diendieme" 1201 "PS Djinani" 1202 "PS Djiragone" 1203 "PS Faoune" 1204 "PS Inor Diola" 1205 "PS Kandion Mangana" 1206 "PS Medina Wandifa" 1207 "PS Ndiama" 1208 "PS Ndiamacouta" 1209 "PS Ndiolofene" 1210 "PS Nioroky" 1211 "PS Senoba" 1212 "PS Seydou N Tall" 1213 "PS Sinthiou Mady Mbaye" 1214 "PS Sinthiou Tankon" 1215 "PS Soumboundou Fogny" 1216 "PS Syllaya" 1217 "PS Tankon" 1218 "PS Touba Fall" 1219 "CS Goudomp" 1220 "CS Samine" 1221 "PS Bafata" 1222 "PS Baghere" 1223 "PS Binako" 1224 "PS Diareng" 1225 "PS Djibanar" 1226 "PS Karantaba" 1227 "PS Kawour" 1228 "PS Kolibantang" 1229 "PS Kougnara" 1230 "PS Niagha" 1231 "PS Safane" 1232 "PS Sandiniery" 1233 "PS Sinbandi Brassou" 1234 "PS Tanaff" 1235 "PS Yarang Balante" 1236 "CS Bambaly" 1237 "CS Sedhiou" 1238 "EPS Sedhiou" 1239 "PS Bemet Bidjini" 1240 "PS Boudhié Samine" 1241 "PS Boumouda" 1242 "PS Bouno" 1243 "PS Dembo Coly" 1244 "PS Diana Malary" 1245 "PS Diannah Bah" 1246 "PS Diende" 1247 "PS Djibabouya" 1248 "PS Djiredji" 1249 "PS Koussy" 1250 "PS Manconoba" 1251 "PS Marakissa" 1252 "PS Marsassoum" 1253 "PS Medina Souane" 1254 "PS Nguindir" 1255 "PS Oudoucar" 1256 "PS Sakar" 1257 "PS Sansamba" 1258 "PS Singhere" 1259 "PS Tourecounda" 1260 "CS Bakel" 1261 "PS Aroundou" 1262 "PS Ballou" 1263 "PS Dedji" 1264 "PS Diawara" 1265 "PS Gabou" 1266 "PS Gallade" 1267 "PS Gande" 1268 "PS Golmy" 1269 "PS Kahé" 1270 "PS Kounghany" 1271 "PS Manael" 1272 "PS Marsa" 1273 "PS Moudery" 1274 "PS Ndjimbe" 1275 "PS Ololdou" 1276 "PS Samba Yide" 1277 "PS Sebou" 1278 "PS Sira Mamadou Bocar" 1279 "PS Tourime" 1280 "PS Tuabou" 1281 "PS Urbain Bakel" 1282 "PS Yaféra" 1283 "PS Yellingara" 1284 "CS Dianké Makha" 1285 "PS Bani Israel" 1286 "PS Bantanani" 1287 "PS Binguel" 1288 "PS Bodé" 1289 "PS Boutoukoufara" 1290 "PS Dalafine" 1291 "PS Diana" 1292 "PS Dieylani" 1293 "PS Dougue" 1294 "PS Douleyabe" 1295 "PS Gouta" 1296 "PS Kayan" 1297 "PS Komoty" 1298 "PS Koudy" 1299 "PS Koussan" 1300 "PS Lelekone" 1301 "PS Madina Diakha" 1302 "PS Niery" 1303 "PS Soutouta" 1304 "PS Talibadji" 1305 "CS Goudiry" 1306 "PS Ainoumady" 1307 "PS Bala" 1308 "PS Boynguel Bamba" 1309 "PS Diare Mbolo" 1310 "PS Diyabougou" 1311 "PS Gognedji" 1312 "PS Goumbayel" 1313 "PS Kagnoube" 1314 "PS Koar" 1315 "PS Kothiary" 1316 "PS Koulor" 1317 "PS Kouthia" 1318 "PS Madie" 1319 "PS Mbaniou" 1320 "PS Ndiya" 1321 "PS Sinthiou Mamadou Boubou" 1322 "PS Sinthiou Tafsir" 1323 "PS Tabading" 1324 "PS Thiara" 1325 "PS Toumounguel" 1326 "PS Waly Babacar" 1327 "Sinthiou Bocar Aly Kandar" 1328 "CS Kidira" 1329 "PS Arigabo" 1330 "PS Banipelly" 1331 "PS Bele" 1332 "PS Belijimbaré" 1333 "PS Daharatou/Ourothierno" 1334 "PS Dialiguel" 1335 "PS Didde Gassama" 1336 "PS Dyabougou" 1337 "PS Gathiary" 1338 "PS Kenieba" 1339 "PS Laminia" 1340 "PS Madina Foulbé" 1341 "PS Nayes" 1342 "PS Ouro Himadou" 1343 "PS Sadatou" 1344 "PS Samba Colo" 1345 "PS Sansanding" 1346 "PS Senedebou" 1347 "PS Sinthiou Dialiguel" 1348 "PS Sinthiou Fissa" 1349 "PS Tacoutala" 1350 "PS Toumboura" 1351 "PS Wouro Souleye" 1352 "CS Koumpentoum" 1353 "PS Bamba Thialene" 1354 "PS Darou Nbimbelane" 1355 "PS Darou Salam" 1356 "PS Darou Salam 2" 1357 "PS Diagle Sine" 1358 "PS Diam Diam" 1359 "PS Fass Gounass" 1360 "PS Kaba" 1361 "PS Kahene" 1362 "PS Kanouma" 1363 "PS Kouthia Gaidy" 1364 "PS Kouthiaba" 1365 "PS Loffé" 1366 "PS Loumby travaux" 1367 "PS Malemba" 1368 "PS Malene Niani" 1369 "PS Mereto" 1370 "PS Ndame" 1371 "PS Pass Koto" 1372 "PS Payar" 1373 "PS Syll Serigne Malick" 1374 "PS Velingara Koto" 1375 "CS Maka" 1376 "PS Cissecounda" 1377 "PS Colibantang" 1378 "PS Fadiyacounda" 1379 "PS Mboulembou" 1380 "PS Ndoga Babacar" 1381 "PS Pathiap" 1382 "PS Sare Diame" 1383 "PS Saré Ely" 1384 "PS Seoro" 1385 "PS Souba Counda" 1386 "PS Syllame" 1387 "PS Touba Belel" 1388 "CS Tambacounda" 1389 "EPS Tambacounda" 1390 "PS Afia" 1391 "PS Bambadinka" 1392 "PS Bantantinty" 1393 "PS Bira" 1394 "PS Bohe Baledji" 1395 "PS Botou" 1396 "PS Dar Salam" 1397 "PS Dar Salam Fodé" 1398 "PS Dawady" 1399 "PS Depot" 1400 "PS Dialocoto" 1401 "PS Djinkore" 1402 "PS Fodécounda Ansou" 1403 "PS Gouloumbou" 1404 "PS Gourel Djiadji" 1405 "PS Gouye" 1406 "PS Koussanar" 1407 "PS Missirah" 1408 "PS Neteboulou" 1409 "PS Pont" 1410 "PS Saal" 1411 "PS Sankagne" 1412 "PS Sare Guilele" 1413 "PS Saré Niana" 1414 "PS Segou Coura" 1415 "PS Sinthiou Malene" 1416 "PS Tamba Socé" 1417 "PS Tessan" 1418 "CS Joal" 1419 "PS Caritas" 1420 "PS Fadial" 1421 "PS Fadiouth" 1422 "PS Mbodiene" 1423 "PS Ndianda" 1424 "PS Ndiemane" 1425 "PS Ngueniene" 1426 "PS Santhe Elisabeth Diouf" 1427 "CS Khombole" 1428 "PS Bangadji" 1429 "PS Bokh" 1430 "PS Diack" 1431 "PS Diayane" 1432 "PS Kaba" 1433 "PS Keur Ibra Gueye" 1434 "PS Keur Macodou" 1435 "PS Keur Yaba Diop" 1436 "PS Mboss" 1437 "PS Mboulouctene" 1438 "PS Mbouvaille" 1439 "PS Ndiakhou" 1440 "PS Ndiayene Sirakh" 1441 "PS Ndoucoumane" 1442 "PS Ndouff-Ndengler" 1443 "PS Ngoudiane" 1444 "PS Sewekhaye" 1445 "PS Thiangaye" 1446 "PS Thienaba" 1447 "PS Touba Toul" 1448 "CS Mbour" 1449 "EPS Mbour" 1450 "PS Chaden" 1451 "PS Darou Salam" 1452 "PS Diamaguene" 1453 "PS Djilakh" 1454 "PS Fallokh Malicounda" 1455 "PS Falokh Mbour" 1456 "PS Fandane" 1457 "PS Gandigal" 1458 "PS Grand Mbour" 1459 "PS Malicounda Bambara" 1460 "PS Malicounda Keur Maissa" 1461 "PS Mballing" 1462 "PS Mbouleme" 1463 "PS Mbour Toucouleur" 1464 "PS Medine" 1465 "PS Ngaparou 1" 1466 "PS Ngaparou 2" 1467 "PS Ngoukhouthie" 1468 "PS Nguekokh 1" 1469 "PS Nguekokh 2" 1470 "PS Nguérigne Bambara" 1471 "PS Nianing" 1472 "PS Point Sarene" 1473 "PS Roff" 1474 "PS Saly" 1475 "PS Saly Carrefour" 1476 "PS Santessou" 1477 "PS Santhie" 1478 "PS Somone" 1479 "PS Takhoum" 1480 "PS Tene Toubab" 1481 "PS Trypano" 1482 "PS Varedo" 1483 "PS Warang" 1484 "CS Mekhe" 1485 "PS Nguembé" 1486 "PS Darou Gaye" 1487 "PS Diemoul" 1488 "PS Fass Diacksao" 1489 "PS Gade Yell" 1490 "PS Golobé" 1491 "PS Kelle" 1492 "PS Khandane" 1493 "PS Khawlou" 1494 "PS Koul" 1495 "PS Lebou" 1496 "PS Macka Léye" 1497 "PS Mbakhiss" 1498 "PS Mbayene" 1499 "PS Merina Dakhar" 1500 "PS Ndierigne" 1501 "PS Ndéméne" 1502 "PS Ngalick" 1503 "PS Ngandiouf" 1504 "PS Ngaye Diagne" 1505 "PS Ngaye Djitté" 1506 "PS Nguéwoul Loto" 1507 "PS Niakhene" 1508 "PS Pekesse" 1509 "PS Serigne Massamba Diop Same" 1510 "PS Thilmakha" 1511 "PS Thiékére" 1512 "PS Touba Kane" 1513 "PS Tyll Sathé" 1514 "CS Popenguine" 1515 "PS Boukhou" 1516 "PS Dagga" 1517 "PS Diass" 1518 "PS Guereo" 1519 "PS Kirene" 1520 "PS Ndayane" 1521 "PS Popenguine Serere" 1522 "PS Sindia" 1523 "PS Thicky" 1524 "PS Toglou" 1525 "CS Pout" 1526 "PS Bayakh" 1527 "PS Beer" 1528 "PS Cayar" 1529 "PS Keur Matar" 1530 "PS Keur Mousseu" 1531 "PS Ndiar" 1532 "PS Ndiender" 1533 "PS Ngomene" 1534 "PS Soune Serere" 1535 "PS Thor" 1536 "CS Thiadiaye" 1537 "PS Fissel" 1538 "PS Guelor" 1539 "PS Louly Mbentenier" 1540 "PS Louly Ndia" 1541 "PS Mbafaye" 1542 "PS Mbalamsome" 1543 "PS Mboulouctene Secco" 1544 "PS Mbourokh" 1545 "PS Ndiaganiao" 1546 "PS Ndiarao" 1547 "PS Ngeme" 1548 "PS Sandiara" 1549 "PS Sessene" 1550 "PS Tocomack" 1551 "CS 10ème de THIES" 1552 "CS Keur Mame El Hadji" 1553 "EPS Amadou S Dieuguene" 1554 "PS Cite Lamy" 1555 "PS Cite Niakh" 1556 "PS Darou Salam" 1557 "PS Diakhao" 1558 "PS Grand Thies" 1559 "PS Hanene" 1560 "PS Hersent" 1561 "PS Kawsara" 1562 "PS Keur Issa" 1563 "PS Keur Saib Ndoye" 1564 "PS Keur Serigne Ablaye" 1565 "PS Kissane" 1566 "PS Mbour I" 1567 "PS Mbour II" 1568 "PS Mbour III" 1569 "PS Mbousnakh" 1570 "PS Medina Fall I" 1571 "PS Medina Fall II" 1572 "PS Ngoumsane" 1573 "PS Nguinth" 1574 "PS Notto" 1575 "PS Parcelle Assainies" 1576 "PS Petit Thialy" 1577 "PS Peyckouk" 1578 "PS Pognène" 1579 "PS Pout Diack" 1580 "PS Sam Ndiaye" 1581 "PS Sampathe" 1582 "PS Silmang" 1583 "PS Takhikao" 1584 "PS Tassette" 1585 "PS Thies None" 1586 "PS Randoulene" 1587 "CS Tivaouane" 1588 "EPS ABDOU AZIZ SY" 1589 "PS Cherif Lo" 1590 "PS Darou Alpha" 1591 "PS Darou Khoudoss" 1592 "PS Diogo" 1593 "PS Diogo sur mer" 1594 "PS Fass Boye" 1595 "PS Fouloum" 1596 "PS Ka Fall" 1597 "PS Keur Khar DIOP" 1598 "PS Keur Mbir Ndao" 1599 "PS Khonk Yoye" 1600 "PS Mbayenne 3" 1601 "PS Mboro I" 1602 "PS Mboro II" 1603 "PS Medine" 1604 "PS Mekhe Village" 1605 "PS Meouane" 1606 "PS Mibasse" 1607 "PS Mont Rolland" 1608 "PS Ndankh" 1609 "PS Ndiassane" 1610 "PS Ngakhame1" 1611 "PS Nombile" 1612 "PS Notto Gouye Diama" 1613 "PS Pambal" 1614 "PS Pire Goureye" 1615 "PS Sao" 1616 "PS Taîba Ndiaye" 1617 "PS Touba Fall" 1618 "CS Bignona" 1619 "PS Badioncoto" 1620 "PS Badioure" 1621 "PS Baila" 1622 "PS Bougoutoub" 1623 "PS Boureck" 1624 "PS Coubalan" 1625 "PS Coubanao" 1626 "PS Diacoye Banga" 1627 "PS Diamaye" 1628 "PS Diocadou" 1629 "PS Diondji" 1630 "PS Djibidione" 1631 "PS Djilonguia" 1632 "PS Kagnarou" 1633 "PS Mampalago" 1634 "PS Mangouléne" 1635 "PS Manguiline" 1636 "PS Médiegue" 1637 "PS Médiègue Banghouname" 1638 "PS Niamone" 1639 "PS Niandane" 1640 "PS Niankitte" 1641 "PS Oulampane" 1642 "PS Ouonck" 1643 "PS Silinkine" 1644 "PS Sindialon" 1645 "PS Sindian" 1646 "PS Souda" 1647 "PS Suelle" 1648 "PS Tendieme" 1649 "PS Tendimane" 1650 "PS Tendine" 1651 "PS Tenghory Arrondissement" 1652 "PS Tenghory Transgambienne" 1653 "PS Tobor" 1654 "CS Diouloulou" 1655 "PS Abene" 1656 "PS Badiana" 1657 "PS Baranlire" 1658 "PS Belaye" 1659 "PS Biti Biti" 1660 "PS Couba" 1661 "PS Courame" 1662 "PS Dambondir" 1663 "PS Dar Salam" 1664 "PS Darou Kairy" 1665 "PS Diogue" 1666 "PS Djannah" 1667 "PS Djinaki" 1668 "PS Ebinkine" 1669 "PS Essom Sylatiaye" 1670 "PS Kabiline" 1671 "PS Kafountine" 1672 "PS Medina Daffe" 1673 "PS Niomoune Ile" 1674 "PS Selety" 1675 "PS Touba Tranquille" 1676 "CS Oussouye" 1677 "PS Boucotte" 1678 "PS Cabrousse" 1679 "PS Cadjinolle" 1680 "PS Cagnoute" 1681 "PS Cap Skirring" 1682 "PS Carabane Ile" 1683 "PS Carounate" 1684 "PS Diakene Diola" 1685 "PS Diakene Ouolof" 1686 "PS Diembering" 1687 "PS Elinkine" 1688 "PS Loudia Ouolof" 1689 "PS Wendaye" 1690 "PS Youtou" 1691 "CS Thionck Essyl" 1692 "PS Bagaya" 1693 "PS Balingor" 1694 "PS Bassire" 1695 "PS Dianki" 1696 "PS Diatock" 1697 "PS Diegoune I" 1698 "PS Diegoune II" 1699 "PS Kagnobon" 1700 "PS Kartiack" 1701 "PS Mandegane" 1702 "PS Mlomp" 1703 "PS Tendouck" 1704 "PS Thiobon" 1705 "CS Ziguinchor" 1706 "EPS CHR ZIGUINCHOR" 1707 "EPS Hopital de la Paix" 1708 "PS Adeane" 1709 "PS Agnack" 1710 "PS Baghagha" 1711 "PS Belfort" 1712 "PS Bethesda" 1713 "PS Bourofaye" 1714 "PS Boutoupa" 1715 "PS Colette Senghor" 1716 "PS Diabir" 1717 "PS Diagnon" 1718 "PS Djibock" 1719 "PS Djifanghor" 1720 "PS Emile Badiane" 1721 "PS Enampor" 1722 "PS Kaguitte" 1723 "PS Kande 1" 1724 "PS Kande II" 1725 "PS Kandialang I" 1726 "PS Kandialang II" 1727 "PS Lyndiane Municipal" 1728 "PS Mpack" 1729 "PS Nema" 1730 "PS Niaguis" 1731 "PS Niaguis II" 1732 "PS Nyassia" 1733 "PS Santhiaba" 1734 "PS Seleky" 1735 "PS Sindone" 1736 "PS Toubacouta" 1737 "PS soucoupapaye" 2001 "Ajouter une nouvelle structure" 2002 "Ajouter une nouvelle structure" 2003 "Ajouter une nouvelle structure" 2004 "Ajouter une nouvelle structure" 2005 "Ajouter une nouvelle structure" 2006 "Ajouter une nouvelle structure" 2007 "Ajouter une nouvelle structure" 2008 "Ajouter une nouvelle structure" 2009 "Ajouter une nouvelle structure" 2010 "Ajouter une nouvelle structure" 2011 "Ajouter une nouvelle structure" 2012 "Ajouter une nouvelle structure" 2013 "Ajouter une nouvelle structure" 2014 "Ajouter une nouvelle structure" 2015 "Ajouter une nouvelle structure" 2016 "Ajouter une nouvelle structure" 2017 "Ajouter une nouvelle structure" 2018 "Ajouter une nouvelle structure" 2019 "Ajouter une nouvelle structure" 2020 "Ajouter une nouvelle structure" 2021 "Ajouter une nouvelle structure" 2022 "Ajouter une nouvelle structure" 2023 "Ajouter une nouvelle structure" 2024 "Ajouter une nouvelle structure" 2025 "Ajouter une nouvelle structure" 2026 "Ajouter une nouvelle structure" 2027 "Ajouter une nouvelle structure" 2028 "Ajouter une nouvelle structure" 2029 "Ajouter une nouvelle structure" 2030 "Ajouter une nouvelle structure" 2031 "Ajouter une nouvelle structure" 2032 "Ajouter une nouvelle structure" 2033 "Ajouter une nouvelle structure" 2034 "Ajouter une nouvelle structure" 2035 "Ajouter une nouvelle structure" 2036 "Ajouter une nouvelle structure" 2037 "Ajouter une nouvelle structure" 2038 "Ajouter une nouvelle structure" 2039 "Ajouter une nouvelle structure" 2040 "Ajouter une nouvelle structure" 2041 "Ajouter une nouvelle structure" 2042 "Ajouter une nouvelle structure" 2043 "Ajouter une nouvelle structure" 2044 "Ajouter une nouvelle structure" 2045 "Ajouter une nouvelle structure" 2046 "Ajouter une nouvelle structure" 2047 "Ajouter une nouvelle structure" 2048 "Ajouter une nouvelle structure" 2049 "Ajouter une nouvelle structure" 2050 "Ajouter une nouvelle structure" 2051 "Ajouter une nouvelle structure" 2052 "Ajouter une nouvelle structure" 2053 "Ajouter une nouvelle structure" 2054 "Ajouter une nouvelle structure" 2055 "Ajouter une nouvelle structure" 2056 "Ajouter une nouvelle structure" 2057 "Ajouter une nouvelle structure" 2058 "Ajouter une nouvelle structure" 2059 "Ajouter une nouvelle structure" 2060 "Ajouter une nouvelle structure" 2061 "Ajouter une nouvelle structure" 2062 "Ajouter une nouvelle structure" 2063 "Ajouter une nouvelle structure" 2064 "Ajouter une nouvelle structure" 2065 "Ajouter une nouvelle structure" 2066 "Ajouter une nouvelle structure" 2067 "Ajouter une nouvelle structure" 2068 "Ajouter une nouvelle structure" 2069 "Ajouter une nouvelle structure" 2070 "Ajouter une nouvelle structure" 2071 "Ajouter une nouvelle structure" 2072 "Ajouter une nouvelle structure" 2073 "Ajouter une nouvelle structure" 2074 "Ajouter une nouvelle structure" 2075 "Ajouter une nouvelle structure" 2076 "Ajouter une nouvelle structure" 2077 "Ajouter une nouvelle structure" 2078 "Ajouter une nouvelle structure" 2079 "Ajouter une nouvelle structure"
	label values i3 i3

	label variable i3b "Nom de la nouvelle structure"
	note i3b: "Nom de la nouvelle structure"

	label variable i4 "104. Type de structure"
	note i4: "104. Type de structure"
	label define i4 1 "EPS" 2 "CS" 3 "PS"
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

	label variable s2_1 "201. Sexe du répondant"
	note s2_1: "201. Sexe du répondant"
	label define s2_1 1 "Masculin" 2 "Féminin"
	label values s2_1 s2_1

	label variable s2_2 "202. Quel âge aviez-vous à votre dernier anniversaire ?"
	note s2_2: "202. Quel âge aviez-vous à votre dernier anniversaire ?"

	label variable s2_3 "203. Quel est votre catégorie socio-professionnelle ?"
	note s2_3: "203. Quel est votre catégorie socio-professionnelle ?"
	label define s2_3 1 "Infirmier d'état" 2 "Sage-femme d'état" 3 "Infirmier d'école" 4 "Sage-femme d'école" 5 "Autre à préciser"
	label values s2_3 s2_3

	label variable s2_3a "203. Veuillez préciser la profession"
	note s2_3a: "203. Veuillez préciser la profession"

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

	label variable s2_6 "206. Quel est le diplôme le plus élevé obtenu ?"
	note s2_6: "206. Quel est le diplôme le plus élevé obtenu ?"
	label define s2_6 1 "Diplôme d'infirmer" 2 "Diplôme de sage-femme" 3 "Diplôme d'aide infirmer" 4 "Autre (préciser)"
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

	label variable s2_14_1a "214a. Préciser"
	note s2_14_1a: "214a. Préciser"

	label variable s2_15_1 "215a. Avez-vous bénéficié d'une formation en cours d'emploi, d'une formation de "
	note s2_15_1: "215a. Avez-vous bénéficié d'une formation en cours d'emploi, d'une formation de remise à niveau, d'un mentorat (sur site/hors site) dans la préparation à l’accouchement et préparation aux complications ?"
	label define s2_15_1 1 "Formation continue" 2 "Formation de remise à niveau" 3 "Mentorat" 4 "Aucun"
	label values s2_15_1 s2_15_1

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

	label variable s2_14_2a "214b. Préciser"
	note s2_14_2a: "214b. Préciser"

	label variable s2_15_2 "215b. Avez-vous bénéficié d'une formation en cours d'emploi, d'une formation de "
	note s2_15_2: "215b. Avez-vous bénéficié d'une formation en cours d'emploi, d'une formation de remise à niveau, d'un mentorat (sur site/hors site) dans la détection des grossesses à haut risque et orientation appropriée ?"
	label define s2_15_2 1 "Formation continue" 2 "Formation de remise à niveau" 3 "Mentorat" 4 "Aucun"
	label values s2_15_2 s2_15_2

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

	label variable s2_14_3a "214c. Préciser"
	note s2_14_3a: "214c. Préciser"

	label variable s2_15_3 "215c. Avez-vous bénéficié d'une formation en cours d'emploi, d'une formation de "
	note s2_15_3: "215c. Avez-vous bénéficié d'une formation en cours d'emploi, d'une formation de remise à niveau, d'un mentorat (sur site/hors site) dans la prise en charge de l'anémie sévère avec du fer saccharose ?"
	label define s2_15_3 1 "Formation continue" 2 "Formation de remise à niveau" 3 "Mentorat" 4 "Aucun"
	label values s2_15_3 s2_15_3

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

	label variable s2_14_4a "214d. Préciser"
	note s2_14_4a: "214d. Préciser"

	label variable s2_15_4 "215d. Avez-vous bénéficié d'une formation en cours d'emploi, d'une formation de "
	note s2_15_4: "215d. Avez-vous bénéficié d'une formation en cours d'emploi, d'une formation de remise à niveau, d'un mentorat (sur site/hors site) dans le partogramme ?"
	label define s2_15_4 1 "Formation continue" 2 "Formation de remise à niveau" 3 "Mentorat" 4 "Aucun"
	label values s2_15_4 s2_15_4

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
	note s3_14: "314. Quels sont les effets secondaires de l’utilisation du DIU dont vous informez les clientes ?"

	label variable s3_14a "314a Précisez autre effet secondaire informé aux clientes."
	note s3_14a: "314a Précisez autre effet secondaire informé aux clientes."

	label variable s3_15 "315. De quel mécanisme de suivi disposez-vous/la structure sanitaire dispose-t-e"
	note s3_15: "315. De quel mécanisme de suivi disposez-vous/la structure sanitaire dispose-t-elle, c'est-à-dire comment vous/la structure sanitaire assurez-vous que les clients DIU reçoivent des services de suivi à l'heure prévue ?"

	label variable s3_15a "315a. Précisez autre mécanisme de suivi de la structure."
	note s3_15a: "315a. Précisez autre mécanisme de suivi de la structure."

	label variable s3_16_1 "A. La période post-placentaire immédiate est le meilleur moment pour que la femm"
	note s3_16_1: "A. La période post-placentaire immédiate est le meilleur moment pour que la femme puisse se faire insérer un DIU."
	label define s3_16_1 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_16_1 s3_16_1

	label variable s3_16_2 "B. Une femme dont le diabète est contrôlé peut se faire insérer un DIU."
	note s3_16_2: "B. Une femme dont le diabète est contrôlé peut se faire insérer un DIU."
	label define s3_16_2 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_16_2 s3_16_2

	label variable s3_16_3 "C. Les DIU peuvent être insérés en toute sécurité chez un client atteint d'IST."
	note s3_16_3: "C. Les DIU peuvent être insérés en toute sécurité chez un client atteint d'IST."
	label define s3_16_3 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_16_3 s3_16_3

	label variable s3_16_4 "D. Les DIU ne peuvent pas être administrés aux clients souffrant d'anémie sévère"
	note s3_16_4: "D. Les DIU ne peuvent pas être administrés aux clients souffrant d'anémie sévère."
	label define s3_16_4 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_16_4 s3_16_4

	label variable s3_16_5 "E. Il est possible d'administrer un DIU à une femme atteinte du VIH/SIDA."
	note s3_16_5: "E. Il est possible d'administrer un DIU à une femme atteinte du VIH/SIDA."
	label define s3_16_5 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_16_5 s3_16_5

	label variable s3_16_6 "F. Une femme peut avoir un DIU inséré à tout moment dans les 12 jours suivant le"
	note s3_16_6: "F. Une femme peut avoir un DIU inséré à tout moment dans les 12 jours suivant le début des saignements menstruels."
	label define s3_16_6 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_16_6 s3_16_6

	label variable s3_16_7 "G. Des légers saignements entre les périodes menstruelles sont fréquents au cour"
	note s3_16_7: "G. Des légers saignements entre les périodes menstruelles sont fréquents au cours des 3 à 6 premiers mois d'utilisation du DIU. Ce n’est pas nocif et ils diminuent généralement avec le temps."
	label define s3_16_7 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_16_7 s3_16_7

	label variable s3_16_8 "H. Le DIU ne doit être supprimé qu'après le début du traitement de la salpingite"
	note s3_16_8: "H. Le DIU ne doit être supprimé qu'après le début du traitement de la salpingite si l'utilisateur souhaite le supprimer.Une visite de suivi après les premières règles ou 3 à 6 semaines après l'insertion d'un DIU est suffisante."
	label define s3_16_8 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_16_8 s3_16_8

	label variable s3_16_9 "I. Le DIU peut être utilisé comme contraception d’urgence dans les cinq jours su"
	note s3_16_9: "I. Le DIU peut être utilisé comme contraception d’urgence dans les cinq jours suivant un rapport sexuel non protégé."
	label define s3_16_9 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_16_9 s3_16_9

	label variable s3_16_10 "J. Une femme peut avoir un DIU inséré dans les 12 premiers jours après un avorte"
	note s3_16_10: "J. Une femme peut avoir un DIU inséré dans les 12 premiers jours après un avortement chirurgical."
	label define s3_16_10 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_16_10 s3_16_10

	label variable s3_16_11 "K. Une femme peut avoir un DIU inséré après 15 jours d’avortement médicamenteux "
	note s3_16_11: "K. Une femme peut avoir un DIU inséré après 15 jours d’avortement médicamenteux (en s’assurant que la cavité utérine est vide)."
	label define s3_16_11 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_16_11 s3_16_11

	label variable s3_16_12 "L. Les femmes atteintes de fibrome sous-muqueux peuvent se faire insérer un DIU."
	note s3_16_12: "L. Les femmes atteintes de fibrome sous-muqueux peuvent se faire insérer un DIU."
	label define s3_16_12 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_16_12 s3_16_12

	label variable s3_16_13 "M. Les femmes dont le partenaire a des antécédents d'écoulement pénien peuvent s"
	note s3_16_13: "M. Les femmes dont le partenaire a des antécédents d'écoulement pénien peuvent se faire insérer un DIU."
	label define s3_16_13 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_16_13 s3_16_13

	label variable s3_16_14 "N. La cliente doit contacter le prestataire si les saignements menstruels sont a"
	note s3_16_14: "N. La cliente doit contacter le prestataire si les saignements menstruels sont augmentés de deux fois en quantité et/ou en deux fois en durée après l'insertion d'un DIU."
	label define s3_16_14 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_16_14 s3_16_14

	label variable s3_16_15 "O. La mesure de la longueur de l'utérus est une étape critique dans la procédure"
	note s3_16_15: "O. La mesure de la longueur de l'utérus est une étape critique dans la procédure d'insertion du DIU."
	label define s3_16_15 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_16_15 s3_16_15

	label variable s3_16_16 "P. Le ruban mètre doit être utilisé pour mesurer la longueur de l’utérus lors de"
	note s3_16_16: "P. Le ruban mètre doit être utilisé pour mesurer la longueur de l’utérus lors de l’insertion d’un DIU."
	label define s3_16_16 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_16_16 s3_16_16

	label variable s3_16_17 "Q. Après un avortement chirurgical, il est recommandé l’application d'un antisep"
	note s3_16_17: "Q. Après un avortement chirurgical, il est recommandé l’application d'un antiseptique approprié (par exemple, povidone iodée ou chlohexidine) deux fois ou plus sur le col et le vagin en commençant par le canal cervical avant l'insertion de DIU."
	label define s3_16_17 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_16_17 s3_16_17

	label variable s3_16_18 "R. Le chargement du DIU sans contact empêche l'introduction d'une infection pend"
	note s3_16_18: "R. Le chargement du DIU sans contact empêche l'introduction d'une infection pendant la procédure d'insertion."
	label define s3_16_18 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_16_18 s3_16_18

	label variable s3_16_19 "S. Le diagramme OMS pour les critères d’éligibilité est utilisé pour vérifier l’"
	note s3_16_19: "S. Le diagramme OMS pour les critères d’éligibilité est utilisé pour vérifier l’éligibilité de la cliente à l‘administration d’un DIU."
	label define s3_16_19 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_16_19 s3_16_19

	label variable s3_16_20 "T. Certains DIU sont approuvés pour 10 ans d’utilisation après insertion."
	note s3_16_20: "T. Certains DIU sont approuvés pour 10 ans d’utilisation après insertion."
	label define s3_16_20 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_16_20 s3_16_20

	label variable s3_16_a "De quoi l'infirmière devrait-elle informer Sarah concernant le dispositif intra-"
	note s3_16_a: "De quoi l'infirmière devrait-elle informer Sarah concernant le dispositif intra-utérin (DIU) ?"
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
	label define s3_28_1 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_28_1 s3_28_1

	label variable s3_28_2 "B. Un examen pelvien est requis avant l’administration d’Injectable."
	note s3_28_2: "B. Un examen pelvien est requis avant l’administration d’Injectable."
	label define s3_28_2 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_28_2 s3_28_2

	label variable s3_28_3 "C. L’injectable peut être administré immédiatement ou dans les sept jours suivan"
	note s3_28_3: "C. L’injectable peut être administré immédiatement ou dans les sept jours suivant un avortement chirurgical."
	label define s3_28_3 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_28_3 s3_28_3

	label variable s3_28_4 "D. L’injectable peut être administré après 45 ans."
	note s3_28_4: "D. L’injectable peut être administré après 45 ans."
	label define s3_28_4 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_28_4 s3_28_4

	label variable s3_28_5 "E. Le retour à la fertilité après l'arrêt du DMPA injectable prend 12 mois après"
	note s3_28_5: "E. Le retour à la fertilité après l'arrêt du DMPA injectable prend 12 mois après la dernière injection."
	label define s3_28_5 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_28_5 s3_28_5

	label variable s3_28_6 "F. L’injectable protège du VIH et des IST."
	note s3_28_6: "F. L’injectable protège du VIH et des IST."
	label define s3_28_6 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_28_6 s3_28_6

	label variable s3_28_7 "G. Si l'injectable est administré au-delà du 7ème jour du cycle menstruel, les p"
	note s3_28_7: "G. Si l'injectable est administré au-delà du 7ème jour du cycle menstruel, les préservatifs doivent être conseillés comme solution de secours pendant une semaine."
	label define s3_28_7 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_28_7 s3_28_7

	label variable s3_28_8 "H. La méthode injectable peut être administrée par voie sous-cutanée."
	note s3_28_8: "H. La méthode injectable peut être administrée par voie sous-cutanée."
	label define s3_28_8 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_28_8 s3_28_8

	label variable s3_28_9 "I. Il est recommandé de reprendre le poids et la TA à chaque dose ultérieure."
	note s3_28_9: "I. Il est recommandé de reprendre le poids et la TA à chaque dose ultérieure."
	label define s3_28_9 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_28_9 s3_28_9

	label variable s3_28_10 "J. L’injection injectable doit être réfrigérée."
	note s3_28_10: "J. L’injection injectable doit être réfrigérée."
	label define s3_28_10 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_28_10 s3_28_10

	label variable s3_28_11 "K. L’hygiène des mains doit se faire après l'administration."
	note s3_28_11: "K. L’hygiène des mains doit se faire après l'administration."
	label define s3_28_11 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_28_11 s3_28_11

	label variable s3_28_12 "L. L'injectable peut être administré aux clientes atteintes d'un cancer du sein."
	note s3_28_12: "L. L'injectable peut être administré aux clientes atteintes d'un cancer du sein."
	label define s3_28_12 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_28_12 s3_28_12

	label variable s3_28_13 "M. L'injectable peut être administré aux clientes atteintes d'un cancer du col d"
	note s3_28_13: "M. L'injectable peut être administré aux clientes atteintes d'un cancer du col de l'utérus."
	label define s3_28_13 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_28_13 s3_28_13

	label variable s3_28_14 "N. L'injectable peut être administré aux clients dont la TA est > 160/100 mm Hg."
	note s3_28_14: "N. L'injectable peut être administré aux clients dont la TA est > 160/100 mm Hg."
	label define s3_28_14 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_28_14 s3_28_14

	label variable s3_28_15 "O. L'injectable a un effet sur la densité minérale osseuse."
	note s3_28_15: "O. L'injectable a un effet sur la densité minérale osseuse."
	label define s3_28_15 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_28_15 s3_28_15

	label variable s3_28_16 "P. Le traitement injectable peut être commencé immédiatement si la femme allaite"
	note s3_28_16: "P. Le traitement injectable peut être commencé immédiatement si la femme allaite."
	label define s3_28_16 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_28_16 s3_28_16

	label variable s3_28_17 "Q. L’injectable provoque des saignements intermenstruels ou une ménorragie."
	note s3_28_17: "Q. L’injectable provoque des saignements intermenstruels ou une ménorragie."
	label define s3_28_17 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_28_17 s3_28_17

	label variable s3_28_18 "R. L’injectable provoque une prise de poids."
	note s3_28_18: "R. L’injectable provoque une prise de poids."
	label define s3_28_18 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_28_18 s3_28_18

	label variable s3_28_19 "S. Si le saignement est deux fois plus long et deux fois plus abondant, une inte"
	note s3_28_19: "S. Si le saignement est deux fois plus long et deux fois plus abondant, une intervention médicale lourde est nécessaire."
	label define s3_28_19 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_28_19 s3_28_19

	label variable s3_28_20 "T. Les aiguilles après utilisation doivent être jetées dans la poubelle."
	note s3_28_20: "T. Les aiguilles après utilisation doivent être jetées dans la poubelle."
	label define s3_28_20 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_28_20 s3_28_20

	label variable s3_28_21 "U. Le recapuchonnage de l'aiguille usagée devrait être obligatoire."
	note s3_28_21: "U. Le recapuchonnage de l'aiguille usagée devrait être obligatoire."
	label define s3_28_21 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
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

	label variable s3_38 "338. Informez-vous les clientes des complications possibles après la pose de l'i"
	note s3_38: "338. Informez-vous les clientes des complications possibles après la pose de l'implant ?"
	label define s3_38 1 "Oui" 2 "Non"
	label values s3_38 s3_38

	label variable s3_39 "339. Quelles sont les complications possibles pour lesquelles la cliente doit re"
	note s3_39: "339. Quelles sont les complications possibles pour lesquelles la cliente doit retourner immédiatement à l'établissement ?"

	label variable s3_39a "339a. Préciser autre complication pouvant entrainer un retour à l'établissement."
	note s3_39a: "339a. Préciser autre complication pouvant entrainer un retour à l'établissement."

	label variable s3_40 "340. Quelles instructions et conseils donnez-vous à une femme après le retrait d"
	note s3_40: "340. Quelles instructions et conseils donnez-vous à une femme après le retrait des implants ?"

	label variable s3_40a "340a. Préciser autre instruction et conseils."
	note s3_40a: "340a. Préciser autre instruction et conseils."

	label variable s3_41_1 "A. Les implants offrent une protection de 3 à 5 ans contre une grossesse non dés"
	note s3_41_1: "A. Les implants offrent une protection de 3 à 5 ans contre une grossesse non désirée selon le type d'implant."
	label define s3_41_1 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_41_1 s3_41_1

	label variable s3_41_2 "B. L'implant doit être inséré sous la peau du bras non dominant."
	note s3_41_2: "B. L'implant doit être inséré sous la peau du bras non dominant."
	label define s3_41_2 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_41_2 s3_41_2

	label variable s3_41_3 "C. Le retour à la fertilité après le retrait de l'implant prend 12 mois."
	note s3_41_3: "C. Le retour à la fertilité après le retrait de l'implant prend 12 mois."
	label define s3_41_3 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_41_3 s3_41_3

	label variable s3_41_4 "D. L'implant ne peut pas être inséré chez une femme présentant une rupture prolo"
	note s3_41_4: "D. L'implant ne peut pas être inséré chez une femme présentant une rupture prolongée de la membrane."
	label define s3_41_4 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_41_4 s3_41_4

	label variable s3_41_5 "E. L'implant peut être donné à une femme après une Hémorragie du postpartum."
	note s3_41_5: "E. L'implant peut être donné à une femme après une Hémorragie du postpartum."
	label define s3_41_5 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_41_5 s3_41_5

	label variable s3_41_6 "F. L'implant devient efficace en 48 heures après l'insertion."
	note s3_41_6: "F. L'implant devient efficace en 48 heures après l'insertion."
	label define s3_41_6 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_41_6 s3_41_6

	label variable s3_41_7 "G. L'implant a un effet sur la densité minérale osseuse."
	note s3_41_7: "G. L'implant a un effet sur la densité minérale osseuse."
	label define s3_41_7 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_41_7 s3_41_7

	label variable s3_41_8 "H. L'implant doit être retiré par un prestataire de soins de santé qualifié."
	note s3_41_8: "H. L'implant doit être retiré par un prestataire de soins de santé qualifié."
	label define s3_41_8 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_41_8 s3_41_8

	label variable s3_41_9 "I. Les implants font partie des méthodes les plus efficaces et ont une action pr"
	note s3_41_9: "I. Les implants font partie des méthodes les plus efficaces et ont une action prolongée."
	label define s3_41_9 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_41_9 s3_41_9

	label variable s3_41_10 "J. Les implants ne doivent pas être insérés chez une femme qui allaite un bébé d"
	note s3_41_10: "J. Les implants ne doivent pas être insérés chez une femme qui allaite un bébé de moins de 6 semaines."
	label define s3_41_10 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_41_10 s3_41_10

	label variable s3_41_11 "K. Les implants ne doivent pas être insérés si une femme souffre d’une maladie g"
	note s3_41_11: "K. Les implants ne doivent pas être insérés si une femme souffre d’une maladie grave, d’une infection ou d’une tumeur dans le foie."
	label define s3_41_11 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_41_11 s3_41_11

	label variable s3_41_12 "L. Les implants ne doivent pas être insérés chez une femme atteinte d'un cancer "
	note s3_41_12: "L. Les implants ne doivent pas être insérés chez une femme atteinte d'un cancer du sein ."
	label define s3_41_12 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_41_12 s3_41_12

	label variable s3_41_13 "M. Les implants ne doivent pas être insérés chez une femme qui présente actuelle"
	note s3_41_13: "M. Les implants ne doivent pas être insérés chez une femme qui présente actuellement un caillot sanguin dans les veines profondes des jambes ou des poumons."
	label define s3_41_13 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_41_13 s3_41_13

	label variable s3_41_14 "N. Les implants ne se déplacent pas vers d’autres parties du corps."
	note s3_41_14: "N. Les implants ne se déplacent pas vers d’autres parties du corps."
	label define s3_41_14 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_41_14 s3_41_14

	label variable s3_41_15 "O. Une femme qui a choisi des implants doit être informée de ce qui se passe lor"
	note s3_41_15: "O. Une femme qui a choisi des implants doit être informée de ce qui se passe lors de l'insertion."
	label define s3_41_15 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_41_15 s3_41_15

	label variable s3_41_16 "P. La tige retirée et les articles contaminés (compresse, coton et autres articl"
	note s3_41_16: "P. La tige retirée et les articles contaminés (compresse, coton et autres articles) doivent être jetés dans la poubelle ."
	label define s3_41_16 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_41_16 s3_41_16

	label variable s3_41_17 "Q. Le client doit être orienté vers un établissement supérieur si la tige n'est "
	note s3_41_17: "Q. Le client doit être orienté vers un établissement supérieur si la tige n'est pas palpable ou palpable profondément."
	label define s3_41_17 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_41_17 s3_41_17

	label variable s3_41_18 "R. L'implant peut être localisé par radiographie bidimensionnelle."
	note s3_41_18: "R. L'implant peut être localisé par radiographie bidimensionnelle."
	label define s3_41_18 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
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
	label define s3_58_1 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_58_1 s3_58_1

	label variable s3_58_2 "B. La stérilisation féminine ne doit pas être associée à un avortement chirurgic"
	note s3_58_2: "B. La stérilisation féminine ne doit pas être associée à un avortement chirurgical."
	label define s3_58_2 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_58_2 s3_58_2

	label variable s3_58_3 "C. La stérilisation ne peut pas être pratiquée sur les femmes dont le taux d'hém"
	note s3_58_3: "C. La stérilisation ne peut pas être pratiquée sur les femmes dont le taux d'hémoglobine est inférieur à 7 g/dL."
	label define s3_58_3 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_58_3 s3_58_3

	label variable s3_58_4 "D. Il est acceptable d'effectuer une stérilisation sur une cliente atteinte d’un"
	note s3_58_4: "D. Il est acceptable d'effectuer une stérilisation sur une cliente atteinte d’une IST."
	label define s3_58_4 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_58_4 s3_58_4

	label variable s3_58_5 "E. Le dépistage du VIH est obligatoire avant de procéder à la stérilisation."
	note s3_58_5: "E. Le dépistage du VIH est obligatoire avant de procéder à la stérilisation."
	label define s3_58_5 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_58_5 s3_58_5

	label variable s3_58_6 "F. La présence d'anesthésistes est nécessaire pour la procédure de stérilisation"
	note s3_58_6: "F. La présence d'anesthésistes est nécessaire pour la procédure de stérilisation."
	label define s3_58_6 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_58_6 s3_58_6

	label variable s3_58_7 "G. La présence d'un membre de la famille auprès de la femme est nécessaire pour "
	note s3_58_7: "G. La présence d'un membre de la famille auprès de la femme est nécessaire pour la stérilisation."
	label define s3_58_7 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_58_7 s3_58_7

	label variable s3_58_8 "H. Le consentement du mari est obligatoire pour que les femmes puissent se faire"
	note s3_58_8: "H. Le consentement du mari est obligatoire pour que les femmes puissent se faire stériliser."
	label define s3_58_8 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_58_8 s3_58_8

	label variable s3_58_9 "I. Une nuitée est requise pour la stérilisation par laparoscopie."
	note s3_58_9: "I. Une nuitée est requise pour la stérilisation par laparoscopie."
	label define s3_58_9 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_58_9 s3_58_9

	label variable s3_58_10 "J. La procédure de stérilisation doit être différée chez les femmes ayant une Hb"
	note s3_58_10: "J. La procédure de stérilisation doit être différée chez les femmes ayant une Hb > 7 g/dl."
	label define s3_58_10 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_58_10 s3_58_10

	label variable s3_58_11 "K. La procédure de stérilisation doit être différée chez une femme qui est entre"
	note s3_58_11: "K. La procédure de stérilisation doit être différée chez une femme qui est entre 8 et 42 de post-partum."
	label define s3_58_11 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_58_11 s3_58_11

	label variable s3_58_12 "L. La procédure de stérilisation ne doit pas être différée chez une femme ayant "
	note s3_58_12: "L. La procédure de stérilisation ne doit pas être différée chez une femme ayant eu une grossesse avec une éclampsie ou une pré-éclampsie sévère."
	label define s3_58_12 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_58_12 s3_58_12

	label variable s3_58_13 "M. La procédure de stérilisation ne doit pas être différée chez une femme attein"
	note s3_58_13: "M. La procédure de stérilisation ne doit pas être différée chez une femme atteinte d'une maladie trophoblastique hamaligne."
	label define s3_58_13 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_58_13 s3_58_13

	label variable s3_58_14 "N. La procédure de stérilisation ne doit pas être différée chez une femme présen"
	note s3_58_14: "N. La procédure de stérilisation ne doit pas être différée chez une femme présentant actuellement une cervicite purulente, une chlamydia ou une gonorrhée."
	label define s3_58_14 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_58_14 s3_58_14

	label variable s3_58_15 "O. La procédure de stérilisation doit être abandonnée chez une femme souffrant a"
	note s3_58_15: "O. La procédure de stérilisation doit être abandonnée chez une femme souffrant actuellement d'une maladie de la vésicule biliaire."
	label define s3_58_15 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_58_15 s3_58_15

	label variable s3_58_16 "P. L'approche sous-ombilicale est appropriée dans la stérilisation post-partum."
	note s3_58_16: "P. L'approche sous-ombilicale est appropriée dans la stérilisation post-partum."
	label define s3_58_16 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_58_16 s3_58_16

	label variable s3_58_17 "Q. L'identification de la trompe lors d'une intervention par mini-tour doit être"
	note s3_58_17: "Q. L'identification de la trompe lors d'une intervention par mini-tour doit être effectuée avec une pince babcock."
	label define s3_58_17 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_58_17 s3_58_17

	label variable s3_58_18 "R. Il existe un risque de blessure d'une vessie pleine pendant l'intervention."
	note s3_58_18: "R. Il existe un risque de blessure d'une vessie pleine pendant l'intervention."
	label define s3_58_18 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
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
	label define s3_74_1 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_74_1 s3_74_1

	label variable s3_74_2 "B. Le dépistage du VIH est obligatoire avant de procéder à la stérilisation masc"
	note s3_74_2: "B. Le dépistage du VIH est obligatoire avant de procéder à la stérilisation masculine."
	label define s3_74_2 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_74_2 s3_74_2

	label variable s3_74_3 "C. La présence d'anesthésistes est nécessaire pour la procédure de stérilisation"
	note s3_74_3: "C. La présence d'anesthésistes est nécessaire pour la procédure de stérilisation masculine."
	label define s3_74_3 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_74_3 s3_74_3

	label variable s3_74_4 "D. La présence d'un membre de la famille avec les hommes est nécessaire pour la "
	note s3_74_4: "D. La présence d'un membre de la famille avec les hommes est nécessaire pour la stérilisation masculine."
	label define s3_74_4 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_74_4 s3_74_4

	label variable s3_74_5 "E. Le consentement de l'épouse est obligatoire pour qu'un homme puisse subir une"
	note s3_74_5: "E. Le consentement de l'épouse est obligatoire pour qu'un homme puisse subir une stérilisation masculine."
	label define s3_74_5 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_74_5 s3_74_5

	label variable s3_74_6 "F. Une nuitée est requise pour la stérilisation masculine."
	note s3_74_6: "F. Une nuitée est requise pour la stérilisation masculine."
	label define s3_74_6 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_74_6 s3_74_6

	label variable s3_74_7 "G. La stérilisation masculine n'est considérée comme réussie qu'après que l'anal"
	note s3_74_7: "G. La stérilisation masculine n'est considérée comme réussie qu'après que l'analyse du sperme montre un nombre nul de spermatozoïdes."
	label define s3_74_7 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s3_74_7 s3_74_7

	label variable s3_74_8 "H. Le préservatif doit être utilisé pour chaque acte sexuel pendant trois à six "
	note s3_74_8: "H. Le préservatif doit être utilisé pour chaque acte sexuel pendant trois à six mois après la stérilisation masculine."
	label define s3_74_8 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
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

	label variable s4_3_12 "L. Une femme qui est certaine de vouloir un espacement prolongé entre les enfant"
	note s4_3_12: "L. Une femme qui est certaine de vouloir un espacement prolongé entre les enfants est une bonne candidate pour le DIU."
	label define s4_3_12 1 "Tout à fait d'accord" 2 "D'accord" 3 "Neutre" 4 "Je ne suis pas d'accord" 5 "Fortement en désaccord"
	label values s4_3_12 s4_3_12

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
	note s4_9a: "409a. Scénario : Une femme de 30 ans nommée Maria se voit prescrire des pilules contraceptives à des fins de contraception. Elle se soucie de ne pas oublier de les prendre quotidiennement. Question : Comment l'infirmière devrait-elle répondre aux inquiétudes de Maria concernant le fait de ne pas oublier de prendre ses pilules contraceptives ?"

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

	label variable s5_1 "501. Selon vous, qui devrait être conseillé en matière de planification familial"
	note s5_1: "501. Selon vous, qui devrait être conseillé en matière de planification familiale ?"

	label variable autre_501 "Autre"
	note autre_501: "Autre"

	label variable s5_2 "502. Mme Y a 20 ans et a deux enfants vivants avec une différence d'âge de 2,5 a"
	note s5_2: "502. Mme Y a 20 ans et a deux enfants vivants avec une différence d'âge de 2,5 ans et elle ne souhaite pas avoir d'autres enfants à l'avenir. Veuillez expliquer ce que vous faites pour qu'elle puisse choisir une méthode."

	label variable autre_502 "Autre"
	note autre_502: "Autre"

	label variable s5_3 "503. Selon vous, quels sont les obstacles auxquels vous êtes confrontés lorsque "
	note s5_3: "503. Selon vous, quels sont les obstacles auxquels vous êtes confrontés lorsque vous fournissez des services de conseil en planification familiale aux femmes éligibles ?"

	label variable autre_503 "Autre"
	note autre_503: "Autre"

	label variable s5_4 "504. Fournissez-vous une référence pour une méthode que vous ne pouvez pas propo"
	note s5_4: "504. Fournissez-vous une référence pour une méthode que vous ne pouvez pas proposer dans votre établissement ?"
	label define s5_4 1 "Oui" 2 "Non"
	label values s5_4 s5_4

	label variable s5_5 "505. Sur quelle méthode passez-vous la majorité de votre temps à parler aux femm"
	note s5_5: "505. Sur quelle méthode passez-vous la majorité de votre temps à parler aux femmes ?"
	label define s5_5 1 "Stérilisation féminine" 2 "Stérilisation masculine" 3 "DIU" 4 "pillule" 5 "Injectable" 6 "CU" 7 "Préservatif MASCULIN" 8 "Préservatif feminin" 9 "MAMA." 10 "Autres (préciser)"
	label values s5_5 s5_5

	label variable autre_505 "Autre"
	note autre_505: "Autre"

	label variable s5_6 "506. Ressentez-vous une pression pour promouvoir une méthode spécifique ?"
	note s5_6: "506. Ressentez-vous une pression pour promouvoir une méthode spécifique ?"
	label define s5_6 1 "Oui" 2 "Non"
	label values s5_6 s5_6

	label variable s5_7 "Si oui, veuillez nommer la méthode ?"
	note s5_7: "Si oui, veuillez nommer la méthode ?"
	label define s5_7 1 "Stérilisation féminine" 2 "Stérilisation masculine" 3 "DIU" 4 "pillule" 5 "Injectable" 6 "CU" 7 "Préservatif MASCULIN" 8 "Préservatif feminin" 9 "MAMA." 10 "Autres (préciser)"
	label values s5_7 s5_7

	label variable autre_507 "Autre"
	note autre_507: "Autre"

	label variable s5_7aa "507aa. Scénario : DIARRA, une femme de 25 ans, se rend à la clinique de planning"
	note s5_7aa: "507aa. Scénario : DIARRA, une femme de 25 ans, se rend à la clinique de planning familial pour demander conseil sur les options contraceptives après s'être récemment mariée. Elle veut quelque chose de fiabl e mais s’inquiète des effets secondaires potentiels. Question : Quelle doit être la priorité de l'infirmière lors de la séance de conseil en contraception de DIARRA?"
	label define s5_7aa 1 "Recommander la stérilisation comme solution permanente" 2 "Explorer les préférences, le style de vie et les antécédents médicaux de DIARRA" 3 "Planifier un rendez-vous de suivi pour un examen pelvien" 4 "Prescrire une méthode contraceptive sans discussion"
	label values s5_7aa s5_7aa

	label variable s6_01 "601. Quels sont les signes de danger pour lesquels une femme enceinte doit être "
	note s6_01: "601. Quels sont les signes de danger pour lesquels une femme enceinte doit être évaluée à son arrivée pour l'accouchement ?"

	label variable autre_601 "Autre"
	note autre_601: "Autre"

	label variable s6_02 "602. En quoi consiste une évaluation initiale rapide ?"
	note s6_02: "602. En quoi consiste une évaluation initiale rapide ?"

	label variable autre_602 "Autre"
	note autre_602: "Autre"

	label variable s6_03 "603. EDD est calculé comme LMP+9 mois+7 jours. Cette déclaration est vraie ou fa"
	note s6_03: "603. EDD est calculé comme LMP+9 mois+7 jours. Cette déclaration est vraie ou fausse?"
	label define s6_03 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s6_03 s6_03

	label variable s6_04 "604. La grossesse à terme dure de 37 semaines complètes à 42 semaines complètes."
	note s6_04: "604. La grossesse à terme dure de 37 semaines complètes à 42 semaines complètes. Cette déclaration est vraie ou fausse?"
	label define s6_04 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s6_04 s6_04

	label variable s6_05 "605. Quelles informations clés collectez-vous sur les grossesses antérieures des"
	note s6_05: "605. Quelles informations clés collectez-vous sur les grossesses antérieures des femmes qui arrivent en travail ?"

	label variable autre_605 "Autre"
	note autre_605: "Autre"

	label variable s6_06 "606. Quel est le contenu d'un plateau d’accouchement ? SONDE : Veuillez parler d"
	note s6_06: "606. Quel est le contenu d'un plateau d’accouchement ? SONDE : Veuillez parler de la préparation du plateau d’accouchements"

	label variable autre_606 "Autre"
	note autre_606: "Autre"

	label variable s6_07 "607. Maintenant, j'aimerais en savoir plus sur la préparation des gouttières du "
	note s6_07: "607. Maintenant, j'aimerais en savoir plus sur la préparation des gouttières du nouveau- né. Quel est le contenu d'un plateau nouveau-né ?"

	label variable autre_607 "Autre"
	note autre_607: "Autre"

	label variable s6_08 "608. Maintenant, j'aimerais connaître les noms de ces articles dont vous assurez"
	note s6_08: "608. Maintenant, j'aimerais connaître les noms de ces articles dont vous assurez la disponibilité au niveau du coins de soins au nouveau né avant de procéder à l’accouchement?"

	label variable autre_608 "Autre"
	note autre_608: "Autre"

	label variable s6_09 "609. Comment identifiez-vous que la femme est anémique ?"
	note s6_09: "609. Comment identifiez-vous que la femme est anémique ?"

	label variable autre_609 "Autre"
	note autre_609: "Autre"

	label variable s6_10 "610. Quels sont les taux d’hémoglobine qui définissent une anémie sévère ?"
	note s6_10: "610. Quels sont les taux d’hémoglobine qui définissent une anémie sévère ?"

	label variable autre_610 "Autre"
	note autre_610: "Autre"

	label variable s6_11 "611. Quels sont les taux d’hémoglobine qui définissent une anémie très sévère ?"
	note s6_11: "611. Quels sont les taux d’hémoglobine qui définissent une anémie très sévère ?"

	label variable autre_611 "Autre"
	note autre_611: "Autre"

	label variable s6_12 "612.Quels sont les symptômes et les signes d’une anémie sévère ou très sévère ?"
	note s6_12: "612.Quels sont les symptômes et les signes d’une anémie sévère ou très sévère ?"

	label variable autre_612 "Préciser"
	note autre_612: "Préciser"

	label variable s6_13 "613. Quel est le médicament utilisé pour déparasiter les femmes enceintes ?"
	note s6_13: "613. Quel est le médicament utilisé pour déparasiter les femmes enceintes ?"

	label variable autre_613 "Autre"
	note autre_613: "Autre"

	label variable s6_14 "614. Quels sont les principaux symptômes/signes d’une dystocie ?"
	note s6_14: "614. Quels sont les principaux symptômes/signes d’une dystocie ?"

	label variable autre_614 "Autre"
	note autre_614: "Autre"

	label variable s6_15 "615.Quels sont les signes d’une hypertension gestationnelle ?"
	note s6_15: "615.Quels sont les signes d’une hypertension gestationnelle ?"

	label variable autre_615 "Autre"
	note autre_615: "Autre"

	label variable s6_16 "616.Le traitement de l'hypertension gestationnelle ne doit être instauré que lor"
	note s6_16: "616.Le traitement de l'hypertension gestationnelle ne doit être instauré que lorsque la tension artérielle diastolique est supérieure ou égale à 100 mmHg. Cette déclaration est vraie ou fausse?"
	label define s6_16 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s6_16 s6_16

	label variable s6_17 "617. Quel est le traitement de l'hypertension gestationnelle (TA diastolique <11"
	note s6_17: "617. Quel est le traitement de l'hypertension gestationnelle (TA diastolique <110 mmHg) ?"

	label variable autre_617 "Autre"
	note autre_617: "Autre"

	label variable s6_18 "618.Quels sont les signes d’une pré-éclampsie légère ?"
	note s6_18: "618.Quels sont les signes d’une pré-éclampsie légère ?"

	label variable autre_618 "Autre"
	note autre_618: "Autre"

	label variable s6_19 "619. Quels sont les signes/symptômes d’une pré-éclampsie sévère ?"
	note s6_19: "619. Quels sont les signes/symptômes d’une pré-éclampsie sévère ?"

	label variable autre_619 "Autre"
	note autre_619: "Autre"

	label variable s6_20 "620. Quel est le traitement principal de la pré- éclampsie sévère ?"
	note s6_20: "620. Quel est le traitement principal de la pré- éclampsie sévère ?"

	label variable autre_620 "Autre"
	note autre_620: "Autre"

	label variable s6_21 "621. Quels sont les signes/symptômes de l’éclampsie ?"
	note s6_21: "621. Quels sont les signes/symptômes de l’éclampsie ?"

	label variable autre_621 "Autre"
	note autre_621: "Autre"

	label variable s6_22 "622. Quels sont les composants (médicaments) de la prise en charge de l'éclampsi"
	note s6_22: "622. Quels sont les composants (médicaments) de la prise en charge de l'éclampsie ?"

	label variable autre_622 "Autre"
	note autre_622: "Autre"

	label variable s6_23 "623. Quels sont les signes de toxicité du sulfate de magnésium ?"
	note s6_23: "623. Quels sont les signes de toxicité du sulfate de magnésium ?"

	label variable autre_623 "Autre"
	note autre_623: "Autre"

	label variable s6_24 "624. Injection de l’Antidote du gluconate de calcium doit être administré aux ca"
	note s6_24: "624. Injection de l’Antidote du gluconate de calcium doit être administré aux cas de pré-éclampsie/éclampsie sévère qui sont sous traitement de sulfate de magnésium lorsque leur fréquence respiratoire devient <16/min. Cette déclaration est vraie ou fausse?"
	label define s6_24 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s6_24 s6_24

	label variable s6_25 "625. Quelles sont les principales causes d’hémorragie antepartum ?"
	note s6_25: "625. Quelles sont les principales causes d’hémorragie antepartum ?"

	label variable autre_625 "Autre"
	note autre_625: "Autre"

	label variable s6_26 "626. Quels sont les signes d’une rupture de l’utérus ?"
	note s6_26: "626. Quels sont les signes d’une rupture de l’utérus ?"

	label variable autre_626 "Autre"
	note autre_626: "Autre"

	label variable s6_27 "627. En cas de décollement placentaire, le saignement peut être dissimulé à l’in"
	note s6_27: "627. En cas de décollement placentaire, le saignement peut être dissimulé à l’intérieur de l’utérus et non visible à l’extérieur. Cette déclaration est vraie ou fausse?"
	label define s6_27 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s6_27 s6_27

	label variable s6_28 "628. Le saignement du placenta praevia est indolore, frais et rouge. Cette décla"
	note s6_28: "628. Le saignement du placenta praevia est indolore, frais et rouge. Cette déclaration est vraie ou fausse?"
	label define s6_28 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s6_28 s6_28

	label variable s6_29 "629. Un examen vaginal doit être effectué pour déterminer la cause de l'hémorrag"
	note s6_29: "629. Un examen vaginal doit être effectué pour déterminer la cause de l'hémorragie antepartum. Cette déclaration est vraie ou fausse?"
	label define s6_29 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s6_29 s6_29

	label variable s6_30 "630. Quels sont les signes et symptômes de la septicémie puerpérale ?"
	note s6_30: "630. Quels sont les signes et symptômes de la septicémie puerpérale ?"

	label variable autre_630 "Autre"
	note autre_630: "Autre"

	label variable s6_31 "631. Selon vous, à quelles semaines, lorsqu'une femme est appelée, elle est en t"
	note s6_31: "631. Selon vous, à quelles semaines, lorsqu'une femme est appelée, elle est en travail prématuré ?"

	label variable autre_631 "Autre"
	note autre_631: "Autre"

	label variable s6_32 "632. Comment diagnostique-t-on le travail prématuré ?"
	note s6_32: "632. Comment diagnostique-t-on le travail prématuré ?"

	label variable autre_632 "Autre"
	note autre_632: "Autre"

	label variable s6_33 "633. Quels sont les symptômes des fausses douleurs du travail ?"
	note s6_33: "633. Quels sont les symptômes des fausses douleurs du travail ?"

	label variable autre_633 "Autre"
	note autre_633: "Autre"

	label variable s6_34 "634. Quels sont les symptômes des véritables douleurs de l’accouchement ?"
	note s6_34: "634. Quels sont les symptômes des véritables douleurs de l’accouchement ?"

	label variable autre_634 "Autre"
	note autre_634: "Autre"

	label variable s6_35 "635. Quel doit être l’âge gestationnel pour administrer des corticostéroïdes pré"
	note s6_35: "635. Quel doit être l’âge gestationnel pour administrer des corticostéroïdes prénatals ?"

	label variable autre_635 "Autre"
	note autre_635: "Autre"

	label variable s6_36 "636. Un examen vaginal doit être effectué pour confirmer la rupture des membrane"
	note s6_36: "636. Un examen vaginal doit être effectué pour confirmer la rupture des membranes avant le travail. Cette déclaration est vraie ou fausse?"
	label define s6_36 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s6_36 s6_36

	label variable s6_37 "637. Quelles sont les étapes de prise en charge avant la référence en cas de rup"
	note s6_37: "637. Quelles sont les étapes de prise en charge avant la référence en cas de rupture des membranes avant le travail lors d'une grossesse à terme ?"

	label variable autre_637 "Autre"
	note autre_637: "Autre"

	label variable s6_38 "638. Quelles sont les étapes de prise en charge de la rupture prématurée des mem"
	note s6_38: "638. Quelles sont les étapes de prise en charge de la rupture prématurée des membranes avant le travail sans fièvre ?"

	label variable autre_638 "Autre"
	note autre_638: "Autre"

	label variable s6_39 "639. Quels sont les signes de l’ hémorragie du Postpartum?"
	note s6_39: "639. Quels sont les signes de l’ hémorragie du Postpartum?"

	label variable autre_639 "Autre"
	note autre_639: "Autre"

	label variable s6_40 "640. Quelles sont les évaluations requises/doivent être effectuées immédiatement"
	note s6_40: "640. Quelles sont les évaluations requises/doivent être effectuées immédiatement pour une femme atteinte de l’ hémorragie du Postpartum? ?"

	label variable autre_640 "Autre"
	note autre_640: "Autre"

	label variable s6_41 "641. Quelles sont les étapes de prise en charge d’un cas d’hémorragie du Postpar"
	note s6_41: "641. Quelles sont les étapes de prise en charge d’un cas d’hémorragie du Postpartum? ?"

	label variable autre_641 "Autre"
	note autre_641: "Autre"

	label variable s6_42 "642. Quels sont les signes et symptômes d’un choc ?"
	note s6_42: "642. Quels sont les signes et symptômes d’un choc ?"

	label variable autre_642 "Autre"
	note autre_642: "Autre"

	label variable s6_43 "643. Comment identifier une hemorragie postpartum atonique ?"
	note s6_43: "643. Comment identifier une hemorragie postpartum atonique ?"

	label variable autre_643 "Autre"
	note autre_643: "Autre"

	label variable s6_44 "644. Quand dit-on qu’il y’a une rétention placentaire?"
	note s6_44: "644. Quand dit-on qu’il y’a une rétention placentaire?"

	label variable autre_644 "Autre"
	note autre_644: "Autre"

	label variable s6_45 "645. Un compactage vaginal doit être réalisé pour les cas d' hemorragie postpart"
	note s6_45: "645. Un compactage vaginal doit être réalisé pour les cas d' hemorragie postpartum atonique référés au centre supérieur. Cette déclaration est vraie ou fausse?"
	label define s6_45 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s6_45 s6_45

	label variable s6_46 "646. Quelles sont les causes de l’ hemorragie postpartum ?"
	note s6_46: "646. Quelles sont les causes de l’ hemorragie postpartum ?"

	label variable autre_646 "Autre"
	note autre_646: "Autre"

	label variable s6_47 "647. Quand dit-on que la femme enceinte est au premier stade du travail ?"
	note s6_47: "647. Quand dit-on que la femme enceinte est au premier stade du travail ?"

	label variable autre_647 "Autre"
	note autre_647: "Autre"

	label variable s6_48 "648. Quelles informations sont tracées toutes les 30 minutes sur le partogramme "
	note s6_48: "648. Quelles informations sont tracées toutes les 30 minutes sur le partogramme ?"

	label variable autre_648 "Autre"
	note autre_648: "Autre"

	label variable s6_49 "649. Quelles informations sont reportées toutes les 4 heures sur le partogramme "
	note s6_49: "649. Quelles informations sont reportées toutes les 4 heures sur le partogramme ?"

	label variable autre_649 "Autre"
	note autre_649: "Autre"

	label variable s6_50 "650. La température maternelle est relevée toutes les 2 heures sur le partogramm"
	note s6_50: "650. La température maternelle est relevée toutes les 2 heures sur le partogramme. Cette déclaration est vraie ou fausse?"
	label define s6_50 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s6_50 s6_50

	label variable s6_51 "651. Quand dit-on que la mère est en travail actif ?"
	note s6_51: "651. Quand dit-on que la mère est en travail actif ?"

	label variable autre_651 "Autre"
	note autre_651: "Autre"

	label variable s6_52 "652. Comment identifierez-vous un cas de travail prolongé à partir des lectures "
	note s6_52: "652. Comment identifierez-vous un cas de travail prolongé à partir des lectures du partogramme ?"

	label variable autre_652 "Autre"
	note autre_652: "Autre"

	label variable s6_53 "653. L'épisiotomie est obligatoire pour tous les accouchements primi gravida. Ce"
	note s6_53: "653. L'épisiotomie est obligatoire pour tous les accouchements primi gravida. Cette déclaration est vraie ou fausse?"
	label define s6_53 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s6_53 s6_53

	label variable s6_54 "654. Quelle est la troisième étape du travail ?"
	note s6_54: "654. Quelle est la troisième étape du travail ?"

	label variable autre_654 "Autre"
	note autre_654: "Autre"

	label variable s6_55 "655. Dans quels cas faut-il faire la GATPA ?"
	note s6_55: "655. Dans quels cas faut-il faire la GATPA ?"

	label variable autre_655 "Autre"
	note autre_655: "Autre"

	label variable s6_56 "656. Quelles sont les étapes de la prise en charge active du troisième stade du "
	note s6_56: "656. Quelles sont les étapes de la prise en charge active du troisième stade du travail ?"

	label variable autre_656 "Autre"
	note autre_656: "Autre"

	label variable s6_57 "657. Quelle Quelle est la dose appropriée d’ocytocine pour la GATPA ? la troisiè"
	note s6_57: "657. Quelle Quelle est la dose appropriée d’ocytocine pour la GATPA ? la troisième étape du travail ?"

	label variable autre_657 "Autre"
	note autre_657: "Autre"

	label variable s6_58 "658. Quelle est la voie appropriée pour administrer l’ocytocine pour la GATPA ?"
	note s6_58: "658. Quelle est la voie appropriée pour administrer l’ocytocine pour la GATPA ?"

	label variable autre_658 "Autre"
	note autre_658: "Autre"

	label variable s6_59 "659. Pouvez-vous me dire quand administreriez-vous de l'ocytocine ?"
	note s6_59: "659. Pouvez-vous me dire quand administreriez-vous de l'ocytocine ?"

	label variable autre_659 "Autre"
	note autre_659: "Autre"

	label variable s6_60 "660. Quelle est la température idéale pendant l’approvisionnement et le stockage"
	note s6_60: "660. Quelle est la température idéale pendant l’approvisionnement et le stockage de l’ocytocine ?"

	label variable autre_660 "Autre"
	note autre_660: "Autre"

	label variable s6_61 "661. Quelles sont les composantes des soins essentiels au nouveau-né ?"
	note s6_61: "661. Quelles sont les composantes des soins essentiels au nouveau-né ?"

	label variable autre_661 "Autre"
	note autre_661: "Autre"

	label variable s6_62 "662. La table chauffante ne doit pas être allumé pour tous les accouchements. Ce"
	note s6_62: "662. La table chauffante ne doit pas être allumé pour tous les accouchements. Cette déclaration est vraie ou fausse?"
	label define s6_62 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s6_62 s6_62

	label variable s6_63 "663. La température de la salle de travail doit être de 25 à 28°C. Cette déclara"
	note s6_63: "663. La température de la salle de travail doit être de 25 à 28°C. Cette déclaration est vraie ou fausse?"
	label define s6_63 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s6_63 s6_63

	label variable s6_64 "664. Pouvez-vous me dire quelles mesures vous prendriez immédiatement si le nouv"
	note s6_64: "664. Pouvez-vous me dire quelles mesures vous prendriez immédiatement si le nouveau- né ne respire pas ou ne pleure pas à la naissance ?"

	label variable autre_664 "Autre"
	note autre_664: "Autre"

	label variable s6_65 "665. Pouvez-vous me dire les étapes que vous suivriez si le nouveau-né ne respir"
	note s6_65: "665. Pouvez-vous me dire les étapes que vous suivriez si le nouveau-né ne respire pas / ne pleure pas après 30 secondes de suivi des étapes ci-dessus ?"

	label variable autre_665 "Autre"
	note autre_665: "Autre"

	label variable s6_66 "666. Pourquoi l’asphyxie à la naissance se produit-elle ?"
	note s6_66: "666. Pourquoi l’asphyxie à la naissance se produit-elle ?"

	label variable autre_666 "Autre"
	note autre_666: "Autre"

	label variable s6_67 "667. Qu'entendez-vous par la minute d’or ?"
	note s6_67: "667. Qu'entendez-vous par la minute d’or ?"

	label variable autre_667 "Autre"
	note autre_667: "Autre"

	label variable s6_68 "668. Combien de temps le ballon et le masque sont-ils utilisés pour réanimer le "
	note s6_68: "668. Combien de temps le ballon et le masque sont-ils utilisés pour réanimer le bébé ?"

	label variable autre_668 "Autre"
	note autre_668: "Autre"

	label variable s6_69 "669. Quelles sont les caractéristiques cliniques du sepsis néonatal ?"
	note s6_69: "669. Quelles sont les caractéristiques cliniques du sepsis néonatal ?"

	label variable autre_669 "Autre"
	note autre_669: "Autre"

	label variable s6_70 "670. Quels sont les médicaments pour la prise en charge du sepsis néonatal ?"
	note s6_70: "670. Quels sont les médicaments pour la prise en charge du sepsis néonatal ?"

	label variable autre_670 "Autre"
	note autre_670: "Autre"

	label variable s6_71 "671. Qu'est-ce que la 4 ème étape du travail ?"
	note s6_71: "671. Qu'est-ce que la 4 ème étape du travail ?"
	label define s6_71 1 "2 heures d'observation maternelle et néonatale dès l'expulsion du placenta" 2 "Autres, préciser" 3 "Je ne sais pas"
	label values s6_71 s6_71

	label variable autre_671 "Autre"
	note autre_671: "Autre"

	label variable s6_72 "672. Les observations de la mère et du nouveau-né sont effectuées toutes les 30 "
	note s6_72: "672. Les observations de la mère et du nouveau-né sont effectuées toutes les 30 minutes au 4 ème stade du travail. Cette déclaration est vraie ou fausse?"
	label define s6_72 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s6_72 s6_72

	label variable s6_73 "673. Quels paramètres sont mesurés chez la mère au 4ème stade du travail ?"
	note s6_73: "673. Quels paramètres sont mesurés chez la mère au 4ème stade du travail ?"

	label variable autre_673 "Autre"
	note autre_673: "Autre"

	label variable s6_74 "674. Quels paramètres sont mesurés chez le nouveau-né au 4ème stade du travail ?"
	note s6_74: "674. Quels paramètres sont mesurés chez le nouveau-né au 4ème stade du travail ?"

	label variable autre_674 "Autre"
	note autre_674: "Autre"

	label variable s6_75 "675. Quelle doit être la position de la mère avant de commencer à allaiter ?"
	note s6_75: "675. Quelle doit être la position de la mère avant de commencer à allaiter ?"
	label define s6_75 1 "N'importe quelle position confortable" 7 "Autre" 8 "Je ne sais pas"
	label values s6_75 s6_75

	label variable autre_675 "Autre"
	note autre_675: "Autre"

	label variable s6_76 "676. Quels points inspecter au niveau du sein lors du début de l'allaitement ?"
	note s6_76: "676. Quels points inspecter au niveau du sein lors du début de l'allaitement ?"

	label variable autre_676 "Autre"
	note autre_676: "Autre"

	label variable s6_77 "677. Quels sont les quatre signes d’une position correcte ?"
	note s6_77: "677. Quels sont les quatre signes d’une position correcte ?"

	label variable autre_677 "Autre"
	note autre_677: "Autre"

	label variable s6_78 "678. Quels sont les quatre signes d’un attachement correct ?"
	note s6_78: "678. Quels sont les quatre signes d’un attachement correct ?"

	label variable autre_678 "Autre"
	note autre_678: "Autre"

	label variable s6_79 "679. Quelle doit être la fréquence d’allaitement sur 24 heures, nuit comprise ?"
	note s6_79: "679. Quelle doit être la fréquence d’allaitement sur 24 heures, nuit comprise ?"

	label variable autre_679 "Autre"
	note autre_679: "Autre"

	label variable s6_80 "680. Quels sont les éléments clés de la méthode Mére Kangourou ?"
	note s6_80: "680. Quels sont les éléments clés de la méthode Mére Kangourou ?"

	label variable autre_680 "Autre"
	note autre_680: "Autre"

	label variable s6_81 "681. Combien de temps le contact peau à peau doit-il être maintenu dans les 24 h"
	note s6_81: "681. Combien de temps le contact peau à peau doit-il être maintenu dans les 24 heures ?"
	label define s6_81 1 "4 heures" 2 "5-8 heures" 3 "9-12 heures" 4 "Autres, préciser" 5 "Je ne sais pas"
	label values s6_81 s6_81

	label variable autre_681 "Autre"
	note autre_681: "Autre"

	label variable s6_82 "682. Quels sont les avantages de la méthode Mére Kangourou ?"
	note s6_82: "682. Quels sont les avantages de la méthode Mére Kangourou ?"

	label variable autre_682 "Autre"
	note autre_682: "Autre"

	label variable s6_83 "683. Quels vaccins sont administrés en salle de travail ?"
	note s6_83: "683. Quels vaccins sont administrés en salle de travail ?"

	label variable autre_683 "Autre"
	note autre_683: "Autre"

	label variable s6_84a "A. Il est important de garantir la confidentialité des femmes pendant les examen"
	note s6_84a: "A. Il est important de garantir la confidentialité des femmes pendant les examens et les procédures, ainsi que de protéger la confidentialité de leurs informations médicales."
	label define s6_84a 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s6_84a s6_84a

	label variable s6_84b "B. Les femmes devraient être autorisées à avoir un compagnon choisi (tel qu'un p"
	note s6_84b: "B. Les femmes devraient être autorisées à avoir un compagnon choisi (tel qu'un partenaire, un membre de la famille ou un accompagnant) présent pendant le travail et l'accouchement pour fournir un soutien émotionnel et des conseils."
	label define s6_84b 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s6_84b s6_84b

	label variable s6_84c "C. Les interventions médicales inutiles, telles que les épisiotomies de routine,"
	note s6_84c: "C. Les interventions médicales inutiles, telles que les épisiotomies de routine, la surveillance fœtale continue et les césariennes électives, doivent être évitées à moins d'être médicalement justifiées et avec un consentement éclairé."
	label define s6_84c 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s6_84c s6_84c

	label variable s6_84d "D. Les femmes doivent être informées de tous les examens et procédures"
	note s6_84d: "D. Les femmes doivent être informées de tous les examens et procédures"
	label define s6_84d 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s6_84d s6_84d

	label variable s6_84e "E. Les femmes ne devraient pas être soumises à des violences physiques ou verbal"
	note s6_84e: "E. Les femmes ne devraient pas être soumises à des violences physiques ou verbales"
	label define s6_84e 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s6_84e s6_84e

	label variable s6_84f "F. Une pression utérine doit être appliquée si la mère est épuisée et incapable "
	note s6_84f: "F. Une pression utérine doit être appliquée si la mère est épuisée et incapable de pousser le bébé vers l'extérieur."
	label define s6_84f 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s6_84f s6_84f

	label variable s6_84g "G. Une augmentation de l'injection d'ocytocine doit être effectuée dans tous les"
	note s6_84g: "G. Une augmentation de l'injection d'ocytocine doit être effectuée dans tous les cas au cours de la phase 1 du travail."
	label define s6_84g 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values s6_84g s6_84g

	label variable s7_01a "A. Lorsque les femmes n'appuient pas au 2ème temps, il faut exercer une pression"
	note s7_01a: "A. Lorsque les femmes n'appuient pas au 2ème temps, il faut exercer une pression fundique"
	label define s7_01a 1 "Tout à fait d’accord" 2 "D’accord" 3 "Neutre" 4 "Je ne suis pas d’accord" 5 "Fortement en désaccord"
	label values s7_01a s7_01a

	label variable s7_01b "B. Il n'est pas nécessaire d'avoir ou de tirer des rideaux dans la salle de trav"
	note s7_01b: "B. Il n'est pas nécessaire d'avoir ou de tirer des rideaux dans la salle de travail s'il n'y a que des femmes dans la pièce."
	label define s7_01b 1 "Tout à fait d’accord" 2 "D’accord" 3 "Neutre" 4 "Je ne suis pas d’accord" 5 "Fortement en désaccord"
	label values s7_01b s7_01b

	label variable s7_01c "C. Bien que le partogramme mentionne de faire l’examen pelvien seulement à 4 heu"
	note s7_01c: "C. Bien que le partogramme mentionne de faire l’examen pelvien seulement à 4 heures d'intervalle, il est parfois nécessaire de le faire fréquemment en fonction de la demande du client ou de son compagnon."
	label define s7_01c 1 "Tout à fait d’accord" 2 "D’accord" 3 "Neutre" 4 "Je ne suis pas d’accord" 5 "Fortement en désaccord"
	label values s7_01c s7_01c

	label variable s7_01d "D. Il n'est pas nécessaire de remplir le partogramme car nous notons déjà mental"
	note s7_01d: "D. Il n'est pas nécessaire de remplir le partogramme car nous notons déjà mentalement les résultats de l’examen pelvien et pouvons revérifier à nouveau."
	label define s7_01d 1 "Tout à fait d’accord" 2 "D’accord" 3 "Neutre" 4 "Je ne suis pas d’accord" 5 "Fortement en désaccord"
	label values s7_01d s7_01d

	label variable s7_01e "E. Le bruit du cœur fœtal mesuré à l'admission est suffisant pour indiquer l'éta"
	note s7_01e: "E. Le bruit du cœur fœtal mesuré à l'admission est suffisant pour indiquer l'état du fœtus et il n'est pas nécessaire de le mesurer toutes les 30 minutes car cela n'affecte pas le pronostic du nouveau-né."
	label define s7_01e 1 "Tout à fait d’accord" 2 "D’accord" 3 "Neutre" 4 "Je ne suis pas d’accord" 5 "Fortement en désaccord"
	label values s7_01e s7_01e

	label variable s7_01f "F. Autoriser le compagnon de naissance dans la salle de travail entrave le trava"
	note s7_01f: "F. Autoriser le compagnon de naissance dans la salle de travail entrave le travail et peut créer des problèmes"
	label define s7_01f 1 "Tout à fait d’accord" 2 "D’accord" 3 "Neutre" 4 "Je ne suis pas d’accord" 5 "Fortement en désaccord"
	label values s7_01f s7_01f

	label variable s7_01g "G. Il est possible de couper le cordon avec des ciseaux/une lame après l'avoir s"
	note s7_01g: "G. Il est possible de couper le cordon avec des ciseaux/une lame après l'avoir simplement lavé à l'eau s'il n'y a pas de sang visible dessus lors de l'accouchement précédent."
	label define s7_01g 1 "Tout à fait d’accord" 2 "D’accord" 3 "Neutre" 4 "Je ne suis pas d’accord" 5 "Fortement en désaccord"
	label values s7_01g s7_01g

	label variable s7_01h "H. Il est difficile de commencer à allaiter dans l'heure qui suit car il n'y a p"
	note s7_01h: "H. Il est difficile de commencer à allaiter dans l'heure qui suit car il n'y a pratiquement pas de lait et les seins ont besoin d'être nettoyés."
	label define s7_01h 1 "Tout à fait d’accord" 2 "D’accord" 3 "Neutre" 4 "Je ne suis pas d’accord" 5 "Fortement en désaccord"
	label values s7_01h s7_01h

	label variable s7_01i "I.Les soins peau à peau pendant 1 heure après l'accouchement ne sont ni réalisab"
	note s7_01i: "I.Les soins peau à peau pendant 1 heure après l'accouchement ne sont ni réalisables ni nécessaires"
	label define s7_01i 1 "Tout à fait d’accord" 2 "D’accord" 3 "Neutre" 4 "Je ne suis pas d’accord" 5 "Fortement en désaccord"
	label values s7_01i s7_01i

	label variable s7_01j "J.Un accouchement normal ne peut pas avoir lieu si l'injection d'ocytocine n'est"
	note s7_01j: "J.Un accouchement normal ne peut pas avoir lieu si l'injection d'ocytocine n'est pas administrée pendant le travail"
	label define s7_01j 1 "Tout à fait d’accord" 2 "D’accord" 3 "Neutre" 4 "Je ne suis pas d’accord" 5 "Fortement en désaccord"
	label values s7_01j s7_01j

	label variable s7_01k "K. La plupart des cas d'asphyxie à la naissance surviennent parce que les femmes"
	note s7_01k: "K. La plupart des cas d'asphyxie à la naissance surviennent parce que les femmes ne poussent pas correctement au cours de la deuxième étape du travail."
	label define s7_01k 1 "Tout à fait d’accord" 2 "D’accord" 3 "Neutre" 4 "Je ne suis pas d’accord" 5 "Fortement en désaccord"
	label values s7_01k s7_01k

	label variable s7_01l "L.Le sexe du bébé ne doit pas être révélé à la mère car cela peut conduire à une"
	note s7_01l: "L.Le sexe du bébé ne doit pas être révélé à la mère car cela peut conduire à une Hemorragie postpartum."
	label define s7_01l 1 "Tout à fait d’accord" 2 "D’accord" 3 "Neutre" 4 "Je ne suis pas d’accord" 5 "Fortement en désaccord"
	label values s7_01l s7_01l

	label variable s7_01m "M. La femme ne doit ni manger ni boire pendant le travail car cela provoquerait "
	note s7_01m: "M. La femme ne doit ni manger ni boire pendant le travail car cela provoquerait des vomissements."
	label define s7_01m 1 "Tout à fait d’accord" 2 "D’accord" 3 "Neutre" 4 "Je ne suis pas d’accord" 5 "Fortement en désaccord"
	label values s7_01m s7_01m

	label variable s7_01n "N. Un lavement doit être administré à toutes les femmes en travail car il accélè"
	note s7_01n: "N. Un lavement doit être administré à toutes les femmes en travail car il accélère le processus d'accouchement."
	label define s7_01n 1 "Tout à fait d’accord" 2 "D’accord" 3 "Neutre" 4 "Je ne suis pas d’accord" 5 "Fortement en désaccord"
	label values s7_01n s7_01n

	label variable s7_01o "O. L'étape la plus importante de la réanimation d'un nouveau-né consiste à stimu"
	note s7_01o: "O. L'étape la plus importante de la réanimation d'un nouveau-né consiste à stimuler le dos du nouveau-né."
	label define s7_01o 1 "Tout à fait d’accord" 2 "D’accord" 3 "Neutre" 4 "Je ne suis pas d’accord" 5 "Fortement en désaccord"
	label values s7_01o s7_01o

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
		foreach rgvar of varlist s2_27autre_* {
			label variable `rgvar' "Préciser autre raison"
			note `rgvar': "Préciser autre raison"
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
*   Corrections file path and filename:  C:/Users/pkaberia/Dropbox//FP-Project-APHRC-UM/Atelier_FP/Codes//QUESTIONNAIRE INFIRMIER & SAGE-FEMME_corrections.csv
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
