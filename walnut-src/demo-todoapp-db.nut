module demo-todoapp-db %% demo-todoapp-model, $db/core:

DatabaseQueryResultRow ==> TodoTask @ HydrationError|MapItemNotFound :: [
    id: $ => item('id'),
    title: $ => item('title'),
    description: $ => item('description'),
    isDone: {$ => item('is_done')} == 1,
    dueDate: $ => item('due_date'),
    createdAt: $ => item('created_at')
] => asJsonValue => hydrateAs(type{TodoTask});

TodoTask ==> DatabaseQueryBoundParameters :: [
    id: $id->value->value,
    title: $title,
    description: $description,
    isDone: ?whenIsTrue { $isDone: 1, ~: 0 },
    dueDate: $dueDate->asString,
    createdAt: $createdAt->asString
];

DbTodoBoard = :[];
DbTodoBoard->addTask(^TodoTask => *Result<TaskAdded, TaskAlreadyExists>) %% DatabaseConnector :: {
    existing = $->taskWithId[#->id];
    ?whenTypeOf(existing) is {
        type{TodoTask}: @TaskAlreadyExists[#->id],
        ~: {
            result = %->execute[
                query: 'INSERT INTO tasks (id, title, description, is_done, due_date, created_at) VALUES (:id, :title, :description, :isDone, :dueDate, :createdAt)',
                boundParameters: #->asDatabaseQueryBoundParameters
            ];
            ?whenTypeOf(result) is {
                type{Integer<0..>}: TaskAdded[task: #],
                type{Error<DatabaseQueryFailure>}: @{result->error->asExternalError}
            }
        }
    }
};
DbTodoBoard->removeTask(^[~TodoTaskId] => *Result<TaskRemoved, UnknownTask>) %% DatabaseConnector :: {
    existing = $->taskWithId[#.todoTaskId];
    ?whenTypeOf(existing) is {
        type{TodoTask}: {
            result = %->execute[
                query: 'DELETE FROM tasks WHERE id = ?',
                boundParameters: [#.todoTaskId->value->value]
            ];
            ?whenTypeOf(result) is {
                type{Integer<0..>}: TaskRemoved[task: existing],
                type{Error<DatabaseQueryFailure>}: @{result->error->asExternalError}
            }
        },
        ~: @UnknownTask[#.todoTaskId]
    }
};
DbTodoBoard->taskWithId(^[~TodoTaskId] => *Result<TodoTask, HydrationError|MapItemNotFound|UnknownTask>) %% DatabaseConnector :: {
    data = %->query[query: 'SELECT * FROM tasks WHERE id = :todoTaskId', boundParameters: [todoTaskId: #todoTaskId->value->value]];
    ?whenTypeOf(data) is {
        type{DatabaseQueryResult}: ?whenTypeOf(data) is {
            type[DatabaseQueryResultRow]: data.0 => asTodoTask,
            ~: @UnknownTask(#)
        },
        type{Error<DatabaseQueryFailure>}: @{data->error->asExternalError}
    }
};
DbTodoBoard->allTasks(^Null => Result<Array<TodoTask>, HydrationError|MapItemNotFound|DatabaseQueryFailure>) %% DatabaseConnector :: { %
    => query[query: 'SELECT * FROM tasks', boundParameters: [:]]}
    => map(^DatabaseQueryResultRow => Result<TodoTask, HydrationError|MapItemNotFound> :: # => asTodoTask);

DbTodoBoard ==> TodoBoard :: [
    addTask: ^TodoTask => *Result<TaskAdded, TaskAlreadyExists> :: $->addTask(#),
    removeTask: ^[~TodoTaskId] => *Result<TaskRemoved, UnknownTask> :: $->removeTask(#),
    taskWithId: ^[~TodoTaskId] => *Result<TodoTask, UnknownTask> :: {
        result = $->taskWithId(#);
        ?whenTypeOf(result) is {
            type{*Result<TodoTask, UnknownTask>}: result,
            type{Error}: @ExternalError[errorType: result->type->printed, originalError: result, errorMessage: 'error']
        }
    },
    allTasks: ^Null => *Array<TodoTask> :: {
        result = $->allTasks;
        ?whenTypeOf(result) is {
            type{Array<TodoTask>}: result,
            type{Error}: @ExternalError[errorType: result->type->printed, originalError: result, errorMessage: 'error']
        }
    }
];

==> TaskUpdatedEventListener %% [~TodoBoard, ~DatabaseConnector] :: ^TaskMarkedAsDone|TaskUnmarkedAsDone => *Null :: {
    task = #->todoTask;
    existing = %.todoBoard.taskWithId[task->id];
    ?whenTypeOf(existing) is {
        type{TodoTask}: {
            result = %.databaseConnector->execute[
                query: 'UPDATE tasks SET is_done = :isDone WHERE id = :id',
                boundParameters: [isDone: ?whenIsTrue { task->isDone: 1, ~: 0 }, id: task->id->value->value]
            ];
            ?whenTypeOf(result) is {
                type{Integer<0..>}: null,
                type{Error<DatabaseQueryFailure>}: @{result->error->asExternalError}
            }
        },
        ~: @ExternalError[errorType: 'UnknownTask', originalError: UnknownTask[task->id], errorMessage: 'error']
    }
};