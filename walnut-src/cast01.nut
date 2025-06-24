module cast01:

S = String;

fn = ^Any => Any :: [
    ?when(#) { 1; 3 } ~ { 2; 4 },
    ?when(#) { 1; 3 },
    ?whenIsError(#) { 1; 3 } ~ { 2; 4 },
    ?whenIsError(#) { 1; 3 }
];

main = ^Array<String> => String :: fn([3])->printed;