let isMIDIConnected = false;
let noteCode = 59;

document.addEventListener("click", () => {
  if (!isMIDIConnected) {
    isMIDIConnected = true;
    console.log("Now connected to fake MIDI! Click again to play fake notes.");

    // Tell Elm that MIDI has been successfully set up! -- bool
    app.ports.fakeHandleInitMIDI.send(true); 

  } else {
    if (noteCode >= 108) {
      noteCode = 21
    } else {
      noteCode++;
    }
    
    console.log("Fake note played: " + noteCode);

    // Send MIDI note code to Elm -- integer
    app.ports.fakeHandleNotePlayed.send(noteCode); 
  }

});

