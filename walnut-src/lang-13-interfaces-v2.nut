module lang-13-interfaces-v2:
/* A Walnut-Lang implementation of https://github.com/gabrieldim/Go-Crash-Course/blob/main/13_interfaces/main.go */

PositiveReal = Real<0..>;

Circle <: [x: Real, y: Real, radius: PositiveReal];

Rectangle <: [width: PositiveReal, height: PositiveReal];

Circle->area(^Null => PositiveReal) :: 3.1416 * $.radius * $.radius;
Rectangle->area(^Null => PositiveReal) :: $.width * $.height;

getArea = ^Circle|Rectangle => PositiveReal :: #->area;

main = ^Any => String :: {
    circle = Circle[x: 0, y: 0, radius: 7];
    rectangle = Rectangle[width: 10, height: 7];

    [
        getArea(circle),
        getArea(rectangle)
    ]->printed
};