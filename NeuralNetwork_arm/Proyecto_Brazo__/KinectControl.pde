/*
Clases que contiene el PDE:
 1. KinectControl
 2. BaseKinect
 */
import org.openkinect.processing.*; 

class KinectControl extends BaseKinect {

  /*
  DESCRIPCIÓN:A traves de la instancia de éste objeto se obtiene la imagen desde el kinect, tanto la de profundidad como la RGB y se segmenta la imagen de la profundidad. 
   
   Notas: 
   1. EL algoritmo de segmentación (véase función segmentBubble()) recorre la imágen pixel por pixel. Se calcula la distancia 
   de los 4 pixeles vecinos del pixel (x,y). Si alguna distancia es menor a "umbral" el pixel (x,y) y sus pixeles vecinos se deben
   colorearse del color almacenado en la variable "background", si no, el pixel (x,y) se colorea del color almacenado por la variable "object"
   
   2. Como la cámara RGB y la de profundidad se encuentran en diferentes lugares a través de las variables "posCloudX", "posCloudY", "posXColor", "posYColor" se 
   calibra para emparejar el color con la profundidad.
   
   3. Se manejan 3 tipos de imagenes. La primera es la imagen RGB, con ella se obtiene el color de los pixeles (variable "imgRGB"). La segunda es la imagen de 
   profundidad pero segmentada en regiones (variable "imgDepth"). La tercera es la imágen con los valores crudos de profundidad. Con las tres imagenes se 
   obtiene el color, la porfundidad de cada pixel y la región a la que pertenece. Las regione pueden ser las manos, el mismo brazo o calquier otro objeto 
   que se encuentre dentro de la vista del kinect.
   
   4. Las variables "csColor00", "csColor01", "csColor10", "csColor11" se utilizan para localizar con un sistema de coordenadas las esquinas 
   de la imagen de profundidad dentro del espacio 3D.
   */

  //Imagen del Kinect
  private PImage imgRGB;
  //Imagen del kinect que es usada para segmentar la profundidad
  private PImage imgDepth; 
  //Imagen del kinect con los datos de profundidad (no se segmenta, solo se guarda la información de profundidad)
  private PImage imgDepthValues; 
  //Datos de profundidad
  public int[] depth;
  //Variables auxilares para calcular la posición de cada punto de la nube de puntos
  private float[][] pointInKinect, pointInWord;
  //Guarda el índice de los pixeles vecinos de un pixel i
  private int[] neighbor;
  //Variable auxiliar
  private CoordinateSystem csColorAux;
  //Colores para segmentar la imagen
  private color object, background;
  //Posiciones de la nube de puntos y el color sobre el último sistema de coordenadas del kinect
  private int posCloudX, posCloudY, posXColor, posYColor;

  //Objeto Kinect
  public Kinect kinect;
  //Sistemas de coordenadas del color dentro del último sistema de coordenadas del kinect
  public CoordinateSystem csColor00, csColor01, csColor10, csColor11 ; 
  //Densidad de la nube de puntos. Entre menor sea el valor más puntos aparecen.
  public int resolution;
  //Umbral de algoritmo (ver función segmentBubble(int))
  public float umbral;


  /*
  CONSTRUCTOR.
   PARAMS:
   a: Referencia del pde principal, donde va la función draw() y update()
   */
  KinectControl(PApplet a) {
    neighbor = new int[8];
    umbral = 160;

    object = color(255);
    background = color(100);
    //se inicializa la imagen RGB y de profundidad del kinect
    kinect = new Kinect(a);
    kinect.initDepth();
    kinect.initVideo();

    //se inicializa la imagen
    imgRGB = createImage(640, 480, RGB);
    imgDepthValues = createImage(640, 480, RGB);
    imgDepth = new PImage(640, 480, RGB);

    //variables auxiliares para imprimir la nube de puntos
    pointInKinect = new float[4][1];
    pointInWord = new float[4][1];
    pointInKinect[3][0] = 1;
    pointInWord[3][0] = 1;

    posCloudX = -320;
    posCloudY = -240;

    csColor00 = new CoordinateSystem();
    csColor01 = new CoordinateSystem();
    csColor10 = new CoordinateSystem();
    csColor11 = new CoordinateSystem();
    csColorAux = new CoordinateSystem();

    resolution = 4;
  }

