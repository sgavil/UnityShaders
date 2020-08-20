Shader "Custom/PhongSpecular"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _MainColor ("Diffuse color", Color) = (1,1,1,1)
        _SpecColor("Specular color", Color) = (1,1,1,1)
        _SpecPower ("Specular Power", Range(0,30)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Phong

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        float4 _MainColor;
        float _SpecPower;

        struct Input
        {
            float2 uv_MainTex;
        };

    inline fixed4 LightingPhong(SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten){
        float diff = dot(s.Normal, lightDir);
        float3 reflectionVector = normalize(2.0 * s.Normal * diff - lightDir);

        float spec = pow (max(0,dot(reflectionVector,viewDir)) ,_SpecPower);
        float3 finalSpec = _SpecColor.rgb * spec;

        fixed4 c;
        c.rgb = (s.Albedo * _LightColor0.rgb * diff) + (_LightColor0.rgb * finalSpec);
        c.a = 1.0;
        return c;   


    }
        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            half4 c = tex2D(_MainTex,IN.uv_MainTex) * _MainColor;
            o.Specular = _SpecPower;
            o.Gloss = 1.0;
            o.Albedo = c;

        }
        ENDCG
    }
    FallBack "Diffuse"
}
