import java.util.Random;

/**
 *
 * @author lily
 */
class Arbol {
    String[] Funcion = {"if", ">="};
    String[] Terminal = {"d", "constA", "constB", "constC"};
    NodoArbol raiz;
    Random rand;
    int altura;
    int peso;
    //DATA FROM MOP
    float step = 15;
    float score = 0;
    
    
    public Arbol(int method, int pM, Random rand){
        this.rand = rand;
        createArbol(method, pM);
        calcularAltura(raiz, 0, 0);
        
        calcularPeso(raiz);
    }

    private void createArbol(int method, int pM) {
        //System.out.println("Método: " + method);
        switch(method){
            case 0:
                //FullMethod
                raiz = FullMethod(null, pM);
                break;
            case 1:
                //GrowMethod
                raiz = GrowMethod(null, pM);
                break; 
            case 2:
                //M-ario
                raiz = Mario(null, pM);
        }
    }

    private NodoArbol FullMethod(NodoArbol padre, int tam) {
        NodoArbol n = new NodoArbol();
        n.setPadre(padre);
        if(tam <= 1){
            n.setContenido(Terminal[getRandom(Terminal.length)]);
            n.setTipo("FunT");
            n.setHijoDer(null);
            n.setHijoIzq(null);
        } else{
                n.setContenido(Funcion[getRandom(Funcion.length)]);
                n.setHijoDer(FullMethod(n, tam-1));
                n.setHijoIzq(FullMethod(n, tam-1));
        }
        return n;
    }

    private NodoArbol GrowMethod(NodoArbol padre, int tam) {        
        int x = getRandom(2);
        System.out.println("Tipo: " + x);
        NodoArbol n = new NodoArbol();
        n.setPadre(padre);
        if(tam <= 0 || x == 1){
            n.setContenido(Terminal[getRandom(Terminal.length)]);
            n.setTipo("FunT");
            n.setHijoDer(null);
            n.setHijoIzq(null);
        }
        else{
                n.setContenido(Funcion[getRandom(Funcion.length)]);
                n.setHijoDer(FullMethod(n, tam-1));
                n.setHijoIzq(FullMethod(n, tam-1));
        }
        return n;
    }
    
    private NodoArbol Mario(NodoArbol padre, int tam) { 
          NodoArbol n = new NodoArbol();
          n.setPadre(padre);
          if(tam <= 0){
              n.setContenido(Terminal[getRandom(Terminal.length)]);
              n.setTipo("FunT");
              n.setHijoDer(null);
              n.setHijoIzq(null);
          }
          else{
          
          }
          return n;
    }
    
    public void imprimirArbol(NodoArbol nodo, int nivel)
    {
        //System.out.print("|");
        for(int i = nivel; i < altura; i++)
        {
            System.out.print("\t");
            //System.out.print("----");
        }        
        nivel--;
        System.out.println(nodo.contenido /*+ "(" + nodo.id + ")"*/);
        if(nodo.hijoIzq != null)
        {
            imprimirArbol(nodo.hijoIzq, nivel);
        }
        if(nodo.hijoDer != null)
        {
            imprimirArbol(nodo.hijoDer, nivel);
        }
    }
    
    public void calcularPeso(NodoArbol nodo)
    {
        peso++;
        nodo.setID(peso);
        if(nodo.getHijoIzq() != null)
        {
            calcularPeso(nodo.hijoIzq);
        }
        if(nodo.hijoDer != null)
        {
            calcularPeso(nodo.hijoDer);
        }
    }
    
    public void calcularAltura(NodoArbol nodo, int nivA, int nivB)
    {
        if(nodo.hijoIzq != null)
        {
            nivA++;
            calcularAltura(nodo.hijoIzq, nivA, nivB);
        }
        if(nodo.hijoDer != null)
        {
            nivB++;
            calcularAltura(nodo.hijoDer, nivA, nivB);
        }
        
        if(nivA > nivB)
            altura = nivA;
        else
            altura = nivB;
    }
    
    private int getRandom(int num) {        
        return rand.nextInt(num);
    }

    int getPeso() {
        return this.peso;
    }

    int getAltura() {
        return this.altura;
    }

    float getScore() {
        return this.score;
    }
    
    public NodoArbol getRoot(){
        return this.raiz;
    }
    
}
