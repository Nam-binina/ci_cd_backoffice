-- Supprimer l'ancienne FK hotel -> aeroport si elle existe
SET @fk_hotel_aeroport := (
   SELECT CONSTRAINT_NAME
   FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
   WHERE TABLE_SCHEMA = DATABASE()
     AND TABLE_NAME = 'hotel'
     AND COLUMN_NAME = 'id_aeroport'
     AND REFERENCED_TABLE_NAME = 'aeroport'
   LIMIT 1
);
SET @sql_drop_fk := IF(
   @fk_hotel_aeroport IS NULL,
   'SELECT 1',
   CONCAT('ALTER TABLE hotel DROP FOREIGN KEY `', @fk_hotel_aeroport, '`')
);
PREPARE stmt_drop_fk FROM @sql_drop_fk;
EXECUTE stmt_drop_fk;
DEALLOCATE PREPARE stmt_drop_fk;

-- Supprimer la colonne id_aeroport si elle existe (pour repartir proprement)
SET @has_id_aeroport := (
   SELECT COUNT(*)
   FROM INFORMATION_SCHEMA.COLUMNS
   WHERE TABLE_SCHEMA = DATABASE()
     AND TABLE_NAME = 'hotel'
     AND COLUMN_NAME = 'id_aeroport'
);
SET @sql_drop_col := IF(
   @has_id_aeroport = 0,
   'SELECT 1',
   'ALTER TABLE hotel DROP COLUMN id_aeroport'
);
PREPARE stmt_drop_col FROM @sql_drop_col;
EXECUTE stmt_drop_col;
DEALLOCATE PREPARE stmt_drop_col;

-- Créer/recréer la table aeroport
SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS aeroport;
SET FOREIGN_KEY_CHECKS=1;
CREATE TABLE aeroport(
   id INT AUTO_INCREMENT,
   nom VARCHAR(100) NOT NULL,
   PRIMARY KEY(id)
);

-- Ajouter la colonne id_aeroport à la table hotel
ALTER TABLE hotel ADD COLUMN id_aeroport INT;

-- Ajouter la contrainte de clé étrangère
ALTER TABLE hotel ADD CONSTRAINT fk_hotel_aeroport FOREIGN KEY(id_aeroport) REFERENCES aeroport(id);

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
