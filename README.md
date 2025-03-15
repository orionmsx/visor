# Visor
Visor de mapeado de pantallas sin scroll para MSX en screen 2

## Changelog

* [15/03/2025] v1.0 - Primera versión

## Descripción

* Es una herramienta que me hice para mi uso personal.
* Sirve para ver las pantallas de un mapeado y poder moverte entre ellas con los cursores.
* A mí me sirve para ver en el emulador o en un MSX real el aspecto que van a tener, sobre todo los colores.
* Escrito en asm, concretamente he usado Sjasm Z80 Assembler v0.42c, de [XL2S Entertainment](https://www.xl2s.tk/).
* Trabaja con mapas de hasta 99x99 pantallas.
* Funciona de forma bastante directa si traes las pantallas desde [nMSXtiles](https://github.com/pipagerardo/nMSXtiles).

## Uso

1. En el archivo constantes.asm tienes que dar el valor correcto a ANCHO_MAPA y ALTO_MAPA.
2. Coloca las pantallas, los tiles y sus colores en /gfx. Se da por hecho que están comprimidas con Pletter, de [XL2S Entertainment](https://www.xl2s.tk/).
3. En el archivo pantallas.asm haz los cambios a los incbin siguiendo el esquema de ejemplo. Cada pantalla debe tener su definición dw correspondiente.
4. En el raíz del proyecto, crea la carpeta out.
5. Compila con `sjasm src/main.asm`.
6. En /out tendrás el archivo main.bin, que puedes cargar con bload en el MSX.

## Licencia

Ninguna, puedes usar este código para lo que quieras.

# Créditos

* Escrito por [Orion](https://orionmsx.com/).
* Uso algunas rutinas de Konami para la gestión del VDP y para controlar el puntero a la pantalla que hay que cargar, gracias al desensamblado de [Manuel Pazos](https://github.com/GuillianSeed).
* Rutina de conversión a BCD publicada por "bore" en los [foros de msx.org](https://www.msx.org/forum/development/msx-development/bcdhex-conversion-asm).