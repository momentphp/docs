<?php

/**
 * Routes definitions
 */
$app->group('/docs', function () {
    $this->get('', 'DocsController:home')->setName('docs');
    $this->get('/readme', 'DocsController:readme')->setName('docs-readme');
});

$app->get('/api', function ($req, $res) {
    return $res->withRedirect('/bundles/docs/api/index.html');
})->setName('api');
