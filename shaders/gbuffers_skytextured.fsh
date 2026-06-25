#version 330 compatibility

uniform sampler2D texture;

in vec2 texCoord;
in vec4 vertexColor;

out vec4 fragColor;

void main() {
    vec4 albedo = texture2D(texture, texCoord) * vertexColor;
    
    // Alpha discard to prevent rendering the empty square box around the sun/moon
    if (albedo.a < 0.05) discard; 

    fragColor = albedo;
}