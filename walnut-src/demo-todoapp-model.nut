module demo-todoapp-model %% $event, $datetime:

TodoTaskId = #Uuid;
TodoTask = $[
    id: TodoTaskId,
    title: String<1..>,
    isDone: Mutable<Boolean>,
    dueDate: Date,
    createdAt: DateAndTime,
    description: String
];

TaskMarkedAsDone = $[~TodoTask];
TaskMarkedAsDone->todoTask(^Null => TodoTask) :: $todoTask;
TaskUnmarkedAsDone = $[~TodoTask];
TaskUnmarkedAsDone->todoTask(^Null => TodoTask) :: $todoTask;

TodoTask[title: String<1..>, dueDate: Date, description: String] %% [~Clock, ~Random] :: [
    id: TodoTaskId(%random->uuid),
    title: #title,
    isDone: mutable{Boolean, false},
    dueDate: #dueDate,
    createdAt: %clock->now,
    description: #description
];
TodoTask->id(=> TodoTaskId) :: $id;
TodoTask->isDone(=> Boolean) :: $isDone->value;
TodoTask->markAsDone(=> *TaskMarkedAsDone) %% [~EventBus] :: {
    $isDone->SET(true);
    %eventBus => fire(TaskMarkedAsDone[$])
};
TodoTask->unmarkAsDone(=> *TaskUnmarkedAsDone) %% [~EventBus] :: {
    $isDone->SET(false);
    %eventBus => fire(TaskUnmarkedAsDone[$])
};
TaskUpdatedEventListener = ^TaskMarkedAsDone|TaskUnmarkedAsDone => *Null;

TodoTask ==> JsonValue :: $->shape(`JsonValue);


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

TodoBoard ==> JsonValue @ InvalidJsonValue :: $allTasks()->asJsonValue;
