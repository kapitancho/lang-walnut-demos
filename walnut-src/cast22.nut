module cast22:

Point <: [x: Real, y: Real];
PositiveInteger = Integer<1..>;
Point ==> String :: {
    ''->concatList['{', {$.x}->asString, ',', {$.y}->asString, '}']
};
Suit = :[Spades, Hearts, Diamonds, Clubs];
pi = 3.1415927;

myFn = ^Array<Any> => Any :: {
    {Point[pi, 42]}->asString
};

main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};