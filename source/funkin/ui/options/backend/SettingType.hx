package funkin.ui.options.backend;

enum abstract SettingType(String) from String to String
{
	var STR = "_str";
	var BOOL = "_bool";
	var INT = "_int";
	var FLOAT = "_float";
	var PERCENT = "_percent";
}
