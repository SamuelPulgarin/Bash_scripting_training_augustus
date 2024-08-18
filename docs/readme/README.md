# Convertir archivos gff3 a genbank para el entrenamiento de especies Eucariotas en Augustus

*By: Samuel Pulgarin Muñoz [Desarrollador de software]*
*14/junio 2024*

Suit de scripts programada para procesar archivos en formato *gff*, *fasta* y *genbank* con el fin de generar un archivo específico.(*genbank*) para el entrenamiento de una nueva especie *Saccharum* usando el software *Augustus* (Herramienta Bioinformática).


# NAVEGACIÓN (Ctrl + clic)

- [Sección 1](#PREPARAR_ENTORNO)

- [Sección 2](#PAQUETES_USADOS)

- [Sección 3](#SCRIPTS)
    - [script](#gff_to_genbank_augustus_etrainingsh)
    - [script](#format_gff3_R570sh)
    - [script](#gff_to_genbankpy)
    - [script](#format_genbank_R570sh)

- [Sección 4](#PROBLEMAS_CON_EL_ENTORNO_VIRTUAL)

- [Sección 5](#FORMATO_README)


# PREPARAR_ENTORNO:

- Asegurese que el script principal *gff_to_genbank.sh* tenga permisos de administrador para crear, modificar, eliminar archivos y carpetas.


# PAQUETES_USADOS (python):

*biopython*
[Ir al sitio oficial](https://biopython.org/wiki/Documentation)

*bcbio-gff*
[Ir al sitio oficial](https://biopython.org/wiki/GFF_Parsing)

*NOTA*: Si presenta problemas con el paquete y las importaciones de python, por favor dirijase hacia la Seccion 4 de este archivo.


# SCRIPTS:

## gff_to_genbank_augustus_etraining.sh
Script principal encargado de ejecutar todos los demás scripts. 
      
- Se debe ejecutar de la la siguiente forma:
``` ./gff_to_genbank_augustus_etraining.sh archivo.gff archivo.fasta ```


## format_gff3_R570.sh
Script opcional encargado de parsear el archivo *gff* suministrado a un formato *gff* aceptado por el script de python, usando la siguiente expresión regular: 
s/\.([0-9]+|[a-zA-Z]+[0-9]*)//g.

Se recomienda siempre ejecutar este script para garantizar un correcto funcionamiento de la suit.

- El script se encarga de formatear líneas como las siguientes:

    ### Ejemplo 1
    - Sin formato: ID=SoffiXsponR570.10Ag000100.v2.1;
    - Formateado:  ID=SoffiXsponR570Ag000100;
    ### Ejemplo 2
    - Sin formato: Parent=SoffiXsponR570.10Ag000100.3;
    - Formateado:  Parent=SoffiXsponR570Ag000100;

- El script genera el siguiente archivo de salida:

    ### Saccharum_hybrid_cultivar_formatted_R570.gff3
    Archivo en formato *gff3* en condiciones para ser escrito en formato *genbank*.
    
- Si desea ejecutar de manera individual, se debe ejecutar el script de la siguiente forma: 
``` ./format_gff3_R570.sh archivo.gff3 ```.


## gff_to_genbank.py
Script escrito en python encargado de convertir el archivo *gff* previamente procesado a fomato *genbank*, tomando como base el archivo *fasta* en el cual se encuentran las secuencias de nucleótidos.

- El script esta conformado por las siguientes funciones:

    ### _extract_regions(){ }
    Función diseñada para extraer regiones específicas de secuencias de *ADN* representadas en formato *GFF*, y ajustar las anotaciones de las características y subcaracterísticas dentro de esas regiones.

    ### _fix_ncbi_id(){ }
    Función diseñada para ajustar los identificadores y tipos de características en registros de formato *FASTA*, específicamente para manejar los identificadores de *NCBI* y acortar los tipos de características a una longitud máxima de 15 caracteres.

    ### _flatten_features(){ }
    Función que toma un registro con características jerárquicas y las transforma en una lista plana de características, lo cual facilita el análisis de datos. Para lograr esto, la función recorre recursivamente todas las características y subcaracterísticas anidadas del registro, agregándolas secuencialmente a una lista de características planas. El resultado es un registro donde todas las características y subcaracterísticas están listadas de manera lineal, lo que puede ser más fácil de manejar para ciertos procesamientos o análisis posteriores.

    ### _check_gff(){ }
    Función encargada de verificar cada registro en el iterador para asegurarse de que contenga la secuencia correspondiente en el archivo *FASTA*. Si una secuencia no está presente en un registro, emite una advertencia indicando que la secuencia *FASTA* no se ha encontrado para ese registro en el archivo *GFF*. Luego, llama a *_flatten_features(rec)* para "aplanar" las características del registro y devolver el registro modificado.

    ### main(){ }
    Función encargada de coordinar el procesamiento de archivos GFF y FASTA, realiza ciertas manipulaciones y correcciones en los registros GFF y escribe los resultados en un archivo GenBank.

- El script genera el siguiente archivo de salida:

    ### Saccharum_hybrid_cultivar_formatted_R570.gb
    Archivo en formato genbank generado por el script *gff_to_genbank.py*.
    
- Si desea ejecutar de manera individual, se debe ejecutar el script de la siguiente forma:
``` python3 gff_to_genbank.py archivoFormateado.gff archivo.fasta ```


## format_genbank_R570.sh
Script encargado de formatear el archivo genbank *Saccharum_hybrid_cultivar_formatted_R570.gb* generado por el script *gff_to_genbank.py*, en un formato que *Augustus* acepte para el entrenamiento de especies.

- El script se basa en lo siguiente:

    ### ranges_overlap(){ }
    Función que proporciona una manera de verificar si dos rangos dados se superponen entre sí, es decir, evita las siguiente situaciones:

    - Superposición: join(*567..953,667..953*,1371..1534).
    - Formato correcto: join(567..953,1371..1534).

    - Si los rangos se superponen, la función devuelve 0 (éxito).
    - Si los rangos no se superponen, la función devuelve 1 (fracaso).

    ### while IFS= read -r linea || [[ -n "$linea" ]];
    Ciclo encargado de leer cada línea del archivo *Saccharum_hybrid_cultivar_formatted_R570.gb* y así mismo escribir nuevamente un archivo *genbank* con el formato deseado.
    Se basa en condicionales para identificar los encabezados del formato y realizar las respectivas modificaciones.

- El script genera el siguiente archivo de salida:

    ### Etraining_saccharum_specie_R570.gb
    El archivo *genbank* contiene unicamente las secuencias codificantes del genoma (*CDS*), representadas de manera que puedan ser procesadas por el software *Augustus*.

- Si desea ejecutar de manera individual, asegurese que exista el archivo    *Saccharum_hybrid_cultivar_formatted_R570.gb*. Posteriormente, puede ejecutar el script de la siguiente forma:
``` ./format_genbank_R570.sh ```


# PROBLEMAS_CON_EL_ENTORNO_VIRTUAL

- Primero asegurese de tener instalado los siguientes recursos necesarios:
``` sudo apt update ```
``` sudo apt install python3-pip ```
``` sudo apt install python3.10-venv ```

- Posteriormente debe crear un entorno virtual para las librerías y paquetes:
``` python3 -m venv myenv ```

- Debe acceder al entorno virtual de la siguiente manera:
``` source myenv/bin/activate ```

- Finalmente puede instalar y hacer uso de los paquetes que usted requiera:
``` pip install biopython ```
``` pip install bcbio-gff ```


# FORMATO_README

# *Carácter utilizado para representar secciones (títulos) al interior del archivo.*

- *Carácter utiizado para representar una lista de elementos.*

## *Caracteres utilizados para representar sub-secciones (subtítulos) al interior del archivo.*

* *Carácter utilizado para resaltar palabras, terminos y fragmentos importantes*

### *Caracteres utilizados para representar sub-sub-secciones (sub-subtítulos) al interior del archivo.*

[''](#) Caracteres que permiten navegar al interior del archivo o ir a sitios externos.

``` *Caracteres utilizados para representar comandos o líneas de codigo.*



      
      
      