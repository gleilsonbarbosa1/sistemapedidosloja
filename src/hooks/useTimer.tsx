import { createContext, useContext, useEffect, useState } from 'react';

interface TimerContextType {
  startTime: number | null;
  isRunning: boolean;
  elapsedTime: number;
  startTimer: () => void;
  stopTimer: () => void;
  resetTimer: () => void;
  formatTime: (ms: number) => string;
}

const TimerContext = createContext<TimerContextType | undefined>(undefined);

const TIMER_STORAGE_KEY = 'timerState';

export const TimerProvider = ({ children }: { children: React.ReactNode }) => {
  const [timerState, setTimerState] = useState(() => {
    const savedState = localStorage.getItem(TIMER_STORAGE_KEY);
    if (savedState) {
      const { startTime, isRunning, elapsedTime } = JSON.parse(savedState);
      if (isRunning && startTime) {
        const storedStartTime = parseInt(startTime);
        const currentTime = Date.now();
        const newElapsedTime = currentTime - storedStartTime;
        return {
          startTime: storedStartTime,
          isRunning: true,
          elapsedTime: newElapsedTime
        };
      }
      return { startTime: null, isRunning: false, elapsedTime: parseInt(elapsedTime) || 0 };
    }
    return { startTime: null, isRunning: false, elapsedTime: 0 };
  });

  useEffect(() => {
    let intervalId: NodeJS.Timeout;

    if (timerState.isRunning && timerState.startTime) {
      intervalId = setInterval(() => {
        const newElapsedTime = Date.now() - timerState.startTime!;
        setTimerState(prev => ({ ...prev, elapsedTime: newElapsedTime }));
        
        // Save to localStorage
        localStorage.setItem(TIMER_STORAGE_KEY, JSON.stringify({
          startTime: timerState.startTime,
          isRunning: true,
          elapsedTime: newElapsedTime
        }));
      }, 1000);
    }

    return () => {
      if (intervalId) {
        clearInterval(intervalId);
      }
    };
  }, [timerState.isRunning, timerState.startTime]);

  const startTimer = () => {
    if (!timerState.isRunning) {
      const now = Date.now();
      const newState = {
        startTime: now - timerState.elapsedTime,
        isRunning: true,
        elapsedTime: timerState.elapsedTime
      };
      setTimerState(newState);
      localStorage.setItem(TIMER_STORAGE_KEY, JSON.stringify(newState));
    }
  };

  const stopTimer = () => {
    if (timerState.isRunning) {
      const newState = {
        ...timerState,
        isRunning: false
      };
      setTimerState(newState);
      localStorage.setItem(TIMER_STORAGE_KEY, JSON.stringify(newState));
    }
  };

  const resetTimer = () => {
    const newState = {
      startTime: null,
      isRunning: false,
      elapsedTime: 0
    };
    setTimerState(newState);
    localStorage.setItem(TIMER_STORAGE_KEY, JSON.stringify(newState));
  };

  const formatTime = (ms: number) => {
    const seconds = Math.floor(ms / 1000);
    const minutes = Math.floor(seconds / 60);
    const hours = Math.floor(minutes / 60);
    
    const pad = (n: number) => n.toString().padStart(2, '0');
    
    return `${pad(hours)}:${pad(minutes % 60)}:${pad(seconds % 60)}`;
  };

  return (
    <TimerContext.Provider value={{
      ...timerState,
      startTimer,
      stopTimer,
      resetTimer,
      formatTime
    }}>
      {children}
    </TimerContext.Provider>
  );
};

export const useTimer = () => {
  const context = useContext(TimerContext);
  if (!context) {
    throw new Error('useTimer must be used within a TimerProvider');
  }
  return context;
};