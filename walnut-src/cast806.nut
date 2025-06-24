module cast806:

MyInteger := #Integer;
MyReal := #Real;
MyString := #String;
MyNull := #Null;
MyBoolean := #Boolean;
MyArray := #Array;
MyMap := #Map;
MyMutable := #Mutable;

i1 = ^Integer => Any :: #->hydrateAs(type{MyInteger});
i2 = ^Any => Any :: 5->hydrateAs(type{MyInteger});
r1 = ^Real => Any :: #->hydrateAs(type{MyReal});
r2 = ^Any => Any :: 3.14->hydrateAs(type{MyReal});
s1 = ^String => Any :: #->hydrateAs(type{MyString});
s2 = ^Any => Any :: 'hello world'->hydrateAs(type{MyString});
n1 = ^Null => Any :: #->hydrateAs(type{MyNull});
n2 = ^Any => Any :: null->hydrateAs(type{MyNull});
b1 = ^Boolean => Any :: #->hydrateAs(type{MyBoolean});
b2 = ^Any => Any :: true->hydrateAs(type{MyBoolean});
b3 = ^Any => Any :: false->hydrateAs(type{MyBoolean});
a1 = ^Array<Integer> => Any :: #->hydrateAs(type{MyArray});
a2 = ^Any => Any :: [1, 2, 3]->hydrateAs(type{MyArray});
m1 = ^Map<Integer> => Any :: #->hydrateAs(type{MyMap});
m2 = ^Any => Any :: [a: 1, b: 2]->hydrateAs(type{MyMap});
v1 = ^Mutable<Real> => Any :: #->hydrateAs(type{MyMutable});
v2 = ^Any => Any :: mutable{Integer, 42}->hydrateAs(type{MyMutable});

Q := ();

myFn = ^Any => Any :: [
    i1(42), i2(), r1(-2.71), r2(), s1('hello'),
    s2(), n1(), n2(), b1(true), b2(), b3(),
    a1([]), a2(), m1([:]), m2(), v1(mutable{Real, 3.14}), v2(),
    999->stringify
];

main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};