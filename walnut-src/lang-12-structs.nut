module lang-12-structs:
/* A Walnut-Lang implementation of https://github.com/gabrieldim/Go-Crash-Course/blob/main/12_structs/main.go */

NonEmptyString = String<1..>;
Gender := (Male, Female);
Age = Integer<0..>;

Person := #[
    firstName: NonEmptyString,
    lastName: Mutable<NonEmptyString>,
    city: NonEmptyString,
    ~Gender,
    age: Mutable<Age>
];
Person[
    firstName: NonEmptyString,
    lastName: NonEmptyString,
    city: NonEmptyString,
    ~Gender,
    ~Age
] :: [
    firstName: #firstName,
    lastName: mutable{NonEmptyString, #lastName},
    city: #city,
    gender: #gender,
    age: mutable{Age, #age}
];

Person->greet(=> String) :: 'Hello, my name is ' + $firstName + ' ' + $lastName->value +
    ' and i\`m ' + $age->value->asString;

Person->hasBirthday() :: $age->SET({$age->value} + 1);

Person->getMarried(^toPersonLastName: NonEmptyString => Null) :: ?whenValueOf($gender) is {
    Gender.Male: null,
    Gender.Female: {
        $lastName->SET(toPersonLastName);
        null
    }
};

main = ^Any => String :: {
    person1 = Person[
        firstName: 'Samantha',
        lastName: 'Rico',
        city: 'NYC',
        gender: Gender.Female,
        age: 23
    ];
    person2 = Person[
        firstName: 'Bob',
        lastName: 'Johnson',
        city: 'LA',
        gender: Gender.Male,
        age: 42
    ];

    person1->DUMPNL;
    person1.firstName->DUMPNL;
    person1->greet->DUMPNL;

    person1->hasBirthday;
    person1->hasBirthday;
    person1->hasBirthday;
    person1->hasBirthday;
    person1->greet->DUMPNL;

    person1->getMarried('Jackson');
    person1->greet->DUMPNL;
    person1->printed
};