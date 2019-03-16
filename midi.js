// Handle Web MIDI API and send messages to Elm with MIDI data!

navigator.requestMIDIAccess().then(onMIDISuccess, onMIDIFailure);

let devicesArray = [];
let currentPort;
let connectionStatus = false;

function onMIDISuccess(midiAccess) {
  console.log(midiAccess);
  console.log(midiAccess.inputs);
  console.log(midiAccess.inputs.values());

  // On page load, if a device is connected, update state!
      if (midiAccess.inputs.size > 0) {

        for (var input of midiAccess.inputs.values()) {
          devicesArray.push(input);
          console.log(input);
        }

        console.log("num devices now: " + devicesArray.length);
        console.log(devicesArray);
        
        currentPort = devicesArray[ devicesArray.length - 1 ];

        // Listen for MIDI messages on current device!
        currentPort.onmidimessage = getMIDIMessage;
        
        // Tell Elm that MIDI has been successfully set up! -- bool
        // app.ports.handleInitMIDI.send(true); 
        // console.log("CONNECTED A NEEEWWW DEVICE, SENDING TRUE");

      } // end if a device is already connected on page load

    // Listen for connect/disconnect events!
    midiAccess.onstatechange = function(e) {
      console.log("STATE CHANGE:", e.port.name, e.port.manufacturer, e.port.state, e.port.connection);
      console.log(e);

      // If state has changed and most recent port is OPEN,
      // use this port!
      if (e.port.connection === "open") {
        connectionStatus = true;
        currentDevice = e.port;

        // Listen for MIDI messages on current device!
        currentPort.onmidimessage = getMIDIMessage;
        
        // Tell Elm that MIDI has been successfully set up! -- bool
        app.ports.handleInitMIDI.send(true); 
        console.log("PORT OPEN, SENDING TRUE");

      // OTHERWISE, if num devices hasn't changed,
        // that means one was disconnected ????
      } else if (e.port.connection === "closed") {
        let prevConnectionStatus = connectionStatus;
        connectionStatus = false;
        if (prevConnectionStatus === true) {
          // Tell Elm that MIDI has been REMOVED
          app.ports.handleInitMIDI.send(false); 
          console.log("PORT CLOSED, SENDING FALSE");
        }
      }
    }; // end onstatechange event handler

} // end if MIDI API available

function onMIDIFailure() {
  console.log('Could not access your MIDI devices.');
  // Tell Elm that MIDI is not available -- bool
  app.ports.handleInitMIDI.send(false); 
}


function getMIDIMessage(midiMessage) {
  console.log(midiMessage);
  // midiMessage looks like: [144, 72, 64]
  // index 0: command (note on/off), 144 means note on
  // index 1: note code, from 0 - 127
  // index 2: velocity

  const command = midiMessage.data[0];
  const noteCode = midiMessage.data[1];
  const velocity = midiMessage.data[2];

  console.log(command);
  console.log(noteCode);
  console.log(velocity);

  if (command === 144 && velocity > 0) {
    // Send MIDI note code to Elm -- integer
    app.ports.handleNotePlayed.send(noteCode); 
  }
}

