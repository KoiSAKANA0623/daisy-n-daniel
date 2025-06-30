shader_type canvas_item; // BY WYE, FROM THEIR SMW IN GODOT SERIES.

uniform int block_size = 1;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;

void fragment() {
	if (block_size == 1) {
		discard;
	}

	vec2 block_num = vec2(textureSize(SCREEN_TEXTURE, 0)) / float(block_size);

	vec2 uv = floor(SCREEN_UV * block_num) / block_num;
	COLOR = texture(SCREEN_TEXTURE, uv);
}
