<?php

use Walnut\Lang\Implementation\Compilation\Compiler;
use Walnut\Lang\Implementation\Compilation\MultiFolderBasedModuleLookupContext;
use Walnut\Lang\Implementation\Program\EntryPoint\CliEntryPoint;

require_once __DIR__ . '/../vendor/autoload.php';

$input = $argv ?? [0];
array_shift($input);
$source = array_shift($input);

$compiler = new Compiler(
	new MultiFolderBasedModuleLookupContext(
		__DIR__ . '/../vendor/walnut/lang/core-nut-lib',
		__DIR__ . '/../walnut-src'
	)
);

$ep = new CliEntryPoint($compiler);
$content = $ep->call($source, ... $input ?? []);

echo $content, PHP_EOL;
