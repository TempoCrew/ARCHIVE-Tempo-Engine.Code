package engine.types;

enum SaveTag
{
	MAIN;
	OPTIONS;
	FLIXEL;
	INPUT;
	EDITOR;

	#if FEATURE_GAMEJOLT_CLIENT
	GAMEJOLT;
	#end
}
