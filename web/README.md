Moment is a lightweight and intuitive PHP mini-framework enabling modular app design.
The *mini* prefix means that it sits somewhere between micro and full-stack frameworks.
It offers bare minimum of functionality required in order to create web sites and
web applications. Most importantly it gives "structure" to your code, leaving
free choice about inclusion of additional tools. It is built on top of well-known amongst the PHP community
libraries and solutions:

- [Slim][Slim] micro-framework
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
$this->app->config // inside controller, model etc.
{$this->app->config} // inside template
```

You can also retrieve services directly via container:

```php
$config = $app->getContainer()->get('config');
```

## Registering services

In order to register a new service, it must be given a **name**. Service name should be unique and in [camelCase][camelCase]
format. To register a service which returns the same shared instance of the object for all calls:

```php
$app->service('someService', function ($container) {
    $otherService = $container->get('otherService'); // you may access other services in the container
    return new Object;
});
```

If you want a different instance to be returned for all calls:

```php
$app->service('someService', function ($container) {
    return new Object;
}, 'factory');
```

You can also register anonymous function as a service. The function will be returned without being invoked:

```php
$app->service('someService', function ($name) {
    return 'Hello ' . $name;
}, 'protect');
```

In some cases you may want to modify a service after it has been defined:

```php
$app->service('someService', function ($service, $container) {
    $service->setParam();
    return $service;
}, 'extend');
```

## Service providers

Service providers are classes responsible for registering services and are located inside `/service` folder
within bundle. Service provider class should extend `\moment\Service` and implement `register()` method:

```php
namespace app\bundle\welcome\service;

class TestService extends \moment\Service
{
    public function register()
    {
        $this->app->service('test', function() {
            return 'Test Service';
        });
    }
}
```

Service providers are loaded via configuration. In order to load above service you must put
following line in `/config/app.php`:

```php
'services' => [
    'Test' => true
]
```

You can also unload service provider loaded by previous bundle (see [Bundle inheritance][BUNDLES-BUNDLE-INHERITANCE]):

```php
'services' => [
    'Other' => false
]
```

## Important framework services

All framework features are buit as services. Most important ones with their names and short descriptions are presented
in the following table:

<table>
    <tr>
        <th>name</th>
        <th>description</th>
    </tr>
    <tr>
        <td><code>$app->app</code></td>
        <td>returns application object</td>
    </tr>
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
        <td>returns object that manages cache stores</td>
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
    <tr>
        <td><code>$app->error</td>
        <td>returns object that manages error handling &amp; error logging</td>
    </tr>
</table>

# Bundles

Moment enables modular design via **bundles**. Bundles are mini-apps offering certain
functionality. Have a great user management module, simple blog, or web services module in one of
your applications? Package it as bundle so you can reuse it in other applications and share with the community.
Your main application can use multiple bundles.

## Creating new bundle

By default bundles are placed inside `/bundle` folder (assuming you are using [app skeleton]).
Each bundle should have its own unique **name** in [camelCase][camelCase] format.
If we were to create `helloWorld` bundle we should create class file `/bundle/helloWorld/HelloWorldBundle.php`
with following content:

```php
namespace app\bundle\helloWorld;

class HelloWorldBundle extends \moment\Bundle
{
}
```

Bundle class name is derived from bundle name. The location of bundle class file determines bundle
root folder. Within that folder you can place various bundle components like configuration, models, controllers etc.
Theoretically bundle can be placed anywhere as long as Composer's autoloader is able to locate
bundle class file.

## Bundle folder structure

<table>
    <tr>
        <th>folder or file</td>
        <th>description</th>
    </tr>
    <tr>
        <td><code>/config</code></td>
        <td>bundle configuration</td>
    </tr>
    <tr>
        <td><code>/controller</code></td>
        <td>bundle controllers</td>
    </tr>
    <tr>
        <td><code>/helper</code></td>
        <td>bundle helpers</td>
    </tr>
    <tr>
        <td><code>/middleware</code></td>
        <td>bundle middlewares</td>
    </tr>
    <tr>
        <td><code>/service</code></td>
        <td>bundle service providers</td>
    </tr>
    <tr>
        <td><code>/model</code></td>
        <td>bundle models</td>
    </tr>
    <tr>
        <td><code>/template/helloWorld</code></td>
        <td>bundle templates</td>
    </tr>
    <tr>
        <td><code>route.php</code></td>
        <td>bundle routes</td>
    </tr>
    <tr>
        <td><code>HelloWorldBundle.php</code></td>
        <td>bundle class file</td>
    </tr>
</table>

## Loading bundles

Appliation loads bundles in main `index.php` file which serves as a front controller responding for all incoming
requests:

```php
$app = new moment\App([
    new app\bundle\helloWorld\HelloWorldBundle,
    ...
]);

