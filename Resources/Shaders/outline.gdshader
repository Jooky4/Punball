shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1.0, 0.0, 0.0, 1.0); // Цвет обводки
uniform float outline_width : hint_range(0, 10) = 2.0; // Толщина обводки
uniform float outline_smoothness : hint_range(0, 1) = 0.5; // Сила сглаживания

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    
    // Проверяем, является ли текущий пиксель прозрачным
    if (tex_color.a < 0.5) {
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
        float outline_strength = smoothstep(0.0, outline_smoothness, max_alpha);
        COLOR = mix(vec4(0.0), outline_color, outline_strength);
    } else {
        COLOR = tex_color;
    }
}