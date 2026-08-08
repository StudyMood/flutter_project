document.addEventListener('DOMContentLoaded', () => {
  // ==========================================
  // DOM SELECTORS
  // ==========================================
  
  // Navigation Tabs
  const navItems = document.querySelectorAll('.nav-item');
  const tabContents = document.querySelectorAll('.tab-content');
  
  // Accent & Theme Controls
  const themeToggleBtn = document.getElementById('theme-toggle-btn');
  const themeSunIcon = document.getElementById('theme-sun-icon');
  const themeMoonIcon = document.getElementById('theme-moon-icon');
  const accentDots = document.querySelectorAll('.accent-dot');
  
  // Active Clock
  const hourEl = document.getElementById('hours');
  const minuteEl = document.getElementById('minutes');
  const secondEl = document.getElementById('seconds');
  const ampmEl = document.getElementById('ampm');
  const dateEl = document.getElementById('full-date');
  const dayOfWeekEl = document.getElementById('day-of-week');
  const localTimezoneEl = document.getElementById('local-timezone');
  const clockMarkersEl = document.getElementById('clock-markers');
  
  const analogHourHand = document.getElementById('analog-hour');
  const analogMinuteHand = document.getElementById('analog-minute');
  const analogSecondHand = document.getElementById('analog-second');
  
  // Stopwatch
  const swHoursEl = document.getElementById('sw-hours');
  const swMinutesEl = document.getElementById('sw-minutes');
  const swSecondsEl = document.getElementById('sw-seconds');
  const swMsEl = document.getElementById('sw-ms');
  const swBtnStart = document.getElementById('sw-btn-start');
  const swBtnLap = document.getElementById('sw-btn-lap');
  const swBtnReset = document.getElementById('sw-btn-reset');
  const lapsContainer = document.getElementById('laps-container');
  const lapsList = document.getElementById('laps-list');
  
  // Timer
  const timerProgress = document.getElementById('timer-progress');
  const timerHoursInput = document.getElementById('timer-hours');
  const timerMinutesInput = document.getElementById('timer-minutes');
  const timerSecondsInput = document.getElementById('timer-seconds');
  const timerInputArea = document.getElementById('timer-input-area');
  const timerDigitsDisplay = document.getElementById('timer-digits-display');
  const timerStatusLabel = document.getElementById('timer-status-label');
  const timerPresetsRow = document.getElementById('timer-presets-row');
  const timerBtnStart = document.getElementById('timer-btn-start');
  const timerBtnReset = document.getElementById('timer-btn-reset');
  const timerBtnText = document.getElementById('timer-btn-text');
  const timerWidgetGlow = document.getElementById('timer-widget-glow');
  
  // World Clock
  const timezoneSelector = document.getElementById('timezone-selector');
  const btnAddTimezone = document.getElementById('btn-add-timezone');
  const worldClocksContainer = document.getElementById('world-clocks-container');

  // ==========================================
  // NAVIGATION CONTROL
  // ==========================================
  navItems.forEach(item => {
    item.addEventListener('click', () => {
      const targetTab = item.getAttribute('data-tab');
      
      // Toggle active states on sidebar items
      navItems.forEach(nav => nav.classList.remove('active'));
      item.classList.add('active');
      
      // Switch active tab view pane
      tabContents.forEach(content => {
        if (content.id === targetTab) {
          content.classList.add('active');
        } else {
          content.classList.remove('active');
        }
      });
    });
  });

  // ==========================================
  // CORE THEMING & ACCENTS
  // ==========================================
  
  // Load settings from LocalStorage
  let currentTheme = localStorage.getItem('theme') || 'dark';
  let currentHue = localStorage.getItem('accent-hue') || '190'; // Default cyan
  
  // Set initial theme
  document.body.setAttribute('data-theme', currentTheme);
  updateThemeIcons(currentTheme);
  
  // Set initial accent
  document.documentElement.style.setProperty('--accent-hue', currentHue);
  accentDots.forEach(dot => {
    if (dot.getAttribute('data-hue') === currentHue) {
      dot.classList.add('active');
    } else {
      dot.classList.remove('active');
    }
  });

  // Theme Toggle Event
  themeToggleBtn.addEventListener('click', () => {
    currentTheme = document.body.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
    document.body.setAttribute('data-theme', currentTheme);
    localStorage.setItem('theme', currentTheme);
    updateThemeIcons(currentTheme);
  });

  function updateThemeIcons(theme) {
    if (theme === 'dark') {
      themeSunIcon.style.display = 'block';
      themeMoonIcon.style.display = 'none';
    } else {
      themeSunIcon.style.display = 'none';
      themeMoonIcon.style.display = 'block';
    }
  }

  // Accent Dot Events
  accentDots.forEach(dot => {
    dot.addEventListener('click', () => {
      accentDots.forEach(d => d.classList.remove('active'));
      dot.classList.add('active');
      
      const hue = dot.getAttribute('data-hue');
      currentHue = hue;
      document.documentElement.style.setProperty('--accent-hue', hue);
      localStorage.setItem('accent-hue', hue);
    });
  });

  // ==========================================
  // ANALOG DIAL GENERATION
  // ==========================================
  function generateClockDial() {
    if (!clockMarkersEl) return;
    clockMarkersEl.innerHTML = '';
    for (let i = 0; i < 60; i++) {
      const marker = document.createElement('div');
      marker.classList.add('marker');
      marker.style.transform = `rotate(${i * 6}deg)`;
      clockMarkersEl.appendChild(marker);
    }
  }
  generateClockDial();

  // ==========================================
  // REALTIME TICK ENGINE (Digital + Analog)
  // ==========================================
  let accumulatedSecondsAngle = 0;
  let accumulatedMinutesAngle = 0;
  let accumulatedHoursAngle = 0;
  let lastSec = -1;
  let lastMin = -1;
  let lastHr = -1;

  function triggerTickAnimation(el) {
    if (!el) return;
    el.classList.remove('tick');
    void el.offsetWidth; // trigger reflow
    el.classList.add('tick');
  }

  function updateRealtimeClock() {
    const now = new Date();
    
    // Fetch time values
    const rawHours = now.getHours();
    const minutes = now.getMinutes();
    const seconds = now.getSeconds();
    const isAm = rawHours < 12;
    const hours12 = rawHours % 12 || 12;
    
    // 1. Update Digital Elements with Flip/Tick animation
    const targetHr = String(hours12).padStart(2, '0');
    const targetMin = String(minutes).padStart(2, '0');
    const targetSec = String(seconds).padStart(2, '0');

    if (hourEl && hourEl.textContent !== targetHr) {
      hourEl.textContent = targetHr;
      triggerTickAnimation(hourEl);
    }
    if (minuteEl && minuteEl.textContent !== targetMin) {
      minuteEl.textContent = targetMin;
      triggerTickAnimation(minuteEl);
    }
    if (secondEl && secondEl.textContent !== targetSec) {
      secondEl.textContent = targetSec;
      triggerTickAnimation(secondEl);
    }
    if (ampmEl) ampmEl.textContent = isAm ? 'AM' : 'PM';
    
    // Date displays
    const dateOptions = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
    if (dateEl) dateEl.textContent = now.toLocaleDateString('en-US', dateOptions);
    if (dayOfWeekEl) dayOfWeekEl.textContent = `Today is ${now.toLocaleDateString('en-US', { weekday: 'long' })}`;
    
    // 2. Continuous Analog Hands Rotation (Prevents backward-wrapping snaps)
    if (lastSec === -1) {
      accumulatedSecondsAngle = seconds * 6;
      accumulatedMinutesAngle = minutes * 6 + seconds * 0.1;
      accumulatedHoursAngle = (rawHours % 12) * 30 + minutes * 0.5;
    } else {
      // Calculate rotation delta for seconds
      let secDiff = seconds - lastSec;
      if (secDiff < 0) secDiff += 60;
      if (secDiff > 0) accumulatedSecondsAngle += secDiff * 6;
      
      // Calculate rotation delta for minutes
      let minDiff = minutes - lastMin;
      if (minDiff < 0) minDiff += 60;
      if (minDiff > 0 || secDiff > 0) {
        // Precise fractional minute angle update
        accumulatedMinutesAngle = (minutes * 6) + (seconds * 0.1) + (Math.floor(accumulatedSecondsAngle / 360) * 360);
      }
      
      // Calculate rotation delta for hours
      let hrDiff = rawHours - lastHr;
      if (hrDiff < 0) hrDiff += 24;
      if (hrDiff > 0 || minDiff > 0) {
        accumulatedHoursAngle = ((rawHours % 12) * 30) + (minutes * 0.5) + (Math.floor(accumulatedMinutesAngle / 360) * 360);
      }
    }
    
    lastSec = seconds;
    lastMin = minutes;
    lastHr = rawHours;

    if (analogSecondHand) analogSecondHand.style.transform = `rotate(${accumulatedSecondsAngle}deg)`;
    if (analogMinuteHand) analogMinuteHand.style.transform = `rotate(${accumulatedMinutesAngle}deg)`;
    if (analogHourHand) analogHourHand.style.transform = `rotate(${accumulatedHoursAngle}deg)`;
  }
  
  // Set timezone badge
  try {
    const tzName = Intl.DateTimeFormat().resolvedOptions().timeZone;
    const gmtOffsetStr = new Intl.DateTimeFormat('en-US', { timeZoneName: 'short' })
      .formatToParts(new Date())
      .find(part => part.type === 'timeZoneName').value;
    if (localTimezoneEl) localTimezoneEl.textContent = `${gmtOffsetStr} (${tzName})`;
  } catch (e) {
    if (localTimezoneEl) localTimezoneEl.textContent = "Local Time";
  }

  // Active sync timer
  setInterval(updateRealtimeClock, 1000);
  updateRealtimeClock(); // Run immediately

  // ==========================================
  // PRECISION STOPWATCH ENGINE
  // ==========================================
  let swStartTime = 0;
  let swElapsedTime = 0;
  let swIntervalId = null;
  let swRunning = false;
  let swLaps = [];

  function formatTime(totalMs) {
    const hrs = Math.floor(totalMs / 3600000);
    const mins = Math.floor((totalMs % 3600000) / 60000);
    const secs = Math.floor((totalMs % 60000) / 1000);
    const ms = Math.floor((totalMs % 1000) / 10);
    
    const hh = String(hrs).padStart(2, '0');
    const mm = String(mins).padStart(2, '0');
    const ss = String(secs).padStart(2, '0');
    const msStr = `.${String(ms).padStart(2, '0')}`;
    
    return {
      hrs: hh,
      mins: mm,
      secs: ss,
      ms: msStr,
      main: `${hh}:${mm}:${ss}`
    };
  }

  function updateStopwatchUI() {
    const formatted = formatTime(swElapsedTime);
    
    if (swHoursEl && swHoursEl.textContent !== formatted.hrs) {
      swHoursEl.textContent = formatted.hrs;
      triggerTickAnimation(swHoursEl);
    }
    if (swMinutesEl && swMinutesEl.textContent !== formatted.mins) {
      swMinutesEl.textContent = formatted.mins;
      triggerTickAnimation(swMinutesEl);
    }
    if (swSecondsEl && swSecondsEl.textContent !== formatted.secs) {
      swSecondsEl.textContent = formatted.secs;
      triggerTickAnimation(swSecondsEl);
    }
    if (swMsEl) swMsEl.textContent = formatted.ms;
  }

  function runStopwatchLoop() {
    if (!swRunning) return;
    swElapsedTime = Date.now() - swStartTime;
    updateStopwatchUI();
    swIntervalId = requestAnimationFrame(runStopwatchLoop);
  }

  swBtnStart.addEventListener('click', () => {
    if (swRunning) {
      // Pause
      swRunning = false;
      cancelAnimationFrame(swIntervalId);
      swElapsedTime = Date.now() - swStartTime;
      updateStopwatchUI();
      
      swBtnStart.classList.remove('btn-primary');
      swBtnStart.querySelector('span').textContent = 'Resume';
      // Show play icon
      swBtnStart.querySelector('svg').innerHTML = '<polygon points="5 3 19 12 5 21 5 3"></polygon>';
      
      swBtnLap.disabled = true;
      swBtnReset.disabled = false;
    } else {
      // Start / Resume
      swRunning = true;
      swStartTime = Date.now() - swElapsedTime;
      runStopwatchLoop();
      
      swBtnStart.classList.add('btn-primary');
      swBtnStart.querySelector('span').textContent = 'Pause';
      // Show pause icon
      swBtnStart.querySelector('svg').innerHTML = '<rect x="6" y="4" width="4" height="16"></rect><rect x="14" y="4" width="4" height="16"></rect>';
      
      swBtnLap.disabled = false;
      swBtnReset.disabled = true;
    }
  });

  swBtnLap.addEventListener('click', () => {
    if (!swRunning) return;
    
    const lapTime = swElapsedTime;
    swLaps.push(lapTime);
    
    // Reveal laps list container
    lapsContainer.style.display = 'block';
    
    const lapItem = document.createElement('li');
    lapItem.classList.add('lap-item');
    
    const lapNumStr = String(swLaps.length).padStart(2, '0');
    const formatted = formatTime(lapTime);
    
    lapItem.innerHTML = `
      <span class="lap-number">Lap ${lapNumStr}</span>
      <span class="lap-time">${formatted.main}<span style="color: var(--accent-color);">${formatted.ms}</span></span>
    `;
    
    // Prepend new lap to list
    lapsList.insertBefore(lapItem, lapsList.firstChild);
    
    // Auto scroll container to top
    lapsContainer.scrollTop = 0;
  });

  swBtnReset.addEventListener('click', () => {
    swRunning = false;
    cancelAnimationFrame(swIntervalId);
    swElapsedTime = 0;
    swLaps = [];
    updateStopwatchUI();
    
    swBtnStart.classList.remove('btn-primary');
    swBtnStart.querySelector('span').textContent = 'Start';
    swBtnStart.querySelector('svg').innerHTML = '<polygon points="5 3 19 12 5 21 5 3"></polygon>';
    
    swBtnLap.disabled = true;
    swBtnReset.disabled = true;
    
    // Clear and hide lap listing
    lapsList.innerHTML = '';
    lapsContainer.style.display = 'none';
  });

  // ==========================================
  // RADIAL COUNTDOWN TIMER ENGINE
  // ==========================================
  let timerDurationSeconds = 300; // default 5m
  let timerSecondsRemaining = 300;
  let timerIntervalId = null;
  let timerRunning = false;
  const timerCircleCircumference = 691.15; // 2 * pi * r (110)

  // Configure SVG Dasharray
  timerProgress.style.strokeDasharray = timerCircleCircumference;
  setTimerProgress(1);

  function setTimerProgress(percent) {
    const offset = timerCircleCircumference * (1 - percent);
    timerProgress.style.strokeDashoffset = offset;
  }

  function formatTimerDigits(totalSeconds) {
    const h = Math.floor(totalSeconds / 3600);
    const m = Math.floor((totalSeconds % 3600) / 60);
    const s = totalSeconds % 60;
    return `${String(h).padStart(2, '0')}:${String(m).padStart(2, '0')}:${String(s).padStart(2, '0')}`;
  }

  function readTimerInputs() {
    const h = parseInt(timerHoursInput.value, 10) || 0;
    const m = parseInt(timerMinutesInput.value, 10) || 0;
    const s = parseInt(timerSecondsInput.value, 10) || 0;
    return (h * 3600) + (m * 60) + s;
  }

  function setTimerInputsFromSeconds(totalSecs) {
    const h = Math.floor(totalSecs / 3600);
    const m = Math.floor((totalSecs % 3600) / 60);
    const s = totalSecs % 60;
    timerHoursInput.value = String(h).padStart(2, '0');
    timerMinutesInput.value = String(m).padStart(2, '0');
    timerSecondsInput.value = String(s).padStart(2, '0');
  }

  function handleTimerPreset(seconds) {
    if (timerRunning) return;
    timerDurationSeconds = seconds;
    timerSecondsRemaining = seconds;
    setTimerInputsFromSeconds(seconds);
    timerDigitsDisplay.textContent = formatTimerDigits(seconds);
    setTimerProgress(1);
    timerBtnReset.disabled = true;
  }

  // Hook preset buttons
  timerPresetsRow.querySelectorAll('.preset-btn').forEach(btn => {
    btn.addEventListener('click', () => {
      const sec = parseInt(btn.getAttribute('data-sec'), 10);
      handleTimerPreset(sec);
    });
  });

  // Watch input changes to update duration
  [timerHoursInput, timerMinutesInput, timerSecondsInput].forEach(input => {
    input.addEventListener('change', () => {
      // Validate bounds
      if (input.id === 'timer-hours') {
        if (input.value < 0) input.value = 0;
      } else {
        if (input.value < 0) input.value = 0;
        if (input.value > 59) input.value = 59;
      }
      
      // Auto pad
      input.value = String(parseInt(input.value, 10) || 0).padStart(2, '0');
      
      const secs = readTimerInputs();
      timerDurationSeconds = secs;
      timerSecondsRemaining = secs;
      setTimerProgress(1);
    });
  });

  timerBtnStart.addEventListener('click', () => {
    if (timerRunning) {
      // Pause State
      timerRunning = false;
      clearInterval(timerIntervalId);
      timerBtnText.textContent = 'Resume';
      timerBtnStart.querySelector('svg').innerHTML = '<polygon points="5 3 19 12 5 21 5 3"></polygon>';
      timerBtnReset.disabled = false;
      timerStatusLabel.textContent = 'Paused';
    } else {
      // Start State
      const totalSecs = readTimerInputs();
      if (totalSecs <= 0) return;
      
      if (timerSecondsRemaining <= 0 || timerDurationSeconds !== totalSecs) {
        timerDurationSeconds = totalSecs;
        timerSecondsRemaining = totalSecs;
      }

      timerRunning = true;
      timerBtnReset.disabled = true;
      timerBtnText.textContent = 'Pause';
      timerBtnStart.querySelector('svg').innerHTML = '<rect x="6" y="4" width="4" height="16"></rect><rect x="14" y="4" width="4" height="16"></rect>';
      
      // Hide Inputs, Show Display Digits
      timerInputArea.style.display = 'none';
      timerDigitsDisplay.style.display = 'block';
      timerDigitsDisplay.textContent = formatTimerDigits(timerSecondsRemaining);
      timerStatusLabel.textContent = 'Running';
      
      timerIntervalId = setInterval(tickTimer, 1000);
      tickTimer(); // first tick immediately
    }
  });

  function tickTimer() {
    if (timerSecondsRemaining <= 0) {
      // Timer finished!
      timerRunning = false;
      clearInterval(timerIntervalId);
      
      setTimerProgress(0);
      timerDigitsDisplay.textContent = '00:00:00';
      timerStatusLabel.textContent = 'Finished!';
      
      // Audio Alert placeholder/visual trigger
      timerWidgetGlow.classList.add('timer-visual-alert');
      
      timerBtnStart.disabled = true;
      timerBtnReset.disabled = false;
      return;
    }
    
    // Decrement time
    timerDigitsDisplay.textContent = formatTimerDigits(timerSecondsRemaining);
    const progress = timerSecondsRemaining / timerDurationSeconds;
    setTimerProgress(progress);
    
    timerSecondsRemaining--;
  }

  timerBtnReset.addEventListener('click', () => {
    timerRunning = false;
    clearInterval(timerIntervalId);
    timerSecondsRemaining = timerDurationSeconds;
    
    // Clear flash alerts
    timerWidgetGlow.classList.remove('timer-visual-alert');
    
    // Switch views
    timerInputArea.style.display = 'flex';
    timerDigitsDisplay.style.display = 'none';
    timerStatusLabel.textContent = 'Set Time';
    
    // Reset controls
    timerBtnStart.disabled = false;
    timerBtnReset.disabled = true;
    timerBtnText.textContent = 'Start';
    timerBtnStart.querySelector('svg').innerHTML = '<polygon points="5 3 19 12 5 21 5 3"></polygon>';
    
    setTimerInputsFromSeconds(timerDurationSeconds);
    setTimerProgress(1);
  });

  // ==========================================
  // WORLD CLOCK / MULTI-TIMEZONE ENGINE
  // ==========================================
  let activeZones = [];
  const defaultZones = ['America/New_York', 'Europe/London', 'Asia/Tokyo'];
  
  // Load user timezones
  try {
    const stored = localStorage.getItem('world-timezones');
    activeZones = stored ? JSON.parse(stored) : defaultZones;
  } catch (e) {
    activeZones = defaultZones;
  }

  function getCityName(tzString) {
    // America/New_York -> New York
    const parts = tzString.split('/');
    const rawCity = parts[parts.length - 1];
    return rawCity.replace(/_/g, ' ');
  }

  function renderWorldClocks() {
    if (!worldClocksContainer) return;
    worldClocksContainer.innerHTML = '';
    
    activeZones.forEach(zone => {
      const card = document.createElement('div');
      card.classList.add('timezone-card');
      card.setAttribute('data-zone', zone);
      
      card.innerHTML = `
        <div class="timezone-card-header">
          <div>
            <div class="timezone-city">${getCityName(zone)}</div>
            <div class="timezone-offset" id="offset-${zone.replace(/\//g, '-')}" style="font-size:0.75rem;">Loading offset...</div>
          </div>
          <button class="btn-delete-zone" data-zone="${zone}" title="Delete Zone">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path><line x1="10" y1="11" x2="10" y2="17"></line><line x1="14" y1="11" x2="14" y2="17"></line></svg>
          </button>
        </div>
        <div>
          <div class="timezone-card-time">
            <span id="time-${zone.replace(/\//g, '-')}">00:00</span>
            <span class="timezone-card-ampm" id="ampm-${zone.replace(/\//g, '-')}">AM</span>
          </div>
          <div class="timezone-card-date" id="date-${zone.replace(/\//g, '-')}">Loading date...</div>
        </div>
      `;
      
      // Delete listener
      card.querySelector('.btn-delete-zone').addEventListener('click', (e) => {
        const zoneToDelete = e.currentTarget.getAttribute('data-zone');
        activeZones = activeZones.filter(z => z !== zoneToDelete);
        localStorage.setItem('world-timezones', JSON.stringify(activeZones));
        renderWorldClocks();
      });
      
      worldClocksContainer.appendChild(card);
    });
    
    updateWorldClocksData();
  }

  function updateWorldClocksData() {
    const now = new Date();
    
    activeZones.forEach(zone => {
      const zoneId = zone.replace(/\//g, '-');
      const timeEl = document.getElementById(`time-${zoneId}`);
      const ampmEl = document.getElementById(`ampm-${zoneId}`);
      const dateEl = document.getElementById(`date-${zoneId}`);
      const offsetEl = document.getElementById(`offset-${zoneId}`);
      
      if (!timeEl) return;
      
      try {
        // Format Time
        const timeOptions = { timeZone: zone, hour: '2-digit', minute: '2-digit', second: '2-digit', hour12: true };
        const timeParts = new Intl.DateTimeFormat('en-US', timeOptions).formatToParts(now);
        
        const hr = timeParts.find(p => p.type === 'hour').value;
        const min = timeParts.find(p => p.type === 'minute').value;
        const sec = timeParts.find(p => p.type === 'second').value;
        const ampm = timeParts.find(p => p.type === 'dayPeriod').value;
        
        timeEl.textContent = `${hr}:${min}:${sec}`;
        ampmEl.textContent = ampm;
        
        // Format Date
        const dateOptions = { timeZone: zone, weekday: 'short', month: 'short', day: 'numeric' };
        dateEl.textContent = new Intl.DateTimeFormat('en-US', dateOptions).format(now);
        
        // Format Offset (e.g. GMT-5)
        const offsetOptions = { timeZone: zone, timeZoneName: 'shortOffset' };
        const offsetParts = new Intl.DateTimeFormat('en-US', offsetOptions).formatToParts(now);
        const offsetVal = offsetParts.find(p => p.type === 'timeZoneName').value;
        offsetEl.textContent = offsetVal;
        
      } catch (e) {
        timeEl.textContent = "Error";
        ampmEl.textContent = "";
        dateEl.textContent = "Invalid Zone";
        offsetEl.textContent = "";
      }
    });
  }

  // Add Timezone Event
  btnAddTimezone.addEventListener('click', () => {
    const selectedZone = timezoneSelector.value;
    if (!selectedZone) return;
    
    if (activeZones.includes(selectedZone)) {
      alert('This timezone is already in your dashboard!');
      return;
    }
    
    activeZones.push(selectedZone);
    localStorage.setItem('world-timezones', JSON.stringify(activeZones));
    renderWorldClocks();
    timezoneSelector.value = ''; // reset selection
  });

  // World clock updates every second
  setInterval(updateWorldClocksData, 1000);
  
  // Initial render
  renderWorldClocks();
});

/* ================================================================
   BUTTON INTERACTION ENGINE
   Ripple  |  Magnetic Hover  |  Particle Burst on Click
   ================================================================ */
(function () {

  // ---- Ripple helper ----
  function createRipple(e) {
    const btn = e.currentTarget;
    const rect = btn.getBoundingClientRect();
    const size = Math.max(rect.width, rect.height) * 1.4;
    const x = e.clientX - rect.left - size / 2;
    const y = e.clientY - rect.top  - size / 2;

    const ripple = document.createElement('span');
    ripple.className = 'ripple-wave';
    ripple.style.cssText = `width:${size}px;height:${size}px;left:${x}px;top:${y}px;`;
    btn.appendChild(ripple);

    ripple.addEventListener('animationend', () => ripple.remove());
  }

  // ---- Magnetic hover ----
  function addMagnetic(btn) {
    btn.addEventListener('mousemove', (e) => {
      const rect = btn.getBoundingClientRect();
      const cx = rect.left + rect.width / 2;
      const cy = rect.top  + rect.height / 2;
      const dx = (e.clientX - cx) / rect.width;
      const dy = (e.clientY - cy) / rect.height;
      const strength = btn.classList.contains('nav-item') ? 5 : 9;
      btn.style.transform = `translate(${dx * strength}px, ${dy * strength}px) scale(1.04)`;
    });

    btn.addEventListener('mouseleave', () => {
      btn.style.transform = '';
    });
  }

  // ---- Particle burst on click ----
  const burstCanvas = document.createElement('canvas');
  burstCanvas.style.cssText = 'position:fixed;top:0;left:0;width:100vw;height:100vh;pointer-events:none;z-index:9999;';
  document.body.appendChild(burstCanvas);
  const bctx = burstCanvas.getContext('2d');
  burstCanvas.width  = window.innerWidth;
  burstCanvas.height = window.innerHeight;
  window.addEventListener('resize', () => {
    burstCanvas.width  = window.innerWidth;
    burstCanvas.height = window.innerHeight;
  });

  const bursts = [];

  function spawnBurst(x, y, hue) {
    const count = 22;
    for (let i = 0; i < count; i++) {
      const angle  = (Math.PI * 2 / count) * i + (Math.random() - 0.5) * 0.5;
      const speed  = Math.random() * 5 + 2.5;
      const size   = Math.random() * 5 + 2;
      bursts.push({
        x, y,
        vx: Math.cos(angle) * speed,
        vy: Math.sin(angle) * speed,
        size,
        hue: hue + (Math.random() - 0.5) * 60,
        alpha: 1,
        life: 0,
        maxLife: Math.random() * 30 + 20,
        gravity: Math.random() * 0.15 + 0.05,
        isCircle: Math.random() > 0.4,
      });
    }
  }

  let burstRunning = false;
  function runBursts() {
    bctx.clearRect(0, 0, burstCanvas.width, burstCanvas.height);
    for (let i = bursts.length - 1; i >= 0; i--) {
      const p = bursts[i];
      p.life++;
      p.x  += p.vx;
      p.y  += p.vy;
      p.vy += p.gravity;
      p.vx *= 0.97;
      p.alpha = 1 - p.life / p.maxLife;

      bctx.globalAlpha = p.alpha;
      bctx.shadowColor = `hsla(${p.hue},100%,70%,${p.alpha})`;
      bctx.shadowBlur  = p.size * 3;
      bctx.fillStyle   = `hsla(${p.hue},100%,75%,1)`;

      if (p.isCircle) {
        bctx.beginPath();
        bctx.arc(p.x, p.y, p.size / 2, 0, Math.PI * 2);
        bctx.fill();
      } else {
        // tiny sparkle square
        bctx.save();
        bctx.translate(p.x, p.y);
        bctx.rotate(p.life * 0.15);
        bctx.fillRect(-p.size / 2, -p.size / 2, p.size, p.size);
        bctx.restore();
      }

      if (p.life >= p.maxLife) bursts.splice(i, 1);
    }
    bctx.globalAlpha = 1;
    bctx.shadowBlur  = 0;

    if (bursts.length > 0) {
      requestAnimationFrame(runBursts);
    } else {
      burstRunning = false;
      bctx.clearRect(0, 0, burstCanvas.width, burstCanvas.height);
    }
  }

  function getHue() {
    return parseFloat(
      getComputedStyle(document.documentElement).getPropertyValue('--accent-hue').trim()
    ) || 190;
  }

  // ---- Apply to all buttons + nav-items ----
  function applyToButtons() {
    const allBtns = document.querySelectorAll('.btn, .nav-item, .theme-toggle-btn, .accent-dot');
    allBtns.forEach(btn => {
      if (btn.dataset.fxApplied) return;
      btn.dataset.fxApplied = 'true';

      btn.addEventListener('click', (e) => {
        createRipple(e);

        // Burst at click point
        const hue = btn.classList.contains('btn-danger') ? 0 : getHue();
        spawnBurst(e.clientX, e.clientY, hue);
        if (!burstRunning) { burstRunning = true; runBursts(); }
      });

      addMagnetic(btn);
    });
  }

  // Run on load + observe for dynamic buttons (world clock add btn etc.)
  applyToButtons();
  const domObserver = new MutationObserver(applyToButtons);
  domObserver.observe(document.body, { childList: true, subtree: true });

})();


/* ================================================================
   CINEMATIC VIDEO-LIKE BACKGROUND ENGINE
   Aurora Waves + Nebula Glow + Floating Particles + Shooting Stars
   ================================================================ */
(function () {
  const canvas = document.getElementById('bg-canvas');
  const ctx = canvas.getContext('2d');

  let W, H;
  let animFrame;
  let time = 0;

  // ---- Bubbles ----
  const BUBBLE_COUNT = 90;
  const bubbles = [];

  // ---- Shooting Stars ----
  const shootingStars = [];

  // ---- Get current accent hue from CSS variable ----
  function getAccentHue() {
    return parseFloat(
      getComputedStyle(document.documentElement).getPropertyValue('--accent-hue').trim()
    ) || 190;
  }

  // ---- Resize canvas to fill viewport ----
  function resize() {
    W = canvas.width = window.innerWidth;
    H = canvas.height = window.innerHeight;
  }

  // ---- Initialize bubbles ----
  function initParticles() {
    bubbles.length = 0;
    for (let i = 0; i < BUBBLE_COUNT; i++) {
      spawnParticle(true);
    }
  }

  function spawnParticle(randomY) {
    const hue = getAccentHue();
    const r = Math.random() * 28 + 8;     // radius 8px–36px
    bubbles.push({
      x: Math.random() * W,
      y: randomY ? Math.random() * H : H + r + 10,
      r: r,
      speedY: -(Math.random() * 0.9 + 0.35),   // upward speed
      wobbleAmp: Math.random() * 1.8 + 0.6,     // side wobble amount
      wobbleFreq: Math.random() * 0.04 + 0.015, // side wobble speed
      wobbleOffset: Math.random() * Math.PI * 2,
      hue: hue + (Math.random() - 0.5) * 120,   // slight color variation
      life: 0,
      maxLife: Math.random() * 500 + 250,
      popPhase: false,  // when near maxLife, bubble pops
    });
  }

  // ---- Spawn shooting star ----
  function spawnShootingStar() {
    const hue = getAccentHue();
    shootingStars.push({
      x: Math.random() * W * 0.8,
      y: Math.random() * H * 0.4,
      len: Math.random() * 180 + 80,
      speed: Math.random() * 14 + 8,
      angle: Math.PI / 4 + (Math.random() - 0.5) * 0.4,
      opacity: 1,
      hue: hue,
      width: Math.random() * 1.5 + 0.8,
      life: 0,
      maxLife: Math.random() * 40 + 25,
    });
  }

  // ---- Draw aurora waves ----
  function drawAurora() {
    const hue = getAccentHue();
    const isDark = !document.documentElement.hasAttribute('data-theme') ||
                   document.documentElement.getAttribute('data-theme') !== 'light';

    const baseAlpha = isDark ? 0.13 : 0.07;

    // Layer 1 — wide slow wave
    for (let layer = 0; layer < 4; layer++) {
      const layerHue = hue + layer * 42;
      const amp = H * (0.08 + layer * 0.03);
      const freq = 0.0012 + layer * 0.0004;
      const speed = time * (0.0003 + layer * 0.00015);
      const yBase = H * (0.18 + layer * 0.17);

      const grad = ctx.createLinearGradient(0, yBase - amp, 0, yBase + amp * 3);
      grad.addColorStop(0, `hsla(${layerHue}, 100%, 60%, 0)`);
      grad.addColorStop(0.3, `hsla(${layerHue}, 100%, 55%, ${baseAlpha + 0.04})`);
      grad.addColorStop(0.6, `hsla(${layerHue + 30}, 90%, 60%, ${baseAlpha})`);
      grad.addColorStop(1, `hsla(${layerHue}, 100%, 60%, 0)`);

      ctx.beginPath();
      ctx.moveTo(0, yBase);

      for (let x = 0; x <= W; x += 4) {
        const y = yBase
          + Math.sin(x * freq + speed) * amp
          + Math.sin(x * freq * 1.7 + speed * 1.3 + layer) * (amp * 0.4)
          + Math.cos(x * freq * 0.5 + speed * 0.7) * (amp * 0.25);
        ctx.lineTo(x, y);
      }

      ctx.lineTo(W, H);
      ctx.lineTo(0, H);
      ctx.closePath();
      ctx.fillStyle = grad;
      ctx.fill();
    }
  }

  // ---- Draw nebula glow orbs ----
  function drawNebula() {
    const hue = getAccentHue();
    const isDark = !document.documentElement.hasAttribute('data-theme') ||
                   document.documentElement.getAttribute('data-theme') !== 'light';
    const alpha = isDark ? 0.12 : 0.06;

    const orbs = [
      { xFrac: 0.15, yFrac: 0.2, r: W * 0.28, hShift: 0, speed: 0.00018 },
      { xFrac: 0.8, yFrac: 0.75, r: W * 0.32, hShift: 120, speed: 0.00013 },
      { xFrac: 0.5, yFrac: 0.5, r: W * 0.22, hShift: -60, speed: 0.00022 },
    ];

    orbs.forEach((orb, i) => {
      const ox = W * orb.xFrac + Math.sin(time * orb.speed + i * 2.1) * W * 0.07;
      const oy = H * orb.yFrac + Math.cos(time * orb.speed * 1.3 + i * 1.5) * H * 0.06;
      const orbHue = hue + orb.hShift;

      const grad = ctx.createRadialGradient(ox, oy, 0, ox, oy, orb.r);
      grad.addColorStop(0, `hsla(${orbHue}, 100%, 65%, ${alpha + 0.05})`);
      grad.addColorStop(0.5, `hsla(${orbHue + 20}, 90%, 55%, ${alpha})`);
      grad.addColorStop(1, `hsla(${orbHue}, 100%, 50%, 0)`);

      ctx.beginPath();
      ctx.arc(ox, oy, orb.r, 0, Math.PI * 2);
      ctx.fillStyle = grad;
      ctx.fill();
    });
  }

  // ---- Draw soap bubbles ----
  function drawParticles() {
    for (let i = bubbles.length - 1; i >= 0; i--) {
      const b = bubbles[i];
      b.life++;

      // Wobble side-to-side (X axis drift)
      b.x += Math.sin(b.life * b.wobbleFreq + b.wobbleOffset) * b.wobbleAmp;
      b.y += b.speedY;

      // Fade in at start
      const fadeIn  = b.life < 40 ? b.life / 40 : 1;
      // Fade out near death
      const fadeOut = b.life > b.maxLife * 0.80
        ? 1 - (b.life - b.maxLife * 0.80) / (b.maxLife * 0.20)
        : 1;
      const alpha = fadeIn * fadeOut;

      if (alpha <= 0.01) {
        bubbles.splice(i, 1);
        spawnParticle(false);
        continue;
      }

      const { x, y, r, hue } = b;

      // ---- Outer glow ----
      const outerGlow = ctx.createRadialGradient(x, y, r * 0.6, x, y, r * 1.5);
      outerGlow.addColorStop(0, `hsla(${hue}, 80%, 70%, 0)`);
      outerGlow.addColorStop(1, `hsla(${hue}, 80%, 60%, ${0.06 * alpha})`);
      ctx.beginPath();
      ctx.arc(x, y, r * 1.5, 0, Math.PI * 2);
      ctx.fillStyle = outerGlow;
      ctx.fill();

      // ---- Bubble body — transparent with tinted fill ----
      const bodyGrad = ctx.createRadialGradient(
        x - r * 0.3, y - r * 0.3, r * 0.05,
        x, y, r
      );
      bodyGrad.addColorStop(0,   `hsla(${hue}, 60%, 95%, ${0.10 * alpha})`);
      bodyGrad.addColorStop(0.5, `hsla(${hue}, 70%, 75%, ${0.06 * alpha})`);
      bodyGrad.addColorStop(1,   `hsla(${hue}, 80%, 60%, ${0.03 * alpha})`);
      ctx.beginPath();
      ctx.arc(x, y, r, 0, Math.PI * 2);
      ctx.fillStyle = bodyGrad;
      ctx.fill();

      // ---- Bubble rim (stroke) ----
      ctx.beginPath();
      ctx.arc(x, y, r, 0, Math.PI * 2);
      const rimGrad = ctx.createLinearGradient(x - r, y - r, x + r, y + r);
      rimGrad.addColorStop(0,   `hsla(${hue + 40}, 100%, 90%, ${0.55 * alpha})`);
      rimGrad.addColorStop(0.4, `hsla(${hue},      90%,  70%, ${0.30 * alpha})`);
      rimGrad.addColorStop(0.7, `hsla(${hue - 30}, 80%,  60%, ${0.20 * alpha})`);
      rimGrad.addColorStop(1,   `hsla(${hue + 60}, 100%, 95%, ${0.50 * alpha})`);
      ctx.strokeStyle = rimGrad;
      ctx.lineWidth = Math.max(1, r * 0.07);
      ctx.shadowColor = `hsla(${hue}, 100%, 80%, ${0.25 * alpha})`;
      ctx.shadowBlur = r * 0.8;
      ctx.stroke();
      ctx.shadowBlur = 0;

      // ---- Top-left shine highlight ----
      const shinX = x - r * 0.32;
      const shinY = y - r * 0.35;
      const shineR = r * 0.28;
      const shineGrad = ctx.createRadialGradient(shinX, shinY, 0, shinX, shinY, shineR);
      shineGrad.addColorStop(0,   `rgba(255,255,255,${0.55 * alpha})`);
      shineGrad.addColorStop(0.6, `rgba(255,255,255,${0.15 * alpha})`);
      shineGrad.addColorStop(1,   `rgba(255,255,255,0)`);
      ctx.beginPath();
      ctx.arc(shinX, shinY, shineR, 0, Math.PI * 2);
      ctx.fillStyle = shineGrad;
      ctx.fill();

      // ---- Bottom-right micro-shine ----
      const shin2X = x + r * 0.28;
      const shin2Y = y + r * 0.30;
      const shine2R = r * 0.12;
      const shineGrad2 = ctx.createRadialGradient(shin2X, shin2Y, 0, shin2X, shin2Y, shine2R);
      shineGrad2.addColorStop(0,   `rgba(255,255,255,${0.30 * alpha})`);
      shineGrad2.addColorStop(1,   `rgba(255,255,255,0)`);
      ctx.beginPath();
      ctx.arc(shin2X, shin2Y, shine2R, 0, Math.PI * 2);
      ctx.fillStyle = shineGrad2;
      ctx.fill();

      // Dead at top or end of life
      if (b.life >= b.maxLife || b.y < -b.r * 2) {
        bubbles.splice(i, 1);
        spawnParticle(false);
      }
    }
  }


  // ---- Draw shooting stars ----
  function drawShootingStars() {
    for (let i = shootingStars.length - 1; i >= 0; i--) {
      const s = shootingStars[i];
      s.life++;
      s.x += Math.cos(s.angle) * s.speed;
      s.y += Math.sin(s.angle) * s.speed;
      s.opacity = 1 - s.life / s.maxLife;

      const tailX = s.x - Math.cos(s.angle) * s.len;
      const tailY = s.y - Math.sin(s.angle) * s.len;

      const grad = ctx.createLinearGradient(tailX, tailY, s.x, s.y);
      grad.addColorStop(0, `hsla(${s.hue}, 100%, 85%, 0)`);
      grad.addColorStop(0.7, `hsla(${s.hue}, 100%, 90%, ${s.opacity * 0.6})`);
      grad.addColorStop(1, `hsla(0, 0%, 100%, ${s.opacity})`);

      ctx.beginPath();
      ctx.moveTo(tailX, tailY);
      ctx.lineTo(s.x, s.y);
      ctx.strokeStyle = grad;
      ctx.lineWidth = s.width;
      ctx.shadowColor = `hsla(${s.hue}, 100%, 90%, ${s.opacity})`;
      ctx.shadowBlur = 8;
      ctx.stroke();
      ctx.shadowBlur = 0;

      if (s.life >= s.maxLife) shootingStars.splice(i, 1);
    }

    // Randomly spawn shooting stars
    if (Math.random() < 0.004 && shootingStars.length < 4) {
      spawnShootingStar();
    }
  }

  // ---- Draw dark overlay to keep UI readable ----
  function drawOverlay() {
    const isDark = !document.documentElement.hasAttribute('data-theme') ||
                   document.documentElement.getAttribute('data-theme') !== 'light';
    ctx.fillStyle = isDark ? 'rgba(5, 6, 12, 0.55)' : 'rgba(230, 235, 245, 0.50)';
    ctx.fillRect(0, 0, W, H);
  }

  // ---- Draw star field base ----
  function drawStarfield() {
    if (document.documentElement.getAttribute('data-theme') === 'light') return;
    const hue = getAccentHue();
    // Static small stars
    const seed = 42;
    for (let i = 0; i < 80; i++) {
      // Pseudo-random using index
      const sx = ((i * 1327 + seed * 37) % W);
      const sy = ((i * 977 + seed * 53) % H);
      const sr = i % 3 === 0 ? 1.2 : 0.6;
      const sa = 0.2 + (i % 5) * 0.08;
      ctx.beginPath();
      ctx.arc(sx, sy, sr, 0, Math.PI * 2);
      ctx.fillStyle = `hsla(${hue + i * 7}, 60%, 90%, ${sa})`;
      ctx.fill();
    }
  }

  // ---- Main render loop ----
  function render() {
    time++;
    ctx.clearRect(0, 0, W, H);

    drawOverlay();
    drawStarfield();
    drawNebula();
    drawAurora();
    drawParticles();
    drawShootingStars();

    animFrame = requestAnimationFrame(render);
  }

  // ---- Boot ----
  resize();
  initParticles();
  render();

  window.addEventListener('resize', () => {
    resize();
    initParticles();
  });

  // Re-sync bubble hue when accent changes (MutationObserver on :root style)
  const observer = new MutationObserver(() => {
    const hue = getAccentHue();
    bubbles.forEach(b => {
      if (b) b.hue = hue + (Math.random() - 0.5) * 120;
    });
  });
  observer.observe(document.documentElement, { attributes: true, attributeFilter: ['style'] });

})();

