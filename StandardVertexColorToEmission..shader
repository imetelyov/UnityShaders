Shader "Instanced/StandardVertexColorToEmission" {
	
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_SpecGlossMap("Specular", 2D) = "white" {}
		_Specular ("Specular Mult", Range (0, 1)) = .5
		_Smoothness ("Glossiness Mult", Range (0, 1)) = .5
		
        [Normal][NoScaleOffset] _BumpMap ("Normal", 2D) = "bump" {}
		_BumpScale ("BumpScale", Range (0, 4)) = 1
		
		[NoScaleOffset] _EmissionMap ("Emission Mask", 2D) = "bump" {}
	   	[HDR]_EmissionColor ("Emission Color", Color) = (1,1,1,1)
	
	}
	SubShader {
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha
		ZWrite Off 
		
		CGPROGRAM
		
		#pragma surface surf StandardSpecular nofog
		#pragma target 3.0
		#pragma multi_compile_instancing

		sampler2D _BumpMap;
		sampler2D _MainTex;
		sampler2D _SpecGlossMap;
		sampler2D _EmissionMap;
		sampler2D _EmissionTex;

		struct Input {
			float2 uv_MainTex;
			fixed4 color : COLOR;
		};
		
		half4 _EmissionColor;
		half4 _Color;
		half _BumpScale;
		half _Smoothness;
		half _Specular;

		void surf (Input IN, inout SurfaceOutputStandardSpecular o) {
			
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * UNITY_ACCESS_INSTANCED_PROP(_Color);
			
			clip(c.a-.01);
			
			o.Albedo = c.rgb;
			o.Alpha = c.a;
			
			o.Normal = UnpackScaleNormal(tex2D (_BumpMap, IN.uv_MainTex.xy), _BumpScale);
			o.Specular = tex2D(_SpecGlossMap, IN.uv_MainTex);
			o.Smoothness = _Smoothness;
			o.Emission = _EmissionColor * IN.color.rgb * tex2D(_EmissionMap, IN.uv_MainTex) * IN.color.a;
			// c.a = o.Alpha;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
