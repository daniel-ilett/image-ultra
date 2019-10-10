using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Image Effects Ultra/Composite", order = 1)]
public class CompositeEffect : BaseEffect
{
    [SerializeField]
    private List<BaseEffect> effects;

    public override void Render(RenderTexture src, RenderTexture dst)
    {
        RenderTexture tmpSrc = RenderTexture.GetTemporary(src.width, src.height);
        RenderTexture tmpDst = RenderTexture.GetTemporary(src.width, src.height);
        Graphics.Blit(src, tmpSrc);

        foreach(var effect in effects)
        {
            effect.Render(tmpSrc, tmpDst);

            // Swap the two render textures.
            var tmp = tmpSrc;
            tmpSrc = tmpDst;
            tmpDst = tmp;
        }

        Graphics.Blit(tmpSrc, dst);

        RenderTexture.ReleaseTemporary(tmpSrc);
        RenderTexture.ReleaseTemporary(tmpDst);
    }
}
