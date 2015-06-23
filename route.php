<?php

$app->any('/docs', 'Docs@home')->setName('docsHome');
$app->any('/api', function ($req, $res) {
    return $res->withRedirect('/bundle/docs/api/index.html');
})->setName('docsApi');
