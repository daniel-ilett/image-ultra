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
			sampler2D _CameraDepthTexture;

			float _OverlayOffset;
			float _Strength;
			float _Tiling;
			float _Smudge;
			float _DepthThreshold;

            float4 frag (v2f i) : SV_Target
            {
                float2 drawingUV = i.uv * _Tiling + _OverlayOffset;
				drawingUV.y *= _ScreenParams.y / _ScreenParams.x;
				float4 drawingCol = (tex2D(_DrawingTex, drawingUV) + 
					tex2D(_DrawingTex, drawingUV / 3.0f)) / 2.0f;

				float2 texUV = i.uv + drawingCol * _Smudge;
				float4 col = tex2D(_MainTex, texUV);

				float lum = dot(col, float3(0.3f, 0.59f, 0.11f));
				float4 drawing = lerp(col, drawingCol * col, (1.0f - lum) * _Strength);

				float depth = tex2D(_CameraDepthTexture, i.uv).r;
				depth = Linear01Depth(depth);

				return depth < _DepthThreshold ? drawing : col;
            }
            ENDCG
        }
    }
}
