DROP TABLE IF EXISTS hotel_aeroport_distance;

CREATE TABLE hotel_aeroport_distance (
	id INT AUTO_INCREMENT PRIMARY KEY,
	id_hotel INT NOT NULL,
	id_aeroport INT NOT NULL,
	km DECIMAL(8,2) NOT NULL,
	CONSTRAINT fk_had_hotel FOREIGN KEY (id_hotel) REFERENCES hotel(Id_hotel),
	CONSTRAINT fk_had_aeroport FOREIGN KEY (id_aeroport) REFERENCES aeroport(id),
	CONSTRAINT uq_had_pair UNIQUE (id_hotel, id_aeroport)
);

-- Update table reservation: ajouter id_aeroport
SET @has_reservation_id_aeroport := (
	SELECT COUNT(*)
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_SCHEMA = DATABASE()
	  AND TABLE_NAME = 'reservation'
	  AND COLUMN_NAME = 'id_aeroport'
);
SET @sql_add_reservation_id_aeroport := IF(
	@has_reservation_id_aeroport = 0,
	'ALTER TABLE reservation ADD COLUMN id_aeroport INT',
	'SELECT 1'
);
PREPARE stmt_add_reservation_id_aeroport FROM @sql_add_reservation_id_aeroport;
EXECUTE stmt_add_reservation_id_aeroport;
DEALLOCATE PREPARE stmt_add_reservation_id_aeroport;

SET @has_fk_reservation_aeroport := (
	SELECT COUNT(*)
	FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
	WHERE TABLE_SCHEMA = DATABASE()
	  AND TABLE_NAME = 'reservation'
	  AND COLUMN_NAME = 'id_aeroport'
	  AND REFERENCED_TABLE_NAME = 'aeroport'
);
SET @sql_add_fk_reservation_aeroport := IF(
	@has_fk_reservation_aeroport = 0,
	'ALTER TABLE reservation ADD CONSTRAINT fk_reservation_aeroport FOREIGN KEY (id_aeroport) REFERENCES aeroport(id)',
	'SELECT 1'
);
PREPARE stmt_add_fk_reservation_aeroport FROM @sql_add_fk_reservation_aeroport;
EXECUTE stmt_add_fk_reservation_aeroport;
DEALLOCATE PREPARE stmt_add_fk_reservation_aeroport;

