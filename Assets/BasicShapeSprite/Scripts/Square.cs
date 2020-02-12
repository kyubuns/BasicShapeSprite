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
        [SerializeField] public float round;
        [SerializeField] public float border;
        [SerializeField] public bool topLeft = true;
        [SerializeField] public bool topRight = true;
        [SerializeField] public bool bottomLeft = true;
        [SerializeField] public bool bottomRight = true;

        private Mesh _mesh;
        private Vector3 _cachedScale;

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

            round = Mathf.Clamp(round, 0.0f, Mathf.Min(scale.x, scale.y) / 2f);
            border = Mathf.Clamp(border, 0.0f, Mathf.Min(scale.x, scale.y) / 2f);
            var tmpBorder = border;
            if (Mathf.Approximately(tmpBorder, 0.0f)) tmpBorder = Mathf.Min(scale.x, scale.y) / 2f;

            _mesh.colors = new[]
            {
                color,
                color,
                color,
                color,
            };

            _mesh.SetUVs(0, new List<Vector4>
            {
                new Vector4(0f, 0f, scale.x, scale.y),
                new Vector4(scale.x, 0f, scale.x, scale.y),
                new Vector4(0f, scale.y, scale.x, scale.y),
                new Vector4(scale.x, scale.y, scale.x, scale.y),
            });

            _mesh.SetUVs(1, new List<Vector2>
            {
                new Vector2(round, tmpBorder),
                new Vector2(round, tmpBorder),
                new Vector2(round, tmpBorder),
                new Vector2(round, tmpBorder),
            });

            _mesh.SetUVs(2, new List<Vector4>
            {
                new Vector4(bottomLeft ? 1f : 0f, topLeft ? 1f : 0f, bottomRight ? 1f : 0f, topRight ? 1f : 0f),
                new Vector4(bottomLeft ? 1f : 0f, topLeft ? 1f : 0f, bottomRight ? 1f : 0f, topRight ? 1f : 0f),
                new Vector4(bottomLeft ? 1f : 0f, topLeft ? 1f : 0f, bottomRight ? 1f : 0f, topRight ? 1f : 0f),
                new Vector4(bottomLeft ? 1f : 0f, topLeft ? 1f : 0f, bottomRight ? 1f : 0f, topRight ? 1f : 0f),
            });
        }
    }
}
