using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class BaseEffect : ScriptableObject
{
    protected Material baseMaterial;

    public virtual void OnCreate() { }
    public abstract void Render(RenderTexture src, RenderTexture dst);
}
