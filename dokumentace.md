# Module "Projects" of the Student Information System

This document describes the architecture of the Projects module. It is intended primarily for the Student Information System development teams.

## Context

Projects is the part of the Student Information System which is responsible for management of projects, enrolment of students in the project, communication within the project team and with the teacher.

The described Projects context is displayed on the C4 model software system diagram.

## Functional overview

Projects provides its functionality to the user through a web application. It is assumed that the user is logged into the Student Information System using their login credentials. There are two separate Web Applications for [Teacher](#teacher-web-application) and [Student](#student-web-application) due to the fact that the information displayed and the functionality provided are different for teachers and students.
There is also the [Communication Web Application](#communication-web-application) that provides access to the chat interface.
Data containing information about projects is persisted in the Project Database. Data containing chat information is persisted in the Chat Database.

### Teacher Web Application

Teacher uses Teacher Web Application for announcement of project topics, confirmation of the project team, view project details including enrolled students and submitted files. After receiving a request from the Teacher, it retrieves the project data from the Project Manager and sends it to the Teacher via an HTML page.

### Student Web Application

The student uses the Student Web Application to search and filter projects, enroll in required projects, upload and edit project files, view project details including other enrolled students, project supervisor, and submitted files. After receiving a request from the Student, it retrieves the project data from the Project Manager and sends it to the Student via an HTML page.

### Communication Web Application

The Communication Web Application can be accessed from the project page. The Teacher or Student clicks on the "View chat" button and this action will display the chat window. The Communication Web Application also provides a functionality to create a private chat with a selected member. The application is independent of the Student and Teacher Web Applications, requiring only the member IDs and project ID to open the corresponding chat window.
#### Chat notifications
The Communication Web Application displays notifications about new messages and members.

### Project Management
The core Projects logic that processes data received from a Teacher or Student through a Web Application. It provides business logic, data checks and validations, query creation and communication with the Project Database. 
#### System notifications
The Project Management also includes a Notification Manager that sends a notification to the Web Application whether the action was successful or not.
