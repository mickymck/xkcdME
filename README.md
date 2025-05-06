# xkcdME

## Step 1: Setup + Networking

<ol>
  <li>create Comic model</li>
  <li>create Networking service</li>
  <li>create the VM to call the Service</li>
</ol>

## Step 2: Bind + Render

<ol>
  <li>create a TextField for the number</li>
  <li>bind the number to the @State var and fetch the correct Comic</li>
  <li>render the AsyncImage on the screen</li>
</ol>

## Step 3: Navigation + Detail

<ol>
  <li>create a Nav Stack</li>
  <li>instead of rendering Comic on the main View, navigate to a detailView</li>
  <li>change TextField to include Submit button</li>
  <li>add Date to the Model and format it for the DetailView</li>
</ol>

## Step 4: Unit Tests

<ol>
  <li>create testable protocol for easy injection</li>
  <li>write some unit tests with injected mock data</li>
</ol>

<b>note:</b> https://xkcd.com/info.0.json is the current comic, and it has a "num" value that can give me the total number of comics, so I can prevent the user from entering a number that is too large
