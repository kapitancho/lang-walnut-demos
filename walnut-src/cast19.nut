module cast19:

Point <: [x: Real, y: Real];
Point2 <: [x: Integer<0..200>, y: Integer<-3000..10>];

Point ==> String :: {
    ''->concatList['{', $.x->asString, ',', $.y->asString, '}']
};

Point->invoke(^Real => Point) :: {
    Point[$.x * #, $.y * #]
};

pointToString = ^Point => String/*<5..2211>*/ :: {
    ''->concatList['{', #.x->asString, ',', #.y->asString, '}']
};

fn = ^Integer<1..40> => Point :: {
    Point[#, # * 2]
};

Z1 = String<10..30>;
Z2 = Array<String, 5..100>;
Z3 = Map<String<1..10>, 5..100>;
Z4 = Integer<10..30>;
Z5 = Real<3.14..5.13>;

myFn = ^Array<String> => Any :: {
    p = Point[4, 7];
    [
        fn(20)->asString,
        pointToString(Point[4, 7]),
        {['A', 'B', 'C']}->combineAsString(', '),
        p(5)
    ]
};

main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};