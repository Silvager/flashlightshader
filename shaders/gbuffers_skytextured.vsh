#version 330 compatibility
out vec2 texCoord;
out vec4 vertexColor;

void main() {
    gl_Position = gl_ModelViewProjectionMatrix * (gl_Vertex);
    texCoord = vec2(gl_MultiTexCoord0.x, gl_MultiTexCoord0.y);
    vertexColor = gl_Color;
}