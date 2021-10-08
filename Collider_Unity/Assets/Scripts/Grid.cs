using UnityEngine;

public class Grid : MonoBehaviour
{
    public GameObject gridPrefab;
    [Header("odd number recommend")]
    public int gridCount;

    private void Start()
    {
        DrawGrid();
    }

    private void DrawGrid()
    {
        int gridBase = -gridCount / 2;

        Vector2 rowStart = new Vector2(gridBase, gridBase);
        Vector2 rowEnd = new Vector2(gridBase, -gridBase);

        Vector2 columnStart = new Vector2(gridBase, gridBase);
        Vector2 columnEnd = new Vector2(-gridBase, gridBase);

        for (int i = 0; i < gridCount; ++i)
        {
            LineRenderer rowGrid = Instantiate(gridPrefab, transform).GetComponent<LineRenderer>();
            rowGrid.SetPosition(0, rowStart + Vector2.right * i);
            rowGrid.SetPosition(1, rowEnd + Vector2.right * i);

            LineRenderer columnGrid = Instantiate(gridPrefab, transform).GetComponent<LineRenderer>();
            columnGrid.SetPosition(0, columnStart + Vector2.up * i);
            columnGrid.SetPosition(1, columnEnd + Vector2.up * i);
        }
    }
}
