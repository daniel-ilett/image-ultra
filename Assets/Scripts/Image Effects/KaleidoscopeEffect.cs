using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Image Effects Ultra/Kaleidoscope", order = 1)]
public class KaleidoscopeEffect : BaseEffect
{
    [SerializeField]
    private int segments = 4;

    // Find the Kaleidoscope shader source.
    public override void OnCreate()
    {
        baseMaterial = new Material(Resources.Load<Shader>("Shaders/Kaleidoscope"));
        baseMaterial.SetFloat("_SegmentCount", segments);
    }

    public override void Render(RenderTexture src, RenderTexture dst)
    {
        Graphics.Blit(src, dst, baseMaterial);
    }
}
