<?php
// POTMAN server diagnostic. Delete this file after use.
ini_set('display_errors', '1');
ini_set('display_startup_errors', '1');
error_reporting(E_ALL);
header('Content-Type: text/plain; charset=utf-8');

$logFile = __DIR__ . '/diag-result.txt';
register_shutdown_function(function () use ($logFile) {
    $e = error_get_last();
    if ($e) {
        $msg = "\n!!! FATAL: {$e['message']}\n    in {$e['file']} on line {$e['line']}\n";
        echo $msg;
        @file_put_contents($logFile, $msg, FILE_APPEND);
    }
});

function line($label, $value) { echo str_pad($label, 34) . $value . "\n"; }
function yn($b) { return $b ? 'OK' : 'MISSING  <<<<<<'; }

echo "=== PHP ===\n";
line('PHP version', PHP_VERSION);
line('SAPI', PHP_SAPI);
line('memory_limit', ini_get('memory_limit'));
line('open_basedir', ini_get('open_basedir') ?: '(none)');
line('disable_functions', ini_get('disable_functions') ?: '(none)');
line('error_log ini', ini_get('error_log') ?: '(default)');

echo "\n=== Required extensions ===\n";
foreach (['mbstring','openssl','pdo','pdo_mysql','tokenizer','xml','ctype','json','fileinfo','curl','bcmath','dom','session','filter','hash'] as $ext) {
    line($ext, yn(extension_loaded($ext)));
}

echo "\n=== Files ===\n";
$base = __DIR__;
foreach (['vendor/autoload.php','bootstrap/app.php','.env','public/index.php','routes/web.php','public/build/manifest.json'] as $f) {
    line($f, yn(file_exists("$base/$f")));
}

echo "\n=== Writable paths ===\n";
foreach (['storage','storage/logs','storage/framework','storage/framework/cache','storage/framework/cache/data','storage/framework/sessions','storage/framework/views','bootstrap/cache'] as $d) {
    $p = "$base/$d";
    line($d, file_exists($p) ? (is_writable($p) ? 'writable' : 'NOT WRITABLE  <<<<<<') . '  perms ' . substr(sprintf('%o', fileperms($p)), -4) : 'MISSING  <<<<<<');
}

echo "\n=== .env check ===\n";
if (file_exists("$base/.env")) {
    $raw = file_get_contents("$base/.env");
    line('size', strlen($raw) . ' bytes');
    line('has BOM', substr($raw, 0, 3) === "\xEF\xBB\xBF" ? 'YES <<<<<<' : 'no');
    line('has CRLF', strpos($raw, "\r") !== false ? 'yes (ok)' : 'no');
    foreach (explode("\n", $raw) as $i => $l) {
        $t = trim($l);
        if ($t === '' || $t[0] === '#') continue;
        if (strpos($t, '=') === false) { line('line ' . ($i + 1), 'NO "=" : ' . $t . '  <<<<<<'); continue; }
        [$k, $v] = explode('=', $t, 2);
        if (stripos($k, 'PASSWORD') !== false || stripos($k, 'SECRET') !== false || stripos($k, 'KEY') !== false) $v = '(hidden, len ' . strlen($v) . ')';
        line($k, $v);
        if (preg_match('/\s/', trim($v, '"\'')) && !preg_match('/^["\'].*["\']$/', trim($v)) && $v[0] !== '(') {
            echo "   ^ value has spaces but no quotes  <<<<<<\n";
        }
    }
} else {
    echo ".env is MISSING\n";
}

echo "\n=== Autoload ===\n";
require $base . '/vendor/autoload.php';
echo "autoload OK\n";

echo "\n=== Boot Laravel ===\n";
try {
    $app = require $base . '/bootstrap/app.php';
    echo "app created OK\n";
    $kernel = $app->make(Illuminate\Contracts\Http\Kernel::class);
    echo "kernel OK\n";
    $request = Illuminate\Http\Request::create('/', 'GET');
    $response = $kernel->handle($request);
    echo "HTTP status from app: " . $response->getStatusCode() . "\n";
    if ($response->getStatusCode() >= 500) {
        echo "Body (first 1500 chars):\n" . substr(strip_tags($response->getContent()), 0, 1500) . "\n";
    }
} catch (Throwable $t) {
    $msg = "\n!!! EXCEPTION: " . get_class($t) . "\n    " . $t->getMessage() . "\n    in " . $t->getFile() . ':' . $t->getLine() . "\n";
    echo $msg;
    @file_put_contents($logFile, $msg, FILE_APPEND);
}

echo "\n=== Done ===\n";
