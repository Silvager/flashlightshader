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
void main() {
    gl_Position = gl_ModelViewProjectionMatrix * (gl_Vertex);
    texCoord = vec2(gl_MultiTexCoord0.x, gl_MultiTexCoord0.y);
    lightCoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    vertexColor = gl_Color;
    vec3 normalizedVertexPos = normalize((gl_Vertex).xyz);
    float distanceToView = length(normalizedVertexPos-playerLookVector);
    vertexDistance = length((gl_ModelViewMatrix * gl_Vertex).xyz);
    flashlightLightStrength = getFlashlightLightStrength(heldBlockLightValue, gl_Vertex.xyz, playerLookVector, vertexDistance);
    moonLighting = getMoonLighting(moonPhase);
}