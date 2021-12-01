Shader "Custom/HologramShader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert noambient alpha:fade
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            float rim = saturate(dot(o.Normal, IN.viewDir));
            //o.Albedo = c.rgb;
            o.Emission = float3(0, 1, 0);
            rim = pow(1 - rim, 3);

            //o.Alpha = rim * abs(sin(_Time.y * 3) * 0.5 + 0.5);
            o.Alpha = rim * abs(sin(_Time.y * 3) * 0.5 + 0.5);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
