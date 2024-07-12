shader_type spatial;
render_mode unshaded; // shadow_to_opacity

void fragment() {
	ALBEDO = vec3(1.0, 1.0, 0.0);
	ALPHA = 0.5;
}
