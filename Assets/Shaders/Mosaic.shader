Shader "UltraEffects/Mosaic"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_OverlayTex("Overlay Texture", 2D) = "white" {}
		_YTileCount("Tile Count", Int) = 100
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
			uniform sampler2D _OverlayTex;
			uniform int _YTileCount;
			uniform float4 _CameraDepthTexture_TexelSize;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);

				float2 overlayUV = i.uv * _YTileCount;
				overlayUV.y /=
					_CameraDepthTexture_TexelSize.z * abs(_CameraDepthTexture_TexelSize.y);

				float4 overlayCol = tex2D(_OverlayTex, overlayUV);

				col = lerp(col, overlayCol, overlayCol.a);

                return col;
            }
            ENDCG
        }
    }
}
