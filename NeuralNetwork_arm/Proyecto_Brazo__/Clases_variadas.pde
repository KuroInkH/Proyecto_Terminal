/*
Clases que contiene el PDE:
 1. CoordinateSystem
 2. Cylinder
 3. MatrixOperations
 4. Functions
 */

class CoordinateSystem {
  /*
  DESCRIPCIÓN: Clase utilizada para crear sistemas de coordenadas.
   */

  //Punto de origen 
  float[][] origen;
  //Eje X del sistema de coordenadas
  float[][] X;
  //Eje Y del sistema de coordenadas
  float[][] Y;
  //Eje Z del sistema de coordenadas
  float[][] Z;

  CoordinateSystem() {
    X = new float[4][1];
    Y = new float[4][1];
    Z = new float[4][1];
    X[0][0] = 50;
    X[1][0] = 0;
    X[2][0] = 0;
    X[3][0] = 1;
    Y[0][0] = 0;
    Y[1][0] = 50;
    Y[2][0] = 0;
    Y[3][0] = 1;
    Z[0][0] = 0;
    Z[1][0] = 0;
    Z[2][0] = 50;
    Z[3][0] = 1;


    origen = new float[4][1];
    origen[0][0] = 0;
    origen[1][0] = 0;
    origen[2][0] = 0;
    origen[3][0] = 1;
  }

  /*
  DESCRIPCIÓN: Muestra el sistema de coordenadas dentro del Canvas
   PARAMS: void
   */
  public void showCS() {
    stroke(255, 0, 0);
    line(origen[0][0], origen[1][0], origen[2][0], X[0][0], X[1][0], X[2][0]);
    stroke(0, 255, 0);
    line(origen[0][0], origen[1][0], origen[2][0], Y[0][0], Y[1][0], Y[2][0]);
    stroke(0, 0, 255);
    line(origen[0][0], origen[1][0], origen[2][0], Z[0][0], Z[1][0], Z[2][0]);
    
  }

  /*
  DESCRIPCIÓN: Muestra el sistema de coordenadas dentro del Canvas con un texto informativo en su punto de origen
   PARAMS: 
   center: Texto informativo que se muestra en el origen del sistema de coordenadas
   */
  public void showCS(String center) {
    stroke(255, 0, 0);
    line(origen[0][0], origen[1][0], origen[2][0], X[0][0], X[1][0], X[2][0]);
    stroke(0, 255, 0);
    line(origen[0][0], origen[1][0], origen[2][0], Y[0][0], Y[1][0], Y[2][0]);
    stroke(0, 0, 255);
    line(origen[0][0], origen[1][0], origen[2][0], Z[0][0], Z[1][0], Z[2][0]);
    textSize(30);
    text(center, origen[0][0], origen[1][0], origen[2][0]);
  }

  /*
  DESCRIPCIÓN: Resetea el sistema de coordenadas a sus valores iniciales (ver miembros de la clase)
   PARAMS: void
   */
  public void reset() {
    X[0][0] = 50;
    X[1][0] = 0;
    X[2][0] = 0;
    X[3][0] = 1;
    Y[0][0] = 0;
    Y[1][0] = 50;
    Y[2][0] = 0;
    Y[3][0] = 1;
    Z[0][0] = 0;
    Z[1][0] = 0;
    Z[2][0] = 50;
    Z[3][0] = 1;
    origen[0][0] = 0;
    origen[1][0] = 0;
    origen[2][0] = 0;
    origen[3][0] = 1;
  }

  /*
  DESCRIPCIÓN: Mueve el sistema de coordenadas a una nueva posición
   PARAMS: 
   x,y,z: Nueva posición del sistema de coordenadas
   */
  public void moveCS(float x, float y, float z) {
    X[0][0] += x;
    X[1][0] += y;
    X[2][0] += z;

    Y[0][0] += x;
    Y[1][0] += y;
    Y[2][0] += z;

    Z[0][0] += x;
    Z[1][0] += y;
    Z[2][0] += z;

    origen[0][0] += x;
    origen[1][0] += y;
    origen[2][0] += z;
  }

