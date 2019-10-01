shader_type canvas_item;

void fragment(){
	COLOR = vec4(UV * SCREEN_UV, 1.0, 0.7);
}