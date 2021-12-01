Shader "Custom/Normal Extrusion" 
{
    Properties
    {
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _NormalMap("Normal Map", 2D) = "bump" {}
        _Amount("Extrusion Amount", Range(-1, 1)) = 0
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        CGPROGRAM
        #pragma surface surf Lambert vertex:vert

        struct Input 
        {
            float2 uv_MainTex;
            float2 uv_NormalMap;
        };

        float _Amount;

        void vert(inout appdata_full v) 
        {
            v.vertex.xyz += v.normal * _Amount;
        }

        sampler2D _MainTex;
        sampler2D _NormalMap;

        void surf(Input IN, inout SurfaceOutput o) 
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);

            o.Albedo = c.rgb;
            o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
            o.Alpha = c.a;
        }
        ENDCG
    }

    Fallback "Diffuse"
}