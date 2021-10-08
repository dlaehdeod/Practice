using System.Collections;
using UnityEngine;
using UnityEngine.UI;

public class Triangle_Simulation : MonoBehaviour
{
    public Triangle_ClickPoint triangle_clickPoint;
    [Space]
    public LineRenderer[] simulationLineRenderers;
    [Space]
    public Transform[] lineDirectionArrow;
    [Space]
    public Text[] leftOrRightText;
    [Space]
    public Text simulationResultText;
    public Button startButton;
    public Button backButton;
    public Button stopButton;
    public Button progressButton;
    public float simulationSpeed = 2.0f;

    private bool isSimulating;
    private int simulationStep;

    private void Start()
    {
        simulationResultText.transform.parent.gameObject.SetActive(false);
        lineDirectionArrow[0].gameObject.SetActive(false);
        lineDirectionArrow[1].gameObject.SetActive(false);

        leftOrRightText[0].text = string.Empty;
        leftOrRightText[1].text = string.Empty;
        leftOrRightText[2].text = string.Empty;
    }

    private void ButtonActive()
    {
        backButton.interactable = simulationStep > 1;
        stopButton.interactable = true;
        progressButton.interactable = simulationStep < 3;

        startButton.interactable = false;
    }

    private void ButtonDeactive()
    {
        backButton.interactable = false;
        stopButton.interactable = false;
        progressButton.interactable = false;

        simulationResultText.transform.parent.gameObject.SetActive(false);
        leftOrRightText[0].text = string.Empty;
        leftOrRightText[1].text = string.Empty;
        leftOrRightText[2].text = string.Empty;

        lineDirectionArrow[0].gameObject.SetActive(false);
        lineDirectionArrow[1].gameObject.SetActive(false);

        simulationLineRenderers[0].gameObject.SetActive(false);
        simulationLineRenderers[1].gameObject.SetActive(false);

        startButton.interactable = true;
    }

    private void InitSimulation ()
    {
        simulationResultText.transform.parent.gameObject.SetActive(false);
        lineDirectionArrow[0].gameObject.SetActive(false);
        lineDirectionArrow[1].gameObject.SetActive(false);
        simulationLineRenderers[0].gameObject.SetActive(false);
        simulationLineRenderers[1].gameObject.SetActive(false);
    }

    private IEnumerator Progress ()
    {
        isSimulating = true;
        InitSimulation();

        Vector3[] positions = triangle_clickPoint.GetTrianglePositions();

        yield return null;

        Vector3 startPosition = positions[simulationStep - 1];
        Vector3 endPosition = positions[simulationStep];
        
        yield return StartCoroutine(MoveVector(simulationLineRenderers[0], lineDirectionArrow[0], startPosition, endPosition));

        endPosition = triangle_clickPoint.GetClickPosition();

        yield return  StartCoroutine(MoveVector(simulationLineRenderers[1], lineDirectionArrow[1], startPosition, endPosition));

        isSimulating = false;
        DeterminePosition();
    }

    private void DeterminePosition ()
    {
        Vector3[] positions = triangle_clickPoint.GetTrianglePositions();

        Vector3 startPosition = positions[simulationStep - 1];
        Vector3 endPosition = positions[simulationStep];
        Vector3 basePoint = endPosition - startPosition;
        
        endPosition = triangle_clickPoint.GetClickPosition();
        Vector3 clickPoint = endPosition - startPosition;

        float cross = basePoint.x * clickPoint.y - basePoint.y * clickPoint.x;
        //float cross = Vector3.Cross(basePoint, clickPoint).z;

        if (cross > 0)
        {
            leftOrRightText[simulationStep - 1].text = string.Format("[{0}] Is Left", simulationStep);
            simulationResultText.text = "Is Left";
        }
        else
        {
            leftOrRightText[simulationStep - 1].text = string.Format("[{0}] Is Right", simulationStep);
            simulationResultText.text = "Is Right";
        }

        simulationResultText.transform.parent.gameObject.SetActive(true);

        Vector3 resultPosition = Vector3.Lerp(startPosition, endPosition, 0.5f);
        resultPosition.z = -3.0f;

        simulationResultText.transform.parent.position = resultPosition;
    }

    private IEnumerator MoveVector (LineRenderer targetLineRenderer, Transform directionArrow, Vector3 startPosition, Vector3 endPosition)
    {
        float time = 0.0f;

        yield return null;

        Vector3 point = endPosition - startPosition;
        float arrowAngle = Mathf.Atan2(point.y, point.x) * Mathf.Rad2Deg;

        directionArrow.GetChild(0).eulerAngles = new Vector3(0, 0, 180 + arrowAngle);

        directionArrow.gameObject.SetActive(true);
        targetLineRenderer.SetPosition(0, startPosition);
        targetLineRenderer.SetPosition(1, startPosition);
        targetLineRenderer.gameObject.SetActive(true);

        while (time < 1)
        {
            time += Time.deltaTime * simulationSpeed;
            
            Vector3 lerpPosition = Vector3.Lerp(startPosition, endPosition, time);
            targetLineRenderer.SetPosition(1, lerpPosition);
            directionArrow.position = lerpPosition;
            
            yield return null;
        }

        targetLineRenderer.SetPosition(1, endPosition);
        directionArrow.position = endPosition;
    }

    #region Simulation Button

    public void SimulationButtonDown()
    {
        triangle_clickPoint.isSimulating = true;
        simulationStep = 0;

        ProgressButtonDown();
    }

    public void ProgressButtonDown()
    {
        if (isSimulating)
        {
            DeterminePosition();
            InitSimulation();
            StopAllCoroutines();
            isSimulating = false;
        }

        simulationStep++;
        ButtonActive();

        StartCoroutine(Progress());
    }
    
    public void StopButtonDown()
    {
        StopAllCoroutines();
        
        isSimulating = false;
        triangle_clickPoint.isSimulating = false;
        simulationStep = 0;
        ButtonDeactive();
    }

    public void BackButtonDown()
    {
        if (isSimulating)
        {
            DeterminePosition();
            InitSimulation();
            StopAllCoroutines();
            isSimulating = false;
        }

        simulationStep--;
        leftOrRightText[simulationStep].text = string.Empty;

        ButtonActive();
        StartCoroutine(Progress());
    }

    #endregion
}
