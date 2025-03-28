module cast14:
/* Figure examples with an "interface" and three implementations. */

Figure = [
    area: ^Null => Real
];

Square = #[sideLength: Real];
Square ==> Figure :: [
    area: ^Null => Real :: $sideLength * $sideLength
];

Rectangle = #[width: Real, height: Real];
Rectangle ==> Figure :: [
    area: ^Null => Real :: $width * $height
];
Square ==> Rectangle :: Rectangle([$sideLength, $sideLength]);

Circle = #[radius: Real];
Circle ==> Figure :: [
    area: ^Null => Real :: $radius * $radius * 3.1415927
];

calculateArea = ^figure: Shape<Figure> => [String, Real] :: [figure->type->asString, figure->shape(`Figure).area()];

longestSide = ^Rectangle => Real :: {
    {[#.width, #.height]}->max
};

myFn = ^Array<String> => Any :: {
    sq = Square[12];
    ci = Circle[6];
    re = Rectangle[8, 18];
    s = type{Figure};
    [
        sq->as(type{Figure}).area(),
        ci->as(s).area(),
        re->as(s).area(),
        longestSide(re),
        longestSide(sq->as(type{Rectangle})),
        sq->as(re->type),
        calculateArea(sq),
        calculateArea(ci),
        calculateArea(re)
    ]
};

main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};