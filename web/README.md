Moment is a lightweight and intuitive PHP mini-framework enabling modular app design.
The *mini* prefix means that it sits somewhere between micro and full-stack frameworks.
It offers bare minimum of functionality required in order to create web sites and
web applications. Most importantly it gives "structure" to your code, leaving
free choice about inclusion of additional tools. It is built on top of well-known amongst the PHP community
libraries and solutions:

- [Slim 3][Slim] micro-framework
- [Smarty][Smarty] templating engine
- components responsible for database access, configuration and caching from [Laravel][Laravel] framework
- [Composer][Composer] dependency manager

Moment (as well as its building blocks) embraces popular web software design patterns such as:

- [Model-View-Controller][MVC]
- [Front Controller][Front Controller]
- [Dependency Injection][DI] and service container

# Installation

Moment requires following software stack in order to run:

- Apache with `mod_rewrite` module enabled
- PHP 5.4 or above with [mbstring][mbstring] and [intl][intl] modules enabled
- [ionCube Loader][ionCube Loader] to be installed on the web server and made available to PHP
- [Composer][Composer] dependency manager

Here is step-by-step guide on how to install framework locally using [XAMPP][XAMPP] on Windows:

- create project folder: `C:\xampp\htdocs\moment`
- within project folder issue following command (this will install app skeleton and all dependencies):

```bash
composer create-project momentphp/app . --stability=dev
```
- create domain to serve application (`moment.dev` in this example). Do that by adding following
vhost configuration inside `C:\xampp\apache\conf\extra\httpd-vhosts.conf`:

```
<VirtualHost *:80>
    DocumentRoot "C:\xampp\htdocs\moment\web"
    ServerName moment.dev
    <Directory "C:\xampp\htdocs\moment\web">
        Options All
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
```

- add new domain definition to OS hosts file (`C:\WINDOWS\system32\drivers\etc\hosts`):
- restart Apache server

After completing above steps, point your browser to `http://moment.dev` and you should see framework welcome page with
some debug information.

# Service container

Put simply, a **service** is usually a PHP object that performs some sort of task such as sending emails or persisting information
into a database. A **service container** (or dependency injection container) is a PHP object that manages the
instantiation of services (with their dependencies). You can register and retrieve services via `$app` object,
which is an instance of `moment\App` class.

To retrieve a service from container:

```php
$this->app->config // inside controller, model or helper
{$this->app->config} // inside template
```

## Registering services

In order to register a new service, it must be given a **name**. Service name should be unique and in [camelCase][camelCase]
format. To register a service which returns the same shared instance of the object for all calls:

```php
$app->service('someService', function () {
    return new Object;
});
```

If you want a different instance to be returned for all calls:

```php
$app->service('someService', function () {
    return new Object;
}, 'factory');
```

You can also register anonymous function as a service. The function will be returned without being invoked:

```php
$app->service('someService', function ($name) {
    return 'Hello ' . $name;
}, 'protect');
```

## Core framework services

All framework features are buit as services. Their names and short descriptions are presented in the following table:

<table>
    <tr>
        <th>name</th>
        <th>description</th>
    <tr>
        <td><code>$app->bundle</code></td>
        <td>returns object that manages loaded bundles (e.g retrieves components instances)</td>
    </tr>
    <tr>
        <td><code>$app->env</code></td>
        <td>returns app environment name</td>
    </tr>
    <tr>
        <td><code>$app->environment</code></td>
        <td>returns server environment data</td>
    </tr>
    <tr>
        <td><code>$app->debug</code></td>
        <td>returns app debug flag</td>
    </tr>
    <tr>
        <td><code>$app->pathBase</code></td>
        <td>returns app skeleton installation path</td>
    </tr>
    <tr>
        <td><code>$app->pathWeb</code></td>
        <td>returns web server document root path</td>
    </tr>
    <tr>
        <td><code>$app->pathTmp</code></td>
        <td>returns temporary files path</td>
    </tr>
    <tr>
        <td><code>$app->pathLog</code></td>
        <td>returns log files path</td>
    </tr>
    <tr>
        <td><code>$app->config</code></td>
        <td>returns object that manages configuration</td>
    </tr>
    <tr>
        <td><code>$app->database</code></td>
        <td>returns object that manages database connections</td>
    </tr>
    <tr>
        <td><code>$app->model</code></td>
        <td>returns object that manages database models</td>
    </tr>
    <tr>
        <td><code>$app->cache</code></td>
        <td>returns object that manages cache adapters</td>
    </tr>
    <tr>
        <td><code>$app->log</code></td>
        <td>returns object that manages loggers</td>
    </tr>
    <tr>
        <td><code>$app->router</code></td>
        <td>returns object that manages routes</td>
    </tr>
    <tr>
        <td><code>$app->view</td>
        <td>returns view object that controller uses</td>
    </tr>
    <tr>
        <td><code>$app->viewEngine</td>
        <td>returns templating engine object</td>
    </tr>
</table>

# Bundles

# Configuration

# Controllers

# Models

# Templates

# Error handling

[Slim]: http://www.slimframework.com/
[Smarty]: http://www.smarty.net/
[Laravel]: http://http://laravel.com/
[Composer]: https://getcomposer.org/
[XAMPP]: https://www.apachefriends.org/
[ionCube Loader]: https://www.ioncube.com/loaders.php

[MVC]: https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller
[Front Controller]: https://en.wikipedia.org/wiki/Front_Controller_pattern
[DI]: https://en.wikipedia.org/wiki/Dependency_injection
[camelCase]: https://en.wikipedia.org/wiki/CamelCase

[mbstring]: http://php.net/manual/en/book.mbstring.php
[intl]: http://php.net/manual/en/book.intl.php

