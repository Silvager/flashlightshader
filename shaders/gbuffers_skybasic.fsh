#version 330 compatibility

uniform vec3 fogColor;

in vec3 viewPos;
in vec4 vertexColor;

out vec4 fragColor;

void main() {
    // 1. Calculate how far up or down the pixel is on the sky dome
    // Normalizing the direction vector isolates the vertical elevation

    bool isStar = (vertexColor.r > 0.5 && vertexColor.g > 0.5 && vertexColor.b > 0.5);
    vec3 localUp = normalize(viewPos);
    float elevation = localUp.y; 

    float fogMult = smoothstep(1.0, 0.0, elevation);

    // If we are looking below the horizon, make it entirely fog color
    if (elevation < 0.0) {
        fogMult = 1.0;
    }
    if (isStar) {
        fogMult = 0.0;
    }

    // 3. Linearly interpolate between the vanilla sky gradient and the fog color
    vec3 finalSky = mix(vertexColor.rgb, fogColor, fogMult);
    fragColor = vec4(finalSky, vertexColor.a);
    
}