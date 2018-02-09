/*Projet EtuDoc - NA17 - UTC*/
/*Groupe 11*/
/*Marlow Justine - Houlliez Solène - Meurou Thomas*/

/*Ce code est mis à disposition selon les termes de la Licence Creative Commons Attribution - Pas d’Utilisation Commerciale - Pas de Modification 3.0 France.*/
/* http://creativecommons.org/licenses/by-nc-nd/3.0/fr/ */

/*Ajout des personnes tests*/
INSERT INTO Semestre(nom) VALUES
	('GI01'),
        ('GI02'),
        ('TC05'),
        ('IM05'),
	('GSU01'),
	('GB01');
INSERT INTO Etudiant(nom, prenom, semestre) VALUES
	('Marlow','Justine','GI01'),
        ('Houlliez','Solène','GI02'),
        ('Meurou','Thomas','IM05'),
	('Thyere','Laurine','GSU01'),
	('Payrastre','Mathilde','GB01');
INSERT INTO Departement(nom) VALUES
	('Informatique'),
        ('Biologique'),
        ('Mécanique'),
	('Chimie'),
	('Sciences humaines'),
	('Systemes urbains'),
	('Mathematiques');
INSERT INTO Enseignant(nom, prenom, departement) VALUES
	('Crozat','Stéphane','Informatique'),
	('Boufflet','Jean-Paul','Informatique'),
	('Moulier-Boutang','Yann','Sciences humaines'),
	('Hedou','Veronique','Mathematiques');
INSERT INTO Exterieur(nom, prenom) VALUES
	('Turing','Alan'),
	('Dupont','Paul');
/*Ajout des UVs tests*/
INSERT INTO UV(code,titre) VALUES
	('NA17', 'Base de données'),
	('SI22','Signes et contenus numeriques'),
	('MT09','Analyse numerique'),
	('GE10','Economie politique');
/*Ajout des caractéristiques tests*/
INSERT INTO Type(nom) VALUES
	('texte'),
	('image'),
	('slides');
INSERT INTO Categorie(nom) VALUES
	('Note de clarification'),
	('Expose'),
	('Rapport'),
	('These'),
	('Devoir maison');
INSERT INTO Mot_cle(nom) VALUES
	('base de donnees'),
    	('conception'),
	('economie'),
	('mathematiques'),
	('semiologie'),
	('science humaine');
INSERT INTO Licence(nom,description) VALUES
	('UTCDoc','Licence de l''UTC'),
	('CC-Zero', 'Zero'),
	('CC-BY', 'Attribution');
/*Ajout de document*/
INSERT INTO Document(id_doc, titre, date_publication, annee, semestre, etat, uv, type, categorie) VALUES
	('2017-A-NA17-Note','Note de clarification de projet','2017-09-24',2017,'Automne','actif','NA17','texte','Note de clarification'),
	('2016-P-GE10-Expose','Expose d economie politique','2016-05-24',2016,'Printemps','actif','GE10','texte','Expose'),
	('2015-P-SI22-Expose','Expose sur le culinaire a la television','2015-03-14',2016,'Printemps','actif','SI22','texte','Expose'),
	('2016-A-MT09-DevoirMaison','DM01','2016-11-15',2016,'Automne','actif','MT09','texte','Devoir maison');
INSERT INTO Ecrit(id_doc,id_etu) VALUES 
	('2017-A-NA17-Note',1),
   	('2017-A-NA17-Note',2),
    	('2017-A-NA17-Note',3),
	('2016-P-GE10-Expose',4),
	('2015-P-SI22-Expose',2),
	('2015-P-SI22-Expose',5),
	('2016-A-MT09-DevoirMaison',1),
	('2016-A-MT09-DevoirMaison',2),
	('2016-A-MT09-DevoirMaison',3) ;
INSERT INTO Participe_enseignant(id_doc,id_enseignant) VALUES
	('2017-A-NA17-Note',1),
	('2016-A-MT09-DevoirMaison',4),
	('2016-P-GE10-Expose',3);
INSERT INTO Participe_exterieur(id_doc,id_exterieur) VALUES
	('2017-A-NA17-Note',1),
	('2016-P-GE10-Expose',2);
INSERT INTO Protege(doc,licence) VALUES
	('2017-A-NA17-Note','UTCDoc'),
	('2016-P-GE10-Expose','CC-Zero'),
	('2016-A-MT09-DevoirMaison','CC-BY'),
	('2015-P-SI22-Expose','UTCDoc');
INSERT INTO Traite(doc,mot) VALUES
	('2017-A-NA17-Note','base de donnees'),
    	('2017-A-NA17-Note','conception'),
	('2016-P-GE10-Expose','economie'),
	('2016-A-MT09-DevoirMaison','mathematiques'),
	('2015-P-SI22-Expose','semiologie'),
	('2015-P-SI22-Expose','science humaine');
