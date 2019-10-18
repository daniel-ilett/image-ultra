using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Image Effects Ultra/Underwater", order = 1)]
public class UnderwaterEffect : BaseEffect
{
    [SerializeField]
    private Texture2D normalMap;

    [SerializeField]
    private float strength = 0.01f;

    [SerializeField]
    private Color waterColour = Color.white;

    [SerializeField]
    private float fogStrength = 0.1f;

    // Find the Underwater shader source.
    public override void OnCreate()
    {
        baseMaterial = new Material(Resources.Load<Shader>("Shaders/Underwater"));

        baseMaterial.SetTexture("_BumpMap", normalMap);
        baseMaterial.SetFloat("_Strength", strength);
        baseMaterial.SetColor("_WaterColour", waterColour);
        baseMaterial.SetFloat("_FogStrength", fogStrength);
    }

    public override void Render(RenderTexture src, RenderTexture dst)
    {
        Graphics.Blit(src, dst, baseMaterial);
    }
}
