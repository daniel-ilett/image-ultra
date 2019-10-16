using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Camera))]
public class ImageEffect : MonoBehaviour
{
    [SerializeField]
    private BaseEffect effect;

    private void Awake()
    {
        effect.OnCreate();
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        effect.Render(src, dst);
    }
}
