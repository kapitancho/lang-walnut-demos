module demo-task-repository-config %% demo-task-repository-mapper, demo-task-db:
==> DatabaseConnection :: DatabaseConnection['sqlite:db.sqlite'];

/*
module demo-task-repository-config %% demo-task-repository-mapper, demo-task-db:
==> DatabaseConnection :: DatabaseConnection['sqlite:db.sqlite'];
*/

/*
module demo-task-repository-config %% demo-task-repository-mapper, demo-task-json-file:
==> JsonFileTaskList @ CannotWriteFile :: JsonFileTaskList[jsonStorage: {File['tasks.json']}=>createIfMissing('{}')];
*/

/*
module demo-task-repository-config %% demo-task-repository-mapper, demo-task-in-memory:
==> InMemoryTaskList :: mutable{Map<TaskStorageData>, [:]};
*/

==> EventBus %% [
    ~TaskPersistEventListener,
    ~TaskRemoveEventListener
] :: EventBus[listeners: %->values];