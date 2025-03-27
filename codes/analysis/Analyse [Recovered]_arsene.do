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

gen dui_daily = .
replace dui_daily = 1 if s5_7f == 1 
replace dui_daily = 0 if s5_7f !=1 & s5_6 ==1
label values dui_daily dui_daily


gen dui_daily_trained = .
replace dui_daily_trained = 1 if (dui_daily == 1) & (( s4_1_5a_1!=0 & s4_1_5a_1!= 99& s4_1_5a_1!= 999)|( s4_1_5b_1!=0 & s4_1_5b_1!= 99& s4_1_5b_1!= 999))
replace dui_daily_trained = 0 if dui_daily == 0
label values dui_daily_trained yesno


gen dui_daily_trained_stock = .
replace dui_daily_trained_stock  = 1 if dui_daily_trained == 1 &  s6_16i == 1
replace dui_daily_trained_stock = 0 if dui_daily == 0 
label values dui_daily_trained_stock yesno

 
gen dui_daily_trained_stock_items = .
replace dui_daily_trained_stock_items = 1 if ((s6_3trav_a==1 & s6_3trav_b==1 &  s6_3trav_c==1 &  s6_3trav_d ==1 & s6_3trav_e==1 &  s6_3trav_f==1 &  s6_3trav_g==1 &  s6_3trav_h==1 &  s6_3trav_i ==1 & s6_3trav_j ==1 & s6_3trav_k==1 &  s6_3trav_l==1 &  s6_3trav_m==1 &  s6_3trav_n==1)|(s6_3coin_a ==1 &  s6_3coin_b ==1 & s6_3coin_c==1 &  s6_3coin_d==1 &  s6_3coin_e==1 &  s6_3coin_f ==1 & s6_3coin_g ==1 & s6_3coin_h==1 &  s6_3coin_i==1 &  s6_3coin_j ==1 & s6_3coin_k==1 &  s6_3coin_l ==1 & s6_3coin_m ==1 & s6_3coin_n==1)|(s6_3both_a ==1 & s6_3both_b ==1 & s6_3both_c==1 &  s6_3both_d==1 &  s6_3both_e==1 &  s6_3both_f==1 &  s6_3both_g ==1 & s6_3both_h ==1 & s6_3both_i==1 &  s6_3both_j ==1 & s6_3both_k==1 &  s6_3both_l==1 &  s6_3both_m==1 &  s6_3both_n==1)|(s6_3other_a==1 &  s6_3other_b==1 &  s6_3other_c==1 &  s6_3other_d==1 &  s6_3other_e==1 &  s6_3other_f==1 &  s6_3other_g==1 &  s6_3other_h==1 &  s6_3other_i ==1 & s6_3other_j==1 &  s6_3other_k==1 &  s6_3other_l==1 &  s6_3other_m==1 &  s6_3other_n==1)) & dui_daily_trained_stock == 1

replace dui_daily_trained_stock_items = 0 if dui_daily == 0

label values dui_daily_trained_stock_items yesno


tabout dui_daily dui_daily_trained dui_daily_trained_stock  dui_daily_trained_stock_items s1_7 if id == 1 using "table_cascade.xls", append c(col) npos(both) nlab(Number) 














