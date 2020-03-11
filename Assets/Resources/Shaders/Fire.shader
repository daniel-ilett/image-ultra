Shader "UltraEffects/Fire"
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

            sampler2D _MainTex;
			sampler2D _DissolveNoise;
			sampler2D _ColorRamp;
			sampler2D _AlphaRamp;
			sampler2D _FlowMap;
			float _Strength;
			float _Tiling;
			float2 _FlickerDir;
			float4 _BackgroundColor;

            float4 frag (v2f i) : SV_Target
            {
				float4 col = tex2D(_MainTex, i.uv);

				half3 normal = UnpackNormal(tex2D(_FlowMap, (i.uv + _Time.x) % 1.0));
				float2 uvOffset = i.uv + normal * _Strength * 0.05f;

				float2 distance = abs((i.uv - 0.5f) * 2.0f);
				float dissolveDist = sqrt(distance.x*distance.x + distance.y*distance.y);

				float2 dissolveUV = i.uv * _Tiling;
				float dissolveBase = (tex2D(_DissolveNoise, dissolveUV) + 
					tex2D(_DissolveNoise, dissolveUV * 3.0f + _Time.x * _FlickerDir)) / 2.0f;

				float dissolve = (dissolveBase + _Strength) * dissolveDist;

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
