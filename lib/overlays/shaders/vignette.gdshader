shader_type canvas_item;

uniform float vignette_feather: hint_range(0.01, 0.5) = 0.25;
uniform float vignette_midpoint: hint_range(0.0, 1.0) = 0.5;
uniform float vignette_alpha: hint_range(0.0, 1.0) = 0.9;

float circle(vec2 position, float radius, float feather) {
	return smoothstep(radius, radius + feather, length(position - vec2(0.5)));
}

void fragment() {
	float vignette = circle(UV, vignette_midpoint, vignette_feather);
	COLOR = mix(COLOR, vec4(vec3(0.0), 1.0), vignette * vignette_alpha);
}
