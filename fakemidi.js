let isMIDIConnected = false;
let noteCode = 59;

// .............. add test control buttons to top of page ..............

// Control bar
const testControls = document.createElement("section");
testControls.className = "testControls";

// const sectionTitle = document.createElement("h2");
// sectionTitle.textContent = "Test without a MIDI instrument:"

// Connect MIDI
const connectButton = document.createElement("button");
connectButton.textContent = "Click here to test the game without a MIDI instrument";
connectButton.addEventListener("click", connectFakeMidi);

// Generate buttons for the supported MIDI codes:
const noteMidi = [60, 62, 64, 65, 67, 69, 71, 72, 74, 76, 77, 79];

const noteButtons = noteMidi.map( midi => {
  const elem = document.createElement("button");
  elem.textContent = getNoteName(midi);
  elem.setAttribute('data-midi', "" + midi);
  elem.addEventListener("mousedown", pressFakeNote);
  elem.addEventListener("mouseup", releaseFakeNote);
  return elem;
});

// Append to DOM
// testControls.appendChild(sectionTitle);
testControls.appendChild(connectButton);
document.body.append(testControls);
// .....................................................................

function connectFakeMidi () {
  if (!isMIDIConnected) {
    isMIDIConnected = true;
    console.log("Now connected to fake MIDI! Click again to play fake notes.");

    // Remove "connect to fake midi" button
    testControls.removeChild(connectButton);

    // Display buttons to play notes
    noteButtons.map( elem => { 
      testControls.appendChild(elem);
    });

    // Tell Elm that MIDI has been successfully set up! -- bool
    app.ports.fakeHandleInitMIDI.send(true); 
  }
}

function pressFakeNote (e) {
  const midiCode = e.target.dataset.midi;
  console.log(midiCode + ", " + e.target.textContent + " pressed!");
  // Send MIDI note code to Elm -- integer
  app.ports.fakeHandleNotePressed.send( parseInt(midiCode, 10) ); 
}

function releaseFakeNote (e) {
  const midiCode = e.target.dataset.midi;
  console.log(midiCode + ", " + e.target.textContent + " released!");
  // Send released msg to Elm
  app.ports.fakeHandleNoteReleased.send(true); 
}


// Helper for converting midi codes to note name + octave
function getNoteName (midi) { 
  const noteNames = [ "C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B" ];
  const index = midi % 12;
  const octave = Math.floor(midi / 12) - 1;
  return "" + noteNames[index] + octave;
}

