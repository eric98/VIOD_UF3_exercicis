#!/bin/bash
# Pròposit: Crear una còpia de seguretat d'una base de dades a un directori específic
# Ús: ./backupBD.sh usuari password host base_de_dades desti

# 0. Comprovem si rebem els paràmetres
# Si no rebem els paràmetres que esperem, parem l'execució informant de l'error
if [ $# -ne 5 ]; then
	echo "[ERROR] El nombre de paràmetres no és correcte"
	echo "Ús: $0 usuari password host base_de_dades desti" # Utilitzem $0 per a que sempre agafi el nom de l'script
	exit 1 # -> Finaltiza l'execució indicant un error
	# exit 0 -> Finalitza l'execució indicant 0 errors
fi

usuari=$1 		# Assignem el 1r paràmetre a la variable usuari
contrasenya=$2	 	# Assignem el 2n paràmetre a la variable contrasenya
host=$3			# Assignem el 3r paràmetre a la variable host
base_de_dades=$4	# Assignem el 4t paràmetre a la variable base_de_dades
desti=$5		# Assignem el 5é paràmetre a la variable desti

# 1. Preparem les variables rebudes per paràmetre
# Si el directori destí no existeix, parem l'execució informant de l'error
if [ ! -d $desti ]; then
	echo "[ERROR] La ruta ${desti} no existeix"
	exit 1
fi

# 2. Fem la còpia de seguretat amb mysqldump
minut_actual=$(date +"%Y%m%d%H%M") # Calculem el minut actual amb el format "any|mes|dia|hora|minut" per a identificar cada backup segons el minut en el que s'ha realitzat
fitxer_backup="${base_de_dades}_${minut_actual}.sql"

# Si hi ha hagut un error en generar el backup, parem l'execució informant de l'error
if mysqldump -u $usuari -p$contrasenya $base_de_dades > $fitxer_backup; then
	echo "[INFO] Còpia de segurat generada correctament a ${fitxer_backup}"
else
	echo "[ERROR] Hi ha hagut algun problema al generar la còpia de seguretat"
	exit 1
fi

# 3. Comprimim la còpia de seguretat amb gzip
fitxer_backup_comprimit="${fitxer_backup}.gz" # Fitxer que es generarà en fer un gzip sobre $fitxer_backup
if gzip $fitxer_backup; then
	echo "[INFO] Arxiu ${fitxer_backup} comprimit correctament a ${fitxer_backup_comprimit}"
else
	echo "[ERROR] Error en comprimir l'arxiu ${fitxer_backup}"
	exit 1
fi

# 4. Movem la còpia de seguretat comprimida al directori de destí amb mv
# Per a aquesta versió de l'script, necessitem que la destinació final del comprimit sigui diferent de la current path
# L'alternativa i millora seria comprovar si la destinació és diferent al current path, i executar el mv només si hi ha necessitat de moure el fitxer
destinacio_backup_comprimit="${desti}/${fitxer_backup_comprimit}"

# Si hi ha hagut un error en moure l'arxiu comprimit, parem l'execució informant de l'error
if mv "$fitxer_backup_comprimit" "$destinacio_backup_comprimit"; then
	echo "[INFO] Arxiu guardat a ${destinacio_backup_comprimit}"
else
	echo "[ERROR] Error en moure l'arxiu a ${desti}"
	exit 1
fi

# Finalitza el programa sense errors ✔✔
exit 0
