Shader "UltraEffects/Underwater"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_BumpMap("Normal Map", 2D) = "bump" {}
		_Strength("Strength", Float) = 0.01
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
			uniform sampler2D _BumpMap;
			uniform sampler2D _CameraDepthTexture;
			uniform float4 _CameraDepthTexture_TexelSize;

			uniform float _Strength;

            fixed4 frag (v2f i) : SV_Target
            {
				half3 normal = UnpackNormal(tex2D(_BumpMap, (i.uv + _Time.x) % 1.0));

				float2 uvOffset = normal * _Strength;

				uvOffset.y *=
					_CameraDepthTexture_TexelSize.z * abs(_CameraDepthTexture_TexelSize.y);

				float2 uv = i.uv + uvOffset;

                fixed4 col = tex2D(_MainTex, uv);


                return col;
            }
            ENDCG
        }
    }
}
