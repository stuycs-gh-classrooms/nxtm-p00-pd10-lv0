[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/gbHItYk9)
## Project 00
### NeXTCS
### Period: 10
## Name0: Vincent Zheng
---

This project will be completed in phases. The first phase will be to work on this document. Use github-flavoured markdown. (For more markdown help [click here](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet) or [here](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax) )

All projects will require the following:
- Researching new forces to implement.
- Method for each new force, returning a `PVector`  -- similar to `getGravity` and `getSpring` (using whatever parameters are necessary).
- A distinct demonstration for each individual force (including gravity and the spring force).
- A visual menu at the top providing information about which simulation is currently active and indicating whether movement is on or off.
- The ability to toggle movement on/off
- The ability to toggle bouncing on/off
- The user should be able to switch _between_ simluations using the number keys as follows:
  - `1`: Gravity
  - `2`: Spring Force
  - `3`: Drag
  - `4`: Custom Force
  - `5`: Combination


## Phase 0: Force Selection, Analysis & Plan
---------- 

#### Custom Force: Buoyant Force

### Forumla
What is the formula for your force? Including descriptions/definitions for the symbols. (You may include a picture of the formula if it is not easily typed.)

![image](https://github.com/user-attachments/assets/f6222e05-7f24-43ce-841a-30a6fc663050)

### Custom Force
- What information that is already present in the `Orb` or `OrbNode` classes does this force use?
  - g (acceleration due to gravity)

- Does this force require any new constants, if so what are they and what values will you try initially?
  - None.

- Does this force require any new information to be added to the `Orb` class? If so, what is it and what data type will you use?
  - Fluid Density and Fluid Volume (volume displaced by the object)

- Does this force interact with other `Orbs`, or is it applied based on the environment?
  - Applied based on the environment (fluid/medium it is passing through)

- In order to calculate this force, do you need to perform extra intermediary calculations? If so, what?
  - Calculate fluid volume (volume of submerged object) using V = m/P (volume = mass/density)

--- 

### Simulation 1: Gravity
Describe how you will attempt to simulate orbital motion.

Give the option to have a fixed orb applying gravitational force on everything in/around it (inside earth/in space) and give the option to have the orbs apply gravitational force on each other.

--- 

### Simulation 2: Spring
Describe what your spring simulation will look like. Explain how it will be setup, and how it should behave while running.

The spring simulation will display springs connecting each individual orb to adjacent orbs (in the future, potentially allowing for orbs to be selected to connect them with springs). During program setup, springs will be turned off and when turned on, springs will become visible and orbs will apply spring force depending on the spring length and spring constant.

--- 

### Simulation 3: Drag
Describe what your drag simulation will look like. Explain how it will be setup, and how it should behave while running.

The drag simulation will apply downwards drag force on each orb (depending on the medium it is going through). During program setup, drag will be turned off and when turned on AND gravity is turned on, the orbs will be dragged down with more force than the gravitational force alone.

--- 

### Simulation 4: Custom force
Describe what your Custom force simulation will look like. Explain how it will be setup, and how it should behave while running.

The buoyancy simulation will allow orbs to sink/float on a medium depending on the mass and size of the orbs, along with the medium the orb is going through. During program setup, buoyancy will be turned off and when turned on, the orbs will eventually either sink or float. They may also sink slightly and float back up or continue sinking downwards if they are dropped down into the fluid (not already in the fluid).

--- 

### Simulation 5: Combination
Describe what your combination simulation will look like. Explain how it will be setup, and how it should behave while running.

The combination simulation will apply every force all at once on every orb. It will be turned off at the start and when turned on, chaos will occur. In the future, maybe another combination button where mass/size/coordinates of orbs are all randomized, along with randomized gravitational constant, spring constant, and more.
