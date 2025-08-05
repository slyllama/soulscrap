shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform sampler2D smoke_effect: filter_nearest, repeat_enable;
uniform sampler2D wobble_pattern: filter_nearest, repeat_enable;

uniform float value: hint_range(0.0, 1.0) = 0.5;
uniform float overall_scale = 1.5;
uniform float time_factor = 0.1;

const vec2 center = vec2(0.5, 0.5);

void fragment() {
	float adj_value = value / 1.2;
	float ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y * 1.5;
	vec2 scaled_uv = (SCREEN_UV - vec2(0.5, 0.0)) / vec2(ratio, 1.0) + vec2(0.5, 0.0);
	float mask = (1.0 - smoothstep(adj_value, adj_value - 0.25, length(UV - center)));
	
	vec2 wobble = texture(wobble_pattern, scaled_uv * 0.2 + TIME * time_factor).rg * 0.3;
	vec3 smoke = texture(smoke_effect, scaled_uv * overall_scale + wobble).rgb;
	
	smoke = smoke * vec3(mask);
	smoke = smoke + vec3(mask) * 0.3 - value * 0.3;
	COLOR.rgba = vec4(vec3(0.0), pow(smoke.r, value * 2.0) * 1.0 - pow(value, 3.0));
}
