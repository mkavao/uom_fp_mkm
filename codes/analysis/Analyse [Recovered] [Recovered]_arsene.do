clear

use "C:\Users\asandie\Desktop\structure_dm\Clean_data\EPS\eps_data_clean_combined.dta"

append using "C:\Users\asandie\Desktop\structure_dm\Clean_data\Centre de santé\centre_data_clean_combined.dta", force


append using "C:\Users\asandie\Desktop\structure_dm\Clean_data\Poste de santé\poste_data_clean_combined.dta", force //s5_10_autrea


append using "C:\Users\asandie\Desktop\structure_dm\Clean_data\Case de santé\case_data_clean_combined.dta", force 


append using "C:\Users\asandie\Desktop\structure_dm\Clean_data\Clinique\clinique_clean_combined.dta", force 

bysort parent_key :gen id=_n

tab s1_7 if id == 1


************* Infrastructures généraux **************


tabout s3_1a s3_1b s3_1c s3_1d s3_1e s3_1f s3_1g s3_1h s3_1i s3_1j s3_1k s3_1l s3_1m s3_1n s1_7 if id == 1 using "table_dhs.xls", append c(col) npos(both) nlab(Number) 


************* Fourniture des services de PF **************

gen pillule_fourni = .
replace pillule_fourni = 1 if s5_7a == 1 | s5_7a == 2 | s5_7a == 3 | s5_7a == 4
replace pillule_fourni = 0 if s5_7a == 5


gen injectable_fourni = .
replace injectable_fourni = 1 if s5_7b == 1 | s5_7b == 2 | s5_7b == 3 | s5_7b == 4
replace injectable_fourni = 0 if s5_7b == 5

gen condom_male_fourni = .
replace condom_male_fourni = 1 if s5_7c == 1 | s5_7c == 2 | s5_7c == 3 | s5_7c == 4
replace condom_male_fourni = 0 if s5_7c == 5

gen condom_female_fourni = .
replace condom_female_fourni = 1 if s5_7d == 1 | s5_7d == 2 | s5_7d == 3 | s5_7d == 4
replace condom_female_fourni = 0 if s5_7d == 5

gen pcu_fourni = .
replace pcu_fourni = 1 if s5_7e == 1 | s5_7e == 2 | s5_7e == 3 | s5_7e == 4
replace pcu_fourni = 0 if s5_7e == 5


gen dui_fourni = .
replace dui_fourni = 1 if s5_7f == 1 | s5_7f == 2 | s5_7f == 3 | s5_7f == 4
replace dui_fourni = 0 if s5_7f == 5


gen implant_fourni = .
replace implant_fourni = 1 if s5_7g == 1 | s5_7g == 2 | s5_7g == 3 | s5_7g == 4
replace implant_fourni = 0 if s5_7g == 5

gen sterilisation_f_fourni = .
replace sterilisation_f_fourni = 1 if s5_7h == 1 | s5_7h == 2 | s5_7h == 3 | s5_7h == 4
replace sterilisation_f_fourni = 0 if s5_7h == 5

gen sterilisation_m_fourni = .
replace sterilisation_m_fourni = 1 if s5_7i == 1 | s5_7i == 2 | s5_7i == 3 | s5_7i == 4
replace sterilisation_m_fourni = 0 if s5_7i == 5

gen mama_fourni = .
replace mama_fourni = 1 if s5_7j == 1 | s5_7j == 2 | s5_7j == 3 | s5_7j == 4
replace mama_fourni = 0 if s5_7j == 5


gen mjf_fourni = .
replace mjf_fourni = 1 if s5_7k == 1 | s5_7k == 2 | s5_7k == 3 | s5_7k == 4
replace mjf_fourni = 0 if s5_7k == 5


label val injectable_fourni injectable_fourni condom_male_fourni condom_female_fourni pcu_fourni dui_fourni implant_fourni sterilisation_f_fourni sterilisation_m_fourni mama_fourni mjf_fourni yesno

tabout pillule_fourni injectable_fourni condom_male_fourni condom_female_fourni pcu_fourni dui_fourni implant_fourni sterilisation_f_fourni sterilisation_m_fourni mama_fourni mjf_fourni s1_7 if id == 1 using "table_fourniture.xls", append c(col) npos(both) nlab(Number) 

*Short-acting methods include pills, injectables, or the emergency contraceptive pill
*Long-acting and permanent methods include implants or IUDs

egen short_acting = rowtotal(pillule_fourni injectable_fourni pcu_fourni)

egen long_acting = rowtotal(implant_fourni dui_fourni sterilisation_f_fourni sterilisation_m_fourni)

gen short_acting_3 = .
replace short_acting_3 = 1 if short_acting == 3
replace short_acting_3 = 0 if short_acting != 3 & s5_6 ==1
label val  short_acting_3 yesno

gen long_acting_1 = .
replace long_acting_1 = 1 if long_acting  >= 1
replace long_acting_1 = 0 if long_acting == 0 & s5_6 ==1 
label values long_acting_1 yesno

tabout short_acting_3 long_acting_1 s1_7 if id == 1 using "table_fourniture.xls", append c(col) npos(both) nlab(Number) 




********************* Cascade availability **************************
/*Pilules=A, Injectables= B, Préservatif masculin =C, Préservatif féminin= D, Contraception d'urgence=E, DIU= F, Implants=G, Stérilisation féminine (Ligature des trompes)H, Stérilisation masculine/ Vasectomie= J, Allaitement maternel exclusif (MAMA)= K, Méthode des jours fixes (MJF)= L */

********************* DUI 

gen dui_daily = 0
replace dui_daily = 1  if s5_7f == 1 
replace dui_daily = .  if s5_6 == 2
label values dui_daily yesno


gen dui_daily_trained = 0
replace dui_daily_trained = 1 if (dui_daily == 1) & (( s4_1_5a_1!=0 & s4_1_5a_1!= 99& s4_1_5a_1!= 999)|( s4_1_5b_1!=0 & s4_1_5b_1!= 99& s4_1_5b_1!= 999))
replace dui_daily_trained = .  if s5_6 == 2
label values dui_daily_trained yesno


