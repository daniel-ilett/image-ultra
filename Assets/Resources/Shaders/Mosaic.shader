Shader "UltraEffects/Mosaic"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_OverlayTex("Overlay Texture", 2D) = "white" {}
		_OverlayColour("Overlay Colour", Color) = (1, 1, 1, 1)
		_XTileCount("X-axis Tile Count", Int) = 100
		_YTileCount("Y-axis Tile Count", Int) = 100
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
			uniform float4 _OverlayColour;
			uniform int _XTileCount;
			uniform int _YTileCount;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);

				float2 overlayUV = i.uv * float2(_XTileCount, _YTileCount);
				float4 overlayCol = tex2D(_OverlayTex, overlayUV) * _OverlayColour;

				col = lerp(col, overlayCol, overlayCol.a);

                return col;
            }
            ENDCG
        }
    }
}
