/*
 * Created on: 1/Nov/2018
 *      Author: Antonio LJ
 *
 * This class allows us to start several car-clients (individuals of population) for competing
 * in the same race (i.e., same torcs server). We call this configuration a rally. This way, several
 * individuals can be evaluated in the same race. Note that if we have several processors,
 * each of them run a torcs server and its car-clients.
 * Examples:
 *  - If the size of the rally is 1, the individuals are evaluated 1 by 1, each one alone in a race.
 *  - If the size of the rally is 4 and the population size is 20, then 5 rallies are configured in such a way
 *  that each one receives 4 individuals of the population.
 */

#ifndef TORCSIMRALLY_H
#define TORCSIMRALLY_H

#include <mops/mop.h>
#include "Individual.h"
#include <vector>

using namespace std;


class TorcsSimRally : public MOP
{
public:
//   TorcsSimRally(int nProcs=1, int rallySize=4, const int numObjs=3, const int numCons=1,
//		         const int nInputs=60, const int nOutputs=5, const int nHidden=5);

   TorcsSimRally(int nProcs=1, int rallySize=4, const int numObjs=3, const int numCons=1,
               const int nInputs=24, const int nOutputs=5, const int nHidden=0);

   virtual ~TorcsSimRally();

   // This method come from the base class MOP.
   void evaluate(vector<double> const &x, vector<int> const &gene,
	                 vector<double> &fx, vector<double> &gcons) const;

   void evaluatePop(Individual **ind, int popSize);

private:
   int nProcs;       // Number of simultaneous processes to evaluate the population.
   int numInputsNN;  // Number of inputs of the neural network.
   int numOutputsNN; // Number of outputs of the neural network.
   int numHidden;    // Number of hidden nodes of the neural network.

   string popFilePattern; // Name of the file in which each individual will be written.
   string objFilePattern; // Name of the file in which the evaluation of each individual is written by the server.
   ofstream popStream;    // Stream to write each individual.
   ifstream objStream;    // Stream to read the evaluation of each individual.


   int rallySize; // Number of cars per rally.

   void writePopFile(int idxIndividual, vector<double> &weights);

   void readRallyEvaluation(int idxRally,
                            int idxInd,
                            int rallySize,
                            Individual **ind);

   void printVector(vector<double> &v);
   string getPopFileName(int i);
   string getObjFileName(int i);
/*
   void readObjectiveEvaluation(int idxIndividual,
                                vector<double> &objValues,
                                vector<double> &consValues);
*/
};

#endif /*TORCSIMRALLY_H*/
