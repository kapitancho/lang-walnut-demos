module demo-type:

negate = ^Integer => Real :: -#;
LengthType = ^String => Integer;

ProductId <: Integer<1..>;
ProductState = $[title: String, price: Real, quantity: Integer];

reflectType = ^Type<Type> => Type :: #->refType;
reflectArray = ^Type<Array> => [Type, Integer<0..>, (Integer<0..>|PlusInfinity)] :: [#->itemType, #->minLength, #->maxLength];
reflectMap = ^Type<Map> => [Type, Integer<0..>, (Integer<0..>|PlusInfinity)] :: [#->itemType, #->minLength, #->maxLength];
reflectString = ^Type<String> => [Integer<0..>, (Integer<0..>|PlusInfinity)] :: [#->minLength, #->maxLength];
reflectInteger = ^Type<Integer> => [Integer|MinusInfinity, Integer|PlusInfinity] :: [#->minValue, #->maxValue];
reflectReal = ^Type<Real> => [Real|MinusInfinity, Real|PlusInfinity] :: [#->minValue, #->maxValue];
reflectMutable = ^Type<Mutable> => Type :: #->valueType;
reflectResult = ^Type<Result> => [Type, Type] :: [#->returnType, #->errorType];

reflectFunction = ^Type<^Nothing => Any> => [Type, Type] :: [#->parameterType, #->returnType];

/* the following types:
   Function, Tuple, Record, Union, Intersection,
   Subtype, State, Atom, Enumeration,
   EnumerationSubset, IntegerSubset, RealSubset, StringSubset,
   are only available within Type<T> */
reflectFunction2 = ^Type<Function> => [Type, Type] :: [#->parameterType, #->returnType];
reflectTuple = ^Type<Tuple> => [Array<Type>, Type] :: [#->itemTypes, #->restType];
reflectRecord = ^Type<Record> => [Map<Type>, Type] :: [#->itemTypes, #->restType];
reflectUnion = ^Type<Union> => Array<Type> :: #->itemTypes;
reflectIntersection = ^Type<Intersection> => Array<Type> :: #->itemTypes;
reflectAtom = ^Type<Atom> => String :: #->typeName;
reflectEnumeration = ^Type<Enumeration> => [String, Array] :: [#->typeName, #->values];
reflectEnumerationSubset = ^Type<EnumerationSubset> => [Any, Array] :: [#->enumerationType, #->values];
reflectEnumerationValue = ^Type<EnumerationValue> => [Any, Array] :: [#->enumerationType, #->values];
reflectIntegerSubset = ^Type<IntegerSubset> => Array<Integer> :: #->values;
reflectMutableValue = ^Type<MutableValue> => Type :: #->valueType;
reflectRealSubset = ^Type<RealSubset> => Array<Real> :: #->values;
reflectStringSubset = ^Type<StringSubset> => Array<String> :: #->values;
reflectAlias = ^Type<Alias> => [String, Type] :: [#->typeName, #->aliasedType];
reflectSubtype = ^Type<Subtype> => [String, Type] :: [#->typeName, #->baseType];
reflectSealed = ^Type<Sealed> => [String, Type] :: [#->typeName, #->valueType];
reflectNamed = ^Type<Named> => String :: #->typeName;

/*x = ^Tuple => Array :: #;*/

Z1 = String<10..30>;
Z2 = Array<String, 5..100>;
Z3 = Map<String<1..10>, 5..100>;
Z4 = Integer<10..30>;
Z5 = Real<3.14..5.13>;

qT = ^Array => Any :: {
    v = #;
    t = #->type;
    ?whenTypeOf(t) is {
        type{Type<Tuple>}: t->itemTypes->mapIndexValue(^[index: Integer, value: Type] => Any :: v->item(#.index)),
        ~: null
    }
};

qR = ^Map => Any :: {
    v = #;
    t = #->type;
    ?whenTypeOf(t) is {
        type{Type<Record>}: t->itemTypes->mapKeyValue(^[key: String, value: Type] => Any :: v->item(#.key)),
        ~: null
    }
};

Func = ^Nothing => Any;
qF = ^Func => Any :: {
    v = #;
    t = #->type;
    ?whenTypeOf(t) is {
        type{Type<Function>}: [t->parameterType, t->returnType],
        ~: null
    }
};

myFn = ^Array<String> => Any :: {
    [
        type{[Integer]},

        reflectString(type{Z1}),
        reflectString(type{String}),
        reflectArray(type{Z2}),
        reflectArray(type{Array}),
        reflectMap(type{Z3}),
        reflectMap(type{Map}),
        reflectInteger(type{Z4}),
        reflectInteger(type{Integer}),
        reflectReal(type{Z5}),
        reflectReal(type{Real}),
        reflectFunction(negate->type),
        reflectFunction(type{LengthType}),
        reflectFunction2(negate->type),
        reflectFunction2(type{LengthType}),
        reflectMutable(type{Mutable<String>}),
        reflectResult(type{Result<String, Integer>}),

        reflectTuple(type[Integer, String, ... Real]),
        reflectRecord(type[a: Integer, b: String, ... Real]),
        reflectUnion(type{Integer|String}),
        reflectIntersection(type{Integer&String}),

        reflectAtom(type{Null}),
        reflectEnumeration(type{Boolean}),
        reflectEnumerationSubset(type{True}),
        reflectEnumerationValue(type{True}),
        reflectIntegerSubset(type{Integer[1, -7, 42]}),
        reflectRealSubset(type{Real[3.14, -7.29, 42]}),
        reflectStringSubset(type{String['hello', 'world']}),

        reflectAlias(type{LengthType}),
        reflectSubtype(type{ProductId}),
        reflectSealed(type{ProductState}),
        reflectMutableValue(type{Mutable<String>}),

        reflectNamed(type{ProductId}),

        type{Integer|String}->isSubtypeOf(type{Union}),
        type{Integer&String}->isSubtypeOf(type{Intersection}),
        type{Func}->isSubtypeOf(type{Function}),
        type[Integer, String]->isSubtypeOf(type{Tuple}),
        type[a: Integer, b: String]->isSubtypeOf(type{Record}),

        type[Integer, String, ... Boolean]->itemTypes,
        type[Integer, String, ... Boolean]->restType,
        type[a: Integer, b: String, ... Boolean]->itemTypes,
        type[a: Integer, b: String, ... Boolean]->restType,
        type{ProductId}->baseType,
        type{ProductState}->valueType,

        qT[1, 2],
        qR[a: 1, b: 2],
        qF(qF)
    ]
};

main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};