<?php
/**
 * @var string $debug
 * @var string $content
 * @var string $source
 * @var string $sourceCode
 * @var string $qs
 * @var string[] $sources
 */
?>
<!DOCTYPE html>
<html lang="en">
	<head>
		<title></title>
		<link rel="stylesheet" type="text/css" href="style.css" />
		<style>
			main {
				display: grid;
				grid-template-columns: 3fr 2fr;
			}
			#source {
				height: calc(100vh - 120px);
				overflow-y: scroll;
			}
			#run {
				width: 100%;
				height: calc(100vh - 120px);
			}
			#source {
				white-space: pre;
			}
			strong { background: #EEE; }
			strong[title="module_identifier"] { background: yellow; }
			strong[title="code_comment"] { color: #777; }
			strong[title="var_keyword"] { color: brown; }
			strong[title="type_keyword"] { color: blue; }
			strong[title="type_proxy_keyword"] { color: blue; background: #EAE; }
			strong[title="string_value"] { color: #cc2282; }
			strong[title="positive_integer_number"] { color: orangered; }
			strong[title="integer_number"] { color: orangered; }
			strong[title="real_number"] { color: orange; }
			strong[title="special_var"] { color: brown; background: #e0e0e0; }
			strong[title="mutable"],
			strong[title="null"], strong[title="true"], strong[title="false"], strong[title="type"] { color: #b4a44f; }
			strong[title="when_type_of"], strong[title="when_value_of"], strong[title="when_is_true"] { color: green; }
		</style>
	</head>
	<body>
		<header>
			<h4>Select file:</h4>
			<?php foreach($sources as $sourceF) {
				$isExecutable = preg_match('/^(cast\d+|demo-\w+|nwk-\w+|lang-[\w\-]+)$/', $sourceF);
			?>
				<?php if ($source === $sourceF) { ?>
					<em><?= $sourceF ?></em>
					<?php if ($isExecutable) { ?>
						<!--<a target="run" style="color: fuchsia" href="exec.php?r=1&src=<?= $sourceF ?><?= $qs ?>">[execute]</a>-->
						<input type="text" value="<?= $qs ?>" />
						<a target="run" style="color: fuchsia" data-href="index.php?run=1&src=<?= $sourceF ?>"
							href=""
							onclick="this.href = this.dataset.href + this.previousElementSibling.value"
						>[execute]</a>
					<?php } ?>
				<?php } else { ?>
					<a href="?src=<?= $sourceF ?><?= $isExecutable ? '&autoexec=1' : '' ?>"><?= $sourceF ?></a>
				<?php } ?>
			<?php } ?>
		</header>
		<main>
			<div id="source">
<?= $sourceCode ?>
<?php if ($debug) { ?><hr/><?= $debug ?><?php } ?>
			</div>
			<iframe id="run" name="run" src="about:blank">

			</iframe>
		</main>
		<script>
			<?php if ($_GET['autoexec'] ?? null) { ?>
				document.querySelector('a[target="run"]').click();
			<?php } ?>
		</script>
	</body>
</html>