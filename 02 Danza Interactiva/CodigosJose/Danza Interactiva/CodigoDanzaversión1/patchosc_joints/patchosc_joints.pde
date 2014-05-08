//------------OSC// importar libreria y variables
import oscP5.*; // -->importar librerías oscP5 y netP5
import netP5.*;
OscP5 oscP5; //--> definición del objeto
OscP5 oscP5In;
NetAddress direccionRemota;
int puertoOut;

String ip = "192.168.1.115"; //-->dirección ip Reno
//------------OSC// importar libreria y variables

float amp;
float ampr;

import SimpleOpenNI.*;

SimpleOpenNI  context;
color[]       userClr = new color[] { 
  color(255, 0, 0), 
  color(0, 255, 0), 
  color(0, 0, 255), 
  color(255, 255, 0), 
  color(255, 0, 255), 
  color(0, 255, 255)
};
PVector com = new PVector();                                   
PVector com2d = new PVector();   

// Vectores para obtener de esqueleto (sin transformación para proyección).

PVector head = new PVector();
PVector neck = new PVector();
PVector torso = new PVector();

PVector left_shoulder = new PVector();
PVector left_elbow = new PVector();
PVector left_hand = new PVector();

PVector right_shoulder = new PVector();
PVector right_elbow = new PVector();
PVector right_hand = new PVector();

PVector left_hip = new PVector();
PVector left_knee = new PVector();
PVector left_foot = new PVector();

PVector right_hip = new PVector();
PVector right_knee = new PVector();
PVector right_foot = new PVector();

// vectores convertidos 

PVector c_head = new PVector();
PVector c_neck = new PVector();
PVector c_torso = new PVector();

PVector c_left_shoulder = new PVector();
PVector c_left_elbow = new PVector();
PVector c_left_hand = new PVector();

PVector c_right_shoulder = new PVector();
PVector c_right_elbow = new PVector();
PVector c_right_hand = new PVector();

PVector c_left_hip = new PVector();
PVector c_left_knee = new PVector();
PVector c_left_foot = new PVector();

PVector c_right_hip = new PVector();
PVector c_right_knee = new PVector();
PVector c_right_foot = new PVector();

void setup()
{
  size(640, 480);

  context = new SimpleOpenNI(this);
  if (context.isInit() == false)
  {
    println("No se puede iniciar SimpleOpenNI, talvea la camara no esta conectada!"); 
    exit();
    return;
  }

  // activada la generación del  depthMap  
  context.enableDepth();

  // activada la generación de esqueleto para todos los joints(vectores)
  context.enableUser();

  background(200, 0, 0);

  stroke(0, 0, 255);
  strokeWeight(3);
  smooth();

  //OSC// Inicialización Configuración puerto IP
  
//  ip = "localhost";
  puertoOut = 9000;
  oscP5 = new OscP5(this, puertoOut); //-->inicialización del objeto
  direccionRemota = new NetAddress(ip, puertoOut); //-->Entrada: mensajes de entrada por el puerto especificado
  //OSC//
}

void draw()
{
  // actualización de la camara
  context.update();

  // dibujar depthImageMap
  //image(context.depthImage(),0,0);
  image(context.userImage(), 0, 0);

  // dibujar el esquelto si este esta disponible
  int[] userList = context.getUsers();
  for (int i=0;i<userList.length;i++)
  {
    if (context.isTrackingSkeleton(userList[i]))
    {
      stroke(userClr[ (userList[i] - 1) % userClr.length ] );
      drawSkeleton(userList[i]);
    }
  }

  mandaElOSC();
}

// graficar el esqueleto con joints seleccionados
void drawSkeleton(int userId)
{
  // obteniendo los datos 3d de los joints

  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_HEAD, head);
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_NECK, neck);
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_TORSO, torso);

  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, left_shoulder);
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, left_elbow);
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, left_hand);

  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, right_shoulder);
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, right_elbow);
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, right_hand);

  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HIP, left_hip);
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_KNEE, left_knee);
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_FOOT, left_foot);

  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HIP, right_hip);
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, right_knee);
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_FOOT, right_foot);


  // convirtiendo  a joints de proyección 

  context.convertRealWorldToProjective(head, c_head);
  context.convertRealWorldToProjective(neck, c_neck);
  context.convertRealWorldToProjective(torso, c_torso);

  context.convertRealWorldToProjective(left_shoulder, c_left_shoulder);
  context.convertRealWorldToProjective(left_elbow, c_left_elbow);
  context.convertRealWorldToProjective(left_hand, c_left_hand);

  context.convertRealWorldToProjective(right_shoulder, c_right_shoulder);
  context.convertRealWorldToProjective(right_elbow, c_right_elbow);
  context.convertRealWorldToProjective(right_hand, c_right_hand);

  context.convertRealWorldToProjective(left_hip, c_left_hip);
  context.convertRealWorldToProjective(left_knee, c_left_knee);
  context.convertRealWorldToProjective(left_foot, c_left_foot);

  context.convertRealWorldToProjective(right_hip, c_right_hip);
  context.convertRealWorldToProjective(right_knee, c_right_knee);
  context.convertRealWorldToProjective(right_foot, c_right_foot);

  //dibujando el limbo

  context.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);
  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
}

