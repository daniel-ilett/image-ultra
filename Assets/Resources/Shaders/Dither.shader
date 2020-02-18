Shader "UltraEffects/Dither"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_NoiseTex("Noise Texture", 2D) = "white" {}
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

            sampler2D _MainTex;
			sampler2D _NoiseTex;
			float4 _NoiseTex_TexelSize;

			float _XOffset;
			float _YOffset;

			float4 _DarkColor;
			float4 _LightColor;

            float4 frag (v2f i) : SV_Target
            {
                float3 col = tex2D(_MainTex, i.uv).xyz;
				float lum = dot(col, float3(0.299f, 0.587f, 0.114f));

				float2 noiseUV = i.uv * _ScreenParams.xy / _NoiseTex_TexelSize.zw;
				noiseUV += float2(_XOffset, _YOffset);
				float threshold = (tex2D(_NoiseTex, noiseUV)) / 2.0f + 0.25f;

				float3 rgb = lum < threshold ? _DarkColor : _LightColor;

				return float4(rgb, 1.0f);
            }
            ENDCG
        }
    }
}
