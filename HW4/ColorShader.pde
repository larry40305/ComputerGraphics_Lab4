public class PhongVertexShader extends VertexShader {
    Vector4[][] main(Object[] attribute, Object[] uniform) {
        Vector3[] aVertexPosition = (Vector3[]) attribute[0];
        Vector3[] aVertexNormal = (Vector3[]) attribute[1];
        Matrix4 MVP = (Matrix4) uniform[0];
        Matrix4 M = (Matrix4) uniform[1];
        Vector4[] gl_Position = new Vector4[3];
        Vector4[] w_position = new Vector4[3];
        Vector4[] w_normal = new Vector4[3];

        for (int i = 0; i < gl_Position.length; i++) {
            gl_Position[i] = MVP.mult(aVertexPosition[i].getVector4(1.0));
            w_position[i] = M.mult(aVertexPosition[i].getVector4(1.0));
            w_normal[i] = M.mult(aVertexNormal[i].getVector4(0.0));
        }

        Vector4[][] result = { gl_Position, w_position, w_normal };

        return result;
    }
}

public class PhongFragmentShader extends FragmentShader {
    Vector4 main(Object[] varying) {
        Vector3 w_position = (Vector3) varying[1];  //world position
        Vector3 w_normal = (Vector3) varying[2];    //法向量
        Vector3 albedo = (Vector3) varying[3];      //反照率(Albedo)
        Vector3 kdksm = (Vector3) varying[4];       //漫反射係數（Kd）、鏡面反射係數（Ks）、高光指數（m）
        Light light = basic_light;                  //光源
        Camera cam = main_camera;                   //主攝影機

        // TODO HW4
        // In this section, we have passed in all the variables you need.
        // Please use these variables to calculate the result of Phong shading
        // for that point and return it to GameObject for rendering

        // 計算環境光
        Vector3 ambient = light.light_color.product(AMBIENT_LIGHT).product(albedo);

        // 計算漫反射光
        Vector3 light_dir = Vector3.sub(light.transform.position, w_position).unit_vector();
        Vector3 diffuse = light.light_color.mult(kdksm.x()).mult(Math.max(Vector3.dot(w_normal.unit_vector(), light_dir), 0.0f));

        // 表面顏色
        Vector3 laId = albedo.product(ambient.add(diffuse));

        // 計算鏡面反射光
        Vector3 viewDir = Vector3.sub(cam.transform.position, w_position).unit_vector();
        Vector3 h = light.transform.position.add(cam.transform.position).unit_vector();
        Vector3 specular = light.light_color.mult(kdksm.y()).mult((float)Math.pow(Math.max(Vector3.dot(h, w_normal.unit_vector()), 0.0), kdksm.z()));

        // 合成光照結果
        Vector3 illuminate = laId.add(specular);

        // return 包含最終顏色和 Alpha 值的 Vector4
        return new Vector4(illuminate.x(), illuminate.y(), illuminate.z(), 1.0);

        
    }
}

public class FlatVertexShader extends VertexShader {
    Vector4[][] main(Object[] attribute, Object[] uniform) {
        Vector3[] aVertexPosition = (Vector3[]) attribute[0];   //頂點位置
        Matrix4 MVP = (Matrix4) uniform[0];
        Matrix4 M = (Matrix4) uniform[1];
        Vector3 centroid = Vector3.add(aVertexPosition[0], aVertexPosition[1]).add(aVertexPosition[2]).dive(3.0f);  //三角形中心
        Vector3 w_centroid = M.mult(centroid.getVector4(1.0f)).xyz();   //轉換到 world space

        //計算三角形法向量
        Vector3 v0 = Vector3.sub(aVertexPosition[1], aVertexPosition[0]);
        Vector3 v1 = Vector3.sub(aVertexPosition[2], aVertexPosition[0]);
        Vector3 faceNormal = Vector3.cross(v0, v1).unit_vector();

        //轉換到world space
        Vector3 w_normal = M.mult(faceNormal.getVector4(0.0f)).xyz().unit_vector();

        //轉換頂點
        Vector4[] gl_Position = new Vector4[aVertexPosition.length];
        for (int i = 0; i < gl_Position.length; i++) {
            gl_Position[i] = MVP.mult(aVertexPosition[i].getVector4(1.0f));
        }

        //回傳頂點、幾何中心、法向量
        Vector4[] centroids = new Vector4[]{w_centroid.getVector4(1.0f), w_centroid.getVector4(1.0f), w_centroid.getVector4(1.0f)};
        Vector4[] normals = new Vector4[]{w_normal.getVector4(0.0f), w_normal.getVector4(0.0f), w_normal.getVector4(0.0f)};
        Vector4[][] result = {gl_Position, centroids, normals};
        return result;

        // TODO HW4
        // Here you have to complete Flat shading.
        // We have instantiated the relevant Material, and you may be missing some
        // variables.
        // Please refer to the templates of Phong Material and Phong Shader to complete
        // this part.

        // Note: Here the first variable must return the position of the vertex.
        // Subsequent variables will be interpolated and passed to the fragment shader.
        // The return value must be a Vector4.

    }
}

