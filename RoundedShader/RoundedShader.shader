///圆形Shader 、用来处理图片四个角为圆角 
Shader "Custom/RoundedShader" {
	Properties{
		_MainTex("Base (RGB)", 2D) = "white" {}
	///_RoundedRadius 为 半径
	_RoundedRadius("Raounded Radius", Range(0,1)) = 0.1
	} 
		SubShader{
		Tags{ "RenderType" = "Opaque" }
		LOD 200
		Blend SrcAlpha OneMinusSrcAlpha

		Pass{

		CGPROGRAM
#pragma vertex vert
#pragma fragment frag

		sampler2D _MainTex;
	float _RoundedRadius;

	struct appdata_t {
		float4 vertex : POSITION;
		float4 color : COLOR;
		float2 texcoord : TEXCOORD0;
	};
	struct v2f {
		float4 vertex : SV_POSITION;
		fixed4 color : COLOR;
		half2 texcoord : TEXCOORD0;
		float4 worldPosition : TEXCOORD1;
	};

	v2f vert(appdata_t IN) {
		v2f OUT;
		OUT.worldPosition = IN.vertex;
		OUT.vertex = mul(UNITY_MATRIX_MVP, OUT.worldPosition);
		OUT.texcoord = IN.texcoord;
		OUT.color = IN.color;
		return OUT;
	}

	fixed4 frag(v2f IN) : SV_Target{
		half4 color = (tex2D(_MainTex, IN.texcoord)) * IN.color;

		float r = _RoundedRadius;

		///左上角
		if (IN.texcoord.x < r && IN.texcoord.y < r)
		{
			if (pow((IN.texcoord.x - r), 2) + pow((IN.texcoord.y - r), 2) > pow(r, 2)) {
				color.a = 0;
			}
		}

		///右上角
		if (IN.texcoord.x >(1 - r) && IN.texcoord.y < r)
		{
			if (pow((IN.texcoord.x - (1 - r)), 2) + pow((IN.texcoord.y - r), 2) > pow(r, 2)) {
				color.a = 0;
			}
		}

		///左下角
		if (IN.texcoord.x < r && IN.texcoord.y >(1 - r))
		{
			if (pow((IN.texcoord.x - r), 2) + pow((IN.texcoord.y - (1 - r)), 2) > pow(r, 2)) {
				color.a = 0;
			}
		}

		///右下角
		if (IN.texcoord.x > (1 - r) && IN.texcoord.y > (1 - r))
		{
			if (pow((IN.texcoord.x - (1 - r)), 2) + pow((IN.texcoord.y - (1 - r)), 2) > pow(r, 2)) {
				color.a = 0;
			}
		}
		return color;
	}
		ENDCG
	}
	}
}
