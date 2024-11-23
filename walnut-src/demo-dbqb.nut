module demo-dbqb %% db, db-sql-query-builder, db-sql-quoter-mysql:

==> DatabaseConnection :: DatabaseConnection['sqlite:db.sqlite'];

temp = ^Any => Any %% [~SqlQuoter] :: {
    i = InsertQuery['products', [
        title: PreparedValue['title'],
        price: PreparedValue['price'],
        is_active: SqlValue[true]
    ]];
    qf = SqlQueryFilter[SqlFieldExpression[TableField['products', 'id'], SqlFieldExpressionOperation.Equals, PreparedValue['id']]];
    u = UpdateQuery['products', [
        title: PreparedValue['title'],
        price: PreparedValue['price'],
        is_active: SqlValue[true]
    ], qf];
    d = DeleteQuery['products', qf];
    expr = SqlNotExpression[
        SqlAndExpression[[
            SqlRawExpression['a = 1'],
            SqlFieldExpression[TableField['e', 'f'], SqlFieldExpressionOperation.NotEquals, TableField['g', 'h']],
            SqlOrExpression[[
                SqlFieldExpression[TableField['c', 'd'], SqlFieldExpressionOperation.Equals, PreparedValue['d']],
                SqlFieldExpression['c', SqlFieldExpressionOperation.NotLike, SqlValue['%foo%']]
            ]]
        ]]
    ];
    s = SelectQuery[
        tableName: 'products',
        fields: SqlSelectFieldList[[
            id: 'id',
            title: TableField['products', 'title'],
            price: SqlValue[3.14]
        ]],
        joins: [
            SqlTableJoin['e', 'f', SqlTableJoinType.Inner, SqlQueryFilter[SqlFieldExpression[TableField['e', 'f'], SqlFieldExpressionOperation.Equals, TableField['g', 'h']]]],
            SqlTableJoin['c', 'd', SqlTableJoinType.Left, SqlQueryFilter[SqlFieldExpression['c', SqlFieldExpressionOperation.Equals, PreparedValue['d']]]]
        ],
        queryFilter: qf,
        orderBy: SqlOrderByFields[[
            SqlOrderByField['title', SqlOrderByDirection.Asc],
            SqlOrderByField['price', SqlOrderByDirection.Desc]
        ]],
        limit: SqlSelectLimit[10, 20]
    ];
    [
        %sqlQuoter.quoteIdentifier('foo'),
        %sqlQuoter.quoteValue('bar'),
        %sqlQuoter.quoteValue(3.14),
        %sqlQuoter.quoteValue(null),
        {SqlValue[42]}->asSqlString,
        {PreparedValue['title']}->asSqlString,
        i,
        i->as(type{DatabaseSqlQuery}),
        u,
        u->as(type{DatabaseSqlQuery}),
        d,
        d->as(type{DatabaseSqlQuery}),
        s,
        s->as(type{DatabaseSqlQuery}),
        expr,
        expr->asSqlString
    ]
};


main = ^Array<String> => String :: {

    [
        temp(),
        'end'
    ]->printed
};