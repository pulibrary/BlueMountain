// var SERVER = 'http://localhost/loris/'
var SERVER = 'http://libimages.princeton.edu/loris2/'
var INFO = '/info.json'


var height = jQuery(window).height();
var width = jQuery(window).width();

$('#viewer').width( width );
$('#viewer').height( height );
$('#container').width( width );
$('#container').height( height );
$('.toolbar').width( width );

// Read a page's GET URL variables and return them as an associative array.
function getUrlVars() {
  var vars = [], hash;
  var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
  for(var i = 0; i < hashes.length; i++) {
    hash = hashes[i].split('=');
    vars.push(hash[0]);
    vars[hash[0]] = hash[1];
  }
  return vars;
}

var osd_config = {
  id: "viewer",
  prefixUrl: "resources/js/openseadragon/images/",
  preserveViewport: true,
  showNavigator:  false,
  visibilityRatio: 1,
  minZoomLevel: 3,
  minLevel: 3,
  showReferenceStrip:     true,
  referenceStripScroll:   'vertical',

  tileSources: []
}


feedMe = getUrlVars()['feedme'];

if (feedMe) {
  osd_config['tileSources'].push(SERVER + feedMe + INFO);
} else {
  for (c=0; c<PAGES.length; c++) {
    osd_config['tileSources'].push(SERVER + PAGES[c] + INFO);
  }
}

OpenSeadragon(osd_config);
