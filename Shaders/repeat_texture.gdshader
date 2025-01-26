shader_type canvas_item;
void fragment() {
	vec2 uv = vec2(UV.x - (TIME * 2.5), UV.y);
	COLOR.rgba = texture(TEXTURE, uv).rgba;
}