  /*
  DESCRIPCIÓN: Obtiene la imagen RGB del kinect
   PARAMS: void
   */
  public void getImageFromKinect() {
    imgRGB = kinect.getVideoImage().copy();
    //imgRGB = kinect.getDepthImage().copy();
  }

  /*
  DESCRIPCIÓN: Muestra la nube de puntos en el espacio 3D
   PARAMS: void
   */
  public void showCloudPoints() {

    imgRGB.loadPixels();
    imgDepth.loadPixels();
    imgDepthValues.loadPixels();
    //se obtiene la profundidad
    depth = kinect.getRawDepth();
    //se imprime la nube de puntos

    for (int x = 0; x < kinect.width; x+=resolution) {
      for (int y = 0; y < kinect.height; y+=resolution) {
        int offset = x + y*kinect.width;
        int offset2 = (x+posXColor)+(y+posYColor)*kinect.width;
        //se establece el color del punto
        if (x+posXColor>= 0 && x+posXColor < kinect.width && y+posYColor < kinect.height && y+posYColor >= 0) {
          stroke(red(imgRGB.pixels[offset2]), green(imgRGB.pixels[offset2]), blue(imgRGB.pixels[offset2]));
        } else {
          stroke(0, 255, 0);
        }

        pointInKinect[0][0] = (x+posCloudX);
        pointInKinect[1][0] = (y+posCloudY);
        pointInKinect[2][0] =  depth[offset];
        //se obtiene la posicion del punto segun la psición de la base del kinect
        MatrixOperations.multiplyMatrices(E3.HMNextEslabon, pointInKinect, pointInWord);
        //se muestra el punto en su posición correspondiente
        pushMatrix();
        translate(pointInWord[0][0], pointInWord[1][0], pointInWord[2][0]);
        point(0, 0);
        popMatrix();
      }
    }
    //segmentBubble(depth);
    imgDepth.updatePixels();
    imgDepthValues.updatePixels();
  }

  /*
  DESCRIPCIÓN: Devuelve la imagen de profundidad del kinect, segmentada
   PARAMS: 
   */
  public PImage getSegmentedDepthImg() {
    PImage p = imgDepth.copy();
    p.resize(480, 360);
    return p;
  }  

  /*
  DESCRIPCIÓN: Devuelve la imagen de profundidad desde el kinect sin segmentar.
   PARAMS: void
   */
  public PImage getValuesDepthImg() {
    PImage p = imgDepthValues.copy();
    p.resize(480, 360);
    return p;
  }

  /*
  DESCRIPCIÓN: Mueve la nube de puntos dentro del último sistema de coordenadas del modelo del kinect en los ejes X,Y. 
   También recorre el color dentro de la nube de puntos.
   
   PARAMS: 
   xCloud, yCloud: Posición de la nube puntos dentro del último sistema de coordenadas del modelo del kinect.
   xColor, yColor: Posición del color dentro de la nube de puntos.
   */
  public void model(int xCloud, int yCloud, int xColor, int yColor) {
    if (depth != null) { 
      segmentBubble(depth);
    }
    coordinateSystemsCloudPoint(xCloud, yCloud);
    coordinateSystemsColor(xColor, yColor);
  }

