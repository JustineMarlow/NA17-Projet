/*Projet EtuDoc - NA17 - UTC*/
/*Groupe 11*/
/*Marlow Justine - Houlliez Solène - Meurou Thomas*/

/*Ce code est mis à disposition selon les termes de la Licence Creative Commons Attribution - Pas d’Utilisation Commerciale - Pas de Modification 3.0 France.*/
/* http://creativecommons.org/licenses/by-nc-nd/3.0/fr/ */

/*Création de la base de données*/
CREATE DATABASE groupe11 WITH OWNER postgres;
\c groupe11 postgres;
/*Création des différentes tables*/
CREATE TABLE Semestre(
	nom VARCHAR(5) PRIMARY KEY);
CREATE TABLE Etudiant(
	id SERIAL PRIMARY KEY,
	nom VARCHAR(25),
	prenom VARCHAR(25),
	semestre VARCHAR(5) NOT NULL,
	FOREIGN KEY (semestre) REFERENCES Semestre(nom));
CREATE TABLE Departement(
	nom VARCHAR(25) PRIMARY KEY);
CREATE TABLE Enseignant(
	id SERIAL PRIMARY KEY,
	nom VARCHAR(25),
	prenom VARCHAR(25),
	departement VARCHAR(25) NOT NULL,
	FOREIGN KEY (departement) REFERENCES Departement(nom));
CREATE TABLE Exterieur(
	id SERIAL PRIMARY KEY,
	nom VARCHAR(25),
	prenom VARCHAR(25));
CREATE TABLE UV(
	code VARCHAR(4) PRIMARY KEY,
	titre VARCHAR(40));
CREATE TABLE Type(
	nom VARCHAR(15) PRIMARY KEY);
CREATE TABLE Categorie(
	nom VARCHAR(30) PRIMARY KEY);
CREATE TABLE Document(
	id_doc VARCHAR(30) PRIMARY KEY,
	titre VARCHAR(50),
	date_publication DATE,
	annee INTEGER,
	semestre VARCHAR(10) CHECK (semestre='Automne' OR semestre='Printemps'),
	etat VARCHAR(7) CHECK (etat='actif' OR etat='archive'),
	uv VARCHAR(4) NOT NULL,
	type VARCHAR(15),
	categorie VARCHAR(30),
	FOREIGN KEY (uv) REFERENCES UV(code),
	FOREIGN KEY (type) REFERENCES Type(nom),
	FOREIGN KEY (categorie) REFERENCES Categorie(nom));
CREATE TABLE Ecrit(
	id_doc VARCHAR(30),
	id_etu INTEGER,
	PRIMARY KEY (id_doc,id_etu),
	FOREIGN KEY (id_doc) REFERENCES Document(id_doc),
	FOREIGN KEY (id_etu) REFERENCES Etudiant(id));
CREATE TABLE Participe_enseignant(
	id_doc VARCHAR(30),
	id_enseignant INTEGER,
	PRIMARY KEY (id_doc,id_enseignant),
	FOREIGN KEY (id_doc) REFERENCES Document(id_doc),
	FOREIGN KEY (id_enseignant) REFERENCES Enseignant(id));
CREATE TABLE Participe_exterieur(
	id_doc VARCHAR(30),
	id_exterieur INTEGER,
	PRIMARY KEY (id_doc,id_exterieur),
	FOREIGN KEY (id_doc) REFERENCES Document(id_doc),
	FOREIGN KEY (id_exterieur) REFERENCES Exterieur(id));
CREATE TABLE Mot_cle(
	nom VARCHAR(20) PRIMARY KEY);
CREATE TABLE Licence(
	nom VARCHAR(15) PRIMARY KEY,
	description VARCHAR(200));
CREATE TABLE Protege(
	doc VARCHAR(30),
	licence VARCHAR(15),
	PRIMARY KEY (doc, licence),
	FOREIGN KEY (doc) REFERENCES Document(id_doc),
	FOREIGN KEY (licence) REFERENCES Licence(nom));
CREATE TABLE Traite(
	doc VARCHAR(30),
	mot VARCHAR(20),
	PRIMARY KEY (doc, mot),
	FOREIGN KEY (doc) REFERENCES Document(id_doc),
	FOREIGN KEY (mot) REFERENCES Mot_cle(nom));
