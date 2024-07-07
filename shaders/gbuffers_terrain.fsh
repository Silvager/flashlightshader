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
    vec4 unFogColor = commonFsh(texCoord,
    lightCoord,
    vertexColor,
    vertexDistance,
    flashlightLightStrength,
    moonLighting,
    gtexture,
    lightmap,
    nightVision);
    if (vertexDistance > fogStart) {
        float fogValue = vertexDistance < fogEnd ? smoothstep(fogStart, fogEnd, vertexDistance) : 1.0;
        pixelColor = vec4(mix(unFogColor.rgb, fogColor, fogValue), unFogColor.a);
    } else {
        pixelColor = unFogColor;
    }
}
// mix it all into one thing