  /*
  DESCRIPCIÓN: Segmenta la nube de puntos. Los colores de una misma área lo establece la variiable "object" y "background" las lineas que separan las áreas.
   PARAMS: 
   depth: Array que almacena los valores de profundidad. La variable "depth" almacena dicha información.
   */
  private void segmentBubble(int[] depth) {
    int skip=1;
    imgDepth.loadPixels();
    for (int x = 1; x < kinect.width-1; x+=skip) {
      for (int y = 1; y < kinect.height-1; y+=skip) {
        int index = x + y * kinect.width;

        //Se almacena la profundidad en una imagen por facilidad, comodidad y alta efectividad
        imgDepthValues.pixels[index] = depth[index];

        //Se calcula el indice dentro del array de los pixeles vecinos
        neighbor[7] = (x-1)+(y+1)*kinect.width;
        neighbor[6] = (x)+(y+1)*kinect.width;
        neighbor[5] = (x+1)+(y+1)*kinect.width;
        neighbor[4] = (x+1)+(y)*kinect.width;
        neighbor[3] = (x+1)+(y-1)*kinect.width;
        neighbor[2] = x+(y-1)*kinect.width;
        neighbor[1] = (x-1)+(y-1)*kinect.width;
        neighbor[0] = (x-1)+y*kinect.width;

        //Distancia desde el pixel centrala  a cada uno de sus vecinos.
        float d7 = dist(x, y, depth[index], (x-1), (y+1), depth[neighbor[7]]);
        float d6 = dist(x, y, depth[index], (x), (y+1), depth[neighbor[6]]);
        float d5 = dist(x, y, depth[index], (x+1), (y+1), depth[neighbor[5]]);
        float d4 = dist(x, y, depth[index], (x+1), (y), depth[neighbor[4]]);
        float d3 = dist(x, y, depth[index], (x+1), (y-1), depth[neighbor[3]]);
        float d2 = dist(x, y, depth[index], x, (y-1), depth[neighbor[2]]);
        float d1 = dist(x, y, depth[index], (x-1), (y-1), depth[neighbor[1]]);
        float d0 = dist(x, y, depth[index], (x-1), y, depth[neighbor[0]]);

        boolean exist = false;

        //Se identifica de que color se va a colorear el pixel, dependiendo si suoeran el umbral o no
        if (d7 <= umbral) { 
          imgDepth.pixels[neighbor[7]] = object;
        } else { 
          imgDepth.pixels[neighbor[7]] = background;
          exist = true;
        }

        if (d6 <= umbral) { 
          imgDepth.pixels[neighbor[6]] = object;
        } else { 
          imgDepth.pixels[neighbor[6]] = background;
          exist = true;
        }

        if (d5 <= umbral) { 
          imgDepth.pixels[neighbor[5]] = object;
        } else { 
          imgDepth.pixels[neighbor[5]] = background;
          exist = true;
        }

        if (d4 <= umbral) { 
          imgDepth.pixels[neighbor[4]] = object;
        } else {
          imgDepth.pixels[neighbor[4]] = background;
          exist = true;
        }

        if (d3 <= umbral) { 
          imgDepth.pixels[neighbor[3]] = object;
        } else {
          imgDepth.pixels[neighbor[3]] = background;
          exist = true;
        }

        if (d2 <= umbral) { 
          imgDepth.pixels[neighbor[2]] = object;
        } else {
          imgDepth.pixels[neighbor[2]] = background;
          exist = true;
        }

        if (d1 <= umbral) { 
          imgDepth.pixels[neighbor[1]] = object;
        } else {
          imgDepth.pixels[neighbor[1]] = background;
          exist = true;
        }

        if (d0 <= umbral) { 
          imgDepth.pixels[neighbor[0]] = object;
        } else { 
          imgDepth.pixels[neighbor[0]] = background;
          exist = true;
        }

        //Si algún pixel tiene un vecino que supera el umbral de distancia, el pixel central junto con todos sus vecinos se colorean del color que guarde la variable "background"
        if (exist) {
          for (int i = 0; i < 8; i++) {
            imgDepth.pixels[neighbor[i]] = background;
          }
        }
      }
    }
  }

