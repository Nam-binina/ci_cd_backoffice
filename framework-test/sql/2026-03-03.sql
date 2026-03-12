CREATE TABLE IF NOT EXISTS parametre(
   Id_parametre INT AUTO_INCREMENT,
   vitesse_moyenne DOUBLE NOT NULL,
   temps_attente INT NOT NULL,
   PRIMARY KEY(Id_parametre)
);



-- Suppression des anciennes colonnes spécifiques par voiture/réservation
SET @has_voiture_vitesse := (
   SELECT COUNT(*)
   FROM INFORMATION_SCHEMA.COLUMNS
   WHERE TABLE_SCHEMA = DATABASE()
     AND TABLE_NAME = 'voiture'
     AND COLUMN_NAME = 'vitesse_moyenne'
);
SET @sql_drop_voiture_vitesse := IF(
   @has_voiture_vitesse > 0,
   'ALTER TABLE voiture DROP COLUMN vitesse_moyenne',
   'SELECT 1'
);
PREPARE stmt_drop_voiture_vitesse FROM @sql_drop_voiture_vitesse;
EXECUTE stmt_drop_voiture_vitesse;
DEALLOCATE PREPARE stmt_drop_voiture_vitesse;

SET @has_reservation_ta := (
   SELECT COUNT(*)
   FROM INFORMATION_SCHEMA.COLUMNS
   WHERE TABLE_SCHEMA = DATABASE()
     AND TABLE_NAME = 'reservation'
     AND COLUMN_NAME = 'TA'
);
SET @sql_drop_reservation_ta := IF(
   @has_reservation_ta > 0,
   'ALTER TABLE reservation DROP COLUMN TA',
   'SELECT 1'
);
PREPARE stmt_drop_reservation_ta FROM @sql_drop_reservation_ta;
EXECUTE stmt_drop_reservation_ta;
DEALLOCATE PREPARE stmt_drop_reservation_ta;
