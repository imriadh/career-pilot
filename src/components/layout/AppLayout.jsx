import { Link, Outlet } from 'react-router-dom'

const navItems = [
  { path: '/', label: 'Dashboard' },
  { path: '/jobs', label: 'Jobs' },
  { path: '/resume', label: 'Resume' },
  { path: '/analysis', label: 'Analysis' },
  { path: '/interview', label: 'Interview' },
  { path: '/profile', label: 'Profile' },
]

function AppLayout() {
  return (
    <>
      <header className="container" style={{ paddingBlock: '1rem' }}>
        <h1 style={{ margin: 0 }}>CareerPilot</h1>
        <nav style={{ display: 'flex', gap: '0.75rem', flexWrap: 'wrap', marginTop: '0.75rem' }}>
          {navItems.map((item) => (
            <Link key={item.path} to={item.path}>
              {item.label}
            </Link>
          ))}
        </nav>
      </header>

      <main className="container" style={{ paddingBottom: '1.5rem' }}>
        <Outlet />
      </main>
    </>
  )
}

export default AppLayout
