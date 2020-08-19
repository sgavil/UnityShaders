using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR;

public class ProceduralTexture : MonoBehaviour
{
    public int texSize = 512;
    public Texture2D generatedTexture;
    public Material currentMaterial;

    private Vector2 centerPosition;


    // Start is called before the first frame update
    void Start()
    {
        if (currentMaterial)
        {
            centerPosition = new Vector2(.5f, .5f);
            generatedTexture = GenerateParabola();

            currentMaterial.SetTexture("_MainTex", generatedTexture);
        }
    }

    Texture2D GenerateParabola()
    {
        Texture2D proceduralTexture = new Texture2D(texSize, texSize);

        Vector2 centeredPixelPos = centerPosition * texSize;

        for (int i = 0; i < texSize; i++)
        {
            for (int j  = 0; j < texSize; j++)
            {
                Vector2 currenPosition = new Vector2(i, j);
                float pixelDistance = Vector2.Distance(currenPosition, centeredPixelPos) / (texSize * 0.5f);

                pixelDistance = Mathf.Abs(1 - Mathf.Clamp(pixelDistance, 0.0f, 1.0f));


                //Dot product of pixel dir
                Vector2 pixelDir = centeredPixelPos - currenPosition;
                pixelDir.Normalize();
                float rightDir = Vector2.Dot(pixelDir, Vector2.right);
                float leftDir = Vector2.Dot(pixelDir, Vector2.left);
                float upDir = Vector2.Dot(pixelDir, Vector2.up);

                
                //Cirlces from center
                //pixelDistance = Mathf.Sin(pixelDistance * 30) * pixelDistance;

                Color pixelColor = new Color(rightDir, leftDir, upDir, 1.0f);
                proceduralTexture.SetPixel(i, j, pixelColor);
            }
        }

        proceduralTexture.Apply();
        return proceduralTexture;
    }
}
