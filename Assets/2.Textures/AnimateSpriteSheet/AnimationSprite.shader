Shader "Custom/AnimationSprite"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _TexWidth("Sheet Width",float) = 0.0
        _CellAmount("Cell Amount",float) = 0.0
        _Speed("Speed",Range(0.01,32)) = 12
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

        sampler2D _MainTex;
        float _TexWidth;
        float _CellAmount;
        float _Speed;

        struct Input
        {
            float2 uv_MainTex;
        };


        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float2 spriteUV = IN.uv_MainTex;

            //Ancho de cada sprite
            float cellPixelWidth = _TexWidth / _CellAmount;

            //Como el UV va de 0 a 1 necesitamos encontrar el porcentaje de parte que ocupa cada celda
            float cellUVPercentage = cellPixelWidth / _TexWidth;

            float timeVal = fmod(_Time.y * _Speed, _CellAmount);
            timeVal = ceil(timeVal);

            float xValue = spriteUV.x;
            xValue+= cellUVPercentage * timeVal * _CellAmount;
            xValue *= cellUVPercentage;

            spriteUV = float2(xValue,spriteUV.y);

            half4 c = tex2D(_MainTex,spriteUV);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
