DROP TABLE Etudiant;/
DROP TABLE UV;/
DROP TABLE Doc;/
DROP TYPE T_Doc;/
DROP TYPE T_UV;/
DROP TYPE ListeRefEtudiant;/
DROP TYPE RefEtudiant;/
DROP TYPE T_Etudiant;/

CREATE OR REPLACE TYPE T_UV AS OBJECT(
    code_uv VARCHAR(4),
    titre VARCHAR(100)
);
/
CREATE TABLE UV OF T_UV(
    PRIMARY KEY (code_uv)
);
/
CREATE OR REPLACE TYPE T_Etudiant AS OBJECT(
    id_etu INTEGER(3),
    nom VARCHAR(20),
    prenom VARCHAR(20)
);
/
CREATE TABLE Etudiant OF T_Etudiant(
    PRIMARY KEY (id_etu)
);
/
CREATE OR REPLACE TYPE RefEtudiant AS OBJECT(
    refEtudiant REF T_Etudiant
);
/
CREATE OR REPLACE TYPE ListeRefEtudiant AS TABLE OF RefEtudiant;
/
CREATE TYPE T_Doc AS OBJECT(
    id_doc VARCHAR(20),
    titre VARCHAR(50),
    date_publication DATE,
    annee INTEGER(4),
    semestre VARCHAR(9),
    etat VARCHAR(7),
    uv REF T_UV,
    auteurs ListeRefEtudiant
);
/
CREATE TABLE Doc OF T_Doc(
    PRIMARY KEY (id_doc),
    SCOPE FOR (uv) IS UV,
    CHECK (semestre IN ('Automne','Printemps')),
    CHECK (etat IN ('actif','archive'))
)
NESTED TABLE auteurs STORE AS ntListeAuteurs;

--On notera que le choix d'implémentation de auteurs en collection de
--références à des OID nous empêche dans l'implémentation sous Oracle de 
--définir le SCOPE FOR et donc de contraindre l'intégrité référentielle à 
--la table Etudiant. Dans le cas présent ce n'est pas préjudiciable dans 
--la mesure où seule la table Etudiant contient des objets T_Etudiant.

DECLARE
    etu1 REF T_Etudiant;
    etu2 REF T_Etudiant;
    etu3 REF T_Etudiant;
    uv1 REF T_UV;
    uv2 REF T_UV;
BEGIN
	INSERT INTO UV(code_uv, titre) VALUES ('NA17','Conception de bases de données relationnelles et non relationnelles (autonomie)');
	INSERT INTO UV(code_uv, titre) VALUES ('NF16','Algorithmique et structure de données');
	INSERT INTO Etudiant(id_etu,nom,prenom) VALUES (1, 'Marlow', 'Justine');
	INSERT INTO Etudiant(id_etu,nom,prenom) VALUES (2, 'Houlliez', 'Solène');
	INSERT INTO Etudiant(id_etu,nom,prenom) VALUES (3, 'Meurou', 'Thomas');
    
    SELECT REF(E) INTO etu1 FROM Etudiant E WHERE id_etu=1;
    SELECT REF(E) INTO etu2 FROM Etudiant E WHERE id_etu=2;
    SELECT REF(E) INTO etu3 FROM Etudiant E WHERE id_etu=3;
    SELECT REF(U) INTO uv1 FROM UV U WHERE code_uv='NA17';
    SELECT REF(U) INTO uv2 FROM UV U WHERE code_uv='NF16';
    
    INSERT INTO Doc(id_doc, titre, date_publication, annee, semestre, etat, uv, auteurs) VALUES (
        '2017-A-NA17-Note',
        'Note de clarification de projet',
        to_date('10092017', 'DDMMYYYY'),
        2017,
        'Automne',
        'actif',
        uv1,
        ListeRefEtudiant(RefEtudiant(etu1),RefEtudiant(etu2),RefEtudiant(etu3))
    );
    INSERT INTO Doc(id_doc, titre, date_publication, annee, semestre, etat, uv, auteurs) VALUES (
        '2017-A-NF16-Rapport',
        'Rapport TP Noté',
        to_date('09112017', 'DDMMYYYY'),
        2017,
        'Automne',
        'actif',
        uv2,
        ListeRefEtudiant(RefEtudiant(etu1))
    );
END;
/

SELECT d.id_doc, d.titre, d.date_publication, d.annee, d.semestre, d.etat,
       d.uv.code_uv, d.uv.titre,
       a.RefEtudiant.id_etu, a.RefEtudiant.nom, a.RefEtudiant.prenom
FROM Doc d, TABLE(d.auteurs) a;