  /*
  DESCRIPCION: Determina la posicion de los sistemas de coordenadas de las esquinas de la imágen de la nube de puntos y 
   el centro de la imagen del kinect dentro del último sistema de coordenadas del kinect dentro de los ejes x,y
   */
  private void coordinateSystemsCloudPoint(int x, int y) {
    posCloudX = x;
    posCloudY = y;

    csAux.reset();
    csAux.moveCS(x, y, 0);
    MatrixOperations.multiplyMatrices(E3.HMNextEslabon, csAux.X, csCloud00.X);
    MatrixOperations.multiplyMatrices(E3.HMNextEslabon, csAux.Y, csCloud00.Y);
    MatrixOperations.multiplyMatrices(E3.HMNextEslabon, csAux.Z, csCloud00.Z);
    MatrixOperations.multiplyMatrices(E3.HMNextEslabon, csAux.origen, csCloud00.origen);

    csAux.reset();
    csAux.moveCS(x+640, y, 0);
    MatrixOperations.multiplyMatrices(E3.HMNextEslabon, csAux.X, csCloud01.X);
    MatrixOperations.multiplyMatrices(E3.HMNextEslabon, csAux.Y, csCloud01.Y);
    MatrixOperations.multiplyMatrices(E3.HMNextEslabon, csAux.Z, csCloud01.Z);
    MatrixOperations.multiplyMatrices(E3.HMNextEslabon, csAux.origen, csCloud01.origen);

    csAux.reset();
    csAux.moveCS(x, y+480, 0);
    MatrixOperations.multiplyMatrices(E3.HMNextEslabon, csAux.X, csCloud10.X);
    MatrixOperations.multiplyMatrices(E3.HMNextEslabon, csAux.Y, csCloud10.Y);
    MatrixOperations.multiplyMatrices(E3.HMNextEslabon, csAux.Z, csCloud10.Z);
    MatrixOperations.multiplyMatrices(E3.HMNextEslabon, csAux.origen, csCloud10.origen);

    csAux.reset();
    csAux.moveCS(x+640, y+480, 0);
    MatrixOperations.multiplyMatrices(E3.HMNextEslabon, csAux.X, csCloud11.X);
    MatrixOperations.multiplyMatrices(E3.HMNextEslabon, csAux.Y, csCloud11.Y);
    MatrixOperations.multiplyMatrices(E3.HMNextEslabon, csAux.Z, csCloud11.Z);
    MatrixOperations.multiplyMatrices(E3.HMNextEslabon, csAux.origen, csCloud11.origen);

    csAux.reset();
    csAux.moveCS(x+320, y+240, 0);
    MatrixOperations.multiplyMatrices(E3.HMNextEslabon, csAux.X, csCloudCenter.X);
    MatrixOperations.multiplyMatrices(E3.HMNextEslabon, csAux.Y, csCloudCenter.Y);
    MatrixOperations.multiplyMatrices(E3.HMNextEslabon, csAux.Z, csCloudCenter.Z);
    MatrixOperations.multiplyMatrices(E3.HMNextEslabon, csAux.origen, csCloudCenter.origen);
  }

