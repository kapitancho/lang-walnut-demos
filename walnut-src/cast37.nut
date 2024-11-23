module cast37:

Uuid = String;
MemberId = Uuid;
Username = String;
EmailAddress = String;
Password = String;
PasswordHash = String;
ProfileDetails = [
    profilePicture: String,
    profileDescription: String
];
MemberData = [~MemberId, ~EmailAddress, ~Username, ~PasswordHash, ~ProfileDetails];
UnknownMember = :[];

/*Members = [
    member: ^[~MemberId] => Result<Member, UnknownMember|ExternalError>,
    ~MemberByUsername,
    memberByEmail: ^[~EmailAddress] => Result<Member, UnknownMember|ExternalError>,
    register: ^[~EmailAddress, ~Username, ~Password, ~ProfileDetails, activateUser: Boolean] => Result<Member, ExternalError>
];
Content = [search: ^String => Array<ContentData>];*/

Member = $[memberData: Mutable<MemberData>];
Member->memberId(^Null => MemberId) :: $.memberData->value.memberId;

MemberForData = ^[~MemberData] => Member;
MemberDataById = ^[~MemberId] => Result<MemberData, UnknownMember|ExternalError>;
MemberDataByUsername = ^[~Username] => Result<MemberData, UnknownMember|ExternalError>;

memberForData = ^[~MemberData] => Member :: Member[Mutable[type{MemberData}, #.memberData]];
memberDataById = ^[~MemberId] => MemberData :: [
    memberId: #.memberId,
    emailAddress: 'a@b.com',
    username: 'user',
    passwordHash: 'hash',
    profileDetails: [profilePicture : 'pic', profileDescription: 'desc']
];

memberDataByUsername = ^[~Username] => MemberData :: [
    memberId: 'memberId',
    emailAddress: 'a@b.com',
    username: #.username,
    passwordHash: 'hash',
    profileDetails: [profilePicture : 'pic', profileDescription: 'desc']
];

Members = :[];
Members->member(^[~MemberId] => Result<Member, UnknownMember|ExternalError>)
    %% [~MemberDataById, ~MemberForData] :: %.memberForData[?noError(%.memberDataById(#))];
Members->memberByUsername(^[~Username] => Result<Member, UnknownMember|ExternalError>)
    %% [~MemberDataByUsername, ~MemberForData] :: %.memberForData[?noError(%.memberDataByUsername(#))];

Content = :[];

App = [~Members, ~Content];

myFn = ^Array<String> => Any :: {
    ctr = DependencyContainer[];
    app = ?noError(ctr->valueOf(type{App}));
    [
        ?noError(app.members->member[memberId: 'ABC'])->memberId,
        ?noError(app.members->memberByUsername['ABC'])->memberId/*,
        ?noError(app.members->member[memberId: 'ABC'])->profile->accountSettings,
        {{app.members.memberByUsername['ABC']}.profile()}.accountSettings(),
        {{{app.members.memberByUsername['ABC']}.profile()}.withNewUsername['New username']}.accountSettings()*/
    ]
};

main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};