class Global
  constructor: ->
    @dropdownNav()
    @imgFill()
    # @checkCustomize()
    @selectCtm()
    @smoothScroll()
    @optionBtn()

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
    inputList = $("input[type='radio'")
    for i in [inputList.length - 1 .. 0] by -1
      $(inputList[i]).prettyCheckable

    inputcheck = $("input[type='checkbox']")
    for j in [inputcheck.length - 1 .. 0] by -1
      $(inputcheck[j]).prettyCheckable

    $('.prettyradio').on "click", ->
      $('.prettyradio').removeClass 'active'
      if $(this).find('.checked')
        $(this).addClass 'active'
    $('.prettycheckbox').on 'click', ->
      $('.prettycheckbox').removeClass 'active'
      if $(this).find '.checked'
        $(this).toggleClass 'active'

  smoothScroll: ->
    $('a[href*=#]:not([href=#])').on "click", ->
      if location.pathname.replace(/^\//, '') is this.pathname.replace(/^\//, '') && location.hostname is this.hostname
        target = $(this.hash)
        target = target.length ? target : $("[name=#{this.hash.slice(1)}]")
        if target.length && $(window).width() >= 640
          $('html,body').animate {
            scrollTop: target.offset.top + -60
          }, 1000
          return false

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


