using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Camera))]
public class Fisheye : MonoBehaviour
{
    [SerializeField]
    private Material material;

    [SerializeField]
    private float pow;

    private void Update()
    {
        material.SetFloat("_BarrelPower", pow);
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        Graphics.Blit(src, dst, material);
    }
}
