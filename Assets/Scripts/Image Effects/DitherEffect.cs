using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Image Effects Ultra/Dither", order = 1)]
public class DitherEffect : BaseEffect
{
    [SerializeField]
    private Texture2D ditherTex;

    [SerializeField]
    private Color darkColor = new Color(0.199f, 0.195f, 0.102f);

    [SerializeField]
    private Color lightColor = new Color(0.895f, 1.0f, 1.0f);

    // Find the Dither shader source.
    public override void OnCreate()
    {
        if (ditherTex == null)
        {
            ditherTex = Texture2D.whiteTexture;
        }

        baseMaterial = new Material(Resources.Load<Shader>("Shaders/Dither"));
        baseMaterial.SetTexture("_NoiseTex", ditherTex);
        baseMaterial.SetColor("_DarkColor", darkColor);
        baseMaterial.SetColor("_LightColor", lightColor);
    }

    public override void Render(RenderTexture src, RenderTexture dst)
    {
        var camEuler = Camera.main.transform.eulerAngles;
        var xOffset = 2.0f * camEuler.y / Camera.main.fieldOfView;
        var yOffset = -1.0f * Camera.main.aspect * camEuler.x / Camera.main.fieldOfView;

        baseMaterial.SetFloat("_XOffset", xOffset);
        baseMaterial.SetFloat("_YOffset", yOffset);

        RenderTexture super = RenderTexture.GetTemporary(src.width * 2, src.height * 2);
        RenderTexture half = RenderTexture.GetTemporary(src.width / 2, src.height / 2);
        Graphics.Blit(src, super);
        Graphics.Blit(super, half, baseMaterial);
        Graphics.Blit(half, dst);
        RenderTexture.ReleaseTemporary(half);
        RenderTexture.ReleaseTemporary(super);
    }
}
