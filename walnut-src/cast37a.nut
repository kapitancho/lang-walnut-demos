module cast37:

Uuid = String;
MemberId = Uuid;
ContentTitle = String;
ContentText = String;
ContentId = Uuid;
ContentKey = String;
UnknownContentEntry = :[];
MemberContentEntry = [
    updateTitle: ^[~ContentTitle] => `MemberContentEntry,
    startEdit: ^Null => `MemberContentEntry,
    updateContent: ^[~ContentText] => `MemberContentEntry,
    discardChanges: ^Null => Null,
    publish: ^Null => `MemberContentEntry,
    contentId: ^Null => ContentId,
    contentKey: ^Null => ContentKey,
    remove: ^Null => Null
];
MemberContent = [
    createDraft: ^[~ContentTitle, ~ContentText] => Null,
    entry: ^[~ContentId] => Result<MemberContentEntry, UnknownContentEntry|ExternalError>
];
Username = String;
EmailAddress = String;
Password = String;
PasswordHash = String;
ProfileDetails = [
    profilePicture: String,
    profileDescription: String
];
MemberData = [~MemberId, ~EmailAddress, ~Username, ~PasswordHash, ~ProfileDetails];
AccountSettingsData = MemberData;
MemberFeed = [];
MemberSocial = [];
MemberMessaging = [];
MemberNotifications = [];
ContactMessageData = [subject: String, body: String];
ContentData = [~ContentTitle, ~ContentText];
Content = [search: ^String => Array<ContentData>];
MemberProfile = [
    withNewUsername: ^[~Username] => `MemberProfile,
    withNewEmailAddress: ^[~EmailAddress] => `MemberProfile,
    withNewPassword: ^[~Password, tokenProtection: String|Null] => `MemberProfile,
    confirmRegistration: ^Null => `MemberProfile,
    passwordRecoveryRequest: ^Null => `MemberProfile,
    withNewProfileDetails: ^[~ProfileDetails] => `MemberProfile,
    accountSettings: ^Null => AccountSettingsData,
    isAuthorizedWithPassword: ^[~Password] => Boolean
];
Member = [
    content: ^Null => MemberContent,
    profile: ^Null => MemberProfile,
    feed: ^Null => MemberFeed,
    social: ^Null => MemberSocial,
    messaging: ^Null => MemberMessaging,
    notifications: ^Null => MemberNotifications,
    unregister: ^Null => Null,
    sendContactMessage: ^[~ContactMessageData] => Null,
    memberId: ^Null => MemberId
];
UnknownMember = :[];
MemberByUsername = ^[~Username] => Result<Member, UnknownMember|ExternalError>;
Members = [
    member: ^[~MemberId] => Result<Member, UnknownMember|ExternalError>,
    ~MemberByUsername,
    memberByEmail: ^[~EmailAddress] => Result<Member, UnknownMember|ExternalError>,
    register: ^[~EmailAddress, ~Username, ~Password, ~ProfileDetails, activateUser: Boolean] => Result<Member, ExternalError>
];

App = [~Members, ~Content];


/*getContainerConfig = ^Null => ContainerConfiguration :: {
    []
};*/

MyApp <: [~Members, ~Content];
MemberForData = ^[~MemberData] => Member;
MemberDataById = ^[~MemberId] => Result<MemberData, UnknownMember|ExternalError>;
MemberDataByUsername = ^[~Username] => Result<MemberData, UnknownMember|ExternalError>;
MyMembers <: [~MemberForData, ~MemberDataById, ~MemberByUsername];
MyContent = :[];


