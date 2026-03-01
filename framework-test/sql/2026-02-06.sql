SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS reservation;
DROP TABLE IF EXISTS hotel;
SET FOREIGN_KEY_CHECKS=1;

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


