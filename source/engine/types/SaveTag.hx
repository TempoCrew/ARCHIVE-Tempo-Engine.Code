package engine.types;

enum SaveTag
{
	MAIN;
	OPTIONS;
	FLIXEL;
	INPUT;

	#if FEATURE_GAMEJOLT_CLIENT
	GAMEJOLT;
	#end
}