MemberByUsernameQuery <: [~MemberForData, ~MemberDataByUsername];
MemberByUsernameQuery ==> MemberByUsername :: ^[~Username] => Result<Member, UnknownMember|ExternalError> :: {
    $.memberForData[?noError($.memberDataByUsername[#.username])]
};

MemberProfileForData = ^[~MemberData] => MemberProfile;
MyMember <: [~MemberData, ~MemberProfileForData];

MyMember ==> Member :: [
    content: ^Null => MemberContent :: [
        createDraft: ^[~ContentTitle, ~ContentText] => Null :: null,
        entry: ^[~ContentId] => Result<MemberContentEntry, UnknownContentEntry|ExternalError> :: {
            Error(UnknownContentEntry[])
        }
    ],
    profile: ^Null => MemberProfile :: {
        $.memberProfileForData[$.memberData]
    },
    feed: ^Null => MemberFeed :: [],
    social: ^Null => MemberSocial :: [],
    messaging: ^Null => MemberMessaging :: [],
    notifications: ^Null => MemberNotifications :: [],
    unregister: ^Null => Null :: null,
    sendContactMessage: ^[~ContactMessageData] => Null :: null,
    memberId: ^Null => MemberId :: $.memberData.memberId
];

MemberForDataFactory <: [~MemberProfileForData];
MemberForDataFactory ==> MemberForData :: {
    ^[~MemberData] => Member :: {
        {MyMember[#.memberData, $.memberProfileForData]}->as(type{Member})
    }
};

ChangeUsername = ^[~MemberData, ~Username] => MemberData;

MyMemberProfile <: [~MemberData, ~MemberProfileForData, ~ChangeUsername];
MyMemberProfile ==> MemberProfile :: {
    p = ^Null => MemberProfile :: $->as(type{MemberProfile});
    [
        withNewUsername: ^[~Username] => MemberProfile :: {
            result = $.changeUsername[$.memberData, #.username];
            $.memberProfileForData[result]
        },
        withNewEmailAddress: ^[~EmailAddress] => MemberProfile :: p(),
        withNewPassword: ^[~Password, tokenProtection: String|Null] => MemberProfile :: p(),
        confirmRegistration: ^Null => MemberProfile :: p(),
        passwordRecoveryRequest: ^Null => MemberProfile :: p(),
        withNewProfileDetails: ^[~ProfileDetails] => MemberProfile :: p(),
        accountSettings: ^Null => AccountSettingsData :: $.memberData,
        isAuthorizedWithPassword: ^[~Password] => Boolean :: false
    ]
};

MemberProfileForDataFactory = $[~ChangeUsername];
MemberProfileForDataFactory ==> MemberProfileForData :: {
    ^[~MemberData] => MemberProfile :: {
        {MyMemberProfile[#.memberData, $->as(type{MemberProfileForData}), $.changeUsername]}->as(type{MemberProfile})
    }
};

MemberRepository = :[];
MemberRepository ==> MemberDataById :: ^[~MemberId] => Result<MemberData, UnknownMember|ExternalError> :: [
    memberId: #.memberId,
    emailAddress: 'mail@mail.com',
    username: 'username',
    passwordHash: 'password hash',
    profileDetails: [profilePicture: 'pic', profileDescription: 'desc']
];
MemberRepository ==> MemberDataByUsername :: ^[~Username] => Result<MemberData, UnknownMember|ExternalError> :: [
    memberId: 'memberId',
    emailAddress: 'mail@mail.com',
    username: #.username,
    passwordHash: 'password hash',
    profileDetails: [profilePicture: 'pic', profileDescription: 'desc']
];

EventListener = ^Any => Any;
AppEventListener = :[];
AppEventListener ==> EventListener :: ^Any => Any :: null;

UsernameChanged <: [~MemberData, previousState: MemberData];
ChangeUsernameCommand <: [~EventListener];
ChangeUsernameCommand ==> ChangeUsername :: {
    ^[~MemberData, ~Username] => MemberData :: {
        m = #.memberData->with[username: #.username];
        $.eventListener(UsernameChanged[m, #.memberData]);
        m
    }
};


MyApp ==> App :: $;
MyMembers ==> Members :: [
    member: ^[~MemberId] => Result<Member, UnknownMember|ExternalError> :: {
        $.memberForData[$.memberDataById[#.memberId]]
    },
    memberByUsername: $.memberByUsername,
    memberByEmail: ^[~EmailAddress] => Result<Member, UnknownMember|ExternalError> :: { @ UnknownMember() },
    register: ^[~EmailAddress, ~Username, ~Password, ~ProfileDetails, activateUser: Boolean] => Result<Member, ExternalError> :: {
        @ UnknownMember()
    }
];
MyContent ==> Content :: [
    search: ^String => Array<ContentData> :: []
];

myFn = ^Array<String> => Any :: {
    ctr = Container[getContainerConfig()];
    app = ctr->instanceOf(App);
    [
        {app.members.member['ABC']}.memberId(),
        {{app.members.member['ABC']}.profile()}.accountSettings(),
        {app.members.memberByUsername['ABC']}.memberId(),
        {{app.members.memberByUsername['ABC']}.profile()}.accountSettings(),
        {{{app.members.memberByUsername['ABC']}.profile()}.withNewUsername['New username']}.accountSettings()
    ]
};

main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};