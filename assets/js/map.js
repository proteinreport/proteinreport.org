// based on code from https://ttntm.me/blog/store-locator-leaflet-hugo/

import 'leaflet';
import 'leaflet.markercluster';
import 'leaflet-gesture-handling';

//const items = $('.dir-item'); // all shops in the list
const items = document.querySelectorAll('.dir-item');
//const item = $('.sItem--offline'); // each shop
const startZoom = 2; //Define zoom level - 13 = default | 19 = max
const startLat = 0;
const startLon = 0;

// initialize map
var map = L.map('map', {gestureHandling: true}).setView([startLat, startLon], startZoom);

// add tile layer
L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 19,
    attribution: '© OpenStreetMap'
}).addTo(map);

// create marker cluster layer
var markers = L.markerClusterGroup();

// iterate directory entries, add markers to map
for(let i = 0; i < items.length; i++) {
  let iLat = items[i].getAttribute('data-lat');
  let iLon = items[i].getAttribute('data-lon');

  if(iLat && iLon) {
    // get popup info
    let name = items[i].getAttribute('data-name');
    let popup_content = items[i].querySelector('.popup-content');
    var customIcon = L.icon({
        iconUrl: items[i].getAttribute('data-logo'),  // Provide the path to your custom icon image
    });
    // let ad = items[i].getAttribute('data-add');
    // let plz = items[i].getAttribute('data-plz');
    // create marker with associated popup
    markers.addLayer(L.marker([iLat,iLon],{ icon: customIcon, key:iLat+'__'+iLon}).bindPopup(popup_content)); // marker added to cluster layer
    // we use an ID made up of iLat and iLon here, so we can find the marker again later
  }
}

// add clustered markers to map
map.addLayer(markers);
