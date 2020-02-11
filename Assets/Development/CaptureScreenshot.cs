using System;
using System.IO;
using UnityEditor;
using UnityEngine;

namespace Development
{
    public class CaptureScreenshot
    {
        [MenuItem("Export/Capture")]
        public static void Capture()
        {
            var fileName = $"{DateTime.Now:yyyyMMdd-HHmmss}.png";
            var filePath = Path.Combine("Screenshot", fileName);
            ScreenCapture.CaptureScreenshot(filePath, 2);
            var assembly = typeof(EditorWindow).Assembly;
            var type = assembly.GetType("UnityEditor.GameView");
            var gameView = EditorWindow.GetWindow(type);
            gameView.Repaint();

            Debug.Log($"ScreenShot: {filePath}");
        }
    }
}
