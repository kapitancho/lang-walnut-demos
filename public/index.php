<?php

use Walnut\Lang\Blueprint\AST\Parser\ParserException;
use Walnut\Lang\Blueprint\Code\Analyser\AnalyserException;
use Walnut\Lang\Blueprint\Code\Execution\ExecutionException;
use Walnut\Lang\Blueprint\Compilation\AST\AstCompilationException;
use Walnut\Lang\Blueprint\Compilation\AST\AstModuleCompilationException;
use Walnut\Lang\Blueprint\Compilation\AST\AstProgramCompilationException;
use Walnut\Lang\Blueprint\Compilation\Module\ModuleDependencyException;
use Walnut\Lang\Blueprint\Program\InvalidEntryPoint;
use Walnut\Lang\Blueprint\Type\Type;
use Walnut\Lang\Blueprint\Value\Value;
use Walnut\Lang\Implementation\AST\Parser\WalexLexerAdapter;
use Walnut\Lang\Implementation\Compilation\Compiler;
use Walnut\Lang\Implementation\Compilation\Module\MultiFolderBasedModuleLookupContext;
use Walnut\Lang\Implementation\Compilation\Module\TemplatePrecompiler;
use Walnut\Lang\Implementation\Compilation\Module\TemplatePrecompilerModuleLookupDecorator;
use Walnut\Lang\Implementation\Program\EntryPoint\CliEntryPoint;
use Walnut\Lang\Implementation\Program\EntryPoint\CliEntryPointBuilder;
use Walnut\Lib\Walex\SourcePosition;
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
$moduleLookupContext = new TemplatePrecompilerModuleLookupDecorator(
	$tcx,
	new MultiFolderBasedModuleLookupContext(
		__DIR__ . '/../core-nut-lib',
		__DIR__ . '/../walnut-src'
	),
	__DIR__ . '/../walnut-src'
);

//$db = new PDO('sqlite:' . __DIR__ . '/db.sqlite');
//$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
//$db->exec("CREATE TABLE IF NOT EXISTS products (id INTEGER PRIMARY KEY, name TEXT, price REAL, description TEXT)");

$compiler = new Compiler($moduleLookupContext);

if ($_GET['check'] ?? null === 'all') {
	echo '<pre>';
	foreach($sources as $source) {
		$compiler = new Compiler($moduleLookupContext);
		try {
			echo "Compiling source: $source ...\n";
			$compilationResult = $compiler->compile($source);

			try {
				$ep = new CliEntryPoint(new CliEntryPointBuilder($compiler));
				$content = $ep->call($source, ... $_GET['parameters'] ?? []);
				echo "OK: $source\n";
			} catch (InvalidEntryPoint $mex) {
			} catch (ExecutionException $mex) {
				echo nl2br(htmlspecialchars("Execution error in $source: {$mex->getMessage()}\n"));
			}
		} catch (AstProgramCompilationException|AstCompilationException|ModuleDependencyException $e) {
			echo nl2br(htmlspecialchars("Compilation error in $source: {$e->getMessage()}\n"));
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

ob_start();
$logger = $compiler->transitionLogger;
$m = $compiler->safeCompile($source);
$pr = $m->ast;
//$m = $parser->programFromTokens($tokens);
//$m = 'TODO';
$debug = ob_get_clean();

if ($m->ast instanceof ParserException) {
	echo nl2br(htmlspecialchars("Error: {$m->ast->getMessage()}\n"));

	foreach(array_reverse(array_slice($tokens, 0, $m->ast->state->i)) as $idx => $token) {
		$sourceCode = substr_replace($sourceCode,
			'<strong title="' .
				($token->rule->tag instanceof SpecialRuleTag ? $token->rule->tag->name : $token->rule->tag) .
			'">' .
				htmlspecialchars($token->patternMatch->text) .
			'</strong>' .
			($idx === 0 ? '<span class="ERROR">&#x2190;</span>' : ''),
			$token->sourcePosition->offset,
			strlen($token->patternMatch->text)
		);
	}
	if (!$isRun) {
		ob_start();
		echo $logger, PHP_EOL;
		var_dump($tokens);
		$debug = ob_get_clean();
		include __DIR__ . '/code.tpl.php';

		//echo '<pre>', $m->ast->getTraceAsString();
		die;
	}
} elseif ($m->ast instanceof ModuleDependencyException) {
	echo nl2br(htmlspecialchars("Error: {$m->ast->getMessage()}\n"));
} elseif ($m->program instanceof AstProgramCompilationException) {
	echo nl2br(htmlspecialchars("Error: {$m->program->getMessage()}\n"));
	$errorPositions = array_merge(...
		array_map(static fn(AstModuleCompilationException $mcx): array =>
			$mcx->moduleName === $source ?
				array_map(static fn(AstCompilationException $cx): SourcePosition =>
					$cx->node->sourceLocation->startPosition, $mcx->compilationExceptions
				) : [],
			$m->program->moduleExceptions
		)
	);
} elseif ($m->program instanceof AstCompilationException) {
	echo nl2br(htmlspecialchars("Error: {$m->program->getMessage()}\n"));
	$errorPositions = [$m->program->node->sourceLocation->startPosition];
} elseif ($m->program instanceof AnalyserException) {
	echo nl2br(htmlspecialchars("Error: {$m->program->getMessage()}\n"));
}
$errorPositions ??= [];

foreach(array_slice(array_reverse($tokens), 1) as $token) {
	$sourceCode = substr_replace($sourceCode,
		'<strong title="' . $token->rule->tag . '">' .
			htmlspecialchars($token->patternMatch->text) .
		'</strong>' .
		(in_array($token->sourcePosition, $errorPositions) ? '<span class="ERROR">&#x2190;</span>' : ''),
		$token->sourcePosition->offset,
		strlen($token->patternMatch->text)
	);
}
if (!$isRun) { include __DIR__ . '/code.tpl.php'; }

//echo '<pre>', $debug;
if ($isRun) {
	try {
		$ep = new CliEntryPoint(new CliEntryPointBuilder($compiler));
		$content = $ep->call($source, ... $_GET['parameters'] ?? []);
		$content = htmlspecialchars($content);
	} catch (Exception $e) {
		if (0) foreach($e->getTrace() as $t) {
			echo implode('<br>', array_map(fn($arg) =>
				$arg instanceof Type || $arg instanceof Value ? (string)$arg : (is_object($arg) ? $arg::class : json_encode($arg)), $t['args']));
			echo '<hr/>';
		}
		$content = '<pre>' . htmlspecialchars($e::class . ' | ' . PHP_EOL . ' | ' . PHP_EOL . $e->getMessage()) . '</pre>';
		//echo $e->getTraceAsString();
	}
	$program = $sourceCode;
	$output = $debug;
	include __DIR__ . '/exec.tpl.php';
}