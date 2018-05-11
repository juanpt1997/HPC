# Taller Parcial 2
High Performance Computing. 

**Realizado por:** Santiago Gómez Grajales - Juan Pablo Tabares Rico. UTP, 2018

## Enunciado:

1. A partir de la construcción de la primera parte del Parcial 2 se deberá construir un programa que haga uso de Memoria Compartida, como se vió en clase.
2. Se deberán presentar gráficas comparativas de tiempos de ejecución entre los algoritmos, sin aceleración, la implementación ingenua y la implementación con memoria compartida.
3. Deberán existir gráficas comparativas de aceleración de la implementación ingenua y la implementación con memoria compartida con respecto a la implementación sin aceleración.
4. Deberán entregarse conclusiones puntuales sobre las tendencias que se obtienen de acuerdo a las gráficas. Deben ser conclusiones profesionales. **OJO**.
5. El proyecto como tal deberá estar albergado en un repositorio (Github, Gitlab, Bitbucket, ... entre otros). Se deberá hacer uso de Markdown para mostrar los resultados y el reporte de este proceso.
6. Este proceso pueden hacer en grupos. Ojalá los mismos que van a presentar el proyecto final.
7. La calificación se hará seleccionando **(El profesor lo seleccionará)** uno de los integrantes del grupo para que explique todo el proceso.
8. Todas las implementaciones deberán hacerse a través de **SLURM​.**
9. Sino se usa **SLURM​,** se tendrá una nota de 0.0.
10. Se tendrá en cuenta la fluidez a la hora de usar la consola, conectarse al clúster y conocer toda la infraestructura que están usando.
11. Tengan en cuenta investigar todo sobre las características de las GPU que contiene el clúster.
12. Todas las implementaciones deberán ejecutarse mínimo 10 veces para garantizar un tiempo y cálculo de aceleración promedio que servirá como insumo para la construcción de las gráficas.
13. El resultado de esta implementación debe mostrar una aceleración del algoritmo.
14. El algoritmo debe multiplicar bien. **SÚPER IMPORTANTE.**


## Implementación:

Para la construcción de este taller se realizaron 3 implementaciones diferentes de un mismo algoritmo para la multiplicación de dos matrices, estos algoritmos fueron:

- MulMat_V1.c [Versión sin optimizar, algoritmo secuencial]
- MulMat_V2.cu [Versión paralela optimizada con CUDA, algoritmo ingenuo]
- MulMat_V3.cu [Versión paralela optimizada con CUDA, algoritmo haciendo uso de memoria compartida]

Y se usaron también, 3 tipos de entradas diferentes:

- input-short.txt [2 Matrices de 400x400]
- input-medium.txt [2 Matrices de 1000x1000]
- input-long.txt [2 Matrices de 2000x2000]


## CPU's y GPU's:

Los algoritmos fueron probados y ejecutados en un clúster a través de la herramienta **SLURM** solicitando **1GB** de memoria RAM y un único nodo, con las siguientes especificaciones:

### CPU:

**Core i7**

### GPU's

**Nvidia GTX 980**

**Nvidia GTX 780**

Las implementaciones realizadas, se ejecutaron de manera independiente en cada GPU.