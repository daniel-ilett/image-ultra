using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Image Effects Ultra/Anaglyph 3D Pro", order = 1)]
public class AnaglyphProEffect : BaseEffect
{
    [SerializeField]
    private float rotation = 1.0f;

    [SerializeField]
    private Camera cameraPrefab;

    private Camera camera;

    // Find the Anaglyph Pro shader source.
    public override void OnCreate()
    {
        baseMaterial = new Material(Resources.Load<Shader>("Shaders/Anaglyph3DPro"));

        camera = Instantiate(cameraPrefab);
    }

    public override void Render(RenderTexture src, RenderTexture dst)
    {
        // Render camera at pos 1.
        camera.CopyFrom(Camera.main);
        camera.transform.Rotate(camera.transform.up, rotation);
        var leftTexture = RenderTexture.GetTemporary(src.descriptor);
        camera.targetTexture = leftTexture;
        camera.Render();
        baseMaterial.SetTexture("_LeftTex", leftTexture);

        // Render camera at pos 2.
        camera.CopyFrom(Camera.main);
        camera.transform.Rotate(camera.transform.up, -rotation);
        var rightTexture = RenderTexture.GetTemporary(src.descriptor);
        camera.targetTexture = rightTexture;
        camera.Render();
        baseMaterial.SetTexture("_RightTex", rightTexture);

        Graphics.Blit(src, dst, baseMaterial);

        // Release images.
        RenderTexture.ReleaseTemporary(leftTexture);
        RenderTexture.ReleaseTemporary(rightTexture);
    }
}
