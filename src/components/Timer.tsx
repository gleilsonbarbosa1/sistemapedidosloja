import React from 'react';
import { Timer as TimerIcon } from 'lucide-react';
import { useTimer } from '../hooks/useTimer';

const Timer: React.FC = () => {
  const { elapsedTime, formatTime } = useTimer();

  return (
    <div className="flex items-center bg-purple-50 rounded-lg px-3 sm:px-4 py-2 border-2 border-purple-500">
      <TimerIcon className="h-4 w-4 sm:h-5 sm:w-5 mr-2 text-purple-600" />
      <span className="font-mono text-sm sm:text-base text-purple-600 font-medium">
        {formatTime(elapsedTime)}
      </span>
    </div>
  );
};

export default Timer;