using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class BackToMain : MonoBehaviour
{
    public static BackToMain instance = null;
    
    private void Awake()
    {
        if (instance == null)
        {
            instance = this;
            transform.GetChild(0).GetComponent<Button>().onClick.AddListener(delegate { BackToMainButtonDown(); });
            gameObject.SetActive(false);
            DontDestroyOnLoad(gameObject);
        }
        else
        {
            instance.gameObject.SetActive(false);
            Destroy(gameObject);
        }
    }

    public void BackToMainButtonDown()
    {
        SceneManager.LoadScene("_Main");
    }
}
