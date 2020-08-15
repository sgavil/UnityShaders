Shader "Custom/FakeBRDF"
{
	Properties
	{
		_EmissiveColor("Emissive Color", Color) = (1,1,1,1)
		_AmbientColor("Ambient Color", Color) = (1,1,1,1)
		_MySliderValue("This is a Slider", Range(0,10)) = 2.5
		_RampTex("Ramp Texture", 2D) = "" {}
	}
		SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf BasicDiffuse

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		//Property attributes
		float4 _EmissiveColor;
		float4 _AmbientColor;
		float _MySliderValue;
		sampler2D  _RampTex;

	

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

		inline float4 LightingBasicDiffuse(SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
			float difLight = dot(s.Normal, lightDir);
			float rimLight = dot(s.Normal, viewDir);
			float hLambert = difLight * 0.5 + 0.5; //Se pasa de valores 0-1 a valores 0.5 -1
			float3 ramp = tex2D(_RampTex, float2(hLambert, rimLight)).rgb;
			float4 col;
			col.rgb = s.Albedo * _LightColor0.rgb * (ramp);
			col.a = s.Alpha;
			return col;
		}

		void surf(Input IN, inout SurfaceOutput o)
		{
			float4 c;
			c = pow((_EmissiveColor + _AmbientColor), _MySliderValue);
			o.Albedo = c.rgb;
			o.Alpha = c.a;

			// Albedo comes from a texture tinted by color
			//fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			//o.Albedo = c.rgb;
			//// Metallic and smoothness come from slider variables
			//o.Metallic = _Metallic;
			//o.Smoothness = _Glossiness;
			//o.Alpha = c.a;
		}
		ENDCG
	}
		FallBack "Diffuse"
}
