Shader "BasicShapeSprite/Unlit"
{
    Properties
    {
    }

    SubShader
    {
        Tags {
            "RenderType"="Transparent"
            "Queue"="Transparent"
        }
        LOD 100

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
				float4 vertex : POSITION;
				fixed4 color : COLOR;
				float2 uv : TEXCOORD0;
				float2 uv2 : TEXCOORD1;
				float2 uv3 : TEXCOORD2;
            };

            struct v2f
            {
				float4 position : SV_POSITION;
				fixed4 color : COLOR;
				float2 uv : TEXCOORD0;
				float2 wh : TEXCOORD1;
				fixed round : TEXCOORD2;
            };

            v2f vert (appdata v)
            {
				v2f o;
				o.position = UnityObjectToClipPos(v.vertex);
				o.color = v.color;
                o.uv = v.uv;
                o.wh = v.uv2;
                o.round = v.uv3.x;
				return o;
            }

            fixed checkBL(v2f i)
            {
                fixed r = distance(i.uv, fixed2(i.round, i.round));
                fixed ss = 1 - smoothstep(i.round - 0.01, i.round, r);
                fixed xx = step(i.round, i.uv.x);
                fixed yy = step(i.round, i.uv.y);
                return max(max(xx, yy), ss);
            }

            fixed checkTL(v2f i)
            {
                fixed r = distance(i.uv, fixed2(i.round, i.wh.y - i.round));
                fixed ss = 1 - smoothstep(i.round - 0.01, i.round, r);
                fixed xx = step(i.round, i.uv.x);
                fixed yy = step(i.round, i.wh.y - i.uv.y);
                return max(max(xx, yy), ss);
            }

            fixed checkBR(v2f i)
            {
                fixed r = distance(i.uv, fixed2(i.wh.x - i.round, i.round));
                fixed ss = 1 - smoothstep(i.round - 0.01, i.round, r);
                fixed xx = step(i.round, i.wh.x - i.uv.x);
                fixed yy = step(i.round, i.uv.y);
                return max(max(xx, yy), ss);
            }

            fixed checkLR(v2f i)
            {
                fixed r = distance(i.uv, fixed2(i.wh.x - i.round, i.wh.y - i.round));
                fixed ss = 1 - smoothstep(i.round - 0.01, i.round, r);
                fixed xx = step(i.round, i.wh.x - i.uv.x);
                fixed yy = step(i.round, i.wh.y - i.uv.y);
                return max(max(xx, yy), ss);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = i.color;
                col.a = min(min(min(checkBL(i), checkTL(i)), checkBR(i)), checkLR(i));
                return col;
            }

            ENDCG
        }
    }
}
