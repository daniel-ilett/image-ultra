using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Image Effects Ultra/Disintegrate", order = 1)]
public class DisintegrateEffect : BaseEffect
{
    [SerializeField]
    private Texture2D dissolveNoise;

    [SerializeField]
    private Texture2D colorRamp;

    [SerializeField]
    private Texture2D alphaRamp;

    [SerializeField]
    private Texture2D flowMap;

    [SerializeField]
    private float strength = 0.5f;

    [SerializeField]
    private float tiling = 1.0f;

    [SerializeField]
    private Vector2 flickerDir = Vector2.zero;

    [SerializeField]
    private Color backgroundColour = Color.black;

    // Find the Disintegrate shader source.
    public override void OnCreate()
    {
        baseMaterial = new Material(Resources.Load<Shader>("Shaders/Disintegrate"));

        baseMaterial.SetTexture("_DissolveNoise", dissolveNoise);
        baseMaterial.SetTexture("_ColorRamp", colorRamp);
        baseMaterial.SetTexture("_AlphaRamp", alphaRamp);
        baseMaterial.SetTexture("_FlowMap", flowMap);
        baseMaterial.SetFloat("_Strength", strength);
        baseMaterial.SetFloat("_Tiling", tiling);
        baseMaterial.SetVector("_FlickerDir", flickerDir);
        baseMaterial.SetColor("_BackgroundColor", backgroundColour);
    }

    public override void Render(RenderTexture src, RenderTexture dst)
    {
        Graphics.Blit(src, dst, baseMaterial);
    }
}
