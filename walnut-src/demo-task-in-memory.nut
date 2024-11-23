module demo-task-in-memory %% demo-task-repository:

InMemoryTaskList = Mutable<Map<TaskStorageData>>;

==> TaskRetrieveAll  %% [~InMemoryTaskList] :: ^Null => Array<TaskStorageData> ::
    %inMemoryTaskList->value->values;
==> TaskRetrieveById %% [~InMemoryTaskList] :: ^String<36> => Result<TaskStorageData, UnknownTask> :: {
    result = %inMemoryTaskList->value->item(#);
    ?whenTypeOf(result) is {
        type{TaskStorageData}: result,
        ~: @UnknownTask[]
    }
};
==> TaskPersist      %% [~InMemoryTaskList] :: ^TaskStorageData => TaskStorageSuccessful :: {
    %inMemoryTaskList->SET(%inMemoryTaskList->value->withKeyValue[key: #id, value: #]);
    TaskStorageSuccessful[]
};
==> TaskRemoveById   %% [~InMemoryTaskList] :: ^String<36> => Result<TaskStorageSuccessful, UnknownTask> :: {
    result = %inMemoryTaskList->value->withoutByKey(#);
    ?whenTypeOf(result) is {
        type[element: TaskStorageData, map: Map<TaskStorageData>]: {
            %inMemoryTaskList->SET(result.map);
            TaskStorageSuccessful[]
        },
        ~: @UnknownTask[]
    }
};
