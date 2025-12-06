import { useState, useEffect } from 'react'
import axios from 'axios'
import './App.css'

const API_URL = import.meta.env.VITE_API_URL || ''
console.log('API_URL:', API_URL)

function App() {
  const [user, setUser] = useState(null)
  const [view, setView] = useState('login')
  const [formData, setFormData] = useState({
    username: '',
    password: '',
    role: 'ROLE_USER'
  })
  const [rides, setRides] = useState([])
  const [newRide, setNewRide] = useState({ pickupLocation: '', dropLocation: '' })
  const [message, setMessage] = useState('')

  // auto-load rides when logged in
  useEffect(() => {
    if (user) loadRides()
  }, [user])

  const showMessage = (msg) => {
    setMessage(msg)
    setTimeout(() => setMessage(''), 3000)
  }

  const handleAuth = async (isLogin) => {
    try {
      const endpoint = isLogin ? `${API_URL}/api/auth/login` : `${API_URL}/api/auth/register`
      const { data } = await axios.post(endpoint, formData)
      
      if (isLogin && data.token) {
        setUser({ ...formData, token: data.token })
        setView('dashboard')
        showMessage('Welcome back!')
      } else {
        showMessage(data.message || 'Account created! Please login.')
        setView('login')
      }
    } catch (error) {
      showMessage(error.response?.data?.message || 'Something went wrong')
    }
  }

  const loadRides = async () => {
    if (!user) return
    try {
      const endpoint = user.role === 'ROLE_DRIVER' ? `${API_URL}/api/v1/driver/rides` : `${API_URL}/api/v1/user/rides`
      const { data } = await axios.get(endpoint, {
        headers: { Authorization: `Bearer ${user.token}` }
      })
      setRides(data)
    } catch (error) {
      showMessage('Failed to load rides')
    }
  }

  const createRide = async () => {
    if (!newRide.pickupLocation || !newRide.dropLocation) return
    try {
      await axios.post(`${API_URL}/api/v1/rides`, newRide, {
        headers: { Authorization: `Bearer ${user.token}` }
      })
      setNewRide({ pickupLocation: '', dropLocation: '' })
      showMessage('Ride created!')
      loadRides()
    } catch (error) {
      showMessage('Failed to create ride')
    }
  }

  const acceptRide = async (rideId) => {
    try {
      await axios.post(`${API_URL}/api/v1/rides/${rideId}/accept`, {}, {
        headers: { Authorization: `Bearer ${user.token}` }
      })
      showMessage('Ride accepted!')
      loadRides()
    } catch (error) {
      showMessage('Failed to accept ride')
    }
  }

  const completeRide = async (rideId) => {
    try {
      await axios.post(`${API_URL}/api/v1/rides/${rideId}/complete`, {}, {
        headers: { Authorization: `Bearer ${user.token}` }
      })
      showMessage('Ride completed!')
      loadRides()
    } catch (error) {
      showMessage('Failed to complete ride')
    }
  }

  const logout = () => {
    setUser(null)
    setView('login')
    setRides([])
    showMessage('Logged out')
  }

  return (
    <div className="app">
      {message && <div className="toast">{message}</div>}

      {!user ? (
        <div className="auth-container">
          <div className="auth-box">
            <h1>RideSharz</h1>
            <div className="tabs">
              <button 
                className={view === 'login' ? 'active' : ''} 
                onClick={() => setView('login')}
              >
                Login
              </button>
              <button 
                className={view === 'register' ? 'active' : ''} 
                onClick={() => setView('register')}
              >
                Register
              </button>
            </div>

            <input
              type="text"
              placeholder="Username"
              value={formData.username}
              onChange={(e) => setFormData({ ...formData, username: e.target.value })}
            />
            <input
              type="password"
              placeholder="Password"
              value={formData.password}
              onChange={(e) => setFormData({ ...formData, password: e.target.value })}
            />
            
            {view === 'register' && (
              <select 
                value={formData.role}
                onChange={(e) => setFormData({ ...formData, role: e.target.value })}
              >
                <option value="ROLE_USER">Passenger</option>
                <option value="ROLE_DRIVER">Driver</option>
              </select>
            )}

            <button 
              className="primary"
              onClick={() => handleAuth(view === 'login')}
            >
              {view === 'login' ? 'Login' : 'Register'}
            </button>
          </div>
        </div>
      ) : (
        <div className="dashboard">
          <header>
            <h2>Hey, {user.username}</h2>
            <button onClick={logout}>Logout</button>
          </header>

          {user.role === 'ROLE_USER' ? (
            <div className="content">
              <div className="card">
                <h3>Request a Ride</h3>
                <input
                  type="text"
                  placeholder="Pickup location"
                  value={newRide.pickupLocation}
                  onChange={(e) => setNewRide({ ...newRide, pickupLocation: e.target.value })}
                />
                <input
                  type="text"
                  placeholder="Drop location"
                  value={newRide.dropLocation}
                  onChange={(e) => setNewRide({ ...newRide, dropLocation: e.target.value })}
                />
                <button className="primary" onClick={createRide}>Book Ride</button>
              </div>

              <div className="card">
                <h3>My Rides</h3>
                {rides.length === 0 ? (
                  <p className="empty">No rides yet</p>
                ) : (
                  rides.map(ride => (
                    <div key={ride.id} className="ride-card">
                      <div className="ride-info">
                        <p><strong>From:</strong> {ride.pickupLocation}</p>
                        <p><strong>To:</strong> {ride.dropLocation}</p>
                        <span className={`status ${ride.status.toLowerCase()}`}>
                          {ride.status}
                        </span>
                      </div>
                    </div>
                  ))
                )}
              </div>
            </div>
          ) : (
            <div className="content">
              <div className="card">
                <h3>Available Rides</h3>
                {rides.length === 0 ? (
                  <p className="empty">No rides available</p>
                ) : (
                  rides.map(ride => (
                    <div key={ride.id} className="ride-card">
                      <div className="ride-info">
                        <p><strong>From:</strong> {ride.pickupLocation}</p>
                        <p><strong>To:</strong> {ride.dropLocation}</p>
                        <span className={`status ${ride.status.toLowerCase()}`}>
                          {ride.status}
                        </span>
                      </div>
                      {ride.status === 'REQUESTED' && (
                        <button onClick={() => acceptRide(ride.id)}>Accept</button>
                      )}
                      {ride.status === 'ACCEPTED' && (
                        <button onClick={() => completeRide(ride.id)}>Complete</button>
                      )}
                    </div>
                  ))
                )}
              </div>
            </div>
          )}
        </div>
      )}
    </div>
  )
}

export default App
