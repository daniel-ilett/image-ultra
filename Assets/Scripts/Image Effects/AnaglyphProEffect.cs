using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Image Effects Ultra/Anaglyph 3D Pro", order = 1)]
public class AnaglyphProEffect : BaseEffect
{
    [SerializeField]
    private float strength = 1.0f;

    [SerializeField]
    private float focalDistance = 50.0f;

    [SerializeField]
    private Camera cameraPrefab;

    private Camera camera;

    // Find the Anaglyph shader source.
    public override void OnCreate()
    {
        baseMaterial = new Material(Resources.Load<Shader>("Shaders/Anaglyph3DPro"));

        baseMaterial.SetFloat("_Strength", strength);

        camera = Instantiate(cameraPrefab);
    }

    public override void Render(RenderTexture src, RenderTexture dst)
    {
        // Copy properties.
        camera.CopyFrom(Camera.main);

        var cameraPos = camera.transform.position;
        var cameraRot = camera.transform.rotation;
        var focalPoint = cameraPos + camera.transform.forward * strength;

        // Render camera at pos 1.
        camera.transform.position = cameraPos;
        var leftFocus = cameraPos + camera.transform.forward * focalDistance + camera.transform.right * strength;
        camera.transform.LookAt(leftFocus);
        var leftTexture = RenderTexture.GetTemporary(src.descriptor);
        camera.targetTexture = leftTexture;
        camera.Render();
        baseMaterial.SetTexture("_LeftTex", leftTexture);

        // Render camera at pos 2.
        camera.transform.rotation = cameraRot;
        camera.transform.position = cameraPos + camera.transform.right * strength;
        var rightFocus = cameraPos + camera.transform.forward * focalDistance - camera.transform.right * strength;
        camera.transform.LookAt(rightFocus);
        var rightTexture = RenderTexture.GetTemporary(src.descriptor);
        camera.targetTexture = rightTexture;
        camera.Render();
        baseMaterial.SetTexture("_RightTex", rightTexture);

        /*
        // Render camera at pos 1.
        camera.transform.position = cameraPos - camera.transform.right * strength;
        camera.transform.LookAt(focalPoint);
        var leftTexture = RenderTexture.GetTemporary(src.descriptor);
        camera.targetTexture = leftTexture;
        camera.Render();
        baseMaterial.SetTexture("_LeftTex", leftTexture);

        // Render camera at pos 2.
        camera.transform.rotation = cameraRot;
        camera.transform.position = cameraPos + camera.transform.right * strength;
        camera.transform.LookAt(focalPoint);
        var rightTexture = RenderTexture.GetTemporary(src.descriptor);
        camera.targetTexture = rightTexture;
        camera.Render();
        baseMaterial.SetTexture("_RightTex", rightTexture);
        */

        // Send both images to the shader.

        Graphics.Blit(src, dst, baseMaterial);

        // Release images.
        RenderTexture.ReleaseTemporary(leftTexture);
        RenderTexture.ReleaseTemporary(rightTexture);

        /*
        // Reset camera properties.
        camera.transform.position = cameraPos;
        camera.transform.rotation = cameraRot;
        camera.targetTexture = null;
        */
    }
}
