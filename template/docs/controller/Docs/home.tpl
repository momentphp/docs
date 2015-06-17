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
        <div role="flatdoc-content"></div>
    </div>
</div>
{/block}

{block 'scripts'}
<script src="//cdnjs.cloudflare.com/ajax/libs/highlight.js/8.5/highlight.min.js"></script>
<script src="//cdn.rawgit.com/rstacruz/flatdoc/v0.9.0/flatdoc.js"></script>
<script src="//cdn.rawgit.com/rstacruz/jquery-stuff/master/anchorjump/jquery.anchorjump.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/waypoints/2.0.5/waypoints.js"></script>
<script>

    Flatdoc.run({
      fetcher: Flatdoc.file('/bundle/docs/README.md')
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

        $('a').each(function() {
            var a = new RegExp('/' + window.location.host + '/');
            if (!a.test(this.href)) {
               $(this).click(function(event) {
                   event.preventDefault();
                   event.stopPropagation();
                   window.open(this.href, '_blank');
               });
            }
        });

    });

</script>
{/block}

