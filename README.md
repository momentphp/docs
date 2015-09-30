MomentPHP is a lightweight and intuitive PHP mini-framework enabling modular app design.
The *mini* prefix means that it sits somewhere between micro and full-stack frameworks.
It offers bare minimum of functionality required in order to create web sites and
web applications. Most importantly it gives "structure" to your code, leaving
free choice about inclusion of additional tools. It is built on top of well-known (amongst the PHP community)
libraries and solutions:

- [Slim][Slim] micro-framework
- [Twig][Twig] / [Smarty][Smarty] templating engines (both supported out of the box)
- components responsible for database access, configuration and caching from [Laravel][Laravel] framework
- [Composer][Composer] dependency manager

The framework (as well as its building blocks) embraces popular web software design patterns such as:

- [Model-View-Controller][MVC]
- [Front Controller][Front Controller]
- [Dependency Injection][DI] / service container

# Installation

MomentPHP requires following software stack in order to operate:

- a web server like Apache or Nginx (read more about [web server setup][web-servers] in Slim's documentation)
- PHP 5.5.9 or above
- free [ionCube Loader][ionCube Loader] module to be installed and made available to PHP
- [Composer][Composer] dependency manager

It is also recommended (but not required) to enable following PHP modules:

- [mbstring][mbstring]
- [intl][intl]

## Local setup

Here is step-by-step guide on how to setup framework locally using [XAMPP][XAMPP] on Windows:

- create project folder: `C:\xampp\htdocs\momentphp`
- within project folder issue following command (this will install app skeleton along with its dependencies):

```bash
composer create-project momentphp/app . --stability=dev
```

- create domain to serve the application (`momentphp.local` in this example). Do that by adding following
vhost configuration inside `C:\xampp\apache\conf\extra\httpd-vhosts.conf`:

```
<VirtualHost *:80>
    DocumentRoot "C:\xampp\htdocs\momentphp\web"
    ServerName momentphp.local
    <Directory "C:\xampp\htdocs\momentphp\web">
        Options All
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
```

- add new domain definition to OS hosts file (`C:\WINDOWS\system32\drivers\etc\hosts`):

```bash
127.0.0.1 momentphp.local
```

- restart Apache web server

After completing above steps, point your browser to `http://momentphp.local` and you should see framework welcome page with
some debug information.

# Services

Put simply, a **service** is usually a PHP object that performs some sort of task
such as sending emails, rendering templates or persisting information into a database.
A **service container** (or dependency injection container) is a PHP object that
manages the instantiation of services (with their dependencies). MomentPHP uses default
service container provided by Slim - [Pimple][Pimple]. You can register and retrieve
services via `$app` object (passed around to various framework classes), which is an
instance of `momentphp\App` class.

To retrieve a service from container via `$app` object:

```php
$this->app->config // inside controller, model etc.
{{ this.app.config }} // inside Twig template
{$this->app->config} // inside Smarty template
```

You can also retrieve services using service container directly:

```php
$config = $app->getContainer()->get('config');
```

There is also a global helper function `app()` which allows accessing services in the container.
It can be used just about anywhere (for example in configuration files):

```php
return [
    'templates' => app('bundles')->paths('templates'),
]
```

## Registering services

In order to register a new service, it must be given a **name**. Service name should be unique and in [camelCase][camelCase]
format. You may use handy `momentphp\App::service()` helper method to register a service which returns **the same shared instance**
of the object for all calls:

```php
$app->service('someService', function ($container) {
    $otherService = $container->get('otherService'); // you may access other services in the container
    return new Object($otherService);
});
```

You may need to use service container directly in order to register non-shared services.
For example if you want a **different instance** to be returned for all calls:

```php
$app->service('someService', $app->getContainer()->factory(function ($container) {
    return new Object;
}));
```

You can also register **anonymous function as a service**. The function will be returned without being invoked:

```php
$app->service('someService', $app->getContainer()->protect(function ($name) {
    return 'Hello ' . $name;
}));
```

In some cases you may want to **modify a service after it has been defined**:

```php
$app->getContainer()->extend('someService', function ($service, $container) {
    $service->setParam();
    return $service;
});
```

## Service providers

Service providers are classes responsible for registering services and are located inside `/providers` folder
within bundle. Service provider class should extend `momentphp\ServiceProvider` and implement `register()` method:

```php
namespace app\bundle\welcome\providers;

class TestService extends \momentphp\ServiceProvider
{
    public function register()
    {
        $this->app->service('test', function() {
            return 'Test Service';
        });
    }
}
```

Service providers are loaded via configuration. In order to load above service provider you must put
following line in `/config/app.php`:

```php
'providers' => [
    'Test' => true
]
```

You can also unload service provider loaded by previous bundle (see [Bundle inheritance][BUNDLES-BUNDLE-INHERITANCE]):

```php
'providers' => [
    'Other' => false
]
```

You can also load service provider manually via `momentphp\App::register()` method:

```php
$app->register('TestServiceProvider');
```

Note that you may put default service provider options in `/config/providers.php` and later access
those options within the class via `$this->options()` - see [Instance configuration][INSTANCE-CONFIGURATION].

You may also implement `ServiceProvider::boot()` method. This method is called after all
other service providers have been registered, meaning you have access to all other services
that have been registered.

## Important framework services

Most framework features are buit as services. Important ones with their names and short descriptions are presented
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
        <td><code>$app->bundles</code></td>
        <td>returns object that manages loaded bundles (e.g retrieves correct classes or paths)</td>
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
        <td><code>$app->request</code></td>
        <td>returns current request object</td>
    </tr>
    <tr>
        <td><code>$app->response</code></td>
        <td>returns current response object</td>
    </tr>
    <tr>
        <td><code>$app->debug</code></td>
        <td>returns app debug flag</td>
    </tr>
    <tr>
        <td><code>$app->console</code></td>
        <td>returns app console flag</td>
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
        <td><code>$app->pathLogs</code></td>
        <td>returns logs path</td>
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
        <td><code>$app->models</code></td>
        <td>returns object that manages models</td>
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
        <td><code>$app->view</code></td>
        <td>returns view object that allows to render templates</td>
    </tr>
    <tr>
        <td><code>$app->error</td>
        <td>returns object that registers framework error handlers</td>
    </tr>
</table>

# Bundles

One of the most powerful features of MomentPHP is its bundles system.
Bundles are mini-apps offering certain functionality. Have a great user management module, simple blog, or web services
module in one of your applications? Package it as bundle so you can reuse it in other applications and share with the community.
Your application can use multiple bundles.

## Creating a new bundle

By default bundles are placed inside `/bundle` folder (assuming you are using [app skeleton]).
Each bundle should have its own **unique namespace**. If we were to create `helloWorld` bundle we should start
by creating bundle class file `/bundle/helloWorld/HelloWorldBundle.php` with following content:

```php
namespace app\bundle\helloWorld;

class HelloWorldBundle extends \momentphp\Bundle
{
}
```

The location of bundle class file determines bundle root folder. Within that folder you can place various
bundle resources like configuration, routes, models, controllers etc. Theoretically bundle can be placed in any path
as long as Composer's autoloader is able to locate bundle class file.

Each bundle has an alias, which is the lower-cased version of the bundle namespace where namespace separators (`\`)
are replaced with dots:

<table>
    <tr>
        <th>namespace</th>
        <th>alias</th>
    </tr>
    <tr>
        <td><code>app\bundle\helloWorld</code></td>
        <td><code>app.bundle.helloworld</code></td>
    </tr>
</table>

Aliases are used across various framework parts - i.e. to load templates from specific bundle or
get bundle object from `$app->bundles` service. You may alter default alias with custom one while
loading bundle.

`momentphp\Bundle::boot()` callback is invoked just before response is sent to the client.
It can be used to set some global PHP settings or to manually register middlewares:

```php
class HelloWorldBundle extends \momentphp\Bundle
{
    public function boot()
    {
        $this->app->add('TestMiddleware'); // register app middleware
        ini_set('memory_limit', '2048M'); // set global PHP settings
    }
}
```

## Bundle folder structure

<table>
    <tr>
        <th>folder or file</td>
        <th>description</th>
    </tr>
    <tr>
        <td><code>/cells</code></td>
        <td>bundle cells</td>
    </tr>
    <tr>
        <td><code>/config</code></td>
        <td>bundle configuration</td>
    </tr>
    <tr>
        <td><code>/controllers</code></td>
        <td>bundle controllers</td>
    </tr>
    <tr>
        <td><code>/helpers</code></td>
        <td>bundle helpers</td>
    </tr>
     <tr>
        <td><code>/templates</code></td>
        <td>bundle templates</td>
    </tr>
    <tr>
        <td><code>/middlewares</code></td>
        <td>bundle middlewares</td>
    </tr>
    <tr>
        <td><code>/providers</code></td>
        <td>bundle service providers</td>
    </tr>
    <tr>
        <td><code>/models</code></td>
        <td>bundle models</td>
    </tr>
    <tr>
        <td><code>routes.php</code></td>
        <td>bundle routes</td>
    </tr>
    <tr>
        <td><code>HelloWorldBundle.php</code></td>
        <td>bundle main class file</td>
    </tr>
</table>

## Loading bundles

Appliation loads bundles in main `index.php` file which serves as a front controller responding for all incoming
requests:

```php
$app = new momentphp\App([
    app\bundle\helloWorld\HelloWorldBundle::class,
    ...
]);
// or
$app = new momentphp\App;
$app->bundles->load(app\bundle\helloWorld\HelloWorldBundle::class);
$app->bundles->load(...);
```

While loading a bundle you may choose to disable loading of certain bundle resources or assign custom
alias:

```php
/**
 * Do not load configuration and routes from helloWorld bundle and assign custom alias
 */
$app = new momentphp\App([
    app\bundle\helloWorld\HelloWorldBundle::class => ['alias' => 'hello', 'skip' => ['config', 'routes']],
    ...
]);
// or
$app->bundles->load([app\bundle\helloWorld\HelloWorldBundle::class => ['alias' => 'hello', 'skip' => ['config', 'routes']]]);
```

## Bundle inheritance

Bundle inheritance is one of the most powerful features of MomentPHP. As stated earlier application
can use multiple bundles. The order in which bundles are loaded matters. Resources from
previous bundle can be overriden in next bundle in chain. To illustrate this process let's assume
that application loads two bundles:

```php
$app = new momentphp\App([
    app\bundle\first\FirstBundle::class,
    app\bundle\second\SecondBundle::class
]);
```

### Configuration

In order to override configuration from `first` bundle you need to create config file with the same name in `second` bundle
but only with options you wish to override (see [Configuration][CONFIGURATION]).

### Routes

In order to override route from `first` bundle you need to create a route in `second` bundle with the same URL pattern but different
handler (see [Routes][ROUTES]).

### Templates

In order to override specific template from `first` bundle:

```html
/bundle/first/templates/partials/post.tpl
```

create the template file with the same name in `second` bundle:

```html
/bundle/second/templates/partials/post.tpl
```

See [Templates][TEMPLATES] for more information.

### Classes

In order to override class-based resources (like [controllers][CONTROLLERS], [models][MODELS], etc.)
create corresponding class file with the same name and extend suitable parent class:

```php
namespace app\bundle\second\models;

class PostModel extends \app\bundle\first\models\PostModel
{
    public function index()
    {
        return parent::index();
    }
}
```

# Configuration

Configuration is stored in plain PHP files inside `/config` folder in each bundle. Each file should return an array
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
By default application environment is set to `production`. You can change environment setting inside main `index.php` file:

```php
$services = [
    'env' => 'production',
    'pathBase' => $pathBase,
    'pathWeb' => __DIR__,
];

$app = new momentphp\App([...], $services);
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

Framework stores its configuration in a set of pre-defined files:

<table>
    <tr>
        <th>file name</td>
        <th>description</th>
    </tr>
    <tr>
        <td><code>app.php</code></td>
        <td>application configuration</td>
    </tr>
    <tr>
        <td><code>bundles.php</code></td>
        <td>bundles configuration (see <a href="#instance-configuration">Instance configuration</a>)</td>
    </tr>
    <tr>
        <td><code>cache.php</code></td>
        <td>cache stores configuration</td>
    </tr>
    <tr>
        <td><code>cells.php</code></td>
        <td>cells configuration (see <a href="#instance-configuration">Instance configuration</a>)</td>
    </tr>
    <tr>
        <td><code>database.php</code></td>
        <td>database connections configuration</td>
    </tr>
    <tr>
        <td><code>helpers.php</code></td>
        <td>helpers configuration (see <a href="#instance-configuration">Instance configuration</a>)</td>
    </tr>
    <tr>
        <td><code>loggers.php</code></td>
        <td>loggers configuration</td>
    </tr>
    <tr>
        <td><code>middlewares.php</code></td>
        <td>middlewares configuration (see <a href="#instance-configuration">Instance configuration</a>)</td>
    </tr>
    <tr>
        <td><code>models.php</code></td>
        <td>models configuration (see <a href="#instance-configuration">Instance configuration</a>)</td>
    </tr>
    <tr>
        <td><code>providers.php</code></td>
        <td>service providers configuration (see <a href="#instance-configuration">Instance configuration</a>)</td>
    </tr>
</table>

# Instance configuration

Many framework classes are using configuration capabilities provided by `momentphp\traits\OptionsTrait`. It provides clean
solution for configuring instances without the need to create unnecessary class properties. Firstly you may
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
For [bundles][BUNDLES], [models][MODELS], [helpers][TEMPLATES-HELPERS], [cells][TEMPLATES-CELLS], [service providers][SERVICES-SERVICE-PROVIDERS] and [middlewares][MIDDLEWARES] you can define configuration options passed to constructor by creating
appropriate configuration file. For `PostModel` above we could create `/config/models.php` file with following content:

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
files on disk or even external web services. MomentPHP model classes are located inside `/models` folder within bundle.

Here is a simple example of a model definition from `miniBlog` bundle:

```php
namespace app\bundle\miniBlog\models;

class PostModel extends \momentphp\Model
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

Within model methods, you can access database connection object via `momentphp\Model::db()` method. Please refer to Laravel's
documentation on how to create simple and advanced queries using this object:

- [Database][database]
- [Queries][queries]

Note that connections are lazily loaded when they are needed so a model may not use database at all - and
can talk to web service for instance.

## Connections

By default all model classes will use default database connection. In `/config/database.php` file within bundle you
may define all of your database connections, as well as specify which connection should be used by default.

You may tell model class to use different connection by specifying `$connection` property:

```php
class PostModel extends \momentphp\Model
{
    public $connection = 'connection2';
}
```

Moreover, you can access just about any defined connection by passing it's name to `$this->db()` method:

```php
$this->db('connection5')->table('posts')->where('id', $id)->first();
```

You may also access the raw, underlying [PDO][pdo] instance following way:

```php
$pdo = $this->db()->getPdo(); // inside model class
$pdo = $this->app->database->connection()->getPdo(); // via app object elsewhere
```

## Accessing models

You can access model instance via `$app->models` service:

```php
$this->app->models->Post->index();
```

Above creates "global" model instance which is initialized with configuration from `/config/models.php`:

```php
return [
    'Post' => [
        'perPage' => 25
    ]
]
```

If needed, you can create as many model instances as you wish manually via `momentphp\Model::factory()` method.
Using this way you must pass configuration in second param:

```php
$Post = $this->app->models->factory('Post', ['perPage' => 25]);
```

Inside controller, cell and model classes you can access models with more concise syntax:

```php
$this->Post->index();
```

## Model callbacks

`momentphp\Model::initialize()` callback lets you perform some logic just after model creation:

```php
class PostModel extends \momentphp\Model
{
    public function initialize()
    {
        // extecuted after model creation
    }
}
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
        <td>the name of cache store to use (will use default store if not set - see <a href="#caching">Caching</a>)</td>
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

# Controllers

Controllers classes are located under `/controllers` folder inside a bundle. In a typical scenario
controller is responsible for interpreting the request data, making sure the correct models are called, and the
right response or template is rendered. Commonly, a controller is used to manage the logic around a single model.

## Controller actions

Methods inside controller class are called **actions**. You map incoming URL to given controller action by creating
corresponding [route][ROUTES]. Let's create simple route:

```php
$app->get('/hello/{name}', 'HelloController:say');
```

and corresponding controller class:

```php
namespace app\bundle\helloWorld\controllers;

class HelloController extends \momentphp\Controller
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

In case nothing is returned from action default action template will be rendered:
`/templates/controllers/Hello/say.twig`. You can specify which template should be rendered by
interacting with controller's view object:

```php
$this->view->template('say2'); // will render: /templates/controllers/Hello/say2.twig
// or
$this->view->template('/say2'); // will render: /templates/say2.twig
```

You can also force controller to use template from specific bundle (referenced by alias):

```php
// following will render: /templates/controllers/Hello/say2.twig from 'hello' bundle
$this->view->template('say2')->bundle('hello');
```

If client asks for JSON (or XML) and your application is using [ContentTypeMiddleware][MIDDLEWARES-DEFAULT-MIDDLEWARES]
templates are rendered in following manner:

```php
// client asks for JSON
$this->view->template('say2'); // will render: /templates/controllers/Hello/json/say2.twig
// client asks for XML
$this->view->template('say2'); // will render: /templates/controllers/Hello/xml/say2.twig
```

The `momentphp\Controller::set()` method is the main way to send data from your controller to your template:

```php
// send variable to the template inside controller action:
$this->set('color', 'pink');
// or
$this->view->set('color', 'pink');

// access variable inside a template
You have choosen {{ color }} color.
```

The `set()` method also takes an associative array as its first parameter.

## Controller callbacks

If you need to perform some logic before or after controller action is invoked, you can use following
callbacks:

```php
class HelloController extends \momentphp\Controller
{
    public function beforeAction($action)
    {
        if ($action === 'say') {
            // extecuted before say() action
        }
    }

    public function afterAction($action)
    {
        if ($action === 'say') {
            // extecuted after say() action
        }
    }

    public function say($name)
    {
        return 'Hello ' . $name;
    }
}

```

There is also `momentphp\Controller::initialize()` callback which is fired just after controller creation.

## Request object

You can access current request object inside actions using `$this->request` property.
You may fetch an associative array of query string parameters with `getQueryParams()` method.
This method returns an empty array if no query string is present:

```php
$queryParams = $this->request->getQueryParams();
```

To fetch request parameter value from body OR query string (in that order):

```php
$foo = $this->request->getParam('foo'); // $_POST['foo'] or $_GET['foo']
$bar = $this->request->getParam('bar', 'default'); // setting default value if param not set
```

You can find more information about request object in [Slim’s][Slim] documentation:

- [Request object][request]

## Response object

You can access current response object inside actions using `$this->response` property. Response object
can be returned from action. To return redirect response:

```php
class HelloController extends \momentphp\Controller
{
    public function say($name)
    {
        return $this->response->withRedirect('/login');
    }
}
```

To return [JSON][JSON] response:

```php
class HelloController extends \momentphp\Controller
{
    public function say($name)
    {
        return $this->response->withJson(['name' => $name]);
    }
}
```

You can find more information about response object in [Slim’s][Slim] documentation:

- [Response object][response]

# Templates

Out of the box framework supports [Smarty][Smarty] and [Twig][Twig] templating engines.
Templating engines are exposed as services (named `smarty` and `twig` respectively) implementing
a common interface and are configured inside `/config/providers.php`. You pick which service
should be used by default by setting appropriate value inside `/config/app.php`:

```php
[
    'viewEngine' => 'smarty'
]
```

Template files should be placed inside `/templates` folder within bundle.
Templates should fall into pre-defined folders presented below:

<table>
    <tr>
        <th>folder</th>
        <th>description</th>
    </tr>
    <tr>
        <td><code>/templates/cells</code></td>
        <td>templates for cells actions</td>
    </tr>
    <tr>
        <td><code>/templates/controllers</code></td>
        <td>templates for controllers actions</td>
    </tr>
    <tr>
        <td><code>/templates/partials</code></td>
        <td>sub-templates - templates that are included by other templates via <code>{include}</code></td>
    </tr>
    <tr>
        <td><code>/templates/layouts</code></td>
        <td>layout templates</td>
    </tr>
</table>

The `this` variable inside templates represents `\momentphp\ViewTemplate` instance and allows you to
access various objects inside template file:

<table>
    <tr>
        <th>Smarty</th>
        <th>Twig</th>
        <th>description</th>
    </tr>
    <tr>
        <td><code>{$this->app}</code></td>
        <td><code>{{ this.app }}</code></td>
        <td>app object</td>
    </tr>
    <tr>
        <td><code>{$this->request}</code></td>
        <td><code>{{ this.request }}</code></td>
        <td>request object</td>
    </tr>
    <tr>
        <td><code>{$this->Html}</code></td>
        <td><code>{{ this.Html }}</code></td>
        <td>HtmlHelper object</td>
    </tr>
</table>

You can include template from specific bundle (referenced by alias - `hello` in following
example) via following syntax:

```
{include file='[hello]partials/debugTable.tpl'} // Smarty
{% include '@hello/partials/debugTable.twig' %} // Twig
```

## Helpers

Helpers are classes for the presentation layer of your application. They contain presentational logic that is shared
between many templates, elements, or layouts. Helpers may assist in creating well-formed markup, aid in formatting text,
times and numbers etc. Helper classes are placed under `/helpers` folder within bundle. Let's create sample `TextHelper`.
Create class file under `/app/bundle/helloWorld/helpers/TextHelper.php` with following content:

```php
namespace app\bundle\helloWorld\helpers;

class TextHelper extends \momentphp\Helper
{
    public function uppercase($text)
    {
        return strtoupper($text);
    }
}
```

Now, the helper is ready to be used inside templates:

```html
Here is uppercase post title: {$this->Text->uppercase($post.title)} // Smarty
Here is uppercase post title: {{ this.Text.uppercase(post.title) }} // Twig
```

Inside helper methods you may access:

```php
$this->app // app object
$this->view // ViewTemplate object
$this->view->request // request object
$this->view->vars // template variables
$this->options() // helper configuration set in /config/helpers.php
```

## Cells

Cells are small mini-controllers that can invoke view logic and render out templates.
Cells are ideal for building reusable page components that require interaction with models, view logic, and
rendering logic. A simple example would be the cart in an online store, or a data-driven navigation menu in a CMS.
Cells do not dispatch sub-requests. Cells classes are placed under `/cells` folder within bundle.

Let's create sample `ShoppingCart` cell. Create cell class file `/app/bundle/helloWorld/cells/ShoppingCartCell.php`
with following content:

```php
namespace app\bundle\helloWorld\cells;

class ShoppingCartCell extends \momentphp\Cell
{
    public function display($items = 5)
    {
        // grab some data and set it to the template
    }
}
```

Templates behave just like controller templates but are placed inside `/templates/cells` subfolder.
In case nothing is returned from cell action default template will be rendered:
`/app/bundle/helloWorld/templates/cells/ShoppingCart/display.twig`.

Our newly created cell may be invoked inside any template:

```html
{{ this.cell('ShoppingCart') }} // Twig
{$this->cell('ShoppingCart')} // Smarty
```

You can also invoke any cell action and pass additional arguments:

```html
{{ this.cell('ShoppingCart:display', 10) }} // Twig
{$this->cell('ShoppingCart:display', 10)} // Smarty
```

# Routes

Routes are a way to map URL-s to the code that gets executed only when a certain request is
received at the server. Routes are defined in `/routes.php` file inside bundle. Each route
consists of three elements:

- HTTP method
- URL pattern
- route handler

Here is sample route definition:

```php
$app->any('/docs', 'DocsController:index');
```

With above definition, any HTTP request (`GET`, `POST`, `...`) to `/docs` URL will invoke handler - that is
`DocsController::index()` method. Handler can also be defined as anonymous function which takes
`$request`, `$response` and `$args` params:

```php
$app->any('/docs', function ($request, $response, $args) {
    $debugFlag = $this->debug; // accessing $app->debug service
    return $response->write('Hello world');
});
```

Note that you will have access to the `$app` instance inside of the Closure via the `$this` keyword.

You can find more information about router and routes in [Slim's][Slim] documentation:

- [Router][router]

# Middlewares

Middleware is a callable which is invoked during application request/response lifecycle.
Please find more detailed information about middleware in [Slim's][Slim] documentation:

- [Middleware][middleware]

In order to create simple `Auth` middleware
create class file `/middlewares/AuthMiddleware.php` with content:

```php
namespace app\bundle\helloWorld\middlewares;

class AuthMiddleware extends \momentphp\Middleware
{
    public function run($request, $response, $next)
    {
        $cookies = $request->getCookieParams();
        if (!isset($cookies['auth'])) {
            return $response->withRedirect('/login');
        }
        return $next($request, $response);
    }
}
```

Middleware can be attached at application level manually:

```php
$app->add('AuthMiddleware');
```

or via configuration inside `/config/app.php`:

```php
'middlewares' => [
    'Auth' => true
]
```

Also you can attach middleware only to certain routes:

```php
$app->any('/pages/{page:.+}', 'PagesController:display')->add('AuthMiddleware');
```

## Default middlewares

By default MomentPHP ships with following middlewares:

<table>
    <tr>
        <th>name</th>
        <th>description</th>
    </tr>
    <tr>
        <td><code>BundleAssetsMiddleware</code></td>
        <td>
            Allows to serve bundle assets placed inside <code>/web</code> folder via properly
            constructed URL: <code>/bundle/{bundleAlias}/css/style.css</code>. Note that is's
            just a quick solution (files are served via PHP) and you should symlink your assets for
            performance reasons in production.
        </td>
    </tr>
    <tr>
        <td><code>ContentTypeMiddleware</code></td>
        <td>Will automatically switch response content type from HTML to JSON (or XML) if client asks for it.</td>
    </tr>
</table>

# Caching

Moment uses caching component from Laravel framework. Cache manager instance is available
as `cache` service. The cache configuration is located at `/config/cache.php`. In this file you
may specify which cache driver you would like used by default throughout your application.
By default, framework is configured to use the file cache driver, which stores the serialized,
cached objects in the filesystem.

Storing an item in the cache:

```php
$app->cache->put('key', 'value', $minutes);
```

Retrieving an item from the cache:

```php
$app->cache->get('key', 'default'); // retrieving an item or returning a default value
```

Checking for existence in cache:

```php
if ($app->cache->has('key'))
{
    //
}
```

Sometimes you may wish to retrieve an item from the cache, but also store a default value if the
requested item doesn't exist. You may do this using the `remember()` method:

```php
$value = $app->cache->remember('users', $minutes, function() use ($app) {
    return $app->model->Users->all();
});
```

When using multiple cache stores, you may access them via the `store()` method:

```php
$value = $app->cache->store('foo')->get('key');
```

Please refer to Laravel’s documentation for more information about cache manager features:

- [Cache][cache]

# Logging

By default `log` service will use default logger. In `/config/loggers.php` file within bundle
you may define all of your loggers, as well as specify which logger should be used by default.
Framework uses popular [Monolog][Monolog] library so under the hood each logger is
an instance of `Monolog\Logger` class.

Adding records to the log:

```php
$app->log->addDebug('Foo', ['some' => 'data']);
// or
$app->log->log(\Psr\Log\LogLevel::DEBUG, 'Foo', ['some' => 'data']);
```

You man access any configured logger via the `logger()` method:

```php
$app->log->logger('error')->addDebug('Foo', ['some' => 'data']);
```

## Error logging

You may want to log PHP errors. In order to do so please set appropriate
logger name in `/config/app.php`:

```php
'error' => [
    'log' => 'error'
]
```

# Error handling

MomentPHP converts all PHP errors to exceptions. You can set PHP error reporting level by
setting `app.error.level` to appropriate value:

```php
'error' => [
    'level' => -1 // report all errors
]
```

By default framework will display all errors as exceptions using the [Whoops!][Whoops] package if the `app.debug`
switch is turned on OR hide them and use `ErrorController` to render client-friendly messages if the switch is turned off.

The value of `app.debug` configuration setting is available as a `$app->debug` service.

To sum up - setting `debug` to `false` changes the following types of things:

- PHP errors are not displayed
- uncaught exceptions and fatal errors will render default internal server error page - using `ErrorController::error()`
- uncaught `momentphp\exceptions\NotFoundException` will render default not found page - using `ErrorController::notFound()`
- templates are not re-compiled when changed

# Command line

MomentPHP application can also be invoked in command line mode. This comes handy when
you need to setup some background processing tasks invoked by cron daemon for instance.

First, setup a `GET` route in `/routes.php`:

```
if ($app->console) {
    $app->get('/background/task', function($request, $response, $args) {
        // perform some tasks using models etc.
        ...
    });
}
```

Then, issue following command (where `index.php` is application's front controller):

```
php index.php background/task
```

[Slim]: http://www.slimframework.com/
[Smarty]: http://www.smarty.net/
[Twig]: http://twig.sensiolabs.org/
[Laravel]: http://http://laravel.com/
[Composer]: https://getcomposer.org/
[Monolog]: https://github.com/Seldaek/monolog
[XAMPP]: https://www.apachefriends.org/
[ionCube Loader]: https://www.ioncube.com/loaders.php
[JSON]: https://en.wikipedia.org/wiki/JSON
[Pimple]: http://pimple.sensiolabs.org/
[Whoops]: http://filp.github.io/whoops/

[MVC]: https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller
[Front Controller]: https://en.wikipedia.org/wiki/Front_Controller_pattern
[DI]: https://en.wikipedia.org/wiki/Dependency_injection
[camelCase]: https://en.wikipedia.org/wiki/CamelCase

[mbstring]: http://php.net/manual/en/book.mbstring.php
[intl]: http://php.net/manual/en/book.intl.php
[pdo]: http://php.net/manual/en/book.pdo.php

[database]: http://laravel.com/docs/5.0/database
[queries]: http://laravel.com/docs/5.0/queries
[cache]: http://laravel.com/docs/5.0/cache
[router]: http://www.slimframework.com/docs/objects/router.html
[response]: http://www.slimframework.com/docs/objects/response.html
[request]: http://www.slimframework.com/docs/objects/request.html
[middleware]: http://www.slimframework.com/docs/concepts/middleware.html
[web-servers]: http://www.slimframework.com/docs/start/web-servers.html

[app skeleton]: https://github.com/momentphp/app

[INSTALLATION]: #installation
[SERVICES]: #services
[SERVICES-SERVICE-PROVIDERS]: #services-service-providers
[BUNDLES]: #bundles
[TEMPLATES-HELPERS]: #templates-helpers
[TEMPLATES-CELLS]: #templates-cells
[MIDDLEWARES]: #middlewares
[MIDDLEWARES-DEFAULT-MIDDLEWARES]: #middlewares-default-middlewares
[BUNDLES-BUNDLE-INHERITANCE]: #bundles-bundle-inheritance
[MODELS]: #models
[CONTROLLERS]: #controllers
[ROUTES]: #routes
[CONFIGURATION]: #configuration
[INSTANCE-CONFIGURATION]: #instance-configuration
[TEMPLATES]: #templates
