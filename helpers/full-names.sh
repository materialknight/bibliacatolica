#!/bin/bash

#* Regularización de comillas y de tres puntos:

sed -i -E \
   -e 's/[“”]/"/g' \
   -e 's/[«»]/*/g' \
   -e "s/[‘’]/'/g" \
   -e 's/…/.../g' \
   "$1"

#* El texto entre 2 asteriscos nunca debería terminar en coma ni en dos puntos. En tales casos, el siguente código mueve el signo de puntuación afuera del texto inter-asteriscal. Por ejemplo: *"Término a definir":* -> *"Término a definir"*:

sed -i -E \
   -e 's/\*([A-Za-záéíóúüñÁÉÍÓÚÜÑ" ]+)([:,])\*/*\1*\2/g' \
   "$1"

#* Regularizaciones:
#* "y ss." -> "ss."
#* "versículo 19" -> "v. 19"
#* "versículos 19 ss." -> "vv. 19 ss."
#* "capítulo 20" -> "cap. 20"
#* "capítulos 21 s." -> "caps. 21 s."

sed -i -E \
   -e 's/y ss\./ss\./g' \
   -e 's/versículo ([0-9]+)/v. \1/g' \
   -e 's/versículos ([0-9]+)/vv. \1/g' \
   -e 's/capítulo ([0-9]+)/cap. \1/g' \
   -e 's/capítulos ([0-9]+)/caps. \1/g' \
   "$1"

#* Conversión en hipervínculos de algunos pasajes aislados (que no indican libro pero sí capítulo) precedidos por "(V/v)éase" o "(C/c)f." o entre paréntesis (reemplácese manualmente "book" por el libro correcto):

sed -i -E \
   -e 's/(Cf\.|cf\.|Véase|véase) ([0-9]+), ([0-9]+)/\1 [\2, \3](#c\2-v\3)/g' \
   -e 's/\(([0-9]+), ([0-9]+)([0-9 s\.\-]*)\)/([\1, \2](book#c\1-v\2)\3)/g' \
   "$1"

#* Conversión de versículos precedidos de v(v). Reemplácese manualmente "?" por el número de capítulo:

sed -i -E \
   -e 's/\bv\. ([0-9]+)/v. [\1](#c?-v\1)/g' \
   -e 's/\bvv\. ([0-9]+)([0-9 s\.\-]*), ([0-9]+)([0-9 s\.\-]*) y ([0-9]+)([0-9 s\.\-]*)/vv. [\1](#c?-v\1)\2, [\3](#c?-v\3)\4 y [\5](#c?-v\5)\6/g' \
   -e 's/\bvv\. ([0-9]+)([0-9 s\.\-]*) y ([0-9]+)([0-9 s\.\-]*)/vv. [\1](#c?-v\1)\2 y [\3](#c?-v\3)\4/g' \
   -e 's/\bvv\. ([0-9]+)([0-9 s\.\-]*)/vv. [\1](#c?-v\1)\2/g' \
   "$1"

#* Remoción de coma (,) antes de "cap(s).":

sed -i -E \
   -e 's/, (caps?\.)/ \1/g' \
   "$1"

#* El código a continuación reemplaza las abreviaturas por el nombre completo (Gn. -> Génesis), y los nombres alternativos, por el nombre usual (I Paralipómenos -> Crónicas).

#* Libros sin abreviatura: Rut, Judit, Job, Eclesiastés.

#* Libros con nombres alternativos:
#*    I Reyes -> 1 Samuel
#*    II Reyes -> 2 Samuel
#*    III Reyes -> 1 Reyes
#*    IV Reyes -> 2 Reyes
#*    I Paralipómenos -> 1 Crónicas
#*    II Paralipómenos -> 2 Crónicas

#* Las abreviaturas de 1 Juan, 2 Juan y 3 Juan (las epístolas) deben procesarse antes que la de Juan (el evangelio):

