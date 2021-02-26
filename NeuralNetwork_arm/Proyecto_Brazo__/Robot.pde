/*
Clases que contiene el PDE:
 1. Robot
 2. RobotArm
 3. Eslabon
 */

import org.openkinect.processing.*;
import org.openkinect.freenect.*;
import processing.serial.*;
import java.util.*;
import java.net.*;
import java.io.*;


class Robot extends Thread {

  //Valores del tamaño de los links y giro de los servos del kinect y el robot
  private float[] anglesServos, lengthLinks;
  //imagen del kinect
  private PImage img;
  //Desactiva la entrada por scalebox
  private boolean inputFromScaleBox;
  //Rangos de mapeo de los movimientos radiales y angulares
  private float rangeMinRadio, rangeMaxRadio, rangeMinAngle, rangeMaxAngle;
  // Se utilizan para ubicar y rotar el modelo del brazo dentro del espacio 3D.
  private PVector posModelRobot, rotModelRobot;
  //Escala del modelo.
  private float escala;
  //Calcula las esquinas del espacio de trabajo de robot.
  private PVector p1, p2, p3, p4;

  //Brazo del robot
  public RobotArm robotArm;
  //Kinect
  public KinectControl kinect;
  //Objeto a sujetar
  public Objeto objeto1;
  //Coordenadas de objeto1
  public PVector[] objCoord;
  //Objeto(s) a evitar
  public Obstacle[] obstaculo;
  //Coordenadas de obstáculos
  public PVector[] obstaculos;
  //Número de obstáculos
  public int numObstaculos;
  public boolean chocado = false;
  //valor del movimiento del radio y ángulo del Robot (Algoritmo de Hernando)
  public int valRadio, valAngle;
  //Posición de la nube de puntos dentro de los ejes x,y del sistema de coordenadas final del kinect
  public PVector posCloud;
  //Recorre el color dentro de la nube de puntos sobre los ejes x,y
  public PVector posColor;
  //Indica si se usa el algoritmo de Hernando o se usan los valores individuales del robot. mode = 1 (Hernando) mode=0(valor individual de cada servo)
  public int mode;
  //Los movimientos que hace el brazo es como se formara un triángulo rectangulo donde la punta de la muñeca del brazo y el segundo servo son las esquinas de la 
  //hipotenusa. csTriangle es el vértice donde se forma el ángulo recto de dicho triángulo.
  public CoordinateSystem csTriangle; 


   class RemoteMethodInterface implements Runnable {

      float[] w = new float[54];   //////////////////////------------------------------------------------------------------5---->6
      float[] initAngles = new float[]{0, 0, 1.5, -1.5};
      float[] angles = new float[4];

               
      /*
      * Este es el método que cambiará los valores de los ángulos del modelo.
      */
      public void evaluateMovement(float[] a, double[] resultados) {
        for (int i = 0; i < a.length; i++) {
          anglesServos[i] = a[i];
          //System.out.println("Ángulo " + i + ": " + anglesServos[i]);
        }
      
        // Esperar que se hagan los cálculos del movimiento.
        try{
          Thread.sleep(500);
        }
        catch(InterruptedException ie) {}
      
          // Objetivo 1: Suma de los angulos.
          float sumaAngulos = 0.0;
          for (int i = 0; i < a.length; i++)
            sumaAngulos += abs(a[i]);
      
          resultados[0] = sumaAngulos;//sumaAngulos;
      
          // Objetivo 2: Riesgo de colisión
          float riesgo = 0; int numObs = 0;
          for(int y = 0; y < numObstaculos; y++){
            if (obstaculo[y].isVisible) {
              numObs++;
            }
            riesgo = riesgo + getObstacleDistance(obstaculo[y]);
          }
          if (numObs >= 1) {
            resultados[1] = riesgo/numObs;
          }else{
            resultados[1] = 0;
          }
      
          PVector Coord = new PVector();
      
          Coord.x=robotArm.eslabon5.csNextEslabon.origen[0][0];
          Coord.y=robotArm.eslabon5.csNextEslabon.origen[1][0];
          Coord.z=robotArm.eslabon5.csNextEslabon.origen[2][0];
          resultados[2]= (1*objeto1.DistanciaCentro(Coord)) - (objeto1.size/2);
      }  
      
      public ArrayList<Double> getCoordDistance(){
        ArrayList<Double> distCoord = new ArrayList<Double>();
        PVector Coord = new PVector();
        double[] result = new double[3];

        Coord.x=robotArm.eslabon5.csNextEslabon.origen[0][0];
        Coord.y=robotArm.eslabon5.csNextEslabon.origen[1][0];
        Coord.z=robotArm.eslabon5.csNextEslabon.origen[2][0];
        result = objeto1.getCoordDistance(Coord);        
        for(int i = 0; i < result.length; i++){
          distCoord.add(result[i]);
        }        
        return distCoord;       
      }
      
      
      //dividir 1/getObstacleDistance y guardar en la variable RiesgoDeColisión
      public float getObstacleDistance(Obstacle obst){
        float distancia = 0, distFin = 0;
        int numEslabon = 4;

      if (obst.isVisible) {
          PVector p = new PVector();
          PVector[] rA = new PVector[numEslabon];
          PVector[] rB = new PVector[numEslabon];
      
          for(int i =0; i < numEslabon; i++){
            rA[i] = new PVector();
            rB[i] = new PVector();
          }

          //Set obstacle distance
          p.x = obst.Centro.x;
          p.y = obst.Centro.y;
          p.z = obst.Centro.z;
          //Set bot actual distance
          //eslabon1 es de 1 a 2
          rA[0].x=robotArm.eslabon1.csNextEslabon.origen[0][0];
          rA[0].y=robotArm.eslabon1.csNextEslabon.origen[1][0];
          rA[0].z=robotArm.eslabon1.csNextEslabon.origen[2][0];
          rB[0].x=robotArm.eslabon2.csNextEslabon.origen[0][0];
          rB[0].y=robotArm.eslabon2.csNextEslabon.origen[1][0];
          rB[0].z=robotArm.eslabon2.csNextEslabon.origen[2][0];
      
          //Eslabon2 es de 2 a 3
          rA[1].x=robotArm.eslabon2.csNextEslabon.origen[0][0];
          rA[1].y=robotArm.eslabon2.csNextEslabon.origen[1][0];
          rA[1].z=robotArm.eslabon2.csNextEslabon.origen[2][0];
          rB[1].x=robotArm.eslabon3.csNextEslabon.origen[0][0];
          rB[1].y=robotArm.eslabon3.csNextEslabon.origen[1][0];
          rB[1].z=robotArm.eslabon3.csNextEslabon.origen[2][0];
      
          //Eslabon3 es de 3 a 4
          rA[2].x=robotArm.eslabon3.csNextEslabon.origen[0][0];
          rA[2].y=robotArm.eslabon3.csNextEslabon.origen[1][0];
          rA[2].z=robotArm.eslabon3.csNextEslabon.origen[2][0];
          rB[2].x=robotArm.eslabon4.csNextEslabon.origen[0][0];
          rB[2].y=robotArm.eslabon4.csNextEslabon.origen[1][0];
          rB[2].z=robotArm.eslabon4.csNextEslabon.origen[2][0];
      
          //Eslabon4 es de 4 a 5
          rA[3].x=robotArm.eslabon4.csNextEslabon.origen[0][0];
          rA[3].y=robotArm.eslabon4.csNextEslabon.origen[1][0];
          rA[3].z=robotArm.eslabon4.csNextEslabon.origen[2][0];
          rB[3].x=robotArm.eslabon5.csNextEslabon.origen[0][0];
          rB[3].y=robotArm.eslabon5.csNextEslabon.origen[1][0];
          rB[3].z=robotArm.eslabon5.csNextEslabon.origen[2][0];
          
          //Calcular vector director
          for(int i = 0; i < numEslabon; i++){
            //Calcular vector director
            PVector director = new PVector();
            director = new PVector();
            director.x = rB[i].x - rA[i].x;
            director.y = rB[i].y - rA[i].y;
            director.z = rB[i].z - rA[i].z;
            //System.out.println("El vector director es: " + director.x +", " + director.y +", "+ director.z);
      
            //Calcular el VectorAP
            PVector AP = new PVector();
            AP.x = p.x - rA[i].x;
            AP.y = p.y - rA[i].y;
            AP.z = p.z - rA[i].z;
            //System.out.println("El vector AP es: " + AP.x +", "+ AP.y +", "+ AP.z);
      
            //Calcular el producto vectorial
            PVector APV = new PVector();
            APV.x = ((AP.y*director.z)-(director.y*AP.z));
            APV.y = -((AP.x*director.z)-(director.x*AP.z));
            APV.z = ((AP.x*director.y)-(director.x*AP.y));
            //System.out.println("El vector APV es: " + APV.x +", "+ APV.y +", "+ APV.z);
      
            //Calcular la distancia final
            float sqrtAPV = (float) sqrt((APV.x*APV.x) + (APV.y*APV.y) + (APV.z*APV.z));
            float sqrtV = (float) sqrt((director.x*director.x) + (director.y*director.y) + (director.z*director.z));
            float dist = (sqrtAPV/sqrtV) - ((obst.size/2)+5);
            if(dist < 3){
              chocado = true;
              System.out.println("CHOCAMOS!");
            }
            distancia = distancia + dist;
          }
  
          distFin = distancia/numEslabon;        
        }
        return distFin;
    }
      
      
      
