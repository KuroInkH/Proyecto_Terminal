class SceneObjectDetection {
  //boton que muestra lo que esta pasando en el cuadrado de busqueda
  Button buttonShowContentCB;
  //boton que muestra las imaganes de profundidad dentro del rectángulo de seguimiento
  Button buttonShowDepthImg;
  //boton que resetea los cuadrados de busqueda
  Button buttonResetScene;
  //boton que dispara el neurocontrolador
  Button buttonNeuroControlador;
  //Rectangulos de seguimiento
  TrackingRectangleCromatics trackingRecCromaHand, trackingRecCromaObject;
  TrackingRectangleBoofCV trackingRecBoofHand, trackingRecBoofObject;
  //Menú para seleccionar el algoritmo de seguimiento
  Choice choiceTracker;
  //Controles de los parametros de detección 
  ScaleBox sBoxSensibilityArea, sBoxFrameRate, sBoxSensiDepth, sBoxDistStability, sBoxDistFusionBlob, sBoxDensityDepth;
  //Numero de colores
  TextBox tBoxNumColors;
  //tamaño del rango de selector de color
  TextBox tBoxDimBrush; 
  //Modelo completo del robot (kinect y brazo robótico)
  RoboticVision robotVision;
  //Imagen del kinect
  PImage img;
  //Variable auxiliar
  TrackingRectangle[] trackRec;

  SceneObjectDetection() {
    //Boton que muestra el contenido del cuadro de busqueda
    buttonShowContentCB = new Button(posXImgKinect+420, posYImgKinect+370, 60, 20, "ShowRGB");
    //Boton que resetea el contenido del cuadro de busqueda
    buttonResetScene = new Button(posXImgKinect+345, posYImgKinect+370, 60, 20, "Reset");
    //Boton que muestra la imagen de profundidad
    buttonShowDepthImg = new Button(posXImgKinect+270, posYImgKinect+370, 60, 20, "ShowD");
    //Boton que muestra la imagen de profundidad
    buttonNeuroControlador = new Button(posXImgKinect+170, posYImgKinect+370, 60, 20, "NeuroC");
    //rectangulos de seguimiento
    trackingRecCromaHand = new TrackingRectangleCromatics(posXImgKinect, posYImgKinect, "Hand");
    trackingRecCromaObject = new TrackingRectangleCromatics(posXImgKinect, posYImgKinect, "Object");
    trackingRecBoofHand = new TrackingRectangleBoofCV(posXImgKinect, posYImgKinect, "Hand");
    trackingRecBoofObject = new TrackingRectangleBoofCV(posXImgKinect, posYImgKinect, "Object");

    img = new PImage(480, 360);
    //Seleccionador
    choiceTracker = new Choice(posXImgKinect+305, posYImgKinect+400, 180, 20, 3);
    choiceTracker.addToGroup("trackerCirculant      ");
    choiceTracker.addToGroup("trackerTld            ");
    choiceTracker.addToGroup("trackerMeanShiftComaniciu");
    choiceTracker.addToGroup("trackerSparseFlow     ");
    choiceTracker.addToGroup("Chromatic colors      ");
    choiceTracker.selectedGroup = 4;

    trackRec = new TrackingRectangle[2];

    int px = posXImgKinect+15;
    int py = 529;
    int aument = 77;
    sBoxFrameRate = new ScaleBox(px, py, 8, 144, "FrameRate", "int");
    sBoxSensibilityArea = new ScaleBox(px+1*aument, py, 8, 144, "Density", "int");
    sBoxDistStability = new ScaleBox(px+2*aument, py, 8, 144, "DistEstabi", "float");
    sBoxDistFusionBlob = new ScaleBox(px+3*aument, py, 8, 144, "DistFusBlob", "float");
    sBoxSensiDepth = new ScaleBox(px+4*aument+10, py, 8, 144, "SensibilityD", "int");
    sBoxDensityDepth = new ScaleBox(px+5*aument+10, py, 8, 144, "DensityD", "int");

    //Controles del movimiento de suavisado del rectanguo de seguimiento

    //COnfiguración de rangos
    sBoxDistStability.setRange(4, 100);
    sBoxDistFusionBlob.setRange(4, 100);
    sBoxFrameRate.setRange(1, 10);
    sBoxSensibilityArea.setRange(0, 450);
    sBoxSensiDepth.setRange(10, 300);
    sBoxDensityDepth.setRange(100, 2000);

    //Valores por default
    sBoxDistStability.setDefaultVal(10);
    sBoxDistFusionBlob.setDefaultVal(10);
    sBoxFrameRate.setDefaultVal(1);
    sBoxSensibilityArea.setDefaultVal(90);
    sBoxSensiDepth.setDefaultVal(160);
    sBoxDensityDepth.setDefaultVal(200);

    tBoxDimBrush = new TextBox(posXImgKinect+215, posYImgKinect+400, 70, 20);
    tBoxDimBrush.setTextID("Dim Brush");
    tBoxDimBrush.setValue(5);

    tBoxNumColors = new TextBox(posXImgKinect+215, posYImgKinect+435, 70, 20);
    tBoxNumColors.setValue(5);
    tBoxNumColors.setTextID("Num Color");
  }

  /*
  DESCRIPCION: Realiza el seguimiento del objeto en cada rectángulo de seguimiento y ajusta los parámetros de detección del algoritmo de seguimiento
   PARAMS: 
   im: Imagen del kinect
   r: Modelo completo del robot
   */
  public void model(PImage im, RoboticVision r) {
    img = im;
    robotVision = r;
    robotVision.kinect.umbral = sBoxSensiDepth.val;
    robotVision.labelingH.thresHoldDensity = int(sBoxDensityDepth.val);
    robotVision.labelingO.thresHoldDensity = int(sBoxDensityDepth.val);

    if (choiceTracker.selectedGroup == 4) {
      //Se reinician los rectangulos de seguimiento de boof para evitar que corran por atras
      trackingRecBoofHand.reset();
      trackingRecBoofObject.reset();

      //Se realiza el seguimiento
      trackingRecCromaHand.model(img);
      trackingRecCromaObject.model(img);

      //VALORES DE CONFIGURACION
      //distancia estabilizadora
      trackingRecCromaHand.distStability = sBoxDistStability.val;
      trackingRecCromaObject.distStability = sBoxDistStability.val;
      //Umbral de densidad de area
      trackingRecCromaHand.labeling.thresHoldDensity = int(sBoxSensibilityArea.val);
      trackingRecCromaObject.labeling.thresHoldDensity = int(sBoxSensibilityArea.val);
      //Distancia de fusión de blob
      trackingRecCromaHand.labeling.distBlob = sBoxDistFusionBlob.val;
      trackingRecCromaObject.labeling.distBlob = sBoxDistFusionBlob.val;
      //Cada cuantos frames se realiza el seguimiento
      trackingRecCromaHand.frameRateTR = int(sBoxFrameRate.val);
      trackingRecCromaObject.frameRateTR = int(sBoxFrameRate.val);
      //tamaño del pincel selector de color
      trackingRecCromaHand.tamBrush = int(tBoxDimBrush.val);
      trackingRecCromaObject.tamBrush = int(tBoxDimBrush.val);
      //Cantidad de colores a seleccionar
      trackingRecCromaHand.setNumColors(int(tBoxNumColors.val));
      trackingRecCromaObject.setNumColors(int(tBoxNumColors.val));
    } else {
      //Se reinician los rectangulos de seguimiento de color cromatico para evitar que corran por atras
      trackingRecCromaHand.reset();
      trackingRecCromaObject.reset();

      //Se realiza el seguimiento
      trackingRecBoofHand.model(img);
      trackingRecBoofObject.model(img);

      //Se pasan los valores de configuracion
      trackingRecBoofHand.frameRateTR = int(sBoxFrameRate.val);
      trackingRecBoofObject.frameRateTR = int(sBoxFrameRate.val);
    }
  }

  /*
  DESCRIPCIÓN: Retorna los rectángulos de seguimiento ue se encuentren dentro del canvas.
   PARAMS: void
   */
  public TrackingRectangle[] getTrackingRectangle() {
    if (choiceTracker.selectedGroup == 4) {
      if (trackingRecCromaHand.validSizeRectangle)trackRec[1] = trackingRecCromaHand;
      else trackRec[1] = null;

      if (trackingRecCromaObject.validSizeRectangle)trackRec[0] = trackingRecCromaObject;
      else trackRec[0] = null;
    } else {
      if (trackingRecBoofHand.validSizeRectangle) trackRec[1] = trackingRecBoofHand;
      else trackRec[1] = null;

      if (trackingRecBoofObject.validSizeRectangle) trackRec[0] = trackingRecBoofObject;
      else trackRec[0] = null;
    }
    return trackRec;
  }

  /*
  DESCRIPCION: Muestra los controles de configuración de la detección de objetos y los rectángulos de seguimiento.
   PARAMS: void
   */
  public void view() {
    //botones
    buttonResetScene.view();
    buttonShowDepthImg.view();
    buttonNeuroControlador.view();
    //Selector
    choiceTracker.show(); 
    //Cada cuantos frames se realiza el seguimiento
    sBoxFrameRate.view();
    sBoxSensiDepth.view();
    sBoxDensityDepth.view();

    if (choiceTracker.selectedGroup == 4) {
      buttonShowContentCB.view();

      trackingRecCromaHand.view();
      trackingRecCromaObject.view();

      //distancia estabilizadora
      sBoxDistStability.view();
      //Umbral de densidad de area
      sBoxSensibilityArea.view();
      //Distancia de fusión de blob
      sBoxDistFusionBlob.view();
      //tamaño del pincel selector de color
      tBoxDimBrush.view();
      //Cantidad de colores a seleccionar      
      tBoxNumColors.view();
    } else {
      trackingRecBoofHand.view();
      trackingRecBoofObject.view();
    }

    //Posición del color respecto a la nube de puntos
    noFill();
    stroke(0);
    textSize(15);
    text("CloudPoints", posXImgKinect-(robotVision.posColor.x), posYImgKinect-(robotVision.posColor.y));
    rect(posXImgKinect-(robotVision.posColor.x), posYImgKinect-(robotVision.posColor.y), img.width, img.height);
  }

  /*
  DESCRIPCION: Función ejecutada cada vez que se precione un botón del mouse
   PARAMS: void
   */
  public void mousePressed() {
    choiceTracker.mousePressed();
    //Cada cuantos frames se realiza el seguimiento
    sBoxFrameRate.mousePressed();
    sBoxSensiDepth.mousePressed();
    sBoxDensityDepth.mousePressed();

    if (choiceTracker.selectedGroup == 4) {
      //distancia estabilizadora
      sBoxDistStability.mousePressed();
      //Umbral de densidad de area
      sBoxSensibilityArea.mousePressed();
      //Distancia de fusión de blob
      sBoxDistFusionBlob.mousePressed();
      //tamaño del pincel selector de color
      tBoxDimBrush.mousePressed();
      //Cantidad de colores a seleccionar   
      tBoxNumColors.mousePressed();

      if (mouseButton == LEFT) {
        trackingRecCromaHand.mousePressed();
      }
      if (mouseButton == RIGHT) {
        trackingRecCromaObject.mousePressed();
      }
    } else {
      if (mouseButton == LEFT) {
        trackingRecBoofHand.mousePressed();
      }
      if (mouseButton == RIGHT) {
        trackingRecBoofObject.mousePressed();
      }
    }

    //Boton para mostrar la profundidad
    if (buttonShowDepthImg.mousePressed()) {
      //se desactiva
      if (robotVision.showImgDepth) {
        robotVision.showImgDepth = false;
        buttonShowDepthImg.text = "ShowDepth";
      } else { //se activa
        trackingRecCromaHand.showImg = false;
        trackingRecCromaObject.showImg = false;
        buttonShowContentCB.text = "ShowImg";

        robotVision.showImgDepth = true;
        buttonShowDepthImg.text = "HideDepth";
      }
    }

    //Boton para disparar el neurocontrolador
    if (buttonNeuroControlador.mousePressed()) {
            
      try {
         //Process process = Runtime.getRuntime().exec("xterm -hold -e /home/bci/eclipse-workspace/Optimizador/Release/nsga2_arm_trajectory 0.5");
         Process process = Runtime.getRuntime().exec("konsole --hold -e /home/antonio/eclipse-workspace/nsga2_arm_trajectory/Release/nsga2_arm_trajectory 0.5");
        } catch (IOException e) {
          e.printStackTrace();
        }
     }
     
    //Se selecciona el boton de reseteo
    if (buttonResetScene.mousePressed()) {
      trackingRecCromaHand.reset();
      trackingRecCromaObject.reset();
      trackingRecBoofHand.reset();
      trackingRecBoofObject.reset();
    }

    //Se selecciona el boton de vista
    if (buttonShowContentCB.mousePressed()) {
      if (trackingRecCromaHand.showImg) {
        trackingRecCromaHand.showImg = false;
        trackingRecCromaObject.showImg = false;
        buttonShowContentCB.text = "ShowImg";
      } else {
        robotVision.showImgDepth = false;
        buttonShowDepthImg.text = "ShowDepth";

        trackingRecCromaHand.showImg = true;
        trackingRecCromaObject.showImg = true;
        buttonShowContentCB.text = "HideImg";
      }
    }
  }

  /*
  DESCRIPCION: Función ejecutada cada vez que se mantiene precionado un botón del mouse
   PARAMS: void
   */
  public void mouseDragged() {
    //Cada cuantos frames se realiza el seguimiento
    sBoxFrameRate.mouseDragged();
    sBoxSensiDepth.mouseDragged();
    sBoxDensityDepth.mouseDragged();

    if (choiceTracker.selectedGroup == 4) {
      trackingRecCromaHand.mouseDragged();
      trackingRecCromaObject.mouseDragged();

      //distancia estabilizadora
      sBoxDistStability.mouseDragged();
      //Umbral de densidad de area
      sBoxSensibilityArea.mouseDragged();
      //Distancia de fusión de blob
      sBoxDistFusionBlob.mouseDragged();
    } else {
      trackingRecBoofHand.mouseDragged();
      trackingRecBoofObject.mouseDragged();
    }
  }

  /*
  DESCRIPCION: Función ejecutada cada vez que se deje de precionar un botón del mouse
   PARAMS: void
   */
  void mouseReleased() {
    //Cada cuantos frames se realiza el seguimiento
    sBoxFrameRate.mouseReleased();
    sBoxSensiDepth.mouseReleased();
    sBoxDensityDepth.mouseReleased();

    if (choiceTracker.selectedGroup == 4) {
      trackingRecCromaHand.mouseReleased();
      trackingRecCromaObject.mouseReleased();

      //distancia estabilizadora
      sBoxDistStability.mouseReleased();
      //Umbral de densidad de area
      sBoxSensibilityArea.mouseReleased();
      //Distancia de fusión de blob
      sBoxDistFusionBlob.mouseReleased();
    } else {
      trackingRecBoofHand.mouseReleased();
      trackingRecBoofObject.mouseReleased();
    }
  }

  /*
  DESCRIPCIÓN: Función ejecutada cada vez que se precione una tecla.
   PARAMS: void
   */
  public void keyPressed() {
    //Cada cuantos frames se realiza el seguimiento
    sBoxFrameRate.keyPressed();
    sBoxSensiDepth.keyPressed();
    sBoxDensityDepth.keyPressed();

    if (choiceTracker.selectedGroup == 4) {
      //distancia estabilizadora
      sBoxDistStability.keyPressed();
      //Umbral de densidad de area
      sBoxSensibilityArea.keyPressed();
      //Distancia de fusión de blob
      sBoxDistFusionBlob.keyPressed();
      //tamaño del pincel selector de color
      tBoxDimBrush.keyPressed();
      //Cantidad de colores a seleccionar   
      tBoxNumColors.keyPressed();
    }
  }
}
