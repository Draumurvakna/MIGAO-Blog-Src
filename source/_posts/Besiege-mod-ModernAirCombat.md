---
title: Besiege mod "ModernAirCombat"
date: 2022-08-05 17:24:50
tags:
- Game
- Mod
- Unity
- CSharp
categories:
- Note
---
mod name: ModernAirCombat

# Setup of mod
``` besiege
$createmod "ModernAirCombat"
```

modify `./Mod.xml`
- Author
- Description

``` besiege
$createblock "ModernAirCombat" "SRAAM"
```

``` besiege
mkdir ./Resources/SRAAM
```
add assets of SRAAM block `r73.obj`, `r73.png`

modify `./Mod.xml`
- Add resources
``` besiege
<Mesh name="SRAAM Mesh" path="SRAAM\r73.obj"/>
<Texture name="SRAAM Texture" path="SRAAM\r73.png"/>
```
![SRAAM-apppearance](SRAAM-apppearance.png "SRAAM Apppearance")


modify `./SRAAM.xml`
- Mass
- Mesh name
- Texture name
- Icon
- Colliders
- Points

create assembly for scripts
``` besiege
createassembly "ModernAirCombat" compiled MacAssembly ModernAirCombat forceUnityTools
```

open project with VStudio

edit `ModernAirCombat.cs`
```
using System;
using Modding;
using UnityEngine;

namespace ModernAirCombat
{
    public enum BlockList
    {
        SRAAM = 1,
        MRAAM = 2,
        LRAAM = 3
    }
    public class ModernAirCombat : ModEntryPoint
    {
        public static GameObject Mod;
        public override void OnLoad()
		    {
            Mod = new GameObject("Morden Firearm Kit Mod");
            UnityEngine.Object.DontDestroyOnLoad(Mod); \\avoid destroy mod instance when changing levels
            Debug.Log("Hello, this is Modern Air Combat！");
            // Called when the mod is loaded.
        }
    }
}
```

# Write Block Scripts

add a block class `SRAAM.cs`
```
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using System.Collections;

using Modding.Modules;
using Modding;
using Modding.Blocks;
using UnityEngine;

namespace ModernAirCombat
{
    class SRAAMBlock : BlockScript
    {
        public MToggle IFF;
        public MSlider detectAngleSlider;
        private Transform myTransform;      //实例化Transform对象
        private Rigidbody myRigidbody;

        public override void SafeAwake()
        {
            IFF = AddToggle("开启友伤", "IFF", true);
            detectAngleSlider = AddSlider("探测角度", "detection angle", 45.0f, 0.0f, 150.0f);
        }
        private void Start()
        {
            myTransform = gameObject.GetComponent<Transform>();        //获取相应对象的引用
            myRigidbody = gameObject.GetComponent<Rigidbody>();
            myRigidbody.drag = 2;
            myRigidbody.angularDrag = 4;
        }

        public override void OnSimulateStart()
        {
            base.OnSimulateStart();
        }

        public override void OnSimulateStop()
        {
            base.OnSimulateStop();
        }

        private void Update() {
            myRigidbody.AddRelativeForce(new Vector3(0, 1, 0), ForceMode.Impulse);
        }
    }
}
```

modify `SRAAM.xml`
```
<Script>ModernAirCombat.SRAAMBlock</Script>
```
