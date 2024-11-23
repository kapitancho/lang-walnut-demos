module demo-task-api %% demo-task-model:

TaskData = [id: String<36>, title: String<1..>, createdAt: DateAndTime, dueDate: Date, isDone: Boolean, description: String];
NewTaskData = [title: String<1..>, dueDate: Date, description: String];

Task ==> TaskData :: [
    id: $id, title: $title, createdAt: $createdAt, dueDate: $dueDate, isDone: $isDone->value, description: $description
];

TaskNotAdded = :[];

ListTasks = ^[:] => *Array<TaskData>;
TaskById = ^[~TaskId] => *Result<TaskData, UnknownTaskId>;
AddTask = ^[~NewTaskData] => *Result<TaskAdded, TaskNotAdded>;
MarkTaskAsDone = ^[~TaskId] => *Result<TaskMarkedAsDone, UnknownTaskId>;
UnmarkTaskAsDone = ^[~TaskId] => *Result<TaskUnmarkedAsDone, UnknownTaskId>;
RemoveTask = ^[~TaskId] => *Result<TaskRemoved, UnknownTaskId>;
