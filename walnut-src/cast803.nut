module cast803:

MyError = :[];
v = ^Integer => Result<Integer, MyError> :: ?whenTypeOf(#) is { type{Integer<1..>}: # - 1, ~: @MyError() };

impure0 = ^Integer => *Nothing :: @MyError() *> ('External error '->concat(#->asString));
impure1 = ^Integer => Impure<Integer> :: impure0(#);
impure2 = ^Integer => *Integer :: impure0(#);
impure3 = ^Integer => Result<Integer, ExternalError> :: impure0(#);

impure4 = ^[a: Integer, b: Integer] => *Integer :: {impure1 |> invoke (#a)} + {impure2 |> invoke (#b)};

impure10 = ^Integer => *Result<Nothing, MyError> :: @MyError() /* *> ('External error '->concat(#->asString)) */;
impure11 = ^Integer => Impure<Result<Integer, MyError>> :: impure10(#);
impure12 = ^Integer => *Result<Integer, MyError> :: impure10(#);
impure13 = ^Integer => Result<Integer, MyError|ExternalError> :: impure10(#);

impure14 = ^[a: Integer, b: Integer] => *Result<Integer, MyError> :: {impure11 => invoke (#a)} + {impure12 => invoke (#b)};

myFn = ^Any => Any :: {
    [
        [1, 5, 10]->map(v),
        [2, -3, 7]->map(v),
        impure1(1),
        impure2(2),
        impure3(3),
        impure4[4, -4],
        impure11(1),
        impure12(2),
        impure13(3),
        impure14[4, -4]
    ]
};

main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};