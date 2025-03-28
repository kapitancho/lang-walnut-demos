module demo-task-db %% demo-task-repository, db:

DatabaseQueryResultRow ==> TaskStorageData @ HydrationError|MapItemNotFound :: [
    id: $ => item('id'),
    title: $ => item('title'),
    description: $ => item('description'),
    isDone: {$ => item('is_done')} == 1,
    dueDate: $ => item('due_date'),
    createdAt: $ => item('created_at')
] => asJsonValue => hydrateAs(type{TaskStorageData});

TaskStorageData ==> DatabaseQueryBoundParameters :: [
    id: $id,
    title: $title,
    description: $description,
    isDone: ?whenIsTrue { $isDone: 1, ~: 0 },
    dueDate: $dueDate->asString,
    createdAt: $createdAt->asString
];

==> TaskRetrieveAll  %% [~DatabaseConnector] :: ^Null => *Array<TaskStorageData> :: {
    retriever = ^Null => Result<Array<TaskStorageData>, HydrationError|MapItemNotFound|DatabaseQueryFailure> ::
        {%databaseConnector=>query[query: 'SELECT * FROM tasks', boundParameters: [:]]}
            =>map(^DatabaseQueryResultRow => Result<TaskStorageData, HydrationError|MapItemNotFound> :: #=>asTaskStorageData);
    retriever() *> ('Unable to retrieve tasks')
};
==> TaskRetrieveById %% [~DatabaseConnector] :: ^String<36> => *Result<TaskStorageData, UnknownTask> :: {
    taskId = #;
    retriever = ^Null => Result<TaskStorageData, DatabaseQueryFailure|HydrationError|MapItemNotFound|IndexOutOfRange> ::
        {%databaseConnector=>query[query: 'SELECT * FROM tasks WHERE id = :todoTaskId', boundParameters: [taskId]]}
            =>item(0)=>asTaskStorageData;
    result = retriever();
    ?whenTypeOf(result) is {
        type{Error<IndexOutOfRange>}: @UnknownTask(),
        ~: result *> ('Unable to retrieve task')
    }
};
==> TaskPersist      %% [~TaskRetrieveById, ~DatabaseConnector] :: ^TaskStorageData => *TaskStorageSuccessful :: {
    task = #;
    existingTask = %taskRetrieveById |> invoke(task.id);
    ?whenTypeOf(existingTask) is {
        type{TaskStorageData}: {
            result = {%databaseConnector->execute[
                query: 'UPDATE tasks SET title = :title, description = :description, is_done = :isDone, due_date = :dueDate WHERE id = :id',
                boundParameters: #->asDatabaseQueryBoundParameters
            ]} *> ('Unable to update task');
            TaskStorageSuccessful()
        },
        type{Error<UnknownTask>}: {
            result = {%databaseConnector->execute[
                query: 'INSERT INTO tasks (id, title, description, is_done, due_date, created_at) VALUES (:id, :title, :description, :isDone, :dueDate, :createdAt)',
                boundParameters: #->asDatabaseQueryBoundParameters
            ]} *> ('Unable to create task');
            TaskStorageSuccessful()
        }
    }
};
==> TaskRemoveById   %% [~TaskRetrieveById, ~DatabaseConnector] :: ^String<36> => *Result<TaskStorageSuccessful, UnknownTask> :: {
    taskId = #;
    task = %taskRetrieveById => invoke(taskId);
    persister = ^Null => Result<Integer<0..>, DatabaseQueryFailure> ::
        %databaseConnector=>execute[query: 'DELETE FROM tasks WHERE id = :id', boundParameters: [id: taskId]];
    result = persister() *> ('Unable to remove task');
    ?whenTypeOf(result) is {
        type{Integer<1..>}: TaskStorageSuccessful(),
        ~: @UnknownTask()
    }
};
