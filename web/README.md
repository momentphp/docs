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

[mbstring]: http://php.net/manual/en/book.mbstring.php
[intl]: http://php.net/manual/en/book.intl.php

