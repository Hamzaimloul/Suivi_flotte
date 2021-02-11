# Driver behavior Cluster  
**Introduction**
In this project, we tried to create a statistical model to cluster driver behavior based on CAN Bus sensors data.  
We will use Hierarchical clustering to identify and group the drivers based on their behavior and driving style. This identification of drivers can be used for improvements.

**Features**
`id`:     identifier of the vehicle.  
`odo`:    The odometer reading from the vehicle in km.  
`dist`:   Driven distance during the time period.  
`fuelc`:  Total fuel consumption during report period while driving, idling and using a power take-off (litres).  
`idle`:   Engine running time in idle mode expressed as HH:MM:SS  
`pause`:  Engine running time with pause expressed as HH:MM:SS  
`fuelr`:  How many litres of fuel the vehicle or driver has consumed per 100 km.  
