<?php
/**
 * @var string $content
 * @var string $program
 * @var string $output
 */
?>
<!DOCTYPE html>
<html lang="en">
	<head>
		<title></title>
        <meta charset="UTF-8">
		<link rel="stylesheet" type="text/css" href="style.css" />
	</head>
	<body>
		<main>
			<details open>
				<summary>Result</summary>
				<div id="value"><?= $content ?></div>
			</details>
			<?php if (trim($output) !== '') { ?>
				<details open>
					<summary>Stdout</summary>
					<div id="value">
						<?= $output ?: '--- no output ---' ?>
					</div>
				</details>
			<?php } ?>
			<?php if (trim($program) !== '') { ?>
				<details>
					<summary>Program</summary>
					<div id="value">
						<div id="source">
<?= $program ?>
						</div>
					</div>
				</details>
                <?php if (isset($pr)) { ?>
                    <details>
                        <summary>AST</summary>
                        <div id="value">
                            <div id="source">
    <?= htmlspecialchars(json_encode($pr, JSON_PRETTY_PRINT)) ?>
                            </div>
                        </div>
                    </details>
    			<?php } ?>
			<?php } ?>
		</main>
	</body>
</html>