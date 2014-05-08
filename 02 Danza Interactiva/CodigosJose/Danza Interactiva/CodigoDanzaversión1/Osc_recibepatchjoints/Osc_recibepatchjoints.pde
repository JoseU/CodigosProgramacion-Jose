
import oscP5.*; // -->se importan las librerías oscP5 y netP5 
import netP5.*; 

OscP5 oscP5In1;
OscP5 oscP5In2;//--> definición del objeto
OscP5 oscP5Out;
NetAddress direccionRemota;

int puertoIn1 = 9000; // osc esqueleto
int puertoIn2 = 9500; // osc amplitud de audio

int puertoOut = 10200; // osc envio boolean particulas
String ipjose = "192.168.1.106";

//vectores de cada joint (x,y). 

PVector  head = new PVector(); 
PVector  neck = new PVector(); 
PVector  torso = new PVector(); 

PVector  lshoulder = new PVector(); 
PVector  lelbow = new PVector(); 
PVector  lhand = new PVector(); 

PVector  rshoulder = new PVector(); 
PVector  relbow = new PVector(); 
PVector  rhand = new PVector(); 

PVector  lhip = new PVector(); 
PVector  lknee = new PVector(); 
PVector  lfoot = new PVector(); 

PVector  rhip = new PVector(); 
PVector  rknee = new PVector(); 
PVector  rfoot = new PVector(); 
//
float amp; //amplitud (volumen) audio
boolean part; // variable boolean particula



void setup() {
  //osc esqueleto 
  oscP5In1 = new OscP5(this, puertoIn1); // Entrada: esqueleto
  //osc audio 
  oscP5In2 = new OscP5(this, puertoIn2); // Entrada: audio
  //  envio osc
  oscP5Out = new OscP5(this, puertoOut); // salida boolean particulas
  direccionRemota = new NetAddress(ipjose, puertoOut);
}

void draw() {

  if (mousePressed == true) {
    part = true;
  } 
  else {
    part = false;
  }


mandaElOSC();

}


void oscEvent(OscMessage theOscMessage) {
  //esqueleto
  if (theOscMessage.checkAddrPattern("/head")==true) { 
    head.x = theOscMessage.get(0).floatValue();         
    head.y = theOscMessage.get(1).floatValue(); 
    //    println("head.x " + head.x + " head.y " + head.y);
    return;
  }
  if (theOscMessage.checkAddrPattern("/neck")==true) { 
    neck.x = theOscMessage.get(0).floatValue();         
    neck.y = theOscMessage.get(1).floatValue(); 
    //    println("neck.x " + neck.x + " neck.y " + neck.y);
    return;
  }
  if (theOscMessage.checkAddrPattern("/torso")==true) { 
    torso.x = theOscMessage.get(0).floatValue();         
    torso.y = theOscMessage.get(1).floatValue(); 
    //    println("torso.x " + torso.x + " torso.y " + torso.y);
    return;
  }
  if (theOscMessage.checkAddrPattern("/lshoulder")==true) { 
    lshoulder.x = theOscMessage.get(0).floatValue();         
    lshoulder.y = theOscMessage.get(1).floatValue(); 
    //    println("lshoulder.x " + lshoulder.x + " lshoulder.y " + lshoulder.y);
    return;
  }
  if (theOscMessage.checkAddrPattern("/lelbow")==true) { 
    lelbow.x = theOscMessage.get(0).floatValue();         
    lelbow.y = theOscMessage.get(1).floatValue(); 
    //    println("lelbow.x " + lelbow.x + " lelbow.y " + lelbow.y);
    return;
  }
  if (theOscMessage.checkAddrPattern("/lhand")==true) { 
    lhand.x = theOscMessage.get(0).floatValue();         
    lhand.y = theOscMessage.get(1).floatValue(); 
    //    println("lhand.x " + lhand.x + " lhand.y " + lhand.y);
    return;
  }
  if (theOscMessage.checkAddrPattern("/rshoulder")==true) { 
    rshoulder.x = theOscMessage.get(0).floatValue();         
    rshoulder.y = theOscMessage.get(1).floatValue(); 
    //    println("rshoulder.x " + rshoulder.x + " rshoulder.y " + rshoulder.y);
    return;
  }
  if (theOscMessage.checkAddrPattern("/relbow")==true) { 
    relbow.x = theOscMessage.get(0).floatValue();         
    relbow.y = theOscMessage.get(1).floatValue(); 
    //    println("relbow.x " + relbow.x + " relbow.y " + relbow.y);
    return;
  }
  if (theOscMessage.checkAddrPattern("/rhand")==true) { 
    rhand.x = theOscMessage.get(0).floatValue();         
    rhand.y = theOscMessage.get(1).floatValue(); 
    //    println("rhand.x " + rhand.x + " rhand.y " + rhand.y);
    return;
  }
  if (theOscMessage.checkAddrPattern("/lhip")==true) { 
    lhip.x = theOscMessage.get(0).floatValue();         
    lhip.y = theOscMessage.get(1).floatValue(); 
    //    println("lhip.x " + lhip.x + " lhip.y " + lhip.y);
    return;
  }
  if (theOscMessage.checkAddrPattern("/lknee")==true) { 
    lknee.x = theOscMessage.get(0).floatValue();         
    lknee.y = theOscMessage.get(1).floatValue(); 
    //    println("lknee.x " + lknee.x + " lknee.y " + lknee.y);
    return;
  }
  if (theOscMessage.checkAddrPattern("/lfoot")==true) { 
    lfoot.x = theOscMessage.get(0).floatValue();         
    lfoot.y = theOscMessage.get(1).floatValue(); 
    //    println("lfoot.x " + lfoot.x + " lfoot.y " + lfoot.y);
    return;
  }
  if (theOscMessage.checkAddrPattern("/rhip")==true) { 
    rhip.x = theOscMessage.get(0).floatValue();         
    rhip.y = theOscMessage.get(1).floatValue(); 
    //    println("rhip.x " + rhip.x + " rhip.y " + rhip.y);
    return;
  }
  if (theOscMessage.checkAddrPattern("/rknee")==true) { 
    rknee.x = theOscMessage.get(0).floatValue();         
    rknee.y = theOscMessage.get(1).floatValue(); 
    //    println("rknee.x " + rknee.x + " rknee.y " + rknee.y);
    return;
  }
  if (theOscMessage.checkAddrPattern("/rfoot")==true) { 
    rfoot.x = theOscMessage.get(0).floatValue();         
    rfoot.y = theOscMessage.get(1).floatValue(); 
    //  println("rfoot.x " + rfoot.x + " rfoot.y " + rfoot.y);
    return;
  }
  //audio amp
  if (theOscMessage.checkAddrPattern("/amp")==true) { 
    amp = theOscMessage.get(0).floatValue();         
    //    println("amp " + amp);
    return;
  }
}

void mandaElOSC() {
  //boolean
  OscMessage mensaje1 = new OscMessage("/boolean");
  mensaje1.add(part);  
  oscP5Out.send(mensaje1, direccionRemota);
}


