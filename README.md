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

## Uso

1. Open the spv.html file with your web browser
2. Select sprite size: 16x16 or 8x8
3. Check if the binary file contains a header
4. Select the binary file 

## Licencia

Ninguna, puedes usar este código para lo que quieras.

# Créditos

* Escrito por [Orion](https://orionmsx.com/).
* Uso algunas rutinas de Konami para la gestión del VDP y para controlar el puntero a la pantalla que hay que cargar, gracias al desensamblado de [Manuel Pazos](https://github.com/GuillianSeed).
* Rutina de conversión a BCD publicada por "bore" en los [foros de msx.org](https://www.msx.org/forum/development/msx-development/bcdhex-conversion-asm).