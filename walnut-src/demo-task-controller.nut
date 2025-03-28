module demo-task-controller %% demo-task-api:

==> ListTasks %% [~TaskBoard] :: ^[:] => *Array<TaskData> ::
    %taskBoard=>allTasks->map(^Task => TaskData :: #->as(type{TaskData}));
==> TaskById %% [~TaskBoard] :: ^[~TaskId] => *Result<TaskData, UnknownTaskId> ::
    %taskBoard=>taskWithId(#)->as(type{TaskData});
==> AddTask %% [~TaskBoard] :: ^[~NewTaskData] => Result<TaskAdded, TaskNotAdded> :: {
    result = %taskBoard->addTask[Task(#newTaskData)];
    ?whenTypeOf(result) is {
        type{TaskAdded}: result,
        ~: Error(TaskNotAdded())
    }
};
==> MarkTaskAsDone %% [~TaskBoard] :: ^[~TaskId] => *Result<TaskMarkedAsDone, UnknownTaskId> ::
    %taskBoard=>taskWithId(#)=>markAsDone;
==> UnmarkTaskAsDone %% [~TaskBoard] :: ^[~TaskId] => *Result<TaskUnmarkedAsDone, UnknownTaskId> ::
    %taskBoard=>taskWithId(#)=>unmarkAsDone;
==> RemoveTask %% [~TaskBoard] :: ^[~TaskId] => *Result<TaskRemoved, UnknownTaskId> ::
    %taskBoard=>removeTask(#);

