# CareerPilot — AI Job & Interview Assistant

## 1. Role

Act as a senior full-stack software engineer and mentor.

I am a beginner in full-stack development and have approximately one week to complete this university project. I will use AI assistance to develop the application, but I must understand the architecture and be able to explain the important parts to my instructor.

Do not generate the entire application at once.

Develop the application incrementally, one feature at a time. Before writing substantial code, explain the architecture and the reason for the implementation. After each implementation, provide testing instructions and explain the important code so I can understand it.

The final application must be clean, maintainable, secure, responsive, and appropriate for a university project and portfolio/CV.

---

# 2. Project

## Name

CareerPilot — AI Job & Interview Assistant

## Purpose

CareerPilot is a web application that helps students and job seekers manage job applications and use AI to analyze job descriptions, identify matching and missing skills, generate interview questions, and provide feedback on interview answers.

The goal is not to create a generic chatbot.

AI must be integrated into specific workflows where it provides useful functionality.

---

# 3. Technology Stack

Frontend:
- React
- JavaScript
- HTML
- CSS
- React Router

Backend / Platform:
- Supabase

Database:
- PostgreSQL through Supabase

Authentication:
- Supabase Authentication

Server-side API integration:
- Supabase Edge Functions
- TypeScript/Deno

AI:
- NVIDIA NIM API
- NVIDIA hosted inference endpoint
- OpenAI-compatible chat-completions API

Deployment:
- Vercel or another suitable free hosting platform

Do not introduce additional frameworks or services unless they are genuinely necessary.

---

# 4. Main Features

## Authentication

Users must be able to:

- Register
- Login
- Logout
- Maintain a session
- Access protected pages only after authentication

Use Supabase Authentication.

Do not implement custom password storage.

---

# 5. Dashboard

The dashboard should display:

- Total applications
- Applications currently active
- Interview count
- Rejected applications
- Recent applications

The dashboard should be clean and responsive.

---

# 6. Job Application Management

Users can:

- Create a job application
- View their applications
- View application details
- Edit an application
- Delete an application
- Change application status

Application statuses:

- Saved
- Applied
- Interview
- Offer
- Rejected

Job fields:

- Company name
- Job title
- Location
- Job description
- Status
- Created date

Users must only be able to access their own applications.

---

# 7. Resume/Profile Information

The first version does NOT need complicated PDF parsing.

Allow the user to enter or paste resume information as text.

Store:

- User ID
- Resume text
- Created date
- Updated date

The user should be able to update their resume information.

---

# 8. AI Job Analysis

This is the primary AI feature.

The user selects a job and clicks:

"Analyze with AI"

The application sends:

- Job description
- Resume text

to a secure Supabase Edge Function.

The Edge Function calls the NVIDIA NIM API.

The AI should analyze the compatibility between the resume and job description.

The AI should return structured JSON containing:

- match_score
- matching_skills
- missing_skills
- recommendations

Example:

{
  "match_score": 78,
  "matching_skills": [
    "JavaScript",
    "React",
    "HTML",
    "CSS"
  ],
  "missing_skills": [
    "TypeScript",
    "Next.js"
  ],
  "recommendations": [
    "Highlight React project experience",
    "Mention JavaScript experience more clearly"
  ]
}

Do not rely on fragile string parsing if structured JSON can be requested.

Validate the response before displaying it.

Save the useful analysis result in the database.

---

# 9. AI Interview Question Generator

The user selects a job and clicks:

"Prepare for Interview"

The AI should generate approximately 5 interview questions based on:

- Job title
- Job description
- Required skills

Each question should include:

- Question
- Category
- Difficulty

Example:

{
  "question": "What is the difference between useState and useEffect?",
  "category": "React",
  "difficulty": "Medium"
}

Store the interview session and questions in Supabase.

---

# 10. AI Interview Answer Evaluation

The user answers a generated question.

Send:

- Question
- User answer
- Job context

to the NVIDIA AI service.

Return:

- Score from 0–10
- Strengths
- Weaknesses
- Improvement suggestions
- Short feedback

Example:

{
  "score": 7,
  "strengths": [
    "Correctly explained state management"
  ],
  "weaknesses": [
    "Did not explain the dependency array"
  ],
  "suggestions": [
    "Explain when useEffect executes"
  ],
  "feedback": "Your answer demonstrates a basic understanding..."
}

Do not claim that AI evaluation is objectively correct. Present it as AI-assisted feedback.

---

# 11. Database Schema

Use a simple relational design.

