shader_type canvas_item;
instance uniform bool active = true;
uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float outline_width : hint_range(0.0, 10.0) = 1.5;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);

	if(!active) {
		COLOR = tex_color;
	} else {
		vec4 tex_color = texture(TEXTURE, UV);
    float max_alpha = tex_color.a;

    // Check surrounding pixels
    for (float x = -outline_width; x <= outline_width; x++) {
        for (float y = -outline_width; y <= outline_width; y++) {
            vec2 offset = vec2(x, y) * TEXTURE_PIXEL_SIZE;
            max_alpha = max(max_alpha, texture(TEXTURE, UV + offset).a);
        }
    }

    // Mix between outline and original color
    COLOR = mix(outline_color, tex_color, tex_color.a);
    COLOR.a = max(tex_color.a, max_alpha);
	}



}
