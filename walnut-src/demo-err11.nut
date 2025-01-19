module demo-err11:

P <: Integer;
Q <: P;
R <: Integer;

P->p(^String => Integer) :: $ + #->length;
Q->q(^String => Integer) :: $ + #->length;

P->d(^String => Integer|Boolean) :: $ + #->length;
Q->d(^String|Real => Integer) :: $;

F = P;
F->d(^String|Boolean => Integer|Boolean|String) :: false;

/*F->binaryMinus(^Integer => String) :: $ - 41;*/

P->binaryPlus(^Integer => Integer) :: $ - 41;
P->asJsonValue(=> String<5..5>) :: 'Hello';

P ==> Boolean :: false;
Q ==> Boolean @ String :: false;
R ==> Boolean @ String :: false;

P->m(^String => Integer) :: $ + #->length;
Q->m(^String => Integer|Boolean) :: false;

P->t(^String => Integer) :: $ + #->length;
Q->t(^Array<Integer, 1..> => Integer) :: #->item(0);

getP = ^P => Integer :: #->asInteger;
getQ = ^P => P :: Q(#);

getInt1 = ^P => Integer :: #->m('!');
getInt2 = ^P => Integer :: #->t('!');

main = ^Any => String :: {
    p = P(7);
    q1 = Q(p);
    q2 = getQ(p);
    [
        getP(p),
        getP(q1),
        getP(q2),
        getInt1(p),
        getInt1(q1),
        getInt1(q2),
        getInt2(p),
        /*getInt2(q1),
        getInt2(q2),*/
        p->m('Hello'),
        q1->m('Hello'),
        q2->m('Hello')
    ]->printed;
};