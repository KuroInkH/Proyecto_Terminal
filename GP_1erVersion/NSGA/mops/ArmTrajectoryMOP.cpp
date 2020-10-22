/*
 * ArmTrajectoryMOP.cpp
 *
 *  Created on: Sep 30, 2019
 *      Author: antonio
 */

#include "ArmTrajectoryMOP.h"
#include <iostream>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <cstring>
#include <string>
#include <sstream>
#include <unistd.h>
#include <math.h>

using namespace std;

ArmTrajectoryMOP::ArmTrajectoryMOP(int numWeight) : MOP("ArmTrajectoryMOP", numWeight, 2, 1)
{
   vector< pair<double,double> > ranges(numWeight, make_pair(1,-1));
   setVarsRange(ranges);

   char ip[] = "127.0.0.1"; // The JAVA server is local.
   puerto = 7778;           // Port number.

   // Crear el descriptor de archivo del socket
   sockfd = socket(AF_INET, SOCK_STREAM, 0);
   if (sockfd < 0)
      cerr << "Error, no se pudo crear el socket.\n";
   else
      cerr << "Socket creado.\n";

   // Encontrar el host con la IP dada.
   server = gethostbyname(ip);
   if (server == NULL) {
      fprintf(stderr,"ERROR, no existe el host.\n");
      exit(0);
   }

   // Inicializar la estructura serv_addr.
   memset(&serv_addr, sizeof (serv_addr), 0);

   // Poner la configuración del socket al que nos vamos a conectar.
   serv_addr.sin_family = AF_INET;
   bcopy((char *)server->h_addr, (char *)&serv_addr.sin_addr.s_addr, server->h_length);
   serv_addr.sin_port = htons(puerto);

   // Conectarse al socket dado.
   if (connect(sockfd,(struct sockaddr *)&serv_addr,sizeof(serv_addr)) < 0)
      cerr << "ERROR al conectarse al socket.\n";
   else
      cerr << "Ya se conectó al socket\n";
}

ArmTrajectoryMOP::~ArmTrajectoryMOP() {
   // TODO Auto-generated destructor stub
}

void ArmTrajectoryMOP::evaluate(const vector<double>& x, const vector<int>& gene, vector<double>& fx, vector<double>& gcons) const
{
      //1. Empaquetar los valores de las variables para pedir la evaluación de la solución.
      string str = "";
      for (double val : x)
         str += " " + to_string(val);
      str += "\n";

      //Quitar luego
     // str = "0 0 0.5 -0.5\n";

      // convert from string to c string, has to have \0 terminal
      char *wbuff = (char *)str.c_str();

      cerr << "\nMandando ángulos al simulador...";
      int wbytes = write(sockfd, wbuff, strlen(wbuff));
      if(wbytes < 0)
         cerr << "No se pudo escribir al socket.\n";
      //else
      //   cerr << "Se mandó la petición al servidor.\n";

      //2. Esperar la evaluación de la solución por el socket...

      //3. Leer la respuesta del servidor en JAVA.
      char strValues[512]; // This array will have the objective values separated by spaces: "4.5   6.7   9.3"
      int rbytes;
      rbytes = read(sockfd, strValues, sizeof(strValues)); // read from socket and store the msg into buffer
      //rbytes = recv(sockfd, rbuff, sizeof(rbuff), 0); // similar to read(), but return -1 if socket closed
      strValues[rbytes] = '\0'; // set null terminal


      //4. Split the string and copy to the vector fx (parameter above)
      string values = strValues;
      stringstream ss(values);

      double temp;
      unsigned int i = 0;
      while ((ss >> temp) && i < fx.size()) { // Cuidar que no se pase si hay más elementos en la cadena.
          fx[i] = temp;
          //DEBERÍAN LLEGAR EN EL SIGUIENTE ORDEN
          //>obj1 sum áng
          //>obj2 riesgo de colisión
          //>Restricción distancia
          if (i == 0) {
        	  cout << "--> suma de ángulos= " << fx[i] << "; ";
          }
          else{
            cout << "--> riesgo de colisión= " << fx[i] << "; ";
          }
          i++;
      }

      ss >> temp;
      gcons[0] = temp * (-1);
      cout << "\trestr. (dist)= " << gcons[0] << endl;
}