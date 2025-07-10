import React from 'react';
import { Outlet, useNavigate } from 'react-router-dom';
import { useAuth } from '../hooks/useAuth';
import { LogOut } from 'lucide-react';

const Layout: React.FC = () => {
  const { signOut } = useAuth();
  const navigate = useNavigate();

  const handleLogout = async () => {
    await signOut();
    navigate('/login');
  };

  return (
    <div className="min-h-screen bg-gray-50">
      <header className="bg-white shadow">
        <div className="mobile-container mx-auto py-3 flex justify-between items-center">
          <h1 className="text-xl sm:text-2xl font-bold text-gray-900">Elite Açaí</h1>
          <button
            onClick={handleLogout}
            className="flex items-center text-gray-600 hover:text-gray-900 transition-colors"
          >
            <LogOut className="h-5 w-5 mr-2" />
            <span className="hidden sm:inline">Sair</span>
          </button>
        </div>
      </header>
      <main className="flex-1 overflow-x-hidden overflow-y-auto">
        <div className="mobile-container mx-auto py-4 sm:py-6">
          <Outlet />
        </div>
      </main>
    </div>
  );
};

export default Layout;