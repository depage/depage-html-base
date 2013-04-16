/**
 * @file    js/global.js
 *
 * copyright (c) 2006-2013 Frank Hellenkamp [jonas@depage.net]
 *
 * @author    Frank Hellenkamp [jonas@depage.net]
 */

;var projectName = (function() {
    "use strict";

    var lang = $('html').attr('lang');

    // local Project instance that holds all variables and function
    var localJS = {
        // {{{ ready
        ready: function() {
            $("html").addClass("javascript");

            localJS.setup();

            // setup global events
            $(window).on("statechangecomplete", localJS.setup);
        },
        // }}}
        // {{{ setup
        setup: function() {
            localJS.setupVarious();
        },
        // }}}
        // {{{ setupVarious
        setupVarious: function() {
            // add click event for teaser
            $(".teaser").click( function() {
                document.location = $("a", this)[0].href;
            });
            
            // email antispam
            $("a[href*='mailto:']").depageAntispam();
        }
        // }}}
    };

    return localJS;
})();

// {{{ register events
$(document).ready(function() {
    projectName.ready();
});
// }}}
    
/* vim:set ft=javascript sw=4 sts=4 fdm=marker : */
