<?php

namespace momentphp\bundles\docs\controllers;

/**
 * DocsController
 */
class DocsController extends \momentphp\Controller
{
    /**
     * Render docs home page
     */
    protected function home()
    {
        $this->set('htmlTitle', 'Docs')->set('content', with(new \Parsedown)->text($this->readme()));
    }

    /**
     * Return README.md contents
     *
     * @return string
     */
    protected function readme()
    {
        return file_get_contents(path([dirname(dirname(class_path(\momentphp\bundles\docs\controllers\DocsController::class))), 'README.md']));
    }
}
