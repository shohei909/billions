package filter;
import h2d.filter.Shader;
import h3d.shader.ScreenShader;

class StripFilter extends Shader<StripShader>
{
	public function new()
	{
		super(new StripShader());
	}
}

class StripShader extends ScreenShader
{
	static var SRC = {
		@param var texture : Sampler2D;
		@param var stripColor:Vec3;
		@param var thickness  :Float;
		@param var rate       :Float;
		@param var sourceImage:Float;
		
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
