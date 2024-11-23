module lang-13-interfaces:
/* A Walnut-Lang implementation of https://github.com/gabrieldim/Go-Crash-Course/blob/main/13_interfaces/main.go */

PositiveReal = Real<0..>;

Shape = [area: ^Null => PositiveReal];

Circle <: [x: Real, y: Real, radius: PositiveReal];

Rectangle <: [width: PositiveReal, height: PositiveReal];

Circle ==> Shape :: [
    area: ^Null => PositiveReal :: 3.1416 * $.radius * $.radius
];

Rectangle ==> Shape :: [
    area: ^Null => PositiveReal :: $.width * $.height
];

getArea = ^Shape => PositiveReal :: #.area(null);

main = ^Any => String :: {
    circle = Circle[x: 0, y: 0, radius: 7];
    rectangle = Rectangle[width: 10, height: 7];

    [
        getArea(circle->asShape),
        getArea(rectangle->asShape)
    ]->printed
};