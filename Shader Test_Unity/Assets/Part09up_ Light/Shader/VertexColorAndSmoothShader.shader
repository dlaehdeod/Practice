Shader "Custom/VertexColorAndSmoothShader"
{
    Properties
    {
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _BumpMap("NormalMap", 2D) = "bump" {}
        _Smooth("Smooth", Range(0, 1)) = 0.5
        _Metallic("Metallic", Range(0, 1)) = 0
    }
        SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard

        sampler2D _MainTex;
        sampler2D _BumpMap;
        fixed _Smooth;
        fixed _Metallic;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
            float4 color:COLOR;
        };

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            o.Smoothness = _Smooth * 0.3;
            o.Metallic = _Metallic;
            o.Alpha = c.a;
        }
        ENDCG
    }
        FallBack "Diffuse"
}
