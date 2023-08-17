// app.js for concatenation of smaller libraryies
// to reduce http requests of small files
'use strict';

// import core.js
import '@hyas/core/assets/js/core.js';

// swup page transitions
//import Swup from 'swup';
// swup progress plugin
//import SwupProgressPlugin from '@swup/progress-plugin';
// swup head plugin
//import SwupHeadPlugin from '@swup/head-plugin';
// initiate swup
//const swup = new Swup({
 //   plugins: [
     /*   new SwupProgressPlugin({
            className: 'swup-progress-bar',
            transition: 300,
            delay: 0,
            initialValue: 0.25,
            finishAnimation: true
        }), */
 //       new SwupHeadPlugin({
 //           awaitAssets: true
 //       })
 //   ]
 //});

// main navigation 

/* When the user scrolls down, hide the navbar. When the user scrolls up, show the navbar */
var prevScrollpos = window.scrollY;
window.onscroll = function() {
  var currentScrollPos = window.scrollY;
  if (prevScrollpos > currentScrollPos) {
    document.getElementById("navbar").style.top = "0";
  } else {
    document.getElementById("navbar").style.top = "-200px";
  }
  prevScrollpos = currentScrollPos;
}