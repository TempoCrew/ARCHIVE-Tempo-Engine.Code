package engine.backend.macro;

#if macro
/**
 * Macros for Flixel Library.
 */
class FlixelMacro
{
	/**
	 * A macro to be called targetting the `FlxBasic` class.
	 * @return An array of fields that the class contains.
	 */
	public static macro function buildFlxBasic():Array<haxe.macro.Expr.Field>
	{
		var fields:Array<haxe.macro.Expr.Field> = haxe.macro.Context.getBuildFields();

		fields = fields.concat([
			{
				name: "zIndex",
				access: [haxe.macro.Expr.Access.APublic],
				kind: haxe.macro.Expr.FieldType.FVar(macro :Int, macro $v{0}),
				pos: haxe.macro.Context.currentPos()
			}
		]);

		return fields;
	}
}
#end
