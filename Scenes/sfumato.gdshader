shader_type canvas_item;

uniform float blur_strength = 0.1;
uniform float fade_strength = 0.1;

void fragment() {
    vec4 sum = vec4(0.0);
    vec2 size = vec2(textureSize(TEXTURE, 0));
    vec2 uv = UV;
    float total = 0.0;

    // Simple box blur kernel
    for (int x = -2; x <= 2; x++) {
        for (int y = -2; y <= 2; y++) {
            vec2 offset = vec2(float(x), float(y)) * blur_strength / size;
            sum += texture(TEXTURE, uv + offset);
            total += 1.0;
        }
    }

    vec4 blurred = sum / total;

    // Fog-like fade
    float fade = clamp(1.0 - (fade_strength * length(SCREEN_UV - vec2(0.5))), 0.0, 1.0);
    COLOR = mix(blurred, vec4(blurred.rgb, 0.0), 1.0 - fade);
}

void light() {
    vec4 sum = vec4(0.0);
    vec2 size = vec2(textureSize(TEXTURE, 0));
    vec2 uv = UV;
    float total = 0.0;

    // Apply same box blur for light pass
    for (int x = -2; x <= 2; x++) {
        for (int y = -2; y <= 2; y++) {
            vec2 offset = vec2(float(x), float(y)) * blur_strength / size;
            sum += texture(TEXTURE, uv + offset);
            total += 1.0;
        }
    }

    vec4 blurred = sum / total;

    // Apply same fog-like fade for light pass
    float fade = clamp(1.0 - (fade_strength * length(SCREEN_UV - vec2(0.5))), 0.0, 1.0);
    vec4 base_color = mix(blurred, vec4(blurred.rgb, 0.0), 1.0 - fade);

    // Apply light's color and energy
    vec3 light_color = LIGHT_COLOR.rgb * LIGHT_ENERGY;
    LIGHT = vec4(base_color.rgb * light_color * base_color.a, base_color.a);
}