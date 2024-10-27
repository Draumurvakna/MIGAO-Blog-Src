---
aliases: null
cover: /gallery/Unity.png
date:
- 2023-05-09 21:58:07
tags:
- Control
- Unity
thumbnail: /thumb/Unity.png
title: Aircraft control policy
toc: true

---
# Aircraft control policy

## State Variable

### Intuitive
- Aircraft
	- Rotation (in euler angle: x,y,z)
	- Position (In the world coordinate system:x,y,z)
	- Linear velocity (In the world coordinate system: x,y,z)
	- Angular velocity (In the world coordinate system: x,y,z)
	- Acceleration (In the world coordinate system:x,y,z)
- Carrier Vessel Landing Runway
	- Position
	- Rotation (fixed)
	- Velocity (fixed)
### Extensive
- Aircraft
	- AoA (angle of attack 攻角)


## Decision Variable

- Aircraft
	- Pitch angle (control aircraft's rotation along x axis)
	- Roll angle (control aircraft's rotation along z axis)
	- Yaw angle (control aircraft's rotation along y axis)
	- Throttle (control thrust)

## Level 1 (Basic) Policy

Only contain the control over *control surface* (on control over throttle)

### Attitude Control/Maintainance

#### Pitch（俯仰角） C/M

Function: `KeepPitch()`

Control the angle of *horizontal tail (elevator)*

1. First keep the angle of elevator same with AoA(攻角), to avoid the disturbance of the horizontal tail on the attitide of the aircraft.
```csharp
aircraft.PitchAngle = aircraft.AoA;
```
这里的aircraft.PitchAngle指的是飞机升降舵的角度(下片为正)

2. 根据当前俯仰角，俯仰速度，和目标俯仰角，调整升降舵面的角度
```csharp
aircraft.PitchAngle += 5 * (p - aircraft.Pitch) / Mathf.Exp(10 * aircraft.PitchSpeed * Mathf.Sign(p - aircraft.Pitch));
```

#### Other Attitude C/M

与俯仰角类似（分别控制滚转舵面以及偏航舵面），不过不需要第一步

## Level 2 Policy

### Velocity Direction Control/Maintainance

#### Gliding Angle (下滑角)

Control the thrust of aircraft to change the angle of gliding

1. 保持飞机的俯仰角不变(5度仰角)
```csharp
KeepPitch(5f);
```

2. 计算当前下滑角
```csharp
float velAngle = 90 - Vector3.Angle(aircraft.rb.velocity, Vector3.up);
```

3. 根据下滑角更改油门大小
```csharp
aircraft.Thrust += (p - velAngle)/500f;
```

## Level 3 Policy

### Follow Trajectory

#### Vertical Approaching (竖直平面上接近预定下滑道)

通过调整飞机的下滑角来使飞机在竖直面上接近并维持在理想的下滑道

1. 计算偏差对应的向量
```csharp
Vector3 approachDirection = Vector3.ProjectOnPlane(route.Destination - transform.position, route.direction);
```
2. 根据偏差值调整下滑角的大小（-3为目标下滑轨道的下滑角）
```csharp
ThrustKeepGliding(-3 + Mathf.Clamp(approachDirection.y / 10f, -5,5));
```

#### Horizontal Approaching (水平面上接近预定下滑道)

通过调整飞机的偏航舵面角度（进而影响飞机的y轴rotation）来使飞机在水平面上接近并维持在理想的航道上

1. 计算偏差对应的向量
```csharp
Vector3 approachDirection = Vector3.ProjectOnPlane(route.Destination - transform.position, route.direction);
float distance = 0;

if (Vector3.Angle(approachDirection, transform.right) < 90)
{
	distance = Vector3.ProjectOnPlane(approachDirection, Vector3.up).magnitude;
}
else
{
	distance = -Vector3.ProjectOnPlane(approachDirection, Vector3.up).magnitude;
}
```
2. 根据偏差值调整飞机的目标偏航角度（-8为目标下滑轨道的偏航角度）
```csharp
KeepYaw(-8 + Mathf.Clamp(distance / 10f, -50, 50));
```

## Get the ideal trajectory（补充）

基本的策略以及阐述完毕，那么所谓的理想下滑道到底应该怎么得到呢？
理想下滑道是一个射线，包含一个终点（飞机着陆的终点）和一个方向（飞机接近的方向）
```csharp
public class Target_Route
{
	public Vector3 Destination;
	public Vector3 direction;
}
```
理想航道的偏航角和下滑角已知（分别为-8（平行于着陆跑道）和-3）
通过迭代飞机着陆所需时间来求得下滑道终点的位置

```csharp
route.Destination = CV.transform.position;
route.direction = new Vector3(-0.14f, -0.05f, 0.99f).normalized;
// 获取飞机速度在下滑道方向上投影的大小
float axialVel = Vector3.Dot(aircraft.rb.velocity, route.direction);

// calculate precise destination
float FlightTime = 0;
for (int i = 0; i < 10; i++)
{
	FlightTime = Vector3.Dot(route.Destination - aircraft.transform.position,route.direction) / axialVel;// 获取预计到达终点需要的时间
	route.Destination = CV.transform.position + 15 * FlightTime * Vector3.forward; // 其中15是航母的速度，Vector3.forward是航母前进方向
}
```