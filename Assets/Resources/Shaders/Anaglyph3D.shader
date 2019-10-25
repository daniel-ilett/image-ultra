Shader "UltraEffects/Anaglyph3D"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Strength("Strength", Float) = 0.1
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
			uniform sampler2D _CameraDepthTexture;

			uniform float _Strength;

            fixed4 frag (v2f i) : SV_Target
            {
				float depth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv);
				depth = Linear01Depth(depth);

				float2 offset = float2(depth * _Strength, 0.0f);

                float2 redUV = i.uv - offset;
				float2 blueUV = i.uv + offset;

				fixed4 redCol = tex2D(_MainTex, redUV);
				fixed4 blueCol = tex2D(_MainTex, blueUV);

				float4 col;
				col.r = redCol.r;
				col.gb = blueCol.gb;
				col.a = 1.0f;

                return col;
            }
            ENDCG
        }
    }
}
