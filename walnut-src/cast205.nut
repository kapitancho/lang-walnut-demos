module cast205:

R = [a: String, b: Integer, c: Integer<5..20>, ... Any];
Q = [b: Real, c: Integer<10..30>, d: Boolean, ... Any];

Rx = R;
Qx = Q;
S = R & Q;

getRa = ^R => String :: #.a;
getRxa = ^Rx => String :: #.a;
getQb = ^Q => Real :: #.b;
getQxb = ^Qx => Real :: #.b;
getSb = ^S => Integer :: #.b;
getSc = ^S => Integer<10..20> :: #.c;

callRM = ^R => String :: #->m;
/*callQM = ^Q => Boolean :: #->m;*/
callSM = ^S => String|Boolean :: #->m;

/*callRH = ^R => Integer :: #->h(9);*/
callQH = ^Q => Real :: #->h(6.4);
callSH = ^S => Real :: #->h(2);

R->m(^Null => String) :: $.a;
/*Q->m(^Null => Boolean) :: $.d;*/

/*R->h(^Integer => Integer) :: $.c + #;*/
Q->h(^Real => Real) :: $.b + #;

myFn = ^Array<String> => Any :: {
    r = [a: 'hello', b: 10, c: 15, d: false];
    [
        getRa(r),
        getRxa(r),
        getQb(r),
        getQxb(r),
        getSb(r),
        getSc(r),

        callRM(r),
        /*callQM(r),*/
        callSM(r),

        /*callRH(r),*/
        callQH(r),
        callSH(r),

        0
    ]
};

main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};