gen dui_daily_trained_stock = 0
replace dui_daily_trained_stock  = 1 if dui_daily_trained == 1 &  s6_16i == 1
replace dui_daily_trained_stock = . if s5_6 == 2
label values dui_daily_trained_stock yesno

 
gen dui_daily_trained_stock_items = 0
replace dui_daily_trained_stock_items = 1 if ((s6_3trav_a==1 & s6_3trav_b==1 &  s6_3trav_c==1 &  s6_3trav_d ==1 & s6_3trav_e==1 &  s6_3trav_f==1 &  s6_3trav_g==1 &  s6_3trav_h==1 &  s6_3trav_i ==1 & s6_3trav_j ==1 & s6_3trav_k==1 &  s6_3trav_l==1 &  s6_3trav_m==1 &  s6_3trav_n==1)|(s6_3coin_a ==1 &  s6_3coin_b ==1 & s6_3coin_c==1 &  s6_3coin_d==1 &  s6_3coin_e==1 &  s6_3coin_f ==1 & s6_3coin_g ==1 & s6_3coin_h==1 &  s6_3coin_i==1 &  s6_3coin_j ==1 & s6_3coin_k==1 &  s6_3coin_l ==1 & s6_3coin_m ==1 & s6_3coin_n==1)|(s6_3both_a ==1 & s6_3both_b ==1 & s6_3both_c==1 &  s6_3both_d==1 &  s6_3both_e==1 &  s6_3both_f==1 &  s6_3both_g ==1 & s6_3both_h ==1 & s6_3both_i==1 &  s6_3both_j ==1 & s6_3both_k==1 &  s6_3both_l==1 &  s6_3both_m==1 &  s6_3both_n==1)|(s6_3other_a==1 &  s6_3other_b==1 &  s6_3other_c==1 &  s6_3other_d==1 &  s6_3other_e==1 &  s6_3other_f==1 &  s6_3other_g==1 &  s6_3other_h==1 &  s6_3other_i ==1 & s6_3other_j==1 &  s6_3other_k==1 &  s6_3other_l==1 &  s6_3other_m==1 &  s6_3other_n==1)) & dui_daily_trained_stock == 1

replace dui_daily_trained_stock_items = . if s5_6 == 2

label values dui_daily_trained_stock_items yesno


gen dui_daily_trained_stock_items_p = 0
replace dui_daily_trained_stock_items_p = 1 if (dui_daily_trained_stock_items == 1)&((strpos(produitb_labell_1, "DIU")&(s8_3_1!=0)&(s8_3_1!=998)&(s8_3_1!=999)&(s8_3_1!=9998)&(s8_3_1!=.)&(s8_3_1!=9998)&(s8_3_1!=.))|(strpos(produitb_labell_2, "DIU")&(s8_3_2!=0)&(s8_3_2!=998)&(s8_3_2!=999)&(s8_3_2!=9998)&(s8_3_2!=.)&(s8_3_2!=9998)&(s8_3_2!=.))|(strpos(produitb_labell_3, "DIU")&(s8_3_3!=0)&(s8_3_3!=998)&(s8_3_3!=999)&(s8_3_3!=9998)&(s8_3_3!=.)&(s8_3_3!=9998)&(s8_3_3!=.))|(strpos(produitb_labell_4, "DIU")&(s8_3_4!=0)&(s8_3_4!=998)&(s8_3_4!=999)&(s8_3_4!=9998)&(s8_3_4!=.)&(s8_3_4!=9998)&(s8_3_4!=.))|(strpos(produitb_labell_5, "DIU")&(s8_3_5!=0)&(s8_3_5!=998)&(s8_3_5!=999)&(s8_3_5!=9998)&(s8_3_5!=.)&(s8_3_5!=9998)&(s8_3_5!=.))|(strpos(produitb_labell_6, "DIU")&(s8_3_6!=0)&(s8_3_6!=998)&(s8_3_6!=999)&(s8_3_6!=9998)&(s8_3_6!=.)&(s8_3_6!=9998)&(s8_3_6!=.))|(strpos(produitb_labell_7, "DIU")&(s8_3_7!=0)&(s8_3_7!=998)&(s8_3_7!=999)&(s8_3_7!=9998)&(s8_3_7!=.)&(s8_3_7!=9998)&(s8_3_7!=.))|(strpos(produitb_labell_8, "DIU")&(s8_3_8!=0)&(s8_3_8!=998)&(s8_3_8!=999)&(s8_3_8!=9998)&(s8_3_8!=.)&(s8_3_8!=9998)&(s8_3_8!=.))|(strpos(produitb_labell_9, "DIU")&(s8_3_9!=0)&(s8_3_9!=998)&(s8_3_9!=999)&(s8_3_9!=9998)&(s8_3_9!=.)&(s8_3_9!=9998)&(s8_3_9!=.))|(strpos(produitb_labell_10, "DIU")&(s8_3_10!=0)&(s8_3_10!=998)&(s8_3_10!=999)&(s8_3_10!=9998)&(s8_3_10!=.)&(s8_3_10!=9998)&(s8_3_10!=.))|(strpos(produitb_labell_11, "DIU")&(s8_3_11!=0)&(s8_3_11!=998)&(s8_3_11!=999)&(s8_3_11!=9998)&(s8_3_11!=.)&(s8_3_11!=9998)&(s8_3_11!=.)))
replace dui_daily_trained_stock_items_p = . if s5_6 == 2

label values dui_daily_trained_stock_items_p yesno

tabout dui_fourni dui_daily dui_daily_trained dui_daily_trained_stock  dui_daily_trained_stock_items dui_daily_trained_stock_items_p s1_7 if id == 1 using "table_cascade.xls", append c(col) npos(both) nlab(Number) 



********************* Injectables


gen inject_daily = 0
replace inject_daily = 1 if s5_7b == 1 
replace inject_daily = . if s5_6 == 2
label values inject_daily yesno



gen inject_daily_stock = 0
replace inject_daily_stock  = 1 if (inject_daily == 1) & ( s6_16d== 1 |  s6_16e==1)
replace inject_daily_stock  = . if s5_6 == 2 
label values inject_daily_stock yesno


