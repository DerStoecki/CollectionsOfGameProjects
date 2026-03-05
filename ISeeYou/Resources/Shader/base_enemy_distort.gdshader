shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform sampler2D distortionTexture;
uniform vec2 scroll = vec2(0.1, 0.1);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 preDistortionUV = UV;
	float x = preDistortionUV.x;
	float y = preDistortionUV.y;
	//preDistortionUV.x -= sin(TIME * 1.5 + y);
	//preDistortionUV.y += sin(TIME * 0.5 + x);
	vec2 distortedUV = SCREEN_UV + texture(distortionTexture, preDistortionUV).r * sin(TIME * 1.1 + y)/5.0 ;
	vec4 screenColor = texture(SCREEN_TEXTURE, distortedUV);
	vec4 original = texture(TEXTURE, UV);
	COLOR = screenColor;
	COLOR.a = original.a;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
