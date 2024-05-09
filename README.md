# Switch
Binary Lamp Switch Game - Crewate Binary Numbers (from 0 to 127) using Lamps :3
With each iteration your time becomes less :3 yay :3 Every ten seconds the time gets less unless you jsut have 10s uwu

> **_NOTE:_**  The options Menu content Box is kinda weird, so just try clicking on differnet places a few times uwu

> **_NOTE:_**  Tutorial is currently for the old UI, Textfields have been moved etc

## Showcase
<img src="https://kiarar.moe/images/Switch/game.png">

### Controls Desktop Version
ESC - naviagte Back to menu
Arrow Keys Up/Down: Navigate Main Menu
Enter/Sapcebar: Confirm selection in main menu
ArrowK Keys Left/Right & Sapcebar/Enter: naviagte in Tutorial

## Game Loop
* The game generates a random decimal number like 42
  * You have to translate this number into binary using the lamps
  * lamp on = 1 * 2^x, lamp of = 0 * 2^x
  * the little arrow on the left/right of the löamps indicates from where to read the number
* when you have corectly replicated the number the remaining time will be added to your score
  * on every 10 iterations your time will get less
  * there is a point where the game ends ;3, but you will always have atleast 10 seconds for a number  
	
## Supported Plattforms
| Plattform         | Status | Supported | Tested |
|--------------|:-----:| :----: | :----: |
| iOS | Testflight | :heavy_check_mark: | :heavy_check_mark:
| MacOS      |  WIP | :x:| :x:
| Android |  WIP  | :heavy_check_mark:| :x:
| Windows      |  WIP | :heavy_check_mark:| :x:

### Compiling for iOS
> **_NOTE:_**  Pls edit the build version in the project file to not be the same as the version number

## Development
### Map Generation
#### Pairing Lamps and Switches
Each lamp becomes a random switch assigned, one random lamps becomes a second random switch

<img src="https://kiarar.moe/images/Switch/map2.png" height= 250>

#### Drawing Wires
p0': Position of the lamp lx
p0: Position of the lamp + padding pad1 (since we dont want the line to start in the middle of the lamp but rather bvelow the lamp)
p1: p0 extended on the y-axis to the assigned level fx

p3': Center Position of the Switch sx
p3: Postion of sx with padding pad2
p2: p3 extended on the y-axis to the assigned level fx

<img src="https://kiarar.moe/images/Switch/map1.png" height= 300>

## Game Options
* Endian Switching (Changes the direction form where you have to read the number in binary)

## Requierements
* Gdoot 4.2.2

## Asset Sources
[Sound](https://pixabay.com/sound-effects/electric-zap-001-6374/)

[Font](http://www.pentacom.jp/pentacom/bitfontmaker2/gallery/?id=646)
