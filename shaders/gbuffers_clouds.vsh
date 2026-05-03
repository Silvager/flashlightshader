#version 330 compatibility
#include "/lib/vsh_fxns.glsl"

out vec2 texCoord;
out vec2 lightCoord;
out vec4 vertexColor;
out float vertexDistance;
out float fogMult;

uniform vec3 cameraPosition;
uniform float far;

void main() {
    gl_Position = gl_ModelViewProjectionMatrix * (gl_Vertex);
    texCoord = vec2(gl_MultiTexCoord0.x, gl_MultiTexCoord0.y);
    lightCoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    vertexDistance = length((gl_ModelViewMatrix * gl_Vertex).xyz);
    vertexColor = gl_Color;
    fogMult = getFogMult(vertexDistance, far);
}