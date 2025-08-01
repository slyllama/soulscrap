shader_type spatial;
render_mode specular_disabled;

uniform sampler2D albedo_texture: filter_linear_mipmap, repeat_enable;
uniform vec3 albedo_color: source_color = vec3(0.5);
uniform float uv_scale = 1.0;

void fragment() {
	vec3 t = texture(albedo_texture, UV * uv_scale).rgb;
	ALBEDO = t * albedo_color;

	SPECULAR = 0.0;
	METALLIC = 0.0;
	ROUGHNESS = 1.0;
}
