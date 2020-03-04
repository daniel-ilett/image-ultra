Shader "UltraEffects/Outline"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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

			#pragma multi_compile EDGE_COLORS EDGE_DEPTH EDGE_NORMALS

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
			float4 _MainTex_TexelSize;

			sampler2D _CameraDepthTexture;
			sampler2D _CameraDepthNormalsTexture;

			float _ColorSensitivity;
			float _ColorStrength;
			float _DepthSensitivity;
			float _DepthStrength;
			float _NormalsSensitivity;
			float _NormalsStrength;

            float4 frag (v2f i) : SV_Target
            {
                float4 col = tex2D(_MainTex, i.uv);

				float2 leftUV = i.uv + float2(-_MainTex_TexelSize.x, 0);
				float2 rightUV = i.uv + float2(_MainTex_TexelSize.x, 0);
				float2 bottomUV = i.uv + float2(0, -_MainTex_TexelSize.y);
				float2 topUV = i.uv + float2(0, _MainTex_TexelSize.y);

				float3 col0 = tex2D(_MainTex, leftUV).rgb;
				float3 col1 = tex2D(_MainTex, rightUV).rgb;
				float3 col2 = tex2D(_MainTex, bottomUV).rgb;
				float3 col3 = tex2D(_MainTex, topUV).rgb;

				float3 c0 = col1 - col0;
				float3 c1 = col3 - col2;

				float edgeCol = sqrt(dot(c0, c0) + dot(c1, c1));
				edgeCol = edgeCol > _ColorSensitivity ? _ColorStrength : 0;

				float depth0 = tex2D(_CameraDepthTexture, leftUV).r;
				float depth1 = tex2D(_CameraDepthTexture, rightUV).r;
				float depth2 = tex2D(_CameraDepthTexture, bottomUV).r;
				float depth3 = tex2D(_CameraDepthTexture, topUV).r;

				depth0 = Linear01Depth(depth0);
				depth1 = Linear01Depth(depth1);
				depth2 = Linear01Depth(depth2);
				depth3 = Linear01Depth(depth3);

				float d0 = depth1 - depth0;
				float d1 = depth3 - depth2;

				float edgeDepth = sqrt(d0 * d0 + d1 * d1);
				edgeDepth = edgeDepth > _DepthSensitivity ? _DepthStrength : 0;

				float3 normal0 = tex2D(_CameraDepthNormalsTexture, leftUV).rgb;
				float3 normal1 = tex2D(_CameraDepthNormalsTexture, rightUV).rgb;
				float3 normal2 = tex2D(_CameraDepthNormalsTexture, bottomUV).rgb;
				float3 normal3 = tex2D(_CameraDepthNormalsTexture, topUV).rgb;

				float3 n0 = normal1 - normal0;
				float3 n1 = normal3 - normal2;

				float edgeNormal = sqrt(dot(n0, n0) + dot(n1, n1));
				edgeNormal = edgeNormal > _NormalsSensitivity ? _NormalsStrength : 0;

				float edge = max(max(edgeCol, edgeDepth), edgeNormal);

				return col * (1.0f - edge);
            }
            ENDCG
        }
    }
}
