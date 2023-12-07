# Quality scenarios for Schedules module

Task:
```
Describe 2*n quality requirement scenarios for at least n quality dimensions.
n = number of team members
>= n/2 quality requirements in design-time dimensions
modifiability, testability, interoperability
<= 3*n/2 quality requirements in run-time dimensions
performance, availability, scalability, security
For each scenario, decide if the architecture needs to be updated.
Use the tactics from the lecture.
If yes, update the C4 model and explain
If not, explain why the current architecture can fulfill the scenario
```
## Availability
- Browser (stimulus source): unable to recieve client source code from Static File Server (artifact)
  
  The responce: mask the fault and repeat the request within 1 second

  The architecture can fulfill the scenario by detecting the fault using the HTTP HEAD request method. It is also possible to provide backup copies of the static file server with active redundancy so the system can recover from a fault.
  
## Performance
## Security
## Scalability
## Modifiability
## Testability
## Interoperability
- The Enrollments module (stimulus source) needs the data from the Schedules module (artifact) to display scheduled tickets (interoperability on data).

  The responce: 100% of already scheduled tickets are provided

  The architecture lacks a communication channel with the Enrollments module. API and data format need to be defined.

 

  
