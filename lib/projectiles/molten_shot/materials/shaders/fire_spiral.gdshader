shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D paint_texture: hint_default_white, repeat_enable, filter_linear_mipmap;
uniform sampler2D gradient_texture: hint_default_white, repeat_disable, filter_linear_mipmap;
uniform sampler2D albedo_gradient_texture: hint_default_white, repeat_disable, filter_linear_mipmap;
uniform vec2 uv_scale = vec2(1.0, 1.0);
uniform float exponent: hint_range(0.0, 1.0) = 1.0;

void fragment() {
	ALBEDO = texture(albedo_gradient_texture, UV * uv_scale * vec2(3.0, 1.0)).rgb;

	ALPHA *= texture(paint_texture, UV * uv_scale + TIME * 0.2).r;
	ALPHA *= texture(gradient_texture, UV * uv_scale).r;
	ALPHA = pow(ALPHA, pow(exponent, 3.0) * 9.0 + 2.0) * 2.0;
	ALPHA = clamp(ALPHA * (1.0 - pow(exponent, 4.0)), 0.0, 1.0);
}
