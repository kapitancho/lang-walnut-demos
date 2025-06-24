module cast0:

/* The global scope contains the following declarations: */

/* Type aliases: */
MyAlias = Integer;

MyIntegers = [
    Integer<(..-6)>, Integer<(6..)>, Integer<(2..7)>, Integer<(2..7]>,
    Integer<(..-6]>, Integer<[6..)>, Integer<[2..7)>, Integer<[2..7]>,
    Integer<(..-6], [1..5], (-3..7), [-1..42), (6..10], [8..), (..4], [15..)>,
    Integer<(-3..3), 15, -29, [4..6], 11>, Integer<9, -12>, Integer<-16, [5..7)>
];

MyReals = [
    Real<(..-6.2)>, Real<(6.14..)>, Real<(2.3..7)>, Real<(2..7.3]>,
    Real<(..-6]>, Real<[6.3..)>, Real<[2.5..7)>, Real<[2..7.2]>,
    Real<(..-6], [1..5.4], (-3.2..7), [-1.1..42.03), (6..10], [8..), (..4], [15..)>,
    Real<(-3..3), 15.17, -29, [4..6.8], 11.3>, Real<9.3, -12>, Real<-16, [5.4..7)>
];

/* Atoms */
MyAtom := ();

/* Enumerations */
MyEnum := (Value1, Value2, Value3);

/* Open types */
MyData42   := [a: Integer, b: Integer];
MyData43   := [Integer, Integer];
MyData44   := Integer;
MyNestedData := MyData44;

/* Open types */
/*MyAtom41   := #[];*/
MyOpen42   := #[a: Integer, b: Integer] @ MyAtom :: null;
MyOpen43   := #[Integer, Integer] @ MyAtom :: null;
MyScalar44 := #Integer @ MyAtom :: null;

/* Sealed types */
/*MySealed91 := $[];*/
MySealed92 := $[a: Integer, b: Integer] @ MyAtom :: null;
MySealed93 := $[Integer, Integer] @ MyAtom :: null;
MySealed94 := $Integer @ MyAtom :: null;

/* Sealed types */
MySealed := $[a: Integer, b: Integer] @ MyAtom :: null;

/* Methods */
MyAtom->myMethod(^String => Integer) %% MyAtom :: #->length;

/* Constructors */
MySealed[a: Real, b: Real] %% MyAtom :: [a: #a->asInteger, b: #b->asInteger];

/* Variables */
a = 1;
b = ^MyAlias => Integer :: # + a;
c = type{String};
d = @42;
e = MyData44!79;
f1 = [A2: 5];
f2 = ['A': 5];
r1 = mutable{Integer, 42};

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
    `MyIntegers->itemTypes,
    `MyReals->itemTypes,

    a, b, b(2), c, d, e, f1, f2, main->type,
    fa(MyAtom),
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

    MyAtom, MyAtom->myMethod('hi!'), MyEnum.Value1,
    p = 42,
    MyData44!{p + 1},
    MyNestedData!MyData44!-9,
    MySealed[3.14, -2],
    Error(42),
    /*Error:42,*/
    @{p + 1},
    [A: 5],
    ['A': 5],
    mutable{Integer, 42}
];

main = ^Array<String> => String :: fn()->printed;