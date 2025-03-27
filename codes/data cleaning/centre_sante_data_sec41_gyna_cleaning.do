use "F:/Dropbox_APHRC/Dropbox/FP-Project-APHRC-UM/Atelier_FP/Data/raw/centre_sante_section41_personnel1_raw.dta",clear

*** cleaning
cd "F:\Dropbox_APHRC\Dropbox\FP-Project-APHRC-UM\Atelier_FP\Data\clean"

destring _all,replace
compress

lab def yesno 0 Non 1 Oui,modify

drop if codeb_produitf==.&produitb_labelg==""
drop key setofpersonnel numerob_produitf  produitb_labelg

ren codeb_produitf s4_1

lab def colonne 2 "Gynécologue" 9 "Sage-femmes"11 "Aide infirmier" 3 "anesthésiste" 4	"médecin généraliste" 8 "infirmier/infirmière" 5 "DES" 1 "Chirurgien (chirurgien général)" 6 "pédiatre" 7	"pharmacien" 10 "ASC",modify

lab val s4_1 colonne


ren s4_1_3_0 s4_2
ren s4_1_3_1 s4_3

ren s4_1_4a s4_4a
ren s4_1_4b s4_4b

ren s4_1_6a s4_5b
ren s4_1_6b s4_5a 

gen s4_5=(inlist(s4_5a,0,99,.)&inlist(s4_5b,0,99,.))
recode s4_5 0=1 1=0

la var s4_5 "Formations complémentaires sur le PF? (en majorité)"
lab val s4_5 yesno


ren s4_1_7a s4_6b 
ren s4_1_7b s4_6a 


ren s4_1_8_a s4_7a
ren s4_1_8_b s4_7b
ren s4_1_8_c s4_7c
ren s4_1_8_d s4_7d
ren s4_1_8_e s4_7e
ren s4_1_8_f s4_7f
ren s4_1_8_g s4_7g
ren s4_1_8_h s4_7h
ren s4_1_8_i s4_7i
ren s4_1_8_j s4_7j
ren s4_1_8_k s4_7k

drop s4_1_8

lab val s4_7* yesno

replace s4_7a=-9 if inlist(s4_6a,0,99,.)&inlist(s4_6b,0,99,.)
replace s4_7b=-9 if inlist(s4_6a,0,99,.)&inlist(s4_6b,0,99,.)
replace s4_7c=-9 if inlist(s4_6a,0,99,.)&inlist(s4_6b,0,99,.)
replace s4_7d=-9 if inlist(s4_6a,0,99,.)&inlist(s4_6b,0,99,.)
replace s4_7e=-9 if inlist(s4_6a,0,99,.)&inlist(s4_6b,0,99,.)
replace s4_7f=-9 if inlist(s4_6a,0,99,.)&inlist(s4_6b,0,99,.)
replace s4_7g=-9 if inlist(s4_6a,0,99,.)&inlist(s4_6b,0,99,.)
replace s4_7h=-9 if inlist(s4_6a,0,99,.)&inlist(s4_6b,0,99,.)
replace s4_7i=-9 if inlist(s4_6a,0,99,.)&inlist(s4_6b,0,99,.)
replace s4_7j=-9 if inlist(s4_6a,0,99,.)&inlist(s4_6b,0,99,.)
replace s4_7k=-9 if inlist(s4_6a,0,99,.)&inlist(s4_6b,0,99,.)

lab var s4_7a "Services de PF que propose: Pilules"
lab var s4_7b "Services de PF que propose: Injectables"
lab var s4_7c "Services de PF que propose: Préservatif masculin"
lab var s4_7d "Services de PF que propose: Préservatif féminin"
lab var s4_7e "Services de PF que propose: Contraception d'urgence"
lab var s4_7f "Services de PF que propose: DIU"
lab var s4_7g "Services de PF que propose: Implants"
lab var s4_7h "Services de PF que propose: Stérilisation féminine (Ligature des trompes)"
lab var s4_7i "Services de PF que propose: Stérilisation masculine/ Vasectomie"
lab var s4_7j "Services de PF que propose: Allaitement maternel exclusif (MAMA)"  
lab var s4_7k "Services de PF que propose: Méthode des jours fixes (MJF)"

ren s4_1_9a s4_8a
ren s4_1_9b s4_8b

ren s4_1_10a s4_9a
ren s4_1_10b s4_9b

drop s4_1_11 

ren s4_1_11_a s4_10a
ren s4_1_11_b s4_10b
ren s4_1_11_c s4_10c
ren s4_1_11_d s4_10d
ren s4_1_11_e s4_10e
ren s4_1_11_f s4_10f
ren s4_1_11_g s4_10g

lab val s4_10* yesno

lab var s4_10a "Services de SMNI: CPN"
lab var s4_10b "Services de SMNI: accouchement normal"
lab var s4_10c "Services de SMNI: césarienne"
lab var s4_10d "Services de SMNI: gestion des complications maternelles"
lab var s4_10e "Services de SMNI: gestion des complications néonatales"
lab var s4_10f "Services de SMNI: vaccination"
lab var s4_10g "Services de SMNI: traitement des maladies infantiles"

ren s4_1_11_2 s4_11b
ren s4_1_11_3 s4_11a

drop s4_1_12

ren s4_1_12_1 s4_12a
ren s4_1_12_2 s4_12b
ren s4_1_12_3 s4_12c
ren s4_1_12_4 s4_12d
ren s4_1_12_5 s4_12e
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


ren s4_1_13 s4_13
replace s4_13=-9 if inlist(s4_3,0,9999)

gen s4_0="facility"

aorder

drop if inlist(s4_2,0,99,9999)

replace s4_4a=-5 if inlist(s4_4a,.,99)
replace s4_4b=-5 if inlist(s4_4b,.,99)
replace s4_5b=-9 if inlist(s4_5,0)
replace s4_6b=-9 if inlist(s4_5,0) // 11 records need to be reviewed



replace s4_8a=-5 if inlist(s4_8a,.,99) //no skip
replace s4_9a=-5 if inlist(s4_9a,.,99) //no skip

replace s4_10a=-9 if inlist(s4_10a,.,99)
replace s4_10b=-9 if inlist(s4_10b,.,99)
replace s4_10c=-9 if inlist(s4_10c,.,99)
replace s4_10d=-9 if inlist(s4_10d,.,99)
replace s4_10e=-9 if inlist(s4_10e,.,99)
replace s4_10f=-9 if inlist(s4_10f,.,99)
replace s4_10g=-9 if inlist(s4_10g,.,99)
replace s4_11b=-9 if inlist(s4_11b,.,99)
	
							


drop s4_5a s4_6a s4_8b s4_9b s4_11b

ren parent_key id
lab var s4_0 department
lab var s4_1 profile
lab var id "structure id"
sort id
save "F:\Dropbox_APHRC\Dropbox\FP-Project-APHRC-UM\Atelier_FP\Data\clean\cs_hr_all",replace
