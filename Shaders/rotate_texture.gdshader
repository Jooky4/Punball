shader_type canvas_item;

uniform float speed = 2.0;

vec2 rotateUV(vec2 uv, vec2 pivot, float rotation)
{
	mat2 rotation_matrix=mat2(	vec2(sin(rotation),-cos(rotation)),
								vec2(cos(rotation),sin(rotation))
								);
    uv -= pivot;
    uv= uv*rotation_matrix;
    uv += pivot;
    return uv;
}

void vertex() {
	VERTEX = rotateUV(VERTEX, TEXTURE_PIXEL_SIZE, TIME * speed);
}