   @Override
   /*
   * Este método estará ciclando para atender la peticiones de evaluación:
   *   - Leer parámetros.
   *   - Regresar valores de los objetivos.
   */
   public void run() {
        //When there is a obstacle value is 1, otherwise 0
        int isObstacle = 1;

        //Here we connect with the NSGA-II
        System.out.println("Entrando al run del hilo...");
        ServerSocket serverSocket = null;
        Socket clientSocket = null;

        try {
            serverSocket = new ServerSocket(7778);
            System.out.print("Esperando la conexión del socket...");
            clientSocket = serverSocket.accept();
            System.out.println("... ya se conectó.");
        } catch (IOException e) {
            e.printStackTrace();
        } // 7778 is port number
        
        System.out.println("Se creó el socket en el puerto 7778...");

        String inputLine;
        BufferedReader in;
        BufferedWriter wr;

        //We create the neural network
        int inputNeurons = 3+isObstacle, hiddenNeurons = 6, outputNeurons = 5;
        ArrayList<Integer> hiddenLayers = new ArrayList<Integer>();
        hiddenLayers.add(hiddenNeurons);
        NeuralNetwork nn = new NeuralNetwork(inputNeurons,  hiddenLayers, outputNeurons); 
        
        try {
          in = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
          wr = new BufferedWriter(new OutputStreamWriter(clientSocket.getOutputStream()));

          while(true) {
            System.out.println("Esperando petición de C++...");
            inputLine = in.readLine();
            Scanner scanner = new Scanner(inputLine);

            int i = 0;
            while (scanner.hasNext()) {
                if (scanner.hasNextFloat()) {
                    w[i] = scanner.nextFloat();
                    //System.out.println("peso " + i + " = " + w[i]);
                    i++;
                }
                else {
                    System.out.println("Not found Double() value :" + scanner.next());
                }
            }
          
          /**************
             * 2. Ya se leyeron los nuevos ángulos, ahora se tienen que evaluar los criterios
             * de desempeño del movimiento del brazo: distancia al punto final, aceleración, energía.
             * 2.1 En la segunda versión recibe los pesos para la red neuronal. Una vez recibidos
             * los asignamos a la red.
             ****************/
             ArrayList<Double> w2 = new ArrayList<Double>();
             for(int m = 0; m < w.length; m++){
               w2.add((double)w[m]);
             }            

            nn.setWeight(w2);

            double[] resultados = new double[3];
            double actualDistance = Integer.MAX_VALUE, obstacleDistance = Integer.MAX_VALUE, sumAng = 0;
            int MaxIt = 15, finalIterNumber = 0;

            for (int k = 0; k < initAngles.length; k++) {
                  anglesServos[k] = initAngles[k];
              }
              try{
                  Thread.sleep(150);
              }
              catch(InterruptedException ie) {
              }
              
              //Coloca los obstáculos. Ya están predefinidos.
              setScene(0);

            while(finalIterNumber < MaxIt && actualDistance > 5){
                float riesgo = Integer.MAX_VALUE;
;
                for(int y = 0; y < numObstaculos; y++){
                    float temp = getObstacleDistance(obstaculo[y]);
                    if (temp < riesgo) {
                      riesgo = temp;
                    }
                }

                nn.setInput(getCoordDistance(), (double)riesgo, isObstacle);
                nn.calcular();
                angles = nn.getAngles();
                
                evaluateMovement(angles,resultados);
                try{
                    Thread.sleep(200);
                }
                catch(InterruptedException ie) {
                }
                
                if(resultados[1] < obstacleDistance)
                  obstacleDistance = resultados[1];

                if(resultados[2] < actualDistance){
                  actualDistance = resultados[2];
                  sumAng = resultados[0];
                }
  
                finalIterNumber++;
            }
            
            System.out.println("Riesgo de colisión: " + obstacleDistance);
            System.out.println("Mejor distancia: "+ actualDistance);         
            System.out.println("Complejidad de ángulos: "+ sumAng);         

            resultados[0] = sumAng;
            if(isObstacle == 0){
              resultados[1] = 0;
            } else{
              resultados[1] = 1/obstacleDistance;
            }
            
            if(actualDistance < 5){
              resultados[2] = 0;
            } else{
              resultados[2] = actualDistance;
            }            
            
            System.out.println("Resultados");
            System.out.println("Obj1: Suma de ángulos: "+resultados[0]);
            System.out.println("Obj2: Distancia promedio a obstaculos: " + resultados[1]);
            System.out.println("Restr: Distancia al objeto: "+resultados[2]);
  
            /**************************
             * 3. Ahora se regresará al optimizador los valores de la evaluación del movimiento.
             **************************/
            System.out.println("enviado...");
            String sDist = String.valueOf(resultados[0]) + " " + String.valueOf(resultados[1]) + " " + String.valueOf(resultados[2]);
            wr.write(sDist);
            wr.flush(); // flushes the stream
          } 
        } catch (IOException e) {
            e.printStackTrace();
        }

      }
   }
   
   public void setScene(int actualScene){
     objeto1.cambiarCoordenadas(objCoord[actualScene]);
     
     switch(actualScene){
       case 0:
         obstaculo[0].isVisible = true;
         obstaculo[1].isVisible = false;
         obstaculo[2].isVisible = false;
         obstaculo[3].isVisible = false;
         break;
       case 1:
         obstaculo[0].isVisible = false;
         obstaculo[1].isVisible = false;
         obstaculo[2].isVisible = false;
         obstaculo[3].isVisible = false;
         break;
       case 2:
         obstaculo[0].isVisible = false;
         obstaculo[1].isVisible = false;
         obstaculo[2].isVisible = false;
         obstaculo[3].isVisible = false;
         break;         
     }
   }
   
  Robot(PApplet canvas) {
    robotArm = new RobotArm(canvas);
    kinect = new KinectControl(canvas);

    anglesServos = new float[7];
    anglesServos[0] = robotArm.angleE1;
    anglesServos[1] = robotArm.angleE2;
    anglesServos[2] = robotArm.angleE3;
    anglesServos[3] = robotArm.angleE4;
    anglesServos[4] = robotArm.angleE5;
    anglesServos[5] = kinect.angleE1;
    anglesServos[6] = kinect.angleE3;
    lengthLinks= new float[11];
    lengthLinks[0] = robotArm.getLengthLink("base");
    lengthLinks[1] = robotArm.getLengthLink("l1");
    lengthLinks[2] = robotArm.getLengthLink("l2");
    lengthLinks[3] = robotArm.getLengthLink("l3");
    lengthLinks[4] = robotArm.getLengthLink("l35");
    lengthLinks[5] = robotArm.getLengthLink("l4");
    lengthLinks[6] = robotArm.getLengthLink("l45");
    lengthLinks[7] = robotArm.getLengthLink("l5");
    lengthLinks[8] = kinect.getLengthLink("l1");
    lengthLinks[9] = kinect.getLengthLink("l2");
    lengthLinks[10] = kinect.getLengthLink("l3");

    posCloud = new PVector();
    posCloud.x = -320;
    posCloud.y = -240;

    posColor = new PVector();

    mode = 1;

    csTriangle = new CoordinateSystem();

    inputFromScaleBox = true;
    p1= new PVector();
    p2= new PVector();
    p3= new PVector();
    p4= new PVector();
    posModelRobot = new PVector();
    rotModelRobot = new PVector();

    //Se indica que se calcule los angulos de mapeo
    robotArm.isModifyModel = true;
    //comienza a ejecutar la instancia de Robot en un hilo
    start();
    
    
    //Coordenadas del primer objeto que sujetara el robot
    objCoord = new PVector[4];
    
    for(int i = 0; i < 4; i++){
      objCoord[i] = new PVector();
    }
    
    objCoord[0].x = 194;
    objCoord[0].y = 100;
    objCoord[0].z = 200;
                   
    objCoord[2].x = 150;
    objCoord[2].y = 172;
    objCoord[2].z = 100;
                  
    objCoord[3].x = 222;
    objCoord[3].y = 52;
    objCoord[3].z = 27;
    
    objCoord[1].x = 420;
    objCoord[1].y = 397.27917;
    objCoord[1].z = -374.7792;
    
    /*CoordObst[3].x=420;
    CoordObst[3].y=397.27917;
    CoordObst[3].z=-374.7792;*/

    objeto1 = new Objeto(objCoord[1],40,150,20,10);
    
    
    
    //Creación de los obstáculos y sus coordenadas
    numObstaculos = 4;
    PVector[] CoordObst = new PVector[numObstaculos];
    for(int i = 0; i < numObstaculos; i++){
      CoordObst[i] = new PVector();
    }
    
    CoordObst[0].x=206;
    CoordObst[0].y=241;
    CoordObst[0].z=-150;
    
    CoordObst[1].x=138;
    CoordObst[1].y=123;
    CoordObst[1].z=200;
    
    CoordObst[2].x=-182;
    CoordObst[2].y=150;
    CoordObst[2].z=-200;
    
    /*CoordObst[2].x=420;
    CoordObst[2].y=127.27922;
    CoordObst[2].z=-374.7792;*/
    
    /*CoordObst[3].x=420;
    CoordObst[3].y=397.27917;
    CoordObst[3].z=-374.7792;*/
    
    CoordObst[3].x=-222;
    CoordObst[3].y=-100;
    CoordObst[3].z=270;
    
    //Aquí cambiamos la cantidad de obstáculos 
    obstaculo = new Obstacle[numObstaculos];
    for(int i = 0; i < numObstaculos; i++){
      obstaculo[i] = new Obstacle(CoordObst[i], 45,100,0, 150);
    }
    
    
    
     Thread t = new Thread(new RemoteMethodInterface());
      t.start();
  }

