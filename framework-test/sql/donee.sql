
INSERT INTO aeroport (nom) VALUES
('Aeroport Ivato'),
('Aeroport Toliara'),
('Aeroport Antsiranana'),
('Aeroport Antsirabe');

INSERT INTO hotel (nom, id_aeroport) VALUES
('Colbert', 1),
('Novotel', 1),
('Ibis', 2),
('Lokanga', 3);

INSERT INTO reservation (date_arriver, nbr_passager, id_client, Id_hotel, id_aeroport) VALUES
('2026-02-05 00:55:00', 5, '4631', 3, 2),
('2026-02-05 01:00:00', 1,  '4394', 3, 2),
('2026-02-09 01:30:00', 2,  '8054', 1, 1);

INSERT INTO token (uid) VALUES
(UUID()),
(UUID()),
(UUID());



INSERT INTO hotel_hotel_distance (from_hotel_id, to_hotel_id, km) VALUES
(1, 2, 3.40),
(1, 3, 8.20),
(1, 4, 12.60),
(2, 3, 5.10),
(2, 4, 9.80),
(3, 4, 6.30);

INSERT INTO hotel_aeroport_distance (id_hotel, id_aeroport, km) VALUES
(1, 1, 14.50),
(1, 2, 31.20),
(1, 3, 49.80),
(1, 4, 28.40),
(2, 1, 16.20),
(2, 2, 29.90),
(2, 3, 52.10),
(2, 4, 30.70),
(3, 2, 7.80),
(3, 1, 22.60),
(3, 3, 44.30),
(3, 4, 25.90),
(4, 1, 35.10),
(4, 2, 26.80),
(4, 3, 5.40),
(4, 4, 33.20);

INSERT INTO consommation (description) VALUES
('Essence'),
('Diesel'),
('Electrique'),
('Hybride');

INSERT INTO voiture (immatriculation, nombre_place, id_consommation) VALUES
('1234 TAA', 20, 1),
('5678 TBB', 10, 2),
('9012 TCC', 15, 1),
('3456 TDD', 2, 2),
('7890 TEE', 5, 1);

INSERT INTO parametre (vitesse_moyenne, temps_attente) VALUES
(50.0, 10);

SELECT * FROM aeroport;
SELECT * FROM hotel;
SELECT * FROM reservation;
SELECT * FROM token;
SELECT * FROM hotel_hotel_distance;
SELECT * FROM hotel_aeroport_distance;
SELECT * FROM consommation;
SELECT * FROM voiture;
SELECT * FROM parametre;
