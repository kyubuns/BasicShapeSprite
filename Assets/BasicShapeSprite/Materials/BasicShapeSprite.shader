Shader "BasicShapeSprite/Unlit"
{
    Properties
    {
        _Smooth ("Smooth", Float) = 0.01
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
                float4 uv : TEXCOORD0;
                float4 uv2 : TEXCOORD1;
                float2 uv3 : TEXCOORD2;
            };

            struct v2f
            {
                float4 position : SV_POSITION;
                fixed4 color : COLOR;
                float2 uv : TEXCOORD0;
                float2 wh : TEXCOORD1;
                float4 round : TEXCOORD2;
                float border : TEXCOORD3;
            };

            float _Smooth;

            v2f vert (appdata v)
            {
                v2f o;
                o.position = UnityObjectToClipPos(v.vertex);
                o.color = v.color;
                o.uv = v.uv.xy;
                o.wh = v.uv.zw;
                o.round = v.uv2;
                o.border = v.uv3.x;
                return o;
            }

            fixed checkBL(v2f i)
            {
                fixed round = i.round[0];
                fixed r1 = distance(i.uv, fixed2(round, round));
                fixed ss1 = 1 - smoothstep(round, round + _Smooth, r1);
                fixed ss2 = smoothstep(round - i.border - _Smooth, round - i.border, r1);

                fixed ss = ss1 * ss2;
                fixed xx = step(i.uv.x, round);
                fixed yy = step(i.uv.y, round);
                return ss * xx * yy;
            }

            fixed checkTL(v2f i)
            {
                fixed round = i.round[1];
                fixed r1 = distance(i.uv, fixed2(round, i.wh.y - round));
                fixed ss1 = 1 - smoothstep(round, round + _Smooth, r1);
                fixed ss2 = smoothstep(round - i.border - _Smooth, round - i.border, r1);

                fixed ss = ss1 * ss2;
                fixed xx = step(i.uv.x, round);
                fixed yy = step(i.wh.y - i.uv.y, round);
                return ss * xx * yy;
            }

            fixed checkBR(v2f i)
            {
                fixed round = i.round[2];
                fixed r1 = distance(i.uv, fixed2(i.wh.x - round, round));
                fixed ss1 = 1 - smoothstep(round, round + _Smooth, r1);
                fixed ss2 = smoothstep(round - i.border - _Smooth, round - i.border, r1);

                fixed ss = ss1 * ss2;
                fixed xx = step(i.wh.x - i.uv.x, round);
                fixed yy = step(i.uv.y, round);
                return ss * xx * yy;
            }

            fixed checkTR(v2f i)
            {
                fixed round = i.round[3];
                fixed r1 = distance(i.uv, fixed2(i.wh.x - round, i.wh.y - round));
                fixed ss1 = 1 - smoothstep(round, round + _Smooth, r1);
                fixed ss2 = smoothstep(round - i.border - _Smooth, round - i.border, r1);

                fixed ss = ss1 * ss2;
                fixed xx = step(i.wh.x - i.uv.x, round);
                fixed yy = step(i.wh.y - i.uv.y, round);
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
                fixed bl = step(i.round[0], i.uv.x) + step(i.round[0], i.uv.y);
                fixed tl = step(i.round[1], i.uv.x) + step(i.round[1], i.wh.y - i.uv.y);
                fixed br = step(i.round[2], i.wh.x - i.uv.x) + step(i.round[2], i.uv.y);
                fixed tr = step(i.round[3], i.wh.x - i.uv.x) + step(i.round[3], i.wh.y - i.uv.y);
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
