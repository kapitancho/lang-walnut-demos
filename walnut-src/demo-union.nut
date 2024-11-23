module demo-union:

User = [name: String<1..>, age: Integer<1..>, ...];
Employee = [name: String<1..>, position: String<1..>, salary: Integer<0..>, ...];

getName = ^User|Employee => String<1..> :: #.name;
getData = ^User|Employee => [name: String<1..>, ...] :: #;

getTricky = ^[a: Integer<5..20>, b: Real, c: Integer<4..22>, ... Integer<0..15>]|[a: Integer<14..26>, d: Integer<1..8>, ... Integer<0..10>]
    => [a: Integer<5..26>, b: Real, c: Integer<0..22>, d: Integer<0..15>, ...Integer<0..30>] :: #;

myFn = ^Array<String> => Any :: {
    john = [name: 'John', age: 30, position: 'Manager', salary: 10000, degree: 'Bachelor'];
    [
        getName(john),
        getData(john),
        getTricky[a: 18, b: 3, c: 10, d: 3]
    ]
};

main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};