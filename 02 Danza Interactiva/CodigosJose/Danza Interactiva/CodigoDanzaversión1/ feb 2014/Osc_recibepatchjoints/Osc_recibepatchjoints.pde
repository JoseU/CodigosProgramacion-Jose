
import oscP5.*; // -->se importan las librerías oscP5 y netP5 
import netP5.*; 

OscP5 oscP5; //--> definición del objeto

int puerto; //--> Se define un puerto de entrada para la comunicación osc

PVector  head = new PVector(); 

float x, y; //--> varialbe para la posicion y

float posX, posY, diametro, alfa; // varialbes para el círculo

void setup() {
  size (400, 400);
  
    
  puerto = 9500; // elegimos el puerto, que debe ser el mismo del servidor
  oscP5 = new OscP5(this, puerto); // Entrada: mensajes de entrada por el puerto especificado
}

void draw() {
  
frameRate(20);
 int colrd = (ceil(random(89)));
  alfa = 255;
   background (200, colrd, colrd, alfa);  
 diametro = random(100);
 
  noStroke();
  fill(255, colrd, colrd, alfa);
  ellipse(posX, posY, diametro, diametro);
 
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/head")==true) { // si la dirección es "x"
    println("entro head");
    if (theOscMessage.checkTypetag("i")) {          // si el dato que trae el mensaje es un float
      x = theOscMessage.get(0).intValue();        // extraemos el primer dato (0) y se lo asignamos a x 
      y = theOscMessage.get(1).intValue();  
      println("x " + x + "y" + y);
      return;
    }
  }
  
}





