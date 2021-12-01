Shader "Custom/AlphaTestingShader"
{
    Properties
    {
        //PC에선 알파블랜딩보다 빠르기 때문에 이런식으로 사용됨
        //_Color 는 코드에서 사용되지 않지만 그림자를 위해 유니티에서 이용한다.
        _Color("Main Color", Color) = (1, 1, 1, 1)
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _Cutoff("Alpha cutoff", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType" = "TransparentCutout" "Queue" = "AlphaTest" }

        CGPROGRAM
        #pragma surface surf Lambert alphatest:_Cutoff
        
        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }

    FallBack "Legacy Shaders/Transparent/Cutout/VertexLit"
}
