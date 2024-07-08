#include "/lib/settings.glsl"

void makeTexturesBw(inout vec4 newVertexColor, inout vec4 texColor) {
    float blackWhiteTexCol = (texColor.r+texColor.g+texColor.b)/3.0;
    float blackWhiteVertexCol = (newVertexColor.r+newVertexColor.g+newVertexColor.b)/3.0;
    newVertexColor = vec4(blackWhiteVertexCol, blackWhiteVertexCol, blackWhiteVertexCol, newVertexColor.a);
    texColor = vec4(blackWhiteTexCol, blackWhiteTexCol, blackWhiteTexCol, texColor.a);
}

vec4 commonFsh(vec2 texCoord, vec2 lightCoord, vec4 vertexColor,
float vertexDistance,
float flashlightLightStrength,
float moonLighting,
sampler2D gtexture,
sampler2D lightmap,
float nightVision,
float fogStart,
float fogEnd,
vec3 fogColor
) {
    vec4 texColor = texture(gtexture, texCoord);
    
    if (texColor.a < 0.1) discard;
    vec4 lightColor = texture(lightmap, lightCoord);
    float lightBrightness = (lightColor.r + lightColor.g + lightColor.b)/3.0;
    vec4 newVertexColor = vertexColor;
    if (nightVision > 0.0) {
        makeTexturesBw(newVertexColor, texColor);
        lightColor = vec4(1.0, 1.0, 1.0, 1.0);
         } else if (flashlightLightStrength > 0.0) {

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
            
        }
        lightColor = lightColor*lightBrightness;
    }
    if (flashlightLightStrength > 0.0) {
    vec4 modifiedFlashlightColor = vec4(flashlightColor.rgb*flashlightLightStrength, 0.0);
    if (lightBrightness < 0.4) {
    lightColor *= smoothstep(0.0, 1.0, (1.0-(vertexDistance/FLASHLIGHT_DISTANCE)));
    }
    lightColor += modifiedFlashlightColor;
    }
    vec4 unFogColor = texColor * newVertexColor * lightColor;
    if (vertexDistance > fogStart) {
        float fogValue = vertexDistance < fogEnd ? smoothstep(fogStart, fogEnd, vertexDistance) : 1.0;
        return(vec4(mix(unFogColor.rgb, fogColor, fogValue), unFogColor.a));
    } else {
        return(unFogColor);
    }
}