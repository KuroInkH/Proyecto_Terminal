class RoboticVision extends Robot {

  //Almacena los rectangulos de seguimiento
  private TrackingRectangle[] trackRect;
  //Ayuda a extraer imagenes y realizar el labeling
  private Labeling labelingH, labelingO;
  
  //indica si se muestra la imagen de profundidad
  public boolean showImgDepth;
  //Imagenes del objeto
  private PImage imgDepthSegO;//Imagen de profundidad segmentada
  private PImage imgDepthValO;//Imagen de profundidad con valores crudos de profunidad
  //Imagenes de la mano
  private PImage imgDepthSegH;//Imagen de profundidad segmentada
  private PImage imgDepthValH;//Imagen de profundidad con valores crudos de profunidad
  //candidato seleccionado por medio de la profundidad
  private DataEquival targetH, targetO;
  //variables auxiliares
  float[][] w, w2;
  int[] neighbor;
  HashMap<Integer, Integer>values;

  RoboticVision(PApplet canvas) {
    super(canvas);

    trackRect = new TrackingRectangle[2];

    showImgDepth = false;
    imgDepthSegO = createImage(10, 10, RGB);
    imgDepthValO = createImage(10, 10, RGB);
    imgDepthSegH = createImage(10, 10, RGB);
    imgDepthValH = createImage(10, 10, RGB);

    labelingH = new Labeling(color(255));
    labelingO = new Labeling(color(255));
    labelingH.distBlob = 0;
    labelingO.distBlob = 0;

    w = new float[4][1];
    w[3][0] = 1;
    w2 = new float[4][1];
    w2[3][0] = 1;
    neighbor = new int[8];
    values = new HashMap<Integer, Integer>();
  }

  /*
  DESCRIPCION: Setter del rectangulo de seguimiento.
   PARAMS: 
   t: Nuevo(s) rectangulo(s) de seguimiento a ser usado(s) para obtener la posición de un objeto dentro de la imagen RGB.
   */
  public void setTrackingRect(TrackingRectangle[] t) {
    trackRect[0] = t[0];
    trackRect[1] = t[1];
  }

  /*
  DESCRIPCION: Retorna si se entabló conexión con la targeta CM700
   PARAMS: void
   */
  public boolean isConnectCM700() {
    return super.robotArm.isConnectCM700;
  }

  /*
  DESCRIPCIÓN: Realiza los calculos para que se mueva el robot.
   PARAMS: 
   */
  public void model() {
    motionPlanning();
  }

  /*
  DESCRIPCIÓN: Realiza la planeación de rutas.
   PARAMS: void
   */
  private void motionPlanning() {
    if (trackRect[0] != null && !trackRect[0].drag) {
      //Se cierra el control por medio de los ScaleBox
      super.inputFromScaleBox = false;
      //Se extraen las imagenes de profundidad
      extractImgDepth(trackRect[0], 0);
      //Se calcula el objeto a seguir
      calculateTarget(trackRect[0], 0, imgDepthSegO);
      //Se calcula la posición del rectangulo de seguimiento en la nube de puntos
      calculatePosIn3D(trackRect[0], targetO);

      if (targetO != null) {
        //Posición angular del reactangulo de seguimiento del objeto respecto al hombro del robot
        float angleObject = atan2(targetO.blob3D.posEnfoque.y - super.csTriangle.origen[1][0], targetO.blob3D.posEnfoque.x - super.csTriangle.origen[0][0]);
        //float distObject = dist(super.csTriangle.origen[0][0], super.csTriangle.origen[1][0], super.csTriangle.origen[2][0], targetO.blob3D.posEnfoque.x, targetO.blob3D.posEnfoque.y, targetO.blob3D.posEnfoque.z );
        float distObject = dist(super.csTriangle.origen[0][0], super.csTriangle.origen[1][0], targetO.blob3D.posX, targetO.blob3D.posY)-targetO.blob.radio;

        //Se pasan los valores angulares y de radio al robot
        super.valAngle = int(Functions.constrain2(map(angleObject, super.rangeMinAngle, super.rangeMaxAngle, 2982, 1665), 2982, 1665));
        super.valRadio = int(Functions.constrain2(map(distObject, super.rangeMinRadio, super.rangeMaxRadio, 255, 0), 255, 0));
      }
    } else {
      //No hay rectangulo de seguimiento para el objeto asi que se reinicia el blob3D
      if (targetO != null) {
        targetO.blob3D.sizeR = 0;
        targetO.blob3D.sizeG = 0;
        targetO.blob3D.sizeB = 0;
        targetO.blob3D.model();
      }
      //Se abre apertura al control con el ScaleBox
      super.inputFromScaleBox = true;
    }

    if (trackRect[1] != null) {
      //Se calcula la posición del rectangulo de seguimiento en la nube de puntos
    } else {
      //No hay rectangulo de seguimiento para el objeto asi que se reinicia el blob3D
      if (targetH != null) {
        targetH.blob3D.sizeR = 0;
        targetH.blob3D.sizeG = 0;
        targetH.blob3D.sizeB = 0;
        targetH.blob3D.model();
      }
    }
  }

  /*
  DESCRIPCIÓN: Extrae la imagen de profundidad de las mismas dimenciones y posición que el rectangulo de seguimiento
   que es pasado a la función.
   PARAMS: 
   t: Rectángulo de seguimiento
   recNum: Rectangulo de seguimiento al que se refiere. 0 cuando es el rectangulo de seguimiento del objeto, 1 cuando es el de la mano (no funcional el de la mano)
   */
  private void extractImgDepth(TrackingRectangle t, int rectNum) {
    //Posición del rectangulo de seguimiento en la imagen tomando en cuenta la translación del color
    int px = int(t.c1.x+super.kinect.posXColor);
    int py = int(t.c1.y+super.kinect.posYColor);

    //Se comprueba las dimenciones de la imagen de profundidad del rectangulo de seguimiento
    int a1 = int(dist(t.c1.x, t.c1.y, t.c2.x, t.c2.y));
    int a2 = int(dist(t.c1.x, t.c1.y, t.c3.x, t.c3.y));
    if (rectNum == 0) {//del objeto
      if (imgDepthSegO.width != a1 || imgDepthSegO.height != a2) {
        imgDepthSegO = createImage(a1, a2, RGB);
        imgDepthValO = createImage(a1, a2, RGB);
      }
      //Se extraen las imagenes de profundidad
      labelingO.extractImage(super.kinect.getSegmentedDepthImg(), imgDepthSegO, px, py);
      labelingO.extractImage( super.kinect.getValuesDepthImg(), imgDepthValO, px, py);
      //Se realiza el labeling a la imagen segmentada de profundidad
      labelingO.labelingImage(imgDepthSegO, imgDepthValO);
    } else {//rectangulo de seguimiento de la mano
      if (imgDepthSegH.width != a1 || imgDepthSegH.height != a2) {
        imgDepthSegH = createImage(a1, a2, RGB);
        imgDepthValH = createImage(a1, a2, RGB);
      }
      //Se extraen las imagenes de profundidad
      labelingH.extractImage(super.kinect.getSegmentedDepthImg(), imgDepthSegH, px, py);
      labelingH.extractImage(super.kinect.getValuesDepthImg(), imgDepthValH, px, py);
      //Se realiza el labeling a la imagen segmentada de profundidad
      labelingH.labelingImage(imgDepthSegH, imgDepthValH);
    }
  }

  /*
  DESCRIPCION: Función usada para seleccionar el área(s) del objeto a seguir. Con un rectángulo de seguimiento del tipo TrackingRectangleCromatics se tiene 
   implementada pero para uno del tipo TrackingRectangleBoofCV se deja pendiente.
   
   PARAMS: 
   t: Rectánguo de seguimiento
   recNum: El numero del rectangulo de seguimiento. 0:Rectangulo de seguimiento del objeto, 1:Rectangulo de seguimiento de la mano
   idepth: Imágen de profundidad segmentada.
   */
  private void calculateTarget(TrackingRectangle t, int rectNum, PImage idepth) {
    Labeling labeling;
    values.clear();
    //se selecciona el obejeto labeling correspondiente
    if (rectNum == 0) {
      labeling = labelingO;
    } else {
      labeling = labelingH;
    }
    //De tipo TrackingRectangleCromatics
    if (t.getClass().getSimpleName().equals("TrackingRectangleCromatics")) {
      TrackingRectangleCromatics a = (TrackingRectangleCromatics) t;
      //Se verifica exista un target
      if (a.target != null) { 
        a.imgTracking.loadPixels();
        //Se extraen los valores de las areas que se encuentren dentro de la misma posición que los pixeles del target de color cromatico
        for (int x = int(a.target.blob.minx); x <= a.target.blob.maxx; x++) {
          for (int y = int(a.target.blob.miny); y <= a.target.blob.maxy; y++) {
            int index = x+y*a.imgTracking.width;
            if (0 <= index && index < a.imgTracking.width*a.imgTracking.height) {
              //Valor del area en la imagen cromatica
              int val = a.imgTracking.pixels[index];
              //Se comprueba si estamos en un pixel del blob de seguimiento
              if ( val == a.target.numEquival) {
                //valor del pixel en la imagen de profundidad segmentada
                int valD = idepth.pixels[index];
                //Se obtienen la información del pixel
                DataEquival dtA = labeling.data.get(valD);
                //Se verifica si el pixel se encuentra dentro de un candidato
                if (labeling.candidates.contains(dtA)) {
                  //Se contabiliza cuantos pixeles se sobreponen sobre el area del target cromatico
                  if (values.containsKey(valD)) {
                    int v = values.get(valD);
                    v++;
                    values.put(valD, v);
                  } else {
                    values.put(valD, 1);
                  }
                }
              }
            }
          }
        }

        int sizeVal = values.size();
        if (sizeVal == 0)return;
        int numArea=0; 
        //Se sacan las probabilidades de cada area y se extrae la mayor
        float proba = -100;
        for (int val : values.keySet()) {
          float probaArea = values.get(val)/a.target.density;
          if (probaArea > proba) {
            numArea = val;
          }
        }

        //Se asigna el target a seguir
        if (rectNum == 0) {
          targetO = labeling.data.get(numArea);
        } else {
          targetH = labeling.data.get(numArea);
        }
      }
    } else {//De tipo "TrackingRectangleBoofCV"
      /*Como este tipo de rectangulo de seguimiento no da información del area del objeto, si no solo realiza el seguimiento según lo que capture
       se debe realizar una segmentación de la imagen con la profundidad y seleccionar un objeto
       */
    }
  }

  /*
  DESCRIPCIÓN: Convierte un blob 2D dentro al espacio 3D.
   PARAMS: 
   t: Rectángulo de seguimiento.
   target: área seleccionada que representa al objeto a seguir.
   */
  private void calculatePosIn3D(TrackingRectangle t, DataEquival target) {
    if (target == null) return; 

    //Dimenciones del blob de seguimiento dentro del canvas
    float d1Canvas = target.blob.maxx-target.blob.minx; 
    float d2Canvas = target.blob.maxy-target.blob.miny; 

    //Dimenciones del blob de seguimiento en 2D
    target.blob3D.sizeR = d1Canvas; 
    target.blob3D.sizeG = d2Canvas; 

    //Posición central
    target.blob3D.posX = ((t.posXCenter)+super.kinect.posCloudX)-super.kinect.posXColor; 
    target.blob3D.posY = ((t.posYCenter)+super.kinect.posCloudY)-super.kinect.posYColor; 

    //Posición en el eje Z
    float pz = target.getAverageDepth(); 
    if (pz > 15) target.blob3D.posZ = pz; //Estabiliza el blob
    target.blob3D.sizeB = target.getAverageMaxDepth()-target.getAverageMinDepth(); 
    if (target.blob3D.sizeB < 40) target.blob3D.sizeB = 40; //Provoca que no se vea plano el blob
    
    if(target.blob3D.posEnfoque == null){
     println("posEnfoque is null"); 
    }
    if(super.kinect == null){
     println("t is null"); 
    }
    
    //Posicion de enfoque
    target.blob3D.posEnfoque.x = (((target.blob.posEnfoqueX+t.c1.x))+super.kinect.posCloudX)-super.kinect.posXColor; 
    target.blob3D.posEnfoque.y = (((target.blob.posEnfoqueY+t.c1.y))+super.kinect.posCloudY)-super.kinect.posYColor; 
    target.blob3D.posEnfoque.z = pz; 

    //Se calculan las esquinas del blob 3D
    target.blob3D.model(); 
    //Se obtiene su posición dentro del ultimo sistema de coordenadas del kinect
    calculatePosInKinectModel(target.blob3D);
  }

  /*
  DESCRIPCIÓN: Calcula las posiciones del blob3D en referencia al último sistema de coordenadas del modelo del kinect.
   PARAMS: 
   cd: Descriptor de color que representa el blob 3D
   */
  private void calculatePosInKinectModel(ColorDescriptor cd) {
    //POSICIÓN DEL RECTANGULO DE SEGUIMIENTO DENTRO DEL ULTIMO SISTEMA DE COORDENADAS DEL KINECT
    //centro
    w[0][0] = cd.posX; 
    w[1][0] = cd.posY; 
    w[2][0] = cd.posZ; 
    MatrixOperations.multiplyMatrices(super.kinect.E3.HMNextEslabon, w, w2 ); 
    cd.posX = w2[0][0]; 
    cd.posY = w2[1][0]; 
    cd.posZ = w2[2][0]; 

    //para p1
    w[0][0] = cd.p1.x; 
    w[1][0] = cd.p1.y; 
    w[2][0] = cd.p1.z; 
    MatrixOperations.multiplyMatrices(super.kinect.E3.HMNextEslabon, w, w2 ); 
    cd.p1.x = w2[0][0]; 
    cd.p1.y = w2[1][0]; 
    cd.p1.z = w2[2][0]; 

    //para p2
    w[0][0] = cd.p2.x; 
    w[1][0] = cd.p2.y; 
    w[2][0] = cd.p2.z; 
    MatrixOperations.multiplyMatrices(super.kinect.E3.HMNextEslabon, w, w2 ); 
    cd.p2.x = w2[0][0]; 
    cd.p2.y = w2[1][0]; 
    cd.p2.z = w2[2][0]; 

    //para p3
    w[0][0] = cd.p3.x; 
    w[1][0] = cd.p3.y; 
    w[2][0] = cd.p3.z; 
    MatrixOperations.multiplyMatrices(super.kinect.E3.HMNextEslabon, w, w2 ); 
    cd.p3.x = w2[0][0]; 
    cd.p3.y = w2[1][0]; 
    cd.p3.z = w2[2][0]; 

    //para p4
    w[0][0] = cd.p4.x; 
    w[1][0] = cd.p4.y; 
    w[2][0] = cd.p4.z; 
    MatrixOperations.multiplyMatrices(super.kinect.E3.HMNextEslabon, w, w2 ); 
    cd.p4.x = w2[0][0]; 
    cd.p4.y = w2[1][0]; 
    cd.p4.z = w2[2][0]; 

    //para p5
    w[0][0] = cd.p5.x; 
    w[1][0] = cd.p5.y; 
    w[2][0] = cd.p5.z; 
    MatrixOperations.multiplyMatrices(super.kinect.E3.HMNextEslabon, w, w2 ); 
    cd.p5.x = w2[0][0]; 
    cd.p5.y = w2[1][0]; 
    cd.p5.z = w2[2][0]; 


    //para p6
    w[0][0] = cd.p6.x; 
    w[1][0] = cd.p6.y; 
    w[2][0] = cd.p6.z; 
    MatrixOperations.multiplyMatrices(super.kinect.E3.HMNextEslabon, w, w2 ); 
    cd.p6.x = w2[0][0]; 
    cd.p6.y = w2[1][0]; 
    cd.p6.z = w2[2][0]; 

    //para p7
    w[0][0] = cd.p7.x; 
    w[1][0] = cd.p7.y; 
    w[2][0] = cd.p7.z; 
    MatrixOperations.multiplyMatrices(super.kinect.E3.HMNextEslabon, w, w2 ); 
    cd.p7.x = w2[0][0]; 
    cd.p7.y = w2[1][0]; 
    cd.p7.z = w2[2][0]; 

    //para p8
    w[0][0] = cd.p8.x; 
    w[1][0] = cd.p8.y; 
    w[2][0] = cd.p8.z; 
    MatrixOperations.multiplyMatrices(super.kinect.E3.HMNextEslabon, w, w2 ); 
    cd.p8.x = w2[0][0]; 
    cd.p8.y = w2[1][0]; 
    cd.p8.z = w2[2][0]; 

    //para el enfoque de agarre
    w[0][0] = cd.posEnfoque.x; 
    w[1][0] = cd.posEnfoque.y; 
    w[2][0] = cd.posEnfoque.z; 
    MatrixOperations.multiplyMatrices(super.kinect.E3.HMNextEslabon, w, w2 ); 
    cd.posEnfoque.x = w2[0][0]; 
    cd.posEnfoque.y = w2[1][0]; 
    cd.posEnfoque.z = w2[2][0];
  }

  /*
  DESCRIPCIÓN: Muestra el blob 3D dentro del Canvas.
   PARAMS: void
   */
  public void viewInSpace() {
    if (targetO != null) targetO.blob3D.view(); 
    if (targetH != null) targetH.blob3D.view(); 
    super.viewInSpace();
  }

  /*
  DESCRIPCIÓN: Mustra los blobs 2D obtenidos después de la segmentación de la imagen de profundidad dentro del Canvas.
   PARAMS: void
   */
  public void view() {

    if (showImgDepth) {
      //Iamgen del objeto
      if (trackRect[0] != null) {
        image(labelingO.imgColor, trackRect[0].c1.x+posXImgKinect, trackRect[0].c1.y+posYImgKinect); 
        if (targetO != null)targetO.blob.showBlob(int(trackRect[0].c1.x+posXImgKinect), int(trackRect[0].c1.y+posYImgKinect), color(255, 0, 0));
      }
      //imagen de la mano
      if (trackRect[1] != null) {
        image(labelingH.imgColor, trackRect[1].c1.x+posXImgKinect, trackRect[1].c1.y+posYImgKinect); 
        if (targetH != null)targetH.blob.showBlob(int(trackRect[1].c1.x+posXImgKinect), int(trackRect[1].c1.y+posYImgKinect), color(255, 0, 0));
      }

      //Candidatos de la segmentacion por profundidad
      if (trackRect[0] != null) {
        for (int i = 0; i < labelingO.candidates.size(); i++) {
          DataEquival a = labelingO.candidates.get(i); 
          if (a != targetO) {
            //Se muestra el blob
            a.blob.showBlob(int(posXImgKinect+trackRect[0].c1.x), int(posYImgKinect+trackRect[0].c1.y), color(0, 0, 255));
          }
        }
      }
      if (trackRect[1] != null) {
        for (int i = 0; i < labelingH.candidates.size(); i++) {
          DataEquival a = labelingH.candidates.get(i); 
          if (a != targetH) {
            //Se muestra el blob
            a.blob.showBlob(int(posXImgKinect+trackRect[1].c1.x), int(posYImgKinect+trackRect[1].c1.y), color(0, 0, 255));
          }
        }
      }
    }
  }
}
