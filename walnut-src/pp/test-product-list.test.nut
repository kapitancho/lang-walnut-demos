module pp/test-product-list %% $test/runner, pp/cli, pp/test-product-mocks:

==> TestCases %% [~CliCommands] :: {
    [
        ^ => TestResult :: TestResult[
            name: 'List 3 products',
            expected: 'Apple\nBanana\nCherry',
            actual: ^ :: %cliCommands->listProducts
        ],
        ^ => TestResult :: TestResult[
            name: 'List 2 products (fake error)',
            expected: 'Apple\nBanana',
            actual: ^ :: %cliCommands->listProducts
        ]
    ]
};