  /*
  DESCRIPCIÓN: El sistema de coordenadas obtiene los valores de otro Sistema de coordenadas
   PARAMS: 
   cs: Sistema de coordenadas del cual se copiaran los valores de cada eje
   */
  public void copyValues(CoordinateSystem cs) {
    X[0][0] = cs.X[0][0];
    X[1][0] = cs.X[1][0];
    X[2][0] = cs.X[2][0];

    Y[0][0] = cs.Y[0][0];
    Y[1][0] = cs.Y[1][0];
    Y[2][0] = cs.Y[2][0];

    Z[0][0] = cs.Z[0][0];
    Z[1][0] = cs.Z[1][0];
    Z[2][0] = cs.Z[2][0];

    origen[0][0] = cs.origen[0][0];
    origen[1][0] = cs.origen[1][0];
    origen[2][0] = cs.origen[2][0];
  }
}

/*
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 */

/*
Clase usada para poner volumen a los eslabones del robot
 */
class Cylinder {
  /*
  DESCRIPCION: Clase usada para crear cilindros a lo largo de los ejes X y Z. Los cilindros tienen una posición de inicio y una de termino dentro del eje seleccionado.
   NOTAS:
   1. Si se desea mover el cilindro en tiempo de ejecución se pueden usar las funciones: setPos(). 
   2. La función addMatrixsHomo() crea el clindro dada una matriz de transformación homogénea. 
   3. La función showCylinder() muestra el cilindro dentro del Canvas.
   
   */

  //Posiciones de los vertices del poligono regular 1 (cara 1 del cilindro)
  private float[] sin1, cos1;
  //Posiciones de los vertices del poligono regular 2 (cara 2 del cilindro)
  private float[] sin2, cos2;
  //Posiciones de las dos caras del poligono y su centro dentro de su eje correspondiente
  private float[][][] positionsDown, positionsUp, center;
  //Posiciones de las dos caras del poligono y su centro dentro del sistema de coordenadas global
  private float[][][] positionsDown2, positionsUp2, center2;

  //Posición inicial del cilindro dentro del eje correspondiente
  public float posIni;
  //Posoción dentro del eje correspondiente donde termina el cilidro
  public float posEnd;
  //Número de vertices del poligono regular de las dos caras del cilindro. Entre más grande el poligono se acerca a un circulo, por lo tanto define la resolución del cilindro.
  public float sides;
  //Radio del poligono regular de las dos caras del cilindro
  public float radio;
  //Eje en el cual se creará el cilindro
  public String eje;

  /*
  DESCRIPTOR.
   PARAMS:
   
   radio: Distancia del centro del polígono regular a un vértice. Los polígonos se crean a lo largo de un Eje de Coordenadas ya sea el X o Z según el String 
   que se pase en el  parametro "e". 
   
   posI, posE: Son el punto de inicio del cilindro y su terminación en el eje seleccionado. 
   
   sides: Regula que tanto se va a pulir el cilindro, entre más alto sea el valor del miembro "sides" el cilindro tendrá más detallado su curvatura.
   
   e: Es el eje seleccionado. "e" solo puede se le pueden pasar los string  "z" o "x".
   */
  Cylinder(float radio, float posI, float posE, int sides, String e) {
    sin1 = new float[sides+1];
    cos1 = new float[sides+1];

    sin2 = new float[sides+1];
    cos2 = new float[sides+1];

    positionsDown = new float[sides+1][4][1];
    positionsUp = new float[sides+1][4][1];

    positionsDown2 = new float[sides+1][4][1];
    positionsUp2 = new float[sides+1][4][1];
    for (int i = 0; i < sides+1; i++) {
      positionsDown[i][3][0] = 1;
      positionsUp[i][3][0] = 1;
      positionsDown2[i][3][0] = 1;
      positionsUp2[i][3][0] = 1;
    }

    center = new float[2][4][1];
    center2 = new float[2][4][1];
    for (int i = 0; i < 2; i++) {
      center[i][3][0] = 1;
      center2[i][3][0] = 1;
    }

    eje = e;
    this.sides = sides;
    this.radio = radio;
    this.posIni = posI;
    this.posEnd = posE;
    buildCyrcles();
    makeCylinder();
  }

