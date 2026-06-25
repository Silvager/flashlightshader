#version 330 compatibility

in vec2 texCoord;
in vec2 lightCoord;
in vec4 vertexColor;
in float vertexDistance;
in float fogMult;

uniform sampler2D gtexture;
uniform sampler2D lightmap;
uniform vec3 fogColor;

layout(location = 0) out vec4 pixelColor;

void main() {
    vec4 texColor = texture(gtexture, texCoord);
    if (texColor.a < 0.1) discard;
    vec4 lightColor = texture(lightmap, lightCoord);
    pixelColor = texColor * lightColor * vertexColor;

    if (fogMult == 0) return;
    if (fogMult == 1.0) discard;
    pixelColor = vec4(mix(pixelColor.xyz, fogColor, fogMult), pixelColor.a-fogMult);
}