---
aliases:
- Types
- Reference
date:
- 2023-05-09 21:58:07
tags:
- ML
- supervised-learning
- unsupervised-learning
- reinforcement-learning
title: basic
toc: true

---

<!--toc:start-->
- [Reference](#reference)
- [Types](#types)
  - [Supervised learning](#supervised-learning)
  - [Unsupervised learning](#unsupervised-learning)
  - [Reinforcement learning](#reinforcement-learning)
    - [Action space](#action-space)
    - [Policy](#policy)
    - [Episode](#episode)
    - [Horizon](#horizon)
    - [Return](#return)
    - [Value function](#value-function)
    - [Q function](#q-function)
<!--toc:end-->


# Reference
[ Deep-Reinforcement-Learning-With-Python](https://github.com/sudharsan13296/Deep-Reinforcement-Learning-With-Python)

# Types

---
## Supervised learning
In supervised learning, the machine learns from training data. The training data consists of a labeled pair of inputs and outputs. So, we train the model (agent) using the training data in such a way that the model can generalize its learning to new unseen data. It is called supervised learning because the training data acts as a supervisor, since it has a labeled pair of inputs and outputs, and it guides the model in learning the given task.

### Regression
Quantitative response
predict a quantitative variable from a set of features

### Classification
Categorical response
predict a categorical variable

---
## Unsupervised learning
Similar to supervised learning, in unsupervised learning, we train the model (agent) based on the training data. But in the case of unsupervised learning, the training data does not contain any labels; that is, it consists of only inputs and not outputs. The goal of unsupervised learning is to determine hidden patterns in the input. There is a common misconception that RL is a kind of unsupervised learning, but it is not. In unsupervised learning, the model learns the hidden structure, whereas, in RL, the model learns by maximizing the reward.

---
## Reinforcement learning
### Action space
The set of all possible actions in the environment is called the action space. Thus, for this grid world environment, the action space will be *\[up, down, left, right\]*. We can categorize action spaces into two types:
- **Discrete action space** 
  When our action space consists of actions that are discrete, then it is called a discrete action space. For instance, in the grid world environment, our action space consists of four discrete actions, which are up, down, left, right, and so it is called a discrete action space.
- **Continuous action space**
  When our action space consists of actions that are continuous, then it is called a continuous action space. For instance, let's suppose we are training an agent to drive a car, then our action space will consist of several actions that have continuous values, such as the speed at which we need to drive the car, the number of degrees we need to rotate the wheel, and so on. In cases where our action space consists of actions that are continuous, it is called a continuous action space.

### Policy
A policy defines the agent's behavior in an environment. The policy tells the agent what action to perform in each state.
Over a series of iterations, the agent will learn a good policy that gives a positive reward.
The optimal policy tells the agent to perform the correct action in each state so that the agent can receive a good reward.
- **Deterministic Policy**
  deterministic policy tells the agent to perform a one particular action in a state. Thus, the deterministic policy maps the state to one particular action

- **Stochastic Policy**
  maps the state to a probability distribution over an action space. 
    - **Categorical policy**
      when the action space is discrete
      uses categorical probability distribution over action space to select actions
    - **Gaussian policy**
      when our action space is continuous
      the stochastic policy uses Gaussian probability distribution over action space to select actions when the action space is continuous

### Episode
The agent interacts with the environment by performing some action starting from the initial state and reach the final state. This agent-environment interaction starting from the initial state until the final state is called an episode. For instance, in the car racing video game, the agent plays the game by starting from the initial state (starting point of the race) and reach the final state (endpoint of the race). This is considered an episode. An episode is also often called trajectory (path taken by the agent)
- **Episodic task**
  As the name suggests episodic task is the one that has the terminal state. That is, episodic tasks are basically tasks made up of episodes and thus they have a terminal state. Example: Car racing game. 
- **Continuous task**
  Unlike episodic tasks, continuous tasks do not contain any episodes and so they don't have any terminal state. For example, a personal assistance robot does not have a terminal state. 
  
### Horizon
Horizon is the time step until which the agent interacts with the environment. We can classify the horizon into two:
- **Finite horizon**
  If the agent environment interaction stops at a particular time step then it is called finite Horizon. For instance, in the episodic tasks agent interacts with the environment starting from the initial state at time step t =0 and reach the final state at a time step T. Since the agent environment interaction stops at the time step T, it is considered a finite horizon.
- **Infinite horizon**
  If the agent environment interaction never stops then it is called an infinite horizon. For instance, we learned that the continuous task does not have any terminal states, so the agent environment interaction will never stop in the continuous task and so it is considered an infinite horizon. 
### Return
Return is the sum of rewards received by the agent in an episode.

### Value function
Value function or the value of the state is the expected return that the agent would get starting from the state $s$ following the policy $\pi$

### Q function
implies the expected return agent would obtain starting from the state $s$ and an action $a$ following the policy $\pi$. 


