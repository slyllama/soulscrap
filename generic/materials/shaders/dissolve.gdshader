shader_type canvas_item;

uniform sampler2D dissolve_texture: hint_default_black, repeat_enable;
uniform float dissolve_state: hint_range(0.0, 1.0) = 0.0;
uniform float uv_scale = 4.0;

void fragment() {
	if (dissolve_state > 0.0) {
		float dissolve = texture(dissolve_texture, UV * uv_scale).r;
		float texture_state = pow(dissolve_state, 3.0);
		dissolve = pow(dissolve, texture_state * 10.0);
		COLOR.a *= dissolve;
	}
	COLOR.a *= 1.0 - pow(dissolve_state, 4.0);
}