## profiles

Fields:

- id
- full_name
- email
- created_at

The id should correspond to the authenticated Supabase user.

## jobs

Fields:

- id
- user_id
- company_name
- job_title
- location
- job_description
- status
- created_at
- updated_at

## resumes

Fields:

- id
- user_id
- resume_text
- created_at
- updated_at

## ai_analyses

Fields:

- id
- user_id
- job_id
- match_score
- matching_skills
- missing_skills
- recommendations
- created_at

## interview_sessions

Fields:

- id
- user_id
- job_id
- created_at

## interview_questions

Fields:

- id
- session_id
- question
- category
- difficulty
- answer
- score
- strengths
- weaknesses
- suggestions
- feedback
- created_at

Use appropriate primary keys, foreign keys, timestamps, constraints, and indexes.

---

# 12. Row Level Security

Security is mandatory.

Enable Row Level Security for user-owned tables.

A user must only be able to:

- Read their own records
- Insert records belonging to themselves
- Update their own records
- Delete their own records

Do not depend only on frontend filtering for security.

Explain every RLS policy clearly.

The application should demonstrate proper database authorization.

---

# 13. AI API Security

Never place the NVIDIA API key in React frontend code.

The NVIDIA API key must remain server-side.

Use Supabase Edge Functions.

Store the NVIDIA API key as a Supabase secret/environment variable.

The React frontend should call the Edge Function rather than NVIDIA directly.

The Edge Function should:

1. Authenticate/authorize the request.
2. Validate input.
3. Retrieve or receive the required data.
4. Call NVIDIA.
5. Validate the AI response.
6. Return a safe response to the frontend.
7. Handle errors properly.

Never expose the NVIDIA secret to the browser.

---

# 14. React Project Structure

Use a maintainable structure similar to:

src/
  components/
    ui/
    layout/
    jobs/
    interview/

  pages/
    Login.jsx
    Register.jsx
    Dashboard.jsx
    Jobs.jsx
    JobDetails.jsx
    Resume.jsx
    Analysis.jsx
    Interview.jsx
    Profile.jsx

  hooks/
    useAuth.js
    useJobs.js

  services/
    jobs.js
    resume.js
    ai.js

  lib/
    supabase.js

  utils/
    validation.js

  App.jsx
  main.jsx

supabase/
  migrations/
    database.sql

  functions/
    ai-analysis/
      index.ts

Do not put the whole application inside App.jsx.

Keep components focused and reusable.

---

# 15. React Coding Standards

Follow modern React practices.

Use:

- Functional components
- Hooks
- React Router
- Strict Mode
- ESLint
- Reusable components
- Controlled forms where appropriate
- Proper loading states
- Proper error states
- Empty states

Do not:

- Use class components
- Mutate state directly
- Put API keys in frontend code
- Put huge amounts of logic inside JSX
- Create unnecessary global state
- Duplicate the same code in many components
- Use useEffect unnecessarily

Keep components reasonably small.

---

# 16. JavaScript Standards

Use:

- const by default
- let only when necessary
- async/await
- try/catch for asynchronous failures
- descriptive variable names
- small functions
- reusable utility functions
- clear error handling

Avoid:

- var
- deeply nested functions
- duplicated code
- unexplained magic numbers
- unnecessary dependencies

---

# 17. Supabase Standards

Use the Supabase JavaScript client.

Keep database operations in service modules rather than scattering database queries throughout UI components.

Handle Supabase errors explicitly.

Do not expose privileged/service-role keys in the browser.

Use Row Level Security for authorization.

Use migrations for the database schema rather than relying only on manual dashboard changes.

---

# 18. Edge Function Standards

Use TypeScript.

Keep NVIDIA API integration inside the Edge Function.

Validate incoming requests.

Validate AI output.

Handle:

- invalid input
- unauthenticated requests
- NVIDIA API failures
- timeouts
- malformed responses
- empty responses

Keep secrets in environment variables.

Do not log sensitive information.

Create reusable shared utilities if appropriate.

---

# 19. AI Prompting Standards

Do not use vague prompts such as:

"Analyze this resume."

Use explicit instructions.

The AI should:

- Follow a defined role
- Receive clearly labeled input
- Return the required JSON structure
- Avoid unnecessary prose
- Avoid inventing information
- Base recommendations only on the provided information
- Clearly indicate uncertainty when appropriate

For structured responses, use a clearly defined schema and validate the returned object.

---

# 20. UI/UX Requirements

The application must be responsive.

