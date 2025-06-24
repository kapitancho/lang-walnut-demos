module pp/main %% pp/config:

main = ^args: Array<String> => String %% [~CliCommands] :: ?whenTypeOf(args) is {
    type[String['help']]: %cliCommands->showHelp,
    type[String['product'], String['list']]: %cliCommands->listProducts,
    type[String['product'], String]: %cliCommands->productById(args.1),
    ~ : 'Hello World!'
};