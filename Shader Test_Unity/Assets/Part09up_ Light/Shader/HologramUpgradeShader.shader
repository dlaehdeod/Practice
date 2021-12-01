Shader "Custom/HologramUpgradeShader"
{
    Properties
    {
        _MainTex("Albedo (RGB)", 2D) = "white" {}
    }
        SubShader
    {
        Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert noambient alpha:fade
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
            float3 worldPos;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            float rim = saturate(dot(o.Normal, IN.viewDir));
            
            //frac() 0.0 ~0.9 값이 되도록 잘라줌
            //o.Emission = frac(IN.worldPos.g);

            //frac 전에 곱하기를 통해 라인의 수를 조절할 수 있다.
            //o.Emission = pow(frac(IN.worldPos.g * 0.5), 30);

            o.Emission = float3(0, 1, 0);
            rim = saturate(pow(1 - rim, 3) + pow(frac(IN.worldPos.g * 0.5 - _Time.y), 5) * 0.05);

            //o.Alpha = rim * abs(sin(_Time.y * 3) * 0.5 + 0.5);
            o.Alpha = rim;
        }

        float4 Lightingnolight(SurfaceOutput s, float3 lightDir, float atten) {
            return float4(0, 0, 0, s.Alpha);
        }
        ENDCG
    }
        FallBack "Diffuse"
}
