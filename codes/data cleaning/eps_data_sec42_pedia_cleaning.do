
use "F:/Dropbox_APHRC/Dropbox/FP-Project-APHRC-UM/Atelier_FP/Data/raw/eps_section42_personnel2_raw.dta",clear

*** cleaning
cd "F:\Dropbox_APHRC\Dropbox\FP-Project-APHRC-UM\Atelier_FP\Data\clean"

destring _all,replace
compress

lab def yesno 0 Non 1 Oui,modify

drop if codeb_produitf_2==.&produitb_labelg_2==""
drop key setofpersonnel_2 numerob_produitf_2  produitb_labelg_2

ren codeb_produitf_2 s4_1

lab def colonne 2 "Gynécologue" 9 "Sage-femmes"11 "Aide infirmier" 3 "anesthésiste" 4	"médecin généraliste" 8 "infirmier/infirmière" 5 "DES" 1 "Chirurgien (chirurgien général)" 6 "pédiatre" 7	"pharmacien" 10 "ASC",modify

lab val s4_1 colonne


ren s4_1_3_0b s4_2
ren s4_1_3_2 s4_3

ren s4_1_4a_2 s4_4a
ren s4_1_4b_2 s4_4b

ren s4_1_9a_2 s4_9a
ren s4_1_9b_2 s4_9b

ren s4_1_10a_2 s4_10a
ren s4_1_10b_2 s4_10b

drop s4_1_11_2 

ren s4_1_11_2_a s4_11a
ren s4_1_11_2_b s4_11b
ren s4_1_11_2_c s4_11c
ren s4_1_11_2_d s4_11d
ren s4_1_11_2_e s4_11e
ren s4_1_11_2_f s4_11f
ren s4_1_11_2_g s4_11g

lab val s4_11* yesno

lab var s4_11a "Services de SMNI: CPN"
lab var s4_11b "Services de SMNI: accouchement normal"
lab var s4_11c "Services de SMNI: césarienne"
lab var s4_11d "Services de SMNI: gestion des complications maternelles"
lab var s4_11e "Services de SMNI: gestion des complications néonatales"
lab var s4_11f "Services de SMNI: vaccination"
lab var s4_11g "Services de SMNI: traitement des maladies infantiles"

drop s4_1_12_2 

ren s4_1_12_2_1 s4_12a
ren s4_1_12_2_2 s4_12b
ren s4_1_12_2_3 s4_12c
ren s4_1_12_2_4 s4_12d
ren s4_1_12_2_5 s4_12e
ren s4_1_12au   s4_12eau



lab var s4_12a "Pourquoi les vacants: Non recruté/nommé"
lab var s4_12b "Pourquoi les vacants: En détachement dans une autre sanitaire de santé"
lab var s4_12c "Pourquoi les vacants: En congé/poursuivant des études supérieures ou une formation pendant plus de 6 mois"
lab var s4_12d "Pourquoi les vacants: Absent du travail"
lab var s4_12e "Pourquoi les vacants: Autre"

replace s4_12a=-9 if inlist(s4_3,0,9999)
replace s4_12b=-9 if inlist(s4_3,0,9999)
replace s4_12c=-9 if inlist(s4_3,0,9999)
replace s4_12d=-9 if inlist(s4_3,0,9999)
replace s4_12e=-9 if inlist(s4_3,0,9999)


ren s4_1_13_2 s4_13
replace s4_13=-9 if inlist(s4_3,0,9999)

gen s4_0="Pediatrie department"

aorder

drop if inlist(s4_2,0,99,9999)

replace s4_4a=-5 if inlist(s4_4a,.,99)
replace s4_4b=-5 if inlist(s4_4b,.,99)



replace s4_9a=-5 if inlist(s4_9a,.,99) //no skip
replace s4_9b=-5 if inlist(s4_9b,.,99) //no skip

replace s4_10a=-5 if inlist(s4_10a,.,99) //no skip
replace s4_10b=-5 if inlist(s4_10b,.,99) //no skip

replace s4_11a=-9 if inlist(s4_11a,.,99)
replace s4_11b=-9 if inlist(s4_11b,.,99)
replace s4_11c=-9 if inlist(s4_11c,.,99)
replace s4_11d=-9 if inlist(s4_11d,.,99)
replace s4_11e=-9 if inlist(s4_11e,.,99)
replace s4_11f=-9 if inlist(s4_11f,.,99)
replace s4_11g=-9 if inlist(s4_11g,.,99)
replace s4_12b=-9 if inlist(s4_12b,.,99)
	
							
ren parent_key id
lab var s4_0 department
lab var s4_1 profile
lab var id "structure id"
save "F:\Dropbox_APHRC\Dropbox\FP-Project-APHRC-UM\Atelier_FP\Data\clean\eps_hr_padiatrie",replace


