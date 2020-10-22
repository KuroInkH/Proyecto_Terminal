import java.util.ArrayList;
/**
 *
 * @author lily
 */
enum funct{SIGMOID, TANH}

class Neuron {
    
    private ArrayList<Double> weight;
    private Double output;
    private Double outputBeforeActivation;
    private funct aFunction;
    private int numPesos;
    
    public Neuron(int w){
        weight = new ArrayList<Double>();
        for(int i = 0; i < w; i++){
            weight.add((double)1.0);
        }
        output = (double)1.0;
        outputBeforeActivation = (double)0.0;
        aFunction = funct.TANH;
        numPesos = weight.size();
    }
    
    public void Calcular(ArrayList<Double> input){
        outputBeforeActivation = (double)0.0;
        for(int i = 0; i < input.size(); i++){
            outputBeforeActivation = outputBeforeActivation + input.get(i)*weight.get(i);
            //System.out.println("oba: " + outputBeforeActivation);
        }        
        output = activationFunction();
    }
    
    public Double activationFunction(){
        Double result = (double)0.0;
        switch(aFunction){
            case TANH:
                result = Math.tanh(Math.toRadians(outputBeforeActivation));
                result = Math.tanh(outputBeforeActivation);
                break;
            case SIGMOID:
                result = 1.0 / (1 + Math.exp(-outputBeforeActivation));
                break;
            default:
                System.out.println("La función no existe");
                break;
        }
        return result;
    }
    
    public void setData(Double out){
        this.output = out;
    }
    
    public Double getOutput(){
        return this.output;
    }
    
    public Double getOutputBA(){
        return this.outputBeforeActivation;
    }

    public ArrayList<Double> getWeights() {
        return weight;
    }

    public void setWeights(ArrayList<Double> w) {
        this.weight = w;
    }

    public int getNumPesos() {
        return this.numPesos;
    }
    
    public void setActivationFunction(funct func) {
        this.aFunction = func;
    }
}
