module demo-asraw:

MyInt <: Integer;

matchMe = ^[a: Integer, b: Integer] => String :: ?whenValueOf (#a->rawValue) is {
    #b: 'a = b',
    ~ : 'a != b'
};

main = ^Array<String> => String :: {
    set = [5; 12];
    set = set + [MyInt(5); MyInt(12)->rawValue];
    [set, matchMe[5, MyInt(5)], matchMe[MyInt(5), 5]]->printed;
};