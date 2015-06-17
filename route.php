<?php

$app->any('/docs/source', 'Docs@source')->setName('docsSource');
$app->any('/docs', 'Docs@home')->setName('docsHome');
