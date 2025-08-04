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
	
	float fade_distance = length(VERTEX);
	const vec3 magic = vec3(0.06711056, 0.00583715, 52.9829189);
	float fade = clamp(smoothstep(0.5, 0.9, fade_distance), 0.0, 1.0);
	if (fade < 0.001 || fade < fract(magic.z * fract(dot(FRAGCOORD.xy, magic.xy)))) {
		discard;
	}
}
