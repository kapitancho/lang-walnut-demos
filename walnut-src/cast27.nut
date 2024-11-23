module cast26:

Suit = :[Spades, Hearts, Clubs, Diamonds];

Point <: [x: Real, y: Real];

InvalidProductId <: Any;
ProductId = Integer<1..>;

InvalidProductName <: Any;
ProductName = String<1..>;
Product <: [~ProductId, ~ProductName, tags: Array<String>];

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

A <: Integer;
B <: A;

t = ^[x: Integer] => ^[y: Integer] => Integer :: {
    x = #.x;
    ^[y: Integer] => Integer :: {
        x + #.y
    }
};

myFn = ^Array<String> => Any :: {
    p = hydrateAs[[productId: 15, productName: 'My Product', tags: ['seasonal', 'clothing']], type{Product}];
    [
        a0: hydrateAs[159, type{Any}],
        i1: hydrateAs[1, type{Integer}],
        i2: hydrateAs[1.4, type{Integer}],
        i3: hydrateAs[3, type{OneToFive}],
        i4: hydrateAs[13, type{OneToFive}],
        r1: hydrateAs[1, type{Real}],
        r2: hydrateAs['Welcome', type{Real}],
        r3: hydrateAs[3.14, type{Percent}],
        r4: hydrateAs[103.9, type{Percent}],
        s1: hydrateAs['Hello', type{String}],
        s2: hydrateAs[3.14, type{String}],
        s3: hydrateAs['X', type{CompanyName}],
        s4: hydrateAs['My Company Ltd', type{CompanyName}],
        b1: hydrateAs[true, type{Boolean}],
        b2: hydrateAs[false, type{Boolean}],
        b3: hydrateAs[3.14, type{Boolean}],
        t1: hydrateAs[true, type{True}],
        t2: hydrateAs[false, type{True}],
        t3: hydrateAs[3.14, type{True}],
        f1: hydrateAs[true, type{False}],
        f2: hydrateAs[false, type{False}],
        f3: hydrateAs[3.14, type{False}],
        n1: hydrateAs[null, type{Null}],
        n2: hydrateAs[3.14, type{Null}],
        a1: hydrateAs[[3.14, 2, -100], type{Array}],
        a2: hydrateAs[[a: 3.14, b: 2, c: -100], type{Array}],
        ar1: hydrateAs[[3.14, 2, -100], type{ShortListOfReals}],
        ar2: hydrateAs[[3.14, 2, -100, 1.23, 1.25, 2.99], type{ShortListOfReals}],
        ar3: hydrateAs[[3.14, 2, -100, 'Hello', 4.44], type{ShortListOfReals}],
        ai1: hydrateAs[[5, 2, 0], type{ListOfDigits}],
        ai2: hydrateAs[[5, 2, 11], type{ListOfDigits}],
        ai3: hydrateAs[[3.14, 2, 5], type{ListOfDigits}],
        ai4: hydrateAs[[3, 2, 5, 1, 4, 7], type{ListOfDigits}],
        m1: hydrateAs[[a: 3.14, b: 2, c: -100], type{Map}],
        m2: hydrateAs[[3.14, 2, -100], type{Map}],
        mr1: hydrateAs[[a: 3.14, b: 2, c: -100], type{ShortDictOfReals}],
        mr2: hydrateAs[[a: 3.14, b: 2, c: -100, d: 1.23, e: 1.25, f: 2.99], type{ShortDictOfReals}],
        mr3: hydrateAs[[a: 3.14, b: 2, c: -100, d: 'Hello', e: 4.44], type{ShortDictOfReals}],
        mi1: hydrateAs[[a: 5, b: 2, c: 0], type{DictOfDigits}],
        mi2: hydrateAs[[a: 5, b: 2, c: 11], type{DictOfDigits}],
        mi3: hydrateAs[[a: 3.14, b: 2, c: 5], type{DictOfDigits}],
        mi4: hydrateAs[[a: 3, b: 2, c: 5, d: 1, e: 4, f: 7], type{DictOfDigits}],
        mi5: hydrateAs[[a: 5, b: 2, c: 0], type{Map<Integer<0..9>, 1..5>}],

        tu1: hydrateAs[[3.14, 2, -100], type{RealRealIntTuple}],
        tu2: hydrateAs[[3.14, 2, 3.14], type{RealRealIntTuple}],
        tu3: hydrateAs[[3.14, 2, 3, 5], type{RealRealIntTuple}],
        tu4: hydrateAs[[3.14, 2], type{RealRealIntTuple}],
        tu5: hydrateAs[[a: 3.14, b: 2], type{RealRealIntTuple}],

        tu6: hydrateAs[[3.14, 2, -100], type[Real, Real, Integer]],

        re1: hydrateAs[[a: 3.14, b: 2, c: -100], type{RealRealIntRecord}],
        re2: hydrateAs[[a: 3.14, b: 2, c: 3.14], type{RealRealIntRecord}],
        re3: hydrateAs[[a: 3.14, b: 2, c: 3, d: 5], type{RealRealIntRecord}],
        re4: hydrateAs[[a: 3.14, b: 2], type{RealRealIntRecord}],
        re5: hydrateAs[[3.14, 2], type{RealRealIntRecord}],

        re6: hydrateAs[[a: 3.14, b: 2, c: -100], type[a: Real, b: Real, c: Integer]],

        mu1: hydrateAs[15, type{MutableInteger}],
        mu2: hydrateAs[15, type{Mutable<Integer>}],

        st1: hydrateAs[[x: 15, y: 3.14], type{Point}],
        st2: p,
        st2x1: p->as(type{JsonValue}),
        st2x2: {p->as(type{JsonValue})}->stringify,
        st2x3: {{p->as(type{JsonValue})}->stringify}->jsonDecode,
        st2x4: hydrateAs[?noError({{p->as(type{JsonValue})}->stringify}->jsonDecode), type{Product}],

        is1: hydrateAs[[a: 3, b: 3.14, c: 'Hello', d: true], type{R3}],
        un1: hydrateAs[120, type{IntegerOrString}],
        un2: hydrateAs['Hello', type{IntegerOrString}],
        un3: hydrateAs[3.14, type{IntegerOrString}],

        en1: hydrateAs['Clubs', type{Suit}],
        en2: hydrateAs['Ace', type{Suit}],
        en3: hydrateAs[3.14, type{Suit}],

        ty1: hydrateAs['IntegerOrString', type{Type}],
        ty2: hydrateAs['Banana', type{Type}],
        ty3: hydrateAs['Integer', type{RealType}],
        ty4: hydrateAs['Real', type{RealType}],
        ty5: hydrateAs['String', type{RealType}],

        ty6: hydrateAs['Integer', type{IntegerOrStringType}],
        ty7: hydrateAs['Real', type{IntegerOrStringType}],
        ty8: hydrateAs['String', type{IntegerOrStringType}],


        ix1: hydrateAs[15, type{Integer<2..20>}],
        ix2: hydrateAs[[5], type{[Any]}],
        t1 : {t[3]}[4],

        su1 : 1,
        su2 : A(1),
        su3 : B(A(1)),
        su4 : A(1)->baseValue,
        su5 : B(A(1))->baseValue,
        su6 : B(A(1))->baseValue->baseValue
    ]
};
main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};