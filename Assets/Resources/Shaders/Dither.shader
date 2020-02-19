Shader "UltraEffects/Dither"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_NoiseTex("Noise Texture", 2D) = "white" {}
		_ColorRampTex("Color Ramp", 2D) = "white" {}
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
			float4 _MainTex_TexelSize;

			sampler2D _NoiseTex;
			float4 _NoiseTex_TexelSize;

			sampler2D _ColorRampTex;

			float _XOffset;
			float _YOffset;

            float4 frag (v2f i) : SV_Target
            {
                float3 col = tex2D(_MainTex, i.uv).xyz;
				float lum = dot(col, float3(0.299f, 0.587f, 0.114f));

				float2 noiseUV = i.uv * _NoiseTex_TexelSize.xy * _MainTex_TexelSize.zw;
				noiseUV += float2(_XOffset, _YOffset);
				float3 threshold = tex2D(_NoiseTex, noiseUV);
				float thresholdLum = dot(threshold, float3(0.299f, 0.587f, 0.114f));

				float rampVal = lum < thresholdLum ? thresholdLum - lum : 1.0f;
				float3 rgb = tex2D(_ColorRampTex, float2(rampVal, 0.5f));

				return float4(rgb, 1.0f);
            }
            ENDCG
        }
    }
}
