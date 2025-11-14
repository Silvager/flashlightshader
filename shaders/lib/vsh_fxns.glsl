#include "/lib/settings.glsl"
// Return the "strength" of the flashlight- 0 if not in beam, otherwise smoothstep based on dist
float getFlashlightLightStrength(int heldBlockLightValue, vec3 vertexXYZ, vec3 playerLookVector, float vertexDistance) {
    if (heldBlockLightValue == 0) {
        return(0.0);
    }
    vec3 normalizedVertexPos = normalize(vertexXYZ);
    float distanceToView = length(normalizedVertexPos-playerLookVector);
    if (distanceToView < FLASHLIGHT_BEAM_WIDTH) {
        return(smoothstep(0.0, 1.0, (1.0-(vertexDistance/FLASHLIGHT_DISTANCE))));
    } else {
        return(0.0);
    }
}
// Only in this old version and only for gbuffers_textured
float getFlashlightLightStrengthWithNormalizedVertexPos(int heldBlockLightValue, vec3 normalizedVertexPos, vec3 playerLookVector, float vertexDistance) {
    if (heldBlockLightValue == 0) {
        return(0.0);
    }
    float distanceToView = length(normalizedVertexPos-playerLookVector);
    if (distanceToView < FLASHLIGHT_BEAM_WIDTH) {
        return(smoothstep(0.0, 1.0, (1.0-(vertexDistance/FLASHLIGHT_DISTANCE))));
    } else {
        return(0.0);
    }
}

float getMoonLighting(int moonPhase) {
    int moonBrightness;
    if (moonPhase <= 4) {
        moonBrightness = 4-moonPhase;
    } else {
        moonBrightness = moonPhase-4;
    }
    return(float(moonBrightness)/4.0);
}