using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Image Effects Ultra/Anaglyph 3D", order = 1)]
public class AnaglyphEffect : BaseEffect
{
    [SerializeField]
    private float strength = 0.01f;

    // Find the Anaglyph shader source.
    public override void OnCreate()
    {
        baseMaterial = new Material(Resources.Load<Shader>("Shaders/Anaglyph3D"));

        baseMaterial.SetFloat("_Strength", strength);
    }

    public override void Render(RenderTexture src, RenderTexture dst)
    {
        Graphics.Blit(src, dst, baseMaterial);
    }
}
