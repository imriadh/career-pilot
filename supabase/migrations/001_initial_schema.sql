-- Enable extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create profiles table
CREATE TABLE profiles (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  full_name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create jobs table
CREATE TABLE jobs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  company_name TEXT NOT NULL,
  job_title TEXT NOT NULL,
  location TEXT,
  job_description TEXT NOT NULL,
  status TEXT CHECK (status IN ('Saved', 'Applied', 'Interview', 'Offer', 'Rejected')) DEFAULT 'Saved',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create resumes table
CREATE TABLE resumes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  resume_text TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create ai_analyses table
CREATE TABLE ai_analyses (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  job_id UUID REFERENCES jobs(id) ON DELETE CASCADE,
  match_score INTEGER,
  matching_skills TEXT[],
  missing_skills TEXT[],
  recommendations TEXT[],
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create interview_sessions table
CREATE TABLE interview_sessions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  job_id UUID REFERENCES jobs(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create interview_questions table
CREATE TABLE interview_questions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  session_id UUID REFERENCES interview_sessions(id) ON DELETE CASCADE,
  question TEXT NOT NULL,
  category TEXT,
  difficulty TEXT,
  answer TEXT,
  score INTEGER,
  strengths TEXT[],
  weaknesses TEXT[],
  suggestions TEXT[],
  feedback TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE resumes ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_analyses ENABLE ROW LEVEL SECURITY;
ALTER TABLE interview_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE interview_questions ENABLE ROW LEVEL SECURITY;

-- Create policies for profiles table
CREATE POLICY "Profiles are viewable by users."
  ON profiles FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can create their own profile."
  ON profiles FOR INSERT
  WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can update their own profile."
  ON profiles FOR UPDATE
  USING (auth.uid() = id);

CREATE POLICY "Users can delete their own profile."
  ON profiles FOR DELETE
  USING (auth.uid() = id);

-- Create policies for jobs table
CREATE POLICY "Users can view their own jobs."
  ON jobs FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create jobs for themselves."
  ON jobs FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own jobs."
  ON jobs FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own jobs."
  ON jobs FOR DELETE
  USING (auth.uid() = user_id);

-- Create policies for resumes table
CREATE POLICY "Users can view their own resumes."
  ON resumes FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create resumes for themselves."
  ON resumes FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own resumes."
  ON resumes FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own resumes."
  ON resumes FOR DELETE
  USING (auth.uid() = user_id);

-- Create policies for ai_analyses table
CREATE POLICY "Users can view their own AI analyses."
  ON ai_analyses FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create AI analyses for themselves."
  ON ai_analyses FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own AI analyses."
  ON ai_analyses FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own AI analyses."
  ON ai_analyses FOR DELETE
  USING (auth.uid() = user_id);

-- Create policies for interview_sessions table
CREATE POLICY "Users can view their own interview sessions."
  ON interview_sessions FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create interview sessions for themselves."
  ON interview_sessions FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own interview sessions."
  ON interview_sessions FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own interview sessions."
  ON interview_sessions FOR DELETE
  USING (auth.uid() = user_id);

-- Create policies for interview_questions table
CREATE POLICY "Users can view their own interview questions."
  ON interview_questions FOR SELECT
  USING (auth.uid() = (SELECT user_id FROM interview_sessions WHERE id = session_id));

CREATE POLICY "Users can create interview questions for their own sessions."
  ON interview_questions FOR INSERT
  WITH CHECK (auth.uid() = (SELECT user_id FROM interview_sessions WHERE id = session_id));

CREATE POLICY "Users can update their own interview questions."
  ON interview_questions FOR UPDATE
  USING (auth.uid() = (SELECT user_id FROM interview_sessions WHERE id = session_id));

CREATE POLICY "Users can delete their own interview questions."
  ON interview_questions FOR DELETE
  USING (auth.uid() = (SELECT user_id FROM interview_sessions WHERE id = session_id));