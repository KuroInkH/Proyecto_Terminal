import static javax.swing.JOptionPane.*;

/*
DESCRIPCIÓN: PDE principal donde se inicializa todo el programa, se dibuja en el Canvas y se ejecutan los eventos.
 
 NOTAS:
 
 1. Toda instancia de una clase que tenga la necesidad de los eventos por medio de las funciones: mouseDragged(), mouseReleased(), mousePressed(), keyPressed(), 
 debe de mandar a llamar a dichas funciones en su respectiva función (tiene el mismo nombre) dentro del pde principal.
 Las instancias que no implementen dichas funciones dentro del PDE principal no serán afectadas por los eventos, perdiendo comportamientos deseados. s
 */

//Escena 1: Detección de objetos
SceneObjectDetection sceneObjectDetection;
//Escena 2: Modelo del robot
SceneModelRobot sceneModelRobot;
//Escena 3: Espacio de color cromatico
SceneSpaceColor sceneSpaceColor;
//boton que muestra la scena 1
Button buttonShowSpaceColor;
//boton que muestra la scena 2
Button buttonShowModelRobot;
//Imagen del kinect
PImage imgkinect;
//posicion de la imagen obtenida por el kinect, dentro del canvas
int posXImgKinect, posYImgKinect;
//determina la poscion del espacio de color dentro del canvas
PVector translate;
//determian los angulos de rotacion del spacio de color dentro del canvas
float angleY, angleX, angleZ;
//indica si una texbox esta activado
boolean activeC;
//La imagen mostrada en el canvas es 3/4 de su tamaño, para convertir las medidas a su original se multiplica por 4/3
float escalaImgg;
//Escala de la imagen a la mostrada en el canvas
float escalaImggCanvas;

float catetoO, catetoA, hipotenusa;
Button buttonSave, buttonLoad;
String[] info;
String nameFile;
boolean errorLoad, errorDownload;

