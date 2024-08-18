# Instalación de software Augustus para la anotación estructural de genes

*By: Samuel Pulgarin Muñoz [Desarrollador de software]*
*14/junio 2024*

Guía de instalación (*no oficial*) para el software *Augustus* en maquina Ubuntu - linux 22.04.4 LTS 

[Sitio oficial](https://bioinf.uni-greifswald.de/augustus/downloads/)


# NAVEGACIÓN (Ctrl + clic)

- [Sección 1](#PRE-REQUISITOS)
- [Sección 2](#INSTALACIÓN)
- [Sección 3](#EJEMPLO_DE_USO)
- [Sección 4](#ERRORES-SOLUCIONES)
- [Sección 5](#ESPECIES)
- [Sección 6](#FORMATO_README)


# PRE-REQUISITOS

- Sistema operativo Linux.
- Git instalado en el sistema.
- Acceso a internet.
- 8 GB de almacenamiento en el disco duro.


# INSTALACIÓN

## Clonar repositorio
[Repositorio](https://github.com/Gaius-Augustus/Augustus)

- En la terminal ejecutamos los siguientes comandos:
``` git clone https://github.com/Gaius-Augustus/Augustus.git ```
``` cd Augustus ```

## Compilar Augustus
- Para completar la instalación del software, ejecutar dentro del directorio raíz del software:
``` make augustus ```

- Para compilar utilidades adicionales del software ejecutar:
``` make auxprogs ```

- Si el sistema no reconoce el comando *make* instalar:
``` sudo apt update ```
``` sudo apt install make ```

*NOTA*: Si presenta problemas con la instalación del software, por favor dirijase hacia la Seccion 4 de este archivo.


# EJEMPLO_DE_USO
- Para observar una lista de comandos y parámetros propios de *Augustus*, ejecutar dentro del directorio raíz:
``` bin/augustus ```

- Para ver toda una lista de especies disponibles del modelo, ejecutar:
``` augustus --species=help ```

- Para realizar anotación estructural de un genoma (*predicción de genes*) basado en una especie, ejecutar:
``` bin/augustus --species=nombre_especie archivo.fasta ```


# ERRORES-SOLUCIONES
Lista de posibles errores que se pueden presentar durante el proceso de instalación del software, junto a su solución.

## Errores al compilar Augustus
- Errores generados por el comando *make augustus*:

    *ERROR: make[1]: g++: No such file or directory*
    ### Solución: ```sudo apt install g++ ```

    *ERROR: No such file or directory 16 | #include <boost/archive/text_oarchive.hpp>*
    ### Solución: ```sudo apt install libboost-all-dev ```

    *ERROR: mysql++/mysql++.h: No such file or directory 21 | #include <mysql++/mysql++.h>*
    ### Solución: ``` sudo apt install libmysql++-dev ```

    *ERROR: sqlite3.h: No such file or directory 13 | #include <sqlite3.h>*
    ### Solución: ``` sudo apt install libsqlite3-dev ```

    *ERROR: sl/gsl_matrix.h: No such file or directory 18 | #include <gsl/gsl_matrix.h>*
    ### Solución: ``` sudo apt install libgsl-dev ```

    *ERROR: lp_lib.h: No such file or directory 16 | #include "lp_lib.h"*
    ### Solución 1: ``` sudo apt-get install liblpsolve55-dev ```
    ### Solución 2: ``` sudo apt install lp-solve ```


## Errores al compilar utilidades adicionales de Augustus
- Errores generados por el comando *make auxprogs*:

    *ERROR: api/BamReader.h: No such file or directory 16 | #include <api/BamReader.h>*
    ### Solución: ```sudo apt install libbamtools-dev ```

    *ERROR: bgzf.h: No such file or directory 12 | #include "bgzf.h"*
    ### Solución: ``` sudo apt install libhts-dev ```

*NOTA*: Si presenta errores que no estan descritos en esta guía, puede dirigirse al sitio oficial:
[Librerias - Dependencias](https://github.com/Gaius-Augustus/Augustus/blob/master/docs/INSTALL.md)


# ESPECIES

## Crear nueva especie
- Inicialmente se debe configurar la variable de entorno, dicha variable debe apuntar hacia el directorio de configuración de *Augustus*. Escribir en la terminal de comandos:
``` export AUGUSTUS_CONFIG_PATH=/ruta/hacia/el/directorio/Augustus/config/ ```

- Verificar que la variable de entorno se configuró correctamente:
``` echo $AUGUSTUS_CONFIG_PATH ```

- Navegar hasta el directorio de scripts de *Augustus* (*Augustus/scripts*) y ejecutar el siguiente script de *Perl*:
``` perl new_species.pl --species=nombreDeMiNuevaEspecie ```

Si todo funciona de forma correcta, dentro del directorio (*Augustus/config/species*) se debió crear una carpeta con el nombre de la nueva especie especificada *nombreDeMiNuevaEspecie*.

Al interior del directorio, podemos encontrar los siguientes archivos de configuración:

- nombreDeMiNuevaEspecie_metapars.cfg
- nombreDeMiNuevaEspecie_metapars.cgp.cfg
- nombreDeMiNuevaEspecie_metapars.utr.cfg
- nombreDeMiNuevaEspecie_parameters.cfg
- nombreDeMiNuevaEspecie_weightmatrix.txt

Estos archivos son esenciales para configurar y entrenar *Augustus* para la predicción precisa de genes en una nueva especie. Cada archivo contiene información específica que afecta cómo *Augustus* realiza las predicciones de genes basadas en el modelo y los datos proporcionados.

Más abajo en esta misma sección 5, encontrará los pasos para configurar los *meta-parámetros* del archivo *_parameters.cfg* para la especie.

## Entrenar especie - Forma manual
Para entrenar una nueva especie eucariota se debe contar con un archivo en formato genbank que contenga las secuencias codificantes (*CDS*) en el formato adecuado, para realizar dicha labor puede hacer uso de la suit *"ETRAINING_AUGUSTUS_WITH_GENBANK_FILE"*.

Para usar el archivo en formato genbank, debe asegurar que la variable de entorno $AUGUSTUS_CONFIG_PATH esté correctamente configurada. Posteriormente ejecutar dentro del directorio raíz del software:
``` etraining --species=minuevaespecie archivo.gb ```

## Entrenar especie - Forma automatizada
Existe un script de *Perl* en el directorio *Augustus/scripts* llamado *autoAug.pl* que se encarga de crear archivos de secuencia y archivos de anotación necesarios para el entrenamiento de Augustus. Para poner en marcha, debe seguir los siguientes pasos:

- Realizar instalaciones adicionales para un correcto funcionamiento. Debe instalar lo siguiente:

    - PASA: Es un programa utilizado para ensamblar alineaciones de secuencias de genes. Es especialmente útil cuando se tienen alineamientos empalmados (que representan la estructura de los genes) y se desea ensamblar estos alineamientos en transcritos completos.

    - BLAT: Herramienta de alineación de secuencias, especialmente útil para alinear secuencias de ADN y ARN contra genomas.

    - SCIPIO: Es un programa diseñado para la predicción de estructuras genéticas basado en secuencias de proteínas. Es útil cuando se tienen secuencias de proteínas que se conocen y se desean encontrar las estructuras genéticas correspondientes en un genoma.

- Verificar que la variable de entorno $AUGUSTUS_CONFIG_PATH esté correctamente configurada.

- Navegar hasta el directorio de scripts (*Augustus/scripts*) y ejecutar el script de la siguiente manera:
``` autoAug.pl -g genome.fa -t traingenes.gff --species=tuEspecie --cdna=cdna.fa -v ```

- También se puede ejecutar de la siguiente forma:
``` autoAug.pl --genome=genome.fa --species=tuEspecie --trainingset=protein.fa -v ```

Los archivos generados por el script de perl *autoAug.pl* se pueden usar para entrenar la especie, para ello debe ejecutar en el directorio raíz del software:
``` etraining --species=minuevaespecie archivoGeneradoPorAutoAug ``` 

*NOTA*: El modelo de la nueva especie fue entrenado de forma manual, es por ello que en esta guía *NO* garantizamos el soporte y correcto funcionamiento en la forma automatizada.

Si desea más información para realizar el entrenamiento de forma automatizada, revise la documentación oficial:

[README.autoAug](https://github.com/Gaius-Augustus/Augustus/blob/master/scripts/README.autoAug)


# FORMATO_README

# *Carácter utilizado para representar secciones (títulos) al interior del archivo.*

- *Carácter utiizado para representar una lista de elementos.*

## *Caracteres utilizados para representar sub-secciones (subtítulos) al interior del archivo.*

* *Carácter utilizado para resaltar palabras, terminos y fragmentos importantes*

### *Caracteres utilizados para representar sub-sub-secciones (sub-subtítulos) al interior del archivo.*

[''](#) Caracteres que permiten navegar al interior del archivo o ir a sitios externos.

``` *Caracteres utilizados para representar comandos o líneas de codigo.*


