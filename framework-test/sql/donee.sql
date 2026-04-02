-- =============================================================
-- JEU DE DONNÉES DE VALIDATION DES RÈGLES D'ASSIGNATION AUTO
-- =============================================================
-- Règles couvertes :
-- 1) Fenêtre de groupe = heure_dispo véhicule -> heure_dispo + TA
-- 2) Si aucune réservation dans la fenêtre, on attend la prochaine réservation
-- 3) Priorité aux non-assignés, puis règles classiques sur les nouveaux
-- 4) Tri réservations par nbr_passager DESC
-- 5) Choix voiture = capacité minimale suffisante (>=), priorité Diesel, puis aléatoire
-- 6) Remplissage immédiat des places restantes dans la même voiture
-- 7) Calcul trajet optimum + distance + heure retour avec vitesse_moyenne

INSERT INTO aeroport (nom) VALUES
('Aeroport A1');

INSERT INTO hotel (nom, id_aeroport) VALUES
('Hotel 1', 1),
('Hotel 2', 1),
('Hotel 3', 1);

-- Distances hôtel <-> aéroport
INSERT INTO hotel_aeroport_distance (id_hotel, id_aeroport, km) VALUES
(1, 1, 20.00),
(2, 1, 12.00),
(3, 1, 18.00);

-- Distances hôtel <-> hôtel (sens unique par paire)
INSERT INTO hotel_hotel_distance (from_hotel_id, to_hotel_id, km) VALUES
(1, 2, 20.00),
(1, 3, 15.00),
(2, 3, 19.00);


INSERT INTO consommation (description) VALUES
('Essence'),
('Diesel');

-- Parc voitures : doublons de capacité pour tester Diesel + aléatoire
-- + heure_disponibilite pour tester les fenêtres TA basées sur disponibilité
INSERT INTO voiture (immatriculation, nombre_place, id_consommation, heure_disponibilite) VALUES
('vehicule1',12, 1, '00:00:00'),
('vehicule2', 7, 2, '08:35:00'),
('vehicule3', 15, 2, '08:35:00'),
('vehicule4', 12 , 2, '10:00:00');


-- Paramètres : vitesse pour heure retour, TA=30 min pour les groupes
INSERT INTO parametre (vitesse_moyenne, temps_attente) VALUES
(30.0, 30);

-- =============================================================
-- Réservations du 19/03/2026
-- =============================================================
-- Fenêtre basée sur disponibilité :
--   - Véhicules dispo dès 08:00 mais aucune réservation avant 09:00
--   - La fenêtre 08:00 -> 08:30 est vide, donc on attend 09:00
-- GROUPE 1 (09:00 -> 09:30)
-- - Cas remplissage : 10 + 5 + 3 dans une 12 places
-- - Cas priorité Diesel : capacité minimale 8 pour la réservation de 7
-- GROUPE 2 (09:30 -> 10:00)
-- - Cas non assignée : 20 passagers (aucune voiture >=20)
-- GROUPE 3 (10:40 -> 11:10)
-- - Cas trajet multi-hôtels + calcul retour

INSERT INTO reservation (date_arriver, nbr_passager, id_client, id_hotel, id_aeroport) VALUES
('2026-04-01 10:20:00', 7,  'C007', 2, 1),
('2026-04-01 08:00:00', 26,  'C001', 1, 1),
('2026-04-01 08:15:00', 6,  'C002', 2, 1),
('2026-04-01 09:45:00', 8, 'C003', 1, 1),
('2026-04-01 09:20:00', 12,  'C004', 2, 1),
('2026-04-01 14:00:00', 18, 'C005', 3, 1),
('2026-04-01 16:20:00', 12,  'C006', 3, 1);

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

