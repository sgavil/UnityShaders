Shader "Custom/ScrollTexture"
{
    Properties
    {
        _MainTint("Diffuse Tint", Color) = (1,1,1,1)
        _MainTex("Base (RGB)", 2D) = "white" {}
        _ScrollSpeedX("X Scroll Speed", Range(0,10)) = 2
        _ScrollSpeedY("Y Scroll Speed", Range(0,10)) = 2
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        fixed4 _MainTint;
       sampler2D _MainTex;
        fixed _ScrollSpeedX;
        fixed _ScrollSpeedY;


        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed2 scrolledUV = IN.uv_MainTex;

            fixed xScrollValue = _ScrollSpeedX * _Time;
            fixed yScrollValue = _ScrollSpeedY * _Time ;

            scrolledUV+= fixed2(xScrollValue,yScrollValue);

            half4 c = tex2D(_MainTex,scrolledUV);
            o.Albedo = c.rgb * _MainTint;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
