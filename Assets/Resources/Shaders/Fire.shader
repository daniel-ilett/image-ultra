Shader "UltraEffects/Fire"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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
			sampler2D _DissolveNoise;
			sampler2D _ColorRamp;
			sampler2D _AlphaRamp;
			sampler2D _FlowMap;
			float _Size;
			float _Strength;
			float _Tiling;
			float2 _FlickerDir;
			float4 _BackgroundColor;

            float4 frag (v2f i) : SV_Target
            {
				float4 col = tex2D(_MainTex, i.uv);

				float2 flickerOffset = _Time.x * _FlickerDir;
				half3 normal = UnpackNormal(tex2D(_FlowMap, (i.uv + flickerOffset) % 1.0));
				float2 uvOffset = normal * _Strength;

				float2 dissolveUV = i.uv * _Tiling;
				float dissolveBase = (tex2D(_DissolveNoise, dissolveUV) + 
					tex2D(_DissolveNoise, dissolveUV * 3.0f + uvOffset + flickerOffset)) / 2.0f;

				float2 distance = (i.uv - 0.5f) * 2.0f;
				float dissolveDist = sqrt(distance.x*distance.x + distance.y*distance.y);

				float dissolve = (dissolveBase + _Size) * dissolveDist;

				float4 dissolveColor = tex2D(_ColorRamp, float2(dissolve, 0.5f));
				float dissolveAlpha = tex2D(_AlphaRamp, float2(dissolve, 0.5f)).a;

				col = lerp(col, dissolveColor, dissolveColor.a);
				col = lerp(_BackgroundColor, col, dissolveAlpha);
				
                return col;
            }
            ENDCG
        }
    }
}
