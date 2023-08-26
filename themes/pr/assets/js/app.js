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

// submit newsletter form without redirect
// adapted from
// https://css-tricks.com/using-netlify-forms-and-netlify-functions-to-build-an-email-sign-up-widget/
const processForm = form => {
  const formData = new FormData(form);
  const email = formData.get('email'); // Assuming your input field has name="email"

  if (!email) {
    form.innerHTML = `<div class="form--error">Please enter your email address.</div>`;
    return;
  }

  fetch('/.netlify/functions/subscribeToMailerLite', {
    method: 'POST',
    body: new URLSearchParams({ email }), // Convert to URLSearchParams
  })
  .then(response => response.json())
  .then(result => {
    if (result.statusCode === 200) {
      form.innerHTML = `<div class="form--success">Almost there! Check your inbox for a confirmation e-mail.</div>`;
    } else {
      form.innerHTML = `<div class="form--error">Error: ${result.message}</div>`;
    }
  })
  .catch(error => {
    form.innerHTML = `<div class="form--error">Error: ${error}</div>`;
  });
}

const emailForm = document.querySelector('.email-form');
if (emailForm) {
  emailForm.addEventListener('submit', e => {
    e.preventDefault();
    processForm(emailForm);
  });
}
