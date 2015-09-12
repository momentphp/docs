<?php

namespace momentphp\bundle\docs\controllers;

class DocsController extends \momentphp\Controller
{
    public function home()
    {
        $this->set('htmlTitle', 'Docs');
    }
}
