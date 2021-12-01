using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//shader value change test script

public class RimLightHandler : MonoBehaviour
{
    public float upSpeed;
    public float maxPower;
    public float minPower;
    private Renderer thisRenderer;
    private Material thisMaterial;
    private float power;
    private bool isPlus;

    private void Start()
    {
        isPlus = true;
        thisRenderer = GetComponent<Renderer>();
        thisMaterial = thisRenderer.materials[0];
        power = 3;
        upSpeed = 30.0f;
    }

    private void Update()
    {
        if (isPlus)
        {
            power += Time.deltaTime * upSpeed;
            if (power > maxPower)
            {
                power = maxPower;
                isPlus = false;
            }
        }
        else
        {
            power -= Time.deltaTime * upSpeed;
            if (power < minPower)
            {
                power = minPower;
                isPlus = true;
            }
        }

        thisMaterial.SetFloat("_RimPower", power);
    }
}
