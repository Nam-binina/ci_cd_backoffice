-- Ajout de l'heure de disponibilite pour les voitures
SET @has_heure_disponibilite := (
    SELECT COUNT(*)
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'voiture'
      AND COLUMN_NAME = 'heure_disponibilite'
);

SET @sql_add_heure_disponibilite := IF(
    @has_heure_disponibilite = 0,
    'ALTER TABLE voiture ADD COLUMN heure_disponibilite TIME NULL',
    'SELECT 1'
);

PREPARE stmt_add_heure_disponibilite FROM @sql_add_heure_disponibilite;
EXECUTE stmt_add_heure_disponibilite;
DEALLOCATE PREPARE stmt_add_heure_disponibilite;
