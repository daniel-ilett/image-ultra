Shader "UltraEffects/Drawing"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_DrawingTex("Drawing Texture", 2D) = "white" {}
		_OverlayOffset("Overlay Offset", Float) = 0
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
			sampler2D _DrawingTex;

			float _XOffset;
			float _YOffset;

			float _OverlayOffset;
			float _Strength;

            float4 frag (v2f i) : SV_Target
            {
                float4 col = tex2D(_MainTex, i.uv);

				float2 drawingUV = i.uv * 10.0f + _OverlayOffset + float2(_XOffset, _YOffset);
				drawingUV.y *= _ScreenParams.y / _ScreenParams.x;
				float4 drawingCol = tex2D(_DrawingTex, drawingUV);

				return lerp(col, drawingCol * col, _Strength);
            }
            ENDCG
        }
    }
}
