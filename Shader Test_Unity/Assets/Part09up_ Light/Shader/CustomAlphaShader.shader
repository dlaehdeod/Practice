Shader "Custom/CustomAlphaShader"
{
    //blend options
    //One
    //Zero
    //SrcColor
    //SrcAlpha
    //DstColor
    //DstAlpha
    //OneMinusSrcColor
    //OneMinusSrcAlpha
    //OneMinusDstColor
    //OneMinusDstAlpha

    //keepalpha
    //기본 알파값 1.0을 원하지 않을때 사용

    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        zwrite off
        blend SrcAlpha oneMinusSrcAlpha

        CGPROGRAM
        #pragma surface surf Lambert keepalpha

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Legacy Shaders/Transparent/VertexLit"
}
