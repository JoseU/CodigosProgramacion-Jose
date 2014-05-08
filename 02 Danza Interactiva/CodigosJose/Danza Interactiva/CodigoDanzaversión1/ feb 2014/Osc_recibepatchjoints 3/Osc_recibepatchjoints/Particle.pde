// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Simple Particle System

class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;

  Particle(PVector l) {
    acceleration = new PVector(0, mic);
    velocity = new PVector(mic,random(-2,0));
    location = l.get();
    lifespan = 255.0;
  }

  void run() {
    update();
    display();
  }

  // Method to update location
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    lifespan -= 2.0;
  }

  // Method to display
  void display() {
    stroke(0, lifespan, 0, 200);
    strokeWeight(2);
    fill(127, lifespan, 0, 200 );
    ellipse(location.x,location.y, 12, 12);
  }
  
  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}

