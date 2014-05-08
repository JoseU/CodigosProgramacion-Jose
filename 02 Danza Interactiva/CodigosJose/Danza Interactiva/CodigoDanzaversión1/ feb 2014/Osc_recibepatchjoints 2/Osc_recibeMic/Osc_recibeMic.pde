
import oscP5.*; // -->se importan las librerías oscP5 y netP5 
import netP5.*; 


OscP5 oscP5In3;

NetAddress direccionRemota;

ParticleSystem ps;
int puertoIn3 = 9700; // osc amplitud microfono aire
//vectores de cada joint (x,y). 
//
float mic; //amplitud (volumen) audio mic




void setup() {
  size(640, 360);
  ps = new ParticleSystem(new PVector(width/2, 50));
  //osc audio mic 
  oscP5In3 = new OscP5(this, puertoIn3); // Entrada: esqueleto
}

void draw() {
  background(255);

  // Option #1 (move the Particle System origin)
  ps.origin.set(mouseX, mouseY, 0);

  ps.addParticle();
  ps.run();

  // Option #2 (move the Particle System origin)
  // ps.addParticle(mouseX,mouseY);
}


void oscEvent(OscMessage theOscMessage) {
  //esqueleto
  if (theOscMessage.checkAddrPattern("/mic")==true) { 
    mic = theOscMessage.get(0).floatValue();         

    println("mic " + mic);
    return;
  }
}