public class FlatFragmentShader extends FragmentShader {
    Vector4 main(Object[] varying) {
        // TODO HW4
        // Here you have to complete Flat shading.
        // We have instantiated the relevant Material, and you may be missing some
        // variables.
        // Please refer to the templates of Phong Material and Phong Shader to complete
        // this part.

        // Note : In the fragment shader, the first 'varying' variable must be its
        // screen position.
        // Subsequent variables will be received in order from the vertex shader.
        // Additional variables needed will be passed by the material later.

        Vector3 w_centroid = (Vector3) varying[1];  //幾何中心
        Vector3 normal = (Vector3) varying[2];    //法向量
        Vector3 albedo = (Vector3) varying[3];      //反照率(Albedo)
        Vector3 kdksm = (Vector3) varying[4];       //漫反射係數（Kd）、鏡面反射係數（Ks）、高光指數（m）
        Light light = basic_light;                  //光源
        Camera cam = main_camera;                   //主攝影機

        // 計算環境光
        Vector3 ambient = light.light_color.product(AMBIENT_LIGHT).product(albedo);

        // 計算漫反射光
        Vector3 light_dir = Vector3.sub(light.transform.position, w_centroid).unit_vector();
        Vector3 diffuse = light.light_color.mult(Math.max(Vector3.dot(normal, light_dir), 0.0f)).product(albedo);

        // 合成最終顏色
        Vector3 finalColor = ambient.add(diffuse);

        return new Vector4(finalColor.x(), finalColor.y(), finalColor.z(), 1.0f);
    }
}

public class GouraudVertexShader extends VertexShader {
    Vector4[][] main(Object[] attribute, Object[] uniform) {
        Vector3[] aVertexPosition = (Vector3[]) attribute[0];   //頂點位置
        Vector3[] aVertexNormal = (Vector3[]) attribute[1];     //頂點法線
        Matrix4 MVP = (Matrix4) uniform[0];
        Matrix4 M = (Matrix4) uniform[1];
        Vector3 Ka = (Vector3)uniform[2];                       // 環境光系数
        float Kd = (Float)uniform[3];                           // 漫反射系数
        Vector3 albedo = (Vector3)uniform[4];                   // 反照率
        Light light = basic_light;
        Vector4[] gl_Position = new Vector4[3];
        Vector4[] vertex_color = new Vector4[3];

        for (int i = 0; i < aVertexPosition.length; i++) {
            gl_Position[i] = MVP.mult(aVertexPosition[i].getVector4(1.0));
            Vector3 worldPos = M.mult(aVertexPosition[i].getVector4(1.0)).xyz();
            Vector3 worldNormal = M.mult(aVertexNormal[i].getVector4(0.0)).xyz().unit_vector();

            // 光照計算
            Vector3 ambient = Ka.product(albedo);
            Vector3 light_dir = Vector3.sub(light.transform.position, worldPos).unit_vector();
            float diff = Math.max(Vector3.dot(worldNormal, light_dir), 0.0f);
            Vector3 diffuse = albedo.product(light.light_color).mult(diff * Kd);

            // 將環境光和漫反射光结合
            Vector3 totalLight = ambient.add(diffuse);
            vertex_color[i] = totalLight.getVector4(1.0);
        }

        return new Vector4[][]{gl_Position, vertex_color};

        // TODO HW4
        // Here you have to complete Gouraud shading.
        // We have instantiated the relevant Material, and you may be missing some
        // variables.
        // Please refer to the templates of Phong Material and Phong Shader to complete
        // this part.

        // Note: Here the first variable must return the position of the vertex.
        // Subsequent variables will be interpolated and passed to the fragment shader.
        // The return value must be a Vector4.
    }
}

public class GouraudFragmentShader extends FragmentShader {
    Vector4 main(Object[] varying) {

        // TODO HW4
        // Here you have to complete Gouraud shading.
        // We have instantiated the relevant Material, and you may be missing some
        // variables.
        // Please refer to the templates of Phong Material and Phong Shader to complete
        // this part.

        // Note : In the fragment shader, the first 'varying' variable must be its
        // screen position.
        // Subsequent variables will be received in order from the vertex shader.
        // Additional variables needed will be passed by the material later.

        Vector4 interpolated_color = (Vector4) varying[0];
        return interpolated_color;
    }
}
