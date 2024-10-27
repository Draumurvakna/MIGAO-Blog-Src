---
title: ROS-Publisher
date: 2022-04-15 23:31:54
tags: 
- ROS
categories: 
- Note
cover: /gallery/ROS.jpg
thumbnail: /thumb/ROS.png
---
Study note for ROS publisher.

# Model of Topic
- Publisher(turtle Velocity)
- - --[Message(geometry\_msgs::Twist)]--> 
- Topic (/turtle1/cmd\_vel)
- - --[Message(geometry\_msgs::Twist)]-->
- Subscriber(turtlesim)

# Programming realization
Take turtlesim as the example.
We write a program acting like a publisher and sending controlling messages.

## Create package
```bash
$ cd catkin_ws/src
$ catkin_create_pkg learning_topic roscpp rospy std_msgs geometry_msgs turtlesim
```
can see:
```bash
$ ls
CMakeLists.txt  include  package.xml  src
```
**How to realize a publisher?**
- Initialize <font color=#00bbbb>ROS node</font>
- register node info from <font color=#00bbbb>ROS Master</font>, including name of the topic and msg type
- create message data
- publish message at a specific frequency


## Code
create `velocity_publisher.cpp` file in `learning_topic/src`
```cpp
#include <ros/ros.h>
#include <geometry_msgs/Twist.h>

int main(int argc, char *argv[])
{
    //init the node
    ros::init(argc,argv,"velocitypublisher");

    //create node handle
    ros::NodeHandle n;

    //create a publisher, who publish topic names '/turtle1/cmd_vel', message type 'geometry_msgs:Twist', queue length 10
    ros::Publisher turtle_vel_pub = n.advertise<geometry_msgs::Twist>("/turtle1/cmd_vel",10);

    //set loop rate
    ros::Rate loop_rate(10);
    while (ros::ok()) {
        //initialize geometry_msgs:Twist msg
        geometry_msgs::Twist vel_msg;
        vel_msg.linear.x = 0.5;
        vel_msg.angular.z = 0.2;

        //publish msgs
        turtle_vel_pub.publish(vel_msg);
        ROS_INFO("Publish turtle velocity command at %0.2f m/s, %0.2f rad/s",
                vel_msg.linear.x,vel_msg.angular.z);

        //delay
        loop_rate.sleep();
    }
    return 0;
}
```

**What is queue length?**
- msgs can be published very fast while the data transmission rate is limited, so the queue act as a buffer
- first in, first thrown, keeping the remained msgs in the queue relatively new

## Configure the compile rule of publisher
Steps:
- set the code need to be complied and the generated excutable file
- set the link library

Add two lines to `learning\_topic/CMakeLists.txt` (in <font color=#00bbbb>build</font> part):
```txt
add_executable(velocity_publisher src/velocity_publisher.cpp)
target_link_libraries(velocity_publisher ${catkin_LIBRARIES})
```

## Compile
```bash
$ cd ~/ROS_study/catkin_ws
$ catkin_make
$ source ./devel/setup.zsh
$ roscore
$ rosrun turtlesim turtlesim_node
$ rosrun learning_topic velocity_publisher
```
Then, you can see turtle:

![](ros_turtle.png "ros_turtle")

And outputs:
```
...
[ INFO] [1650088100.376299177]: Publish turtle velocity command at 0.50 m/s, 0.20 rad/s
[ INFO] [1650088100.476312726]: Publish turtle velocity command at 0.50 m/s, 0.20 rad/s
[ INFO] [1650088100.576304995]: Publish turtle velocity command at 0.50 m/s, 0.20 rad/s
...
```





