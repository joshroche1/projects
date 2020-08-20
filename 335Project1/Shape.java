/*

*/
package CMSC335Project1;

// import

public class Shape {
  int numberofDimensions;

  public static void main(String[] args) {

  }
}


////
////

// import

public class TwoDimensionalShape extends Shape {
  double area;
  
  public double getArea() {
    
	return area;
  }
}

public class ThreeDimensionalShape extends Shape {
  double volume;
  
  public double getVolume() {
    
	return volume;
  }
}

public class Circle extends TwoDimensionalShape {
  double radius;
  area = Math.PI * radius * radius;
}

public class Square extends TwoDimensionalShape {
  double side;
  area = side * side;
}

public class Triangle extends TwoDimensionalShape {
  double base;
  double height;
  area = (base * height) / 2;
}
public class Rectangle extends TwoDimensionalShape {
  double length;
  double width;
  area = length * width;
}

public class Sphere extends ThreeDimensionalShape {
  double radius;
  volume = ((4 * Math.PI) / 3 ) * (radius * radius * radius);
}

public class Cube extends ThreeDimensionalShape {
  double side;
  volume = side * side * side;
}

public class Cone extends ThreeDimensionalShape {
  double radius;
  double length;
  volume = ((Math.PI * radius * radius) * length) / 3;
}

public class Cylinder extends ThreeDimensionalShape {
  double radius;
  double length;
  volume = Math.PI * radius * radius * length;
}

public class Torus extends ThreeDimensionalShape {
  double majorradius;
  double minorradius;
  volume = (Math.PI * minorradius * minorradius) * (2 * Math.PI * majorradius);
}
