module cast26:

Suit := (Spades, Hearts, Clubs, Diamonds);

Point := #[x: Real, y: Real];

InvalidProductId := #Any;
ProductId = Integer<1..>;

InvalidProductName := #Any;
ProductName = String<1..>;
Product := #[~ProductId, ~ProductName, tags: Array<String>];

R1 = [a: Integer, b: Real];
R2 = [a: Real, c: String, d: Boolean];
R3 = R1 & R2;

IntegerOrString = Integer|String;
IntegerOrStringType = Type<IntegerOrString>;
RealType = Type<Real>;
RealRealIntegerTuple = [Real, Real, Integer];

OneToFive = Integer<1..5>;
Percent = Real<0..100>;

CompanyName = String<2..30>;

ShortListOfReals = Array<Real, 1..5>;
ListOfDigits = Array<Integer<0..9>, 1..5>;

ShortDictOfReals = Map<Real, 1..5>;
DictOfDigits = Map<Integer<0..9>, 1..5>;

RealRealIntTuple = [Real, Real, Integer];
RealRealIntRecord = [a: Real, b: Real, c: Integer];

MutableInteger = Mutable<Integer>;

hydrateAs = ^[value: JsonValue, type: Type] => Result<Any, HydrationError> :: {
    #.value->hydrateAs(#.type)
};

hydrateAs3 = ^[value: JsonValue, type: Type] => Result<Any, HydrationError> :: {
    hydrateAs[[3.14, 2, -100], type{RealRealIntegerTuple}]
};

A := #Integer;
B := #A;

t = ^[x: Integer] => ^[y: Integer] => Integer :: {
    x = #.x;
    ^[y: Integer] => Integer :: {
        x + #.y
    }
};

