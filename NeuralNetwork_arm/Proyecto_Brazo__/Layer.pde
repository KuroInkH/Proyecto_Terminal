import java.util.ArrayList;
/**
 *
 * @author lily
 */
public class Layer {
    private ArrayList<Neuron> Neurons;
    private ArrayList<Double> input;
    private Layer ant;
    private Layer sig;
    int numNeurons;
    
    public Layer(){
        ant = null;
        sig = null;
        numNeurons = 0;
        Neurons = new ArrayList<Neuron>();
    }
    
    void add(Neuron neuron) {
        this.Neurons.add(neuron);
        this.numNeurons++;
    }

    void Calcular() {
        for(int i = 0; i < this.numNeurons; i++){
            this.Neurons.get(i).Calcular(this.input);
        }            
    }
    
    void setNeuronsWeight(ArrayList<Double> w) {
        ArrayList<Double> subW;
        int cont = 0;
        for(int i = 0; i < this.numNeurons; i++){
            subW = new ArrayList<Double>();
            int p = this.Neurons.get(i).getNumPesos();
            for(int j = 0; j < p; j++){
                //System.out.println("Numero de pesos: " + p + ", " + j + ", " + cont);
                subW.add(w.get(cont));
                cont++;
            }
            this.Neurons.get(i).setWeights(subW);
        }
    }

    void setLayerInput(ArrayList<Double> inp) {        
        input = new ArrayList<Double>();
        for(int i = 0; i < inp.size(); i++){
            this.input.add(inp.get(i));
        }
    }
    
    void setInput(ArrayList<Double> input) {
        this.input = input;        
        for(int i = 0; i < numNeurons-1; i++){
            this.Neurons.get(i).setData(input.get(i));
        }
    }

    void setNext(Layer next) {
        this.sig = next;
    }

    void setPrevious(Layer prev) {
        this.ant = prev;
    }
    
    public int getNumNeurons() {
        return numNeurons;
    }    

    public ArrayList<Double> getNeuronContent() {
        ArrayList<Double> content = new ArrayList<Double>();
        Double x = (double)0.0;
        for(int i = 0; i < Neurons.size(); i++){            
            x = Neurons.get(i).getOutput();
            content.add(x);
        }
        return content;
    }
    
    public ArrayList<Double> getLayerWeights(){
        ArrayList<Double> layerWeights = new ArrayList<Double>();
        for(int i = 0; i < this.numNeurons; i++){
            layerWeights.addAll(this.Neurons.get(i).getWeights());
        }
        return layerWeights;
    }
    
    public ArrayList<Double> getLayerInput() {
        return this.input;
    }

    public ArrayList<Double> getLayerOutput() {
        ArrayList<Double> o = new ArrayList<Double>();
        for(int i = 0; i < this.numNeurons; i++){
            o.add(this.Neurons.get(i).getOutput());
        }
        return o;
    }
}
