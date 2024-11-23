module cast14:

Shape = [
    area: ^Null => Real
];

Square <: [sideLength: Real];
Square ==> Shape :: [
    area: ^Null => Real :: $.sideLength * $.sideLength
];

Rectangle <: [width: Real, height: Real];
Rectangle ==> Shape :: [
    area: ^Null => Real :: $.width * $.height
];
Square ==> Rectangle :: Rectangle([$.sideLength, $.sideLength]);

Circle <: [radius: Real];
Circle ==> Shape :: [
    area: ^Null => Real :: $.radius * $.radius * 3.1415927
];

longestSide = ^Rectangle => Real :: {
    {[#.width, #.height]}->max
};

myFn = ^Array<String> => Any :: {
    sq = Square[12];
    ci = Circle[6];
    re = Rectangle[8, 18];
    s = type{Shape};
    [
        sq->as(type{Shape}).area(),
        ci->as(s).area(),
        re->as(s).area(),
        longestSide(re),
        longestSide(sq->as(type{Rectangle})),
        sq->as(re->type)
    ]
};

main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};