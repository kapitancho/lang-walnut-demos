module cast204:

R = [a: String, b: Integer, c: Integer<5..20>];
Q = [b: Real, c: Integer<10..30>, d: Boolean];

Rx = R;
Qx = Q;
S = R | Q;

getRa = ^R => String :: #.a;
getRxa = ^Rx => String :: #.a;
getQb = ^Q => Real :: #.b;
getQxb = ^Qx => Real :: #.b;
getSb = ^S => Real :: #.b;
getSc = ^S => Integer<5..30> :: #.c;

callRM = ^R => String :: #->m;
callQM = ^Q => Boolean :: #->m;
callSM = ^S => String|Boolean :: #->m;

callRH = ^R => Integer :: #->h(9);
callQH = ^Q => Real :: #->h(6.4);
callSH = ^S => Real :: #->h(2);

R->m(^Null => String) :: $.a;
Q->m(^Null => Boolean) :: $.d;

R->h(^Integer => Integer) :: $.c + #;
Q->h(^Real => Real) :: $.b + #;

myFn = ^Array<String> => Any :: {
    r = [a: 'hello', b: 10, c: 15];
    q = [b: 10.9, c: 12, d: true];
    [
        getRa(r),
        getRxa(r),
        getQb(q),
        getQxb(q),
        getSb(r),
        getSc(r),
        getSb(q),
        getSc(q),

        callRM(r),
        callQM(q),
        callSM(r),
        callSM(q),

        callRH(r),
        callQH(q),
        callSH(r),
        callSH(q),
        0
    ]
};

main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};