-- Table distance entre deux hôtels
CREATE TABLE distance (
	id INT AUTO_INCREMENT PRIMARY KEY,
	from_hotel_id INT NOT NULL,
	to_hotel_id INT NOT NULL,
	km DECIMAL(8,2) NOT NULL,
	CONSTRAINT fk_distance_from_hotel FOREIGN KEY (from_hotel_id) REFERENCES hotel(Id_hotel),
	CONSTRAINT fk_distance_to_hotel FOREIGN KEY (to_hotel_id) REFERENCES hotel(Id_hotel),
	CONSTRAINT uq_distance_pair UNIQUE (from_hotel_id, to_hotel_id)
);

-- Données exemples (distance entre hôtels)


