using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Image Effects Ultra/Cinematic", order = 1)]
public class CinematicEffect : BaseEffect
{
    [SerializeField]
    private float strength = 0.1f;

    [SerializeField]
    private float aspectRatio = 1.777f;

    // Find the Cinematic shader source.
    public override void OnCreate()
    {
        baseMaterial = new Material(Resources.Load<Shader>("Shaders/Cinematic"));

        baseMaterial.SetFloat("_Strength", strength);
        baseMaterial.SetFloat("_Aspect", aspectRatio);
    }

    public override void Render(RenderTexture src, RenderTexture dst)
    {
        Graphics.Blit(src, dst, baseMaterial);
    }
}
