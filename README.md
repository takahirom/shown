#shown v0.01
これは表示され、スクロールしていき表示された時に動作するアニメーションを実現するためのjQueryプラグインです。現在スクロール中の横移動、物に集まるアニメーション、フェードイン、右と左から真ん中に寄るエフェクトができます。

動きなどは[jsdo.itのサンプル][http://jsdo.it/takam/20Nw]を見てください。

##使い方
jQueryとbuildフォルダにあるshown.jsを読み込んだあとに以下のようなソースコードでできます。
```　js
$(function(){
	$('#left_move').shown("leftMove");
	$('#right_move').shown("rightMove");
	$('#right_stop').shown("rightMoveStop");
	$('#left_stop').shown("leftMoveStop");
	$('#fade_in').shown("fadeIn");
	$('.fragment').each(function(){
		$(this).shown("fragment",$("#fragment_box"));
	});
});
```
##仕組み
CoffeeScriptを利用しています。ソースコードはsourceフォルダのshown.coffeeにあります。

takam