module demo-http-config %% db, demo-http-http:

==> DatabaseConnection :: DatabaseConnection['sqlite:db.sqlite'];
==> LookupRouterMapping :: [
    [path: '/templates', type: type{TemplateHandler}]
];
