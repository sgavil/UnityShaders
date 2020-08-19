Shader "Custom/Levels"
{
	Properties
	{
		_MainTex("Albedo (RGB)", 2D) = "white" {}

	//Input levels Values
	_inBlack("Input black", Range(0,255)) = 0
	_inGamma("Input gamma", Range(0,2)) = 1.61
	_inWhite("Input white", Range(0,255)) = 255

		//Output levels
		_outWhite("Output white", Range(0,255)) = 255
		_outBlack("Output black", Range(0,255)) = 0

	}
		SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		float _inBlack;
		float _inGamma;
		float _inWhite;
		float _outWhite;
		float _outBlack;

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

		float GetPixelLevel(float pixelColor){
			float pixelResult = pixelColor * 255;
			pixelResult = max(0,pixelResult - _inBlack);
			pixelResult = saturate(pow(pixelResult / (_inWhite -  _inBlack),_inGamma));
			pixelResult = (pixelResult * (_outWhite- _outBlack) + _outBlack) / 255.0;

			return pixelResult;
		}

		void surf(Input IN, inout SurfaceOutputStandard o)
		{
			half4 c = tex2D(_MainTex, IN.uv_MainTex);
			

			o.Albedo = float4(GetPixelLevel(c.r),GetPixelLevel(c.g),GetPixelLevel(c.b),c.a);
		}
		ENDCG
	}
		FallBack "Diffuse"
}