sed -i -E \
   -e 's/\bGn\. ([0-9]+,)/Génesis \1/g' \
   -e 's/\bEx\. ([0-9]+,)/Éxodo \1/g' \
   -e 's/\bLv\. ([0-9]+,)/Levítico \1/g' \
   \
   -e 's/\bNúm\. ([0-9]+,)/Números \1/g' \
   -e 's/\bNm\. ([0-9]+,)/Números \1/g' \
   \
   -e 's/\bDt\. ([0-9]+,)/Deuteronomio \1/g' \
   -e 's/\bJos\. ([0-9]+,)/Josué \1/g' \
   -e 's/\bJc\. ([0-9]+,)/Jueces \1/g' \
   \
   -e 's/\b1 Sam\. ([0-9]+,)/1 Samuel \1/g' \
   -e 's/\bI Reyes ([0-9]+,)/1 Samuel \1/g' \
   \
   -e 's/\b2 Sam\. ([0-9]+,)/2 Samuel \1/g' \
   -e 's/\bII Reyes ([0-9]+,)/2 Samuel \1/g' \
   \
   -e 's/\b1 R\. ([0-9]+,)/1 Reyes \1/g' \
   -e 's/\bIII Reyes ([0-9]+,)/1 Reyes \1/g' \
   \
   -e 's/\b2 R\. ([0-9]+,)/2 Reyes \1/g' \
   -e 's/\bIV Reyes ([0-9]+,)/2 Reyes \1/g' \
   \
   -e 's/\b1 Cro\. ([0-9]+,)/1 Crónicas \1/g' \
   -e 's/\bI Paralipómenos ([0-9]+,)/1 Crónicas \1/g' \
   \
   -e 's/\b2 Cro\. ([0-9]+,)/2 Crónicas \1/g' \
   -e 's/\bII Paralipómenos ([0-9]+,)/2 Crónicas \1/g' \
   \
   -e 's/\bEsd\. ([0-9]+,)/Esdras \1/g' \
   -e 's/\bNe\. ([0-9]+,)/Nehemías \1/g' \
   -e 's/\bTob\. ([0-9]+,)/Tobías \1/g' \
   -e 's/\bEst\. ([0-9]+,)/Ester \1/g' \
   \
   -e 's/\b1 Mac\. ([0-9]+,)/1 Macabeos \1/g' \
   -e 's/\bI Macabeos ([0-9]+,)/1 Macabeos \1/g' \
   \
   -e 's/\bII Mac\. ([0-9]+,)/2 Macabeos \1/g' \
   -e 's/\bII Macabeos ([0-9]+,)/2 Macabeos \1/g' \
   \
   -e 's/\bSal\. ([0-9]+,)/Salmo \1/g' \
   -e 's/\bPr\. ([0-9]+,)/Proverbios \1/g' \
   -e 's/\bCant\. ([0-9]+,)/Cantar de los Cantares \1/g' \
   -e 's/\bSb\. ([0-9]+,)/Sabiduría \1/g' \
   \
   -e 's/\bEclo\. ([0-9]+,)/Eclesiástico \1/g' \
   -e 's/\bSi\. ([0-9]+,)/Eclesiástico \1/g' \
   \
   -e 's/\bIs\. ([0-9]+,)/Isaías \1/g' \
   -e 's/\bJr\. ([0-9]+,)/Jeremías \1/g' \
   \
   -e 's/\bLam\. ([0-9]+,)/Lamentaciones \1/g' \
   -e 's/\bLm\. ([0-9]+,)/Lamentaciones \1/g' \
   \
   -e 's/\bBar\. ([0-9]+,)/Baruc \1/g' \
   -e 's/\bEz\. ([0-9]+,)/Ezequiel \1/g' \
   \
   -e 's/\bDan\. ([0-9]+,)/Daniel \1/g' \
   -e 's/\bDn\. ([0-9]+,)/Daniel \1/g' \
   \
   -e 's/\bOs\. ([0-9]+,)/Oseas \1/g' \
   -e 's/\bJl\. ([0-9]+,)/Joel \1/g' \
   -e 's/\bAm\. ([0-9]+,)/Amós \1/g' \
   -e 's/\bAb\. ([0-9]+)/Abdías \1/g' \
   -e 's/\bJon\. ([0-9]+,)/Jonás \1/g' \
   -e 's/\bMi\. ([0-9]+,)/Miqueas \1/g' \
   -e 's/\bNah\. ([0-9]+,)/Nahúm \1/g' \
   -e 's/\bHab\. ([0-9]+,)/Habacuc \1/g' \
   -e 's/\bSof\. ([0-9]+,)/Sofonías \1/g' \
   -e 's/\bAg\. ([0-9]+,)/Ageo \1/g' \
   -e 's/\bZa\. ([0-9]+,)/Zacarías \1/g' \
   -e 's/\bMal\. ([0-9]+,)/Malaquías \1/g' \
   \
   -e 's/\bMat\. ([0-9]+,)/Mateo \1/g' \
   -e 's/\bMt\. ([0-9]+,)/Mateo \1/g' \
   \
   -e 's/\bMarc\. ([0-9]+,)/Marcos \1/g' \
   -e 's/\bMc\. ([0-9]+,)/Marcos \1/g' \
   \
   -e 's/\bLc\. ([0-9]+,)/Lucas \1/g' \
   \
   -e 's/\b1 Jn\. ([0-9]+,)/1 Juan \1/g' \
   -e 's/\bI Jn\. ([0-9]+,)/1 Juan \1/g' \
   -e 's/\bI Juan ([0-9]+,)/1 Juan \1/g' \
   \
   -e 's/\b2 Jn\. ([0-9]+)/2 Juan \1/g' \
   -e 's/\bII Juan ([0-9]+)/2 Juan \1/g' \
   \
   -e 's/\b3 Jn\. ([0-9]+)/3 Juan \1/g' \
   -e 's/\bIII Juan ([0-9]+)/3 Juan \1/g' \
   \
   -e 's/\bJn\. ([0-9]+,)/Juan \1/g' \
   -e 's/\bHch\. ([0-9]+,)/Hechos \1/g' \
   \
   -e 's/\bRom\. ([0-9]+,)/Romanos \1/g' \
   -e 's/\bRm\. ([0-9]+,)/Romanos \1/g' \
   \
   -e 's/\b1 Co\. ([0-9]+,)/1 Corintios \1/g' \
   -e 's/\bI Corintios ([0-9]+,)/1 Corintios \1/g' \
   \
   -e 's/\b2 Co\. ([0-9]+,)/2 Corintios \1/g' \
   -e 's/\bII Corintios ([0-9]+,)/2 Corintios \1/g' \
   \
   -e 's/\bGa\. ([0-9]+,)/Gálatas \1/g' \
   -e 's/\bGal\. ([0-9]+,)/Gálatas \1/g' \
   -e 's/\bGál\. ([0-9]+,)/Gálatas \1/g' \
   \
   -e 's/\bEf\. ([0-9]+,)/Efesios \1/g' \
   \
   -e 's/\bFlp\. ([0-9]+,)/Filipenses \1/g' \
   -e 's/\bFil\. ([0-9]+,)/Filipenses \1/g' \
   \
   -e 's/\bCol\. ([0-9]+,)/Colosenses \1/g' \
   \
   -e 's/\b1 Ts\. ([0-9]+,)/1 Tesalonicenses \1/g' \
   -e 's/\bI Tesalonicenses ([0-9]+,)/1 Tesalonicenses \1/g' \
   \
   -e 's/\b2 Ts\. ([0-9]+,)/2 Tesalonicenses \1/g' \
   -e 's/\bII Tesalonicenses ([0-9]+,)/2 Tesalonicenses \1/g' \
   \
   -e 's/\b1 Tm\. ([0-9]+,)/1 Timoteo \1/g' \
   -e 's/\b1 Tim\. ([0-9]+,)/1 Timoteo \1/g' \
   -e 's/\bI Tim\. ([0-9]+,)/1 Timoteo \1/g' \
   -e 's/\bI Timoteo ([0-9]+,)/1 Timoteo \1/g' \
   \
   -e 's/\b2 Tm\. ([0-9]+,)/2 Timoteo \1/g' \
   -e 's/\bII Tim\. ([0-9]+,)/2 Timoteo \1/g' \
   -e 's/\bII Timoteo ([0-9]+,)/2 Timoteo \1/g' \
   \
   -e 's/\bTit\. ([0-9]+,)/Tito \1/g' \
   -e 's/\bTt\. ([0-9]+,)/Tito \1/g' \
   \
   -e 's/\bFlm\. ([0-9]+)/Filemón \1/g' \
   -e 's/\bHb\. ([0-9]+,)/Hebreos \1/g' \
   \
   -e 's/\bSt\. ([0-9]+,)/Santiago \1/g' \
   -e 's/\bSant\. ([0-9]+,)/Santiago \1/g' \
   \
   -e 's/\b1 Pe\. ([0-9]+,)/1 Pedro \1/g' \
   -e 's/\bI Pedro ([0-9]+,)/1 Pedro \1/g' \
   \
   -e 's/\b2 Pe\. ([0-9]+,)/2 Pedro \1/g' \
   -e 's/\bII Pedro ([0-9]+,)/2 Pedro \1/g' \
   \
   -e 's/\bJud\. ([0-9]+)/Judas \1/g' \
   \
   -e 's/\bAp\. ([0-9]+,)/Apocalipsis \1/g' \
   -e 's/\bApoc\. ([0-9]+,)/Apocalipsis \1/g' \
   "$1"

#* Remoción de "versículo(s)" y "v(v)." de los libros de 1 solo capítulo.

declare -A one_chapter_books=([Abdías]='abdias' [Filemón]=filemon [2 Juan]='2-juan' [3 Juan]='3-juan' [Judas]='Judas')

one_chap_books="$(IFS='|'; echo "${!one_chapter_books[*]}")"

sed -i -E \
   -e "s/\b(${one_chap_books}),? (v+\.|versículos?)/\1/g" \
   "$1"

#* Array asociativo - clave: libro, valor: libro para URL.

declare -A many_chapters_books=([Génesis]='genesis' [Éxodo]='exodo' [Levítico]='levitico' [Números]='numeros' [Deuteronomio]='deuteronomio' [Josué]='josue' [Jueces]='jueces' [1 Samuel]='1-samuel' [2 Samuel]='2-samuel' [1 Reyes]='1-reyes' [2 Reyes]='2-reyes' [1 Crónicas]='1-cronicas' [2 Crónicas]='2-cronicas' [Esdras]='esdras' [Nehemías]='nehemias' [Tobías]='tobias' [Ester]='ester' [1 Macabeos]='1-macabeos' [2 Macabeos]='2-macabeos' [Salmos]='salmos' [Proverbios]='proverbios' [Cantar de los Cantares]='cantar-de-los-cantares' [Sabiduría]='sabiduria' [Eclesiástico]='eclesiastico' [Isaías]='isaias' [Jeremías]='jeremias' [Lamentaciones]='lamentaciones' [Baruc]='baruc' [Ezequiel]='ezequiel' [Daniel]='daniel' [Oseas]='oseas' [Joel]='joel' [Amós]='amos' [Jonás]='jonas' [Miqueas]='miqueas' [Nahúm]='nahum' [Habacuc]='habacuc' [Sofonías]='sofonias' [Ageo]='ageo' [Zacarías]='zacarias' [Malaquías]='malaquias' [Mateo]='mateo' [Marcos]='marcos' [Lucas]='lucas' [1 Juan]='1-juan' [Juan]='juan' [Hechos]='hechos' [Romanos]='romanos' [1 Corintios]='1-corintios' [2 Corintios]='2-corintios' [Gálatas]='galatas' [Efesios]='efesios' [Filipenses]='filipenses' [Colosenses]='colosenses' [1 Tesalonicenses]='1-tesalonicenses' [2 Tesalonicenses]='2-tesalonicenses' [1 Timoteo]='1-timoteo' [2 Timoteo]='2-timoteo' [Tito]='tito' [Hebreos]='hebreos' [Santiago]='santiago' [1 Pedro]='1-pedro' [2 Pedro]='2-pedro' [Apocalipsis]='apocalipsis' [Rut]='rut' [Judit]='judit' [Job]='job' [Eclesiastés]='eclesiastes')

