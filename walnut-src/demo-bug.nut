module demo-bug:

Amount = Real;
Currency := (Euro, Dollar, Yen);
WestCurrency = Currency[Euro, Dollar];

/* Support for JSON to Currency conversion */
InvalidCurrency := (); /* An Atom that represents an invalid currency */
JsonValue ==> Currency @ InvalidCurrency :: ?whenValueOf($) is {
    'EUR': Currency.Euro,
    'USD': Currency.Dollar,
    'JPY': Currency.Yen,
    ~: @InvalidCurrency
};

/* Money is a record with two fields: currency and amount */
Money := #[~Currency, ~Amount];
Money ==> String :: {$currency->asString} + $amount->asString;

MyAtom := ();
InvalidAtom := ();
JsonValue ==> MyAtom @ InvalidAtom :: ?whenTypeOf($) is {
    type{Null}: MyAtom,
    ~ : @InvalidAtom
};

InvalidPoint := ();
Point := #[x: Real, y: Real] @ InvalidPoint :: ?whenValueOf([#x, #y]) is { [0, 0]: => @InvalidPoint };
JsonValue ==> Point @ InvalidPoint :: ?whenTypeOf($) is {
    type[x: Real, y: Real]: Point[$.x, $.y],
    ~ : @InvalidPoint
};

InvalidPoint3d := ();
Point3d := $[x: Real, y: Real, z: Real] @ InvalidPoint3d :: ?whenValueOf([#x, #y, #z]) is { [0, 0, 0]: => @InvalidPoint3d };
JsonValue ==> Point3d @ InvalidPoint3d :: ?whenTypeOf($) is {
    type[x: Real, y: Real, z: Real]: Point3d[$.x, $.y, $.z],
    ~ : @InvalidPoint3d
};

main = ^Array<String> => String :: {
    myImportedMoney = [currency: 'EUR', amount: 3.14]->hydrateAs(`Money);
    myInvalidMoney = [currency: 'XXX', amount: 3.14]->hydrateAs(`Money);
    myInvalidCurrency = 'XYZ'->hydrateAs(`Currency);
    myWestCurrency = 'EUR'->hydrateAs(`WestCurrency);
    myNonWestCurrency = 'JPY'->hydrateAs(`WestCurrency);
    myInvalidWestCurrency = 'XYZ'->hydrateAs(`WestCurrency);
    myPoint = [x: 3.14, y: 2.71]->hydrateAs(`Point);
    myZeroPoint = [x: 0, y: 0]->hydrateAs(`Point);
    myInvalidPoint = [x: 3.14, z: 2.71]->hydrateAs(`Point);
    myPoint3d = [x: 3.14, y: 2.71, z: 1.41]->hydrateAs(`Point3d);
    myZeroPoint3d = [x: 0, y: 0, z: 0]->hydrateAs(`Point3d);
    myInvalidPoint3d = [x: 3.14, y: 2.71]->hydrateAs(`Point3d);
    myAtom = null->hydrateAs(`MyAtom);
    myInvalidAtom = 'hello'->hydrateAs(`MyAtom);
    [
        importedMoney: myImportedMoney,
        invalidCurrency: myInvalidCurrency,
        invalidMoney: myInvalidMoney,
        westCurrency: myWestCurrency,
        nonWestCurrency: myNonWestCurrency,
        invalidWestCurrency: myInvalidWestCurrency,
        point: myPoint,
        zeroPoint: myZeroPoint,
        invalidPoint: myInvalidPoint,
        point3d: myPoint3d,
        zeroPoint3d: myZeroPoint3d,
        invalidPoint3d: myInvalidPoint3d,
        atom: myAtom,
        invalidAtom: myInvalidAtom
    ]->printed
};