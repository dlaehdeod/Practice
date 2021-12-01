Shader "Custom/LambertShader" {
	Properties{
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_BumpMap("Albedo (RGB)", 2D) = "bump" {}
	}
	SubShader{
		Tags { "RenderType" = "Opaque" }

		CGPROGRAM
		#pragma surface surf Test

		sampler2D _MainTex;
		sampler2D _BumpMap;

		struct Input {
			float2 uv_MainTex;
			float2 uv_BumpMap;
		};

		void surf(Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
			fixed4 d = tex2D(_BumpMap, IN.uv_BumpMap);
			fixed3 normal = UnpackNormal(d);

			o.Albedo = c.rgb;
			o.Normal = normal;
			o.Alpha = c.a;
		}

		float4 LightingTest(SurfaceOutput s, float3 lightDir, float atten) {

			//float ndotl = saturate(dot(s.Normal, lightDir)); //기존 Lambert 방식
			//dot의 결과(-1 ~ 1) 는 너무 급격한 음영이 나타날 수 있다. 이에 Half-Lambert 방식을 사용한다.
			//기존의 값에 *0.5 + 0.5 연산을 통해 0~1 값으로 만들 수 있다.

			float ndotl = dot(s.Normal, lightDir) * 0.5 + 0.5; // Half-Lambert 방식
			float4 final;
			final.rgb = ndotl * s.Albedo * _LightColor0.rgb * atten; //유니티 내장 변수 _LightColor0
			final.a = s.Alpha;
			return final;
		}

		ENDCG
	}
	FallBack "Diffuse"
}
