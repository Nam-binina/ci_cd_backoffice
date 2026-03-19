-- Ajout de la distance totale du trajet pour les assignations
SET @has_distance_totale := (
    SELECT COUNT(*)
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'assignation'
      AND COLUMN_NAME = 'distance_totale'
);

SET @sql_add_distance_totale := IF(
    @has_distance_totale = 0,
    'ALTER TABLE assignation ADD COLUMN distance_totale DOUBLE NULL',
    'SELECT 1'
);

PREPARE stmt_add_distance_totale FROM @sql_add_distance_totale;
EXECUTE stmt_add_distance_totale;
DEALLOCATE PREPARE stmt_add_distance_totale;
