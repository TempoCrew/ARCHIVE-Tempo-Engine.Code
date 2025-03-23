package tempo.ui.interfaces;

interface ITempoUIState
{
	public function getEvent(name:String, sender:ITempoUI):Void;
	public function getFocus(value:Bool, thing:ITempoUI):Void;
}
