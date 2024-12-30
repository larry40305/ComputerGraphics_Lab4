# ComputerGraphics_Lab4

## Barycentric Coordinates
P=αA+βB+γC  
α+β+γ=1  
Compute Barycentric Coordinate and store in alpha, beta, gamma  
Then apply Perspective Correction  

Code:  
![alt text](/Photo/image.png)  

## Phong Shading
### PhongMaterial 
Pass parameters for the PhongVertexShader:  
triangle vertices, normals, and transformation matrices  
  
Pass parameters for the PhongFragmentShader to compute lighting for each pixel:  
Ka(ambient reflectivity), Kd(diffuse reflectivity), Ks(specular reflectivity), m(shininess coefficient), and albedo  
  
Code:  
![alt text](/Photo/image-1.png)  

### PhongVertexShader
Calculate the position in screen space (gl_Position) and the position in world space (w_position)  
Then transform each vertex's normal vector to world space (w_normal)  
  
Code:  
![alt text](/Photo/image-2.png)  

### PhongFragmentShader
Calculate ambient light and diffuse light  
Multiply the albedo by the ambient light and diffuse light to handle the surface color  
Calculate specular light and produce the final lighting result  
  
Code:  
![alt text](/Photo/image-3.png)  

## Flat Shading
### FlatMaterial
Pass parameters for the FlatVertexShader：  
triangle vertices, normals, and transformation matrices  
  
Pass parameters for the FlatFragmentShader:  
Ka(ambient reflectivity), Kd(diffuse reflectivity), Ks(specular reflectivity), m(shininess coefficient), and albedo  
  
Code:  
![alt text](/Photo/image-4.png)  

### FlatVertexShader
Calculate the position in screen space(gl_position), the position of the triangle's center in world space(centroids), and the normal of the entire triangle face in world space(normals)  
  
Code:  
![alt text](/Photo/image-5.png)  

### FlatFragmentShader
Calculate ambient light and diffuse light  
Multiply the albedo by the ambient light and diffuse light to handle the surface color  
Calculate specular light and produce the final lighting result  
  
Code:  
![alt text](/Photo/image-6.png)  

## Gouraud Shading
### GouraudMaterial
Pass parameters for the GouraudVertexShader：  
triangle vertices, normals, transformation matrices, Ka, Kd, and albedo  
  
Pass parameters for the GouraudFragmentShader  
  
Code:  
![alt text](/Photo/image-7.png)  

### GouraudVertexShader
Calculate the position in screen space (gl_Position) and the lighting calculation for the triangle's vertices (vertex_color)  
  
Code:  
![alt text](/Photo/image-8.png)  

### GouraudFragmentShader
Directly use the lighting color calculated in the VertexShader  
Return the interpolated color  
  
Code:  
![alt text](/Photo/image-9.png)  

## Demo
<video controls src="/Photo/Demo.mp4" title="Title"></video>  
  
## Conclusion
I complete all the tasks with ChatGPT.
I use ChatGPT to help me figure out some part of the source code and help me recognize some concept of task.  
I also collect relevant information from the Internet.  
I revise some part of previous Hw3 because the program cannot run correctly.

