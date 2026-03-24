🕹️ Pac-Man (x86 Assembly)

A fully playable Pac-Man clone written in x86 Assembly, running in DOS graphics mode (Mode 13h). This project demonstrates low-level programming concepts including direct memory manipulation, interrupt handling, and basic game engine design.

🚀 Features
🎮 Classic Pac-Man gameplay (movement, scoring, lives)
👻 Multiple ghosts with different behaviors and AI patterns
🧠 Collision detection using pixel color analysis
🍒 Power-up system (freight mode / ghost-eating mode)
🗺️ Custom map rendered from BMP files
🎨 Sprite-based animations (Pac-Man + ghosts)
📊 Score tracking and high score system
🖱️ Main menu with keyboard/mouse interaction
⚙️ Technical Highlights
Written entirely in x86 Assembly (MASM/TASM syntax)
Uses BIOS interrupts (INT 10h, INT 16h, INT 21h) for:
Graphics rendering
Keyboard input
File handling
Runs in 320x200 (Mode 13h) with direct video memory access
Custom BMP loader for rendering sprites and backgrounds
Modular structure with procedures for:
Movement & animation
Ghost AI logic
Collision detection
Game state management
🧠 Ghost AI

Each ghost has a unique behavior:

🔴 Red: Semi-random movement with obstacle awareness
🔵 Blue: Tracks Pac-Man’s position
🟠 Orange: Follows a corner-based patrol logic
🎯 Learning Goals

This project was built to explore:

Low-level graphics programming
Game loop design in Assembly
Memory and register management
Real-time input handling
Procedural decomposition in Assembly
▶️ How to Run
Compile using an assembler like TASM / MASM
Run in a DOS environment (DOSBox recommended)
Make sure all .BMP assets are in the same directory
📁 Assets

The game uses multiple .BMP files for:

Sprites (Pac-Man, ghosts)
Map rendering
UI (menu, win screen)
