module demo-r:

A = ['$ref\`\\': String];
a = ['$ref\`\\': ''];
B1 = [a: String, b: ?String];
B2 = [a: String, b: OptionalKey<String>];

NotAnOddInteger = :[];
OddInteger <: Integer @ NotAnOddInteger :: ?whenValueOf(# % 2) is { 0: Error(NotAnOddInteger[]) };

T = [a: Integer, b: ?Boolean, ... String];
S = [Integer, Boolean, ... String];

t1 = ^T => Integer :: #.a;
t2 = ^T => Result<Boolean, MapItemNotFound> :: #.b;
t3 = ^T => Result<String, MapItemNotFound> :: #.c;
s1 = ^S => Integer :: #.0;
s2 = ^S => Boolean :: #.1;
s3 = ^S => Result<String, IndexOutOfRange> :: #.2;

test = ^Any => Any :: [
    a->isOfType(type{A}),
    type{B1}->isSubtypeOf(type{B2}),
    type{B2}->isSubtypeOf(type{B1}),
    x = ?noError(OddInteger(5)),
    x + 1,
    t1[a: 1, b: true, c: 'x'],
    t2[a: 1, b: true, c: 'x'],
    t3[a: 1, b: true, c: 'x'],
    t1[a: 42],
    t2[a: 42],
    t3[a: 42],
    s1[1, true, 'x'],
    s2[1, true, 'x'],
    s3[1, true, 'x'],
    s1[42, true],
    s2[42, true],
    s3[42, true]
];

main = ^Array<String> => String :: test()->printed;