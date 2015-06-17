<?php
namespace moment\bundle\docs\controller;

class DocsController extends \moment\Controller
{
    public function home()
    {
        $this->set('htmlTitle', 'Docs');
    }
}
