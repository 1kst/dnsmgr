-- Third-party TCP API check upgrade for existing DNMgr databases.
-- Run this against the DNMgr database when upgrading an existing install.

SET @has_detect_source := (
  SELECT COUNT(*)
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'dnsmgr_dmtask'
    AND COLUMN_NAME = 'detect_source'
);

SET @sql := IF(
  @has_detect_source = 0,
  'ALTER TABLE `dnsmgr_dmtask` ADD COLUMN `detect_source` tinyint(1) NOT NULL DEFAULT 0 AFTER `checktype`',
  'SELECT ''dnsmgr_dmtask.detect_source already exists'' AS message'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