gen inject_daily_stock_prov = 0
replace inject_daily_stock_prov  = 1 if (inject_daily_stock == 1)&((strpos(produitb_labell_1, "Injectable")&(s8_3_1!=0)&(s8_3_1!=998)&(s8_3_1!=999)&(s8_3_1!=9998)&(s8_3_1!=.)&(s8_3_1!=9998)&(s8_3_1!=.))|(strpos(produitb_labell_2, "Injectable")&(s8_3_2!=0)&(s8_3_2!=998)&(s8_3_2!=999)&(s8_3_2!=9998)&(s8_3_2!=.)&(s8_3_2!=9998)&(s8_3_2!=.))|(strpos(produitb_labell_3, "Injectable")&(s8_3_3!=0)&(s8_3_3!=998)&(s8_3_3!=999)&(s8_3_3!=9998)&(s8_3_3!=.)&(s8_3_3!=9998)&(s8_3_3!=.))|(strpos(produitb_labell_4, "Injectable")&(s8_3_4!=0)&(s8_3_4!=998)&(s8_3_4!=999)&(s8_3_4!=9998)&(s8_3_4!=.)&(s8_3_4!=9998)&(s8_3_4!=.))|(strpos(produitb_labell_5, "Injectable")&(s8_3_5!=0)&(s8_3_5!=998)&(s8_3_5!=999)&(s8_3_5!=9998)&(s8_3_5!=.)&(s8_3_5!=9998)&(s8_3_5!=.))|(strpos(produitb_labell_6, "Injectable")&(s8_3_6!=0)&(s8_3_6!=998)&(s8_3_6!=999)&(s8_3_6!=9998)&(s8_3_6!=.)&(s8_3_6!=9998)&(s8_3_6!=.))|(strpos(produitb_labell_7, "Injectable")&(s8_3_7!=0)&(s8_3_7!=998)&(s8_3_7!=999)&(s8_3_7!=9998)&(s8_3_7!=.)&(s8_3_7!=9998)&(s8_3_7!=.))|(strpos(produitb_labell_8, "Injectable")&(s8_3_8!=0)&(s8_3_8!=998)&(s8_3_8!=999)&(s8_3_8!=9998)&(s8_3_8!=.)&(s8_3_8!=9998)&(s8_3_8!=.))|(strpos(produitb_labell_9, "Injectable")&(s8_3_9!=0)&(s8_3_9!=998)&(s8_3_9!=999)&(s8_3_9!=9998)&(s8_3_9!=.)&(s8_3_9!=9998)&(s8_3_9!=.))|(strpos(produitb_labell_10, "Injectable")&(s8_3_10!=0)&(s8_3_10!=998)&(s8_3_10!=999)&(s8_3_10!=9998)&(s8_3_10!=.)&(s8_3_10!=9998)&(s8_3_10!=.))|(strpos(produitb_labell_11, "Injectable")&(s8_3_11!=0)&(s8_3_11!=998)&(s8_3_11!=999)&(s8_3_11!=9998)&(s8_3_11!=.)&(s8_3_11!=9998)&(s8_3_11!=.)))
replace inject_daily_stock_prov  = . if s5_6 == 2
label values inject_daily_stock_prov yesno


tabout injectable_fourni inject_daily inject_daily_stock inject_daily_stock_prov s1_7 if id == 1 using "table_cascade.xls", append c(col) npos(both) nlab(Number)



********************* Implants 

gen implant_daily = 0
replace implant_daily = 1 if s5_7g == 1
replace implant_daily = . if s5_6 == 2
label values implant_daily  yesno


gen implant_daily_trained = 0
replace implant_daily_trained = 1 if (implant_daily == 1) & (( s4_1_5a_1!=0 & s4_1_5a_1!= 99& s4_1_5a_1!= 999)|( s4_1_5b_1!=0 & s4_1_5b_1!= 99& s4_1_5b_1!= 999))
replace implant_daily_trained= .  if s5_6 == 2
label values implant_daily_trained yesno


gen     implant_daily_trained_stock = 0
replace implant_daily_trained_stock  = 1 if implant_daily_trained == 1 &   s6_16f == 1
replace implant_daily_trained_stock = . if s5_6 == 2
label values implant_daily_trained_stock yesno



gen implant_daily_stock_prov = 0
replace implant_daily_stock_prov  = 1 if (implant_daily_trained_stock == 1)&((strpos(produitb_labell_1, "Implant")&(s8_3_1!=0)&(s8_3_1!=998)&(s8_3_1!=999)&(s8_3_1!=9998)&(s8_3_1!=.)&(s8_3_1!=9998)&(s8_3_1!=.))|(strpos(produitb_labell_2, "Implant")&(s8_3_2!=0)&(s8_3_2!=998)&(s8_3_2!=999)&(s8_3_2!=9998)&(s8_3_2!=.)&(s8_3_2!=9998)&(s8_3_2!=.))|(strpos(produitb_labell_3, "Implant")&(s8_3_3!=0)&(s8_3_3!=998)&(s8_3_3!=999)&(s8_3_3!=9998)&(s8_3_3!=.)&(s8_3_3!=9998)&(s8_3_3!=.))|(strpos(produitb_labell_4, "Implant")&(s8_3_4!=0)&(s8_3_4!=998)&(s8_3_4!=999)&(s8_3_4!=9998)&(s8_3_4!=.)&(s8_3_4!=9998)&(s8_3_4!=.))|(strpos(produitb_labell_5, "Implant")&(s8_3_5!=0)&(s8_3_5!=998)&(s8_3_5!=999)&(s8_3_5!=9998)&(s8_3_5!=.)&(s8_3_5!=9998)&(s8_3_5!=.))|(strpos(produitb_labell_6, "Implant")&(s8_3_6!=0)&(s8_3_6!=998)&(s8_3_6!=999)&(s8_3_6!=9998)&(s8_3_6!=.)&(s8_3_6!=9998)&(s8_3_6!=.))|(strpos(produitb_labell_7, "Implant")&(s8_3_7!=0)&(s8_3_7!=998)&(s8_3_7!=999)&(s8_3_7!=9998)&(s8_3_7!=.)&(s8_3_7!=9998)&(s8_3_7!=.))|(strpos(produitb_labell_8, "Implant")&(s8_3_8!=0)&(s8_3_8!=998)&(s8_3_8!=999)&(s8_3_8!=9998)&(s8_3_8!=.)&(s8_3_8!=9998)&(s8_3_8!=.))|(strpos(produitb_labell_9, "Implant")&(s8_3_9!=0)&(s8_3_9!=998)&(s8_3_9!=999)&(s8_3_9!=9998)&(s8_3_9!=.)&(s8_3_9!=9998)&(s8_3_9!=.))|(strpos(produitb_labell_10, "Implant")&(s8_3_10!=0)&(s8_3_10!=998)&(s8_3_10!=999)&(s8_3_10!=9998)&(s8_3_10!=.)&(s8_3_10!=9998)&(s8_3_10!=.))|(strpos(produitb_labell_11, "Implant")&(s8_3_11!=0)&(s8_3_11!=998)&(s8_3_11!=999)&(s8_3_11!=9998)&(s8_3_11!=.)&(s8_3_11!=9998)&(s8_3_11!=.)))

replace implant_daily_stock_prov = . if s5_6 == 2
label values implant_daily_stock_prov yesno


tabout implant_fourni implant_daily implant_daily_trained implant_daily_trained_stock implant_daily_stock_prov s1_7 if id == 1 using "table_cascade.xls", append c(col) npos(both) nlab(Number)



*************  Condoms

* Male condoms

gen male_condoms_daily = 0
replace male_condoms_daily = 1 if  s5_7c == 1
replace male_condoms_daily = . if s5_6 == 2
label values male_condoms_daily  yesno



