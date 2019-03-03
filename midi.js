// Handle Web MIDI API and send messages to Elm with MIDI data!

navigator.requestMIDIAccess().then(onMIDISuccess, onMIDIFailure);

function onMIDISuccess(midiAccess) {
  console.log(midiAccess);
  console.log(midiAccess.inputs);
  console.log(midiAccess.inputs.values());

  if (midiAccess.inputs.size > 0) {
    // let outputs = midiAccess.outputs;

    let ar = [];
    for (var input of midiAccess.inputs.values()) {
      ar.push(input);
      console.log(input);
    }

    console.log(ar);

    ar[0].onmidimessage = getMIDIMessage;
    console.log(ar[0]);
    // Tell Elm that MIDI has been successfully set up! -- bool
    app.ports.handleInitMIDI.send(true); 
  }
}

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

