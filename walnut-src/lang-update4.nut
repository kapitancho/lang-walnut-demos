module lang-update4:

/* Case 1 - with default match */
matchTest1 = ^Integer|String => Integer :: ?whenTypeOf(#) is {
    type{Integer}: #,
    ~: 0
};

/* Case 2 - no default match but the union type of all match expressions is a subtype of the target */
matchTest2 = ^Integer|String => Integer :: ?whenTypeOf(#) is {
    type{Integer}: #,
    type{String}: 0
};

/* Case 3 - no default match (null required) */
matchTest3 = ^Integer|String => Integer|Null :: ?whenTypeOf(#) is {
    type{Integer}: #,
    type{Boolean}: 0
};

Enum4 = :[Clubs, Spades, Hearts, Diamonds];

/* Case 4 - enum type fully covered */
matchTest4 = ^Enum4 => Integer :: ?whenTypeOf(#) is {
    type{Enum4[Clubs]}: 1,
    type{Enum4[Spades, Diamonds]}: 2,
    type{Enum4[Hearts]}: 3
};

/* Case 5 - integer range type fully covered */
matchTest5 = ^Integer<1..4> => Integer :: ?whenTypeOf(#) is {
    type{Integer[1]}: 1,
    type{Integer[2, 4, 7]}: 2,
    type{Integer[3]}: 3
};

/* Case 6 - integer range type NOT fully covered */
matchTest6 = ^Integer<1..4> => Integer|Null :: ?whenTypeOf(#) is {
    type{Integer[1]}: 1,
    type{Integer[2, 7]}: 2,
    type{Integer[3]}: 3
};

/* Case 7 - integer subset type fully covered */
matchTest7 = ^Integer[1, 2, 5, 8] => Integer :: ?whenTypeOf(#) is {
    type{Integer[1]}: 1,
    type{Integer[2, 5, 7]}: 2,
    type{Integer[8]}: 3
};

/* Case 8 - integer subset type NOT fully covered */
matchTest8 = ^Integer[1, 2, 5, 8] => Integer|Null :: ?whenTypeOf(#) is {
    type{Integer[1]}: 1,
    type{Integer[2, 7]}: 2,
    type{Integer[8]}: 3
};

/* Case 9 - real subset type fully covered */
matchTest9 = ^Real[1.25, 2.9, 5, 8] => Integer :: ?whenTypeOf(#) is {
    type{Real[1.25]}: 1,
    type{Real[2.9, 5, 7]}: 2,
    type{Real[8]}: 3  /* Ideally it should support integers as well */
};

/* Case 10 - real subset type NOT fully covered */
matchTest10 = ^Real[1.25, 2.9, 5, 8] => Integer|Null :: ?whenTypeOf(#) is {
    type{Real[1.25]}: 1,
    type{Real[2.9, 7]}: 2,
    type{Real[8]}: 3
};

/* Case 11 - string subset type fully covered */
matchTest11 = ^String['', 'hello', 'world', 'hi'] => Integer :: ?whenTypeOf(#) is {
    type{String['']}: 1,
    type{String['hello', 'world', 'welcome']}: 2,
    type{String['hi']}: 3
};

/* Case 12 - real subset type NOT fully covered */
matchTest12 = ^String['', 'hello', 'world', 'hi'] => Integer|Null :: ?whenTypeOf(#) is {
    type{String['']}: 1,
    type{String['hello', 'welcome']}: 2,
    type{String['hi']}: 3
};

/* Case 13 - boolean type fully covered */
matchTest13 = ^Boolean => Integer :: ?whenTypeOf(#) is {
    type{True}: 1,
    type{False}: 2
};

/* Case 14 - integer range/subset mix fully covered */
matchTest14 = ^Integer[1, 2, 5, 8] => Integer|Null :: ?whenTypeOf(#) is {
    type{Integer<0..2>}: 1,
    type{Integer[5, 7]}: 2,
    type{Integer[8]}: 3
};

/* Case 15 - integer range/subset mix fully covered - NOT done */
matchTest15 = ^Integer<1..4> => Integer|Null :: ?whenTypeOf(#) is {
    type{Integer[1]}: 1,
    type{Integer[2, -6]}: 2,
    type{Integer<3..5>}: 3
};

/* Case 16 - range type fully covered */
matchTest16 = ^Integer<1..4> => Integer :: ?whenValueOf(#) is {
    1: 1,
    2: 4,
    3: 9,
    4: 16
};

/* Case 17 - range type NOT fully covered */
matchTest17 = ^Integer<1..4> => Integer|Null :: ?whenValueOf(#) is {
    1: 1,
    2: 4,
    15: 9,
    4: 16
};

/* Case 18 - enum type fully covered */
matchTest18 = ^Enum4 => Integer :: ?whenValueOf(#) is {
    Enum4.Clubs: 1,
    Enum4.Spades: 5,
    Enum4.Diamonds: 2,
    Enum4.Hearts: 3
};

/* Case 19 - integer subset type fully covered */
matchTest19 = ^Integer[1, 2, 5, 8] => Integer :: ?whenValueOf(#) is {
    1: 1,
    2: 2,
    5: 12,
    8: 3
};

/* Case 20 - real subset type fully covered */
matchTest20 = ^Real[1.25, 2.9, 5, 8] => Integer :: ?whenValueOf(#) is {
    1.25: 1,
    2.9: 2,
    5.0: 12,
    8.0: 3
};

/* Case 21 - string subset type fully covered */
matchTest21 = ^String['', 'hello', 'world', 'hi'] => Integer :: ?whenValueOf(#) is {
    '': 1,
    'hello': 2,
    'world': 2,
    'hi': 3
};

/* Case 22 - boolean type fully covered */
matchTest22 = ^Boolean => Integer :: ?whenValueOf(#) is {
    true: 1,
    false: 2
};

/* Case 23 - union with integer subset type fully covered */
matchTest23 = ^Null|Integer[1, 2, 5, 8] => Integer :: ?whenValueOf(#) is {
    1: 1,
    2: 2,
    5: 12,
    8: 3,
    null: 9
};

main = ^Array<String> => String :: [
    matchTest1(42),
    matchTest1('Hello'),
    matchTest2(42),
    matchTest2('Hello'),
    matchTest3(42),
    matchTest3('Hello'),
    matchTest4(Enum4.Clubs),
    matchTest5(2),
    matchTest6(2),
    matchTest7(2),
    matchTest8(5),
    matchTest9(2.9),
    matchTest10(5),
    matchTest11('hello'),
    matchTest12('world'),
    matchTest13(true),
    matchTest14(2),
    matchTest15(2),
    matchTest16(2),
    matchTest17(2),
    matchTest18(Enum4.Clubs),
    matchTest19(2),
    matchTest20(2.9),
    matchTest21('hello'),
    matchTest22(true),
    matchTest23(2)
]->printed;