many_chaps_books="$(IFS='|'; echo "${!many_chapters_books[*]}")"

#* Creación de enlaces para los libros de un solo capítulo:

declare -a sed_scripts

for book in "${!one_chapter_books[@]}"
do
   sed_scripts+=('-e' "s/$book ([0-9]+)([0-9 s\.\-]*)/$book [\1](${one_chapter_books[$book]}#v\1)\2/g")
done

sed --in-place --regexp-extended \
   "${sed_scripts[@]}" \
   "$1"

#* Creación de enlaces para los libros de más de un capítulo:

unset sed_scripts
declare -a sed_scripts

sed_scripts+=('-e' 's/1 Juan ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/1 Juan [\1, \2](1-juan#c\1-v\2)\3; [\4, \5](1-juan#c\4-v\5)\6; [\7, \8](1-juan#c\7-v\8)\9/g')

sed_scripts+=('-e' 's/1 Juan ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/1 Juan [\1, \2](1-juan#c\1-v\2)\3; [\4, \5](1-juan#c\4-v\5)\6/g')

sed_scripts+=('-e' 's/1 Juan ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/1 Juan [\1, \2](1-juan#c\1-v\2)\3/g')

sed_scripts+=('-e' 's/Salmo ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Salmo [\1, \2](salmos#c\1-v\2)\3/g')


for book in "${!many_chapters_books[@]}"
do
   if [[ $book != '1 Juan' ]]
   then
      sed_scripts+=('-e' "s/$book ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/$book [\1, \2](${many_chapters_books[$book]}#c\1-v\2)\3; [\4, \5](${many_chapters_books[$book]}#c\4-v\5)\6; [\7, \8](${many_chapters_books[$book]}#c\7-v\8)\9/g")

      sed_scripts+=('-e' "s/$book ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/$book [\1, \2](${many_chapters_books[$book]}#c\1-v\2)\3; [\4, \5](${many_chapters_books[$book]}#c\4-v\5)\6/g")

      sed_scripts+=('-e' "s/$book ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/$book [\1, \2](${many_chapters_books[$book]}#c\1-v\2)\3/g")
   fi
done

sed --in-place --regexp-extended \
   "${sed_scripts[@]}" \
   "$1"

#* Creación de enlaces para los pasajes que indican libro y capítulo pero no versículo:

unset sed_scripts
declare -a sed_scripts

sed_scripts+=('-e' 's/1 Juan (caps?\.) ([0-9]+)([0-9 s\.\-]*)/1 Juan \1 [\2](1-juan#c\2)\3/g')

for book in "${!many_chapters_books[@]}"
do
   if [[ $book != '1 Juan' ]]
   then
      sed_scripts+=('-e' "s/$book (caps?\.) ([0-9]+)([0-9 s\.\-]*)/$book \1 [\2](${many_chapters_books[$book]}#c\2)\3/g")
   fi
done

sed --in-place --regexp-extended \
   "${sed_scripts[@]}" \
   "$1"

#* Colecta de notas explicativas:

matches="$(
   grep --extended-regexp --only-matching \
   '^[[0-9]+]' \
   "$1"
)"

matches=($(echo "$matches"))

#* Detección de inconsistencias en la numeración de las notas, y formación del script sed de su renumeración:

unset sed_scripts
declare -a sed_scripts

ref_num="${matches[0]//[\[\]]}"
new_num=1

for match in "${matches[@]}"
do
   match_num="${match//[\[\]]}"

   if (( match_num != ref_num ))
   then
      echo 'Error en la numeración de las notas!'
      echo "La nota: $match_num"
      echo "debería ser: $ref_num"
      echo "Desháganse los cambios (Ctrl + Z), corríjase manualmente el error, y vuélvase a correr este script."
      exit 1
   fi

   sed_scripts+=('-e' "s/\[$match_num\] ([0-9]+)( s+\.)?\.?/[[$new_num]](#rn-$new_num){:#n-$new_num} [?, \1](#c?-v\1)\2/g")
   (( ++ ref_num ))
   (( ++ new_num ))
done

echo "Total de notas: ${#matches[@]}"
echo "Rango original: ${matches[1]} - ${matches[-1]}"

#* Renumeración:

sed --in-place --regexp-extended \
   "${sed_scripts[@]}" \
   "$1"

# [[343]](#rn-343){:#n-343} [39, 9](#c39-v9) # para test
# echo '[300] 34' | sed -E -e 's/\[[0-9]+\] ([0-9]+)/[[1]](#rn-1){:#n-1} [?, \1](#c?-v\1)/g' #test

# ONE_CHAPTER_BOOKS='Abdías|Filemón|2 Juan|3 Juan|Judas'
# MANY_CHAPTERS_BOOKS='Génesis|Éxodo|Levítico|Números|Deuteronomio|Josué|Jueces|1 Samuel|2 Samuel|1 Reyes|2 Reyes|1 Crónicas|2 Crónicas|Esdras|Nehemías|Tobías|Ester|1 Macabeos|2 Macabeos|Salmos|Proverbios|Cantar de los Cantares|Sabiduría|Eclesiástico|Isaías|Jeremías|Lamentaciones|Baruc|Ezequiel|Daniel|Oseas|Joel|Amós|Jonás|Miqueas|Nahúm|Habacuc|Sofonías|Ageo|Zacarías|Malaquías|Mateo|Marcos|Lucas|1 Juan|Juan|Hechos|Romanos|1 Corintios|2 Corintios|Gálatas|Efesios|Filipenses|Colosenses|1 Tesalonicenses|2 Tesalonicenses|1 Timoteo|2 Timoteo|Tito|Hebreos|Santiago|1 Pedro|2 Pedro|Apocalipsis|Rut|Judit|Job|Eclesiastés'

#* Los libros de 1 solo capítulo (Abdías, Filemón, 2 Juan, 3 Juan, Judas) se citan diferente, sin el capítulo, por lo que no hay coma que separe el capítulo del versículo, como sí hay en las referencias a otros libros, por lo tanto, las regex arriba que buscan referencias de estos libros no llevan la coma final que sí llevan las demás; esa coma final se incluye en las demás regex simplemente para que sean más rígidas, reduciendo así la probabilidad de que este script reemplace texto que no debe.

#* Consecuentemente, los regex abajo que corresponden a los libros de 1 solo capítulo, no incluyen la parte del capítulo en el link generado.

#* Las referencias a 1 Juan, 2 Juan y 3 Juan (las epístolas) deben procesarse antes que las de Juan (el evangelio):

