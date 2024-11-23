module demo-array:

MyArray <: Array<2..10>;

/* array specific Array->... */
length                = ^Array<1..15>                              => Integer<1..15>                                                            :: #->length;
reverse               = ^Array<1..15>                              => Array<1..15>                                                              :: #->reverse;
item                  = ^[Array<String, 1..15>, Integer<1..15>]    => Result<String, IndexOutOfRange>                                           :: #.0->item(#.1);
itemNoError           = ^[Array<String, 3..15>, Integer<0..2>]     => String                                                                    :: #.0->item(#.1);
contains              = ^[Array<String, 1..15>, Any]               => Boolean                                                                   :: #.0->contains(#.1);
indexOf               = ^[Array<String, 1..15>, Any]               => Result<Integer<0..14>, ItemNotFound>                                      :: #.0->indexOf(#.1);
lastIndexOf           = ^[Array<String, 1..15>, Any]               => Result<Integer<0..14>, ItemNotFound>                                      :: #.0->lastIndexOf(#.1);
without               = ^[Array<Integer, 2..10>, Integer]          => Result<Array<Integer, 1..9>, ItemNotFound>                                :: #.0->without(#.1);
withoutAll            = ^[Array<Integer, 2..10>, Integer]          => Array<Integer, ..10>                                                      :: #.0->withoutAll(#.1);
withoutByIndex        = ^[Array<Integer, 2..10>, Integer]          => Result<[element: Integer, array: Array<Integer, 1..9>], IndexOutOfRange>  :: #.0->withoutByIndex(#.1);
withoutByIndexNoError = ^[Array<Integer, 2..10>, Integer<0..1>]    => [element: Integer, array: Array<Integer, 1..9>]                           :: #.0->withoutByIndex(#.1);
withoutFirst          = ^Array<Integer, ..10>                      => Result<[element: Integer, array: Array<Integer, ..9>], ItemNotFound>      :: #->withoutFirst;
withoutFirstNoError   = ^Array<Integer, 2..10>                     => [element: Integer, array: Array<Integer, 1..9>]                           :: #->withoutFirst;
withoutLast           = ^Array<Integer, ..10>                      => Result<[element: Integer, array: Array<Integer, ..9>], ItemNotFound>      :: #->withoutLast;
withoutLastNoError    = ^Array<Integer, 2..10>                     => [element: Integer, array: Array<Integer, 1..9>]                           :: #->withoutLast;
combineAsString       = ^[Array<String<2..5>, 2..4>, String<1..2>] => String/*<5..26>*/                                                         :: #.0->combineAsString(#.1);
insertFirst           = ^[Array<String, 3..15>, Integer<0..20>]    => Array<String|Integer<0..20>, 4..16>                                       :: #.0->insertFirst(#.1);
insertLast            = ^[Array<String, 3..15>, Integer<0..20>]    => Array<String|Integer<0..20>, 4..16>                                       :: #.0->insertLast(#.1);
insertAt              = ^[Array<String, 3..15>, Integer<0..20>, Integer<2..10>] => Result<Array<String|Integer<0..20>, 4..16>, IndexOutOfRange> :: #.0->insertAt[value: #.1, index: #.2];
insertAtNoError       = ^[Array<String, 3..15>, Integer<0..20>, Integer<1..3>] => Array<String|Integer<0..20>, 4..16>                           :: #.0->insertAt[value: #.1, index: #.2];
appendWith            = ^[Array<String, 3..15>, Array<Integer, 1..9>] => Array<String|Integer, 4..24>                                           :: #.0->appendWith(#.1);
sortString            = ^Array<String, 3..15>                      => Array<String, 3..15>                                                      :: #->sort;
sortNumeric           = ^Array<Real, ..15>                         => Array<Real, ..15>                                                         :: #->sort;
uniqueString          = ^Array<String, 3..15>                      => Array<String, ..15>                                                       :: #->unique;
uniqueNumeric         = ^Array<Real, ..15>                         => Array<Real, ..15>                                                         :: #->unique;
sum                   = ^Array<Real<0.2..15>, ..9>                 => Real<0..135>                                                              :: #->sum;
min                   = ^Array<Real<0.2..35>, 3..9>                => Real<0.2..35>                                                             :: #->min;
max                   = ^Array<Real<0.2..35>, 3..9>                => Real<0.2..35>                                                             :: #->max;
flip                  = ^Array<String, 3..9>                       => Map<Integer<0..9>, 1..9>                                                  :: #->flip;
map                   = ^[Array<Integer<5..30>, 3..9>, ^Integer<5..30> => Real]    => Array<Real, 3..9>                                         :: #.0->map(#.1);
mapIndexValue         = ^[Array<Integer<5..30>, 3..9>, ^[index: Integer<0..9>, value: Integer<5..30>] => Real] => Array<Real, 3..9>             :: #.0->mapIndexValue(#.1);
filter                = ^[Array<Integer<5..30>, 3..9>, ^Integer<5..30> => Boolean] => Array<Integer<5..30>, ..9>                                :: #.0->filter(#.1);
findFirst             = ^[Array<Integer<5..30>, 3..9>, ^Integer<5..30> => Boolean] => Result<Integer<5..30>, ItemNotFound>                      :: #.0->findFirst(#.1);
findLast              = ^[Array<Integer<5..30>, 3..9>, ^Integer<5..30> => Boolean] => Result<Integer<5..30>, ItemNotFound>                      :: #.0->findLast(#.1);
padLeft               = ^[Array<String, 3..15>, Integer<8..32>, Integer<0..20>]    => Array<String|Integer<0..20>, 8..32>                       :: #.0->padLeft[length: #.1, value: #.2];
padRight              = ^[Array<String, 3..15>, Integer<8..32>, Integer<0..20>]    => Array<String|Integer<0..20>, 8..32>                       :: #.0->padRight[length: #.1, value: #.2];
slice                 = ^[Array<Real, ..15>, Integer<1..6>, Integer<1..3>]         => Array<Real, ..3>                                          :: #.0->slice[start: #.1, length: #.2];
sliceRange            = ^[Array<Real, ..15>, Integer<1..6>, Integer<1..3>]         => Array<Real, ..3>                                          :: #.0->sliceRange[start: #.1, end: #.2];
countValuesString     = ^Array<String, 3..15>                                      => Map<Integer<1..15>, ..15>                                 :: #->countValues;
countValuesNumeric    = ^Array<Integer, ..15>                                      => Map<Integer<1..15>, ..15>                                 :: #->countValues;

