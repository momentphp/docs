$(document).ready(function() {

    $('.page-heading h1 a').lettering();

    Flatdoc.run({
        fetcher: Flatdoc.file(app.docsReadme)
    });

});

$(document).on('flatdoc:ready', function() {

    $('.docs-nav, .docs-content').TrackpadScrollEmulator();

    $('h1, h2, h3', '.docs-content').waypoint(function(direction) {
        var id = $(this).attr('id');
        if (!id) {
            return;
        }
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
