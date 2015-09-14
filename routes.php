<?php

$app->group('/docs', function () {
    $this->any('/', 'DocsController:home')->setName('docs');
    $this->any('/readme', 'DocsController:readme')->setName('docs-readme');
});

$app->any('/api', function ($req, $res) {
    return $res->withRedirect('/bundles/docs/api/index.html');
})->setName('api');
