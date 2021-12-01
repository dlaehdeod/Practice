Shader "Custom/AlphaBlendShader"
{
    //알파블랜딩의 특징
    //0. 연산이 무겁다. 불완전하다.
    //1. 불투명(Opaque)은 먼저 그린다.
    //2. 반투명(Transparent)은 나중에 그린다.
    //3. 반투명끼리는 뒤에서부터 그린다.
    //4. 알파 소팅을 사용해도 (카메라와 물체의 피봇 거리) 완벽한 판별은 불가능 하다.
    //5. 4번에 의한 연산을 줄이기 위해 z버퍼는 무시한다. zwrite off
    
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        cull off
        zwrite off

        CGPROGRAM
        #pragma surface surf Lambert alpha:fade
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    //FallBack 을 통해 그림자를 인식하게 해준다.
    FallBack "Legacy Shaders/Transparent/VertexLit"
}
