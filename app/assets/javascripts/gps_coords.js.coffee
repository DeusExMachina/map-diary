# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->

  L.mapbox.accessToken = 'pk.eyJ1Ijoic3RlcGhzY2hpZSIsImEiOiJJa3VXWk9NIn0.150AUXe2kLvNeFGsunRabQ';

  mapboxTiles = L.tileLayer('https://{s}.tiles.mapbox.com/v3/stephschie.jmdpk5mm/{z}/{x}/{y}.png', {
      attribution: '<a href="http://www.mapbox.com/about/maps/" target="_blank">Terms &amp; Feedback</a>'
  });

  map = L.map('map').addLayer(mapboxTiles)

  # index action?
  if gon.index? 
    map.setView([gon.first_coord.latitude, gon.first_coord.longitude], 15);

    L.geoJson(JSON.parse(gon.json_all)).addTo(map);

  # show action?
  if gon.show?
    map.setView([gon.lat, gon.lon], 15);

    add_marker(map, gon.when, gon.lat, gon.lon).openPopup();

  if gon.day_overview?
    map.setView([gon.first_coord.latitude, gon.first_coord.longitude], 15);
    L.geoJson(JSON.parse(gon.json_today)).addTo(map);

    $('.datepicker').datepicker({
        format: "dd.mm.yyyy",
        weekStart: 1,
        language: "de",
        todayHighlight: true
    });

    $('#dp').on('changeDate', (e) -> dateChanged2(e.date) );



add_marker = (map, time, lat, lon) ->
  marker = L.marker([lat, lon]).addTo(map);

  popup_html = 'Am: <b>' + time + '</b>' + '<br />' +
               'Koordinaten: ' + lat + ',' + lon  

  marker.bindPopup(popup_html);



get_json = (url) ->
  $.getJSON "#{url}.json"



dateChanged = (ev) ->
  $.ajax("/gps_coords/geojson_of_day", null, null, null).done (gejson) ->
     alert ev
     L.geoJson(JSON.parse(gejson)).addTo(map);


dateChanged2 = (ev) ->
  $.ajax({
    type: 'GET',
    url:'/gps_coords/geojson_of_day',
    data:{ day: ev },
    success: (data) ->
      alert(data);
  });