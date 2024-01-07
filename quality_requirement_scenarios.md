# Quality scenarios for Schedules module

**Task:**

Describe 12 quality requirement scenarios for at least 6 quality dimensions.

- $>= 3$ quality requirements in design-time dimensions
  - [modifiability](#modifiability), [testability](#testability), [interoperability](#interoperability)
- $<= 9$ quality requirements in run-time dimensions
  - [performance](#performance), [availability](#availability), [scalability](#scalability), [security](#security)

For each scenario, decide if the architecture needs to be updated. Use the tactics from the lecture.

- If yes, update the C4 model and explain.
- If not, explain why the current architecture can fulfill the scenario.

**Template for a requirement:**

```markdown
### Scenario number

- Source of Stimulus:
- Stimulus:
- Artifact:
- Response:
- Measure:
- Architecture: OK / Needs update

Why is the architecture OK. / Note about architecture changes.
```

---

## Availability

### Scenario 1

- Source of Stimulus: Browser
- Stimulus: Inability to receive client source code from Static File Server
- Artifact: Static File Server
- Response: Mask the fault and repeat the request
- Measure: 1-second downtime
- Architecture: Needs update

Current architecture fails to respond if Static File Server is unavailable. Implementing active redundancy and fault detection using HTTP HEAD requests will improve reliability.

Browser should send the request to the Request Handler, which will request data from the Static File Server and repeat the request if needed. It is also possible to provide backup copies of the static file server with active redundancy so the system can recover from a fault. If the Static File Server does not respond repeatedly, the Request Handler will redirect the request to one of back up copies.

### Scenario 2

- Stimulus source: Business Processor
- Stimulus: Unable to get collision data response (Example: Ticket Editing, Automatic Scheduling Caller) after sending data to be checked
- Artifact: Collision Controller
- Response: Mask the fault, postpone, and log
- Measure: 5-minute retry interval
- Architecture: Needs update

New container will be added for queueing requests. Within 5 minutes request will be sent to the Business processor again to be sent to Collision Controller and serviced.

### Scenario 3

- Source of Stimulus: Browser/User
- Stimulus: No response from the system
- Artifact: Business Processor
- Response: Mask the fault and repeat the request
- Measure: 5-second downtime
- Architecture: TODO

TODO

---

## Performance

1. - Automatic Scheduller Caller sends request to Automatic Scheduler to schedule tickets and the results have to be provided in a reasonable time.
   - Stimulus Source: Business Processor (Automatic Scheduller Caller)
   - Artifact: Collision Controller (Automatic Scheduler)
   - Response: The system can analyze the task to estimate the time needed to schedule tickets. If the time is too long, the system can notify the user and ask for permission to make compromises.
   - Measure: The estimate corresponds approximately to the final time.

---

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

---

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

---

## Modifiability

---

## Testability

1. - System tester (stimulus source)
   - Stimulus: Testing Business Processor (dispatcher in particular) with requests
   - Artifact: Business Processor (Dispatcher)
   - Response: Synthetic user data prepared, correctness of requests dispatching is checked on the data
   - Measure: Coverage of 100% known user requests with different rights and permissions in 3 man-months

2. - Source of Stimulus: System tester
   - Stimulus: Testing Collision Controller with tickets to check for collisions
   - Artifact: Collision Controller (Collision Checker)
   - Response: Synthetic tickets prepared and checked for collisions
   - Measure: Coverage of 100% known kinds of collisions in 2 man-weeks

---

## Interoperability

1. - The Enrollments module (stimulus source) needs the data from the Schedules module (artifact) to display scheduled tickets (interoperability on data).
   - The responce: 100% of already scheduled tickets are provided
   - The architecture lacks a communication channel with the Enrollments module. The Dispatcher for the communication with external services should be added.

2. - Stimulus Source: Collision Controller (Automatic Scheduller Caller)
   - Stimulus: Stimulus Source needs data about schoolrooms, buildings and mutual distances from the Student Information System to schedule tickets.
   - Artifact: Collision Controller (Automatic Scheduller Caller)
   - Response: Data about schoolrooms, buildings and distances between them are provided.
