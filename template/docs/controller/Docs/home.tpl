{extends file='welcome/layout/default.tpl'}

{block 'head'}

    <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/highlight.js/8.5/styles/default.min.css">
    <link rel="stylesheet" href="//cdn.rawgit.com/jnicol/trackpad-scroll-emulator/master/css/trackpad-scroll-emulator.css">
    <link rel="stylesheet" href="/bundle/docs/css/docs.css">

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
                        <a href="/" class="button-action">Home page &raquo;</a>
                    </div>
                    {if $this->app->bundle->has('welcome')}
                        {$this->cell('Logo')}
                    {/if}
                    <div role="flatdoc-content"></div>
                    <div class="_right">
                        <a href="{$this->app->config->get('bundle.docs.url.improve')}" class="button-action">Improve this doc &raquo;</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

{/block}

{block 'scripts'}

    <script src="//cdnjs.cloudflare.com/ajax/libs/highlight.js/8.5/highlight.min.js"></script>
    <script src="//cdn.rawgit.com/rstacruz/flatdoc/v0.9.0/flatdoc.js"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/waypoints/2.0.5/waypoints.js"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/lettering.js/0.7.0/jquery.lettering.js"></script>
    <script src="//cdn.rawgit.com/jnicol/trackpad-scroll-emulator/master/jquery.trackpad-scroll-emulator.js"></script>
    <script>

        $(document).ready(function() {

            $('.page-heading h1 a').lettering();

            Flatdoc.run({
                fetcher: Flatdoc.file('/bundle/docs/README.md')
            });

        });

        $(document).on('flatdoc:ready', function() {

            $('.docs-nav, .docs-content').TrackpadScrollEmulator();

            $('h1, h2, h3', '.docs-content').waypoint(function(direction) {
                var id = $(this).attr('id');
                $('.docs-nav a').removeClass('active');
                $("[href='#" + id + "']").addClass('active');
            }, {
                context: '.docs-content .tse-scroll-content'
            });

            $('pre code').each(function(i, block) {
                hljs.highlightBlock(block);
            });

            if (window.location.hash) {
                $(window.location.hash).get(0).scrollIntoView();
            }

        });

    </script>

{/block}

