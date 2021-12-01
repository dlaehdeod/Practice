Shader "Custom/TwoPassOuterShader"
{
    Properties
    {
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _OuterSize ("Outer Size", Range(0, 0.05)) = 0.01
        _OuterCol ("Outer Color", color) = (0, 0, 0, 1)
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200

        cull front

        //1st Pass
        CGPROGRAM
        #pragma surface surf Nolight vertex:vert noshadow noambient
            
        fixed _OuterSize;
        fixed4 _OuterCol;

        struct Input {
            float4 color:COLOR;
        };

        void vert(inout appdata_full v) {
            v.vertex.xyz = v.vertex.xyz + v.normal.xyz * _OuterSize;
        }

        void surf(Input IN, inout SurfaceOutput o) {

        }

        float4 LightingNolight(SurfaceOutput s, float3 lightDir, float atten) {
            return _OuterCol;
        }
        ENDCG

        cull back

        //2st Pass
        CGPROGRAM
        #pragma surface surf Lambert

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
        FallBack "Diffuse"
}