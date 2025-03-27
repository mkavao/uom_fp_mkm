* import_asc_corr.do
*
* 	Imports and aggregates "QUESTIONNAIRE ASC" (ID: asc_corr) data.
*
*	Inputs:  "C:/Users/pkaberia/Dropbox//FP-Project-APHRC-UM/Atelier_FP/Codes//QUESTIONNAIRE ASC_WIDE.csv"
*	Outputs: "C:/Users/pkaberia/Dropbox//FP-Project-APHRC-UM/Atelier_FP/Data/Donnees brutes//QUESTIONNAIRE ASC.dta"
*
*	Output by SurveyCTO February 14, 2025 1:50 PM.

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
local csvfile "C:/Users/pkaberia/Dropbox//FP-Project-APHRC-UM/Atelier_FP/Codes//QUESTIONNAIRE ASC_WIDE.csv"
local dtafile "C:/Users/pkaberia/Dropbox//FP-Project-APHRC-UM/Atelier_FP/Data/Donnees brutes//QUESTIONNAIRE ASC.dta"
local corrfile "C:/Users/pkaberia/Dropbox//FP-Project-APHRC-UM/Atelier_FP/Codes//QUESTIONNAIRE ASC_corrections.csv"
local note_fields1 ""
local text_fields1 "deviceid devicephonenum username i4a q108 q109 autre_travail q208 autre_asc q209 autres_motivation autres_contrat q311 autre_311 q314 autre_314 q401 autre_domaine_sante q402 autre q403 autre_403 q502"
local text_fields2 "autre_502 autre_506 autres_507 q602 autre_602 q604 autre_604 q605 autre_605 q607 autre_607 q610 q610b autre_610 q611 autre_611 q612 autre_612 q613 autre_613 q617 q617_autre q618 autre_618 q619"
local text_fields3 "autre_619 q621 autre_621 q622 autre_622 q624 autre_624 autre_625 q627 autre_627 q628 autre_628 q632 autre_632 q633 autre_633 q634 autre_634 q639 autre_639 q640 autre_640 autre_641 autre_642 q643"
local text_fields4 "autre_643 q654 autre_654 q655 autre_655 q657 autre_657 q658 autre_658 q660 autre_660 q701 autre_701 autre_703 autre_704 autre_705 q708 autre_708 q709 autre_709 q710 autre_710 autre_712 q714 autre_714"
local text_fields5 "q715 autre_715 q716 autre_716 autre_717 autre_719 q720 autre_720 q721 autre_721 q722 autre_722 autre_723 autre_724 autre_725 autre_726 autre_727 autre_728 autre_729 autre_730 autre_731 q801"
local text_fields6 "grp_801_ind_count numero_benef_* code_benef_* type_benef_* q802 grp_802_count numero_fourni_* code_fourni_* type_fourni_* q804 autre_804 q806 autre_806 q808 autre_808 q811 autre_811 note_interviewer"
local text_fields7 "instanceid"
local date_fields1 "q503_date"
local datetime_fields1 "submissiondate starttime endtime"

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
	label define i3 1 "CS Gaspard Camara" 2 "CS Grand Dakar" 3 "CS HLM" 4 "CS Hann Mer" 5 "CS Liberté 6 (Mamadou DIOP)" 6 "CS Mariste" 7 "EPS Hopital de Fann" 8 "PS Bel Air" 9 "PS Bourguiba" 10 "PS Derkle" 11 "PS Fann Hock" 12 "PS Georges Lahoud" 13 "PS HLM" 14 "PS Hann Sur Mer" 15 "PS Hann Village" 16 "PS Liberte 2" 17 "PS Liberte 6" 18 "CS Abdoul Aziz SY Dabakh" 19 "CS Camberene" 20 "CS Nabil Choucair" 21 "CS SAMU Municipal Grand Yoff" 22 "EPS Hoggy" 23 "PS Camberene" 24 "PS Grand Medine" 25 "PS Grand Yoff 2" 26 "PS Grand Yoff I" 27 "PS HLM Grand Yoff" 28 "PS Khar Yalla" 29 "PS Norade" 30 "PS Unite 16" 31 "PS Unite 22" 32 "PS Unite 8" 33 "PS Unite 9" 34 "PS Unité 26" 35 "CS Annette Mbaye Derneville" 36 "CS Municipal de Ouakam" 37 "CS Ngor" 38 "CS Philippe Senghor" 39 "EPS Hôpital Militaire de Ouakam (Hmo)" 40 "PS Apecsy 1" 41 "PS Cité Avion" 42 "PS Communautaire de Tonghor" 43 "PS Diamalaye" 44 "PS Liberte 4" 45 "PS Mermoz" 46 "PS Yoff" 47 "CS Cheikh Ahmadou Bamba Mbacke" 48 "CS Colobane" 49 "CS Elisabeth Diouf" 50 "CS Keur Yaye Sylvie" 51 "CS Plateau" 52 "EPS Institut Hygiene Sociale" 53 "EPS Hopital Abass Ndao" 54 "EPS Hopital Principal" 55 "INFIRMERIE HOPITAL DE LA GENDARMERIE ( Ex Gendarmerie Colobane)" 56 "PS THIEUDEME (privé)" 57 "PS Goree" 58 "PS HLM Fass" 59 "PS Raffenel" 60 "PS Sandial" 61 "PS Service D'Hygiene" 62 "CS Diamniadio" 63 "CS Ndiaye Diouf" 64 "EPS Hôpital d'Enfant Diamniadio" 65 "PS Bargny Guedji" 66 "PS Dougar" 67 "PS Kip Carrieres" 68 "PS Missirah" 69 "PS Ndiolmane" 70 "PS Ndoukhoura Peulh" 71 "PS Ndoyénne" 72 "PS Niangal" 73 "PS Sebi Ponty" 74 "PS Sebikotane" 75 "PS Sendou" 76 "PS Yenne" 77 "CS Wakhinane" 78 "EPS Dalal Jamm" 79 "EPS Roi Baudoin" 80 "PS Daroukhane" 81 "PS Darourakhmane" 82 "PS Fith Mith" 83 "PS Golfe Sud" 84 "PS HLM Las Palmas" 85 "PS Hamo Tefess" 86 "PS Hamo V" 87 "PS Medina Gounass" 88 "PS Nimzath" 89 "PS Parcelles Assainies Unite 4" 90 "CS Keur Massar" 91 "PS Mme Fatou BA" 92 "PS Aladji Pathe" 93 "PS Boune" 94 "PS Jaxaaye" 95 "PS Keur Massar Village" 96 "PS Malika" 97 "PS Malika Sonatel" 98 "PS Parcelle Assainie Keur Massar" 99 "CS Khadim Rassoul" 100 "EPS Pikine" 101 "EPS Psychiatrique de Thiaroye" 102 "PS CAPEC" 103 "PS Diacksao" 104 "PS Diamegueune" 105 "PS Fass Mbao" 106 "PS Grand Mbao" 107 "PS Kamb" 108 "PS Mbao Gare" 109 "PS Nassroulah" 110 "PS Petit Mbao" 111 "PS Taif" 112 "PS Thiaroye Azur" 113 "PS Thiaroye Gare" 114 "PS Thiaroye Sur Mer" 115 "PS la Rochette" 116 "CS Dominique" 117 "PS Dalifort" 118 "PS Darou Khoudoss" 119 "PS Darou Salam" 120 "PS Deggo" 121 "PS Guinaw Rail Nord" 122 "PS Guinaw Rail Sud" 123 "PS Khourounar" 124 "PS Municipal 1" 125 "PS Municipal 2" 126 "PS Pepiniere" 127 "PS Santa Yalla" 128 "PS Touba Diack Sao" 129 "CS Polyclinique" 130 "CS SOCOCIM" 131 "EPS Youssou Mbargane Diop" 132 "PS Arafat" 133 "PS Dangou" 134 "PS Diokoul Kher" 135 "PS Diokoul Wague" 136 "PS Diorga" 137 "PS Fass" 138 "PS Gouye Mouride" 139 "PS HLM" 140 "PS Keury Souf" 141 "PS Nimzath" 142 "PS TACO" 143 "PS Thiawlene" 144 "CS Sangalkam" 145 "PS Apix" 146 "PS Bambilor" 147 "PS Cite Gendarmerie" 148 "PS Denes" 149 "PS Gorome" 150 "PS Gorome 2" 151 "PS Keur Ndiaye Lo" 152 "PS Kounoune" 153 "PS Lébougui 2000" 154 "PS Medina Thioub" 155 "PS Niacourab" 156 "PS Niague" 157 "PS Tawfekh" 158 "PS Tivaoune Peulh" 159 "PS Wayembam" 160 "CS yeumbeul" 161 "PS Darou Salam 6" 162 "PS Darourahmane 2" 163 "PS Gallo Dia" 164 "PS Thiaroye Miname" 165 "PS Yeumbeul Ainoumady Sotrac" 166 "PS Yeumbeul Diamalaye" 167 "PS Yeumbeul Sud" 168 "PS cheikh Sidaty FALL" 169 "PS Ndondol" 170 "CS Bambey" 171 "PS Aguiyaye" 172 "PS Baba Garage" 173 "PS Bambay Serere" 174 "PS Bambeye Serere 2" 175 "PS Batal" 176 "PS DVF" 177 "PS Dinguiraye" 178 "PS Gatte" 179 "PS Gawane" 180 "PS Gourgourène" 181 "PS Keur Madiop" 182 "PS Keur Samba Kane" 183 "PS Lambaye" 184 "PS Leona" 185 "PS Mekhe Lambaye" 186 "PS N'dangalma" 187 "PS Ndeme Meissa" 188 "PS Ndereppe" 189 "PS Ndiakalack" 190 "PS Ngogom" 191 "PS Ngoye" 192 "PS Pallene" 193 "PS Refane" 194 "PS Reomao" 195 "PS Silane" 196 "PS Sokano" 197 "PS Tawa Fall" 198 "PS Thiakhar" 199 "PS Thieppe" 200 "PS Thieytou" 201 "PS Mme Elisabeth Diouf" 202 "CS Diourbel" 203 "CS Ndindy" 204 "EPS Lubke de Diourbel" 205 "PS Cheikh Anta" 206 "PS Dankh Sene" 207 "PS Gade Escale" 208 "PS Grand Diourbel" 209 "PS Keur Ngalgou" 210 "PS Keur Ngana" 211 "PS Keur Serigne Mbaye Sarr" 212 "PS Lagnar" 213 "PS Medinatoul" 214 "PS Ndayane" 215 "PS Ndoulo" 216 "PS Patar" 217 "PS Sareme Wolof" 218 "PS Sessene" 219 "PS Taiba Moutoupha" 220 "PS Tawfekh" 221 "PS Thiobe" 222 "PS Tocky Gare" 223 "PS Toure Mbonde" 224 "PS Walalane" 225 "CS Mbacke" 226 "PS Dalla Ngabou" 227 "PS Darou Nahim" 228 "PS Darou salam" 229 "PS Dendeye Gouyegui" 230 "PS Diamaguene" 231 "PS Digane" 232 "PS Doyoly" 233 "PS Guerle" 234 "PS Kael" 235 "PS Madina" 236 "PS Mbacke Ndimb" 237 "PS Missirah" 238 "PS Municipal" 239 "PS Ndioumane Taiba" 240 "PS Nghaye" 241 "PS Sadio" 242 "PS Taiba Thekene" 243 "PS Taïf" 244 "PS Touba Fall" 245 "PS Touba Mboul Kael" 246 "PS Typ" 247 "Ps Pallene" 248 "Ps Santhie" 249 "CS Darou Marnane" 250 "CS Darou Tanzil" 251 "CS Keur Niang" 252 "CS Saïdyl Badawi" 253 "CS Serigne Mbacke Madina" 254 "CS Serigne Saliou Mbacke" 255 "EPS Ndamatou" 256 "EPS Cheikh Ahmadoul Khadim" 257 "EPS Matlaboul Fawzayni" 258 "PS Boukhatoul Moubarak" 259 "PS Darou Karim" 260 "PS Darou Khadim" 261 "PS Darou Khoudoss" 262 "PS Darou Minam" 263 "PS Darou Rahmane" 264 "PS Dialybatou" 265 "PS Gouye Mbinde" 266 "PS Guede Bousso" 267 "PS Guede Kaw" 268 "PS Heliport" 269 "PS Kaîra" 270 "PS Keur Gol" 271 "PS Khelcom" 272 "PS Madyana I" 273 "PS Madyana II" 274 "PS Mboussobe" 275 "PS Ndindy Abdou" 276 "PS Oumoul Khoura" 277 "PS Sourah" 278 "PS Thiawene" 279 "PS Tindody" 280 "PS Touba Bagdad" 281 "PS Touba Belel" 282 "PS Touba Boborel" 283 "PS Touba Bogo" 284 "PS Touba Hlm" 285 "PS Touba Lansar" 286 "Cs Diakhao" 287 "PS Boff Mballeme" 288 "PS Boof Poupouye" 289 "PS Darou Salam Rural" 290 "PS Diakhao Fermé" 291 "PS Diaoule" 292 "PS Magarite Davary" 293 "PS Marouth" 294 "PS Mbellacadiao" 295 "PS Mbouma" 296 "PS Ndiop" 297 "PS Ndiourbel Sine" 298 "PS Ndjilasseme" 299 "PS Thiare" 300 "PS Toffaye" 301 "CS Dioffior" 302 "PS Boyard" 303 "PS Djilasse Public" 304 "PS Faoye" 305 "PS Fimela" 306 "PS Loul Sessene" 307 "PS Marfafaco" 308 "PS Marlothie" 309 "PS Ndangane" 310 "PS Ndiagamba" 311 "PS Nobandane" 312 "PS Palmarin Facao" 313 "PS Palmarin Ngallou" 314 "PS Samba Dia" 315 "PS Simal" 316 "PS Soudiane" 317 "CS Fatick" 318 "CS prive Dal Xel de Fatick" 319 "EPS de Fatick" 320 "PS Bacoboeuf" 321 "PS Bicole" 322 "PS Darou Salam Urbain" 323 "PS Diarere" 324 "PS Diohine" 325 "PS Diouroup" 326 "PS Emetteur" 327 "PS Fayil" 328 "PS Gadiack" 329 "PS Mbelloghoutt" 330 "PS Mbettite" 331 "PS Mbédap" 332 "PS Ndiayendiaye" 333 "PS Ndiongolor" 334 "PS Ndiosmone" 335 "PS Ndoffonghor" 336 "PS Ndouck" 337 "PS Ngoye Mbadatt" 338 "PS Peulga Darel" 339 "PS Senghor" 340 "PS Sobene" 341 "PS Sowane" 342 "PS Tataguine" 343 "CS Foundiougne" 344 "CS Niodior" 345 "PS Baouth" 346 "PS Bassar" 347 "PS Bassoul" 348 "PS Diamniadio" 349 "PS Diogane" 350 "PS Dionewar" 351 "PS Djirnda" 352 "PS Mbam" 353 "PS Mounde" 354 "PS Soum" 355 "CS Gossas" 356 "PS Colobane" 357 "PS Darou Marnane" 358 "PS Deguerre" 359 "PS Diabel" 360 "PS Gaina Mbar" 361 "PS Mbar" 362 "PS Moure" 363 "PS Ndiene Lagane" 364 "PS Ouadiour" 365 "PS Patar Lia" 366 "PS Somb" 367 "PS Thienaba Gossas" 368 "PS Yargouye" 369 "CS Niakhar" 370 "PS Mbadatte" 371 "PS Ndiambour Sine" 372 "PS Ndoss" 373 "PS Ngayokheme" 374 "PS Ngonine" 375 "PS Patar Sine" 376 "PS Sagne" 377 "PS Sob" 378 "PS Sorokh" 379 "PS Tella" 380 "PS Toucar" 381 "PS Yenguelé" 382 "CS Passy" 383 "PS Darou Keur Mor Khoredia" 384 "PS Diagane barka" 385 "PS Diossong" 386 "PS Djilor" 387 "PS Keur Birane Khoredia" 388 "PS Lerane Coly" 389 "PS Lérane Sambou" 390 "PS Mbelane" 391 "PS Mbowene" 392 "PS Ndiassane Saloum" 393 "PS Ndiaye Ndiaye Wolof" 394 "PS Niassene" 395 "PS Sadiogo" 396 "PS Thiamene Keur Souleymane" 397 "PS Thiaméne Diogo" 398 "CS Sokone" 399 "PS Bambadalla Thiakho (CU_MILDA 2022)" 400 "PS Baria" 401 "PS Bettenty" 402 "PS Bossinkang" 403 "PS Coular Soce" 404 "PS Dassilame Soce" 405 "PS Diaglé" 406 "PS Djinack Bara" 407 "PS Karang" 408 "PS Keur Amath Seune" 409 "PS Keur Gueye Yacine" 410 "PS Keur Ousseynou Dieng (CU_MILDA 2022)" 411 "PS Keur Saloum Diane" 412 "PS Keur Samba Gueye" 413 "PS Keur Seny Gueye" 414 "PS Medina Djikoye" 415 "PS Missirah" 416 "PS Nemabah" 417 "PS Nemanding" 418 "PS Ngayene Thiebo" 419 "PS Nioro Alassane Tall" 420 "PS Pakala" 421 "PS Santamba" 422 "PS Sirmang" 423 "PS Sokone" 424 "PS Toubacouta" 425 "CS de Mbirkilane" 426 "PS Bidiam" 427 "PS Bossolel" 428 "PS Diamal" 429 "PS Keur Mbouki" 430 "PS Keur Pathè" 431 "PS Keur Sader" 432 "PS Keur Sawely" 433 "PS Koumpal" 434 "PS Mabo" 435 "PS Mbeuleup" 436 "PS Ndiayene Waly" 437 "PS Ndiognick" 438 "PS Ngouye" 439 "PS Segre Secco" 440 "PS Segregata" 441 "PS Thicatt" 442 "PS Touba Mbela" 443 "PS Weynde" 444 "PS Ngodiba" 445 "CS de Kaffrine" 446 "EPS Thierno Birahim Ndao" 447 "PS Boulel" 448 "PS Darou Salam" 449 "PS Diacksao" 450 "PS Diamagadio" 451 "PS Diamaguene" 452 "PS Diokoul Mbellboul" 453 "PS Dioumada" 454 "PS Djouth Nguel" 455 "PS Gniby" 456 "PS Goulokoum" 457 "PS Hore" 458 "PS Kaffrine II" 459 "PS Kahi" 460 "PS Kathiote" 461 "PS Keur Babou" 462 "PS Kélimane" 463 "PS Mbegue" 464 "PS Mbelbouck" 465 "PS Medinatoul Salam 2" 466 "PS Médina Taba" 467 "PS Méo Diobéne" 468 "PS Ndiaobambaly" 469 "PS Nganda" 470 "PS Nguer Mandakh" 471 "PS Pathe Thiangaye" 472 "PS Same Nguéyéne" 473 "PS Santhie Galgone" 474 "PS Sorocogne" 475 "CS Koungheul" 476 "PS Arafat" 477 "PS Coura Mouride" 478 "PS Darou Kaffat" 479 "PS Dimiskha" 480 "PS Fass Thieckene" 481 "PS Gainth Pathe" 482 "PS Ida Mouride" 483 "PS Keur Malick Marame" 484 "PS Keur Mandoumbe" 485 "PS Keur NGAYE" 486 "PS Koukoto Simong" 487 "PS Koung Koung" 488 "PS Kourdane" 489 "PS Lour Escale" 490 "PS Maka Gouye" 491 "PS Maka Yop" 492 "PS Minam" 493 "PS Missira Public" 494 "PS Ndiayene Lour" 495 "PS Ndoume" 496 "PS Ngouye Diaraf" 497 "PS Piram Manda" 498 "PS Ribot Escale" 499 "PS Saly Escale" 500 "PS Santhie Nguerane" 501 "PS Sine Matar" 502 "PS Sobel Diam Diam" 503 "PS Taif Thieckene" 504 "PS Touba Alia" 505 "PS Touba Aly Mbenda" 506 "PS Urbain" 507 "PS Urbain 2" 508 "CS Malem Hodar" 509 "PS Darou Mbané" 510 "PS Darou Minam" 511 "PS Diaga Keur Serigne" 512 "PS Diam Diam" 513 "PS Dianke Souf" 514 "PS Fass Mame Baba" 515 "PS Hodar" 516 "PS Khaîra Diaga" 517 "PS Maka Belal" 518 "PS Mbarocounda" 519 "PS Medina Sy" 520 "PS Médina Dianké" 521 "PS Ndiobene" 522 "PS Ndioté Séane" 523 "PS Ndioum Gainthie" 524 "PS Ngaba" 525 "PS Niahene" 526 "PS Paffa" 527 "PS Sagna" 528 "PS Seane" 529 "PS Tip Saloum" 530 "PS Touba Médinatoul" 531 "PS Touba Ngueyene" 532 "CS Guinguineo" 533 "PS Athiou" 534 "PS Back Samba Dior" 535 "PS Colobane Lambaye" 536 "PS Dara Mboss" 537 "PS Farabougou" 538 "PS Fass" 539 "PS Gagnick" 540 "PS Goweth Sérère" 541 "PS Kongoly" 542 "PS Mande Keur Miniane" 543 "PS Mbadakhoun" 544 "PS Mboss" 545 "PS Mboulougne" 546 "PS Ndelle" 547 "PS Ndiagne Kahone" 548 "PS Ndiago" 549 "PS Ngathie Naoude" 550 "PS Ngoloum" 551 "PS Nguekhokh" 552 "PS Nguelou" 553 "PS Ourour" 554 "PS Panal" 555 "PS Tchiky" 556 "PS Walo" 557 "PS Wardiakhal" 558 "PS Sibassor" 559 "CS Kasnack" 560 "EPS El hadji Ibrahima NIASS de Kaolack" 561 "PS Abattoirs" 562 "PS Boustane" 563 "PS Darou Ridouane" 564 "PS Dialegne" 565 "PS Diamegueune" 566 "PS Dya" 567 "PS Fass Thioffack" 568 "PS Gandiaye" 569 "PS Kabatoki" 570 "PS Kahone" 571 "PS Kanda" 572 "PS Keur Mbagne Diop" 573 "PS Koundam" 574 "PS Leona" 575 "PS Lyndiane" 576 "PS Medina Baye" 577 "PS Medina Mbaba" 578 "PS Ndiebel" 579 "PS Ndorong" 580 "PS Ngane" 581 "PS Ngothie" 582 "PS Nimzatt" 583 "PS Parcelles Assainies" 584 "PS Same" 585 "PS Sara" 586 "PS Sob2" 587 "PS Taba Ngoye" 588 "PS Thioffac" 589 "PS Thiomby" 590 "CS Ndoffane" 591 "PS Daga Sambou" 592 "PS Daga Youndoume" 593 "PS Darou Mbiteyene" 594 "PS Darou Pakathiar" 595 "PS Darou Salam" 596 "PS Djilekhar" 597 "PS Keur Aly Bassine" 598 "PS Keur Baka" 599 "PS Keur Lassana" 600 "PS Keur Serigne Bassirou" 601 "PS Keur Soce" 602 "PS Koumbal" 603 "PS Koutal" 604 "PS Kouthieye" 605 "PS Lamarame" 606 "PS Latmingue" 607 "PS Mbitéyène Abdou" 608 "PS Ndiaffate" 609 "PS Ndiedieng" 610 "PS Tawa Mboudaye" 611 "PS Thiare" 612 "PS Darou Mbapp" 613 "PS Dinguiraye" 614 "PS Falifa" 615 "CS Nioro" 616 "CS Wack Ngouna" 617 "PS Dabaly" 618 "PS Darou Khoudoss" 619 "PS Darou Salam Commune" 620 "PS Darou Salam Mouride" 621 "PS Darou Salam Nioro" 622 "PS Diamagueune" 623 "PS Fass HLM" 624 "PS Gainthes Kayes" 625 "PS Kabacoto" 626 "PS Kaymor" 627 "PS Keur Abibou Niasse" 628 "PS Keur Ale Samba" 629 "PS Keur Ayip" 630 "PS Keur Birane Ndoupy" 631 "PS Keur Cheikh Oumar TOURE" 632 "PS Keur Lahine Sakho" 633 "PS Keur Maba Diakhou" 634 "PS Keur Madiabel 1" 635 "PS Keur Madiabel 2" 636 "PS Keur Mandongo" 637 "PS Keur Moussa" 638 "PS Keur Sountou" 639 "PS Keur Tapha" 640 "PS Kohel" 641 "PS Lohène" 642 "PS Medina Sabakh" 643 "PS Missirah Walo" 644 "PS Ndiba Ndiayenne" 645 "PS Ndrame Escale" 646 "PS Ngayene Sabakh" 647 "PS Niappa Balla" 648 "PS Niassène Walo" 649 "PS Paoskoto" 650 "PS Porokhane" 651 "PS Saboya" 652 "PS Santhie Thiamène" 653 "PS Sine ngayene" 654 "PS Soucouta" 655 "PS Taiba Niassene" 656 "PS Thila Grand" 657 "CS Kedougou" 658 "CS Ndormi" 659 "EPS Amath Dansokho" 660 "PS Banda Fassi" 661 "PS Bantako" 662 "PS Dimboli" 663 "PS Dinde Felo" 664 "PS Fadiga" 665 "PS Fongolimby" 666 "PS Mako" 667 "PS Ninefescha" 668 "PS Sylla Counda" 669 "PS Tenkoto" 670 "PS Thiabedji" 671 "PS Thiabekare" 672 "PS Tomboronkoto" 673 "PS Tripano" 674 "PS de Dalaba" 675 "CS Salemata" 676 "PS Ebarack" 677 "PS Dakately" 678 "PS Dar Salam" 679 "PS Darou Ningou" 680 "PS Ethiolo" 681 "PS Kevoye" 682 "PS Nepene" 683 "PS Oubadji" 684 "PS Thiankoye" 685 "CS Saraya" 686 "PS Bambadji" 687 "PS Bembou" 688 "PS Bransan" 689 "PS Daloto" 690 "PS Diakha Macky" 691 "PS Diakha Madina" 692 "PS Diakhaba" 693 "PS Diakhaling" 694 "PS Kharakhena" 695 "PS Khossanto" 696 "PS Madina Baffe" 697 "PS Madina Sirimana" 698 "PS Mamakhono" 699 "PS Missira Dentila" 700 "PS Missira Sirimana" 701 "PS Moussala" 702 "PS Nafadji" 703 "PS Sabodola" 704 "PS Saensoutou" 705 "PS Sambrambougou" 706 "PS Saroudia" 707 "PS Wassangaran" 708 "CS Kolda" 709 "EPS Kolda" 710 "PS Anambe" 711 "PS Bagadadji" 712 "PS Bambadinka" 713 "PS Bantancountou Maounde" 714 "PS Bouna Kane" 715 "PS Coumbacara" 716 "PS Dabo" 717 "PS Darou Salam Thierno" 718 "PS Dialacoumbi" 719 "PS Dialembere" 720 "PS Diankancounda Oguel" 721 "PS Diassina" 722 "PS Dioulacolon" 723 "PS Gadapara" 724 "PS Guire Yoro Bocar" 725 "PS Hafia" 726 "PS Ibrahima Nima" 727 "PS Kampissa" 728 "PS Kossanké" 729 "PS Mampatim" 730 "PS Medina Alpha Sadou" 731 "PS Medina Cherif" 732 "PS Medina El Hadj" 733 "PS Nghocky" 734 "PS Salamata" 735 "PS Salikegne" 736 "PS Sare Bidji" 737 "PS Sare Demdayel" 738 "PS Sare Kemo" 739 "PS Sare Moussa" 740 "PS Sare Moussa Meta" 741 "PS Sare Yoba Diega" 742 "PS Saré Bilaly" 743 "PS Sikilo Est" 744 "PS Sikilo ouest" 745 "PS Tankanto Escale" 746 "PS Temento Samba" 747 "PS Thiarra" 748 "PS Thiety" 749 "PS Thiewal Lao" 750 "PS Zone lycée" 751 "CS Medina Yoro Foulah" 752 "PS Badion" 753 "PS Bourouko" 754 "PS Diakhaly" 755 "PS Dinguiraye" 756 "PS Dioulanghel Banta" 757 "PS Fafacourou" 758 "PS Firdawsi" 759 "PS Kerewane" 760 "PS Koulinto" 761 "PS Kourkour Balla" 762 "PS Linkédiang" 763 "PS Mballocounda (MYF)" 764 "PS Medina Passy" 765 "PS Médina Manda" 766 "PS Ndorna" 767 "PS Ngoudourou" 768 "PS Niaming" 769 "PS Pata" 770 "PS Santankoye" 771 "PS Sare Yoro Bouya" 772 "PS Sobouldé" 773 "PS Sourouyel" 774 "PS Touba Thieckene" 775 "CS Medina gounass" 776 "CS Velingara" 777 "PS Afia" 778 "PS Bonconto" 779 "PS Dialadiang" 780 "PS Dialakegny" 781 "PS Diaobe" 782 "PS Doubirou" 783 "PS Kabendou" 784 "PS Kalifourou" 785 "PS Kandia" 786 "PS Kandiaye" 787 "PS Kaouné" 788 "PS Kounkane" 789 "PS Linkering" 790 "PS Manda Douane" 791 "PS Mballocounda (Vélingara)" 792 "PS Medina Dianguette" 793 "PS Medina Gounass" 794 "PS Medina Marie Cisse" 795 "PS Municipal thiankan" 796 "PS Nemataba" 797 "PS Nianao" 798 "PS Ouassadou" 799 "PS Pakour" 800 "PS Paroumba" 801 "PS Payoungou" 802 "PS Sare Coly Salle" 803 "PS Saré Balla" 804 "PS Saré Nagué" 805 "PS Sinthian Koundara" 806 "PS Wadiya Toulaye" 807 "Poste Croix Rouge" 808 "CS Dahra" 809 "PS Affe" 810 "PS Boulal Nianghene" 811 "PS Communal" 812 "PS Dealy" 813 "PS Kamb" 814 "PS Mbaye Awa" 815 "PS Mbeulekhe Diane" 816 "PS Mbeyene" 817 "PS Mboulal" 818 "PS Mélakh" 819 "PS NGuenene" 820 "PS Sagata Djoloff" 821 "PS Sam Fall" 822 "PS Sine Abdou" 823 "PS Tessekere" 824 "PS Thiamene" 825 "PS Touba Boustane" 826 "PS Widou" 827 "PS Yang Yang" 828 "CS Darou Mousty" 829 "CS Mbacke Kadior" 830 "PS Arafat" 831 "PS Darou Diop" 832 "PS Darou Kosso" 833 "PS Darou Marnane" 834 "PS Darou Miname Pet" 835 "PS Darou Wahab" 836 "PS Dekheule" 837 "PS Fass Toure" 838 "PS Keur Alioune Ndiaye" 839 "PS Mbadiane" 840 "PS Ndoyene" 841 "PS Nganado" 842 "PS Sam Yabal" 843 "PS Sar Sara" 844 "PS Taysir" 845 "PS Touba Merina" 846 "PS Touba Roof" 847 "PS Yari Dakhar" 848 "CS Gueoul" 849 "CS Kebemer" 850 "PS Bandegne" 851 "PS Diamaguene" 852 "PS Diokoul" 853 "PS Kab Gaye" 854 "PS Kanene" 855 "PS Keur Amadou Yalla" 856 "PS Lompoul" 857 "PS Loro" 858 "PS Ndakhar Syll" 859 "PS Ndande" 860 "PS Ndieye" 861 "PS Ngourane" 862 "PS Pallene Ndedd" 863 "PS Sagatta Gueth" 864 "PS Thieppe" 865 "PS Thiolom" 866 "CS Keur Momar SARR" 867 "PS Boudy Sakho" 868 "PS Boyo 2" 869 "PS Gande" 870 "PS Gankette Balla" 871 "PS Gouye Mbeuth" 872 "PS Keur Maniang" 873 "PS Keur Momar Sarr" 874 "PS Loboudou" 875 "PS Loumboule Mbath" 876 "PS Mbar Toubab" 877 "PS Nayobe" 878 "PS Ndimb" 879 "PS Nguer Malal" 880 "CS Coki" 881 "PS Coki" 882 "PS Djadiorde" 883 "PS Garki Diaw" 884 "PS Guet Ardo" 885 "PS Institut Islamique de Koki" 886 "PS Keur Bassine" 887 "PS Ndiagne" 888 "PS Ndiaré Touba Ndiaye" 889 "PS Ouarack" 890 "PS Pete Warack" 891 "PS Thiamene" 892 "CS Linguere" 893 "EPS Linguere" 894 "PS Barkedji" 895 "PS DIagali" 896 "PS Darou Salam DIOP" 897 "PS Dodji" 898 "PS Dolly" 899 "PS Gassane Ndiawene" 900 "PS Kadji" 901 "PS Labgar" 902 "PS Thiargny" 903 "PS Thiel" 904 "PS Touba Kane Gassane" 905 "PS Touba Linguére" 906 "PS Warkhokh" 907 "CS Louga" 908 "EPS Amadou Sakhir Mbaye de Louga" 909 "PS Artillerie" 910 "PS Dielerlou Syll" 911 "PS Kelle Gueye" 912 "PS Keur Ndiaye" 913 "PS Keur Serigne Louga Est" 914 "PS Keur Serigne Louga Ouest" 915 "PS Keur Sérigne Louga Sud" 916 "PS MEDINA SALAM" 917 "PS MERINA SARR" 918 "PS Mbediene" 919 "PS Ndawene" 920 "PS Nguidila" 921 "PS Niomre" 922 "PS Santhiaba Sud" 923 "PS Touba Darou Salame" 924 "PS Touba Seras" 925 "PS Vesos" 926 "PS Yermande" 927 "CS Sakal" 928 "PS Darou Rahma" 929 "PS Keur Sambou" 930 "PS Leona" 931 "PS Madina Thiolom" 932 "PS Ndawass Diagne" 933 "PS Ndialakhar Samb" 934 "PS Ndieye Satoure" 935 "PS Ngadji Sarr" 936 "PS Ngueune Sarr" 937 "PS Palene Mafall" 938 "PS Potou" 939 "PS Sague Sathiel" 940 "PS Syer Peulh" 941 "CS Hamady Ounare" 942 "CS Kanel" 943 "CS Waounde" 944 "PS Aoure" 945 "PS Bokiladji" 946 "PS Bokissaboudou" 947 "PS Bow" 948 "PS Dembacani" 949 "PS Dialloubé" 950 "PS Diella" 951 "PS Dounde" 952 "PS Fadiara" 953 "PS Foumi Hara" 954 "PS Ganguel Maka" 955 "PS Ganguel Souley" 956 "PS Gaode Boffe" 957 "PS Goumal" 958 "PS Gouriki Koliabé" 959 "PS Hadabere" 960 "PS Hamady Ounare" 961 "PS Kanel" 962 "PS Lobaly" 963 "PS Namary" 964 "PS Ndendory" 965 "PS Ndiott" 966 "PS Nganno" 967 "PS Nianghana Thiedel" 968 "PS Odobere" 969 "PS Orkadiere" 970 "PS Orndolde" 971 "PS Padalal" 972 "PS Polel Diaobe" 973 "PS Semme" 974 "PS Sendou" 975 "PS Seno Palel" 976 "PS Sinthiane" 977 "PS Sinthiou Bamambe" 978 "PS Soringho" 979 "PS Tekkinguel" 980 "PS Thiagnaff" 981 "PS Thially" 982 "PS Thiempeng" 983 "PS Waounde" 984 "PS Wendou Bosseabe" 985 "PS Wourosidi" 986 "PS Yacine Lacké" 987 "PS windou nodji" 988 "PS Danthiady" 989 "CS Matam" 990 "EPS Régional de Matam" 991 "EPS de Ouroussogui" 992 "PS Boinadji" 993 "PS Bokidiawe" 994 "PS Bokidiawe 2" 995 "PS Diamel" 996 "PS Diandioly" 997 "PS Dondou" 998 "PS Doumga Ouro Alpha" 999 "PS Fété Niébé" 1000 "PS Gaol" 1001 "PS Mbakhna" 1002 "PS Mboloyel" 1003 "PS Nabadji Civol" 1004 "PS Ndoulomadji Dembe" 1005 "PS Ndouloumadji Founebe" 1006 "PS Nguidjilone" 1007 "PS Ogo" 1008 "PS Ourossogui" 1009 "PS Sadel" 1010 "PS Sedo Sebe" 1011 "PS Sinthiou Garba" 1012 "PS Soubalo" 1013 "PS Taïba" 1014 "PS Thiaréne" 1015 "PS Tiguéré" 1016 "PS Travaux Dendoudy" 1017 "PS Woudourou" 1018 "PS de la Gendarmerie" 1019 "CS Ranerou" 1020 "PS Badagore" 1021 "PS Dayane Guélodé" 1022 "PS Fourdou" 1023 "PS Katane" 1024 "PS Lougre Thioly" 1025 "PS Loumbal Samba Abdoul" 1026 "PS Mbam" 1027 "PS Mbem Mbem" 1028 "PS Naouré" 1029 "PS Oudalaye" 1030 "PS Patouki" 1031 "PS Petiel" 1032 "PS Salalatou" 1033 "PS Samba Doguel" 1034 "PS Thionokh" 1035 "PS Velingara Ferlo" 1036 "PS Younoufere" 1037 "CS Thilogne" 1038 "EPS AGNAM" 1039 "PS Agnam Civol" 1040 "PS Agnam Goly" 1041 "PS Agnam Thiodaye" 1042 "PS Agnam lidoubé" 1043 "PS Dabia Odedji" 1044 "PS Diorbivol" 1045 "PS Goudoudé Diobé" 1046 "PS Goudoudé Ndouetbé" 1047 "PS Gourel Omar LY" 1048 "PS Kobilo" 1049 "PS Loumbal Babadji" 1050 "PS Loumbi Sanarabe" 1051 "PS Mberla Bele" 1052 "PS Ndiaffane" 1053 "PS Oréfondé" 1054 "PS Saré Liou" 1055 "PS Sylla Djonto" 1056 "CS Dagana" 1057 "PS Bokhol" 1058 "PS Bouteyni" 1059 "PS Diagle" 1060 "PS Gae" 1061 "PS Guidakhar" 1062 "PS Mbane" 1063 "PS Mbilor" 1064 "PS Ndombo" 1065 "PS Niassante" 1066 "PS Santhiaba" 1067 "PS Secteur 4 Et 5" 1068 "PS Thiago" 1069 "CS Aere Lao" 1070 "CS Cascas" 1071 "CS Galoya" 1072 "CS Pete" 1073 "PS Aere Lao" 1074 "PS Barobe Wassatake" 1075 "PS Bode lao" 1076 "PS Boguel" 1077 "PS Boke Dialoube" 1078 "PS Boke Mbaybe Salsalbe" 1079 "PS Boke Namari" 1080 "PS Boke Yalalbé" 1081 "PS Boki Sarankobe" 1082 "PS Cascas" 1083 "PS Diaba" 1084 "PS Diongui" 1085 "PS Dioude Diabe" 1086 "PS Doumga Lao" 1087 "PS Dounguel" 1088 "PS Galoya" 1089 "PS Gayekadar" 1090 "PS Gollere" 1091 "PS Karaweyndou" 1092 "PS Lougue" 1093 "PS Madina Ndiathbe" 1094 "PS Mbolo Birane" 1095 "PS Mboumba" 1096 "PS Mery" 1097 "PS Ndiayene Peulh" 1098 "PS Salde" 1099 "PS Saré Maoundé" 1100 "PS Sinthiou Amadou Mairame" 1101 "PS Sioure" 1102 "PS Thioubalel" 1103 "PS Walalde" 1104 "PS Yare Lao" 1105 "PS Yawaldé Yirlabé" 1106 "CS Podor" 1107 "CS Thile Boubacar" 1108 "EPS de NDioum" 1109 "PS Alwar" 1110 "PS Belel Kelle" 1111 "PS Commune de Podor" 1112 "PS Dara Halaybe" 1113 "PS Demet" 1114 "PS Diagnoum" 1115 "PS Diamal" 1116 "PS Diambo" 1117 "PS Diattar" 1118 "PS Dimat" 1119 "PS Dodel" 1120 "PS Donaye/ Taredji" 1121 "PS Doué" 1122 "PS Fanaye" 1123 "PS Gamadji Sarre" 1124 "PS Ganina" 1125 "PS Guede Chantier" 1126 "PS Guede Village" 1127 "PS Guiya" 1128 "PS Louboudou Doué" 1129 "PS Mafré" 1130 "PS Marda" 1131 "PS Mbidi" 1132 "PS Mboyo" 1133 "PS NDIEURBA" 1134 "PS Namarel" 1135 "PS Ndiandane" 1136 "PS Ndiawara" 1137 "PS Ndiayen Pendao" 1138 "PS Ndioum" 1139 "PS Nguendar" 1140 "PS Pathe Gallo" 1141 "PS Sinthiou Dangde" 1142 "PS Tatqui" 1143 "PS Thialaga" 1144 "PS Thiangaye" 1145 "PS Toulde Galle" 1146 "CS Richard Toll" 1147 "CS Ross Bethio" 1148 "CSS" 1149 "EPS Richard Toll" 1150 "PS Debi Tiguette" 1151 "PS Diama" 1152 "PS Diawar" 1153 "PS Gallo Malick" 1154 "PS Kassack Nord" 1155 "PS Kassack Sud" 1156 "PS Khouma" 1157 "PS Mbagam" 1158 "PS Mboundoum" 1159 "PS Ndiangue - Ndiaw" 1160 "PS Ndiaténe" 1161 "PS Ndombo Alarba" 1162 "PS Ngnith" 1163 "PS Niasséne" 1164 "PS Ronkh" 1165 "PS Rosso Senegal 1" 1166 "PS Rosso Senegal 2" 1167 "PS Savoigne" 1168 "PS Taouey" 1169 "PS Thiabakh" 1170 "PS Yamane" 1171 "CS Mpal" 1172 "CS Saint - Louis" 1173 "DPS Yonou Ndoub" 1174 "EPS de Saint Louis" 1175 "PS Bango" 1176 "PS Diamaguene" 1177 "PS Fass NGOM" 1178 "PS Gandon" 1179 "PS Goxu Mbath" 1180 "PS Guet Ndar" 1181 "PS Khor" 1182 "PS Mbakhana" 1183 "PS Ngallele" 1184 "PS Nord" 1185 "PS Pikine" 1186 "PS Rao" 1187 "PS Santhiaba (Ndar Toute)" 1188 "PS Sor" 1189 "PS Sor Daga" 1190 "PS Sud" 1191 "PS Tassinere" 1192 "CS Bounkiling" 1193 "PS Bogal" 1194 "PS Bona" 1195 "PS Boudouk" 1196 "PS Diacounda Diolene" 1197 "PS Dialocounda" 1198 "PS Diambati" 1199 "PS Diaroume" 1200 "PS Diendieme" 1201 "PS Djinani" 1202 "PS Djiragone" 1203 "PS Faoune" 1204 "PS Inor Diola" 1205 "PS Kandion Mangana" 1206 "PS Medina Wandifa" 1207 "PS Ndiama" 1208 "PS Ndiamacouta" 1209 "PS Ndiolofene" 1210 "PS Nioroky" 1211 "PS Senoba" 1212 "PS Seydou N Tall" 1213 "PS Sinthiou Mady Mbaye" 1214 "PS Sinthiou Tankon" 1215 "PS Soumboundou Fogny" 1216 "PS Syllaya" 1217 "PS Tankon" 1218 "PS Touba Fall" 1219 "CS Goudomp" 1220 "CS Samine" 1221 "PS Bafata" 1222 "PS Baghere" 1223 "PS Binako" 1224 "PS Diareng" 1225 "PS Djibanar" 1226 "PS Karantaba" 1227 "PS Kawour" 1228 "PS Kolibantang" 1229 "PS Kougnara" 1230 "PS Niagha" 1231 "PS Safane" 1232 "PS Sandiniery" 1233 "PS Sinbandi Brassou" 1234 "PS Tanaff" 1235 "PS Yarang Balante" 1236 "CS Bambaly" 1237 "CS Sedhiou" 1238 "EPS Sedhiou" 1239 "PS Bemet Bidjini" 1240 "PS Boudhié Samine" 1241 "PS Boumouda" 1242 "PS Bouno" 1243 "PS Dembo Coly" 1244 "PS Diana Malary" 1245 "PS Diannah Bah" 1246 "PS Diende" 1247 "PS Djibabouya" 1248 "PS Djiredji" 1249 "PS Koussy" 1250 "PS Manconoba" 1251 "PS Marakissa" 1252 "PS Marsassoum" 1253 "PS Medina Souane" 1254 "PS Nguindir" 1255 "PS Oudoucar" 1256 "PS Sakar" 1257 "PS Sansamba" 1258 "PS Singhere" 1259 "PS Tourecounda" 1260 "CS Bakel" 1261 "PS Aroundou" 1262 "PS Ballou" 1263 "PS Dedji" 1264 "PS Diawara" 1265 "PS Gabou" 1266 "PS Gallade" 1267 "PS Gande" 1268 "PS Golmy" 1269 "PS Kahé" 1270 "PS Kounghany" 1271 "PS Manael" 1272 "PS Marsa" 1273 "PS Moudery" 1274 "PS Ndjimbe" 1275 "PS Ololdou" 1276 "PS Samba Yide" 1277 "PS Sebou" 1278 "PS Sira Mamadou Bocar" 1279 "PS Tourime" 1280 "PS Tuabou" 1281 "PS Urbain Bakel" 1282 "PS Yaféra" 1283 "PS Yellingara" 1284 "CS Dianké Makha" 1285 "PS Bani Israel" 1286 "PS Bantanani" 1287 "PS Binguel" 1288 "PS Bodé" 1289 "PS Boutoukoufara" 1290 "PS Dalafine" 1291 "PS Diana" 1292 "PS Dieylani" 1293 "PS Dougue" 1294 "PS Douleyabe" 1295 "PS Gouta" 1296 "PS Kayan" 1297 "PS Komoty" 1298 "PS Koudy" 1299 "PS Koussan" 1300 "PS Lelekone" 1301 "PS Madina Diakha" 1302 "PS Niery" 1303 "PS Soutouta" 1304 "PS Talibadji" 1305 "CS Goudiry" 1306 "PS Ainoumady" 1307 "PS Bala" 1308 "PS Boynguel Bamba" 1309 "PS Diare Mbolo" 1310 "PS Diyabougou" 1311 "PS Gognedji" 1312 "PS Goumbayel" 1313 "PS Kagnoube" 1314 "PS Koar" 1315 "PS Kothiary" 1316 "PS Koulor" 1317 "PS Kouthia" 1318 "PS Madie" 1319 "PS Mbaniou" 1320 "PS Ndiya" 1321 "PS Sinthiou Mamadou Boubou" 1322 "PS Sinthiou Tafsir" 1323 "PS Tabading" 1324 "PS Thiara" 1325 "PS Toumounguel" 1326 "PS Waly Babacar" 1327 "Sinthiou Bocar Aly Kandar" 1328 "CS Kidira" 1329 "PS Arigabo" 1330 "PS Banipelly" 1331 "PS Bele" 1332 "PS Belijimbaré" 1333 "PS Daharatou/Ourothierno" 1334 "PS Dialiguel" 1335 "PS Didde Gassama" 1336 "PS Dyabougou" 1337 "PS Gathiary" 1338 "PS Kenieba" 1339 "PS Laminia" 1340 "PS Madina Foulbé" 1341 "PS Nayes" 1342 "PS Ouro Himadou" 1343 "PS Sadatou" 1344 "PS Samba Colo" 1345 "PS Sansanding" 1346 "PS Senedebou" 1347 "PS Sinthiou Dialiguel" 1348 "PS Sinthiou Fissa" 1349 "PS Tacoutala" 1350 "PS Toumboura" 1351 "PS Wouro Souleye" 1352 "CS Koumpentoum" 1353 "PS Bamba Thialene" 1354 "PS Darou Nbimbelane" 1355 "PS Darou Salam" 1356 "PS Darou Salam 2" 1357 "PS Diagle Sine" 1358 "PS Diam Diam" 1359 "PS Fass Gounass" 1360 "PS Kaba" 1361 "PS Kahene" 1362 "PS Kanouma" 1363 "PS Kouthia Gaidy" 1364 "PS Kouthiaba" 1365 "PS Loffé" 1366 "PS Loumby travaux" 1367 "PS Malemba" 1368 "PS Malene Niani" 1369 "PS Mereto" 1370 "PS Ndame" 1371 "PS Pass Koto" 1372 "PS Payar" 1373 "PS Syll Serigne Malick" 1374 "PS Velingara Koto" 1375 "CS Maka" 1376 "PS Cissecounda" 1377 "PS Colibantang" 1378 "PS Fadiyacounda" 1379 "PS Mboulembou" 1380 "PS Ndoga Babacar" 1381 "PS Pathiap" 1382 "PS Sare Diame" 1383 "PS Saré Ely" 1384 "PS Seoro" 1385 "PS Souba Counda" 1386 "PS Syllame" 1387 "PS Touba Belel" 1388 "CS Tambacounda" 1389 "EPS Tambacounda" 1390 "PS Afia" 1391 "PS Bambadinka" 1392 "PS Bantantinty" 1393 "PS Bira" 1394 "PS Bohe Baledji" 1395 "PS Botou" 1396 "PS Dar Salam" 1397 "PS Dar Salam Fodé" 1398 "PS Dawady" 1399 "PS Depot" 1400 "PS Dialocoto" 1401 "PS Djinkore" 1402 "PS Fodécounda Ansou" 1403 "PS Gouloumbou" 1404 "PS Gourel Djiadji" 1405 "PS Gouye" 1406 "PS Koussanar" 1407 "PS Missirah" 1408 "PS Neteboulou" 1409 "PS Pont" 1410 "PS Saal" 1411 "PS Sankagne" 1412 "PS Sare Guilele" 1413 "PS Saré Niana" 1414 "PS Segou Coura" 1415 "PS Sinthiou Malene" 1416 "PS Tamba Socé" 1417 "PS Tessan" 1418 "CS Joal" 1419 "PS Caritas" 1420 "PS Fadial" 1421 "PS Fadiouth" 1422 "PS Mbodiene" 1423 "PS Ndianda" 1424 "PS Ndiemane" 1425 "PS Ngueniene" 1426 "PS Santhe Elisabeth Diouf" 1427 "CS Khombole" 1428 "PS Bangadji" 1429 "PS Bokh" 1430 "PS Diack" 1431 "PS Diayane" 1432 "PS Kaba" 1433 "PS Keur Ibra Gueye" 1434 "PS Keur Macodou" 1435 "PS Keur Yaba Diop" 1436 "PS Mboss" 1437 "PS Mboulouctene" 1438 "PS Mbouvaille" 1439 "PS Ndiakhou" 1440 "PS Ndiayene Sirakh" 1441 "PS Ndoucoumane" 1442 "PS Ndouff-Ndengler" 1443 "PS Ngoudiane" 1444 "PS Sewekhaye" 1445 "PS Thiangaye" 1446 "PS Thienaba" 1447 "PS Touba Toul" 1448 "CS Mbour" 1449 "EPS Mbour" 1450 "PS Chaden" 1451 "PS Darou Salam" 1452 "PS Diamaguene" 1453 "PS Djilakh" 1454 "PS Fallokh Malicounda" 1455 "PS Falokh Mbour" 1456 "PS Fandane" 1457 "PS Gandigal" 1458 "PS Grand Mbour" 1459 "PS Malicounda Bambara" 1460 "PS Malicounda Keur Maissa" 1461 "PS Mballing" 1462 "PS Mbouleme" 1463 "PS Mbour Toucouleur" 1464 "PS Medine" 1465 "PS Ngaparou 1" 1466 "PS Ngaparou 2" 1467 "PS Ngoukhouthie" 1468 "PS Nguekokh 1" 1469 "PS Nguekokh 2" 1470 "PS Nguérigne Bambara" 1471 "PS Nianing" 1472 "PS Point Sarene" 1473 "PS Roff" 1474 "PS Saly" 1475 "PS Saly Carrefour" 1476 "PS Santessou" 1477 "PS Santhie" 1478 "PS Somone" 1479 "PS Takhoum" 1480 "PS Tene Toubab" 1481 "PS Trypano" 1482 "PS Varedo" 1483 "PS Warang" 1484 "CS Mekhe" 1485 "PS Nguembé" 1486 "PS Darou Gaye" 1487 "PS Diemoul" 1488 "PS Fass Diacksao" 1489 "PS Gade Yell" 1490 "PS Golobé" 1491 "PS Kelle" 1492 "PS Khandane" 1493 "PS Khawlou" 1494 "PS Koul" 1495 "PS Lebou" 1496 "PS Macka Léye" 1497 "PS Mbakhiss" 1498 "PS Mbayene" 1499 "PS Merina Dakhar" 1500 "PS Ndierigne" 1501 "PS Ndéméne" 1502 "PS Ngalick" 1503 "PS Ngandiouf" 1504 "PS Ngaye Diagne" 1505 "PS Ngaye Djitté" 1506 "PS Nguéwoul Loto" 1507 "PS Niakhene" 1508 "PS Pekesse" 1509 "PS Serigne Massamba Diop Same" 1510 "PS Thilmakha" 1511 "PS Thiékére" 1512 "PS Touba Kane" 1513 "PS Tyll Sathé" 1514 "CS Popenguine" 1515 "PS Boukhou" 1516 "PS Dagga" 1517 "PS Diass" 1518 "PS Guereo" 1519 "PS Kirene" 1520 "PS Ndayane" 1521 "PS Popenguine Serere" 1522 "PS Sindia" 1523 "PS Thicky" 1524 "PS Toglou" 1525 "CS Pout" 1526 "PS Bayakh" 1527 "PS Beer" 1528 "PS Cayar" 1529 "PS Keur Matar" 1530 "PS Keur Mousseu" 1531 "PS Ndiar" 1532 "PS Ndiender" 1533 "PS Ngomene" 1534 "PS Soune Serere" 1535 "PS Thor" 1536 "CS Thiadiaye" 1537 "PS Fissel" 1538 "PS Guelor" 1539 "PS Louly Mbentenier" 1540 "PS Louly Ndia" 1541 "PS Mbafaye" 1542 "PS Mbalamsome" 1543 "PS Mboulouctene Secco" 1544 "PS Mbourokh" 1545 "PS Ndiaganiao" 1546 "PS Ndiarao" 1547 "PS Ngeme" 1548 "PS Sandiara" 1549 "PS Sessene" 1550 "PS Tocomack" 1551 "CS 10ème de THIES" 1552 "CS Keur Mame El Hadji" 1553 "EPS Amadou S Dieuguene" 1554 "PS Cite Lamy" 1555 "PS Cite Niakh" 1556 "PS Darou Salam" 1557 "PS Diakhao" 1558 "PS Grand Thies" 1559 "PS Hanene" 1560 "PS Hersent" 1561 "PS Kawsara" 1562 "PS Keur Issa" 1563 "PS Keur Saib Ndoye" 1564 "PS Keur Serigne Ablaye" 1565 "PS Kissane" 1566 "PS Mbour I" 1567 "PS Mbour II" 1568 "PS Mbour III" 1569 "PS Mbousnakh" 1570 "PS Medina Fall I" 1571 "PS Medina Fall II" 1572 "PS Ngoumsane" 1573 "PS Nguinth" 1574 "PS Notto" 1575 "PS Parcelle Assainies" 1576 "PS Petit Thialy" 1577 "PS Peyckouk" 1578 "PS Pognène" 1579 "PS Pout Diack" 1580 "PS Sam Ndiaye" 1581 "PS Sampathe" 1582 "PS Silmang" 1583 "PS Takhikao" 1584 "PS Tassette" 1585 "PS Thies None" 1586 "PS Randoulene" 1587 "CS Tivaouane" 1588 "EPS ABDOU AZIZ SY" 1589 "PS Cherif Lo" 1590 "PS Darou Alpha" 1591 "PS Darou Khoudoss" 1592 "PS Diogo" 1593 "PS Diogo sur mer" 1594 "PS Fass Boye" 1595 "PS Fouloum" 1596 "PS Ka Fall" 1597 "PS Keur Khar DIOP" 1598 "PS Keur Mbir Ndao" 1599 "PS Khonk Yoye" 1600 "PS Mbayenne 3" 1601 "PS Mboro I" 1602 "PS Mboro II" 1603 "PS Medine" 1604 "PS Mekhe Village" 1605 "PS Meouane" 1606 "PS Mibasse" 1607 "PS Mont Rolland" 1608 "PS Ndankh" 1609 "PS Ndiassane" 1610 "PS Ngakhame1" 1611 "PS Nombile" 1612 "PS Notto Gouye Diama" 1613 "PS Pambal" 1614 "PS Pire Goureye" 1615 "PS Sao" 1616 "PS Taîba Ndiaye" 1617 "PS Touba Fall" 1618 "CS Bignona" 1619 "PS Badioncoto" 1620 "PS Badioure" 1621 "PS Baila" 1622 "PS Bougoutoub" 1623 "PS Boureck" 1624 "PS Coubalan" 1625 "PS Coubanao" 1626 "PS Diacoye Banga" 1627 "PS Diamaye" 1628 "PS Diocadou" 1629 "PS Diondji" 1630 "PS Djibidione" 1631 "PS Djilonguia" 1632 "PS Kagnarou" 1633 "PS Mampalago" 1634 "PS Mangouléne" 1635 "PS Manguiline" 1636 "PS Médiegue" 1637 "PS Médiègue Banghouname" 1638 "PS Niamone" 1639 "PS Niandane" 1640 "PS Niankitte" 1641 "PS Oulampane" 1642 "PS Ouonck" 1643 "PS Silinkine" 1644 "PS Sindialon" 1645 "PS Sindian" 1646 "PS Souda" 1647 "PS Suelle" 1648 "PS Tendieme" 1649 "PS Tendimane" 1650 "PS Tendine" 1651 "PS Tenghory Arrondissement" 1652 "PS Tenghory Transgambienne" 1653 "PS Tobor" 1654 "CS Diouloulou" 1655 "PS Abene" 1656 "PS Badiana" 1657 "PS Baranlire" 1658 "PS Belaye" 1659 "PS Biti Biti" 1660 "PS Couba" 1661 "PS Courame" 1662 "PS Dambondir" 1663 "PS Dar Salam" 1664 "PS Darou Kairy" 1665 "PS Diogue" 1666 "PS Djannah" 1667 "PS Djinaki" 1668 "PS Ebinkine" 1669 "PS Essom Sylatiaye" 1670 "PS Kabiline" 1671 "PS Kafountine" 1672 "PS Medina Daffe" 1673 "PS Niomoune Ile" 1674 "PS Selety" 1675 "PS Touba Tranquille" 1676 "CS Oussouye" 1677 "PS Boucotte" 1678 "PS Cabrousse" 1679 "PS Cadjinolle" 1680 "PS Cagnoute" 1681 "PS Cap Skirring" 1682 "PS Carabane Ile" 1683 "PS Carounate" 1684 "PS Diakene Diola" 1685 "PS Diakene Ouolof" 1686 "PS Diembering" 1687 "PS Elinkine" 1688 "PS Loudia Ouolof" 1689 "PS Wendaye" 1690 "PS Youtou" 1691 "CS Thionck Essyl" 1692 "PS Bagaya" 1693 "PS Balingor" 1694 "PS Bassire" 1695 "PS Dianki" 1696 "PS Diatock" 1697 "PS Diegoune I" 1698 "PS Diegoune II" 1699 "PS Kagnobon" 1700 "PS Kartiack" 1701 "PS Mandegane" 1702 "PS Mlomp" 1703 "PS Tendouck" 1704 "PS Thiobon" 1705 "CS Ziguinchor" 1706 "EPS CHR ZIGUINCHOR" 1707 "EPS Hopital de la Paix" 1708 "PS Adeane" 1709 "PS Agnack" 1710 "PS Baghagha" 1711 "PS Belfort" 1712 "PS Bethesda" 1713 "PS Bourofaye" 1714 "PS Boutoupa" 1715 "PS Colette Senghor" 1716 "PS Diabir" 1717 "PS Diagnon" 1718 "PS Djibock" 1719 "PS Djifanghor" 1720 "PS Emile Badiane" 1721 "PS Enampor" 1722 "PS Kaguitte" 1723 "PS Kande 1" 1724 "PS Kande II" 1725 "PS Kandialang I" 1726 "PS Kandialang II" 1727 "PS Lyndiane Municipal" 1728 "PS Mpack" 1729 "PS Nema" 1730 "PS Niaguis" 1731 "PS Niaguis II" 1732 "PS Nyassia" 1733 "PS Santhiaba" 1734 "PS Seleky" 1735 "PS Sindone" 1736 "PS Toubacouta" 1737 "PS soucoupapaye"
	label values i3 i3

	label variable i4a "104a. Nom de la case de santé"
	note i4a: "104a. Nom de la case de santé"

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
	label define enqueteur 1 "Fleur Kona" 2 "Maimouna Yaye Pode Faye" 3 "Malick Ndiongue" 4 "Fatoumata Binta Bah" 5 "Mamadou Yacine Diallo Diallo" 6 "Yacine Sall Koumba Boulingui" 7 "Maty Leye" 8 "Catherine Mendy" 9 "Awa Diouf" 10 "Madicke Diop" 11 "Arona Diagne" 12 "Mame Salane Thiongane" 13 "Débo Diop" 14 "Ndeye Aby Gaye" 15 "Papa amadou Dieye" 16 "Younousse Chérif Goudiaby" 17 "Marieme Boye" 18 "Ibrahima Thiam" 19 "Ahmed Sene" 20 "Mame Gnagna Diagne Kane" 21 "Latyr Diagne" 22 "Sokhna Beye" 23 "Abdoul Khadre Djeylani Gueye" 24 "Bah Fall" 25 "Ndeye Mareme Diop" 26 "Ousmane Mbengue" 27 "Amadou Gueye" 28 "Momar Diop" 29 "Serigne Sow" 30 "Christophe Diouf" 31 "Maimouna Kane" 32 "Tabasky Diouf" 33 "Ndeye Anna Thiam" 34 "Youssou Diallo" 35 "Abdourahmane Niang" 36 "Mame Diarra Bousso Ndao" 37 "Omar Cisse" 38 "Coumba Kane" 39 "Yacine Sall" 40 "Mamadou Mar" 41 "Nayèdio Ba" 42 "Mame Bousso FAYE" 43 "Rokhaya Gueye" 44 "Ousmane Samba Gaye" 45 "Ibrahima Diarra" 46 "Khardiata Kane" 47 "Idrissa Gaye" 48 "Mafoudya Camara" 49 "Mouhamed Fall" 50 "Pape Amadou Diop" 51 "Diarra Ndoye" 52 "Bintou Ly" 53 "Mame Mossane Biram Sarr" 54 "Adama Diaw" 55 "Maty Sarr" 56 "Mouhamadou Moustapha Ba" 57 "Serigne saliou Ngom" 58 "Mbaye Ndoye" 59 "Aminata Sall Diéye" 60 "Sophie Faye" 61 "Bintou Gueye" 62 "Louise Taky bonang" 63 "Salimata Diallo" 64 "Adama Ba" 65 "Mamour Diop" 66 "Ndeye Ouleye Sarr" 67 "Djiby Diouf" 68 "Madicke Gaye" 69 "Mouhamadou Sy" 70 "Sokhna Diaité" 71 "Aminata Harouna Diagne" 72 "Moussa Kane" 73 "Cheikh Ndao" 74 "Yaya Balde" 75 "Cheikh Modou Falilou Faye" 76 "Setigne Ousseynou Wade" 77 "Khadim Diouf" 78 "Awa Ndiaye" 79 "Dieynaba Tall" 80 "Souleymane Diol" 81 "Lamine Diop" 82 "Gnima Diedhiou" 83 "Clara Sadio" 84 "Fatoumata Diémé"
	label values enqueteur enqueteur

	label variable q201 "201. Quel âge aviez-vous lors de votre dernier anniversaire ?"
	note q201: "201. Quel âge aviez-vous lors de votre dernier anniversaire ?"

	label variable q202 "202. Sexe de l’agent de santé communautaire ASC ?"
	note q202: "202. Sexe de l’agent de santé communautaire ASC ?"
	label define q202 1 "Masculin" 2 "Féminin"
	label values q202 q202

	label variable q203 "203. Quelle est votre situation matrimoniale actuelle ?"
	note q203: "203. Quelle est votre situation matrimoniale actuelle ?"
	label define q203 1 "Marié(e)" 2 "Veuf/veuve" 3 "Divorcé(e)" 5 "Célibataire (jamais marié(e))" 6 "Préfère ne rien dire"
	label values q203 q203

	label variable q204 "204. Quel est le niveau scolaire le plus élevé que vous ayez atteint ?"
	note q204: "204. Quel est le niveau scolaire le plus élevé que vous ayez atteint ?"
	label define q204 1 "N’a jamais fréquenté l’école" 2 "Primaire" 3 "Collège (enseignement moyen)" 4 "Lycée (enseignement secondaire)" 5 "Université (enseignement supérieur)" 6 "Préfère ne rien dire"
	label values q204 q204

	label variable q205 "205. Êtes-vous engagé dans un travail autre que celui de la santé et de la prote"
	note q205: "205. Êtes-vous engagé dans un travail autre que celui de la santé et de la protection de l'enfance ?"
	label define q205 1 "Oui" 2 "Non" 3 "Préfère ne rien dire"
	label values q205 q205

	label variable q206 "206. Quelle est la nature de votre travail ?"
	note q206: "206. Quelle est la nature de votre travail ?"
	label define q206 1 "Cultivateur/ agriculteur" 2 "Travailleur agricole/ouvrier" 3 "Travailleur indépendant" 4 "Service privé" 5 "Autre (préciser)" 6 "Préfère ne pas dire"
	label values q206 q206

	label variable autre_travail "Autre"
	note autre_travail: "Autre"

	label variable q207 "207. Depuis combien de temps travaillez-vous en tant qu'ASC ?"
	note q207: "207. Depuis combien de temps travaillez-vous en tant qu'ASC ?"
	label define q207 1 "Année" 2 "Mois"
	label values q207 q207

	label variable q207a "Mettre le nombre d'années"
	note q207a: "Mettre le nombre d'années"

	label variable q207b "Mettre le nombre de mois"
	note q207b: "Mettre le nombre de mois"

	label variable q208 "208. Comment avez-vous été sélectionné comme ASC ?"
	note q208: "208. Comment avez-vous été sélectionné comme ASC ?"

	label variable autre_asc "Autre"
	note autre_asc: "Autre"

	label variable q209 "209. Qu'est-ce qui vous a motivé à devenir ASC ?"
	note q209: "209. Qu'est-ce qui vous a motivé à devenir ASC ?"

	label variable autres_motivation "Autre"
	note autres_motivation: "Autre"

	label variable q210 "210. En moyenne, quelle somme gagnez-vous en tant qu'ASC ?"
	note q210: "210. En moyenne, quelle somme gagnez-vous en tant qu'ASC ?"
	label define q210 1 "Montant mensuel" 2 "Pas de montant" 99 "Préfère ne pas se prononcer"
	label values q210 q210

	label variable montant "211. Montant mensuel"
	note montant: "211. Montant mensuel"

	label variable q212 "212. Quelle est la nature de votre contrat en tant qu’agent de santé communautai"
	note q212: "212. Quelle est la nature de votre contrat en tant qu’agent de santé communautaire ?"
	label define q212 1 "Bénevolat" 2 "Contractuel" 3 "Basé sur l’intéressement" 99 "Autres (préciser)"
	label values q212 q212

	label variable autres_contrat "Veuillez préciser la nature de votre contrat"
	note autres_contrat: "Veuillez préciser la nature de votre contrat"

	label variable q301 "301. Quelle est la taille de la population dans votre zone de polarisation ?"
	note q301: "301. Quelle est la taille de la population dans votre zone de polarisation ?"

	label variable q302 "302. Quel est le nombre total de ménages dans votre zone de polarisation ?"
	note q302: "302. Quel est le nombre total de ménages dans votre zone de polarisation ?"

	label variable q303 "303. Un autre agent de santé communautaire intervient-il dans votre zone de pola"
	note q303: "303. Un autre agent de santé communautaire intervient-il dans votre zone de polarisation ?"
	label define q303 1 "OUI" 2 "NON"
	label values q303 q303

	label variable q304 "304. Au total, combien d'autres ASC travaillent dans votre zone de polarisation "
	note q304: "304. Au total, combien d'autres ASC travaillent dans votre zone de polarisation ?"

	label variable q304a "304a. Combien de ménages sont couverts par les services fournis par vous ou par "
	note q304a: "304a. Combien de ménages sont couverts par les services fournis par vous ou par d'autres ASC dans votre zone de polarisation ?"

	label variable q305 "305. Quelle est la distance (en Km) entre votre domicile et le foyer le plus élo"
	note q305: "305. Quelle est la distance (en Km) entre votre domicile et le foyer le plus éloigné pour vos activités ?"

	label variable q306 "306. Quel est le principal moyen de transport que vous utilisez pour vous rendre"
	note q306: "306. Quel est le principal moyen de transport que vous utilisez pour vous rendre au foyer le plus éloigné ?"
	label define q306 1 "Véhicule personnel" 2 "Transport public" 3 "Marche" 4 "Moto personnel" 5 "Vélo personnel" 6 "Charrette"
	label values q306 q306

	label variable q307 "307. Combien de temps (en minutes) faut-il pour atteindre le ménage le plus éloi"
	note q307: "307. Combien de temps (en minutes) faut-il pour atteindre le ménage le plus éloigné ?"

	label variable q308 "308. Habitez-vous dans votre zone de polarisation ?"
	note q308: "308. Habitez-vous dans votre zone de polarisation ?"
	label define q308 1 "OUI" 2 "NON"
	label values q308 q308

	label variable q309 "309. Quelle est la distance (en Km) qui vous sépare de votre zone de polarisatio"
	note q309: "309. Quelle est la distance (en Km) qui vous sépare de votre zone de polarisation ?"

	label variable q310 "310. Comment décririez-vous le statut socio-économique de votre zone de polarisa"
	note q310: "310. Comment décririez-vous le statut socio-économique de votre zone de polarisation (perception) ?"
	label define q310 1 "Bas" 2 "Moyen" 3 "Élevé" 4 "Incertain/Préfère ne pas se prononcer"
	label values q310 q310

	label variable q311 "311. Lesquels de ces établissements de santé sont disponibles dans votre zone de"
	note q311: "311. Lesquels de ces établissements de santé sont disponibles dans votre zone de polarisation ?"

	label variable autre_311 "Autres"
	note autre_311: "Autres"

	label variable q312 "312. Quelle est la distance (en Km) qui sépare le centre de soins de santé le pl"
	note q312: "312. Quelle est la distance (en Km) qui sépare le centre de soins de santé le plus proche de votre zone de polarisation ?"

	label variable q313 "313. Selon vous, quel est le degré d'accessibilité des structures de santé dans "
	note q313: "313. Selon vous, quel est le degré d'accessibilité des structures de santé dans votre zone de polarisation ?"
	label define q313 1 "Très accessible" 2 "Quelquefois accessible" 3 "Pas très accessible" 4 "Pas du tout accessible"
	label values q313 q313

	label variable q314 "314. Selon vous, quels sont les principaux facteurs qui influencent les pratique"
	note q314: "314. Selon vous, quels sont les principaux facteurs qui influencent les pratiques de planification familiale dans votre zone de polarisation ?"

	label variable autre_314 "Autres"
	note autre_314: "Autres"

	label variable q401 "401. Quels sont les principaux domaines des services de santé que vous fournisse"
	note q401: "401. Quels sont les principaux domaines des services de santé que vous fournissez en tant qu'ASC ?"

	label variable autre_domaine_sante "Veuillez préciser les autres domaines"
	note autre_domaine_sante: "Veuillez préciser les autres domaines"

	label variable q402 "402. Quelles sont les activités spécifiques que vous exercez dans le domaine de "
	note q402: "402. Quelles sont les activités spécifiques que vous exercez dans le domaine de la planification familiale ?"

	label variable autre "Veuillez préciser les autres activités"
	note autre: "Veuillez préciser les autres activités"

	label variable q403 "403. Quelles sont les activités spécifiques que vous exercez dans le domaine de "
	note q403: "403. Quelles sont les activités spécifiques que vous exercez dans le domaine de la santé maternelle et infantile ?"

	label variable autre_403 "Veuillez préciser les autres activités"
	note autre_403: "Veuillez préciser les autres activités"

	label variable q404 "404. En moyenne, combien d'heures par jour consacrez-vous à vos activités en tan"
	note q404: "404. En moyenne, combien d'heures par jour consacrez-vous à vos activités en tant qu'ASC ?"

	label variable q405 "405. Effectuez-vous des visites individuelles à domicile et des réunions/séances"
	note q405: "405. Effectuez-vous des visites individuelles à domicile et des réunions/séances de groupe dans votre communauté/zone de polarisation ?"
	label define q405 1 "Seulement des visites individuelles à domicile" 2 "Uniquement des réunions/séances de groupe" 3 "Les deux" 4 "Non Applicable"
	label values q405 q405

	label variable q406a1 "PF"
	note q406a1: "PF"

	label variable q406a2 "Soins prénatals"
	note q406a2: "Soins prénatals"

	label variable q406b1 "Soins postnatals"
	note q406b1: "Soins postnatals"

	label variable q406b2 "Vaccination des enfants"
	note q406b2: "Vaccination des enfants"

	label variable q406c1 "Soins néonatals à domicile"
	note q406c1: "Soins néonatals à domicile"

	label variable q406c2 "Nutrition"
	note q406c2: "Nutrition"

	label variable q406d1 "Hygiène personnelle"
	note q406d1: "Hygiène personnelle"

	label variable q406d2 "PF"
	note q406d2: "PF"

	label variable q406e1 "Soins prénatals"
	note q406e1: "Soins prénatals"

	label variable q406e2 "Soins postnatals"
	note q406e2: "Soins postnatals"

	label variable q406f1 "Vaccination des enfants"
	note q406f1: "Vaccination des enfants"

	label variable q406f2 "Soins néonatals à domicile"
	note q406f2: "Soins néonatals à domicile"

	label variable q406g1 "Nutrition"
	note q406g1: "Nutrition"

	label variable q406g2 "Hygiène personnelle"
	note q406g2: "Hygiène personnelle"

	label variable q407 "407. Disposez-vous d'outils de travail ou de matériel d'information, d'éducation"
	note q407: "407. Disposez-vous d'outils de travail ou de matériel d'information, d'éducation et de communication à utiliser dans le cadre de votre travail quotidien ?"
	label define q407 1 "OUI" 2 "NON"
	label values q407 q407

	label variable q408 "408. Utilisez-vous ou vous référez-vous à ces aides au travail ou à ce matériel "
	note q408: "408. Utilisez-vous ou vous référez-vous à ces aides au travail ou à ce matériel d'information, d'éducation et de communicationdans votre travail de routine ?"
	label define q408 1 "OUI" 2 "NON"
	label values q408 q408

	label variable q501 "501. Avez-vous reçu une formation pour vos fonctions/devoirs en tant qu'ASC ?"
	note q501: "501. Avez-vous reçu une formation pour vos fonctions/devoirs en tant qu'ASC ?"
	label define q501 1 "Oui, en cours d’exercice" 2 "Oui, avant l’exercice" 3 "Oui, les deux (formation initiale/formation continue)" 4 "Aucun"
	label values q501 q501

	label variable q502 "502. Quels étaient les thèmes abordés lors de la formation ?"
	note q502: "502. Quels étaient les thèmes abordés lors de la formation ?"

	label variable autre_502 "Veuillez préciser les autres thèmes"
	note autre_502: "Veuillez préciser les autres thèmes"

	label variable q503_date "503.a. A quand date la dernière formation ?"
	note q503_date: "503.a. A quand date la dernière formation ?"

	label variable q503b "503b. Pendant combien de jours s'est déroulée la dernière formation ?"
	note q503b: "503b. Pendant combien de jours s'est déroulée la dernière formation ?"

	label variable q504 "504. Sur une echelle de 1 à 5, quelle est votre niveau de satisfaction du conten"
	note q504: "504. Sur une echelle de 1 à 5, quelle est votre niveau de satisfaction du contenu de la formation et de son applicabilité dans votre travail ?"
	label define q504 1 "Très satisfait" 2 "Satisfait" 3 "Neutre" 4 "Insatisfait" 5 "Très insatisfait" 8 "Sans objet (n'a pas participé à la formation)"
	label values q504 q504

	label variable q504a "504a. Selon les directives nationales, combien de modules de formation devez-vou"
	note q504a: "504a. Selon les directives nationales, combien de modules de formation devez-vous suivre en tant qu'ASC ?"

	label variable q504b "504b. Combien de modules de formation avez-vous suivis ?"
	note q504b: "504b. Combien de modules de formation avez-vous suivis ?"

	label variable q505 "505. Avez-vous un superviseur ou quelqu'un d'autre qui surveille votre travail ?"
	note q505: "505. Avez-vous un superviseur ou quelqu'un d'autre qui surveille votre travail ?"
	label define q505 1 "OUI" 2 "NON"
	label values q505 q505

	label variable q506 "506. À quelle fréquence rencontrez-vous votre supérieur hiérarchique ?"
	note q506: "506. À quelle fréquence rencontrez-vous votre supérieur hiérarchique ?"
	label define q506 1 "Quotidien" 2 "Hebdomadaire" 3 "Une fois toutes les deux semaines" 4 "Une fois par mois" 5 "Occasionnellement (moins d’une fois par mois)" 6 "Seulement quand cela est nécessaire" 96 "Autre (préciser)"
	label values q506 q506

	label variable autre_506 "Veuillez préciser la fréquence"
	note autre_506: "Veuillez préciser la fréquence"

	label variable q507 "507. Où rencontrez-vous généralement votre superviseur ?"
	note q507: "507. Où rencontrez-vous généralement votre superviseur ?"
	label define q507 1 "Sur le terrain" 2 "Établissement de santé" 3 "Site de vaccination" 4 "Réunion autour de poste" 5 "Session de formation" 6 "Autre (préciser)"
	label values q507 q507

	label variable autres_507 "Veuillez préciser le lieu"
	note autres_507: "Veuillez préciser le lieu"

	label variable a "Vérifier l’exactitude de votre registre et de vos rapports"
	note a: "Vérifier l’exactitude de votre registre et de vos rapports"
	label define a 1 "OUI" 2 "NON"
	label values a a

	label variable b "Vous observer lors des visites à domicile"
	note b: "Vous observer lors des visites à domicile"
	label define b 1 "OUI" 2 "NON"
	label values b b

	label variable c "Vous fournir un retour d’information direct sur vos performances"
	note c: "Vous fournir un retour d’information direct sur vos performances"
	label define c 1 "OUI" 2 "NON"
	label values c c

	label variable d "Vous fournir des ressources techniques et des informations pour vous aider à app"
	note d: "Vous fournir des ressources techniques et des informations pour vous aider à apprendre et à mieux faire votre travail"
	label define d 1 "OUI" 2 "NON"
	label values d d

	label variable e "Vous aider à résoudre les problèmes ou les difficultés auxquels vous êtes confro"
	note e: "Vous aider à résoudre les problèmes ou les difficultés auxquels vous êtes confrontés"
	label define e 1 "OUI" 2 "NON"
	label values e e

	label variable q509 "509. Votre superviseur vous a-t-il rendu visite sur le terrain au cours du derni"
	note q509: "509. Votre superviseur vous a-t-il rendu visite sur le terrain au cours du dernier mois écoulé ?"
	label define q509 1 "OUI" 2 "NON"
	label values q509 q509

	label variable q510 "510. Quand avez-vous rencontré votre supérieur hiérarchique pour la dernière foi"
	note q510: "510. Quand avez-vous rencontré votre supérieur hiérarchique pour la dernière fois ?"

	label variable q511a "Vérifier l’exactitude de votre registre et de vos rapports"
	note q511a: "Vérifier l’exactitude de votre registre et de vos rapports"
	label define q511a 1 "OUI" 2 "NON"
	label values q511a q511a

	label variable q511b "Vous observer lors des visites à domicile"
	note q511b: "Vous observer lors des visites à domicile"
	label define q511b 1 "OUI" 2 "NON"
	label values q511b q511b

	label variable q511c "Vous fournir un retour d’information direct sur vos performances"
	note q511c: "Vous fournir un retour d’information direct sur vos performances"
	label define q511c 1 "OUI" 2 "NON"
	label values q511c q511c

	label variable q511d "Vous fournir des ressources techniques et des informations pour vous aider à app"
	note q511d: "Vous fournir des ressources techniques et des informations pour vous aider à apprendre et à mieux faire votre travail"
	label define q511d 1 "OUI" 2 "NON"
	label values q511d q511d

	label variable q511e "Vous aider à résoudre les problèmes ou les difficultés auxquels vous êtes confro"
	note q511e: "Vous aider à résoudre les problèmes ou les difficultés auxquels vous êtes confrontés"
	label define q511e 1 "OUI" 2 "NON"
	label values q511e q511e

	label variable q601 "601. Selon vous, quel est l’âge approprié pour qu’une femme tombe enceinte pour "
	note q601: "601. Selon vous, quel est l’âge approprié pour qu’une femme tombe enceinte pour la première fois ?"

	label variable q602 "602. Selon vous, quels sont les avantages pour la santé d’une femme si elle tomb"
	note q602: "602. Selon vous, quels sont les avantages pour la santé d’une femme si elle tombe enceinte à l’âge approprié que vous avez mentionné ?"

	label variable autre_602 "Autre"
	note autre_602: "Autre"

	label variable q603 "603.Selon vous, quel devrait être l’espacement minimum entre deux naissances con"
	note q603: "603.Selon vous, quel devrait être l’espacement minimum entre deux naissances consécutives ? (En mois)"

	label variable q604 "604. Selon vous, quels sont les bénéfices de l’espacement des naissances pour un"
	note q604: "604. Selon vous, quels sont les bénéfices de l’espacement des naissances pour une femme ?"

	label variable autre_604 "Autre"
	note autre_604: "Autre"

	label variable q605 "605. Selon vous, quel(s) avantage(s) sanitaire(s) un enfant aura-t-il si les nai"
	note q605: "605. Selon vous, quel(s) avantage(s) sanitaire(s) un enfant aura-t-il si les naissances sont espacées ?"

	label variable autre_605 "Autre"
	note autre_605: "Autre"

	label variable q606 "606. Selon vous, combien de mois une femme doit-elle attendre après un avortemen"
	note q606: "606. Selon vous, combien de mois une femme doit-elle attendre après un avortement spontané ou provoqué pour retomber enceinte ?"

	label variable q607 "607. Selon vous, quels sont les avantages pour les femmes d’attendre au lieu de "
	note q607: "607. Selon vous, quels sont les avantages pour les femmes d’attendre au lieu de tomber enceinte immédiatement après un avortement ?"

	label variable autre_607 "Autre"
	note autre_607: "Autre"

	label variable q608 "608. Que dites de l’assertion suivante « une femme a plus de chances de tomber e"
	note q608: "608. Que dites de l’assertion suivante « une femme a plus de chances de tomber enceinte si elle a des rapports sexuels à certains jours de son cycle menstruel ». Est-elle vrai ou fausse ?"
	label define q608 1 "Vrai" 2 "Fausse" 3 "Ne sais pas"
	label values q608 q608

	label variable q609 "609. Quelle est la période du cycle menstruel où les chances de tomber enceinte "
	note q609: "609. Quelle est la période du cycle menstruel où les chances de tomber enceinte sont les plus élevées ?"
	label define q609 1 "7 jours avant le début des règles" 2 "Jusqu’à 7 jours après le début des règles" 3 "Du 8e au 20e jour après la menstruation" 99 "Ne sait pas"
	label values q609 q609

	label variable q610 "610. Quelles sont les méthodes contraceptives dont vous avez entendu parler ?"
	note q610: "610. Quelles sont les méthodes contraceptives dont vous avez entendu parler ?"

	label variable q610_1_1 "DUI"
	note q610_1_1: "DUI"
	label define q610_1_1 1 "Oui après incitation" 3 "Non après incitation"
	label values q610_1_1 q610_1_1

	label variable q610_1_2 "Injectables"
	note q610_1_2: "Injectables"
	label define q610_1_2 1 "Oui après incitation" 3 "Non après incitation"
	label values q610_1_2 q610_1_2

	label variable q610_1_3 "Préservatifs (Féminin)"
	note q610_1_3: "Préservatifs (Féminin)"
	label define q610_1_3 1 "Oui après incitation" 3 "Non après incitation"
	label values q610_1_3 q610_1_3

	label variable q610_1_4 "Préservatifs (Masculin)"
	note q610_1_4: "Préservatifs (Masculin)"
	label define q610_1_4 1 "Oui après incitation" 3 "Non après incitation"
	label values q610_1_4 q610_1_4

	label variable q610_1_5 "Contraception d’urgence"
	note q610_1_5: "Contraception d’urgence"
	label define q610_1_5 1 "Oui après incitation" 3 "Non après incitation"
	label values q610_1_5 q610_1_5

	label variable q610_1_6 "Pilules"
	note q610_1_6: "Pilules"
	label define q610_1_6 1 "Oui après incitation" 3 "Non après incitation"
	label values q610_1_6 q610_1_6

	label variable q610_1_7 "Implants"
	note q610_1_7: "Implants"
	label define q610_1_7 1 "Oui après incitation" 3 "Non après incitation"
	label values q610_1_7 q610_1_7

	label variable q610_1_8 "Stérilisation féminine"
	note q610_1_8: "Stérilisation féminine"
	label define q610_1_8 1 "Oui après incitation" 3 "Non après incitation"
	label values q610_1_8 q610_1_8

	label variable q610_1_9 "Stérilisation masculine"
	note q610_1_9: "Stérilisation masculine"
	label define q610_1_9 1 "Oui après incitation" 3 "Non après incitation"
	label values q610_1_9 q610_1_9

	label variable q610_1_10 "Allaitement maternel exclusif"
	note q610_1_10: "Allaitement maternel exclusif"
	label define q610_1_10 1 "Oui après incitation" 3 "Non après incitation"
	label values q610_1_10 q610_1_10

	label variable q610_1_11 "Méthode des jours fixes"
	note q610_1_11: "Méthode des jours fixes"
	label define q610_1_11 1 "Oui après incitation" 3 "Non après incitation"
	label values q610_1_11 q610_1_11

	label variable q610b "610b. Quelles sont les méthodes contraceptives préférées dans votre lieu de trav"
	note q610b: "610b. Quelles sont les méthodes contraceptives préférées dans votre lieu de travail/localité ?"

	label variable autre_610 "Veuillez préciser les autres méthodes"
	note autre_610: "Veuillez préciser les autres méthodes"

	label variable q611 "611. Vous avez dit que vous-avez entendu parler de DIU. Quels sont les avantages"
	note q611: "611. Vous avez dit que vous-avez entendu parler de DIU. Quels sont les avantages d’utiliser cette méthode ?"

	label variable autre_611 "Veuillez préciser les autres avantages"
	note autre_611: "Veuillez préciser les autres avantages"

	label variable q612 "612. Quels sont les problèmes auxquels les clients font face lors de l’utilisati"
	note q612: "612. Quels sont les problèmes auxquels les clients font face lors de l’utilisation de DIU ?"

	label variable autre_612 "Veuillez préciser les autres problèmes"
	note autre_612: "Veuillez préciser les autres problèmes"

	label variable q613 "613. Quels sont les états de santé et les situations dans lesquels une femme ne "
	note q613: "613. Quels sont les états de santé et les situations dans lesquels une femme ne devrait pas utiliser de DIU ?"

	label variable autre_613 "Veuillez préciser les états de santé"
	note autre_613: "Veuillez préciser les états de santé"

	label variable q614 "614. Selon vous, cette méthode est-elle adaptée pour retarder la première naissa"
	note q614: "614. Selon vous, cette méthode est-elle adaptée pour retarder la première naissance ?"
	label define q614 1 "Oui" 2 "Non" 3 "Ne sais pas"
	label values q614 q614

	label variable q615 "615. Selon vous, cette méthode est-elle adaptée au maintien de l’intervalle entr"
	note q615: "615. Selon vous, cette méthode est-elle adaptée au maintien de l’intervalle entre deux naissances ?"
	label define q615 1 "Oui" 2 "Non" 3 "Ne sais pas"
	label values q615 q615

	label variable q616 "616. Pensez-vous que les légers saignements après l’insertion de DIU sont normau"
	note q616: "616. Pensez-vous que les légers saignements après l’insertion de DIU sont normaux ?"
	label define q616 1 "Oui" 2 "Non" 3 "Ne sais pas"
	label values q616 q616

	label variable q617 "617. Selon vous, quel est le moment le plus recommandé pour insérer à une femme "
	note q617: "617. Selon vous, quel est le moment le plus recommandé pour insérer à une femme un DIU ?"

	label variable q617_autre "617. Autre recommandation"
	note q617_autre: "617. Autre recommandation"

	label variable q618 "618. Selon vous, qui peut insérer un DIU ?"
	note q618: "618. Selon vous, qui peut insérer un DIU ?"

	label variable autre_618 "Veuillez préciser les autres"
	note autre_618: "Veuillez préciser les autres"

	label variable q619 "619. Que dites-vous à une femme pour vérifier si le DUI est en place ?"
	note q619: "619. Que dites-vous à une femme pour vérifier si le DUI est en place ?"

	label variable autre_619 "Veuillez préciser les autres choses que vous lui dites"
	note autre_619: "Veuillez préciser les autres choses que vous lui dites"

	label variable q620 "620. Pouvez-vous nous dire la fréquence d’utilisation des pilules ?"
	note q620: "620. Pouvez-vous nous dire la fréquence d’utilisation des pilules ?"
	label define q620 1 "Chaque jour" 2 "Chaque semaine" 3 "Les deux" 99 "Ne sais pas"
	label values q620 q620

	label variable q621 "621. Quels sont les problémes auxquels les femmes peuvent faire face durant/aprè"
	note q621: "621. Quels sont les problémes auxquels les femmes peuvent faire face durant/après la prise d’une pilule ?"

	label variable autre_621 "Veuillez préciser les autres problèmes"
	note autre_621: "Veuillez préciser les autres problèmes"

	label variable q622 "622. Quelles sont les situations sanitaires pour lesquelles la prise de pilules "
	note q622: "622. Quelles sont les situations sanitaires pour lesquelles la prise de pilules chez la femme pourrait être dangeureuse ?"

	label variable autre_622 "Veuillez préciser les autres situations"
	note autre_622: "Veuillez préciser les autres situations"

	label variable q623 "623. Pensez-vous que les pilules peuvent être conseillées à la femme qui allaite"
	note q623: "623. Pensez-vous que les pilules peuvent être conseillées à la femme qui allaite ?"
	label define q623 1 "Oui" 2 "Non" 3 "Ne sais pas"
	label values q623 q623

	label variable q624 "624. A votre avis, quand est ce qu’une femme doit commencer à prendre la pilule "
	note q624: "624. A votre avis, quand est ce qu’une femme doit commencer à prendre la pilule ?"

	label variable autre_624 "Veuillez préciser la période"
	note autre_624: "Veuillez préciser la période"

	label variable q625 "625. Pour être efficace, quand est-ce que les préservatifs doivent être utilisés"
	note q625: "625. Pour être efficace, quand est-ce que les préservatifs doivent être utilisés ?"
	label define q625 1 "À chaque rapport sexuel" 2 "Autre réponse" 8 "Ne sais pas"
	label values q625 q625

	label variable autre_625 "Veuillez préciser"
	note autre_625: "Veuillez préciser"

	label variable q626 "626. Combien de fois peut-on utiliser un préservatif lors d’un rapport sexuel ?"
	note q626: "626. Combien de fois peut-on utiliser un préservatif lors d’un rapport sexuel ?"
	label define q626 1 "Une fois" 2 "Deux fois" 3 "Plus de deux fois" 8 "Ne sais pas"
	label values q626 q626

	label variable q627 "627. Quels sont les avantages d’utiliser un préservatif ?"
	note q627: "627. Quels sont les avantages d’utiliser un préservatif ?"

	label variable autre_627 "Veuillez préciser les autres avantages"
	note autre_627: "Veuillez préciser les autres avantages"

	label variable q628 "628. Quels sont les problémes auxquels un client peut faire face lors de l’utili"
	note q628: "628. Quels sont les problémes auxquels un client peut faire face lors de l’utilisation d’un préservatif ?"

	label variable autre_628 "Veuillez préciser les autres problèmes"
	note autre_628: "Veuillez préciser les autres problèmes"

	label variable q629 "629. Selon vous, cette méthode est-elle adaptée pour retarder la première naissa"
	note q629: "629. Selon vous, cette méthode est-elle adaptée pour retarder la première naissance ?"
	label define q629 1 "Oui" 2 "Non" 3 "Ne sais pas"
	label values q629 q629

	label variable q6230 "630. Selon vous, cette méthode est-elle adaptée au maintien de l’intervalle entr"
	note q6230: "630. Selon vous, cette méthode est-elle adaptée au maintien de l’intervalle entre deux naissances ?"
	label define q6230 1 "Oui" 2 "Non" 3 "Ne sais pas"
	label values q6230 q6230

	label variable q631 "631. Selon vous, cette méthode est-elle adaptée pour la limitation des naissance"
	note q631: "631. Selon vous, cette méthode est-elle adaptée pour la limitation des naissances ?"
	label define q631 1 "Oui" 2 "Non" 3 "Ne sais pas"
	label values q631 q631

	label variable q632 "632. Supposons qu’une femme soutaite utiliser un produit injectable. Selon vous,"
	note q632: "632. Supposons qu’une femme soutaite utiliser un produit injectable. Selon vous, quand doit-elle prendre sa première dose de produit injectable ?"

	label variable autre_632 "Veuillez préciser la bonne période"
	note autre_632: "Veuillez préciser la bonne période"

	label variable q633 "633. Selon vous, quels sont les bénéfices d’utiliser des contraceptifs injectabl"
	note q633: "633. Selon vous, quels sont les bénéfices d’utiliser des contraceptifs injectables ou pourquoi une femme devrait utiliser cette méthode ?"

	label variable autre_633 "Veuillez préciser les autres bénéfices"
	note autre_633: "Veuillez préciser les autres bénéfices"

	label variable q634 "634. Quels sont les problèmes auxquels un client peut faire face après qu’on lui"
	note q634: "634. Quels sont les problèmes auxquels un client peut faire face après qu’on lui ait administré un injectable ?"

	label variable autre_634 "Veuillez préciser les autres problèmes"
	note autre_634: "Veuillez préciser les autres problèmes"

	label variable q635 "635. Selon vous, cette méthode est-elle adaptée pour retarder la première naissa"
	note q635: "635. Selon vous, cette méthode est-elle adaptée pour retarder la première naissance ?"
	label define q635 1 "Oui" 2 "Non" 3 "Ne sais pas"
	label values q635 q635

	label variable q636 "636. Selon vous, cette méthode est-elle adaptée au maintien de l’intervalle entr"
	note q636: "636. Selon vous, cette méthode est-elle adaptée au maintien de l’intervalle entre deux naissances ?"
	label define q636 1 "Oui" 2 "Non" 3 "Ne sais pas"
	label values q636 q636

	label variable q637 "637. Selon vous, cette méthode est-elle adaptée pour la limitation des naissance"
	note q637: "637. Selon vous, cette méthode est-elle adaptée pour la limitation des naissances ?"
	label define q637 1 "Oui" 2 "Non" 3 "Ne sais pas"
	label values q637 q637

	label variable q638 "638. Après la première prise de contraceptif injectable, dans combien de mois la"
	note q638: "638. Après la première prise de contraceptif injectable, dans combien de mois la dose suivante doit-elle être administrée ?"

	label variable q639 "639. Selon vous, quels sont les bénéfices d’utiliser des implants ou pourquoi un"
	note q639: "639. Selon vous, quels sont les bénéfices d’utiliser des implants ou pourquoi une femme devrait utiliser cette méthode ?"

	label variable autre_639 "Veuillez préciser les autres bénéfices"
	note autre_639: "Veuillez préciser les autres bénéfices"

	label variable q640 "640. Quels sont les problémes auxquels un client peut faire face après qu’on lui"
	note q640: "640. Quels sont les problémes auxquels un client peut faire face après qu’on lui ait inséré un implant ?"

	label variable autre_640 "Veuillez préciser les autres problèmes"
	note autre_640: "Veuillez préciser les autres problèmes"

	label variable q641 "641. Quelle est la durée de la période d’efficacité des implants dans la prévent"
	note q641: "641. Quelle est la durée de la période d’efficacité des implants dans la prévention de la grossesse ?"
	label define q641 1 "3-5 ans" 6 "Autres réponses" 8 "Ne sais pas"
	label values q641 q641

	label variable autre_641 "Veuillez préciser la durée"
	note autre_641: "Veuillez préciser la durée"

	label variable q642 "642. Savez-vous où les implants doivent être insérés ?"
	note q642: "642. Savez-vous où les implants doivent être insérés ?"
	label define q642 1 "Partie supérieure du bras" 6 "Autres réponses" 8 "Ne sais pas"
	label values q642 q642

	label variable autre_642 "Veuillez préciser l'endroit"
	note autre_642: "Veuillez préciser l'endroit"

	label variable q643 "643. Selon vous, qui peut effectuer la pose d’implants ?"
	note q643: "643. Selon vous, qui peut effectuer la pose d’implants ?"

	label variable autre_643 "Veuillez préciser"
	note autre_643: "Veuillez préciser"

	label variable q644 "644. Selon vous, cette méthode est-elle adaptée pour retarder la première naissa"
	note q644: "644. Selon vous, cette méthode est-elle adaptée pour retarder la première naissance ?"
	label define q644 1 "Oui" 2 "Non" 3 "Ne sais pas"
	label values q644 q644

	label variable q645 "645. Selon vous, cette méthode est-elle adaptée au maintien de l’intervalle entr"
	note q645: "645. Selon vous, cette méthode est-elle adaptée au maintien de l’intervalle entre deux naissances ?"
	label define q645 1 "Oui" 2 "Non" 3 "Ne sais pas"
	label values q645 q645

	label variable q646 "646. Selon vous, cette méthode est-elle adaptée pour la limitation des naissance"
	note q646: "646. Selon vous, cette méthode est-elle adaptée pour la limitation des naissances ?"
	label define q646 1 "Oui" 2 "Non" 3 "Ne sais pas"
	label values q646 q646

	label variable q647 "647. Savez-vous que la contraception d’urgence peut être prise peu de temps aprè"
	note q647: "647. Savez-vous que la contraception d’urgence peut être prise peu de temps après un rapport sexuel non protégé ?"
	label define q647 1 "OUI" 2 "NON"
	label values q647 q647

	label variable q648 "648. Quel est le nombre d’heures maximal après un rapport sexuel non protégé, po"
	note q648: "648. Quel est le nombre d’heures maximal après un rapport sexuel non protégé, pour qu’une contraceptiond’urgence (CU) puisse être prise ?"

	label variable q649 "649. Pensez-vous qu’une CU peut avoir été efficace bien que la femme soit tombée"
	note q649: "649. Pensez-vous qu’une CU peut avoir été efficace bien que la femme soit tombée enceinte ?"
	label define q649 1 "OUI" 2 "NON"
	label values q649 q649

	label variable q650 "650. Pensez-vous que la CU peut être utilisée comme une méthode de contraception"
	note q650: "650. Pensez-vous que la CU peut être utilisée comme une méthode de contraception régulière ?"
	label define q650 1 "Oui" 2 "Non" 3 "Ne sais pas"
	label values q650 q650

	label variable q651 "651. Selon vous, cette méthode est-elle adaptée pour retarder la première naissa"
	note q651: "651. Selon vous, cette méthode est-elle adaptée pour retarder la première naissance ?"
	label define q651 1 "Oui" 2 "Non" 3 "Ne sais pas"
	label values q651 q651

	label variable q652 "652. Selon vous, cette méthode est-elle adaptée au maintien de l’intervalle entr"
	note q652: "652. Selon vous, cette méthode est-elle adaptée au maintien de l’intervalle entre deux naissances ?"
	label define q652 1 "Oui" 2 "Non" 3 "Ne sais pas"
	label values q652 q652

	label variable q653 "653. Selon vous, cette méthode est-elle adaptée pour la limitation des naissance"
	note q653: "653. Selon vous, cette méthode est-elle adaptée pour la limitation des naissances ?"
	label define q653 1 "Oui" 2 "Non" 3 "Ne sais pas"
	label values q653 q653

	label variable q654 "654. Selon vous, quels sont les bénéfices d’adopter la sterilisation féminine ou"
	note q654: "654. Selon vous, quels sont les bénéfices d’adopter la sterilisation féminine ou pourquoi une femme devrait utiliser cette méthode ?"

	label variable autre_654 "Veuillez préciser les autres bénéfices"
	note autre_654: "Veuillez préciser les autres bénéfices"

	label variable q655 "655. Quels sont les problèmes auxquels un client peut faire face pendant ou aprè"
	note q655: "655. Quels sont les problèmes auxquels un client peut faire face pendant ou après une stérilisation féminine, y compris la procedure post-partum/post avortement"

	label variable autre_655 "Veuillez préciser les autres problèmes"
	note autre_655: "Veuillez préciser les autres problèmes"

	label variable q656 "656. Selon vous, cette méthode est-t-elle adaptée pour la limitation des naissan"
	note q656: "656. Selon vous, cette méthode est-t-elle adaptée pour la limitation des naissances ?"
	label define q656 1 "Oui" 2 "Non" 3 "Ne sais pas"
	label values q656 q656

	label variable q657 "657. Quels sont les problèmes auxquels un client peut faire face pendant ou aprè"
	note q657: "657. Quels sont les problèmes auxquels un client peut faire face pendant ou après une stérilisation féminine, y compris la procédure post-partum/post avortement"

	label variable autre_657 "Veuillez préciser les autres problèmes"
	note autre_657: "Veuillez préciser les autres problèmes"

	label variable q658 "658. Quels sont les problèmes auxquels un client peut faire face pendant ou aprè"
	note q658: "658. Quels sont les problèmes auxquels un client peut faire face pendant ou après une stérilisation féminine, y compris la procédure post-partum/post avortement"

	label variable autre_658 "Veuillez préciser les autres problèmes"
	note autre_658: "Veuillez préciser les autres problèmes"

	label variable q659 "659. Selon vous, cette méthode est-t-elle adaptée pour la limitation des naissan"
	note q659: "659. Selon vous, cette méthode est-t-elle adaptée pour la limitation des naissances ?, cette méthode est-t-elle adaptée pour la limitation des naissances ?"
	label define q659 1 "Oui" 2 "Non" 3 "Ne sais pas"
	label values q659 q659

	label variable q660 "660. Selon vous, pourquoi est-il important pour les femmes et les couples d’util"
	note q660: "660. Selon vous, pourquoi est-il important pour les femmes et les couples d’utiliser des méthodes de contraception ?"

	label variable autre_660 "Veuillez préciser l'importance"
	note autre_660: "Veuillez préciser l'importance"

	label variable qa "Il est important de parler des méthodes contraceptives, quel que soit le sexe."
	note qa: "Il est important de parler des méthodes contraceptives, quel que soit le sexe."
	label define qa 1 "Pas du tout d’accord" 2 "Pas d’accord" 3 "Neutre" 4 "D’accord" 5 "Tout à fait d’accord"
	label values qa qa

	label variable qb "Les informations sur la planification familiale ne doivent être données qu'à ceu"
	note qb: "Les informations sur la planification familiale ne doivent être données qu'à ceux qui en font explicitement la demande"
	label define qb 1 "Pas du tout d’accord" 2 "Pas d’accord" 3 "Neutre" 4 "D’accord" 5 "Tout à fait d’accord"
	label values qb qb

	label variable qc "Les conseils en matière de PF doivent être fournis aux garçons et aux filles non"
	note qc: "Les conseils en matière de PF doivent être fournis aux garçons et aux filles non mariés."
	label define qc 1 "Pas du tout d’accord" 2 "Pas d’accord" 3 "Neutre" 4 "D’accord" 5 "Tout à fait d’accord"
	label values qc qc

	label variable qd "L'utilisation de méthodes contraceptives est importante pour les femmes/hommes e"
	note qd: "L'utilisation de méthodes contraceptives est importante pour les femmes/hommes en âge de procréer."
	label define qd 1 "Pas du tout d’accord" 2 "Pas d’accord" 3 "Neutre" 4 "D’accord" 5 "Tout à fait d’accord"
	label values qd qd

	label variable qe "Les connaissances en matière de planification familiale augmenteront les relatio"
	note qe: "Les connaissances en matière de planification familiale augmenteront les relations sexuelles avant le mariage."
	label define qe 1 "Pas du tout d’accord" 2 "Pas d’accord" 3 "Neutre" 4 "D’accord" 5 "Tout à fait d’accord"
	label values qe qe

	label variable qf "Les contraceptifs affectent le désir sexuel du partenaire."
	note qf: "Les contraceptifs affectent le désir sexuel du partenaire."
	label define qf 1 "Pas du tout d’accord" 2 "Pas d’accord" 3 "Neutre" 4 "D’accord" 5 "Tout à fait d’accord"
	label values qf qf

	label variable qg "Les méthodes contraceptives ont un impact négatif sur la pratique de la religion"
	note qg: "Les méthodes contraceptives ont un impact négatif sur la pratique de la religion."
	label define qg 1 "Pas du tout d’accord" 2 "Pas d’accord" 3 "Neutre" 4 "D’accord" 5 "Tout à fait d’accord"
	label values qg qg

	label variable qh "Les contraceptifs affectent les activités quotidiennes des femmes."
	note qh: "Les contraceptifs affectent les activités quotidiennes des femmes."
	label define qh 1 "Pas du tout d’accord" 2 "Pas d’accord" 3 "Neutre" 4 "D’accord" 5 "Tout à fait d’accord"
	label values qh qh

	label variable qi "L'éducation à la planification familiale devrait être incluse dans le programme "
	note qi: "L'éducation à la planification familiale devrait être incluse dans le programme des établissements d'enseignement."
	label define qi 1 "Pas du tout d’accord" 2 "Pas d’accord" 3 "Neutre" 4 "D’accord" 5 "Tout à fait d’accord"
	label values qi qi

	label variable q701 "701. Quels sont les examens qu'une femme enceinte doit effectuer pendant sa gros"
	note q701: "701. Quels sont les examens qu'une femme enceinte doit effectuer pendant sa grossesse ?"

	label variable autre_701 "Veuillez préciser les autres examens"
	note autre_701: "Veuillez préciser les autres examens"

	label variable q702 "702. Quel est le nombre minimum de visites de contrôle qu'une femme enceinte dev"
	note q702: "702. Quel est le nombre minimum de visites de contrôle qu'une femme enceinte devrait subir pendant sa grossesse ?"

	label variable q703 "703. Au cours de quel mois de la grossesse une femme enceinte devrait-elle idéal"
	note q703: "703. Au cours de quel mois de la grossesse une femme enceinte devrait-elle idéalement passer sa première visite prénatale ?"
	label define q703 1 "Premier trimestre" 6 "Autres réponses" 8 "Ne sait pas"
	label values q703 q703

	label variable autre_703 "Veuillez préciser le mois"
	note autre_703: "Veuillez préciser le mois"

	label variable q704 "704. Au cours de quel mois de grossesse une femme enceinte devrait-elle subir sa"
	note q704: "704. Au cours de quel mois de grossesse une femme enceinte devrait-elle subir sa deuxième visite prénatale ?"
	label define q704 1 "Entre le 4e et le 6e mois" 6 "Autres réponses" 8 "Ne sait pas"
	label values q704 q704

	label variable autre_704 "Veuillez préciser le mois"
	note autre_704: "Veuillez préciser le mois"

	label variable q705 "705. Au cours de quel mois de la grossesse une femme enceinte devrait-elle subir"
	note q705: "705. Au cours de quel mois de la grossesse une femme enceinte devrait-elle subir sa troisième visite prénatale ?"
	label define q705 1 "8e mois" 6 "Autres réponses" 8 "Ne sait pas"
	label values q705 q705

	label variable autre_705 "Veuillez préciser le mois"
	note autre_705: "Veuillez préciser le mois"

	label variable q706 "706. Combien de doses d'anatoxine tétanique doivent être injectées à une femme e"
	note q706: "706. Combien de doses d'anatoxine tétanique doivent être injectées à une femme enceinte ?"

	label variable q707 "707. Pendant combien de jours une femme enceinte doit-elle prendre des comprimés"
	note q707: "707. Pendant combien de jours une femme enceinte doit-elle prendre des comprimés ou un sirop de fer et d'acide folique ?"

	label variable q708 "708. Quels sont les signes d'alerte pendant la grossesse qui indiquent qu'une fe"
	note q708: "708. Quels sont les signes d'alerte pendant la grossesse qui indiquent qu'une femme doit consulter un professionnel de la santé ?"

	label variable autre_708 "Veuillez préciser les examens"
	note autre_708: "Veuillez préciser les examens"

	label variable q709 "709. Quels sont les préparatifs essentiels qu'une femme doit effectuer pour un a"
	note q709: "709. Quels sont les préparatifs essentiels qu'une femme doit effectuer pour un accouchement en toute sécurité ?"

	label variable autre_709 "Veuillez préciser les préparatifs"
	note autre_709: "Veuillez préciser les préparatifs"

	label variable q710 "710. Quels sont les signes d'alerte pendant le travail ou l'accouchement qui ind"
	note q710: "710. Quels sont les signes d'alerte pendant le travail ou l'accouchement qui indiquent qu'une femme doit se rendre à l'hôpital ou chez le médecin ?"

	label variable autre_710 "Veuillez préciser les signes"
	note autre_710: "Veuillez préciser les signes"

	label variable q711 "711. Une femme doit-elle se faire examiner après l'accouchement même si elle se "
	note q711: "711. Une femme doit-elle se faire examiner après l'accouchement même si elle se sent bien ?"
	label define q711 1 "Oui" 2 "Non" 8 "Ne sait pas"
	label values q711 q711

	label variable q712 "712. Combien de temps après l'accouchement une femme doit-elle subir son premier"
	note q712: "712. Combien de temps après l'accouchement une femme doit-elle subir son premier examen médical ?"
	label define q712 1 "Dans les heures/deux jours" 6 "Autres réponses" 8 "Ne sait pas"
	label values q712 q712

	label variable autre_712 "Veuillez préciser la durée"
	note autre_712: "Veuillez préciser la durée"

	label variable q713 "713. Quel est le nombre minimum de visites de contrôle qu'une femme doit effectu"
	note q713: "713. Quel est le nombre minimum de visites de contrôle qu'une femme doit effectuer dans les six semaines suivant l'accouchement ?"

	label variable q714 "714. Quels sont les examens à effectuer lors des contrôles postnatals pour les f"
	note q714: "714. Quels sont les examens à effectuer lors des contrôles postnatals pour les femmes ?"

	label variable autre_714 "Veuillez préciser les examens"
	note autre_714: "Veuillez préciser les examens"

	label variable q715 "715. Quels sont les examens à effectuer lors des contrôles postnatals du nouveau"
	note q715: "715. Quels sont les examens à effectuer lors des contrôles postnatals du nouveau-né ?"

	label variable autre_715 "Veuillez préciser les examens"
	note autre_715: "Veuillez préciser les examens"

	label variable q716 "716. Quels sont les signes d'alerte après l'accouchement qui indiquent qu'une fe"
	note q716: "716. Quels sont les signes d'alerte après l'accouchement qui indiquent qu'une femme devrait consulter un prestataire de soins de santé ?"

	label variable autre_716 "Veuillez préciser les signes"
	note autre_716: "Veuillez préciser les signes"

	label variable q717 "717. Quand faut-il donner du lait maternel à un nouveau-né ?"
	note q717: "717. Quand faut-il donner du lait maternel à un nouveau-né ?"
	label define q717 1 "Immédiatement après la naissance (dans l'heure qui suit)" 6 "Autres réponses" 8 "Ne sait pas"
	label values q717 q717

	label variable autre_717 "Veuillez préciser la période"
	note autre_717: "Veuillez préciser la période"

	label variable q718 "718. Faut-il donner à un nouveau-né le lait jaunâtre qui s'écoule du sein de la "
	note q718: "718. Faut-il donner à un nouveau-né le lait jaunâtre qui s'écoule du sein de la mère après l'accouchement ?"
	label define q718 1 "Oui" 2 "Non" 3 "Ne sais pas"
	label values q718 q718

	label variable q719 "719. Pendant combien de temps un nouveau-né doit-il être nourri exclusivement au"
	note q719: "719. Pendant combien de temps un nouveau-né doit-il être nourri exclusivement au sein ?"
	label define q719 1 "6 mois" 6 "Autres réponses" 8 "Ne sait pas"
	label values q719 q719

	label variable autre_719 "Veuillez préciser la durée"
	note autre_719: "Veuillez préciser la durée"

	label variable q720 "720. Comment nettoyer un nouveau-né ?"
	note q720: "720. Comment nettoyer un nouveau-né ?"

	label variable autre_720 "Veuillez préciser la manière de nettoyer"
	note autre_720: "Veuillez préciser la manière de nettoyer"

	label variable q721 "721. Comment doit-on s'occuper du moignon ombilical ?"
	note q721: "721. Comment doit-on s'occuper du moignon ombilical ?"

	label variable autre_721 "Veuillez préciser la manière de s'en occuper"
	note autre_721: "Veuillez préciser la manière de s'en occuper"

	label variable q722 "722. Quels sont les signes d'alerte dans les premières semaines suivant l'accouc"
	note q722: "722. Quels sont les signes d'alerte dans les premières semaines suivant l'accouchement qui indiquent qu'un nouveau-né doit être emmené chez un médecin ?"

	label variable autre_722 "Veuillez préciser les signes"
	note autre_722: "Veuillez préciser les signes"

	label variable q723 "723. Quand doit-on proposer des aliments complémentaires à un nourrisson ?"
	note q723: "723. Quand doit-on proposer des aliments complémentaires à un nourrisson ?"
	label define q723 1 "6 mois d'âge" 6 "Autres réponses" 8 "Ne sait pas"
	label values q723 q723

	label variable autre_723 "Veuillez préciser la période"
	note autre_723: "Veuillez préciser la période"

	label variable q724 "724. Combien de doses de vaccin BCG faut-il administrer à un nouveau-né ?"
	note q724: "724. Combien de doses de vaccin BCG faut-il administrer à un nouveau-né ?"
	label define q724 1 "Un seul" 6 "Autres réponses" 8 "Ne sait pas"
	label values q724 q724

	label variable autre_724 "Veuillez préciser le nombre de doses"
	note autre_724: "Veuillez préciser le nombre de doses"

	label variable q725 "725. À quel âge un nouveau-né doit-il être vacciné par le BCG ?"
	note q725: "725. À quel âge un nouveau-né doit-il être vacciné par le BCG ?"
	label define q725 1 "À la naissance" 6 "Autres réponses" 8 "Ne sait pas"
	label values q725 q725

	label variable autre_725 "Veuillez préciser l'âge"
	note autre_725: "Veuillez préciser l'âge"

	label variable q726 "726. Combien de doses de vaccin antipoliomyélitique oral doivent être administré"
	note q726: "726. Combien de doses de vaccin antipoliomyélitique oral doivent être administrées à un nouveau-né ?"
	label define q726 1 "4 doses" 6 "Autres réponses" 8 "Ne sait pas"
	label values q726 q726

	label variable autre_726 "Veuillez préciser le nombre de doses"
	note autre_726: "Veuillez préciser le nombre de doses"

	label variable q727 "727. À quel âge un nouveau-né doit-il recevoir la première dose de vaccin oral c"
	note q727: "727. À quel âge un nouveau-né doit-il recevoir la première dose de vaccin oral contre la polio ?"
	label define q727 1 "À la naissance" 6 "Autres réponses" 8 "Ne sait pas"
	label values q727 q727

	label variable autre_727 "Veuillez préciser l'âge"
	note autre_727: "Veuillez préciser l'âge"

	label variable q728 "728. À quel âge un nouveau-né doit-il recevoir la deuxième dose de vaccin oral c"
	note q728: "728. À quel âge un nouveau-né doit-il recevoir la deuxième dose de vaccin oral contre la polio ?"
	label define q728 1 "6 semaines" 6 "Autres réponses" 8 "Ne sait pas"
	label values q728 q728

	label variable autre_728 "Veuillez préciser l'âge"
	note autre_728: "Veuillez préciser l'âge"

	label variable q729 "729. Combien de doses de vaccin DPT doivent être administrées à un nouveau-né ?"
	note q729: "729. Combien de doses de vaccin DPT doivent être administrées à un nouveau-né ?"
	label define q729 1 "3 doses" 6 "Autres réponses" 8 "Ne sait pas"
	label values q729 q729

	label variable autre_729 "Veuillez préciser le nombre de doses"
	note autre_729: "Veuillez préciser le nombre de doses"

	label variable q730 "730. À quel âge un nouveau-né doit-il recevoir la première dose de vaccin DPT ?"
	note q730: "730. À quel âge un nouveau-né doit-il recevoir la première dose de vaccin DPT ?"
	label define q730 1 "6 semaines" 6 "Autres réponses" 8 "Ne sait pas"
	label values q730 q730

	label variable autre_730 "Veuillez préciser l'âge"
	note autre_730: "Veuillez préciser l'âge"

	label variable q731 "731. Combien de doses de vaccin contre la rougeole doivent être administrées à u"
	note q731: "731. Combien de doses de vaccin contre la rougeole doivent être administrées à un nouveau-né?"
	label define q731 1 "Une dose" 6 "Autres réponses" 8 "Ne sait pas"
	label values q731 q731

	label variable autre_731 "Veuillez préciser le nombre de doses"
	note autre_731: "Veuillez préciser le nombre de doses"

	label variable q732a "Il n'est pas nécessaire que le mari/partenaire accompagne sa femme lors des visi"
	note q732a: "Il n'est pas nécessaire que le mari/partenaire accompagne sa femme lors des visites de consultation pré et postnatales."
	label define q732a 1 "Pas du tout d’accord" 2 "Pas d’accord" 3 "Neutre" 4 "D’accord" 5 "Tout à fait d’accord"
	label values q732a q732a

	label variable q732b "Une femme doit prévoir à l'avance le lieu où elle accouchera."
	note q732b: "Une femme doit prévoir à l'avance le lieu où elle accouchera."
	label define q732b 1 "Pas du tout d’accord" 2 "Pas d’accord" 3 "Neutre" 4 "D’accord" 5 "Tout à fait d’accord"
	label values q732b q732b

	label variable q732c "Une femme doit prévoir à l'avance comment elle se rendra sur le lieu de l'accouc"
	note q732c: "Une femme doit prévoir à l'avance comment elle se rendra sur le lieu de l'accouchement."
	label define q732c 1 "Pas du tout d’accord" 2 "Pas d’accord" 3 "Neutre" 4 "D’accord" 5 "Tout à fait d’accord"
	label values q732c q732c

	label variable q732d "Il n'est pas nécessaire qu'un mari/partenaire accompagne sa femme lors de l'acco"
	note q732d: "Il n'est pas nécessaire qu'un mari/partenaire accompagne sa femme lors de l'accouchement."
	label define q732d 1 "Pas du tout d’accord" 2 "Pas d’accord" 3 "Neutre" 4 "D’accord" 5 "Tout à fait d’accord"
	label values q732d q732d

	label variable q732e "L'accouchement à l'hôpital est bénéfique pour le bébé et la mère."
	note q732e: "L'accouchement à l'hôpital est bénéfique pour le bébé et la mère."
	label define q732e 1 "Pas du tout d’accord" 2 "Pas d’accord" 3 "Neutre" 4 "D’accord" 5 "Tout à fait d’accord"
	label values q732e q732e

	label variable q732f "Il est nécessaire de donner des conseils aux femmes qui viennent d'accoucher sur"
	note q732f: "Il est nécessaire de donner des conseils aux femmes qui viennent d'accoucher sur les soins à apporter au nouveau-né."
	label define q732f 1 "Pas du tout d’accord" 2 "Pas d’accord" 3 "Neutre" 4 "D’accord" 5 "Tout à fait d’accord"
	label values q732f q732f

	label variable q732g "En cas d'affection, les remèdes maison et les traitements à base de plantes sont"
	note q732g: "En cas d'affection, les remèdes maison et les traitements à base de plantes sont plus efficaces que l'aide médicale."
	label define q732g 1 "Pas du tout d’accord" 2 "Pas d’accord" 3 "Neutre" 4 "D’accord" 5 "Tout à fait d’accord"
	label values q732g q732g

	label variable q732h "L'accouchement est l'affaire d'une femme. Les maris/partenaires n'ont pas grand-"
	note q732h: "L'accouchement est l'affaire d'une femme. Les maris/partenaires n'ont pas grand-chose à y apporter."
	label define q732h 1 "Pas du tout d’accord" 2 "Pas d’accord" 3 "Neutre" 4 "D’accord" 5 "Tout à fait d’accord"
	label values q732h q732h

	label variable q732i "Les vaccins administrés aux enfants sont inutiles."
	note q732i: "Les vaccins administrés aux enfants sont inutiles."
	label define q732i 1 "Pas du tout d’accord" 2 "Pas d’accord" 3 "Neutre" 4 "D’accord" 5 "Tout à fait d’accord"
	label values q732i q732i

	label variable q732j "Les enfants reçoivent trop de types de vaccins."
	note q732j: "Les enfants reçoivent trop de types de vaccins."
	label define q732j 1 "Pas du tout d’accord" 2 "Pas d’accord" 3 "Neutre" 4 "D’accord" 5 "Tout à fait d’accord"
	label values q732j q732j

	label variable q732k "Les parents/tuteurs devraient avoir le droit de refuser les vaccinations."
	note q732k: "Les parents/tuteurs devraient avoir le droit de refuser les vaccinations."
	label define q732k 1 "Pas du tout d’accord" 2 "Pas d’accord" 3 "Neutre" 4 "D’accord" 5 "Tout à fait d’accord"
	label values q732k q732k

	label variable q732l "La vaccination des enfants devrait être rendue obligatoire."
	note q732l: "La vaccination des enfants devrait être rendue obligatoire."
	label define q732l 1 "Pas du tout d’accord" 2 "Pas d’accord" 3 "Neutre" 4 "D’accord" 5 "Tout à fait d’accord"
	label values q732l q732l

	label variable q801 "801. Quels types de bénéficiaires avez-vous contacté, conseillées, orientées ou "
	note q801: "801. Quels types de bénéficiaires avez-vous contacté, conseillées, orientées ou suivies ?"

	label variable q802 "802. Quels types de fournitures avez-vous reçu ?"
	note q802: "802. Quels types de fournitures avez-vous reçu ?"

	label variable q803 "803. Disposez-vous d'équipements vous permettant de fournir des services plus ef"
	note q803: "803. Disposez-vous d'équipements vous permettant de fournir des services plus efficaces ?"
	label define q803 1 "OUI" 2 "NON"
	label values q803 q803

	label variable q804 "804. Quels sont les équipements fonctionnels dont vous disposez ?"
	note q804: "804. Quels sont les équipements fonctionnels dont vous disposez ?"

	label variable autre_804 "Veuillez préciser les autres équipements"
	note autre_804: "Veuillez préciser les autres équipements"

	label variable q805 "805. Avez-vous fourni des méthodes contraceptives aux femmes/couples éligibles d"
	note q805: "805. Avez-vous fourni des méthodes contraceptives aux femmes/couples éligibles de votre communauté au cours des derniers mois écoulés ?"
	label define q805 1 "OUI" 2 "NON"
	label values q805 q805

	label variable q806 "806. Quelle méthode contraceptive avez-vous fournie ?"
	note q806: "806. Quelle méthode contraceptive avez-vous fournie ?"

	label variable autre_806 "Autre"
	note autre_806: "Autre"

	label variable q807 "807. Avez-vous mobilisé des femmes/couples éligibles vers le centre de santé pou"
	note q807: "807. Avez-vous mobilisé des femmes/couples éligibles vers le centre de santé pour d'autres méthodes contraceptives à long terme ?"
	label define q807 1 "OUI" 2 "NON"
	label values q807 q807

	label variable q808 "808. Pour quelle méthode de contraception à long terme vous êtes-vous mobilisé ?"
	note q808: "808. Pour quelle méthode de contraception à long terme vous êtes-vous mobilisé ?"

	label variable autre_808 "Veuillez préciser la méthode"
	note autre_808: "Veuillez préciser la méthode"

	label variable q809 "809. Avez-vous fourni une aide essentielle aux femmes enceintes au cours du dern"
	note q809: "809. Avez-vous fourni une aide essentielle aux femmes enceintes au cours du dernier mois ?"
	label define q809 1 "OUI" 2 "NON"
	label values q809 q809

	label variable q810 "810. Avez-vous fourni une aide essentielle, telle que le choix d'un contraceptif"
	note q810: "810. Avez-vous fourni une aide essentielle, telle que le choix d'un contraceptif pour retarder la première grossesse, l'accompagnement dans un centre de santé, l'élaboration d'un plan de préparation à l'accouchement, l'organisation du transport pour l'accouchement, etc. aux femmes qui viennent d'accoucher au cours du mois écoulé ?"
	label define q810 1 "OUI" 2 "NON"
	label values q810 q810

	label variable q811 "811. Quelle aide spécifique avez-vous apportée ?"
	note q811: "811. Quelle aide spécifique avez-vous apportée ?"

	label variable autre_811 "Veuillez préciser l'aide"
	note autre_811: "Veuillez préciser l'aide"

	label variable note_interviewer "Observations de l'enquêteur"
	note note_interviewer: "Observations de l'enquêteur"

	label variable tel "Numero de téléphone"
	note tel: "Numero de téléphone"

	label variable coordlatitude "Position (latitude)"
	note coordlatitude: "Position (latitude)"

	label variable coordlongitude "Position (longitude)"
	note coordlongitude: "Position (longitude)"

	label variable coordaltitude "Position (altitude)"
	note coordaltitude: "Position (altitude)"

	label variable coordaccuracy "Position (accuracy)"
	note coordaccuracy: "Position (accuracy)"

	label variable q110 "HEURE DE FIN DE L’ENTRETIEN"
	note q110: "HEURE DE FIN DE L’ENTRETIEN"



	capture {
		foreach rgvar of varlist q801_1a_* {
			label variable `rgvar' "1. Combien de \${type_benef} ont été contactées individuellement?"
			note `rgvar': "1. Combien de \${type_benef} ont été contactées individuellement?"
		}
	}

	capture {
		foreach rgvar of varlist q801_1b_* {
			label variable `rgvar' "1. Combien de \${type_benef} ont été contactées en groupe?"
			note `rgvar': "1. Combien de \${type_benef} ont été contactées en groupe?"
		}
	}

	capture {
		foreach rgvar of varlist q801_2a_* {
			label variable `rgvar' "2. Combien de \${type_benef} ont été conseillées individuellement ?"
			note `rgvar': "2. Combien de \${type_benef} ont été conseillées individuellement ?"
		}
	}

	capture {
		foreach rgvar of varlist q801_2b_* {
			label variable `rgvar' "2. Combien de \${type_benef} ont été conseillées en groupe ?"
			note `rgvar': "2. Combien de \${type_benef} ont été conseillées en groupe ?"
		}
	}

	capture {
		foreach rgvar of varlist q801_3a_* {
			label variable `rgvar' "3. Combien de \${type_benef} ont été orientées individuellement ?"
			note `rgvar': "3. Combien de \${type_benef} ont été orientées individuellement ?"
		}
	}

	capture {
		foreach rgvar of varlist q801_3b_* {
			label variable `rgvar' "3. Combien de \${type_benef} ont été orientées en groupe ?"
			note `rgvar': "3. Combien de \${type_benef} ont été orientées en groupe ?"
		}
	}

	capture {
		foreach rgvar of varlist q801_4_* {
			label variable `rgvar' "4.Combien de \${type_benef} ont été suivies individuellement?"
			note `rgvar': "4.Combien de \${type_benef} ont été suivies individuellement?"
		}
	}

	capture {
		foreach rgvar of varlist q801_5_* {
			label variable `rgvar' "5.Combien de \${type_benef} vous ont contacté individuellement?"
			note `rgvar': "5.Combien de \${type_benef} vous ont contacté individuellement?"
		}
	}

	capture {
		foreach rgvar of varlist q802_1_* {
			label variable `rgvar' "1. Avez-vous reçu \${type_fourni}?"
			note `rgvar': "1. Avez-vous reçu \${type_fourni}?"
			label define `rgvar' 1 "Oui" 2 "Non"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist q802_2_* {
			label variable `rgvar' "2. Quelle est la quantité de \${type_fourni} que vous possédez actuellement ?"
			note `rgvar': "2. Quelle est la quantité de \${type_fourni} que vous possédez actuellement ?"
		}
	}

	capture {
		foreach rgvar of varlist q802_3_* {
			label variable `rgvar' "3. Avez-vous manqué de provisions de \${type_fourni} au cours des 3 derniers moi"
			note `rgvar': "3. Avez-vous manqué de provisions de \${type_fourni} au cours des 3 derniers mois ?"
			label define `rgvar' 1 "Oui" 2 "Non"
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
*   Corrections file path and filename:  C:/Users/pkaberia/Dropbox//FP-Project-APHRC-UM/Atelier_FP/Codes//QUESTIONNAIRE ASC_corrections.csv
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
