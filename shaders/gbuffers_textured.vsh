#version 330 compatibility
#include "/lib/vsh_fxns.glsl"

out vec2 texCoord;
out vec2 lightCoord;
out vec4 vertexColor;
out float vertexDistance;
out float flashlightLightStrength;
out float moonLighting;
out float fogMult;

uniform int heldBlockLightValue;
uniform vec3 playerLookVector;
uniform int moonPhase;
uniform float far;

void main() {
    gl_Position = gl_ModelViewProjectionMatrix * (gl_Vertex);
    texCoord = vec2(gl_MultiTexCoord0.x, gl_MultiTexCoord0.y);
    lightCoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    vertexColor = gl_Color;
    vertexDistance = length((gl_ModelViewMatrix * gl_Vertex).xyz);
    flashlightLightStrength = getFlashlightLightStrength(heldBlockLightValue, gl_Vertex.xyz, playerLookVector, vertexDistance);
    moonLighting = getMoonLighting(moonPhase);
    fogMult = getFogMult(vertexDistance, far);
}