  /*
  DESCRIPCIÓN: Establece la posición donde inicia y termina el cilindro dentro del eje correspondiente
   PARAMS: 
   pIni: Posición donde inicia el cilindro
   pEnd: Posición donde termina el cilindro
   */
  public void setPos(float pIni, float pEnd) {
    posIni = pIni; 
    posEnd = pEnd;
    //Se crea el cilindro
    makeCylinder();
  }

  /*
  DESCRIPCIÓN: Indica la posición donde termina el cilindro dentro del eje correspondiente. El cilindro inicia desde la posición cero
   PARAMS: 
   pEnd: Posición donde termina el cilindro
   */
  public void setPos(float pEnd) {
    posEnd = pEnd;
    makeCylinder();
  }

  /*
  DESCRIPCIÓN: Posición y orientación del cilindro dada por una matriz de transformación homogénea
   PARAMS: 
   matrizHomo: matriz de transformación homogénea
   */
  public void addMatrixsHomo(float[][] matrixHomo) {
    //se obtienen las nuevas coordenadas de los puntos del cilindro

    //Posición de las caras del cilindro
    for (int i=0; i<sides+1; i++) {
      MatrixOperations.multiplyMatrices(matrixHomo, positionsDown[i], positionsDown2[i]);
      MatrixOperations.multiplyMatrices(matrixHomo, positionsUp[i], positionsUp2[i]);
    }
    //Posición central de las caras del cilindro
    MatrixOperations.multiplyMatrices(matrixHomo, center[0], center2[0]);
    MatrixOperations.multiplyMatrices(matrixHomo, center[1], center2[1]);
  }

  /*
  DESCRIPCIÓN: Muestra el cilindro dentro del canvas
   PARAMS: void
   */
  public void showCylinder() {
    //Cara 1 del cilindro
    fill(0);
    stroke(90);
    beginShape(TRIANGLE_FAN);
    vertex(center2[0][0][0], center2[0][1][0], center2[0][2][0]);
    for (int i=0; i < sin1.length; i++) {
      vertex(positionsDown2[i][0][0], positionsDown2[i][1][0], positionsDown2[i][2][0]);
    }
    endShape();

    //cuerpo del cilindro
    beginShape(QUAD_STRIP); 
    for (int i=0; i < sin1.length; i++) {
      vertex(positionsDown2[i][0][0], positionsDown2[i][1][0], positionsDown2[i][2][0]);
      vertex(positionsUp2[i][0][0], positionsUp2[i][1][0], positionsUp2[i][2][0]);
    }
    endShape();

    //Cara 2 del cilindro
    beginShape(TRIANGLE_FAN); 
    vertex(center2[1][0][0], center2[1][1][0], center2[1][2][0]);
    for (int i=0; i < sin1.length; i++) {
      vertex(positionsUp2[i][0][0], positionsUp2[i][1][0], positionsUp2[i][2][0]);
    }
    endShape();
    
  }

  /*
  DESCRIPCIÓN: Contruye las caras del cilindro
   PARAMS: void
   */
  private void buildCyrcles() {
    //posiciones de los vertices de los polígonos regulares que son la caras del cilindro. 
    float angle;
    //cara 1 (polígono 1)
    for (int i=0; i < sin1.length; i++) {
      angle = TWO_PI / (sides) * i;
      sin1[i] = sin(angle) * radio;
      cos1[i] = cos(angle) * radio;
    }
    //cara 2 (polígono 2)
    for (int i=0; i < sin1.length; i++) {
      angle = TWO_PI / (sides) * i;
      sin2[i] = sin(angle) * radio;
      cos2[i] = cos(angle) * radio;
    }
  }

