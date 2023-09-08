'use strict';

// Glide slider

import Glide from '@glidejs/glide';

var glide = new Glide('#event-partners', {
  type: 'carousel',
  perView: 8,
  startAt: 1,
  autoplay: 2000,
  hoverpause: true,
  peek: 0,
  gap: 0,
  breakpoints: {
    1024: {
      perView: 6
    },
    768: {
      perView: 4
    },
    640: {
      perView: 3
    },
    400: {
      perView: 2
    }
  }
})

glide.mount()