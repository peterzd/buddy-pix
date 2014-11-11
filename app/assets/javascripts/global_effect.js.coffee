class Global
  constructor: ->
    @dropdownNav()
    @imgFill()
    @checkCustomize()
    @selectCtm()
    @smoothScroll()
    @optionBtn()
    @wayPoints()

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
        # else if target.length && $(window).width() <= 640
        #   $("html,body").animate {
        #     scrollTop: target.offset().top
        #   }, 1000
        #   return false
        #   // for mobile screens

  optionBtn: ->
    $(".option_drop span").on "click", ->
      $(this).parent().find("ul").slideToggle()

  wayPoints: ->
    $(".wp1").waypoint ->
      $('wp1').addClass "animate fadeInLeft"
    , {
      offset: "75%"
    }
    $(".wp2").waypoint ->
      $('wp2').addClass "animate fadeInUp"
    , {
      offset: "75%"
    }
    $(".wp3").waypoint ->
      $('wp3').addClass "animate fadeInDown"
    , {
      offset: "55%"
    }
    $(".wp4").waypoint ->
      $('wp4').addClass "animate fadeInDown"
    , {
      offset: "75%"
    }
    $(".wp5").waypoint ->
      $('wp5').addClass "animate fadeInUp"
    , {
      offset: "75%"
    }
    $(".wp6").waypoint ->
      $('wp6').addClass "animate fadeInDown"
    , {
      offset: "75%"
    }


$ ->
  alert "good"
  new Global()
# $(document).on "page:load ready", ->
#   alert "good"
#   new Global()


