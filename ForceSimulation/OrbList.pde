class OrbList {

  OrbNode front;

  OrbList() {
    front = null;
  }//constructor

  void addFront(OrbNode o) {
    //insert o to the beginning of the list
    if (front == null) {
      front = o;
    } else {
      o.next = front;
      front.previous = o;
      front = o;
    }
  }//addFront

  void populate(int n, boolean ordered) {
    front = null; //clears list
    
    //adds n number of randomly generated orbs to the list
    for (int i = 0; i < n; i++) {
      OrbNode newNode = new OrbNode();
      
      //if ordered, all orbs have same y coordinate, if not, coordinates already randomized
      if (ordered) {
        newNode.center.x = SPRING_LENGTH * i + 50;
        newNode.center.y = height / 2;
      }
      
      addFront(newNode); //creates the nodes
    }
  }//populate

  void display() {
    //goes through linked list and displays all orb nodes with a while loop
    OrbNode current = front;
    while (current != null) {
      current.display();
      current = current.next;
    }
  }//display

  void applySprings(int springLength, float springK) {
    //goes through linked list and applies spring force on neighboring nodes in the linked list
    OrbNode current = front;
    while (current != null) {
      current.applySprings(springLength, springK);
      current = current.next;
    }
  }//applySprings
  
  void applyGravity(Orb other, float gConstant) {
    //goes through linked list and applies gravity on all nodes
    OrbNode current = front;
    while (current != null) {
      PVector gForce = current.getGravity(other, gConstant);
      current.applyForce(gForce);
      current = current.next;
    }
  }//applySprings

  void run(boolean bounce) {
    //if bounce is true, allow the orbs to bounce off the boundaries of the program
    OrbNode current = front;
    while (current != null) {
      current.move(bounce);
      current = current.next;
    }
  }//applySprings

  void removeFront() {
    //removes the element at the front of the list
    if (front.next != null) {
      OrbNode nextNode = front.next;
      nextNode.previous = null;
      front = nextNode;
    }
  }//removeFront

  OrbNode getSelected(int x, int y) {
    //gets the node that is located at the input x and y values (in this case, mouseX and mouseY)
    OrbNode current = front;
    while (current.next != null) {
      if (current.isSelected(x, y)) {
        return current;
      }
      current = current.next;
    }
    return null;
  }//getSelected

  void removeNode(OrbNode o) {
    //removes the node that is inputted into the method (in this case, the selected node at mouseX and mouseY)
    if (o == front) {
      removeFront();
    } else {
      if (o.previous != null) {
        o.previous.next = o.next;
      }
      if (o.next != null) {
        o.next.previous = o.previous;
      }
    }
  }
}//OrbList
