using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Image Effects Ultra/Outline", order = 1)]
public class OutlineEffect : BaseEffect
{
    [SerializeField]
    private float colorSensitivity = 0.1f;

    [SerializeField]
    private float colorStrength = 1.0f;

    [SerializeField]
    private float depthSensitivity = 0.1f;

    [SerializeField]
    private float depthStrength = 1.0f;

    [SerializeField]
    private float normalsSensitivity = 0.1f;

    [SerializeField]
    private float normalsSrength = 1.0f;

    // Find the Outline shader source.
    public override void OnCreate()
    {
        baseMaterial = new Material(Resources.Load<Shader>("Shaders/Outline"));
    }

    public override void Render(RenderTexture src, RenderTexture dst)
    {
        baseMaterial.SetFloat("_ColorSensitivity", colorSensitivity);
        baseMaterial.SetFloat("_ColorStrength", colorStrength);
        baseMaterial.SetFloat("_DepthSensitivity", depthSensitivity);
        baseMaterial.SetFloat("_DepthStrength", depthStrength);
        baseMaterial.SetFloat("_NormalsSensitivity", normalsSensitivity);
        baseMaterial.SetFloat("_NormalsStrength", normalsSrength);

        Camera.main.depthTextureMode = DepthTextureMode.DepthNormals;
        Graphics.Blit(src, dst, baseMaterial);
    }
}
