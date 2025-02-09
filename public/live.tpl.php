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
                height: calc(100vh);
				display: grid;
				grid-template-columns: 1fr 1fr 1fr;
                background: grey;
                grid-column-gap: 3px;
			}
            main > * {
                background: white;
            }
			.code, #parsed, #result {
                height: 100%;
				overflow-y: scroll;
			}
            #code {
                width: calc(100% - 12px);
                height: calc(100% - 22px);
            }
            #source {
                padding: 5px;
            }
            #result {
                /*white-space: pre;*/
                padding: 5px;
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
		<main>
			<label class="code">
                <textarea id="code">
module live:
MyInt = Integer<0..100>;
myVar = 'Hello';
myFn = ^s: String => Integer :: s->length;

main = ^args: Array<String> => String :: {
    v = myFn(myVar);
    r = ?whenTypeOf(v) is {
        type{MyInt}: v->asString,
        ~: 'error'
    };
    'My result is '->concat(r)
};</textarea>
			</label>
            <div id="source" contenteditable="true">

            </div>
            <div id="result">

            </div>
		</main>
		<script>
            const cEl = document.querySelector('#code');
            const pEl = document.querySelector('#source');
            const rEl = document.querySelector('#result');
            let timeout = null;

            const debounce = async() => {
                const response = await fetch('?', {method: 'post', body: cEl.value});
                const json = await response.json();
                pEl.innerHTML = json.parsed;
                rEl.innerHTML = json.result;
            };
            const debounce2 = async() => {
                const response = await fetch('?', {method: 'post', body: pEl.innerText});
                const json = await response.json();
                cEl.value = pEl.innerText;
                pEl.innerHTML = json.parsed;
                rEl.innerHTML = json.result;
            };

            cEl.addEventListener('keyup', async() => {
                if (timeout) {
                    clearTimeout(timeout);
                }
                timeout = setTimeout(debounce, 500);
            });
            pEl.addEventListener('input', async() => {
                if (timeout) {
                    clearTimeout(timeout);
                }
                timeout = setTimeout(debounce2, 1500);
            });
            //setInterval(() => console.log(getSelection()), 3000);
            debounce();
		</script>
	</body>
</html>