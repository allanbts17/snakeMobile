shader_type canvas_item;

uniform float time_factor = 1.5;
uniform float amplitud = 0.8;

void vertex(){
	float scale = amplitud * 0.5 + 0.5;
	VERTEX.x *= cos(TIME * time_factor) * (1.0 - scale) + scale;
	VERTEX.y *= cos(TIME * time_factor) * (1.0 - scale) + scale;
}