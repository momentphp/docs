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

- Apache web server with `mod_rewrite` module enabled
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
- restart Apache web server

After completing above steps, point your browser to `http://moment.dev` and you should see framework welcome page with
some debug information.

# Services

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

## Service providers

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

# Models

Model classes in MVC pattern are responsible for providing controllers with data from various sources: databases,
files on disk or even external web services. Moment model classes are located inside `/model` folder within bundle.

Here is a simple example of a model definition from `miniBlog` bundle:

```php
namespace app\bundle\miniBlog\model;

class PostModel extends \moment\Model
{
    public function index()
    {
        return $this->db()->table('posts')->get();
    }

    public function view($id)
    {
        return $this->db()->table('posts')->where('id', $id)->first();
    }
}
```

Within model methods, you can access database connection object via `$this->db()` method. Please refer to Laravel's
documentation on how to create simple and advanced queries using this object:

- [http://laravel.com/docs/5.0/database][database]
- [http://laravel.com/docs/5.0/queries][queries]

Note that connections are lazily loaded when they are needed so your model may not use database at all - and
can talk to web service for instance.

## Connections

By default all model classes will use default database connection. In `/config/database.php` file within bundle you
may define all of your database connections, as well as specify which connection should be used by default.

You may tell model class to use different connection by specifying `$connection` property:

```php
class PostModel extends Model {

    protected $connection = 'connection2';

}
```

Moreover, you can access just about any defined connection by passing it's name to `$this->db()` method:

```php
$this->db('connection5')->table('posts')->where('id', $id)->first();
```

You may also access the raw, underlying PDO instance following way:

```php
$pdo = $this->db()->getPdo(); // inside model class
$pdo = $this->app->database->getConnection()->getPdo(); // via app object elsewhere
```

## Accessing models

You can access model instance via `$app->model` service:

```php
$this->app->model->Post->index();
```

Above creates "global" model instance which is initialized with configuration from `/config/model.php`:

```php
return [
    'Post' => [
        'perPage' => 25
    ]
]
```

If needed, you can create as many model instances as you wish manually via `factory()` method. Using this way you must
pass configuration in second param:

```php
$Post = $this->app->model->factory('Post', ['perPage' => 25]);
```

Inside controller and model classes you can access models with more concise syntax:

```php
$this->Post->index();
```

## Configuration

You can hard code default model configuration inside `$options` property within model class:

```
class PostModel extends Model {

    protected $options = [
        'index' => [
            'perPage' => 10
        ]
    ];

}
```

Hard coded options will be merged with options from `/config/model.php` for global models or passed options when
using `factory()` method.

You can get and set model configuration after model creation via `options()` method:

```php
$this->Post->options('index.perPage'); // get
$this->Post->options('index.perPage', 5); // set
```

## Caching model methods

There is convenient caching mechanism built into model layer. By specifying `cache` key in model configuration
you can control its behaviour:

```php
return [
    'Post' => [
        'cache' => [
            'ttl' => 60 // cache all methods calls for 60 minutes
        ]
    ]
];
```

Following table shows a list of all supported options:

<table>
    <tr>
        <th>option</td>
        <th>data type</th>
        <th>default value</th>
        <th>description</th>
    </tr>
    <tr>
        <td><code>store</code></td>
        <td><code>string</code></td>
        <td>not set</td>
        <td>the name of cache store to use (will use default store if not set)</td>
    </tr>
    <tr>
        <td><code>enabled</code></td>
        <td><code>boolean</code></td>
        <td><code>true</code></td>
        <td>cache method calls by default</td>
    </tr>
    <tr>
        <td><code>ttl</code></td>
        <td><code>integer</code></td>
        <td><code>30</code></td>
        <td>default time to live (in minutes)</td>
    </tr>
    <tr>
        <td><code>ttlMap</code></td>
        <td><code>array</code></td>
        <td><code>30</code></td>
        <td>maps method to ttl (in order to create non-default ttl for given method)</td>
    </tr>
    <tr>
        <td><code>cacheMethods</code></td>
        <td><code>array</code></td>
        <td><code>[]</code></td>
        <td>list of methods to cache (if <code>enabled</code> is set to <code>false</code>)</td>
    </tr>
    <tr>
        <td><code>nonCacheMethods</code></td>
        <td><code>array</code></td>
        <td><code>[]</code></td>
        <td>list of methods to no-cache (if <code>enabled</code> is set to <code>true</code>)</td>
    </tr>
</table>

# Routes

# Controllers

# Templates

# Caching

# Logging

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

[database]: http://laravel.com/docs/5.0/database
[queries]: http://laravel.com/docs/5.0/queries

[Caching]: /docs/#caching

