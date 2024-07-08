#version 330 compatibility
#include "/lib/common_fsh.glsl"

in vec2 texCoord;
in vec2 lightCoord;
in vec4 vertexColor;
in float vertexDistance;
in float flashlightLightStrength;
in float moonLighting;

uniform sampler2D gtexture;
uniform sampler2D lightmap;
uniform float nightVision;
uniform float fogStart;
uniform float fogEnd;
uniform vec3 fogColor;

layout(location = 0) out vec4 pixelColor;

void main() {
    pixelColor = commonFsh(texCoord,
    lightCoord,
    vertexColor,
    vertexDistance,
    flashlightLightStrength,
    moonLighting,
    gtexture,
    lightmap,
    nightVision,
    fogStart,
    fogEnd,
    fogColor);
}
// mix it all into one thing