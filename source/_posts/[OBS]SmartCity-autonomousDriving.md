---
aliases:
- Autonomous Driving
date:
- 2023-05-09 21:58:07
tags:
- autonomousDriving
title: autonomousDriving
toc: true

---

# Autonomous Driving

<!--toc:start-->
- [Autonomous Driving](#autonomous-driving)
  - [Perception](#perception)
  - [Decision-making](#decision-making)
    - [Architecture](#architecture)
      - [Pre-trip decisions](#pre-trip-decisions)
      - [In-trip decisions](#in-trip-decisions)
      - [Post-trip decision](#post-trip-decision)
  - [Speed tracking](#speed-tracking)
    - [Dynamic system](#dynamic-system)
      - [Open-loop control](#open-loop-control)
      - [Closed-loop control](#closed-loop-control)
        - [Linear controller](#linear-controller)
    - [LTI system](#lti-system)
      - [Control of LTI system](#control-of-lti-system)
  - [Speed tracking](#speed-tracking)
  - [Trajectory tracking](#trajectory-tracking)
    - [Control policy](#control-policy)
<!--toc:end-->

## Perception

- Navigation tool
- Camera
- Radar
- LiDAR
- Infrared detector
- Speedometer
- veh-veh communication
- veh-infrastructure communication

## Decision-making

- departure time
- good route
- good lane
- driving style
- way to accel/decel
- make a turn
- park location

### Architecture

- Pre-trip
> trip generation, modal choice, routine choice
- In-trip
> Path planning, Maneuver regulation
- Post-trip
> Parking

#### Pre-trip decisions

- Centralized
> central command center send instructions
> Some win, some lose
- Decentralized
> plan trip independently, selfish
> little communication
> Sometime efficient, sometime inefficient

#### In-trip decisions

- offline info
> static, in form of map
- online info
> enable the route to be adapted to changing traffic conditions

#### Post-trip decision

## Speed tracking

### Dynamic system

- State Variable
> $v[t]$
- State space
> $R>= 0$
- Control input
> $u[t]$(accel)
- System dynamic
> $v[t+dt] = v[t]+u[t]*dt$

#### Open-loop control

Specify the control input $u[t]$ for all t in $[0,T]$
not a good idea for autonomous driving.

In practice, we need to consider the uncertainty of the system.
We should have:
$$
v[t+dt]=v[t]+u[t]dt+w(t)
$$
Where w(t) is the noise term capturing the uncertainty of the system.

#### Closed-loop control

Specify the control input $u[t]$ as a function of the state $v[t]$
able to adapt to the uncertainty of the system.
Compare the state $v[t]$ with the desired state $v_desired[t]$
Essentially, we need a mapping from state to control input
like map speed to acceleration
$$
v[t+dt]=v[t]+mu[v[t]]dt+w(t)
$$
##### Linear controller
the $u[t]$ has linear relationship with $v[t]$
$$
\mu[v] = k[v-v_{desired}]
$$
### LTI system
linear time-invariant

#### Control of LTI system
exponential convergence is stronger than asymptotic convergent
if LTI system is asymptotic convergent, it is also exponential convergent
$$
x[t+1]=ax[t]+bu[t]
$$

## Speed tracking
- given:
> $v_{desired}, \delta$

- determine:
> $u[t]$ $t = 0,1,2$

- state
> $v[t]$
> $v[t+1] = v[t] + u[t]\delta + w[t]$

select $u[t]$ so that $w[t]$ will not accumulate
> $u[t]=\mu(v[t]) = kv[t]$

$$
v[t+1] = f(v[t],u[t])
$$



**Remember the review question**


## Trajectory tracking

Overview:
- track means asymptotic convergent
- $x[t]$ and $x_{desired}[t]$
- $\lim_{t\rightarrow\infty}|x[t]-x_{desired}[t] | = 0$

- state of system:$[x[t], v[t]]^T$
- if successful:
$$
[x[t], v[t]]^T \rightarrow [x_{desired}[t], v_{desired}[t]]^T
$$

### Control policy
- A control policy is a function
- This function maps a state to a control input
$$
u[t] = f(x[t],v[t])
$$

$$
u[t] = -k_1(x[t]-x_{desired}[t])-k_2(v[t]-v_{desired}[t])
$$

$$
k_1,k_2>0
$$

