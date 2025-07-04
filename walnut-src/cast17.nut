module cast17:

Point := #[x: Real, y: Real];
Point3d := #[Real, Real, Real];
ProductId := #Integer<1..>;

fn = ^[a: String, b: Integer<0..>] => String :: {
    #.a->substringRange([start: #.b, end: #.a->length])
};

myFn = ^Array<String> => Any :: {
    [
        fn['Hello!', 3],
        fn[a: 'How are you?', b: 2],
        #->insertFirst['A'],
        #->insertFirst('A'),
        Point[3.14, 42],
        Point[x: 3.14, y: 42],
        Point3d[1, 2.71, 1.618],
        ProductId(13)
    ]
};

main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};