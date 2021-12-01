Shader "Custom/TwoPassBaseShader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        //cull front //앞면을 자른다.
        //cull back //뒷면을 자른다.
        //cull off //자르지 않는다.

        //vertex:vert 추가 해줄것! vert라는 이름의 함수가 필요!
        //appdata_ base/tan/full 구조체를 받아와야 한다.
        //#pragma surface ... vertex:vert
        
        /*
        * 
        * vert 매개변수 구조체
        * 
        struct appdata_base {
            float4 vertex : POSITION;
            float3 normal : NORMAL;
            float4 texcoord : TEXCOORD0;
            UNITY_VERTEX_INPUT_INSTANCE_ID
        };

        struct appdata_tan {
            float4 vertex : POSITION;
            float4 tangent : TANGENT;
            float3 normal : NORMAL;
            float4 texcoord : TEXCOORD0;
            UNITY_VERTEX_INPUT_INSTANCE_ID
        };

        struct appdata_full {
            float4 vertex : POSITION;
            float4 tangent : TANGENT;
            float3 normal : NORMAL;
            float4 texcoord : TEXCOORD0;
            float4 texcoord1 : TEXCOORD1;
            float4 texcoord2 : TEXCOORD2;
            float4 texcoord3 : TEXCOORD3;
            fixed4 color : COLOR;
            UNITY_VERTEX_INPUT_INSTANCE_ID
        };
        */

        //appdata_base : position, normal and one texture coordinate
        //vertex, normal, texcoord

        //appdata_tan : position, tangent, normal and one texture coordinate
        //vertex, tangent, normal, texcoord

        //appdata_full : position, tangent, normal, four texture coordinates and color
        //vertex, tangent, normal, texcoord, texcoord1, texcoord2, texcoord3, color

        cull front

        //1st Pass
        CGPROGRAM
        #pragma surface surf Lambert vertex:vert noshadow noambient

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void vert(inout appdata_full v) {
            v.vertex.xyz = v.vertex.xyz + v.normal.xyz * 0.01;
        }

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG

        //2st Pass
        /*CGPROGRAM
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
        ENDCG*/
    }
    FallBack "Diffuse"
}