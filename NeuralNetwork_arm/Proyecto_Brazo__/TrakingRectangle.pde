import boofcv.processing.*;
import boofcv.struct.image.*;
import georegression.struct.point.*;
import georegression.struct.shapes.*;

/*
Clases que contiene el PDE:
 1. TrackingRectangle
 2. TrackingRectangleBoofCV
 3. TrackingRectangleCromatics
 4. Labeling
 5. ColorDescriptor
 6. Blob
 7. DataEquival
 */

abstract class TrackingRectangle {

  /*
  DESCRIPCIÓN: Clase abstracta del rectangulo de seguimiento. El rectangulo de seguimiento es el encargado de seguir el objeto deseado dentro del vídeo.
   
   NOTAS: 
   1. Se utiliza ésta clase para poder utilizar variables genericas que manejen los rectángulos de seguimiento sin importar de que tipo son. 
   
   2. Se considera ésta clase como la generalización de un rectangulo de seguimiento. Los mienbros de clase son las caracteristicas generales de un rectangulo
   de seguimiento como  las dimenciones, cuando es un rectangulo de seguimiento específico como uno TrackingRectangleBoofCV, tiene un miembro llamado
   algorithm que guarda el número de algoritmo usado por el rectángulo de seguimiento.
   
   3. Para que una variable de éste tipo guarde un rectángulo de seguimiento específco se debe hacer un down-cast
   Ejemplo:
   
   TrackingRectangleBoofCV a = new TrackingRectangleBoofCV();
   TrackingRectangle b = (TrackingRectangle)a;
   */


  //texto de identificacion de cuadro
  public String text;
  //esquinas del cuadrado de busqueda 
  public PVector c1, c2, c3, c4;
  //indica si el rectangulo de busqueda tiene dimenciones validas
  public boolean validSizeRectangle;
  //Frames de procesamiento
  public int frameRateTR;
  //posiciones del rectangulo de seguimiento
  public int posXCenter;
  public int posYCenter;
  //tamaños minimos para el rectangulo de seguimiento
  public float tamWidth, tamHeight;
  //VARIABLES IMPORTANTES PARA LA CLASE "TrackingRectangleCromatics" Y SERÁN NULL CUADO SEAN USADAS EN UNA INSTANCIA DE LA CLASE "TrackingRectangleBoofCV"
  //Posiciones de los colores cromaticos.
  public float[] posColorCromaR;
  public float[] posColorCromaG;
  public float[] posColorCromaB;
  //Indica si es un color seleccionado o no
  public float[] isSelected;
  //almacena los descriptores de color
  public ColorDescriptor[] descriptores;
  //Indica si se esta seleccionando el rectangulo de seguimiento
  public boolean drag;
  /*
  Diseño del rectangulo de seguimiento
   O-----> X
   |  c1--c2
   |  |    |
   |  c3--c4
   Y
   */

  TrackingRectangle() {
    c1 = new PVector(0, 0, 0);
    c2 = new PVector(0, 0, 0);
    c3 = new PVector(0, 0, 0);
    c4 = new PVector(0, 0, 0);
  }

  /*
  DESCRIPCIÓN: Reinicia o borra el rectangulo de seguimiento
   PARAMS: void
   */
  public abstract void reset();

  /*
  DESCRIPCIÓN: Procesa la imagem para realizar el seguimiento del objeto seleccionado. 
   PARAMS: 
   i: Imagen sobre la cual se realiza el seguimiento
   */
  public abstract void model(PImage i);

  /*
  DESCRIPCIÓN: Muestra el rectángulo de seguimiento dentro del Canvas
   PARAMS: void
   */
  public abstract void view();

  /*
  DESCRIPCION: Función ejecutada cada vez que se deje de precionar un botón del mouse
   PARAMS: void
   */
  public abstract void mouseReleased();

  /*
  DESCRIPCION: Función ejecutada cada vez que se precione un botón del mouse
   PARAMS: void
   */
  public abstract void mousePressed();

  /*
  DESCRIPCION: Función ejecutada cada vez que se deje precionado un botón del mouse
   PARAMS: void
   */
  public abstract void mouseDragged();
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

class TrackingRectangleBoofCV extends TrackingRectangle {
  /*
  DESCRIPCION: Clase usada para crear un rectángulo de seguimiento que usa los algoritmos proporcionados por BoofCV  para realizar el seguimiento de los objetos.
   */

  //Procesa la imagen con alguno de los 4 algoritmos que maneja la clase para realizar el seguimiento al objeto deseado.
  private SimpleTrackerObject[] tracker;
  //Rectángulo de seguimiento
  private Quadrilateral_F64 target;
  //Indica si existe un error de inicialización del algoritmo de seguimiento
  private boolean errorIni;
  //informa si el traker ha encontrado el  objeto a seguir
  private boolean targetVisible;
  //Imagen base
  private PImage img;

  //Numero de algoritmo seleccionado
  public int algorithm;

  /*
  CONSTRUCTOR.
   DESCRIPCIÓN: 
   PARAMS: 
   x,y: Posición inicial del rectángulo de seguimiento.
   t: Texto identificativo del rectángulo de seguimiento. EL texto se muestra arriba del rectángulo de seguimiento.
   */
  TrackingRectangleBoofCV(int x, int y, String t) {
    tamHeight = 5;
    tamWidth = 5;
    target = new Quadrilateral_F64();
    tracker = new SimpleTrackerObject[4];
    tracker[0] = Boof.trackerCirculant(null, ImageDataType.F32);
    tracker[1] = Boof.trackerTld(null, ImageDataType.F32);
    tracker[2] = Boof.trackerMeanShiftComaniciu(null, ImageType.pl(3, GrayF32.class));
    tracker[3] = Boof.trackerSparseFlow(null, ImageDataType.F32);
    drag = false;
    errorIni = false;
    targetVisible = false;
    validSizeRectangle = false;
    algorithm = 0;
    posXImgKinect = x;
    posYImgKinect = y;
    text = t;
    img = new PImage(480, 360);
    frameRateTR = 1;
  }

  /*
  DESCRIPCIÓN: Procesa la imagem para realizar el seguimiento del objeto seleccionado. 
   PARAMS: 
   i: Imagen sobre la cual se realiza el seguimiento
   */
  @Override
    public void model(PImage i) {
    img = i;
    if (!drag && validSizeRectangle && !errorIni) {
      //Tasa de procesamiento 
      if (frameCount%frameRateTR == 0) {
        //Se procesa la imagen
        if ( tracker[algorithm].process(img) ) {
          //Se obtiene la localización y se pasa al rectangulo de seguimiento
          target.set(tracker[algorithm].getLocation());
          //Se mueve el rectángulo de seguimiento a su nueva posición
          c1.x = (float)target.a.x;
          c1.y = (float)target.a.y;

          c2.x = (float)target.b.x;
          c2.y = (float)target.b.y;

          c3.x = (float)target.d.x;
          c3.y = (float)target.d.y;

          c4.x = (float)target.c.x;
          c4.y = (float)target.c.y;

          //Se manda la señal de que si se identificó el objeto
          targetVisible = true;

          //Se calcula el centro
          float a = abs((float)(target.a.x-target.b.x))/2;
          float b =  abs((float)(target.a.y-target.d.y))/2;

          //posicion dentro de la imagen
          posXCenter = int(a + (float)target.a.x);
          posYCenter = int(b + (float)target.a.y);
        } else targetVisible = false;
      }
    }
  }

  /*
  DESCRIPCIÓN: Cambia el algoritmo utilizado para realizar el seguimento del objeto seleccionado.
   PARAMS:
   num: Numero de algoritmo a seleccionar. Los valores válidos son [0,3]
   */
  public int changeAlgorithm(int num) {
    if (0 <= num && num <= 3 ) {
      //Se selecciona el algoritmo
      algorithm = num;
    } else errorIni = true;
    return -1;
  }

