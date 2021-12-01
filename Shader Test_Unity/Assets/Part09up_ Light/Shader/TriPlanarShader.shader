Shader "Custom/TriPlanarShader"
{
    Properties
    {
        _MainTex ("Top Texture", 2D) = "white" {}
        _MainTexUV("tileU, tileV, offsetU, offsetV", vector) = (1, 1, 0, 0)
        _MainTex2("Side Texture", 2D) = "white" {}
        _MainTex2UV("tileU, tileV, offsetU, offsetV", vector) = (1, 1, 0, 0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        CGPROGRAM
        
        #pragma surface surf Standard

        sampler2D _MainTex;
        sampler2D _MainTex2;
        half4 _MainTexUV;
        half4 _MainTex2UV;

        struct Input
        {
            float3 worldPos;
            float3 worldNormal;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float2 topUV = float2(IN.worldPos.x, IN.worldPos.z);
            float2 frontUV = float2(IN.worldPos.x, IN.worldPos.y);
            float2 sideUV = float2(IN.worldPos.z, IN.worldPos.y);

            float4 topTex = tex2D(_MainTex, topUV * _MainTexUV.xy + _MainTexUV.zw);
            float4 frontTex = tex2D(_MainTex2, frontUV * _MainTex2UV.xy + _MainTex2UV.zw);
            float4 sideTex = tex2D(_MainTex2, sideUV * _MainTex2UV.xy + _MainTex2UV.zw);

            o.Albedo = lerp(topTex, frontTex, abs(IN.worldNormal.z));
            o.Albedo = lerp(o.Albedo, sideTex, abs(IN.worldNormal.x));
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
