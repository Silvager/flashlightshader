#version 330 compatibility

out vec2 texCoord;
out vec4 vertexColor;

void main() {
    gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
    texCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;
    vertexColor = gl_Color;
}