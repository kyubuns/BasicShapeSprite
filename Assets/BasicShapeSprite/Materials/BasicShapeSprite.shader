﻿Shader "BasicShapeSprite/Unlit"
{
    Properties
    {
    }

    SubShader
    {
        Tags
        {
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
                fixed border : TEXCOORD3;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.position = UnityObjectToClipPos(v.vertex);
                o.color = v.color;
                o.uv = v.uv;
                o.wh = v.uv2;
                o.round = v.uv3.x;
                o.border = v.uv3.y;
                return o;
            }

            fixed checkBL(v2f i)
            {
                fixed r1 = distance(i.uv, fixed2(i.round, i.round));
                fixed ss1 = 1 - step(i.round, r1);
                fixed ss2 = step(i.round - i.border, r1);

                fixed ss = ss1 * ss2;
                fixed xx = step(i.uv.x, i.round);
                fixed yy = step(i.uv.y, i.round);
                return ss * xx * yy;
            }

            fixed checkTL(v2f i)
            {
                fixed r1 = distance(i.uv, fixed2(i.round, i.wh.y - i.round));
                fixed ss1 = 1 - step(i.round, r1);
                fixed ss2 = step(i.round - i.border, r1);

                fixed ss = ss1 * ss2;
                fixed xx = step(i.uv.x, i.round);
                fixed yy = step(i.wh.y - i.uv.y, i.round);
                return ss * xx * yy;
            }

            fixed checkBR(v2f i)
            {
                fixed r1 = distance(i.uv, fixed2(i.wh.x - i.round, i.round));
                fixed ss1 = 1 - step(i.round, r1);
                fixed ss2 = step(i.round - i.border, r1);

                fixed ss = ss1 * ss2;
                fixed xx = step(i.wh.x - i.uv.x, i.round);
                fixed yy = step(i.uv.y, i.round);
                return ss * xx * yy;
            }

            fixed checkTR(v2f i)
            {
                fixed r1 = distance(i.uv, fixed2(i.wh.x - i.round, i.wh.y - i.round));
                fixed ss1 = 1 - step(i.round, r1);
                fixed ss2 = step(i.round - i.border, r1);

                fixed ss = ss1 * ss2;
                fixed xx = step(i.wh.x - i.uv.x, i.round);
                fixed yy = step(i.wh.y - i.uv.y, i.round);
                return ss * xx * yy;
            }

            fixed checkCenter(v2f i)
            {
                fixed a =
                    (1 - step(i.border, i.uv.x))
                    + (step(i.wh.x - i.border, i.uv.x))
                    + (1 - step(i.border, i.uv.y))
                    + (step(i.wh.y - i.border, i.uv.y))
                    ;
                fixed bl = step(i.round, i.uv.x) + step(i.round, i.uv.y);
                fixed tl = step(i.round, i.uv.x) + step(i.round, i.wh.y - i.uv.y);
                fixed br = step(i.round, i.wh.x - i.uv.x) + step(i.round, i.uv.y);
                fixed tr = step(i.round, i.wh.x - i.uv.x) + step(i.round, i.wh.y - i.uv.y);
                return min(a * bl * tl * br * tr, 1);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = i.color;
                col.a = checkCenter(i) + checkBL(i) + checkTL(i) + checkBR(i) + checkTR(i);
                return col;
            }

            ENDCG
        }
    }
}
