module demo-integer:

MyBoolean <: Boolean;

/* string specific Integer->... */
unaryNot            = ^Boolean            => Boolean        :: #->unaryNot;
binaryAnd           = ^[Boolean, Boolean] => Boolean        :: #.0->binaryAnd(#.1);
binaryOr            = ^[Boolean, Boolean] => Boolean        :: #.0->binaryOr(#.1);
binaryXor           = ^[Boolean, Boolean] => Boolean        :: #.0->binaryXor(#.1);

/* common Any->... */
binaryEqual         = ^[Boolean, Boolean] => Boolean        :: #.0 == #.1;
binaryNotEqual      = ^[Boolean, Boolean] => Boolean        :: #.0 != #.1;
asString            = ^Boolean            => String<4..5>   :: #->asString;
asInteger           = ^Boolean            => Integer<0..1>  :: #->asInteger;
asReal              = ^Boolean            => Real[0.0, 1.0] :: #->asReal;
valueType           = ^Boolean            => Type<Boolean>  :: #->type;
isOfType            = ^[Boolean, Type]    => Boolean        :: #.0->isOfType(#.1);
jsonStringify       = ^Boolean            => String         :: #->jsonStringify;

test = ^[a: Boolean, b: Boolean, c: True, d: False, e: MyBoolean] => Map :: [
    unaryNot: unaryNot(#.c),
    binaryAnd: binaryAnd[#.d, #.a],
    binaryOr: binaryOr[#.d, #.a],
    binaryXor: binaryXor[#.d, #.e],
    asString: asString(#.a),
    asReal: asReal(#.a),
    asInteger: asInteger(#.b),
    type: valueType(#.a),
    isOfTypeTrue: isOfType[#.a, type{Boolean}],
    isOfTypeFalse: isOfType[#.a, type{String}],
    binaryEqualTrue: binaryEqual[#.a, #.c],
    binaryEqualFalse: binaryEqual[#.a, #.b],
    binaryNotEqualTrue: binaryNotEqual[#.a, #.b],
    binaryNotEqualFalse: binaryNotEqual[#.a, #.c],
    jsonStringify: jsonStringify(#.c),
    myBoolean: #.e,
    myBooleanBaseValue: #.e->baseValue,
    end: 'end'
];

main = ^Array<String> => String :: {
    x = test[true, false, true, false, MyBoolean(true)];
    x->printed
};