  /*
  DESCRIPCION: Retorna la imagen del kinect
   PARAMS: void
   */
  public PImage getImageKinect() {
    kinect.getImageFromKinect();
    img = kinect.imgRGB;
    return img;
  }

  /*
  DESCRIPCION: Calcúla la posición del vértice del triangulo rectángulo cuyas aristas que lo componen forman un ángulo de 90 grados. El brazo se mueve como si 
   estuviera dentro de un triángulo rectánguo que cambia de tamaño.
   PARAMS: void
   */
  private void triangleRobot() {
    CoordinateSystem ee = robotArm.eslabon5.csNextEslabon;
    CoordinateSystem sh = robotArm.eslabon2.csEslabon;
    csTriangle.reset();
    csTriangle.moveCS(sh.origen[0][0], sh.origen[1][0], sh.origen[2][0]);
    csTriangle.moveCS(0, 0, ee.Z[2][0]);
  }

  /*
  DESCRIPCION: Cambia de posición al model del brazo dentro del espacio 3D. La posición se toma desde el primer servomotor.
   PARAMS: 
   x,y,z: Nueva posición del modelo
   */
  public void setPosRobot(float x, float y, float z) {
    posModelRobot.x = x; 
    posModelRobot.y = y; 
    posModelRobot.z = z;
  }

  /*
  DESCRIPCION: Rota el modelo del brazo a lo largo de los 3 ejes. 
   PARAMS: 
   x,y,z: Nueva orientación del modelo.
   */
  public void setRotRobot(float x, float y, float z) {
    rotModelRobot.x = x; 
    rotModelRobot.y = y; 
    rotModelRobot.z = z;
  }

  /*
  DESCRIPCION: Cambia la escala del modelo. La escala a 1 el tamaño de los links es dado en cm. 
   PARAMS: 
   e: Nuevo número de escala del modelo
   */
  public void setEscala(float e) {
    escala = e;
  }

  /*
  DESCRIPCION: Manda la señal a la mano pediatrica para que se cierre.
   PARAMS: void
   */
  public void takeObject() {
    robotArm.closeHand();
  }

  /*
  DESCRIPCION: Manda la señal a la mano pediatrica para que se abra.
   PARAMS: void
   */
  public void dropObject() {
    robotArm.openHand();
  }

  /*
  DESCRIPCION: Función ejecutada en un hilo independiente.
   */
  public void run() {
    while (true) {
      //se mueve la nuve de puntos sobre el eje x,y del sistema de coordenadas final de kinect y
      //Se mueve el color entorno a la nube de puntos
      kinect.model(int(posCloud.x), int(posCloud.y), int(posColor.x), int(posColor.y));

      //Se mueve y rota el modelo del robot
      robotArm.setPosRobot(posModelRobot.x, posModelRobot.y, posModelRobot.z);
      robotArm.setRotRobot(rotModelRobot.x, rotModelRobot.y, rotModelRobot.z);

      //escala del modelo
      robotArm.setEscala(escala);

      //Los angulos del modelo se establecen según los valores recibidos desde la targeta CM700
      robotArm.receiveAnglesFromRobot();

      //Se establecen los tamaños de los links
      robotArm.setLengthLink(lengthLinks[0], lengthLinks[1], lengthLinks[2], lengthLinks[3], lengthLinks[4], lengthLinks[5], lengthLinks[6], lengthLinks[7]);
      kinect.setLengthLink(lengthLinks[8], lengthLinks[9], lengthLinks[10]);

      int retrasoMiliSeg = 10;

      //se rotan los servos de manera individual
      if (mode == 0) {
        kinect.rotateServo(anglesServos[5], anglesServos[6]);
        //se cambia el angulo de giro del robot
        robotArm.rotateServo("s1", anglesServos[0]);
        delay(retrasoMiliSeg);
        robotArm.rotateServo("s2", anglesServos[1]);
        delay(retrasoMiliSeg);
        robotArm.rotateServo("s3", anglesServos[2]);
        delay(retrasoMiliSeg);
        robotArm.rotateServo("s4", anglesServos[3]);
        delay(retrasoMiliSeg);
        robotArm.rotateServo("s5", anglesServos[4]);
        delay(retrasoMiliSeg);
      }

      //se rotan los servos según el algoritmo de Hernando
      if (mode == 1) {
        robotArm.moveRobotArm("angle", valAngle, true);
        delay(retrasoMiliSeg);
        robotArm.moveRobotArm("radio", valRadio, true);
        //Imprime los valores radiales y angulares cuando es manipulado con los ScaleBox

        //println(atan2(robotArm.eslabon5.csNextEslabon.origen[1][0] - csTriangle.origen[1][0], robotArm.eslabon5.csNextEslabon.origen[0][0] - csTriangle.origen[0][0]));
        //println(dist(csTriangle.origen[0][0], csTriangle.origen[1][0], robotArm.eslabon5.csNextEslabon.origen[0][0], robotArm.eslabon5.csNextEslabon.origen[1][0]));
      }

      //Cinematica de seguimiento
      robotArm.perfomFollowKinematic();
      kinect.perfomFollowKinematic();

      //calcula los puntos del trinagulo
      triangleRobot();

      /*Si se modifcó el modelo, ya sea el tamaño de un link o se rotó, entonces se debe actualizar los rangos de mapeo de las distancias radiales y anguales.
       Esto es provocado porque al modificar un link entonces el modelo del robot no tendrá el mismo alcance es su espacio de trabajo, si se rota el modelo
       entonces las direcciones de movimiento ya no son las mismas.
       */
      if (robotArm.isModifyModel) {
        //se calcula el punto p1
        robotArm.moveRobotArm("angle", 1665, false);
        robotArm.moveRobotArm("radio", 0, false);
        robotArm.perfomFollowKinematic();//se calcula la nueva posicion del endEfector
        //Se obtienen las posiciones
        p1.x = robotArm.eslabon5.csNextEslabon.origen[0][0];
        p1.y = robotArm.eslabon5.csNextEslabon.origen[1][0];
        p1.z = robotArm.eslabon5.csNextEslabon.origen[2][0];
        //Se actualizan los rangos de mapeo
        rangeMaxRadio = dist(p1.x, p1.y, p1.z, csTriangle.origen[0][0], csTriangle.origen[1][0], csTriangle.origen[2][0]);
        rangeMaxAngle = atan2(robotArm.eslabon5.csNextEslabon.origen[1][0] - csTriangle.origen[1][0], robotArm.eslabon5.csNextEslabon.origen[0][0] - csTriangle.origen[0][0]);


        //se calcula el punto p2
        robotArm.moveRobotArm("angle", 1665, false);
        robotArm.moveRobotArm("radio", 255, false);
        robotArm.perfomFollowKinematic();//se calcula la nueva posicion del endEfector
        //Se obtienen las posiciones
        p2.x = robotArm.eslabon5.csNextEslabon.origen[0][0];
        p2.y = robotArm.eslabon5.csNextEslabon.origen[1][0];
        p2.z = robotArm.eslabon5.csNextEslabon.origen[2][0];
        //Se actualizan los rangos de mapeo
        rangeMinRadio = dist(p2.x, p2.y, p2.z, csTriangle.origen[0][0], csTriangle.origen[1][0], csTriangle.origen[2][0]);

        //se calcula el punto p3
        robotArm.moveRobotArm("angle", 2982, false);
        robotArm.moveRobotArm("radio", 0, false);
        robotArm.perfomFollowKinematic();//se calcula la nueva posicion del endEfector
        //Se obtienen las posiciones
        p3.x = robotArm.eslabon5.csNextEslabon.origen[0][0];
        p3.y = robotArm.eslabon5.csNextEslabon.origen[1][0];
        p3.z = robotArm.eslabon5.csNextEslabon.origen[2][0];
        //Se actualizan los rangos de mapeo
        rangeMinAngle = atan2(robotArm.eslabon5.csNextEslabon.origen[1][0] - csTriangle.origen[1][0], robotArm.eslabon5.csNextEslabon.origen[0][0] - csTriangle.origen[0][0]);

        //se calcula el punto p4
        robotArm.moveRobotArm("angle", 2982, false);
        robotArm.moveRobotArm("radio", 255, false);
        robotArm.perfomFollowKinematic();//se calcula la nueva posicion del endEfector
        //Se obtienen las posiciones
        p4.x = robotArm.eslabon5.csNextEslabon.origen[0][0];
        p4.y = robotArm.eslabon5.csNextEslabon.origen[1][0];
        p4.z = robotArm.eslabon5.csNextEslabon.origen[2][0];

        robotArm.isModifyModel = false;
      }
    }
  }

