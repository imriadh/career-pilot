import { Link } from 'react-router-dom'

function Login() {
  return (
    <section className="page-card">
      <h2 className="page-title">Login</h2>
      <p className="page-note">Authentication will be implemented in the authentication phase.</p>
      <p>
        Need an account? <Link to="/register">Register</Link>
      </p>
    </section>
  )
}

export default Login
