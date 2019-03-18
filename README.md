# SeePlay

*Learn to sight-read sheet music! SeePlay teaches you to hear with your eyes and play from your heart.* 👀🎹💖

Built with [Elm](https://elm-lang.org) and the web MIDI API. This project is a work in progress, because I'm using this to [learn Elm](https://elm-lang.org)!

***Important note:** The Web MIDI API pretty much only works in Google Chrome and Opera for now. (See [CanIUse.com/#feat=midi](https://caniuse.com/#feat=midi) for details on cross-browser support.)*


## Development setup

  1. Make sure you have Nodejs installed: `node --version`
 
  1. Install the latest version of Elm by [following these instructions from the official Elm docs](https://guide.elm-lang.org/install.html) 

  1. Install the Elm tests package with `npm install -g elm-test`

  1. Clone this repository: `git clone https://github.com/LearningNerd/seeplay.git`
  
  1. Go to the project directory (`cd seeplay`) and run `npm install` to download dependencies

  1. Compile the Elm code with `elm make src/Main.elm --output=elm.js`

  1. Run tests with `elm-test`

  1. Open the `index.html` file in your web browser to run the app locally

