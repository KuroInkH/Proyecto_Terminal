import java.util.ArrayList;
import java.util.List;

class NeuralNetwork {
    
    private Layer InputLayer;
    private ArrayList<Layer> HiddenLayer;
    private Layer OutputLayer;
    private int numPesos;

    NeuralNetwork(int inputNeurons, ArrayList<Integer> hiddenNeurons, int outputNeurons) {
        numPesos = 0;
        InputLayer = new Layer();
        //Add input neurons
        for(int i = 0; i < inputNeurons; i++){
            InputLayer.add(new Neuron(0));
        }
        
        //Add hidden layers and neurons
        Layer prev = InputLayer;
        HiddenLayer = new ArrayList<Layer>();
        for(int i = 0; i < hiddenNeurons.size(); i++){
            HiddenLayer.add(new Layer());
            for(int j = 0; j < hiddenNeurons.get(i); j++){
                HiddenLayer.get(i).add(new Neuron(prev.getNumNeurons()));                
            }
            numPesos = numPesos + (prev.getNumNeurons() * HiddenLayer.get(i).getNumNeurons());
            prev = HiddenLayer.get(i);
        }
        
        OutputLayer = new Layer();
        //Add Output Neurons
        int x = (HiddenLayer.size()-1);
        for(int i = 0; i < outputNeurons; i++){
            OutputLayer.add(new Neuron(HiddenLayer.get(x).numNeurons));
        }
        numPesos = numPesos + (OutputLayer.getNumNeurons() * HiddenLayer.get(HiddenLayer.size()-1).getNumNeurons());
    }
    
    public void setInput(ArrayList<Double> input, Double riesgo, int isObst){
        //System.out.println(input.size()+", "+(InputLayer.getNumNeurons()-1));
        if(isObst == 1){
          input.add(riesgo);
        }        
        if(input.size() == InputLayer.getNumNeurons()){
            InputLayer.setInput(input);
            
        } else{
            System.out.println("Error al introducir los datos. Revisa los datos de entrada. (Mensaje enviado desde la clase NeuralNetwork)");
        }        
    }

    public int getNumberInputNeurons() {
        return (InputLayer.numNeurons);
    }

    public int getNumberHiddenLayers() {
        return this.HiddenLayer.size();
    }

    public int getNumberOutputNeurons() {
        return this.OutputLayer.numNeurons;
    }
    
    //Método duplicado con getOutput
    public ArrayList<Double> getNNInput(){
        return InputLayer.getNeuronContent();
    }

    public ArrayList<Double> getOutput() {
        return OutputLayer.getLayerOutput();
    }

    public int getNumPesos() {
        return this.numPesos;
    }

    public ArrayList<Double> getWeights() {
        ArrayList<Double> w = new ArrayList<Double>();
        for(int i = 0; i < HiddenLayer.size(); i++){
            w.addAll(HiddenLayer.get(i).getLayerWeights());
        }
        w.addAll(OutputLayer.getLayerWeights());
        return w;
    }

    public void setWeight(ArrayList<Double> w) {
        List<Double> pesos = new ArrayList<Double>();
        int ant = InputLayer.getNumNeurons(), tam, idx = 0;
        for(int i = 0; i < HiddenLayer.size(); i++){
            //Obtenemos el numero de pesos por layer
            tam = ant * HiddenLayer.get(i).getNumNeurons() + idx;
            //Cortamos w acorde al número de pesos de la layer
            //System.out.println("Sublista de " + idx + " a " + tam);
            pesos = w.subList(idx, tam);
            //Mandamos al layer los pesos
            HiddenLayer.get(i).setNeuronsWeight(new ArrayList<Double>(pesos));
            //ant = act
            ant = HiddenLayer.get(i).getNumNeurons();
            idx = tam;
        }      
        
        tam = HiddenLayer.get(HiddenLayer.size()-1).getNumNeurons() * OutputLayer.getNumNeurons() +idx;
        //System.out.println("Sublista de " + idx + " a " + tam);
        pesos = w.subList(idx, tam);
        OutputLayer.setNeuronsWeight(new ArrayList<Double>(pesos));
    }

    public void calcular() {
        //Darle input de una layer a otra y calcular
        Layer ant = InputLayer;
        for(int i = 0; i < HiddenLayer.size(); i++){
            HiddenLayer.get(i).setLayerInput(ant.getLayerOutput());
            HiddenLayer.get(i).Calcular();
            ant = HiddenLayer.get(i);
        }
        //Hacer lo mismo con outputlayer
        int idx = HiddenLayer.size()-1;
        OutputLayer.setLayerInput(HiddenLayer.get(idx).getLayerOutput());
        OutputLayer.Calcular();
    }
    
    
    
    
    
    
    public float[] getAngles() {
        //Obtener los valores de la red        
        float[] result = transformOutput(getOutput());        
        return result;
    }
    
    public float[] transformOutput(ArrayList<Double> o){
    float[] output = new float[o.size()];
    for (int x = 0; x < o.size(); x++) {
      output[x] = (float)((o.get(x) * (Math.PI*2)));
      //output[x] = (float)(output[x] - Math.PI);
      if(output[x]>0){
        output[x] =  (float)(output[x] - (Math.PI));
      }
      else{
         output[x] =  (float)(output[x] + (Math.PI));
      }
      //System.out.println("Output " + x + ": " + (o.get(x))+", " +output[x]);
    }
    return output;
  
    }
    
}
