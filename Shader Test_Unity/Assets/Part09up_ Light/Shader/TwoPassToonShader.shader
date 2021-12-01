Shader "Custom/TwoPassToonShader"
{
    Properties
    {
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _BumpMap("NormalMap", 2D) = "bump" {}
        _OuterSize("Outer Size", Range(0, 1)) = 0.01
        _OuterCol("Outer Color", color) = (0, 0, 0, 1)
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
        #pragma surface surf Toon noambient

        sampler2D _MainTex;
        sampler2D _BumpMap;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }

        float4 LightingToon(SurfaceOutput s, float3 lightDir, float atten) {
            float ndotl = dot(s.Normal, lightDir) * 0.5 + 0.5;

            ndotl = ndotl * 2;
            ndotl = ceil(ndotl) / 2;

            float4 final;
            final.rgb = s.Albedo * ndotl * _LightColor0.rgb;
            final.a = s.Alpha;

            return final;
        }
        ENDCG
    }
    FallBack "Diffuse"
}