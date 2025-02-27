package engine.ui.debug.charting;

import tempo.types.TempoListData;

class ChartingData
{
	public static var ui_list_data(get, never):Array<List_Data>;

	static function get_ui_list_data():Array<List_Data>
	{
		final v:Array<List_Data> = [
			{
				list: "File",
				data: [
					{
						type: "button",
						name: "new_chart",
						text: "New Chart",
						buttonBind: "CTRL+N"
					},
					{isLine: true},
					{
						type: "button",
						name: "open_chart",
						text: "Open Chart...",
						buttonBind: "CTRL+O"
					},
					{
						type: "arrow", // Well, this hard to coding a recent files for `arrowData`... i will thinking about this   ~mrzk
						name: "open_recent_chart",
						text: "Open Recent...",
						isNotWorking: true
					},
					{isLine: true},
					{
						type: "button",
						name: "save_chart",
						text: "Save Chart",
						buttonBind: "CTRL+S"
					},
					{
						type: "button",
						name: "save_as_chart",
						text: "Save Chart as...",
						buttonBind: "CTRL+SHIFT+S"
					},
					{isLine: true},
					{
						type: "button",
						name: "playtest",
						text: "Play Test",
						buttonBind: "F5"
					},
					{
						type: "button",
						name: "playtest_minimal",
						text: "Play Test (Minimalized)",
						buttonBind: "ESC"
					},
					{isLine: true},
					{
						type: "button",
						name: "import_chart",
						text: "Import...",
						isNotWorking: true
					},
					{
						type: "button",
						name: "export_chart",
						text: "Export...",
						isNotWorking: true
					},
					{isLine: true},
					{
						type: "button",
						name: "exit",
						text: "Exit",
						buttonBind: "CTRL+F4"
					}
				]
			},
			{
				list: "Edit",
				data: [
					{
						type: "button",
						name: "undo",
						text: "Undo",
						buttonBind: "CTRL+Z"
					},
					{
						type: "button",
						name: "redo",
						text: "Redo",
						buttonBind: "CTRL+Y"
					},
					{isLine: true},
					{
						type: "button",
						name: "cut",
						text: "Cut",
						buttonBind: "CTRL+X"
					},
					{
						type: "button",
						name: "copy",
						text: "Copy",
						buttonBind: "CTRL+C"
					},
					{
						type: "button",
						name: "paste",
						text: "Paste",
						buttonBind: "CTRL+V"
					},
					{
						type: "button",
						name: "delete",
						text: "Delete",
						buttonBind: "DELETE"
					},
					{isLine: true},
					{
						type: "button",
						name: "select_all",
						text: "Select All",
						buttonBind: "CTRL+SHIFT+A"
					},
					{
						type: "button",
						name: "select_notes",
						text: "Select Notes",
						buttonBind: "CTRL+SHIFT+N"
					},
					{
						type: "button",
						name: "select_events",
						text: "Select Events",
						buttonBind: "CTRL+SHIFT+E"
					},
					{
						type: "button",
						name: "deselect",
						text: "Deselect",
						buttonBind: "CTRL+SHIFT+D"
					},
					{
						type: "button",
						name: "invert_selection",
						text: "Invert Selection",
						buttonBind: "CTRL+SHIFT+I"
					},
					{isLine: true},
					{
						type: "arrow",
						name: "note_snap",
						text: "Note Snapping",
						arrowData: [
							{
								type: "button",
								name: "increase_snap",
								text: "Increase Snapping",
								buttonBind: "SHIFT+ALT+PLUS"
							},
							{
								type: "button",
								name: "decrease_snap",
								text: "Decrease Snapping",
								buttonBind: "SHIFT+ALT+MINUS"
							}
						]
					},
					{
						type: "arrow",
						name: "live_input",
						text: "Live Input Mode",
						arrowData: [
							{
								type: "radio",
								name: "lim_radio",
								radioValues: ["NONE", "Number Keys", "WASD + Arrows"],
								radioDefaultValue: "NONE"
							}
						]
					},
				]
			},
			{
				list: "Audio",
				data: [
					{
						type: "button",
						name: "play_pause_music",
						text: "Play/Pause",
						buttonBind: "SPACE"
					}
				]
			},
			{
				list: "View",
				data: [
					{
						type: "arrow",
						name: "theme",
						text: "Theme",
						arrowData: [
							{
								type: "radio",
								name: "theme_radio",
								radioValues: ["Default", "Dark", "Light", "V-Slice", "Psych", "Codename", "Sub-Zero", "Legacy"],
								radioDefaultValue: "Default"
							}
						]
					},
					{isLine: true},
					{
						type: 'checkbox',
						name: "downscroll",
						text: "DownScroll",
						isNotWorking: true
					}
				]
			},
			{
				list: "Plugins",
				data: [
					{
						type: "button",
						name: "reset_options",
						text: "Reset Options to Default",
						isNotWorking: true
					}
				]
			},
			{
				list: "Tools",
				data: [
					{
						type: 'checkbox',
						name: "win_metadata",
						text: "Metadata",
						checkboxHideList: true
					},
					{
						type: 'checkbox',
						name: "win_difficulty",
						text: "Difficulty",
						checkboxHideList: true
					},
					{
						type: 'checkbox',
						name: "win_offsets",
						text: "Offsets",
						checkboxHideList: true
					},
					{
						type: 'checkbox',
						name: "win_note-data",
						text: "Note Data",
						checkboxHideList: true
					},
					{
						type: 'checkbox',
						name: "win_event-data",
						text: "Event Data",
						checkboxHideList: true
					},
					{
						type: 'checkbox',
						name: "win_freeplay-prop",
						text: "Freeplay Properties",
						checkboxHideList: true
					},
					{
						type: 'checkbox',
						name: "win_playtest-prop",
						text: "PlayTest Properties",
						checkboxHideList: true
					},
					{isLine: true},
					{
						type: "button",
						name: "win_pos-reset",
						text: "Reset Positions"
					}
				]
			},
			{
				list: "Help",
				data: [
					{
						type: "button",
						name: "welcome_dialog",
						text: "Welcome Dialog",
						isNotWorking: true
					},
					{
						type: "button",
						name: "open_guide",
						text: "User Guide's",
						isNotWorking: true,
						buttonBind: "CTRL+SHIFT+P"
					},
					{
						type: "button",
						name: "open_backups",
						text: "Open Backups Folder..."
					},
					{
						type: "button",
						name: "open_about",
						text: "About..."
					}
				]
			}
		];

		return v;
	}
}
