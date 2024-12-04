module demo-overloaded:

stringRepeat    = ^[s: String<2..10>, n: Integer<1..5>]         => String<2..50> :: #s * #n;
stringConcat    = ^[String<1..15>, String<1..6>]                => String<2..21> :: #.0 + #.1;

arrayAppendWith = ^[Array<String, 3..15>, Array<Integer, 1..9>] => Array<String|Integer, 4..24> :: #.0 + #.1;
mapMergeWith    = ^[Map<String, 3..15>, Map<Integer, 1..9>]     => Map<String|Integer, 3..24> :: #.0 + #.1;

test = ^[a: String<3..10>, b: String<..5>, c: String['a', 'hello'], d: String<1..10>, e: String<2..2>, f: Integer<2..4>] => Map :: [
    stringRepeat: stringRepeat[#a, #f],
    stringConcat: stringConcat[#a, #c],
    arrayAppendWith: arrayAppendWith[['a', 'b', 'c'], [1, 2, 3]],
    mapMergeWith: mapMergeWith[[a: #a, b: #b, c: #c], [c: -7, d: #f]],

    end: 'end'
];

main = ^Array<String> => String :: {
    x = test[' Who? ', 'says', 'hello', '3.14', '42', 3];
    x->printed
};