// or

$app = new moment\App;
$app->bundle->load(new app\bundle\helloWorld\HelloWorldBundle);
$app->bundle->load(...);
```

Instead of bundle instance, you can also pass bundle name:

```php
$app = new moment\App([
    'helloWorld'
    ...
]);
```

Application will search default bundle namespaces (`\app\bundle`, `\moment\bundle`) and load correct bundle.
Use `$app->bundle->addNamespace($namespace)` method to add more namespaces to search.

## Bundle inheritance

As stated earlier application can use multiple bundles. The order in which bundles are loaded matters. Components from
previous bundle can be overriden in next bundle in chain. To illustrate this process let's assume
that application loads two bundles:

```php
$app = new moment\App(['a', 'b']);
```

In order to override configuration from bundle `a` you need to create config file with the same name in bundle `b`
but only with options you wish to override.

In order to override route from bundle `a` you need to create a route in bundle `b` with the same URL path but different
handler.

In order to override specific template from bundle `a` e.g:

```html
/bundle/a/template/a/element/post.tpl
```

create the same file in bundle `b`:


```html
/bundle/b/template/a/element/post.tpl
```

In order to override class-based components ([controllers][CONTROLLERS], [models][MODELS], [helpers][HELPERS],
[middlewares][MIDDLEWARES] or [service providers][SERVICES-SERVICE-PROVIDERS]) create corresponding class file with
the same name and extend class from previous bundle:

```php
namespace app\bundle\b\model;

