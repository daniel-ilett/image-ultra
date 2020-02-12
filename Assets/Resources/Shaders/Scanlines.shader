Shader "UltraEffects/Scanlines"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_ScanlineTex("Scanline Texture", 2D) = "white" {}
		_ScanlineStrength("Scanline Strength", Float) = 0.1
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
			sampler2D _ScanlineTex;
			float _Strength;
			int _Size;

            float4 frag (v2f i) : SV_Target
            {
				float2 scanlineUV = i.uv * (_ScreenParams.y / _Size);

                float4 col = tex2D(_MainTex, i.uv);
				float4 scanlines = tex2D(_ScanlineTex, scanlineUV);
                return lerp(col, col * scanlines, _Strength);
            }
            ENDCG
        }
    }
}
