import java.util.ArrayList;
import java.util.Random;

/**
 *
 * @author lily
 */
class GeneticProgram {
    ArrayList<Arbol> listaArbol;
    ArrayList<Arbol> seleccion;
    double pCruza;
    double pMutacion;
    int tamPoblacion;    
    //RANDOM
    Random rand;
    
    public GeneticProgram(int tPoblacion, double pCruza, double pMutacion, long seed){
        this.listaArbol = new ArrayList<Arbol>();
        this.seleccion = new ArrayList<Arbol>();
        this.pCruza = pCruza;
        this.pMutacion = pMutacion;
        this.tamPoblacion = tPoblacion;
        this.rand = new Random((long)seed);
    }
    
    public void start(long seed){
        rand = new Random((long)seed);
        //Verificar que tamPoblacion sea par
        if(tamPoblacion % 2 == 0){
            //Generar población
            //generarPoblacion(tamPoblacion, metodo, rand);
            //Imprimir para verificar
            for(int i = 0; i < listaArbol.size(); i++){
                System.out.println("Árbol #" + i);
                System.out.println("Peso: " + listaArbol.get(i).getPeso());
                System.out.println("Altura " + listaArbol.get(i).getAltura());
                System.out.println("Calificación: " + listaArbol.get(i).getScore());
                listaArbol.get(i).imprimirArbol(listaArbol.get(i).getRoot(), listaArbol.get(i).getAltura());
            }
            
            //Evaluar población
            //Seleccionar parejas
            //Cruzar
            //Mutar
        }
        else{
            System.out.println("El tamaño de población: '" + tamPoblacion + "' No es par");
        }
        
    }


    
    public void generarPoblacion(int profMaxima, int method) {
        if(method == 2){
            for(int i = 0; i < tamPoblacion; i++){
                if(i%2 == 0){
                    listaArbol.add(new Arbol(0, profMaxima, rand));
                }
                else{
                    listaArbol.add(new Arbol(1, profMaxima, rand));
                }
            }
        } else{
            for(int i = 0; i < tamPoblacion; i++){
                listaArbol.add(new Arbol(method, profMaxima, rand));
            }
        }
    }
    
    
    public void imprimirPoblacion(){
      for(int i = 0; i < listaArbol.size(); i++){
                System.out.println("Árbol #" + i);
                System.out.println("Peso: " + listaArbol.get(i).getPeso());
                System.out.println("Altura " + listaArbol.get(i).getAltura());
                System.out.println("Calificación: " + listaArbol.get(i).getScore());
                listaArbol.get(i).imprimirArbol(listaArbol.get(i).getRoot(), listaArbol.get(i).getAltura());
            }
    }
}
