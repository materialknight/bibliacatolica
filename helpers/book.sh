#!/bin/bash

#* Regularización de comillas y de tres puntos:

sed --in-place \
   -e 's/[“”]/"/g' \
   -e 's/[«»]/*/g' \
   -e "s/[‘’]/'/g" \
   -e 's/…/.../g' \
   "$1"

#* Colecta de referencias a notas:

matches="$(
   grep --perl-regexp --only-matching -- \
   '(?<=[^ ]\[)[0-9]+(?=\])|(?<=\[)[0-9]+(?=\][^ ])' \
   "$1"
)"

matches=($(echo "$matches"))

#* Detección de inconsistencias en la numeración de las referencias a notas, y formación del script sed de su renumeración:

sed_scripts=()
ref_num="${matches[0]}"
new_num=1

for match in "${matches[@]}"
do
   if (( match != ref_num ))
   then
      echo 'Error en la numeración de las referencias a notas!'
      echo "La referencia: $match"
      echo "debería ser: $ref_num"
      echo "Desháganse los cambios (Ctrl + Z), corríjase manualmente el error, y vuélvase a correr este script."
      exit 1
   fi

   sed_scripts+=('-e' "s/\[$match\]/[[$new_num]](#n-$new_num){:#rn-$new_num}/g")
   (( ++ ref_num ))
   (( ++ new_num ))
done

echo "Total de referencias: ${#matches[@]}"
echo "Rango original de referencias: ${matches[1]} - ${matches[-1]}"

#* Renumeración:

sed --in-place "${sed_scripts[@]}" -- "$1"

#* Espaciado alrededor de las referencias a notas:

sed --in-place --regexp-extended \
   -e 's/([^0-9 ])(\[\[[0-9]+\]\])/\1 \2/g' \
   -e 's/(rn-[0-9]+\})([^:;,. ])/\1 \2/g' \
   "$1"

#* Formateo de los epígrafes y encabezados de cada capítulo:

declare -A book_map_C=([GÉNESIS]='Génesis' [ÉXODO]='Éxodo' [LEVÍTICO]='Levítico' [NÚMEROS]='Números' [DEUTERONOMIO]='Deuteronomio' [JOSUÉ]='Josué' [JUECES]='Jueces' [1 SAMUEL]='1 Samuel' [2 SAMUEL]='2 Samuel' [1 REYES]='1 Reyes' [2 REYES]='2 Reyes' [1 CRÓNICAS]='1 Crónicas' [2 CRÓNICAS]='2 Crónicas' [ESDRAS]='Esdras' [NEHEMÍAS]='Nehemías' [TOBÍAS]='Tobías' [ESTER]='Ester' [1 MACABEOS]='1 Macabeos' [2 MACABEOS]='2 Macabeos' [SALMOS]='Salmos' [PROVERBIOS]='Proverbios' [CANTAR DE LOS CANTARES]='Cantar de los Cantares' [SABIDURÍA]='Sabiduría' [ECLESIÁSTICO]='Eclesiástico' [ISAÍAS]='Isaías' [JEREMÍAS]='Jeremías' [LAMENTACIONES]='Lamentaciones' [BARUC]='Baruc' [EZEQUIEL]='Ezequiel' [DANIEL]='Daniel' [OSEAS]='Oseas' [JOEL]='Joel' [AMÓS]='Amós' [JONÁS]='Jonás' [MIQUEAS]='Miqueas' [NAHÚM]='Nahúm' [HABACUC]='Habacuc' [SOFONÍAS]='Sofonías' [AGEO]='Ageo' [ZACARÍAS]='Zacarías' [MALAQUÍAS]='Malaquías' [MATEO]='Mateo' [MARCOS]='Marcos' [LUCAS]='Lucas' [1 JUAN]='1 Juan' [JUAN]='Juan' [HECHOS]='Hechos' [ROMANOS]='Romanos' [1 CORINTIOS]='1 Corintios' [2 CORINTIOS]='2 Corintios' [GÁLATAS]='Gálatas' [EFESIOS]='Efesios' [FILIPENSES]='Filipenses' [COLOSENSES]='Colosenses' [1 TESALONICENSES]='1 Tesalonicenses' [2 TESALONICENSES]='2 Tesalonicenses' [1 TIMOTEO]='1 Timoteo' [2 TIMOTEO]='2 Timoteo' [TITO]='Tito' [HEBREOS]='Hebreos' [SANTIAGO]='Santiago' [1 PEDRO]='1 Pedro' [2 PEDRO]='2 Pedro' [APOCALIPSIS]='Apocalipsis' [RUT]='Rut' [JUDIT]='Judit' [JOB]='Job' [ECLESIASTÉS]='Eclesiastés')

unset sed_scripts
sed_scripts=()

if grep -quiet '^[IVX]\+\.' "$1"
then
   for uppercase_book in "${!book_map_C[@]}"
   do
      sed_scripts+=('-e' "s/^${uppercase_book} ([0-9]+)/### ${book_map_C[${uppercase_book}]} [\1](#c\1) {#c\1}\n/g")
   done

   sed --in-place --regexp-extended \
      -e 's/^([IVX]+\.) (.+)/## \1 \L\u\2\n/g' \
      "${sed_scripts[@]}" \
      -e '14,$ s/^[A-Za-zÁÉÍÓÚÑáéíóúñ¿¡].+/#### &\n/g' \
      "$1"
else
   for uppercase_book in "${!book_map_C[@]}"
   do
      sed_scripts+=("-e" "s/^${uppercase_book} ([0-9]+)/## ${book_map_C[${uppercase_book}]} [\1](#c\1) {#c\1}\n/g")
   done

   sed --in-place --regexp-extended \
      "${sed_scripts[@]}" \
      -e '14,$ s/^[A-Za-zÁÉÍÓÚÑáéíóúñ¿¡].+/### &\n/g' \
      "$1"
fi

#* Formateo de los versículos:

sed --in-place --regexp-extended \
   -e 's/^([0-9]+)([^ ])/[\1](#c??-v\1){:#c??-v\1} \2/g' \
   -e 's/ ([0-9]+)([^ ])/\n\n[\1](#c??-v\1){:#c??-v\1} \2/g' \
   "$1"

#* Detección de inconsistencias en la numeración de los versículos:

unset matches sed_scripts

matches="$(
   grep --perl-regexp --only-matching -- \
   '^\[[0-9]+(?=\]\(#)' \
   "$1"
)"

matches=($(echo "$matches"))

sed_scripts=()
verse_num=1

for match in "${matches[@]}"
do
   match="${match/#\[}"

   if (( match != verse_num ))
   then
      verse_num=1

      if (( match != verse_num ))
      then
         echo 'Error en la numeración de los versículos!'
         echo "El versículo: $match"
         echo "debería ser: $verse_num"
         echo "Desháganse los cambios (Ctrl + Z), corríjase manualmente el error, y vuélvase a correr este script."
         exit 1
      fi
   fi

   # sed_scripts+=('-e' "s/^$match/[$match](#c??-v$match){:#c??-v$match}/g")
   (( ++ verse_num ))
done

#* Formateo de los versículos:

# sed --in-place "${sed_scripts[@]}" -- "$1"
