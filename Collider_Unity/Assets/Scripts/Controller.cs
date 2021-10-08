using UnityEngine;
using UnityEngine.UI;

public abstract class Controller : MonoBehaviour
{
    public Raycast_UI raycast_UI;
    public Toggle toggle_grid;
    public LineRenderer distanceLineRenderer;
    public SpriteRenderer baseSpriteRenderer;
    public Text distanceText;
    public Color innerColor = new Color(0.75f, 0.28f, 0.28f);

    protected Transform target;
    protected bool isDrag;
    protected bool isSnap;

    protected Vector2 colliderPosition;
    protected Vector2 clickPosition;

    protected virtual void Start()
    {
        UpdateColliderSize();
        UpdatePositionAndText();
    }

    public abstract void InputField_EndEdit();
    protected abstract void UpdateColliderSize();
    protected abstract bool IsInner();
    
    protected virtual void UpdatePositionAndText()
    {
        colliderPosition = baseSpriteRenderer.transform.position;
        clickPosition = transform.position;

        if (isSnap)
        {
            colliderPosition = GetSnapVector(colliderPosition);
            clickPosition = GetSnapVector(clickPosition);
        }

        distanceLineRenderer.SetPosition(0, colliderPosition);
        distanceLineRenderer.SetPosition(1, clickPosition);

        float distance = Vector2.Distance(colliderPosition, clickPosition);

        if (IsInner())
        {
            baseSpriteRenderer.color = innerColor;
        }
        else
        {
            baseSpriteRenderer.color = Color.white;
        }

        distanceText.transform.position = Vector3.Lerp(colliderPosition, clickPosition, 0.5f);
        distanceText.text = distance.ToString();
    }

    protected void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            MouseButtonDown();
        }

        if (Input.GetMouseButtonUp(0))
        {
            MouseButtonUp();
        }

        if (isDrag)
        {
            TargetMove();
            UpdatePositionAndText();
        }
    }

    protected void MouseButtonDown()
    {
        if (raycast_UI.IsSelectedUI())
        {
            return;
        }

        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        RaycastHit2D hit = Physics2D.Raycast(ray.origin, ray.direction);

        if (!hit)
        {
            target = transform;
            transform.position = ray.origin;
        }
        else
        {
            target = hit.transform;
            target.position = ray.origin;
        }

        isDrag = true;
    }

    protected Vector2 GetSnapVector(Vector2 position)
    {
        return new Vector2(Mathf.RoundToInt(position.x), Mathf.RoundToInt(position.y));
    }

    protected void MouseButtonUp()
    {
        isDrag = false;
        target = null;
    }

    protected void TargetMove()
    {
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);

        if (isSnap)
        {
            target.position = GetSnapVector(ray.origin);
        }
        else
        {
            target.position = ray.origin;
        }
    }

    #region Call By UI
    
    public void Toggle_ValueChanged()
    {
        isSnap = toggle_grid.isOn;
    }

    #endregion
}
