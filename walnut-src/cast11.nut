module cast11:

NotAnOddInteger = :[];
oddInteger = ^Integer => Result<Integer, NotAnOddInteger> :: {
    ?whenValueOf(# % 2) is {
        1: #,
        ~: Error(NotAnOddInteger[])
    }
};
OddInteger <: Integer @ NotAnOddInteger :: {
    ?whenValueOf(# % 2) is {
        1: #,
        ~: Error(NotAnOddInteger[])
    }
};

max = ^[a: Integer, b: Integer] => Integer :: #.a;
max2 = ^[Integer, Integer] => Integer :: #.0;

InvalidRange = :[];
Range <: [from: Integer, to: Integer] @ InvalidRange :: {
    ?whenIsTrue {
        #.from < #.to: #,
        ~: Error(InvalidRange[])
    }
};
Range2 <: [Integer, Integer] @ InvalidRange :: {
    ?whenIsTrue {
        #.0 < #.1: #,
        ~: Error(InvalidRange[])
    }
};
FromTo = [from: Integer, to: Integer];
Range3 <: FromTo @ InvalidRange :: {
    ?whenIsTrue {
        #.from < #.to: #,
        ~: Error(InvalidRange[])
    }
};

myFn = ^Array<String> => Any :: [
    oddInteger(5),
    OddInteger(5),
    Range([14, 23]),
    Range2([14, 23]),
    Range3([from: 14, to: 23]),
    max([3, 5]),
    max2([3, 5])
];

main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};