shader_type spatial;

uniform sampler2D molten_texture: filter_linear_mipmap,repeat_enable;
uniform float dissolve_state: hint_range(0.0, 1.0) = 0.0;

float random (vec2 uv) {
	return fract(sin(dot(uv.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

void vertex() {
	float f = random(UV) * 0.9;
	// Called for every vertex the material is visible on.
	VERTEX.y += cos(VERTEX.x * 0.15 + TIME * f * 5.0) * sin(VERTEX.z * 0.35);
}

void fragment() {
	// Called for every pixel the material is visible on.
	METALLIC = 0.9;
	ROUGHNESS = 0.45;
	ALBEDO = texture(molten_texture, UV2 * vec2(1.0, 5.0) + TIME * 0.1).rgb;
	ALPHA = pow(texture(molten_texture, UV2).r, pow(dissolve_state, 3.0) * 10.0);
	ALPHA *= (1.0 - pow(dissolve_state, 6.0));
}
