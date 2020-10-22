class SceneSpaceColor {

  //controles del tamañio del descriptor de color 
  ScaleBox sBoxSizeDescRHand, sBoxSizeDescGHand, sBoxSizeDescBHand;
  ScaleBox sBoxSizeDescRObject, sBoxSizeDescGObject, sBoxSizeDescBObject;
  //boton que regresa al tamañio por default del descriptor de color
  Button buttonDefaulSizeDescriptorColor;
  //translacion y rotacion de la escena
  PVector translationScene, rotationScene;
  //indica si se oculta la escena
  Boolean hideScene;

  SceneSpaceColor() {
    //se muestra la escena
    hideScene = false;

    //scalebox que controlan el tamaño del descriptor de color de la mano
    int posXSB = 160;
    int posYSB = 100;

    sBoxSizeDescRHand = new ScaleBox( posXSB, posYSB, 8, 164, "HSR", "float");
    sBoxSizeDescGHand = new ScaleBox( posXSB, posYSB+200, 8, 164, "HSG", "float");
    sBoxSizeDescBHand = new ScaleBox( posXSB, posYSB+400, 8, 164, "HSB", "float");

    //scalebox que controlan el tamaño del descriptor de color del objeto
    int posXSB2 = 780;
    int posYSB2 = 100;
    sBoxSizeDescRObject = new ScaleBox( posXSB2, posYSB2, 8, 164, "OSR", "float");
    sBoxSizeDescGObject = new ScaleBox( posXSB2, posYSB2+200, 8, 164, "OSG", "float");
    sBoxSizeDescBObject = new ScaleBox( posXSB2, posYSB2+400, 8, 164, "OSB", "float");

    //boton que gresa al tamanio por deafult los descriptores de color
    buttonDefaulSizeDescriptorColor = new Button(670, 560, 60, 20, "Default");

    //traslacion y rotacion de la escena
    //hay que establecer los valores por default
    translationScene = new PVector(0, 0, 0);
    rotationScene = new PVector(0, 0, 0);
  }

  /*
  DESCRIPCIÓN: Muestran los colores cromáticos obtenidos dentro del rectángulo de seguimiento y sus descriptores de color.
   Dichos descriptores son pasados a traves de sceneObjectDetection
   PARAMS: 
   tr: Arreglo con los descriptores de color a ser pasados
   */
  void viewInSpace(TrackingRectangle[] tr) {
    if (!hideScene) {

      //Linea que marca el eje x
      stroke(255, 0, 0);
      line(0, 0, 0, 255, 0, 0);

      //Linea que marca el eje y
      stroke(0, 255, 0);
      line(0, 0, 0, 0, 255, 0);

      //Linea que marca el eje z
      stroke(0, 0, 255);
      line(0, 0, 0, 0, 0, 255);

      //Rango del espacio de colores cromaticos
      stroke(0);
      line(255, 0, 0, 0, 255, 0);  
      line(0, 255, 0, 0, 0, 255);
      line(0, 0, 255, 255, 0, 0);
      line(255/2, 255/2, 0, 255/2, 255/2, 0);

      for (int k = 0; k < 2; k++) {
        if (tr[k] != null && tr[k].isSelected != null) {
          for (int i = 0; i < tr[k].isSelected.length; i+=2) {
            //Se establece el color del punto en el espacio de color cromatico
            if (tr[k].isSelected[i] == 1)stroke(255);
            else stroke(tr[k].posColorCromaR[i], tr[k].posColorCromaG[i], tr[k].posColorCromaB[i]);

            //Posición del punto del color cromatico
            pushMatrix();
            translate(tr[k].posColorCromaR[i], tr[k].posColorCromaG[i], tr[k].posColorCromaB[i]);
            point(0, 0);
            popMatrix();
          }
          //Se imprimen los descriptores
          for (int i = 0; i < tr[k].descriptores.length; i++) {
            tr[k].descriptores[i].view();
          }
        }
      }
    }
  }

  /*
  DESCRIPCIÓN: Muestra los controles de los descriptores de color
   PARAMS: 
   */
  public void view() {
    if (!hideScene) {
      sBoxSizeDescRHand.view();
      sBoxSizeDescGHand.view();
      sBoxSizeDescBHand.view();

      sBoxSizeDescRObject.view();
      sBoxSizeDescGObject.view();
      sBoxSizeDescBObject.view();

      buttonDefaulSizeDescriptorColor.view();
    }
  }

  /*
  DESCRIPCIÓN: 
   PARAMS: 
   */
  public void keyPressed() {
    if (!hideScene) {
      sBoxSizeDescRHand.keyPressed();
      sBoxSizeDescGHand.keyPressed();
      sBoxSizeDescBHand.keyPressed();

      sBoxSizeDescRObject.keyPressed();
      sBoxSizeDescGObject.keyPressed();
      sBoxSizeDescBObject.keyPressed();
    }
  }

  /*
  DESCRIPCION: Función ejecutada cada vez que se precione un botón del mouse
   PARAMS: void
   */
  public void mousePressed() {
    if (!hideScene) {
      sBoxSizeDescRHand.mousePressed(); 
      sBoxSizeDescGHand.mousePressed(); 
      sBoxSizeDescBHand.mousePressed(); 

      sBoxSizeDescRObject.mousePressed();
      sBoxSizeDescGObject.mousePressed();
      sBoxSizeDescBObject.mousePressed();

      if (buttonDefaulSizeDescriptorColor.mousePressed()) {
        /*sBoxSizeDescRObject.valScaleBox = tamDefaultRGB.x;
         sBoxSizeDescGObject.valScaleBox= tamDefaultRGB.y;
         sBoxSizeDescBObject.valScaleBox = tamDefaultRGB.z;
         
         sBoxSizeDescRHand.valScaleBox = tamDefaultRGB.x;
         sBoxSizeDescGHand.valScaleBox = tamDefaultRGB.y;
         sBoxSizeDescBHand.valScaleBox = tamDefaultRGB.z;*/
      }
    }
  }

  /*
  DESCRIPCION: Función ejecutada cada vez que se mantiene precionado un botón del mouse
   PARAMS: void
   */
  public void mouseDragged() {
    if (!hideScene) {
      sBoxSizeDescRHand.mouseDragged(); 
      sBoxSizeDescGHand.mouseDragged(); 
      sBoxSizeDescBHand.mouseDragged(); 

      sBoxSizeDescRObject.mouseDragged(); 
      sBoxSizeDescGObject.mouseDragged(); 
      sBoxSizeDescBObject.mouseDragged();
    }
  }

  /*
  DESCRIPCION: Función ejecutada cada vez que se deje de precionar un botón del mouse
   PARAMS: void
   */
  public void mouseReleased() {
    if (!hideScene) {
      sBoxSizeDescRHand.mouseReleased(); 
      sBoxSizeDescGHand.mouseReleased(); 
      sBoxSizeDescBHand.mouseReleased(); 

      sBoxSizeDescRObject.mouseReleased(); 
      sBoxSizeDescGObject.mouseReleased(); 
      sBoxSizeDescBObject.mouseReleased();
    }
  }
}
