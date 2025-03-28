module demo-task-json-file %% demo-task-repository, fs:

JsonFileTaskList = $[jsonStorage: File];
JsonFileTaskList->retrieve(^Null => *Map<TaskStorageData>) :: {
    retriever = ^Null => Result<Map<TaskStorageData>, HydrationError|InvalidJsonString|CannotReadFile> ::
        $jsonStorage=>content => jsonDecode => hydrateAs(type{Map<TaskStorageData>});
    retriever() *> ('Unable to read tasks from JSON')
};
JsonFileTaskList->persist(^Map<TaskStorageData> => *Map<TaskStorageData>) :: {
    persister = ^Map<TaskStorageData> => Result<Map<TaskStorageData>, CannotWriteFile|InvalidJsonValue> :: {
        $jsonStorage=>replaceContent(#=>jsonStringify);
        #
    };
    persister(#) *> ('Unable to write tasks to JSON')
};

==> TaskRetrieveAll  %% [~JsonFileTaskList] :: ^Null => *Array<TaskStorageData> :: %jsonFileTaskList=>retrieve->values;
==> TaskRetrieveById %% [~JsonFileTaskList] :: ^String<36> => *Result<TaskStorageData, UnknownTask> :: {
    result = %jsonFileTaskList=>retrieve->item(#);
    ?whenTypeOf(result) is {
        type{TaskStorageData}: result,
        type{Error<MapItemNotFound>}: @UnknownTask()
    }
};
==> TaskPersist      %% [~JsonFileTaskList] :: ^TaskStorageData => *TaskStorageSuccessful :: {
    %jsonFileTaskList=>persist(%jsonFileTaskList=>retrieve->withKeyValue[key: #id, value: #]);
    TaskStorageSuccessful()
};
==> TaskRemoveById   %% [~JsonFileTaskList] :: ^String<36> => *Result<TaskStorageSuccessful, UnknownTask> :: {
    result = %jsonFileTaskList=>retrieve->withoutByKey(#);
    ?whenTypeOf(result) is {
        type[element: TaskStorageData, map: Map<TaskStorageData>]: {
            %jsonFileTaskList=>persist(result.map);
            TaskStorageSuccessful()
        },
        ~: @UnknownTask()
    }
};