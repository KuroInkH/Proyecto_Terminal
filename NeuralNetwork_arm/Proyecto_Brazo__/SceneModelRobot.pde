class SceneModelRobot {

  //ScaleBox que controlan la posición de la nube de punto dentro del último sistema de coordenadas del modelo del kinect
  ScaleBox sBoxEkX, sBoxEkY;
  //ScaleBox que controlan la posición del color dentro de la nube de puntos.
  ScaleBox sBoxPosColorX, sBoxPosColorY;
  //Controla los servomotores del modelo y el robót físico. 
  ScaleBox[] sBoxAngles;
  //Controla el tamaño de los eslabones del modelo del robot.
  ScaleBox[] sBoxLengths;
  //Controla la posición radial y angular del robot.
  ScaleBox sBoxRadio, sBoxAngle;
  //TextBox que controla la escala del modelo y la resolución de la nube de punto.
  TextBox tBoxEscala, tBoxResolution;
  //TextBox que controla la posición del modelo dentro del espacio 3D
  TextBox tBoxPosXModel, tBoxPosYModel, tBoxPosZModel; 
  //TextBox que controla la rotación del modelo dentro del espacio 3D
  TextBox tBoxRotXModel, tBoxRotYModel, tBoxRotZModel; 
  //Modelo completo del robot (modelo del robot y el kinect)
  RoboticVision robotVision;
  //Imagen obtenida desde el kinect
  PImage img;
  //indica si se muestra o no la scena
  boolean hideScene;
  //Menú para controlar el modelo o realizar cambios
  Choice choiceControls;

  SceneModelRobot(PApplet c) {
    hideScene = false;

    choiceControls = new Choice(655, 110, 135, 20, 3);
    choiceControls.addToGroup("Modify Model");
    choiceControls.addToGroup("Control Links");
    choiceControls.addToGroup("Movement Hernando");
    choiceControls.addToGroup("Calibrate Kinect");
    choiceControls.selectedGroup = 1;

    robotVision = new RoboticVision(c);

    int aX = 170;
    int aY = 500;
    int aument = 68;
    sBoxAngles = new ScaleBox[7];
    sBoxLengths = new ScaleBox[9];

    sBoxLengths[0] = new ScaleBox(aX, aY, 8, 164, "E1", "float");
    sBoxLengths[1] = new ScaleBox(aX+aument, aY, 8, 164, "E2", "float");
    sBoxLengths[2] = new ScaleBox(aX+2*aument, aY, 8, 164, "E3", "float");
    sBoxLengths[3] = new ScaleBox(aX+3*aument, aY, 8, 164, "E35", "float");
    sBoxLengths[4] = new ScaleBox(aX+4*aument, aY, 8, 164, "E4", "float");
    sBoxLengths[5] = new ScaleBox(aX+5*aument, aY, 8, 164, "E45", "float");
    sBoxLengths[6] = new ScaleBox(aX+6*aument, aY, 8, 164, "E5", "float");
    sBoxLengths[7] = new ScaleBox(aX+7*aument, aY, 8, 164, "E1K", "float");
    sBoxLengths[8] = new ScaleBox(aX+8*aument, aY, 8, 164, "E2K", "float");

    float val = robotVision.getLengthLink("l1");
    sBoxLengths[0].setDefaultVal(val);
    sBoxLengths[0].setRange(val-10, val+10);

    val = robotVision.getLengthLink("l2");
    sBoxLengths[1].setDefaultVal(val);
    sBoxLengths[1].setRange(val-10, val+10);

    val = robotVision.getLengthLink("l3");
    sBoxLengths[2].setDefaultVal(val);
    sBoxLengths[2].setRange(val-10, val+10);

    val = robotVision.getLengthLink("l35");
    sBoxLengths[3].setDefaultVal(val);
    sBoxLengths[3].setRange(val-10, val+10);

    val = robotVision.getLengthLink("l4");
    sBoxLengths[4].setDefaultVal(val);
    sBoxLengths[4].setRange(val-10, val+10);

    val = robotVision.getLengthLink("l45");
    sBoxLengths[5].setDefaultVal(val);
    sBoxLengths[5].setRange(val-10, val+10);

    val = robotVision.getLengthLink("l5");
    sBoxLengths[6].setDefaultVal(val);
    sBoxLengths[6].setRange(val-10, val+10);

    val = robotVision.getLengthLink("l1k");
    sBoxLengths[7].setDefaultVal(val);
    sBoxLengths[7].setRange(val-10, val+10);

    val = robotVision.getLengthLink("l2k");
    sBoxLengths[8].setDefaultVal(val);
    sBoxLengths[8].setRange(val-10, val+10);

    sBoxAngles[0] = new ScaleBox(aX, aY, 8, 164, "E1", "float");
    sBoxAngles[1] = new ScaleBox(aX+aument, aY, 8, 164, "E2", "float");
    sBoxAngles[2] = new ScaleBox(aX+2*aument, aY, 8, 164, "E3", "float");
    sBoxAngles[3] = new ScaleBox(aX+3*aument, aY, 8, 164, "E4", "float");
    sBoxAngles[4] = new ScaleBox(aX+4*aument, aY, 8, 164, "E5", "float");
    sBoxAngles[5] = new ScaleBox(aX+5*aument, aY, 8, 164, "E1K", "float");
    sBoxAngles[6] = new ScaleBox(aX+6*aument, aY, 8, 164, "E2K", "float");

    val = 0;
    sBoxAngles[0].setDefaultVal(val);
    sBoxAngles[0].setRange(val-180, val+180);

    sBoxAngles[1].setDefaultVal(val);
    sBoxAngles[1].setRange(val-180, val+180);

    sBoxAngles[2].setDefaultVal(val);
    sBoxAngles[2].setRange(val-180, val+180);

    sBoxAngles[3].setDefaultVal(val);
    sBoxAngles[3].setRange(val-180, val+180);

    sBoxAngles[4].setDefaultVal(val);
    sBoxAngles[4].setRange(val-180, val+180);

    sBoxAngles[5].setDefaultVal(315);
    sBoxAngles[5].setRange(val-180, val+180);

    sBoxAngles[6].setDefaultVal(270);
    sBoxAngles[6].setRange(val-180, val+180);

    sBoxAngle = new ScaleBox(aX+aument, aY, 8, 164, "Angle", "int");
    sBoxRadio = new ScaleBox(aX+2*aument, aY, 8, 164, "Radio", "int");

    sBoxEkX = new ScaleBox(aX+aument, aY, 8, 164, "X", "float");
    sBoxEkY = new ScaleBox(aX+2*aument, aY, 8, 164, "Y", "float");
    sBoxPosColorX = new ScaleBox(aX+3*aument, aY, 8, 164, "Color X", "float");
    sBoxPosColorY = new ScaleBox(aX+4*aument, aY, 8, 164, "Color Y", "float");

    sBoxPosColorX.setDefaultVal(0);
    sBoxPosColorX.setRange(-100, 300);

    sBoxPosColorY.setDefaultVal(0);
    sBoxPosColorY.setRange(-100, 300);

    sBoxAngle.setDefaultVal(1665);
    sBoxAngle.setRange(1665, 2982);

    sBoxRadio.setDefaultVal( 255);
    sBoxRadio.setRange(255, 0);

    sBoxEkX.setDefaultVal(-188.292);
    sBoxEkX.setRange( sBoxEkX.val -133, sBoxEkX.val +150);

    sBoxEkY.setDefaultVal(-192.926);
    sBoxEkY.setRange(sBoxEkX.val -50, sBoxEkY.val +100);

    tBoxEscala = new TextBox(740, 190, 70, 20);
    tBoxResolution = new TextBox(740, 225, 70, 20);

    tBoxEscala.setTextID("Escala");
    tBoxResolution.setTextID("Resolution");
    tBoxEscala.setValue(10);
    tBoxResolution.setValue(4);

    aX = 140;
    aY = 135;
    tBoxPosXModel = new TextBox(aX, aY, 60, 20);
    tBoxPosYModel = new TextBox(aX, aY+35, 60, 20);
    tBoxPosZModel = new TextBox(aX, aY+70, 60, 20);
    tBoxPosXModel.setTextID("Pos X");
    tBoxPosYModel.setTextID("Pos Y");
    tBoxPosZModel.setTextID("Pos Z");
    tBoxPosXModel.setValue(robotVision.getLengthLink("base"));

    aX += 75;
    tBoxRotXModel = new TextBox(aX, aY, 60, 20);
    tBoxRotYModel = new TextBox(aX, aY+35, 60, 20);
    tBoxRotZModel = new TextBox(aX, aY+70, 60, 20);
    tBoxRotXModel.setTextID("Rot X");
    tBoxRotYModel.setTextID("Rot Y");
    tBoxRotZModel.setTextID("Rot Z");
  }

  /*
  DESCRIPCIÓN: Realiza las configuraciones de la escena o control de los modelos.
   PARAMS: 
   t: Rectangulo(s) de seguimiento provenientes de la escena SceneObjectDetection 
   */
  public void model(TrackingRectangle[] t) {
    //Se realiza el seguimiento del objeto a buscar
    robotVision.setTrackingRect(t);

    //resolucion de la nube de puntos
    robotVision.kinect.resolution = int(tBoxResolution.val);

    //Escala del modelo del robot
    robotVision.setEscala(int(tBoxEscala.val));

    //Se cambia de posición al modelo
    robotVision.setPosRobot(tBoxPosXModel.val, tBoxPosYModel.val, tBoxPosZModel.val);
    robotVision.setRotRobot(radians(tBoxRotXModel.val), radians(tBoxRotYModel.val), radians(tBoxRotZModel.val));

    //Secambia el tamaño de los eslabones del robotVision
    robotVision.setLengthLink("l1", sBoxLengths[0].val);
    robotVision.setLengthLink("l2", sBoxLengths[1].val);
    robotVision.setLengthLink("l3", sBoxLengths[2].val);
    robotVision.setLengthLink("l35", sBoxLengths[3].val);
    robotVision.setLengthLink("l4", sBoxLengths[4].val);
    robotVision.setLengthLink("l45", sBoxLengths[5].val);
    robotVision.setLengthLink("l5", sBoxLengths[6].val);
    robotVision.setLengthLink("l1k", sBoxLengths[7].val);
    robotVision.setLengthLink("l2k", sBoxLengths[8].val);

    //Se mueve el color en la nube de puntos
    robotVision.moveColor(sBoxPosColorX.val, sBoxPosColorY.val);

    //Se mueve la nube de puntos
    robotVision.setPosCloudPoints(sBoxEkX.val, sBoxEkY.val);

    //Se mueve de manera individual los servos
    if (choiceControls.selectedGroup == 1) {
      robotVision.mode = 0;
      if (false) {
        robotVision.setServoTurn("s1", radians(sBoxAngles[0].val));
        robotVision.setServoTurn("s2", radians(sBoxAngles[1].val));
        robotVision.setServoTurn("s3", radians(sBoxAngles[2].val));
        robotVision.setServoTurn("s4", radians(sBoxAngles[3].val));
        robotVision.setServoTurn("s5", radians(sBoxAngles[4].val));
        robotVision.setServoTurn("s1k", radians(sBoxAngles[5].val));
        robotVision.setServoTurn("s3k", radians(sBoxAngles[6].val));
      }
    }

    //Se mueve el robotVision según el algoritmo de Hernando
    if (choiceControls.selectedGroup == 2) {
      robotVision.mode = 1;
      if (t[1] == null) {
        robotVision.moveRobot("angle", int(sBoxAngle.val));
        robotVision.moveRobot("radio", int(sBoxRadio.val));
      } else {
        sBoxAngle.val = robotVision.valAngle;
        sBoxRadio.val = robotVision.valRadio;
      }
    }
    robotVision.model();
  }

  /*
  DESCRIPCIÓN: Retorna el modelo copleto del robot
   PARAMS: void 
   */
  public RoboticVision getRobot() {
    return robotVision;
  }

  /*
  DESCRIPCION: Retorna la imagen obtenida por el kinect
   PARAMS: void
   */
  public PImage getImgKinect() {
    img = robotVision.getImageKinect().copy();
    img.resize(480, 360);
    return img;
  }

  /*
  DESCRIPCION: Muestra el modelo completo del robot dentro del espacio 3D
   PARAMS: void
   */
  public void viewInSpace() {
    if (!hideScene) {
      robotVision.viewInSpace();
      if (robotVision.targetO != null) {
        stroke(255, 0, 0);
        line( robotVision.targetO.blob3D.posX, robotVision.targetO.blob3D.posY, robotVision.targetO.blob3D.posZ, robotVision.targetO.blob3D.posEnfoque.x, robotVision.targetO.blob3D.posEnfoque.y, robotVision.targetO.blob3D.posEnfoque.z);
        stroke(#D38031);
        line( robotVision.csTriangle.origen[0][0], robotVision.csTriangle.origen[1][0], robotVision.csTriangle.origen[2][0], robotVision.targetO.blob3D.posEnfoque.x, robotVision.targetO.blob3D.posEnfoque.y, robotVision.targetO.blob3D.posEnfoque.z);
      }
    }
  }

  /*
  DESCRIPCIÓN: Muestra los controles de la escena dentro del Canvas
   PARAMS: 
   */
  public void view() {
    robotVision.view();

    if (!hideScene) {
      tBoxEscala.view();
      tBoxResolution.view();
      choiceControls.show();

      if (choiceControls.selectedGroup == 0) {
        sBoxLengths[0].view();
        sBoxLengths[1].view();
        sBoxLengths[2].view();
        sBoxLengths[3].view();
        sBoxLengths[4].view();
        sBoxLengths[5].view();
        sBoxLengths[6].view();
        sBoxLengths[7].view();
        sBoxLengths[8].view();
        tBoxPosXModel.view();
        tBoxPosYModel.view();
        tBoxPosZModel.view();
        tBoxRotXModel.view();
        tBoxRotYModel.view();
        tBoxRotZModel.view();
      }

      if (choiceControls.selectedGroup == 1) {

        sBoxAngles[0].view();
        sBoxAngles[1].view();
        sBoxAngles[2].view();
        sBoxAngles[3].view();
        sBoxAngles[4].view();
        sBoxAngles[5].view();
        sBoxAngles[6].view();
      }

      if (choiceControls.selectedGroup == 2) {
        sBoxAngle.view();
        sBoxRadio.view();
      }
      if (choiceControls.selectedGroup == 3) {
        sBoxEkX.view();
        sBoxEkY.view();
        sBoxPosColorX.view();
        sBoxPosColorY.view();
      }
    }
  }

  /*
  DESCRIPCION: Muestra los datos enviados al robotVision y la posición de cada servo dentro del Canvas
   PARAMS: 
   info: el string "enviado" muestra los datos enviados al robot. "servos" muestra la posicion de cada servo 
   x,y: Posición dentro del canvas donde se mostrará la imagen
   */
  public void showText(String info, float x, float y) {
    fill(0);
    textSize(15);
    //valores enviados
    if (info.equals("enviado")) {
      text("Send to robot", x, y-2);
      textLeading(18);
      String s1 = "ValRadio:"+robotVision.valRadio;
      String s2 = "ValAngle:"+robotVision.valAngle;
      text(s1, x+5, y+20);
      text(s2, x+5, y+40);
      //rectangulo
      noFill();
      stroke(0);
      rect(x, y, 128, 50);
    }
    if (!hideScene) {

      //valores de servomotores
      if (info.equals("servos")) {

        text("Servos", x, y-2);
        textLeading(18);
        float val = degrees(robotVision.getServoTurn("s1"));
        String s1 = "Servo1: \nGrados:"+Functions.precisionFloat(val, 2)+"\nValor:"+(int)map(val, PI, -PI, 0, 4095);
        val = degrees(robotVision.getServoTurn("s2"));
        String s2 = "Servo2: \nGrados:"+Functions.precisionFloat(val, 2)+"\nValor:"+(int)map(val, PI, -PI, 0, 4095);
        val = degrees(robotVision.getServoTurn("s3"));
        String s3 = "Servo3: \nGrados:"+Functions.precisionFloat(val, 2)+"\nValor:"+(int)map(val, PI, -PI, 0, 4095);
        val = degrees(robotVision.getServoTurn("s4"));
        String s4 = "Servo4: \nGrados:"+Functions.precisionFloat(val, 2)+"\nValor:"+(int)map(val, PI, -PI, 0, 4095);
        val = degrees(robotVision.getServoTurn("s5"));
        String s5 = "Servo5: \nGrados:"+Functions.precisionFloat(val, 2)+"\nValor:"+(int)map(val, -1*radians(150), radians(150), 0, 1023);

        text(s1, x+5, y+20);
        text(s2, x+5, y+80);
        text(s3, x+5, y+140);
        text(s4, x+5, y+200);
        text(s5, x+5, y+260);
        //rectangulo
        noFill();
        stroke(0);
        rect(x, y, 113, 345);
      }
    }
  }

  /*
  DESCRIPCION: Función ejecutada cada vez que se mantiene precionado un botón del mouse
   PARAMS: void
   */
  public void mouseDragged() {
    if (!hideScene) {

      if (choiceControls.selectedGroup == 0) {
        for (int i = 0; i < 9; i++) sBoxLengths[i].mouseDragged();
      }
      if (choiceControls.selectedGroup == 1) {
        for (int i = 0; i < 7; i++) sBoxAngles[i].mouseDragged();
      }
      if (choiceControls.selectedGroup == 2) {
        sBoxAngle.mouseDragged();
        sBoxRadio.mouseDragged();
      }
      if (choiceControls.selectedGroup == 3) {
        sBoxEkX.mouseDragged();
        sBoxEkY.mouseDragged();
        sBoxPosColorX.mouseDragged();
        sBoxPosColorY.mouseDragged();
      }
    }
  }

  /*
  DESCRIPCION: Función ejecutada cada vez que se deje de precionar un botón del mouse
   PARAMS: void
   */
  public void mouseReleased() {
    if (!hideScene) {

      if (choiceControls.selectedGroup == 0) {
        for (int i = 0; i < 9; i++) sBoxLengths[i].mouseReleased();
      }
      if (choiceControls.selectedGroup == 1) {
        for (int i = 0; i < 7; i++) sBoxAngles[i].mouseReleased();
      }
      if (choiceControls.selectedGroup == 2) {
        sBoxAngle.mouseReleased();
        sBoxRadio.mouseReleased();
      }
      if (choiceControls.selectedGroup == 3) {
        sBoxEkX.mouseReleased();
        sBoxEkY.mouseReleased();
        sBoxPosColorX.mouseReleased();
        sBoxPosColorY.mouseReleased();
      }
    }
  }

  /*
  DESCRIPCION: Función ejecutada cada vez que se precione un botón del mouse
   PARAMS: void
   */
  public void mousePressed() {
    if (!hideScene) {
      choiceControls.mousePressed();
      tBoxEscala.mousePressed();
      tBoxResolution.mousePressed();

      if (choiceControls.selectedGroup == 0) {
        tBoxPosXModel.mousePressed();
        tBoxPosYModel.mousePressed();
        tBoxPosZModel.mousePressed();
        tBoxRotXModel.mousePressed();
        tBoxRotYModel.mousePressed();
        tBoxRotZModel.mousePressed();
        for (int i = 0; i < 9; i++) sBoxLengths[i].mousePressed();
      }
      if (choiceControls.selectedGroup == 1) {
        for (int i = 0; i < 7; i++) sBoxAngles[i].mousePressed();
      }
      if (choiceControls.selectedGroup == 2) {
        sBoxAngle.mousePressed();
        sBoxRadio.mousePressed();
      }
      if (choiceControls.selectedGroup == 3) {
        sBoxEkX.mousePressed();
        sBoxEkY.mousePressed();
        sBoxPosColorX.mousePressed();
        sBoxPosColorY.mousePressed();
      }
    }
  }

  /*
  DESCRIPCIÓN: Función ejecutada cada vez que se precione una tecla.
   PARAMS: void
   */
  public void keyPressed() {
    if (!hideScene) {
      tBoxEscala.keyPressed();
      tBoxResolution.keyPressed();

      if (choiceControls.selectedGroup == 1) for (int i = 0; i < sBoxAngles.length; i++) sBoxAngles[i].keyPressed();
      if (choiceControls.selectedGroup == 0) {  
        for (int i = 0; i < sBoxLengths.length; i++) sBoxLengths[i].keyPressed();
        tBoxPosXModel.keyPressed();
        tBoxPosYModel.keyPressed();
        tBoxPosZModel.keyPressed();
        tBoxRotXModel.keyPressed();
        tBoxRotYModel.keyPressed();
        tBoxRotZModel.keyPressed();
      }
      if (choiceControls.selectedGroup == 2) {
        sBoxAngle.keyPressed();
        sBoxRadio.keyPressed();
      }
      if (choiceControls.selectedGroup == 3) {
        sBoxEkX.keyPressed();
        sBoxEkY.keyPressed();
        sBoxPosColorX.keyPressed();
        sBoxPosColorY.keyPressed();
      }
    }
  }
}
