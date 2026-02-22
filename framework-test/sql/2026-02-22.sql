-- Créer la table aeroport
CREATE TABLE aeroport(
   id INT AUTO_INCREMENT,
   nom VARCHAR(100) NOT NULL,
   PRIMARY KEY(id)
);

-- Ajouter la colonne id_aeroport à la table hotel
ALTER TABLE hotel ADD COLUMN id_aeroport INT;

-- Ajouter la contrainte de clé étrangère
ALTER TABLE hotel ADD FOREIGN KEY(id_aeroport) REFERENCES aeroport(id);

-- Données exemples pour la table aeroport
INSERT INTO aeroport (nom) VALUES
('Aeroport Ivato'),
('Aeroport Toliara'),
('Aeroport Antsiranana'),
('Aeroport Antsirabe');

-- Mettre à jour les hôtels avec leurs aéroports associés
UPDATE hotel SET id_aeroport = 1 WHERE nom = 'Colbert';
UPDATE hotel SET id_aeroport = 1 WHERE nom = 'Novotel';
UPDATE hotel SET id_aeroport = 2 WHERE nom = 'Ibis';
UPDATE hotel SET id_aeroport = 3 WHERE nom = 'Lokanga';

-- Vérifier les données
SELECT * FROM aeroport;
SELECT * FROM hotel;
