#version 330 compatibility

uniform vec3 fogColor;
uniform int renderStage;

in vec3 viewPos;
in vec4 vertexColor;

out vec4 fragColor;

void main() {
    // 1. Calculate how far up or down the pixel is on the sky dome
    // Normalizing the direction vector isolates the vertical elevation
    if (renderStage == MC_RENDER_STAGE_STARS) {
        fragColor = vertexColor;
        return;
    }
    vec3 localUp = normalize(viewPos);
    float elevation = localUp.y; 

    float fogMult;

    // If we are looking below the horizon, make it entirely fog color
    if (elevation < 0.0) {
        fogMult = 1.0;
    } else if (elevation > 0.5) {
        fogMult = 0;
    } else {
        fogMult = smoothstep(0.5, 0.0, elevation);
    }
    
    fragColor = vec4(mix(vertexColor.rgb, fogColor, fogMult), vertexColor.a);
    // fragColor = vec4(vertexColor.rgb, 1.0);
    
}