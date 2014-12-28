class Global
  constructor: ->
    @dropdownNav()
    @imgFill()
    @checkCustomize()
    @selectCtm()
    @smoothScroll()
    @optionBtn()
    @remove_msg()
    @fancy_box()

  dropdownNav: ->
    $('.expand_nav_point').on "click", ->
      if $(window).width() >= 1025
        if $('.expand_nav_point').hasClass "active"
          $('.drop_nav_links').slideUp 0
          $('.expand_nav_point').removeClass "active"
          $('.drop_overlay').remove()
        else
          $('.drop_nav_links').slideDown 0
          $('.expand_nav_point').addClass "active"
          $('body').append '<div class="drop_overlay"></div>'
        $('.drop_overlay').on "mouseover", ->
          $('.drop_nav_links').slideUp 0
          $('.expand_nav_point').removeClass "active"
          $('.drop_overlay').remove
      if $(window).width() < 1025
        $('body').toggleClass 'suffle'
    $(".min_nav_btn").on "click", ->
      if $(window).width() < 480
        $('body').toggleClass "suffle"
    $(window).on "resize", ->
      $('body').removeClass 'suffle'


  imgFill: ->
    $(".img_fill").imgLiquid { fill: true }
    $(".img_set").imgLiquid { fill: false }

  checkCustomize: ->
    inputList = $("input[type='radio']")
    i = inputList.length - 1

    while i >= 0
      $(inputList[i]).prettyCheckable()
      i--
    inputcheck = $("input[type='checkbox']")
    j = inputcheck.length - 1

    while j >= 0
      elem = $(inputcheck[j])
      elem.prettyCheckable()
      if elem.data("invited")
        elem.prettyCheckable "check"
        elem.prettyCheckable "disable"
      j--
    $(".prettyradio").on "click", ->
      $(".prettyradio").removeClass "active"
      $(this).addClass "active"  if $(this).find(".checked")
      return

    $(".prettycheckbox").on "click", ->
      $(this).toggleClass "active"  if $(this).find(".checked")
      return
    elem = click_radio_elem()
    $(elem).click()



  remove_msg: ->
    $(".msg .fa-times").on 'click', ->
      $(this).parents('.msg').remove()
    $('.invite_row .link_btns a.close').on 'click', ->
      $(this).parents('.invite_row').addClass 'decline'

  fancy_box: ->
    $(".fancybox").fancybox()

  smoothScroll: ->
    $("a[href*=#]:not([href=#])").not(".fancybox").click ->
      if location.pathname.replace(/^\//, "") is @pathname.replace(/^\//, "") and location.hostname is @hostname
        target = $(@hash)
        target = (if target.length then target else $("[name=" + @hash.slice(1) + "]"))
        if target.length and $(window).width() >= 640
          $("html,body").animate
            scrollTop: target.offset().top + -60
          , 1000
          return false
      return

  selectCtm: ->
    opts = {
      'select': { disable_search_threshold: 5, width: "100%" }
    }
    for selector of opts
      $(selector).chosen(opts[selector])

  optionBtn: ->
    $(".option_drop span").on "click", ->
      $(this).parent().find("ul").slideToggle()

$(document).on "page:load ready", ->
  new Global()


