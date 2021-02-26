/*
Clases que contiene el PDE:
 1. Choice
 2. ScaleBox
 3. TextBox
 4. Button
 */

/*
Clase usada para mostrar un menú seleccionador
 */
class Choice {
  /*
  DESCRIPCION: Clase usada para crear un menú dentro del Canvas. 
   
   */

  //Alamcena las opciones del menú
  private ArrayList<String> group;
  //Cada opción es un boton
  private Button[] buttons;
  //Botones de subir y bajar para navegar dentro del menú
  private Button[] upDown;
  //Posición inicial visual. Las opciones se enumeran apartir del cero, posGroup toma el valor de cualquier opción del menú y las opciones que se mostrarán 
  // son posGroup+showItems
  private int posGroup;

  //Posicón del menú
  public int posX, posY;
  //Número de opciones a mostrar en el menú
  public int showItems;
  //Ancho y alto de una opción. EL ancho del menú depende de widthC y el alto showItems*heightC
  public float widthC, heightC;
  //Opción seleccionada del menú
  public int selectedGroup;

  /*
  CONSTRUCTOR
   PARAMS:
   x,y : posición del menú dentro del Canvas. La posición es tomada desde la parte superior izquierda del menú.
   widthC: Ancho del menú
   heightC: Alto del menú
   showItem: Cuantas opciones puede mostrar el menú dentro del Canvas. Cuando el número de opciones es mayor a "showItem" algunas opciones
   se vana  ocultar y para acceder a ellas debes de navegar dentro del menú.
   */
  Choice(int x, int y, int widthC, int heightC, int showItem) {
    group = new ArrayList<String>();
    posX = x;
    posY = y;
    this.widthC = widthC;
    this.heightC = heightC;
    showItems = showItem;
    buttons = new Button[showItem];
    upDown = new Button[2];
    upDown[0] = new Button(posX+widthC+2, posY-1, 20, 20, "↑");
    upDown[1] = new Button(posX+widthC+2, posY+heightC*showItems-16, 20, 20, "↓");
    for (int i = 0; i < showItem; i++) {
      buttons[i] = new Button(posX, posY, 0, 0, "__");
      buttons[i].buttonHight = heightC;
      buttons[i].buttonWidth = widthC;
      buttons[i].setColorButton(color(255));
      buttons[i].colorText = color(0);
      buttons[i].setTextAlignButton("LEFT");
    }
    posGroup = 0;
  }

  /*
  DESCRIPCIÓN: Agrega una opción nueva al menú
   PARAMS: 
   name: texto de la nueva opción
   */
  public void addToGroup(String name) {
    if (!group.contains(name)) {
      group.add(name);
    }
  }

  /*
  DESCRIPCIÓN: Muestra el menú dentro del canvas
   PARAMS: void
   */
  public void show() {
    //Marco del menú
    stroke(0);
    fill(255);
    rect(posX-1, posY-1, widthC+2, heightC*showItems+4);
    //Barra de desplazamiento del menú
    fill(upDown[0].colorText);
    float heightBarra = (posY+heightC*showItems-16)-(posY+19);
    rect(posX+widthC+2, posY+19, 20, heightBarra);
    //Opciones que se muestran del menú
    int j=0;
    for (int i = posGroup; i < group.size() && i<posGroup+showItems; i++) {
      buttons[j].text = group.get(i);
      buttons[j].posX = posX;
      buttons[j].posY = posY+j*(heightC+1);
      buttons[j].view();
      j++;
    }
    //Botones de desplazamiento (arriba/abajo)
    upDown[0].view();
    upDown[1].view();

    //barra que muestra la posicón actual dentro de la barra de desplazamiento
    float barra = map(1, 0, group.size(), 0, showItems);
    if (barra <= 1) {
      float posYbarra = map(posGroup, 0, group.size(), posY+19, posY+19+heightBarra);
      fill(230);
      rect(posX+widthC+2, posYbarra, 20, heightBarra*barra);
    }

    //Se colorean las opciones
    if (selectedGroup-posGroup < showItems && selectedGroup-posGroup >= 0) {
      buttons[selectedGroup-posGroup].setColorButton(color(0));
      buttons[selectedGroup-posGroup].colorText = color(255);
      for (int i = 0; i < buttons.length; i++) {
        if (i != selectedGroup-posGroup) {
          buttons[i].setColorButton(color(255));
          buttons[i].colorText = color(0);
        }
      }
    } else {
      for (int i = 0; i < buttons.length; i++) {
        buttons[i].setColorButton(color(255));
        buttons[i].colorText = color(0);
      }
    }
  }

