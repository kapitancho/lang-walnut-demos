module cast9999:

M1 = Shape<Integer>;
M2 = {Integer};
M3 := #Shape<Integer>;
M4 := #{Integer};
M5 := $Shape<Integer>;
M6 := ${Integer};
M7 = Shape<[a: Integer]>;
M8 = {[a: Integer]};
M9 = Shape<[]>;
M10 = {[]};
M11 = Shape<[:]>;
M12 = {[:]};
M13 = Shape<*Integer>;
M14 = {*Integer};
M15 = *Null;
M16 = ^{Integer} => Integer;
M17 = ^Integer => {Integer};
M18 = ^ *Integer => Integer;
M19 = ^ Integer => *Integer;
M20 = [*Integer, *Integer];
M21 = [{Integer}, {Integer}];
M22 = [a: *Integer, b: *Integer];
M23 = [a: "Integer", b: "Integer"];
M24 = {[{Integer}]};
M25 := #*Integer;
M26 := $*Integer;

s1 = ^Shape<Integer> => Integer :: #;
s2 = ^{Integer} => Integer :: #;
s3 = ^Integer => Shape<Integer> :: $;
s4 = ^Integer => {Integer} :: $;
s5 = ^ *Integer => Integer :: $;
s6 = ^ :: `Shape<Integer>;
s7 = ^ :: `{Integer};

T1 := #Null @ {Integer} :: null;
T1({Integer}) :: null;
T1->x(^ {Integer}) :: null;
T1->y(=> {Integer}) :: 1;
T1->z() :: 2;

g = ^a: String => Integer :: a->length;
h = ^b: [a: Integer, b: String] => Integer :: #a + #b->length;
c = ^ => Boolean :: false;

Integer->m(^s: Integer => Integer) :: $ - s;
Integer->r(^s: [a: Integer, b: String] => Integer) :: $ * {#a - #b->length};
Integer->d(=> Integer) :: $ * 2;

J = Integer<-20..20>;
J->d(^Real|Null => Integer) :: $ * 2;

Integer->x(^True => Integer) :: 1;
J->x(^Boolean => Integer) :: 1;

R = Real<0..9.999>;
R->floor(=> Integer[0]) :: 0;

e = ^ => Result<Nothing, Integer> :: @3968;

fn = ^Any => Any :: {
    r = ^ => Boolean :: false;
    k = 1;
    l = ^t: Integer => Integer :: t + k;
    m = ^[a: Integer, b: String] => Integer :: #a + #b->length;
    [
        g('hello'),
        l(2),
        e(),
        3->m(1),
        -7->d,
        5->r[a: 6, b: 'good'],
        5->r[6, 'good'],
        h[a: 3, b: 'world'],
        h[4, 'hello'],
        m[a: 1, b: 'hi!'],
        m[1, 'hi!'],
        'end'
    ]
};

main = ^Array<String> => String :: fn()->printed;