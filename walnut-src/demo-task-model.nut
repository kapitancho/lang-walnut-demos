module demo-task-model %% datetime, event:

TaskId = String<36>;
Task = $[id: TaskId, title: String<1..>, isDone: Mutable<Boolean>, dueDate: Date, createdAt: DateAndTime, description: String];

TaskSource = ^Null => *Array<Task>;
UnknownTaskId = $[~TaskId];
SingleTaskSource = ^[~TaskId] => *Result<Task, UnknownTaskId>;

TaskBoard = $[~TaskSource, ~SingleTaskSource];

TaskAdded          = $[~Task]; TaskAdded->task(^Null => Task) :: $task;
TaskMarkedAsDone   = $[~Task]; TaskMarkedAsDone->task(^Null => Task) :: $task;
TaskUnmarkedAsDone = $[~Task]; TaskUnmarkedAsDone->task(^Null => Task) :: $task;
TaskRemoved        = $[~Task]; TaskRemoved->task(^Null => Task) :: $task;

Task[title: String<1..>, dueDate: Date, description: String] %% [~Clock, ~Random] :: [
    id: %random->uuid,
    title: #title,
    isDone: Mutable[type{Boolean}, false],
    dueDate: #dueDate,
    createdAt: %clock->now,
    description: #description
];

Task->id(^Null => TaskId) :: $id;
Task->isDone(^Null => Boolean) :: $isDone->value;
Task->markAsDone(^Null => *TaskMarkedAsDone) %% [~EventBus] :: {
    $isDone->SET(true);
    %eventBus=>fire(TaskMarkedAsDone[$])
};
Task->unmarkAsDone(^Null => *TaskUnmarkedAsDone) %% [~EventBus] :: {
    $isDone->SET(false);
    %eventBus=>fire(TaskUnmarkedAsDone[$])
};

TaskAlreadyExists = $[~Task];
TaskBoard->addTask(^[~Task] => *Result<TaskAdded, TaskAlreadyExists>) %% [~SingleTaskSource, ~EventBus] :: {
    existingTask = %singleTaskSource |> invoke[#task->id];
    ?whenTypeOf(existingTask) is {
        type{Task}: @TaskAlreadyExists(#),
        type{Error<UnknownTaskId>}: %eventBus=>fire(TaskAdded(#))
    }
};
TaskBoard->removeTask(^[~TaskId] => *Result<TaskRemoved, UnknownTaskId>) %% [~SingleTaskSource, ~EventBus] :: {
    existingTask = %singleTaskSource |> invoke(#);
    ?whenTypeOf(existingTask) is {
        type{Task}: %eventBus=>fire(TaskRemoved[existingTask]),
        type{Error<UnknownTaskId>}: existingTask
    }
};
TaskBoard->taskWithId(^[~TaskId] => *Result<Task, UnknownTaskId>) %% [~SingleTaskSource] :: %singleTaskSource(#);
TaskBoard->allTasks(^Null => *Array<Task>) %% [~TaskSource] :: %taskSource();

/*
==> EventBus :: EventBus[listeners: []];
==> SingleTaskSource :: ^[~TaskId] => *Result<Task, UnknownTaskId> :: @UnknownTaskId(#);
==> TaskSource :: ^Null => *Array<Task> :: [];
*/