using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Image Effects Ultra/Outline", order = 1)]
public class OutlineEffect : BaseEffect
{
    // Find the Outline shader source.
    public override void OnCreate()
    {
        baseMaterial = new Material(Resources.Load<Shader>("Shaders/Outline"));
    }

    public override void Render(RenderTexture src, RenderTexture dst)
    {
        Camera.main.depthTextureMode = DepthTextureMode.DepthNormals;
        Graphics.Blit(src, dst, baseMaterial);
    }
}
