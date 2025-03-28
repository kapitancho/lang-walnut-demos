module cast0:

/* The global scope contains the following declarations: */

/* Type aliases: */
MyAlias = Integer;

/* Atoms */
MyAtom = :[];

/* Enumerations */
MyEnum = :[Value1, Value2, Value3];

/* Open types */
/*MyAtom41   = #[];*/
MyOpen42   = #[a: Integer, b: Integer] @ MyAtom :: null;
MyOpen43   = #[Integer, Integer] @ MyAtom :: null;
MyScalar44 = #Integer @ MyAtom :: null;

/* Sealed types */
/*MySealed91 = $[];*/
MySealed92 = $[a: Integer, b: Integer] @ MyAtom :: null;
MySealed93 = $[Integer, Integer] @ MyAtom :: null;
MySealed94 = $Integer @ MyAtom :: null;

/* Sealed types */
MySealed = $[a: Integer, b: Integer] @ MyAtom :: null;

/* Methods */
MyAtom->myMethod(^String => Integer) %% MyAtom :: #->length;

/* Constructors */
MySealed[a: Real, b: Real] %% MyAtom :: [a: #a->asInteger, b: #b->asInteger];

/* Variables */
a = 1;
b = ^MyAlias => Integer :: # + a;
c = type{String};

getEnumValue1 = ^Any => MyEnum :: MyEnum.Value1;
getEnumValue2 = ^Any => MyEnum[Value2, Value3] :: MyEnum.Value2;

fa = ^Atom => String :: #->type->typeName;
fe = ^EnumerationValue => Any :: [enum: #->enumeration, value: #->textValue, type: #->type, gv: gv(#->type)];
fm = ^MutableValue => Any :: #->value;
ft = ^Tuple => Array :: #->itemValues;
fr = ^Record => Map :: #->itemValues;
fs = ^Sealed => Any :: #->type->typeName;

ge = ^Type<Enumeration> => Any :: [values: #->values, valueWithName: #->valueWithName('Value1'),
    withValues: #->withValues[MyEnum.Value1, MyEnum.Value2], typeName: #->typeName];
gs = ^Type<EnumerationSubset> => Any :: [enumeration: #->enumerationType, values: #->values, valueWithName: #->valueWithName('Value1')];
gv = ^Type<EnumerationValue> => Any :: [enumeration: #->enumerationType];

fn = ^Any => Any :: [
    a, b, b(2), c, main->type,
    fa(MyAtom()),
    fe(getEnumValue1()),
    fe(getEnumValue2()),
    fe(MyEnum.Value3),
    fm(mutable{Integer, 42}),
    ft[1, 5],
    fr[a: 1, b: 2],
    fs(?noError(MySealed[3.14, -2])),
    ge(type{MyEnum}),
    gs(type{MyEnum}),
    gs(type{MyEnum[Value1, Value2]}),
    gv(type{MyEnum}),
    gv(type{MyEnum[Value1, Value2]}),

    MyAtom(), MyAtom()->myMethod('hi!'), MyEnum.Value1,
    MySealed[3.14, -2]
];

main = ^Array<String> => String :: fn()->printed;