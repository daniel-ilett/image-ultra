using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Image Effects Ultra/Mosaic", order = 1)]
public class MosaicEffect : BaseEffect
{
    [SerializeField]
    private int yTileCount = 100;

    [SerializeField]
    private Texture2D overlayTexture;

    /*
    // Reset the tile count whenever it changes.
    private int YTileCount
    {
        get
        {
            return yTileCount;
        }
        set
        {
            yTileCount = value;
            baseMaterial.SetInt("_YTileCount", value);
        }
    }

    // Reset the overlay texture whenever it changes.
    private Texture2D OverlayTexture
    {
        get
        {
            return overlayTexture;
        }
        set
        {
            overlayTexture = value;
            baseMaterial.SetTexture("_OverlayTex", value);
        }
    }
    */

    // Find the Mosaic shader source.
    public override void OnCreate()
    {
        baseMaterial = new Material(Resources.Load<Shader>("Shaders/Mosaic"));

        baseMaterial.SetInt("_YTileCount", yTileCount);
        baseMaterial.SetTexture("_OverlayTex", overlayTexture);
    }

    public override void Render(RenderTexture src, RenderTexture dst)
    {
        RenderTexture tmp = 
            RenderTexture.GetTemporary(yTileCount, (int)(((float)src.height / src.width) * yTileCount));

        tmp.filterMode = FilterMode.Point;
        
        Graphics.Blit(src, tmp);
        Graphics.Blit(tmp, dst, baseMaterial);
    }
}
