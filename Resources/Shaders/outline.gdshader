shader_type canvas_item;

//uniform vec4 outline_color : source_color = vec4(1.0, 0.0, 0.0, 1.0); // Цвет обводки
//uniform float outline_width : hint_range(0, 10) = 2.0; // Толщина обводки
//uniform float outline_smoothness : hint_range(0, 1) = 0.5; // Сила сглаживания
//uniform float top_bound : hint_range(0.0, 1.0) = 0.0; // Верхняя граница (UV.y < top_bound)
//uniform float bottom_bound : hint_range(0.0, 1.0) = 1.0; // Нижняя граница (UV.y > bottom_bound)
//uniform vec4 modulate_color : source_color = vec4(1.0, 1.0, 1.0, 1.0); // Цвет для окрашивания текстуры

void fragment() {
    /*vec4 tex_color = texture(TEXTURE, UV);
    
    // Проверяем, является ли текущий пиксель прозрачным
    if (tex_color.a < 0.1) {
        // Выбираем максимальное значение альфа-канала из соседних пикселей
        float max_alpha = 0.0;
        float total_weight = 0.0;
        
        // Используем фиксированные направления для проверки соседних пикселей
        vec2 offsets[16] = vec2[](
            vec2(-1.0, -1.0), vec2(-1.0, 0.0), vec2(-1.0, 1.0),
            vec2( 0.0, -1.0),                   vec2( 0.0, 1.0),
            vec2( 1.0, -1.0), vec2( 1.0, 0.0), vec2( 1.0, 1.0),
            
            // Дополнительные направления для лучшего сглаживания
            vec2(-1.0, -0.5), vec2(-0.5, -1.0),
            vec2( 1.0, -0.5), vec2( 0.5, -1.0),
            vec2(-1.0,  0.5), vec2(-0.5,  1.0),
            vec2( 1.0,  0.5), vec2( 0.5,  1.0)
        );
        
        for (int i = 0; i < 16; i++) {
            vec2 sample_uv = UV + offsets[i] * TEXTURE_PIXEL_SIZE * outline_width;
            float alpha = texture(TEXTURE, sample_uv).a;
            
            // Веса для сглаживания: чем дальше от центра, тем меньше вес
            float weight = 1.0 - smoothstep(0.0, outline_width * 0.7, length(offsets[i]));
            max_alpha += alpha * weight;
            total_weight += weight;
        }
        
        // Усредненное значение альфа-канала с учетом весов
        max_alpha = (total_weight > 0.0) ? (max_alpha / total_weight) : 0.0;
        
        // Плавное наложение обводки с регулируемой мягкостью
        float outline_strength = smoothstep(0.0, 0.025, max_alpha);
        
        // Отключаем обводку за пределами границ
        if (UV.y < top_bound || UV.y > bottom_bound) {
            outline_strength = 0.0;
        }
        
        // Обводка не зависит от modulate
        COLOR = mix(vec4(0.0), outline_color, outline_strength);
    } else {
        // Применяем modulate_color к RGB текстуры, сохраняя альфа-канал
        COLOR = vec4(tex_color.rgb * modulate_color.rgb, tex_color.a);
    }*/
}