gen male_condoms_daily_stock = 0
replace male_condoms_daily_stock = 1 if (male_condoms_daily == 1) & (s6_16a == 1)
replace male_condoms_daily_stock  = . if s5_6 == 2 
label values male_condoms_daily_stock yesno






gen male_condoms_daily_stock_prov = 0
replace male_condoms_daily_stock_prov  = 1 if (male_condoms_daily_stock == 1)&((strpos(produitb_labell_1, "Préservatif masculin")&(s8_3_1!=0)&(s8_3_1!=998)&(s8_3_1!=999)&(s8_3_1!=9998)&(s8_3_1!=.)&(s8_3_1!=9998)&(s8_3_1!=.))|(strpos(produitb_labell_2, "Préservatif masculin")&(s8_3_2!=0)&(s8_3_2!=998)&(s8_3_2!=999)&(s8_3_2!=9998)&(s8_3_2!=.)&(s8_3_2!=9998)&(s8_3_2!=.))|(strpos(produitb_labell_3, "Préservatif masculin")&(s8_3_3!=0)&(s8_3_3!=998)&(s8_3_3!=999)&(s8_3_3!=9998)&(s8_3_3!=.)&(s8_3_3!=9998)&(s8_3_3!=.))|(strpos(produitb_labell_4, "Préservatif masculin")&(s8_3_4!=0)&(s8_3_4!=998)&(s8_3_4!=999)&(s8_3_4!=9998)&(s8_3_4!=.)&(s8_3_4!=9998)&(s8_3_4!=.))|(strpos(produitb_labell_5, "Préservatif masculin")&(s8_3_5!=0)&(s8_3_5!=998)&(s8_3_5!=999)&(s8_3_5!=9998)&(s8_3_5!=.)&(s8_3_5!=9998)&(s8_3_5!=.))|(strpos(produitb_labell_6, "Préservatif masculin")&(s8_3_6!=0)&(s8_3_6!=998)&(s8_3_6!=999)&(s8_3_6!=9998)&(s8_3_6!=.)&(s8_3_6!=9998)&(s8_3_6!=.))|(strpos(produitb_labell_7, "Préservatif masculin")&(s8_3_7!=0)&(s8_3_7!=998)&(s8_3_7!=999)&(s8_3_7!=9998)&(s8_3_7!=.)&(s8_3_7!=9998)&(s8_3_7!=.))|(strpos(produitb_labell_8, "Préservatif masculin")&(s8_3_8!=0)&(s8_3_8!=998)&(s8_3_8!=999)&(s8_3_8!=9998)&(s8_3_8!=.)&(s8_3_8!=9998)&(s8_3_8!=.))|(strpos(produitb_labell_9, "Préservatif masculin")&(s8_3_9!=0)&(s8_3_9!=998)&(s8_3_9!=999)&(s8_3_9!=9998)&(s8_3_9!=.)&(s8_3_9!=9998)&(s8_3_9!=.))|(strpos(produitb_labell_10, "Préservatif masculin")&(s8_3_10!=0)&(s8_3_10!=998)&(s8_3_10!=999)&(s8_3_10!=9998)&(s8_3_10!=.)&(s8_3_10!=9998)&(s8_3_10!=.))|(strpos(produitb_labell_11, "Préservatif masculin")&(s8_3_11!=0)&(s8_3_11!=998)&(s8_3_11!=999)&(s8_3_11!=9998)&(s8_3_11!=.)&(s8_3_11!=9998)&(s8_3_11!=.)))

replace male_condoms_daily_stock_prov = . if s5_6 == 2
label values male_condoms_daily_stock_prov yesno


tabout condom_male_fourni male_condoms_daily male_condoms_daily_stock male_condoms_daily_stock_prov s1_7 if id == 1 using "table_cascade.xls", append c(col) npos(both) nlab(Number)




* Femaleale condoms
gen female_condoms_daily = 0
replace female_condoms_daily = 1 if  s5_7d == 1
replace female_condoms_daily = . if s5_6 == 2
label values female_condoms_daily  yesno



gen female_condoms_daily_stock = 0
replace female_condoms_daily_stock = 1 if (female_condoms_daily == 1) & ( s6_16b == 1)
replace female_condoms_daily_stock  = . if s5_6 == 2 
label values female_condoms_daily_stock yesno



gen female_condoms_daily_stock_prov = 0
replace female_condoms_daily_stock_prov  = 1 if (female_condoms_daily_stock == 1)&((strpos(produitb_labell_1, "Préservatif féminin")&(s8_3_1!=0)&(s8_3_1!=998)&(s8_3_1!=999)&(s8_3_1!=9998)&(s8_3_1!=.)&(s8_3_1!=9998)&(s8_3_1!=.))|(strpos(produitb_labell_2, "Préservatif féminin")&(s8_3_2!=0)&(s8_3_2!=998)&(s8_3_2!=999)&(s8_3_2!=9998)&(s8_3_2!=.)&(s8_3_2!=9998)&(s8_3_2!=.))|(strpos(produitb_labell_3, "Préservatif féminin")&(s8_3_3!=0)&(s8_3_3!=998)&(s8_3_3!=999)&(s8_3_3!=9998)&(s8_3_3!=.)&(s8_3_3!=9998)&(s8_3_3!=.))|(strpos(produitb_labell_4, "Préservatif féminin")&(s8_3_4!=0)&(s8_3_4!=998)&(s8_3_4!=999)&(s8_3_4!=9998)&(s8_3_4!=.)&(s8_3_4!=9998)&(s8_3_4!=.))|(strpos(produitb_labell_5, "Préservatif féminin")&(s8_3_5!=0)&(s8_3_5!=998)&(s8_3_5!=999)&(s8_3_5!=9998)&(s8_3_5!=.)&(s8_3_5!=9998)&(s8_3_5!=.))|(strpos(produitb_labell_6, "Préservatif féminin")&(s8_3_6!=0)&(s8_3_6!=998)&(s8_3_6!=999)&(s8_3_6!=9998)&(s8_3_6!=.)&(s8_3_6!=9998)&(s8_3_6!=.))|(strpos(produitb_labell_7, "Préservatif féminin")&(s8_3_7!=0)&(s8_3_7!=998)&(s8_3_7!=999)&(s8_3_7!=9998)&(s8_3_7!=.)&(s8_3_7!=9998)&(s8_3_7!=.))|(strpos(produitb_labell_8, "Préservatif féminin")&(s8_3_8!=0)&(s8_3_8!=998)&(s8_3_8!=999)&(s8_3_8!=9998)&(s8_3_8!=.)&(s8_3_8!=9998)&(s8_3_8!=.))|(strpos(produitb_labell_9, "Préservatif féminin")&(s8_3_9!=0)&(s8_3_9!=998)&(s8_3_9!=999)&(s8_3_9!=9998)&(s8_3_9!=.)&(s8_3_9!=9998)&(s8_3_9!=.))|(strpos(produitb_labell_10, "Préservatif féminin")&(s8_3_10!=0)&(s8_3_10!=998)&(s8_3_10!=999)&(s8_3_10!=9998)&(s8_3_10!=.)&(s8_3_10!=9998)&(s8_3_10!=.))|(strpos(produitb_labell_11, "Préservatif féminin")&(s8_3_11!=0)&(s8_3_11!=998)&(s8_3_11!=999)&(s8_3_11!=9998)&(s8_3_11!=.)&(s8_3_11!=9998)&(s8_3_11!=.)))

