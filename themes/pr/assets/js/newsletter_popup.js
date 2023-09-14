console.log("Script is loaded");

// Cookie functions
function setCookie(name, value, days) {
    const date = new Date();
    date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
    document.cookie = name + "=" + value + ";expires=" + date.toUTCString() + ";path=/";
}

function getCookie(name) {
    const value = "; " + document.cookie;
    const parts = value.split("; " + name + "=");
    if (parts.length === 2) return parts.pop().split(";").shift();
}

const popup = document.getElementById('popupFormContainer');
let popupDisplayed = false;

// Process form function (moved from File 1)
const processForm = form => {
    const formData = new FormData(form);
    const email = formData.get('email'); 

    if (!email) {
        form.innerHTML = `<div class="form--error">Please enter your email address.</div>`;
        return;
    }

    fetch('/.netlify/functions/subscribeToMailerLite', {
        method: 'POST',
        body: new URLSearchParams({ email }),
    })
    .then(response => response.json().then(result => ({ status: response.status, result })))
    .then(({ status, result }) => {
        if (status === 200 || status === 201 || status === 202 || status === 204) {
            form.innerHTML = `<div class="form--success">Almost there! Check your inbox for a confirmation e-mail. If you had previously unsubscribed, you've now been resubscribed.</div>`;
        } else {
            form.innerHTML = `<div class="form--error">Error: ${result.message}</div>`;
        }
    })
    .catch(error => {
        form.innerHTML = `<div class="form--error">Error: ${error}</div>`;
    });

    // Moved cookie setting to this location
    setCookie('popupClosedOrSubmitted', 'true', 30);
}

const emailForms = document.querySelectorAll('.email-form');
emailForms.forEach(form => {
    form.addEventListener('submit', e => {
        e.preventDefault();
        processForm(e.target);
    });
});

// Check cookie to determine if popup should be shown
if (!getCookie('popupClosedOrSubmitted')) {
    window.addEventListener('scroll', function() {
        if (popupDisplayed) return;

        const scrollPosition = window.scrollY + window.innerHeight;
        const halfPage = document.documentElement.scrollHeight / 2;

        console.log("Scroll position:", scrollPosition, "Half page:", halfPage);

        if (scrollPosition > halfPage) {
            popup.style.display = 'flex';
            popupDisplayed = true;
        }
    });
}

// Logic to close the popup and set the cookie
document.getElementById('closePopupButton').addEventListener('click', function() {
    popup.style.display = 'none';
    setCookie('popupClosedOrSubmitted', 'true', 30);
});