  /*
  DESCRIPCIÓN: Construye el cilindro en el eje X o Z
   PARAMS: void
   */
  private void makeCylinder() {
    if (eje.equals("z")) {
      center[0][0][0] = 0;
      center[0][1][0] = 0;
      center[0][2][0] = posIni;

      for (int i=0; i < sin1.length; i++) {
        positionsDown[i][0][0] = cos1[i];
        positionsDown[i][1][0] = sin1[i];
        positionsDown[i][2][0] = posIni;
      }

      center[1][0][0] = 0;
      center[1][1][0] = 0;
      center[1][2][0] = posEnd;
      for (int i=0; i < sin1.length; i++) {
        positionsUp[i][0][0] = cos2[i];
        positionsUp[i][1][0] = sin2[i];
        positionsUp[i][2][0] = posEnd;
      }
    }

    if (eje.equals("x")) {
      center[0][0][0] = posIni;
      center[0][1][0] = 0;
      center[0][2][0] = 0;
      for (int i=0; i < sin1.length; i++) {
        positionsDown[i][0][0] = posIni;
        positionsDown[i][1][0] = sin1[i];
        positionsDown[i][2][0] = cos1[i];
      }

      center[1][0][0] = posEnd;
      center[1][1][0] = 0;
      center[1][2][0] = 0;
      for (int i=0; i < sin1.length; i++) {
        positionsUp[i][0][0] = posEnd;
        positionsUp[i][1][0] = sin2[i];
        positionsUp[i][2][0] = cos2[i];
      }
    }
  }
}

/*
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 */

/*
Clase usada para realizar operaciones entre matrices y vectores
 */

import java.text.MessageFormat;

public static class MatrixOperations {



  /*
  DESCRIPCIÓN: Multiplicación de matrices o una matriz por un vector
   PARAMS: 
   x: matriz 1/vector 1
   y: matriz 2/vector 2
   */
  public static void multiplyMatrices (float[][] x, float[][] y, float[][] result) {

    int xColumns, xRows, yColumns, yRows;

    xRows = x.length;
    xColumns = x[0].length;
    yRows = y.length;
    yColumns = y[0].length;

    if (xColumns != yRows) {
      throw new IllegalArgumentException (
        MessageFormat.format ("Matrices don't match: {0} != {1}.", xColumns, yRows));
    }
    //se limpia la matriz de resultado
    for (int i = 0; i < xRows; i++) {
      for (int j = 0; j < yColumns; j++) {
        result[i][j]=0;
      }
    }

    //se realiza la multiplicacion
    for (int i = 0; i < xRows; i++) {
      for (int j = 0; j < yColumns; j++) {
        for (int k = 0; k < xColumns; k++) {
          result[i][j] += (x[i][k] * y[k][j]);
        }
      }
    }
  }

  /*
  DESCRIPCIÓN: Imprime una matriz dentro de consola
   PARAMS: 
   matrix: matriz a imprimir
   */
  public static void printMatrix (float[][] matrix) {
    int cols, rows;

    rows = matrix.length;
    cols = matrix[0].length;

    System.out.print (MessageFormat.format ("Matrix[{0}][{1}]:", rows, cols));
    System.out.println ();

    for (int i = 0; i < matrix.length; i++) {
      System.out.print ("[");

      for (int j = 0; j < matrix[i].length; j++) {
        System.out.print (matrix[i][j]);
        if ((j + 1) != matrix[i].length) {
          System.out.print (", ");
        }
      }

      if ((i + 1) != matrix.length) {
        System.out.println ("]");
      } else {
        System.out.println ("].");
      }
    }

    System.out.println ();
  }

  /*
  DESCRIPCIÓN: Calcula el ángulo entro dos vectores 
   PARAMS: 
   v1: vector 1
   v2: vector 2
   type: Unidad de medida del ángulo
   */
  public static float AngleTwoVectors(float[][] v1, float[][] v2, String type) {
    if (v1.length != v2.length) {
      throw new IllegalArgumentException (
        MessageFormat.format ("Vectores don't match: {0} != {1}.", v1.length, v2.length));
    }

    float cos, aux;
    cos = v1[0][0]*v2[0][0]+v1[1][0]*v2[1][0]+v1[2][0]*v2[2][0];
    aux = dist(0, 0, 0, v1[0][0], v1[1][0], v1[2][0])*dist(0, 0, 0, v2[0][0], v2[1][0], v2[2][0]);
    cos /=aux;
    if (type.equals("radian"))return acos(cos);
    if (type.equals("degree"))return degrees(acos(cos));
    return 0;
  }

