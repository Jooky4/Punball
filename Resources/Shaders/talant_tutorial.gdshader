shader_type canvas_item;

// Центр и размер прозрачной зоны (в UV-координатах 0-1)
uniform vec2 center = vec2(0.5, 0.5);
uniform vec2 size = vec2(0.3, 0.3);

void fragment() {
    vec2 uv = UV;

    // Проверяем, находится ли текущий пиксель внутри зоны
    bool inside =
        uv.x > center.x - size.x/2.0 &&
        uv.x < center.x + size.x/2.0 &&
        uv.y > center.y - size.y/2.0 &&
        uv.y < center.y + size.y/2.0;

    // Делаем пиксель прозрачным внутри зоны
    if (inside) {
        COLOR.a = 0.0;
    } else {
        COLOR = texture(TEXTURE, UV) * COLOR;
    }
}