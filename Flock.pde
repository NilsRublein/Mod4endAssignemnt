// Does very little, simply manages the ArrayList of all the Fishes

class Flock {
  ArrayList<Fish> Fishes;                 // An ArrayList for all the (small) Fishes

  Flock() {
    Fishes = new ArrayList<Fish>();       // Initialize the ArrayList
  }

  void run() {
    for (Fish f : Fishes) {
      f.run(Fishes);                      // Passing the entire list of Fishes to each Fish individually
    }
  }

  void applyRepel(MainFish r) {       //Calculating a force for each fish based on a MainFish
    for (Fish f : Fishes) {
      PVector force = r.repel(f);
      f.applyForce(force);
    }
  }

  void applyRepel(Hook r) {      //Calculating a force for each fish based on a Repeller
    for (Fish f : Fishes) {
      PVector force = r.repel(f);
      f.applyForce(force);
    }
  }

  void applyAttract(Hook r) {      //Calculating a force for each fish based on a Hook
    for (Fish f : Fishes) {
      PVector force = r.attract(f);
      f.applyForce(force);
    }
  }
  
  void addFish(Fish f) {        //add small fishes
    Fishes.add(f);
  }
}