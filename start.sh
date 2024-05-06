#!/bin/bash
sudo service mysql start

read -p  "Vols crear la base de dades? (s/N)" dbcreation

case "$dbcreation" in
	[yYsSsiyes] )
	echo "ok, creare la base de dades de nou"
	echo "Contrasenya de l'usuari root de MySQL"
	mysql -u root -proot -vv <<EOF || { echo ""; exit 1; }

	## Comprobar si existeix la base de dades vueproject y eliminar-la
	DROP DATABASE IF EXISTS pyproject;

	## Crear la base de dades vueproject
	CREATE DATABASE pyproject;

	## Utilitzar la base de dades vueproject
	USE pyproject;

	## Comprobar si existeix l'usuari gerard y eliminar-lo
	DROP USER IF EXISTS 'gerard'@'localhost';

	## Afegir l'usuari gerard amb contrasenya gerard y tots els permisos a la base de dades vueproject
	CREATE USER 'gerard'@'localhost' IDENTIFIED WITH mysql_native_password BY 'gerard';
	GRANT ALL PRIVILEGES ON pyproject.* TO 'gerard'@'localhost';
	flush privileges;

	## Afegir la taula users i totes les columnes corresponents
	CREATE TABLE temperature (
	    id INT NOT NULL AUTO_INCREMENT,
	    temperature VARCHAR(255) NOT NULL,
	    humidity VARCHAR(255) NOT NULL,
	    date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	    PRIMARY KEY (id)
	);

	INSERT INTO temperature (temperature,humidity) VALUES ('25','40');
	INSERT INTO temperature (temperature,humidity) VALUES ('28','48');
	INSERT INTO temperature (temperature,humidity) VALUES ('30','56');
	INSERT INTO temperature (temperature,humidity) VALUES ('34','62');
	INSERT INTO temperature (temperature,humidity) VALUES ('40','70');
	INSERT INTO temperature (temperature,humidity) VALUES ('38','61');
	INSERT INTO temperature (temperature,humidity) VALUES ('28','50');
EOF
	;;
	[nNnoNO] ) 
		echo "ok, no creare la base de dades"
	;;
esac

# Iniciar el servidor vite i api
sudo npm install
sudo npm run dev
