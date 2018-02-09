#!/usr/bin/env python
#-*- coding: utf-8 -*-

import cx_Oracle
import datetime

connection = cx_Oracle.connect("na17a034", "cTVwMJ0b", "sme-oracle.sme.utc/nf26")

cursor = connection.cursor()

choix = -1

while choix!=0:
	print("\n")
	print("========= Menu Application EtuDoc ========= \n")
	print("1 : Consulter un document en ligne \n")
	print("2 : Deposer un nouveau document \n")
	print("3 : Ajouter une UV \n")
	print("4 : Ajouter un etudiant \n")
	print("5 : Ajouter un auteur à un document \n")
	print("6 : Supprimer un auteur d'un document \n")
	print("7 : Modifier les informations d'un document \n")
	print("8 : Archiver un document \n")
	print("0 : Quitter l'application \n")
	choix=int(input("Que voulez vous faire ? \n"))

	if choix==1:
		cursor.execute("SELECT DISTINCT d.id_doc FROM Doc d WHERE d.etat='actif'")
		i = 0
		doc_liste = list()
		for row in cursor:
			doc_liste.append(row[0])
			i += 1
		i = 0
		c=0
		while c<1 or c>len(doc_liste):
			print("Choix du document: \n")
			i=0
			while i < len(doc_liste):
				cursor.execute("SELECT DISTINCT d.id_doc, d.titre FROM Doc d WHERE d.id_doc = '"+str(doc_liste[i])+"'")
				for row in cursor:
					print("""
				(%d) %s : %s
					"""%(i+1,row[0],row[1]))
				i += 1
			c=int(input("Entrer le numero du document (qui apparait entre parentheses) : \n"))
		c=c-1
		cursor.execute("SELECT d.id_doc, d.titre, d.date_publication, d.annee, d.semestre, d.etat, d.uv.code_uv FROM Doc d  WHERE d.id_doc='"+doc_liste[c]+"'")
		for row in cursor:
			print("""
				Code  : %s
				Titre   : %s
				Date de publication : %s
				Annee : %d
				Semestre : %s
				Etat : %s
				UV : %s
				Auteurs : """%(str(row[0]),row[1],str(row[2]),row[3],row[4],row[5],row[6]))
		cursor.execute("SELECT d.id_doc, d.titre, d.date_publication, d.annee, d.semestre, d.etat, d.uv.code_uv FROM Doc d  WHERE d.id_doc='"+doc_liste[c]+"'")
		cursor.execute("SELECT a.RefEtudiant.nom, a.RefEtudiant.prenom FROM Doc d, TABLE (d.auteurs) a 	WHERE d.id_doc='"+doc_liste[c]+"'")
		for row in cursor:
			print("""
					%s %s"""%(row[0],row[1]))

	elif choix==2:
		id_doc = input("Entrer son identifiant : \n")
		titre = input("Entrer son titre : \n")
		annee = int(input("Entrer l'annee de suivi de l'UV : \n"))
		c=0
		while c!=1 and c!=2:
			c=int(input("Entrer le semestre de suivi : 1 pour Automne, 2 pour Printemps \n"))
		if c==1:
			semestre="Automne"
		else :
			semestre="Printemps"
		cursor.execute("SELECT DISTINCT u.code_uv FROM UV u")
		i = 0
		uv_liste = list()
		for row in cursor:
			uv_liste.append(row[0])
			i += 1
		i = 0
		choix_uv=0
		while choix_uv<1 or choix_uv>len(uv_liste):
			print("Choix de l'UV : \n")
			i=0
			while i < len(uv_liste):
				cursor.execute("SELECT DISTINCT u.code_uv,u.titre FROM UV u WHERE u.code_uv = '"+str(uv_liste[i])+"'")
				for row in cursor:
					print("""
				(%d)
					Code  : %s
					Titre   : %s
					"""%(i+1,str(row[0]),str(row[1])))
				i += 1
			choix_uv=int(input("Entrer le numero de l'UV (qui apparait entre parentheses) : \n"))
		choix_uv=choix_uv-1

		nb_auteurs=0
		cursor.execute("SELECT DISTINCT count(id_etu) FROM Etudiant e")
		nb_auteurs_max=cursor.fetchone()[0]
		print(nb_auteurs_max)
		while nb_auteurs<1 or nb_auteurs>nb_auteurs_max:
			nb_auteurs=int(input("Entrer le nombre d'auteurs du document (si votre saisie est refusee, c'est parce que le nombre d'auteurs depasse le nombre total d'etudiants dans la base) \n"))
		auteurs_liste = list()
		
		requete="""
		DECLARE
			uv1 REF T_UV;"""
		i=1
		while i<=nb_auteurs:
			car=str(i)
			requete+="""
			etu"""+car+" REF T_Etudiant;"
			i=i+1
		requete+="""
		BEGIN
			SELECT REF(u) INTO uv1 FROM UV u WHERE code_uv='"""+uv_liste[choix_uv]+"';"
		sous_requete="ListeRefEtudiant("

		i=1
		while i<=nb_auteurs:
			requete_inter="SELECT DISTINCT e.id_etu FROM Etudiant e"
			if i>1:
				requete_inter+=" WHERE e.id_etu <> "+str(auteurs_liste[0])
			j=2
			while j<=i-1:
				requete_inter+=" AND e.id_etu <> "+str(auteurs_liste[j])

			print(requete_inter)

			cursor.execute(requete_inter)
			j=0
			etu_liste = list()
			for row in cursor:
				etu_liste.append(row[0])
				j += 1
			j = 0
			choix_etu=0
			while choix_etu<1 or choix_etu>len(etu_liste):
				print("Choix de l'auteur %d : \n"%(i))
				j=0
				while j < len(etu_liste):
					cursor.execute("SELECT DISTINCT e.nom, e.prenom FROM Etudiant e WHERE e.id_etu = '"+str(etu_liste[j])+"'")
					for row in cursor:
						print("""
					(%d) %s %s
					"""%(j+1,row[0],row[1]))
					j += 1
				choix_etu=int(input("Entrer le numero de l'etudiant (qui apparait entre parentheses) : \n"))
			choix_etu=choix_etu-1
			auteurs_liste.append(etu_liste[choix_etu])

			car=str(i)
			requete+="""
			SELECT REF(e) INTO etu"""+car+" FROM Etudiant e WHERE id_etu="""+str(auteurs_liste[i-1])+";"
			if i>1:
				sous_requete+=","
			sous_requete+="RefEtudiant(etu"+car+")"
			i=i+1
		sous_requete+=")"
		requete+="""
			INSERT INTO Doc(id_doc, titre, date_publication, annee, semestre, etat, uv, auteurs) VALUES ('"""+id_doc+"','"+titre+"', to_date('"+datetime.date.today().strftime("%d%m%Y")+"', 'DDMMYYYY'),"+str(annee)+",'"+semestre+"','actif',uv1,"""+sous_requete+");"+"""
		END;"""
		print(requete)
		cursor.execute(requete)
		connection.commit()
		
	elif choix==3:
		code_uv = input("Entrer son code UV : \n")
		titre = input("Entrer son titre : \n")
		cursor.execute("INSERT INTO UV(code_uv, titre) VALUES ('"+code_uv+"','"+titre+"')")
		print("L'UV a bien été ajoutée à la base !")
		connection.commit()
	elif choix==4:
		prenom = input("Entrer son prenom : \n")
		nom = input("Entrer son nom : \n")
		cursor.execute("SELECT DISTINCT e.id_etu FROM Etudiant e")
		i = 0
		etu_liste = list()
		for row in cursor:
			i += 1
		i += 1
		cursor.execute("INSERT INTO Etudiant(id_etu, nom, prenom) VALUES ("+str(i)+",'"+nom+"','"+prenom+"')")
		print("L'étudiant a bien été ajouté à la base !")
		connection.commit()
	elif choix==5:
		cursor.execute("SELECT DISTINCT d.id_doc FROM Doc d WHERE d.etat='actif'")
		i = 0
		doc_liste = list()
		for row in cursor:
			doc_liste.append(row[0])
			i += 1
		i = 0
		choix_doc=0
		while choix_doc<1 or choix_doc>len(doc_liste):
			print("Choix du document: \n")
			i=0
			while i < len(doc_liste):
				cursor.execute("SELECT DISTINCT d.id_doc, d.titre FROM Doc d WHERE d.id_doc = '"+str(doc_liste[i])+"'")
				for row in cursor:
					print("""
				(%d) %s : %s
					"""%(i+1,row[0],row[1]))
				i += 1
			choix_doc=int(input("Entrer le numero du document (qui apparait entre parentheses) : \n"))
		choix_doc=choix_doc-1

		cursor.execute("SELECT DISTINCT Etudiant.id_etu, Etudiant.nom, Etudiant.prenom FROM Etudiant WHERE Etudiant.id_etu NOT IN(SELECT a.RefEtudiant.id_etu FROM Doc d, TABLE (d.auteurs) a	WHERE d.id_doc='"+doc_liste[choix_doc]+"')")
		i = 0
		etu_liste = list()
		for row in cursor:
			etu_liste.append(row[0])
			i += 1
		i = 0
		if len(etu_liste)==0:
			print("Erreur : tous les étudiants de la base sont déjà auteurs du document sélectionné !")
		else:
			choix_etu=0
			while choix_etu<1 or choix_etu>len(etu_liste):
				print("Ces étudiants ne sont pas encore auteurs du document sélectionné: \n")
				i=0
				while i < len(etu_liste):
					cursor.execute("SELECT DISTINCT Etudiant.prenom, Etudiant.nom FROM Etudiant WHERE Etudiant.id_etu = "+str(etu_liste[i]))
					for row in cursor:
						print("""
					(%d) %s %s
						"""%(i+1,row[0],row[1]))
					i += 1
				choix_etu=int(input("Entrer le numero de l'étudiant que vous souhaitez ajouter comme auteur (qui apparait entre parentheses) : \n"))
			choix_etu=choix_etu-1
			sous_requete="SELECT auteurs FROM Doc WHERE id_doc='"+str(doc_liste[choix_doc])+"'"
			requete="""
			DECLARE
				etu REF T_Etudiant;	
			BEGIN
				SELECT REF(E) INTO etu FROM Etudiant E WHERE id_etu="""+str(etu_liste[choix_etu])+""";
				INSERT INTO THE ("""+sous_requete+""") VALUES (etu);
			END;"""

			cursor.execute(requete);
			print("L'étudiant a bien été rajouté comme auteur du document ")
		connection.commit()
	elif choix==6:
		cursor.execute("SELECT DISTINCT d.id_doc FROM Doc d WHERE d.etat='actif'")
		i = 0
		doc_liste = list()
		for row in cursor:
			doc_liste.append(row[0])
			i += 1
		i = 0
		choix_doc=0
		while choix_doc<1 or choix_doc>len(doc_liste):
			print("Choix du document: \n")
			i=0
			while i < len(doc_liste):
				cursor.execute("SELECT DISTINCT d.id_doc, d.titre FROM Doc d WHERE d.id_doc = '"+str(doc_liste[i])+"'")
				for row in cursor:
					print("""
				(%d) %s : %s
					"""%(i+1,row[0],row[1]))
				i += 1
			choix_doc=int(input("Entrer le numero du document (qui apparait entre parentheses) : \n"))
		choix_doc=choix_doc-1

		cursor.execute("SELECT a.RefEtudiant.id_etu FROM Doc d, TABLE (d.auteurs) a 	WHERE d.id_doc='"+doc_liste[choix_doc]+"'")
		i = 0
		etu_liste = list()
		for row in cursor:
			etu_liste.append(row[0])
			i += 1
		i = 0
		choix_etu=0
		while choix_etu<1 or choix_etu>len(etu_liste):
			print("Ces étudiants sont auteurs du document sélectionné: \n")
			i=0
			while i < len(etu_liste):
				cursor.execute("SELECT DISTINCT Etudiant.prenom, Etudiant.nom FROM Etudiant WHERE Etudiant.id_etu = "+str(etu_liste[i]))
				for row in cursor:
					print("""
				(%d) %s %s
					"""%(i+1,row[0],row[1]))
				i += 1
			choix_etu=int(input("Entrer le numero de l'étudiant que vous souhaitez supprimer des auteurs (qui apparait entre parentheses) : \n"))
		choix_etu=choix_etu-1
		sous_requete="SELECT auteurs FROM Doc WHERE id_doc='"+str(doc_liste[choix_doc])+"'"
		requete="""
		DECLARE
			etu REF T_Etudiant;	
		BEGIN
			SELECT REF(E) INTO etu FROM Etudiant E WHERE id_etu="""+str(etu_liste[choix_etu])+""";
			DELETE FROM THE ("""+sous_requete+""") WHERE RefEtudiant=etu;
		END;"""

		cursor.execute(requete);
		print("L'étudiant a bien été supprimé des auteurs du document ")
		connection.commit()
	elif choix==7:
		cursor.execute("SELECT DISTINCT d.id_doc FROM Doc d WHERE d.etat='actif'")
		i = 0
		doc_liste = list()
		for row in cursor:
			doc_liste.append(row[0])
			i += 1
		i = 0
		choix_doc=0
		while choix_doc<1 or choix_doc>len(doc_liste):
			print("Choix du document: \n")
			i=0
			while i < len(doc_liste):
				cursor.execute("SELECT DISTINCT d.id_doc, d.titre FROM Doc d WHERE d.id_doc = '"+str(doc_liste[i])+"'")
				for row in cursor:
					print("""
				(%d) %s : %s
					"""%(i+1,row[0],row[1]))
				i += 1
			choix_doc=int(input("Entrer le numero du document que vous voulez modifier (qui apparait entre parentheses) : \n"))
		choix_doc=choix_doc-1

		choix_modif=-1
		while choix_modif<1 or choix_modif>3:
			print("Que voulez-vous modifier ?")
			print("""
			(1) Titre
			(2) Année
			(3) Semestre
			""")
			choix_modif=int(input())

		if choix_modif==1:
			titre=input("Entrez le nouveau titre du document : ")
			cursor.execute("UPDATE Doc SET titre='"+titre+"' WHERE id_doc='"+doc_liste[choix_doc]+"'")
			print("Le titre du document a bien été modifié")
		elif choix_modif==2:
			annee=input("Entrez la nouvelle année du document : ")
			cursor.execute("UPDATE Doc SET annee="+annee+" WHERE id_doc='"+doc_liste[choix_doc]+"'")
			print("L'année du document a bien été modifiée")
		elif choix_modif==3:
			cursor.execute("SELECT semestre from Doc where id_doc='"+doc_liste[choix_doc]+"'")
			semestre=cursor.fetchone()[0]
			if semestre=='Automne':
				cursor.execute("UPDATE Doc SET semestre='Printemps' WHERE id_doc='"+doc_liste[choix_doc]+"'")
			else:
				cursor.execute("UPDATE Doc SET semestre='Automne' WHERE id_doc='"+doc_liste[choix_doc]+"'")
			print("Le semestre du document a bien été changé")
		connection.commit()
	elif choix==8:
		cursor.execute("SELECT DISTINCT d.id_doc FROM Doc d WHERE d.etat='actif'")
		i = 0
		doc_liste = list()
		for row in cursor:
			doc_liste.append(row[0])
			i += 1
		i = 0
		c=0
		while c<1 or c>len(doc_liste):
			print("Choix du document: \n")
			i=0
			while i < len(doc_liste):
				cursor.execute("SELECT DISTINCT d.id_doc, d.titre FROM Doc d WHERE d.id_doc = '"+str(doc_liste[i])+"' AND d.etat='actif'")
				for row in cursor:
					print("""
					(%d) %s : %s
					"""%(i+1,row[0],row[1]))
				i += 1
			c=int(input("Entrer le numero du document (qui apparait entre parentheses) : \n"))
		c=c-1
		cursor.execute("UPDATE Doc SET etat='archive' WHERE id_doc='"+doc_liste[c]+"'")
		print("Le document a bien été archivé !")
		connection.commit()
	elif choix==0:
		print("A bientot ! \n")

connection.commit()
cursor.close()
connection.close()