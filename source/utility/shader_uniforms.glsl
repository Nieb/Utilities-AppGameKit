//
//  AGK built-in GLSL uniforms.
//
uniform mat4 agk_Ortho;         //  A matrix to transform sprites from 2D world space into window space

uniform mat4 agk_World;         //  A matrix to transform 3D object verticies from object space to 3D world space
uniform mat4 agk_View;          //  A matrix to transform from 3D world space to camera space
uniform mat4 agk_Proj;          //  A matrix to transform from camera space to window space

uniform mat4 agk_ViewProj;      //  A combination of the View and Proj matrices, transforms from 3D world space to window space
uniform mat4 agk_WorldViewProj; //  A combination of the World, View, and Proj matrices, transforms from object space to window space

uniform mat3 agk_WorldNormal;   //  A matrix to transform 3D object normals from object space to 3D world space



uniform float agk_invert;       //  -1 if drawing to an image, 1 if drawing to the screen, only needed by quads         also needed for SetRenderToImage()

uniform vec2 agk_resolution;    //  The resolution of the current render target, image or window
uniform float agk_time;         //  The time in seconds, taken from the AGK Timer() command
uniform float agk_sintime;      //  The sine of the time value, equivalent to Sin(Timer()) in AGK

uniform vec3 agk_CameraPos;     //  The world position of the current 3D camera

uniform vec2 agk_spritepos;     //  If the shader is being used to draw a sprite then this is its current position in world coordinates
uniform vec2 agk_spritesize;    //  If the shader is being used to draw a sprite then this is its current size in world coordinates

uniform vec4 agk_MeshDiffuse;   //  The color of the mesh being drawn, set with SetObjectColor
uniform vec4 agk_MeshEmmisive;  //  The emissive color of the mesh being drawn, set with SetObjectColorEmissive
