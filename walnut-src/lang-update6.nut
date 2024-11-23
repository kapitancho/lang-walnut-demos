module lang-update6:

/*main = ^Array<String> => String :: 'hi'->length + 3;*/
/*main = ^Array<String> => String :: #->xqs(b)->ywt(c) * ->printed;*/

main = ^Array<String> => String :: [
    111 - 222 - 333,
    2 + 3 * 4,
    2 * 3 + 4,
    3 * 4 ^ 5,
    3 ^ 4 * 5,
    3 + 4 < 7,
    1 + 2 * 3 + 4 * 5 + 6,
    false && false || true,
    true || false && false,
    /*3 + 4 < 7 && -5 / 2 > 0 || 5 - 3 <= 2,*/
    [12 <= 13, 15 <= 15, 16 <= 15, 12 >= 13, 15 >= 15, 16 > 15]
]->printed;
/*
T = Integer|String|Boolean;
testOp = ^Null => Any :: 1 - 2 - 3;
testMethodChain = ^Null => Any :: 'a'->reverse->length;
testPropertyChain = ^Null => Any :: [a: [b: 1]].a.b;

Sub <: Integer<1..10>;
OneDigitPrime = Integer[2, 3, 5, 7];
FamousRealNumber = Real[3.14159, 2.71828];
HelloWorld = String['Hello', 'World'];
Suit = :[Hearts, Diamonds, Clubs, Spades];
BlackSuit = Suit[Clubs, Spades];

callMe = ^Null => Any :: 1;
testFn = ^Null => Any :: [
    ?whenValueOf(#) is { 1: 'One', ~: 'Not One' },
    ?whenTypeOf(#) is { type{Integer}: 'Integer', ~: 'Not Integer' },
    ?whenIsTrue { #: 'True', ~: => 'False' },
    { ?noError(#); x = #; x },
    Error(#),
    callMe(),
    'hello'->length,
    [1, [a: 2]].1.a
]->printed;

main = ^Array<String> => String :: [
    type{T},
    testOp(),
    testMethodChain(),
    testPropertyChain()
]->printed;
*/