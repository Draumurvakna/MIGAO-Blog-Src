---
title: ROS Orgmode Note
date: 2022-4-12 15:29:55
tags: 
- ROS
categories: 
- Note
cover: /gallery/ROS.jpg
thumbnail: /thumb/ROS.png
---
```org-mode
Study note for ROS
* Core Concept
** Node and ROS Master
*** Node
implement functions for purposes
support various language
can have thousands of nodes
*** ROS Master
mange the registion and name of various nodes
support(trace and record) communication between different nodes
for nodes to find each other
provide parameter server(store global variables...)[[about parameter]]
** Communication between nodes
|                    | Topic               | Service        |
|--------------------+---------------------+----------------|
| sync               | n                   | y              |
| model              | publish/subscribe   | service/client |
| protocol           | ROSTCP/ROSUDP       | ROSTCP/ROSUDP  |
| response           | n                   | y              |
| buffer             | y                   | n              |
| real-time          | weak                | strong         |
| nodes relationship | multi/one to multi  | one to multi   |
| scene              | data transformation | logic process  |
*** Topic
Node(publisher)->Topic(/example)&Message_Tyoe(std_msgs/String)->other ROS nodes(subscriber)
Message: define the data type and struct of data, defined by .msg file
async
*** Service
C/S model(Client/Server)
client send requests, server return response data
defined by .srv file, defines the structure of the requests and response
    ROS node(Service Server)
    ^  |response
request|  v
    ROS node(Service Client)
sync
** Parameter
<<about parameter>>
talker -> ROS master : setParam("foo",1)
listener -> ROS master: getParam("foo")
ROS master ->listener: {"foo",1}

multiple variable dictionary
for storing static nonbinary configuration, not suitable for dynamic
** File system
*** package
Basic unit in ROS, include the src of nodes, cfg, data def
*** package manifest
record the basic information of packages
*** Meta packages
orgnize multi packages for one common purpose
* Commond Line Tools
** rqt_graph
visualize tool
display the calculate process graph
** rosnode
display node information
*** rosnode list
list all node
default node /rosout
*** rosnode info /turtle_sim
show info of a node
** rostopic
usage like rosnode(list,info)
*** rostopic pub /../.. data_structure data 
publish message as a topic
add -r num to repeat sending at rate num/s
** rosmsg
*** rosmsg show data_structure
show the data structure
** rosservice 
| commond addition       |                                   |
|------------------------+-----------------------------------|
| list                   | list all service the node provide |
| call service_name data |                                   |
** rosbag
| command addition        |                                               |        |                 |
|-------------------------+-----------------------------------------------+--------+-----------------|
| record -a -O cmd_record | record the topic data in the system           | -a:all | -O as a package |
| play cmd_record.bag     | play the recorded data of previous simulation |        |                 |
|                         |                                               |        |                 |
* setup workspace and function package
** workspace
*** overview
| src     | source space  |                         |
| build   | build space   | no need to touch        |
| devel   | develop space | script, executable file |
| install | install sapce |                         |

work space folder/
  src/
    CmakeLists.txt
    package_1/
      CmakeList.txt
      package.xml
      ...
    package_n/
      CmakeList.txt
      package.xml
      ...
  build/
    CATKIN_IGNORE
  devel/
    bin/
    etc/
    include/
    lib/
    share/
    .catkin
    env.bash
    setup.bash
    setup.sh
    ...
  install/
    bin/
    etc/
    include/
    lib/
    share/
    .catkin
    env.bash
    setup.bash
    setup.sh
    ...
*** setup
**** establish ws
mkdir -p ./catkin_ws/src
cd ./catkin_ws/src
catkin_init_workspace
**** compile ws
cd ./catkin_ws/
catkin_make -DPYTHON_EXECUTABLE=/usr/bin/python3
catkin_make install
**** set env variables
source devel/setup.bash
**** check env variables
echo $ROS_PACKAGE_PATHH
** fucntion package
*** setup
| establish package | cd ./src                                                                   |                                       |
|                   | catkin_create_pkg <pkg_name> [depend1] [depend2].. (rospy,roscpp,std_msgs) |                                       |
| source env path   | source devel/setup.bash                                                    | make sure that ros can detect the pkg |

*** package.xml
| label                        | description                                         |
|------------------------------+-----------------------------------------------------|
| <name>                       |                                                     |
| <version>                    |                                                     |
| <description>                |                                                     |
| <maintainer email="">        | maintainer's name and email                         |
| <license>                    |                                                     |
| <buildtool depend>           | usually catkin                                      |
| <build_depend>/<exec_depend> | package dependencies ,usually roscpp rospy std_msgs |
*** CmakeList.txt
TODO


```
