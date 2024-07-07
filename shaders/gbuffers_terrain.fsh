#version 330 compatibility
#include "/lib/common.glsl"

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

void makeTexturesBw(inout vec4 newVertexColor, inout vec4 texColor) {
    float blackWhiteTexCol = (texColor.r+texColor.g+texColor.b)/3.0;
    float blackWhiteVertexCol = (vertexColor.r+vertexColor.g+vertexColor.b)/3.0;
    newVertexColor = vec4(blackWhiteVertexCol, blackWhiteVertexCol, blackWhiteVertexCol, newVertexColor.a);
    texColor = vec4(blackWhiteTexCol, blackWhiteTexCol, blackWhiteTexCol, texColor.a);
}

void main() {
    vec4 texColor = texture(gtexture, texCoord);
    
    if (texColor.a < 0.1) discard;
    vec4 lightColor = texture(lightmap, lightCoord);
    float lightBrightness = (lightColor.r + lightColor.g + lightColor.b)/3.0;
    vec4 newVertexColor = vertexColor;
    if (nightVision > 0.0) {
        makeTexturesBw(newVertexColor, texColor);
        lightColor = vec4(1.0, 1.0, 1.0, 1.0);
        } else if (MEGA_DARKNESS_ENABLED == 1) {
            lightBrightness = lightBrightness + flashlightLightStrength;
            if (lightBrightness < 0.2) { //If in absolute darkness, see zilch
                lightBrightness = 0.0;
            } else if (lightBrightness < 0.4) {
                if (vertexDistance < moonLighting*50.0) {
                    float max_brightness = 0.6 * moonLighting;
                    float distanceAway = (vertexDistance/(moonLighting*50));
                    lightBrightness = max_brightness*(1.0-distanceAway);
                    if (flashlightLightStrength == 0.0) {
                        makeTexturesBw(newVertexColor, texColor);
                    }
                } else {
                    lightBrightness = 0.0;
                }
            lightColor = lightColor*lightBrightness;
        }
    }
    if (flashlightLightStrength != 0.0) {
    vec4 modifiedFlashlightColor = vec4(flashlightColor.rgb*flashlightLightStrength, 1.0);
    lightColor += modifiedFlashlightColor;
    }
    vec4 unFogColor = texColor * newVertexColor * lightColor;
    if (vertexDistance > fogStart) {
        float fogValue = vertexDistance < fogEnd ? smoothstep(fogStart, fogEnd, vertexDistance) : 1.0;
        pixelColor = vec4(mix(unFogColor.rgb, fogColor, fogValue), unFogColor.a);
    } else {
        pixelColor = unFogColor;
    }
}
// mix it all into one thing