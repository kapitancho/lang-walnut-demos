module demo-task-repository:

TaskStorageSuccessful = :[];
UnknownTask = :[];
TaskStorageData = [
    id: String<36>,
    title: String<1..>,
    isDone: Boolean,
    dueDate: String<10>,
    createdAt: String<19>,
    description: String
];

TaskPersist = ^TaskStorageData => *TaskStorageSuccessful;
TaskRetrieveAll = ^Null => *Array<TaskStorageData>;
TaskRetrieveById = ^String<36> => *Result<TaskStorageData, UnknownTask>;
TaskRemoveById = ^String<36> => *Result<TaskStorageSuccessful, UnknownTask>;
