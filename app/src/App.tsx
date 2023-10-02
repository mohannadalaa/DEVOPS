import React, { useEffect, useState } from 'react';
import logo from './logo.svg';
import './App.css';
import axios from 'axios';

function App() {

var [weather, setweather] = useState<any[]>([]);
  const fetchWeather = async () => {
    var response = await axios.get("http://localhost:14600/WeatherForecast");
    setweather(response.data);
  }

  useEffect(() => {
    fetchWeather();
  }, []);


  return (
    <div className="App">
      <header className="App-header">
        {weather.map(w => 
          <div>Date: {w.date}, Temp:{w.temperatureC}, Summary:{w.summary} </div>
          )}
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          Edit <code>src/App.tsx</code> and save to reload.
        </p>
        <a
          className="App-link"
          href="https://reactjs.org"
          target="_blank"
          rel="noopener noreferrer"
        >
          Learn React
        </a>
      </header>
    </div>
  );
}

export default App;
