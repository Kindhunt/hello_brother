shader_type canvas_item;

uniform float pixel_size = 4.0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    vec2 resolution = vec2(textureSize(SCREEN_TEXTURE, 0));
    vec2 uv = SCREEN_UV;

    vec2 pixelated_uv = floor(uv * resolution / pixel_size) * pixel_size / resolution;

    COLOR = texture(SCREEN_TEXTURE, pixelated_uv);
}
