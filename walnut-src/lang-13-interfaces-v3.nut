module lang-13-interfaces-v3:
/* A Walnut-Lang implementation of https://github.com/gabrieldim/Go-Crash-Course/blob/main/13_interfaces/main.go */

Figure = [area: ^Null => PositiveReal];

Circle := [x: Real, y: Real, radius: PositiveReal];
Rectangle := [width: PositiveReal, height: PositiveReal];

Circle ==> Figure :: [
    area: ^ => PositiveReal :: 3.1416 * $radius * $radius
];

Rectangle ==> Figure :: [
    area: ^ => PositiveReal :: $width * $height
];

getArea = ^f: Shape<Figure> => PositiveReal :: f->shape(`Figure).area();

main = ^Any => String :: {
    circle = Circle![x: 0, y: 0, radius: 7];
    rectangle = Rectangle![width: 10, height: 7];

    [
        getArea(circle),
        getArea(rectangle)
    ]->printed
};