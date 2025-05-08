#!/bin/bash

#* Regularización de comillas y de tres puntos:

sed -i -E \
   -e 's/[“”]/"/g' \
   -e 's/[«»]/*/g' \
   -e "s/[‘’]/'/g" \
   -e 's/…/.../g' \
   "$1"

#* Formateo de las referencias a los comentarios, y de los versículos:

sed -i -E \
   -e 's/([^0-9 ])(\[[0-9]+\])/\1 \2/g' \
   -e 's/(\[[0-9]+\])([^:;,.])/\1 \2/g' \
   -e 's/ \[([0-9]+)\]/ [[\1]](#n-\1){:#rn-\1}/g' \
   -e 's/ ?([0-9]+)([A-Za-zÁÉÍÓÚÑáéíóúñ\[])/\n\n[\1](#c?-v\1){:#c?-v\1} \2/g' \
   "$1"

MANY_CHAPTERS_BOOKS='Génesis|Éxodo|Levítico|Números|Deuteronomio|Josué|Jueces|1 Samuel|2 Samuel|1 Reyes|2 Reyes|1 Crónicas|2 Crónicas|Esdras|Nehemías|Tobías|Ester|1 Macabeos|2 Macabeos|Salmos|Proverbios|Cantar de los Cantares|Sabiduría|Eclesiástico|Isaías|Jeremías|Lamentaciones|Baruc|Ezequiel|Daniel|Oseas|Joel|Amós|Jonás|Miqueas|Nahúm|Habacuc|Sofonías|Ageo|Zacarías|Malaquías|Mateo|Marcos|Lucas|1 Juan|Juan|Hechos|Romanos|1 Corintios|2 Corintios|Gálatas|Efesios|Filipenses|Colosenses|1 Tesalonicenses|2 Tesalonicenses|1 Timoteo|2 Timoteo|Tito|Hebreos|Santiago|1 Pedro|2 Pedro|Apocalipsis|Rut|Judit|Job|Eclesiastés'

declare -A BOOK_MAP_B=([GÉNESIS]='Génesis' [ÉXODO]='Éxodo' [LEVÍTICO]='Levítico' [NÚMEROS]='Números' [DEUTERONOMIO]='Deuteronomio' [JOSUÉ]='Josué' [JUECES]='Jueces' [1 SAMUEL]='1 Samuel' [2 SAMUEL]='2 Samuel' [1 REYES]='1 Reyes' [2 REYES]='2 Reyes' [1 CRÓNICAS]='1 Crónicas' [2 CRÓNICAS]='2 Crónicas' [ESDRAS]='Esdras' [NEHEMÍAS]='Nehemías' [TOBÍAS]='Tobías' [ESTER]='Ester' [1 MACABEOS]='1 Macabeos' [2 MACABEOS]='2 Macabeos' [SALMOS]='Salmos' [PROVERBIOS]='Proverbios' [CANTAR DE LOS CANTARES]='Cantar de los Cantares' [SABIDURÍA]='Sabiduría' [ECLESIÁSTICO]='Eclesiástico' [ISAÍAS]='Isaías' [JEREMÍAS]='Jeremías' [LAMENTACIONES]='Lamentaciones' [BARUC]='Baruc' [EZEQUIEL]='Ezequiel' [DANIEL]='Daniel' [OSEAS]='Oseas' [JOEL]='Joel' [AMÓS]='Amós' [JONÁS]='Jonás' [MIQUEAS]='Miqueas' [NAHÚM]='Nahúm' [HABACUC]='Habacuc' [SOFONÍAS]='Sofonías' [AGEO]='Ageo' [ZACARÍAS]='Zacarías' [MALAQUÍAS]='Malaquías' [MATEO]='Mateo' [MARCOS]='Marcos' [LUCAS]='Lucas' [1 JUAN]='1 Juan' [JUAN]='Juan' [HECHOS]='Hechos' [ROMANOS]='Romanos' [1 CORINTIOS]='1 Corintios' [2 CORINTIOS]='2 Corintios' [GÁLATAS]='Gálatas' [EFESIOS]='Efesios' [FILIPENSES]='Filipenses' [COLOSENSES]='Colosenses' [1 TESALONICENSES]='1 Tesalonicenses' [2 TESALONICENSES]='2 Tesalonicenses' [1 TIMOTEO]='1 Timoteo' [2 TIMOTEO]='2 Timoteo' [TITO]='Tito' [HEBREOS]='Hebreos' [SANTIAGO]='Santiago' [1 PEDRO]='1 Pedro' [2 PEDRO]='2 Pedro' [APOCALIPSIS]='Apocalipsis' [RUT]='Rut' [JUDIT]='Judit' [JOB]='Job' [ECLESIASTÉS]='Eclesiastés')

SED_SCRIPTS=()

if grep -q '^[IVX]' "$1"
then

   for UPPERCASE_BOOK in "${!BOOK_MAP_B[@]}"
   do
      SED_SCRIPTS+=("-e" "s/^${UPPERCASE_BOOK} ([0-9]+)/### ${BOOK_MAP_B[${UPPERCASE_BOOK}]} [\1](#c\1) {#c\1}/g")
   done

   sed -i -E \
      -e 's/^([IVX]+\.) (.+)/## \1 \L\u\2/g' \
      "${SED_SCRIPTS[@]}" \
      -e 's/^[A-Za-zÁÉÍÓÚÑáéíóúñ].+/#### &/g' \
      "$1"

else

   for UPPERCASE_BOOK in "${!BOOK_MAP_B[@]}"
   do
      SED_SCRIPTS+=("-e" "s/^${UPPERCASE_BOOK} ([0-9]+)/## ${BOOK_MAP_B[${UPPERCASE_BOOK}]} [\1](#c\1) {#c\1}/g")
   done

   sed -i -E \
      "${SED_SCRIPTS[@]}" \
      -e 's/^[A-Za-zÁÉÍÓÚÑáéíóúñ].+/### &/g' \
      "$1"

fi


   # -e 's/([A-Za-zÁÉÍÓÚÑáéíóúñ])(\[[0-9]+\])/\1 [/g' \
   # -e 's/([A-Za-zÁÉÍÓÚÑáéíóúñ])\[/\1 [/g' \


# [[17]](#n-17){:#rn-17}
echo '¡Hecho!'
