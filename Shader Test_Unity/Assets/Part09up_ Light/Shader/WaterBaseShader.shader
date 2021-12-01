Shader "Custom/WaterBaseShader"
{
    Properties
    {
        _BumpMap("Normal Map", 2D) = "bump" {}
        _Cube("Cube Map", Cube) = "" {}
        _Alpha("Alpha Value", Range(0, 1)) = 0.5
        _RimPower("Rim Power", Range(0, 10)) = 3
        _Strength("Emission Strength", Range(0, 5)) = 2

        _RightSpeed ("Water RightSpeed", Range(0, 2)) = 0.6
        _LeftSpeed ("Water LeftSpeed", Range(0, 2)) = 0.3
    }
    SubShader
    {
        Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }

        CGPROGRAM
        #pragma surface surf Lambert alpha:fade

        sampler2D _BumpMap;
        samplerCUBE _Cube;
        fixed _Alpha;
        half _RimPower;
        half _Strength;
        half _RightSpeed;
        half _LeftSpeed;

        struct Input
        {
            float2 uv_BumpMap;
            float3 worldRefl;
            float3 viewDir;
            INTERNAL_DATA
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            float3 normal1 = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap + _Time.x * _RightSpeed));
            float3 normal2 = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap - _Time.x * _LeftSpeed));
            o.Normal = (normal1 + normal2) / 2;

            float3 refcolor = texCUBE(_Cube, WorldReflectionVector(IN, o.Normal));

            fixed rim = saturate(dot(o.Normal, IN.viewDir));
            rim = pow(1 - rim, _RimPower);
            o.Emission = refcolor * rim * _Strength;
            o.Alpha = saturate(rim + 0.5) * _Alpha;
        }

        ENDCG
    }
    FallBack "Legacy Shaders/Transparent/Vertexlit"
}
