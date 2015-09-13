<?php

$app->any('/docs', 'DocsController:home')->setName('docs');
$app->any('/api', function ($req, $res) {
    return $res->withRedirect('/bundles/docs/api/index.html');
})->setName('api');
