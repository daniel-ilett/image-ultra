Shader "UltraEffects/Kaleidoscope"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_SegmentCount("Segment Count", Float) = 4
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
			float _SegmentCount;

            float4 frag (v2f i) : SV_Target
            {
				// Convert to polar coordinates.
				float2 shiftUV = i.uv - 0.5;
				float radius = sqrt(dot(shiftUV, shiftUV));
				float angle = atan2(shiftUV.y, shiftUV.x);

				// Calculate segment angle amount.
				float segmentAngle = UNITY_TWO_PI / _SegmentCount;

				// Calculate which segment this angle is in.
				angle -= segmentAngle * floor(angle / segmentAngle);

				// Each segment contains one reflection.
				angle = min(angle, segmentAngle - angle);

				// Convert back to UV coordinates.
				float2 uv = float2(cos(angle), sin(angle)) * radius + 0.5f;

				// Reflect outside the inner circle boundary.
				uv = max(min(uv, 2.0 - uv), -uv);

				return tex2D(_MainTex, uv);
            }
            ENDCG
        }
    }
}