class PostModel extends \app\bundle\a\model\PostModel
{
    public function index()
    {
        return parent::index();
    }
}
```

# Configuration

Configuration is stored in plain PHP files inside `/config` folder. Each file should return an array
of options. It is advisable to create separate file for each category of configuration options. If we
would like to store API keys for our application we could create `/config/api.php` file with following
content:

```php
return [
    'Google' => [
        'Recaptcha' => [
            'publicKey' => 'fc2baa1a20b4d5190b122b383d7449fd',
            'privateKey' => '4f14fbe4af13860085e563210782da88'
        ]
    ],
    'Twitter' => 'f561aaf6ef0bf14d4208bb46a4ccb3ad'
];
```

Config service allows you to access above configuration values anywhere:

```php
$app->config->get('api.Google.Recaptcha.publicKey'); // returns single key
$app->config->get('api'); // returns whole array
```

You may also specify a default value to return if the configuration option does not exist:

```php
$app->config->get('api.Instagram', 'bf083d4ab960620b645557217dd59a49');
```

Configuration values can also be set at run-time:

```php
$app->config->set('api.Yahoo', '241fe8af1e038118cd817048a65f803e');
```

There is also a handy method for checking existence of given configuration key:

```php
$app->config->has('api.Github'); // false
```

## Environment specific configuration

It is often helpful to have different configuration values based on the environment the application is running in.
Application environment is set inside main `index.php` file:

```php
$app->service('env', 'development');
```

To override configuration for development environment (set above) simply create a folder within the `/config` directory
that matches environment name. Next, create the configuration files you wish to override and specify the options for
that environment. For example, to override the debug flag for the development environment, you would create a
`/config/development/app.php` file with the following content:

```php
return [
    'debug' => true
]
```

## Default configuration file names

Framework stores its configuration in following files:

<table>
    <tr>
        <th>file name</td>
        <th>description</th>
    </tr>
    <tr>
        <td>`app.php`</td>
        <td>application configuration</td>
    </tr>
    <tr>
        <td>`bundle.php`</td>
        <td>bundles configuration (see <a href="#instance-configuration">Instance configuration</a>)</td>
    </tr>
    <tr>
        <td>`cache.php`</td>
        <td>cache stores configuration</td>
    </tr>
    <tr>
        <td>`database.php`</td>
        <td>database connections configuration</td>
    </tr>
    <tr>
        <td>`helper.php`</td>
        <td>helpers configuration (see <a href="#instance-configuration">Instance configuration</a>)</td>
    </tr>
    <tr>
        <td>`log.php`</td>
        <td>loggers configuration</td>
    </tr>
    <tr>
        <td>`middleware.php`</td>
        <td>middleware providers configuration (see <a href="#instance-configuration">Instance configuration</a>)</td>
    </tr>
    <tr>
        <td>`model.php`</td>
        <td>models configuration (see <a href="#instance-configuration">Instance configuration</a>)</td>
    </tr>
    <tr>
        <td>`service.php`</td>
        <td>services configuration (see <a href="#instance-configuration">Instance configuration</a>)</td>
    </tr>
</table>

# Instance configuration

Many framework classes are using configuration capabilities provided by `\moment\OptionsTrait`. It provides clean
solution for configuring instances without the need to create unnecessary class properties. Firstly you can
hard code configuration inside a class:

```php
class PostModel extends Model
{
    protected $options = [
        'listing' => [
            'perPage' => 10
        ]
    ];
}
```

Hard-coded options are merged with options passed to constructor function during object initialization.
For [bundles][Bundles], [models][MODELS], [helpers][Helpers], [service providers][Services] and
[middleware providers][Middlewares] you can define configuration options passed to constructor by creating
appropriate configuration file. For `PostModel` above we could create `/config/model.php` file with following content:

```php
return [
    'Post' => [
        'listing' => [
            'perPage' => 20,
            'more' => true,
        ]
    ]
];
```

You can get and set model configuration after instance creation via `options()` method:

```php
$this->Post->options('listing.perPage'); // get
$this->Post->options('listing.perPage', 5); // set
```

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
class PostModel extends Model
{
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

Routes are a way to map URLs to the code that gets executed only when a certain request is
received at the server. Routes are defined in `/route.php` file inside bundle. Each route
consists of three elements:

- HTTP method
- URL pattern
- route handler

Here is sample route definition:

```php
$app->any('/docs', 'Docs@index');
```

With above definition, any HTTP request (`GET`, `POST`, `...`) to `/docs` URL will invoke handler - that is
`DocsController::index()` method. Handler can also be defined as anonymous function which takes
`$request`, `$response` and `$args` params:

```php
$app->any('/docs', function ($request, $response, $args) use ($app) {
    $debugFlag = $app->debug; // accessing services
    return $response->write('Hello world');
});
```

Note that you can optionally pass `$app` to anonymous function using `use` statement to
access services if needed.

You can find more information about routes in Slim's documentation:

- [http://docs-new.slimframework.com/objects/router/][routes]

# Middlewares

# Controllers

Controllers classes are located under `/controller` folder inside a bundle. In a typical scenario
controller is responsible for interpreting the request data, making sure the correct models are called, and the
right response or template is rendered. Commonly, a controller is used to manage the logic around a single model.

## Controller actions

Methods inside controller class are called **actions**. You map incoming URL to given controller action by creating
corresponding [route][Routes]. Let's create simple route:

```php
$app->get('/hello/{name}', 'Hello@say');
```

and corresponding controller class:

```php
namespace app\bundle\helloWorld\controller;

class HelloController extends \moment\Controller
{
    public function say($name)
    {
        return 'Hello ' . $name;
    }
}
```

Controller action can return:

- a string (sent to browser as `text/html`)
- a response object
- nothing

In case nothing is returned from action default action template will be rendered: `/template/helloWorld/controller/Hello/say.tpl`.
You can specify which template should be rendered by setting `$template` property inside action body:

```php
$this->template = 'say2'; // will render: /template/helloWorld/controller/Hello/say2.tpl
// or
$this->template = '/say2'; // will render: /template/say2.tpl
```

The `Controller::set()` method is the main way to send data from your controller to your template:

```php
// inside controller action:
$this->set('color', 'pink');

// inside template
You have choosen {$color} color.
```

The `Controller::set()` method also takes an associative array as its first parameter.

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
[routes]: http://www.slimframework.com/docs/objects/router.html
[response]: http://www.slimframework.com/docs/objects/response.html

[app skeleton]: https://github.com/momentphp/app

[INSTALLATION]: #installation
[SERVICES]: #services
[SERVICES-SERVICE-PROVIDERS]: #services-service-providers
[MODELS]: #models
[BUNDLES]: #bundles
[HELPERS]: #helpers
[MIDDLEWARES]: #middlewares
[BUNDLES-BUNDLE-INHERITANCE]: #bundles-bundle-inheritance
[CONTROLLERS]: #controllers