  /*
  DESCRIPCION: Muestra el modelo del brazo del robot y el kinect dentro del Canvas 
   PARAMS: void
   */
  public void viewInSpace() {
    //Linea que marca el eje x
    stroke(255, 0, 0);
    line(0, 0, 0, 255, 0, 0);

    //Linea que marca el eje y
    stroke(0, 255, 0);
    line(0, 0, 0, 0, 255, 0);

    //Linea que marca el eje z
    stroke(0, 0, 255);
    line(0, 0, 0, 0, 0, 255);

    robotArm.showRobotArm();
    kinect.showCloudPoints();
    kinect.showKinect();

    //Triangulo
    CoordinateSystem ee = robotArm.eslabon5.csNextEslabon;
    CoordinateSystem sh = robotArm.eslabon2.csEslabon;

    line(sh.origen[0][0], sh.origen[1][0], sh.origen[2][0], csTriangle.origen[0][0], csTriangle.origen[1][0], csTriangle.origen[2][0]);
    line(ee.origen[0][0], ee.origen[1][0], ee.origen[2][0], csTriangle.origen[0][0], csTriangle.origen[1][0], csTriangle .origen[2][0]);
    line(sh.origen[0][0], sh.origen[1][0], sh.origen[2][0], ee.origen[0][0], ee.origen[1][0], ee.origen[2][0]);

    //Triangulo de la mano 
    csTriangle.showCS();

    //Espacio de trabajo del robot
    line(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
    line(p3.x, p3.y, p3.z, p4.x, p4.y, p4.z);
    
    
    
    PMatrix pm = getMatrix();
    

    //Dibujar obj     
    objeto1.DibujaObjeto();
    
    setMatrix(pm);
    
    for(int i = 0; i < numObstaculos; i++){
      if(obstaculo[i].isVisible) obstaculo[i].DibujaObjeto();
      setMatrix(pm);
    }
    
    setMatrix(pm);

  }

  /*
  DESCRIPCION: Recorre el color dentro de la nube de puntos sobre los ejes x,y
   PARAMS:
   x,y: recorrimiento del color sobre x,y
   */
  public void moveColor(float x, float y) {
    posColor.x = x;
    posColor.y = y;
  }

  /*
  DESCRIPCION: Recorre la nube de puntos sobre los ejes x,y del sistema de coordenadas final del modelo del kinect
   PARAMS:
   x,y: recorrimiento de la nube sobre x,y
   */
  public void setPosCloudPoints(float x, float y) {
    posCloud.x = x;
    posCloud.y = y;
  }

  /*
  DESCRIPCION: Cambia el tamaño de un link, ya sea del brazo o el kinect
   PARAMS: 
   link: link al que se desea cambiar su tamaño. Los string "l1"-"l5" y "l35", "l45" sirven para modificar los links del brazo. 
   Los strings "l1k"- l3k" se usan para modificar los links del kinect.
   
   val: valor de longitud.
   */
  public void setLengthLink(String link, float val) {
    if (link.equals("base") ) {
      lengthLinks[0] = val;
    } else {
      if (link.equals("l1") ) {
        lengthLinks[1] = val;
      } else {
        if (link.equals("l2")) {
          lengthLinks[2] = val;
        } else {
          if (link.equals("l3")) {
            lengthLinks[3] = val;
          } else {
            if (link.equals("l35")) {
              lengthLinks[4] = val;
            } else {
              if (link.equals("l4")) {
                lengthLinks[5] = val;
              } else {
                if (link.equals("l45")) {
                  lengthLinks[6] = val;
                } else {
                  if (link.equals("l5")) {
                    lengthLinks[7] = val;
                  } else {
                    if (link.equals("l1k")) {
                      lengthLinks[8] = val;
                    } else {
                      if (link.equals("l2k")) {
                        lengthLinks[9] = val;
                      } else {
                        if (link.equals("l3k")) {
                          lengthLinks[10] = val;
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  /*
  DESCRIPCION: Rota un servomotor del modelo, ya sea del brazo o el kinect
   PARAMS: 
   link: servomotor que se desea girar. Los strings "s1"-"s5" se usan para girar los servomotores del brazo. Los strings "s1k"-"s3k" se usan para girar
   los servomotores del kinect. Aplica el giro tanto en los modelos y el brazo físico.
   
   val: valor de rotacion. Las unidades de giro radianes
   */
  public void setServoTurn(String link, float val) {
    if (inputFromScaleBox) {
      if (link.equals("s1") ) {
        anglesServos[0] = val;
      } else {
        if (link.equals("s2")) {
          anglesServos[1] = val;
        } else {
          if (link.equals("s3")) {
            anglesServos[2] = val;
          } else {
            if (link.equals("s4")) {
              anglesServos[3] = val;
            } else {
              if (link.equals("s5")) {
                anglesServos[4] = val;
              } else {
                if (link.equals("s1k")) {
                  anglesServos[5] = val;
                } else {
                  if (link.equals("s3k")) {
                    anglesServos[6] = val;
                  }
                }
              }
            }
          }
        }
      }
    }
  }


  /*
  DESCRIPCION: Mueve el brazo con el algoritmo de Hernando. Se meueve como coordenadas polares.
   PARAMS: 
   type: El string "radio" se usa para mandar una coordenada de radio. EL string "angle" es usado para pasarle al brazo la coordenada de giro.
   */
  public void moveRobot(String type, int val) {
    if (inputFromScaleBox) {
      if (type.equals("radio")) {
        valRadio = val;
      }
      if (type.equals("angle")) {
        valAngle = val;
      }
    }
  }


  /*
  DESCRIPCION: retorna el tamaño de un link, ya sea del brazo o el kinect
   PARAMS: 
   link: link que se desea obtener su tamaño.  Los string "l1"-"l5" y "l35", "l45" sirven para obtener el tamaño de los links del brazo. Los strings 
   "l1k"- l3k" se usan para obtener el tamaño de los links del kinect.
   */
  public float getLengthLink(String link) {
    if (link.equals("base") ) {
      return lengthLinks[0];
    } else {
      if (link.equals("l1") ) {
        return lengthLinks[1];
      } else {
        if (link.equals("l2")) {
          return lengthLinks[2];
        } else {
          if (link.equals("l3")) {
            return lengthLinks[3];
          } else {
            if (link.equals("l35")) {
              return lengthLinks[4];
            } else {
              if (link.equals("l4")) {
                return lengthLinks[5];
              } else {
                if (link.equals("l45")) {
                  return lengthLinks[6];
                } else {
                  if (link.equals("l5")) {
                    return lengthLinks[7];
                  } else {
                    if (link.equals("l1k")) {
                      return lengthLinks[8];
                    } else {
                      if (link.equals("l2k")) {
                        return lengthLinks[9];
                      } else {
                        if (link.equals("l3k")) {
                          return lengthLinks[10];
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    return 0;
  }

  /*
  DESCRIPCION: Retorna la posición de giro ya sea de un servo del brazo o el kinect
   PARAMS: 
   link: Servo al que se le desea obtener su posición. Los strings "s1"-"s5" se usan para obtener la posición de los servomotores 
   del brazo. Los strings "s1k"-"s3k" se usan para obtener las posiciones de los servomotores del kinect.
   */
  public float getServoTurn(String link) {
    if (link.equals("s1") ) {
      return anglesServos[0];
    } else {
      if (link.equals("s2")) {
        return anglesServos[1];
      } else {
        if (link.equals("s3")) {
          return anglesServos[2];
        } else {
          if (link.equals("s4")) {
            return anglesServos[3];
          } else {
            if (link.equals("s5")) {
              return anglesServos[4];
            } else {
              if (link.equals("s1k")) {
                return anglesServos[5];
              } else {
                if (link.equals("s3k")) {
                  return anglesServos[7];
                }
              }
            }
          }
        }
      }
    }
    return 0;
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
 /*Clase para crear los objetos que sujetará el brazo*/
  class Objeto{
   public PVector Centro = new PVector();
   public int size;
   private int R;
   private int G;
   private int B;
   
   public Objeto(PVector Coord, int t, int R, int G, int B){
    this.Centro.x=Coord.x;
    this.Centro.y=Coord.y;
    this.Centro.z=Coord.z;
    this.R = R;
    this.G = G;
    this.B = B;
    this.size=t;
   }
   
   public void DibujaObjeto(){
    noStroke();
    fill(R,G,B);
    lights();
    translate(Centro.x, Centro.y, Centro.z);
    sphere (size);
   }
   
   public double DistanciaCentro(PVector Coord){
     double d;
     d=dist(Centro.x,Centro.y,Centro.z,Coord.x,Coord.y,Coord.z);
     return (d);
   }
   
   public double[] getCoordDistance(PVector Coord){
      double[] distCoord = new double[3];
      distCoord[0] = Centro.x - Coord.x;
      distCoord[1] = Centro.y - Coord.y;
      distCoord[2] = Centro.z - Coord.z;      
      return distCoord;
   } 
   
   public void cambiarCoordenadas(PVector Coord){
     this.Centro.x=Coord.x-20;
     this.Centro.y=Coord.y-20;
     this.Centro.z=Coord.z-20;
   }
 }
 
 
 /*Clase para crear los obstáculos que evitará el brazo*/
  class Obstacle{
   public PVector Centro = new PVector();
   public boolean isVisible;
   public int size;
   private int R;
   private int G;
   private int B;
   
   public Obstacle(PVector Coord, int t, int R, int G, int B){
    this.Centro.x=Coord.x;
    this.Centro.y=Coord.y;
    this.Centro.z=Coord.z;
    this.R = R;
    this.G = G;
    this.B = B;
    this.size=t;
    this.isVisible = false;
   }
   
   public void DibujaObjeto(){
    //resetMatrix();
    noStroke();
    fill(R,G,B);
    lights();
    translate(Centro.x, Centro.y, Centro.z);
    sphere (size);
   }
   
   /*public double DistanciaCentro(PVector Coord){
     double d;
     d=dist(Centro.x,Centro.y,Centro.z,Coord.x,Coord.y,Coord.z);
     return (d);
   }
   
   public double[] getCoordDistance(PVector Coord){
      double[] distCoord = new double[3];
      distCoord[0] = Centro.x - Coord.x;
      distCoord[1] = Centro.y - Coord.y;
      distCoord[2] = Centro.z - Coord.z;      
      return distCoord;
   } */
 }
 
/*
 clase que se encarga de crear al brazo robotico
 */
class RobotArm {

  //volumen del brazo
  private Cylinder[] cylinders;
  //tamaño de cada eslabon
  private float lengthE1, lengthE2, lengthE3, lengthE35, lengthE4, lengthE45, lengthE5, lengthBase;
  //indica si se debe hacer algun cambio al modelo
  private boolean changeValue;
  //Escala del modelo. Default=10 donde las medidas de lengthBase-lengthE5
  private float escala;
  //eslabones del robot
  private Eslabon eslabon1, eslabon2, eslabon3, eslabon35, eslabon4, eslabon45, eslabon5, base;
  //angulos de cada servo
  private float angleE1, angleE2, angleE3, angleE35, angleE4, angleE45, angleE5;
  //Indica si hay una modificación 
  private boolean isModifyModel;

  //Indica si se abre el puerto hacia la CM700
  public boolean isConnectCM700, isConnectOpenCM9_04;
  //Puerto de las tarjetas
  public Serial CM700, openCM9_04;
  //valor angular del servo en valor del servomotor
  public int valAngleE1, valAngleE2, valAngleE3, valAngleE4, valAngleE5;
  //valor que se envia al robot
  public float sendToRobotAngle, sendToRobotRadio;
  //Posición del modelo respecto al eje de coordenadas global
  public PVector modelPosition;
  //rotacion del modelo
  public PVector modelRotation;

  RobotArm(PApplet ca) {
    //si escala = 10 la unidad de medida es milimetros
    escala = 10;

    //eslabones
    base = new Eslabon( 0, 0);
    eslabon1 = new Eslabon( 0, 0);
    eslabon2 = new Eslabon( 0, 0);
    eslabon3 = new Eslabon( 0, PI/2);
    eslabon35 = new Eslabon( 0, 0);
    eslabon4 = new Eslabon( 0, 0);
    eslabon45 = new Eslabon( 0, 0);
    eslabon5 = new Eslabon( 0, PI/2);

    //Longitudes de los links, obtenidos midiendolos de manera individual con una cinta
    lengthBase = 25;
    lengthE1 = 17;
    lengthE2 = -5.75;
    lengthE3 = 19;
    lengthE35 = 7;
    lengthE4 = 11;
    lengthE45 = 7.5;
    lengthE5 = 19.5;

    //Angulos de cada articulacion
    angleE1 = 0;
    angleE2 = 0;
    angleE3 = 0;
    angleE35 = -PI/4;
    angleE4 = 0;
    angleE45 = -PI/4;
    angleE5 = 0;

    //posición del modelo
    modelPosition = new PVector(lengthBase, 0, 0);
    modelRotation = new PVector(0, 0, 0);

    // se inicializa el puerto serial con la tarjeta CM700
    if (Serial.list().length > 0) {
      printArray(Serial.list()); //Imprime la lista de todos los puertos que están conectados
      /*
      DESCOMENTAR LA DOS LINEAS DE ABAJO Y DENTRO DE LA POSICION DEL ARRAY INDICAR EL PUERTO SERIAL CORRESPONDIENTE DEL BRAZO Y LA MANO ROBOTICA
      */
      //CM700 = new Serial(ca, Serial.list()[0], 57600); //Controlador del brazo
      //openCM9_04 = new Serial(ca, Serial.list()[1], 9600);  //Controlador de la mano
    } 
    //Se comprueba la conexión
    if (CM700 == null) isConnectCM700 = false;
    else isConnectCM700 = true; 
    if (openCM9_04 == null) isConnectOpenCM9_04 = false;
    else isConnectOpenCM9_04 = true; 

    //volumen del brazo
    int sides = 20;
    int margin = 5;
    float radio = 2.7056*escala;
    cylinders = new Cylinder[7];
    cylinders[0] = new Cylinder(radio, margin, lengthE1*escala-2*margin, sides, "x");
    cylinders[1] = new Cylinder(radio, margin, lengthE2*escala-2*margin, sides, "z");
    cylinders[2] = new Cylinder(radio, margin, lengthE3*escala-margin, sides, "x");
    cylinders[3] = new Cylinder(radio, 0, lengthE35*escala-margin, sides, "x");
    cylinders[4] = new Cylinder(radio, margin, lengthE4*escala-margin, sides, "x");
    cylinders[5] = new Cylinder(radio, 0, lengthE45*escala-margin, sides, "x");
    cylinders[6] = new Cylinder(radio, margin, lengthE5*escala-margin, sides, "z");
  }
  /*
  DESCRIPCION: Manda una señal a la mano pediatrica con la tarjeta openCM9.04 para que cierra la mano.
   PARAMS: void
   */
  public void closeHand() {
    if (isConnectOpenCM9_04) {
      openCM9_04.write("A");
    }
  }

  /*
  DESCRIPCION: Manda una señal a la mano pediatrica con la tarjeta openCM9.04 para que abra la mano.
   PARAMS: void
   */
  public void openHand() {
    if (isConnectOpenCM9_04) {
      openCM9_04.write("B");
    }
  }

  /*
  DESCRIPCION: Cambia de posición al modelo del brazo dentro del sistema de coordenadas global.
   PARAMS:
   x,y,z: Nueva posición del modelo del brazo
   */
  public void setPosRobot(float x, float y, float z) {
    if (modelPosition.x != x || modelPosition.y != y || modelPosition.z != z) {
      modelPosition.x = x;
      modelPosition.y = y;
      modelPosition.z = z;
      changeValue = true;
      isModifyModel = true;
    }
  }

  /*
  DESCRIPCION: Rota el modelo del brazo sobre los ejes del sistema de coordenadas global.
   PARAMS:
   rx,ry,rz: Nueva orientación del modelo del brazo
   */
  public void setRotRobot(float rx, float ry, float rz) {
    if (modelRotation.x != rx || modelRotation.y != ry || modelRotation.z != rz) {
      modelRotation.x = rx;
      modelRotation.y = ry;
      modelRotation.z = rz;
      changeValue = true;
      isModifyModel = true;
    }
  }

  /*
  DESCRIPCION: Cambia la escala de tamaño del robot. Cuando está a 1 los valores son dados en centímetros.
   PARAMS: 
   esc: Nueva escala del modelo del brazo.
   */
  public void setEscala(float esc) {
    if (escala != esc) {
      escala = esc;
      changeValue = true;
      isModifyModel = true;
    }
  }

  /*
  DESCRIPCION: Convierte un valor dado en grados a su respectivo valor para el servomotor
   PARAMS: 
   servo: El String "MX-106" convierte el ángulo a un valor para un servomotor Dynamixel MX-106. El String "RX-28" convierte el 
   ángulo a un valor para un servomotor Dynamixel RX-28.
   */
  private float valRobotToAngle(String servo, int val) {
    if (servo.equals("MX-106")) {
      float aux = (val*360)/4095;
      aux -= 180;
      return -1*radians(aux);
    }

    if (servo.equals("RX-28)")) {
      float aux = (val*300)/1023;
      aux -= 150;
      return -1*radians(aux);
    }
    return 0;
  }

  /*
  DESCRIPCION: Cambia el tamaño de los links del modelo del brazo.
   PARAMS:
   l1: Nueva longitud del link 1
   l2: Nueva longitud del link 2
   l3: Nueva longitud del link 3
   l35: Nueva longitud del link 35
   l4: Nueva longitud del link 4
   l45: Nueva longitud del link 45
   l5: Nueva longitud del link 5
   */
  public void setLengthLink(float b, float l1, float l2, float l3, float l35, float l4, float l45, float l5) {
    if (lengthBase != b) {
      lengthBase = b;
      changeValue = true;
      isModifyModel = true;
    }
    if (lengthE1 != l1) {
      lengthE1 = l1;
      changeValue = true;
      isModifyModel = true;
    }
    if (-1*lengthE2 != l2) {
      lengthE2 = -1*l2;
      changeValue = true;
      isModifyModel = true;
    }
    if (lengthE3 != l3 ) {
      lengthE3 = l3;
      changeValue = true;
      isModifyModel = true;
    }
    if (lengthE35 != l35) {
      lengthE35 = l35;
      changeValue = true;
      isModifyModel = true;
    }
    if (lengthE4 != l4 ) {
      lengthE4 = l4;
      changeValue = true;
      isModifyModel = true;
    }
    if (lengthE45 != l45) {
      lengthE45 = l45;
      changeValue = true;
      isModifyModel = true;
    }
    if (lengthE5 != l5) {
      lengthE5 = l5;
      changeValue = true;
      isModifyModel = true;
    }
  }

  /*
  DESCRIPCION: Devuelve el tamaño de un link del robot
   PARAMS:
   link: link que se desea obtener su tamaño.  Los string "l1"-"l5" y "l35", "l45" sirven para obtener el tamaño de los links del brazo. Los strings 
   "l1k"- l3k" se usan para obtener el tamaño de los links del kinect.
   */
  public float getLengthLink(String link) {
    if (link.equals("base") ) {
      return lengthBase;
    } else {
      if (link.equals("l1") ) {
        return lengthE1;
      } else {
        if (link.equals("l2")) {
          return lengthE2*-1;
        } else {
          if (link.equals("l3")) {
            return lengthE3;
          } else {
            if (link.equals("l35")) {
              return lengthE35;
            } else {
              if (link.equals("l4")) {
                return lengthE4;
              } else {
                if (link.equals("l45")) {
                  return lengthE45;
                } else {
                  if (link.equals("l5")) {
                    return lengthE5;
                  }
                }
              }
            }
          }
        }
      }
    }
    return 0;
  }

  /*
  DESCRIPCION: Rota un servomotor del modelo y el brazo físico.
   PARAMS:
   s: Servo que se desea girar. Los strings "s1"-"s5" se usan para girar los servomotores del brazo. 
   Los strings "s1k"-"s3k" se usan para girar los servomotores del kinect.
   
   angle: Ángulo a rotar el servo s. Unidad de medida: radianes
   */
  public void rotateServo(String s, float angle) {
    //componer funcion en el ultimo servo y los valores del robot y los valores enviados

    //mapeo de radianes al valor de servomotor 
    int val = (int)map(angle, PI, -PI, 0, 4095);

    if (s.equals("s1") && angle != angleE1) {
      angleE1 = angle;
      //se envia el valor al robot
      envia(val, 1);
      changeValue = true;
    }

    if (s.equals("s2") && angle != angleE2) {
      angleE2 = angle;
      //se envia el valor al robot
      envia(val, 2);
      changeValue = true;
    }

    if (s.equals("s3") && angle != angleE3) {
      angleE3 = angle;
      //se envia el valor al robot
      envia(val, 3);
      changeValue = true;
    }

    if (s.equals("s4") && angle != angleE4) {
      angleE4 = angle;
      //se envia el valor al robot
      envia(val, 4);
      changeValue = true;
    }

    if (s.equals("s5") && angle != angleE5) {
      angleE5 = angle;
      val = (int)map(angle, -1*radians(150), radians(150), 0, 1023);
      //val+=20479;
      //se envia el valor al robot
      envia(val, 5);
      changeValue = true;
    }
  }

  /*
  DESCRIPCION: cambia los ángulos de los servomotores del modelo y envia los valore al robot para realizar el movimiento 
   radial o angular según el algoritmo de Hernando.
   PARAMS: 
   s: tipo de movimiento "radio" o "angle" o "300". EL string "300" se usa para cambiar de posición el objeto tomado por el brazo robótico.
   val: valor a ser enviado al robot. Dicho valor se utiliza para calcular los ángulos de las articulaciones del modelo
   */
  public void moveRobotArm(String s, int val, boolean envia) {

    //envio de datos al servo
    if (s.equals("radio")) {
      //Se calcula su movimiento
      float radioFinal2 = (val*2)+(val/2);
      radioFinal2 += 1879;

      float radioFinal3 = (val*2)+(val/2);
      if (val >= 190 && val <= 255) radioFinal3+=1710;
      if (val < 190 && val >= 0) radioFinal3 += 1760;

      //Se pasa su nueva posición a los servos del modelo
      angleE3 = valRobotToAngle("MX-106", int(radioFinal2));
      angleE4 = valRobotToAngle("MX-106", int(radioFinal3));

      //valor que se envia al robot
      sendToRobotRadio = val;
      val+=20480;
      if (envia)envia(val);

      //Se indica que hay cambios y debe realizarse los calculos de la cinematica de seguimiento
      changeValue = true;
    }

    if (s.equals("angle")) {
      angleE2 = valRobotToAngle("MX-106", val);
      //valor que se envia al robot
      sendToRobotAngle = val;
      val+=20480;
      if (envia)envia(val);

      //Se indica que hay cambios y debe realizarse los calculos de la cinematica de seguimiento
      changeValue = true;
    }

    if (s.equals("300")) {
      //valor que se envia al robot
      sendToRobotAngle = val;
      sendToRobotRadio = val;
      val+=20480;
      if (envia)envia(val);

      //Se indica que hay cambios y debe realizarse los calculos de la cinematica de seguimiento
      changeValue = true;
    }
  }

  /*
   DESCRIPCION: función que realiza la cinemática de seguimiento del modelo del robot. Crea el modelo y en caso de que se presente un cambio lo actualiza.
   PARAMS: void
   */
  public void perfomFollowKinematic() {
    if (changeValue) {
      changeValue = false;
      //Se mueve y gira el modelo del brazo en base al sistema de coordenadas globales
      base.moveLink(modelPosition.x*escala, modelPosition.y*escala, modelPosition.z*escala, modelRotation.x, modelRotation.y, modelRotation.z);

      //se giran los eslabones o cambian de tamaño de manera individual
      eslabon1.performTransformation(  angleE1, 0, lengthE1*escala, 0);
      eslabon2.performTransformation(  angleE2, lengthE2*escala, 0, 0);
      eslabon3.performTransformation(  angleE3, 0, lengthE3*escala, PI);
      eslabon35.performTransformation( angleE35, 0, lengthE35*escala, 0);
      eslabon4.performTransformation(  angleE4, 0, lengthE4*escala, 0);
      eslabon45.performTransformation( angleE45, 0, lengthE45*escala, 0);
      eslabon5.performTransformation(  angleE5, lengthE5*escala, 0, 0);
      base.enlazarInit();
      eslabon1.enlazar(base.HMNextEslabon);
      eslabon2.enlazar(eslabon1.HMNextEslabon);
      eslabon3.enlazar(eslabon2.HMNextEslabon);
      eslabon35.enlazar(eslabon3.HMNextEslabon);
      eslabon4.enlazar(eslabon35.HMNextEslabon);
      eslabon45.enlazar(eslabon4.HMNextEslabon);
      eslabon5.enlazar(eslabon45.HMNextEslabon);

      //se agrega el volumen
      cylinders[0].setPos(lengthE1*escala);
      cylinders[1].setPos(lengthE2*escala);
      cylinders[2].setPos(lengthE3*escala);
      cylinders[3].setPos(lengthE35*escala);
      cylinders[4].setPos(lengthE4*escala);
      cylinders[5].setPos(lengthE45*escala);
      cylinders[6].setPos(lengthE5*escala);

      //Se enlazan los cilindros a través de la matriz adjunta al inicio de cada eslabon 
      cylinders[0].addMatrixsHomo(eslabon1.HMEslabon);
      cylinders[1].addMatrixsHomo(eslabon2.HMEslabon);
      cylinders[2].addMatrixsHomo(eslabon3.HMEslabon);
      cylinders[3].addMatrixsHomo(eslabon35.HMEslabon);
      cylinders[4].addMatrixsHomo(eslabon4.HMEslabon);
      cylinders[5].addMatrixsHomo(eslabon45.HMEslabon);
      cylinders[6].addMatrixsHomo(eslabon5.HMEslabon);
    }
  }

  /*
  DESCRIPCION: muestra el modelo del robot dentro del Canvas.
   PARAMS: void
   */
  private void showRobotArm() {
    //se muestra el link base
    base.showEslabon();
    //se muestran los sistemas de coordenadas de cada eslabon
    eslabon1.showCoordinateSystem();
    eslabon2.showCoordinateSystem();
    eslabon3.showCoordinateSystem();
    eslabon35.showCoordinateSystem("35");
    eslabon4.showCoordinateSystem();
    eslabon45.showCoordinateSystem("45");
    eslabon5.showCoordinateSystem();
    //Se muestra el sistema de coordenadas del EndEfector
    eslabon5.showAttachedCoordinateSystem();
    //Se muestra el volumen del brazo
    for (int i = 0; i < 7; i++) {   
      cylinders[i].showCylinder();
    }
  }

  /*
  DESCRIPCIÓN: Se encarga de recibir a través del puerto serial los valores enviados por cada servomotor y lo convierte en un valor dado en radianes. Además 
   manda una señal para actualizar el modelo del robot.
   PARAMS: void
   */
  public void receiveAnglesFromRobot() {
    //se reciben los datos angulares del robot
    int rcvData = ReceiveData();

    if (rcvData != -1) {

      if (rcvData >= 0 && rcvData <= 4095) {
        valAngleE1 = rcvData;
        angleE1 = valRobotToAngle("MX-106", rcvData);
        changeValue = true;
      }
      if (rcvData >= 4096 && rcvData <= 8191) {
        valAngleE2 = rcvData - 4095;
        angleE2 = valRobotToAngle("MX-106", valAngleE2);
        changeValue = true;
      }
      if (rcvData >= 8192 && rcvData <= 12287) {
        valAngleE3 = rcvData - 8191;
        angleE3 = valRobotToAngle("MX-106", valAngleE3);
        changeValue = true;
      }
      if (rcvData >= 12288 && rcvData <= 16383) {
        valAngleE4 = rcvData - 12287;
        angleE4 = valRobotToAngle("MX-106", valAngleE4);
        changeValue = true;
      }
      if (rcvData >= 16384 && rcvData <= 20479) {
        valAngleE5 = rcvData - 16383;
        angleE5 = valRobotToAngle("RX-28", valAngleE5);
        changeValue = true;
      }
    }
  }

  /* 
   DESCRIPCION: Función para enviar un valor a un servomotor en espacifico. El controlador del brazo es una tarjeta CM700 
   PARAMS: 
   dato: Valor a enviar al servo.
   idServo: Número de servo al cual va dirigido el valor.
   */
  private int envia(int dato, int idServo) {
    if (isConnectCM700) {
      if (idServo == 1) {
        dato = (int)Functions.constrain2(dato, 0, 4095);
      }
      if (idServo == 2) {
        dato+=4096;
        dato = (int)Functions.constrain2(dato, 4096, 8191);
      }
      if (idServo == 3) {
        dato+=8192;
        dato = (int)Functions.constrain2(dato, 8192, 12287);
      }
      if (idServo == 4) {
        dato+=12288;
        dato = (int)Functions.constrain2(dato, 12288, 16383);
      }

      if (idServo == 5) {
        dato+=16384;
        dato = (int)Functions.constrain2(dato, 16384, 20479);
      }

      int high = dato >> 8;  
      int low = dato & 255;  
      CM700.write(0xFF); 
      delay(1);
      CM700.write(0x55);
      delay(1);
      CM700.write(low); 
      delay(1);
      CM700.write(255 - low);
      delay(1);
      CM700.write(high);
      delay(1);
      CM700.write(255 - high);    
      return 1;
    }
    return 0;
  }

  /* 
   DESCRIPCION: Función para enviar un dato al controlador del brazo con tarjeta CM700
   PARAMS: 
   dato: Valor a enviar.
   */
  private int envia(int dato) {
    if (isConnectCM700) {
      int high = dato >> 8;  
      int low = dato & 255;  
      CM700.write(0xFF); 
      delay(1);
      CM700.write(0x55);
      delay(1);
      CM700.write(low); 
      delay(1);
      CM700.write(255 - low);
      delay(1);
      CM700.write(high);
      delay(1);
      CM700.write(255 - high);
    }
    return 1;
  }

  /*
  DESCRIPCION: Función para recibir información del contolador CM700
   PARAMS: void
   */
  private int ReceiveData() {
    String valS="-1";
    if (isConnectCM700) {
      if (CM700.available() > 0) {
        int  d1, d2, d3, d4, d5, d6;
        d1 = CM700.read();
        delay(1);
        d2 = CM700.read();
        delay(1);
        d3 = CM700.read();
        delay(1);
        d4 = CM700.read();
        delay(1);
        d5 = CM700.read();
        delay(1);
        d6 = CM700.read();

        String low = Integer.toBinaryString(d3);
        String high = Integer.toBinaryString(d5);
        if (low.length() < 8) {
          int aux = 8-low.length();
          String zero = "";
          for (int i = 0; i < aux; i++)zero +="0";
          low = zero+low;
        }
        valS = high+low;
      }
    }

    try {
      return Integer.parseInt(valS, 2);
    }
    catch(NumberFormatException p) {
      return -1;
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


class Eslabon {

  /*
    DESCRIPCIÓN: Clase usada para crear los eslabones (links) del brazo robótico. 
   NOTAS:
   
   1. Los eslabones constan de dos partes: el inicio y el final. EL punto (0,0,0) es el início del eslabon. La orientación del eslabon depende de las 
   matrices HMD, HMMA sobre los ejes Z,X repectivamente. La posición del sistema de coordenadas adjunto al final del eslabon está determinada por las 
   matrices HMA, Ry, HMD sobre los ejes X,Y,Z respectivamente. Cuando un eslabón i se enlaza con otro eslabón i-1, el sistemas de coordenadas adjunto 
   en el inicio del eslabón i son transladados a la posición final del eslabón i-1. La orientación del eslabón i ya no será en base al sistema de coordenadas global
   si no del sistema de coordenadas adjunto al final del eslabón i-1.
   
   2. Se usaron los parámetros de Denavid Hartenberg para crear los modelos del robot y el kinect. Los parámetros son theta,D,A,Alpha y 
   se deben multiplicar Ry*theta*D*A*Alpha para formar un eslabón. El eje Z es el eje de giro del servomotor. Theta es la rotación sobre el eje Z, 
   D la translación sobre Z, A la transación sobre el eje X, Alpha la translación sobre el eje X y Ry la orientación sobre el eje Y.
   
   3. Con la matriz "HMEslabon" se ubica el sistema de coordenadas adjunto al inicio del eslabón. Cuando un eslabón se enlaza con otro, su posición y
   orientación ya no es la misma y para ubicar un punto respecto al sistema de coordenadas adjunto al inicio del eslabón se debe multiplicar por ésta matriz
   para calcular su nueva ubicación.
   
   4. La matriz "HMNextEslabon" es análoga a la descrita en el punto 3 pero ésta es usada para localizar el sistema de coordenadas adjunto al final del eslabón.
   
   5. Tomando de manera de ejemplo para mostrar como usar las matrices "HMEslabon" y "HMNextEslabon", supongamos que un punto P es un tornillo de un eslabón x.
   Cuando un eslabón aun no está enlazado con otro, el sistema de coordenadas adjunto al inicio del eslabón es el sistema de coordenadas global. La ubicación 
   del punto P debe ser en base al sistema de coordenadas global. Si se enlaza el eslabón x con otro, para calcular la nueva posición del punto P se usa la matriz
   "HMEslabon": P'=P*HMEslabon 
   */

  //matrices de rotacion y translacion sobre z
  private float[][] HMTheta;
  private float[][] HMD;
  //matrices de rotacion y translacion sbre x
  private float[][] HMAlpha;
  private float[][] HMA;

  //matriz que rota el eslabón sobre y
  private float[][] Ry;
  //matriz que rota el eslabón sobre y,z
  private float[][] Ry_HMTheta;
  //matriz que translada sobre z,x y rota sobre x
  private float[][] D_A_Alpha;
  //matriz que translada sobre z,x
  private float[][] HMD_A;
  //indica si hay cambios en el modelo del eslabon
  private boolean changeValue;
  //Variable auxiliar
  private CoordinateSystem csAux;

  //sistemas de coordenadas adjunto al final del eslabón
  public CoordinateSystem csNextEslabon;
  //Sistema de coordenadas adjunto al inicio del eslabón
  public CoordinateSystem csEslabon;
  //Rotación y translación del eslabón.
  public PVector rotation;
  public PVector translation;
  //matriz usada para calcular la posición del sistema de coordenadas adjunto al final del eslabón
  public float[][] HMNextEslabon;
  //matriz usada para calcular la posición del sistema de coordenadas adjunto al inicio del eslabón
  public float[][] HMEslabon;

  /*
  CONSTRUCTOR
   PARAMS:
   y: Posición en el eje Y del extremo del eslabon (donde termina).
   ry: Orientación sobre el eje Y del eslabón.
   */
  Eslabon( float y, float ry) {
    rotation = new PVector();
    translation = new PVector();
    rotation.y = ry;
    translation.y = y;
    changeValue = true;

    //matriz que determina la posición del sistema de coordenadas del eslabon
    HMEslabon = new float[4][4];
    //matriz que determina la posición del sistema de coordenadas del siguiente eslabon
    HMNextEslabon = new float[4][4];

    //matrices de rotacion y translacion sobre z
    HMTheta = new float[4][4];
    HMD = new float[4][4];
    //matrices de rotacion y translacion sobre x
    HMA = new float[4][4];
    HMAlpha = new float[4][4];

    //matriz de rotacion sobre y
    Ry = new float[4][4];
    //matriz de translacion sobre x,z
    HMD_A = new float[4][4];
    //matriz de rotacion sobre y,z
    Ry_HMTheta = new float[4][4];
    //matriz de translacion sobre x,z y rotacion sobre x
    D_A_Alpha = new float[4][4];

    //sistema de coordenadas
    csEslabon = new CoordinateSystem();
    csNextEslabon = new CoordinateSystem();
    csAux = new CoordinateSystem();

    //se inicializa la matriz de rotacion sobre y
    setY(y, ry);
  }

  /*
  DESCRIPCION: Enlaza el eslabon a otro. Está función es usada para crear los modelos enlazando varios eslabones y así construir una cadena cinemática
   PARAMS: 
   link: Matriz de transformacion homogenea de la punta del eslabón (variale csNextEslabon)
   */
  public void enlazar(float[][] link) {

    //se obtiene la matriz de transformación del inicio del eslabon
    MatrixOperations.multiplyMatrices(link, Ry_HMTheta, HMEslabon);

    //se posiciona el sistema de coordenadas del eslabon en su posicion correspondiente
    csAux.reset();
    MatrixOperations.multiplyMatrices(HMEslabon, csAux.X, csEslabon.X);
    MatrixOperations.multiplyMatrices(HMEslabon, csAux.Y, csEslabon.Y);
    MatrixOperations.multiplyMatrices(HMEslabon, csAux.Z, csEslabon.Z);
    MatrixOperations.multiplyMatrices(HMEslabon, csAux.origen, csEslabon.origen);

    //Se calcula la matriz de transformacion homogenea para el extremo del eslabon
    MatrixOperations.multiplyMatrices(HMEslabon, D_A_Alpha, HMNextEslabon);

    csAux.reset();
    MatrixOperations.multiplyMatrices(HMNextEslabon, csAux.X, csNextEslabon.X);
    MatrixOperations.multiplyMatrices(HMNextEslabon, csAux.Y, csNextEslabon.Y);
    MatrixOperations.multiplyMatrices(HMNextEslabon, csAux.Z, csNextEslabon.Z);
    MatrixOperations.multiplyMatrices(HMNextEslabon, csAux.origen, csNextEslabon.origen);
  }

  /*
  DESCRIPCIÓN: Función que debe ser llamada cuando el eslabon es la base de la cadena cinemática (primer link)
   PARAMS:
   */
  public void enlazarInit() {
    MatrixOperations.multiplyMatrices(Ry_HMTheta, D_A_Alpha, HMNextEslabon);
  }

  /*
  DESCRIPCIÓN: Muestra el eslabón dentro del Canvas. El eslabón es formado por una línea desde el origen del sistema de coordenadas adjunto al inicio, hasta 
   el origen del sistema de coordenadas adjunto al final del eslabón.
   PARAMS: void
   */
  public void showEslabon() {
    csAux.reset();
    //se obtiene le punto de origen del siguiente sistema de coordenadas
    MatrixOperations.multiplyMatrices(HMNextEslabon, csAux.origen, csNextEslabon.origen);

    stroke(0);
    line( csEslabon.origen[0][0], csEslabon.origen[1][0], csEslabon.origen[2][0], csNextEslabon.origen[0][0], csNextEslabon.origen[1][0], csNextEslabon.origen[2][0]);
  }

  /*
  DESCRIPCIÓN: Muestra el sistema de coordenadas adjunto al inicio del eslabón dentro del Canvas.
   PARAMS: void
   */
  public void showCoordinateSystem() {
    csEslabon.showCS();
  }

  /*
  DESCRIPCIÓN:  Muestra el sistema de coordenadas adjunto al inicio de eslabón dentro del Canvas, con un texto.
   PARAMS:
   txt: Texto a mostrar cerca del inicio del eslabón.
   */
  public void showCoordinateSystem(String txt) {
    text(txt, csEslabon.origen[0][0]-5, csEslabon.origen[1][0]-5, csEslabon.origen[2][0]-5);
    csEslabon.showCS();
  }

  /*
  DESCRIPCIÓN: Muestra el sistema de coordenadas adjunto al final del eslabón.
   PARAMS: void
   */
  public void showAttachedCoordinateSystem() {
    csNextEslabon.showCS();
  }

  /*
  DESCRIPCIÓN:  Mueve y rota un eslabón sobre el sistema de coordenadas del cual se encuentre enlazado, si no esta enlazado se hará en base al sistam de coordenadas
   global. Este función se usó para mover y rotar el modelo del brazo.
   PARAMS:
   x,y,z: Nueva posición del eslabón. 
   rx,ry,rz: Nueva orientación del eslabón.
   */
  public void moveLink(float x, float y, float z, float rx, float ry, float rz) {
    if (translation.x != x || translation.y != y || translation.z != z || rotation.x != rx || rotation.y != ry || rotation.z != rz) {
      setTranslation("x", x);
      setRotation("x", rx);
      setY(y, ry);
      setTranslation("z", z);
      setRotation("z", rz);

      MatrixOperations.multiplyMatrices(Ry, HMTheta, Ry_HMTheta);
      MatrixOperations.multiplyMatrices(HMD, HMA, HMD_A);
      MatrixOperations.multiplyMatrices(HMD_A, HMAlpha, D_A_Alpha);
    }
  }

  /*
  DESCRIPCIÓN: Parámetros de Denavid Hartenberg. A través de estos parámetros se define la posoción y rotación del eslabón sobre los ejes X,Z
   PARAMS:
   theta: Rotación del modelo sobre el eje Z. La unidad de medida son radianes
   d: Posición del final del eslabon sobre el eje Z.
   a: Posición final del eslabon sobre el eje X.
   alpha: Rotación del modelo sobre el eje X. La unidad de medida son radianes
   */
  public void performTransformation(float theta, float d, float a, float alpha) {
    if (rotation.z != theta || translation.z != d || translation.x != a || rotation.x != alpha) {
      //Se inicializan las matrices de transformación homogénea
      setRotation("z", theta);
      setTranslation("z", d);
      setTranslation("x", a);
      setRotation("x", alpha);

      MatrixOperations.multiplyMatrices(Ry, HMTheta, Ry_HMTheta);

      MatrixOperations.multiplyMatrices(HMD, HMA, HMD_A);
      MatrixOperations.multiplyMatrices(HMD_A, HMAlpha, D_A_Alpha);
    }
  }

  /*
  DESCRIPCION: Inicializa la matriz de rotación del eslabón para los ejes X o Z 
   PARAMS:
   axis: Los String "x" o "z" indican sobre cual eje se desea rotar el eslabón.
   angle: Cuantos grados se girará el eslabón sobre el eje X o Z
   */
  private void setRotation(String axis, float angle) {
    //Alpha
    if (axis.equals("x")) {
      this.rotation.x = angle;
      HMAlpha[0][0] = 1;
      HMAlpha[0][1] = 0;
      HMAlpha[0][2] = 0;
      HMAlpha[0][3] = 0;

      HMAlpha[1][0] = 0;
      HMAlpha[1][1] = cos(rotation.x);
      HMAlpha[1][2] = -sin(rotation.x);
      HMAlpha[1][3] = 0;

      HMAlpha[2][0] = 0;
      HMAlpha[2][1] = sin(rotation.x);
      HMAlpha[2][2] = cos(rotation.x);
      HMAlpha[2][3] = 0;

      HMAlpha[3][0] = 0;
      HMAlpha[3][1] = 0;
      HMAlpha[3][2] = 0;
      HMAlpha[3][3] = 1;
    }
    //Theta
    if (axis.equals("z")) {
      this.rotation.z = angle;

      HMTheta[0][0] = cos(rotation.z);
      HMTheta[0][1] = -sin(rotation.z);
      HMTheta[0][2] = 0;
      HMTheta[0][3] = 0;

      HMTheta[1][0] = sin(rotation.z);
      HMTheta[1][1] = cos(rotation.z);
      HMTheta[1][2] = 0;
      HMTheta[1][3] = 0;

      HMTheta[2][0] = 0;
      HMTheta[2][1] = 0;
      HMTheta[2][2] = 1;
      HMTheta[2][3] = 0;

      HMTheta[3][0] = 0;
      HMTheta[3][1] = 0;
      HMTheta[3][2] = 0;
      HMTheta[3][3] = 1;
    }
  }

  /*
  DESCRIPCION: Inicializa la matriz de translación sobre los ejes X,Z del final del eslabón.
   PARAMS:
   axis: Los Strings "x" o "z" indican sobre cual eje se desea realizar la translación.
   pos: Posición final del sistema de coordenadas adjunto al final del eslabón sobre el eje X o Z
   */
  private void setTranslation(String axis, float pos) {
    //A
    if (axis.equals("x")) {
      translation.x = pos;
      HMA[0][0] = 1;
      HMA[1][1] = 1;
      HMA[2][2] = 1;
      HMA[3][3] = 1;

      HMA[0][3] = translation.x;
    }

    //D
    if (axis.equals("z")) {
      translation.z = pos;
      HMD[0][0] = 1;
      HMD[1][1] = 1;
      HMD[2][2] = 1;
      HMD[3][3] = 1;

      HMD[2][3] = translation.z;
    }
  }

  /*
  DESCRIPCIÓN: Inicializa la matriz de rotación y translación sobre el eje Y.
   PARAMS:
   y: Translación sobre el eje Y
   ry: Rotación a lo largo del eje Y
   */
  public void setY(float y, float ry) {
    translation.y = y;
    rotation.y = ry;

    Ry[0][0] = cos(rotation.y);
    Ry[0][1] = 0;
    Ry[0][2] = sin(rotation.y);
    Ry[0][3] = 0;

    Ry[1][0] = 0;
    Ry[1][1] = 1;
    Ry[1][2] = 0;
    Ry[1][3] = y;

    Ry[2][0] = -sin(rotation.y);
    Ry[2][1] = 0;
    Ry[2][2] = cos(rotation.y);
    Ry[2][3] = 0;

    Ry[3][0] = 0;
    Ry[3][1] = 0;
    Ry[3][2] = 0;
    Ry[3][3] = 1;

    HMD[2][3] = translation.z;
  }
}
