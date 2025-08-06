# Type3801–3807

Custom set of TRNSYS Types that evaluate multiple logical input signals and return a logical output based on the selected gate type.

## Purpose

```Type3801–3807``` enables the simulation of logic gates within TRNSYS models.  
It supports common logic gates (```AND```, ```NAND```, ```OR```, ```NOR```, ```XOR```, ```XNOR```, ```NOT```) so that users can integrate control logic, switching conditions, and digital decision-making processes directly into their TRNSYS simulations.

> [!NOTE]  
> TRNSYS already provides ```AND```, ```OR```, and ```NOT``` gates within the ```Calculator Type```, which are generally more optimized for simulation speed.  
> The advantage of this set of Types is that they do not require creating custom inputs or outputs within the Calculator, making them easier to integrate and more visually intuitive compared to code-based implementations.

## Requirement

- TRNSYS v.18

## Installation

1. Clone the repo or download the source files:

   ```bash
   git clone https://github.com/allachance/TRNSYS-LogicGates-Type3801-3808.git
   ```

2. Copy the folders into your TRNSYS 18 installation directory, e.g., ```C:\TRNSYS18```

## Configuration

### Parameter

| Name   | Description                                                   | Options                                                                                                                                                                         |
| ------ | ------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `Mode` | Defines how input values are interpreted as `TRUE` or `FALSE` | `1` → Inputs must be exactly 0 (`FALSE`) or 1 (`TRUE`) <br>`2` → Inputs are `TRUE` if greater than 0, `FALSE` if 0 or less <br>`3` → Inputs are `TRUE` if nonzero, `FALSE` if 0 |

### Inputs

| Name               | Description                                 | Options                   |
| ------------------ | ------------------------------------------- | ------------------------- |
| `Input-n`          | Input signal(s) evaluated by the logic gate | —                         |
| `Number of Inputs` | Total number of input signals               | Minimum: 2 / Maximum: 100 |


### Output
| Name     | Description                                | Options |
| -------- | ------------------------------------------ | ------- |
| `Output` | Resulting logical value from the gate type | —       |



## Usage

1. Add the Component in TRNSYS Studio  
   - Insert the desired logic gate into your simulation workspace: 

     - ```Type3801```: `AND`  
     - ```Type3802```: `NAND`  
     - ```Type3803```: `OR`  
     - ```Type3804```: `NOR`  
     - ```Type3805```: `XOR`  
     - ```Type3806```: `XNOR`  
     - ```Type3807```: `NOT`  

2. Configure Parameters  
   - Set the ```Mode``` parameter to define how the inputs should be interpreted as ```TRUE``` or ```FALSE```.  
   - Ensure the number of inputs matches your control logic requirements.  
   - For ```NOT``` gates, only one input should be provided. 

3. Connect Input Signals  
   - Link each `Input-n` port to the variables or outputs in your TRNSYS model that represent the logical conditions  
     (e.g., thermostat signals, switch states, or other binary controls).  

4. Use the Output  
   - The `Output` provides a logical value (`0` or `1`) according to the chosen gate type.  
   - Connect the output to other TRNSYS components such as switches, controllers, or system decision logic.  

5. Example Application  
   Enable a fan only if:  
   - The room temperature is above a threshold `AND`  
   - The occupancy sensor indicates presence.

## Truth Table

### AND (```Type3801```)

| Input A | Input B | Output |
| ------- | ------- | ------ |
| 0       | 0       | 0      |
| 0       | 1       | 0      |
| 1       | 0       | 0      |
| 1       | 1       | 1      |

### NAND (```Type3802```)

| Input A | Input B | Output |
| ------- | ------- | ------ |
| 0       | 0       | 1      |
| 0       | 1       | 1      |
| 1       | 0       | 1      |
| 1       | 1       | 0      |

### OR (```Type3803```)

| Input A | Input B | Output |
| ------- | ------- | ------ |
| 0       | 0       | 0      |
| 0       | 1       | 1      |
| 1       | 0       | 1      |
| 1       | 1       | 1      |

### NOR (```Type3804```)

| Input A | Input B | Output |
| ------- | ------- | ------ |
| 0       | 0       | 1      |
| 0       | 1       | 0      |
| 1       | 0       | 0      |
| 1       | 1       | 0      |

### XOR (```Type3805```)

| Input A | Input B | Output |
| ------- | ------- | ------ |
| 0       | 0       | 0      |
| 0       | 1       | 1      |
| 1       | 0       | 1      |
| 1       | 1       | 0      |

### XNOR (```Type3806```)

| Input A | Input B | Output |
| ------- | ------- | ------ |
| 0       | 0       | 1      |
| 0       | 1       | 0      |
| 1       | 0       | 0      |
| 1       | 1       | 1      |

### NOT (```Type3807```)

| Input A | Output |
| ------- | ------ |
| 0       | 1      |
| 1       | 0      |