# sed -i -E \
#    -e 's/Génesis ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Génesis [\1, \2](genesis#c\1-v\2)\3; [\4, \5](genesis#c\4-v\5)\6; [\7, \8](genesis#c\7-v\8)\9/g' \
#    -e 's/Génesis ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Génesis [\1, \2](genesis#c\1-v\2)\3; [\4, \5](genesis#c\4-v\5)\6/g' \
#    -e 's/Génesis ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Génesis [\1, \2](genesis#c\1-v\2)\3/g' \
#    \
#    -e 's/Éxodo ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Éxodo [\1, \2](exodo#c\1-v\2)\3; [\4, \5](exodo#c\4-v\5)\6; [\7, \8](exodo#c\7-v\8)\9/g' \
#    -e 's/Éxodo ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Éxodo [\1, \2](exodo#c\1-v\2)\3; [\4, \5](exodo#c\4-v\5)\6/g' \
#    -e 's/Éxodo ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Éxodo [\1, \2](exodo#c\1-v\2)\3/g' \
#    \
#    -e 's/Levítico ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Levítico [\1, \2](levitico#c\1-v\2)\3; [\4, \5](levitico#c\4-v\5)\6; [\7, \8](levitico#c\7-v\8)\9/g' \
#    -e 's/Levítico ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Levítico [\1, \2](levitico#c\1-v\2)\3; [\4, \5](levitico#c\4-v\5)\6/g' \
#    -e 's/Levítico ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Levítico [\1, \2](levitico#c\1-v\2)\3/g' \
#    \
#    -e 's/Números ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Números [\1, \2](numeros#c\1-v\2)\3; [\4, \5](numeros#c\4-v\5)\6; [\7, \8](numeros#c\7-v\8)\9/g' \
#    -e 's/Números ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Números [\1, \2](numeros#c\1-v\2)\3; [\4, \5](numeros#c\4-v\5)\6/g' \
#    -e 's/Números ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Números [\1, \2](numeros#c\1-v\2)\3/g' \
#    \
#    -e 's/Deuteronomio ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Deuteronomio [\1, \2](deuteronomio#c\1-v\2)\3; [\4, \5](deuteronomio#c\4-v\5)\6; [\7, \8](deuteronomio#c\7-v\8)\9/g' \
#    -e 's/Deuteronomio ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Deuteronomio [\1, \2](deuteronomio#c\1-v\2)\3; [\4, \5](deuteronomio#c\4-v\5)\6/g' \
#    -e 's/Deuteronomio ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Deuteronomio [\1, \2](deuteronomio#c\1-v\2)\3/g' \
#    \
#    -e 's/Josué ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Josué [\1, \2](josue#c\1-v\2)\3; [\4, \5](josue#c\4-v\5)\6; [\7, \8](josue#c\7-v\8)\9/g' \
#    -e 's/Josué ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Josué [\1, \2](josue#c\1-v\2)\3; [\4, \5](josue#c\4-v\5)\6/g' \
#    -e 's/Josué ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Josué [\1, \2](josue#c\1-v\2)\3/g' \
#    \
#    -e 's/Jueces ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Jueces [\1, \2](jueces#c\1-v\2)\3; [\4, \5](jueces#c\4-v\5)\6; [\7, \8](jueces#c\7-v\8)\9/g' \
#    -e 's/Jueces ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Jueces [\1, \2](jueces#c\1-v\2)\3; [\4, \5](jueces#c\4-v\5)\6/g' \
#    -e 's/Jueces ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Jueces [\1, \2](jueces#c\1-v\2)\3/g' \
#    \
#    -e 's/Rut ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Rut [\1, \2](rut#c\1-v\2)\3; [\4, \5](rut#c\4-v\5)\6; [\7, \8](rut#c\7-v\8)\9/g' \
#    -e 's/Rut ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Rut [\1, \2](rut#c\1-v\2)\3; [\4, \5](rut#c\4-v\5)\6/g' \
#    -e 's/Rut ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Rut [\1, \2](rut#c\1-v\2)\3/g' \
#    \
#    -e 's/1 Samuel ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/1 Samuel [\1, \2](1-samuel#c\1-v\2)\3; [\4, \5](1-samuel#c\4-v\5)\6; [\7, \8](1-samuel#c\7-v\8)\9/g' \
#    -e 's/1 Samuel ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/1 Samuel [\1, \2](1-samuel#c\1-v\2)\3; [\4, \5](1-samuel#c\4-v\5)\6/g' \
#    -e 's/1 Samuel ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/1 Samuel [\1, \2](1-samuel#c\1-v\2)\3/g' \
#    \
#    -e 's/2 Samuel ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/2 Samuel [\1, \2](2-samuel#c\1-v\2)\3; [\4, \5](2-samuel#c\4-v\5)\6; [\7, \8](2-samuel#c\7-v\8)\9/g' \
#    -e 's/2 Samuel ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/2 Samuel [\1, \2](2-samuel#c\1-v\2)\3; [\4, \5](2-samuel#c\4-v\5)\6/g' \
#    -e 's/2 Samuel ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/2 Samuel [\1, \2](2-samuel#c\1-v\2)\3/g' \
#    \
#    -e 's/1 Reyes ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/1 Reyes [\1, \2](1-reyes#c\1-v\2)\3; [\4, \5](1-reyes#c\4-v\5)\6; [\7, \8](1-reyes#c\7-v\8)\9/g' \
#    -e 's/1 Reyes ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/1 Reyes [\1, \2](1-reyes#c\1-v\2)\3; [\4, \5](1-reyes#c\4-v\5)\6/g' \
#    -e 's/1 Reyes ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/1 Reyes [\1, \2](1-reyes#c\1-v\2)\3/g' \
#    \
#    -e 's/2 Reyes ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/2 Reyes [\1, \2](2-reyes#c\1-v\2)\3; [\4, \5](2-reyes#c\4-v\5)\6; [\7, \8](2-reyes#c\7-v\8)\9/g' \
#    -e 's/2 Reyes ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/2 Reyes [\1, \2](2-reyes#c\1-v\2)\3; [\4, \5](2-reyes#c\4-v\5)\6/g' \
#    -e 's/2 Reyes ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/2 Reyes [\1, \2](2-reyes#c\1-v\2)\3/g' \
#    \
#    -e 's/1 Crónicas ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/1 Crónicas [\1, \2](1-cronicas#c\1-v\2)\3; [\4, \5](1-cronicas#c\4-v\5)\6; [\7, \8](1-cronicas#c\7-v\8)\9/g' \
#    -e 's/1 Crónicas ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/1 Crónicas [\1, \2](1-cronicas#c\1-v\2)\3; [\4, \5](1-cronicas#c\4-v\5)\6/g' \
#    -e 's/1 Crónicas ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/1 Crónicas [\1, \2](1-cronicas#c\1-v\2)\3/g' \
#    \
#    -e 's/2 Crónicas ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/2 Crónicas [\1, \2](2-cronicas#c\1-v\2)\3; [\4, \5](2-cronicas#c\4-v\5)\6; [\7, \8](2-cronicas#c\7-v\8)\9/g' \
#    -e 's/2 Crónicas ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/2 Crónicas [\1, \2](2-cronicas#c\1-v\2)\3; [\4, \5](2-cronicas#c\4-v\5)\6/g' \
#    -e 's/2 Crónicas ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/2 Crónicas [\1, \2](2-cronicas#c\1-v\2)\3/g' \
#    \
#    -e 's/Esdras ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Esdras [\1, \2](esdras#c\1-v\2)\3; [\4, \5](esdras#c\4-v\5)\6; [\7, \8](esdras#c\7-v\8)\9/g' \
#    -e 's/Esdras ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Esdras [\1, \2](esdras#c\1-v\2)\3; [\4, \5](esdras#c\4-v\5)\6/g' \
#    -e 's/Esdras ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Esdras [\1, \2](esdras#c\1-v\2)\3/g' \
#    \
#    -e 's/Nehemías ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Nehemías [\1, \2](nehemias#c\1-v\2)\3; [\4, \5](nehemias#c\4-v\5)\6; [\7, \8](nehemias#c\7-v\8)\9/g' \
#    -e 's/Nehemías ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Nehemías [\1, \2](nehemias#c\1-v\2)\3; [\4, \5](nehemias#c\4-v\5)\6/g' \
#    -e 's/Nehemías ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Nehemías [\1, \2](nehemias#c\1-v\2)\3/g' \
#    \
#    -e 's/Tobías ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Tobías [\1, \2](tobias#c\1-v\2)\3; [\4, \5](tobias#c\4-v\5)\6; [\7, \8](tobias#c\7-v\8)\9/g' \
#    -e 's/Tobías ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Tobías [\1, \2](tobias#c\1-v\2)\3; [\4, \5](tobias#c\4-v\5)\6/g' \
#    -e 's/Tobías ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Tobías [\1, \2](tobias#c\1-v\2)\3/g' \
#    \
#    -e 's/Judit ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Judit [\1, \2](judit#c\1-v\2)\3; [\4, \5](judit#c\4-v\5)\6; [\7, \8](judit#c\7-v\8)\9/g' \
#    -e 's/Judit ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Judit [\1, \2](judit#c\1-v\2)\3; [\4, \5](judit#c\4-v\5)\6/g' \
#    -e 's/Judit ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Judit [\1, \2](judit#c\1-v\2)\3/g' \
#    \
#    -e 's/Ester ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Ester [\1, \2](ester#c\1-v\2)\3; [\4, \5](ester#c\4-v\5)\6; [\7, \8](ester#c\7-v\8)\9/g' \
#    -e 's/Ester ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Ester [\1, \2](ester#c\1-v\2)\3; [\4, \5](ester#c\4-v\5)\6/g' \
#    -e 's/Ester ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Ester [\1, \2](ester#c\1-v\2)\3/g' \
#    \
#    -e 's/1 Macabeos ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/1 Macabeos [\1, \2](1-macabeos#c\1-v\2)\3; [\4, \5](1-macabeos#c\4-v\5)\6; [\7, \8](1-macabeos#c\7-v\8)\9/g' \
#    -e 's/1 Macabeos ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/1 Macabeos [\1, \2](1-macabeos#c\1-v\2)\3; [\4, \5](1-macabeos#c\4-v\5)\6/g' \
#    -e 's/1 Macabeos ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/1 Macabeos [\1, \2](1-macabeos#c\1-v\2)\3/g' \
#    \
#    -e 's/2 Macabeos ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/2 Macabeos [\1, \2](2-macabeos#c\1-v\2)\3; [\4, \5](2-macabeos#c\4-v\5)\6; [\7, \8](2-macabeos#c\7-v\8)\9/g' \
#    -e 's/2 Macabeos ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/2 Macabeos [\1, \2](2-macabeos#c\1-v\2)\3; [\4, \5](2-macabeos#c\4-v\5)\6/g' \
#    -e 's/2 Macabeos ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/2 Macabeos [\1, \2](2-macabeos#c\1-v\2)\3/g' \
#    \
#    -e 's/Job ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Job [\1, \2](job#c\1-v\2)\3; [\4, \5](job#c\4-v\5)\6; [\7, \8](job#c\7-v\8)\9/g' \
#    -e 's/Job ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Job [\1, \2](job#c\1-v\2)\3; [\4, \5](job#c\4-v\5)\6/g' \
#    -e 's/Job ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Job [\1, \2](job#c\1-v\2)\3/g' \
#    \
#    -e 's/Salmos ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Salmos [\1, \2](salmos#c\1-v\2)\3; [\4, \5](salmos#c\4-v\5)\6; [\7, \8](salmos#c\7-v\8)\9/g' \
#    -e 's/Salmos ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Salmos [\1, \2](salmos#c\1-v\2)\3; [\4, \5](salmos#c\4-v\5)\6/g' \
#    -e 's/Salmo ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Salmo [\1, \2](salmos#c\1-v\2)\3/g' \
#    \
#    -e 's/Proverbios ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Proverbios [\1, \2](proverbios#c\1-v\2)\3; [\4, \5](proverbios#c\4-v\5)\6; [\7, \8](proverbios#c\7-v\8)\9/g' \
#    -e 's/Proverbios ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Proverbios [\1, \2](proverbios#c\1-v\2)\3; [\4, \5](proverbios#c\4-v\5)\6/g' \
#    -e 's/Proverbios ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Proverbios [\1, \2](proverbios#c\1-v\2)\3/g' \
#    \
#    -e 's/Eclesiastés ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Eclesiastés [\1, \2](eclesiastes#c\1-v\2)\3; [\4, \5](eclesiastes#c\4-v\5)\6; [\7, \8](eclesiastes#c\7-v\8)\9/g' \
#    -e 's/Eclesiastés ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Eclesiastés [\1, \2](eclesiastes#c\1-v\2)\3; [\4, \5](eclesiastes#c\4-v\5)\6/g' \
#    -e 's/Eclesiastés ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Eclesiastés [\1, \2](eclesiastes#c\1-v\2)\3/g' \
#    \
#    -e 's/Cantar de los Cantares ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Cantar de los Cantares [\1, \2](cantar-de-los-cantares#c\1-v\2)\3; [\4, \5](cantar-de-los-cantares#c\4-v\5)\6; [\7, \8](cantar-de-los-cantares#c\7-v\8)\9/g' \
#    -e 's/Cantar de los Cantares ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Cantar de los Cantares [\1, \2](cantar-de-los-cantares#c\1-v\2)\3; [\4, \5](cantar-de-los-cantares#c\4-v\5)\6/g' \
#    -e 's/Cantar de los Cantares ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Cantar de los Cantares [\1, \2](cantar-de-los-cantares#c\1-v\2)\3/g' \
#    \
#    -e 's/Sabiduría ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Sabiduría [\1, \2](sabiduria#c\1-v\2)\3; [\4, \5](sabiduria#c\4-v\5)\6; [\7, \8](sabiduria#c\7-v\8)\9/g' \
#    -e 's/Sabiduría ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Sabiduría [\1, \2](sabiduria#c\1-v\2)\3; [\4, \5](sabiduria#c\4-v\5)\6/g' \
#    -e 's/Sabiduría ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Sabiduría [\1, \2](sabiduria#c\1-v\2)\3/g' \
#    \
#    -e 's/Eclesiástico ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Eclesiástico [\1, \2](eclesiastico#c\1-v\2)\3; [\4, \5](eclesiastico#c\4-v\5)\6; [\7, \8](eclesiastico#c\7-v\8)\9/g' \
#    -e 's/Eclesiástico ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Eclesiástico [\1, \2](eclesiastico#c\1-v\2)\3; [\4, \5](eclesiastico#c\4-v\5)\6/g' \
#    -e 's/Eclesiástico ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Eclesiástico [\1, \2](eclesiastico#c\1-v\2)\3/g' \
#    \
#    -e 's/Isaías ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Isaías [\1, \2](isaias#c\1-v\2)\3; [\4, \5](isaias#c\4-v\5)\6; [\7, \8](isaias#c\7-v\8)\9/g' \
#    -e 's/Isaías ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Isaías [\1, \2](isaias#c\1-v\2)\3; [\4, \5](isaias#c\4-v\5)\6/g' \
#    -e 's/Isaías ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Isaías [\1, \2](isaias#c\1-v\2)\3/g' \
#    \
#    -e 's/Jeremías ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Jeremías [\1, \2](jeremias#c\1-v\2)\3; [\4, \5](jeremias#c\4-v\5)\6; [\7, \8](jeremias#c\7-v\8)\9/g' \
#    -e 's/Jeremías ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Jeremías [\1, \2](jeremias#c\1-v\2)\3; [\4, \5](jeremias#c\4-v\5)\6/g' \
#    -e 's/Jeremías ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Jeremías [\1, \2](jeremias#c\1-v\2)\3/g' \
#    \
#    -e 's/Lamentaciones ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Lamentaciones [\1, \2](lamentaciones#c\1-v\2)\3; [\4, \5](lamentaciones#c\4-v\5)\6; [\7, \8](lamentaciones#c\7-v\8)\9/g' \
#    -e 's/Lamentaciones ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Lamentaciones [\1, \2](lamentaciones#c\1-v\2)\3; [\4, \5](lamentaciones#c\4-v\5)\6/g' \
#    -e 's/Lamentaciones ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Lamentaciones [\1, \2](lamentaciones#c\1-v\2)\3/g' \
#    \
#    -e 's/Baruc ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Baruc [\1, \2](baruc#c\1-v\2)\3; [\4, \5](baruc#c\4-v\5)\6; [\7, \8](baruc#c\7-v\8)\9/g' \
#    -e 's/Baruc ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Baruc [\1, \2](baruc#c\1-v\2)\3; [\4, \5](baruc#c\4-v\5)\6/g' \
#    -e 's/Baruc ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Baruc [\1, \2](baruc#c\1-v\2)\3/g' \
#    \
#    -e 's/Ezequiel ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Ezequiel [\1, \2](ezequiel#c\1-v\2)\3; [\4, \5](ezequiel#c\4-v\5)\6; [\7, \8](ezequiel#c\7-v\8)\9/g' \
#    -e 's/Ezequiel ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Ezequiel [\1, \2](ezequiel#c\1-v\2)\3; [\4, \5](ezequiel#c\4-v\5)\6/g' \
#    -e 's/Ezequiel ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Ezequiel [\1, \2](ezequiel#c\1-v\2)\3/g' \
#    \
#    -e 's/Daniel ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Daniel [\1, \2](daniel#c\1-v\2)\3; [\4, \5](daniel#c\4-v\5)\6; [\7, \8](daniel#c\7-v\8)\9/g' \
#    -e 's/Daniel ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Daniel [\1, \2](daniel#c\1-v\2)\3; [\4, \5](daniel#c\4-v\5)\6/g' \
#    -e 's/Daniel ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Daniel [\1, \2](daniel#c\1-v\2)\3/g' \
#    \
#    -e 's/Oseas ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Oseas [\1, \2](oseas#c\1-v\2)\3; [\4, \5](oseas#c\4-v\5)\6; [\7, \8](oseas#c\7-v\8)\9/g' \
#    -e 's/Oseas ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Oseas [\1, \2](oseas#c\1-v\2)\3; [\4, \5](oseas#c\4-v\5)\6/g' \
#    -e 's/Oseas ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Oseas [\1, \2](oseas#c\1-v\2)\3/g' \
#    \
#    -e 's/Joel ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Joel [\1, \2](joel#c\1-v\2)\3; [\4, \5](joel#c\4-v\5)\6; [\7, \8](joel#c\7-v\8)\9/g' \
#    -e 's/Joel ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Joel [\1, \2](joel#c\1-v\2)\3; [\4, \5](joel#c\4-v\5)\6/g' \
#    -e 's/Joel ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Joel [\1, \2](joel#c\1-v\2)\3/g' \
#    \
#    -e 's/Amós ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Amós [\1, \2](amos#c\1-v\2)\3; [\4, \5](amos#c\4-v\5)\6; [\7, \8](amos#c\7-v\8)\9/g' \
#    -e 's/Amós ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Amós [\1, \2](amos#c\1-v\2)\3; [\4, \5](amos#c\4-v\5)\6/g' \
#    -e 's/Amós ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Amós [\1, \2](amos#c\1-v\2)\3/g' \
#    \
#    -e 's/Abdías ([0-9]+)([0-9 s\.\-]*)/Abdías [\1](abdias#v\1)\2/g' \
#    \
#    -e 's/Jonás ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Jonás [\1, \2](jonas#c\1-v\2)\3; [\4, \5](jonas#c\4-v\5)\6; [\7, \8](jonas#c\7-v\8)\9/g' \
#    -e 's/Jonás ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Jonás [\1, \2](jonas#c\1-v\2)\3; [\4, \5](jonas#c\4-v\5)\6/g' \
#    -e 's/Jonás ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Jonás [\1, \2](jonas#c\1-v\2)\3/g' \
#    \
#    -e 's/Miqueas ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Miqueas [\1, \2](miqueas#c\1-v\2)\3; [\4, \5](miqueas#c\4-v\5)\6; [\7, \8](miqueas#c\7-v\8)\9/g' \
#    -e 's/Miqueas ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Miqueas [\1, \2](miqueas#c\1-v\2)\3; [\4, \5](miqueas#c\4-v\5)\6/g' \
#    -e 's/Miqueas ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Miqueas [\1, \2](miqueas#c\1-v\2)\3/g' \
#    \
#    -e 's/Nahúm ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Nahúm [\1, \2](nahum#c\1-v\2)\3; [\4, \5](nahum#c\4-v\5)\6; [\7, \8](nahum#c\7-v\8)\9/g' \
#    -e 's/Nahúm ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Nahúm [\1, \2](nahum#c\1-v\2)\3; [\4, \5](nahum#c\4-v\5)\6/g' \
#    -e 's/Nahúm ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Nahúm [\1, \2](nahum#c\1-v\2)\3/g' \
#    \
#    -e 's/Habacuc ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Habacuc [\1, \2](habacuc#c\1-v\2)\3; [\4, \5](habacuc#c\4-v\5)\6; [\7, \8](habacuc#c\7-v\8)\9/g' \
#    -e 's/Habacuc ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Habacuc [\1, \2](habacuc#c\1-v\2)\3; [\4, \5](habacuc#c\4-v\5)\6/g' \
#    -e 's/Habacuc ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Habacuc [\1, \2](habacuc#c\1-v\2)\3/g' \
#    \
#    -e 's/Sofonías ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Sofonías [\1, \2](sofonias#c\1-v\2)\3; [\4, \5](sofonias#c\4-v\5)\6; [\7, \8](sofonias#c\7-v\8)\9/g' \
#    -e 's/Sofonías ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Sofonías [\1, \2](sofonias#c\1-v\2)\3; [\4, \5](sofonias#c\4-v\5)\6/g' \
#    -e 's/Sofonías ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Sofonías [\1, \2](sofonias#c\1-v\2)\3/g' \
#    \
#    -e 's/Ageo ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Ageo [\1, \2](ageo#c\1-v\2)\3; [\4, \5](ageo#c\4-v\5)\6; [\7, \8](ageo#c\7-v\8)\9/g' \
#    -e 's/Ageo ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Ageo [\1, \2](ageo#c\1-v\2)\3; [\4, \5](ageo#c\4-v\5)\6/g' \
#    -e 's/Ageo ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Ageo [\1, \2](ageo#c\1-v\2)\3/g' \
#    \
#    -e 's/Zacarías ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Zacarías [\1, \2](zacarias#c\1-v\2)\3; [\4, \5](zacarias#c\4-v\5)\6; [\7, \8](zacarias#c\7-v\8)\9/g' \
#    -e 's/Zacarías ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Zacarías [\1, \2](zacarias#c\1-v\2)\3; [\4, \5](zacarias#c\4-v\5)\6/g' \
#    -e 's/Zacarías ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Zacarías [\1, \2](zacarias#c\1-v\2)\3/g' \
#    \
#    -e 's/Malaquías ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Malaquías [\1, \2](malaquias#c\1-v\2)\3; [\4, \5](malaquias#c\4-v\5)\6; [\7, \8](malaquias#c\7-v\8)\9/g' \
#    -e 's/Malaquías ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Malaquías [\1, \2](malaquias#c\1-v\2)\3; [\4, \5](malaquias#c\4-v\5)\6/g' \
#    -e 's/Malaquías ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Malaquías [\1, \2](malaquias#c\1-v\2)\3/g' \
#    \
#    -e 's/Mateo ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Mateo [\1, \2](mateo#c\1-v\2)\3; [\4, \5](mateo#c\4-v\5)\6; [\7, \8](mateo#c\7-v\8)\9/g' \
#    -e 's/Mateo ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Mateo [\1, \2](mateo#c\1-v\2)\3; [\4, \5](mateo#c\4-v\5)\6/g' \
#    -e 's/Mateo ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Mateo [\1, \2](mateo#c\1-v\2)\3/g' \
#    \
#    -e 's/Marcos ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Marcos [\1, \2](marcos#c\1-v\2)\3; [\4, \5](marcos#c\4-v\5)\6; [\7, \8](marcos#c\7-v\8)\9/g' \
#    -e 's/Marcos ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Marcos [\1, \2](marcos#c\1-v\2)\3; [\4, \5](marcos#c\4-v\5)\6/g' \
#    -e 's/Marcos ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Marcos [\1, \2](marcos#c\1-v\2)\3/g' \
#    \
#    -e 's/Lucas ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Lucas [\1, \2](lucas#c\1-v\2)\3; [\4, \5](lucas#c\4-v\5)\6; [\7, \8](lucas#c\7-v\8)\9/g' \
#    -e 's/Lucas ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Lucas [\1, \2](lucas#c\1-v\2)\3; [\4, \5](lucas#c\4-v\5)\6/g' \
#    -e 's/Lucas ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Lucas [\1, \2](lucas#c\1-v\2)\3/g' \
#    \
#    -e 's/1 Juan ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/1 Juan [\1, \2](1-juan#c\1-v\2)\3; [\4, \5](1-juan#c\4-v\5)\6; [\7, \8](1-juan#c\7-v\8)\9/g' \
#    -e 's/1 Juan ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/1 Juan [\1, \2](1-juan#c\1-v\2)\3; [\4, \5](1-juan#c\4-v\5)\6/g' \
#    -e 's/1 Juan ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/1 Juan [\1, \2](1-juan#c\1-v\2)\3/g' \
#    \
#    -e 's/2 Juan ([0-9]+)([0-9 s\.\-]*)/2 Juan [\1](2-juan#v\1)\2/g' \
#    \
#    -e 's/3 Juan ([0-9]+)([0-9 s\.\-]*)/3 Juan [\1](3-juan#v\1)\2/g' \
#    \
#    -e 's/Juan ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Juan [\1, \2](juan#c\1-v\2)\3; [\4, \5](juan#c\4-v\5)\6; [\7, \8](juan#c\7-v\8)\9/g' \
#    -e 's/Juan ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Juan [\1, \2](juan#c\1-v\2)\3; [\4, \5](juan#c\4-v\5)\6/g' \
#    -e 's/Juan ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Juan [\1, \2](juan#c\1-v\2)\3/g' \
#    \
#    -e 's/Hechos ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Hechos [\1, \2](hechos#c\1-v\2)\3; [\4, \5](hechos#c\4-v\5)\6; [\7, \8](hechos#c\7-v\8)\9/g' \
#    -e 's/Hechos ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Hechos [\1, \2](hechos#c\1-v\2)\3; [\4, \5](hechos#c\4-v\5)\6/g' \
#    -e 's/Hechos ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Hechos [\1, \2](hechos#c\1-v\2)\3/g' \
#    \
#    -e 's/Romanos ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Romanos [\1, \2](romanos#c\1-v\2)\3; [\4, \5](romanos#c\4-v\5)\6; [\7, \8](romanos#c\7-v\8)\9/g' \
#    -e 's/Romanos ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Romanos [\1, \2](romanos#c\1-v\2)\3; [\4, \5](romanos#c\4-v\5)\6/g' \
#    -e 's/Romanos ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Romanos [\1, \2](romanos#c\1-v\2)\3/g' \
#    \
#    -e 's/1 Corintios ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/1 Corintios [\1, \2](1-corintios#c\1-v\2)\3; [\4, \5](1-corintios#c\4-v\5)\6; [\7, \8](1-corintios#c\7-v\8)\9/g' \
#    -e 's/1 Corintios ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/1 Corintios [\1, \2](1-corintios#c\1-v\2)\3; [\4, \5](1-corintios#c\4-v\5)\6/g' \
#    -e 's/1 Corintios ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/1 Corintios [\1, \2](1-corintios#c\1-v\2)\3/g' \
#    \
#    -e 's/2 Corintios ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/2 Corintios [\1, \2](2-corintios#c\1-v\2)\3; [\4, \5](2-corintios#c\4-v\5)\6; [\7, \8](2-corintios#c\7-v\8)\9/g' \
#    -e 's/2 Corintios ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/2 Corintios [\1, \2](2-corintios#c\1-v\2)\3; [\4, \5](2-corintios#c\4-v\5)\6/g' \
#    -e 's/2 Corintios ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/2 Corintios [\1, \2](2-corintios#c\1-v\2)\3/g' \
#    \
#    -e 's/Gálatas ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Gálatas [\1, \2](galatas#c\1-v\2)\3; [\4, \5](galatas#c\4-v\5)\6; [\7, \8](galatas#c\7-v\8)\9/g' \
#    -e 's/Gálatas ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Gálatas [\1, \2](galatas#c\1-v\2)\3; [\4, \5](galatas#c\4-v\5)\6/g' \
#    -e 's/Gálatas ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Gálatas [\1, \2](galatas#c\1-v\2)\3/g' \
#    \
#    -e 's/Efesios ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Efesios [\1, \2](efesios#c\1-v\2)\3; [\4, \5](efesios#c\4-v\5)\6; [\7, \8](efesios#c\7-v\8)\9/g' \
#    -e 's/Efesios ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Efesios [\1, \2](efesios#c\1-v\2)\3; [\4, \5](efesios#c\4-v\5)\6/g' \
#    -e 's/Efesios ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Efesios [\1, \2](efesios#c\1-v\2)\3/g' \
#    \
#    -e 's/Filipenses ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Filipenses [\1, \2](filipenses#c\1-v\2)\3; [\4, \5](filipenses#c\4-v\5)\6; [\7, \8](filipenses#c\7-v\8)\9/g' \
#    -e 's/Filipenses ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Filipenses [\1, \2](filipenses#c\1-v\2)\3; [\4, \5](filipenses#c\4-v\5)\6/g' \
#    -e 's/Filipenses ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Filipenses [\1, \2](filipenses#c\1-v\2)\3/g' \
#    \
#    -e 's/Colosenses ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Colosenses [\1, \2](colosenses#c\1-v\2)\3; [\4, \5](colosenses#c\4-v\5)\6; [\7, \8](colosenses#c\7-v\8)\9/g' \
#    -e 's/Colosenses ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Colosenses [\1, \2](colosenses#c\1-v\2)\3; [\4, \5](colosenses#c\4-v\5)\6/g' \
#    -e 's/Colosenses ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Colosenses [\1, \2](colosenses#c\1-v\2)\3/g' \
#    \
#    -e 's/1 Tesalonicenses ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/1 Tesalonicenses [\1, \2](1-tesalonicenses#c\1-v\2)\3; [\4, \5](1-tesalonicenses#c\4-v\5)\6; [\7, \8](1-tesalonicenses#c\7-v\8)\9/g' \
#    -e 's/1 Tesalonicenses ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/1 Tesalonicenses [\1, \2](1-tesalonicenses#c\1-v\2)\3; [\4, \5](1-tesalonicenses#c\4-v\5)\6/g' \
#    -e 's/1 Tesalonicenses ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/1 Tesalonicenses [\1, \2](1-tesalonicenses#c\1-v\2)\3/g' \
#    \
#    -e 's/2 Tesalonicenses ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/2 Tesalonicenses [\1, \2](2-tesalonicenses#c\1-v\2)\3; [\4, \5](2-tesalonicenses#c\4-v\5)\6; [\7, \8](2-tesalonicenses#c\7-v\8)\9/g' \
#    -e 's/2 Tesalonicenses ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/2 Tesalonicenses [\1, \2](2-tesalonicenses#c\1-v\2)\3; [\4, \5](2-tesalonicenses#c\4-v\5)\6/g' \
#    -e 's/2 Tesalonicenses ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/2 Tesalonicenses [\1, \2](2-tesalonicenses#c\1-v\2)\3/g' \
#    \
#    -e 's/1 Timoteo ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/1 Timoteo [\1, \2](1-timoteo#c\1-v\2)\3; [\4, \5](1-timoteo#c\4-v\5)\6; [\7, \8](1-timoteo#c\7-v\8)\9/g' \
#    -e 's/1 Timoteo ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/1 Timoteo [\1, \2](1-timoteo#c\1-v\2)\3; [\4, \5](1-timoteo#c\4-v\5)\6/g' \
#    -e 's/1 Timoteo ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/1 Timoteo [\1, \2](1-timoteo#c\1-v\2)\3/g' \
#    \
#    -e 's/2 Timoteo ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/2 Timoteo [\1, \2](2-timoteo#c\1-v\2)\3; [\4, \5](2-timoteo#c\4-v\5)\6; [\7, \8](2-timoteo#c\7-v\8)\9/g' \
#    -e 's/2 Timoteo ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/2 Timoteo [\1, \2](2-timoteo#c\1-v\2)\3; [\4, \5](2-timoteo#c\4-v\5)\6/g' \
#    -e 's/2 Timoteo ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/2 Timoteo [\1, \2](2-timoteo#c\1-v\2)\3/g' \
#    \
#    -e 's/Tito ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Tito [\1, \2](tito#c\1-v\2)\3; [\4, \5](tito#c\4-v\5)\6; [\7, \8](tito#c\7-v\8)\9/g' \
#    -e 's/Tito ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Tito [\1, \2](tito#c\1-v\2)\3; [\4, \5](tito#c\4-v\5)\6/g' \
#    -e 's/Tito ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Tito [\1, \2](tito#c\1-v\2)\3/g' \
#    \
#    -e 's/Filemón ([0-9]+)([0-9 s\.\-]*)/Filemón [\1](filemon#v\1)\2/g' \
#    \
#    -e 's/Hebreos ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Hebreos [\1, \2](hebreos#c\1-v\2)\3; [\4, \5](hebreos#c\4-v\5)\6; [\7, \8](hebreos#c\7-v\8)\9/g' \
#    -e 's/Hebreos ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Hebreos [\1, \2](hebreos#c\1-v\2)\3; [\4, \5](hebreos#c\4-v\5)\6/g' \
#    -e 's/Hebreos ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Hebreos [\1, \2](hebreos#c\1-v\2)\3/g' \
#    \
#    -e 's/Santiago ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Santiago [\1, \2](santiago#c\1-v\2)\3; [\4, \5](santiago#c\4-v\5)\6; [\7, \8](santiago#c\7-v\8)\9/g' \
#    -e 's/Santiago ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Santiago [\1, \2](santiago#c\1-v\2)\3; [\4, \5](santiago#c\4-v\5)\6/g' \
#    -e 's/Santiago ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Santiago [\1, \2](santiago#c\1-v\2)\3/g' \
#    \
#    -e 's/1 Pedro ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/1 Pedro [\1, \2](1-pedro#c\1-v\2)\3; [\4, \5](1-pedro#c\4-v\5)\6; [\7, \8](1-pedro#c\7-v\8)\9/g' \
#    -e 's/1 Pedro ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/1 Pedro [\1, \2](1-pedro#c\1-v\2)\3; [\4, \5](1-pedro#c\4-v\5)\6/g' \
#    -e 's/1 Pedro ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/1 Pedro [\1, \2](1-pedro#c\1-v\2)\3/g' \
#    \
#    -e 's/2 Pedro ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/2 Pedro [\1, \2](2-pedro#c\1-v\2)\3; [\4, \5](2-pedro#c\4-v\5)\6; [\7, \8](2-pedro#c\7-v\8)\9/g' \
#    -e 's/2 Pedro ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/2 Pedro [\1, \2](2-pedro#c\1-v\2)\3; [\4, \5](2-pedro#c\4-v\5)\6/g' \
#    -e 's/2 Pedro ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/2 Pedro [\1, \2](2-pedro#c\1-v\2)\3/g' \
#    \
#    -e 's/Judas ([0-9]+)([0-9 s\.\-]*)/Judas [\1](judas#v\1)\2/g' \
#    \
#    -e 's/Apocalipsis ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Apocalipsis [\1, \2](apocalipsis#c\1-v\2)\3; [\4, \5](apocalipsis#c\4-v\5)\6; [\7, \8](apocalipsis#c\7-v\8)\9/g' \
#    -e 's/Apocalipsis ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Apocalipsis [\1, \2](apocalipsis#c\1-v\2)\3; [\4, \5](apocalipsis#c\4-v\5)\6/g' \
#    -e 's/Apocalipsis ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Apocalipsis [\1, \2](apocalipsis#c\1-v\2)\3/g' \
#    "$1"

