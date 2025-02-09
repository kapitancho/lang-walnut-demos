module cast212:

IntegerMonad = ^Integer => Integer;

timesTwo = ^Integer => Integer :: # * 2;
plusOne = ^Integer => Integer :: # + 1;
squared = ^Integer => Integer :: # * #;

composed = ^Integer => Integer :: [timesTwo, plusOne, squared]->chainInvoke(#);

NotAnInteger = :[];
dividedByThree = ^Integer => Result<Integer, NotAnInteger> :: ?whenIsTrue {
    {# % 3} == 0: {# / 3}->asInteger,
    ~: Error(NotAnInteger[])
};

PartialMonad = ^Integer => Result<Integer, NotAnInteger>;
BrokenMonad = ^Result<Integer, NotAnInteger> => Result<Integer, NotAnInteger>;
monadFixer = ^monad: PartialMonad => BrokenMonad :: {
    ^r: Result<Integer, NotAnInteger> => Result<Integer, NotAnInteger> :: ?whenTypeOf(r) is {
        type{Integer}: ?noError(monad(r)),
        type{Result<Nothing, NotAnInteger>}: r
    }
};

brokenComposed = ^i: Integer => Result<Integer, NotAnInteger> :: [
    timesTwo, plusOne, dividedByThree, squared
]->map(monadFixer)->chainInvoke(i);

myFn = ^Array<String> => Any :: [
    composed(3), composed(4), composed(5),
    brokenComposed(3), brokenComposed(4),
    brokenComposed(5), brokenComposed(6),
    brokenComposed(7), brokenComposed(8),
    brokenComposed(9), brokenComposed(10)
];

main = ^args: Array<String> => String :: {
    x = myFn(args);
    x->printed
};