// Based on code from:
// https://www.geeks3d.com/20140213/glsl-shader-library-fish-eye-and-dome-and-barrel-distortion-post-processing-filters/2/

/*	This shader imitates a fisheye lens using barrel distortion.
*/
Shader "UltraEffects/Fisheye"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_BarrelPower("Barrel Power", Float) = 1.0
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

			// Standard vertex shader.
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            uniform sampler2D _MainTex;
			uniform float _BarrelPower;
			uniform fixed4 _CullColour;

			// Inflate the centre of the screen.
			float2 distort(float2 p)
			{
				float theta = atan2(p.y, p.x);
				float radius = length(p);
				radius = pow(radius, _BarrelPower);
				p.x = radius * cos(theta);
				p.y = radius * sin(theta);

				return 0.5 * (p + 1.0);
			}

            fixed4 frag (v2f i) : SV_Target
            {
                float2 xy = 2.0 * i.uv - 1.0;
				float2 uv;
				float d = length(xy);

				if (d >= 1.0)
				{
					discard;
				}

				uv = distort(xy);
				return tex2D(_MainTex, uv);
            }
            ENDCG
        }
    }
}
