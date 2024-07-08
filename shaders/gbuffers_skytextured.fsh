#version 330 compatibility

in vec2 texCoord;
in vec4 vertexColor;

// Our new textures!
uniform sampler2D gtexture;

layout(location = 0) out vec4 pixelColor;

void main() {
    vec4 texColor = texture(gtexture, texCoord);
    if (texColor.a < 0.1) discard;
    pixelColor = texColor;
}