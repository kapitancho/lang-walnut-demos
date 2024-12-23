<?php

use Walnut\Lang\Blueprint\Code\Analyser\AnalyserException;
use Walnut\Lang\Blueprint\Type\Type;
use Walnut\Lang\Blueprint\Value\Value;
use Walnut\Lang\Implementation\Compilation\Compiler;
use Walnut\Lang\Implementation\Compilation\MultiFolderBasedModuleLookupContext;
use Walnut\Lang\Implementation\Compilation\Parser\ParserException;
use Walnut\Lang\Implementation\Compilation\TemplatePrecompiler;
use Walnut\Lang\Implementation\Compilation\TemplatePrecompilerModuleLookupDecorator;
use Walnut\Lang\Implementation\Compilation\WalexLexerAdapter;
use Walnut\Lang\Implementation\Program\EntryPoint\CliEntryPoint;
use Walnut\Lib\Walex\SpecialRuleTag;

require_once __DIR__ . '/../vendor/autoload.php';
//require_once __DIR__ . '/inc.php';

$input = $argv ?? [
	...[0],
	...(($_GET['src'] ?? null) ? [$_GET['src']] : []),
];
array_shift($input);
$source = array_shift($input);
$sources = [];
$htmlSources = [];

$sourceRoot = __DIR__ . '/../walnut-src';

foreach(glob("$sourceRoot/*.nut") as $sourceFile) {
	$sources[] = str_replace('.nut', '', basename($sourceFile));
}
foreach(glob("$sourceRoot/*.nut.html") as $sourceFile) {
	$sp = str_replace('.nut.html', '', basename($sourceFile));
	$sources[] = $sp;
	$htmlSources[] = $sp;
}

$tcx = new TemplatePrecompiler();

$compiler = new Compiler(
	new TemplatePrecompilerModuleLookupDecorator(
		$tcx,
		new MultiFolderBasedModuleLookupContext(
			__DIR__ . '/../vendor/walnut/lang/core-nut-lib',
			__DIR__ . '/../walnut-src'
		),
		__DIR__ . '/../walnut-src'
	)
);

if ($_GET['check'] ?? null === 'all') {
	echo '<pre>';
	foreach($sources as $source) {
		try {
			echo "Compiling source: $source ...\n";
			$compilationResult = $compiler->compile($source);
			echo "OK: $source\n";
		} catch (AnalyserException $e) {
			echo nl2br(htmlspecialchars("Analyse error in $source: {$e->getMessage()}\n"));
		} catch (ParserException $e) {
			echo htmlspecialchars("Parse error in $source: {$e->getMessage()}\n");
		}
	}
	die;
}

if (!in_array($source, $sources, true)) {
	$source = 'cast10';
}
$qs = [
	'cast4' => '&parameters[]=4',
	'cast7' => '&parameters[]=3&parameters[]=4',
	'cast8' => '&parameters[]=29&parameters[]=15&parameters[]=51&parameters[]=31&parameters[]=211',
	'cast9' => '&parameters[]=30',
	'cast10' => '&parameters[]=3&parameters[]=3.14',
][$source] ?? '';
$generate = ($input[0] ?? null) === '-g' && array_shift($input);
$cached = ($input[0] ?? null) === '-c' && array_shift($input);

$isHtml = in_array($source, $htmlSources, true);
$originalSourceCode = $isHtml ?
	file_get_contents("$sourceRoot/$source.nut.html") :
	file_get_contents("$sourceRoot/$source.nut");
$sourceCode = $isHtml ? $tcx->precompileSourceCode($source, $originalSourceCode) : $originalSourceCode;

$lexer = new WalexLexerAdapter();
$tokens = $lexer->tokensFromSource($sourceCode);

$isRun = $_GET['run'] ?? null;

