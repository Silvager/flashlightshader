#include "/lib/settings.glsl"

void makeTexturesBw(inout vec4 newVertexColor, inout vec4 texColor, float percentDarkened) {
    float blackWhiteTexCol = (texColor.r+texColor.g+texColor.b)/3.0 * percentDarkened;
    float blackWhiteVertexCol = (newVertexColor.r+newVertexColor.g+newVertexColor.b)/3.0 * percentDarkened;
    newVertexColor = vec4(((newVertexColor.rgb * (1-percentDarkened))+blackWhiteVertexCol), newVertexColor.a);
    texColor = vec4(((texColor.rgb * (1-percentDarkened))+blackWhiteTexCol), texColor.a);
}
// void makeTexturesBw(inout vec4 newVertexColor, inout vec4 texColor) {
//     float blackWhiteTexCol = (texColor.r+texColor.g+texColor.b)/3.0;
//     float blackWhiteVertexCol = (newVertexColor.r+newVertexColor.g+newVertexColor.b)/3.0;
//     newVertexColor = vec4(blackWhiteVertexCol, blackWhiteVertexCol, blackWhiteVertexCol, newVertexColor.a);
//     texColor = vec4(blackWhiteTexCol, blackWhiteTexCol, blackWhiteTexCol, texColor.a);
// }
vec4 getDarkenedLightColor(vec4 lightColor, float vertexDistance, float moonLighting) {
    float lightBrightness = (lightColor.r+lightColor.g+lightColor.b)/3.0;
    if (lightBrightness < 0.2) { //If in absolute darkness, see zilch
        lightBrightness = 0.0;
    } else if (lightBrightness < 0.5) {
        float darkBrightnessMult = smoothstep(1.0, 0.0, (vertexDistance/(moonLighting*50)));
        float fadeDarknessMult = smoothstep(0.38, 0.5, lightBrightness);
        if (darkBrightnessMult > fadeDarknessMult) {
            lightBrightness *= darkBrightnessMult;
        } else {
            lightBrightness *= fadeDarknessMult;
        }
        

    }
    return(vec4(lightColor.rgb*lightBrightness, 1.0));
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
    
    vec4 newVertexColor = vertexColor;
    // if (flashlightLightStrength == 0.0) {
    //             makeTexturesBw(newVertexColor, texColor);
    //         }
    if (MEGA_DARKNESS_ENABLED == 1) {
        lightColor = getDarkenedLightColor(lightColor, vertexDistance, moonLighting);
    }
    if (flashlightLightStrength > 0.0) {
        vec4 modifiedFlashlightColor = vec4(flashlightColor.rgb*flashlightLightStrength, 0.01);
        if ((lightColor.r + lightColor.g + lightColor.b)/3.0 < 0.4 && MEGA_DARKNESS_ENABLED == 1) {
            modifiedFlashlightColor *= smoothstep(0.0, 1.0, (1.0-(vertexDistance/FLASHLIGHT_DISTANCE)));

        }
    lightColor += modifiedFlashlightColor;
    }
    float lightBrightness = (lightColor.r + lightColor.g + lightColor.b)/3.0;
    if (lightBrightness < 0.4) {
        //0.3 should be 0 0.4 is 1;
        float bwAmount = (lightBrightness * 10)+0.3;
        makeTexturesBw(newVertexColor, texColor, smoothstep(0.4, 0.2, lightBrightness));
        // makeTexturesBw(newVertexColor, texColor, 1.0);
    }
    vec4 unFogColor = texColor * newVertexColor * lightColor;
    if (vertexDistance > fogStart) {
        float fogValue = vertexDistance < fogEnd ? smoothstep(fogStart, fogEnd, vertexDistance) : 1.0;
        return(vec4(mix(unFogColor.rgb, fogColor, fogValue), unFogColor.a));
    } else {
        return(unFogColor);
    }
}