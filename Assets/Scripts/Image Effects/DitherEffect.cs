using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Image Effects Ultra/Dither", order = 1)]
public class DitherEffect : BaseEffect
{
    [SerializeField]
    private Texture2D ditherTex;

    // Find the Dither shader source.
    public override void OnCreate()
    {
        if (ditherTex == null)
        {
            ditherTex = Texture2D.whiteTexture;
        }

        baseMaterial = new Material(Resources.Load<Shader>("Shaders/Dither"));
        baseMaterial.SetTexture("_NoiseTex", ditherTex);
    }

    public override void Render(RenderTexture src, RenderTexture dst)
    {
        RenderTexture tmp = RenderTexture.GetTemporary(src.width / 2, src.height / 2);
        Graphics.Blit(src, tmp, baseMaterial);
        Graphics.Blit(tmp, dst);
        RenderTexture.ReleaseTemporary(tmp);
    }
}
