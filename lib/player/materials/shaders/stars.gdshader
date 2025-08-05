shader_type spatial;
render_mode unshaded;

uniform sampler2D stars_texture: filter_linear_mipmap, repeat_enable;
uniform sampler2D stars_wobble_texture: filter_linear_mipmap, repeat_enable;
uniform float uv_scale = 2.0;
uniform vec3 fresnel_color: source_color = vec3(1.0);

float fresnel(float amount, vec3 normal, vec3 view) {
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0)), amount);
}

void fragment() {
	float stars_wobble = texture(stars_wobble_texture, UV * 0.5 + TIME * 0.02).r;
	
	ALBEDO = texture(stars_texture, UV * uv_scale + stars_wobble * 0.1).rgb;
	ALBEDO += fresnel(4.0, NORMAL, VIEW) * fresnel_color;
	ALBEDO += vec3(pow(texture(stars_wobble_texture, UV * 0.75 + TIME * 0.04).r, 8.0)) * fresnel_color * 0.2;
	ALBEDO *= 4.0;
	ALBEDO = clamp(ALBEDO, vec3(0), vec3(1.0));
}
