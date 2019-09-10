from pylab import figure, triplot, tripcolor, axis, axes, show, hold, plot
#from Distmesh2D import *
from Distmesh2DCUDA import *
import numpy as np
from time import time

# Funciones distancia para diferentes formas: =================================

def circulo(pts):
    return dcircle(pts, 0, 0, 1)

def circulohueco(pts):
    return ddiff(dcircle(pts, 0, 0, 0.7), dcircle(pts, 0, 0, 0.3))

def rectangulo(pts):
    return ddiff(drectangle(pts, -1, 1, -1, 1), dcircle(pts, 0, 0, 0.4))

def circuloconcentrado(pts):
    return np.minimum(4*np.sqrt(sum(pts**2, 1)) - 1, 2)

def circle_h(pts):
    return 0.1 - circulo(pts)

def annulus(pts):
    return 0.04 + 0.15 * dcircle(pts, 0, 0, 0.3)

def estrella(pts):
    return dunion(dintersect(dcircle(pts, np.sqrt(3), 0, 2), dcircle(pts, -np.sqrt(3), 0, 2)),
                  dintersect(dcircle(pts, 0, np.sqrt(3), 2), dcircle(pts, 0, -np.sqrt(3), 2)))


# Funciones para graficar: =================================

def plot_mesh(pts, tri, *args):
    if len(args) > 0:
        tripcolor(pts[:,0], pts[:,1], tri, args[0], edgecolor='black', cmap="Blues")
    else:
        triplot(pts[:,0], pts[:,1], tri, "k-", lw=2)
    axis('tight')
    axes().set_aspect('equal')

def plot_nodes(pts, mask, *args):
    boundary = pts[mask == True]
    interior = pts[mask == False]
    plot(boundary[:,0], boundary[:,1], 'o', color="black")
    plot(interior[:,0], interior[:,1], 'o', color="black")
    axis('tight')
    axes().set_aspect('equal')


bbox = [[-1, 1], [-1, 1]]
square = [[-1,-1], [-1,1], [1,-1], [1,1]]

# Definicion de los ejemplos: =================================

# Circulo
def Circulo():
    figure()
    start_time = time()
    pts, tri = distmesh2d(circulo, huniform, 0.4, bbox, [])
    elapsed_time = time() - start_time
    print("Tiempo ejecucion: %0.10f segundos." % elapsed_time)
    #plot_mesh(pts, tri)
    #show()

# Circulo con hueco en el centro
def CirculoConHueco():
    figure()
    start_time = time()
    pts, tri = distmesh2d(circulohueco, huniform, 0.4, bbox, [])
    elapsed_time = time() - start_time
    print("Tiempo ejecucion: %0.10f segundos." % elapsed_time)
    #plot_mesh(pts, tri)
    #show()


# Cuadrado con circulo concentrado
def CuadradoCirculoConcentrado():
    figure()
    start_time = time()
    pts, tri = distmesh2d(rectangulo, circuloconcentrado, 0.035, bbox, square)
    elapsed_time = time() - start_time
    print("Tiempo ejecucion: %0.10f segundos." % elapsed_time)
    #plot_mesh(pts, tri)
    #show()


# Circulo con malla no uniforme
def CirculoNoUniforme():
    figure()
    start_time = time()
    pts, tri = distmesh2d(circulo, circle_h, 0.1, bbox, [])
    elapsed_time = time() - start_time
    print("Tiempo ejecucion: %0.10f segundos." % elapsed_time)
    #plot_mesh(pts, tri)
    #show()


# Annulus
def Annulus():
    figure()
    start_time = time()
    pts, tri = distmesh2d(circulohueco, annulus, 0.04, bbox, square)
    boundary = boundary_mask(pts, circulohueco, 0.04)
    elapsed_time = time() - start_time
    print("Tiempo ejecucion: %0.10f segundos." % elapsed_time)
    #plot_mesh(pts, tri)
    #plot_nodes(pts, boundary)
    #show()

# Una estrella, usando circulos
def Estrella():
    figure()
    start_time = time()
    pfix = [[0.25, 0.25], [-0.25, 0.25], [-0.25, -0.25], [0.25, -0.25]]
    pts, tri = distmesh2d(estrella, huniform, 0.1, bbox, pfix)
    boundary = boundary_mask(pts, estrella, 0.5)
    elapsed_time = time() - start_time
    print("Tiempo ejecucion: %0.10f segundos." % elapsed_time)
    #plot_mesh(pts, tri)
    #plot_nodes(pts, boundary)
    #show()


# Ejecucion: =================================
Circulo()