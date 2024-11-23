module cast25:

Point <: [x: Real, y: Real];

Point ==> Boolean :: {
    {$.x != 0} || {$.y != 0}
};

FileExists <: Boolean;

gugu = ^Integer|String => Boolean :: {
    #->asBoolean
};

meme = ^[Integer, Real] => Real :: {
    {#.0} + {#.1}
};

myFn = ^Array<String> => Any :: {
    p = Point[1, 2];
    q = Point[0, 0];
    r = Point[0, 3.14];
    t = ?whenIsTrue { p: 'Yes', ~: 'No' };
    u = ?whenIsTrue { q: 'Yes', ~: 'No' };
    v = ?whenIsTrue { r: 'Yes', ~: 'No' };
    w = ?whenIsTrue {
        q : 1,
        p : 3.14,
        ~ : 42
    };
    f = FileExists(true);
    g = FileExists(false);

    [p, q, r, t, u, v, w, p->asBoolean, q->as(type{Boolean}), f, g, gugu(0), gugu(''), gugu(-1), gugu('hi!'), meme[1, 3.14]]
};
main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};