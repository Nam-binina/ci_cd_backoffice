-- Table hotel_hotel_distance entre deux hôtels
DROP TABLE IF EXISTS assignation;
DROP TABLE IF EXISTS hotel_hotel_distance;
DROP TABLE IF EXISTS voiture;
DROP TABLE IF EXISTS consommation;

CREATE TABLE hotel_hotel_distance (
	id INT AUTO_INCREMENT PRIMARY KEY,
	from_hotel_id INT NOT NULL,
	to_hotel_id INT NOT NULL,
	km DECIMAL(8,2) NOT NULL,
	CONSTRAINT fk_distance_from_hotel FOREIGN KEY (from_hotel_id) REFERENCES hotel(Id_hotel),
	CONSTRAINT fk_distance_to_hotel FOREIGN KEY (to_hotel_id) REFERENCES hotel(Id_hotel),
	CONSTRAINT uq_distance_pair UNIQUE (from_hotel_id, to_hotel_id)
);

-- Données exemples (hotel_hotel_distance entre hôtels)



-- Table consommation
CREATE TABLE consommation (
	id INT AUTO_INCREMENT PRIMARY KEY,
	description VARCHAR(255) NOT NULL
);

-- Table voiture
CREATE TABLE voiture (
	id INT AUTO_INCREMENT PRIMARY KEY,
	immatriculation VARCHAR(50) NOT NULL UNIQUE,
	nombre_place INT NOT NULL,
	id_consommation INT NOT NULL,
	vitesse_moyenne DECIMAL(5,2),
	CONSTRAINT fk_voiture_consommation FOREIGN KEY (id_consommation) REFERENCES consommation(id)
);

-- Modification de la table reservation pour ajouter le temps d'attente
SET @has_ta := (
	SELECT COUNT(*)
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_SCHEMA = DATABASE()
	  AND TABLE_NAME = 'reservation'
	  AND COLUMN_NAME = 'TA'
);
SET @sql_add_ta := IF(
	@has_ta = 0,
	"ALTER TABLE reservation ADD COLUMN TA INT COMMENT 'Temps d''attente en minutes'",
	'SELECT 1'
);
PREPARE stmt_add_ta FROM @sql_add_ta;
EXECUTE stmt_add_ta;
DEALLOCATE PREPARE stmt_add_ta;

-- Table assignation (liaison réservation <-> voiture)
CREATE TABLE assignation (
	id INT AUTO_INCREMENT PRIMARY KEY,
	id_reservation INT NOT NULL,
	id_voiture INT NOT NULL,
	CONSTRAINT fk_assignation_reservation FOREIGN KEY (id_reservation) REFERENCES reservation(Id_reservation),
	CONSTRAINT fk_assignation_voiture FOREIGN KEY (id_voiture) REFERENCES voiture(id)
);

