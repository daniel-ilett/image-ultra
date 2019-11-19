Shader "UltraEffects/Cinematic"
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

		// Generate time-sensitive random numbers between 0 and 1.
		float rand(float2 pos)
		{
			return frac(sin(dot(pos + _Time.y,
				float2(12.9898f, 78.233f))) * 43758.5453123f);
		}

		// Generate a random vector on the unit circle.
		float2 randUnitCircle(float2 pos)
		{
			const float PI = 3.14159265f;
			float randVal = rand(pos);
			float theta = 2.0f * PI * randVal;

			return float2(cos(theta), sin(theta));
		}

		// Quintic interpolation curve.
		float quinterp(float2 f)
		{
			return f*f*f * (f * (f * 6.0f - 15.0f) + 10.0f);
		}

		// Perlin gradient noise generator.
		float perlin2D(float2 pixel)
		{
			float2 pos00 = floor(pixel);
			float2 pos10 = pos00 + float2(1.0f, 0.0f);
			float2 pos01 = pos00 + float2(0.0f, 1.0f);
			float2 pos11 = pos00 + float2(1.0f, 1.0f);

			float2 rand00 = randUnitCircle(pos00);
			float2 rand10 = randUnitCircle(pos10);
			float2 rand01 = randUnitCircle(pos01);
			float2 rand11 = randUnitCircle(pos11);

			float dot00 = dot(rand00, pos00 - pixel);
			float dot10 = dot(rand10, pos10 - pixel);
			float dot01 = dot(rand01, pos01 - pixel);
			float dot11 = dot(rand11, pos11 - pixel);

			float2 d = frac(pixel);

			float x1 = lerp(dot00, dot10, quinterp(d.x));
			float x2 = lerp(dot01, dot11, quinterp(d.x));
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
