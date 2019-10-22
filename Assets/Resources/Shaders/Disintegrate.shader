Shader "UltraEffects/Disintegrate"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_DissolveTex("Dissolve Texture", 2D) = "white" {}
		_DissolveRamp("Dissolve Colour Ramp", 2D) = "white" {}
		_Threshold("Threshold", Float) = 0.5
		_Tiling("Tiling Amount", Float) = 1.0
		_BGColour("Background Colour", Color) = (0, 0, 0, 1)
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            uniform sampler2D _MainTex;
			uniform sampler2D _DissolveTex;
			uniform sampler2D _DissolveRamp;
			uniform float _Threshold;
			uniform float _Tiling;
			uniform float4 _BGColour;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
				fixed dissolve = _Threshold + tex2D(_DissolveTex, i.uv * _Tiling);
				fixed4 dissolveColour = tex2D(_DissolveRamp, float2(dissolve, 0.5f));

				col *= dissolveColour;
				col = lerp(col, _BGColour, 1.0f - dissolveColour.a);
				
                return col;
            }
            ENDCG
        }
    }
}