  /*
  DESCRIPCIÓN: realiza la proyección vectorial de v1 sobre v2
   PARAMS: 
   v1: vector 1
   v2: vector 2
   result: vector resultante
   */
  public static void vectorProjectionV(float[][] v1, float[][] v2, float[][] result) {
    if (v1.length != v2.length) {
      throw new IllegalArgumentException (
        MessageFormat.format ("Vectores don't match: {0} != {1}.", v1.length, v2.length));
    }
    float num = v1[0][0]*v2[0][0]+v1[1][0]*v2[1][0]+v1[2][0]*v2[2][0];
    float dem = v2[0][0]*v2[0][0]+v2[1][0]*v2[1][0]+v2[2][0]*v2[2][0];
    result[0][0] = (num/dem)*v2[0][0];
    result[1][0] = (num/dem)*v2[1][0];
    result[2][0] = (num/dem)*v2[2][0];
  }

  /*
  DESCRIPCIÓN: Proyección vectorial de v1 sobre v2 
   PARAMS: 
   */
  public static float vectorProjectionE(float[][] v1, float[][] v2) {
    if (v1.length != v2.length) {
      throw new IllegalArgumentException (
        MessageFormat.format ("Vectores don't match: {0} != {1}.", v1.length, v2.length));
    }

    float num = v1[0][0]*v2[0][0]+v1[1][0]*v2[1][0]+v1[2][0]*v2[2][0];
    float dem = dist(0, 0, 0, v2[0][0], v2[1][0], v2[2][0]);
    return num/dem;
  }

  /*
  DESCRIPCIÓN: Vector director 
   PARAMS: 
   v1: vector 1
   v2: vector 2
   rest: vector resultante
   dirección: dirección para calcular el vector. 1to2 vector director de v1 a v2, 2to1 vector director de v2 a v1
   */
  public static void directorVector(float[][] v1, float[][] v2, float[][] rest, String direccion) {
    if (v1.length != v2.length) {
      throw new IllegalArgumentException (
        MessageFormat.format ("Vectores don't match: {0} != {1}.", v1.length, v2.length));
    }

    if (direccion.equals("1to2")) {
      rest[0][0] = v2[0][0]-v1[0][0];
      rest[1][0] = v2[1][0]-v1[1][0];
      rest[2][0] = v2[2][0]-v1[2][0];
    }

    if (direccion.equals("2to1")) {
      rest[0][0] = v1[0][0]-v2[0][0];
      rest[1][0] = v1[1][0]-v2[1][0];
      rest[2][0] = v1[2][0]-v2[2][0];
    }
  }
}

/*
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 */

/*
Clase usada para realizar  operaciones variadas
 */
static class Functions {

  /*
  DESCRIPCIÓN: Regresa un valor flotante en formato de string con "precision" de x dígitos a la derecha despues del punto
   PARAMS: 
   val: valor al cual se le camia su preción
   precision: numero de dígitos deseados despues del punto
   */
  public static String precisionFloat(float val, int precision) {
    String a = str(val);
    int b = a.indexOf(".");
    if (b != -1) {
      if (a.length()-b-precision-2 >= 0) a = a.substring(0, b+precision+1);
    }
    return getValue(float(a));
  }

  /*
  DESCRIPCIÓN: Convierte un valor flotante a entero y despues a string
   PARAMS:
   v: valor a convertir
   */
  public static String getValue(float v) {
    String s;
    //Casteo del valor
    if (v%1 == 0) s = str(int(v));
    else {
      s = str(v);
    }
    return s;
  }

  /*
  DESCRIPCIÓN: Verifica que un valor se encuentre dentro de su rango [lim1, lim2]. Si se encuentra dentro del rango se retorna el mismo valor, si no se retorna el valor del limite más cercano
   PARAMS:
   val: Valor
   lim1: limite 1
   lim2: limite 2
   */
  public static float constrain2(float val, float lim1, float lim2) {
    if (lim1 < lim2) {
      if (val < lim1) return lim1;
      if (val > lim2) return lim2;
      else return val;
    }

    if (lim1 > lim2) {
      if (val > lim1) return lim1;
      if (val < lim2) return lim2;
      else return val;
    } else { 
      return lim1;
    }
  }
}
