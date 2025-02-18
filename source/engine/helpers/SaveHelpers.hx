package engine.helpers;

enum SaveTag
{
	MAIN;
	OPTIONS;

	#if FEATURE_GAMEJOLT_CLIENT
	GAMEJOLT;
	#end

	STUFF;
	INPUT;
}