  /*
  DESCRIPCION: Determina la posicion de los sistemas de coordenadas de las esquinas y el centro de la imagen del kinect dentro del último sistema de 
   coordenadas del kinect dentro de los ejes x,y
   */
  private void coordinateSystemsColor(int x, int y) {
    posXColor = x;
    posYColor = y;
    //Se encuentra la ubicación de los colores respecto a la nube de puntos

    //para csColor00
    float x1 = posCloudX - posXColor;
    float y1 = posCloudY - posYColor;

    csColorAux.reset();
    csColorAux.moveCS(x1, y1, 0);
    MatrixOperations.multiplyMatrices(E3.HMNextEslabon, csColorAux.X, csColor00.X);
    MatrixOperations.multiplyMatrices(E3.HMNextEslabon, csColorAux.Y, csColor00.Y);
    MatrixOperations.multiplyMatrices(E3.HMNextEslabon, csColorAux.Z, csColor00.Z);
    MatrixOperations.multiplyMatrices(E3.HMNextEslabon, csColorAux.origen, csColor00.origen);

    //Para csColor01
    float x2 = x1+imgRGB.width; 
    float y2 = y1;

    csColorAux.reset();
    csColorAux.moveCS(x2, y2, 0);
    MatrixOperations.multiplyMatrices(E3.HMNextEslabon, csColorAux.X, csColor01.X);
    MatrixOperations.multiplyMatrices(E3.HMNextEslabon, csColorAux.Y, csColor01.Y);
    MatrixOperations.multiplyMatrices(E3.HMNextEslabon, csColorAux.Z, csColor01.Z);
    MatrixOperations.multiplyMatrices(E3.HMNextEslabon, csColorAux.origen, csColor01.origen);

    //Para csColor10
    x2 = x1; 
    y2 = y1+imgRGB.height;

    csColorAux.reset();
    csColorAux.moveCS(x2, y2, 0);
    MatrixOperations.multiplyMatrices(E3.HMNextEslabon, csColorAux.X, csColor10.X);
    MatrixOperations.multiplyMatrices(E3.HMNextEslabon, csColorAux.Y, csColor10.Y);
    MatrixOperations.multiplyMatrices(E3.HMNextEslabon, csColorAux.Z, csColor10.Z);
    MatrixOperations.multiplyMatrices(E3.HMNextEslabon, csColorAux.origen, csColor10.origen);

    //Para csColor10
    x2 = x1+imgRGB.width; 
    y2 = y1+imgRGB.height;

    csColorAux.reset();
    csColorAux.moveCS(x2, y2, 0);
    MatrixOperations.multiplyMatrices(E3.HMNextEslabon, csColorAux.X, csColor11.X);
    MatrixOperations.multiplyMatrices(E3.HMNextEslabon, csColorAux.Y, csColor11.Y);
    MatrixOperations.multiplyMatrices(E3.HMNextEslabon, csColorAux.Z, csColor11.Z);
    MatrixOperations.multiplyMatrices(E3.HMNextEslabon, csColorAux.origen, csColor11.origen);
  }

