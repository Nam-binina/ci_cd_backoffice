CREATE TABLE hotel(
   Id_hotel INT AUTO_INCREMENT,
   nom VARCHAR(50)  NOT NULL,
   PRIMARY KEY(Id_hotel)
);

CREATE TABLE reservation(
   Id_reservation INT AUTO_INCREMENT,
   date_arriver DATETIME NOT NULL,
   nbr_passager INT NOT NULL,
   id_client VARCHAR(20)  NOT NULL,
   Id_hotel INT NOT NULL,
   PRIMARY KEY(Id_reservation),
   FOREIGN KEY(Id_hotel) REFERENCES hotel(Id_hotel)
);

-- Si la table existe déjà avec id_client VARCHAR(4), appliquer ceci :
-- ALTER TABLE reservation MODIFY id_client VARCHAR(20) NOT NULL;

-- Données exemples pour la table hotel
INSERT INTO hotel (nom) VALUES
('Colbert'),
('Novotel'),
('Ibis'),
('Lokanga');

-- Données exemples pour la table reservation
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

