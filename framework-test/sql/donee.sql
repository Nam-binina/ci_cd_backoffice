-- =============================================================
-- JEU DE DONNÉES DE VALIDATION DES RÈGLES D'ASSIGNATION AUTO
-- =============================================================
-- Règles couvertes :
-- 1) Groupement par TA (temps_attente) à partir de la 1ère réservation du groupe
-- 2) Tri réservations par nbr_passager DESC
-- 3) Choix voiture = capacité minimale suffisante (>=), priorité Diesel, puis aléatoire
-- 4) Remplissage immédiat des places restantes dans la même voiture
-- 5) Réservations non assignées si aucune voiture suffisante
-- 6) Départ de TOUTES les voitures d'un groupe = dernière date ARRIVÉE ASSIGNÉE du groupe
-- 7) Calcul trajet optimum + distance + heure retour avec vitesse_moyenne

INSERT INTO aeroport (nom) VALUES
('Aeroport A1');

INSERT INTO hotel (nom, id_aeroport) VALUES
('Hotel 1', 1),
('Hotel 2', 1);

-- Distances hôtel <-> aéroport
INSERT INTO hotel_aeroport_distance (id_hotel, id_aeroport, km) VALUES
(1, 1, 90.00),
(2, 1, 35.00);

-- Distances hôtel <-> hôtel (sens unique par paire)
INSERT INTO hotel_hotel_distance (from_hotel_id, to_hotel_id, km) VALUES
(1, 2, 60.00);


INSERT INTO consommation (description) VALUES
('Essence'),
('Diesel');

-- Parc voitures : doublons de capacité pour tester Diesel + aléatoire
INSERT INTO voiture (immatriculation, nombre_place, id_consommation) VALUES
('vehicule1',5, 2),
('vehicule2', 5, 1),
('vehicule3', 12, 2),
('vehicule4', 9, 2),
('vehicule5', 12, 1);

-- Paramètres : vitesse pour heure retour, TA=30 min pour les groupes
INSERT INTO parametre (vitesse_moyenne, temps_attente) VALUES
(50.0, 30);

-- =============================================================
-- Réservations du 12/03/2026
-- =============================================================
-- GROUPE 1 (08:00 -> 08:30)
-- - Cas remplissage : 10 prend une 12 places, puis +2 dans la même voiture
-- - Cas priorité Diesel : capacité minimale 8 pour la réservation de 7
-- - Départ groupe attendu : 08:30 (dernière réservation assignée du groupe)

-- GROUPE 2 (09:20 -> 09:50)
-- - Cas non assignée : 20 passagers (aucune voiture >=20)
-- - Départ groupe attendu : 09:45 (09:50 n'est PAS assignée)

-- GROUPE 3 (10:40 -> 11:10)
-- - Cas trajet multi-hôtels + calcul retour

INSERT INTO reservation (date_arriver, nbr_passager, id_client, id_hotel, id_aeroport) VALUES
-- Groupe 1
('2026-03-19 09:00:00', 7, 'C001', 1, 1),
('2026-03-19 08:00:00', 20,  'C002', 2, 1),
('2026-03-19 09:10:00', 3,  'C003', 1, 1),
('2026-03-19 09:15:00', 10,  'C004', 1, 1),
('2026-03-19 09:20:00', 5,  'C005', 1, 1),
('2026-03-19 13:30:00', 12,  'C006', 1, 1);
-- ('2026-03-12 08:30:00', 7,  'C004', 4, 1),

-- -- Groupe 2
-- ('2026-03-12 09:20:00', 6,  'C005', 5, 1),
-- ('2026-03-12 09:45:00', 4,  'C006', 2, 1),
-- ('2026-03-12 09:50:00', 20, 'C007', 1, 1),

-- -- Groupe 3
-- ('2026-03-12 10:40:00', 9,  'C008', 3, 1),
-- ('2026-03-12 10:50:00', 3,  'C009', 4, 1),
-- ('2026-03-12 11:00:00', 1,  'C010', 5, 1);

INSERT INTO token (uid) VALUES
(UUID()),
(UUID()),
(UUID());

