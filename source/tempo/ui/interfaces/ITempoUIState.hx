package tempo.ui.interfaces;

interface ITempoUIState extends IEventGetter
{
	public function getFocus(value:Bool, thing:ITempoUI):Void;
}
