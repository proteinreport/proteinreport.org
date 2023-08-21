import GLightbox from 'glightbox';

const lightbox = GLightbox({
    loop: true
});
lightbox.on('open', (target) => {
    console.log('lightbox opened');
});
var lightboxDescription = GLightbox({
    selector: '.glightbox'
});
