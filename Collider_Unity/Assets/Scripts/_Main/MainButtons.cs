using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class MainButtons : MonoBehaviour
{
    public Button[] buttons;

    private void Start()
    {
        buttons[0].onClick.AddListener(delegate { CircleColliderButtonDown(); });
        buttons[1].onClick.AddListener(delegate { BoxColliderButtonDown(); });
        buttons[2].onClick.AddListener(delegate { TriangleColliderButtonDown(); });
        buttons[3].onClick.AddListener(delegate { QuitButtonDown(); });
    }

    public void CircleColliderButtonDown ()
    {
        SceneManager.LoadScene("CircleCollider");
        BackToMain.instance.gameObject.SetActive(true);
    }

    public void BoxColliderButtonDown ()
    {
        SceneManager.LoadScene("BoxCollider");
        BackToMain.instance.gameObject.SetActive(true);
    }

    public void TriangleColliderButtonDown ()
    {
        SceneManager.LoadScene("TriangleCollider");
        BackToMain.instance.gameObject.SetActive(true);
    }

    public void QuitButtonDown ()
    {
        Application.Quit();
    }
}
