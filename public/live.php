<?php

use Walnut\Lang\Implementation\Compilation\Compiler;
use Walnut\Lang\Blueprint\AST\Parser\ParserException;
use Walnut\Lang\Implementation\AST\Parser\WalexLexerAdapter;
use Walnut\Lang\Implementation\Compilation\Module\MultiFolderBasedModuleLookupContext;
use Walnut\Lang\Implementation\Program\EntryPoint\CliEntryPoint;
use Walnut\Lang\Implementation\Program\EntryPoint\CliEntryPointBuilder;
use Walnut\Lib\Walex\SpecialRuleTag;

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
	include 'live.tpl.php';
	die;
}

require_once __DIR__ . '/../vendor/autoload.php';

$code = $sourceCode = file_get_contents('php://input');
$lexer = new WalexLexerAdapter();
$tokens = $lexer->tokensFromSource($sourceCode);

$compiler = new Compiler(
	new MultiFolderBasedModuleLookupContext(
		__DIR__,
		__DIR__ . '/../vendor/walnut/lang/core-nut-lib'
	)
);

file_put_contents(__DIR__ . '/live.nut', $code);
$ep = new CliEntryPoint(new CliEntryPointBuilder($compiler));
try {
	$content = $ep->call('live', ... $_GET['parameters'] ?? []);
	$content = htmlspecialchars($content);

	foreach(array_slice(array_reverse($tokens), 1) as $token) {
		$sourceCode = substr_replace($sourceCode, '<strong title="' . $token->rule->tag . '">' .
			htmlspecialchars($token->patternMatch->text) . '</strong>', $token->sourcePosition->offset, strlen($token->patternMatch->text));
	}

} catch (Exception $e) {
	$m = $e instanceof ParserException ? array_slice($tokens, 0, $e->state->i) : $tokens;
	$b = $e instanceof ParserException ? $tokens[$e->state->i] ?? null : null;
	if ($b) {
		$sourceCode =
			substr($sourceCode, 0, $b->sourcePosition->offset) .
			'<span style="background-color: #fddee3; color: #444;">' . substr($sourceCode, $b->sourcePosition->offset) . '<span>';
	}
	foreach(array_reverse($m) as $token) {
		$sourceCode = substr_replace($sourceCode, '<strong title="' .
			($token->rule->tag instanceof SpecialRuleTag ? $token->rule->tag->name : $token->rule->tag) .
			'">' .
			htmlspecialchars($token->patternMatch->text) . '</strong>', $token->sourcePosition->offset, strlen($token->patternMatch->text));
	}

	$msg = $e->getMessage() ?: $e::class;
	$content =  nl2br(htmlspecialchars("Error: {$msg}\n"));
}
unlink(__DIR__ . '/live.nut');

header('Content-Type: application/json');
echo json_encode(['parsed' => $sourceCode, 'result' => $content]);