---
categories:
- Note
cover: /gallery/Unity.png
date:
- 2024-04-16 19:19:55
tags:
- Mod
- csharp
- Unity
- Game
thumbnail: /thumb/Unity.png
title: ONI Modding
toc: true

---
## Basic

### Useful tools
- Dnspy: decompile the runtime library of ONI
- Visual Studio (though it's too fat)
- Poedit: read the `.po` file for zh-en translation

### Hello world
Apply patches on the `Initialize()` method in `Db` class.
```csharp
public class Patches
    {
        [HarmonyPatch(typeof(Db))]
        [HarmonyPatch("Initialize")]
        public class Db_Initialize_Patch
        {
            public static void Prefix()
            {
                Debug.Log("Hello! Welcome to CuppyUniverse! [before Db.Initialize]");
            }

            public static void Postfix()
            {
                Debug.Log("CuppyUniverse initialized! [after Db.Initialize]");
            }
        }
        [HarmonyPatch(typeof(ElectrolyzerConfig))]
        [HarmonyPatch("CreateBuildingDef")]
        public class ElectrolyzerConfig_Patch
        {
            public static void Postfix(ref BuildingDef __result)
            {
                __result.EnergyConsumptionWhenActive = 114f;
            }
        }
    }
```

### Add new building

Take gold washer (just like water purifier but output small amount of gold) as an example.
1. Find the source code for water purifier.
i.e.
```csharp
using System;
using TUNING;
using UnityEngine;

// Token: 0x0200039A RID: 922
public class WaterPurifierConfig : IBuildingConfig
{
	// Token: 0x06001314 RID: 4884 RVA: 0x000665C4 File Offset: 0x000647C4
	public override BuildingDef CreateBuildingDef()
	{
		string id = "WaterPurifier";
		int width = 4;
		int height = 3;
		string anim = "waterpurifier_kanim";
		int hitpoints = 100;
		float construction_time = 30f;
		float[] tier = BUILDINGS.CONSTRUCTION_MASS_KG.TIER3;
		string[] all_METALS = MATERIALS.ALL_METALS;
		float melting_point = 800f;
		BuildLocationRule build_location_rule = BuildLocationRule.OnFloor;
		EffectorValues tier2 = NOISE_POLLUTION.NOISY.TIER3;
		BuildingDef buildingDef = BuildingTemplates.CreateBuildingDef(id, width, height, anim, hitpoints, construction_time, tier, all_METALS, melting_point, build_location_rule, BUILDINGS.DECOR.PENALTY.TIER2, tier2, 0.2f);
		...
		return buildingDef;
	}

	// Token: 0x06001315 RID: 4885 RVA: 0x000666A8 File Offset: 0x000648A8
	public override void ConfigureBuildingTemplate(GameObject go, Tag prefab_tag)
	{
		...
	}

	// Token: 0x06001316 RID: 4886 RVA: 0x0006688B File Offset: 0x00064A8B
	public override void DoPostConfigureComplete(GameObject go)
	{
		...
	}

	// Token: 0x04000A88 RID: 2696
	public const string ID = "WaterPurifier";

	// Token: 0x04000A89 RID: 2697
	private const float FILTER_INPUT_RATE = 1f;

	// Token: 0x04000A8A RID: 2698
	private const float DIRTY_WATER_INPUT_RATE = 5f;

	// Token: 0x04000A8B RID: 2699
	private const float FILTER_CAPACITY = 1200f;

	// Token: 0x04000A8C RID: 2700
	private const float USED_FILTER_OUTPUT_RATE = 0.2f;

	// Token: 0x04000A8D RID: 2701
	private const float CLEAN_WATER_OUTPUT_RATE = 5f;

	// Token: 0x04000A8E RID: 2702
	private const float TARGET_OUTPUT_TEMPERATURE = 313.15f;
}

```

Create a new csharp class file in VS and copy the content into it. 
Remember to rename
- the class name
- `id` in method `CreateBuildingDef()`
- `ID` in class
In this example change them to `GoldWasher`

2. Add GoldWasher to build menu.
create a new patch for `GeneratedBuildings`
```csharp
using System;
using HarmonyLib;

namespace ONI_CuppyUniverse_Mod
{
    [HarmonyPatch(typeof(GeneratedBuildings), "LoadGeneratedBuildings")]
    public class GeneratedBuildings_LoadGeneratedBuildings
    {
        public static void Prefix()
        {
            Strings.Add(new string[] { 
                "STRINGS.BUILDINGS.PREFABS.GOLDWASHER.NAME",
                "淘金器"
            });
            Strings.Add(new string[] {
                "STRINGS.BUILDINGS.PREFABS.GOLDWASHER.EFFECT",
                "从纯净水中淘取黄金"
            });
            Strings.Add(new string[] {
                "STRINGS.BUILDINGS.PREFABS.GOLDWASHER.DESC",
                "你是信无中生有的"
            });
            ModUtil.AddBuildingToPlanScreen("Food", "GoldWasher");
        }
    }
}

```

## Reference
- [Some mod src](https://github.com/Nightinggale/ONI-mods)
- [ONI Mod Guidance](https://github.com/Cairath/Oxygen-Not-Included-Modding/wiki)
- [Harmony Guidance](https://harmony.pardeike.net/articles/patching.html)