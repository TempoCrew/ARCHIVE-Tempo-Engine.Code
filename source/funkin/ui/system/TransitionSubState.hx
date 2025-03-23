package funkin.ui.system;

import flixel.util.FlxGradient;

class TransitionSubState extends TempoSubState
{
	var _fadeIn:Null<Bool> = null;
	var _onComplete:Null<Void->Void> = null;
	var _timer:Null<Float> = null;

	public function new(?fadeIn:Bool = true, timer:Float, ?onComplete:Void->Void, ?newCamera:FlxCamera):Void
	{
		super();

		this.camera = (newCamera == null ? cameras[cameras.length - 1] : newCamera);

		_fadeIn = fadeIn;
		_onComplete = onComplete;
		_timer = timer;

		trans();
	}

	function trans():Void
	{
		if (_fadeIn)
		{
			if (_onComplete == null)
			{
				trace('[WARNING] Transition cancelled! onComplete is null!');

				return;
			}

			var blackfuck:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
			blackfuck.antialiasing = Save.optionsData.antialiasing;
			blackfuck.updateHitbox();
			blackfuck.scrollFactor.set();

			var gradient:FlxSprite = FlxGradient.createGradientFlxSprite(FlxG.width, Std.int(FlxG.height / 2), [FlxColor.BLACK, 0x0]);
			gradient.y = -(FlxG.height / 2);
			gradient.antialiasing = Save.optionsData.antialiasing;
			gradient.updateHitbox();
			gradient.scrollFactor.set();

			blackfuck.y = -(FlxG.height + gradient.height);

			FlxTween.tween(blackfuck, {y: 0}, _timer, {ease: FlxEase.quadInOut});
			FlxTween.tween(gradient, {y: FlxG.height}, _timer, {ease: FlxEase.quadInOut});

			new FlxTimer().start(_timer, (_) -> _onComplete());

			add(blackfuck);
			add(gradient);
		}
		else
		{
			var blackfuck:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
			blackfuck.antialiasing = Save.optionsData.antialiasing;
			blackfuck.updateHitbox();
			blackfuck.scrollFactor.set();

			var gradient:FlxSprite = FlxGradient.createGradientFlxSprite(FlxG.width, Std.int(FlxG.height / 2), [0x0, FlxColor.BLACK]);
			gradient.antialiasing = Save.optionsData.antialiasing;
			gradient.updateHitbox();
			gradient.scrollFactor.set();

			gradient.y = blackfuck.y - gradient.height;

			FlxTween.tween(blackfuck, {y: FlxG.height + gradient.height}, _timer, {
				ease: FlxEase.quadInOut,
				onComplete: (_) ->
				{
					blackfuck.kill();
					remove(blackfuck);
					blackfuck.destroy();
				}
			});
			FlxTween.tween(gradient, {y: FlxG.height}, _timer, {
				ease: FlxEase.quadInOut,
				onComplete: (_) ->
				{
					gradient.kill();
					remove(gradient);
					gradient.destroy();
				}
			});

			new FlxTimer().start(_timer, (_) ->
			{
				if (_onComplete != null)
					_onComplete();

				close();
			});

			add(blackfuck);
			add(gradient);
		}
	}
}
