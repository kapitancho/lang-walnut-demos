module pp/test-product-details %% $test/runner, pp/cli, pp/test-product-mocks:

==> TestCases %% [~CliCommands] :: {
    [
        ^ => TestResult :: TestResult[
            name: 'Product found',
            expected: 'Banana',
            actual = ^ :: %cliCommands->productById('2')
        ],
        ^ => TestResult :: TestResult[
            name: 'Product not found',
            expected: 'Unknown Product Id: 999',
            actual = ^ :: %cliCommands->productById('999')
        ],
        ^ => TestResult :: TestResult[
            name: 'Invalid product id',
            expected: 'Invalid Product Id: pr-1',
            actual = ^ :: %cliCommands->productById('pr-1')
        ]
    ]
};