dropdown = ->
  $('.expand_nav_point').on "click", ->
    if $(window).width() >= 1025
      $('.drop_nav_links').slideToggle "slow"
      $(".expand_nav_point").toggleClass "active"
    if $(window).width() < 1025
      $('body').toggleClass "suffle"
  $(".min_nav_btn").on "click", ->
    if $(window).width() < 480
      $('body').toggleClass "suffle"
  $(window).on "resize", ->
    $('body').removeClass 'suffle'


$(document).on "page:load ready", ->
  dropdown()

