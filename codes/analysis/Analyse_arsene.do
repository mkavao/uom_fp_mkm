clear

use "C:\Users\asandie\Desktop\structure_dm\Clean_data\EPS\eps_data_clean_combined.dta"

append using "C:\Users\asandie\Desktop\structure_dm\Clean_data\Centre de santé\centre_data_clean_combined.dta", force


append using "C:\Users\asandie\Desktop\structure_dm\Clean_data\Poste de santé\poste_data_clean_combined.dta", force //s5_10_autrea


append using "C:\Users\asandie\Desktop\structure_dm\Clean_data\Case de santé\case_data_clean.dta", force 


append using "C:\Users\asandie\Desktop\structure_dm\Clean_data\Clinique\clinique_data_clean.dta", force 