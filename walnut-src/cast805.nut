module cast805:


MyType := $[a: String, b: ?Integer, c: Real];

MyType->a(=> String) :: $a;
MyType->b(=> Result<Integer, MapItemNotFound>) :: ?noError($b) + 1;

MyType->s(=> Result<String, InvalidJsonValue>) :: $ => asJsonValue -> stringify;

XType := #[a: String, b: ?Integer, c: Real];
n = ^XType => String :: #a;
r = ^XType => Result<Integer, MapItemNotFound> :: ?noError(#b) + 1;

p = ^Null => String %% XType :: %a;
s = ^Null => Result<Integer, MapItemNotFound> %% XType :: ?noError(%b) + 1;

u = ^Null => String %% [~XType] :: %xType.a;
w = ^Null => Result<Integer, MapItemNotFound> %% [~XType] :: ?noError(%xType.b) + 1;

/*==> XType :: XType[a: 'Hello', b: -37, c: 3.14];*/
==> XType :: XType[a: 'World', c: 9.99];

myFn = ^Any => Any :: {
    m = MyType[a: 'Hello', b: -37, c: 3.14];
    t = MyType[a: 'World', c: 9.99];

    x = XType[a: 'Hello', b: -37, c: 3.14];
    y = XType[a: 'World', c: 9.99];
    [
        m, m->a, m->b, m->s,
        t, t->a, t->b, t->s,
        n(x), r(x),
        n(y), r(y),
        p(), s(),
        u(), w()
    ]
};

main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};