// -----------------------------------------------------------------
// SimpleOpenNI events

void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");

  curContext.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  //println("onVisibleUser - userId: " + userId);
}


void keyPressed()
{
  switch(key)
  {
  case ' ':
    context.setMirror(!context.mirror());
    break;
  }
}  


void mandaElOSC() {
  //axis OSC
  OscMessage mensaje1 = new OscMessage("/head");
  mensaje1.add(c_head.x);
  mensaje1.add(c_head.y);
  //  mensaje1.add(c_head.z);

  OscMessage mensaje2 = new OscMessage("/neck");
  mensaje2.add(c_neck.x);
  mensaje2.add(c_neck.y);
  // mensaje2.add(c_neck.z);

  OscMessage mensaje3 = new OscMessage("/torso");
  mensaje3.add(c_torso.x);
  mensaje3.add(c_torso.y);
  //  mensaje3.add(c_torso.z);

  OscMessage mensaje4 = new OscMessage("/lshoulder");
  mensaje4.add(c_left_shoulder.x);
  mensaje4.add(c_left_shoulder.y);
  //  mensaje4.add(c_left_shoulder.z);

  OscMessage mensaje5 = new OscMessage("/lelbow");
  mensaje5.add(c_left_elbow.x);
  mensaje5.add(c_left_elbow.y);
  //  mensaje5.add(c_left_elbow.z);

  OscMessage mensaje6 = new OscMessage("/lhand");
  mensaje6.add(c_left_hand.x);
  mensaje6.add(c_left_hand.y);
  //  mensaje6.add(c_left_hand.z);

  OscMessage mensaje7 = new OscMessage("/rshoulder");
  mensaje7.add(c_right_shoulder.x);
  mensaje7.add(c_right_shoulder.y);
  //  mensaje7.add(c_right_shoulder.z);

  OscMessage mensaje8 = new OscMessage("/relbow");
  mensaje8.add(c_right_elbow.x);
  mensaje8.add(c_right_elbow.y);
  //  mensaje8.add(c_right_elbow.z);

  OscMessage mensaje9 = new OscMessage("/rhand");
  mensaje9.add(c_right_hand.x);
  mensaje9.add(c_right_hand.y);
  //  mensaje9.add(c_right_hand.z);

  OscMessage mensaje10 = new OscMessage("/lhip");
  mensaje10.add(c_left_hip.x);
  mensaje10.add(c_left_hip.y);
  //  mensaje10.add(c_left_hip.z);

  OscMessage mensaje11 = new OscMessage("/lknee");
  mensaje11.add(c_left_knee.x);
  mensaje11.add(c_left_knee.y);
  //  mensaje11.add(c_left_knee.z);

  OscMessage mensaje12 = new OscMessage("/lfoot");
  mensaje12.add(c_left_foot.x);
  mensaje12.add(c_left_foot.y);
  //  mensaje12.add(c_left_foot.z);

  OscMessage mensaje13 = new OscMessage("/rhip");
  mensaje13.add(c_right_hip.x);
  mensaje13.add(c_right_hip.y);
  //  mensaje13.add(c_right_hip.z);

  OscMessage mensaje14 = new OscMessage("/rknee");
  mensaje14.add(c_right_knee.x);
  mensaje14.add(c_right_knee.y);
  //  mensaje14.add(c_right_knee.z);

  OscMessage mensaje15 = new OscMessage("/rfoot");
  mensaje15.add(c_right_foot.x);
  mensaje15.add(c_right_foot.y);
  //  mensaje15.add(c_right_foot.z);


  oscP5.send(mensaje1, direccionRemota); //-->Se envia el mensaje
  oscP5.send(mensaje2, direccionRemota); 
  oscP5.send(mensaje3, direccionRemota);
  oscP5.send(mensaje4, direccionRemota);
  oscP5.send(mensaje5, direccionRemota);
  oscP5.send(mensaje6, direccionRemota);
  oscP5.send(mensaje7, direccionRemota);
  oscP5.send(mensaje8, direccionRemota);
  oscP5.send(mensaje9, direccionRemota);
  oscP5.send(mensaje10, direccionRemota);
  oscP5.send(mensaje11, direccionRemota);
  oscP5.send(mensaje12, direccionRemota);
  oscP5.send(mensaje13, direccionRemota);
  oscP5.send(mensaje14, direccionRemota);
  oscP5.send(mensaje15, direccionRemota);
}

