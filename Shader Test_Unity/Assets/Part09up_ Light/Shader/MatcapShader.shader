Shader "Custom/MatcapShader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap("Normal Map", 2D) = "bump" {}
        _Matcap("Matcap", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf nolight noambient

        sampler2D _MainTex;
        sampler2D _Matcap;
        sampler2D _BumpMap;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
            float3 worldNormal;
            INTERNAL_DATA
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            float3 worldNormal = WorldNormalVector(IN, o.Normal);
            float3 viewNormal = mul((float3x3)UNITY_MATRIX_V, worldNormal);
            float2 matcapUV = viewNormal.xy * 0.5 + 0.5;
            o.Emission = tex2D(_Matcap, matcapUV) * c.rgb;
            o.Alpha = c.a;
        }

        float4 Lightingnolight(SurfaceOutput s, float3 lightDir, float atten)
        {
            return float4(0, 0, 0, s.Alpha);
        }
        ENDCG
    }
    FallBack "Diffuse"
}

//Shader "Custom/MatcapShader"
//{
//    Properties
//    {
//        _MainTex ("Albedo (RGB)", 2D) = "white" {}
//        _Matcap("Matcap", 2D) = "white" {}
//    }
//    SubShader
//    {
//        Tags { "RenderType"="Opaque" }
//
//        CGPROGRAM
//        #pragma surface surf nolight noambient
//
//        sampler2D _MainTex;
//        sampler2D _Matcap;
//
//        struct Input
//        {
//            float2 uv_MainTex;
//            float3 worldNormal;
//        };
//
//        void surf (Input IN, inout SurfaceOutput o)
//        {
//            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
//
//            //[step 1 start]
//            //기본 뷰노멀 확인
//            //노멀값은 -1 ~ 1 로 0 ~ 1 로 만들어주기 위해선 *0.5 + 0.5 를 해주어야함 
//            //float3 viewNormal = mul((float3x3)UNITY_MATRIX_V, IN.worldNormal.rgb);
//            //o.Emission = viewNormal.x;
//            //o.Alpha = c.a;
//            //[step 1 end]
//
//            float3 viewNormal = mul((float3x3)UNITY_MATRIX_V, IN.worldNormal.rgb);
//            float2 matcapUV = viewNormal.xy * 0.5 + 0.5;
//            o.Emission = tex2D(_Matcap, matcapUV) * c.rgb;
//            o.Alpha = c.a;
//        }
//
//        float4 Lightingnolight(SurfaceOutput s, float3 lightDir, float atten)
//        {
//            return float4(0, 0, 0, s.Alpha);
//        }
//        ENDCG
//    }
//    FallBack "Diffuse"
//}
