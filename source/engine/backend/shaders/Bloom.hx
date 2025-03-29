package engine.backend.shaders;

class Bloom
{
	public var shader:BloomShader = new BloomShader();
	public var colorRange(default, set):Float = 24.0;

	public function new(colorRange:Float = 24.0):Void
	{
		this.colorRange = colorRange;
	}

	function set_colorRange(v:Float):Float
	{
		colorRange = v;
		shader.colorRange.value = [colorRange];

		return colorRange;
	}
}

class BloomShader extends FlxShader
{
	@:glFragmentSource('
  // From https://www.shadertoy.com/view/lsBfRc
  // Automatically converted with https://github.com/TheLeerName/ShadertoyToFlixel

  #pragma header

  #define iResolution vec3(openfl_TextureSize, 0.)
  #define iChannel0 bitmap
  #define iChannel1 bitmap
  #define texture flixel_texture2D

  // end of ShadertoyToFlixel header

  uniform float colorRange;

  vec3 jodieReinhardTonemap(vec3 c){
    float l = dot(c, vec3(0.2126, 0.7152, 0.0722));
    vec3 tc = c / (c + 1.0);

    return mix(c / (l + 1.0), tc, tc);
  }

  vec3 bloomTile(float lod, vec2 offset, vec2 uv){
    return texture(iChannel1, uv * exp2(-lod) + offset).rgb;
  }

  vec3 getBloom(vec2 uv){
    vec3 blur = vec3(0.0);

    blur = pow(bloomTile(2., vec2(0.0,0.0), uv),vec3(2.2))       	   	+ blur;
    blur = pow(bloomTile(3., vec2(0.3,0.0), uv),vec3(2.2)) * 1.3        + blur;
    blur = pow(bloomTile(4., vec2(0.0,0.3), uv),vec3(2.2)) * 1.6        + blur;
    blur = pow(bloomTile(5., vec2(0.1,0.3), uv),vec3(2.2)) * 1.9 	   	+ blur;
    blur = pow(bloomTile(6., vec2(0.2,0.3), uv),vec3(2.2)) * 2.2 	   	+ blur;

    return blur * colorRange;
  }

  void mainImage( out vec4 fragColor, in vec2 fragCoord )
  {
	  vec2 uv = fragCoord.xy / iResolution.xy;

    vec3 color = pow(texture(iChannel0, uv).rgb * colorRange, vec3(2.2));
    color = pow(color, vec3(2.2));
    color += pow(getBloom(uv), vec3(2.2));
    color = pow(color, vec3(1.0 / 2.2));

    color = jodieReinhardTonemap(color);

	  fragColor = vec4(color, texture(iChannel0, fragCoord / iResolution.xy).a);
  }


  void main() {
	  mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
  }
  ')
	public function new():Void
	{
		super();
	}
}