myFn = ^Array<String> => Any :: {
    p = hydrateAs[[productId: 15, productName: 'My Product', tags: ['seasonal', 'clothing']], type{Product}];
    [
        a0: hydrateAs[159, `Any],
        i1: hydrateAs[1, `Integer],
        i2: hydrateAs[1.4, `Integer],
        i3: hydrateAs[3, `OneToFive],
        i4: hydrateAs[13, `OneToFive],
        r1: hydrateAs[1, `Real],
        r2: hydrateAs['Welcome', `Real],
        r3: hydrateAs[3.14, `Percent],
        r4: hydrateAs[103.9, `Percent],
        s1: hydrateAs['Hello', `String],
        s2: hydrateAs[3.14, `String],
        s3: hydrateAs['X', `CompanyName],
        s4: hydrateAs['My Company Ltd', `CompanyName],
        b1: hydrateAs[true, `Boolean],
        b2: hydrateAs[false, `Boolean],
        b3: hydrateAs[3.14, `Boolean],
        t1: hydrateAs[true, `True],
        t2: hydrateAs[false, `True],
        t3: hydrateAs[3.14, `True],
        f1: hydrateAs[true, `False],
        f2: hydrateAs[false, `False],
        f3: hydrateAs[3.14, `False],
        n1: hydrateAs[null, `Null],
        n2: hydrateAs[3.14, `Null],
        a1: hydrateAs[[3.14, 2, -100], `Array],
        a2: hydrateAs[[a: 3.14, b: 2, c: -100], `Array],
        ar1: hydrateAs[[3.14, 2, -100], `ShortListOfReals],
        ar2: hydrateAs[[3.14, 2, -100, 1.23, 1.25, 2.99], `ShortListOfReals],
        ar3: hydrateAs[[3.14, 2, -100, 'Hello', 4.44], `ShortListOfReals],
        ai1: hydrateAs[[5, 2, 0], `ListOfDigits],
        ai2: hydrateAs[[5, 2, 11], `ListOfDigits],
        ai3: hydrateAs[[3.14, 2, 5], `ListOfDigits],
        ai4: hydrateAs[[3, 2, 5, 1, 4, 7], `ListOfDigits],
        m1: hydrateAs[[a: 3.14, b: 2, c: -100], `Map],
        m2: hydrateAs[[3.14, 2, -100], `Map],
        mr1: hydrateAs[[a: 3.14, b: 2, c: -100], `ShortDictOfReals],
        mr2: hydrateAs[[a: 3.14, b: 2, c: -100, d: 1.23, e: 1.25, f: 2.99], `ShortDictOfReals],
        mr3: hydrateAs[[a: 3.14, b: 2, c: -100, d: 'Hello', e: 4.44], `ShortDictOfReals],
        mi1: hydrateAs[[a: 5, b: 2, c: 0], `DictOfDigits],
        mi2: hydrateAs[[a: 5, b: 2, c: 11], `DictOfDigits],
        mi3: hydrateAs[[a: 3.14, b: 2, c: 5], `DictOfDigits],
        mi4: hydrateAs[[a: 3, b: 2, c: 5, d: 1, e: 4, f: 7], `DictOfDigits],
        mi5: hydrateAs[[a: 5, b: 2, c: 0], `Map<Integer<0..9>, 1..5>],

        tu1: hydrateAs[[3.14, 2, -100], `RealRealIntTuple],
        tu2: hydrateAs[[3.14, 2, 3.14], `RealRealIntTuple],
        tu3: hydrateAs[[3.14, 2, 3, 5], `RealRealIntTuple],
        tu4: hydrateAs[[3.14, 2], `RealRealIntTuple],
        tu5: hydrateAs[[a: 3.14, b: 2], `RealRealIntTuple],

        tu6: hydrateAs[[3.14, 2, -100], type[Real, Real, Integer]],

        re1: hydrateAs[[a: 3.14, b: 2, c: -100], `RealRealIntRecord],
        re2: hydrateAs[[a: 3.14, b: 2, c: 3.14], `RealRealIntRecord],
        re3: hydrateAs[[a: 3.14, b: 2, c: 3, d: 5], `RealRealIntRecord],
        re4: hydrateAs[[a: 3.14, b: 2], `RealRealIntRecord],
        re5: hydrateAs[[3.14, 2], `RealRealIntRecord],

        re6: hydrateAs[[a: 3.14, b: 2, c: -100], type[a: Real, b: Real, c: Integer]],

        mu1: hydrateAs[15, `MutableInteger],
        mu2: hydrateAs[15, `Mutable<Integer>],

        st1: hydrateAs[[x: 15, y: 3.14], `Point],
        st2: p,
        st2x1: p->as(`JsonValue),
        /*st2x2: {p->as(`JsonValue)}->stringify,
        st2x3: {{p->as(`JsonValue)}->stringify}->jsonDecode,
        st2x4: hydrateAs[?noError({{p->as(`JsonValue)}->stringify}->jsonDecode), `Product],*/

        is1: hydrateAs[[a: 3, b: 3.14, c: 'Hello', d: true], `R3],
        un1: hydrateAs[120, `IntegerOrString],
        un2: hydrateAs['Hello', `IntegerOrString],
        un3: hydrateAs[3.14, `IntegerOrString],

        en1: hydrateAs['Clubs', `Suit],
        en2: hydrateAs['Ace', `Suit],
        en3: hydrateAs[3.14, `Suit],

        ty1: hydrateAs['IntegerOrString', `Type],
        ty2: hydrateAs['Banana', `Type],
        ty3: hydrateAs['Integer', `RealType],
        ty4: hydrateAs['Real', `RealType],
        ty5: hydrateAs['String', `RealType],

        ty6: hydrateAs['Integer', `IntegerOrStringType],
        ty7: hydrateAs['Real', `IntegerOrStringType],
        ty8: hydrateAs['String', `IntegerOrStringType],


        ix1: hydrateAs[15, `Integer<2..20>],
        ix2: hydrateAs[[5], `[Any]],
        t1 : {t[3]}[4],

        su1 : 1,
        su2 : A(1),
        su3 : B(A(1)),
        su4 : A(1)->value,
        su5 : B(A(1))->value,
        su6 : B(A(1))->value->value
    ]
};
main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};