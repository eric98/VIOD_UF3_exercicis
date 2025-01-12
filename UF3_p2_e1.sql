-- == PREPARACIÓ ==
DROP DATABASE IF EXISTS hyrule;
CREATE DATABASE hyrule;
USE hyrule;

CREATE TABLE herois (
	id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	nom VARCHAR(25),
	edat INT UNSIGNED
);

CREATE TABLE mascares (
	id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	nom VARCHAR(25),
	color VARCHAR(15)
);

CREATE TABLE armes (
	id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	nom VARCHAR(25),
	poder INT UNSIGNED
);

INSERT INTO herois (nom,edat) VALUES  ('superman', 352), ('spiderman', 21);
INSERT INTO mascares (nom, color) VALUES ('majora', 'marró'), ('rupies', 'verd');
INSERT INTO armes (nom, poder) VALUES ('espasa mestra', 100), ('arc', 40);

-- >> Comprovació
SHOW DATABASES;
SHOW TABLES;
DESCRIBE herois;
DESCRIBE mascares;
DESCRIBE armes;

-- == TASQUES A FER ==
-- a) Amb les taules mysql.user i mysql.tables_priv crea una consulta per a 
-- que et retorni els privilegis dels usuaris sobre les taules de la BD hyrule
-- que tens dins SGBD.
SELECT mysql.user.user,
	mysql.user.host,
	mysql.tables_priv.Db,
	mysql.tables_priv.Table_name,
	mysql.tables_priv.Table_priv,
	mysql.tables_priv.Column_priv
	FROM mysql.tables_priv
	JOIN mysql.user
	ON mysql.user.user = mysql.tables_priv.User
	WHERE mysql.tables_priv.Db = 'hyrule';

SELECT u.user,
	u.host,
	p.Db,
	p.Table_name,
	p.Table_priv,
	p.Column_priv
	FROM mysql.tables_priv AS p
	JOIN mysql.user AS u
	ON u.user = p.User
	WHERE p.Db = 'hyrule';

-- b) Amb la taula views de la base de dades information_schema consulta la 
-- definició de les vistes creades al SGBD. Pensa que abans hauràs de crear 
-- una vista o vistes sobre alguna de les taules de la BD hyrule.
-- Creem una vista
CREATE VIEW hyrule.heroisjoves AS
	SELECT nom, edat FROM hyrule.herois
	WHERE edat < 18;

-- Comprovació
SELECT * FROM information_schema.views WHERE TABLE_SCHEMA = 'hyrule' AND TABLE_NAME = 'heroisjoves'\G
	
-- c) Consulta el nombre de files que té cada taula de la base de dades hyrule.
SELECT TABLE_SCHEMA,TABLE_NAME,TABLE_ROWS FROM information_schema.tables WHERE TABLE_SCHEMA='hyrule';

-- d) Mostra les columnes de la taula armes de la base de dades hyrule.
SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME FROM information_schema.COLUMNS WHERE TABLE_NAME = 'armes' AND TABLE_SCHEMA = 'hyrule';

-- Curiositat: consulta SELECT a la taula information_schema.COLUMNS simulant el resultat de la comanda DESCRIBE
SELECT COLUMN_NAME AS 'Field',
	COLUMN_TYPE AS 'Type',
	IS_NULLABLE AS 'Null',
	COLUMN_KEY AS 'Key',
	COLUMN_DEFAULT AS 'Default',
	EXTRA AS 'Extra'
	FROM information_schema.COLUMNS
	WHERE TABLE_SCHEMA = 'hyrule'
		AND TABLE_NAME = 'armes';