Desktop and mobile layouts should work.

Every asynchronous operation should have a visible state:

Loading:
"Analyzing..."

Success:
"Analysis completed."

Error:
"Unable to complete the analysis. Please try again."

Empty state:
"No applications yet."

Destructive actions such as deleting a job should require confirmation.

Use accessible labels for form fields.

Do not sacrifice usability for visual effects.

---

# 21. Environment Variables

Use environment variables.

Frontend may contain only public Supabase configuration that is safe for browser use.

Never put:

- NVIDIA secret
- Supabase service-role key
- other privileged credentials

in frontend environment variables.

Create a `.env.example` file showing required variable names without real secrets.

---

# 22. Error Handling

Every major feature must handle failure.

Examples:

- Failed login
- Failed database request
- Failed job creation
- Failed AI request
- Invalid AI response
- Network failure
- Empty resume
- Empty job description

Never silently ignore errors.

Show user-friendly messages.

Log only useful non-sensitive information for debugging.

---

# 23. Testing

After implementing each feature, explain how to test it manually.

Minimum test cases:

Authentication:
- Register
- Login
- Logout
- Access protected page without login

Jobs:
- Create
- Read
- Update
- Delete
- Invalid form submission

Authorization:
- User A cannot access User B's records

AI:
- Valid analysis
- Missing resume
- Missing job description
- NVIDIA API failure
- Malformed AI response

Interview:
- Generate questions
- Answer question
- Evaluate answer
- Handle AI failure

---

# 24. Development Process

DO NOT generate the entire project in one response.

Work in the following order:

Phase 1:
Project initialization and dependencies.

Phase 2:
Supabase setup and database schema.

Phase 3:
Authentication.

Phase 4:
Application layout and routing.

Phase 5:
Job CRUD.

Phase 6:
Resume/profile management.

Phase 7:
Row Level Security verification.

Phase 8:
NVIDIA AI Edge Function.

Phase 9:
AI job analysis.

Phase 10:
Interview question generation.

Phase 11:
Answer evaluation.

Phase 12:
UI polish and responsive design.

Phase 13:
Testing and security review.

Phase 14:
Deployment.

Phase 15:
README and project documentation.

After each phase:

1. Explain what was implemented.
2. Show only the files that need to be created or modified.
3. Provide complete code for those files.
4. Explain important sections.
5. Provide exact commands to run.
6. Provide manual testing steps.
7. Mention common errors and how to fix them.
8. Wait for confirmation before moving to the next major phase.

---

# 25. Important AI Coding Rule

Do not invent APIs, package names, Supabase methods, NVIDIA endpoints, or configuration values.

If a current API detail is uncertain, say that it needs verification against the official documentation rather than guessing.

Prefer official documentation.

Do not introduce a library when the existing stack can solve the problem cleanly.

---

# 26. Beginner-Friendly Explanation Requirement

I am a beginner in full-stack development.

Whenever you introduce:

- API
- REST
- authentication
- JWT
- RLS
- Edge Functions
- environment variables
- database relationships
- async/await
- React hooks

briefly explain what it is, why we need it, and where it is used in this project.

Do not overwhelm me with unnecessary theory.

---

# 27. Scope Restriction

The project must remain achievable within approximately one week.

Do NOT add:

- payment
- social login unless necessary
- job scraping
- LinkedIn integration
- Gmail integration
- voice interview
- real-time chat
- vector database
- RAG
- autonomous agents
- complex recommendation systems
- microservices
- Kubernetes
- Docker unless specifically required
- unnecessary third-party services

The goal is a polished MVP.

---

# 28. Definition of Done

The project is considered complete when:

- User can register and log in.
- User can create and manage job applications.
- User can store resume information.
- User can analyze a job using NVIDIA AI.
- AI returns matching and missing skills.
- User can generate interview questions.
- User can answer questions.
- AI can provide interview feedback.
- Data is persisted in Supabase PostgreSQL.
- Row Level Security prevents cross-user access.
- NVIDIA API key is never exposed to the browser.
- Application is responsive.
- Loading and error states work.
- Project is deployed.
- README explains setup and architecture.
- I can explain the main architecture to my instructor.

---

# 29. Start Here

Do not write the entire application.

Start with Phase 1 only.

First explain:

1. Final architecture.
2. Required software/accounts.
3. React project initialization.
4. Required npm packages.
5. Folder structure.
6. Why each major technology is being used.

Then provide the exact commands and files required for Phase 1.

Wait for me to test Phase 1 before proceeding.