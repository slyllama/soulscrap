shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform sampler2D noise_texture: filter_linear_mipmap, repeat_enable;
uniform sampler2D gradient_mask: filter_linear_mipmap;

float fresnel(float amount, vec3 normal, vec3 view) {
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0)), amount);
}

void fragment() {
	float wobble = texture(noise_texture, UV * 0.3 + TIME * 0.1).r;
	float f = fresnel(1.0, NORMAL, VIEW);
	ALBEDO = mix(
		texture(SCREEN_TEXTURE, SCREEN_UV).rgb,
		texture(SCREEN_TEXTURE, SCREEN_UV + wobble * 0.12).rgb,
		(1.0 - f) * texture(gradient_mask, UV).r);
}
