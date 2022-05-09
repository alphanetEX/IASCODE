#!/bin/bash
[ ! -f .env ] || export $(grep -v '^#' .env | xargs)
source /opt/tp/scripts/general_print.sh
unset query[3]


function tercer_lunes {
MES=$1
# Calculo el tercer lunes del mes
for D in 01 02 03 04 05 06; do
	[ "`date --date \"$ANIO-$MES-$D\" +'%w'`" -eq 1 ] && DIA="$ANIO-$MES-$D"
done
FTL=`date --date "$DIA 14 days" +'%d/%m/%Y'`
}


funcion esLaborable(){
#!/bin/bash
[ ! -f .env ] || export $(grep -v '^#' .env | xargs)
#stable
mysql -u root -p${PASS_MYSQL_ROOT} feriados << EOF && mv /var/lib/mysql-files/results.csv $PWD/
SELECT
feriados.fecha,
tipo_feriado.tipo,
feriados.titulo FROM
tipo_feriado INNER JOIN
feriados
ON tipo_feriado.id_tferiado = feriados.id_tferiado
WHERE feriados.fecha = "$1"
INTO OUTFILE '/var/lib/mysql-files/results.csv'
FIELDS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY '\"'
LINES TERMINATED BY '\r\n';
EOF

query[0]=$(sed -r 's/\"(.*)\"/\1/' <<< $(cut -d ';' -f1 results.csv))
query[1]=$(sed -r 's/\"(.*)\"/\1/' <<< $(cut -d ';' -f2 results.csv))
query[2]=$(sed -r 's/\"(.*)\"/\1/' <<< $(cut -d ';' -f3 results.csv))

[[ -f ${query[0]} && -f ${query[1]} && -f ${query[2]} ]] && "" || echo "${query[1]}" "${query[2]}"

}

esLaborable $1



