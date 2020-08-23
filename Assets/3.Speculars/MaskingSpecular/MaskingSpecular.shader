Shader "Custom/MaskingSpecular"
{
    Properties
    {
        _MainTint ("Diffuse tint", Color) = (1,1,1,1)
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _SpecularColor ("Specular tint", Color) = (1,1,1,1)
        _SpecularMask("Specular texture", 2D) = "white" {}
        _SpecPower ("Specular power", Range(0.1,120)) = 3
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf CustomPhong

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _SpecularMask;
        float4 _MainTint;
        float4 _SpecularColor;
        float _SpecPower;

        struct SurfaceCustomOutput{
            fixed3 Albedo;
            fixed3 Normal;
            fixed3 Emission;
            fixed3 SpecularColor;
            half Specular;
            fixed Gloss;
            fixed Alpha;
        };

        inline fixed4 LightingCustomPhong(SurfaceCustomOutput s,fixed3 lightDir, half3 viewDir, fixed atten){
            //Calculate de diff and reflection vector
            float diff = dot(s.Normal,lightDir);
            float3 reflectionVector = normalize(2.0 * s.Normal * diff - lightDir);

            //Calculate de phong specular
            float spec = pow(max(0.0f,dot(reflectionVector,viewDir)),_SpecPower) * s.Specular;
            float3 finalSpec = s.SpecularColor * spec * _SpecularColor.rgb;

            //Final color
            fixed4 c;
            c.rgb = (s.Albedo * _LightColor0.rgb * diff) + (_LightColor0.rgb * finalSpec);
            c.a = s.Alpha;
            return c;
        }

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_SpecularMask;
        };

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceCustomOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _MainTint;
            float4 specMask = tex2D(_SpecularMask, IN.uv_SpecularMask) * _SpecularColor;

            o.Albedo = c.rgb;
            o.Specular = specMask.r;
            o.SpecularColor = specMask.rgb;
            o.Alpha = c.a;
            
        }
        ENDCG
    }
    FallBack "Diffuse"
}
