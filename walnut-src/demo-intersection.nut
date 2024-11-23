module demo-intersection:

User = [name: String<1..>, age: Integer<1..>, ...];
Employee = [name: String<1..>, position: String<1..>, salary: Integer<0..>, ...];

getName = ^User&Employee => String<1..> :: #.name;
getData = ^User&Employee => [name: String<1..>, age: Integer<1..>, position: String<1..>, salary: Integer<0..>] ::
    [name: #.name, age: #.age, position: #.position, salary: #.salary];

getTricky = ^[a: Integer<5..20>, b: Real, c: Integer<4..22>, ... Integer<0..15>]&[a: Integer<14..26>, d: Integer<1..8>, ... Integer<0..10>]
    => [a: Integer<14..20>, b: Integer<0..10>, c: Integer<4..10>, d: Integer<1..8>, ...Integer<0..10>] :: #;

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