replace female_condoms_daily_stock_prov = . if s5_6 == 2
label values female_condoms_daily_stock_prov yesno


tabout condom_female_fourni female_condoms_daily female_condoms_daily_stock female_condoms_daily_stock_prov s1_7 if id == 1 using "table_cascade.xls", append c(col) npos(both) nlab(Number)



******** Pills


gen pills_daily = 0
replace pills_daily = 1 if  s5_7a == 1
replace pills_daily = . if s5_6 == 2
label values pills_daily  yesno



gen pills_daily_stock = 0
replace pills_daily_stock = 1 if (pills_daily == 1) & ( s6_16g == 1 | s6_16h ==1 )
replace pills_daily_stock  = . if s5_6 == 2 
label values pills_daily_stock yesno



gen pills_daily_stock_prov = 0
replace pills_daily_stock_prov  = 1 if (pills_daily_stock == 1)&((strpos(produitb_labell_1, "Pilule")&(s8_3_1!=0)&(s8_3_1!=998)&(s8_3_1!=999)&(s8_3_1!=9998)&(s8_3_1!=.)&(s8_3_1!=9998)&(s8_3_1!=.))|(strpos(produitb_labell_2, "Pilule")&(s8_3_2!=0)&(s8_3_2!=998)&(s8_3_2!=999)&(s8_3_2!=9998)&(s8_3_2!=.)&(s8_3_2!=9998)&(s8_3_2!=.))|(strpos(produitb_labell_3, "Pilule")&(s8_3_3!=0)&(s8_3_3!=998)&(s8_3_3!=999)&(s8_3_3!=9998)&(s8_3_3!=.)&(s8_3_3!=9998)&(s8_3_3!=.))|(strpos(produitb_labell_4, "Pilule")&(s8_3_4!=0)&(s8_3_4!=998)&(s8_3_4!=999)&(s8_3_4!=9998)&(s8_3_4!=.)&(s8_3_4!=9998)&(s8_3_4!=.))|(strpos(produitb_labell_5, "Pilule")&(s8_3_5!=0)&(s8_3_5!=998)&(s8_3_5!=999)&(s8_3_5!=9998)&(s8_3_5!=.)&(s8_3_5!=9998)&(s8_3_5!=.))|(strpos(produitb_labell_6, "Pilule")&(s8_3_6!=0)&(s8_3_6!=998)&(s8_3_6!=999)&(s8_3_6!=9998)&(s8_3_6!=.)&(s8_3_6!=9998)&(s8_3_6!=.))|(strpos(produitb_labell_7, "Pilule")&(s8_3_7!=0)&(s8_3_7!=998)&(s8_3_7!=999)&(s8_3_7!=9998)&(s8_3_7!=.)&(s8_3_7!=9998)&(s8_3_7!=.))|(strpos(produitb_labell_8, "Pilule")&(s8_3_8!=0)&(s8_3_8!=998)&(s8_3_8!=999)&(s8_3_8!=9998)&(s8_3_8!=.)&(s8_3_8!=9998)&(s8_3_8!=.))|(strpos(produitb_labell_9, "Pilule")&(s8_3_9!=0)&(s8_3_9!=998)&(s8_3_9!=999)&(s8_3_9!=9998)&(s8_3_9!=.)&(s8_3_9!=9998)&(s8_3_9!=.))|(strpos(produitb_labell_10, "Pilule")&(s8_3_10!=0)&(s8_3_10!=998)&(s8_3_10!=999)&(s8_3_10!=9998)&(s8_3_10!=.)&(s8_3_10!=9998)&(s8_3_10!=.))|(strpos(produitb_labell_11, "Pilule")&(s8_3_11!=0)&(s8_3_11!=998)&(s8_3_11!=999)&(s8_3_11!=9998)&(s8_3_11!=.)&(s8_3_11!=9998)&(s8_3_11!=.)))

replace pills_daily_stock_prov = . if s5_6 == 2
label values pills_daily_stock_prov yesno

tabout pillule_fourni pills_daily pills_daily_stock pills_daily_stock_prov s1_7 if id == 1 using "table_cascade.xls", append c(col) npos(both) nlab(Number)



******** Emergency pills


gen pcu_daily = 0
replace pcu_daily = 1 if  s5_7e  == 1
replace pcu_daily = . if s5_6 == 2
label values pcu_daily  yesno



gen pcu_daily_stock = 0
replace pcu_daily_stock = 1 if (pcu_daily == 1) & ( s6_16c == 1)
replace pcu_daily_stock  = . if s5_6 == 2 
label values pcu_daily_stock yesno



