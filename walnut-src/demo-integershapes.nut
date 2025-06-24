module demo-integershapes:

Speed := Integer;
s = ^i: Shape<Integer> => Integer :: {i->shape(`Integer)} * 2;

Range := #[from: Integer, to: Integer];
Range ==> Integer :: $to - $from;

MySecret := $Integer;
MySecret ==> Integer :: $$;

v = ^ => [Integer, Mutable<Integer>, Real, Speed, Range, MySecret, String] :: [
    42, mutable{Integer, -9}, 3.14, Speed!80, Range[3, 9], MySecret(0), '7'];

int = type{Integer};

fn = ^ => Any :: {
    t = v();
    [
        s(t.0), /* the value IS an integer */
        s(t.1), /* There is a built-in cast from Mutable<Integer> to Integer */
        s(t.2), /* There is a built-in cast from Real to Integer */
        s(t.3), /* the Open type is based on Integer */
        s(t.4), /* The Range is an Open type which is not based on Integer but there exists a cast from Range to Integer */
        s(t.5), /* The Secret is a Sealed type but there exists a cast from MySecret to Integer */
        s(t.6=>as(int)) /* the cast from String to Integer may return @NotANumber[] */
    ]
};
main = ^Array<String> => String :: fn()->printed;