echo '¡Hecho!'

#* Test de regex para los libros de un solo capítulo:

# echo 'Abdías 7-10 ss.' | sed -E 's/Abdías ([0-9]+)([0-9 s\.\-]*)/Abdías [\1](abdias#v\1)\2/g'

#* Test de regex para los libros con más de un capítulo:

# echo 'Génesis 11, 3; 12, 35-37; 13, 5 ss.' | sed -E 's/Génesis ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Génesis [\1, \2](genesis#c\1-v\2)\3; [\4, \5](genesis#c\4-v\5)\6; [\7, \8](genesis#c\7-v\8)\9/g'

#* Libros de 1 solo capítulo: _Abdías, _Filemón, _2 Juan, _3 Juan, _Judas

#* Plantilla para libros de 1 solo capítulo:

# sed -i -E \
#    -e 's/Apocalipsis ([0-9]+)([0-9 s\.\-]*)/Apocalipsis [\1](apocalipsis#v\1)\2/g' \
#    \

#* Plantilla para libros de más de un capítulo:

# sed -i -E \
#    -e 's/Apocalipsis ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Apocalipsis [\1, \2](apocalipsis#c\1-v\2)\3; [\4, \5](apocalipsis#c\4-v\5)\6; [\7, \8](apocalipsis#c\7-v\8)\9/g' \
#    -e 's/Apocalipsis ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Apocalipsis [\1, \2](apocalipsis#c\1-v\2)\3; [\4, \5](apocalipsis#c\4-v\5)\6/g' \
#    -e 's/Apocalipsis ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Apocalipsis [\1, \2](apocalipsis#c\1-v\2)\3/g' \
#    \

#* El argumento de este script debe ser un libro bíblico en construcción, que solo tenga la introducción y las notas explicativas (sin el texto bíblico, para anular la posibilidad de que este script lo modifique), excepto si el libro tiene título alternativo, en cuyo caso no debe tener tampoco la introducción (pues la introducción explica el nombre alternativo, así que las ocurrencias de este en ella no deben reemplazarse).

#* Regex útiles:

# ^(\d+)\\.
# [$1](#v$1)

#  \[↑\]\(#footnote-ref-\d+\)
