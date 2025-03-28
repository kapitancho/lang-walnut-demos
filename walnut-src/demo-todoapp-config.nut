module demo-todoapp-config %% $event, demo-todoapp-model, demo-todoapp-json-file, demo-todoapp-http, $http/middleware:

==> LookupRouterMapping :: [
    [path: '/v1', type: type{TodoTaskHttpHandler}]
];

==> CompositeHandler %% [
    defaultHandler: NotFoundHandler,
    ~LookupRouter,
    ~CorsMiddleware
] :: CompositeHandler[
    defaultHandler: %.defaultHandler->as(type{HttpRequestHandler}),
    middlewares: [
        %.corsMiddleware->as(type{HttpMiddleware}),
        %.lookupRouter->as(type{HttpMiddleware})
    ]
];

==> EventBus %% [
    ~TaskUpdatedEventListener
] :: EventBus[listeners: [
    %.taskUpdatedEventListener
]];

==> TodoTaskJsonStorage @ CannotWriteFile :: TodoTaskJsonStorage[jsonStorage: {File['tasks.json']}=>createIfMissing('[]')];
==> TodoBoard %% JsonFileTodoBoard :: %->as(type{TodoBoard});

/*
==> TodoBoardDataSource @ InvalidDate :: {
    task1 = TodoTask[title: 'Task 1', dueDate: ?noError(Date[2024, 6, 30]), description: 'This is the first task'];
    [:]->withKeyValue[key: task1->id, value: task1]
};

==> TodoBoard %% InMemoryTodoBoard :: %->as(type{TodoBoard});
*/

/*

==> DatabaseConnection :: DatabaseConnection['sqlite:db.sqlite'];
==> TodoBoard %% DbTodoBoard :: %->as(type{TodoBoard});

*/