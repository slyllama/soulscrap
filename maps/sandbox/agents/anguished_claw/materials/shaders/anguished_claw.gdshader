shader_type spatial;
render_mode unshaded;

uniform sampler2D gradient_texture: hint_default_white, filter_linear_mipmap, repeat_disable;
uniform sampler2D albedo_gradient_texture: hint_default_white, filter_linear_mipmap, repeat_disable;
uniform sampler2D overlay_texture: hint_default_black, filter_linear_mipmap, repeat_enable;

void fragment() {
	ALBEDO = texture(albedo_gradient_texture, UV).rgb;
	ALBEDO = clamp(ALBEDO, vec3(0.0), vec3(1.0));
	ALPHA = texture(gradient_texture, UV).r;
	ALPHA -= 1.0 - texture(overlay_texture, UV2 * vec2(2.0) + TIME * 0.03).r;
	ALPHA = clamp(ALPHA, 0.0, 1.0);
}
