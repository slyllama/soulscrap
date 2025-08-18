shader_type spatial;
render_mode unshaded, blend_mix;

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
	float s = sin(TIME * PI) + 1.0;
	ALPHA = (1.0 - circle(UV, 0.0, 0.5)) * 0.45;
	ALBEDO = vec3(1.0, 1.0, 1.0) * (0.5 + 0.5 * s);
}
