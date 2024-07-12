shader_type spatial;
render_mode shadow_to_opacity, unshaded;

void fragment() {
	ALBEDO = vec3(0.0, 0.0, 0.0);
	ALPHA = 0.0;
}
