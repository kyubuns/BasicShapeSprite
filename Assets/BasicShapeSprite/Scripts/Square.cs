using System.Collections.Generic;
using UnityEngine;

namespace BasicShapeSprite
{
    [ExecuteInEditMode]
    [RequireComponent(typeof(MeshFilter))]
    [RequireComponent(typeof(MeshRenderer))]
    public class Square : MonoBehaviour
    {
        [SerializeField] public Color color;
        [SerializeField] public float topLeft;
        [SerializeField] public float topRight;
        [SerializeField] public float bottomLeft;
        [SerializeField] public float bottomRight;
        [SerializeField] public float border;

        private Mesh _mesh;
        private Vector3 _cachedScale;
        private readonly List<Color> _cachedColor = new List<Color> { default, default, default, default };
        private readonly List<Vector4> _cachedUv0 = new List<Vector4> { default, default, default, default };
        private readonly List<Vector4> _cachedUv1 = new List<Vector4> { default, default, default, default };
        private readonly List<Vector2> _cachedUv2 = new List<Vector2> { default, default, default, default };

        public void Start()
        {
            _mesh = new Mesh();

            _mesh.vertices = new[]
            {
                new Vector3(-0.5f, -0.5f, 0),
                new Vector3(0.5f, -0.5f, 0),
                new Vector3(-0.5f, 0.5f, 0),
                new Vector3(0.5f, 0.5f, 0),
            };

            _mesh.triangles = new[]
            {
                0, 2, 1,
                2, 3, 1,
            };

            UpdateMeshUv();
            GetComponent<MeshFilter>().mesh = _mesh;
        }

        public void OnValidate()
        {
            if (_mesh == null) return;
            UpdateMeshUv();
        }

        public void Update()
        {
            if (_cachedScale == transform.localScale) return;
            UpdateMeshUv();
        }

        private void UpdateMeshUv()
        {
            var scale = transform.localScale;
            _cachedScale = scale;

            topLeft = Mathf.Clamp(topLeft, 0.0f, Mathf.Min(scale.x, scale.y) / 2f);
            topRight = Mathf.Clamp(topRight, 0.0f, Mathf.Min(scale.x, scale.y) / 2f);
            bottomLeft = Mathf.Clamp(bottomLeft, 0.0f, Mathf.Min(scale.x, scale.y) / 2f);
            bottomRight = Mathf.Clamp(bottomRight, 0.0f, Mathf.Min(scale.x, scale.y) / 2f);
            border = Mathf.Clamp(border, 0.0f, Mathf.Min(scale.x, scale.y) / 2f);
            var tmpBorder = border;
            if (Mathf.Approximately(tmpBorder, 0.0f)) tmpBorder = Mathf.Min(scale.x, scale.y) / 2f;

            _cachedColor[0] = _cachedColor[1] = _cachedColor[2] = _cachedColor[3] = color;
            _mesh.SetColors(_cachedColor);

            _cachedUv0[0] = new Vector4(0f, 0f, scale.x, scale.y);
            _cachedUv0[1] = new Vector4(scale.x, 0f, scale.x, scale.y);
            _cachedUv0[2] = new Vector4(0f, scale.y, scale.x, scale.y);
            _cachedUv0[3] = new Vector4(scale.x, scale.y, scale.x, scale.y);
            _mesh.SetUVs(0, _cachedUv0);

            _cachedUv1[0] = _cachedUv1[1] = _cachedUv1[2] = _cachedUv1[3] = new Vector4(bottomLeft, topLeft, bottomRight, topRight);
            _mesh.SetUVs(1, _cachedUv1);

            _cachedUv2[0] = _cachedUv2[1] = _cachedUv2[2] = _cachedUv2[3] = new Vector2(tmpBorder, 0f);
            _mesh.SetUVs(2, _cachedUv2);
        }
    }
}
