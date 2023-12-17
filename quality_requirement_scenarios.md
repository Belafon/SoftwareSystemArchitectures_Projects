# Quality scenarios for Schedules module

**Task:**

Describe 2*n quality requirement scenarios for at least n quality dimensions.

- $n =$ number of team members
- $>= n/2$ quality requirements in design-time dimensions
  - modifiability, testability, interoperability
- $<= 3*n/2$ quality requirements in run-time dimensions
  - performance, availability, scalability, security

For each scenario, decide if the architecture needs to be updated. Use the tactics from the lecture.

- If yes, update the C4 model and explain.
- If not, explain why the current architecture can fulfill the scenario.

## Availability

1. - Browser (stimulus source): unable to recieve client source code from Static File Server (artifact)
   - The responce: mask the fault and repeat the request within 1 second
   - The architecture can fulfill the scenario by detecting the fault using the HTTP HEAD request method. It is also possible to provide backup copies of the static file server with active redundancy so the system can recover from a fault.

2. - Business Processor (stimulus source): unable to get response (data) about collisions (Example: Ticket Editing, Automatic Scheduling Caller) after sending data to be checked
   - Artifact: Collision Controller
   - Response: mask the fault and postpone (within 5 minutes repeat action), and log
   - The architecture can fulfill scenario by getting response within 5 minutes ??

## Performance

1. - Stimulus Source: Business Processor (Automatic Scheduller Caller)
   - Stimulus: Stimulus Sourcesends request to Automatic Scheduler (artifact) to schedule tickets and the results are not provided in a reasonable time.
   - Artifact: Collision Controller (Automatic Scheduler)
   - Response: The system can analyze the task to estimate the time needed to schedule tickets. If the time is too long, the system can notify the user and ask for permission to make compromises.

## Security

1. - Source of Stimulus: Unknown attacker
   - Stimulus: Request to view schedule of a specific student
   - Artifact: Business Processor
   - Response: Unauthorized request detected
   - Measure: Each unauthorized request is detected and its information is stored for further analysis, such requests are not processed.

2. - Source of Stimulus: Unknown attacker.
   - Stimulus: Request to edit ticket data.
   - Artifact: Business Processor.
   - Response: Unauthorized request detected.


## Scalability

1. - Source of Stimulus: Browser/User
   - Stimulus: Increasing avarage number of requests
   - Artifact: Business Processor
   - Response: Request processing is scaled up
   - Measure: Performance and availability is not affected
  
2. - Source of Stimulus: Browser/User.
   - Stimulus: Higher number of tickets to schedule.
   - Atifact: Business Processor.
   - Response: Automatic scheduling is scaled up.
   - Measure: Performance and availability is not affected.


## Modifiability

## Testability

1. - System tester (stimulus source)
   - Stimulus: Testing Business Processor (dispatcher in particular) with requests
   - Artifact: Business Processor (Dispatcher)
   - Respons: Synthetic user data prepared, correctness of requests dispatching is checked on the data
   - Measure: Coverage of 100% known user requests with different rights and permissions in 3 man-month
  
## Interoperability

1. - The Enrollments module (stimulus source) needs the data from the Schedules module (artifact) to display scheduled tickets (interoperability on data).
   - The responce: 100% of already scheduled tickets are provided
   - The architecture lacks a communication channel with the Enrollments module. API and data format need to be defined.

2. - Stimulus Source: Collision Controller (Automatic Scheduller Caller)
   - Stimulus: Stimulus Source needs data about schoolrooms (artifact), buildings and mutual distances to schedule tickets.
   - Artifact: Student Information System
   - Responce: 100% of schoolrooms and buildings and distances between them are provided
