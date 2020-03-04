using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Image Effects Ultra/Drawing", order = 1)]
public class DrawingEffect : BaseEffect
{
    [SerializeField]
    private Texture2D drawingTex;

    [SerializeField]
    private float shiftCycleTime = 1.0f;

    [SerializeField]
    private float strength = 0.5f;

    [SerializeField]
    private float tiling = 10.0f;

    [SerializeField]
    private float smudge = 1.0f;

    [SerializeField]
    private float depthThreshold = 0.99f;

    // Find the Drawing shader source.
    public override void OnCreate()
    {
        baseMaterial = new Material(Resources.Load<Shader>("Shaders/Drawing"));
    }

    public override void Render(RenderTexture src, RenderTexture dst)
    {
        bool isOffset = (Time.time % shiftCycleTime) < (shiftCycleTime / 2.0f);

        if (drawingTex != null)
        {
            baseMaterial.SetTexture("_DrawingTex", drawingTex);
        }
        
        baseMaterial.SetFloat("_OverlayOffset", isOffset ? 0.5f : 0.0f);
        baseMaterial.SetFloat("_Strength", strength);
        baseMaterial.SetFloat("_Tiling", tiling);
        baseMaterial.SetFloat("_Smudge", smudge);
        baseMaterial.SetFloat("_DepthThreshold", depthThreshold);
        Graphics.Blit(src, dst, baseMaterial);
    }
}
