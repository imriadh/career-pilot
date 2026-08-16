import { Link } from 'react-router-dom'

function Register() {
  return (
    <section className="page-card">
      <h2 className="page-title">Register</h2>
      <p className="page-note">Authentication will be implemented in the authentication phase.</p>
      <p>
        Already have an account? <Link to="/login">Login</Link>
      </p>
    </section>
  )
}

export default Register