  /*
  DESCRIPCIÓN: Muestra el modelo del kinect dentro del canvas.
   PARAMS: void
   */
  public void showKinect() {
    //Sistemas de coordenadas de la nube de puntos
    csCloud00.showCS("Cloud(0,0)");
    csCloud01.showCS("Cloud(0,1)");
    csCloud10.showCS("Cloud(1,0)");
    csCloud11.showCS("Cloud(1,1)");

    //Sistemas de coordenadas del color
    csColor00.showCS("Color(0,0)");
    csColor01.showCS("Color(0,1)");
    csColor10.showCS("Color(1,0)");
    csColor11.showCS("Color(1,1)");

    //Sistemas de coordenadas de cada link del kinect
    E1.showCoordinateSystem();
    E2.showCoordinateSystem();
    E3.showCoordinateSystem();
    E3.showAttachedCoordinateSystem();

    //Eslabones
    E1.showEslabon();
    E2.showEslabon();
    E3.showEslabon();
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

class BaseKinect {
  /*
  DESCRIPCIÓN: Clase usada para crear el modelo matemático del Robot. EL modelo es usado para ubicar las nube de puntos dentro del modelo matemático.
   
   NOTAS:
   1. Las variables "csCloud00", "csCloud01", "csCloud10", "csCloud11", "csCloudCenter" se usan para calcular las esquinas de la imágen de color 
   dentro del espacio 3D. 
   
   2. Se puede modificar el ángulo de giro de cada articulación del modelo del kinect con las variables "angleE1", "angleE2", "angleE3".
   
   3. Los Eslabones se encargan de construir el modelo matemático del kinect a través de matrices de transformación homogénea.
   */

  //longitud de los eslabones
  private float lengthE1, lengthE2, lengthE3;
  //indica si se debe realiza un cambio al modelo o se mantiene igual
  private boolean changeValue;
  //Escala del modelo.
  private float escala;

  //Sitemas de coordenadas de las esquina de la imagen del kinect
  public CoordinateSystem csCloud00, csCloud01, csCloud10, csCloud11, csCloudCenter, csAux;
  //agulo de giro de los eslabones
  public float angleE1, angleE2, angleE3;
  //Eslabones
  public Eslabon E1, E2, E3;

  /*
  CONSTRUCTOR
   */
  BaseKinect() {
    E1 = new Eslabon(0, 0);
    E2 = new Eslabon(0, 0);
    E3 = new Eslabon(0, 0);

    //longitud de cada eslabon
    //lengthE1 = 44.75;
    lengthE1 = 39;
    lengthE2 = 43.3;
    lengthE3 = -9.65;

    //escala del modelo. Si Escala=10 la unidad de medida es milimetros 
    escala = 10;

    //angulos de cada eslabon
    angleE1 = radians(315);
    angleE2 = PI/2;
    angleE3 = radians(270);

    //Sistemas de coordenadas de las equinas y el centro del kinect
    csAux = new CoordinateSystem();
    csCloud00 = new CoordinateSystem();
    csCloud01 = new CoordinateSystem();
    csCloud10 = new CoordinateSystem();
    csCloud11 = new CoordinateSystem();
    csCloudCenter = new CoordinateSystem();

    changeValue = true;
  }

  /*
  DESCRIPCION: Cambia el tamaño del eslabon
   PARAMS: 
   l1k, l2k, l3k: Nuevo tamaño del eslabón 1,2 y 3 respectivamente.
   */
  public void setLengthLink(float l1k, float l2k, float l3k) {
    if (lengthE1 != l1k) {
      lengthE1 = l1k;
      changeValue = true;
    }
    if (lengthE2 != l2k) {
      lengthE2 = l2k;
      changeValue = true;
    } 

    if (lengthE3 != l3k) {
      lengthE3 = -1*l3k;
      changeValue = true;
    }
  }

  /*
  DESCRIPCION: Regresa el tamaño del eslabon
   PARAMS:
   link:  link del que se quiere obtener su tamaño. Puede tener los valores "l1"-"l3"
   */
  public float getLengthLink(String link) {
    if (link.equals("l1")) {
      return lengthE1;
    } else {
      if (link.equals("l2")) {
        return lengthE2;
      } else {
        if (link.equals("l3")) {
          return -1*lengthE3;
        }
      }
    }
    return 0;
  }

  /*
  DESCRIPCION: Rota un eslabon sobre su eje de giro.
   PARAMS: 
   e1, e3: ángulo de giro de los servos 1 y 2 del modelo del kinect, respectivamente.
   */
  public void rotateServo(float e1, float e3) {
    if (angleE1 != e1) {
      angleE1 = e1;
      changeValue = true;
    }

    if (angleE3 != e3) {
      angleE3 = e3;
      changeValue = true;
    }
  }

  /*
  DESCRIPCIÓN: Realiza la cinemática de seguimiento del modelo del kinect
   PARAMS: void
   */
  public void perfomFollowKinematic() {
    if (changeValue) {
      changeValue = false;
      E1.performTransformation(angleE1, lengthE1*escala, 0, 0);
      E2.performTransformation(angleE2, 0, lengthE2*escala, 0);
      E3.performTransformation(angleE3, lengthE3*escala, 0, PI);

      E1.enlazarInit();
      E2.enlazar(E1.HMNextEslabon);
      E3.enlazar(E2.HMNextEslabon);
    }
  }
}
