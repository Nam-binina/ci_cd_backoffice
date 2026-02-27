
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

INSERT INTO reservation (date_arriver, nbr_passager, id_client, Id_hotel) VALUES
('2026-02-05 00:01:00', 11, '4631', 3),
('2026-02-05 23:55:00', 1,  '4394', 3),
('2026-02-09 10:17:00', 2,  '8054', 1),
('2026-02-01 15:25:00', 4,  '1432', 2),
('2026-01-28 07:11:00', 4,  '7861', 1),
('2026-01-28 07:45:00', 5,  '3308', 1),
('2026-02-28 08:25:00', 13, '4484', 2),
('2026-02-28 13:00:00', 8,  '9687', 2),
('2026-02-15 13:00:00', 7,  '6302', 1),
('2026-02-18 22:55:00', 1,  '8640', 4);

INSERT INTO token (uid) VALUES
(UUID()),
(UUID()),
(UUID());



INSERT INTO distance (from_hotel_id, to_hotel_id, km) VALUES
(1, 2, 3.40),
(1, 3, 8.20),
(1, 4, 12.60),
(2, 3, 5.10),
(2, 4, 9.80),
(3, 4, 6.30);

SELECT * FROM aeroport;
SELECT * FROM hotel;
SELECT * FROM reservation;
SELECT * FROM token;
SELECT * FROM distance;
