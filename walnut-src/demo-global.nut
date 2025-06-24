module demo-global:

NotFound := ();
Suit := (Hearts, Diamonds, Clubs, Spades);
P := (Q);

Dup := (A, B, C, D);
DupSub = Dup[A, C];
/*MyStrList = String['hi', 'ho', 'hi'];
MyRealList = Real[1, 3.14, -28, 0, 1];
MyIntList = Integer[2, 5, -14, 21, 5];*/

MyRealList = Real[1, 3.14, -28, 0, 3.5000, -0.2001, -0.0003];

gInteger = 42;
gReal = 3.14;
gString = 'Hello, World!';
gBoolean = true;
gNull = null;
gTuple = [1, 2, 3];
gRecord = [a: 1, b: 2, c: 3];
gSet = [1; ];
gType = `NotFound;

myFn = ^args: Array<String> => Any :: {
    [
        gInteger, gReal, gString, gBoolean, gNull, gTuple, gRecord, gSet, gType,
        `Dup->values, [1; 2.3; 3.0; 3; -1; 2.3]
    ]
};

main = ^args: Array<String> => String :: myFn(args)->printed;