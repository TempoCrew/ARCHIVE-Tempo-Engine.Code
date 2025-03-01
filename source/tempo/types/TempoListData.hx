package tempo.types;

typedef List_Data =
{
	list:String,
	data:Array<List_Type_Data>
}

typedef List_Type_Data =
{
	/**
	 * If buttons list is end, take this for view a line
	 */
	?isLine:Bool,

	/**
	 * Type of button list (arrow, button, slider or checkbox)
	 */
	?type:String,

	/**
	 * Tag for coding
	 */
	?name:String,

	/**
	 * Text for button
	 */
	?text:String,

	/**
	 * If this button not working NOW, take this
	 */
	?isNotWorking:Bool,

	/**
	 * Checkbox default value... yeah
	 */
	?checkboxDefaultValue:Bool,

	/**
	 * When clicking a checkbox, list will hiding or not?
	 */
	?checkboxHideList:Bool,

	/**
	 * Data for arrow hover
	 */
	?arrowData:Array<List_Type_Data>,

	/**
	 * Default bind for button
	 */
	?buttonBind:String,

	/**
	 * If `type` is `RADIO`, this option for values.
	 */
	?radioValues:Array<String>,

	/**
	 * If `type` is `RADIO`, this option doing a default value for first run
	 */
	?radioDefaultValue:String,

	/**
	 * If `type` is `SLIDER`, this option main (minimum value)
	 */
	?sliderMin:Float,

	/**
	 * If `type` is `SLIDER`, this option main (maximum value)
	 */
	?sliderMax:Float,

	/**
	 * If `type` is `SLIDER`, this option main (slider width scale)
	 */
	?sliderWidth:Float,

	/**
	 * If `type` is `SLIDER`, this option main (changed position for list / not change this if you want a default value)
	 */
	?sliderPosition:{x:Float, y:Float}
}
