Shader "UltraEffects/Vignette"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Strength("Strength", Float) = 0.5
		_Size("Size", Float) = 0.75
		_Falloff("Falloff", Float) = 0.25
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
			uniform float _Strength;
			uniform float _Size;
			uniform float _Falloff;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);

				float dist = distance(i.uv, float2(0.5f, 0.5f));
				float vignette = smoothstep(_Size, _Size - _Falloff, dist);
				vignette = lerp(1.0f, vignette, _Strength);

				col = saturate(col * vignette);

                return col;
            }
            ENDCG
        }
    }
}