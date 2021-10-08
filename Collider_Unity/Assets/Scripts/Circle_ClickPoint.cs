using UnityEngine;
using UnityEngine.UI;

public class Circle_ClickPoint : Controller
{
    public InputField inputField_circleSize;
    public Text resultText;

    public float circleRadius;
    public CircleCollider2D circleCollider2D;
    
    private float circleColliderRadius;

    protected override void Start ()
    {
        inputField_circleSize.text = circleRadius.ToString();
        circleColliderRadius = circleCollider2D.radius;
        base.Start();
    }

    protected override bool IsInner ()
    {
        float distance = Vector2.Distance(colliderPosition, clickPosition);

        return distance <= circleRadius;
    }

    protected override void UpdateColliderSize ()
    {
        circleCollider2D.transform.localScale = Vector3.one * (circleRadius / circleColliderRadius);
    }

    protected override void UpdatePositionAndText ()
    {
        base.UpdatePositionAndText();

        float xDistance = (colliderPosition.x - clickPosition.x) * (colliderPosition.x - clickPosition.x);
        float yDistance = (colliderPosition.y - clickPosition.y) * (colliderPosition.y - clickPosition.y);

        resultText.text = $"sqrt( ({colliderPosition.x} - {clickPosition.x})^2 + ({colliderPosition.y} - {clickPosition.y})^2 )\n" +
            $"= sqrt( {xDistance} + {yDistance} = {Mathf.Sqrt(xDistance + yDistance)}";
    }

    #region Call By UI

    public override void InputField_EndEdit()
    {
        string text = inputField_circleSize.text;

        if (float.TryParse(text, out circleRadius) == false)
        {
            circleRadius = 1;
        }

        UpdateColliderSize();
        UpdatePositionAndText();
    }

    #endregion
}