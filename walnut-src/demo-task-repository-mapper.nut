module demo-task-repository-mapper %% demo-task-model, demo-task-repository:

TaskStorageData ==> Task @ HydrationError :: $->asJsonValue->hydrateAs(type{Task});

Task ==> TaskStorageData @ HydrationError :: [
    id: $id,
    title: $title,
    isDone: $isDone->value,
    dueDate: $dueDate->asString,
    createdAt: $createdAt->asString,
    description: $description
]->asJsonValue->hydrateAs(type{TaskStorageData});

==> TaskSource %% [~TaskRetrieveAll] :: ^Null => *Array<Task> :: %taskRetrieveAll
        => invoke
        -> map(^TaskStorageData => Result<Task, HydrationError> :: #->asTask)
        *> ('Cannot hydrate tasks');

==> SingleTaskSource %% [~TaskRetrieveById] :: ^[~TaskId] => *Result<Task, UnknownTaskId> :: {
    result = %taskRetrieveById |> invoke(#taskId);
    ?whenTypeOf(result) is {
        type{TaskStorageData}: result->asTask *> ('Cannot hydrate task'),
        type{Error<UnknownTask>}: @UnknownTaskId(#)
    }
};

TaskPersistEventListener = ^TaskAdded|TaskMarkedAsDone|TaskUnmarkedAsDone => *Null;
==> TaskPersistEventListener %% [~TaskPersist] :: ^TaskAdded|TaskMarkedAsDone|TaskUnmarkedAsDone => *Null :: {
    data = #->task->asTaskStorageData *> ('Cannot hydrate task storage data');
    %taskPersist(data) *> ('Cannot persist task');
    null
};

TaskRemoveEventListener = ^TaskRemoved => *Null;
==> TaskRemoveEventListener %% [~TaskRemoveById] :: ^TaskRemoved => *Null :: {
    %taskRemoveById(#->task->id) *> ('Cannot remove task');
    null
};
