#version 330 compatibility

out vec4 vertexColor;
out vec3 viewPos;

void main() {
    gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
    vertexColor = gl_Color;
    viewPos = gl_Vertex.xyz;
}