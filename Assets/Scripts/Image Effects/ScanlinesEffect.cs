using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Image Effects Ultra/Scanlines", order = 1)]
public class ScanlinesEffect : BaseEffect
{
    [SerializeField]
    private Texture2D scanlineTex = null;

    [SerializeField]
    private float strength = 0.1f;

    [SerializeField]
    private int size = 8;

    // Find the Scanlines shader source.
    public override void OnCreate()
    {
        if(scanlineTex == null)
        {
            scanlineTex = Texture2D.whiteTexture;
        }

        baseMaterial = new Material(Resources.Load<Shader>("Shaders/Scanlines"));
        baseMaterial.SetTexture("_ScanlineTex", scanlineTex);
        baseMaterial.SetFloat("_Strength", strength);
        baseMaterial.SetInt("_Size", size);
    }

    public override void Render(RenderTexture src, RenderTexture dst)
    {
        Graphics.Blit(src, dst, baseMaterial);
    }
}
