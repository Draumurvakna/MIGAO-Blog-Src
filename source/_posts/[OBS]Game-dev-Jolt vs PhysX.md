---
categories:
- Note
cover: /gallery/Unity.png
date:
- 2024-10-18 10:35:30
tags:
- Unity
- godot
- physics-engine
- jolt
- physX
thumbnail: /thumb/Unity.png
title: Jolt vs PhysX
toc: true

---
Reference: http://nilssondev.com/posts/my-journey-with-physics
![](Pasted_image_20241020211726.png)
![](Pasted_image_20241020211759.png)
![](Pasted_image_20241020211748.png)

### Things Jolt Does Better

- Upfront about allocations. Jolt expects that you tell it how much memory will be needed for the simulation, which definitely results in better performance since Jolt won't be reallocating a lot of memory during the simulation. (Jolt does provide a way of doing allocations dynamically, so upfront allocations isn't a requirement)
- Better multi-core support. Out of the box Jolt will utilize multiple cores very well, whereas I've found that PhysX doesn't utilize multiple cores all too well. Jolt was designed with this in mind whereas PhysX wasn't.(多线程原生支持)
- Explicitly reference counted objects. When you create a new object in Jolt you'll most likely get a "Ref" instance back. PhysX does utilize reference counting, but it's not as apparent as it is with Jolt because PhysX returns pointers to most objects.
- Multiple collision shapes per body. Jolt handles this by providing a "compound" shape, which you construct from multiple other shapes, whereas PhysX just lets you add an arbitrary amount of shapes individually to any body. I'm not entirely sure how PhysX handles this internally, but I _do_ know that Jolt computes these shapes into a single more optimal collision shape, meaning that collision tests are most likely more optimal.（最佳碰撞划分）
- Better Multi-Threaded access. Jolt was designed with this in mind, and most methods in Jolt supports being accessed by multiple threads at once, whereas PhysX requires you to make use of a "Task" system, which is poorly designed in my opinion.（多线程）
- Jolt achieves a higher simulation fidelity / better simulation quality out of the box. Jolt gives us some really good simulation values out of the box, whereas PhysX requires us to play around with a lot of parameters in order to get a high quality simulation.

  

### Things PhysX Does Better

- PhysX has better simulation performance out of the box, whereas Jolt requires more careful setup and usage of the API in order to achieve good performance. Jolt does however gives more opportunities for optimizations, and can achieve better performance overall, but it does require more work（物理准确性方面更好）
- PhysX supports GPU-based simulation by utilizing the CUDA architecture, sadly this is limited to Nvidia GPUs only （可以显卡加速）
- The PhysX Visual Debugger (PVD) supports recording the simulation over the network, Jolt requires us to record the simulation to a file
- The PVD doesn't just visually record our simulation, but also records the parameters of the simulation at any given moment, allowing us to inspect the parameters more easily. Jolt on the other hand only records the simulation visually.
- PhysX offers us more control over mesh collider cooking, giving us more parameters to mess around with
- PhysX has far better documentation overall, since it's an older and more widely used API there's more resources on it online, whereas Jolt lacks online documentation. The developer of Jolt is very active on the GitHub repository though, and has been very helpful with any issues I've encountered, or any questions I've had about the usage. This isn't the case with the PhysX developers.（文档更完备）
- Achieves better performance when adding a lot of new bodies _during_ the simulation. Jolt requires us to manually optimize the broadphase structure, and doing that when there's already a lot of bodies in the broadphase can result in slowdowns temporarily.（在运行时创建物理物体更方便（？））

