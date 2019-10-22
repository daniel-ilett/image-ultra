using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Image Effects Ultra/Disintegrate", order = 1)]
public class DisintegrateEffect : BaseEffect
{
    [SerializeField]
    private Texture2D dissolveTexture;

    [SerializeField]
    private Texture2D dissolveColour;

    [SerializeField]
    private float threshold = 0.5f;

    [SerializeField]
    private float strength = 0.5f;

    [SerializeField]
    private float tiling = 1.0f;

    [SerializeField]
    private Color backgroundColour = Color.black;

    // Find the Disintegrate shader source.
    public override void OnCreate()
    {
        baseMaterial = new Material(Resources.Load<Shader>("Shaders/Disintegrate"));

        baseMaterial.SetTexture("_DissolveTex", dissolveTexture);
        baseMaterial.SetTexture("_DissolveRamp", dissolveColour);
        baseMaterial.SetFloat("_Threshold", threshold);
        baseMaterial.SetFloat("_Strength", strength);
        baseMaterial.SetFloat("_Tiling", tiling);
        baseMaterial.SetColor("_BGColour", backgroundColour);
    }

    public override void Render(RenderTexture src, RenderTexture dst)
    {
        Graphics.Blit(src, dst, baseMaterial);
    }
}
