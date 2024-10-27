---
title: ROS-Subscriber
date: 2022-04-16 14:13:18
tags: 
- ROS
categories: 
- Note
cover: /gallery/ROS.jpg
thumbnail: /thumb/ROS.png
---
Study note for ROS subscriber.

# Model of Topic
- Publisher(turtlesim)
- - --[Message(geometry\_msgs::Twist)]--> 
- Topic (/turtle1/pose)
- - --[Message(geometry\_msgs::Twist)]-->
- Subscriber(Pose Listener)

# Programming realization
**How to realize a subscriber**
- initialize ROS node
- subscribe required topic
- loop wait the msgs from topic, after receiving msgs, enter callback function
- implement msgs processing in the callback function

## Code
Also we put this node into function package `learning_topic`\
Create `velocity_publisher.cpp` file in `learning_topic/src`:
```cpp
#include <ros/ros.h>
#include <turtlesim/Pose.h>

void poseCallback(const turtlesim::Pose::ConstPtr& msg)
{
    ROS_INFO("Turtle pose: x:%0.6f, y:%0.6f, ",msg->x,msg->y);
}

int main(int argc, char *argv[])
{
    ros::init(argc, argv, "pose_subscriber");
    ros::NodeHandle n;
    ros::Subscriber pose_sub = n.subscribe("/turtle1/pose",10,poseCallback）
    //queue also first in first thrown
    //loop waiting for callback function, keep the endless loop
    ros::spin();
    return 0;
}
```
**Note**
- Callback function must be sufficient, or newer data will be blocked

## Configure the compile run of subscriber
Steps same as publisher
Add two lines to `learning\_topic/CMakeLists.txt` (in <font color=#00bbbb>build</font> part):
```txt
add_executable(velocity_publisher src/pose_subscriber.cpp)
target_link_libraries(pose_subsriber ${catkin_LIBRARIES})
```

## Compile
```bash
$ cd ~/ROS_study/catkin_ws
$ catkin_make
$ source ./devel/setup.zsh
$ roscore
$ rosrun turtlesim turtlesim_node
$ rosrun learning_topic velocity_publisher
$ rosrun learning_topic pose_subscriber
```

The output of pose\_subscriber:
```bash
...
[ INFO] [1650184199.757606156]: Turtle pose: x:3.100077, y:7.501662,
[ INFO] [1650184199.773327854]: Turtle pose: x:3.101826, y:7.493855,
[ INFO] [1650184199.790252785]: Turtle pose: x:3.103601, y:7.486054,
...
```




