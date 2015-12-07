{extends file='layouts/default.tpl'}

{block 'head'}

    <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/highlight.js/8.8.0/styles/github.min.css">
    <link rel="stylesheet" href="//cdn.rawgit.com/jnicol/trackpad-scroll-emulator/master/css/trackpad-scroll-emulator.css">
    <link rel="stylesheet" href="/bundles/docs/css/docs.css">

    <script>
        app.docsReadme = '{$this->app->router->pathFor('docs-readme')}';
    </script>

{/block}

{block 'content'}

    <div role="flatdoc">
        <div class="tse-scrollable docs-nav">
            <div class="tse-content" role="flatdoc-menu"></div>
        </div>
        <div class="tse-scrollable docs-content">
            <div class="tse-content">
                <div class="content">
                    <div class="_right">
                        <a href="/" class="action-button">Home page &raquo;</a>
                    </div>
                    {if $this->app->bundles->has('welcome')}
                        {$this->cell('Logo')}
                    {/if}
                    <div role="flatdoc-content"></div>
                    <div class="_right">
                        <a href="{$this->app->config->get('bundles.docs.url.improve')}" class="action-button">Improve this doc &raquo;</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

{/block}

{block 'scripts'}

    <script src="//cdnjs.cloudflare.com/ajax/libs/highlight.js/8.8.0/highlight.min.js"></script>
    <script src="//cdn.rawgit.com/rstacruz/flatdoc/v0.9.0/flatdoc.js"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/waypoints/2.0.5/waypoints.js"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/lettering.js/0.7.0/jquery.lettering.js"></script>
    <script src="//cdn.rawgit.com/jnicol/trackpad-scroll-emulator/master/jquery.trackpad-scroll-emulator.js"></script>
    <script src="/bundles/docs/js/docs.js"></script>

{/block}

