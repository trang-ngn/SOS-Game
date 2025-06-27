shader_type canvas_item;

instance uniform float progress : hint_range(0.0, 1.0) = 0.0;
instance uniform float wiggle_strength : hint_range(0.0,20.0) = 0.0;
uniform float wiggle_speed : hint_range(0.0, 10.0) = 2;
uniform float wiggle_offset = 0.0;

float rand(float seed) {
    return fract(543.2543 * sin(seed * 3525.46 + wiggle_offset));
}

void vertex() {
    float t = TIME * wiggle_speed;
    float moveX = (rand(VERTEX.y + t) - 0.5) * wiggle_strength;
    float moveY = (rand(VERTEX.x + t + 7.7) - 0.5) * wiggle_strength;
    VERTEX.x += moveX;
    VERTEX.y += moveY;
}

void fragment() {
    vec2 uv = UV;
    // bottom-to-top reveal
    if (uv.y < progress) {
        discard;
    }
    COLOR = texture(TEXTURE, uv);
}