gen pcu_daily_stock_prov = 0
replace pcu_daily_stock_prov  = 1 if (pcu_daily_stock == 1)&((strpos(produitb_labell_1, "Contraception d'urgence")&(s8_3_1!=0)&(s8_3_1!=998)&(s8_3_1!=999)&(s8_3_1!=9998)&(s8_3_1!=.)&(s8_3_1!=9998)&(s8_3_1!=.))|(strpos(produitb_labell_2, "Contraception d'urgence")&(s8_3_2!=0)&(s8_3_2!=998)&(s8_3_2!=999)&(s8_3_2!=9998)&(s8_3_2!=.)&(s8_3_2!=9998)&(s8_3_2!=.))|(strpos(produitb_labell_3, "Contraception d'urgence")&(s8_3_3!=0)&(s8_3_3!=998)&(s8_3_3!=999)&(s8_3_3!=9998)&(s8_3_3!=.)&(s8_3_3!=9998)&(s8_3_3!=.))|(strpos(produitb_labell_4, "Contraception d'urgence")&(s8_3_4!=0)&(s8_3_4!=998)&(s8_3_4!=999)&(s8_3_4!=9998)&(s8_3_4!=.)&(s8_3_4!=9998)&(s8_3_4!=.))|(strpos(produitb_labell_5, "Contraception d'urgence")&(s8_3_5!=0)&(s8_3_5!=998)&(s8_3_5!=999)&(s8_3_5!=9998)&(s8_3_5!=.)&(s8_3_5!=9998)&(s8_3_5!=.))|(strpos(produitb_labell_6, "Contraception d'urgence")&(s8_3_6!=0)&(s8_3_6!=998)&(s8_3_6!=999)&(s8_3_6!=9998)&(s8_3_6!=.)&(s8_3_6!=9998)&(s8_3_6!=.))|(strpos(produitb_labell_7, "Contraception d'urgence")&(s8_3_7!=0)&(s8_3_7!=998)&(s8_3_7!=999)&(s8_3_7!=9998)&(s8_3_7!=.)&(s8_3_7!=9998)&(s8_3_7!=.))|(strpos(produitb_labell_8, "Contraception d'urgence")&(s8_3_8!=0)&(s8_3_8!=998)&(s8_3_8!=999)&(s8_3_8!=9998)&(s8_3_8!=.)&(s8_3_8!=9998)&(s8_3_8!=.))|(strpos(produitb_labell_9, "Contraception d'urgence")&(s8_3_9!=0)&(s8_3_9!=998)&(s8_3_9!=999)&(s8_3_9!=9998)&(s8_3_9!=.)&(s8_3_9!=9998)&(s8_3_9!=.))|(strpos(produitb_labell_10, "Contraception d'urgence")&(s8_3_10!=0)&(s8_3_10!=998)&(s8_3_10!=999)&(s8_3_10!=9998)&(s8_3_10!=.)&(s8_3_10!=9998)&(s8_3_10!=.))|(strpos(produitb_labell_11, "Contraception d'urgence")&(s8_3_11!=0)&(s8_3_11!=998)&(s8_3_11!=999)&(s8_3_11!=9998)&(s8_3_11!=.)&(s8_3_11!=9998)&(s8_3_11!=.)))

replace pcu_daily_stock_prov = . if s5_6 == 2
label values pcu_daily_stock_prov yesno

tabout pcu_fourni pcu_daily pcu_daily_stock pcu_daily_stock_prov  s1_7 if id == 1 using "table_cascade.xls", append c(col) npos(both) nlab(Number)



**************** Male seterilisation




gen male_ster_daily = 0
replace male_ster_daily = 1 if   s5_7i == 1
replace male_ster_daily = . if s5_6 == 2
label values male_ster_daily  yesno



gen male_ster_daily_stock = 0
replace male_ster_daily_stock = 1 if (male_ster_daily == 1) & (s6_15>=1)
replace male_ster_daily_stock  = . if s5_6 == 2 
label values male_ster_daily_stock yesno



gen male_ster_daily_stock_item = 0
replace male_ster_daily_stock_item = 1 if (male_ster_daily_stock == 1) & ( s6_14a==1 & s6_14b==1 & s6_14c==1 &  s6_14d==1 &  s6_14e==1 &  s6_14f==1 &  s6_14g==1 &  s6_14h==1 &  s6_14i==1)
replace male_ster_daily_stock_item  = . if s5_6 == 2 
label values male_ster_daily_stock_item  yesno




gen male_ster_daily_stock_item_prov=0
replace male_ster_daily_stock_item_prov  = 1 if (male_ster_daily_stock_item == 1)&((strpos(produitb_labell_1, "Stérilisation masculine/ Vasectomie")&(s8_3_1!=0)&(s8_3_1!=998)&(s8_3_1!=999)&(s8_3_1!=9998)&(s8_3_1!=.)&(s8_3_1!=9998)&(s8_3_1!=.))|(strpos(produitb_labell_2, "Stérilisation masculine/ Vasectomie")&(s8_3_2!=0)&(s8_3_2!=998)&(s8_3_2!=999)&(s8_3_2!=9998)&(s8_3_2!=.)&(s8_3_2!=9998)&(s8_3_2!=.))|(strpos(produitb_labell_3, "Stérilisation masculine/ Vasectomie")&(s8_3_3!=0)&(s8_3_3!=998)&(s8_3_3!=999)&(s8_3_3!=9998)&(s8_3_3!=.)&(s8_3_3!=9998)&(s8_3_3!=.))|(strpos(produitb_labell_4, "Stérilisation masculine/ Vasectomie")&(s8_3_4!=0)&(s8_3_4!=998)&(s8_3_4!=999)&(s8_3_4!=9998)&(s8_3_4!=.)&(s8_3_4!=9998)&(s8_3_4!=.))|(strpos(produitb_labell_5, "Stérilisation masculine/ Vasectomie")&(s8_3_5!=0)&(s8_3_5!=998)&(s8_3_5!=999)&(s8_3_5!=9998)&(s8_3_5!=.)&(s8_3_5!=9998)&(s8_3_5!=.))|(strpos(produitb_labell_6, "Stérilisation masculine/ Vasectomie")&(s8_3_6!=0)&(s8_3_6!=998)&(s8_3_6!=999)&(s8_3_6!=9998)&(s8_3_6!=.)&(s8_3_6!=9998)&(s8_3_6!=.))|(strpos(produitb_labell_7, "Stérilisation masculine/ Vasectomie")&(s8_3_7!=0)&(s8_3_7!=998)&(s8_3_7!=999)&(s8_3_7!=9998)&(s8_3_7!=.)&(s8_3_7!=9998)&(s8_3_7!=.))|(strpos(produitb_labell_8, "Stérilisation masculine/ Vasectomie")&(s8_3_8!=0)&(s8_3_8!=998)&(s8_3_8!=999)&(s8_3_8!=9998)&(s8_3_8!=.)&(s8_3_8!=9998)&(s8_3_8!=.))|(strpos(produitb_labell_9, "Stérilisation masculine/ Vasectomie")&(s8_3_9!=0)&(s8_3_9!=998)&(s8_3_9!=999)&(s8_3_9!=9998)&(s8_3_9!=.)&(s8_3_9!=9998)&(s8_3_9!=.))|(strpos(produitb_labell_10, "Stérilisation masculine/ Vasectomie")&(s8_3_10!=0)&(s8_3_10!=998)&(s8_3_10!=999)&(s8_3_10!=9998)&(s8_3_10!=.)&(s8_3_10!=9998)&(s8_3_10!=.))|(strpos(produitb_labell_11, "Stérilisation masculine/ Vasectomie")&(s8_3_11!=0)&(s8_3_11!=998)&(s8_3_11!=999)&(s8_3_11!=9998)&(s8_3_11!=.)&(s8_3_11!=9998)&(s8_3_11!=.)))
replace male_ster_daily_stock_item_prov = . if s5_6 == 2 
label values male_ster_daily_stock_item_prov yesno


