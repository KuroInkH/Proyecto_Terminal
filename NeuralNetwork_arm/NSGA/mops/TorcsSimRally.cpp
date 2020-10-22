#include "TorcsSimRally.h"

#include <unistd.h>
#include <sys/wait.h>
#include <cstdlib>
#include <cstdio>
#include <cmath>
#include <string>
#include <iostream>
#include <sstream>
#include <fstream>
#include <utility>
#include <iomanip>

using namespace std;

/*********************************************************************
* Constructor of the TORCS Multi-Objective Problem.
* nProcs: Number of processes to run a TORCS server in each one. This way, a set of individuals (a rally) might be
*         evaluated in parallel.
*********************************************************************/

TorcsSimRally::TorcsSimRally(int nProcs, int rallySize, int numObjs, int numCons, int nInputs, int nOutputs, int nHidden)
	: MOP("TORCSimRallyHidden", nInputs*nHidden + nHidden*nOutputs, numObjs, numCons)
{
   cerr << "\nInside of TorcsRally the number of variables is " << nVariables << endl;
   this->nProcs = nProcs;
   this->rallySize = rallySize;
   this->numInputsNN = nInputs;
   this->numOutputsNN = nOutputs;
   this->numHidden = nHidden;

   if (nHidden == 0)
      this->nVariables = nInputs*nOutputs;

   /*
   // Override parent MOP class attributes values
   this->name.assign("TorcsSimRallyHidden");
   this->nVariables = nInputs*NUM_HIDDEN + NUM_HIDDEN*nOutputs;
*/
   // Set the range for the NN's weight values.
   vector< pair<double,double> > ranges(nVariables, make_pair(-1000,1000));
   setVarsRange(ranges);

   popFilePattern.assign("./communication/popfile_%02d.csv");
   objFilePattern.assign("./communication/objEval_%02d.csv");
}

TorcsSimRally::~TorcsSimRally() {}

void TorcsSimRally::evaluate(vector<double> const &x, vector<int> const &gene, vector<double> &f,  vector<double> &cons) const
{
}

/*
 * This implementation allows us to run several TORCS servers in parallel. Each one
 * in a different processor by creating a new process using fork. The number of processes is
 * a parameter of the constructor of the class.
 * With this rally version, a group of individuals (cars) are evaluated simultaneously
 * in the same race.
 * LIMITATION: Since the computer must not to be overloaded, at most, 16 individuals
 * must be in the same race.
 */
void TorcsSimRally::evaluatePop(Individual **ind, int popSize)
{
   pid_t pid; // to get result from calling fork.

   int remainingInds = popSize;    // Number of individuals to be evaluated.
   int indCounter = 0;             // Number of individuals evaluated.
   int nProcessors = nProcs;       // Number of parallel RALLIES.

   if (popSize % rallySize != 0) {
      perror("\nThe population size must be multiple of the rally size.\n");
      exit(1);
   }

   cerr << "\nNumber of processors: " << nProcessors << endl;

   while (remainingInds > 0) {
      cerr << "\n\nBonche de individuos que comienza en " << indCounter << endl;

      // Does the remaining individuals needs less than nProcessors?
      if (remainingInds < nProcessors*rallySize)
         nProcessors = remainingInds / rallySize;

      /** 1. Write every individual of the nProcessors rallies to a different output file ending with "_i" **/
      for (int i = 0, j=indCounter; i < nProcessors*rallySize; i++, j++)
         writePopFile(i, ind[j]->xreal);

      /** 2. Create a different child process for each nP TORCS server w rallySize clients (a RALLY) **/
      for (int i = 0; i < nProcessors; i++) {
         cerr << "\nEjecución para procesador " << i << endl;

         // Create a child process.
         pid = fork();
         if (pid == 0) { // If you are the child, change your code image.

            // Execute each car j of the rally for processor i
            for (int r = 0, j=i*rallySize; r < rallySize; ++r, ++j) {
               string port = std::to_string(3001 + j);
               int serverID = (r==0) ? i : -1;
               stringstream clientCmd;
               clientCmd << "./launch_torcs_client.sh " << " "
                     << port.c_str() << " "
                     << getPopFileName(j) << " "
                     << getObjFileName(i) << " "
                     << std::to_string(serverID).c_str() << " "
                     << std::to_string(rallySize).c_str() << endl;

               system(clientCmd.str().c_str());  // Con system porque no es necesario esperar nada.
            }

            stringstream command;
            command << "./launch_torcs_server_rally_reuse_cars.sh" << " "
                  << std::to_string(i).c_str() << " "
                  << getObjFileName(i).c_str() << " "
                  << std::to_string(rallySize).c_str() << endl;

            // Execute the server for the rally for processor i
            int res = execlp("./launch_torcs_server_rally_reuse_cars.sh",
                  "./launch_torcs_server_rally_reuse_cars.sh",
                  std::to_string(i).c_str(),
                  getObjFileName(i).c_str(),
                  std::to_string(rallySize).c_str(), NULL);

            if (res == -1) {
               perror("Error al ejecutar execlp");
               exit(1);
            }
         }
      }

      /** 3. Wait for every child process to finish the simulation ***/
      cerr << "\nNSGA2 waiting for TORCS simulation results...";
      while ( wait(NULL) > 0 );
      cerr << "\n...Resultados listos.\n";

      /** 4. Read every output file for each rally **/
      for (int i = 0, j=indCounter; i < nProcessors; i++, j+=rallySize)
         readRallyEvaluation(i, j, rallySize, ind);

      indCounter += nProcessors*rallySize;
      remainingInds -= nProcessors*rallySize;
   }
}

