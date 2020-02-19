using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Image Effects Ultra/Dither", order = 1)]
public class DitherEffect : BaseEffect
{
    [SerializeField]
    private Texture2D ditherTex;

    [SerializeField]
    private Texture2D rampTex;

    [SerializeField]
    private bool useScrolling = false;

    [SerializeField]
    private FilterMode filterMode = FilterMode.Bilinear;

    // Find the Dither shader source.
    public override void OnCreate()
    {
        baseMaterial = new Material(Resources.Load<Shader>("Shaders/Dither"));
        baseMaterial.SetTexture("_NoiseTex", ditherTex);
        baseMaterial.SetTexture("_ColorRampTex", rampTex);
    }

    public override void Render(RenderTexture src, RenderTexture dst)
    {
        var xOffset = 0.0f;
        var yOffset = 0.0f;

        if(useScrolling)
        {
            var camEuler = Camera.main.transform.eulerAngles;
            xOffset = 4.0f * camEuler.y / Camera.main.fieldOfView;
            yOffset = -2.0f * Camera.main.aspect * camEuler.x / Camera.main.fieldOfView;
        }

        baseMaterial.SetFloat("_XOffset", xOffset);
        baseMaterial.SetFloat("_YOffset", yOffset);
        
        RenderTexture super = RenderTexture.GetTemporary(src.width * 2, src.height * 2);
        RenderTexture half = RenderTexture.GetTemporary(src.width / 2, src.height / 2);

        super.filterMode = filterMode;
        half.filterMode = filterMode;

        Graphics.Blit(src, super);
        Graphics.Blit(super, half, baseMaterial);
        Graphics.Blit(half, dst);

        RenderTexture.ReleaseTemporary(half);
        RenderTexture.ReleaseTemporary(super);
    }
}
