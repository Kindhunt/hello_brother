shader_type sky;

void sky() {
	vec3 col = vec3(0,sin(TIME)*0.05+0.1,sin(TIME)*0.05+0.1);
	COLOR = col;
}
