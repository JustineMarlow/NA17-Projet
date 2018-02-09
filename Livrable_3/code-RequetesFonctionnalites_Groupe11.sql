/*Projet EtuDoc - NA17 - UTC*/
/*Groupe 11*/
/*Marlow Justine - Houlliez Solène - Meurou Thomas*/

/*Ce code est mis à disposition selon les termes de la Licence Creative Commons Attribution - Pas d’Utilisation Commerciale - Pas de Modification 3.0 France.*/
/* http://creativecommons.org/licenses/by-nc-nd/3.0/fr/ */

/*Consultation d'un document en particulier (grâce à son code et s'il n'est pas archivé)*/
SELECT id_doc,titre,date_publication,annee,semestre,etat,uv,type,categorie FROM Document
	WHERE (id_doc='2017-A-NA17-Note' AND etat='actif');
SELECT Ecrit.id_doc,Etudiant.nom,Etudiant.prenom FROM Etudiant,Ecrit
	WHERE (Ecrit.id_doc='2017-A-NA17-Note' AND Ecrit.id_etu=Etudiant.id);
SELECT Participe_enseignant.id_doc,Enseignant.nom,Enseignant.prenom FROM Enseignant,Participe_enseignant
	WHERE (Participe_enseignant.id_doc='2017-A-NA17-Note' AND Participe_enseignant.id_enseignant=Enseignant.id);
SELECT Participe_exterieur.id_doc,Exterieur.nom,Exterieur.prenom FROM Exterieur,Participe_exterieur
	WHERE (Participe_exterieur.id_doc='2017-A-NA17-Note' AND Participe_exterieur.id_exterieur=Exterieur.id);
SELECT Protege.doc,Licence.nom,Licence.description FROM Licence,Protege
	WHERE (Protege.doc='2017-A-NA17-Note' AND Protege.licence=Licence.nom);
SELECT Traite.doc,Traite.mot FROM Traite
	WHERE (Traite.doc='2017-A-NA17-Note');

/*Archivage d'un document*/
UPDATE Document
	SET etat='archive'
	WHERE id_doc='2017-A-NA17-Note';

/*Mise à jour d'un document, par exemple son titre*/
UPDATE Document
	SET titre='Note de clarification de projet EtuDoc'
	WHERE id_doc='2017-A-NA17-Note';

/*Liste des documents ayant des attributs en commun*/
/*Recherche des titres et identifiants des documents concernant une UV, ici SI22*/
SELECT uv,id_doc,titre FROM Document 
	WHERE uv='SI22';
/*Recherche des titres et identifiants des documents concernant une categorie, ici expose*/
SELECT categorie,id_doc,titre FROM Document 
	WHERE categorie='Expose';
/*Recherche des titres et identifiants des documents concernant un type, ici texte*/
SELECT type,id_doc,titre FROM Document 
	WHERE type='texte';
/*Recherche des titres et identifiants des documents concernant une licence, ici UTCDoc*/
SELECT Protege.licence,Protege.doc,Document.titre FROM Document,Protege 
	WHERE (Protege.licence='UTCDoc' AND Protege.doc=Document.id_doc);
/*Recherche des titres et identifiants des documents concernant un mot clé, ici economie*/
SELECT Traite.mot,Traite.doc,Document.titre FROM Document,Traite 
WHERE (Traite.mot='economie' AND Traite.doc=Document.id_doc);

/*Suppresion d'un document*/
DELETE FROM Ecrit
	WHERE id_doc='2017-A-NA17-Note';
DELETE FROM Participe_enseignant
	WHERE id_doc='2017-A-NA17-Note';
DELETE FROM Participe_exterieur
	WHERE id_doc='2017-A-NA17-Note';
DELETE FROM Protege
	WHERE doc='2017-A-NA17-Note';
DELETE FROM Traite
	WHERE doc='2017-A-NA17-Note';
DELETE FROM Document
	WHERE id_doc='2017-A-NA17-Note';
