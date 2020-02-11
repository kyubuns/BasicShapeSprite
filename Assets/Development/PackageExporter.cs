using System.IO;
using UnityEngine;
using UnityEditor;

namespace Development
{
    public static class PackageExporter
    {
        [MenuItem("Export/Export Unity Package")]
        public static void ExportUnityPackage()
        {
            var libraryDirectories = new[]
            {
                "Assets/BasicShapeSprite"
            };

            var outputFilePath = Path.Combine(Path.GetDirectoryName(Application.dataPath), "BasicShapeSprite.unitypackage");

            Debug.LogFormat("Export package to {0}", outputFilePath);
            AssetDatabase.ExportPackage(libraryDirectories, outputFilePath, ExportPackageOptions.Recurse);
            Debug.LogFormat("Success");
        }
    }
}
