    Shader "Custom/Alpha2PassShader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        
        //z버퍼를 통해 첫번째 윤곽을 그려주지 않으면 뒷면도 함께
        //투명 상태가 되어 출력이 된다.
        //1pass를 주석처리하고 실행해보면 결과를 알 수 있다.

        //[1pass] ColorMask 0은 최종 결과를 화면에 표시하지 않게 만든다.
        zwrite on
        ColorMask 0

        CGPROGRAM
        #pragma surface surf nolight noambient noforwardadd nolightmap novertexlights noshadow
        struct Input
        {
            float4 color:COLOR;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
        }

        float4 Lightingnolight(SurfaceOutput s, float3 lightDir, float atten)
        {
            return float4(0, 0, 0, 0);
        }
        ENDCG

        //[2pass]
        zwrite off
        CGPROGRAM
        #pragma surface surf Lambert alpha:fade

        sampler2D _MainTex;
        struct Input
        {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = 0.5;
        }

        ENDCG
    }
    FallBack "Diffuse"
}
