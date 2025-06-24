module demo-stringshapes:

Title := String;
s = ^s: Shape<String> => String :: s->shape(`String)->reverse;

Range := #[from: Integer, to: Integer];
Range ==> String :: $from->asString + ' - ' + $to->asString;

MySecret := $String;
MySecret ==> String :: $$;

v = ^ => [String, Mutable<String>, Real, Title, Range, MySecret] :: [
    'first', mutable{String, 'mutate me'}, 3.14, Title!'welcome', Range[3, 9], MySecret('how?')];

fn = ^ => Any :: {
    t = v();
    [
        s(t.0), /* the value IS a string */
        s(t.1), /* There is a built-in cast from Mutable<String> to String */
        s(t.2), /* There is a built-in cast from Real to String */
        s(t.3), /* the Data type is based on String */
        s(t.4), /* The Range is an Open type which is not based on String but there exists a cast from Range to String */
        s(t.5) /* The Secret is a Sealed type but there exists a cast from MySecret to String */
    ]
};
main = ^Array<String> => String :: fn()->printed;