using System;
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

            _mesh.colors = new[]
            {
                color,
                color,
                color,
                color,
            };

            _mesh.uv = new[]
            {
                new Vector2(0f, 0f),
                new Vector2(scale.x, 0f),
                new Vector2(0f, scale.y),
                new Vector2(scale.x, scale.y),
            };

            _mesh.uv2 = new[]
            {
                new Vector2(scale.x, scale.y),
                new Vector2(scale.x, scale.y),
                new Vector2(scale.x, scale.y),
                new Vector2(scale.x, scale.y),
            };

            _mesh.uv3 = new[]
            {
                new Vector2(round, 0f),
                new Vector2(round, 0f),
                new Vector2(round, 0f),
                new Vector2(round, 0f),
            };
        }
    }
}
