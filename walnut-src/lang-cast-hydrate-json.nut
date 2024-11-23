module lang-cast-hydrate-json:

TaskEffort = $[hours: Integer<0..>, minutes: Integer[0, 15, 30, 45]];
UnknownEffort = :[];
Task <: [
    title: String<1..100>,
    effort: TaskEffort|UnknownEffort,
    done: Boolean
];

ProjectStatus = :[Draft, Active, Completed, OnHold, Canceled];
ProjectTitle = String<1..100>;
ProjectTag = String<1..>;
Project <: [
    ~ProjectTitle, /* shorthand for projectTitle: ProjectTitle */
    ~ProjectStatus,
    tags: Array<ProjectTag, ..10>,
    tasks: Array<Task>
];

/* there can be casts between any two named types */
UnknownEffort ==> String :: 'Unknown effort';
TaskEffort ==> String :: [$.hours->asString, ' hours ', ?whenValueOf($.minutes) is {
    0: '', ~ : [' and ', $.minutes->asString, ' minutes ']->combineAsString('')}]
    ->combineAsString('');

/* x->asString is the same as x->as(type{String}) */
Task ==> String :: [$.title, ' - ', $.effort->asString,
    ?whenValueOf($.done) is { true: '(done)', ~ : '(not done)' }]->combineAsString('');

/* some types may need an explicit casts from and to JsonValue in order to be serializable/hydratable */
UnknownEffort ==> JsonValue :: null;

/* all examples in one place */
test = ^Null => Any :: {
    project = Project[
        projectTitle: 'My Project',
        projectStatus: ProjectStatus.Active,
        tags: ['tag1', 'tag2'],
        tasks: [
            Task[title: 'Task 1', effort: TaskEffort[hours: 5, minutes: 15], done: true],
            Task[title: 'Task 2', effort: TaskEffort[hours: 2, minutes: 0], done: false],
            Task[title: 'Task 3', effort: UnknownEffort[], done: false]
        ]
    ];
    [
        taskAsString: project.tasks->item(0)->asString,
        projectAsJsonValue: project->asJsonValue,
        projectAsJsonString: project->asJsonValue->jsonStringify,
        projectAsJsonStringAndBack: ?noError(project->asJsonValue->jsonStringify)->jsonDecode,
        projectBackAsProject: ?noError(project->asJsonValue)->hydrateAs(type{Project})
    ]
};

/* call test in order to allow ?noError */
main = ^Array<String> => String :: test(null)->printed;

/*
Result: [
    taskAsString: 'Task 1 - 5 hours and 15 minutes (done)',
    projectAsJsonValue: [
        projectTitle: 'My Project',
        projectStatus: 'Active',
        tags: ['tag1', 'tag2'],
        tasks: [
            [title: 'Task 1', effort: [hours: 5, minutes: 15], done: true],
            [title: 'Task 2', effort: [hours: 2, minutes: 0], done: false],
            [title: 'Task 3', effort: null, done: false]
        ]
    ],
    projectAsJsonString: '{"projectTitle":"My Project","projectStatus":"Active","tags":["tag1","tag2"],
        "tasks":[{"title":"Task 1","effort":{"hours":5,"minutes":15},"done":true},
                 {"title":"Task 2","effort":{"hours":2,"minutes":0},"done":false},
                 {"title":"Task 3","effort":null,"done":false}]}',
     projectAsJsonStringAndBack: [
        projectTitle: 'My Project',
        projectStatus: 'Active',
        tags: ['tag1', 'tag2'],
        tasks: [
            [title: 'Task 1', effort: [hours: 5, minutes: 15], done: true],
            [title: 'Task 2', effort: [hours: 2, minutes: 0], done: false],
            [title: 'Task 3', effort: null, done: false]
        ]
    ],
    projectBackAsProject: Project[
        projectTitle: 'My Project',
        projectStatus: ProjectStatus.Active,
        tags: ['tag1', 'tag2'],
        tasks: [
            Task[title: 'Task 1', effort: TaskEffort[hours: 5, minutes: 15], done: true],
            Task[title: 'Task 2', effort: TaskEffort[hours: 2, minutes: 0], done: false],
            Task[title: 'Task 3', effort: UnknownEffort[], done: false]
        ]
    ]
]
*/