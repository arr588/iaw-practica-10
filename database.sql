DROP DATABASE IF EXISTS db_wordpress;
CREATE DATABASE db_wordpress CHARSET utf8mb4;
USE db_wordpress;

CREATE USER IF NOT EXISTS 'db_user'@'%';
SET PASSWORD FOR 'db_user'@'%' = 'db_password';
GRANT ALL PRIVILEGES ON db_wordpress.* TO 'db_user'@'%';
