using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Image Effects Ultra/Mosaic", order = 1)]
public class MosaicEffect : BaseEffect
{
    [SerializeField]
    private int yTileCount = 100;

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

    // Find the Mosaic shader source.
    private void Awake()
    {
        baseMaterial = new Material(Shader.Find("Shaders/Mosaic"));
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
