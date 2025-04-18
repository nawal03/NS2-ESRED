# ESRED: Extended Stabilized RED in NS2

This project is an NS2-based implementation of an extended version of the **Stabilized Random Early Drop (SRED)** algorithm, tailored to enhance **TCP congestion control**.

## Background

SRED is an Active Queue Management (AQM) algorithm that stabilizes queue length by probabilistically dropping packets before a queue overflows. It maintains a *zombie list* of flow identifiers to detect high-bandwidth flows ("zombies") and penalize them accordingly.

## What This Project Adds

In the original SRED paper, no timestamps were used in managing the zombie list. This project introduces an extension, **ESRED (Extended Stabilized RED)**, with the following enhancements:

 **Timestamp-Based Zombie Tracking:**  
  Each zombie flow now stores a timestamp for when it was last updated.

 **Dynamic Overwrite Probability (`p<sub>overwrite</sub>`):**  
  Instead of using a fixed probability to overwrite a zombie when there is no hit, we dynamically adjust `p<sub>overwrite</sub>` based on the age of the existing zombie.  
  - **Older zombies → higher `p<sub>overwrite</sub>`**
  - **Newer zombies → lower `p<sub>overwrite</sub>`**

This timestamp-aware logic helps better track and penalize active flows, improving fairness and responsiveness in TCP networks.
