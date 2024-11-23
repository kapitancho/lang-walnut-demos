module demo-user %% datetime, event, db-orm:

UserId <: String<36>;

InvalidEmailAddress = $[email: String];
EmailAddress <: String @ InvalidEmailAddress :: ?whenIsTrue {
    #->matchesRegexp('^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$'): null,
    ~: => @InvalidEmailAddress[#]
};

InvalidUsername = $[username: String];
Username <: String @ InvalidUsername :: ?whenIsTrue {
    #->matchesRegexp('^[a-zA-Z0-9._%+-]{3,}$'): null,
    ~: => @InvalidUsername[#]
};

InvalidPassword = $[password: String];
Password <: String @ InvalidPassword :: ?whenIsTrue {
    #->matchesRegexp('^[a-zA-Z0-9._%+-]{6,}$'): null,
    ~: => @InvalidPassword[#]
};

PasswordHash <: String;
Password ==> PasswordHash :: PasswordHash({PasswordString[$->baseValue]}->hash);

ProfileDetails <: [picture: String, description: String];

User = $[~UserId, ~EmailAddress, ~Username, ~PasswordHash, ~ProfileDetails];
User[~UserId, ~EmailAddress, ~Username, ~Password, ~ProfileDetails] :: [
    userId: #userId,
    emailAddress: #emailAddress,
    username: #username,
    passwordHash: #password->asPasswordHash,
    profileDetails: #profileDetails
];

UserJsonValue = [
    userId: String<36>,
    emailAddress: String<1..>,
    username: String<1..>,
    passwordHash: String<1..>,
    profileDetails: [picture: String, description: String]
];

UserStorageModel = [
    id: String<36>,
    username: String<1..>,
    email_address: String<1..>,
    password_hash: String<1..>,
    profile_picture: String,
    profile_description: String
];

UserStorageOrmModel = Type<UserStorageModel>;
UserStorageOrmModel ==> OrmModel :: OrmModel[table: 'users', keyField: 'id'];

UserStorageModel ==> UserJsonValue :: [
    userId: $id,
    username: $username,
    emailAddress: $email_address,
    passwordHash: $password_hash,
    profileDetails: [picture: $profile_picture, description: $profile_description]
];
UserJsonValue ==> UserStorageModel :: [
    id: $userId,
    username: $username,
    email_address: $emailAddress,
    password_hash: $passwordHash,
    profile_picture: $profileDetails.picture,
    profile_description: $profileDetails.description
];
UserJsonValue ==> User @ HydrationError :: $->asJsonValue->hydrateAs(type{User});
User ==> UserJsonValue @ HydrationError|InvalidJsonValue :: $=>asJsonValue->hydrateAs(type{UserJsonValue});


/* Test */
UserTest = ^Null => Any;
==> UserTest :: ^Null => Any :: {
    usm = [
        id: 'c47926fe-84b1-4153-8ad6-899b0225b4e5',
        username: 'test',
        email_address: 'test@test.com',
        password_hash: '123456',
        profile_picture: 'test.jpg',
        profile_description: 'test description'
    ];
    uj = usm => asUserJsonValue;
    u = uj => asUser;
    ujx = u => asUserJsonValue;
    usx = ujx => asUserStorageModel;
    [usm, uj, u, ujx, usx]
};

main = ^Array<String> => String %% [~UserTest] :: %userTest()->printed;
