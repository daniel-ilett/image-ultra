using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Mosaic : MonoBehaviour
{
    [SerializeField]
    private Material mat;

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
            mat.SetInt("_YTileCount", value);
        }
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        RenderTexture tmp = 
            RenderTexture.GetTemporary(yTileCount, (int)(((float)src.height / src.width) * yTileCount));

        tmp.filterMode = FilterMode.Point;

        Graphics.Blit(src, tmp);
        Graphics.Blit(tmp, dst, mat);
    }
}
