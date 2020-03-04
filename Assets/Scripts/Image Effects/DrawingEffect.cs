using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Image Effects Ultra/Drawing", order = 1)]
public class DrawingEffect : BaseEffect
{
    [SerializeField]
    private Texture2D drawingTex;

    [SerializeField]
    private float shiftCycleTime;

    [SerializeField]
    private float strength;

    // Find the Drawing shader source.
    public override void OnCreate()
    {
        baseMaterial = new Material(Resources.Load<Shader>("Shaders/Drawing"));
    }

    public override void Render(RenderTexture src, RenderTexture dst)
    {
        bool isOffset = (Time.time % shiftCycleTime) < (shiftCycleTime / 2.0f);

        var camEuler = Camera.main.transform.eulerAngles;
        var xOffset = 4.0f * camEuler.y / Camera.main.fieldOfView;
        var yOffset = -4.0f * Camera.main.aspect * camEuler.x / Camera.main.fieldOfView;

        baseMaterial.SetFloat("_XOffset", xOffset);
        baseMaterial.SetFloat("_YOffset", yOffset);

        if (drawingTex != null)
        {
            baseMaterial.SetTexture("_DrawingTex", drawingTex);
        }
        
        baseMaterial.SetFloat("_OverlayOffset", isOffset ? 0.5f : 0.0f);
        baseMaterial.SetFloat("_Strength", strength);
        Graphics.Blit(src, dst, baseMaterial);
    }
}
