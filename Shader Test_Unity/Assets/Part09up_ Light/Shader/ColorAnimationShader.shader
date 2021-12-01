Shader "Custom/ColorAnimationShader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _MaskTex("Mask Texture", 2D) = "white" {}
        _RampTex("Ramp Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
       
        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;
        sampler2D _MaskTex;
        sampler2D _RampTex;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_MaskTex;
            float2 uv_RampTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            //마스크에 채널 값이 들어가있어야한다.
            fixed4 mask = tex2D (_MaskTex, IN.uv_MaskTex);
            //ramp는 애니메이션 속도를 조절하기 위해서 사용된다
            fixed4 ramp = tex2D(_RampTex, float2(_Time.y, 0.5));

            o.Albedo = c.rgb;
            o.Emission = c.rgb * mask.r * ramp.r;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