  /*
  DESCRIPCIÓN: Reinicia el rectángulo de seguimiento, detiene el seguimiento y desaparece el rectángulo de seguimiento del Canvas.
   PARAMS: void
   */
  @Override
    public void reset() {
    validSizeRectangle = false;
    target.a.set(0, 0);
    target.b.set(0, 0);
    target.c.set(0, 0);
    target.d.set(0, 0);
  }

  /*
  DESCRIPCIÓN: Muestra el rectangulo de seguimiento dentro del Canvas. En caso de que ocurra un error el rectángulo de seguimiento muestra el estado en el que
   se encuentra.
   
   PARAMS: void
   */
  @Override
    public void view() {
    if (validSizeRectangle) {
      //texto de idetificador de cuadro
      fill(0);
      textSize(15);
      text(text, (float)(posXImgKinect+target.a.x+3), (float)(posYImgKinect+target.a.y-2));
      showTrackingRectangle();

      fill(255, 0, 0);
      textSize(10);
      if (!targetVisible) {
        text("No se puede \ndetectar el objeto", (float)(posXImgKinect+target.a.x), (float)(target.a.y+posYImgKinect+abs((float)(target.a.y-target.d.y))/2));
      }
      if ( errorIni ) {
        text("Error de inicialización.\nSelecciona de nuevo.", (float)(posXImgKinect+target.a.x), (float)(target.a.y+posYImgKinect+abs((float)(target.a.y-target.d.y))/2));
      }
    }
  }

  /*
  DESCRIPCIÓN: Muestra el rectangulo de seguimiento manejado por BoofCV, dentro del Canvas.
   PARAMS: void
   */
  private void showTrackingRectangle() {
    stroke(0);
    line2(target.a, target.b);
    line2(target.b, target.c);
    line2(target.c, target.d);
    line2(target.d, target.a);
  }

  /*
  DESCRIPCIÓN: Crea una linea entre dos puntos del rectangulo de seguimiento manejado por BoofCV
   PARAMS:
   a,b: Puntos que foman la linea
   */
  private void line2( Point2D_F64 a, Point2D_F64 b ) {
    line((float)a.x+posXImgKinect, (float)a.y+posYImgKinect, (float)b.x+posXImgKinect, (float)b.y+posYImgKinect);
  }

  /*
  DESCRIPCION: Función ejecutada cada vez que se precione un botón del mouse
   PARAMS: void
   */
  @Override
    public void mousePressed() {
    if (posXImgKinect < mouseX && mouseX < posXImgKinect+img.width && posYImgKinect < mouseY && mouseY < posYImgKinect+img.height ) {
      drag = true;
      target.a.set(mouseX-posXImgKinect, mouseY-posYImgKinect);
      target.b.set(mouseX-posXImgKinect, mouseY-posYImgKinect);
      target.c.set(mouseX-posXImgKinect, mouseY-posYImgKinect);
      target.d.set(mouseX-posXImgKinect, mouseY-posYImgKinect);
    }
  }

  /*
  DESCRIPCION: Función ejecutada cada vez que se mantiene precionado un botón del mouse
   PARAMS: void
   */
  @Override
    public void mouseDragged() {
    if (drag) {
      drag = true;
      target.b.x = mouseX-posXImgKinect;
      target.c.set(mouseX-posXImgKinect, mouseY-posYImgKinect);
      target.d.y = mouseY-posYImgKinect;
    }
  }

