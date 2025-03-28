module lang-12-structs:
/* A Walnut-Lang implementation of https://github.com/gabrieldim/Go-Crash-Course/blob/main/12_structs/main.go */

NonEmptyString = String<1..>;
Gender = :[Male, Female];
Age = Integer<0..>;

Person = #[
    firstName: NonEmptyString,
    lastName: Mutable<NonEmptyString>,
    city: NonEmptyString,
    ~Gender,
    age: Mutable<Age>
];

Person->greet(^Null => String) :: [
    'Hello, my name is ', $firstName, ' ', $lastName->value, ' and i\`m ', $age->value->asString
]->combineAsString('');

Person->hasBirthday(^Null => Null) :: {
    $age->SET({$age->value} + 1);
    null
};

Person->getMarried(^NonEmptyString => Null) :: ?whenValueOf($gender) is {
    Gender.Male: null,
    Gender.Female: {
        $lastName->SET(#);
        null
    }
};

main = ^Any => String :: {
    person1 = Person[
        firstName: 'Samantha',
        lastName: mutable{NonEmptyString, 'Rico'},
        city: 'NYC',
        gender: Gender.Female,
        age: mutable{Age, 23}
    ];
    person2 = Person[
        firstName: 'Bob',
        lastName: mutable{NonEmptyString, 'Johnson'},
        city: 'LA',
        gender: Gender.Male,
        age: mutable{Age, 42}
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