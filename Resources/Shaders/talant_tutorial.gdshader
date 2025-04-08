shader_type canvas_item;

// Центр и размер прозрачной зоны (в UV-координатах 0-1)
uniform vec2 center = vec2(0.5, 0.5);
uniform vec2 size = vec2(0.3, 0.3);
// Ширина градиента (в UV-координатах)
uniform float gradient_width = 0.05;
// Цвет градиента (по умолчанию черный)
uniform vec4 gradient_color = vec4(0.0, 0.0, 0.0, 0.01);

void fragment() {
    vec2 uv = UV;

    // Вычисляем расстояние до границы прозрачной зоны
    vec2 dist_to_edge = abs(uv - center) - size/2.0;
    float max_dist = max(dist_to_edge.x, dist_to_edge.y);

    // Если внутри прозрачной зоны
    if (max_dist < 0.0) {
        COLOR.a = 0.0;
    }
    // Если в зоне градиента
    else if (max_dist < gradient_width) {
        // Интерполируем между прозрачным и основным цветом
        float t = smoothstep(0.0, gradient_width, max_dist);
        COLOR = mix(texture(TEXTURE, UV) * gradient_color, texture(TEXTURE, UV) * COLOR, t);
    }
    // Если вне зоны градиента
    else {
        COLOR = texture(TEXTURE, UV) * COLOR;
    }
}