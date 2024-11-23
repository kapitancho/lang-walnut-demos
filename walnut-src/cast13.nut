module cast13:

Age = Integer<1..>;
PersonName = String<2..>;
EmployeePosition = :[Developer, QA, Manager];

Apple = [
    color: ^Integer => String
];
Pineapple <: [
    size: Integer
];
Pineapple ==> Apple :: [
    color: ^Integer => String :: {
        {{{'Hi: '}->concat(#->asString)}->concat(' = ')}->concat({$.size}->asString)
    }
];

Person = [name: PersonName, age: Age, ...];
Employee = Person & [position: EmployeePosition, ...];

Salary = Integer<0..>;

getSalary = ^Employee => Salary :: {
    50000
};

myFn = ^Array<String> => Any :: [
    getSalary([name: 'Kiro', age: 25, position: EmployeePosition.Developer]),
    p = Pineapple([20]),
    p->as(type{Apple}).color(4)
];

main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};