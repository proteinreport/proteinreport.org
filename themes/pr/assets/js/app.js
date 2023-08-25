// app.js for concatenation of smaller libraryies
// to reduce http requests of small files
'use strict';

// import core.js
import '@hyas/core/assets/js/core.js';

import './pace.js';
Pace.start();


// main navigation 

/* When the user scrolls down, hide the navbar. When the user scrolls up, show the navbar */
var prevScrollpos = window.scrollY;
window.onscroll = function() {
  var currentScrollPos = window.scrollY;
  if (currentScrollPos > 200) {
    // && prevScrollpos - currentScrollPos > 5
    if (prevScrollpos > currentScrollPos) {
      document.getElementById("navbar").style.top = "0";
    // else if (currentScrollPos - prevScrollpos > 5)
    } else {
      document.getElementById("navbar").style.top = "-200px";
    }
  } else {
    document.getElementById("navbar").style.top = "0";
  }
  prevScrollpos = currentScrollPos;
}

