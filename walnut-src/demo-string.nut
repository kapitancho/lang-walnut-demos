module demo-string:

MyString <: String<4..12>;

/* string specific String->... */
length         = ^String<1..15>                                 => Integer<1..15>                               :: #->length;
reverse        = ^String<1..15>                                 => String<1..15>                                :: #->reverse;
toLowerCase    = ^String<1..15>                                 => String<1..15>                                :: #->toLowerCase;
toUpperCase    = ^String<1..15>                                 => String<1..15>                                :: #->toUpperCase;
trim           = ^String<1..15>                                 => String<..15>                                 :: #->trim;
trimLeft       = ^String<1..15>                                 => String<..15>                                 :: #->trimLeft;
trimRight      = ^String<1..15>                                 => String<..15>                                 :: #->trimRight;
contains       = ^[String<1..15>, String<2..6>]                 => Boolean                                      :: #.0->contains(#.1);
startsWith     = ^[String<1..15>, String<2..6>]                 => Boolean                                      :: #.0->startsWith(#.1);
endsWith       = ^[String<1..15>, String<2..6>]                 => Boolean                                      :: #.0->endsWith(#.1);
substring      = ^[String<1..15>, Integer<1..6>, Integer<1..3>] => String<..3>                                  :: #.0->substring[start: #.1, length: #.2];
substringRange = ^[String<1..15>, Integer<1..2>, Integer<3..4>] => String<..3>                                  :: #.0->substringRange[start: #.1, end: #.2];
positionOf     = ^[String<1..15>, String<2..6>]                 => Result<Integer<0..13>, SubstringNotInString> :: #.0->positionOf(#.1);
lastPositionOf = ^[String<1..15>, String<2..6>]                 => Result<Integer<0..13>, SubstringNotInString> :: #.0->lastPositionOf(#.1);
concat         = ^[String<1..15>, String<1..6>]                 => String<2..21>                                :: #.0->concat(#.1);
concatList     = ^[String<1..15>, Array<String<1..6>, 1..9>]    => String<2..69>                                :: #.0->concatList(#.1);
split          = ^[String<1..15>, String<1..3>]                 => Array<String<1..15>, 1..15>                  :: #.0->split(#.1);
chunk          = ^[String<1..15>, Integer<2..3>]                => Array<String<1..3>, 1..15>                   :: #.0->chunk(#.1);
padLeft        = ^[String<3..15>, Integer<2..20>, String<1..2>] => String<3..20>                                :: #.0->padLeft[length: #.1, padString: #.2];
padRight       = ^[String<3..15>, Integer<4..12>, String<1..2>] => String<4..15>                                :: #.0->padRight[length: #.1, padString: #.2];
/* common Any->... */
binaryEqual    = ^[String<..15>, String<..10>]                  => Boolean                                      :: #.0 == #.1;
binaryNotEqual = ^[String<..15>, String<..10>]                  => Boolean                                      :: #.0 != #.1;
asString       = ^String<1..15>                                 => String<1..15>                                :: #->asString;
asInteger      = ^String<1..15>                                 => Result<Integer, NotANumber>                  :: #->asInteger;
asReal         = ^String<1..15>                                 => Result<Real, NotANumber>                     :: #->asReal;
asBoolean      = ^String<..15>                                  => Boolean                                      :: #->asBoolean;
valueType      = ^String<1..15>                                 => Type<String<1..15>>                          :: #->type;
isOfType       = ^[String<1..15>, Type]                         => Boolean                                      :: #.0->isOfType(#.1);
jsonDecode     = ^String<1..15>                                 => Result<JsonValue, InvalidJsonString>         :: #->jsonDecode;
jsonStringify  = ^String<1..15>                                 => String                                       :: #->jsonStringify;

test = ^[a: String<3..10>, b: String<..5>, c: String['a', 'hello'], d: String<1..10>, e: String<2..2>, f: MyString] => Map :: [
    length: length(#.c),
    reverse: reverse(#.a),
    toLowerCase: toLowerCase(#.a),
    toUpperCase: toUpperCase(#.a),
    trim: trim(#.a),
    trimLeft: trimLeft(#.a),
    trimRight: trimRight(#.a),
    containsTrue: contains[#.a, 'ho'],
    containsFalse: contains[#.a, 'qq'],
    startsWithTrue: startsWith[#.c, 'he'],
    startsWithFalse: startsWith[#.c, 'llo'],
    endsWithTrue: endsWith[#.c, 'llo'],
    endsWithFalse: endsWith[#.c, 'he'],
    substring: substring[#.a, 1, 2],
    substringRange: substring[#.a, 2, 3],
    positionOf: positionOf['x 42 42 x', #.e],
    positionOfNotFound: positionOf[#.c, 'qq'],
    lastPositionOf: lastPositionOf['x 42 42 x', #.e],
    lastPositionOfNotFound: lastPositionOf[#.c, 'qq'],
    concat: concat[#.a, #.c],
    concatMyString: concat[#.f, #.c],
    concatList: concatList[#.a, [#.c, #.e]],
    split: split[#.a, 'h'],
    chunk: chunk[#.a, 3],
    padLeft: padLeft[#.a, 20, '+-'],
    padRight: padRight[#.a, 12, '+-'],
    asString: asString(#.a),
    asInteger: asInteger(#.e),
    asIntegerReal: asInteger(#.d),
    asIntegerOther: asInteger(#.a),
    asRealInteger: asReal(#.e),
    asReal: asReal(#.d),
    asRealOther: asReal(#.a),
    asBooleanTrue: asBoolean(#.a),
    asBooleanFalse: asBoolean(''),
    type: valueType(#.a),
    isOfTypeTrue: isOfType[#.a, type{String}],
    isOfTypeFalse: isOfType[#.a, type{Integer}],
    binaryEqualTrue: binaryEqual[#.e, '42'],
    binaryEqualFalse: binaryEqual[#.a, #.b],
    binaryNotEqualTrue: binaryNotEqual[#.a, #.b],
    binaryNotEqualFalse: binaryNotEqual[#.e, '42'],
    jsonDecodeValid: jsonDecode(#.d),
    jsonDecodeInvalid: jsonDecode(#.a),
    jsonStringify: jsonStringify(#.c),
    myString: #.f,
    myStringBaseValue: #.f->baseValue,
    end: 'end'
];

main = ^Array<String> => String :: {
    x = test[' Who? ', 'says', 'hello', '3.14', '42', MyString('welcome!')];
    x->printed
};