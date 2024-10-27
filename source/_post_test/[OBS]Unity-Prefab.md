---
aliases: null
cover: /gallery/Unity.png
date:
- 2023-05-09 21:58:07
tags:
- Unity
- Prefab
thumbnail: /thumb/Unity.png
title: Prefab
toc: true

---

# Prefabs in Unity

A prefab is a template for a game object that can be reused across multiple scenes. Using prefabs can help build scenes faster because a prefab can be created and then reused across multiple scenes without having to recreate the same game object each time.

## Creating Prefabs

To create a prefab, first create a game object in the Hierarchy window and add components and child game objects to it until it looks like the desired prefab. Then drag the game object from the Hierarchy window to the Assets folder in the Project window. This will turn the game object into a prefab that can be reused across multiple scenes.

An empty prefab can also be created by right-clicking in the Project window and selecting Create > Prefab, and then editing it in the Inspector window.

## Instantiating Prefabs in Scripts

To instantiate an existing prefab in a script, first create a public variable in the script to reference the prefab, and then drag the prefab onto that variable in the Inspector window. For example:

```csharp
public GameObject myPrefab;

void Start()
{
    Instantiate(myPrefab, new Vector3(0, 0, 0), Quaternion.identity);
}
```

The above code creates a public variable named myPrefab and uses the Instantiate method in the Start method to create an instance of the prefab. The prefab can be dragged onto the myPrefab variable in the Inspector window so that it is instantiated at runtime.

To instantiate a prefab from the Assets folder in a script, use the Resources.Load method to load the prefab and then use the Instantiate method to instantiate it. For example:

```csharp
void Start()
{
    GameObject myPrefab = Resources.Load<GameObject>("MyPrefab");
    Instantiate(myPrefab, new Vector3(0, 0, 0), Quaternion.identity);
}
```

The above code uses the Resources.Load method to load a prefab named MyPrefab from the Resources folder in the Assets folder and then uses the Instantiate method to create an instance of the prefab.

**Note:** To use the Resources.Load method, the prefab must be located in a Resources folder within the Assets folder.
