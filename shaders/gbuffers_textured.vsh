#version 330 compatibility
#include "/lib/vsh_fxns.glsl"

out vec2 texCoord;
out vec2 lightCoord;
out vec4 vertexColor;
out float vertexDistance;
out float flashlightLightStrength;
out float moonLighting;
uniform int heldBlockLightValue;
uniform vec3 playerLookVector;
uniform int moonPhase;
//U need this for the old versions
uniform mat4 gbufferModelView;
void main() {
    gl_Position = gl_ModelViewProjectionMatrix * (gl_Vertex);
    texCoord = vec2(gl_MultiTexCoord0.x, gl_MultiTexCoord0.y);
    lightCoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    vertexColor = gl_Color;
    // This stuff here is for the old versions of MC
    // Gets the distance in a different way
    // Also calls getFlashlightLightStrengthWithNormalizedVertexPos which is a special version
    vec3 normalizedVertexPos = normalize((gl_Vertex * gbufferModelView).xyz);
    vertexDistance = length((gl_ModelViewMatrix * (gl_Vertex * gbufferModelView)).xyz);
    flashlightLightStrength = getFlashlightLightStrengthWithNormalizedVertexPos(heldBlockLightValue, normalizedVertexPos, playerLookVector, vertexDistance);
    
    moonLighting = getMoonLighting(moonPhase);
}
