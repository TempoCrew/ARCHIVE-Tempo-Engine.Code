package tempo.ui;

enum abstract TempoUIEvents(String) from String to String
{
	// Click events
	var CHECKBOX_CLICKING = "checkbox_click";
	var HOVERBUTTON_CLICKING = "hoverbutton_click";
	var BUTTON_CLICKING = "button_click";
	var RADIO_CLICKING = "radio_click";
	var DROPDOWN_CLICKING = "dropdown_click";
	var NUMERIC_CLICKING = "numeric_click";
	var SLIDER_CLICKING = "slider_click";
	var INPUTTEXT_CLICKING = "inputtext_click";
	var WINDOW_CLICKING = "window_click";

	// Hover events
	var CHECKBOX_HOVER = "checkbox_hover";
	var HOVERBUTTON_HOVER = "hoverbutton_hover";
	var BUTTON_HOVER = "button_hover";
	var RADIO_HOVER = "button_hover";
	var DROPDOWN_HOVER = "button_hover";
	var NUMERIC_HOVER = "numeric_hover";
	var SLIDER_HOVER = "slider_hover";
	var INPUTTEXT_HOVER = "inputtext_hover";
	var WINDOW_HOVER = "window_hover";

	// Stuff events
	var CHECKBOX_CHANGE = "checkbox_change";
	var RADIO_CHANGE = "radio_change";
	var DROPDOWN_SCROLLING = "dropdown_scroll";
	var SLIDER_CHANGE = "slider_change";
	var INPUTTEXT_CHANGE = "inputtext_change";
	var WINDOW_POS_CHANGE = "window_pos_change";
	var WINDOW_EXIT = "window_exit";
	var WINDOW_MINIMIZE = "window_minimize";
}
