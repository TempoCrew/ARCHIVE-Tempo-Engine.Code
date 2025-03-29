package funkin.ui.options.backend;

class Setting
{
	public var name:String = "";
	public var desc:String = "";
	public var rec:String = "";

	public var values(default, null):Dynamic = null;
	public var variable:String = null;
	public var type:SettingType = BOOL;

	// constructor
	public function new() {}

	/**
	 * Creating a new setting for options menu.
	 * @param name Option Name
	 * @param description Options Description (for peeps who want read smth)
	 * @param type Option Type (`BOOL`, `STR`, `INT`, `FLOAT`, `PERCENT`)
	 * @param variable Variable from `
	 */
	public static function get(name:String, description:String = "", recommended:String = "", type:SettingType = BOOL, variable:String,
			?values:Dynamic = null):Setting
	{
		var s:Setting = new Setting();
		s.name = name;
		s.desc = description;
		s.rec = recommended;
		s.type = type;
		s.variable = variable;
		s.values = values;

		return s;
	}

	@:to
	public function toString():String
	{
		return "Name: " + name + " / Desc: " + desc + " / Var: " + (variable == null ? 'N\\A' : variable) + ' / Values: '
			+ (values == null ? "N\\A" : Std.string(values)) + ' / Type: ' + type;
	}
}
