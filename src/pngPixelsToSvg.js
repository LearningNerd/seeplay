'use strict';

// Convert a small PNG pixel by pixel into a pixel-art SVG
// Code mostly stolen from:
// https://github.com/mapbox/pixelmatch/blob/master/bin/pixelmatch

var PNG = require('pngjs').PNG,
    fs = require('fs');

if (process.argv.length < 4) {
    console.log('Usage: pngPixelsToSvg.js input.png output.svg');
    process.exit(64);
}

var img = fs.createReadStream(process.argv[2]).pipe(new PNG()).on('parsed', doneReading);

var outputFile = process.argv[3];

var svg = `<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" `;

function drawSvgPixel(xPos, yPos, r, g, b, a) {
  return `<rect width="1" height="1" x="${xPos}" y="${yPos}" fill="rgba(${r}, ${g}, ${b}, ${a})"/>`;
}

function doneReading() {
    if (!img.data) return;

     console.log("width: ", img.width);
     console.log("height: ", img.height);
     console.log("numPixels: ", img.width * img.height);

    svg += ` height="${img.height}px" width="${img.width}px">`;

  // Loop through every pixel!
  for (var y = 0; y < img.height; y++) {

        for (var x = 0; x < img.width; x++) {
            // Position for each pixel is every 4 values (rgba)
            var pos = (y * img.width + x) * 4;

            // console.log(img.data[pos]);
            // console.log(img.data[y * img.width + x]);

            // Get the color of the pixel!
            var r = img.data[pos + 0];
            var g = img.data[pos + 1];
            var b = img.data[pos + 2];
            // Convert from 0 to 255 range to 0 to 1 range,
            // to 2 decimal places (like 0.55)
            var a = parseFloat(img.data[pos + 3] / 255).toFixed(2);

           console.log("pos: ", pos);
           console.log("rgba: ", r, g, b, a);
           console.log("-----------");

          // console.log("pos/4 / img.height - ", pos/4, "%", img.height, " = ", ( (pos/4) % img.height));
          // var xPos = pos % img.width;
          // var yPos = Math.floor(pos / img.width);
          var xPos = (pos/4) % img.width;
          var yPos = Math.floor( (pos/4) / img.width);

           console.log(xPos, yPos);
          console.log("==================");


          // Only draw pixels that aren't totally transparent
          if (a !== "0.00") {
            svg += drawSvgPixel(xPos, yPos, r, g, b, a);
          }
        }
  } // end outer loop

  // Finish creating the SVG!
  svg += '</svg>';
  // console.log(svg);

  // Write to `outputFile`!
  var writeStream = fs.createWriteStream(outputFile);

  writeStream.on('close', function () {
    // console.log("\r\n \\( ﾟヮﾟ)/  Hurray! Converted to SVG and saved to file: " + outputFile) + "\r\n";
      console.log("\r\n (ﾉ^ヮ^)ﾉ*:・ﾟ✧ \r\n Hurray! Converted to SVG and saved to file: " + outputFile) + "\r\n";
      process.exit();
  });

  writeStream.on('error', function (err) {
      console.log("\r\n（>﹏<）\r\n Error in writing file: \r\n " + err + "\r\n");
      process.exit();
  });

  writeStream.write(svg);
  writeStream.end();

} // end function

