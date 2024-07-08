#version 330 compatibility
out vec2 texCoord;
out vec2 lightCoord;
out vec4 vertexColor;
out float vertexDistance;

uniform vec3 cameraPosition;

void main() {
    gl_Position = gl_ModelViewProjectionMatrix * (gl_Vertex);
    texCoord = vec2(gl_MultiTexCoord0.x, gl_MultiTexCoord0.y);
    lightCoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    vertexDistance = length((gl_ModelViewMatrix * gl_Vertex).xyz);
    vertexColor = gl_Color;
}