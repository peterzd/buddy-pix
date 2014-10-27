jQuery(function($) {
    //expand nav suffle
    // $('.expand_nav_point').click(function(){
    //     if($(window).width()>=1025){
    //         $('.drop_nav_links').slideToggle('slow'); 
    //         $('.expand_nav_point').toggleClass('active'); 
    //     }
    //     if($(window).width()<1025){
    //         $('body').toggleClass('suffle'); 
    //     }
    // });
    // //
    // $('.min_nav_btn').click(function(){
    //     if($(window).width()<480){
    //         $('body').toggleClass('suffle'); 
    //     }
    // });
    
    // $(window).resize(function(){
    //     $('body').removeClass('suffle');
    // });
    



        
    //smooth scroll
    $('a[href*=#]:not([href=#])').click(function() {
        if (location.pathname.replace(/^\//, '') == this.pathname.replace(/^\//, '') && location.hostname == this.hostname) {
            var target = $(this.hash);
            target = target.length ? target : $('[name=' + this.hash.slice(1) + ']');
            if (target.length && $(window).width()>=640) {
                $('html,body').animate({
                    scrollTop: target.offset().top + -60
                }, 1000);
                return false;
            }
/*            else if (target.length && $(window).width() < 640) {
                $('html,body').animate({
                    scrollTop: target.offset().top 
                }, 1000);
                return false;
            }*///this codition for mobile screens
        }
    });
    
    //Select Box customization	
    // $('input[type="checkbox"],input[type="radio"]').iCheck({
    //     checkboxClass: 'icheckbox_square',
    //     radioClass: 'iradio_square',
    //     increaseArea: '20%' // optional
    // });
    
    //option click btn
    $('.option_drop span').click(function(){
        $(this).parent().find('ul').slideToggle();
    });
    
    
    //Select Box customization	
    // var config = {
    //   'select'           : {disable_search_threshold: 5, width:"100%"}};
    // for (var selector in config) {
    //   $(selector).chosen(config[selector]);
    // }


    /***************** Waypoints ******************/

    $('.wp1').waypoint(function() {
            $('.wp1').addClass('animated fadeInLeft');
    }, {
            offset: '75%'
    });
    $('.wp2').waypoint(function() {
            $('.wp2').addClass('animated fadeInUp');
    }, {
            offset: '75%'
    });
    $('.wp3').waypoint(function() {
            $('.wp3').addClass('animated fadeInDown');
    }, {
            offset: '55%'
    });
    $('.wp4').waypoint(function() {
            $('.wp4').addClass('animated fadeInDown');
    }, {
            offset: '75%'
    });
    $('.wp5').waypoint(function() {
            $('.wp5').addClass('animated fadeInUp');
    }, {
            offset: '75%'
    });
    $('.wp6').waypoint(function() {
            $('.wp6').addClass('animated fadeInDown');
    }, {
            offset: '75%'
    });
    
    //img liquid
    // $('.img_fill').imgLiquid({fill: true});
    // $('.img_set').imgLiquid({fill:false});


});