tabout sterilisation_m_fourni male_ster_daily male_ster_daily_stock male_ster_daily_stock_item male_ster_daily_stock_item_prov  s1_7 if id == 1 using "table_cascade.xls", append c(col) npos(both) nlab(Number)



**************** female seterilisation




gen female_ster_daily = 0
replace female_ster_daily = 1 if    s5_7h == 1
replace female_ster_daily = . if s5_6 == 2
label values female_ster_daily  yesno



gen female_ster_daily_stock = 0
replace female_ster_daily_stock = 1 if (female_ster_daily == 1) & ((s6_9!=0 & s6_9!=9999)|(s6_12!=0 & s6_12!=9999 & s6_12!=998 & s6_12!=999))
replace female_ster_daily_stock  = . if s5_6 == 2 
label values female_ster_daily_stock yesno



gen female_ster_daily_stock_item = 0
replace female_ster_daily_stock_item = 1 if (female_ster_daily_stock == 1) & ((s6_11a==1 & s6_11b==1 & s6_11c==1 & s6_11d==1 & s6_11e==1 & s6_11f==1 & s6_11g==1 & s6_11h==1 & s6_11i==1 & s6_11j==1 & s6_11k==1 & s6_11l ==1 & s6_11m==1 & s6_11n==1 & s6_11o==1 & s6_11p==1 & s6_11q==1 & s6_11r==1 & s6_11s==1 & s6_11t==1 & s6_11u==1 )|( s6_8a==1 & s6_8b==1 & s6_8c==1 & s6_8d==1 & s6_8e==1 & s6_8f==1 & s6_8g==1 & s6_8h==1 & s6_8i==1 & s6_8j==1 & s6_8k==1 & s6_8l==1 & s6_8m==1 & s6_8n==1 & s6_8o==1 & s6_8p==1 & s6_8q==1 & s6_8r==1 & s6_8s==1 & s6_8t==1 & s6_8u==1 & s6_8v==1 & s6_8w==1 & s6_8x==1 & s6_8y==1 & s6_8z==1))
replace female_ster_daily_stock_item  = . if s5_6 == 2 
label values female_ster_daily_stock_item  yesno


gen female_ster_daily_stock_item_p=0
replace female_ster_daily_stock_item_p  = 1 if (female_ster_daily_stock_item == 1)&((strpos(produitb_labell_1, "Stérilisation féminine (Ligature des")&(s8_3_1!=0)&(s8_3_1!=998)&(s8_3_1!=999)&(s8_3_1!=9998)&(s8_3_1!=.)&(s8_3_1!=9998)&(s8_3_1!=.))|(strpos(produitb_labell_2, "Stérilisation féminine (Ligature des")&(s8_3_2!=0)&(s8_3_2!=998)&(s8_3_2!=999)&(s8_3_2!=9998)&(s8_3_2!=.)&(s8_3_2!=9998)&(s8_3_2!=.))|(strpos(produitb_labell_3, "Stérilisation féminine (Ligature des")&(s8_3_3!=0)&(s8_3_3!=998)&(s8_3_3!=999)&(s8_3_3!=9998)&(s8_3_3!=.)&(s8_3_3!=9998)&(s8_3_3!=.))|(strpos(produitb_labell_4, "Stérilisation féminine (Ligature des")&(s8_3_4!=0)&(s8_3_4!=998)&(s8_3_4!=999)&(s8_3_4!=9998)&(s8_3_4!=.)&(s8_3_4!=9998)&(s8_3_4!=.))|(strpos(produitb_labell_5, "Stérilisation féminine (Ligature des")&(s8_3_5!=0)&(s8_3_5!=998)&(s8_3_5!=999)&(s8_3_5!=9998)&(s8_3_5!=.)&(s8_3_5!=9998)&(s8_3_5!=.))|(strpos(produitb_labell_6, "Stérilisation féminine (Ligature des")&(s8_3_6!=0)&(s8_3_6!=998)&(s8_3_6!=999)&(s8_3_6!=9998)&(s8_3_6!=.)&(s8_3_6!=9998)&(s8_3_6!=.))|(strpos(produitb_labell_7, "Stérilisation féminine (Ligature des")&(s8_3_7!=0)&(s8_3_7!=998)&(s8_3_7!=999)&(s8_3_7!=9998)&(s8_3_7!=.)&(s8_3_7!=9998)&(s8_3_7!=.))|(strpos(produitb_labell_8, "Stérilisation féminine (Ligature des")&(s8_3_8!=0)&(s8_3_8!=998)&(s8_3_8!=999)&(s8_3_8!=9998)&(s8_3_8!=.)&(s8_3_8!=9998)&(s8_3_8!=.))|(strpos(produitb_labell_9, "Stérilisation féminine (Ligature des")&(s8_3_9!=0)&(s8_3_9!=998)&(s8_3_9!=999)&(s8_3_9!=9998)&(s8_3_9!=.)&(s8_3_9!=9998)&(s8_3_9!=.))|(strpos(produitb_labell_10, "Stérilisation féminine (Ligature des")&(s8_3_10!=0)&(s8_3_10!=998)&(s8_3_10!=999)&(s8_3_10!=9998)&(s8_3_10!=.)&(s8_3_10!=9998)&(s8_3_10!=.))|(strpos(produitb_labell_11, "Stérilisation féminine (Ligature des")&(s8_3_11!=0)&(s8_3_11!=998)&(s8_3_11!=999)&(s8_3_11!=9998)&(s8_3_11!=.)&(s8_3_11!=9998)&(s8_3_11!=.)))
replace female_ster_daily_stock_item_p = . if s5_6 == 2 
label values female_ster_daily_stock_item_p yesno


tabout sterilisation_f_fourni female_ster_daily female_ster_daily_stock female_ster_daily_stock_item female_ster_daily_stock_item_p  s1_7 if id == 1 using "table_cascade.xls", append c(col) npos(both) nlab(Number)



*************** Raison de non fourniture ************

tabout s5_10a_1 s5_10a_2 s5_10a_3 s5_10a_4 s5_10a_5 s1_7 if id == 1  &  s5_7a == 5 using "table_raison non.xls", append c(col) npos(both) nlab(Number) h1(pillule) 

tabout   s5_10b_1 s5_10b_2 s5_10b_3 s5_10b_4 s5_10b_5 s1_7 if id == 1  &  s5_7b == 5 using "table_raison non.xls", append c(col) npos(both) nlab(Number) h1(Injectable) 

tabout s5_10c_1 s5_10c_2 s5_10c_3 s5_10c_4 s5_10c_5  s1_7 if id == 1  &  s5_7c == 5 using "table_raison non.xls", append c(col) npos(both) nlab(Number) h1(Préservatif masculin) 

