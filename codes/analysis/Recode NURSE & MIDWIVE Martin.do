




recode S2_3 (1 3=1 "Nurse")(2 4=2 "MIDWIVE")(4=.), gen(Categorie)





S2_3a	-- 203. Veuillez préciser la profession
					
		Freq.	Percent	Valid	Cum.
					
Valid		1734	91.60	91.60	91.60
	ASSISTANTE INFIRMIER	1	0.05	0.05	91.65
	Agent sanitaire	1	0.05	0.05	91.71
	Aide infirmier	1	0.05	0.05	91.76
	Aide infirmiere	1	0.05	0.05	91.81
	Aide infirmière	1	0.05	0.05	91.86
	Assistant Infirmier	4	0.21	0.21	92.08
	Assistant infirmier	41	2.17	2.17	94.24
	Assistant infirmier d Etat	1	0.05	0.05	94.29
	Assistant infirmier d état	1	0.05	0.05	94.35
	Assistant infirmier d'état	7	0.37	0.37	94.72
	Assistant infirmier diplômé d'état	1	0.05	0.05	94.77
	Assistant infirmiere d'Etat	1	0.05	0.05	94.82
	Assistant infirmièr	7	0.37	0.37	95.19
	Assistant infirmièr d'état	7	0.37	0.37	95.56
	Assistant infirmière	1	0.05	0.05	95.62
	Assistant infirmière d'état	1	0.05	0.05	95.67
	Assistante	2	0.11	0.11	95.77
	Assistante  infirmière	1	0.05	0.05	95.83
	Assistante Infirmière	4	0.21	0.21	96.04
	Assistante Infirmière d'état	4	0.21	0.21	96.25
	Assistante d infimier	1	0.05	0.05	96.30
	Assistante infirmier	4	0.21	0.21	96.51
	Assistante infirmier d'état	2	0.11	0.11	96.62
	Assistante infirmiere	2	0.11	0.11	96.72
	Assistante infirmièr	1	0.05	0.05	96.78
	Assistante infirmière	43	2.27	2.27	99.05
	Assistante infirmière d'etat	1	0.05	0.05	99.10
	Assistante infirmière d'état	9	0.48	0.48	99.58
	Infirmier communautaire	1	0.05	0.05	99.63
	Infirmiere brevetée	1	0.05	0.05	99.68
	Infirmière breveté	1	0.05	0.05	99.74
	Médecin	1	0.05	0.05	99.79
	Sage femme communautaire	1	0.05	0.05	99.84
	Sage femme licence	1	0.05	0.05	99.89
	Stagiaire Sage femme	1	0.05	0.05	99.95
	Technicienne supérieure	1	0.05	0.05	100.00
	Total	1893	100.00	100.00	          
					

recode S2_3(1 3=1 "Nurse")(2 4=2 "Midwife")(4=.), gen(Categorie)

replace Categorie = 1	if S2_3a=="Médecin"
replace Categorie = 1	if S2_3a=="Assistante"
replace Categorie = 1	if S2_3a=="Aide infirmier"
replace Categorie = 1	if S2_3a=="Agent sanitaire"
replace Categorie = 1	if S2_3a=="Aide infirmiere"
replace Categorie = 1	if S2_3a=="Aide infirmière"
replace Categorie = 1	if S2_3a=="Infirmière breveté"
replace Categorie = 1	if S2_3a=="Assistant Infirmier"
replace Categorie = 1	if S2_3a=="Assistant infirmièr"
replace Categorie = 1	if S2_3a=="Assistant infirmier"
replace Categorie = 1	if S2_3a=="Infirmiere brevetée"
replace Categorie = 1	if S2_3a=="Assistant infirmière"
replace Categorie = 1	if S2_3a=="ASSISTANTE INFIRMIER"
replace Categorie = 1	if S2_3a=="Assistante infirmièr"
replace Categorie = 1	if S2_3a=="Assistante infirmier"
replace Categorie = 1	if S2_3a=="Assistante d infimier"
replace Categorie = 1	if S2_3a=="Assistante infirmiere"
replace Categorie = 1	if S2_3a=="Assistante Infirmière"
replace Categorie = 1	if S2_3a=="Assistante infirmière"
replace Categorie = 1	if S2_3a=="Assistante  infirmière"
replace Categorie = 1	if S2_3a=="Infirmier communautaire"
replace Categorie = 1	if S2_3a=="Technicienne supérieure"
replace Categorie = 2	if S2_3a=="Sage femme communautaire"
replace Categorie = 1	if S2_3a=="Assistant infirmier d Etat"
replace Categorie = 1	if S2_3a=="Assistant infirmier d état"
replace Categorie = 1	if S2_3a=="Assistant infirmier d'état"
replace Categorie = 1	if S2_3a=="Assistant infirmièr d'état"
replace Categorie = 1	if S2_3a=="Assistant infirmiere d'Etat"
replace Categorie = 1	if S2_3a=="Assistant infirmière d'état"
replace Categorie = 1	if S2_3a=="Assistante infirmier d'état"
replace Categorie = 1	if S2_3a=="Assistante infirmière d'etat"
replace Categorie = 1	if S2_3a=="Assistante Infirmière d'état"
replace Categorie = 1	if S2_3a=="Assistante infirmière d'état"
replace Categorie = 1	if S2_3a=="Assistant infirmier diplômé d'état"
replace Categorie = 1	if S2_3==5


ta Categorie, m



