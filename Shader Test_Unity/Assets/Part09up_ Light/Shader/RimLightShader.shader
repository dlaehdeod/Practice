Shader "Custom/RimLightShader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap("Normal Map", 2D) = "bump" {}
        [HDR]_RimColor("RimColor", Color) = (1,1,1,1)
        _RimPower("RimPower", Range(0, 10)) = 3
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        
        #pragma surface surf Standard
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _BumpMap;
        float4 _RimColor;
        half _RimPower;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
            float3 viewDir; //내장 뷰 벡터
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);

            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            float rim = dot(o.Normal, IN.viewDir);
            
            //물체의 노멀값과 내장 뷰 벡터의 내적을 통해 밝기값을 가져오고,
            //1 - rim으로 결과를 뒤집어 준다. (밝은 곳은 어둡게 어두운 곳은 밝게)
            //이 후 해당 값을 제곱해주어 밝기를 조절한다.

            o.Emission = pow(1 - rim, _RimPower) * _RimColor;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
