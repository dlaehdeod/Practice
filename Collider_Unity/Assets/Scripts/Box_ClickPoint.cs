using UnityEngine;
using UnityEngine.UI;

public class Box_ClickPoint : Controller
{
    public InputField inputField_boxSize;
    public Text resultText;

    public float boxSize;
    public BoxCollider2D boxCollider2D;

    private float boxColliderSize;
    private float xMax, xMin, yMax, yMin;

    protected override void Start ()
    {
        inputField_boxSize.text = boxSize.ToString();
        boxColliderSize = boxCollider2D.size.x;
        base.Start();
    }

    protected override bool IsInner ()
    {
        float x = clickPosition.x;
        float y = clickPosition.y;

        return xMin <= x && x <= xMax &&
               yMin <= y && y <= yMax;
    }

    protected override void UpdateColliderSize()
    {
        boxCollider2D.transform.localScale = Vector3.one * (boxSize / boxColliderSize);
    }

    protected override void UpdatePositionAndText()
    {
        base.UpdatePositionAndText();

        colliderPosition = baseSpriteRenderer.transform.position;
        clickPosition = transform.position;

        xMin = colliderPosition.x - boxSize / 2;
        xMax = colliderPosition.x + boxSize / 2;
        yMin = colliderPosition.y - boxSize / 2;
        yMax = colliderPosition.y + boxSize / 2;

        resultText.text = $"{xMin} <= {clickPosition.x} <= {xMax}\n{yMin} <= {clickPosition.y} <= {yMax}";
    }

    #region Call By UI
    
    public override void InputField_EndEdit()
    {
        string text = inputField_boxSize.text;

        if (float.TryParse(text, out boxSize) == false)
        {
            boxSize = 1;
        }

        UpdateColliderSize();
        UpdatePositionAndText();
    }

    #endregion
}