  /*
  DESCRIPCIÓN: Cada vez que se preciona el mouse se verifica si se navega en el menú o si se selecciona una opción
   PARAMS: void
   */
  public void mousePressed() {
    if (upDown[0].mousePressed()) {
      posGroup--;
      posGroup = constrain(posGroup, 0, group.size()-showItems);
    }

    if (upDown[1].mousePressed()) {
      posGroup++;
      posGroup = constrain(posGroup, 0, group.size()-showItems);
    }
    for (int i = 0; i < buttons.length; i++) {
      if (buttons[i].mousePressed()) {
        selectedGroup = i+posGroup;
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

class ScaleBox {
  /*
  DESCRIPCION: Clase usada para crear una barra deslizante. El scaleBox es el rectángulo de control. El indicador de valor es la cantidad que ha sido coloreada
   del scaleBox. EL scaleBox va del rango [rangeLimit,rangeLimitDown]
   Tiene un botón que devuelve el scaleBox a su valor por default y se le puede cambiar su vaor desde el tiempo de ejecución con uso de un textBox.
   */

  //Boton que establece el ScaleBox al default
  private Button buttonDefault;
  //posición del indicador de valor del ScaleBox (varita que sube y baja dentro del ScaleBox)
  private float posYIndicador;
  //dimensiones del ScaleBox
  private float sBoxHeight, sBoxWidth;
  //rangos limite del ScaleBox
  private float rangeLimit;
  private float rangeLimitDown;
  //valor por default del ScaleBox
  private float defaultVal;
  //Tipo del ScaleBox (int o float)
  private String type;
  //Area de texto
  private TextBox tb;
  //Inidica si se esta usando el scaleBox con click sostenido
  boolean drag;

  //Texto identificador del ScaleBox (texto que aparece encima del ScaleBox)
  public String text;
  //Posición del ScaleBox
  public int posX, posY;
  //Valor del ScaleBox
  public float val;

  /*
  CONSTRUCTOR
   PARMS:
   x,y: posición del scaleBox. La posición se toma desde la esquina superior izquierda del scaleBox. 
   w,h: Dimenciones del scaleBox
   txt: texto que se muestra en el Canvas, encima del ScaleBox.
   t: tipo del ScaleBox. Son dos tipos: "int" y "float". Cuando es int, los valores devueltos por el ScaleBox son puros enteros y cuando es float son valores con decimal
   */
  ScaleBox(int x, int y, float w, float h, String txt, String t) {
    posX = x;
    posY = y;
    posYIndicador = 0;
    sBoxWidth = w;
    sBoxHeight = h;
    text = txt;

    if (!t.equals("float") && !t.equals("int")) type = "float";
    else type = t;
    //rangos
    rangeLimitDown = 0;
    rangeLimit = 255;

    //Default
    defaultVal = rangeLimitDown;
    val = defaultVal;

    //botones
    buttonDefault = new Button(posX+sBoxWidth+4, posY+sBoxHeight-15, 20, 15, "Default");
    //Text Box
    float dx = 60;
    float dy = 15;
    tb = new TextBox(posX+sBoxWidth/2-dx/2, posY+sBoxHeight+4, dx, dy);
  }

  /*
  DESCRIPCIÓN: Muestra el scaleBox dentro del canvas
   PARAMS: void
   */
  public void view() {
    //Barra de rango
    fill(0);
    stroke(0);
    rect(posX, posY, sBoxWidth, sBoxHeight);
    //Barra indicadora
    fill(140);
    rect(posX, posY+sBoxHeight-posYIndicador, sBoxWidth, posYIndicador);
    //Se muestra el texBox
    tb.view();
    //Boton que establece el valor del scaleBox a su default
    buttonDefault.view();
    //Texto identificador del ScaleBox
    textAlign(CENTER);
    fill(0);
    textSize(14);
    text(text, posX+sBoxWidth/2, posY-3);
    textAlign(LEFT);
  }

  /*
  DESCRIPCIÓN: Establece el rango del ScaleBox
   PARAMS: 
   low: Limite inferior
   up: Limite superior
   */
  public void setRange(float low, float up) {
    if (low < up ) {
      rangeLimitDown = low;
      rangeLimit = up;
    } else {
      rangeLimitDown = up;
      rangeLimit = low;
    }
    setDefaultVal(defaultVal);
  }

  /*
  DESCRIPCIÓN: Establece el valor por default del ScaleBox
   PARAMS: 
   v: Valor por default
   */
  public void setDefaultVal(float v) {
    if (type.equals("int"))defaultVal = int(v);
    else defaultVal = v;
    val = defaultVal;
    posYIndicador = Functions.constrain2(map(val, rangeLimitDown, rangeLimit, 0, sBoxHeight), 0, sBoxHeight);
    tb.setValue(defaultVal);
  }

  /*
  DESCRIPCIÓN: Cambia de valor del ScaleBox
   PARAMS: 
   v: Nuevo valor del ScaleBox
   */
  public void setVal(float v) {
    if (type.equals("int"))val = int(v);
    else val = v;
    posYIndicador = Functions.constrain2(map(val, rangeLimitDown, rangeLimit, 0, sBoxHeight), 0, sBoxHeight);
    tb.setValue(val);
  }

  /*
  DESCRIPCIÓN: Cambia el valor del ScaleBox ya sea por medio de los botones del textBox, click en un área del ScaleBox o por el boton default.
   PARAMS: void
   */
  public void mousePressed() {
    //Se verifica si se dió click al textBox
    tb.mousePressed();
    //Se verifica si se dió click al boton up del TextBox
    if (tb.buttonUp.mousePressed()) {
      if (type.equals("int"))val = int(tb.val);
      else val = tb.val;
      //Tamaño de la barra indicadora
      posYIndicador = Functions.constrain2(map(val, rangeLimitDown, rangeLimit, 0, sBoxHeight), 0, sBoxHeight);
    }
    //Se verifica si se dió click al botón de abajo del textBox
    if (tb.buttonDown.mousePressed()) {
      if (type.equals("int"))val = int(tb.val);
      else val = tb.val;
      //Tamaño de la barra indicadora
      posYIndicador = Functions.constrain2(map(val, rangeLimitDown, rangeLimit, 0, sBoxHeight), 0, sBoxHeight);
    }
    //Se verifica si se dió click al botón default
    if (buttonDefault.mousePressed()) {
      if (type.equals("int"))val = int(defaultVal);
      else val = defaultVal; 
      //Tamaño de la barra indicadora
      posYIndicador = Functions.constrain2(map(val, rangeLimitDown, rangeLimit, 0, sBoxHeight), 0, sBoxHeight);
      tb.setValue(val);
    }
    //Se verifica si se dió click en un área del ScaleBox
    if (posX < mouseX && mouseX < posX+sBoxWidth && posY < mouseY && mouseY < posY+sBoxHeight) {
      float v = abs(posY+sBoxHeight-mouseY); 
      posYIndicador = v;

      //Valor del ScaleBox
      if (type.equals("int"))val = int(map(v, 0, sBoxHeight, rangeLimitDown, rangeLimit));
      else val = map(v, 0, sBoxHeight, rangeLimitDown, rangeLimit);

      drag = true;
      //Se cambia el valor del textBox
      tb.setValue(val);
    }
  }

  /*
  DESCRIPCIÓN: Cambia el valor del ScaleBox cuando se da click en su área de control y se mantiene sostenido
   PARAMS: void
   */
  public void mouseDragged() {
    if (drag) {
      //Tamaño de la barra indicadora
      float v = posY+sBoxHeight-mouseY; 
      posYIndicador = Functions.constrain2(v, 0, sBoxHeight);
      //Nuevo valor del ScaleBox
      if (type.equals("int"))val = int(Functions.constrain2(map(v, 0, sBoxHeight, rangeLimitDown, rangeLimit), rangeLimitDown, rangeLimit));
      else val = Functions.constrain2(map(v, 0, sBoxHeight, rangeLimitDown, rangeLimit), rangeLimitDown, rangeLimit);
      //Se cambia el valor del textBox
      tb.setValue(val);
    }
  }

  /*
  DESCRIPCIÓN: Se ejecuta la función cada vez que se suelta un boton del mouse
   PARAMS: 
   */
  public void mouseReleased() {
    drag = false;
  }

  /*
  DESCRIPCIÓN: Ingresa manualmente el valor del ScaleBox por medio del textBox
   PARAMS: void 
   */
  public void keyPressed() {
    boolean a = tb.active;
    tb.keyPressed();
    if (key == ENTER && a) {
      if (type.equals("int")) {
        val = int(tb.val);
        tb.setValue(val);
      } else  val = tb.val;
      posYIndicador = Functions.constrain2(map(val, rangeLimitDown, rangeLimit, 0, sBoxHeight), 0, sBoxHeight);
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


class TextBox {
  /*
DESCRIPCION: Caja de texto para valores numéricos. Se puede ingresar números desde el teclado. 
   */

  //posiciones del selector de texto
  private PVector posST1;
  private PVector posST2;
  //texto numérico que se muestra en el textBox
  private String text;
  //texto que se muestra en el canvas, a lado del textBox
  private String textID;
  //margen para el texto dentro del textBox
  private float margin;
  //Botones de aumento
  private Button buttonUp, buttonDown;
  //tiempo de parpadeo del selector de texto (milisegundos)
  private int time;
  //Almacena la posición del selector de texto (barra parpadeante que indica donde nos encontramos dentro del texto)
  private int index;
  //indica las dimenciones de los botones
  private float dimButton;
  //Indica el rango de vista del textbox (que caracteres se muestran dentro del textBox )
  private int iniIndexView, endIndexPos;
  //private indica la distancia máxima entre el inicio de vista y el final (indica cuantos caracteres se van a mostrar dentro del textBox)
  private int distView;
  //variables auxiliares
  private int timeAux;
  private boolean uni;
  //color del texto
  color textColor;

  //posicion del text box
  public float posX;
  public float posY;
  //dimenenciones del textBox
  public float tBoxWidth;
  public float tBoxHeight;
  //valor de aumento para el textBox
  public float aument;
  //indica si esta activo el texbox para escritura
  public boolean active;
  //valor que tiene el textBox
  public float val;

  /*
  Param:
   x: posicion en x dentro del canvas
   y: posicion en y dentro del canvas
   twidth: ancho del texbox
   twidth: alto del textbox
   t: Texto que se muestra a lado del textbox
   v: valor inicial
   */
  TextBox(float x, float y, float twidth, float theight) {
    posST1 = new PVector(0, 0, 0);
    posST2 = new PVector(0, 0, 0);
    posX = x;
    posY = y;
    tBoxHeight = theight;
    tBoxWidth = twidth;
    margin = tBoxHeight/10;
    aument = 1;
    time = 450;
    active = false;
    textColor = color(0);

    float aux = tBoxHeight/2;
    buttonUp = new Button(posX+tBoxWidth-aux, posY, aux, aux, "↑");
    buttonDown = new Button(posX+tBoxWidth-aux, posY+aux, aux, aux, "↓");
    buttonDown.setColorText(color(0));
    buttonUp.setColorText(color(0));
    dimButton = aux;
    text = "";
    uni = true;
    textID = "";
    setValue(0);
  }

  /*
  DESCRIPCIÓN: Muestra el textBox dentro del canvas
   PARAMS: 
   */
  public void view() {
    //textbox
    stroke(0);
    fill(255);
    rect(posX, posY, tBoxWidth-dimButton, tBoxHeight);
    //Se colorea el area texto con el mouse encima
    if (posX < mouseX && mouseX < posX+tBoxWidth-dimButton && posY < mouseY && mouseY < posY+tBoxHeight) {
      //text box
      stroke(40);
      fill(240);
      rect(posX, posY, tBoxWidth-dimButton, tBoxHeight);
    }
    //limites
    index = (int)Functions.constrain2(index, 0, text.length());
    iniIndexView = (int)Functions.constrain2(iniIndexView, 0, text.length());
    endIndexPos = (int)Functions.constrain2(endIndexPos, 0, text.length());
    calculateDistView();
    //Si esta activo el texto se muestra el cursor del texto
    parpadearTextSelct();
    //Se muestra el texto
    fill(0);
    textSize(tBoxHeight-2*margin);
    if (active) {
      moveCursorText();
    }
    text(text.substring(iniIndexView, endIndexPos), posX+margin, posY+tBoxHeight-margin);

    //texto identificador
    fill(0);
    textSize(10);
    text(textID, posX, posY-2);

    //Botones
    buttonDown.view();
    buttonUp.view();
  }

  /*
  DESCRIPCIÓN: Comprueba si el valor del textBox es válido y lo regresa en String
   PARAMS: void
   */
  private String getValue() {
    String s;
    //Se comprueban errores de entrada
    if (Float.isNaN(float(text)))val = 0;
    else val = float(text);
    //Casteo del valor
    if (val%1 == 0) s = str(int(val));
    else {
      s = str(val);
    }
    return s;
  }

  /*
  DESCRIPCIÓN: Cambia el valor del textBox
   PARAMS: 
   v: Nuevo valor del TextBox
   */
  public void setValue(float v) {
    text = Functions.getValue(v);
    val = v;
  }

  /*
  DESCRIPCIÓN: Asigna un texto descriptivo a lado del TextBox dentro del Canvas.
   PARAMS: 
   t: Texto que se muestra a lado del textBox dentro del canvas
   */
  public void setTextID(String t) {
    textID = t;
  }

  /*
  DESCRIPCION: Cuando se esta escribiendo en el area de texto, hace que parpadee el cursor del texto
   PARAMS: void
   */
  private void parpadearTextSelct() {
    int millis = millis();
    if (timeAux+time < millis && millis < timeAux+time+500 && active) {
      stroke(50);
      line(posST1.x, posST1.y, posST2.x, posST2.y);
    } else {
      if (millis > timeAux+time+500)timeAux = timeAux+time+500;
    }
  }

  /*
  DESCRIPCIÓN: Cambia la posición del cursor que indica donde se esta editando el número del TextBox
   PARAMS: void
   */
  private void moveCursorText() {
    moveView();
    if (index >= iniIndexView && index <= endIndexPos) {
      //Se calcula la distancia del texto hasta el primer caracter visible (indexView)
      float wt1 = textWidth(text.substring(0, iniIndexView));
      //Se calcula la distancia del texto desde el inicio del textBox a la posición actual
      float wt2 = textWidth(text.substring(0, index))-wt1;

      //Nueva posición del cursor
      posST1.x = posX+margin+wt2;
      posST1.y = posY+margin;

      posST2.x = posX+margin+wt2;
      posST2.y = posY+tBoxHeight-margin;
    }
  }

  /*
  DESCRIPCIÓN: Calcula cuantos caracteres pueden verse en el textBox
   PARAMS: void
   */
  private void calculateDistView() {
    textSize(tBoxHeight-2*margin);
    for (int i = iniIndexView; i <= text.length(); i++) {
      if (textWidth(text.substring(iniIndexView, i)) < tBoxWidth-2*margin-dimButton) {
        distView = i - iniIndexView;
      }
    }
    endIndexPos = iniIndexView+distView;
  }

  /*
  DESCRIPCIÓN: Mueve los caracteres que se ven en el textBox. Cuando no caben todos los caracteres en el textBox se deben ocultar algunos y se 
   van mostrando y ocultando según el cursor de texto.
   PARAMS: void
   */
  private void moveView() {
    if (index < iniIndexView && index >= 0) {
      iniIndexView = index;
      endIndexPos = index+distView;
    }

    if (index > endIndexPos && index <= text.length()) {
      endIndexPos = index;
      iniIndexView = index-distView;
    }

    if (distView > text.length()) {
      distView = text.length();
      iniIndexView = 0;
      endIndexPos = text.length();
    }

    //limites
    index = (int)Functions.constrain2(index, 0, text.length());
    iniIndexView = (int)Functions.constrain2(iniIndexView, 0, text.length());
    endIndexPos = (int)Functions.constrain2(endIndexPos, 0, text.length());
  }

  /*
  DESCRIPCIÓN: Elimina un caracter del area de texto, por la izquierda del indice
   PARAMS: void
   */
  private void deleteCharIzq() {

    String b="";
    String a="";
    if (index > 1)a = text.substring(0, index-1);
    if (index < text.length()) b = text.substring(index);
    //posición anterior
    index--;
    text = a+b;
  }

  /*
  DESCRIPCIÓN: Elimina un caracter del área de texto, por la derecha del índice
   PARAMS: void
   */
  private void deleteCharDer() {
    String b="";
    String a="";
    if (index > 0)a = text.substring(0, index);
    if (index < text.length()-1) b = text.substring(index+1);
    text = a+b;
  }

  /*
  DESCRIPCIÓN: Inserta un caracter por la derecha del indice, dentro del area de texto
   PARAMS: void
   */
  private void insertVal(String a) {
    String a1 ="";
    String b1 ="";

    if (index > 0) a1 = text.substring(0, index);
    if (index < text.length())b1 = text.substring(index);

    text = a1+a+b1;
    index++;
  }

  /*
  DESCRIPCIÓN: Activa los botones del arriba/abajo del textBox y activa la edición de texto cuando se le da click al area de texto del TextBox.
   PARAMS: void
   */
  public void mousePressed() {
    //aumentar el valor que muestra el textbox, al precionar el boton de arriba
    if (buttonUp.mousePressed()) {
      val = float(getValue());
      val += aument;
      text = Functions.getValue(val);
    }

    //disminuir el valor que muestra el textbox, al precionar el boton de arriba
    if (buttonDown.mousePressed()) {
      val = float(getValue());
      val -= aument;
      text = Functions.getValue(val);
    }

    //se edita el text box
    if (posX < mouseX && mouseX < posX+tBoxWidth-dimButton && posY < mouseY && mouseY < posY+tBoxHeight) {
      active = true;
    } else {
      active = false;
      text = getValue();
      iniIndexView = 0;
      endIndexPos = distView;
    }
  }

  /*
  DESCRIPCIÓN: Permite el ingreso de solo números dentro del ScaleBox desde el teclado.
   PARAMS: void
   */
  public void keyPressed() {
    //se mueve el selector de texto con las flechas
    if (active) {
      if (key == CODED ) {
        if (keyCode == RIGHT)index++;
        if (keyCode == LEFT)index--;
      }
      if (key == BACKSPACE) { 
        if (endIndexPos == text.length()) {
          if (iniIndexView >= 0 && endIndexPos <= text.length()) {
            iniIndexView--;
            endIndexPos--;
          }
        }
        deleteCharIzq();
      }
      if (key == DELETE) { 
        if (endIndexPos == text.length()) {
          if (iniIndexView >= 0 && endIndexPos <= text.length()) {
            iniIndexView--;
            endIndexPos--;
          }
        }
        deleteCharDer();
      }
      if (key == ENTER) {
        active = false;
        text = getValue();
        iniIndexView = 0;
        endIndexPos = distView;
      }
      if ((48 <= key && key <= 57) || key == '.' || key == '-') {
        if (text.length() < distView) {
          endIndexPos++;
        }
        insertVal(str(key));
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

class Button {
  /*
  DESCRIPCION: Clase usada para crear botones dentro del Canvas.
   */

  //Colores del boton durante sus distintos estados ("precionado", "encima de él" y "base" que es cuando solo se muestra el boton dentro del canvas sin ninguna interacción con el usuario)
  private color colorButtonPress;
  private color colorButtonOver;
  private color colorButtonView;
  //color del texto
  private color colorText;
  //Alineacion del texto de boton
  private int textA;

  //Texto del boton
  public String text;  
  //Posición del boton
  public float posX;
  public float posY;
  //Dimenciones el boton
  public float buttonWidth;
  public float buttonHight;


  /*
  Constructor: Se le pasa la posición del boton, el ancho y alto
   PARAMS: 
   x,y: Posición del botón
   w,h: dimenciones del botón. 
   t: texto mostrado dentro del botón.
   */
  Button(float x, float y, float w, float h, String t) {
    posX = x;
    posY = y;
    buttonHight = h;
    buttonWidth = w;
    text = t;
    setColorButton(#8C5E9D);
    colorText = #E8C7E7;
    textA = CENTER;
  }

  /*
  DESCRIPCIÓN: Cambia de color al botón
   PARAMS: void
   */
  public void setColorButton(color c) {
    float r, g, b;
    r = red(c);
    g = green(c);
    b = blue(c);

    colorButtonView = c;
    colorButtonOver = color(r-18, g-18, b-18);
    colorButtonPress = color(r+28, g+28, b+28);
  }

  /*
  DESCRIPCIÓN: Cambia el color del texto del botón.
   PARAMS: 
   c: Nuevo color del texto dle botón
   */
  public void setColorText(color c) {
    colorText = c;
  }

  /*
  DESCRIPCIÓN:  Cambia de color al botón y al texto
   PARAMS: 
   c: color nuevo para el botón
   */
  public void setColor(color c) {
    setColorButton(c);
    if (red(c) < 125 && green(c) < 125 && blue(c) < 125) {
      colorText = color(255);
    } else colorText = color(0);
  }

  /*
  DESCRIPCIÓN: Cambia la posición del texto dentro del botón.
   PARAMS: 
   a: Los string válidos son "CENTER", "LEFT", "RIGHT" para sus respectivas alineaciones. 
   */
  public void setTextAlignButton(String a) {
    if (a.equals("CENTER")) textA = CENTER;
    if (a.equals("LEFT")) textA = LEFT;
    if (a.equals("RIGHT")) textA = RIGHT;
  }

  /*
  DESCRIPCIÓN: Muestra el botón dentro del Canvas
   PARAMS: void
   */
  public void view() {
    //se comprueba si se pasa el mouse por encima 
    if (posX < mouseX && mouseX < posX+buttonWidth && posY < mouseY && mouseY < posY+buttonHight) {
      fill(colorButtonOver);
      stroke(colorButtonOver);
    } else {//si no se colorea normal
      fill(colorButtonView);
      stroke(colorButtonView);
    }

    //boton
    rect(posX, posY, buttonWidth, buttonHight);

    //Texto del boton
    float margin = 3;//tamao del margen inferior y superior para el texto
    float size = buttonHight - (2*margin);//tamaño del texto
    int index=1;
    textSize(size);
    if (textWidth(text)>buttonWidth) {//El texto no cabe en el boton
      for (int i = text.length(); i  > 0; i--) {
        if (textWidth(text.substring(0, i)) < buttonWidth) {
          index = i;
          break;
        }
      }
      //Se coloca el texto parcialmente, hasta donde quepa el texto
      fill(colorText);
      text(text.substring(0, index), posX, posY+buttonHight-margin);
    } else {
      if (textA == CENTER) {
        //Se coloca el texto en el centro del boton
        textAlign(CENTER);
        fill(colorText);
        text(text, posX+(buttonWidth/2), posY+buttonHight-margin);
      }
      if (textA == LEFT) {
        textAlign(LEFT);
        fill(colorText);
        text(text, posX, posY+buttonHight-margin);
      }
      if (textA == RIGHT) {
        textAlign(RIGHT);
        fill(colorText);
        text(text, posX+buttonWidth, posY+buttonHight-margin);
      }
    }
    textAlign(LEFT);
  }

  /*
  DESCRIPCIÓN: Regresa un booleano cuando al botón se le da click
   PARAMS: void
   */
  public boolean mousePressed() {
    if (posX < mouseX && mouseX < posX+buttonWidth && posY < mouseY && mouseY < posY+buttonHight) {
      fill(colorButtonPress);
      stroke(colorButtonPress);
      rect(posX, posY, buttonWidth, buttonHight);
      return true;
    } else return false;
  }
}