tabout  s5_10d_1 s5_10d_2 s5_10d_3 s5_10d_4 s5_10d_5 s1_7 if id == 1  &  s5_7d == 5 using "table_raison non.xls", append c(col) npos(both) nlab(Number) h1(Préservatif féminin) 

tabout  s5_10e_1 s5_10e_2 s5_10e_3 s5_10e_4 s5_10e_5 s1_7 if id == 1  &  s5_7e == 5 using "table_raison non.xls", append c(col) npos(both) nlab(Number) h1(Contraception d'urgence) 

tabout  s5_10f_1 s5_10f_2 s5_10f_3 s5_10f_4 s5_10f_5 s1_7 if id == 1  &  s5_7f == 5 using "table_raison non.xls", append c(col) npos(both) nlab(Number) h1(DIU) 

tabout s5_10g_1 s5_10g_2 s5_10g_3 s5_10g_4 s5_10g_5 s1_7 if id == 1  &  s5_7g == 5 using "table_raison non.xls", append c(col) npos(both) nlab(Number) h1(Implant) 

tabout   s5_10h_1 s5_10h_2 s5_10h_3 s5_10h_4 s5_10h_5 s1_7 if id == 1  &  s5_7h == 5 using "table_raison non.xls", append c(col) npos(both) nlab(Number) h1(Stérilisation féminine (Ligature des trompes) ) 

tabout  s5_10i_1 s5_10i_2 s5_10i_3 s5_10i_4 s5_10i_5   s1_7 if id == 1  &  s5_7i== 5 using "table_raison non.xls", append c(col) npos(both) nlab(Number) h1(Stérilisation Masculine ) 


****************** Rupture stock ****


tabout  s6_16a s1_7 if id == 1  & (s5_7c!=-9 & s5_7c!=5 & s5_7c!=.) using "rupture de stock.xls", append c(col) npos(both) nlab(Number) h1(Condom Masculin) 

tabout  s6_16b s1_7 if id == 1  &  (s5_7d!=-9 & s5_7d!=5 & s5_7d!=.) using "rupture de stock.xls", append c(col) npos(both) nlab(Number) h1(Condom Feminin) 

tabout  s6_16c s1_7 if id == 1  &  (s5_7e!=-9 & s5_7e!=5 & s5_7e!=.) using "rupture de stock.xls", append c(col) npos(both) nlab(Number) h1(PCU) 


tabout  s6_16d s1_7 if id == 1  &  (s5_7b!=-9 & s5_7b!=5 & s5_7b!=.) using "rupture de stock.xls", append c(col) npos(both) nlab(Number) h1(Injectable depo) 

tabout  s6_16e s1_7 if id == 1  &  (s5_7b!=-9 & s5_7b!=5 & s5_7b!=.)  using "rupture de stock.xls", append c(col) npos(both) nlab(Number) h1(Injectable sayana) 

tabout  s6_16f s1_7 if id == 1  &  (s5_7g!=-9 & s5_7g!=5 & s5_7g!=.)  using "rupture de stock.xls", append c(col) npos(both) nlab(Number) h1(Implant) 


tabout  s6_16g s1_7 if id == 1  &  (s5_7a!=-9 & s5_7a!=5 & s5_7a!=.)  using "rupture de stock.xls", append c(col) npos(both) nlab(Number) h1(PCO) 

tabout  s6_16h s1_7 if id == 1  &  (s5_7a!=-9 & s5_7a!=5 & s5_7a!=.) using "rupture de stock.xls", append c(col) npos(both) nlab(Number) h1(Pillule progesterone) 

tabout  s6_16i s1_7 if id == 1  &  (s5_7f!=-9 & s5_7f!=5 & s5_7f!=.) using "rupture de stock.xls", append c(col) npos(both) nlab(Number) h1(DUI) 

tabout  s6_16j s1_7 if id == 1  &  (s5_7h!=-9 & s5_7h!=5 & s5_7h!=.) using "rupture de stock.xls", append c(col) npos(both) nlab(Number) h1(Anneaux tubaire) 

**** Raison de rupture ***********

tabout  s6_19a_1 s6_19a_2 s6_19a_3 s6_19a_4 s6_19a_5 s1_7 if id == 1  &   s6_16a==3 using "table_raison rupture.xls", append c(col) npos(both) nlab(Number) h1(Condom Masculin) 

tabout  s6_19b_1 s6_19b_2 s6_19b_3 s6_19b_4 s6_19b_5  s1_7 if id == 1  &   s6_16b==3 using "table_raison rupture.xls", append c(col) npos(both) nlab(Number) h1(Condom Feminin) 

tabout  s6_19c_1 s6_19c_2 s6_19c_3 s6_19c_4 s6_19c_5 s1_7 if id == 1  &    s6_16c ==3 using "table_raison rupture.xls", append c(col) npos(both) nlab(Number) h1(PCU) 


tabout   s6_19d_1 s6_19d_2 s6_19d_3 s6_19d_4 s6_19d_5 s1_7 if id == 1  &   s6_16d==3  using "table_raison rupture.xls", append c(col) npos(both) nlab(Number) h1(Injectable depo) 

tabout  s6_19e_1 s6_19e_2 s6_19e_3 s6_19e_4 s6_19e_5  s1_7 if id == 1  &   s6_16e==3 using "table_raison rupture.xls", append c(col) npos(both) nlab(Number) h1(Injectable sayana) 

tabout   s6_19f_1 s6_19f_2 s6_19f_3 s6_19f_4 s6_19f_5 s1_7 if id == 1  &   s6_16f==3 using "table_raison rupture.xls", append c(col) npos(both) nlab(Number) h1(Implant) 

tabout  s6_19g_1 s6_19g_2 s6_19g_3 s6_19g_4 s6_19g_5 s1_7  if id == 1  &   s6_16g==3  using "table_raison rupture.xls", append c(col) npos(both) nlab(Number) h1(PCO) 

tabout  s6_19h_1 s6_19h_2 s6_19h_3 s6_19h_4 s6_19h_5 s1_7  if id == 1  &  s6_16h==3 using "table_raison rupture.xls", append c(col) npos(both) nlab(Number) h1(Pillule progesterone) 

tabout  s6_19i_1 s6_19i_2 s6_19i_3 s6_19i_4 s6_19i_5 s1_7 if id == 1  &   s6_16i==3 using "table_raison rupture.xls", append c(col) npos(both) nlab(Number) h1(DUI) 

tabout  s6_19j_1 s6_19j_2 s6_19j_3 s6_19j_4 s6_19j_5 s1_7 if id == 1  &   s6_16j==3 using "table_raison rupture.xls", append c(col) npos(both) nlab(Number) h1(Anneaux tubaire) 


























