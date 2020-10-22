/**
 *
 * @author lily
 */
class NodoArbol {
    NodoArbol padre;
    NodoArbol hijoIzq;
    NodoArbol hijoDer;
    String contenido;
    String tipo;
    int id;
    
    public NodoArbol(){
        this.padre = null;
        this.contenido = null;
        this.hijoDer = null;
        this.hijoIzq = null;
    }
    
    void setHijoDer(NodoArbol n){
        this.hijoDer = n;
    }
    
    void setHijoIzq(NodoArbol n){
        this.hijoIzq = n;
    }

    void setPadre(NodoArbol padre) {
        this.padre = padre;
    }

    void setContenido(String cont) {
        this.contenido = cont;
    }

    void setID(int peso) {
        this.id = peso;
    }

    void setTipo(String fun) {
        this.tipo = fun;
    }

    public NodoArbol getHijoIzq() {
        return this.hijoIzq;
    }

    public NodoArbol getHijoDer() {
        return this.hijoDer;
    }
    
    public String getCont(){
        return this.contenido;
    }
    
    public String getType(){
        return this.tipo;
    }
}
