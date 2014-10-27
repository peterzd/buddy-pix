class Global
  constructor: ->
    @dropdownNav()
    @imgFill()
    @checkCustomize()
    @selectCtm()

  dropdownNav: ->
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


  imgFill: ->
    $(".img_fill").imgLiquid { fill: true }
    $(".img_set").imgLiquid { fill: false }

  checkCustomize: ->
    $('input[type="checkbox"],input[type="radio"]').iCheck {
      checkboxClass: "icheckbox_square",
      radioClass: "iradio_square",
      increaseArea: '20%'
    }

  selectCtm: ->
    opts = {
      'select': { disable_search_threshold: 5, width: "100%" }
    }
    for selector of opts
      $(selector).chosen(opts[selector])

$(document).on "page:load ready", ->
  new Global()

