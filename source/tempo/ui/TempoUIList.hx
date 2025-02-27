package tempo.ui;

import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;

@:access(tempo.ui.TempoUICheckbox)
@:access(tempo.ui.TempoUIArrow)
@:access(tempo.ui.TempoUIButton)
class TempoUIList extends FlxSpriteGroup implements ITempoUI
{
	public var name:String = "ui_list";
	public var broadcastToUI:Bool = true;

	public var globalObjs:Array<FlxSpriteGroup> = [];

	/**
	 * Change this if list do not working.
	 */
	public var working:Bool = true;

	/**
	 * All list data.
	 */
	public var listData(default, set):Null<Array<List_Data>> = null;

	public function new(x:Float, y:Float, data:Array<List_Data>):Void
	{
		super(x, y);

		this.listData = data;
	}

	var curList:Array<List_Type_Data> = null;

	var list_overlapSelectNum:Int = 0;

	var overlapSelectNum:Int = 0;
	var listClicked:Bool = false;
	var selectedListButtonNum:Int = 0;
	var buttonOverlapCount:Int = 0;
	var listOverlapCount:Int = 0;
	var ghostOverlapNum:Int = 0;
	var ghostOverlapCount:Int = 0;
	var curCamera:FlxCamera;
	var grpListOverlaped:Bool = false;

	final LEBOOL_TRUE:Bool = true;

	override function update(elapsed:Float):Void
	{
		curCamera = this.cameras[this.cameras.length - 1];

		if (working)
		{
			for (i in 0...buttonsGrps.length)
			{
				var overlaped:Bool = TempoInput.cursorOverlaps(buttonsGrps[i].members[0], curCamera);

				if (!listClicked)
				{
					var button = buttonsGrps[i].members[0];

					if (overlaped)
					{
						button.alpha = .6;
						overlapSelectNum = i;

						if (TempoInput.cursorJustPressed)
						{
							selectedListButtonNum = i;
							listClicked = true;
						}
					}
					else
						button.alpha = .0;
				}
				else
				{
					if (overlaped)
					{
						buttonsGrps[selectedListButtonNum].members[0].alpha = .0;
						listObjsGrps[selectedListButtonNum].visible = false;

						for (dat => grp in arrowListObjsGrps)
							grp.visible = false;

						overlapSelectNum = selectedListButtonNum = i;

						buttonsGrps[selectedListButtonNum].members[0].alpha = 1.0;
						listObjsGrps[selectedListButtonNum].visible = true;

						if (TempoInput.cursorJustPressed)
						{
							listObjsGrps[selectedListButtonNum].visible = false;
							for (dat => grp in arrowListObjsGrps)
								grp.visible = false;
							listClicked = false;
							listOverlapCount = 0;
						}
					}

					final curListButton = buttonsGrps[selectedListButtonNum].members[0];
					final curListGrp = listObjsGrps[selectedListButtonNum];

					if (!TempoInput.cursorOverlaps(curListButton, curCamera)
						&& !TempoInput.cursorOverlaps(curListGrp, curCamera)
						&& !grpListOverlaped
						&& TempoInput.cursorJustPressed)
					{
						buttonsGrps[selectedListButtonNum].members[0].alpha = .0;
						listObjsGrps[selectedListButtonNum].visible = false;

						for (dat => grp in arrowListObjsGrps)
							grp.visible = false;

						listOverlapCount = 0;
						listClicked = false;
					}

					/*
						if (!TempoInput.cursorOverlaps(buttonsGrps[selectedListButtonNum].members[0], curCamera)
						  && !TempoInput.cursorOverlaps(listObjsGrps[selectedListButtonNum], curCamera)
						  && (arrowListObjsGrps.get(curList).visible ? !TempoInput.cursorOverlaps(arrowListObjsGrps.get(curList), curCamera) : LEBOOL_TRUE)
						  && TempoInput.cursorJustPressed)
						{
						  buttonsGrps[selectedListButtonNum].members[0].alpha = .0;
						  listObjsGrps[selectedListButtonNum].visible = false;

						  for (dat => grp in arrowListObjsGrps)
							grp.visible = false;

						  listOverlapCount = 0;
						  listClicked = false;
					}*/
					/*
						for (i in 0...listObjsGrps[selectedListButtonNum].members.length)
						{
						  if (TempoInput.cursorOverlaps(listObjsGrps[selectedListButtonNum].members[i], curCamera)
							&& ghostOverlapCount < 1)
						  {
							ghostOverlapCount = 0;

							if ((listObjsGrps[selectedListButtonNum].members[i] is TempoUIArrow))
							{
							  trace('is arrow');
							}
							else
							  trace('is lol');

							ghostOverlapCount++;
						  }
						  else if (!TempoInput.cursorOverlaps(listObjsGrps[selectedListButtonNum].members[i], curCamera)
							&& ghostOverlapCount == 1)
						  {
							ghostOverlapCount = 0;
						  }
					}*/
				}
			}

			updateButtonCursorTexture();
		}

		super.update(elapsed);
	}

