#version 330 compatibility

in vec2 texCoord;
in vec4 vertexColor;

uniform sampler2D Sampler0;

layout(location = 0) out vec4 pixelColor;

void main() {
    vec4 texColor = texture(Sampler0, texCoord);
    if (texColor.a < 0.1) discard;
    pixelColor = texColor * vertexColor;
}