/* common Any->... */
binaryEqual    = ^[Array<..15>, Array<..10>]                                       => Boolean                                      :: #.0 == #.1;
binaryNotEqual = ^[Array<..15>, Array<..10>]                                       => Boolean                                      :: #.0 != #.1;
asBoolean      = ^Array<..15>                                                      => Boolean                                      :: #->asBoolean;
valueType      = ^Array<1..15>                                                     => Type<Array<1..15>>                          :: #->type;
isOfType       = ^[Array<1..15>, Type]                                             => Boolean                                      :: #.0->isOfType(#.1);
jsonStringify  = ^Array<JsonValue, 1..15>                                          => String                                       :: #->jsonStringify;

test = ^[a: Array<3..10>, b: Array<String, ..5>, c: Array<String['aa', 'hello'], 3..4>, d: Array<Real<0.3..10>, ..6>, e: Array<Integer<5..30>, 4..8>, f: MyArray] => Map :: [
    length: length(#.c),
    reverse: reverse(#.a),
    item: item[#.c, 1],
    itemOutOfRange: item[#.c, 10],
    containsTrue: contains[#.c, 'hello'],
    containsFalse: contains[#.c, null],
    indexOf: indexOf[#.c, 'hello'],
    indexOfOutOfRange: indexOf[#.c, null],
    lastIndexOf: lastIndexOf[#.c, 'hello'],
    lastIndexOfOutOfRange: lastIndexOf[#.c, null],
    without: without[#.e, 12],
    withoutAll: withoutAll[#.e, 12],
    withoutItemNotFound: without[#.e, 101],
    withoutByIndex: withoutByIndex[#.e, 2],
    withoutByIndexOutOfRange: withoutByIndex[#.e, 12],
    withoutFirst: withoutFirst(#.e),
    withoutFirstNotFound: withoutFirst([]),
    withoutLast: withoutLast(#.e),
    withoutLastNotFound: withoutLast([]),
    combineAsString: combineAsString[#.c, ' '],
    insertFirst: insertFirst[#.c, 15],
    insertLast: insertLast[#.c, 15],
    insertAt: insertAt[#.c, 15, 2],
    appendWith: appendWith[#.c, #.e],
    sortString: sortString(#.c),
    sortNumeric: sortNumeric(#.d),
    uniqueString: uniqueString(#.c),
    uniqueNumeric: uniqueNumeric(#.d),
    sum: sum(#.d),
    min: min(#.e),
    max: max(#.e),
    flip: flip(#.c),
    map: map[#.e, ^Integer<5..30> => Real :: # / 3],
    mapIndexValue: mapIndexValue[#.e, ^[index: Integer<0..9>, value: Integer<5..30>] => Real :: #.index + #.value],
    filter: filter[#.e, ^Integer<5..30> => Boolean :: # > 10],
    findFirst: findFirst[#.e, ^Integer<5..30> => Boolean :: # > 13],
    findFirstNotFound: findFirst[#.e, ^Integer<5..30> => Boolean :: # > 100],
    findLast: findLast[#.e, ^Integer<5..30> => Boolean :: # > 13],
    findLastNotFound: findLast[#.e, ^Integer<5..30> => Boolean :: # > 100],
    padLeft: padLeft[#.c, 8, 0],
    padRight: padRight[#.c, 8, 0],
    slice: slice[#.d, 1, 2],
    sliceRange: sliceRange[#.d, 1, 3],

    countValuesString: countValuesString(#.c),
    countValuesNumeric: countValuesNumeric(#.e),

    asBooleanTrue: asBoolean(#.a),
    asBooleanFalse: asBoolean([]),
    type: valueType(#.a),
    isOfTypeTrue: isOfType[#.a, type{Array}],
    isOfTypeFalse: isOfType[#.a, type{Integer}],
    binaryEqualTrue: binaryEqual[#.e, [9, 12, 18, 15, 12]],
    binaryEqualFalse: binaryEqual[#.a, #.b],
    binaryNotEqualTrue: binaryNotEqual[#.a, #.b],
    binaryNotEqualFalse: binaryNotEqual[#.e, [9, 12, 18, 15, 12]],
    jsonStringify: jsonStringify(#.c),
    myArray: #.f,
    myArrayBaseValue: #.f->baseValue,
    myArrayReverse: reverse(#.f),

    end: 'end'
];

main = ^Array<String> => String :: {
    x = test[
        [1, 'Two', 3.14, false],
        ['hello', 'world', '!'],
        ['aa', 'hello', 'hello'],
        [1.27, 3.14, 7, 3.14],
        [9, 12, 18, 15, 12],
        MyArray['hello', 7]
    ];
    x->printed
};