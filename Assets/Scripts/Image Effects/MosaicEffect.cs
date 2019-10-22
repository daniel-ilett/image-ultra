using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Image Effects Ultra/Mosaic", order = 1)]
public class MosaicEffect : BaseEffect
{
    [SerializeField]
    private Texture2D overlayTexture;

    [SerializeField]
    private Color overlayColour = Color.white;

    [SerializeField]
    private int xTileCount = 100;

    // Find the Mosaic shader source.
    public override void OnCreate()
    {
        baseMaterial = new Material(Resources.Load<Shader>("Shaders/Mosaic"));

        baseMaterial.SetTexture("_OverlayTex", overlayTexture);
        baseMaterial.SetColor("_OverlayColour", overlayColour);
        baseMaterial.SetInt("_XTileCount", xTileCount);
        baseMaterial.SetInt("_YTileCount", 
            Mathf.RoundToInt((float)Screen.height / Screen.width * xTileCount));
    }

    public override void Render(RenderTexture src, RenderTexture dst)
    {
        RenderTexture tmp = 
            RenderTexture.GetTemporary(xTileCount, 
            Mathf.RoundToInt(((float)src.height / src.width) * xTileCount));

        tmp.filterMode = FilterMode.Point;
        
        Graphics.Blit(src, tmp);
        Graphics.Blit(tmp, dst, baseMaterial);
    }
}
