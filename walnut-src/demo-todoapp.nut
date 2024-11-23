module demo-todoapp %% demo-todoapp-model, demo-todoapp-config, http-core, http-route, http-response-helper:

TodoTest = :[];
TodoTest->run(^Any => Any) %% [~TodoBoard] :: {
    task2 = TodoTask[title: 'Task 2', dueDate: ?noError(Date[2024, 5, 12]), description: 'This is the second task'];
    task3 = TodoTask[title: 'Task 3', dueDate: ?noError(Date[2024, 5, 31]), description: 'This is the third task'];
    %.todoBoard.addTask(task2);
    %.todoBoard.addTask(task3);
    task2=>markAsDone;
    task3=>markAsDone;
    task3=>unmarkAsDone;
    [
        task2: task2,
        todoBoard: %.todoBoard => asJsonValue => stringify,
        taskWithId: %.todoBoard.taskWithId[task2->id],
        unknownTask: %.todoBoard.taskWithId['unknown-unknown-unknown-unknown-1234'],
        removeTask: %.todoBoard.removeTask[task3->id],
        removeTaskAgain: %.todoBoard.removeTask[task3->id],
        addTaskAgain: %.todoBoard.addTask(task2),
        allRemainingTasks: %.todoBoard.allTasks(),
        task3Json: task3->asJsonValue,
        hydrated: task3->asJsonValue->hydrateAs(type{TodoTask})
    ]
};

main = ^Any => String :: TodoTest[]->run->printed;
