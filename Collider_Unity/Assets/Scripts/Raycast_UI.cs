using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class Raycast_UI : MonoBehaviour
{
    private PointerEventData pointer;
    private List<RaycastResult> raycastResults;

    private void Start()
    {
        pointer = new PointerEventData(EventSystem.current);
    }

    public bool IsSelectedUI ()
    {
        pointer.position = Input.mousePosition;
        raycastResults = new List<RaycastResult>();
        EventSystem.current.RaycastAll(pointer, raycastResults);

        if (raycastResults.Count > 0)
        {
            return true;
        }

        return false;
    }
}
