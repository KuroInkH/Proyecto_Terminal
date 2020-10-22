/*
 * ArmTrajectoryMOP.h
 *
 *  Created on: Sep 30, 2019
 *      Author: antonio
 */

#ifndef SRC_MOPS_ARMTRAJECTORYMOP_H_
#define SRC_MOPS_ARMTRAJECTORYMOP_H_

#include <mops/mop.h>
#include "Individual.h"
#include <vector>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>


using namespace std;

class ArmTrajectoryMOP: public MOP {
public:
   ArmTrajectoryMOP(int numWeight=54);
   virtual ~ArmTrajectoryMOP();

   // This method come from the base class MOP.
   void evaluate(vector<double> const &x, vector<int> const &gene, vector<double> &fx, vector<double> &gcons) const;

   void evaluatePop(Individual **ind, int popSize);

private:
   int sockfd; // Descriptor de archivo del socket
   int puerto; // Número de puerto
   struct sockaddr_in serv_addr;
   struct hostent *server;
};
#endif /* SRC_MOPS_ARMTRAJECTORYMOP_H_ */

