#!/bin/bash

#* Regularización de comillas y de tres puntos:

sed -i -E \
   -e 's/[“”]/"/g' \
   -e 's/[«»]/*/g' \
   -e "s/[‘’]/'/g" \
   -e 's/…/.../g' \
   "$1"

echo '¡Hecho!'
