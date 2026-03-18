INSERT INTO aeroport (nom) VALUES
('Aeroport A1');

INSERT INTO hotel (nom, id_aeroport) VALUES
('Hotel 1', 1),
('Hotel 2', 1);

INSERT INTO hotel_hotel_distance (from_hotel_id, to_hotel_id, km) VALUES
(1, 2, 10.00);

INSERT INTO hotel_aeroport_distance (id_hotel, id_aeroport, km) VALUES
(1, 1, 50.00),
(2, 1, 50.00);

INSERT INTO consommation (description) VALUES
('Essence'),
('Diesel');

INSERT INTO voiture (immatriculation, nombre_place, id_consommation) VALUES
('Vehicule 1', 12, 2),
('Vehicule 2', 5, 1),
('Vehicule 3', 5, 2),
('Vehicule 4', 12, 1);

INSERT INTO parametre (vitesse_moyenne, temps_attente) VALUES
(50.0, 3);

INSERT INTO reservation (date_arriver, nbr_passager, id_client, Id_hotel, id_aeroport) VALUES
('2026-03-12 09:00:00', 7, 'C1', 1, 1),
('2026-03-12 09:00:00', 11, 'C2', 1, 1),
('2026-03-12 09:00:00', 3, 'C3', 1, 1),
('2026-03-12 09:00:00', 1, 'C4', 1, 1),
('2026-03-12 09:00:00', 2, 'C5', 1, 1),
('2026-03-12 09:00:00', 20, 'C6', 1, 1);

INSERT INTO token (uid) VALUES
(UUID()),
(UUID()),
(UUID());
