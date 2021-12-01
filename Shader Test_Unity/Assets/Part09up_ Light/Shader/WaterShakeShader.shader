Shader "Custom/WaterShakeShader"
{
    Properties
    {
        _BumpMap("Normal Map", 2D) = "bump" {}
        _Cube("Cube Map", Cube) = "" {}
        _Alpha("Alpha Value", Range(0, 1)) = 0.5
        _RimPower("Rim Power", Range(0, 10)) = 1
        _Strength("Emission Strength", Range(0, 5)) = 2.3
        _SPColor("Specular Color", Color) = (1, 1, 1, 1)
        _SPPower("Specular Power", Range(0, 100)) = 30
        _SPMulti("Specular Multiply", Range(1, 10)) = 3

        [Header(Wave Control)][Space]
        _WaveHeight("Wave Height", Range(0, 5)) = 0.5
        _WaveLength("Wave Length", Range(0, 20)) = 7
        _WaveTimeing("Wave Timeing", Range(0, 10)) = 2
    }
        SubShader
        {
            Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }

            CGPROGRAM
            #pragma surface surf WaterSpecular alpha:fade vertex:vert

            sampler2D _BumpMap;
            samplerCUBE _Cube;
            fixed _Alpha;
            half _RimPower;
            half _Strength;

            float4 _SpColor;
            half _SPPower;
            half _SPMulti;

            half _WaveHeight;
            half _WaveLength;
            half _WaveTimeing;

            void vert(inout appdata_full v)
            {
                float movement;
                movement = sin(abs((v.texcoord.x * 2 - 1) * _WaveLength) + _Time.y * _WaveTimeing) * _WaveHeight;
                movement = sin(abs((v.texcoord.y * 2 - 1) * _WaveLength) + _Time.y * _WaveTimeing) * _WaveHeight;
                v.vertex.y = movement * 0.5;
            }

            struct Input
            {
                float2 uv_BumpMap;
                float3 worldRefl;
                float3 viewDir;
                INTERNAL_DATA
            };

            void surf(Input IN, inout SurfaceOutput o)
            {
                float3 normal1 = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap + _Time.x * 0.6));
                float3 normal2 = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap - _Time.x * 0.3));
                o.Normal = (normal1 + normal2) / 2;

                float3 refcolor = texCUBE(_Cube, WorldReflectionVector(IN, o.Normal));

                fixed rim = saturate(dot(o.Normal, IN.viewDir));
                rim = pow(1 - rim, _RimPower);
                o.Emission = refcolor * rim * _Strength;
                o.Alpha = saturate(rim + 0.5) * _Alpha;
            }

            float4 LightingWaterSpecular(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
            {
                float3 H = normalize(lightDir + viewDir);
                float spec = saturate(dot(H, s.Normal));
                spec = pow(spec, _SPPower);

                float4 final;
                final.rgb = spec * _SpColor * _SPMulti;
                final.a = s.Alpha + spec;

                return final;
            }
            ENDCG
        }
            FallBack "Legacy Shaders/Transparent/Vertexlit"
}
