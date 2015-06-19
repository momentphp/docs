{extends file='welcome/layout/default.tpl'}

{block 'head'}
<link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/highlight.js/8.5/styles/default.min.css">
<link rel="stylesheet" href="/bundle/docs/css/docs.css">
{/block}

{block 'content'}
<div role="flatdoc">
    <div class="docs-nav">
        <div role="flatdoc-menu"></div>
    </div>
    <div class="docs-content">
        <div style="text-align: right">
            <a href="/" class="button-action">Home page &raquo;</a>
        </div>
        {if $this->app->bundle->has('welcome')}
            {include file='welcome/element/logo.tpl'}
        {/if}
        <div role="flatdoc-content"></div>
        <div style="text-align: right">
            <a href="{$this->app->config->get('bundle.docs.url.improve')}" class="button-action">Improve this doc &raquo;</a>
        </div>
    </div>
</div>
{/block}

{block 'scripts'}
<script src="//cdnjs.cloudflare.com/ajax/libs/highlight.js/8.5/highlight.min.js"></script>
<script src="//cdn.rawgit.com/rstacruz/flatdoc/v0.9.0/flatdoc.js"></script>
<script src="//cdn.rawgit.com/rstacruz/jquery-stuff/master/anchorjump/jquery.anchorjump.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/waypoints/2.0.5/waypoints.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/lettering.js/0.7.0/jquery.lettering.js"></script>
<script>

    $(document).ready(function() {

        $('.page-heading h1 a').lettering();

        Flatdoc.run({
            fetcher: Flatdoc.file('/bundle/docs/README.md')
        });

    });

    $(document).on('flatdoc:ready', function() {

        $('.docs-nav a').anchorjump();

        $('h1, h2, h3', '.docs-content').waypoint(function(direction) {
            var id = $(this).attr('id');
            $('.docs-nav a').removeClass('active');
            $("[href='#" + id + "']").addClass('active');
        });

        $('pre code').each(function(i, block) {
            hljs.highlightBlock(block);
        });

    });

</script>

{/block}

