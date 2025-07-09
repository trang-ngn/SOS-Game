
shader_type canvas_item;

instance uniform bool use_red = false;
uniform float red_intensity : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    if (use_red) {
        // Blend original color with red tint
        vec4 red_tint = vec4(1.0, 0.0, 0.0, 1.0);
        COLOR = mix(tex_color, red_tint, red_intensity);
        COLOR.a = tex_color.a; // Preserve original transparency
    } else {
        COLOR = tex_color;
    }
}
