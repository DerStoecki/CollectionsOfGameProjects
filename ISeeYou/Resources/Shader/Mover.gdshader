shader_type canvas_item;

uniform float speed = 0.01;
uniform vec2 direction = vec2(1.0, 1.0);
uniform float overallAlphaAddValue = 0.0;

void fragment() {
	float offset = TIME * speed;
	vec2 adaptedUV = UV;
	adaptedUV.x = fract(adaptedUV.x + offset * direction.x);
	adaptedUV.y = fract(adaptedUV.y + offset * direction.y);
	// Called for every pixel the material is visible on.
	vec4 screenColor = texture(TEXTURE, adaptedUV);
	vec4 alphaValue = texture(TEXTURE, UV);
	COLOR = screenColor;
	COLOR.a = screenColor.a - overallAlphaAddValue;
}
