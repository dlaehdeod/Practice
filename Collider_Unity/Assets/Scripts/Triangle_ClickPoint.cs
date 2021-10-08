using UnityEngine;
using UnityEngine.UI;

public class Triangle_ClickPoint : MonoBehaviour
{
    public Raycast_UI raycast_UI;
    public Material triangleMaterial;
    public Toggle toggle_pivotCenter;
    public InputField inputField_triangleSize;
    public LineRenderer triangleLineRenderer;
    
    public Text coordinateText;
    public Text resultText;
    public float triangleSize;
    public Color outColor;
    public Color inColor;
    public bool isSimulating;

    private Vector3[] trianglePositions;
    private bool isPivotCenter;
    private bool isDrag;

    public Vector3[] GetTrianglePositions ()
    {
        Vector3[] positions = new Vector3[4];

        if (isPivotCenter)
        {
            Vector3 offset = new Vector3(-0.5f * triangleSize, -0.5f * triangleSize, 0.0f);

            for (int i = 0; i < 4; ++i)
            {
                positions[i] = trianglePositions[i] * triangleSize + offset;
            }
        }
        else
        {
            for (int i = 0; i < 4; ++i)
            {
                positions[i] = trianglePositions[i] * triangleSize;
            }
        }
        
        return positions;
    }

    public Vector3 GetClickPosition ()
    {
        Vector3 clickPosition = transform.position;
        clickPosition.z = 0.0f;

        return clickPosition;
    }
   
    
    private void Start()
    {
        isPivotCenter = toggle_pivotCenter.isOn;
        inputField_triangleSize.text = triangleSize.ToString();
        trianglePositions = new Vector3[4];
        trianglePositions[0] = new Vector3(0, 0, 0);
        trianglePositions[1] = new Vector3(1, 0, 0);
        trianglePositions[2] = new Vector3(0.5f, 1, 0);
        trianglePositions[3] = new Vector3(0, 0, 0);

        UpdateTriangleSize();
        ShowCoordinate();
    }

    private void Update()
    {
        if (isSimulating)
        {
            return;
        }

        if (Input.GetMouseButtonDown(0))
        {
            MouseButtonDown();
        }
        else if (Input.GetMouseButtonUp(0))
        {
            MouseButtonUp();
        }

        if (isDrag)
        {
            UpdatePositionAndText();
        }
    }

    private void MouseButtonDown ()
    {
        if (raycast_UI.IsSelectedUI())
        {
            return;
        }

        isDrag = true;
    }

    private void MouseButtonUp ()
    {
        isDrag = false;
    }

    private void UpdatePositionAndText ()
    {
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);

        transform.position = ray.origin;
        ShowCoordinate();
        InnerCheck();
    }

    private void InnerCheck()
    {
        /*
        
        A1 = (x1, y1, z1), A2 = (x2, y2, z2)
        E1 = (1, 0, 0), E2 = (0, 1, 0), E3 = (0, 0, 1)
        
        Vector3.Cross (A1, A2) =
                                (E1 E2 E3)
                                (x1 y1 z1)
                                (x2 y2 z2)

        Formula = E1 * (y1 * z2 - z1 * y2) +
                 -E2 * (x1 * z2 - z1 * x2) +
                  E3 * (x1 * y2 - y1 * x2)

        Vector2 Cross Formula = E3 * (x1 * y2 - y1 * x2)

        Result  > 0 : forward direction
        Result == 0 : same position
        Result  < 0 : back direction

        */

        Vector3 point = transform.position;
        point.z = 0.0f;

        if (isPivotCenter)
        {
            point += new Vector3(0.5f * triangleSize, 0.5f * triangleSize, 0.0f);
        }

        for (int i = 0; i < 3; ++i)
        {
            Vector3 baseLine = trianglePositions[i + 1] * triangleSize - trianglePositions[i] * triangleSize;
            Vector3 targetPosition = point - trianglePositions[i] * triangleSize;

            float cross = baseLine.x * targetPosition.y - baseLine.y * targetPosition.x;

            if (cross < 0)
            {
                triangleMaterial.SetColor("_EmissionColor", outColor);
                resultText.text = "Outer";
                return;
            }
        }

        triangleMaterial.SetColor("_EmissionColor", inColor);
        resultText.text = "Inner";
    }

    private void ShowCoordinate ()
    {
        coordinateText.text = string.Format("({0}, {1})", transform.position.x, transform.position.y);

        Vector3 textPosition = transform.position;
        textPosition.y += 0.5f;
        textPosition.z = 0.0f;

        coordinateText.transform.position = textPosition;
    }


    private void UpdateTriangleSize ()
    {
        if (isPivotCenter)
        {
            Vector3 offset = new Vector3(-0.5f * triangleSize, -0.5f * triangleSize, 0.0f);
            
            for (int i = 0; i < 4; ++i)
            {
                triangleLineRenderer.SetPosition(i, trianglePositions[i] * triangleSize + offset);
            }
        }
        else
        {
            for (int i = 0; i < 4; ++i)
            {
                triangleLineRenderer.SetPosition(i, trianglePositions[i] * triangleSize);
            }
        }

        InnerCheck();
    }

    #region Call By UI

    public void Toggle_ValueChanged()
    {
        isPivotCenter = toggle_pivotCenter.isOn;

        UpdateTriangleSize();
    }

    public void InputField_EndEdit()
    {
        string text = inputField_triangleSize.text;

        if (float.TryParse(text, out triangleSize) == false)
        {
            triangleSize = 1;
        }

        UpdateTriangleSize();
    }

    #endregion
}