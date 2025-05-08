# xkcdME

## What specific areas of the project did you prioritize? And Why?

I've used this README as a chronological outline of what I wanted to accomplish at what stage of development, so I'll leave that part in at the bottom to give an idea of how I approached this project. As for the why...

<ol>
  <li>Setup + Networking</li>
  I like to work iteratively and have small successes to build upon, so usually if I am dealing with any kind of data from an API I want to make sure that's the first thing I do. Get my data. Once I've got that, I can do with it what I like. I also wanted to make sure I was familiar with the acceptance criteria for the project, and since it mentioned specifically async/await and MVVM, it made sense to prioritize those things as well.
  
  <li>Bind + Render</li>
  Once I have the data from the API, I want to pass it around! Start to create screens and make sure that no surprises (like if the image URLs didn't work as easily as the Comic endpoints did) snuck up on me. Since I have no designs to reference, it's also important to start visualizing how I will want to lay everything out on the screen by actually doing it.
  
  <li>Navigation + Detail</li>
  On a larger project, separating out a networking layer and utilizing the NavigationStack in such a way that I can have more control over it (for deeplinking, for instance) would be a priority, but I wanted to go with the basic implementation first to see if I even needed a separate navigation layer. I really don't think I did, but it's good to discover that early. I also went back and re-confirmed the AC, focusing on some of the asks that I had put off until this point.

  <li>Unit Tests</li>
  This was something I wanted to spend a good amount of time on, because I wanted to work with some of the newer Swift Testing features (like passing in arguments) even though I'm not super familiar with them. To be honest, if I had the project to do all over again, I would probably start on these earlir and poten tially even go with a more Test Driven Development approach based on the Acceptance Criteria, rather than just testing what I implemented, and then when I (spoiler) changed a whole lot later on, all my tests broke and I had to go back and fix them. That said, working on the tests was the most fun part of the project, and I think I might be a recent convert to TDD...

  <li>Cleanup</li>
  I really wanted to implement accessibility and better error handling for the user before wrapping this up, but since neither was a listed priority for the project, I figured it could wait until near the end. The error handling is actually what tripped me up... in a great way! I realized that working with one ViewModel between two separate Views (with two different comics) was not ideal for properly tracking errors, and my state was behaving in unexpected ways. Separating things out was a longer process than I would have liked, but it should have been done that way from the start, and it really allowed me to dig deep into error handling.

  <li>Pre-Stretch</li>
  Here I am, starting in on the questions asked in the assignment with plenty of time to spare. I'll wrap this up in the morning, then finish my cleanup (I think breaking some of the Views out into separate Components will be nice) and finally, once I think it is totally done, move on to my stretch goals (time-permitting)...

  <li>Stretch</li>
  Just because I noticed xkcd had a button to fetch a random comic (even though I could do it just as easily with my own logic) I thought it might be fun to include a way to fetch a random comic. Also, to potentially search by Date, but I don't think I'll have time for that. They are nice-to-haves, but I will need to wrap up the must-haves before even considering these.
</ol>

--------------------------------------------------

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

## Step 5: Cleanup

<ol>
  <li>accessibility</li>
  <li>handle errors better for the user - specifically around number rules</li>
  <li>remove any TODOs from the code</li>
  <li>confirm all operations are running on proper threads and are async if necessary</li>
  <li>better UI for the textField and Button</li>
</ol>

## Pre-Stretch

<ol>
  <li>answer assignment questions in README</li>
  <li>finish reorganizing + renaming</li>
</ol>

## Stretch

<ol>
  <li>random Comic? could be fun!</li>
  <li>search by Date? could be fun!</li>
</ol>
