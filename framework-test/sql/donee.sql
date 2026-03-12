INSERT INTO aeroport (nom) VALUES
('Aeroport A1'),
('Aeroport A2');

INSERT INTO hotel (nom, id_aeroport) VALUES
('Hotel 1', 2),
('Hotel 2', 2),
('Hotel 3', 2),
('Hotel 4', 2);

INSERT INTO hotel_hotel_distance (from_hotel_id, to_hotel_id, km) VALUES
(1, 2, 6.00),
(1, 3, 4.00),
(1, 4, 7.00),
(2, 3, 9.00),
(2, 4, 3.00),
(3, 4, 5.00);

INSERT INTO hotel_aeroport_distance (id_hotel, id_aeroport, km) VALUES
(1, 2, 10.00),
(2, 2, 20.00),
(3, 2, 8.00),
(4, 2, 15.00),
(1, 1, 30.00),
(2, 1, 28.00),
(3, 1, 26.00),
(4, 1, 24.00);

INSERT INTO consommation (description) VALUES
('Essence'),
('Diesel');

INSERT INTO voiture (immatriculation, nombre_place, id_consommation) VALUES
('1111 AAA', 5, 1),
('2222 BBB', 5, 2),
('3333 CCC', 10, 2),
('4444 DDD', 2, 1),
('5555 EEE', 6, 1),
('666 FFF', 6, 2);

INSERT INTO parametre (vitesse_moyenne, temps_attente) VALUES
(50.0, 10);

INSERT INTO reservation (date_arriver, nbr_passager, id_client, Id_hotel, id_aeroport) VALUES
('2026-02-10 08:00:00', 4, 'C1', 1, 2),
('2026-02-10 08:05:00', 1, 'C2', 3, 2),
('2026-02-10 08:20:00', 5, 'C3', 2, 2),
('2026-02-10 08:35:00', 5, 'C4', 4, 2);

INSERT INTO token (uid) VALUES
(UUID()),
(UUID()),
(UUID());
