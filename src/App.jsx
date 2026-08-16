import { BrowserRouter, Navigate, Route, Routes } from 'react-router-dom'
import AppLayout from './components/layout/AppLayout'
import Analysis from './pages/Analysis'
import Dashboard from './pages/Dashboard'
import Interview from './pages/Interview'
import JobDetails from './pages/JobDetails'
import Jobs from './pages/Jobs'
import Login from './pages/Login'
import Profile from './pages/Profile'
import Register from './pages/Register'
import Resume from './pages/Resume'

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/login" element={<Login />} />
        <Route path="/register" element={<Register />} />

        <Route element={<AppLayout />}>
          <Route path="/" element={<Dashboard />} />
          <Route path="/jobs" element={<Jobs />} />
          <Route path="/jobs/:id" element={<JobDetails />} />
          <Route path="/resume" element={<Resume />} />
          <Route path="/analysis" element={<Analysis />} />
          <Route path="/interview" element={<Interview />} />
          <Route path="/profile" element={<Profile />} />
        </Route>

        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </BrowserRouter>
  )
}

export default App
