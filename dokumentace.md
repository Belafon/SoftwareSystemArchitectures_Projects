# Module "Projects" of the Student Information System

This document describes the architecture of the `Projects` module. It is intended primarily for the `Student Information System` (`SIS` for short) development teams.

## Context

`Projects` is the part of the `SIS` and is responsible for management of projects, enrolment of students in the project, communication within the project team and with the teacher.

The described `Projects` context is displayed on the C4 model software system diagram.

## Functional overview

`Projects` provides its functionality to the user through a web application. It is assumed that the user is logged into the `SIS` using their login credentials. There are two separate Web Applications for [Teacher](#teacher-web-application) and [Student](#student-web-application) due to the fact that the information displayed and the functionality provided are different for teachers and students.

There is also the [Communication Web Application](#communication-web-application) that provides access to the chat interface.

Data containing information about projects is persisted in the `Project Database`. Data containing chat information is persisted in the `Chat Database`.

### Teacher Web Application

`Teacher` uses `Teacher Web Application` for announcement of project topics, confirmation of the project team, view project details including enrolled students and submitted files. After receiving a request from the `Teacher`, it retrieves the project data from the `Project Manager` and sends it to the `Teacher` via an HTML page.

### Student Web Application

The student uses the `Student Web Application` to search and filter projects, enroll in required projects, upload and edit project files, view project details including other enrolled students, project supervisor, and submitted files. After receiving a request from the `Student`, it retrieves the project data from the `Project Manager` and sends it to the `Student` via an HTML page.

### Communication Web Application

Accessible from the project page, the `Communication Web Application` allows either a `Teacher` or `Student` to initiate a chat by clicking the `View chat` button, which redirects to the chat web application. This application offers a feature for initiating private chats with specific members. It operates separately from the `Student` and `Teacher Web Applications`, necessitating only the member IDs and project ID to launch the appropriate chat window.

The simplicity of the redirect is achieved by the `Communication Web Application` having it's own `Chat Database`, which stores the chat logs and member information. The exact details of the redirect are implementation specific.

#### Chat notifications

The `Communication Web Application` displays notifications about new messages and members.

### Project Management

The core `Projects` logic that processes data received from a `Teacher` or `Student` through a `Web Application`. It provides business logic, data checks and validations, query creation and communication with the `Project Database`.

#### System notifications

The `Project Management` also includes a `Notification Manager` that sends a notification to the `Web Application` whether the action was successful or not.
