// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery2
//= require jquery_ujs
//= require turbolinks
//= require bootstrap

// Google Analytics event tracking common functions.
function sendGaEvent(category, action, label) {
    if (typeof label === 'undefined') {
        ga('send', {
            hitType: 'event',
            eventCategory: category,
            eventAction: action
        });
    } else {
        ga('send', {
            hitType: 'event',
            eventCategory: category,
            eventAction: action,
            eventLabel: label.trim()
        });
    };
};

function handleOutboundLinkClicks(href) {
    ga('send', 'event', {
        eventCategory: 'Outbound Link',
        eventAction: 'Click',
        eventLabel: href.trim(),
        transport: 'beacon'
    });
}

// Extension method to convert a number into time format.
String.prototype.toHHMMSS = function() {
    var sec_num = parseInt(this, 10); // Don't forget the second param.
    var hours = Math.floor(sec_num / 3600);
    var minutes = Math.floor((sec_num - (hours * 3600)) / 60);
    var seconds = sec_num - (hours * 3600) - (minutes * 60);

    if (hours < 10) {
        hours = "0" + hours;
    }
    if (minutes < 10) {
        minutes = "0" + minutes;
    }
    if (seconds < 10) {
        seconds = "0" + seconds;
    }

    var time = hours + ':' + minutes + ':' + seconds;
    return time;
}

// Get a random colour.
function getRandomColor() {
    var letters = '0123456789ABCDEF'.split('');
    var color = '#';
    for (var i = 0; i < 6; i++) {
        color += letters[Math.floor(Math.random() * 16)];
    }
    return color;
}