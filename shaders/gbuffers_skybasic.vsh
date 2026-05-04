#version 330 compatibility

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

in vec3 Position;
in vec4 Color;

out vec4 vertexColor;

void main() {
    gl_Position = projectionMatrix * modelViewMatrix * vec4(Position, 1.0);
    vertexColor = Color;
}