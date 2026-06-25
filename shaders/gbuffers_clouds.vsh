#version 330 compatibility
#include "/lib/vsh_fxns.glsl"

out vec2 texCoord;
out vec2 lightCoord;
out vec4 vertexColor;
out float vertexDistance;
out float fogMult;

uniform vec3 cameraPosition;
uniform float far;

float getCloudFogMult(float horizontalVertexDistance, float far) {
    float fogStart = far * 0.6;
    if (horizontalVertexDistance < fogStart) {
        return 0.0;
    }
    if (horizontalVertexDistance > far) {
        return 1.0;
    }
    return smoothstep(fogStart, far, horizontalVertexDistance);
}

void main() {
    gl_Position = gl_ModelViewProjectionMatrix * (gl_Vertex);
    texCoord = vec2(gl_MultiTexCoord0.x, gl_MultiTexCoord0.y);
    lightCoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    vertexDistance = length((gl_ModelViewMatrix * gl_Vertex).xyz);
    float horizontalVertexDistance = length((gl_ModelViewMatrix * gl_Vertex).xz);
    vertexColor = gl_Color;
    fogMult = getCloudFogMult(horizontalVertexDistance, clamp(far*5, 100.0, 1000.0)); // Far has been increased because clouds render farther than blocks
}