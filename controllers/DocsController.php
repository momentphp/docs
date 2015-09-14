<?php

namespace momentphp\bundle\docs\controllers;

class DocsController extends \momentphp\Controller
{
    public function home()
    {
        $this->set('htmlTitle', 'Docs');
    }

    public function readme()
    {
        return file_get_contents(path([$this->app->bundles->owns($this)->path(), 'README.md']));
    }
}
