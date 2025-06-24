module demo-method:

/* Let's define a type which will be injected as a dependency */
CommunicationProtocol := $[prefix: String];
/* Provide a getter for the dependency */
CommunicationProtocol->prefix(=> String) :: $prefix;
/* Provide a DI instance for that type */
==> CommunicationProtocol :: CommunicationProtocol['Dear '];


/* This is out main type */
Person := $[name: String<1..>, age: Integer<0..>];

/* An example where no parameter is passed (implying null) */
Person->greet(=> String) %% [~CommunicationProtocol] :: ['Hello, ', %communicationProtocol->prefix, $name]->combineAsString('');

/* An example where a parameter is passed */
Person->message(^String => String) %% CommunicationProtocol :: [%->prefix, $name, ', ', #]->combineAsString('');

/* An example where no parameter and no return types are specified, implying Null => Any */
Person->age() :: $age;

/* An example where no return type is specified, implying Any */
Person->askQuestion(^String) :: ?whenValueOf(#) is {
    'How old are you?': $age,
    'What is your name?': $name,
    ~: 'I do not understand the question'
};

main = ^Array<String> => String :: {
    person = Person['Alice', 27];
    [
        greetAlice: person->greet,
        messageToAlice: person->message('How are you?'),
        ageOfAlice: person->age,
        question1: person->askQuestion('How old are you?'),
        question2: person->askQuestion('What is your name?'),
        question3: person->askQuestion('What is your job?'),
        end: 'end'
    ]->printed
};