	public var buttonsGrps:Array<FlxTypedSpriteGroup<TempoSprite>> = [];
	public var buttonTextsGrps:Array<FlxTypedSpriteGroup<FlxText>> = [];

	public var listObjsGrps:Array<FlxSpriteGroup> = [];
	public var arrowListObjsGrps:Map<Array<List_Type_Data>, FlxSpriteGroup> = [];
	public var arrowObjParent:Array<TempoUIArrow> = [];

	public var overlaped:Bool = false;

	private var listObjPusher:Array<FlxSpriteGroup> = [];
	private var parentListGrp:FlxSpriteGroup;

	private var arrowTimer:FlxTimer;

	function loadList(listNum:Int):Void
	{
		var buttonsGrp:FlxTypedSpriteGroup<TempoSprite> = new FlxTypedSpriteGroup<TempoSprite>();
		var buttonTextsGrp:FlxTypedSpriteGroup<FlxText> = new FlxTypedSpriteGroup<FlxText>();
		add(buttonsGrp);
		add(buttonTextsGrp);

		buttonsGrps.push(buttonsGrp);
		buttonTextsGrps.push(buttonTextsGrp);

		var curListData:List_Data = listData[listNum];

		final parentX:Float = (buttonsGrps[listNum - 1] != null ? buttonsGrps[listNum - 1].x + buttonsGrps[listNum - 1].members[0].width : 0);
		buttonsGrp.x = parentX;

		var button:TempoSprite = new TempoSprite(5);
		button.scrollFactor.set();
		button.updateHitbox();

		var buttonText:FlxText = new FlxText(parentX + 2.5, button.y + 2.5, 100, listData[listNum].list, 16);
		buttonText.setFormat(TempoUIConstants.FONT, 16, TempoUIConstants.COLOR_BASE_TEXT, LEFT, OUTLINE);
		buttonText.scrollFactor.set();
		buttonText.updateHitbox();

		final rndData:TempoSolidColor = {
			width: buttonText.textField.textWidth + 10,
			height: buttonText.textField.textHeight + 5,
			color: TempoUIConstants.COLOR_LIST_BG,
			roundRect: {elWidth: 10, elHeight: 10}
		};
		button.makeRoundRect(rndData);
		button.alpha = .0;

		buttonsGrp.add(button);
		buttonTextsGrp.add(buttonText);

		var listObjsGrp:FlxSpriteGroup = new FlxSpriteGroup();
		listObjsGrp.visible = false;
		add(listObjsGrp);

		var uiButtons:Array<TempoUIButton> = [];
		var uiArrows:Array<TempoUIArrow> = [];
		var uiCheckbox:Array<TempoUICheckbox> = [];
		var uiRadios:Array<TempoUIRadio> = [];

		listObjsGrps.push(listObjsGrp);

		var listBG:TempoSprite = new TempoSprite(button.x - 5, (button.y + button.height) - 5);
		listObjsGrp.add(listBG);

		var sprYMult:Float = 0;
		var curSprHeight:Float = 0;

		var listWidth:Float = 0;
		var listHeight:Float = 0;

		if (!curListData.data[0].isLine || curListData.data[0].isLine == null)
		{
			switch (curListData.data[0].type)
			{
				case CHECKBOX:
					var obj:TempoUICheckbox = new TempoUICheckbox(0, 0, 'test', false, true);
					obj.visible = false;
					curSprHeight = obj.bg.height;
					obj.kill();
					obj.destroy();

				case RADIO:
					var obj:TempoUIRadio = new TempoUIRadio(0, 0, curListData.data[0].radioValues, curListData.data[0].radioDefaultValue);
					obj.visible = false;
					curSprHeight = obj.bgHeight;
					obj.kill();
					obj.destroy();
					trace('rad');

				default:
					var obj:TempoUIButton = new TempoUIButton(0, 0, 'test', 0, 0);
					obj.visible = false;
					curSprHeight = obj.bg.height;
					obj.kill();
					obj.destroy();
			}
		}

		for (data in curListData.data)
		{
			if (data.isLine)
			{
				sprYMult += .125;
				listHeight += .125;
			}
			else if (!data.isLine || data.isLine == null)
			{
				switch (data.type)
				{
					case CHECKBOX:
						var obj:TempoUICheckbox = new TempoUICheckbox(listBG.x - 2.5, listBG.y - 2.5, data.text, data.checkboxDefaultValue, true);
						obj.scrollFactor.set();
						obj.y += (sprYMult * (curSprHeight));
						obj.working = (data.isNotWorking != null ? !data.isNotWorking : true);
						obj.visible = false;
						uiCheckbox.push(obj);
						listObjsGrp.add(obj);

						curSprHeight = obj.bg.height;

						if (obj.bg.width > listWidth)
							listWidth = obj.bg.width;
						listHeight += curSprHeight + 1.25;

						sprYMult += 1;

					case ARROW:
						var obj:TempoUIArrow = new TempoUIArrow(listBG.x - 2.5, listBG.y - 2.5, data.text, 0, 0);
						obj.listData = data.arrowData;
						obj.scrollFactor.set();
						obj.y += (sprYMult * (curSprHeight));
						obj.working = (data.isNotWorking != null ? !data.isNotWorking : true);
						obj.visible = false;
						uiArrows.push(obj);
						listObjsGrp.add(obj);

						curSprHeight = obj.bg.height;

						if ((obj.bg.width - 2.5) > listWidth)
							listWidth = (obj.bg.width - 2.5);
						listHeight += curSprHeight + 1.5;

						sprYMult += 1;

					case RADIO:
						var obj:TempoUIRadio = new TempoUIRadio(listBG.x - 2.5, listBG.y - 2.5, data.radioValues, data.radioDefaultValue);
						obj.scrollFactor.set();
						obj.y += (sprYMult * curSprHeight);
						obj.visible = false;
						uiRadios.push(obj);
						listObjsGrp.add(obj);
						trace('rer');

						curSprHeight = obj.bgHeight;

						if (obj.bgWidth > listWidth)
							listWidth = (obj.bgWidth);
						listHeight += curSprHeight;

						sprYMult += 1;

					default:
						var obj:TempoUIButton = new TempoUIButton(listBG.x - 2.5, listBG.y - 2.5, data.text, 0, 0, null, data.buttonBind);
						obj.scrollFactor.set();
						obj.y += (sprYMult * (curSprHeight));
						obj.working = (data.isNotWorking != null ? !data.isNotWorking : true);
						obj.visible = false;
						uiButtons.push(obj);
						listObjsGrp.add(obj);

						curSprHeight = obj.bg.height;

						if ((obj.bg.width - 2.5) > listWidth)
							listWidth = (obj.bg.width - 2.5);
						listHeight += curSprHeight + 1.5;

						sprYMult += 1;
				}
			}
		}

		listHeight += 1.75;

		for (uiButt in uiButtons)
		{
			uiButt.changeBGSize(listWidth);

			uiButt.onOverlap = (b:TempoUIButton) ->
			{
				grpListOverlaped = false;

				if (arrowTimer != null)
					arrowTimer.cancel();

				arrowTimer = new FlxTimer().start(0.2, (t:FlxTimer) ->
				{
					t = null;

					for (dat => grp in arrowListObjsGrps)
					{
						grp.visible = false;
					}
				});
			};

			uiButt.onCallback = (b:TempoUIButton) ->
			{
				for (dat => grp in arrowListObjsGrps)
				{
					grp.visible = false;
				}
			};

			if (uiButt.bindText != null)
				uiButt.reloadBindText(uiButt.bindText.text);
		}

		for (uiArrow in uiArrows)
		{
			uiArrow._addTimers.push(arrowTimer);

			uiArrow.changeBGSize(listWidth);

			if (uiArrow.listData == null)
				trace('lol');
			else
			{
				trace('lol');
				var arrowListGrp:FlxSpriteGroup = new FlxSpriteGroup(uiArrow.x + uiArrow.width, uiArrow.y);
				arrowListGrp.x -= 5;
				arrowListGrp.y -= 2.5;
				arrowListGrp.visible = false;
				add(arrowListGrp);

				var ar_uiButtons:Array<TempoUIButton> = [];
				var ar_uiArrows:Array<TempoUIArrow> = [];
				var ar_uiCheckbox:Array<TempoUICheckbox> = [];
				var ar_uiRadios:Array<TempoUIRadio> = [];

				arrowListObjsGrps.set(uiArrow.listData, arrowListGrp);

				var arrowListBG:TempoSprite = new TempoSprite();
				arrowListGrp.add(arrowListBG);

				var ar_sprYMult:Float = 0;
				var ar_curSprHeight:Float = 0;

				var ar_listWidth:Float = 0;
				var ar_listHeight:Float = 0;

				if (!uiArrow.listData[0].isLine || uiArrow.listData[0].isLine == null)
				{
					switch (uiArrow.listData[0].type)
					{
						case CHECKBOX:
							var obj:TempoUICheckbox = new TempoUICheckbox(0, 0, 'test', false, true);
							obj.visible = false;
							ar_curSprHeight = obj.bg.height;
							obj.kill();
							obj.destroy();
							trace('lol');

						case RADIO:
							var obj:TempoUIRadio = new TempoUIRadio(0, 0, uiArrow.listData[0].radioValues, uiArrow.listData[0].radioDefaultValue);
							obj.visible = false;
							ar_curSprHeight = obj.bgHeight;
							obj.kill();
							obj.destroy();
							trace('rad');

						default:
							var obj:TempoUIButton = new TempoUIButton(0, 0, 'test', 0, 0);
							obj.visible = false;
							ar_curSprHeight = obj.bg.height;
							obj.kill();
							obj.destroy();
							trace('lol');
					}
				}
				trace('lol');

				for (data in uiArrow.listData)
				{
					if (data.isLine)
					{
						ar_sprYMult += .125;
						ar_listHeight += .125;
					}
					else if (!data.isLine || data.isLine == null)
					{
						switch (data.type)
						{
							case CHECKBOX:
								var obj:TempoUICheckbox = new TempoUICheckbox(arrowListBG.x - 2.5, arrowListBG.y - 2.5, data.text, data.checkboxDefaultValue,
									true);
								obj.scrollFactor.set();
								obj.y += (ar_sprYMult * (ar_curSprHeight));
								obj.visible = false;
								ar_uiCheckbox.push(obj);
								arrowListGrp.add(obj);
								trace('lol');

								ar_curSprHeight = obj.bg.height;

								if (obj.bg.width > ar_listWidth)
									ar_listWidth = obj.bg.width;
								ar_listHeight += ar_curSprHeight + 1.25;

								ar_sprYMult += 1;

							case ARROW:
								var obj:TempoUIArrow = new TempoUIArrow(2.5, 2.5, data.text, 0, 0);
								obj.listData = data.arrowData;
								obj.scrollFactor.set();
								obj.y += (ar_sprYMult * (ar_curSprHeight));
								obj.visible = false;
								ar_uiArrows.push(obj);
								arrowListGrp.add(obj);
								trace('lol');

								ar_curSprHeight = obj.bg.height;

								if ((obj.bg.width - 2.5) > ar_listWidth)
									ar_listWidth = (obj.bg.width - 2.5);
								ar_listHeight += ar_curSprHeight + 1.5;

								ar_sprYMult += 1;

							case RADIO:
								var obj:TempoUIRadio = new TempoUIRadio(2.5, 2.5, data.radioValues, data.radioDefaultValue);
								obj.scrollFactor.set();
								obj.y += (ar_sprYMult * ar_curSprHeight);
								obj.visible = false;
								ar_uiRadios.push(obj);
								arrowListGrp.add(obj);
								trace('rer');

								ar_curSprHeight = obj.bgHeight;

								if (obj.bgWidth > ar_listWidth)
									ar_listWidth = (obj.bgWidth);
								ar_listHeight += ar_curSprHeight;

								ar_sprYMult += 1;

							default:
								var obj:TempoUIButton = new TempoUIButton(2.5, 2.5, data.text, 0, 0, null, data.buttonBind);
								obj.scrollFactor.set();
								obj.y += (ar_sprYMult * (ar_curSprHeight));
								obj.visible = false;
								ar_uiButtons.push(obj);
								arrowListGrp.add(obj);
								trace('lol');

								ar_curSprHeight = obj.bg.height;

								if ((obj.bg.width - 2.5) > ar_listWidth)
									ar_listWidth = (obj.bg.width - 2.5);
								ar_listHeight += ar_curSprHeight + 1.5;

								ar_sprYMult += 1;
						}
					}
				}

				ar_listHeight += 1.75;

				for (uiButt in ar_uiButtons)
				{
					uiButt.changeBGSize(ar_listWidth);

					if (uiButt.bindText != null)
						uiButt.reloadBindText(uiButt.bindText.text);
				}
				trace('lol');

				for (uiChck in ar_uiCheckbox)
					uiChck.changeBGSize(ar_listWidth);

				arrowListBG.makeRoundRect({
					width: ar_listWidth + 5,
					height: ar_listHeight,
					color: TempoUIConstants.COLOR_LIST_BG,
					roundRect: {elWidth: 10, elHeight: 10}
				});
				arrowListBG.scrollFactor.set();
			}

			uiArrow.onOverlap = (arw:TempoUIArrow) ->
			{
				for (dat => grp in arrowListObjsGrps)
				{
					// old shitty arrow-list remove
					grp.visible = false;

					if (dat == arw.listData)
					{
						grp.visible = true;
						curList = arw.listData;

						parentListGrp = grp;
					}
				}

				grpListOverlaped = true;
				trace('lol');
			};
		}

		for (uiChck in uiCheckbox)
		{
			uiChck.onOverlap = (_) ->
			{
				grpListOverlaped = false;

				if (arrowTimer != null)
					arrowTimer.cancel();

				arrowTimer = new FlxTimer().start(0.2, (t:FlxTimer) ->
				{
					t = null;

					for (dat => grp in arrowListObjsGrps)
					{
						grp.visible = false;
					}
				});
			};

			uiChck.onCallback = (b:Bool) ->
			{
				for (dat => grp in arrowListObjsGrps)
				{
					grp.visible = false;
				}
			};

			uiChck.changeBGSize(listWidth);
		}

		listBG.makeRoundRect({
			width: listWidth + 5,
			height: listHeight,
			color: TempoUIConstants.COLOR_LIST_BG,
			roundRect: {elWidth: 10, elHeight: 10}
		});
		listBG.scrollFactor.set();
	}

	function updateButtonCursorTexture()
	{
		if (TempoInput.cursorOverlaps(buttonsGrps[overlapSelectNum], curCamera) && buttonOverlapCount < 1)
		{
			buttonOverlapCount = 0;

			// CoolStuff.cursor(BUTTON);

			buttonOverlapCount++;
		}
		else if (!TempoInput.cursorOverlaps(buttonsGrps[overlapSelectNum], curCamera) && buttonOverlapCount == 1)
		{
			// CoolStuff.cursor(ARROW);

			buttonOverlapCount = 0;
		}
	}

	function set_listData(v:Array<List_Data>):Array<List_Data>
	{
		listData = v;

		for (i in 0...listData.length)
			loadList(i);

		return listData;
	}
}

@:coreType private enum abstract ListStringType from String to String
{
	var CHECKBOX = "checkbox";
	var BUTTON = "button";
	var ARROW = "arrow";
	var RADIO = "radio";
}
