module demo-shapes:

HasName = Shape<[name: String, ...]>;
namePrinter = ^ ~HasName => String :: hasName->shape(`[name: String, ...]).name;

ProjectId = #Integer;
ProjectId ==> String :: $->value->asString;
UnknownProject = :[];
Project = #[id: ProjectId, name: String];
ProjectById = ^ProjectId => *Result<Project, UnknownProject>;

ArticleId = #Integer;
Article = #[id: ArticleId, title: String];

ProjectUpdater = [
    store: ^Project => *Null,
    remove: ^Project => *Null
];

HasNameOrTitle = Shape<[name: String, ...]|[title: String, ...]>;

NamedRecord = [name: String, ...];
NameProviderRecord = [name: ^Null => String, ...];
HasNameOrFn = Shape<NamedRecord|NameProviderRecord>;

Article ==> NameProviderRecord :: [
    name: ^ => String :: $title
];

MyShape1 = Shape<[a: Integer, b: Integer]>;
MyShape2 = Shape<ProjectById>;

InMemoryProjectRepository = $[projects: Mutable<Map<Project>>];
InMemoryProjectRepository(projects: Map<Project>) :: [projects: mutable{Map<Project>, projects}];

InMemoryProjectRepository ==> ProjectById ::
    ^ ~ProjectId => *Result<Project, UnknownProject> ::
        ?whenIsError(
            project = $projects->value->item(projectId->value->asString)
        ) { @UnknownProject() };

InMemoryProjectRepository ==> ProjectUpdater :: [
    store: ^ ~Project => *Null :: {
        projects = $projects->value;
        $projects->SET($projects->value->withKeyValue[key: project.id->value->asString, value: project]);
        null
    },
    remove: ^ ~Project => *Null :: {
        $projects->SET($projects->value->withoutAll(project));
        null
    }
];

getPr = ^[byId: Shape<ProjectById>, ~ProjectId] => *Result<Project, UnknownProject> :: {
    #byId->shape(`ProjectById)->invoke(#projectId)
};

integerDoubler = ^num: Shape<Integer> => Integer :: num->shape(`Integer) * 2;
nameOrTitlePrinter = ^ v: HasNameOrTitle => String :: {
    s = v->shape(`[name: String, ...]|[title: String, ...]);
    ?whenTypeOf(s) is {
        type[name: String, ...]: s.name,
        type[title: String, ...]: s.title
    }
};
nameOrFnPrinter = ^ v: HasNameOrFn => String :: {
    s = v->shape(`NamedRecord|NameProviderRecord);
    ?whenTypeOf(s) is {
        type{NamedRecord}: s.name,
        type{NameProviderRecord}: s.name(),
        ~: 'oops'
    }
};

updateProject = ^ [u: Shape<ProjectUpdater>, ~Project] => *Null :: #u->shape(`ProjectUpdater).store(#project);
deleteProject = ^ [u: Shape<ProjectUpdater>, ~Project] => *Null :: #u->shape(`ProjectUpdater).remove(#project);

Project ==> Integer :: $id->value;

fn = ^ :: {
    pId = ProjectId(2);
    myRepo = InMemoryProjectRepository[
        '1': pr1 = Project[ProjectId(1), 'Project 1'],
        '2': pr2 = Project[ProjectId(2), 'Project 2']
    ];
    article = Article[id: ArticleId(3), title: 'My Article'];
    fnx = [t: 1, name: ^ => String :: 'fn'];
    [
        getPr: getPr[myRepo, ProjectId(1)],
        namePrinter1a: namePrinter(pr1->value),
        namePrinter1b: namePrinter(pr1->value),
        namePrinter2a: namePrinter(pr2),
        namePrinter2b: namePrinter(pr2),
        pr3Before: getPr[myRepo, ProjectId(3)],
        upd3: updateProject[myRepo, Project[ProjectId(3), 'Project 3']],
        pr3After: getPr[myRepo, ProjectId(3)],
        del3: deleteProject[myRepo, Project[ProjectId(3), 'Project 3']],
        pr3Deleted: getPr[myRepo, ProjectId(3)],
        i2a: integerDoubler(1),
        i2b: integerDoubler(pId),
        i2c: integerDoubler(3.14),
        i2d: integerDoubler(pr1),

        nameOrTitlePrinterName: nameOrTitlePrinter(pr2),
        nameOrTitlePrinterTitle: nameOrTitlePrinter(article),

        nameOrFnPrinterName: nameOrFnPrinter(pr2),
        nameOrFnPrinterCast: nameOrFnPrinter(article),
        nameOrFnPrinterFn: nameOrFnPrinter(fnx),
        'end'
    ]
};

main = ^args => String :: fn()->printed;