shader_type spatial;
render_mode unshaded, blend_mix;

uniform sampler2D swirl_texture;

void vertex() {
	// Billboard Mode: Enabled
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
		MAIN_CAM_INV_VIEW_MATRIX[0],
		MAIN_CAM_INV_VIEW_MATRIX[1],
		MAIN_CAM_INV_VIEW_MATRIX[2],
		MODEL_MATRIX[3]);
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
}

float circle(vec2 position, float radius, float feather) {
	return smoothstep(radius, radius + feather, length(position - vec2(0.5)));
}

void fragment() {
	vec2 og_uv = UV;
	og_uv -= vec2(0.5);
	float uv_x = sqrt(dot(og_uv, og_uv)) * 2.0;
	float uv_y = (atan(og_uv.x, og_uv.y) / -3.14) * 0.5 + 0.5;
	vec2 wobble_uv = texture(
		swirl_texture, (vec2(uv_x, uv_y) * 0.5 + vec2(TIME * 0.05))).rg;
	vec3 ripple = texture(swirl_texture, UV * 0.5 + wobble_uv * 0.24).rgb;
	
	float s = sin(TIME * PI) + 1.0;
	ALPHA = (1.0 - circle(UV, 0.0, 0.5)) * (0.7 + 0.3 * s);
	ALBEDO = pow(vec3(ripple), vec3(3.0));
}
