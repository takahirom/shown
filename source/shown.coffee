do (jQuery) ->
    $ = jQuery
    $.fn.shown = ( method ) ->
        #このプラグインで必ず使われるスーパークラス
        class Box
            constructor: (@element) ->
            setPosition : (x,y)->
                @element.css({
                    "transform": "translate3d("+x+"px,"+y+"px,0)",
                    "-moz-transform": "translate3d("+x+"px,"+y+"px,0)",
                    "-o-transform": "translate3d("+x+"px,"+y+"px,0)",
                    "-webkit-transform": "translate3d("+x+"px,"+y+"px,0)",
                    "-ms-transform": "translate3d("+x+"px,"+y+"px,0)",
                    })
            ###
            サブクラスが必ず実装しないといけないスクロールするごとに実行されるメソッド 
            abstractメソッドにしたかったが仕方がわからなかった
            parsentは画面上でどのぐらいの位置にいるか割合
            ###
            calc:(parsent)->

            setAbsolute:->
                @element.css({"position":"absolute"})


        class LeftMoveBox extends Box
            calc:(parsent)->
                if 101 > parsent >-1
                    boxLeft=(parsent*0.01)*$(window).width()+((100-parsent)*0.01)*(0-@element.width())
                    @setPosition(boxLeft,0)

        class RightMoveBox extends Box
            calc:(parsent)->
                if 101 > parsent >-1
                    boxLeft = parsent*0.01*(0-@element.width())+(100-parsent)*0.01*$(window).width()
                    @setPosition(boxLeft,0);
                  
        class FadeInBox extends Box
            @fadeIned = false
            constructor:(element)->
                #element.hide();
                element.css('visibility','hidden')
                super(element)
            calc:(parsent)->
                if 150 > parsent >-30
                    if @fadeIned==false && 100 > parsent
                        @fadeIned=true
                        @element.hide();
                        @element.css('visibility','visible').hide().fadeIn();;
                else 
                    @element.css('visibility','hidden')
                    @fadeIned =false 
                   

        class LeftMoveStopBox extends Box
            calc:(parsent)->
                if 250>parsent>52
                    boxLeft = parsent*0.01*(0-@element.outerWidth())+(100-parsent)*0.01*$(window).width()-@element.outerWidth()/2
                else
                    parsent = 52
                    boxLeft = parsent*0.01*(0-@element.outerWidth())+(100-parsent)*0.01*$(window).width()-@element.outerWidth()/2
                @setPosition(boxLeft,0)
      
        class RightMoveStopBox extends Box
            calc:(parsent)->
                if 250>parsent>52
                    boxLeft = (parsent*0.01)*$(window).width()+((100-parsent)*0.01)*(0-@element.outerWidth())+@element.outerWidth()/2
                else
                    parsent = 52
                    boxLeft = (parsent*0.01)*$(window).width()+((100-parsent)*0.01)*(0-@element.outerWidth())+@element.outerWidth()/2

                @setPosition(boxLeft,0);
      
                
        class FragmentBox extends Box
            constructor: (element,@fragmentGoal) ->
                @startX=element.offset().left
                @startY=element.offset().top
                @xDistance=(@fragmentGoal.offset().left+@fragmentGoal.width()/2-@startX)
                @yDistance=(@fragmentGoal.offset().top+@fragmentGoal.height()/2-@startY)
                @dX=0
                @dY=0
                super(element)
            calc:(parsent)->
                parsent2 = (parsent*0.01)*(parsent*0.01)*100
                if 0>parsent2
                    parsent2 = 0
                    @setPosition(@xDistance*parsent2*0.01,@yDistance*parsent2*0.01)
                else if 50>parsent2>0
                    @setPosition(@xDistance*parsent2*0.01,@yDistance*parsent2*0.01)
                else if 100>parsent2>49
                    parsent2 = 100 - parsent2
                    @setPosition(@xDistance*parsent2*0.01,@yDistance*parsent2*0.01)
                else if parsent2>100
                    parsent2 = 0
                    @setPosition(@xDistance*parsent2*0.01,@yDistance*parsent2*0.01)

        ###
        スクロールとelementを結びつける 
        element($('#test')などのセレクタでとったもの)とsprite(Boxクラスのサブクラスのインスタンス)を別に引数でとっている理由は、
        他のelementの場所に合わせて実行したい場合のため、例えばFragmentクラスの時のため
        ###
        bindScroll=(element,sprite)->
            $(document).bind('touchmove', (e)->
                e.preventDefault() 
                ).bind('iscroll', (e, pos)->
                parsent = (element.offset().top+element.height() / 2 )  *100 / $(window).height()
                sprite.calc parsent
            )
            $(window).scroll((e)->
                parsent = (element.offset().top - $(window).scrollTop()+element.height() / 2 )  *100 / $(window).height()
                sprite.calc parsent
            )
  
        #プラグインで実装されているメソッド一覧
        methods = {
        leftMove :  ->
            sprite=new LeftMoveBox($(this));
            bindScroll this,sprite
        ,
        rightMove :  ->
            sprite=new RightMoveBox($(this));
            bindScroll this,sprite
        ,
        fadeIn :  ->
            sprite=new FadeInBox($(this));
            bindScroll this,sprite
        ,
        leftMoveStop:  ->
            sprite=new LeftMoveStopBox($(this));
            bindScroll this,sprite
        ,
        rightMoveStop:  ->
            sprite=new RightMoveStopBox ($(this));
            bindScroll this,sprite
        ,
        fragment: (fragmentGoal)->
            sprite=new FragmentBox($(this),fragmentGoal)
            bindScroll fragmentGoal,sprite

        }

 
        # jQueryプラグインで使われるメソッド呼び出しのためのロジック
        if  methods[method] 
            return methods[ method ].apply( this, Array.prototype.slice.call( arguments, 1 ))
        else if  typeof method == 'object' || ! method
            return methods.init.apply this, arguments 
        else 
            $.error 'Method ' +  method + ' does not exist on jQuery.tooltip' 

