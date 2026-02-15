CREATE TABLE carburant(
   Id_carburant INT AUTO_INCREMENT,
   nom VARCHAR(50)  NOT NULL,
   PRIMARY KEY(Id_carburant)
);

CREATE TABLE vehicule(
   Id_vehicule INT AUTO_INCREMENT,
   capacite INT NOT NULL,
   Id_carburant INT NOT NULL,
   PRIMARY KEY(Id_vehicule),
   FOREIGN KEY(Id_carburant) REFERENCES carburant(Id_carburant)
);

CREATE TABLE token(
   Id_token INT AUTO_INCREMENT,
   guid VARCHAR(50)  NOT NULL,
   date_expiration DATETIME NOT NULL,
   PRIMARY KEY(Id_token),
   UNIQUE(guid)
);

INSERT INTO carburant (nom) VALUES
('Essence'),
('Diesel'),
('Electrique'),
('Hybride');
