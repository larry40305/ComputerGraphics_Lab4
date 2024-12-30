public class Camera extends GameObject {
    Matrix4 projection = new Matrix4();
    Matrix4 worldView = new Matrix4();
    int wid;
    int hei;
    float near;
    float far;

    Camera() {
        wid = 256;
        hei = 256;
        worldView.makeIdentity();
        projection.makeIdentity();
        transform.position = new Vector3(0, 0, 0);
        name = "Camera";
    }

    Matrix4 inverseProjection() {
        Matrix4 invProjection = Matrix4.Zero();
        float a = projection.m[0];
        float b = projection.m[5];
        float c = projection.m[10];
        float d = projection.m[11];
        float e = projection.m[14];
        invProjection.m[0] = 1.0f / a;
        invProjection.m[5] = 1.0f / b;
        invProjection.m[11] = 1.0f / e;
        invProjection.m[14] = 1.0f / d;
        invProjection.m[15] = -c / (d * e);
        return invProjection;
    }

    Matrix4 Matrix() {
        return projection.mult(worldView);
    }

    void setSize(int w, int h, float n, float f) {
        wid = w;
        hei = h;
        near = n;
        far = f;
        // TODO HW3
        // This function takes four parameters, which are the width of the screen, the
        // height of the screen
        // the near plane and the far plane of the camera.
        // Where GH_FOV has been declared as a global variable.
        // Finally, pass the result into projection matrix.

        /*
        // 計算螢幕比例
        float aspect = (float) wid / hei;
        GH_FOV = tan(GH_FOV/0.5f);

        projection = Matrix4.Identity();
        projection.m[0] = 1.0f / (aspect*GH_FOV); 
        projection.m[5] = 1.0f / GH_FOV;           
        projection.m[10] = -(far + near) / (far - near);
        projection.m[11] = -1.0f;            
        projection.m[14] = -(2.0f * far * near) / (far - near); 
        projection.m[15] = 0.0f;
        */
        float e = 1.0f / tan(GH_FOV * 2*PI / 360.0f);
        float a = float(h) / float(w);
        float d = near - far;

        // Creating the projection matrix for a perspective projection
        projection.makeZero(); // Resetting the projection matrix to zero
        projection.m[0] = 1;
        projection.m[5] = a;
        projection.m[10] = far / -d * (1/e);
        projection.m[11] = (near * far) / d * (1/e);
        projection.m[14] = 1/e;
        projection = Matrix4.Identity();

    }

    void setPositionOrientation(Vector3 pos, float rotX, float rotY) {
        worldView = Matrix4.RotX(rotX).mult(Matrix4.RotY(rotY)).mult(Matrix4.Trans(pos.mult(-1)));
    }

    void setPositionOrientation() {
        worldView = Matrix4.RotX(transform.rotation.x).mult(Matrix4.RotY(transform.rotation.y))
                .mult(Matrix4.Trans(transform.position.mult(-1)));
    }

    void setPositionOrientation(Vector3 pos, Vector3 lookat) {
        // TODO HW3
        // This function takes two parameters, which are the position of the camera and
        // the point the camera is looking at.
        // We uses topVector = (0,1,0) to calculate the eye matrix.
        // Finally, pass the result into worldView matrix.

        worldView = Matrix4.Identity();
        Vector3 topVector = Vector3.UnitY();

        // 計算方向向量
        Vector3 zAxis = Vector3.unit_vector(Vector3.sub(pos, lookat)); // 視圖的 Z 軸方向
        Vector3 xAxis = Vector3.unit_vector(Vector3.cross(topVector, zAxis)); // 視圖的 X 軸方向
        Vector3 yAxis = Vector3.unit_vector(Vector3.cross(zAxis, xAxis)); // 視圖的 Y 軸方向

        worldView.m[0] = xAxis.x;
        worldView.m[1] = yAxis.x;
        worldView.m[2] = -zAxis.x;
        worldView.m[3] = -(xAxis.x * pos.x + yAxis.x * pos.y - zAxis.x * pos.z);

        worldView.m[4] = xAxis.y;
        worldView.m[5] = yAxis.y;
        worldView.m[6] = -zAxis.y;
        worldView.m[7] = -(xAxis.y * pos.x + yAxis.y * pos.y - zAxis.y * pos.z);

        worldView.m[8] = xAxis.z;
        worldView.m[9] = yAxis.z;
        worldView.m[10] = -zAxis.z;
        worldView.m[11] = -(xAxis.z * pos.x + yAxis.z * pos.y - zAxis.z * pos.z);

        worldView.m[12] = 0.0f;
        worldView.m[13] = 0.0f;
        worldView.m[14] = 0.0f;
        worldView.m[15] = 1.0f;
    }
}
