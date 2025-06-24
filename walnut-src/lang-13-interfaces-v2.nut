module lang-13-interfaces-v2:
/* A Walnut-Lang implementation of https://github.com/gabrieldim/Go-Crash-Course/blob/main/13_interfaces/main.go */

Circle := [x: Real, y: Real, radius: PositiveReal];
Rectangle := [width: PositiveReal, height: PositiveReal];

Circle->area(=> PositiveReal) :: 3.1416 * $radius * $radius;
Rectangle->area(=> PositiveReal) :: $width * $height;

getArea = ^f: Circle|Rectangle => PositiveReal :: f->area;

main = ^Any => String :: {
    circle = Circle![x: 0, y: 0, radius: 7];
    rectangle = Rectangle![width: 10, height: 7];

    [
        getArea(circle),
        getArea(rectangle)
    ]->printed
};