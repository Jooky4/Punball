shader_type canvas_item;

uniform float lightness : hint_range(0.0, 1.0) = 0.0; // Значение осветления, от 0.0 (без изменений) до 1.0 (полностью белый)

void fragment() {
	COLOR = texture(TEXTURE, UV); // Получаем цвет из текстуры спрайта

	// Создаем белый цвет
	vec4 white_color = vec4(1.0, 1.0, 1.0, COLOR.a);

	// Смешиваем цвет спрайта с белым цветом, используя 'lightness' для управления
	COLOR = mix(COLOR, white_color, lightness);
}