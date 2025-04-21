#* Libros de 1 solo capítulo: _Abdías, _Filemón, _2 Juan, _3 Juan, _Judas

#* Plantilla para libros de 1 solo capítulo:

sed -i -E \
   -e 's/Apocalipsis ([0-9]+)([0-9 s\.\-]*)/Apocalipsis [\1](apocalipsis#v\1)\2/g' \
   \

#* Plantilla para libros de más de un capítulo:

sed -i -E \
   -e 's/Apocalipsis ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Apocalipsis [\1, \2](apocalipsis#c\1-v\2)\3; [\4, \5](apocalipsis#c\4-v\5)\6; [\7, \8](apocalipsis#c\7-v\8)\9/g' \
   -e 's/Apocalipsis ([0-9]+), ([0-9]+)([0-9 s\.\-]*); ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Apocalipsis [\1, \2](apocalipsis#c\1-v\2)\3; [\4, \5](apocalipsis#c\4-v\5)\6/g' \
   -e 's/Apocalipsis ([0-9]+), ([0-9]+)([0-9 s\.\-]*)/Apocalipsis [\1, \2](apocalipsis#c\1-v\2)\3/g' \
   \


#* Para normalizar comillas: « »

#* Regex útiles:

# ^(\d+)\\.
# [$1](#v$1)

#  \[↑\]\(#footnote-ref-\d+\)
