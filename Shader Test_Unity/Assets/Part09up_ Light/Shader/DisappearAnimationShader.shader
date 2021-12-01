Shader "Custom/DisappearAnimationShader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _NoiseTex("Noise Texture", 2D) = "white" {}
        _Cut("Alpha Cut", Range(0, 1)) = 0
        _OutlineSize("Outline Size", Range(0, 5)) = 1
        [HDR]_OutlineColor("Outline Color", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
       
        zwrite on
        ColorMask 0

        CGPROGRAM
        #pragma surface surf nolight noambient noforwardadd nolightmap novertexlights noshadow
        struct Input
        {
            float4 color:COLOR;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
        }

        float4 Lightingnolight(SurfaceOutput s, float3 lightDir, float atten)
        {
            return float4(0, 0, 0, 0);
        }
        ENDCG

        zwrite off
        CGPROGRAM
        
        #pragma surface surf Lambert alpha:fade

        sampler2D _MainTex;
        sampler2D _NoiseTex;
        float4 _OutlineColor; 
        half _OutlineSize; 
        fixed _Cut;
        
        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NoiseTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            fixed4 noise = tex2D(_NoiseTex, IN.uv_NoiseTex);
          
            fixed alpha;
            if (noise.r >= _Cut)
            {
                alpha = 1;
            }
            else
            {
                alpha = 0;
            }

            fixed outline;
            if (noise.r >= _Cut * _OutlineSize)
            {
                outline = 0;
            }
            else
            {
                outline = 1;
            }
            o.Albedo = c.rgb + (_OutlineColor * outline);
            
            /*o.Albedo = c.rgb;
            o.Emission = _OutlineColor * outline;*/
            
            o.Alpha = alpha;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
