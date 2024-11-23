module demo-array:

MyMap <: Map<2..10>;

/* map specific Map->... */

values                = ^Map<String<1..10>, 1..15>               => Array<String<1..10>, 1..15>                                               :: #->values;
keys                  = ^Map<String<1..10>, 1..15>               => Array<String, 1..15>                                                      :: #->keys;
keyExists             = ^[Map<String, 1..15>, String]            => Boolean                                                                   :: #.0->keyExists(#.1);
item                  = ^[Map<String, 1..15>, String]            => Result<String, MapItemNotFound>                                           :: #.0->item(#.1);
contains              = ^[Map<String, 1..15>, Any]               => Boolean                                                                   :: #.0->contains(#.1);
keyOf                 = ^[Map<String, 1..15>, Any]               => Result<String, ItemNotFound>                                              :: #.0->keyOf(#.1);
without               = ^[Map<Integer, 2..10>, Integer]          => Result<Map<Integer, 1..9>, ItemNotFound>                                  :: #.0->without(#.1);
withoutAll            = ^[Map<Integer, 2..10>, Integer]          => Map<Integer, ..10>                                                        :: #.0->withoutAll(#.1);
withoutByKey          = ^[Map<Integer, 2..10>, String]           => Result<[element: Integer, map: Map<Integer, 1..9>], MapItemNotFound>    :: #.0->withoutByKey(#.1);
valuesWithoutKey         = ^[Map<Integer, 2..10>, String]           => Result<Map<Integer, 1..9>, MapItemNotFound>                               :: #.0->valuesWithoutKey(#.1);
withKeyValue          = ^[Map<String, 3..15>, String, Integer<2..10>] => Map<String|Integer<0..20>, 3..16>                                    :: #.0->withKeyValue[key: #.1, value: #.2];
mergeWith             = ^[Map<String, 3..15>, Map<Integer, 1..9>] => Map<String|Integer, 3..24>                                               :: #.0->mergeWith(#.1);
flip                  = ^Map<String, 3..9>                       => Map<String, 1..9>                                                         :: #->flip;
map                   = ^[Map<Integer<5..30>, 3..9>, ^Integer<5..30> => Real]    => Map<Real, 3..9>                                         :: #.0->map(#.1);
mapKeyValue           = ^[Map<Integer<5..30>, 3..9>, ^[key: String, value: Integer<5..30>] => Real] => Map<Real, 3..9>                        :: #.0->mapKeyValue(#.1);
findFirstKeyValue     = ^[Map<Integer<5..30>, 3..9>, ^[key: String, value: Integer<5..30>] => Boolean] => Result<[key: String, value: Real], ItemNotFound> :: #.0->findFirstKeyValue(#.1);
filterKeyValue        = ^[Map<Integer<5..30>, 3..9>, ^[key: String, value: Integer<5..30>] => Boolean] => Map<Real, ..9>                      :: #.0->filterKeyValue(#.1);
filter                = ^[Map<Integer<5..30>, 3..9>, ^Integer<5..30> => Boolean] => Map<Integer<5..30>, ..9>                                  :: #.0->filter(#.1);
findFirst             = ^[Map<Integer<5..30>, 3..9>, ^Integer<5..30> => Boolean] => Result<Integer<5..30>, ItemNotFound>                      :: #.0->findFirst(#.1);

/* common Any->... */
binaryEqual    = ^[Map<..15>, Map<..10>]                                         => Boolean                                        :: #.0 == #.1;
binaryNotEqual = ^[Map<..15>, Map<..10>]                                         => Boolean                                        :: #.0 != #.1;
asBoolean      = ^Map<..15>                                                      => Boolean                                        :: #->asBoolean;
valueType      = ^Map<1..15>                                                     => Type<Map<1..15>>                               :: #->type;
isOfType       = ^[Map<1..15>, Type]                                             => Boolean                                        :: #.0->isOfType(#.1);
jsonStringify  = ^Map<JsonValue, 1..15>                                          => String                                         :: #->jsonStringify;

test = ^[a: Map<3..10>, b: Map<String, ..5>, c: Map<String['aa', 'hello'], 3..4>, d: Map<Real<0.3..10>, ..6>, e: Map<Integer<5..30>, 4..8>, f: MyMap] => Map :: [

    keys: keys(#.c),
    values: values(#.c),
    item: item[#.c, 'q'],
    itemOutOfRange: item[#.c, 'qq'],
    /*
    lastIndexOf: lastIndexOf[#.c, 'hello'],
    lastIndexOfOutOfRange: lastIndexOf[#.c, null],
*/
    without: without[#.e, 12],
    withoutAll: withoutAll[#.e, 12],
    withoutItemNotFound: without[#.e, 101],
    withKeyValue: withKeyValue[#.c, 'q', 5],
    withoutByKey: withoutByKey[#.e, 'c'],
    withoutByKeyOutOfRange: withoutByKey[#.e, 'cc'],
    valuesWithoutKey: valuesWithoutKey[#.e, 'c'],
    valuesWithoutKeyOutOfRange: valuesWithoutKey[#.e, 'cc'],
    mergeWith: mergeWith[#.c, #.e],
    flip: flip(#.c),
    map: map[#.e, ^Integer<5..30> => Real :: # / 3],
    mapKeyValue: mapKeyValue[#.e, ^[key: String, value: Integer<5..30>] => Real :: #.value + #.key->length],
    findFirstKeyValue: findFirstKeyValue[#.e, ^[key: String, value: Integer<5..30>] => Boolean :: {#.value == 12}->binaryAnd(#.key == 'e')],
    filterKeyValue: filterKeyValue[#.e, ^[key: String, value: Integer<5..30>] => Boolean :: {#.value > 15}->binaryOr(#.key == 'a')],
    filter: filter[#.e, ^Integer<5..30> => Boolean :: # > 10],
    findFirst: findFirst[#.e, ^Integer<5..30> => Boolean :: # > 13],
    findFirstNotFound: findFirst[#.e, ^Integer<5..30> => Boolean :: # > 100],

    keyExistsTrue: keyExists[#.c, 'q'],
    keyExistsFalse: keyExists[#.c, 'qq'],
    keyOf: keyOf[#.c, 'hello'],
    keyOfOutOfRange: keyOf[#.c, null],
    containsTrue: contains[#.c, 'hello'],
    containsFalse: contains[#.c, null],

    asBooleanTrue: asBoolean(#.a),
    asBooleanFalse: asBoolean([:]),
    type: valueType(#.a),
    isOfTypeTrue: isOfType[#.a, type{Map}],
    isOfTypeFalse: isOfType[#.a, type{Integer}],
    binaryEqualTrue: binaryEqual[#.e, [a: 9, b: 12, c: 18, d: 15, e: 12]],
    binaryEqualFalse: binaryEqual[#.a, #.b],
    binaryNotEqualTrue: binaryNotEqual[#.a, #.b],
    binaryNotEqualFalse: binaryNotEqual[#.e, [a: 9, b: 12, c: 18, d: 15, e: 12]],
    jsonStringify: jsonStringify(#.c),
    myMap: #.f,
    myMapBaseValue: #.f->baseValue,
    myMapValues: #.f->values,

    end: 'end'
];

main = ^Array<String> => String :: {
    x = test[
        [a: 1, b: 'Two', c: 3.14, d: false],
        [a: 'hello', b: 'world', c: '!'],
        [a: 'aa', b: 'hello', q: 'hello'],
        [a: 1.27, b: 3.14, c: 7, d: 3.14],
        [a: 9, b: 12, c: 18, d: 15, e: 12],
        MyMap[a: 'hello', b: 7]
    ];
    x->printed
};