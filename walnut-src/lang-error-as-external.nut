module lang-error-as-external:

a = ^Integer => Result<Integer, String> :: ?whenTypeOf(#) is {
    type{Integer<1..>}: #->sqrt->asInteger,
    ~: @'Error: negative number'
};

b = ^Integer => *Integer :: a(#) *> ('Negative numbers not allowed');

TodoTest = :[];
TodoTest->run(^Any => Any) :: [
    a(3),
    a(-5),
    b(7),
    b(-4)
];

main = ^Any => String :: TodoTest()->run->printed;