  /*
  DESCRIPCION: Función ejecutada cada vez que se deje de precionar un botón del mouse
   PARAMS: void
   */
  @Override
    public void mouseReleased() {
    drag = false;
    float d1 = dist((int)target.a.x, (int)target.a.y, (int)target.b.x, (int)target.b.y);
    float d2 = dist((int)target.a.x, (int)target.a.y, (int)target.d.x, (int)target.d.y);

    //se comprueba si el rectangulo de seguimiento tiene dimenciones validas.
    //Se realiza esto para evitrar que se creen rectangulos de seguimientos muy pequeños
    if (d1 > tamWidth && d2 > tamHeight) {
      validSizeRectangle = true;

      //Se inicializa el algoritmo de seguimiento
      if ( tracker[algorithm].initialize(img, target.a.x, target.a.y, target.c.x, target.c.y) ) errorIni = false;
      else errorIni = true;
    } else {
      validSizeRectangle = false;
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


class TrackingRectangleCromatics extends TrackingRectangle {
  /*
  DESCRIPCION: Clase encargada de realizar el seguimiento de objetos por colores cromáticos.
   
   NOTAS:
   1. Éste tipo de rectángulo extrae un pedazo de la imágen del mismo tamaño del rectangulo de seguimiento y en la misma posición. La imagen extraiada 
   es sobre la cual se hará el procesamiento para detectar el objeto.
   
   2. El rectángulo de seguimiento cuenta con un pincel seleccionador que sigue al puntero del mouse. Dicho puntero es usado para seleccionar pixeles de manera
   aleatoria cada vez que se le da click a una parte de la imagen. Si un pixel es seleccionado se almacena en la variable "selectedColors".
   
   3. Los colores seleccionados se ubican dentro del espacio de color cromático y se les crea un descriptor de color en la misma posición. 
   
   3. EL algoritmo busca los pixeles que tengan los colores almacenados en la variable "selectedColors" o que se encuentre dentro de un descriptor de color.
   Si un pixel tiene el color buscado o se encuentra dentro de un descriptor de color entonces se pinta de color "colorObject" si no de color "colorBackground".
   
   4. Con la variable "numColors"  se puede establecer el número de pixeles que serán seleccionados para buscar su color en la imagen.
   
   5. Como resultado de la búsqueda de colores en la iamgen queda una imagen binaria con los colores "colorBackground" y "colorObject". Si dos pixeles adyacentes
   tienen el mismo color, empiezan a formar áreas. Un área es una zona donde los pixeles que la conforman tienen el mismo color y desde cualquier pixel se puede
   llegar a cualquier otro sin pasar por otro que no sea del mismo color.
   
   6. Las áreas son encerradas con Blobs para ubicarlas y dimencionarlas. Cuando una imagen se manda a realizarle el Labeling 
   (encontar, ubicar, dimencionar y etiquetar las áreas) las áreas detectadas se almacenan dentro de la variable "labeling.candidates". Las áreas candidatas 
   son de tipos DataEquival que almacena la información relacionada con el área (véase clase DataEquival).
   
   7. La variable "target" almacena el candidato seleccionado en la imagen RGB.
   */

  //objeto que hara el labeling en la imagen
  private Labeling labeling;
  //color al cual se pasarán los pixeles que tengan un color buscado por un descriptor de color
  private color colorObject;
  //color al cual se pasarán lso pixeles que no tengan un color buscado por un descriptor de color.
  private color colorBackground;
  //colores a buscar en la imagen 
  private color[] selectedColors;
  //variable auxiliar
  private int tamArista;
  //imagen base
  private PImage img;

  //Imágen extraida de la imagen base con tamaño y posición del rectángulo de seguimiento.
  public PImage imgTracking;
  //indica si se muestra la imagen del rectangulo de seguimiento dentro del Canvas.
  public boolean showImg;
  //Distancia que debe superar el blob del target (objeto a seguir) para que cambie de posición el rectángulo de seguimiento
  public float distStability;
  //numero de colores a buscar en la imagen
  public int numColors;
  //tamaño del sello seleccionador
  public int tamBrush;
  //Objeto seleccionado para seguirlo (ver funcion tracking)
  public DataEquival target;

  /*
  CONSTRUCTOR:
   PARAMS
   posX, posY: posicion de la imagen del kinect
   t: texto que se muestra en la esquia del cuadrado de busqueda
   d: descriptor de color al que controlan
   */
  TrackingRectangleCromatics(int posX, int posY, String t) {
    drag = false;
    c1 = new PVector(0, 0, 0);
    c2 = new PVector(0, 0, 0);
    c3 = new PVector(0, 0, 0);
    c4 = new PVector(0, 0, 0);
    posXImgKinect = posX;
    posYImgKinect = posY;
    imgTracking = createImage(200, 200, RGB);
    text = t;
    colorObject = color(255);
    colorBackground = color(100);
    labeling = new Labeling(colorObject);
    tamHeight = 5; 
    tamWidth = 5;
    numColors = 5;
    selectedColors = new color[numColors];
    tamBrush = 10;
    descriptores = new ColorDescriptor[numColors];
    for (int i = 0; i < numColors; i++) {
      descriptores[i] = new ColorDescriptor();
    }
    frameRateTR = 1;
    distStability = 10;
  }

  /*
  DESCRIPCION: Se encarga de realizar el procedimiento para realizar la deteccióon de objetos
   PARAMS: void
   */
  @Override
    public void model(PImage i) {
    img = i;
    if (!drag && validSizeRectangle) {
      if (frameCount%frameRateTR == 0) {
        //se extrae la imagen en el rectangulo de seguimiento
        labeling.extractImage(img, imgTracking, int(c1.x), int(c1.y));
        //se convierte en una imagen binaria a partir de los colores cromaticos
        convertToBinaryFromChromatics();
        //labeling de la imagen
        labeling.labelingImage(imgTracking);
        //se realiza el seguimiento
        tracking();
        //se determina la posición del rectangulo de seguimiento
        makeTrackingRectangle();
      }
    }
  }

  /*
  DESCRIPCIÓN: Reinicia el rectángulo de seguimiento, detiene el seguimiento y desaparece el rectángulo de seguimiento del Canvas.
   PARAMS: void
   */
  @Override
    public void reset() {
    validSizeRectangle = false;
    tamArista = 0;
    //se determina la posición del rectangulo de seguimiento
    makeTrackingRectangle();

    //Se reinician los colores seleccionados y los descriptores de color 
    for (int i = 0; i < selectedColors.length; i++) {
      selectedColors[i] = color(0);
      descriptores[i].posX = 0;
      descriptores[i].posY = 0;
      descriptores[i].posZ = 0;
    }

    //Se reinica el blob
    target=null;
  }

  /*
  DESCRIPCIÓN: Calcula las esquinas del rectángulo de seguimiento determinado por la variable "tamArista"
   PARAMS: 
   */
  private void makeTrackingRectangle() {
    c1.x = int(posXCenter - tamArista);
    c1.y = int(posYCenter - tamArista);

    c2.x = int(posXCenter + tamArista);
    c2.y = int(posYCenter - tamArista);

    c3.x = int(posXCenter - tamArista);
    c3.y = int(posYCenter + tamArista);

    c4.x = int(posXCenter + tamArista);
    c4.y = int(posYCenter + tamArista);
  }

  /*
  DESCRIPCION: Convierte los colores de una imágen a cromáticos y los almacena en las variables "posColorCromaR", "posColorCromaG" y "posColorCromaB" en su respectivo
   componente de color RGB. Los colores seleccionados por el pincel se ubican dentro del espacio cromático y se les crea un descriptor de color ubicado en la misma 
   posición. Si el color de un pixel se encuentra dentro del descriptor se colorea del color "colorObject" si no "colorBackground". Como resultado 
   queda una imágen binaria.
   
   PARAMS: void
   */
  private void convertToBinaryFromChromatics() {
    imgTracking.loadPixels();
    color c;

    for (int x = 0; x < imgTracking.width; x++) {
      for (int y = 0; y < imgTracking.height; y++) {
        int index = x + y * imgTracking.width;
        c = imgTracking.pixels[index];
        float r = red(c);
        float g = green(c);
        float b = blue(c);

        if ((r+g+b) != 0) {
          float r2 = r/(r+g+b);
          float g2 = g/(r+g+b);
          float b2 = b/(r+g+b);

          r2 = map(r2, 0, 1, 0, 255);
          g2 = map(g2, 0, 1, 0, 255);
          b2 = map(b2, 0, 1, 0, 255);

          //Se almacena la posición del color cromático del pixel en la posición "index"
          posColorCromaR[index] = r2;
          posColorCromaG[index] = g2;
          posColorCromaB[index] = b2;

          for (int i = 0; i < numColors; i++) {
            //se determina si el color cromatico se encuentra dentro del descriptor de color
            if (descriptores[i].limitR[0] < r2 && r2 < descriptores[i].limitR[1] && descriptores[i].limitG[0] < g2 && 
              g2 < descriptores[i].limitG[1] && descriptores[i].limitB[0] < b2 && b2 < descriptores[i].limitB[1]) {
              imgTracking.pixels[index] = colorObject;
              //determina si el color cormatico dentro de la posición "index" es un color buscado
              isSelected[index] = 1;
            } else {     
              imgTracking.pixels[index] = colorBackground;
              //determina si el color cormatico dentro de la posición "index" no es un color buscado
              isSelected[index] = 0;
            }
          }
        }
      }
    }
    imgTracking.updatePixels();
  }

  /*
  DESCRIPCION: Realiza el seguimiento del objeto. En ésta función se utilizan los candidatos encontrados por "labeling" (ver función solveEquivalencia()) y
   se debe elegir uno. Si la posición del área seleccionada tiene una  distancia mayor "distStability" del centro del rectángulo de seguimiento entonces
   la nueva posición del rectángulo de seguimiento pasa a tener la posición del área seleccionada.
   
   PARAMS: void
   */
  private void tracking() {
    float d=0, dMax = 100000, dBlob=0, pxBlob=0, pyBlob=0;
    target = null;

    //Se extraen los candidatos y se realiza la selección del candidato a seguir
    if (labeling.candidates.size() > 0) {
      for (DataEquival area : labeling.candidates) {
        //Posición del area candidato
        float pxC = area.blob.centerX+c1.x; 
        float pyC = area.blob.centerY+c1.y;

        //Criterio de selección: El area candidata más cercana al centro, es la que se selecciona
        d = dist(pxC, pyC, posXCenter, posYCenter);
        if (d <= dMax) {
          dMax = d;
          target = area;
        }
      }

      //Posición del area seleccionada
      pxBlob = target.blob.centerX+c1.x;
      pyBlob = target.blob.centerY+c1.y;

      //Estabilidad del rectangulo de seguimiento. Se cuenta las veces que se mantiene dentro de su area de movimiento
      if (dMax > distStability ) {
        posXCenter = int(target.blob.centerX+c1.x);
        posYCenter = int(target.blob.centerY+c1.y);
      }
    }
  }

  /*
  DESCRIPCION: Muestra la parte visual del rectángulo de seguimiento.
   PARAMS: void
   */
  @Override
    public void view() {
    //Se muestra el rengulo de seguimiento
    showTrackingRectangle();

    //Se muestra el sello selector
    if (posXImgKinect < mouseX && mouseX < posXImgKinect+img.width && posYImgKinect < mouseY && mouseY < posYImgKinect+img.height ) { 
      noFill();
      stroke(0);
      rect(mouseX-(tamBrush/2), mouseY-(tamBrush/2), tamBrush, tamBrush);
    }

    //Se muestran los colores seleccionados
    float d = dist(c3.x, c3.y, c4.x, c4.y);
    float tam = d/numColors;
    stroke(0);
    for (int i = 0; i< numColors; i++) {
      fill(selectedColors[i]);
      rect(c3.x+i*tam+posXImgKinect, c3.y+posYImgKinect, tam, 10);
    }

    //Se muestran todos los candidatos
    if (!drag && showImg && validSizeRectangle) {
      for (int i = 0; i < labeling.candidates.size(); i++) {
        DataEquival a = labeling.candidates.get(i);
        if (a != target) {
          //Area de absorcion
          noFill();
          stroke(255);
          rect(int(posXImgKinect+c1.x+a.blob.posXBlob-labeling.distBlob), int(posYImgKinect+c1.y+a.blob.posYBlob-labeling.distBlob), 
            (a.blob.maxx-a.blob.minx)+2*labeling.distBlob, (a.blob.maxy-a.blob.miny)+2*labeling.distBlob);
          //Se muestra el blob
          a.blob.showBlob(int(posXImgKinect+c1.x), int(posYImgKinect+c1.y), color(0, 0, 255));
        }
      }
    }

    //se muestra el blob del objeto a seguir
    if (target != null && !drag && showImg && validSizeRectangle) {
      //Area de absorcion
      noFill();
      stroke(255);
      rect(int(posXImgKinect+c1.x+target.blob.posXBlob-labeling.distBlob), int(posYImgKinect+c1.y+target.blob.posYBlob-labeling.distBlob), 
        (target.blob.maxx-target.blob.minx)+2*labeling.distBlob, (target.blob.maxy-target.blob.miny)+2*labeling.distBlob);
      target.blob.showBlob(int(c1.x)+posXImgKinect, int(c1.y)+posYImgKinect, color(255, 0, 0));
    }

    //Distancia estabilizadora
    if (validSizeRectangle) {
      noFill();
      stroke(#F26E77);
      ellipse(posXCenter+posXImgKinect, posYCenter+posYImgKinect, 2*distStability, 2*distStability);
    }
  }

  /*
  DESCRIPCIÓN: Cambia el número de pixeles que serán seleccionados por el pincel.
   PARAMS: 
   v: Nuevo número de colores a ser seleccionados.
   */
  public void setNumColors(int v) {
    if (v != numColors) {
      reset();
      numColors = v;
      selectedColors = new color[numColors];
      descriptores = new ColorDescriptor[numColors];
      for (int i = 0; i < numColors; i++) {
        descriptores[i] = new ColorDescriptor();
      }
    }
  }

  /*
  DESCRIPCION: Muestra el cuadrado de busqueda y si se desea, la imágen del rectángulo de seguimiento.
   PARAMS: void
   */
  private void showTrackingRectangle() {
    if (validSizeRectangle) {
      stroke(0);
      line(c1.x+posXImgKinect, c1.y+posYImgKinect, c2.x+posXImgKinect, c2.y+posYImgKinect);
      line(c3.x+posXImgKinect, c3.y+posYImgKinect, c4.x+posXImgKinect, c4.y+posYImgKinect);
      line(c1.x+posXImgKinect, c1.y+posYImgKinect, c3.x+posXImgKinect, c3.y+posYImgKinect);
      line(c2.x+posXImgKinect, c2.y+posYImgKinect, c4.x+posXImgKinect, c4.y+posYImgKinect);

      //texto de idetificador de cuadro
      fill(0);
      textSize(15);
      text(text, c1.x+3+posXImgKinect, c1.y-2+posYImgKinect);

      if (showImg && !drag) {
        image(labeling.imgColor, c1.x+posXImgKinect, c1.y+posYImgKinect);
      }
    }
  }

  /*
  DESCRIPCIÓN: Función ejecutada cada vez que se suelta un botón del mouse. La función debe ser mandada a llamar dentro de la función mouseReleased() del 
   pde principal (pdf donde va la función setup() y draw())
   
   PARAMS: void
   */
  @Override
    public void mouseReleased() {
    if (drag) {
      float d1 = dist(c1.x, c1.y, c2.x, c2.y);
      float d2 = dist(c1.x, c1.y, c3.x, c3.y );
      //se determina si es un ractangulo de seguimiento con dimenciones validas
      //Se realiza esto para evitrar que se creen rectangulos de seguimientos muy pequeños
      if (d1 > tamWidth && d2 > tamHeight) {
        validSizeRectangle = true;
        //SE SELECCIONAN LOS COLORES 
        float r, g, b;
        int valX, valY;
        //posición del rectangulo de seguimiento en el espacio de la imagen, no en el canvas
        int pCx = (posXCenter);
        int pCy = (posYCenter);
        //posición del ultimo pixel o indice mayor de la imagen
        float valMAx = (img.width-1)+(img.height-1)*img.width;
        //colores random no muy lejanos al central
        for (int i = 0; i < numColors; i++) {
          valX = (int)Functions.constrain2(random(pCx-(tamBrush/2), pCx+(tamBrush/2)), 0, img.width-1);
          valY = (int)Functions.constrain2(random(pCy-(tamBrush/2), pCy+(tamBrush/2)), 0, img.height-1);
          //indice de la imagen
          int index = valX + valY*img.width;

          //Posicion invalida
          if (valX < 0 && valY < 0 && index <= valMAx) {
            //Se busca una posición valida
            while (true) {
              valX = int(random(pCx-(tamBrush/2), pCx+(tamBrush/2)));
              valY = int(random(pCy-(tamBrush/2), pCy+(tamBrush/2)));
              if (valX >= 0 && valY >= 0 && index <= valMAx) break;
            }
          }

          r = red(img.pixels[index]);
          g = green(img.pixels[index]);
          b = blue(img.pixels[index]);

          if (r+g+b != 0) {
            float dem = r+g+b;
            //Se convierte a color cromatico
            float r2 = map(r/dem, 0, 1, 0, 255);
            float g2 = map(g/dem, 0, 1, 0, 255);
            float b2 = map(b/dem, 0, 1, 0, 255); 
            //se alcena el color seleccionado
            selectedColors[i] = color(r2, g2, b2);
            //se posiciona el descriptor en el espacio de trabajo
            descriptores[i].posX = r2;
            descriptores[i].posY = g2;
            descriptores[i].posZ = b2;
            //Se actualiza el descriptor con la nueva posición
            descriptores[i].model();
          }
        }
        //Se crea la imagen del rectángulo de búsqueda
        imgTracking = createImage((int)(2*tamArista), (int)(2*tamArista), RGB);
        //Donde s almacenan la informacion de los colores cromaticos
        int tam = 4*tamArista*tamArista;
        posColorCromaR = new float[tam];
        posColorCromaG = new float[tam];
        posColorCromaB = new float[tam];
        isSelected = new float[tam];
      } else {
        validSizeRectangle = false;
      }
    }
    drag = false;
  }

  /*
  DESCRIPCIÓN: Función ejecutada cada vez que se preciona un botón del mouse. La función debe ser mandada a llamar dentro de la función mousePressed() del 
   pde principal (pdf donde va la función setup() y draw())
   
   PARAMS: void
   */
  @Override
    public void mousePressed() {
    //loop();
    if (posXImgKinect < mouseX && mouseX < posXImgKinect+img.width && posYImgKinect < mouseY && mouseY < posYImgKinect+img.height ) {
      drag = true;
      c1.x = int(mouseX);
      c1.y = int(mouseY);

      c2.x = int(mouseX);
      c2.y = int(mouseY);

      c3.x = int(mouseX);
      c3.y = int(mouseY);

      c4.x = int(mouseX);
      c4.y = int(mouseY);

      posXCenter = int(mouseX)-posXImgKinect; 
      posYCenter = int(mouseY)-posYImgKinect;
    }
  }

  /*
  DESCRIPCIÓN: Función ejecutada cada vez que se mantiene precionado un botón del mouse. La función debe ser mandada a llamar dentro de la función mouseDragged() del 
   pde principal (pdf donde va la función setup() y draw())
   
   PARAMS: void
   */
  @Override
    public void mouseDragged() {
    if (drag) {
      drag = true;
      tamArista = int(dist(posXCenter, posYCenter, mouseX-posXImgKinect, mouseY-posYImgKinect));

      //se determina la posición del rectangulo de seguimiento
      makeTrackingRectangle();
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
 Clase que se encarga de realizar el labeling a una imagen
 */

class Labeling {

  //Almacena las equivalencias entre los pixeles
  private HashMap<Integer, Integer> equivalencia;
  //Almacena la información de cada área encontrado
  private HashMap<Integer, DataEquival> data;
  //Almacena los posibles candidatos (Candidto=Area que cumpla ciertas condiciones)
  private ArrayList<DataEquival> candidates;
  //Se usa para correlacionar las etiquetas y formas equivalencias (valor de la quivalencia)
  private int posEquival;
  //Posición de los pixeles vecinos de un pixel (pixel actual)
  private int[] neighbor;
  //Color de los pixeles que forman áreas ( pixeles usados para realizarles el labeling)
  private color colorObject;

  //umbral de selección de áreas. Se su para saber si un área es válida (que supere cierta cantidad de pixeles).
  public int thresHoldDensity;
  //Indica la distancia entre blobs para que sean fucionados (ver función solveEquivalencia())
  public float distBlob;
  //Imagen donde se muestra el resultado del labeling. La imagen pasada en labelingImage() guarda las areas con su valor de equivalencia y como son valores enteros
  //mayores a cero entonces las areas quedan coloreadas sin un color distintivo entre una y otra.
  public PImage imgColor;

  /*
  DESCRIPTOR. 
   PARAMS: 
   object: El color que deben tener los pixeles que formarán las áreas.
   */
  Labeling(color object) {
    equivalencia = new HashMap<Integer, Integer>();
    data = new HashMap<Integer, DataEquival>();
    candidates = new ArrayList<DataEquival>();
    posEquival = 0;
    neighbor = new int[4];
    colorObject = object;

    //umbral de densidad
    thresHoldDensity = 90;
    //Umbral de distancia entre blobs
    distBlob = 80;
    imgColor = createImage(10, 10, RGB);
  }

  /*
  DESCRIPCIÓN: Le realiza el labeing a una imágen RGB. El labeling consiste en determinar las áreas que hay en una imágen. Un área es un conjunto 
   de pixeles que son adyacentes entre sí y se puede llegar de un pixel a otro sin tener que pasar por un pixel que no sea del color "colorObject".
   PARAMS: 
   imgLabeling: Imagen a la cual se le hará el labeling.
   */
  public void labelingImage(PImage imgLabeling) {
    labeling(imgLabeling);
    solveEquivalencia(imgLabeling);
  }

  /*
  DESCRIPCIÓN: Le realiza el labeing a una imágen RGB-D. El labeling consiste en determinar las áreas que hay en una imágen. Un área es un conjunto 
   de pixeles que son adyacentes entre sí y se puede llegar de un pixel a otro sin tener que pasar por un pixel que no sea del color "colorObject".
   PARAMS: 
   
   imgLabeling: Imagen a la cual se le hará el labeling.
   
   imgDepth: La imagen que tiene los valores de profundidad. 
   */
  public void labelingImage(PImage imgLabeling, PImage imgDepth) {
    labeling(imgLabeling);
    solveEquivalencia(imgLabeling, imgDepth);
  }

  /*
  DESCRIPCION: Realiza el etiquetado de una imagen. Consiste en etiquetar áreas de pixeles. El labeling se hace sobre imagenes binarias 
   donde "colorObject" son los pixeles a etiquetar
   PARAMS:
   imgLabeling: Imagen a realizar el labeling
   */
  private void labeling(PImage imgLabeling) {

    if (imgLabeling != null) {
      //Se reinician las equivalencias
      equivalencia.clear();
      data.clear();
      candidates.clear();
      //
      posEquival = 0;

      /*Etiqueta para los pixeles. Los colores tienen un valor menor que cero, "label" debe empezar con un numero mayor a 0
       para que no haya confución con un color y sea una etiqueta distintiva.
       */
      int label = 4;
      //indica si el pixel actual tiene ameno sun vecino con etiqueta
      boolean existVecino  = false;

      imgLabeling.loadPixels();
      for (int y = 1; y < imgLabeling.height; y++) {
        for (int x = 1; x < imgLabeling.width-1; x++ ) {

          int index = x + y * imgLabeling.width;
          neighbor[3] = (x+1)+(y-1)*imgLabeling.width;
          neighbor[2] = x+(y-1)*imgLabeling.width;
          neighbor[1] = (x-1)+(y-1)*imgLabeling.width;
          neighbor[0] = (x-1)+y*imgLabeling.width;

          existVecino = false;
          //pixel con color a realizar el labeling
          if (imgLabeling.pixels[index] == colorObject) {

            //se verifican las etiquetas de los vecinos
            for (int i = 0; i < 4; i++) {
              //vecino con etiqueta
              if (imgLabeling.pixels[neighbor[i]] > 0) {
                //pixel actual sin etiqueta pero con vecino etiquetado
                if (imgLabeling.pixels[index] < 0) {
                  //el pixel toma el valor de su primer vecino de izq-der etiquetado
                  imgLabeling.pixels[index] =  imgLabeling.pixels[neighbor[i]];
                }
                addEquivalencia(imgLabeling.pixels[index], imgLabeling.pixels[neighbor[i]]);
                existVecino = true;
              }
            }

            //pixel sin vecinos con etiqueta
            if (!existVecino) {
              label++;//nueva etiqueta
              imgLabeling.pixels[index] = label; //se le asigna etiqueta al pixel actual
              addEquivalencia(label, label);
            }
          }
        }
      }// fin del recorrido sobe la imagen
      imgLabeling.updatePixels();
    }
  }

  /*
  DESCRIPCION: Agrega un equivalencia entre dos números.
   PARAMS: 
   val1: valor 1 de la aquivalencia
   val2: valor 2 de la equivalencia
   */
  private void addEquivalencia(int val1, int val2) {
    Integer posVal1, posVal2;
    boolean existVal1 = false, existVal2 = false;

    existVal1 = equivalencia.containsKey(val1);
    existVal2 = equivalencia.containsKey(val2);

    //ningun valor se encuetra dentro de una equivalencia
    if (!existVal1 && !existVal2) {
      posEquival++;//nueva etiqueta de equivalencia
      equivalencia.put(val1, posEquival);
      equivalencia.put(val2, posEquival);
      return;
    }

    int valSearch, valChange;
    //ambos valores se encuentran en la misma equivalencia
    if (existVal1 && existVal2) {
      posVal1 = equivalencia.get(val1);
      posVal2 = equivalencia.get(val2);

      //ambas equivalencias deben tener diferente valor
      if (posVal1 != posVal2) {
        /*Si se conociera el numero de elementos de ambas equivalenvias, se cambia el valor de las mas pequeñas
         pero como no se conocen se eligen de manera aleatoria
         */
        if (random(-1, 1) >= 0) {
          valSearch = posVal1;
          valChange = posVal2;
        } else {
          valSearch = posVal2;
          valChange = posVal1;
        }
        //se cambia el valor de las equivalencias
        for (int keyVal : equivalencia.keySet()) {
          if (equivalencia.get(keyVal) == valSearch) {
            equivalencia.put(keyVal, valChange);
          }
        }
      }
      return;
    }

    //un valor se encuentra en una equivalencia y el otro no
    //se agrega el valor faltante
    if (existVal1) {
      posVal1 = equivalencia.get(val1);
      equivalencia.put(val2, posVal1);
    } else {
      posVal2 = equivalencia.get(val2);
      equivalencia.put(val1, posVal2);
    }
  }

  /*
  DESCRIPCION: Calcula las dimenciones de las áreas encontradas y  cuantos pixeles la conforman. Las imágenes "imgLabeling" "imgDepth" deben tener las
   mismas dimenciones.
   
   PARAMS:
   imgLabeling: Imagen en la cual se resolverán las equivalencias.
   imgDepth: imagen que contiene los valores de profundidad de cada pixel.
   */
  private void solveEquivalencia(PImage imgLabeling, PImage imgDepth) {
    int valEquivalencia;
    //Imagen a color
    if (imgColor.width != imgLabeling.width && imgColor.height != imgLabeling.height) {
      imgColor = createImage(imgLabeling.width, imgLabeling.height, RGB);
    }

    imgColor.loadPixels();
    for (int x = 0; x < imgLabeling.width; x++) {
      for (int y = 0; y < imgLabeling.height; y++) {
        int index = x+y*imgLabeling.width;
        valEquivalencia = imgLabeling.pixels[index];

        //El valor del pixel se encuentra en una equivalencias
        if (equivalencia.containsKey(valEquivalencia)) {
          //valor de la equivalencia a la que pertenece
          int val = equivalencia.get(valEquivalencia);
          //se comprueba si el valor de la equivalencia ya tiene atributos
          DataEquival aux;
          if (data.containsKey(val)) {
            //se obtiene el objeto que guarda los atributos del valor de la equivalencia
            aux = data.get(val);
            //aumentamos la densidad
            aux.density++;
          } else {
            //se crean los atributos para la equvalencia, con un color random
            aux = new DataEquival(color(random(0, 256), random(0, 256), random(0, 256)));
            //numero de equivalencia a la que pertenece
            aux.numEquival = val;
            //aumentamos densidad
            aux.density++;
            //se asignan los atributos a la tabla de atributos de equivalencias
            data.put(val, aux);
          }
          //se le asigna su color y valor de equivalencia
          imgColor.pixels[index] = aux.colorEquival;
          imgLabeling.pixels[index] = aux.numEquival;

          //se checan los limites del area de equivalencia
          if (x < aux.blob.minx) aux.blob.minx = x;
          if (x > aux.blob.maxx) aux.blob.maxx = x;

          if (y < aux.blob.miny) aux.blob.miny = y;
          if (y > aux.blob.maxy) aux.blob.maxy = y;

          int depth = imgDepth.pixels[index];
          aux.addValToAverage(depth);
          aux.addMaxDepth(depth);
          aux.addMinDepth(depth);

          //se determina si el valor de equivalencia tiene la densidad necesaria para ser un área válida
          if (aux.density > thresHoldDensity ) {
            //Si el blob no existe se agrega al candidato seleccionado
            if (!candidates.contains(aux)) candidates.add(aux);
            aux.blob.model();
          }
        } else {
          imgColor.pixels[index] = color(100);
        }
      }
    }
    imgColor.updatePixels();
  }

  /*
  DESCRIPCION: Calcula las dimenciones de las áreas, el número de pixeles que la conforman. Las áreas que superen el umbral son seleccionadas
   como posibles áreas candidato.
   
   PARAMS:
   imgLabeling: Imagen en la cual se resolveran las equivalencias.
   */
  private void solveEquivalencia(PImage imgLabeling) {
    int valEquivalencia;
    //Imagen a color
    if (imgColor.width != imgLabeling.width && imgColor.height != imgLabeling.height) {
      imgColor = createImage(imgLabeling.width, imgLabeling.height, RGB);
    }

    imgColor.loadPixels();
    for (int x = 0; x < imgLabeling.width; x++) {
      for (int y = 0; y < imgLabeling.height; y++) {
        int index = x+y*imgLabeling.width;
        valEquivalencia = imgLabeling.pixels[index];

        //El valor del pixel se encuentra en una equivalencias
        if (equivalencia.containsKey(valEquivalencia)) {
          //valor de la equivalencia a la que pertenece
          int val = equivalencia.get(valEquivalencia);
          //se comprueba si el valor de la equivalencia ya tiene atributos
          DataEquival aux;
          if (data.containsKey(val)) {
            //se obtiene el objeto que guarda los atributos del valor de la equivalencia
            aux = data.get(val);
            //aumentamos la densidad
            aux.density++;
          } else {
            //se crean los atributos para la equvalencia, con un color random
            aux = new DataEquival(color(random(0, 256), random(0, 256), random(0, 256)));
            //numero de equivalencia a la que pertenece
            aux.numEquival = (val);
            //aumentamos densidad
            aux.density++;
            //se asignan los atributos a la tabla de atributos de equivalencias
            data.put(val, aux);
          }

          //se le asigna su color y valor de equivalencia
          imgColor.pixels[index] = aux.colorEquival;
          imgLabeling.pixels[index] = aux.numEquival;

          //se checan los limites del area de equivalencia
          if (x < aux.blob.minx) aux.blob.minx = x;
          if (x > aux.blob.maxx) aux.blob.maxx = x;

          if (y < aux.blob.miny) aux.blob.miny = y;
          if (y > aux.blob.maxy) aux.blob.maxy = y;

          //se determina si el valor de equivalencia tiene la densidad necesaria para ser un área válida
          if (aux.density > thresHoldDensity ) {
            //Si el blob no existe se agrega al candidato seleccionado
            if (!candidates.contains(aux)) candidates.add(aux);
            aux.blob.model();
          }
        } else {
          imgColor.pixels[index] = color(100);
        }
      }
    }

    //Numero de candidatos encontrados
    if (candidates.size() > 1) {
      //Se fusionan los blobs. Si un blob esta a una distancia menor que "distBlob" respecto a otro, ya sea en el eje x o y, se fucionan.
      for (int i = 0; i < candidates.size(); i++) {
        for (int j = 0; j < candidates.size(); j++) {

          DataEquival area1 = candidates.get(i);
          DataEquival area2 = candidates.get(j);
          if (area1 != area2 && area1 != null && area2 != null) {
            int r = isFusion(area1, area2, imgLabeling);
            if ( r == 1) candidates.set(j, null);
            if ( r == 2) candidates.set(i, null);
          }
        }
      }
    }
    imgColor.updatePixels();

    //Se eliminan los blobs fusionados y se corrigen el valor de equivalencia de los pixeles de cada area
    for (int i = 0; i < candidates.size(); i++) {
      DataEquival area1 = candidates.get(i);
      if (area1 == null) {
        candidates.remove(i);
        i--;
      }
    }
  }

  /*
  DESCRIPCIÓN: Determina si dos áreas se fusionan o no. La fusión depende si se traslapa el área de fusión de ambas áreas. La distancia de fusión es controlada 
   por la variable "distBlob". La función retorna 1 cuando el área1 abserbe al área 2, caso análogo cuando retorna 2 y cero cuando no se fusionan.  
   
   PARAMS:  
   area1, area2: áreas que posiblemente se fusionen.
   imgLabeling: Imagen donde se almacenan las áreas.
   */
  private int isFusion(DataEquival area1, DataEquival area2, PImage imgLabeling) {
    DataEquival firts, second;
    int pos = 0;
    if (area1 != area2) {
      //Se checan las distancias entre blobs a lo largo del eje X
      if (area1.blob.minx < area2.blob.minx) {
        firts = area1;
        second = area2;
        pos = 2;
      } else {
        firts = area2;
        second = area1;
        pos = 1;
      }

      if (firts.blob.maxx+distBlob >= second.blob.minx-distBlob && second.blob.miny-distBlob <= firts.blob.maxy+distBlob && second.blob.maxy+distBlob >= firts.blob.miny-distBlob ) {
        fusionDataEquival(second, firts, imgLabeling, 1);
        return pos;
      }
    }
    return 0;
  }

  /*
  DESCRIPCIÓN: Fusiona dos áreas en una sola. 
   PARAMS: 
   a,b: Áreas que se van a fusionar
   imgLabeling: Imágen donde se almacenan las áreas. 
   type: se pasa 2 cuando se está tratando con la profundidad.
   */
  private void fusionDataEquival(DataEquival a, DataEquival b, PImage imgLabeling, int type) {
    a.density += b.density;
    a.blob.addBlob(b.blob);
    if (type == 2) {
      a.depthSum += b.depthSum;
      for (int i = 0; i < b.numValues; i++) {
        a.addMaxDepth(b.maxDepth[i]);
        a.addMinDepth(b.minDepth[i]);
      }
    }
    //Se cambia el valor de la equivalencia de los pixeles
    for (int x = int(a.blob.minx); x < a.blob.maxx; x++) {
      for (int y = int(a.blob.miny); y < a.blob.maxy; y++) {
        int index = x+y*imgLabeling.width;
        if (index >= 0 || index < imgLabeling.width*imgLabeling.height) {
          int  valor = imgLabeling.pixels[index];
          if (valor == b.numEquival) {
            imgLabeling.pixels[index] = a.numEquival;
            imgColor.pixels[index] = a.colorEquival;
          }
        }
      }
    }
  }

  /*
  DESCRIPCIÓN: Se copia una region de la imagen "a" en la imagen "b", dentro de la posición (x1,y1)
   Las dimenciones de la sección a copiar vienen determinadas por las dimenciones de la imagen b.
   Se extrae la imagen en la posición (x1,y1) que es la posición superior izquierda de la imagen b
   PARAMS:
   a: Imagen origen.
   b: Imagen donde se extrae un área de "a" 
   x1: posicion en el eje X de b
   y1: posición en el eje Y de b
   */
  public void extractImage(PImage a, PImage b, int x1, int y1) {
    color black = color(0);
    b.loadPixels();
    for (int x = 0; x < b.width; x++) {
      for (int y = 0; y < b.height; y++) {
        int posX = x+x1;
        int posY = y+y1;
        int indexB = x + y * b.width;
        if (posX < 0 || posY < 0) {
          b.pixels[indexB] = black;
        }
        if (posX > a.width || posY > a.height) {
          b.pixels[indexB] = black;
        }
        if (posX >= 0 && posX < a.width && posY >= 0 && posY < a.height) {
          b.pixels[indexB] = a.pixels[posX + posY * a.width];
        }
      }
    }
    b.updatePixels();
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

class ColorDescriptor {
  /*
 DESCRIPCION: Clase que representa los descriptores de color. Un descriptor de color es un paralelepipedo que se mueve dentro del espacio de color
   cromático. Si un color cae dentro del descriptor de color entonces es seleccionado.
   
   A continuacion se muestra como se construye el descriptor de color en sus ejes RGB correspondientes: 
   Largo: eje Green
   Ancho: eje Red
   Alto: eje Blue
   
   cara de abajo del descriptor (alto menor)
   G
   |  p5--p7
   |  |   |
   |  p1--p3
   o-------R
   
   cara de arriba del descriptor (alto mayor)
   G
   |  p6--p8
   |  |   |
   |  p2--p4
   o-------R
   
   cara lateral del descriptor (ancho menor)
   B
   |  p2--p6
   |  |   |
   |  p1--p5
   o-------G
   
   cara lateral del descriptor (ancho mayor)
   B
   |  p4--p8
   |  |   |
   |  p3--p7
   o-------G
   
   NOTAS:
   
   1. También ésta clase es usada como un blob pero en 3D. Como el blob 3D tiene un punto de enfoque (posición donde debe ir el endEfector del brazo
   robótico) el blob 3D también. El punto de enfoque 3D se calcula en base al punto de enfoque 2D. 
   */

  //Esquinas del descriptor de color.
  private PVector p1, p2, p3, p4, p5, p6, p7, p8;


  //tamañio del descriptor de color en cada uno de sus ejes
  public float sizeR;
  public float sizeG;
  public float sizeB;
  //Posición del descriptor de color
  public float posX, posY, posZ;
  //Indica donde empieza y donde termina el descriptor de color.
  public float[] limitR;
  public float[] limitG;
  public float[] limitB;
  //Posición de enfoque de agarre en 3D (véase posEnfoqueX, posEnfoqueY del Blob) 
  public PVector posEnfoque;

  /*
  CONSTRUCTOR.
   PARAMS: void
   */
  ColorDescriptor() {
    p1 = new PVector(0, 0, 0); 
    p2 = new PVector(0, 0, 0);
    p3 = new PVector(0, 0, 0);
    p4 = new PVector(0, 0, 0);
    p5 = new PVector(0, 0, 0);
    p6 = new PVector(0, 0, 0);
    p7 = new PVector(0, 0, 0);
    p8 = new PVector(0, 0, 0);

    limitR = new float[2];
    limitG = new float[2];
    limitB = new float[2];
    
    posEnfoque = new PVector();

    sizeR = 19.125;
    sizeG = 12.75;
    sizeB = 12.75;
  }

  /*
  DESCRIPCIÓN: Muestra el descriptor de color dentro del Canvas.
   PARAMS: void
   */
  void view() {
    //se muestra el cubo  
    stroke(#83547B);
    line(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
    line(p3.x, p3.y, p3.z, p4.x, p4.y, p4.z);
    line(p5.x, p5.y, p5.z, p6.x, p6.y, p6.z);
    line(p7.x, p7.y, p7.z, p8.x, p8.y, p8.z);

    line(p1.x, p1.y, p1.z, p3.x, p3.y, p3.z);
    line(p1.x, p1.y, p1.z, p5.x, p5.y, p5.z);
    line(p5.x, p5.y, p5.z, p7.x, p7.y, p7.z);
    line(p7.x, p7.y, p7.z, p3.x, p3.y, p3.z);

    line(p2.x, p2.y, p2.z, p4.x, p4.y, p4.z);
    line(p2.x, p2.y, p2.z, p6.x, p6.y, p6.z);
    line(p6.x, p6.y, p6.z, p8.x, p8.y, p8.z);
    line(p8.x, p8.y, p8.z, p4.x, p4.y, p4.z);
  }

  /*
  DESCRIPCIÓN: Calcula las esquinas de descriptor de color dada sus dimenciones.
   PARAMS: void
   */
  public void model() {
    p1.x = posX-sizeR/2;
    p1.y = posY-sizeG/2;
    p1.z = posZ-sizeB/2;

    p2.x = posX-sizeR/2;
    p2.y = posY-sizeG/2;
    p2.z = posZ+sizeB-sizeB/2;

    p3.x = posX+sizeR-sizeR/2;
    p3.y = posY-sizeG/2;
    p3.z = posZ-sizeB/2;

    p4.x = posX+sizeR-sizeR/2;
    p4.y = posY-sizeG/2;
    p4.z = posZ+sizeB-sizeB/2;

    p5.x = posX-sizeR/2;
    p5.y = posY+sizeG-sizeG/2;
    p5.z = posZ-sizeB/2;

    p6.x = posX-sizeR/2;
    p6.y = posY+sizeG-sizeG/2;
    p6.z = posZ+sizeB-sizeB/2;

    p7.x = posX+sizeR-sizeR/2;
    p7.y = posY+sizeG-sizeG/2;
    p7.z = posZ-sizeB/2;

    p8.x = posX+sizeR-sizeR/2;
    p8.y = posY+sizeG-sizeG/2;
    p8.z = posZ+sizeB-sizeB/2;

    //limites del descriptor en cada eje
    limitR[0] = p1.x;
    limitR[1] = p3.x;

    limitG[0] = p1.y;
    limitG[1] = p5.y;

    limitB[0] = p1.z;
    limitB[1] = p2.z;
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

class Blob {
  /*
  DESCRIPTOR: Clase usada para crear Blobs. Un blob es un rectánguo que encierra un área de la imágen. La clase es usada para encerrar las áreas 
   encontradas por el Labeling.
   
   NOTAS.
   1. Un punto importante a tomar en cuenta es el sistea de coordenadas sobre el cual se ésta trabajando. Los blobs trabajan sobre el sistema de coordenadas
   de la imagen. Si la imagen se mueve del punto (0,0) dentro del canvas, entonces los blobs deben de cambiar de sistema de coordenadas por eso 
   dentro de las funciones showBlob() se deben pasar la posición de la imagen dentro del canvas.
   
   2. Las variables "posEnfoqueX" "posEnfoqueY" alamcenan la posición de enfoque. La posición de enfoque es el punto donde debe ir el endEfector del brazo
   robótico.
   */

  //Inicio del blob en el eje X 
  private float minx;
  //Inicio del blob en el eje Y
  private float miny;
  //Fin del blob en el eje X
  private float maxx;
  //Fin del blob en el eje Y
  private float maxy;

  //Posición central del blob
  public float centerX;
  public float centerY;
  //Posición del blob de la esquina superior izquierda
  public float posXBlob; 
  public float posYBlob;
  //Posición de enfoque de agarre del blob
  public float radio;
  public float posEnfoqueX;
  public float posEnfoqueY;

  /*
  CONSTRUCTOR.
   PARAMS: void
   */
  Blob() {
    minx = 10000000;
    miny = 10000000;
    maxx = -10000000;
    maxy = -10000000;
    radio = 0;
    posEnfoqueX = 0;
    posEnfoqueY = 0;
  }

  /*
  DESCRIPCIÓN: Muestra el blob dentro de la imagen que se muestra dentro del canvas.
   PARAMS: 
   posX, posY : Posición de la imagenn dentro del canvas.
   */
  public void showBlob(int posX, int posY) {
    stroke(#F26E77);
    noFill();
    strokeWeight(2);
    //Blob
    rect(posXBlob+posX, posYBlob+posY, maxx-minx, maxy-miny);
    //Punto de enfoque
    line(centerX+posX, centerY+posY, posEnfoqueX+posX, posEnfoqueY+posY);
    strokeWeight(.7);
  }

  /*
  DESCRIPCIÓN: Muestra el blob dentro de la imagen que se muestra dentro del canvas.
   PARAMS: 
   posX, posY : Posición de la imagenn dentro del canvas.
   c: Color deseado para el blob
   */
  public void showBlob(int posX, int posY, color c) {
    stroke(c);
    noFill();
    strokeWeight(2);
    //Blob
    rect(posXBlob+posX, posYBlob+posY, maxx-minx, maxy-miny);
    //Punto de enfoque
    line(centerX+posX, centerY+posY, posEnfoqueX+posX, posEnfoqueY+posY);
    strokeWeight(.7);
  }

  /*
  DESCRIPCIÓN: El blob obtiene las dimenciones de si mismo combinado con otro
   PARAMS: 
   b: Blob con el cual se combinar sus dimenciones
   */
  public void addBlob(Blob b) {
    if (minx > b.minx) minx = b.minx;
    if (maxx < b.maxx) maxx = b.maxx;
    if (miny > b.miny) miny = b.miny;
    if (maxy < b.maxy) maxy = b.maxy;
    //Se actualiza el blob
    model();
  }

  /*DESCRIPCION: Actualiza el blob. Cuando un blob sufre algún cambio ésta función calcula las nuevas dimenciones del blob junto con sus partes.
   PARAMS: void
   */
  public void model() {
    //Centro del blob
    centerX = ((maxx-minx)/2 + minx);
    centerY = ((maxy-miny)/2 + miny);

    //Enfoque de agarre
    posXBlob = centerX-((maxx-minx)/2); 
    posYBlob = centerY-((maxy-miny)/2);
    radio = dist(centerX, centerY, posXBlob, posYBlob) +12;
    posEnfoqueX = radio*sin(radians(80))+centerX;
    posEnfoqueY = radio*cos(radians(80))+centerY;
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



class DataEquival {
  /*
  DESCRIPCION: Clase usada para almacenar la información sobre las áreas encontradas durante el Labeling.  
   */

  //Valor de la equivalencia a la que pertenece
  public int numEquival;
  //Color de la equivalencia
  public color colorEquival;
  //Indica cuantos pixeles tienen como valor de la equivalencia igual a numEquival
  public int density;
  //Ayuda a encontrar la posición de los pixeles con valor de la equivalencia igual a numEquival
  public Blob blob;

  //VARIABLES USADAS PARA LA IMAGEN DE PROFUNDIDAD

  //Almacena las profundidades minimas y maximas
  private int[] minDepth, maxDepth;
  //indica si existen lugares disponibles
  private int minL, maxL;
  //Indica cuantos valores minimos y maximos deben ser capturados para calcula el promedio minimo y maximo
  private int numValues;

  //Profundidad promedio
  public float depthAverage;
  //Profundidad promedio minima y maxima
  public float depthMin, depthMax;
  //almacena la sumatoria de la profundidad
  public int depthSum;
  //Blob 3D
  public ColorDescriptor blob3D;

  DataEquival(color c) {
    colorEquival = c;
    density = 0;
    blob = new Blob();
    depthAverage = 0;
    blob3D = new ColorDescriptor();
    numValues = 10;//cantidad de profunidades minimas y maximas a almacenar
    minL = c;
    maxL = numValues;
    minDepth = new int[numValues];
    maxDepth = new int[numValues];

    //Se inicializa
    for (int i = 0; i < minDepth.length; i++) {
      maxDepth[i] = 100000;
      minDepth[i] = 100000;
    }
  }

  /*
  DESCRIPCIÓN: Retorna la profundidad promedio según los valores agragados con la funcion addValToAverage(). Los valores pasados a dicha función deben 
   ser los valores de una misma área.
   PARAMS: 
   */
  public float getAverageDepth() {
    depthAverage = depthSum/density;
    return depthAverage;
  }

  /*
  DESCRIPCIÓN: Retorna la profundidad promedio con valores mínimos agregados y calculados con la función addMinDepth(int). Con la variable "numValues" 
   se determina cuantos valores minimos se desean usar. Cuando se agregan los valores se usa un arreglo de tamaño "numValues" donde se almacenan los valores
   minimos pasados a través de la función addMinDepth(int)
   
   PARAMS: void
   */
  public float getAverageMinDepth() {
    float a=0;
    for (int i = 0; i < numValues; i++) {
      a+=minDepth[i];
    }
    depthMin = a/numValues;
    return depthMin;
  }

  /*
  DESCRIPCIÓN: Retorna la profundidad promedio según los minimos valores agregados con la función addMinDepth(). Con la variable "numValues" 
   se determina cuantos valores minimos se desean usar. Cuando se agregan los valores se usa un arreglo de tamaño "numValues" donde se almacenan los valores
   máximos pasados a través de la función addMaxDepth(int).
   PARAMS: void
   */
  public float getAverageMaxDepth() {
    float b=0;
    for (int i = 0; i < numValues; i++) {
      b+=maxDepth[i];
    }
    depthMax = b/numValues;
    return depthMax;
  }

  /*
  DESCRIPCIÓN: Agrega un valor profundidad para calcular la profundidad promedio de un área. Los valores pasados deben pertenecer a los pixeles de una misma
   área.
   
   PARAMS:
   val: Valor de profundidad
   */
  public void addValToAverage(int val) {
    depthSum+= val;
  }

  /*
  DESCRIPCIÓN: Dado un conjunto de valores que son pasados de uno por uno a la función, determina los valores máximos. EL numero de valores máimos a obtener
   viene dado por la variable "numVaules".
   PARAMS: 
   d: Valor de profunidad
   */
  public void addMaxDepth(int d) {
    if (d < 30) return;
    //Se ordena de menor a mayor
    if (maxL > 0) {
      int index=-1; 
      for (int i =  maxDepth.length-1; i >= 0; i--) {
        if (maxDepth[i] > d) {
          index=i; 
          break;
        }
        if (maxDepth[i] == d)return;
      }

      for (int i =  0; i < index; i++) {
        maxDepth[i] = maxDepth[i+1];
      }
      if (index != -1) {
        maxL--; 
        maxDepth[index] = d;
      }
      return;
    }

    //Se almacenan los valores
    int index = 0; 
    boolean search = false; 
    //Se busca la posición del nuevo valor
    for (int i = 0; i < maxDepth.length; i++) {
      if (maxDepth[i] < d) {
        index = i; 
        search = true; 
        break;
      }
      if (maxDepth[i] == d)return;
    }
    if (search) {
      //Se recorren los valores
      for (int i = maxDepth.length-1; i > index; i--) {
        maxDepth[i] = maxDepth[i-1];
      }
      //se inserta el valor
      maxDepth[index] = d;
    }
  }

  /*
  DESCRIPCIÓN: Dado un conjunto de valores que son pasados de uno por uno a la función, determina los valores mínimos. EL número de valores mínimos a obtener
   viene dado por la variable "numVaules".
   
   PARAMS: 
   d: Valor de profundidad.
   */
  public void addMinDepth(int d) {
    if (d < 30) return;
    //Se ordena de mayor a menor
    if (minL > 0) {
      int index=-1; 
      for (int i =  minDepth.length-1; i >= 0; i--) {
        if (minDepth[i] > d) {
          index=i; 
          break;
        }
        if (minDepth[i] == d)return;
      }

      for (int i =  0; i < index; i++) {
        minDepth[i] = minDepth[i+1];
      }
      if (index != -1) {
        minL--; 
        minDepth[index] = d;
      }
      return;
    }

    //Se almacenan los valores
    int index = 0; 
    boolean search = false; 
    //Se busca la posición del nuevo valor
    for (int i = 0; i < minDepth.length; i++) {
      if (minDepth[i] > d) {
        index = i; 
        search = true; 
        break;
      }
      if (minDepth[i] == d)return;
    }
    if (search) {
      //Se recorren los valores
      for (int i = minDepth.length-1; i > index; i--) {
        minDepth[i] = minDepth[i-1];
      }
      //se inserta el valor
      minDepth[index] = d;
    }
  }
}
