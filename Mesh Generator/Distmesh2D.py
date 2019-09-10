#!/usr/bin/env python
import numpy as np
from numpy import sqrt, sum, vstack
from scipy.spatial import Delaunay
    
def delaunay(pts):
    return Delaunay(pts).vertices


def triangulate(pts, geps, fd, *args):  #Calcula la triangulacion de Delaunay y elimina triangulos con centroides fuera del dominio
        tri = np.sort(delaunay(pts), axis=1)
        pmid = sum(pts[tri], 1)/3
        return tri[fd(pmid, *args) < -geps]


def distmesh2d(fd, fh, h0, bbox, pfix, *args):
    """
    Parametros:
    ==========

    fd: Funcion distancia
    fh: Funcion de tam. de triangulo
    h0: Parametro de tam. del elemento
    bbox: Cuadro delimitador
    pfix: Puntos fijos

    Retornos
    =======

    p: Lisa de puntos
    t: Lista de triangulos
    """

    # Constantes
    dptol = 0.001; ttol = 0.1; Fscale = 1.2; deltat = 0.2; dpscale = 100;
    geps = 0.001 * h0; deps = sqrt(np.finfo(float).eps) * h0

    # Distribucion inicial de los puntos
    x, y = np.meshgrid(np.arange(bbox[0][0], bbox[0][1], h0), np.arange(bbox[1][0], bbox[1][1], h0*sqrt(3)/2))
    x[1::2,:] += h0/2
    p = np.array((x.flatten(), y.flatten())).T
    puntos = len(p)*dpscale
    Fuerzas = np.zeros(puntos)

    # Descartar puntos exteriores
    p = p[fd(p, *args) < geps]
    r0 = 1.0/fh(p, *args)**2
    selection = np.random.rand(p.shape[0], 1) < r0/r0.max()
    p = p[selection[:,0]]

    # Agregar puntos fijos:
    if len(pfix) > 0:
        p = np.vstack((pfix, p))

    pold = np.zeros_like(p); pold[:] = np.inf
    Ftot = np.zeros_like(p)

    while True:
        # Verificar si necesario volver a calcular la triangulacion
        if sqrt(sum((p-pold)**2, 1)).max() > ttol:
            pold[:] = p[:]
            t = triangulate(p, geps,  fd, *args)
            # Encontrar aristas unicas de los triangulos
            bars = t[:, [[0,1], [1,2], [0,2]]].reshape((-1, 2))
            bars = np.unique(bars.view("i,i")).view("i").reshape((-1,2))

        barvec = p[bars[:,0]]-p[bars[:,1]]
        L = sqrt(sum(barvec**2, 1)).reshape((-1,1))
        hbars = fh((p[bars[:,0]] + p[bars[:,1]])/2.0, *args).reshape((-1,1))
        L0 = hbars*Fscale*sqrt(sum(L**2) / sum(hbars**2))

        # Calcular fuerza por cada arista
        Ftot[:] = 0
        F = np.maximum(L0 - L, 0)
        Fvec = F * (barvec / L)
        for j in xrange(bars.shape[0]):
            Ftot[bars[j]] += [Fvec[j], -Fvec[j]]

        # Suma para obtener fuerzas totales para cada punto
        Fuerzas[:] = 0
        for u in xrange(puntos):
            Fuerzas[u] += Fscale*u
        
        # Puntos fijos, fuerza = 0
        Ftot[0:len(pfix), :] = 0.0

        # Actualizar ubicaciones de puntos
        p += deltat * Ftot

        # Encontrar puntos que terminaron fuera del dominio y los proyectarlos hacia el limite:
        d = fd(p, *args); ix = d > 0
        dgradx = (fd(vstack((p[ix,0] + deps, p[ix,1])).T, *args)-d[ix])/deps
        dgrady = (fd(vstack((p[ix,0],p[ix,1] + deps)).T, *args)-d[ix])/deps
        p[ix] -= vstack((d[ix]*dgradx, d[ix]*dgrady)).T

        # Condicion de parada
        if (sqrt(sum((deltat * Ftot[d < -geps])**2, 1)) / h0).max() < dptol:
            break

    return p, triangulate(p,  geps,  fd, *args)


# Funcion distancia para el circulo centrado en (xc, yc)
def dcircle(pts, xc, yc, r):    
    return sqrt((pts[:,0]-xc)**2+(pts[:,1]-yc)**2)-r


# Funcion distancia para el rectangulo (x1, x2)*(y1, y2)
def drectangle(pts, x1, x2, y1, y2):
    return -np.minimum(np.minimum(np.minimum(-y1+pts[:,1], y2-pts[:,1]),-x1+pts[:,0]), x2-pts[:,0])


# Funcion distancia para la diferencia de dos conjuntos
def ddiff(d1, d2):
    return np.maximum(d1, -d2)


# Funcion distancia para la interseccion de dos conjuntos
def dintersect(d1, d2):
    return np.maximum(d1, d2)


# Funcion distancia para la union de dos conjuntos
def dunion(d1, d2):
    return np.minimum(d1, d2)


# Funcion tam. triangulos, proporciona una malla casi uniforme
def huniform(pts, *args):
    return np.ones((pts.shape[0], 1))


# Mascara de limite
def boundary_mask(pts, fd, h0):
    """
    Devuelve una matriz de booleanos, uno para cada punto en pts: True si el punto esta dentro en el limite y False en caso contrario.

    Parametros:
    ==========

    fd: Funcion distancia
    pts: Lista de puntos retornados por la funcion "distmesh2d"
    h0: Parametro de tam. del elemento

    """
    N = pts.shape[0]
    geps = 0.01 * h0
    mask = np.zeros(N, dtype="bool")
    distance = fd(pts)
    for j in xrange(N):
        if distance[j] > -geps:
            mask[j] = True

    return mask