* import_pharmacie_corr.do
*
* 	Imports and aggregates "QUESTIONNAIRE PHARMACIE" (ID: pharmacie_corr) data.
*
*	Inputs:  "C:/Users/pkaberia/Dropbox//FP-Project-APHRC-UM/Atelier_FP/Codes//QUESTIONNAIRE PHARMACIE_WIDE.csv"
*	Outputs: "C:/Users/pkaberia/Dropbox//FP-Project-APHRC-UM/Atelier_FP/Data/Donnees brutes//QUESTIONNAIRE PHARMACIE.dta"
*
*	Output by SurveyCTO February 14, 2025 1:55 PM.

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
local csvfile "C:/Users/pkaberia/Dropbox//FP-Project-APHRC-UM/Atelier_FP/Codes//QUESTIONNAIRE PHARMACIE_WIDE.csv"
local dtafile "C:/Users/pkaberia/Dropbox//FP-Project-APHRC-UM/Atelier_FP/Data/Donnees brutes//QUESTIONNAIRE PHARMACIE.dta"
local corrfile "C:/Users/pkaberia/Dropbox//FP-Project-APHRC-UM/Atelier_FP/Codes//QUESTIONNAIRE PHARMACIE_corrections.csv"
local note_fields1 ""
local text_fields1 "quart_name uius q202b q220a q220b q220c q220d q220e q220f q220g q220h q220i q220j q307other q314_other q321other q328other q335other q342other q349other q401 q402 q402_other q404a q404b q404c q404d"
local text_fields2 "q404e q404f q404g q404h q404i q404j q412other q414 q414other q415 q415other q502 q502_other q504 q504_other q505 q505_other q507 q507_other q610 q511 q511_other q512 q512_other q513 q513_other q517"
local text_fields3 "q517_other q518 q518_other q519 q519_other q521 q521_other q522 q522_other q524_other q525_other q527 q527_other q528 q528_other q532 q532_other q533 q533_other q534 q534_other q539 q539_other q540"
local text_fields4 "q540_other q541_other q542_other q543 q543_other q554 q554_other q555 q555_other q557 q557_other q558 q558_other q560 q560_other q563 q563_other q564 q564_other q565 q565_other q567 q567_other q569"
local text_fields5 "q569_other q570 q570_other instanceid"
local date_fields1 "q204"
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


	label variable region_name "Nom de la région"
	note region_name: "Nom de la région"
	label define region_name 1 "DAKAR" 2 "DIOURBEL" 3 "FATICK" 4 "KAFFRINE" 5 "KAOLACK" 6 "KEDOUGOU" 7 "KOLDA" 8 "LOUGA" 9 "MATAM" 10 "SAINT-LOUIS" 12 "TAMBACOUNDA" 13 "THIES" 14 "ZIGUINCHOR"
	label values region_name region_name

	label variable s1_3 "Choisir le district sanitaire"
	note s1_3: "Choisir le district sanitaire"
	label define s1_3 59 "Bakel" 13 "GUEDIAWAYE" 75 "BIGNONA" 25 "BIRKILANE" 51 "DAGANA" 1 "Dakar Centre" 2 "Dakar Nord" 3 "Dakar Ouest" 4 "Dakar Sud" 14 "DIOURBEL" 19 "FATICK" 20 "FOUNDIOUNE" 26 "KAFFRINE" 47 "KANEL" 30 "KAOLACK" 41 "KEBEMER" 33 "KEDOUGOU" 36 "KOLDA" 27 "KOUNGUEUL" 44 "LINGUERE" 45 "LOUGA" 48 "MATAM" 15 "MBACKE" 68 "MBOUR" 32 "NIORO" 77 "OUSSOUYE" 9 "PIKINE" 53 "PODOR" 10 "RUFISQUE" 55 "SAINT-LOUIS" 65 "TAMBACOUNDA" 73 "THIES" 74 "TIVAOUNE" 38 "VELINGARA" 79 "ZIGUINCHOR"
	label values s1_3 s1_3

	label variable equipe "Choisir l'équipe"
	note equipe: "Choisir l'équipe"
	label define equipe 1 "Equipe 1" 2 "Equipe 2" 3 "Equipe 3" 4 "Equipe 4" 5 "Equipe 5" 6 "Equipe 6" 7 "Equipe 7" 8 "Equipe 8" 9 "Equipe 9" 10 "Equipe 10" 11 "Equipe 11" 12 "Equipe 12" 13 "Equipe 13" 14 "Equipe 14" 15 "Equipe 15" 16 "Equipe 16" 17 "Equipe 17" 18 "Equipe 18" 19 "Equipe 19" 20 "Equipe 20" 21 "Equipe 21"
	label values equipe equipe

	label variable enqueteur "Nom de l'enquêteur"
	note enqueteur: "Nom de l'enquêteur"
	label define enqueteur 1 "Fleur Kona" 2 "Maimouna Yaye Pode Faye" 3 "Malick Ndiongue" 4 "Catherine Mendy" 5 "Mamadou Yacine Diallo Diallo" 6 "Yacine Sall Koumba Boulingui" 7 "Maty Leye" 8 "Fatoumata Binta Bah" 9 "Awa Diouf" 10 "Madicke Diop" 11 "Arona Diagne" 12 "Mame Salane Thiongane" 13 "Débo Diop" 14 "Ndeye Aby Gaye" 15 "Papa amadou Dieye" 16 "Younousse Chérif Goudiaby" 17 "Marieme Boye" 18 "Ibrahima Thiam" 19 "Ahmed Sene" 20 "Mame Gnagna Diagne Kane" 21 "Latyr Diagne" 22 "Sokhna Beye" 23 "Abdoul Khadre Djeylani Gueye" 24 "Bah Fall" 25 "Ndeye Mareme Diop" 26 "Ousmane Mbengue" 27 "Amadou Gueye" 28 "Momar Diop" 29 "Serigne Sow" 30 "Christophe Diouf" 31 "Maimouna Kane" 32 "Tabasky Diouf" 33 "Ndeye Anna Thiam" 34 "Youssou Diallo" 35 "Abdourahmane Niang" 36 "Mame Diarra Bousso Ndao" 37 "Omar Cisse" 38 "Coumba Kane" 39 "Yacine Sall" 40 "Mamadou Mar" 41 "Nayèdio Ba" 42 "Mame Bousso Faye" 43 "Rokhaya Gueye" 44 "Ousmane Samba Gaye" 45 "Ibrahima Diarra" 46 "Khardiata Kane" 47 "Idrissa Gaye" 48 "Mafoudya Camara" 49 "Mouhamed Fall" 50 "Pape Amadou Diop" 51 "Diarra Ndoye" 52 "Bintou Ly" 53 "Mame Mossane Biram Sarr" 54 "Adama Diaw" 55 "Maty Sarr" 56 "Mouhamadou Moustapha Ba" 57 "Serigne saliou Ngom" 58 "Aminata Harouna Dieng" 59 "Aminata Sall Diéye" 60 "Sophie Faye" 61 "Bintou Gueye" 62 "Louise Taky bonang" 63 "Salimata Diallo" 64 "Adama Ba" 65 "Mamour Diop" 66 "Ndeye Ouleye Sarr" 67 "Djiby Diouf" 68 "Madicke Gaye" 69 "Mouhamadou Sy" 70 "Sokhna Diaité" 71 "Mbaye Ndoye" 72 "Moussa Kane" 73 "Cheikh Ndao" 74 "Yaya Balde" 75 "Cheikh Modou Falilou Faye" 76 "Seydina Ousseynou Wade" 77 "Khadim Diouf" 78 "Awa Ndiaye" 79 "Dieynaba Tall" 80 "Souleymane Diol" 81 "Lamine Diop" 82 "Gnima Diedhiou" 83 "Clara Sadio" 84 "Fatoumata Diémé"
	label values enqueteur enqueteur

	label variable pharm_name "Nom de la pharmacie"
	note pharm_name: "Nom de la pharmacie"
	label define pharm_name 1 "DE GOLMY" 2 "DJILY" 3 "EL HADJI MODOU BEYE" 4 "DU KARONE" 5 "YAYE DIARRA" 6 "LE WALO" 7 "MARINAS" 8 "FAKEITA" 9 "SELMA" 10 "BOROM DARADJI" 11 "GRAND DAKAR" 12 "FRONT DE TERRE" 13 "PLUSSS…" 14 "BASS AK BARA" 15 "CAPA" 16 "NASSOU KEITA" 17 "DE L'ETRIER" 18 "HLM MARISTE" 19 "TIDJANI MOUHAMED EL HABIB" 20 "BENETALLY" 21 "ZAHRA MARISTES" 22 "COURO" 23 "DIARAF MBOR NDOYE" 24 "AIME CESAIRE" 25 "MAME FATOU BA" 26 "LE PARCOURS" 27 "CHEIKH ISSA AW" 28 "RAHMA" 29 "HAFIA" 30 "LE COIN SANTE" 31 "EL HADJ ABDOURAHMANE MBENGUE" 32 "DU STADE LEOPOLD SEDAR SENGHOR" 33 "MARIAMA DIANE" 34 "ELHADJI OUMAR DIAW" 35 "MOUNA" 36 "SEYDINA ISSA LAYE" 37 "SERIGNE SALIOU MBACKE" 38 "DE LA PATTE D'OIE" 39 "THIERNO MOUNTAGA AHMED TALL" 40 "LA PARCELLOISE" 41 "DU VIRAGE" 42 "MOULTAZAM" 43 "AMINATA KANE" 44 "MAMADOU KABA KONE" 45 "DAROU SALAM YOFF" 46 "MERMOZ" 47 "YOFFOISE" 48 "XANDAR" 49 "MIGNEL" 50 "STELLA" 51 "DIOGOYE" 52 "MOUHAMADOU EL HAMID" 53 "SABARA" 54 "SUD FOIRE" 55 "DES ALMADIES NGOR" 56 "AL-AMIN" 57 "DU BIEN ETRE" 58 "MEDINA-PROVIDENCE" 59 "ÎLE DE GOREE" 60 "DRUGSTORE" 61 "ABDOUL BIRANE" 62 "GALLIENI" 63 "ROLLAND" 64 "TAMSIR OMAR SALL" 65 "AFRICAINE" 66 "GRANDE PHARMACIE SAHM" 67 "CHEIKH IBRA FALL ROUTE DE BAMBEY" 68 "KHADRISSA" 69 "MAME DIARRA BOUSSO" 70 "NGUETHIONGA" 71 "DAROU KHOUDOSS" 72 "SANT YALLA" 73 "GUEDIAWAYE" 74 "TERMINUS" 75 "DAROU SALAM II" 76 "GOLF SUD" 77 "MARIA" 78 "NATA" 79 "OUMAR SYLLA" 80 "PARMACIE MABEYE EDMOND" 81 "ALHADIA" 82 "NASSIHA" 83 "CANADA" 84 "NDEYE FARY SY" 85 "PASCALINE" 86 "NDIOUGA MARAME" 87 "DU SINE" 88 "ALFAYDA" 89 "SOKHNA DIARRA" 90 "KAWSARA" 91 "SIDY KHARAICHI" 92 "NGANE" 93 "DU TERROIR SIBASSOR" 94 "EL HADJI OUMAR TALL" 95 "YA SALAM" 96 "KENEYA" 97 "DE L' ESPOIR" 98 "MOUHAMADOU KHALY SARR" 99 "ISLAM DAHRA" 100 "ADJA LENA NGER MALAL" 101 "MARBATH GAYE FALL MBOUP" 102 "YAYNI" 103 "DJILY MBAYE" 104 "ALMAMY ABDOU KHADRE KANE" 105 "CHEIKH AHMED TIJANE" 106 "ABDOUL KARIM DAFF" 107 "SOKHNA BOUSSO" 108 "MOUHAMADOUL FADEL" 109 "TOUBA DIANATOU MAHWA" 110 "GUEDE" 111 "WAKANE KHANANE" 112 "SERIGNE CHEIKH SALIOU MBACKE" 113 "MOURIDOULAHI" 114 "SERIGNE ABDOU KHADRE MBACKE" 115 "BOROM DAROU" 116 "NDIGUEL" 117 "ABY DIERE" 118 "AL FATTAH" 119 "DU STADE CAROLINE FAYE" 120 "DE LA PETITE COTE" 121 "LE SOLEIL" 122 "MAME DIARRA BOUSSO" 123 "KHADIDIATOU" 124 "YA LATIF" 125 "SINDIA" 126 "PRINCIPALE" 127 "MBADIENNE FATOU DIOP" 128 "GRANDE PHARMACIE DE THIADIAYE" 129 "OUSMANE THIAM" 130 "DAROU SALAM" 131 "FRATERNITE" 132 "SEYDINA MOUHAMED" 133 "KEUR MAMA DIAKHOU BA" 134 "KASUMAY" 135 "ZAM ZAM" 136 "CATY" 137 "ADJI MOHAMED" 138 "FATY MBAYE MAR" 139 "MAME MBOR" 140 "SERIGNE SALIOU" 141 "PASCAL" 142 "ALBIS" 143 "SANKOUN FATY" 144 "AINOUMADI" 145 "EL HADJ MEDOUNE SEYE" 146 "FATOU BADJI" 147 "SAINT-JOSEPH" 148 "SICAP MBAO" 149 "ADJA KHOUDIA" 150 "MINGUE" 151 "SERIGNE FALLOU MBACKE" 152 "PAPA FAYE" 153 "OUMY NDIAYE" 154 "MAME LENA GAYE" 155 "KHALIFA ABABACAR SY" 156 "AL AMINE MOUHAMED PSL" 157 "AZUR" 158 "ABLAYE GADIAGA" 159 "KEUR MBAYE FALL" 160 "EL HADJI ABDOULAYE SOW" 161 "NDEYE NGATOU BA" 162 "CAS CAS" 163 "ACORE" 164 "KHALY DJIBRIL DIAGNE" 165 "BAYE ISSA" 166 "MOUHAMADOU FADILOU" 167 "NASSIEN BABOULANG" 168 "SR ABDOU AZIZ SY DABAKH" 169 "GALLAS" 170 "SERIGNE ABDOU KHADRE MBACKE" 171 "MOURIDOULLAH" 172 "MASSAWA" 173 "ASTELE" 174 "BINTA DIAGNE" 175 "ALHAMDOULILA" 176 "MOUSSA KANE DIALLO" 177 "KHADIM" 178 "SERIGNE SALIOU THIAM" 179 "FOCUS SANTE" 180 "QUAIE DE PECHE" 181 "THIERNO AMADOU MACTAR SAKHO" 182 "MAME AWA NDIAYE" 183 "DIARAMA" 184 "MOR BAKHE" 185 "CHEIKH IBRAHIMA SALL" 186 "LA THIESSOISE" 187 "RAHMANE GRAND STANDING" 188 "AYNINA FALL" 189 "MAME DIAARA BOUSSO" 190 "LA MAIRIE" 191 "BAKH YAYE MAME ADAMA" 192 "ASHABOUL YAMINE AYA" 193 "MAME ABDOU" 194 "PEKESSE" 195 "DIAMAGUENE" 196 "KHALIFA ABABACAR SY" 197 "SERIGNE MBAYE SY ABDOU" 198 "SERIGNE ABDOURAHMANE MBACKE BOROM DEUR BI" 199 "MANDA DOUANE" 200 "SIMON MANSALY" 201 "BOULEVARD 54M" 202 "DU STADE" 203 "NIAGUIS"
	label values pharm_name pharm_name

	label variable quart_name "Nom du quartier"
	note quart_name: "Nom du quartier"

	label variable lieu_type "Type de lieu"
	note lieu_type: "Type de lieu"
	label define lieu_type 1 "Rural" 2 "Urbain"
	label values lieu_type lieu_type

	label variable uius "Numero d’Identification Unique De Sante (NIUS) du pharmacien ou du proprietaire "
	note uius: "Numero d’Identification Unique De Sante (NIUS) du pharmacien ou du proprietaire de la pharmacie (fourni sur le manuel de l’enquêteur)"

	label variable q201 "Êtes-vous le propriétaire de cette pharmacie ?"
	note q201: "Êtes-vous le propriétaire de cette pharmacie ?"
	label define q201 1 "Oui" 2 "Non"
	label values q201 q201

	label variable q202 "Quel est votre rôle ou votre position dans la gestion de cette pharmacie ?"
	note q202: "Quel est votre rôle ou votre position dans la gestion de cette pharmacie ?"
	label define q202 1 "Pharmacien" 2 "Vendeur" 3 "Autre (Préciser)"
	label values q202 q202

	label variable q202b "Précisez votre rôle"
	note q202b: "Précisez votre rôle"

	label variable q203 "Êtes-vous responsable de la gestion quotidienne de la pharmacie ?"
	note q203: "Êtes-vous responsable de la gestion quotidienne de la pharmacie ?"
	label define q203 1 "Oui" 2 "Non"
	label values q203 q203

	label variable q204 "Depuis quand (date approximative) possédez-vous ou travaillez-vous dans cette ph"
	note q204: "Depuis quand (date approximative) possédez-vous ou travaillez-vous dans cette pharmacie ?"

	label variable q205 "Sexe du répondant"
	note q205: "Sexe du répondant"
	label define q205 1 "Masculin (M)" 2 "Féminin (F)"
	label values q205 q205

	label variable q206 "Quel est le plus haut niveau d’éducation que vous avez atteint ?"
	note q206: "Quel est le plus haut niveau d’éducation que vous avez atteint ?"
	label define q206 1 "CFEE" 2 "BFEM" 3 "Baccalauréat" 4 "Licence" 5 "Master" 6 "Doctorat" 96 "Autres"
	label values q206 q206

	label variable q207 "En vous incluant (ainsi que le propriétaire), combien de personnes travaillent r"
	note q207: "En vous incluant (ainsi que le propriétaire), combien de personnes travaillent régulièrement dans cette pharmacie ?"

	label variable q207a "Combien de femmes font partie du personnel permanent ?"
	note q207a: "Combien de femmes font partie du personnel permanent ?"

	label variable q207b "Combien d'hommes font partie du personnel permanent ?"
	note q207b: "Combien d'hommes font partie du personnel permanent ?"

	label variable q208 "Combien de personnes travaillant régulièrement dans cette pharmacie /, y compris"
	note q208: "Combien de personnes travaillant régulièrement dans cette pharmacie /, y compris le propriétaire, ont une qualification dans le domaine de la santé (pharmacie, vendeur d’officine…)?"

	label variable q209a "Combien de ces employés sont des femmes ?"
	note q209a: "Combien de ces employés sont des femmes ?"

	label variable q209b "Combien de ces employés sont des hommes ?"
	note q209b: "Combien de ces employés sont des hommes ?"

	label variable q210a "Combien de pharmaciens sont des femmes ?"
	note q210a: "Combien de pharmaciens sont des femmes ?"

	label variable q210b "Combien de pharmaciens sont des hommes ?"
	note q210b: "Combien de pharmaciens sont des hommes ?"

	label variable q211 "Avez-vous, vous-même ou l’un de vos collaborateurs, reçu une formation sur des s"
	note q211: "Avez-vous, vous-même ou l’un de vos collaborateurs, reçu une formation sur des sujets liés à la planification familiale ?"
	label define q211 1 "Oui" 2 "Non"
	label values q211 q211

	label variable q211a "Combien d'employés ont reçu une formation en planification familiale ?"
	note q211a: "Combien d'employés ont reçu une formation en planification familiale ?"

	label variable q212 "Cette pharmacie est-elle supervisée par un pharmacien agréé ?"
	note q212: "Cette pharmacie est-elle supervisée par un pharmacien agréé ?"
	label define q212 1 "Oui" 2 "Non"
	label values q212 q212

	label variable q213a "Combien de jours dans la semaine normale, cette pharmacie est-elle ouverte ?"
	note q213a: "Combien de jours dans la semaine normale, cette pharmacie est-elle ouverte ?"

	label variable q213b "Combien de jours dans la semaine de garde, cette pharmacie est-elle ouverte ?"
	note q213b: "Combien de jours dans la semaine de garde, cette pharmacie est-elle ouverte ?"

	label variable q214a "Cette pharmacie offre-t-elle des services 24 heures sur 24 et 7 jours sur 7 en s"
	note q214a: "Cette pharmacie offre-t-elle des services 24 heures sur 24 et 7 jours sur 7 en semaine normale ?"
	label define q214a 1 "Oui" 2 "Non"
	label values q214a q214a

	label variable q214b "Cette pharmacie offre-t-elle des services 24 heures sur 24 et 7 jours sur 7 en s"
	note q214b: "Cette pharmacie offre-t-elle des services 24 heures sur 24 et 7 jours sur 7 en semaine de garde ?"
	label define q214b 1 "Oui" 2 "Non"
	label values q214b q214b

	label variable q215a "Quels sont les horaires d'ouverture de cette pharmacie / droguerie au cours d'un"
	note q215a: "Quels sont les horaires d'ouverture de cette pharmacie / droguerie au cours d'une semaine normale ?"

	label variable q215b "Quels sont les horaires d'ouverture de cette pharmacie / droguerie en semaine de"
	note q215b: "Quels sont les horaires d'ouverture de cette pharmacie / droguerie en semaine de garde ?"

	label variable q216 "Cette pharmacie est-elle affiliée à une formation sanitaire ?"
	note q216: "Cette pharmacie est-elle affiliée à une formation sanitaire ?"
	label define q216 1 "Oui" 2 "Non"
	label values q216 q216

	label variable q217 "La formation sanitaire à laquelle elle est affiliée offre-t-elle des services de"
	note q217: "La formation sanitaire à laquelle elle est affiliée offre-t-elle des services de planification familiale ?"
	label define q217 1 "Oui" 2 "Non"
	label values q217 q217

	label variable q218 "Est ce que vous / cette pharmacie oriente les clients vers l’établissement affil"
	note q218: "Est ce que vous / cette pharmacie oriente les clients vers l’établissement affiliée pour une consultation / administration de services de planification familiale ?"
	label define q218 1 "Oui" 2 "Non"
	label values q218 q218

	label variable q219 "Quelle est la distance entre votre pharmacie et l’établissement de santé auquel "
	note q219: "Quelle est la distance entre votre pharmacie et l’établissement de santé auquel elle est affiliée?"

	label variable q220a "Dispositif intra-utérin"
	note q220a: "Dispositif intra-utérin"

	label variable q220b "Injectables"
	note q220b: "Injectables"

	label variable q220c "Préservatifs (Masculin)"
	note q220c: "Préservatifs (Masculin)"

	label variable q220d "Préservatifs (Féminin)"
	note q220d: "Préservatifs (Féminin)"

	label variable q220e "Contraception d’urgence"
	note q220e: "Contraception d’urgence"

	label variable q220f "Pilules"
	note q220f: "Pilules"

	label variable q220g "Implants"
	note q220g: "Implants"

	label variable q220h "Stérilisation féminine (Ligature des trompes)"
	note q220h: "Stérilisation féminine (Ligature des trompes)"

	label variable q220i "Stérilisation masculine (Vasectomie)"
	note q220i: "Stérilisation masculine (Vasectomie)"

	label variable q220j "Allaitement maternel exclusif (MAMA)"
	note q220j: "Allaitement maternel exclusif (MAMA)"

	label variable q221a "Dispositif intra-utérin"
	note q221a: "Dispositif intra-utérin"

	label variable q221b "Injectables"
	note q221b: "Injectables"

	label variable q221c "Préservatifs (Masculin)"
	note q221c: "Préservatifs (Masculin)"

	label variable q221d "Préservatifs (Féminin)"
	note q221d: "Préservatifs (Féminin)"

	label variable q221e "Contraception d’urgence"
	note q221e: "Contraception d’urgence"

	label variable q221f "Pilules"
	note q221f: "Pilules"

	label variable q221g "Implants"
	note q221g: "Implants"

	label variable q221h "Stérilisation féminine (Ligature des trompes)"
	note q221h: "Stérilisation féminine (Ligature des trompes)"

	label variable q221i "Stérilisation masculine (Vasectomie)"
	note q221i: "Stérilisation masculine (Vasectomie)"

	label variable q221j "Allaitement maternel exclusif (MAMA)"
	note q221j: "Allaitement maternel exclusif (MAMA)"

	label variable q222 "Votre pharmacie facture-t-elle des frais à vos clients pour la prescription de m"
	note q222: "Votre pharmacie facture-t-elle des frais à vos clients pour la prescription de méthodes de planifications familiales ?"
	label define q222 1 "Oui" 2 "Non"
	label values q222 q222

	label variable q223 "Quel est le coût de la prescription de méthodes de planification familiale dans "
	note q223: "Quel est le coût de la prescription de méthodes de planification familiale dans votre pharmacie ?"

	label variable q224 "Cette pharmacie administre-t-elle également des produits injectables/des implant"
	note q224: "Cette pharmacie administre-t-elle également des produits injectables/des implants aux clients ?"
	label define q224 1 "Injectables" 2 "Implants" 3 "Les deux" 4 "Aucune de ces méthodes"
	label values q224 q224

	label variable q225 "Votre pharmacie facture-t-elle des frais à vos clients pour l'administration des"
	note q225: "Votre pharmacie facture-t-elle des frais à vos clients pour l'administration des produits injectables?"
	label define q225 1 "Oui" 2 "Non"
	label values q225 q225

	label variable q226 "Quel est le coût de l’administration des produits injectables dans votre pharmac"
	note q226: "Quel est le coût de l’administration des produits injectables dans votre pharmacie ou votre ?"

	label variable q227 "Votre pharmacie facture-t-elle des frais à vos clients pour la pose d’implant ?"
	note q227: "Votre pharmacie facture-t-elle des frais à vos clients pour la pose d’implant ?"
	label define q227 1 "Oui" 2 "Non"
	label values q227 q227

	label variable q228 "Quel est le montant des frais de pose d’implants appliqués dans votre pharmacie "
	note q228: "Quel est le montant des frais de pose d’implants appliqués dans votre pharmacie ou - ?"

	label variable q301 "Votre pharmacie ou a-t-il stocké ou vendu des DIU au cours des 12 derniers mois "
	note q301: "Votre pharmacie ou a-t-il stocké ou vendu des DIU au cours des 12 derniers mois ?"
	label define q301 1 "Oui" 2 "Non"
	label values q301 q301

	label variable q302 "Combien d’unités (pièces) de DIU votre pharmacie ou a-t-il actuellement en stock"
	note q302: "Combien d’unités (pièces) de DIU votre pharmacie ou a-t-il actuellement en stock ?"

	label variable q303 "Au cours du mois passé, combien de DIU votre pharmacie ou a-t-il vendu ?"
	note q303: "Au cours du mois passé, combien de DIU votre pharmacie ou a-t-il vendu ?"

	label variable q304 "Votre pharmacie a-t-il connu une rupture de stock du DIU au cours des 12 dernier"
	note q304: "Votre pharmacie a-t-il connu une rupture de stock du DIU au cours des 12 derniers mois ?"
	label define q304 1 "Oui" 2 "Non"
	label values q304 q304

	label variable q305 "Quelle a été la durée de la rupture de stock au cours des 12 derniers mois ?"
	note q305: "Quelle a été la durée de la rupture de stock au cours des 12 derniers mois ?"
	label define q305 1 "Mois d'un mois" 2 "1-3mois" 3 "4-6 mois" 4 "Plus de 6 mois"
	label values q305 q305

	label variable q306 "Au cours des trois derniers mois, combien d’incidents se sont produits lorsqu’un"
	note q306: "Au cours des trois derniers mois, combien d’incidents se sont produits lorsqu’une cliente est venue acheter un DIU, mais qu’il n’était pas disponible ?"
	label define q306 1 "Jamais" 2 "Rarement (moins d'une fois par mois)" 3 "Parfois (2 - 3 fois par mois)" 4 "Souvent (plus de 3 fois par mois)"
	label values q306 q306

	label variable q307 "Qu’aviez-vous fait lorsque les DIU n’étaient pas disponibles à un moment ?"
	note q307: "Qu’aviez-vous fait lorsque les DIU n’étaient pas disponibles à un moment ?"
	label define q307 1 "Demander au client de revenir plus tard" 2 "S’arranger quelque part et lui fournir" 3 "Renvoyer le client dans une autre officine" 4 "Renvoyer le client dans un établissement public" 5 "Proposé et vendu une autre méthode" 6 "Renvoyer simplement le client" 96 "Autres (Préciser)"
	label values q307 q307

	label variable q307other "Précisez ce que vous avez fait lorsque les DIU n'étaient pas disponibles ?"
	note q307other: "Précisez ce que vous avez fait lorsque les DIU n'étaient pas disponibles ?"

	label variable q308 "Est ce que votre pharmacie a stocké ou vendu des pilules durant les 12 derniers "
	note q308: "Est ce que votre pharmacie a stocké ou vendu des pilules durant les 12 derniers mois ?"
	label define q308 1 "Oui" 2 "Non"
	label values q308 q308

	label variable q309 "Combien d’unités de pilules cette pharmacie a-t-elle actuellement en stock ?"
	note q309: "Combien d’unités de pilules cette pharmacie a-t-elle actuellement en stock ?"

	label variable q310 "Durant le mois passé, combien d’unités de pilules votre pharmacie a-t-il vendu ?"
	note q310: "Durant le mois passé, combien d’unités de pilules votre pharmacie a-t-il vendu ?"

	label variable q311 "Au cours des 12 derniers mois, votre pharmacie a-t-il connu des ruptures de stoc"
	note q311: "Au cours des 12 derniers mois, votre pharmacie a-t-il connu des ruptures de stock de pilules ?"
	label define q311 1 "Oui" 2 "Non"
	label values q311 q311

	label variable q312 "Quelle a été la durée de la rupture de stock au cours des 12 derniers mois ?"
	note q312: "Quelle a été la durée de la rupture de stock au cours des 12 derniers mois ?"
	label define q312 1 "Mois d'un mois" 2 "1-3mois" 3 "4-6 mois" 4 "Plus de 6 mois"
	label values q312 q312

	label variable q313 "Au cours des trois derniers mois, combien d'incidents se sont produits lorsqu'un"
	note q313: "Au cours des trois derniers mois, combien d'incidents se sont produits lorsqu'un client est venu acheter des pilules, mais que celles-ci n'étaient pas disponibles ?"
	label define q313 1 "Jamais" 2 "Rarement (moins d'une fois par mois)" 3 "Parfois (2 - 3 fois par mois)" 4 "Souvent (plus de 3 fois par mois)"
	label values q313 q313

	label variable q314 "Qu’aviez-vous fait lorsque les pilules n’étaient pas disponibles dans le point d"
	note q314: "Qu’aviez-vous fait lorsque les pilules n’étaient pas disponibles dans le point de vente et que les clients en demandaient ?"
	label define q314 1 "Demander au client de revenir plus tard" 2 "S’arranger quelque part et lui fournir" 3 "Renvoyer le client dans une autre officine" 4 "Renvoyer le client dans un établissement public" 5 "Proposé et vendu une autre méthode" 6 "Renvoyer simplement le client" 96 "Autres (Préciser)"
	label values q314 q314

	label variable q314_other "Précisez ce que vous avez fait d'autre lorsque les pilules n'étaient pas disponi"
	note q314_other: "Précisez ce que vous avez fait d'autre lorsque les pilules n'étaient pas disponibles au point de vente et que les clients les demandaient."

	label variable q315 "Votre pharmacie a-t-il stocké / vendu des préservatifs masculins au cours des 12"
	note q315: "Votre pharmacie a-t-il stocké / vendu des préservatifs masculins au cours des 12 derniers mois ?"
	label define q315 1 "Oui" 2 "Non"
	label values q315 q315

	label variable q316 "Combien d’unités de préservatifs masculins votre pharmacie / a-t-il actuellement"
	note q316: "Combien d’unités de préservatifs masculins votre pharmacie / a-t-il actuellement en stock ?"

	label variable q317 "Durant le mois passé, combien d’unités (paquets) de préservatifs masculins votre"
	note q317: "Durant le mois passé, combien d’unités (paquets) de préservatifs masculins votre pharmacie a-t-il vendu ?"

	label variable q318 "Au cours des 12 derniers mois, votre pharmacie a-t-elle connu des ruptures de pr"
	note q318: "Au cours des 12 derniers mois, votre pharmacie a-t-elle connu des ruptures de préservatifs masculins ?"
	label define q318 1 "Oui" 2 "Non"
	label values q318 q318

	label variable q319 "Quelle a été la durée de la rupture de stock au cours des 12 derniers mois ?"
	note q319: "Quelle a été la durée de la rupture de stock au cours des 12 derniers mois ?"
	label define q319 1 "Mois d'un mois" 2 "1-3mois" 3 "4-6 mois" 4 "Plus de 6 mois"
	label values q319 q319

	label variable q320 "Au cours des 3 derniers mois, combien d’incidents se sont produits lorsqu’un cli"
	note q320: "Au cours des 3 derniers mois, combien d’incidents se sont produits lorsqu’un client est venu acheter de préservatifs masculins, mais qu’il n’était pas disponible ?"
	label define q320 1 "Jamais" 2 "Rarement (moins d'une fois par mois)" 3 "Parfois (2 - 3 fois par mois)" 4 "Souvent (plus de 3 fois par mois)"
	label values q320 q320

	label variable q321 "Qu’aviez-vous fait lorsque les préservatifs masculins n’étaient pas disponibles "
	note q321: "Qu’aviez-vous fait lorsque les préservatifs masculins n’étaient pas disponibles dans le point de vente et que les clients en demandaient ?"
	label define q321 1 "Demander au client de revenir plus tard" 2 "S’arranger quelque part et lui fournir" 3 "Renvoyer le client dans une autre officine" 4 "Renvoyer le client dans un établissement public" 5 "Proposé et vendu une autre méthode" 6 "Renvoyer simplement le client" 96 "Autres (Préciser)"
	label values q321 q321

	label variable q321other "Précisez quelle autre mesure vous avez prise lorsque les préservatifs masculins "
	note q321other: "Précisez quelle autre mesure vous avez prise lorsque les préservatifs masculins n'étaient pas disponibles au point de vente et que les clients en demandaient ?"

	label variable q322 "Votre pharmacie a-t-il stocké / vendu des préservatifs féminins au cours des 12 "
	note q322: "Votre pharmacie a-t-il stocké / vendu des préservatifs féminins au cours des 12 derniers mois ?"
	label define q322 1 "Oui" 2 "Non"
	label values q322 q322

	label variable q323 "Combien d’unités de préservatifs féminins votre pharmacie / a-t-il actuellement "
	note q323: "Combien d’unités de préservatifs féminins votre pharmacie / a-t-il actuellement en stock ?"

	label variable q324 "Durant le mois passé, combien d’unités de préservatifs féminins votre pharmacie "
	note q324: "Durant le mois passé, combien d’unités de préservatifs féminins votre pharmacie / a-t-il vendu ?"

	label variable q325 "Au cours des 12 derniers mois, votre pharmacie / a-t-il connu des ruptures de pr"
	note q325: "Au cours des 12 derniers mois, votre pharmacie / a-t-il connu des ruptures de préservatifs féminins ?"
	label define q325 1 "Oui" 2 "Non"
	label values q325 q325

	label variable q326 "Quelle a été la durée de la rupture de stock au cours des 12 derniers mois ?"
	note q326: "Quelle a été la durée de la rupture de stock au cours des 12 derniers mois ?"
	label define q326 1 "Mois d'un mois" 2 "1-3mois" 3 "4-6 mois" 4 "Plus de 6 mois"
	label values q326 q326

	label variable q327 "Au cours des 3 derniers mois, combien d’incidents se sont produits lorsqu’un cli"
	note q327: "Au cours des 3 derniers mois, combien d’incidents se sont produits lorsqu’un client est venu acheter de préservatifs féminins, mais qu’il n’était pas disponible ?"
	label define q327 1 "Jamais" 2 "Rarement (moins d'une fois par mois)" 3 "Parfois (2 - 3 fois par mois)" 4 "Souvent (plus de 3 fois par mois)"
	label values q327 q327

	label variable q328 "Qu’aviez-vous fait lorsque les préservatifs féminins n’étaient pas disponibles d"
	note q328: "Qu’aviez-vous fait lorsque les préservatifs féminins n’étaient pas disponibles dans le point de vente et que les clients en demandaient ?"
	label define q328 1 "Demander au client de revenir plus tard" 2 "S’arranger quelque part et lui fournir" 3 "Renvoyer le client dans une autre officine" 4 "Renvoyer le client dans un établissement public" 5 "Proposé et vendu une autre méthode" 6 "Renvoyer simplement le client" 96 "Autres (Préciser)"
	label values q328 q328

	label variable q328other "Autre"
	note q328other: "Autre"

	label variable q329 "Votre pharmacie a-t-elle stocké / vendu des contraceptions injectables au cours "
	note q329: "Votre pharmacie a-t-elle stocké / vendu des contraceptions injectables au cours des 12 derniers mois ?"
	label define q329 1 "Oui" 2 "Non"
	label values q329 q329

	label variable q330 "Combien d’unités (doses) de contraception injectable votre pharmacie / a-t-elle "
	note q330: "Combien d’unités (doses) de contraception injectable votre pharmacie / a-t-elle actuellement en stock ?"

	label variable q331 "Durant le mois passé, combien d’unités (doses) de contraception injectable votre"
	note q331: "Durant le mois passé, combien d’unités (doses) de contraception injectable votre pharmacie / a-t-elle vendu ?"

	label variable q332 "Au cours des 12 derniers mois, votre pharmacie / a-t-elle connu des ruptures d’i"
	note q332: "Au cours des 12 derniers mois, votre pharmacie / a-t-elle connu des ruptures d’injectable ?"
	label define q332 1 "Oui" 2 "Non"
	label values q332 q332

	label variable q333 "Quelle a été la durée de la rupture de stock au cours des 12 derniers mois ?"
	note q333: "Quelle a été la durée de la rupture de stock au cours des 12 derniers mois ?"
	label define q333 1 "Mois d'un mois" 2 "1-3mois" 3 "4-6 mois" 4 "Plus de 6 mois"
	label values q333 q333

	label variable q334 "Au cours des 3 derniers mois, combien d’incidents se sont produits lorsqu’un cli"
	note q334: "Au cours des 3 derniers mois, combien d’incidents se sont produits lorsqu’un client est venu acheter des contraceptions injectables mais qu’il n’était pas disponible ?"
	label define q334 1 "Jamais" 2 "Rarement (moins d'une fois par mois)" 3 "Parfois (2 - 3 fois par mois)" 4 "Souvent (plus de 3 fois par mois)"
	label values q334 q334

	label variable q335 "Qu’aviez-vous fait lorsque les contraceptions injectables de vente n’étaient pas"
	note q335: "Qu’aviez-vous fait lorsque les contraceptions injectables de vente n’étaient pas disponibles et que les clients en demandaient ?"
	label define q335 1 "Demander au client de revenir plus tard" 2 "S’arranger quelque part et lui fournir" 3 "Renvoyer le client dans une autre officine" 4 "Renvoyer le client dans un établissement public" 5 "Proposé et vendu une autre méthode" 6 "Renvoyer simplement le client" 96 "Autres (Préciser)"
	label values q335 q335

	label variable q335other "Autre"
	note q335other: "Autre"

	label variable q336 "Votre pharmacie a-t-elle stocké / vendu des implants au cours des 12 derniers mo"
	note q336: "Votre pharmacie a-t-elle stocké / vendu des implants au cours des 12 derniers mois ?"
	label define q336 1 "Oui" 2 "Non"
	label values q336 q336

	label variable q337 "Combien d’unités (pièces) des implants votre pharmacie / a-t-elle actuellement e"
	note q337: "Combien d’unités (pièces) des implants votre pharmacie / a-t-elle actuellement en stock ?"

	label variable q338 "Durant le mois passé, combien d’unités (pièces) d’implants votre pharmacie / a-t"
	note q338: "Durant le mois passé, combien d’unités (pièces) d’implants votre pharmacie / a-t-elle vendu ?"

	label variable q339 "Au cours des 12 derniers mois, votre pharmacie / a-t-elle connu des ruptures d’i"
	note q339: "Au cours des 12 derniers mois, votre pharmacie / a-t-elle connu des ruptures d’implants ?"
	label define q339 1 "Oui" 2 "Non"
	label values q339 q339

	label variable q340 "Quelle a été la durée de la rupture de stock au cours des 12 derniers mois ?"
	note q340: "Quelle a été la durée de la rupture de stock au cours des 12 derniers mois ?"
	label define q340 1 "Mois d'un mois" 2 "1-3mois" 3 "4-6 mois" 4 "Plus de 6 mois"
	label values q340 q340

	label variable q341 "Au cours des 3 derniers mois, combien d’incidents se sont produits lorsqu’un cli"
	note q341: "Au cours des 3 derniers mois, combien d’incidents se sont produits lorsqu’un client est venu acheter des implants, mais qu’il n’était pas disponible ?"
	label define q341 1 "Jamais" 2 "Rarement (moins d'une fois par mois)" 3 "Parfois (2 - 3 fois par mois)" 4 "Souvent (plus de 3 fois par mois)"
	label values q341 q341

	label variable q342 "Qu’aviez-vous fait lorsque les implants de vente n’étaient pas disponibles et qu"
	note q342: "Qu’aviez-vous fait lorsque les implants de vente n’étaient pas disponibles et que les clients en demandaient ?"
	label define q342 1 "Demander au client de revenir plus tard" 2 "S’arranger quelque part et lui fournir" 3 "Renvoyer le client dans une autre officine" 4 "Renvoyer le client dans un établissement public" 5 "Proposé et vendu une autre méthode" 6 "Renvoyer simplement le client" 96 "Autres (Préciser)"
	label values q342 q342

	label variable q342other "Autre"
	note q342other: "Autre"

	label variable q343 "Votre pharmacie / a-t-il stocké ou vendu la contraception d’urgence au cours des"
	note q343: "Votre pharmacie / a-t-il stocké ou vendu la contraception d’urgence au cours des 12 derniers mois ?"
	label define q343 1 "Oui" 2 "Non"
	label values q343 q343

	label variable q344 "Combien d’unités de contraception d’urgence votre pharmacie / a-t-elle actuellem"
	note q344: "Combien d’unités de contraception d’urgence votre pharmacie / a-t-elle actuellement en stock ?"

	label variable q345 "Au cours du mois passé, combien d’unités de contraception d’urgence votre pharma"
	note q345: "Au cours du mois passé, combien d’unités de contraception d’urgence votre pharmacie / a-t-elle vendu ?"

	label variable q346 "Votre pharmacie / a-t-elle connu des ruptures de stock de contraception d’urgenc"
	note q346: "Votre pharmacie / a-t-elle connu des ruptures de stock de contraception d’urgence au cours des 12 derniers mois ?"
	label define q346 1 "Oui" 2 "Non"
	label values q346 q346

	label variable q347 "Quelle a été la durée de la rupture de stock au cours des 12 derniers mois ?"
	note q347: "Quelle a été la durée de la rupture de stock au cours des 12 derniers mois ?"
	label define q347 1 "Mois d'un mois" 2 "1-3mois" 3 "4-6 mois" 4 "Plus de 6 mois"
	label values q347 q347

	label variable q348 "Au cours des 3 derniers mois, combien d’incidents se sont produits lorsqu’un cli"
	note q348: "Au cours des 3 derniers mois, combien d’incidents se sont produits lorsqu’un client est venu acheter une contraception d’urgence, mais qu’ils n’étaient pas disponibles ?"
	label define q348 1 "Jamais" 2 "Rarement (moins d'une fois par mois)" 3 "Parfois (2 - 3 fois par mois)" 4 "Souvent (plus de 3 fois par mois)"
	label values q348 q348

	label variable q349 "Qu’aviez-vous fait lorsque la contraception d’urgence n’était pas disponible à u"
	note q349: "Qu’aviez-vous fait lorsque la contraception d’urgence n’était pas disponible à un moment ?"
	label define q349 1 "Demander au client de revenir plus tard" 2 "S’arranger quelque part et lui fournir" 3 "Renvoyer le client dans une autre officine" 4 "Renvoyer le client dans un établissement public" 5 "Proposé et vendu une autre méthode" 6 "Renvoyer simplement le client" 96 "Autres (Préciser)"
	label values q349 q349

	label variable q349other "Autre"
	note q349other: "Autre"

	label variable q401 "Quelles sont les trois méthodes de planification familiale les plus fréquemment "
	note q401: "Quelles sont les trois méthodes de planification familiale les plus fréquemment demandées par les clients de votre commune ?"

	label variable q401a "Rang pour DIU"
	note q401a: "Rang pour DIU"

	label variable q401b "Rang pour Injectables"
	note q401b: "Rang pour Injectables"

	label variable q401c "Rang pour Préservatifs (Masculin)"
	note q401c: "Rang pour Préservatifs (Masculin)"

	label variable q401d "Rang pour Préservatifs (Féminin)"
	note q401d: "Rang pour Préservatifs (Féminin)"

	label variable q401e "Rang pour Contraception d’urgence"
	note q401e: "Rang pour Contraception d’urgence"

	label variable q401f "Rang pour Pilules"
	note q401f: "Rang pour Pilules"

	label variable q401g "Rang pour Implants"
	note q401g: "Rang pour Implants"

	label variable q401h "Rang pour Stérilisation féminine"
	note q401h: "Rang pour Stérilisation féminine"

	label variable q401i "Rang pour Stérilisation masculine"
	note q401i: "Rang pour Stérilisation masculine"

	label variable q401j "Rang pour Allaitement maternel exclusif"
	note q401j: "Rang pour Allaitement maternel exclusif"

	label variable q402 "Comment décidez-vous des contraceptifs que vous suggérerez aux clients s’ils vou"
	note q402: "Comment décidez-vous des contraceptifs que vous suggérerez aux clients s’ils vous le demandent ?"

	label variable q402_other "Autre"
	note q402_other: "Autre"

	label variable q403 "En moyenne, combien de clients cette pharmacie / sert-il chaque mois pour des mé"
	note q403: "En moyenne, combien de clients cette pharmacie / sert-il chaque mois pour des méthodes de planification familiale ?"

	label variable q404a "Quel type de clients vient habituellement chercher dans votre pharmacie les serv"
	note q404a: "Quel type de clients vient habituellement chercher dans votre pharmacie les services et produits de planification familiale comme le DIU ?"

	label variable q404b "Quel type de clients vient habituellement chercher dans votre pharmacie les serv"
	note q404b: "Quel type de clients vient habituellement chercher dans votre pharmacie les services et produits de planification familiale comme les Injectables ?"

	label variable q404c "Quel type de clients vient habituellement chercher dans votre pharmacie les serv"
	note q404c: "Quel type de clients vient habituellement chercher dans votre pharmacie les services et produits de planification familiale comme les Préservatifs (Masculin) ?"

	label variable q404d "Quel type de clients vient habituellement chercher dans votre pharmacie les serv"
	note q404d: "Quel type de clients vient habituellement chercher dans votre pharmacie les services et produits de planification familiale comme les Préservatifs (féminin) ?"

	label variable q404e "Quel type de clients vient habituellement chercher dans votre pharmacie les serv"
	note q404e: "Quel type de clients vient habituellement chercher dans votre pharmacie les services et produits de planification familiale comme la Contraception d’urgence ?"

	label variable q404f "Quel type de clients vient habituellement chercher dans votre pharmacie les serv"
	note q404f: "Quel type de clients vient habituellement chercher dans votre pharmacie les services et produits de planification familiale comme les Pilules ?"

	label variable q404g "Quel type de clients vient habituellement chercher dans votre pharmacie les serv"
	note q404g: "Quel type de clients vient habituellement chercher dans votre pharmacie les services et produits de planification familiale comme les Implants ?"

	label variable q404h "Quel type de clients vient habituellement chercher dans votre pharmacie les serv"
	note q404h: "Quel type de clients vient habituellement chercher dans votre pharmacie les services et produits de planification familiale comme la Stérilisation féminine ?"

	label variable q404i "Quel type de clients vient habituellement chercher dans votre pharmacie les serv"
	note q404i: "Quel type de clients vient habituellement chercher dans votre pharmacie les services et produits de planification familiale comme la Stérilisation masculine ?"

	label variable q404j "Quel type de clients vient habituellement chercher dans votre pharmacie les serv"
	note q404j: "Quel type de clients vient habituellement chercher dans votre pharmacie les services et produits de planification familiale comme l'Allaitement maternel exclusif ?"

	label variable q405 "Cette pharmacie / propose-t-elle également des pilules abortives < / b>?"
	note q405: "Cette pharmacie / propose-t-elle également des pilules abortives < / b>?"
	label define q405 1 "Oui" 2 "Non"
	label values q405 q405

	label variable q406 "Au cours des 12 derniers mois, votre pharmacie / a-t-elle stocké ou vendu des pi"
	note q406: "Au cours des 12 derniers mois, votre pharmacie / a-t-elle stocké ou vendu des pilules abortives < / b>?"
	label define q406 1 "Oui" 2 "Non"
	label values q406 q406

	label variable q407 "Combien d’unités (bandes) de pilules abortives médicales votre pharmacie / a-t-e"
	note q407: "Combien d’unités (bandes) de pilules abortives médicales votre pharmacie / a-t-elle actuellement en stock ?"

	label variable q408 "Au cours du mois écoulé, combien d’unités de pilules médicales abortives avez-vo"
	note q408: "Au cours du mois écoulé, combien d’unités de pilules médicales abortives avez-vous vendu< / b> ?"

	label variable q409 "Au cours des 12 derniers mois y a-t-il eu des ruptures de stock de pilules abort"
	note q409: "Au cours des 12 derniers mois y a-t-il eu des ruptures de stock de pilules abortives ?"
	label define q409 1 "Oui" 2 "Non"
	label values q409 q409

	label variable q410 "Quelle a été la durée de la rupture de stock au cours des 12 derniers mois ?"
	note q410: "Quelle a été la durée de la rupture de stock au cours des 12 derniers mois ?"
	label define q410 1 "Mois d'un mois" 2 "1-3mois" 3 "4-6 mois" 4 "Plus de 6 mois"
	label values q410 q410

	label variable q411 "Au cours des 3 derniers mois, combien d’incidents se sont produits lorsqu’une cl"
	note q411: "Au cours des 3 derniers mois, combien d’incidents se sont produits lorsqu’une cliente est venue acheter des pilules abortives à des fins médicales, mais qu’elles n’étaient pas disponibles"
	label define q411 1 "Jamais" 2 "Rarement (moins d'une fois par mois)" 3 "Parfois (2 - 3 fois par mois)" 4 "Souvent (plus de 3 fois par mois)"
	label values q411 q411

	label variable q412 "Qu’aviez-vous fait lorsque les pilules médicales abortives n’étaient pas disponi"
	note q412: "Qu’aviez-vous fait lorsque les pilules médicales abortives n’étaient pas disponibles à un moment donné ?"
	label define q412 1 "Demander au client de revenir plus tard" 2 "S’arranger quelque part et lui fournir" 3 "Renvoyer le client dans une autre officine" 4 "Renvoyer le client dans un établissement public" 5 "Proposé et vendu une autre méthode" 6 "Renvoyer simplement le client" 96 "Autres (Préciser)"
	label values q412 q412

	label variable q412other "Autre"
	note q412other: "Autre"

	label variable q413 "Au cours du mois écoulé, combien de clientes se sont présentées à la pharmacie /"
	note q413: "Au cours du mois écoulé, combien de clientes se sont présentées à la pharmacie / pour demander des pilules abortives ?"

	label variable q414 "Comment décidez-vous de la pilule abortive médicale que vous suggérerez à vos cl"
	note q414: "Comment décidez-vous de la pilule abortive médicale que vous suggérerez à vos clients ?"

	label variable q414other "Autre"
	note q414other: "Autre"

	label variable q415 "Quels types de clients achètent généralement les pilules abortives dans votre ph"
	note q415: "Quels types de clients achètent généralement les pilules abortives dans votre pharmacie ?"

	label variable q415other "Autre"
	note q415other: "Autre"

	label variable q501 "Selon vous, quel est l’âge approprié pour qu’une femme tombe enceinte pour la pr"
	note q501: "Selon vous, quel est l’âge approprié pour qu’une femme tombe enceinte pour la première fois ?"

	label variable q502 "Selon vous, quels sont les avantages pour la santé d’une femme si elle tombe enc"
	note q502: "Selon vous, quels sont les avantages pour la santé d’une femme si elle tombe enceinte à l’âge approprié que vous avez mentionné ?"

	label variable q502_other "Autre"
	note q502_other: "Autre"

	label variable q503 "Selon vous, quel devrait être l’espacement minimum entre deux naissances consécu"
	note q503: "Selon vous, quel devrait être l’espacement minimum entre deux naissances consécutives ?"

	label variable q504 "Selon vous, quels sont les bénéfices de l’espacement des naissances pour une fem"
	note q504: "Selon vous, quels sont les bénéfices de l’espacement des naissances pour une femme ?"

	label variable q504_other "Autre"
	note q504_other: "Autre"

	label variable q505 "Selon vous, quel(s) avantage(s) sanitaire(s) un enfant aura-t-il si les naissanc"
	note q505: "Selon vous, quel(s) avantage(s) sanitaire(s) un enfant aura-t-il si les naissances sont espacées ?"

	label variable q505_other "Autre"
	note q505_other: "Autre"

	label variable q506 "Selon vous, combien de temps une femme doit-elle attendre après un avortement sp"
	note q506: "Selon vous, combien de temps une femme doit-elle attendre après un avortement spontané ou provoqué pour retomber enceinte ?"

	label variable q507 "Selon vous, quels sont les avantages pour les femmes d’attendre au lieu de tombe"
	note q507: "Selon vous, quels sont les avantages pour les femmes d’attendre au lieu de tomber enceinte immédiatement ?"

	label variable q507_other "Autre"
	note q507_other: "Autre"

	label variable q508 "Que dites-vous de l’assertion suivante « une femme a plus de chances de tomber e"
	note q508: "Que dites-vous de l’assertion suivante « une femme a plus de chances de tomber enceinte si elle a des rapports sexuels à certains jours de son cycle menstruel ». Est-elle vraie ou fausse ?"
	label define q508 1 "Vraie" 2 "Fausse" 98 "Ne sais pas"
	label values q508 q508

	label variable q509 "Quels sont les jours du cycle menstruel où les chances de tomber enceinte sont l"
	note q509: "Quels sont les jours du cycle menstruel où les chances de tomber enceinte sont les plus élevées ?"
	label define q509 1 "7 jours avant le début des règles" 2 "Jusqu’à 7 jours après le début des règles" 3 "Du 8e au 20e jour après la menstruation" 98 "Ne sais pas"
	label values q509 q509

	label variable q610 "Quelles sont les méthodes contraceptives dont vous avez entendu parler ?"
	note q610: "Quelles sont les méthodes contraceptives dont vous avez entendu parler ?"

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

	label variable q511 "Vous avez dit que vous-avez entendu parler de DIU. Quels sont les avantages d’ut"
	note q511: "Vous avez dit que vous-avez entendu parler de DIU. Quels sont les avantages d’utiliser ces méthodes ? Quoi d’autre ?"

	label variable q511_other "Autre"
	note q511_other: "Autre"

	label variable q512 "Quels sont les problèmes auxquels les clients font face lors de l’utilisation de"
	note q512: "Quels sont les problèmes auxquels les clients font face lors de l’utilisation de DIU ?"

	label variable q512_other "Autre"
	note q512_other: "Autre"

	label variable q513 "Quels sont les états de santé et les situations dans lesquels une femme ne devra"
	note q513: "Quels sont les états de santé et les situations dans lesquels une femme ne devrait pas utiliser de DIU ?"

	label variable q513_other "Autre"
	note q513_other: "Autre"

	label variable q514 "Selon vous, cette méthode est-elle adaptée pour retarder la première naissance ?"
	note q514: "Selon vous, cette méthode est-elle adaptée pour retarder la première naissance ?"
	label define q514 1 "Oui" 2 "Non" 98 "Ne sais pas"
	label values q514 q514

	label variable q515 "Selon vous, cette méthode est-elle adaptée au maintien de l’intervalle entre deu"
	note q515: "Selon vous, cette méthode est-elle adaptée au maintien de l’intervalle entre deux naissances ?"
	label define q515 1 "Oui" 2 "Non" 98 "Ne sais pas"
	label values q515 q515

	label variable q516 "Pensez-vous que les légers saignements après l’insertion de DIU sont normaux ?"
	note q516: "Pensez-vous que les légers saignements après l’insertion de DIU sont normaux ?"
	label define q516 1 "Oui" 2 "Non" 98 "Ne sais pas"
	label values q516 q516

	label variable q517 "Selon vous, quel est le moment le plus recommandé pour insérer à une femme un DI"
	note q517: "Selon vous, quel est le moment le plus recommandé pour insérer à une femme un DIU ?"

	label variable q517_other "Autre"
	note q517_other: "Autre"

	label variable q518 "Selon vous, qui peut insérer un DIU ?"
	note q518: "Selon vous, qui peut insérer un DIU ?"

	label variable q518_other "Autre"
	note q518_other: "Autre"

	label variable q519 "Que dites-vous à une femme pour verifier si le DIU est en place ?"
	note q519: "Que dites-vous à une femme pour verifier si le DIU est en place ?"

	label variable q519_other "Autre"
	note q519_other: "Autre"

	label variable q520 "Pouvez-vous nous dire la fréquence d’utilisation des pilules"
	note q520: "Pouvez-vous nous dire la fréquence d’utilisation des pilules"
	label define q520 1 "Chaque jour" 2 "Chaque semaine" 3 "Les deux" 98 "Ne sais pas"
	label values q520 q520

	label variable q521 "Quels sont les problémes auxquels les femmes peuvent faire face durant / après l"
	note q521: "Quels sont les problémes auxquels les femmes peuvent faire face durant / après la prise d’une pilule?"

	label variable q521_other "Autre"
	note q521_other: "Autre"

	label variable q522 "Quelles sont les situations sanitaires pour lesquelles la prise de pilules chez "
	note q522: "Quelles sont les situations sanitaires pour lesquelles la prise de pilules chez la femme pourrait être dangeureuse ?"

	label variable q522_other "Autre (Préciser)"
	note q522_other: "Autre (Préciser)"

	label variable q523 "Pensez-vous que les pilules peuvent être conseillées à la femme qui allaite ?"
	note q523: "Pensez-vous que les pilules peuvent être conseillées à la femme qui allaite ?"
	label define q523 1 "Oui" 2 "Non" 98 "Ne sais pas"
	label values q523 q523

	label variable q524 "A votre avis, quand est ce qu’une femme doit commencer à prendre la pilule après"
	note q524: "A votre avis, quand est ce qu’une femme doit commencer à prendre la pilule après ses règles ?"
	label define q524 1 "Premier jour du cycle menstruel" 2 "Dans les cinq jours suivant le début du cycle menstruel" 3 "Dernier jour du cycle menstruel" 4 "À tout moment" 96 "Autre (Précisez)" 98 "Ne sais pas"
	label values q524 q524

	label variable q524_other "Autre (Préciser)"
	note q524_other: "Autre (Préciser)"

	label variable q525 "Pour être efficace, quand est-ce que les préservatifs doivent être utilisés ?"
	note q525: "Pour être efficace, quand est-ce que les préservatifs doivent être utilisés ?"
	label define q525 1 "À chaque rapport sexuel" 96 "Autre réponse" 98 "Ne sais pas"
	label values q525 q525

	label variable q525_other "Autre (Préciser)"
	note q525_other: "Autre (Préciser)"

	label variable q526 "Combien de fois peut-on utiliser un préservatif lors d’un rapport sexuel ?"
	note q526: "Combien de fois peut-on utiliser un préservatif lors d’un rapport sexuel ?"
	label define q526 1 "Une fois" 2 "Deux fois" 3 "Plus de deux fois" 98 "Ne sais pas"
	label values q526 q526

	label variable q527 "Quels sont les avantages d’utiliser un préservatif ?"
	note q527: "Quels sont les avantages d’utiliser un préservatif ?"

	label variable q527_other "Autre (Préciser)"
	note q527_other: "Autre (Préciser)"

	label variable q528 "Quels sont les problémes auxquels un client peut faire face lors de l’utilisatio"
	note q528: "Quels sont les problémes auxquels un client peut faire face lors de l’utilisation d’un préservatif ?"

	label variable q528_other "Autre (Préciser)"
	note q528_other: "Autre (Préciser)"

	label variable q529 "Selon vous, cette méthode est-elle adaptée pour retarder la première naissance ?"
	note q529: "Selon vous, cette méthode est-elle adaptée pour retarder la première naissance ?"
	label define q529 1 "Oui" 2 "Non" 98 "Ne sais pas"
	label values q529 q529

	label variable q530 "Selon vous, cette méthode est-elle adaptée au maintien de l’intervalle entre deu"
	note q530: "Selon vous, cette méthode est-elle adaptée au maintien de l’intervalle entre deux naissances ?"
	label define q530 1 "Oui" 2 "Non" 98 "Ne sais pas"
	label values q530 q530

	label variable q531 "Selon vous, cette méthode est-elle adaptée pour la limitation des naissances ?"
	note q531: "Selon vous, cette méthode est-elle adaptée pour la limitation des naissances ?"
	label define q531 1 "Oui" 2 "Non" 98 "Ne sais pas"
	label values q531 q531

	label variable q532 "Supposons qu’une femme souhaite utiliser un produit injectable. Selon vous, quan"
	note q532: "Supposons qu’une femme souhaite utiliser un produit injectable. Selon vous, quand doit-elle prendre sa première dose de produit injectable ?"

	label variable q532_other "Autre (Préciser)"
	note q532_other: "Autre (Préciser)"

	label variable q533 "Selon vous, quels sont les bénéfices d’utiliser des contraceptifs injectables ou"
	note q533: "Selon vous, quels sont les bénéfices d’utiliser des contraceptifs injectables ou pourquoi une femme devrait utiliser cette méthode ?"

	label variable q533_other "Autre (Préciser)"
	note q533_other: "Autre (Préciser)"

	label variable q534 "Quels sont les problemès auxquels un client peut faire face après qu’on lui ait "
	note q534: "Quels sont les problemès auxquels un client peut faire face après qu’on lui ait administré un injectable ?"

	label variable q534_other "Autre (Préciser)"
	note q534_other: "Autre (Préciser)"

	label variable q535 "Selon vous, cette méthode est-elle adaptée pour retarder la première naissance ?"
	note q535: "Selon vous, cette méthode est-elle adaptée pour retarder la première naissance ?"
	label define q535 1 "Oui" 2 "Non" 98 "Ne sais pas"
	label values q535 q535

	label variable q536 "Selon vous, cette méthode est-elle adaptée au maintien de l’intervalle entre deu"
	note q536: "Selon vous, cette méthode est-elle adaptée au maintien de l’intervalle entre deux naissances ?"
	label define q536 1 "Oui" 2 "Non" 98 "Ne sais pas"
	label values q536 q536

	label variable q537 "Selon vous, cette méthode est-elle adaptée pour la limitation des naissances ?"
	note q537: "Selon vous, cette méthode est-elle adaptée pour la limitation des naissances ?"
	label define q537 1 "Oui" 2 "Non" 98 "Ne sais pas"
	label values q537 q537

	label variable q538 "Après la première prise de contraceptif injectable, quand la dose suivante doit-"
	note q538: "Après la première prise de contraceptif injectable, quand la dose suivante doit-elle être administrée ?"

	label variable q539 "Selon vous, quels sont les bénéfices d’utiliser des implants ou pourquoi une fem"
	note q539: "Selon vous, quels sont les bénéfices d’utiliser des implants ou pourquoi une femme devrait utiliser cette méthode ?"

	label variable q539_other "Autre (Préciser)"
	note q539_other: "Autre (Préciser)"

	label variable q540 "Quels sont les problémes auxquels un client peut faire face après qu’on lui ait "
	note q540: "Quels sont les problémes auxquels un client peut faire face après qu’on lui ait inséré un implant ?"

	label variable q540_other "Autre (Préciser)"
	note q540_other: "Autre (Préciser)"

	label variable q541 "Quelle est la durée de la période d’efficacité des implants dans la prévention d"
	note q541: "Quelle est la durée de la période d’efficacité des implants dans la prévention de la grossesse ?"
	label define q541 1 "3-5 ans" 96 "Autres réponses" 98 "Ne sais pas"
	label values q541 q541

	label variable q541_other "Autre (Préciser)"
	note q541_other: "Autre (Préciser)"

	label variable q542 "Savez-vous où les implants doivent être insérés ?"
	note q542: "Savez-vous où les implants doivent être insérés ?"
	label define q542 1 "Partie supérieure du bras" 96 "Autres réponses" 98 "Ne sais pas"
	label values q542 q542

	label variable q542_other "Autre (Préciser)"
	note q542_other: "Autre (Préciser)"

	label variable q543 "Selon vous, qui peut effectuer la pose d’implants ?"
	note q543: "Selon vous, qui peut effectuer la pose d’implants ?"

	label variable q543_other "Autre (Préciser)"
	note q543_other: "Autre (Préciser)"

	label variable q544 "Selon vous, cette méthode est-elle adaptée pour retarder la première naissance ?"
	note q544: "Selon vous, cette méthode est-elle adaptée pour retarder la première naissance ?"
	label define q544 1 "Oui" 2 "Non" 98 "Ne sais pas"
	label values q544 q544

	label variable q545 "Selon vous, cette méthode est-elle adaptée au maintien de l’intervalle entre deu"
	note q545: "Selon vous, cette méthode est-elle adaptée au maintien de l’intervalle entre deux naissances ?"
	label define q545 1 "Oui" 2 "Non" 98 "Ne sais pas"
	label values q545 q545

	label variable q546 "Selon vous, cette méthode est-elle adaptée pour la limitation des naissances ?"
	note q546: "Selon vous, cette méthode est-elle adaptée pour la limitation des naissances ?"
	label define q546 1 "Oui" 2 "Non" 98 "Ne sais pas"
	label values q546 q546

	label variable q547 "Savez-vous que la contraception d’urgence peut être prise peu de temps après un "
	note q547: "Savez-vous que la contraception d’urgence peut être prise peu de temps après un rapport sexuel non protégé ?"
	label define q547 1 "Oui" 2 "Non"
	label values q547 q547

	label variable q548 "Quel est le nombre d’heures maximal après un rapport sexuel non protégé, pour qu"
	note q548: "Quel est le nombre d’heures maximal après un rapport sexuel non protégé, pour qu’une contraceptiond’urgence (CU) puisse être prise ?"

	label variable q549 "Pensez-vous qu’une CU peut avoir été efficace bien que la femme soit tombée ence"
	note q549: "Pensez-vous qu’une CU peut avoir été efficace bien que la femme soit tombée enceinte ?"
	label define q549 1 "Oui" 2 "Non"
	label values q549 q549

	label variable q550 "Pensez-vous que la CU peut être utilisée comme une méthode de contraception régu"
	note q550: "Pensez-vous que la CU peut être utilisée comme une méthode de contraception régulière ?"
	label define q550 1 "Oui" 2 "Non"
	label values q550 q550

	label variable q551 "Selon vous, cette méthode est-elle adaptée pour retarder la première naissance ?"
	note q551: "Selon vous, cette méthode est-elle adaptée pour retarder la première naissance ?"
	label define q551 1 "Oui" 2 "Non" 98 "Ne sais pas"
	label values q551 q551

	label variable q552 "Selon vous, cette méthode est-elle adaptée au maintien de l’intervalle entre deu"
	note q552: "Selon vous, cette méthode est-elle adaptée au maintien de l’intervalle entre deux naissances ?"
	label define q552 1 "Oui" 2 "Non" 98 "Ne sais pas"
	label values q552 q552

	label variable q553 "Selon vous, cette méthode est-elle adaptée pour la limitation des naissances ?"
	note q553: "Selon vous, cette méthode est-elle adaptée pour la limitation des naissances ?"
	label define q553 1 "Oui" 2 "Non" 98 "Ne sais pas"
	label values q553 q553

	label variable q554 "Selon vous, quels sont les bénéfices d’adopter la sterilisation féminine ou pour"
	note q554: "Selon vous, quels sont les bénéfices d’adopter la sterilisation féminine ou pourquoi une femme devrait utiliser cette méthode ?"

	label variable q554_other "Autre (Préciser)"
	note q554_other: "Autre (Préciser)"

	label variable q555 "Quels sont les problèmes auxquels un client peut faire face pendant ou après une"
	note q555: "Quels sont les problèmes auxquels un client peut faire face pendant ou après une sterilisation feminine, y compris la procedure post-partum / post avortement"

	label variable q555_other "Autre (Préciser)"
	note q555_other: "Autre (Préciser)"

	label variable q556 "Selon vous, cette méthode est-t-elle adaptée pour la limitation des naissances ?"
	note q556: "Selon vous, cette méthode est-t-elle adaptée pour la limitation des naissances ?"
	label define q556 1 "Oui" 2 "Non" 98 "Ne sais pas"
	label values q556 q556

	label variable q557 "Selon vous, quels sont les bénéfices d’adopter la sterilisation masculine ou pou"
	note q557: "Selon vous, quels sont les bénéfices d’adopter la sterilisation masculine ou pourquoi un homme devrait utiliser cette méthode ?"

	label variable q557_other "Autre (Préciser)"
	note q557_other: "Autre (Préciser)"

	label variable q558 "Quels sont les problèmes auxquels un client peut faire face pendant ou après une"
	note q558: "Quels sont les problèmes auxquels un client peut faire face pendant ou après une stérilisation masculine"

	label variable q558_other "Autre (Préciser)"
	note q558_other: "Autre (Préciser)"

	label variable q559 "Selon vous, cette méthode est-t-elle adaptée pour la limitation des naissances ?"
	note q559: "Selon vous, cette méthode est-t-elle adaptée pour la limitation des naissances ?"
	label define q559 1 "Oui" 2 "Non" 98 "Ne sais pas"
	label values q559 q559

	label variable q560 "Selon vous, pourquoi est-il important pour les femmes et les couples d’utiliser "
	note q560: "Selon vous, pourquoi est-il important pour les femmes et les couples d’utiliser des méthodes de contraception ?"

	label variable q560_other "Autre (Préciser)"
	note q560_other: "Autre (Préciser)"

	label variable q561a "Il est important de parler des méthodes de contraception, quel que soit le sexe."
	note q561a: "Il est important de parler des méthodes de contraception, quel que soit le sexe."
	label define q561a 1 "Pas du tout d’accord" 2 "Pas d’accord" 3 "Neutre" 4 "D’accord" 5 "Tout à fait d’accord"
	label values q561a q561a

	label variable q561b "Les informations sur la planification familiale ne devraient être données qu’aux"
	note q561b: "Les informations sur la planification familiale ne devraient être données qu’aux personnes qui en font explicitement la demande."
	label define q561b 1 "Pas du tout d’accord" 2 "Pas d’accord" 3 "Neutre" 4 "D’accord" 5 "Tout à fait d’accord"
	label values q561b q561b

	label variable q561c "Des conseils en matière de PF devraient être fournis aux garçons et aux filles n"
	note q561c: "Des conseils en matière de PF devraient être fournis aux garçons et aux filles non mariées."
	label define q561c 1 "Pas du tout d’accord" 2 "Pas d’accord" 3 "Neutre" 4 "D’accord" 5 "Tout à fait d’accord"
	label values q561c q561c

	label variable q561d "L’utilisation de méthodes contraceptives est importante pour les femmes / hommes"
	note q561d: "L’utilisation de méthodes contraceptives est importante pour les femmes / hommes en âge de procréer."
	label define q561d 1 "Pas du tout d’accord" 2 "Pas d’accord" 3 "Neutre" 4 "D’accord" 5 "Tout à fait d’accord"
	label values q561d q561d

	label variable q561e "Les connaissances en matière de planification familiale augmenteront les relatio"
	note q561e: "Les connaissances en matière de planification familiale augmenteront les relations sexuelles pré-maritales."
	label define q561e 1 "Pas du tout d’accord" 2 "Pas d’accord" 3 "Neutre" 4 "D’accord" 5 "Tout à fait d’accord"
	label values q561e q561e

	label variable q561f "Les contraceptifs affectent le désir sexuel du partenaire."
	note q561f: "Les contraceptifs affectent le désir sexuel du partenaire."
	label define q561f 1 "Pas du tout d’accord" 2 "Pas d’accord" 3 "Neutre" 4 "D’accord" 5 "Tout à fait d’accord"
	label values q561f q561f

	label variable q561g "Les méthodes contraceptives ont un impact négatif sur la pratique de la religion"
	note q561g: "Les méthodes contraceptives ont un impact négatif sur la pratique de la religion."
	label define q561g 1 "Pas du tout d’accord" 2 "Pas d’accord" 3 "Neutre" 4 "D’accord" 5 "Tout à fait d’accord"
	label values q561g q561g

	label variable q561h "Les contraceptifs affectent les activités quotidiennes des femmes."
	note q561h: "Les contraceptifs affectent les activités quotidiennes des femmes."
	label define q561h 1 "Pas du tout d’accord" 2 "Pas d’accord" 3 "Neutre" 4 "D’accord" 5 "Tout à fait d’accord"
	label values q561h q561h

	label variable q561i "L’éducation à la planification familiale devrait être incluse dans le programme "
	note q561i: "L’éducation à la planification familiale devrait être incluse dans le programme des établissements d’enseignement."
	label define q561i 1 "Pas du tout d’accord" 2 "Pas d’accord" 3 "Neutre" 4 "D’accord" 5 "Tout à fait d’accord"
	label values q561i q561i

	label variable q562 "Si une femme / un homme / un couple vient dans votre pharmacie / pour des servic"
	note q562: "Si une femme / un homme / un couple vient dans votre pharmacie / pour des services de PF, les informez-vous de toutes les méthodes appropriées disponibles dans le panier de leur choix ?"
	label define q562 1 "Oui" 2 "Non"
	label values q562 q562

	label variable q563 "Selon vous, qui devrait être conseillé en matière de planification familiale ?"
	note q563: "Selon vous, qui devrait être conseillé en matière de planification familiale ?"

	label variable q563_other "Autre (Préciser)"
	note q563_other: "Autre (Préciser)"

	label variable q564 "Avant de vendre les pilules / CU, quel conseil donnez-vous généralement au clien"
	note q564: "Avant de vendre les pilules / CU, quel conseil donnez-vous généralement au client ?"

	label variable q564_other "Autre (Préciser)"
	note q564_other: "Autre (Préciser)"

	label variable q565 "Avant de vendre les injectables / implants, quels conseils donnez-vous généralem"
	note q565: "Avant de vendre les injectables / implants, quels conseils donnez-vous généralement au client ?"

	label variable q565_other "Autre (Préciser)"
	note q565_other: "Autre (Préciser)"

	label variable q566 "Conseillez-vous les clients sur les effets secondaires associés aux contraceptif"
	note q566: "Conseillez-vous les clients sur les effets secondaires associés aux contraceptifs ?"
	label define q566 1 "Oui" 2 "Non"
	label values q566 q566

	label variable q567 "Quels sont les obstacles auxquels vous êtes confronté(e) lorsque vous fournissez"
	note q567: "Quels sont les obstacles auxquels vous êtes confronté(e) lorsque vous fournissez des services de conseil en matière de planification familiale ?"

	label variable q567_other "Autre (Préciser)"
	note q567_other: "Autre (Préciser)"

	label variable q568 "Indiquez-vous à la cliente où se rendre en cas de complications après l'utilisat"
	note q568: "Indiquez-vous à la cliente où se rendre en cas de complications après l'utilisation des contraceptifs ?"
	label define q568 1 "Oui" 2 "Non"
	label values q568 q568

	label variable q569 "Où leur conseillez-vous de se rendre s'ils présentent des complications après av"
	note q569: "Où leur conseillez-vous de se rendre s'ils présentent des complications après avoir consommé des pilules / CU ?"

	label variable q569_other "Autre (Préciser)"
	note q569_other: "Autre (Préciser)"

	label variable q570 "Où leur conseillez-vous de se rendre en cas de complications après l'administrat"
	note q570: "Où leur conseillez-vous de se rendre en cas de complications après l'administration d'un proDIUt injectable ou d'un implant ?"

	label variable q570_other "Autre (Préciser)"
	note q570_other: "Autre (Préciser)"

	label variable locationlatitude "Coordonnées GPS de la pharmacie (latitude)"
	note locationlatitude: "Coordonnées GPS de la pharmacie (latitude)"

	label variable locationlongitude "Coordonnées GPS de la pharmacie (longitude)"
	note locationlongitude: "Coordonnées GPS de la pharmacie (longitude)"

	label variable locationaltitude "Coordonnées GPS de la pharmacie (altitude)"
	note locationaltitude: "Coordonnées GPS de la pharmacie (altitude)"

	label variable locationaccuracy "Coordonnées GPS de la pharmacie (accuracy)"
	note locationaccuracy: "Coordonnées GPS de la pharmacie (accuracy)"






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
*   Corrections file path and filename:  C:/Users/pkaberia/Dropbox//FP-Project-APHRC-UM/Atelier_FP/Codes//QUESTIONNAIRE PHARMACIE_corrections.csv
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
