shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D gradient_texture: hint_default_white, repeat_disable;
uniform sampler2D paint_texture: hint_default_white, filter_linear_mipmap, repeat_enable;
uniform float alpha = 1.0;
uniform vec2 uv_scale = vec2(4.0, 2.0);
uniform vec3 albedo_color: source_color = vec3(1.0);

void fragment() {
	ALBEDO = albedo_color;
	ALPHA = texture(gradient_texture, UV).r * alpha;
	ALPHA *= texture(paint_texture, UV * uv_scale + TIME * 0.05).r;
	ALPHA *= 2.0;
	ALPHA = clamp(ALPHA, 0.0, 1.0);
}

