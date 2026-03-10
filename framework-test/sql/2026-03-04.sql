-- Suppression de la colonne TA de reservation (si elle existe)
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
