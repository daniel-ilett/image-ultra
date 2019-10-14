using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Image Effects Ultra/Fisheye", order = 1)]
public class FisheyeEffect : BaseEffect
{
    [SerializeField]
    private float pow;

    private void Update()
    {
        baseMaterial.SetFloat("_BarrelPower", pow);
    }

    public override void Render(RenderTexture src, RenderTexture dst)
    {
        Graphics.Blit(src, dst, baseMaterial);
    }
}
