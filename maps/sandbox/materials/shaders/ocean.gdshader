shader_type spatial;
render_mode cull_disabled, shadows_disabled;

uniform sampler2D ocean_texture: filter_linear_mipmap, repeat_enable;
uniform sampler2D normal_texture: hint_normal, repeat_enable, filter_linear_mipmap;
uniform float uv_scale = 1.0;

void fragment() {
	// Called for every pixel the material is visible on.
	ALBEDO = texture(ocean_texture, UV * uv_scale + TIME * 0.01).rgb * vec3(0.5);
	NORMAL_MAP = texture(normal_texture, UV * 2.0 - TIME * 0.003).rgb;
	NORMAL_MAP_DEPTH = 4.0;
	ROUGHNESS = 0.2;
	EMISSION = ALBEDO * 0.15;
}