void setup() {
  size(1400, 700, P3D);
  colorMode(RGB);
  translate = new PVector();
  //posicion de la imagen obtenida por el kinect
  posXImgKinect = 850;
  posYImgKinect = 30;
  //Escenas
  sceneModelRobot = new SceneModelRobot(this);
  sceneObjectDetection = new SceneObjectDetection();
  sceneSpaceColor = new SceneSpaceColor();

  //Botones
  buttonShowSpaceColor = new Button(720, 50, 100, 30, "Space Color");
  buttonShowModelRobot = new Button(610, 50, 100, 30, "Model Robot");
  buttonShowSpaceColor.setColor(color(210));
  buttonShowModelRobot.setColor(color(210));
  buttonSave = new Button(30, 10, 88, 20, "Save Profile");
  buttonLoad = new Button(30, 35, 88, 20, "Load Profile");
  buttonSave.setColor(#ED4141);
  buttonLoad.setColor(#ED4141);

  showScene("modelRobot");

  escalaImgg = (float)4/(float)3;
  escalaImggCanvas = (float)3/(float)4;
}

void draw() {
  background(150);
  showWindow();

  //texto offline
  textSize(20);
  fill(0);
  if (!sceneModelRobot.hideScene) {
    if (sceneModelRobot.robotVision.isConnectCM700()) {
      fill(0, 255, 0);
      text("Conectado a CM700", 134, 105);
    } else {
      fill(255, 0, 0);
      text("Sin conexión con CM700", 134, 105);
    }
  }

  //Se obtiene la imagen del kinect
  imgkinect = sceneModelRobot.getImgKinect();
  image(imgkinect, posXImgKinect, posYImgKinect, imgkinect.width, imgkinect.height);

  //model
  sceneModelRobot.model(sceneObjectDetection.getTrackingRectangle());
  sceneObjectDetection.model(imgkinect, sceneModelRobot.getRobot());

  //puntero
  textSize(10);
  text("("+mouseX+", "+mouseY+")", mouseX, mouseY-10);

  pushMatrix();//matriz para mover todo el espacio de color con las teclas
  translate(translate.x, translate.y, translate.z);
  rotateY(radians(angleY));
  rotateX(radians(angleX));
  rotateZ(radians(angleZ));

  //Espacio 3D
  sceneModelRobot.viewInSpace();
  sceneSpaceColor.viewInSpace(sceneObjectDetection.getTrackingRectangle());

  popMatrix();

  //view
  sceneModelRobot.view();
  sceneObjectDetection.view();
  sceneSpaceColor.view();

  //Botones
  buttonShowModelRobot.view();
  buttonShowSpaceColor.view();
  buttonLoad.view();
  buttonSave.view();

  //texto
  sceneModelRobot.showText("enviado", posXImgKinect, posYImgKinect+380);
  sceneModelRobot.showText("servos", 15, 160);
  showTextPosScene(270, 35);

  //Texto de error
  if (errorDownload) {
    errorLoad = false;
    fill(255, 0, 0);
    text("Error al guardar el perfil: "+nameFile, 130, 20);
  }

  if (errorLoad) {
    errorDownload = false;
    fill(255, 0, 0);
    text("Error al guardar el perfil: "+nameFile, 130, 20);
  } else {
    if (!errorDownload) {
      fill(0, 255, 0);
      text("Perfil actual: "+nameFile, 130, 20);
    }
  }
}


/*
  DESCRIPCIÓN: Función utilizada para cargar las configuraciones del programa desde un archivo txt. LA función se ejecuta cada vez que se presiona el botón
 buttonLoad (véase función mousePressed()).
 PARAMS: 
 file: Archivo de salida
 */
void loadProfile(File selection) {
  if (selection != null) {
    try {
      nameFile = selection.getName();
      String[] data = loadStrings(selection.getAbsolutePath());
      //Se pasa la información al programa
      for (int i = 0; i < 9; i++) {
        sceneModelRobot.sBoxLengths[i].setVal(float(data[i]));
      }
      //Color
      sceneModelRobot.sBoxPosColorX.setVal(float(data[9]));
      sceneModelRobot.sBoxPosColorY.setVal(float(data[10]));
      //Nube de puntos
      sceneModelRobot.sBoxEkX.setVal(float(data[11]));
      sceneModelRobot.sBoxEkY.setVal(float(data[12]));
      //Frame rate
      sceneObjectDetection.sBoxFrameRate.setVal(float(data[13]));
      //tamaño del pincel selector de color
      sceneObjectDetection.tBoxDimBrush.setValue(float(data[14]));
      //Cantidad de colores a seleccionar 
      sceneObjectDetection.tBoxNumColors.setValue(float(data[15]));
      //distancia estabilizadora
      sceneObjectDetection.sBoxDistStability.setVal(float(data[16]));
      //Umbral de densidad de area
      sceneObjectDetection.sBoxSensibilityArea.setVal(float(data[17]));
      //Distancia de fusión de blob
      sceneObjectDetection.sBoxDistFusionBlob.setVal(float(data[18]));
      //sensibilidad de la segmentacion de la imagen de profundidad
      sceneObjectDetection.sBoxSensiDepth.setVal(float(data[19]));
      //Densidad de la imagen de profundidad
      sceneObjectDetection.sBoxDensityDepth.setVal(float(data[20]));
      //escala
      sceneModelRobot.tBoxEscala.setValue(float(data[21]));
      //Posición del modelo
      sceneModelRobot.tBoxPosXModel.setValue(float(data[22]));
      sceneModelRobot.tBoxPosYModel.setValue(float(data[23]));
      sceneModelRobot.tBoxPosZModel.setValue(float(data[24]));
      //Rotacion del model
      sceneModelRobot.tBoxRotXModel.setValue(float(data[25]));
      sceneModelRobot.tBoxRotYModel.setValue(float(data[26]));
      sceneModelRobot.tBoxRotZModel.setValue(float(data[27]));
    }
    catch(Exception a) {
      errorLoad = true;
    }
    errorLoad = false;
  } else {
    errorLoad = true;
  }
}

/*
  DESCRIPCIÓN: Función utilizada para guardar las configuraciones del programa dentro de un archivo txt. LA función se ejecuta cada vez que se presiona el botón
 buttonSave (véase función mousePressed()).
 PARAMS: 
 file: Archivo de salida
 */
void downloadProfile(File selection) {
  if (selection != null) {
    nameFile = selection.getName();
    //Se recolecta la información
    //longitud
    String data = "";
    for (int i = 0; i < 9; i++) {
      data +=  str(sceneModelRobot.sBoxLengths[i].val)+" ";
    }
    //color
    data += str(sceneModelRobot.sBoxPosColorX.val)+" ";
    data += str(sceneModelRobot.sBoxPosColorY.val)+" ";
    //nube de puntos
    data += str(sceneModelRobot.sBoxEkX.val)+" ";
    data += str(sceneModelRobot.sBoxEkY.val)+" ";
    //Frame rate
    data += str(sceneObjectDetection.sBoxFrameRate.val)+" ";
    //tamaño del pincel selector de color
    data += str(sceneObjectDetection.tBoxDimBrush.val)+" ";
    //Cantidad de colores a seleccionar 
    data += str(sceneObjectDetection.tBoxNumColors.val)+" ";
    //distancia estabilizadora
    data += str(sceneObjectDetection.sBoxDistStability.val)+" ";
    //Umbral de densidad de area
    data += str(sceneObjectDetection.sBoxSensibilityArea.val)+" ";
    //Distancia de fusión de blob
    data += str(sceneObjectDetection.sBoxDistFusionBlob.val)+" ";
    //sensibilidad de la segmentacion de la imagen de profundidad
    data += str(sceneObjectDetection.sBoxSensiDepth.val)+" ";
    //Densidad de la imagen de profundidad
    data += str(sceneObjectDetection.sBoxDensityDepth.val)+" ";
    //Escala
    data += str(sceneModelRobot.tBoxEscala.val)+" ";
    //Posición del modelo
    data += str(sceneModelRobot.tBoxPosXModel.val)+" ";
    data += str(sceneModelRobot.tBoxPosYModel.val)+" ";
    data += str(sceneModelRobot.tBoxPosZModel.val)+" ";
    //Rotacion del model
    data += str(sceneModelRobot.tBoxRotXModel.val)+" ";
    data += str(sceneModelRobot.tBoxRotYModel.val)+" ";
    data += str(sceneModelRobot.tBoxRotZModel.val)+" ";

    //Se comprueba el nombre del archivo
    int index = nameFile.indexOf(".");
    if (index != -1)nameFile = nameFile.substring(0, index);

    if (nameFile.length() > 0) { 
      //Se almacena la informacion
      try {
        saveStrings(nameFile+".txt", split(data, " "));
      }
      catch(Exception a) {
        errorDownload = true;
      }
      errorDownload = false;
    } else errorDownload = true;
  } else {
    errorDownload = true;
    nameFile = "";
  }
}

/*
  DESCRIPCION: Función ejecutada cada vez que se mantiene precionado un botón del mouse
 PARAMS: void
 */
void mouseDragged() {
  sceneModelRobot.mouseDragged();
  sceneObjectDetection.mouseDragged();
  sceneSpaceColor.mouseDragged();
}

/*
  DESCRIPCION: Función ejecutada cada vez que se precione un botón del mouse
 PARAMS: void
 */
void mousePressed() {
  sceneModelRobot.mousePressed();
  sceneObjectDetection.mousePressed();
  sceneSpaceColor.mousePressed();

  if (mouseButton == LEFT) {
    if (buttonShowSpaceColor.mousePressed()) {
      showScene("spaceColor");
    }
    if (buttonShowModelRobot.mousePressed()) {
      showScene("modelRobot");
    }
  }

  if (buttonSave.mousePressed()) {
    selectOutput("Guardar como", "downloadProfile");
  }

  if (buttonLoad.mousePressed()) {
    selectInput("Selecciona el perfil", "loadProfile");
  }
}

/*
  DESCRIPCION: Función ejecutada cada vez que se deje de precionar un botón del mouse
 PARAMS: void
 */
void mouseReleased() {
  //a.mouseReleased();
  sceneModelRobot.mouseReleased();
  sceneObjectDetection.mouseReleased();
  sceneSpaceColor.mouseReleased();
}

/*
  DESCRIPCIÓN: Función ejecutada cada vez que se precione una tecla.
 PARAMS: void
 */
void keyPressed() {
  sceneModelRobot.keyPressed();
  sceneSpaceColor.keyPressed();
  sceneObjectDetection.keyPressed();

  if (key == CODED && !activeC) {
    if (keyCode == RIGHT) translate.x+=10;
    if (keyCode == LEFT) translate.x-=10;
    if (keyCode == DOWN) translate.y +=10;
    if (keyCode == UP) translate.y -= 10;
  }
  if (key == '+') translate.z += 10;
  if (key == '-') translate.z -= 10;
  if (key == 'y') angleY+=10;
  if (key == '7') angleY-=10;
  if (key == 'd') angleX -=10;
  if (key == 'x') angleX += 10;
  if (key == 'z') angleZ += 10;
  if (key == 's') angleZ -= 10;
}

/*
DESCRIPCIÓN: Muestra el radio y ángulo polar en texto dentro del Canvas
 PARAMS:
 x=posición en el eje x
 y=posición en el eje y
 */
void showTextTriangle(float x, float y) { 
  fill(0);
  textSize(15);
  text("Triangle", x, y-2);
  String h = "Hipotenusa: "+Functions.precisionFloat(hipotenusa, 2);
  String co = "Cateto Opp: "+Functions.precisionFloat(catetoO, 2);
  String ca = "Cateto Ad: "+Functions.precisionFloat(catetoA, 2);

  text(co, x+5, y+20);
  text(ca, x+5, y+40);
  text(h, x+5, y+60);

  //rectangulo
  noFill();
  stroke(0);
  rect(x, y, 180, 70);
}

/*
  DESCRIPCIÓN: Cambia entre las escenas del modelo del robot y el espacio de color
 PARAMS: 
 scene: El string "spaceColor" cambia a la escena del espacio de color y el string "modelRobot" cambia a la escena del robot
 */
void showScene(String scene) {
  if (scene.equals("spaceColor")) {
    //posicion de escena
    translate.x = 440;
    translate.y = 330;
    translate.z = -110;

    angleX = 40;
    angleY = -360;
    angleZ = 20;

    //activacion/desactivacion de escenas
    sceneSpaceColor.hideScene = false;
    sceneModelRobot.hideScene = true;
  }

  if (scene.equals("modelRobot")) {
    //posicion de escena
    translate.x = -160;
    translate.y = 220;
    translate.z = -1380;

    angleX = 90;
    angleY = -210;
    angleZ = -180;

    //activacion/desactivacion de escenas
    sceneSpaceColor.hideScene = true;
    sceneModelRobot.hideScene = false;
  }
}

/*
DESCRIPCION: Muestra el fondo gris de programa
 PARAMS: void
 */
void showWindow() {
  color c = color(240);
  noStroke();
  fill(c);
  rect(0, 0, 130, height);
  rect(0, 0, width, 80);
  rect(posXImgKinect-30, 0, width-(posXImgKinect-30), height);
  rect(0, height-10, width, 10);
}

/*
DESCRIPCIÓN: Muestra la translación y rotación de la escena en texto
 PARAMS:
 x=posición en el eje x
 y=posición en el eje y
 */
void showTextPosScene(float x, float y) { 
  fill(0);
  textSize(15);
  textAlign(RIGHT);
  text("Scene", x-5, y+22);
  textAlign(LEFT);
  String t = "trans ("+translate.x+","+translate.y+","+translate.z+")";
  String r = "Rotat ("+angleX+","+angleY+","+angleZ+")";
  text(t, x+5, y+20);
  text(r, x+5, y+40);

  //rectangulo
  noFill();
  stroke(0);
  if (textWidth(t) < textWidth(r)) rect(x, y, textWidth(r)+10, 45);
  if (textWidth(r) < textWidth(t)) rect(x, y, textWidth(t)+10, 45);
}
