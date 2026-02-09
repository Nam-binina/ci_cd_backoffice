CREATE TABLE hotel(
   Id_hotel INT AUTO_INCREMENT,
   nom VARCHAR(50)  NOT NULL,
   PRIMARY KEY(Id_hotel)
);

CREATE TABLE reservation(
   Id_reservation INT AUTO_INCREMENT,
   date_arriver DATETIME NOT NULL,
   nbr_passager INT NOT NULL,
   id_client VARCHAR(4)  NOT NULL,
   Id_hotel INT NOT NULL,
   PRIMARY KEY(Id_reservation),
   FOREIGN KEY(Id_hotel) REFERENCES hotel(Id_hotel)
);
