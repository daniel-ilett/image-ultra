Shader "UltraEffects/CinematicPerlin"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Strength("Noise Strength", Float) = 0.1
		_Aspect("Aspect Ratio", Float) = 1.777
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

		CGINCLUDE

		const float PI = 3.14159;

		// Generate time-sensitive random numbers.
		float rand(float2 st)
		{
			return frac(sin(dot(st + float2(_Time.y, _Time.y), float2(12.9898f, 78.233f))) * 43758.5453123f);
		}

		// Quintic interpolation curve.
		float quinterp(float2 f)
		{
			return f*f*f * (f * (f * 6.0f - 15.0f) + 10.0f);
		}

		// Perlin gradient noise generator.
		float perlin2D(float2 st)
		{
			float2 pos = floor(st);

			float rand00 = rand(pos);
			float rand10 = rand(pos + float2(1.0f, 0.0f));
			float rand01 = rand(pos + float2(0.0f, 1.0f));
			float rand11 = rand(pos + float2(1.0f, 1.0f));

			float2 d = frac(st);

			float x1 = lerp(rand00, rand01, quinterp(d.x));
			float x2 = lerp(rand01, rand11, quinterp(d.x));
			float y  = lerp(x1, x2, quinterp(d.y));

			return y;
		}

		ENDCG

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
			uniform float _Strength;
			uniform float _Aspect;

            fixed4 frag (v2f i) : SV_Target
            {
				// Calculate Perlin noise.
				float4 col = tex2D(_MainTex, i.uv);
                float2 pos = i.uv * _ScreenParams.xy;
				float n = perlin2D(pos);

				// Calculate cinematic bars.
				float aspect = _ScreenParams.x / _ScreenParams.y;
				float bars = step(abs(0.5f - i.uv.y) * 2.0f, aspect / _Aspect);

                return (col - _Strength * n) * bars;
            }
            ENDCG
        }
    }
}
