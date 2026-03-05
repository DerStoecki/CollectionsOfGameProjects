shader_type canvas_item;


uniform float radius = 0.6; // wird über Zeit verändert oder per Script gesteuert
uniform vec2 center = vec2(0.5, 0.5); // Mitte der Textur
uniform float edge_softness = 0.05; // für weichere Übergänge
uniform float growth = 0.005;
uniform float pulse_speed = 5.5;

void fragment() {
	float r = radius + growth * sin(TIME * pulse_speed);
	float dist = distance(UV, center);
    float alpha_mask = smoothstep(r - edge_softness, r, dist);
    vec4 tex_color = texture(TEXTURE, UV);
    COLOR = vec4(tex_color.rgb, tex_color.a * alpha_mask);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
