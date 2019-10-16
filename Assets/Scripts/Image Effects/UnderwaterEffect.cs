using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Image Effects Ultra/Underwater", order = 1)]
public class UnderwaterEffect : BaseEffect
{
    [SerializeField]
    private float strength = 0.01f;

    [SerializeField]
    private Color waterColour = Color.white;

    // Find the Underwater shader source.
    public override void OnCreate()
    {
        baseMaterial = new Material(Resources.Load<Shader>("Shaders/Underwater"));
    }

    public override void Render(RenderTexture src, RenderTexture dst)
    {
        Graphics.Blit(src, dst, baseMaterial);
    }
}
