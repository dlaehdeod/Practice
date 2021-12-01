using UnityEngine;

public class SetShaderSpeed : MonoBehaviour
{
    [Range(0.0f, 5.0f)]
    public float speed;

    public Renderer[] targetRenderer;

    private void Start()
    {
        for (int i = 0; i < targetRenderer.Length; ++i)
            targetRenderer[i].material.SetFloat("_FlowSpeed", speed);
    }

    private void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            SetSpeed();
        }
    }

    private void SetSpeed ()
    {
        print("Set speed ok : " + speed);
        for (int i = 0; i < targetRenderer.Length; ++i)
            targetRenderer[i].material.SetFloat("_FlowSpeed", speed);
    }
}
