Shader "UltraEffects/Anaglyph3DPro"
{
    Properties
    {
		_LeftTex ("Left Eye Image", 2D) = "white" {}
		_RightTex ("Right Eye Image", 2D) = "white" {}
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

			uniform sampler2D _LeftTex;
			uniform sampler2D _RightTex;

            fixed4 frag (v2f i) : SV_Target
            {
				float4 col;
				float4 leftCol = tex2D(_LeftTex, i.uv);
				float4 rightCol = tex2D(_RightTex, i.uv);

				col.r = rightCol.r;
				col.gb = leftCol.gb;
				col.a = 1.0f;

                return col;
            }
            ENDCG
        }
    }
}
