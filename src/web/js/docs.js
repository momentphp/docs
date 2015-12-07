$(document).ready(function() {

    $('.page-heading h1 a').lettering();

    $('div[role="flatdoc-content"] > div').hide();

    Flatdoc.run({
        fetcher: Flatdoc.file(app.docsReadme)
    });

});

$(document).on('flatdoc:ready', function() {

    $('pre code').each(function(i, block) {
        hljs.highlightBlock(block);
    });

    $('.docs-nav').TrackpadScrollEmulator();

    $('.tse-scroll-content').bind('mousewheel DOMMouseScroll', function (e) {
        var scrollTo = null;
        if (e.type == 'mousewheel') {
            scrollTo = (e.originalEvent.wheelDelta * -1);
        } else if (e.type == 'DOMMouseScroll') {
            scrollTo = 40 * e.originalEvent.detail;
        }
        if (scrollTo) {
            e.preventDefault();
            $(this).scrollTop(scrollTo + $(this).scrollTop());
        }
    });

    $('h1, h2, h3', 'div[role="flatdoc-content"]').each(function() {
        var id = $(this).attr('id');
        if (!id) {
            return;
        }
        $(this).data('inview', new Waypoint.Inview({
            element: $(this)[0],
            entered: function (direction) {
                // $('.docs-nav a').removeClass('active');
                $("[href='#" + id + "']").addClass('active');
            },
            exited: function (direction) {
                $("[href='#" + id + "']").removeClass('active');
            }
        }));
    });

    if (window.location.hash) {
        $(window.location.hash).get(0).scrollIntoView();
    }

});
