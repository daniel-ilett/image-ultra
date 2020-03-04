using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Image Effects Ultra/Painting", order = 1)]
public class PaintingEffect : BaseEffect
{
    [SerializeField]
    private int kernelSize = 17;

    // Find the Painting shader source.
    public override void OnCreate()
    {
        baseMaterial = new Material(Resources.Load<Shader>("Shaders/Painting"));
    }

    public override void Render(RenderTexture src, RenderTexture dst)
    {
        baseMaterial.SetInt("_KernelSize", kernelSize);
        Graphics.Blit(src, dst, baseMaterial);
    }
}
