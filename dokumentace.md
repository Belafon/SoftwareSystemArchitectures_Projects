# Module "Projects" of the Student Information System

This document describes the architecture of the Projects module. It is intended primarily for the Student Information System development teams.

## Context

Projects is the part of the Student Information System which is responsible for management of projects, enrolment of students in the project, communication within a team and with a teacher.

The described Projects context is displayed on the C4 model software system diagram.

## Functional overview

Projects provides its functionality to the user through a web application. It is assumed that the user is logged into the Student Information System using their login  credentials. There are two separate web applications for teacher and student *(why?)*  and the Communication web application that provides access to the chat interface. Data containing information about projects is persisted in the Project Database. Data containing chat information is persisted in the Chat Database.

### Teacher Web Application
Teacher uses Teacher Web Application for announcement of project topics, confirmation of the project team, view project details including enrolled students and submitted files. 
*(add details on how the data is retrieved and sent to the user via the html page.)*


### Student Web Application


### Communication Web Application

The Communication Web Application can be accessed from the project page. The teacher or student clicks on the "View chat" button and this action will display the chat window. *(add something about creating a new chat with different members, private chats...)*
*(add more technical details about how the communication takes place)*
#### Chat notifications
The Communication Web Application displays notifications about new messages, members, *(what else...)*

### Project Management
The core Projects logic that processes data received from a Teacher or Student through a Web Application. It provides business logic, data checks and validations, query creation and communication with the Project Database. 
#### System notifications
The Project Management also includes a Notification Manager that sends a notification to the Web Application whether the action was successful or not.
