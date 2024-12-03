module demo-todoapp-json-file %% demo-todoapp-model, fs:

TodoTaskJsonStorage = $[jsonStorage: File];
TodoTaskJsonStorage->retrieve(^Null => Result<Array<TodoTask>, HydrationError|InvalidJsonString|CannotReadFile>) ::
    $jsonStorage=>content => jsonDecode => hydrateAs(type{Array<TodoTask>});
TodoTaskJsonStorage->persist(^Array<TodoTask> => Result<Array<TodoTask>, CannotWriteFile|InvalidJsonValue>) :: {
    $jsonStorage=>replaceContent(#=>jsonStringify);
    #
};

JsonFileTodoBoard = $[~TodoTaskJsonStorage];
JsonFileTodoBoard->addTask(^TodoTask => *Result<TaskAdded, TaskAlreadyExists>) :: {
    todoTaskId = #->id;
    tasks = $todoTaskJsonStorage->retrieve *> ('Invalid JSON file');
    item = tasks->findFirst(^TodoTask => Boolean :: {#->id} == todoTaskId);
    ?whenTypeOf(item) is {
        type{TodoTask}: @TaskAlreadyExists[#->id],
        ~: {
            result = $todoTaskJsonStorage->persist(tasks->insertLast(#)) *> ;
            TaskAdded[#]
        }
    }
};
JsonFileTodoBoard->removeTask(^[~TodoTaskId] => *Result<TaskRemoved, UnknownTask>) :: {
    todoTaskId = #.todoTaskId;
    tasks = $todoTaskJsonStorage->retrieve *> ('Invalid JSON file');
    item = tasks->findFirst(^TodoTask => Boolean :: {#->id} == todoTaskId);
    ?whenTypeOf(item) is {
        type{TodoTask}: {
            withoutTask = tasks->without(item) *> ('Task not found');
            result = $todoTaskJsonStorage->persist(withoutTask) *> ('Unable to persist tasks');
            TaskRemoved[item]
        },
        ~: @UnknownTask[#.todoTaskId]
    }
};
JsonFileTodoBoard->taskWithId(^[~TodoTaskId] => *Result<TodoTask, HydrationError|MapItemNotFound|UnknownTask>) :: {
    todoTaskId = #.todoTaskId;
    tasks = $todoTaskJsonStorage->retrieve *> ('Invalid JSON file');
    item = tasks->findFirst(^TodoTask => Boolean :: {#->id} == todoTaskId);
    ?whenTypeOf(item) is {
        type{TodoTask}: item,
        ~: @UnknownTask[#.todoTaskId]
    }
};
JsonFileTodoBoard->allTasks(^Null => *Array<TodoTask>) :: $todoTaskJsonStorage->retrieve *> ('Invalid JSON file');

JsonFileTodoBoard ==> TodoBoard :: [
    addTask: ^TodoTask => *Result<TaskAdded, TaskAlreadyExists> :: $->addTask(#),
    removeTask: ^[~TodoTaskId] => *Result<TaskRemoved, UnknownTask> :: $->removeTask(#),
    taskWithId: ^[~TodoTaskId] => *Result<TodoTask, UnknownTask> :: {
        result = $->taskWithId(#);
        ?whenTypeOf(result) is {
            type{Result<TodoTask, UnknownTask>}: result,
            type{Error}: result *> ('Unable to retrieve task')
        }
    },
    allTasks: ^Null => *Array<TodoTask> :: $->allTasks *>
];

==> TaskUpdatedEventListener %% [~TodoTaskJsonStorage] :: ^TaskMarkedAsDone|TaskUnmarkedAsDone => *Null :: {
    task = #->todoTask;
    todoTaskId = task->id;
    tasks = {%.todoTaskJsonStorage->retrieve} *> ('Invalid JSON file');
    item = {tasks->findFirst(^TodoTask => Boolean :: {#->id} == todoTaskId)} *> ('Task not found');
    %.todoTaskJsonStorage->persist(tasks->map(^TodoTask => TodoTask :: ?whenValueOf(#->id) is { todoTaskId: task, ~ : #}));
    null
};