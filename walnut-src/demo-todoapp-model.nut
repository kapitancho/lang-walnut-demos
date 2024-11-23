module demo-todoapp-model %% event, datetime:

TodoTaskId = String<36>;
TodoTask = $[id: TodoTaskId, title: String<1..>, isDone: Mutable<Boolean>, dueDate: Date, createdAt: DateAndTime, description: String];

TaskMarkedAsDone = $[~TodoTask];
TaskMarkedAsDone->todoTask(^Null => TodoTask) :: $.todoTask;
TaskUnmarkedAsDone = $[~TodoTask];
TaskUnmarkedAsDone->todoTask(^Null => TodoTask) :: $.todoTask;

TodoTask[title: String<1..>, dueDate: Date, description: String] %% [~Clock, ~Random] :: [
    id: %.random->uuid,
    title: #.title,
    isDone: Mutable[type{Boolean}, false],
    dueDate: #.dueDate,
    createdAt: %.clock->now,
    description: #.description
];
TodoTask->id(^Null => TodoTaskId) :: $.id;
TodoTask->isDone(^Null => Boolean) :: $.isDone->value;
TodoTask->markAsDone(^Null => *TaskMarkedAsDone) %% [~EventBus] :: {
    $.isDone->SET(true);
    %.eventBus => fire(TaskMarkedAsDone[$])
};
TodoTask->unmarkAsDone(^Null => *TaskUnmarkedAsDone) %% [~EventBus] :: {
    $.isDone->SET(false);
    %.eventBus => fire(TaskUnmarkedAsDone[$])
};
TaskUpdatedEventListener = ^TaskMarkedAsDone|TaskUnmarkedAsDone => *Null;

TodoTask ==> JsonValue :: [
    id: $.id,
    title: $.title,
    isDone: $.isDone->value,
    dueDate: $.dueDate,
    createdAt: $.createdAt,
    description: $.description
];

TodoBoardDataSource = Map<TodoTask>;

UnknownTask = $[~TodoTaskId];
TaskAlreadyExists = $[~TodoTaskId];
TaskAdded = $[task: TodoTask];
TaskRemoved = $[task: TodoTask];

TodoBoard = [
    addTask: ^TodoTask => *Result<TaskAdded, TaskAlreadyExists>,
    removeTask: ^[~TodoTaskId] => *Result<TaskRemoved, UnknownTask>,
    taskWithId: ^[~TodoTaskId] => *Result<TodoTask, UnknownTask>,
    allTasks: ^Null => *Array<TodoTask>
];

TodoBoard ==> JsonValue @ InvalidJsonValue :: $.allTasks()->asJsonValue;