void TorcsSimRally::writePopFile(int idxIndividual, vector<double> &weights)
{
   ofstream popStream(getPopFileName(idxIndividual), std::ofstream::out);
   popStream << fixed << setw(5 + 8) << setprecision(8);

   //cout << "Escribiré el archivo de pesos: " << getPopFileName(idxIndividual) << endl;
   popStream << numInputsNN << "\n" << numOutputsNN << "\n" << numHidden << "\n";

   if (numHidden == 0) {
      for (int i = 0; i < numInputsNN; i++) {
         for (int j = 0; j < numOutputsNN; j++) {
            popStream << weights[i*numOutputsNN + j] << "\t";
         }
         popStream << "\t"; // Change \t for \n to write row in different lines.
      }

      popStream.close();
   }
   else if (numHidden > 0) {
      for (int i = 0; i < numInputsNN; i++) {
         for (int j = 0; j < numHidden; j++) {
            popStream << weights[i*numHidden + j] << "\t";
         }
         //popStream << "\t"; // Change \t for \n to write row in different lines.
      }

      int numWeightsHid1 = numInputsNN*numHidden;

      for (int i = 0; i < numHidden; i++) {
         for (int j = 0; j < numOutputsNN; j++) {
            popStream << weights[numWeightsHid1 + i*numOutputsNN + j] << "\t";
         }
         //popStream << "\t"; // Change \t for \n to write row in different lines.
      }
   }

   popStream.close();
}

void TorcsSimRally::readRallyEvaluation(int idxRally, int idxInd, int rallySize, Individual **ind)
{
   ifstream objStream(getObjFileName(idxRally), std::ifstream::in);
   //cout << "FINALMENTE ---> Leeré el archivo de evaluaciones: " << getObjFileName(idxIndividual) << endl;
   float dummie;
   for (int j = idxInd; j < idxInd+rallySize; ++j) {
      objStream >> dummie; // LEER la posición y desecharla.
      cerr << "j=" << j << "--> \t\t" << dummie << "\t\t";

      for (int i = 0; i < nObjectives; i++) {
         objStream >> ind[j]->obj[i];
         cerr << ind[j]->obj[i] << "\t\t";
      }

      // The last value is Distance_to_finish
      objStream >> ind[j]->constr[0];
      ind[j]->constr_violation = -1*ind[j]->constr[0];
      cerr << ind[j]->constr_violation << endl;
   }

   objStream.close();
}

string TorcsSimRally::getPopFileName(int i) {
   //stringstream fileName;
   //fileName << "./communication/" << popFileName << i << ".csv";
   //return fileName.str();
   char buffer[200];
   sprintf(buffer, popFilePattern.c_str(), i);
   return string(buffer);
}

string TorcsSimRally::getObjFileName(int i) {
//   stringstream fileName;
//   fileName << "./communication/" << objFileName << i << ".csv";
//   return fileName.str();
   char buffer[200];
   sprintf(buffer, objFilePattern.c_str(), i);
   return string(buffer);
}

void TorcsSimRally::printVector(vector<double> &v) {
   for (size_t i = 0; i < v.size(); i++) {
      std::cout << v[i] << "\t";
   }
}

