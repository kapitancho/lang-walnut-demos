module demo-todoapp-in-memory %% demo-todoapp-model:

InMemoryTodoBoard = $[tasks: Mutable<Map<TodoTask>>];
InMemoryTodoBoard(Null) %% TodoBoardDataSource :: [tasks: Mutable[type{Map<TodoTask>}, %]];
InMemoryTodoBoard->addTask(^TodoTask => Result<TaskAdded, TaskAlreadyExists>) :: ?whenIsTrue {
    $.tasks->value->keyExists(#->id): Error(TaskAlreadyExists[#->id]),
    ~: {
        $.tasks->SET($.tasks->value->withKeyValue[key: #->id, value: #]);
        TaskAdded[task: #]
    }
};
InMemoryTodoBoard->removeTask(^[~TodoTaskId] => Result<TaskRemoved, UnknownTask>) :: {
    x = $.tasks->value->withoutByKey(#.todoTaskId);
    ?whenTypeOf(x) is {
        type[map: Map<TodoTask>, element: TodoTask]: {
            $.tasks->SET(x.map);
            TaskRemoved[task: x.element]
        },
        ~: Error(UnknownTask[#.todoTaskId])
    }
};
InMemoryTodoBoard->taskWithId(^[~TodoTaskId] => Result<TodoTask, UnknownTask>) :: {
    task = $.tasks->value->item(#.todoTaskId);
    ?whenTypeOf(task) is {
        type{TodoTask}: task,
        ~: Error(UnknownTask(#))
    }
};
InMemoryTodoBoard->allTasks(^Null => Array<TodoTask>) :: $.tasks->value->values;

InMemoryTodoBoard ==> TodoBoard :: [
    addTask: ^TodoTask => Result<TaskAdded, TaskAlreadyExists> :: $->addTask(#),
    removeTask: ^[~TodoTaskId] => Result<TaskRemoved, UnknownTask> :: $->removeTask(#),
    taskWithId: ^[~TodoTaskId] => Result<TodoTask, UnknownTask> :: $->taskWithId(#),
    allTasks: ^Null => Array<TodoTask> :: $->allTasks
];

==> TaskUpdatedEventListener :: ^TaskMarkedAsDone|TaskUnmarkedAsDone => Null :: null;