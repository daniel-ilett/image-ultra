using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Image Effects Ultra/Interference", order = 1)]
public class InterferenceEffect : BaseEffect
{
    [SerializeField]
    private Texture2D interferenceTex = null;

    [SerializeField]
    private float speed = 0.5f;

    // Find the Interference shader source.
    public override void OnCreate()
    {
        if (interferenceTex == null)
        {
            interferenceTex = Texture2D.whiteTexture;
        }

        baseMaterial = new Material(Resources.Load<Shader>("Shaders/Interference"));
        baseMaterial.SetTexture("_InterferenceTex", interferenceTex);
        baseMaterial.SetFloat("_Speed", speed);
    }

    public override void Render(RenderTexture src, RenderTexture dst)
    {
        Graphics.Blit(src, dst, baseMaterial);
    }
}
