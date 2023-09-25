package filter;
import h2d.filter.Shader;
import h3d.shader.ScreenShader;

class ColorMatrixFilter  extends Shader<ColorMatrixShader>
{
	public function new()
	{
		super(new ColorMatrixShader());
		r.r = 1.0;
		g.g = 1.0;
	}
}

class ColorMatrixShader extends ScreenShader
{
	static var SRC = {
		@param var texture : Sampler2D;
		@param var r:Vec4;
		@param var g:Vec4;
		@param var b:Vec4;
		@param var a:Vec4;
		@param var t:Vec4;
		
		function fragment() 
		{
			var value = _fmod(fragCoord.x + fragCoord.y, thickness);
			value /= thickness;
			value = abs(value - 0.5) * 2;
			
			var result = if (value <= rate)
			{
				var color = texture.get(input.uv);
				vec4(
					stripColor.r * color.a,
					stripColor.g * color.a,
					stripColor.b * color.a,
					color.a
				);
			}
			else
			{
				vec4(0, 0, 0, 0);
			}
			
			var color = texture.get(input.uv);
			var rev = 1 - color.a;
			output.color = vec4(
				sourceImage * (1 - result.a) * color.r + color.a * result.a * result.r,
				sourceImage * (1 - result.a) * color.g + color.a * result.a * result.g,
				sourceImage * (1 - result.a) * color.b + color.a * result.a * result.b,
				sourceImage * (1 - result.a) * color.a + color.a * result.a
			);
		}
		
		function _fmod(x:Float, y:Float):Float
		{
			return x - y * floor(x / y);
		}
	}
}