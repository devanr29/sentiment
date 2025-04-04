import { Link, useLocation } from 'react-router-dom';
import { motion } from 'framer-motion';
import '../styles/Header.css';

export default function Header() {
  const location = useLocation();

  return (
    <nav className="nav">
      <div className="logo">SentimentScope</div>
      <div className="menu">
        <Link to="/" className={location.pathname === '/' ? 'active' : ''}>Home</Link>
        <Link to="/analyze" className={location.pathname === '/analyze' ? 'active' : ''}>Analyze</Link>
        <Link to="/about" className={location.pathname === '/about' ? 'active' : ''}>About</Link>
      </div>
    </nav>
  );
}
