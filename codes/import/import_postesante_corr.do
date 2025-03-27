* import_postesante_corr.do
*
* 	Imports and aggregates "QUESTIONNAIRE POSTE DE SANTE" (ID: postesante_corr) data.
*
*	Inputs:  "C:/Users/pkaberia/Dropbox//FP-Project-APHRC-UM/Atelier_FP/Codes//QUESTIONNAIRE POSTE DE SANTE_WIDE.csv"
*	Outputs: "C:/Users/pkaberia/Dropbox//FP-Project-APHRC-UM/Atelier_FP/Data/Donnees brutes//QUESTIONNAIRE POSTE DE SANTE.dta"
*
*	Output by SurveyCTO February 14, 2025 12:08 PM.

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
local csvfile "C:/Users/pkaberia/Dropbox//FP-Project-APHRC-UM/Atelier_FP/Codes//QUESTIONNAIRE POSTE DE SANTE_WIDE.csv"
local dtafile "C:/Users/pkaberia/Dropbox//FP-Project-APHRC-UM/Atelier_FP/Data/Donnees brutes//QUESTIONNAIRE POSTE DE SANTE.dta"
local corrfile "C:/Users/pkaberia/Dropbox//FP-Project-APHRC-UM/Atelier_FP/Codes//QUESTIONNAIRE POSTE DE SANTE_corrections.csv"
local note_fields1 ""
local text_fields1 "autre_structure s1_4 s1_8 s1_10 s4_1_5au_* s4_1_6_* s4_1_8_* s4_1_9_* s4_1_11_* s4_1_12au_* servi_smni s_cpn s5_5_cpn s5_5_cpn_autre s_acc s5_5_acc s5_5_acc_autre s_pnat s5_5_pnat s5_5_pnat_autre"
local text_fields2 "s_nne s5_5_nne s5_5_nne_autre s_inf s5_5_sinf s5_5_sinf_autre s5_10 s5_10_autre s5_10a s5_10_autrea s5_10b s5_10_autreb s5_10c s5_10_autrec s5_10e s5_10_autree s5_10f s5_10_autref s5_10g s5_10_autreg"
local text_fields3 "s5_10h s5_10_autreh s5_10j s5_10_autrej s5_10k s5_10_autrek s5_10l s5_10_autrel s6_19 s6_20 s6_19a s6_20a s6_19b s6_20b s6_19c s6_20c s6_19d s6_20d s6_19e s6_20e s6_19f s6_20f s6_19g s6_20g s6_19h"
local text_fields4 "s6_20h s6_19j s6_20j obs instanceid"
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
	label define nom_structure 1 "PS Bel Air" 2 "PS Bourguiba" 3 "PS Derkle" 4 "PS Fann Hock" 5 "PS Georges Lahoud" 6 "PS Hann Sur Mer" 7 "PS Hann Village" 8 "PS HLM" 9 "PS Liberte 2" 10 "PS Liberte 6" 11 "PS Camberene" 12 "PS Grand Medine" 13 "PS Grand Yoff 2" 14 "PS Grand Yoff I" 15 "PS HLM Grand Yoff" 16 "PS Khar Yalla" 17 "PS Norade" 18 "PS Unite 16" 19 "PS Unite 22" 20 "PS Unité 26" 21 "PS Unite 8" 22 "PS Unite 9" 23 "PS Apecsy 1" 24 "PS Cité Avion" 25 "PS Communautaire de Tonghor" 26 "PS Diamalaye" 27 "PS Liberte 4" 28 "PS Mermoz" 29 "PS Yoff" 30 "PS THIEUDEME (privé)" 31 "PS Goree" 32 "PS HLM Fass" 33 "PS Raffenel" 34 "PS Sandial" 35 "PS Service D'Hygiene" 36 "PS Bargny Guedji" 37 "PS Dougar" 38 "PS Kip Carrieres" 39 "PS Missirah" 40 "PS Ndiolmane" 41 "PS Ndoukhoura Peulh" 42 "PS Ndoyénne" 43 "PS Niangal" 44 "PS Sebi Ponty" 45 "PS Sebikotane" 46 "PS Sendou" 47 "PS Yenne" 48 "PS Daroukhane" 49 "PS Darourakhmane" 50 "PS Fith Mith" 51 "PS Golfe Sud" 52 "PS Hamo Tefess" 53 "PS Hamo V" 54 "PS HLM Las Palmas" 55 "PS Medina Gounass" 56 "PS Nimzath" 57 "PS Parcelles Assainies Unite 4" 58 "PS Mme Fatou BA" 59 "PS Aladji Pathe" 60 "PS Boune" 61 "PS Jaxaaye" 62 "PS Keur Massar Village" 63 "PS Malika" 64 "PS Malika Sonatel" 65 "PS Parcelle Assainie Keur Massar" 66 "PS CAPEC" 67 "PS Diacksao" 68 "PS Diamegueune" 69 "PS Fass Mbao" 70 "PS Grand Mbao" 71 "PS Kamb" 72 "PS la Rochette" 73 "PS Mbao Gare" 74 "PS Nassroulah" 75 "PS Petit Mbao" 76 "PS Taif" 77 "PS Thiaroye Azur" 78 "PS Thiaroye Gare" 79 "PS Thiaroye Sur Mer" 80 "PS Dalifort" 81 "PS Darou Khoudoss" 82 "PS Darou Salam" 83 "PS Deggo" 84 "PS Guinaw Rail Nord" 85 "PS Guinaw Rail Sud" 86 "PS Khourounar" 87 "PS Municipal 1" 88 "PS Municipal 2" 89 "PS Pepiniere" 90 "PS Santa Yalla" 91 "PS Touba Diack Sao" 92 "PS Arafat" 93 "PS Dangou" 94 "PS Diokoul Kher" 95 "PS Diokoul Wague" 96 "PS Diorga" 97 "PS Fass" 98 "PS Gouye Mouride" 99 "PS HLM" 100 "PS Keury Souf" 101 "PS Nimzath" 102 "PS TACO" 103 "PS Thiawlene" 104 "PS Apix" 105 "PS Bambilor" 106 "PS Cite Gendarmerie" 107 "PS Denes" 108 "PS Gorome" 109 "PS Gorome 2" 110 "PS Keur Ndiaye Lo" 111 "PS Kounoune" 112 "PS Lébougui 2000" 113 "PS Medina Thioub" 114 "PS Niacourab" 115 "PS Niague" 116 "PS Tawfekh" 117 "PS Tivaoune Peulh" 118 "PS Wayembam" 119 "PS cheikh Sidaty FALL" 120 "PS Darou Salam 6" 121 "PS Darourahmane 2" 122 "PS Gallo Dia" 123 "PS Thiaroye Miname" 124 "PS Yeumbeul Ainoumady Sotrac" 125 "PS Yeumbeul Diamalaye" 126 "PS Yeumbeul Sud" 127 "PS Ndondol" 128 "PS Aguiyaye" 129 "PS Baba Garage" 130 "PS Bambay Serere" 131 "PS Bambeye Serere 2" 132 "PS Batal" 133 "PS Dinguiraye" 134 "PS DVF" 135 "PS Gatte" 136 "PS Gawane" 137 "PS Gourgourène" 138 "PS Keur Madiop" 139 "PS Keur Samba Kane" 140 "PS Lambaye" 141 "PS Leona" 142 "PS Mekhe Lambaye" 143 "PS N'dangalma" 144 "PS Ndeme Meissa" 145 "PS Ndereppe" 146 "PS Ndiakalack" 147 "PS Ngogom" 148 "PS Ngoye" 149 "PS Pallene" 150 "PS Refane" 151 "PS Reomao" 152 "PS Silane" 153 "PS Sokano" 154 "PS Tawa Fall" 155 "PS Thiakhar" 156 "PS Thieppe" 157 "PS Thieytou" 158 "PS Mme Elisabeth Diouf" 159 "PS Cheikh Anta" 160 "PS Dankh Sene" 161 "PS Gade Escale" 162 "PS Grand Diourbel" 163 "PS Keur Ngalgou" 164 "PS Keur Ngana" 165 "PS Keur Serigne Mbaye Sarr" 166 "PS Lagnar" 167 "PS Medinatoul" 168 "PS Ndayane" 169 "PS Ndoulo" 170 "PS Patar" 171 "PS Sareme Wolof" 172 "PS Sessene" 173 "PS Taiba Moutoupha" 174 "PS Tawfekh" 175 "PS Thiobe" 176 "PS Tocky Gare" 177 "PS Toure Mbonde" 178 "PS Walalane" 179 "PS Dalla Ngabou" 180 "PS Darou Nahim" 181 "PS Darou salam" 182 "PS Dendeye Gouyegui" 183 "PS Diamaguene" 184 "PS Digane" 185 "PS Doyoly" 186 "PS Guerle" 187 "PS Kael" 188 "PS Madina" 189 "PS Mbacke Ndimb" 190 "PS Missirah" 191 "PS Municipal" 192 "PS Ndioumane Taiba" 193 "PS Nghaye" 194 "Ps Pallene" 195 "PS Sadio" 196 "Ps Santhie" 197 "PS Taiba Thekene" 198 "PS Taïf" 199 "PS Touba Fall" 200 "PS Touba Mboul Kael" 201 "PS Typ" 202 "PS Boukhatoul Moubarak" 203 "PS Darou Karim" 204 "PS Darou Khadim" 205 "PS Darou Khoudoss" 206 "PS Darou Minam" 207 "PS Darou Rahmane" 208 "PS Dialybatou" 209 "PS Gouye Mbinde" 210 "PS Guede Bousso" 211 "PS Guede Kaw" 212 "PS Heliport" 213 "PS Kaîra" 214 "PS Keur Gol" 215 "PS Khelcom" 216 "PS Madyana I" 217 "PS Madyana II" 218 "PS Mboussobe" 219 "PS Ndindy Abdou" 220 "PS Oumoul Khoura" 221 "PS Sourah" 222 "PS Thiawene" 223 "PS Tindody" 224 "PS Touba Bagdad" 225 "PS Touba Belel" 226 "PS Touba Boborel" 227 "PS Touba Bogo" 228 "PS Touba Hlm" 229 "PS Touba Lansar" 230 "PS Boff Mballeme" 231 "PS Boof Poupouye" 232 "PS Darou Salam Rural" 233 "PS Diakhao Fermé" 234 "PS Diaoule" 235 "PS Magarite Davary" 236 "PS Marouth" 237 "PS Mbellacadiao" 238 "PS Mbouma" 239 "PS Ndiop" 240 "PS Ndiourbel Sine" 241 "PS Ndjilasseme" 242 "PS Thiare" 243 "PS Toffaye" 244 "PS Boyard" 245 "PS Djilasse Public" 246 "PS Faoye" 247 "PS Fimela" 248 "PS Loul Sessene" 249 "PS Marfafaco" 250 "PS Marlothie" 251 "PS Ndangane" 252 "PS Ndiagamba" 253 "PS Nobandane" 254 "PS Palmarin Facao" 255 "PS Palmarin Ngallou" 256 "PS Samba Dia" 257 "PS Simal" 258 "PS Soudiane" 259 "PS Bacoboeuf" 260 "PS Bicole" 261 "PS Darou Salam Urbain" 262 "PS Diarere" 263 "PS Diohine" 264 "PS Diouroup" 265 "PS Emetteur" 266 "PS Fayil" 267 "PS Gadiack" 268 "PS Mbédap" 269 "PS Mbelloghoutt" 270 "PS Mbettite" 271 "PS Ndiayendiaye" 272 "PS Ndiongolor" 273 "PS Ndiosmone" 274 "PS Ndoffonghor" 275 "PS Ndouck" 276 "PS Ngoye Mbadatt" 277 "PS Peulga Darel" 278 "PS Senghor" 279 "PS Sobene" 280 "PS Sowane" 281 "PS Tataguine" 282 "PS Baouth" 283 "PS Bassar" 284 "PS Bassoul" 285 "PS Diamniadio" 286 "PS Diogane" 287 "PS Dionewar" 288 "PS Djirnda" 289 "PS Mbam" 290 "PS Mounde" 291 "PS Soum" 292 "PS Colobane" 293 "PS Darou Marnane" 294 "PS Deguerre" 295 "PS Diabel" 296 "PS Gaina Mbar" 297 "PS Mbar" 298 "PS Moure" 299 "PS Ndiene Lagane" 300 "PS Ouadiour" 301 "PS Patar Lia" 302 "PS Somb" 303 "PS Thienaba Gossas" 304 "PS Yargouye" 305 "PS Mbadatte" 306 "PS Ndiambour Sine" 307 "PS Ndoss" 308 "PS Ngayokheme" 309 "PS Ngonine" 310 "PS Patar Sine" 311 "PS Sagne" 312 "PS Sob" 313 "PS Sorokh" 314 "PS Tella" 315 "PS Toucar" 316 "PS Yenguelé" 317 "PS Darou Keur Mor Khoredia" 318 "PS Diagane barka" 319 "PS Diossong" 320 "PS Djilor" 321 "PS Keur Birane Khoredia" 322 "PS Lerane Coly" 323 "PS Lérane Sambou" 324 "PS Mbelane" 325 "PS Mbowene" 326 "PS Ndiassane Saloum" 327 "PS Ndiaye Ndiaye Wolof" 328 "PS Niassene" 329 "PS Sadiogo" 330 "PS Thiaméne Diogo" 331 "PS Thiamene Keur Souleymane" 332 "PS Bambadalla Thiakho (CU_MILDA 2022)" 333 "PS Baria" 334 "PS Bettenty" 335 "PS Bossinkang" 336 "PS Coular Soce" 337 "PS Dassilame Soce" 338 "PS Diaglé" 339 "PS Djinack Bara" 340 "PS Karang" 341 "PS Keur Amath Seune" 342 "PS Keur Gueye Yacine" 343 "PS Keur Ousseynou Dieng (CU_MILDA 2022)" 344 "PS Keur Saloum Diane" 345 "PS Keur Samba Gueye" 346 "PS Keur Seny Gueye" 347 "PS Medina Djikoye" 348 "PS Missirah" 349 "PS Nemabah" 350 "PS Nemanding" 351 "PS Ngayene Thiebo" 352 "PS Nioro Alassane Tall" 353 "PS Pakala" 354 "PS Santamba" 355 "PS Sirmang" 356 "PS Sokone" 357 "PS Toubacouta" 358 "PS Bidiam" 359 "PS Bossolel" 360 "PS Diamal" 361 "PS Keur Mbouki" 362 "PS Keur Pathè" 363 "PS Keur Sader" 364 "PS Keur Sawely" 365 "PS Koumpal" 366 "PS Mabo" 367 "PS Mbeuleup" 368 "PS Ndiayene Waly" 369 "PS Ndiognick" 370 "PS Ngouye" 371 "PS Segre Secco" 372 "PS Segregata" 373 "PS Thicatt" 374 "PS Touba Mbela" 375 "PS Weynde" 376 "PS Ngodiba" 377 "PS Boulel" 378 "PS Darou Salam" 379 "PS Diacksao" 380 "PS Diamagadio" 381 "PS Diamaguene" 382 "PS Diokoul Mbellboul" 383 "PS Dioumada" 384 "PS Djouth Nguel" 385 "PS Gniby" 386 "PS Goulokoum" 387 "PS Hore" 388 "PS Kaffrine II" 389 "PS Kahi" 390 "PS Kathiote" 391 "PS Kélimane" 392 "PS Keur Babou" 393 "PS Mbegue" 394 "PS Mbelbouck" 395 "PS Médina Taba" 396 "PS Medinatoul Salam 2" 397 "PS Méo Diobéne" 398 "PS Ndiaobambaly" 399 "PS Nganda" 400 "PS Nguer Mandakh" 401 "PS Pathe Thiangaye" 402 "PS Same Nguéyéne" 403 "PS Santhie Galgone" 404 "PS Sorocogne" 405 "PS Arafat" 406 "PS Coura Mouride" 407 "PS Darou Kaffat" 408 "PS Dimiskha" 409 "PS Fass Thieckene" 410 "PS Gainth Pathe" 411 "PS Ida Mouride" 412 "PS Keur Malick Marame" 413 "PS Keur Mandoumbe" 414 "PS Keur NGAYE" 415 "PS Koukoto Simong" 416 "PS Koung Koung" 417 "PS Kourdane" 418 "PS Lour Escale" 419 "PS Maka Gouye" 420 "PS Maka Yop" 421 "PS Minam" 422 "PS Missira Public" 423 "PS Ndiayene Lour" 424 "PS Ndoume" 425 "PS Ngouye Diaraf" 426 "PS Piram Manda" 427 "PS Ribot Escale" 428 "PS Saly Escale" 429 "PS Santhie Nguerane" 430 "PS Sine Matar" 431 "PS Sobel Diam Diam" 432 "PS Taif Thieckene" 433 "PS Touba Alia" 434 "PS Touba Aly Mbenda" 435 "PS Urbain" 436 "PS Urbain 2" 437 "PS Darou Mbané" 438 "PS Darou Minam" 439 "PS Diaga Keur Serigne" 440 "PS Diam Diam" 441 "PS Dianke Souf" 442 "PS Fass Mame Baba" 443 "PS Hodar" 444 "PS Khaîra Diaga" 445 "PS Maka Belal" 446 "PS Mbarocounda" 447 "PS Médina Dianké" 448 "PS Medina Sy" 449 "PS Ndiobene" 450 "PS Ndioté Séane" 451 "PS Ndioum Gainthie" 452 "PS Ngaba" 453 "PS Niahene" 454 "PS Paffa" 455 "PS Sagna" 456 "PS Seane" 457 "PS Tip Saloum" 458 "PS Touba Médinatoul" 459 "PS Touba Ngueyene" 460 "PS Athiou" 461 "PS Back Samba Dior" 462 "PS Colobane Lambaye" 463 "PS Dara Mboss" 464 "PS Farabougou" 465 "PS Fass" 466 "PS Gagnick" 467 "PS Goweth Sérère" 468 "PS Kongoly" 469 "PS Mande Keur Miniane" 470 "PS Mbadakhoun" 471 "PS Mboss" 472 "PS Mboulougne" 473 "PS Ndelle" 474 "PS Ndiagne Kahone" 475 "PS Ndiago" 476 "PS Ngathie Naoude" 477 "PS Ngoloum" 478 "PS Nguekhokh" 479 "PS Nguelou" 480 "PS Ourour" 481 "PS Panal" 482 "PS Tchiky" 483 "PS Walo" 484 "PS Wardiakhal" 485 "PS Sibassor" 486 "PS Abattoirs" 487 "PS Boustane" 488 "PS Darou Ridouane" 489 "PS Dialegne" 490 "PS Diamegueune" 491 "PS Dya" 492 "PS Fass Thioffack" 493 "PS Gandiaye" 494 "PS Kabatoki" 495 "PS Kahone" 496 "PS Kanda" 497 "PS Keur Mbagne Diop" 498 "PS Koundam" 499 "PS Leona" 500 "PS Lyndiane" 501 "PS Medina Baye" 502 "PS Medina Mbaba" 503 "PS Ndiebel" 504 "PS Ndorong" 505 "PS Ngane" 506 "PS Ngothie" 507 "PS Nimzatt" 508 "PS Parcelles Assainies" 509 "PS Same" 510 "PS Sara" 511 "PS Sob2" 512 "PS Taba Ngoye" 513 "PS Thioffac" 514 "PS Thiomby" 515 "PS Daga Sambou" 516 "PS Daga Youndoume" 517 "PS Darou Mbiteyene" 518 "PS Darou Pakathiar" 519 "PS Darou Salam" 520 "PS Djilekhar" 521 "PS Keur Aly Bassine" 522 "PS Keur Baka" 523 "PS Keur Lassana" 524 "PS Keur Serigne Bassirou" 525 "PS Keur Soce" 526 "PS Koumbal" 527 "PS Koutal" 528 "PS Kouthieye" 529 "PS Lamarame" 530 "PS Latmingue" 531 "PS Mbitéyène Abdou" 532 "PS Ndiaffate" 533 "PS Ndiedieng" 534 "PS Tawa Mboudaye" 535 "PS Thiare" 536 "PS Darou Mbapp" 537 "PS Dinguiraye" 538 "PS Falifa" 539 "PS Dabaly" 540 "PS Darou Khoudoss" 541 "PS Darou Salam Commune" 542 "PS Darou Salam Mouride" 543 "PS Darou Salam Nioro" 544 "PS Diamagueune" 545 "PS Fass HLM" 546 "PS Gainthes Kayes" 547 "PS Kabacoto" 548 "PS Kaymor" 549 "PS Keur Abibou Niasse" 550 "PS Keur Ale Samba" 551 "PS Keur Ayip" 552 "PS Keur Birane Ndoupy" 553 "PS Keur Cheikh Oumar TOURE" 554 "PS Keur Lahine Sakho" 555 "PS Keur Maba Diakhou" 556 "PS Keur Madiabel 1" 557 "PS Keur Madiabel 2" 558 "PS Keur Mandongo" 559 "PS Keur Moussa" 560 "PS Keur Sountou" 561 "PS Keur Tapha" 562 "PS Kohel" 563 "PS Lohène" 564 "PS Medina Sabakh" 565 "PS Missirah Walo" 566 "PS Ndiba Ndiayenne" 567 "PS Ndrame Escale" 568 "PS Ngayene Sabakh" 569 "PS Niappa Balla" 570 "PS Niassène Walo" 571 "PS Paoskoto" 572 "PS Porokhane" 573 "PS Saboya" 574 "PS Santhie Thiamène" 575 "PS Sine ngayene" 576 "PS Soucouta" 577 "PS Taiba Niassene" 578 "PS Thila Grand" 579 "PS Banda Fassi" 580 "PS Bantako" 581 "PS de Dalaba" 582 "PS Dimboli" 583 "PS Dinde Felo" 584 "PS Fadiga" 585 "PS Fongolimby" 586 "PS Mako" 587 "PS Ninefescha" 588 "PS Sylla Counda" 589 "PS Tenkoto" 590 "PS Thiabedji" 591 "PS Thiabekare" 592 "PS Tomboronkoto" 593 "PS Tripano" 594 "PS Ebarack" 595 "PS Dakately" 596 "PS Dar Salam" 597 "PS Darou Ningou" 598 "PS Ethiolo" 599 "PS Kevoye" 600 "PS Nepene" 601 "PS Oubadji" 602 "PS Thiankoye" 603 "PS Bambadji" 604 "PS Bembou" 605 "PS Bransan" 606 "PS Daloto" 607 "PS Diakha Macky" 608 "PS Diakha Madina" 609 "PS Diakhaba" 610 "PS Diakhaling" 611 "PS Kharakhena" 612 "PS Khossanto" 613 "PS Madina Baffe" 614 "PS Madina Sirimana" 615 "PS Mamakhono" 616 "PS Missira Dentila" 617 "PS Missira Sirimana" 618 "PS Moussala" 619 "PS Nafadji" 620 "PS Sabodola" 621 "PS Saensoutou" 622 "PS Sambrambougou" 623 "PS Saroudia" 624 "PS Wassangaran" 625 "PS Anambe" 626 "PS Bagadadji" 627 "PS Bambadinka" 628 "PS Bantancountou Maounde" 629 "PS Bouna Kane" 630 "PS Coumbacara" 631 "PS Dabo" 632 "PS Darou Salam Thierno" 633 "PS Dialacoumbi" 634 "PS Dialembere" 635 "PS Diankancounda Oguel" 636 "PS Diassina" 637 "PS Dioulacolon" 638 "PS Gadapara" 639 "PS Guire Yoro Bocar" 640 "PS Hafia" 641 "PS Ibrahima Nima" 642 "PS Kampissa" 643 "PS Kossanké" 644 "PS Mampatim" 645 "PS Medina Alpha Sadou" 646 "PS Medina Cherif" 647 "PS Medina El Hadj" 648 "PS Nghocky" 649 "PS Salamata" 650 "PS Salikegne" 651 "PS Sare Bidji" 652 "PS Saré Bilaly" 653 "PS Sare Demdayel" 654 "PS Sare Kemo" 655 "PS Sare Moussa" 656 "PS Sare Moussa Meta" 657 "PS Sare Yoba Diega" 658 "PS Sikilo Est" 659 "PS Sikilo ouest" 660 "PS Tankanto Escale" 661 "PS Temento Samba" 662 "PS Thiarra" 663 "PS Thiety" 664 "PS Thiewal Lao" 665 "PS Zone lycée" 666 "PS Badion" 667 "PS Bourouko" 668 "PS Diakhaly" 669 "PS Dinguiraye" 670 "PS Dioulanghel Banta" 671 "PS Fafacourou" 672 "PS Firdawsi" 673 "PS Kerewane" 674 "PS Koulinto" 675 "PS Kourkour Balla" 676 "PS Linkédiang" 677 "PS Mballocounda (MYF)" 678 "PS Médina Manda" 679 "PS Medina Passy" 680 "PS Ndorna" 681 "PS Ngoudourou" 682 "PS Niaming" 683 "PS Pata" 684 "PS Santankoye" 685 "PS Sare Yoro Bouya" 686 "PS Sobouldé" 687 "PS Sourouyel" 688 "PS Touba Thieckene" 689 "PS Afia" 690 "PS Bonconto" 691 "PS Dialadiang" 692 "PS Dialakegny" 693 "PS Diaobe" 694 "PS Doubirou" 695 "PS Kabendou" 696 "PS Kalifourou" 697 "PS Kandia" 698 "PS Kandiaye" 699 "PS Kaouné" 700 "PS Kounkane" 701 "PS Linkering" 702 "PS Manda Douane" 703 "PS Mballocounda (Vélingara)" 704 "PS Medina Dianguette" 705 "PS Medina Gounass" 706 "PS Medina Marie Cisse" 707 "PS Municipal thiankan" 708 "PS Nemataba" 709 "PS Nianao" 710 "PS Ouassadou" 711 "PS Pakour" 712 "PS Paroumba" 713 "PS Payoungou" 714 "PS Saré Balla" 715 "PS Sare Coly Salle" 716 "PS Saré Nagué" 717 "PS Sinthian Koundara" 718 "PS Wadiya Toulaye" 719 "PS Affe" 720 "PS Boulal Nianghene" 721 "PS Communal" 722 "PS Dealy" 723 "PS Kamb" 724 "PS Mbaye Awa" 725 "PS Mbeulekhe Diane" 726 "PS Mbeyene" 727 "PS Mboulal" 728 "PS Mélakh" 729 "PS NGuenene" 730 "PS Sagata Djoloff" 731 "PS Sam Fall" 732 "PS Sine Abdou" 733 "PS Tessekere" 734 "PS Thiamene" 735 "PS Touba Boustane" 736 "PS Widou" 737 "PS Yang Yang" 738 "PS Arafat" 739 "PS Darou Diop" 740 "PS Darou Kosso" 741 "PS Darou Marnane" 742 "PS Darou Miname Pet" 743 "PS Darou Wahab" 744 "PS Dekheule" 745 "PS Fass Toure" 746 "PS Keur Alioune Ndiaye" 747 "PS Mbadiane" 748 "PS Ndoyene" 749 "PS Nganado" 750 "PS Sam Yabal" 751 "PS Sar Sara" 752 "PS Taysir" 753 "PS Touba Merina" 754 "PS Touba Roof" 755 "PS Yari Dakhar" 756 "PS Bandegne" 757 "PS Diamaguene" 758 "PS Diokoul" 759 "PS Kab Gaye" 760 "PS Kanene" 761 "PS Keur Amadou Yalla" 762 "PS Lompoul" 763 "PS Loro" 764 "PS Ndakhar Syll" 765 "PS Ndande" 766 "PS Ndieye" 767 "PS Ngourane" 768 "PS Pallene Ndedd" 769 "PS Sagatta Gueth" 770 "PS Thieppe" 771 "PS Thiolom" 772 "PS Boudy Sakho" 773 "PS Boyo 2" 774 "PS Gande" 775 "PS Gankette Balla" 776 "PS Gouye Mbeuth" 777 "PS Keur Maniang" 778 "PS Keur Momar Sarr" 779 "PS Loboudou" 780 "PS Loumboule Mbath" 781 "PS Mbar Toubab" 782 "PS Nayobe" 783 "PS Ndimb" 784 "PS Nguer Malal" 785 "PS Coki" 786 "PS Djadiorde" 787 "PS Garki Diaw" 788 "PS Guet Ardo" 789 "PS Institut Islamique de Koki" 790 "PS Keur Bassine" 791 "PS Ndiagne" 792 "PS Ndiaré Touba Ndiaye" 793 "PS Ouarack" 794 "PS Pete Warack" 795 "PS Thiamene" 796 "PS Barkedji" 797 "PS Darou Salam DIOP" 798 "PS DIagali" 799 "PS Dodji" 800 "PS Dolly" 801 "PS Gassane Ndiawene" 802 "PS Kadji" 803 "PS Labgar" 804 "PS Thiargny" 805 "PS Thiel" 806 "PS Touba Kane Gassane" 807 "PS Touba Linguére" 808 "PS Warkhokh" 809 "PS Artillerie" 810 "PS Dielerlou Syll" 811 "PS Kelle Gueye" 812 "PS Keur Ndiaye" 813 "PS Keur Serigne Louga Est" 814 "PS Keur Serigne Louga Ouest" 815 "PS Keur Sérigne Louga Sud" 816 "PS Mbediene" 817 "PS MEDINA SALAM" 818 "PS MERINA SARR" 819 "PS Ndawene" 820 "PS Nguidila" 821 "PS Niomre" 822 "PS Santhiaba Sud" 823 "PS Touba Darou Salame" 824 "PS Touba Seras" 825 "PS Vesos" 826 "PS Yermande" 827 "PS Darou Rahma" 828 "PS Keur Sambou" 829 "PS Leona" 830 "PS Madina Thiolom" 831 "PS Ndawass Diagne" 832 "PS Ndialakhar Samb" 833 "PS Ndieye Satoure" 834 "PS Ngadji Sarr" 835 "PS Ngueune Sarr" 836 "PS Palene Mafall" 837 "PS Potou" 838 "PS Sague Sathiel" 839 "PS Syer Peulh" 840 "PS Aoure" 841 "PS Bokiladji" 842 "PS Bokissaboudou" 843 "PS Bow" 844 "PS Dembacani" 845 "PS Dialloubé" 846 "PS Diella" 847 "PS Dounde" 848 "PS Fadiara" 849 "PS Foumi Hara" 850 "PS Ganguel Maka" 851 "PS Ganguel Souley" 852 "PS Gaode Boffe" 853 "PS Goumal" 854 "PS Gouriki Koliabé" 855 "PS Hadabere" 856 "PS Hamady Ounare" 857 "PS Kanel" 858 "PS Lobaly" 859 "PS Namary" 860 "PS Ndendory" 861 "PS Ndiott" 862 "PS Nganno" 863 "PS Nianghana Thiedel" 864 "PS Odobere" 865 "PS Orkadiere" 866 "PS Orndolde" 867 "PS Padalal" 868 "PS Polel Diaobe" 869 "PS Semme" 870 "PS Sendou" 871 "PS Seno Palel" 872 "PS Sinthiane" 873 "PS Sinthiou Bamambe" 874 "PS Soringho" 875 "PS Tekkinguel" 876 "PS Thiagnaff" 877 "PS Thially" 878 "PS Thiempeng" 879 "PS Waounde" 880 "PS Wendou Bosseabe" 881 "PS windou nodji" 882 "PS Wourosidi" 883 "PS Yacine Lacké" 884 "PS Danthiady" 885 "PS Boinadji" 886 "PS Bokidiawe" 887 "PS Bokidiawe 2" 888 "PS de la Gendarmerie" 889 "PS Diamel" 890 "PS Diandioly" 891 "PS Dondou" 892 "PS Doumga Ouro Alpha" 893 "PS Fété Niébé" 894 "PS Gaol" 895 "PS Mbakhna" 896 "PS Mboloyel" 897 "PS Nabadji Civol" 898 "PS Ndoulomadji Dembe" 899 "PS Ndouloumadji Founebe" 900 "PS Nguidjilone" 901 "PS Ogo" 902 "PS Ourossogui" 903 "PS Sadel" 904 "PS Sedo Sebe" 905 "PS Sinthiou Garba" 906 "PS Soubalo" 907 "PS Taïba" 908 "PS Thiaréne" 909 "PS Tiguéré" 910 "PS Travaux Dendoudy" 911 "PS Woudourou" 912 "PS Badagore" 913 "PS Dayane Guélodé" 914 "PS Fourdou" 915 "PS Katane" 916 "PS Lougre Thioly" 917 "PS Loumbal Samba Abdoul" 918 "PS Mbam" 919 "PS Mbem Mbem" 920 "PS Naouré" 921 "PS Oudalaye" 922 "PS Patouki" 923 "PS Petiel" 924 "PS Salalatou" 925 "PS Samba Doguel" 926 "PS Thionokh" 927 "PS Velingara Ferlo" 928 "PS Younoufere" 929 "PS Agnam Civol" 930 "PS Agnam Goly" 931 "PS Agnam lidoubé" 932 "PS Agnam Thiodaye" 933 "PS Dabia Odedji" 934 "PS Diorbivol" 935 "PS Goudoudé Diobé" 936 "PS Goudoudé Ndouetbé" 937 "PS Gourel Omar LY" 938 "PS Kobilo" 939 "PS Loumbal Babadji" 940 "PS Loumbi Sanarabe" 941 "PS Mberla Bele" 942 "PS Ndiaffane" 943 "PS Oréfondé" 944 "PS Saré Liou" 945 "PS Sylla Djonto" 946 "PS Bokhol" 947 "PS Bouteyni" 948 "PS Diagle" 949 "PS Gae" 950 "PS Guidakhar" 951 "PS Mbane" 952 "PS Mbilor" 953 "PS Ndombo" 954 "PS Niassante" 955 "PS Santhiaba" 956 "PS Secteur 4 Et 5" 957 "PS Thiago" 958 "PS Aere Lao" 959 "PS Barobe Wassatake" 960 "PS Bode lao" 961 "PS Boguel" 962 "PS Boke Dialoube" 963 "PS Boke Mbaybe Salsalbe" 964 "PS Boke Namari" 965 "PS Boke Yalalbé" 966 "PS Boki Sarankobe" 967 "PS Cascas" 968 "PS Diaba" 969 "PS Diongui" 970 "PS Dioude Diabe" 971 "PS Doumga Lao" 972 "PS Dounguel" 973 "PS Galoya" 974 "PS Gayekadar" 975 "PS Gollere" 976 "PS Karaweyndou" 977 "PS Lougue" 978 "PS Madina Ndiathbe" 979 "PS Mbolo Birane" 980 "PS Mboumba" 981 "PS Mery" 982 "PS Ndiayene Peulh" 983 "PS Salde" 984 "PS Saré Maoundé" 985 "PS Sinthiou Amadou Mairame" 986 "PS Sioure" 987 "PS Thioubalel" 988 "PS Walalde" 989 "PS Yare Lao" 990 "PS Yawaldé Yirlabé" 991 "PS Alwar" 992 "PS Belel Kelle" 993 "PS Commune de Podor" 994 "PS Dara Halaybe" 995 "PS Demet" 996 "PS Diagnoum" 997 "PS Diamal" 998 "PS Diambo" 999 "PS Diattar" 1000 "PS Dimat" 1001 "PS Dodel" 1002 "PS Donaye/ Taredji" 1003 "PS Doué" 1004 "PS Fanaye" 1005 "PS Gamadji Sarre" 1006 "PS Ganina" 1007 "PS Guede Chantier" 1008 "PS Guede Village" 1009 "PS Guiya" 1010 "PS Louboudou Doué" 1011 "PS Mafré" 1012 "PS Marda" 1013 "PS Mbidi" 1014 "PS Mboyo" 1015 "PS Namarel" 1016 "PS Ndiandane" 1017 "PS Ndiawara" 1018 "PS Ndiayen Pendao" 1019 "PS NDIEURBA" 1020 "PS Ndioum" 1021 "PS Nguendar" 1022 "PS Pathe Gallo" 1023 "PS Sinthiou Dangde" 1024 "PS Tatqui" 1025 "PS Thialaga" 1026 "PS Thiangaye" 1027 "PS Toulde Galle" 1028 "PS Debi Tiguette" 1029 "PS Diama" 1030 "PS Diawar" 1031 "PS Gallo Malick" 1032 "PS Kassack Nord" 1033 "PS Kassack Sud" 1034 "PS Khouma" 1035 "PS Mbagam" 1036 "PS Mboundoum" 1037 "PS Ndiangue - Ndiaw" 1038 "PS Ndiaténe" 1039 "PS Ndombo Alarba" 1040 "PS Ngnith" 1041 "PS Niasséne" 1042 "PS Ronkh" 1043 "PS Rosso Senegal 1" 1044 "PS Rosso Senegal 2" 1045 "PS Savoigne" 1046 "PS Taouey" 1047 "PS Thiabakh" 1048 "PS Yamane" 1049 "PS Bango" 1050 "PS Diamaguene" 1051 "PS Fass NGOM" 1052 "PS Gandon" 1053 "PS Goxu Mbath" 1054 "PS Guet Ndar" 1055 "PS Khor" 1056 "PS Mbakhana" 1057 "PS Ngallele" 1058 "PS Nord" 1059 "PS Pikine" 1060 "PS Rao" 1061 "PS Santhiaba (Ndar Toute)" 1062 "PS Sor" 1063 "PS Sor Daga" 1064 "PS Sud" 1065 "PS Tassinere" 1066 "PS Bogal" 1067 "PS Bona" 1068 "PS Boudouk" 1069 "PS Diacounda Diolene" 1070 "PS Dialocounda" 1071 "PS Diambati" 1072 "PS Diaroume" 1073 "PS Diendieme" 1074 "PS Djinani" 1075 "PS Djiragone" 1076 "PS Faoune" 1077 "PS Inor Diola" 1078 "PS Kandion Mangana" 1079 "PS Medina Wandifa" 1080 "PS Ndiama" 1081 "PS Ndiamacouta" 1082 "PS Ndiolofene" 1083 "PS Nioroky" 1084 "PS Senoba" 1085 "PS Seydou N Tall" 1086 "PS Sinthiou Mady Mbaye" 1087 "PS Sinthiou Tankon" 1088 "PS Soumboundou Fogny" 1089 "PS Syllaya" 1090 "PS Tankon" 1091 "PS Touba Fall" 1092 "PS Bafata" 1093 "PS Baghere" 1094 "PS Binako" 1095 "PS Diareng" 1096 "PS Djibanar" 1097 "PS Karantaba" 1098 "PS Kawour" 1099 "PS Kolibantang" 1100 "PS Kougnara" 1101 "PS Niagha" 1102 "PS Safane" 1103 "PS Sandiniery" 1104 "PS Sinbandi Brassou" 1105 "PS Tanaff" 1106 "PS Yarang Balante" 1107 "PS Bemet Bidjini" 1108 "PS Boudhié Samine" 1109 "PS Boumouda" 1110 "PS Bouno" 1111 "PS Dembo Coly" 1112 "PS Diana Malary" 1113 "PS Diannah Bah" 1114 "PS Diende" 1115 "PS Djibabouya" 1116 "PS Djiredji" 1117 "PS Koussy" 1118 "PS Manconoba" 1119 "PS Marakissa" 1120 "PS Marsassoum" 1121 "PS Medina Souane" 1122 "PS Nguindir" 1123 "PS Oudoucar" 1124 "PS Sakar" 1125 "PS Sansamba" 1126 "PS Singhere" 1127 "PS Tourecounda" 1128 "PS Aroundou" 1129 "PS Ballou" 1130 "PS Dedji" 1131 "PS Diawara" 1132 "PS Gabou" 1133 "PS Gallade" 1134 "PS Gande" 1135 "PS Golmy" 1136 "PS Kahé" 1137 "PS Kounghany" 1138 "PS Manael" 1139 "PS Marsa" 1140 "PS Moudery" 1141 "PS Ndjimbe" 1142 "PS Ololdou" 1143 "PS Samba Yide" 1144 "PS Sebou" 1145 "PS Sira Mamadou Bocar" 1146 "PS Tourime" 1147 "PS Tuabou" 1148 "PS Urbain Bakel" 1149 "PS Yaféra" 1150 "PS Yellingara" 1151 "PS Bani Israel" 1152 "PS Bantanani" 1153 "PS Binguel" 1154 "PS Bodé" 1155 "PS Boutoukoufara" 1156 "PS Dalafine" 1157 "PS Diana" 1158 "PS Dieylani" 1159 "PS Dougue" 1160 "PS Douleyabe" 1161 "PS Gouta" 1162 "PS Kayan" 1163 "PS Komoty" 1164 "PS Koudy" 1165 "PS Koussan" 1166 "PS Lelekone" 1167 "PS Madina Diakha" 1168 "PS Niery" 1169 "PS Soutouta" 1170 "PS Talibadji" 1171 "PS Ainoumady" 1172 "PS Bala" 1173 "PS Boynguel Bamba" 1174 "PS Diare Mbolo" 1175 "PS Diyabougou" 1176 "PS Gognedji" 1177 "PS Goumbayel" 1178 "PS Kagnoube" 1179 "PS Koar" 1180 "PS Kothiary" 1181 "PS Koulor" 1182 "PS Kouthia" 1183 "PS Madie" 1184 "PS Mbaniou" 1185 "PS Ndiya" 1186 "PS Sinthiou Mamadou Boubou" 1187 "PS Sinthiou Tafsir" 1188 "PS Tabading" 1189 "PS Thiara" 1190 "PS Toumounguel" 1191 "PS Waly Babacar" 1192 "PS Arigabo" 1193 "PS Banipelly" 1194 "PS Bele" 1195 "PS Belijimbaré" 1196 "PS Daharatou/Ourothierno" 1197 "PS Dialiguel" 1198 "PS Didde Gassama" 1199 "PS Dyabougou" 1200 "PS Gathiary" 1201 "PS Kenieba" 1202 "PS Laminia" 1203 "PS Madina Foulbé" 1204 "PS Nayes" 1205 "PS Ouro Himadou" 1206 "PS Sadatou" 1207 "PS Samba Colo" 1208 "PS Sansanding" 1209 "PS Senedebou" 1210 "PS Sinthiou Dialiguel" 1211 "PS Sinthiou Fissa" 1212 "PS Tacoutala" 1213 "PS Toumboura" 1214 "PS Wouro Souleye" 1215 "PS Bamba Thialene" 1216 "PS Darou Nbimbelane" 1217 "PS Darou Salam" 1218 "PS Darou Salam 2" 1219 "PS Diagle Sine" 1220 "PS Diam Diam" 1221 "PS Fass Gounass" 1222 "PS Kaba" 1223 "PS Kahene" 1224 "PS Kanouma" 1225 "PS Kouthia Gaidy" 1226 "PS Kouthiaba" 1227 "PS Loffé" 1228 "PS Loumby travaux" 1229 "PS Malemba" 1230 "PS Malene Niani" 1231 "PS Mereto" 1232 "PS Ndame" 1233 "PS Pass Koto" 1234 "PS Payar" 1235 "PS Syll Serigne Malick" 1236 "PS Velingara Koto" 1237 "PS Cissecounda" 1238 "PS Colibantang" 1239 "PS Fadiyacounda" 1240 "PS Mboulembou" 1241 "PS Ndoga Babacar" 1242 "PS Pathiap" 1243 "PS Sare Diame" 1244 "PS Saré Ely" 1245 "PS Seoro" 1246 "PS Souba Counda" 1247 "PS Syllame" 1248 "PS Touba Belel" 1249 "PS Afia" 1250 "PS Bambadinka" 1251 "PS Bantantinty" 1252 "PS Bira" 1253 "PS Bohe Baledji" 1254 "PS Botou" 1255 "PS Dar Salam" 1256 "PS Dar Salam Fodé" 1257 "PS Dawady" 1258 "PS Depot" 1259 "PS Dialocoto" 1260 "PS Djinkore" 1261 "PS Fodécounda Ansou" 1262 "PS Gouloumbou" 1263 "PS Gourel Djiadji" 1264 "PS Gouye" 1265 "PS Koussanar" 1266 "PS Missirah" 1267 "PS Neteboulou" 1268 "PS Pont" 1269 "PS Saal" 1270 "PS Sankagne" 1271 "PS Sare Guilele" 1272 "PS Saré Niana" 1273 "PS Segou Coura" 1274 "PS Sinthiou Malene" 1275 "PS Tamba Socé" 1276 "PS Tessan" 1277 "PS Caritas" 1278 "PS Fadial" 1279 "PS Fadiouth" 1280 "PS Mbodiene" 1281 "PS Ndianda" 1282 "PS Ndiemane" 1283 "PS Ngueniene" 1284 "PS Santhe Elisabeth Diouf" 1285 "PS Bangadji" 1286 "PS Bokh" 1287 "PS Diack" 1288 "PS Diayane" 1289 "PS Kaba" 1290 "PS Keur Ibra Gueye" 1291 "PS Keur Macodou" 1292 "PS Keur Yaba Diop" 1293 "PS Mboss" 1294 "PS Mboulouctene" 1295 "PS Mbouvaille" 1296 "PS Ndiakhou" 1297 "PS Ndiayene Sirakh" 1298 "PS Ndoucoumane" 1299 "PS Ndouff-Ndengler" 1300 "PS Ngoudiane" 1301 "PS Sewekhaye" 1302 "PS Thiangaye" 1303 "PS Thienaba" 1304 "PS Touba Toul" 1305 "PS Chaden" 1306 "PS Darou Salam" 1307 "PS Diamaguene" 1308 "PS Djilakh" 1309 "PS Fallokh Malicounda" 1310 "PS Falokh Mbour" 1311 "PS Fandane" 1312 "PS Gandigal" 1313 "PS Grand Mbour" 1314 "PS Malicounda Bambara" 1315 "PS Malicounda Keur Maissa" 1316 "PS Mballing" 1317 "PS Mbouleme" 1318 "PS Mbour Toucouleur" 1319 "PS Medine" 1320 "PS Ngaparou 1" 1321 "PS Ngaparou 2" 1322 "PS Ngoukhouthie" 1323 "PS Nguekokh 1" 1324 "PS Nguekokh 2" 1325 "PS Nguérigne Bambara" 1326 "PS Nianing" 1327 "PS Point Sarene" 1328 "PS Roff" 1329 "PS Saly" 1330 "PS Saly Carrefour" 1331 "PS Santessou" 1332 "PS Santhie" 1333 "PS Somone" 1334 "PS Takhoum" 1335 "PS Tene Toubab" 1336 "PS Trypano" 1337 "PS Varedo" 1338 "PS Warang" 1339 "PS Nguembé" 1340 "PS Darou Gaye" 1341 "PS Diemoul" 1342 "PS Fass Diacksao" 1343 "PS Gade Yell" 1344 "PS Golobé" 1345 "PS Kelle" 1346 "PS Khandane" 1347 "PS Khawlou" 1348 "PS Koul" 1349 "PS Lebou" 1350 "PS Macka Léye" 1351 "PS Mbakhiss" 1352 "PS Mbayene" 1353 "PS Merina Dakhar" 1354 "PS Ndéméne" 1355 "PS Ndierigne" 1356 "PS Ngalick" 1357 "PS Ngandiouf" 1358 "PS Ngaye Diagne" 1359 "PS Ngaye Djitté" 1360 "PS Nguéwoul Loto" 1361 "PS Niakhene" 1362 "PS Pekesse" 1363 "PS Serigne Massamba Diop Same" 1364 "PS Thiékére" 1365 "PS Thilmakha" 1366 "PS Touba Kane" 1367 "PS Tyll Sathé" 1368 "PS Boukhou" 1369 "PS Dagga" 1370 "PS Diass" 1371 "PS Guereo" 1372 "PS Kirene" 1373 "PS Ndayane" 1374 "PS Popenguine Serere" 1375 "PS Sindia" 1376 "PS Thicky" 1377 "PS Toglou" 1378 "PS Bayakh" 1379 "PS Beer" 1380 "PS Cayar" 1381 "PS Keur Matar" 1382 "PS Keur Mousseu" 1383 "PS Ndiar" 1384 "PS Ndiender" 1385 "PS Ngomene" 1386 "PS Soune Serere" 1387 "PS Thor" 1388 "PS Fissel" 1389 "PS Guelor" 1390 "PS Louly Mbentenier" 1391 "PS Louly Ndia" 1392 "PS Mbafaye" 1393 "PS Mbalamsome" 1394 "PS Mboulouctene Secco" 1395 "PS Mbourokh" 1396 "PS Ndiaganiao" 1397 "PS Ndiarao" 1398 "PS Ngeme" 1399 "PS Sandiara" 1400 "PS Sessene" 1401 "PS Tocomack" 1402 "PS Randoulene" 1403 "PS Cite Lamy" 1404 "PS Cite Niakh" 1405 "PS Darou Salam" 1406 "PS Diakhao" 1407 "PS Grand Thies" 1408 "PS Hanene" 1409 "PS Hersent" 1410 "PS Kawsara" 1411 "PS Keur Issa" 1412 "PS Keur Saib Ndoye" 1413 "PS Keur Serigne Ablaye" 1414 "PS Kissane" 1415 "PS Mbour I" 1416 "PS Mbour II" 1417 "PS Mbour III" 1418 "PS Mbousnakh" 1419 "PS Medina Fall I" 1420 "PS Medina Fall II" 1421 "PS Ngoumsane" 1422 "PS Nguinth" 1423 "PS Notto" 1424 "PS Parcelle Assainies" 1425 "PS Petit Thialy" 1426 "PS Peyckouk" 1427 "PS Pognène" 1428 "PS Pout Diack" 1429 "PS Sam Ndiaye" 1430 "PS Sampathe" 1431 "PS Silmang" 1432 "PS Takhikao" 1433 "PS Tassette" 1434 "PS Thies None" 1435 "PS Cherif Lo" 1436 "PS Darou Alpha" 1437 "PS Darou Khoudoss" 1438 "PS Diogo" 1439 "PS Diogo sur mer" 1440 "PS Fass Boye" 1441 "PS Fouloum" 1442 "PS Ka Fall" 1443 "PS Keur Khar DIOP" 1444 "PS Keur Mbir Ndao" 1445 "PS Khonk Yoye" 1446 "PS Mbayenne 3" 1447 "PS Mboro I" 1448 "PS Mboro II" 1449 "PS Medine" 1450 "PS Mekhe Village" 1451 "PS Meouane" 1452 "PS Mibasse" 1453 "PS Mont Rolland" 1454 "PS Ndankh" 1455 "PS Ndiassane" 1456 "PS Ngakhame1" 1457 "PS Nombile" 1458 "PS Notto Gouye Diama" 1459 "PS Pambal" 1460 "PS Pire Goureye" 1461 "PS Sao" 1462 "PS Taîba Ndiaye" 1463 "PS Touba Fall" 1464 "PS Badioncoto" 1465 "PS Badioure" 1466 "PS Baila" 1467 "PS Bougoutoub" 1468 "PS Boureck" 1469 "PS Coubalan" 1470 "PS Coubanao" 1471 "PS Diacoye Banga" 1472 "PS Diamaye" 1473 "PS Diocadou" 1474 "PS Diondji" 1475 "PS Djibidione" 1476 "PS Djilonguia" 1477 "PS Kagnarou" 1478 "PS Mampalago" 1479 "PS Mangouléne" 1480 "PS Manguiline" 1481 "PS Médiegue" 1482 "PS Médiègue Banghouname" 1483 "PS Niamone" 1484 "PS Niandane" 1485 "PS Niankitte" 1486 "PS Oulampane" 1487 "PS Ouonck" 1488 "PS Silinkine" 1489 "PS Sindialon" 1490 "PS Sindian" 1491 "PS Souda" 1492 "PS Suelle" 1493 "PS Tendieme" 1494 "PS Tendimane" 1495 "PS Tendine" 1496 "PS Tenghory Arrondissement" 1497 "PS Tenghory Transgambienne" 1498 "PS Tobor" 1499 "PS Abene" 1500 "PS Badiana" 1501 "PS Baranlire" 1502 "PS Belaye" 1503 "PS Biti Biti" 1504 "PS Couba" 1505 "PS Courame" 1506 "PS Dambondir" 1507 "PS Dar Salam" 1508 "PS Darou Kairy" 1509 "PS Diogue" 1510 "PS Djannah" 1511 "PS Djinaki" 1512 "PS Ebinkine" 1513 "PS Essom Sylatiaye" 1514 "PS Kabiline" 1515 "PS Kafountine" 1516 "PS Medina Daffe" 1517 "PS Niomoune Ile" 1518 "PS Selety" 1519 "PS Touba Tranquille" 1520 "PS Boucotte" 1521 "PS Cabrousse" 1522 "PS Cadjinolle" 1523 "PS Cagnoute" 1524 "PS Cap Skirring" 1525 "PS Carabane Ile" 1526 "PS Carounate" 1527 "PS Diakene Diola" 1528 "PS Diakene Ouolof" 1529 "PS Diembering" 1530 "PS Elinkine" 1531 "PS Loudia Ouolof" 1532 "PS Wendaye" 1533 "PS Youtou" 1534 "PS Bagaya" 1535 "PS Balingor" 1536 "PS Bassire" 1537 "PS Dianki" 1538 "PS Diatock" 1539 "PS Diegoune I" 1540 "PS Diegoune II" 1541 "PS Kagnobon" 1542 "PS Kartiack" 1543 "PS Mandegane" 1544 "PS Mlomp" 1545 "PS Tendouck" 1546 "PS Thiobon" 1547 "PS Adeane" 1548 "PS Agnack" 1549 "PS Baghagha" 1550 "PS Belfort" 1551 "PS Bethesda" 1552 "PS Bourofaye" 1553 "PS Boutoupa" 1554 "PS Colette Senghor" 1555 "PS Diabir" 1556 "PS Diagnon" 1557 "PS Djibock" 1558 "PS Djifanghor" 1559 "PS Emile Badiane" 1560 "PS Enampor" 1561 "PS Kaguitte" 1562 "PS Kande 1" 1563 "PS Kande II" 1564 "PS Kandialang I" 1565 "PS Kandialang II" 1566 "PS Lyndiane Municipal" 1567 "PS Mpack" 1568 "PS Nema" 1569 "PS Niaguis" 1570 "PS Niaguis II" 1571 "PS Nyassia" 1572 "PS Santhiaba" 1573 "PS Seleky" 1574 "PS Sindone" 1575 "PS soucoupapaye" 1576 "PS Toubacouta" 2001 "Ajouter un nouveau poste de santé" 2002 "Ajouter un nouveau poste de santé" 2003 "Ajouter un nouveau poste de santé" 2004 "Ajouter un nouveau poste de santé" 2005 "Ajouter un nouveau poste de santé" 2006 "Ajouter un nouveau poste de santé" 2007 "Ajouter un nouveau poste de santé" 2008 "Ajouter un nouveau poste de santé" 2009 "Ajouter un nouveau poste de santé" 2010 "Ajouter un nouveau poste de santé" 2011 "Ajouter un nouveau poste de santé" 2012 "Ajouter un nouveau poste de santé" 2013 "Ajouter un nouveau poste de santé" 2014 "Ajouter un nouveau poste de santé" 2015 "Ajouter un nouveau poste de santé" 2016 "Ajouter un nouveau poste de santé" 2017 "Ajouter un nouveau poste de santé" 2018 "Ajouter un nouveau poste de santé" 2019 "Ajouter un nouveau poste de santé" 2020 "Ajouter un nouveau poste de santé" 2021 "Ajouter un nouveau poste de santé" 2022 "Ajouter un nouveau poste de santé" 2023 "Ajouter un nouveau poste de santé" 2024 "Ajouter un nouveau poste de santé" 2025 "Ajouter un nouveau poste de santé" 2026 "Ajouter un nouveau poste de santé" 2027 "Ajouter un nouveau poste de santé" 2028 "Ajouter un nouveau poste de santé" 2029 "Ajouter un nouveau poste de santé" 2030 "Ajouter un nouveau poste de santé" 2031 "Ajouter un nouveau poste de santé" 2032 "Ajouter un nouveau poste de santé" 2033 "Ajouter un nouveau poste de santé" 2034 "Ajouter un nouveau poste de santé" 2035 "Ajouter un nouveau poste de santé" 2036 "Ajouter un nouveau poste de santé" 2037 "Ajouter un nouveau poste de santé" 2038 "Ajouter un nouveau poste de santé" 2039 "Ajouter un nouveau poste de santé" 2040 "Ajouter un nouveau poste de santé" 2041 "Ajouter un nouveau poste de santé" 2042 "Ajouter un nouveau poste de santé" 2043 "Ajouter un nouveau poste de santé" 2044 "Ajouter un nouveau poste de santé" 2045 "Ajouter un nouveau poste de santé" 2046 "Ajouter un nouveau poste de santé" 2047 "Ajouter un nouveau poste de santé" 2048 "Ajouter un nouveau poste de santé" 2049 "Ajouter un nouveau poste de santé" 2050 "Ajouter un nouveau poste de santé" 2051 "Ajouter un nouveau poste de santé" 2052 "Ajouter un nouveau poste de santé" 2053 "Ajouter un nouveau poste de santé" 2054 "Ajouter un nouveau poste de santé" 2055 "Ajouter un nouveau poste de santé" 2056 "Ajouter un nouveau poste de santé" 2057 "Ajouter un nouveau poste de santé" 2058 "Ajouter un nouveau poste de santé" 2059 "Ajouter un nouveau poste de santé" 2060 "Ajouter un nouveau poste de santé" 2061 "Ajouter un nouveau poste de santé" 2062 "Ajouter un nouveau poste de santé" 2063 "Ajouter un nouveau poste de santé" 2064 "Ajouter un nouveau poste de santé" 2065 "Ajouter un nouveau poste de santé" 2066 "Ajouter un nouveau poste de santé" 2067 "Ajouter un nouveau poste de santé" 2068 "Ajouter un nouveau poste de santé" 2069 "Ajouter un nouveau poste de santé" 2070 "Ajouter un nouveau poste de santé" 2071 "Ajouter un nouveau poste de santé" 2072 "Ajouter un nouveau poste de santé" 2073 "Ajouter un nouveau poste de santé" 2074 "Ajouter un nouveau poste de santé" 2075 "Ajouter un nouveau poste de santé" 2076 "Ajouter un nouveau poste de santé" 2077 "Ajouter un nouveau poste de santé" 2078 "Ajouter un nouveau poste de santé" 2079 "Ajouter un nouveau poste de santé"
	label values nom_structure nom_structure

	label variable autre_structure "Veuillez ajouter le nom du Poste de Santé"
	note autre_structure: "Veuillez ajouter le nom du Poste de Santé"

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

	label variable s2_1 "201. Estimation de la population polarisée par le poste de santé"
	note s2_1: "201. Estimation de la population polarisée par le poste de santé"

	label variable s2_3 "203. Le poste de santé propose-t-il des services ambulatoires, des services hosp"
	note s2_3: "203. Le poste de santé propose-t-il des services ambulatoires, des services hospitaliers ou les deux ?"
	label define s2_3 1 "Soins ambulatoires uniquement" 2 "Hospitalisation et soins ambulatoires"
	label values s2_3 s2_3

	label variable s3_1_1_1 "301A. Le poste de santé dispose t-il d'une salle d'attente avec des sièges ?"
	note s3_1_1_1: "301A. Le poste de santé dispose t-il d'une salle d'attente avec des sièges ?"
	label define s3_1_1_1 1 "Oui" 2 "Non"
	label values s3_1_1_1 s3_1_1_1

	label variable s3_1_2_1 "301B. Le poste de santé dispose t-il de toilettes pour hommes avec eau courante "
	note s3_1_2_1: "301B. Le poste de santé dispose t-il de toilettes pour hommes avec eau courante dans la salle d'attente ?"
	label define s3_1_2_1 1 "Oui" 2 "Non"
	label values s3_1_2_1 s3_1_2_1

	label variable s3_1_3_1 "301C. Le poste de santé dispose t-il de toilettes pour femmes avec eau courante "
	note s3_1_3_1: "301C. Le poste de santé dispose t-il de toilettes pour femmes avec eau courante dans la salle d'attente ?"
	label define s3_1_3_1 1 "Oui" 2 "Non"
	label values s3_1_3_1 s3_1_3_1

	label variable s3_1_4_1 "301D. Le poste de santé dispose t-il de dispositif de lavage des mains ?"
	note s3_1_4_1: "301D. Le poste de santé dispose t-il de dispositif de lavage des mains ?"
	label define s3_1_4_1 1 "Oui" 2 "Non"
	label values s3_1_4_1 s3_1_4_1

	label variable s3_1_5_1 "301E. Le poste de santé dispose t-il d'eau potable ?"
	note s3_1_5_1: "301E. Le poste de santé dispose t-il d'eau potable ?"
	label define s3_1_5_1 1 "Oui" 2 "Non"
	label values s3_1_5_1 s3_1_5_1

	label variable s3_1_6_1 "301F. Le poste de santé dispose t-il d'alimentation en électricité ?"
	note s3_1_6_1: "301F. Le poste de santé dispose t-il d'alimentation en électricité ?"
	label define s3_1_6_1 1 "Oui" 2 "Non"
	label values s3_1_6_1 s3_1_6_1

	label variable s3_2_1 "A. Le poste de santé dispose-t-il d'une salle de travail ?"
	note s3_2_1: "A. Le poste de santé dispose-t-il d'une salle de travail ?"
	label define s3_2_1 1 "Oui" 2 "Non"
	label values s3_2_1 s3_2_1

	label variable s3_2_2 "B. Le poste de santé dispose-t-il de toilettes fonctionnelles avec eau courante "
	note s3_2_2: "B. Le poste de santé dispose-t-il de toilettes fonctionnelles avec eau courante et chasse d'eau dans la salle de travail ?"
	label define s3_2_2 1 "Oui" 2 "Non"
	label values s3_2_2 s3_2_2

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

	label variable s3_4_1_1 "Le service d’hospitalisation est-il disponible ?"
	note s3_4_1_1: "Le service d’hospitalisation est-il disponible ?"
	label define s3_4_1_1 1 "Oui" 2 "Non"
	label values s3_4_1_1 s3_4_1_1

	label variable s3_4_1_2 "Toilettes fonctionnelles avec eau courante et chasse d'eau sont-elles disponible"
	note s3_4_1_2: "Toilettes fonctionnelles avec eau courante et chasse d'eau sont-elles disponibles dans le service ?"
	label define s3_4_1_2 1 "Oui" 2 "Non"
	label values s3_4_1_2 s3_4_1_2

	label variable s3_4_1_3 "Aire de lavage des mains et de bain séparée pour les patients et les visiteurs s"
	note s3_4_1_3: "Aire de lavage des mains et de bain séparée pour les patients et les visiteurs sont-ils disponibles dans le service?"
	label define s3_4_1_3 1 "Oui" 2 "Non"
	label values s3_4_1_3 s3_4_1_3

	label variable s3_5_2 "B. Tensiomètre est-elle disponible dans le service?"
	note s3_5_2: "B. Tensiomètre est-elle disponible dans le service?"
	label define s3_5_2 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_2 s3_5_2

	label variable s3_5_3 "C. Thermomètre est-il disponible dans le service?"
	note s3_5_3: "C. Thermomètre est-il disponible dans le service?"
	label define s3_5_3 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_3 s3_5_3

	label variable s3_5_4 "D. Fœtoscope/Doppler est-il disponible dans le service?"
	note s3_5_4: "D. Fœtoscope/Doppler est-il disponible dans le service?"
	label define s3_5_4 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_4 s3_5_4

	label variable s3_5_5 "E. Balance nourisson est-elle disponible dans le service?"
	note s3_5_5: "E. Balance nourisson est-elle disponible dans le service?"
	label define s3_5_5 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_5 s3_5_5

	label variable s3_5_6 "F. Balance adulte est-elle disponible dans le service?"
	note s3_5_6: "F. Balance adulte est-elle disponible dans le service?"
	label define s3_5_6 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_6 s3_5_6

	label variable s3_5_7 "G. Stéthoscope adulte/enfant est-il disponible dans le service?"
	note s3_5_7: "G. Stéthoscope adulte/enfant est-il disponible dans le service?"
	label define s3_5_7 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_7 s3_5_7

	label variable s3_5_8 "H. Spéculum est-il disponible dans le service?"
	note s3_5_8: "H. Spéculum est-il disponible dans le service?"
	label define s3_5_8 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_8 s3_5_8

	label variable s3_5_10 "J. Oxygène à canalisation centrale/concentrateur/cylindre est-il disponible dans"
	note s3_5_10: "J. Oxygène à canalisation centrale/concentrateur/cylindre est-il disponible dans le service?"
	label define s3_5_10 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_10 s3_5_10

	label variable s3_5_11 "K. Débitmètre pour la source d'oxygène, avec graduations en ml est-il disponible"
	note s3_5_11: "K. Débitmètre pour la source d'oxygène, avec graduations en ml est-il disponible dans le service?"
	label define s3_5_11 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_11 s3_5_11

	label variable s3_5_12 "L. Humidificateur/Climatisation est-il disponible dans le service?"
	note s3_5_12: "L. Humidificateur/Climatisation est-il disponible dans le service?"
	label define s3_5_12 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_12 s3_5_12

	label variable s3_5_13 "M. Appareil d'administration d'oxygène pour adultes/enfants (tubes de raccordeme"
	note s3_5_13: "M. Appareil d'administration d'oxygène pour adultes/enfants (tubes de raccordement et masque) est-il disponible dans le service?"
	label define s3_5_13 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_13 s3_5_13

	label variable s3_5_14 "N. Appareil d'administration d'oxygène pour adultes/enfants (pinces nasales) est"
	note s3_5_14: "N. Appareil d'administration d'oxygène pour adultes/enfants (pinces nasales) est-il disponible dans le service?"
	label define s3_5_14 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_14 s3_5_14

	label variable s3_5_15 "O. Aspirateur est-il disponible dans le service?"
	note s3_5_15: "O. Aspirateur est-il disponible dans le service?"
	label define s3_5_15 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_15 s3_5_15

	label variable s3_5_16 "P. Réfrigérateur est-il disponible dans le service?"
	note s3_5_16: "P. Réfrigérateur est-il disponible dans le service?"
	label define s3_5_16 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_16 s3_5_16

	label variable s3_5_17 "Q. Chariot de réanimation avec plateau d'urgence est-il disponible dans le servi"
	note s3_5_17: "Q. Chariot de réanimation avec plateau d'urgence est-il disponible dans le service?"
	label define s3_5_17 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_17 s3_5_17

	label variable s3_5_17a "P. Chariot à instruments est-il disponible dans le service ?"
	note s3_5_17a: "P. Chariot à instruments est-il disponible dans le service ?"
	label define s3_5_17a 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_17a s3_5_17a

	label variable s3_5_18 "R. Équipement pour la prévention standard des infections courantes est-il dispon"
	note s3_5_18: "R. Équipement pour la prévention standard des infections courantes est-il disponible dans le service?"
	label define s3_5_18 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_18 s3_5_18

	label variable s3_5_19 "S. Support à perfusion (potence) est-il disponible dans le service?"
	note s3_5_19: "S. Support à perfusion (potence) est-il disponible dans le service?"
	label define s3_5_19 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_19 s3_5_19

	label variable s3_5_20 "T. Dispositif électrique pour les équipements comme l'aspirateur est-il disponib"
	note s3_5_20: "T. Dispositif électrique pour les équipements comme l'aspirateur est-il disponible dans le service?"
	label define s3_5_20 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_20 s3_5_20

	label variable s3_5_21 "U. Poste de soins infirmiers est-il disponible dans le service?"
	note s3_5_21: "U. Poste de soins infirmiers est-il disponible dans le service?"
	label define s3_5_21 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_21 s3_5_21

	label variable s3_5_24 "X. Stéthoscope pédiatrique est-il disponible dans le service?"
	note s3_5_24: "X. Stéthoscope pédiatrique est-il disponible dans le service?"
	label define s3_5_24 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_24 s3_5_24

	label variable s3_5_25 "Y. Oxymètre de pouls est-il disponible dans le service?"
	note s3_5_25: "Y. Oxymètre de pouls est-il disponible dans le service?"
	label define s3_5_25 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_25 s3_5_25

	label variable s3_5_27 "AA. Torche est-elle disponible dans le service?"
	note s3_5_27: "AA. Torche est-elle disponible dans le service?"
	label define s3_5_27 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_27 s3_5_27

	label variable s3_5_28 "BB. Nébuliseur est-il disponible dans le service?"
	note s3_5_28: "BB. Nébuliseur est-il disponible dans le service?"
	label define s3_5_28 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_28 s3_5_28

	label variable s3_5_29 "CC. Masque avec chambre d’inhalation est-il disponible dans le service?"
	note s3_5_29: "CC. Masque avec chambre d’inhalation est-il disponible dans le service?"
	label define s3_5_29 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_29 s3_5_29

	label variable s3_5_30 "DD. Masques de protection : Nouveau-né est-il disponible dans le service?"
	note s3_5_30: "DD. Masques de protection : Nouveau-né est-il disponible dans le service?"
	label define s3_5_30 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_30 s3_5_30

	label variable s3_5_33 "GG. Masques de protection : Adulte est-il disponible dans le service?"
	note s3_5_33: "GG. Masques de protection : Adulte est-il disponible dans le service?"
	label define s3_5_33 1 "Disponible et fonctionnel" 2 "Disponible mais pas fonctionnel" 3 "Indisponible"
	label values s3_5_33 s3_5_33

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

	label variable s5_3_cpn "503. Le ticket de CPN est-il fourni gratuitement ?"
	note s5_3_cpn: "503. Le ticket de CPN est-il fourni gratuitement ?"
	label define s5_3_cpn 1 "Oui" 2 "Non"
	label values s5_3_cpn s5_3_cpn

	label variable s5_4_cpn "504. Combien cela coûte-t-il par unité (le ticket de CPN) ?"
	note s5_4_cpn: "504. Combien cela coûte-t-il par unité (le ticket de CPN) ?"

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

	label variable s5_4_acc "504a. Combien cela coûte-t-il par unité (accouchement normal) ?"
	note s5_4_acc: "504a. Combien cela coûte-t-il par unité (accouchement normal) ?"

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

	label variable s6_4_11 "604.a. Le coton-tige stérile sec est-il disponibles et fonctionnels ?"
	note s6_4_11: "604.a. Le coton-tige stérile sec est-il disponibles et fonctionnels ?"
	label define s6_4_11 1 "Disponible" 2 "Indisponible"
	label values s6_4_11 s6_4_11

	label variable s6_4_12 "604.b. Les gants (gants chirurgicaux stériles/désinfectés à haut niveau ou gants"
	note s6_4_12: "604.b. Les gants (gants chirurgicaux stériles/désinfectés à haut niveau ou gants d'examen) sont-ils disponibles et fonctionnels ?"
	label define s6_4_12 1 "Disponible" 2 "Indisponible"
	label values s6_4_12 s6_4_12

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

	label variable s6_20_6 "Misoprostol / Inj Prostadine"
	note s6_20_6: "Misoprostol / Inj Prostadine"
	label define s6_20_6 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_6 s6_20_6

	label variable s6_20_7 "Amoxicilline Comprimé"
	note s6_20_7: "Amoxicilline Comprimé"
	label define s6_20_7 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_7 s6_20_7

	label variable s6_20_8 "Amoxycilline Injectables"
	note s6_20_8: "Amoxycilline Injectables"
	label define s6_20_8 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_8 s6_20_8

	label variable s6_20_9 "Ampicilline Comprimé"
	note s6_20_9: "Ampicilline Comprimé"
	label define s6_20_9 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_9 s6_20_9

	label variable s6_20_10 "Ampicilline Injectables"
	note s6_20_10: "Ampicilline Injectables"
	label define s6_20_10 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_10 s6_20_10

	label variable s6_20_11 "Albendazole /Mebendazole Comprimés"
	note s6_20_11: "Albendazole /Mebendazole Comprimés"
	label define s6_20_11 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_11 s6_20_11

	label variable s6_20_12 "Albendazole Sirop"
	note s6_20_12: "Albendazole Sirop"
	label define s6_20_12 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_12 s6_20_12

	label variable s6_20_13 "Paracétamol / Diclofénac (Voveran) Comprimés"
	note s6_20_13: "Paracétamol / Diclofénac (Voveran) Comprimés"
	label define s6_20_13 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_13 s6_20_13

	label variable s6_20_14 "Ibuprofène Comprimés"
	note s6_20_14: "Ibuprofène Comprimés"
	label define s6_20_14 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_14 s6_20_14

	label variable s6_20_15 "Paracétamol / Diclofénac Sodium (Voveran) Injectables"
	note s6_20_15: "Paracétamol / Diclofénac Sodium (Voveran) Injectables"
	label define s6_20_15 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_15 s6_20_15

	label variable s6_20_16 "Paquets de SRO"
	note s6_20_16: "Paquets de SRO"
	label define s6_20_16 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_16 s6_20_16

	label variable s6_20_17 "Vaccin TT Injectables"
	note s6_20_17: "Vaccin TT Injectables"
	label define s6_20_17 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_17 s6_20_17

	label variable s6_20_18 "vaccin BCG Injectables"
	note s6_20_18: "vaccin BCG Injectables"
	label define s6_20_18 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_18 s6_20_18

	label variable s6_20_19 "Vaccin oral contre la polio (VPO)"
	note s6_20_19: "Vaccin oral contre la polio (VPO)"
	label define s6_20_19 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_19 s6_20_19

	label variable s6_20_20 "Vaccin Pentavalent Injectables"
	note s6_20_20: "Vaccin Pentavalent Injectables"
	label define s6_20_20 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_20 s6_20_20

	label variable s6_20_21 "Vaccin contre la rougeole Injectables"
	note s6_20_21: "Vaccin contre la rougeole Injectables"
	label define s6_20_21 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_21 s6_20_21

	label variable s6_20_22 "Vit A Injectable"
	note s6_20_22: "Vit A Injectable"
	label define s6_20_22 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_22 s6_20_22

	label variable s6_20_23 "Vit K Injectable"
	note s6_20_23: "Vit K Injectable"
	label define s6_20_23 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_23 s6_20_23

	label variable s6_20_24 "Préservatifs"
	note s6_20_24: "Préservatifs"
	label define s6_20_24 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_24 s6_20_24

	label variable s6_20_25 "Pilules contraceptives orales (PCO)"
	note s6_20_25: "Pilules contraceptives orales (PCO)"
	label define s6_20_25 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_25 s6_20_25

	label variable s6_20_26 "Contraceptifs injectables"
	note s6_20_26: "Contraceptifs injectables"
	label define s6_20_26 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_26 s6_20_26

	label variable s6_20_27 "DIU"
	note s6_20_27: "DIU"
	label define s6_20_27 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_27 s6_20_27

	label variable s6_20_28 "Cathéters"
	note s6_20_28: "Cathéters"
	label define s6_20_28 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_28 s6_20_28

	label variable s6_20_29 "Seringues jetables"
	note s6_20_29: "Seringues jetables"
	label define s6_20_29 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_29 s6_20_29

	label variable s6_20_30 "Gants jetables"
	note s6_20_30: "Gants jetables"
	label define s6_20_30 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_30 s6_20_30

	label variable s6_20_31 "Bandelettes d'albumine/sucre urinaire"
	note s6_20_31: "Bandelettes d'albumine/sucre urinaire"
	label define s6_20_31 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_31 s6_20_31

	label variable s6_20_32 "Tests de grossesse urinaires"
	note s6_20_32: "Tests de grossesse urinaires"
	label define s6_20_32 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_32 s6_20_32

	label variable s6_20_33 "Coton absorbant"
	note s6_20_33: "Coton absorbant"
	label define s6_20_33 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_33 s6_20_33

	label variable s6_20_34 "Compresses"
	note s6_20_34: "Compresses"
	label define s6_20_34 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_34 s6_20_34

	label variable s6_20_35 "Serviettes hygiéniques"
	note s6_20_35: "Serviettes hygiéniques"
	label define s6_20_35 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_35 s6_20_35

	label variable s6_20_36 "Gants chirurgicaux"
	note s6_20_36: "Gants chirurgicaux"
	label define s6_20_36 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_36 s6_20_36

	label variable s6_20_37 "Alcool"
	note s6_20_37: "Alcool"
	label define s6_20_37 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_37 s6_20_37

	label variable s6_20_38 "Ruban adhésif chirurgical"
	note s6_20_38: "Ruban adhésif chirurgical"
	label define s6_20_38 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_38 s6_20_38

	label variable s6_20_39 "Solution iodée"
	note s6_20_39: "Solution iodée"
	label define s6_20_39 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_39 s6_20_39

	label variable s6_20_40 "Réactifs pour les anticorps ABO et Rh"
	note s6_20_40: "Réactifs pour les anticorps ABO et Rh"
	label define s6_20_40 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_40 s6_20_40

	label variable s6_20_41 "Kits de test VIH"
	note s6_20_41: "Kits de test VIH"
	label define s6_20_41 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_41 s6_20_41

	label variable s6_20_42 "Carnets de soins prénatals"
	note s6_20_42: "Carnets de soins prénatals"
	label define s6_20_42 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_42 s6_20_42

	label variable s6_20_43 "Carnets de vaccination pour les moins de 5 ans"
	note s6_20_43: "Carnets de vaccination pour les moins de 5 ans"
	label define s6_20_43 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_43 s6_20_43

	label variable s6_20_44 "Partogramme/Guide de l'accouchement"
	note s6_20_44: "Partogramme/Guide de l'accouchement"
	label define s6_20_44 1 "En stock et observé" 2 "En stock mais non observé" 3 "En rupture de stock" 4 "Non Applicable (Produit Jamais Commandé)"
	label values s6_20_44 s6_20_44

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
		foreach rgvar of varlist s4_1_2_* {
			label variable `rgvar' "1. Désignation du personnel autorisé"
			note `rgvar': "1. Désignation du personnel autorisé"
			label define `rgvar' 1 "Infirmier/Infirmière" 2 "Assistant infirmier" 3 "Sage-femmes" 4 "ASC"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist s4_1_3_* {
			label variable `rgvar' "2. Ce poste est-il actuellement vacant ?"
			note `rgvar': "2. Ce poste est-il actuellement vacant ?"
			label define `rgvar' 1 "Oui" 2 "Non"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist s4_1_4_* {
			label variable `rgvar' "3. Quel est son sexe ?"
			note `rgvar': "3. Quel est son sexe ?"
			label define `rgvar' 1 "Homme" 2 "Femme"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist s4_1_5_* {
			label variable `rgvar' "4. Quel est son niveau d'études ?"
			note `rgvar': "4. Quel est son niveau d'études ?"
			label define `rgvar' 0 "Aucun niveau" 1 "primaire" 2 "secondaire" 3 "baccaulauréat" 4 "licence" 5 "maîtrise" 6 "master" 7 "doctorat" 8 "doctorat avec spécialisation (DES)" 9 "autres"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist s4_1_5au_* {
			label variable `rgvar' "Veuillez préciser le niveau d'études"
			note `rgvar': "Veuillez préciser le niveau d'études"
		}
	}

	capture {
		foreach rgvar of varlist s4_1_6_* {
			label variable `rgvar' "5. Cette personne a-t-elle reçu une formation complémentaire sur le PF ?"
			note `rgvar': "5. Cette personne a-t-elle reçu une formation complémentaire sur le PF ?"
		}
	}

	capture {
		foreach rgvar of varlist s4_1_7_* {
			label variable `rgvar' "6. Cette personne fournit-elle actuellement des services de PF ?"
			note `rgvar': "6. Cette personne fournit-elle actuellement des services de PF ?"
			label define `rgvar' 1 "Oui" 2 "Non"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist s4_1_8_* {
			label variable `rgvar' "7. Quelles sont les méthodes qu'il/elle propose ?"
			note `rgvar': "7. Quelles sont les méthodes qu'il/elle propose ?"
		}
	}

	capture {
		foreach rgvar of varlist s4_1_9_* {
			label variable `rgvar' "8. Cette personne a-t-elle reçu une formation supplémentaire sur la SMNI ?"
			note `rgvar': "8. Cette personne a-t-elle reçu une formation supplémentaire sur la SMNI ?"
		}
	}

	capture {
		foreach rgvar of varlist s4_1_10_* {
			label variable `rgvar' "9. Cette personne fournit-elle actuellement un service de SMNI ?"
			note `rgvar': "9. Cette personne fournit-elle actuellement un service de SMNI ?"
			label define `rgvar' 1 "Oui" 2 "Non"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist s4_1_11_* {
			label variable `rgvar' "10. Quels sont les services de SMNI qu'il/elle fournit ?"
			note `rgvar': "10. Quels sont les services de SMNI qu'il/elle fournit ?"
		}
	}

	capture {
		foreach rgvar of varlist s4_1_12_* {
			label variable `rgvar' "11. Pourquoi le poste est-il actuellement vacant ?"
			note `rgvar': "11. Pourquoi le poste est-il actuellement vacant ?"
			label define `rgvar' 1 "Non recruté/nommé" 2 "En détachement dans une autre sanitaire de santé" 3 "En congé/poursuivant des études supérieures ou une formation pendant plus de 6 m" 4 "Absent du travail" 5 "Autre"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist s4_1_12au_* {
			label variable `rgvar' "Veuillez préciser le motif"
			note `rgvar': "Veuillez préciser le motif"
		}
	}

	capture {
		foreach rgvar of varlist s4_1_13_* {
			label variable `rgvar' "12. Depuis combien de temps ce poste est-il vacant ?"
			note `rgvar': "12. Depuis combien de temps ce poste est-il vacant ?"
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
*   Corrections file path and filename:  C:/Users/pkaberia/Dropbox//FP-Project-APHRC-UM/Atelier_FP/Codes//QUESTIONNAIRE POSTE DE SANTE_corrections.csv
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
