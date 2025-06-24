module cast03:

P = Null;
B = Integer;

T1           := $B; T2             := $B; T3              := $B; T4           := $B; T5         := $B;
T1    (P)    :: 0; T2     (~P)    :: 0; T3    (p: P)    :: 0; T4    (p)    :: 0; T5   ()    :: 0;
T1->m(^P)    :: 0; T2->m(^ ~P)    :: 0; T3->m(^p: P)    :: 0; T4->m(^p)    :: 0; T5->m()    :: 0;
t1 =  ^P     :: 0; t2 =  ^ ~P     :: 0; t3 =  ^p: P     :: 0; t4 =  ^p     :: 0; t5 = ^     :: 0;
T1->n(^P=>B) :: 0; T2->n(^ ~P=>B) :: 0; T3->n(^p: P=>B) :: 0; T4->n(^p=>B) :: 0; T5->n(=>B) :: 0;
b1 =  ^P=>B  :: 0; b2 =  ^ ~P=>B  :: 0; b3 =  ^p: P=>B  :: 0; b4 =  ^p=>B  :: 0; b5 = ^=>B  :: 0;

T6   := $B; T7    := $B;
T6[] :: 0; T7[:] :: 0;

dyn = ^i: Integer<1..7> :: {
    a = 'T' + {i->asString};
    b = a=>hydrateAs(`Type);
    c = i->hydrateAs(b)
};
main = ^Array<String> => String %% [r: Random] :: dyn(%r->integer[min: 1, max: 7])->printed;