//$pb = ($pbf = new ProgramBuilderFactory())->getProgramBuilder();
//$logger = new TransitionLogger();
//$moduleImporter = new Walnut\Lang\Implementation\Compilation\ModuleImporter($sourceRoot, $pb, $logger);
//$parser = new Walnut\Lang\Implementation\Compilation\Parser($pb, $logger, $moduleImporter);
try {
	ob_start();
	$logger = $compiler->transitionLogger;
	$m = $compiler->compile($source);
	$pr = $m->programRegistry;
	//$m = $parser->programFromTokens($tokens);
	//$m = 'TODO';
	$debug = ob_get_clean();

	foreach(array_slice(array_reverse($tokens), 1) as $token) {
		$sourceCode = substr_replace($sourceCode, '<strong title="' . $token->rule->tag . '">' .
			htmlspecialchars($token->patternMatch->text) . '</strong>', $token->sourcePosition->offset, strlen($token->patternMatch->text));
	}
	if (!$isRun) { include __DIR__ . '/code.tpl.php'; }

} catch (AnalyserException|ParserException $e) {
	$debug = ob_get_clean();
	echo nl2br(htmlspecialchars("Error: {$e->getMessage()}\n"));

	$m = $e instanceof ParserException ? array_slice($tokens, 0, $e->state->i) : $tokens;
	foreach(array_reverse($m) as $token) {
		$sourceCode = substr_replace($sourceCode, '<strong title="' .
			($token->rule->tag instanceof SpecialRuleTag ? $token->rule->tag->name : $token->rule->tag) .
			'">' .
			htmlspecialchars($token->patternMatch->text) . '</strong>', $token->sourcePosition->offset, strlen($token->patternMatch->text));
	}
	if (!$isRun) {
		ob_start();
		echo $logger, PHP_EOL;
		var_dump($tokens);
		$debug = ob_get_clean();
		include __DIR__ . '/code.tpl.php';

		echo '<pre>', $e->getTraceAsString();
		die;
	}
}

//echo '<pre>', $debug;
if ($isRun) {
	try {
		$ep = new CliEntryPoint($compiler);
		$content = $ep->call($source, ... $_GET['parameters'] ?? []);
		$content = htmlspecialchars($content);
		/*$compilationResult = $compiler->compile($source);
		$program = $compilationResult->program;
		$tr = $compilationResult->programRegistry->typeRegistry();
		$vr = $compilationResult->programRegistry->valueRegistry();
		$ep = $program->getEntryPoint(
			new VariableNameIdentifier('main'),
			$tr->array($tr->string()),
			$tr->string()
		);
		$content = $ep->call($vr->tuple(
			array_map(fn(string $arg) => $vr->string($arg), $_GET['parameters'] ?? [])
		))->literalValue();
		$pb = $compilationResult->programRegistry;*/
		/*$pf = new ProgramFactory();
		$lexer = new WalexLexerAdapter();
		$lookupContext = new FolderBasedModuleLookupContext(__DIR__ . '/../walnut-src');
		$transitionLogger = new TransitionLogger();
		$parser = new Parser($transitionLogger);
		$codeBuilder = $pf->codeBuilder();
		$moduleImporter = new ModuleImporter(
			$lexer,
			$lookupContext,
			$parser,
			$codeBuilder
		);
		$moduleImporter->importModule($source);
		$program = $pf->builder()->analyseAndBuildProgram();*/

		/*
		$cliAdapter = new CliAdapter(
			$pb,
            new NativeCodeContext(
			    $pbf->typeRegistry,
			    $pbf->valueRegistry
            )
		);
		$content = $cliAdapter->execute(... $_GET['parameters'] ?? []);
		*/
	} catch (Exception $e) {
		if (0) foreach($e->getTrace() as $t) {
			echo implode('<br>', array_map(fn($arg) =>
				$arg instanceof Type || $arg instanceof Value ? (string)$arg : (is_object($arg) ? $arg::class : json_encode($arg)), $t['args']));
			echo '<hr/>';
		}
		$content = '<pre>' . htmlspecialchars($e::class . ' | ' . PHP_EOL . $e . ' | ' . PHP_EOL . $e->getMessage()) . '</pre>';
		//echo $e->getTraceAsString();
	}
	$program = $sourceCode;
	$output = $debug;
	include __DIR__ . '/exec.tpl.php';
}