# xkcdME

## What specific areas of the project did you prioritize? And Why?

I've been using this README as a place to outline of what I wanted to accomplish at each stage of development, so I'll leave that part in at the bottom to give you an idea of my approach. As for the why...

<ol>
  <li>Setup + Networking</li>
  I like to work iteratively and have small successes to branch off from and build upon, so usually if I am dealing with any kind of data from an API I want to make sure that's the first thing I do. Get my data. Is it what I expect? Once I've got the data, I can do with it what I like. I also wanted to make sure I was familiar with the technical requirements for the project, and since it specifically mentioned async/await and MVVM, it made sense to prioritize those foundational aspects as well.
  
  <li>Bind + Render</li>
  Once I have the data, I want to pass it around! Start to create screens and make sure that no surprises (like, say, if the image URLs didn't work as easily as the Comic endpoints did) sneak up on me. Since I have no designs to reference, it's also important to start visualizing how I will want to lay everything out on the screen by actually rendering it.
  
  <li>Navigation + Detail</li>
  On a larger project, separating out a networking layer and utilizing the NavigationStack in such a way that I can have more control over it (for deeplinking, for instance) would be a priority, but I wanted to go with the basic implementation first to see if I even needed a separate navigation layer. I really don't think I did, but it's good to discover that early. I also went back and re-confirmed the AC, focusing on some of the asks (button, separate screen, etc.) that I had put off until this point.

  <li>Unit Tests</li>
  This was something I wanted to spend a good amount of time on because I wanted to work with some of the newer Swift Testing features (like passing in arguments) even though they're still pretty new to me. To be honest, if I had the project to do all over again, I would probably start on these earlier and potentially even go with a more Test Driven approach, rather than just testing what I implemented. Then when I (spoiler) changed a whole lot later on and all my tests broke, I wouldn't have had to go back and spend a good amount of time fixing them. That said, working on the tests was the most fun part of the project for me, and I think I might be a little more open to TDD...

  <li>Cleanup</li>
  I really wanted to implement accessibility and better error handling for the user before wrapping this up, but since neither was a listed priority for the project, I figured it could wait until near the end. The error handling is actually what tripped me up... in a great way! I realized that working with one ViewModel between two separate Views (with two different comics) was not ideal for properly tracking errors, and my state was behaving in unexpected ways. Separating things out was a longer process than I would have liked, but it should have been done that way from the start, and it really allowed me to debug a tricky little data race I was having.

  <li>Pre-Stretch</li>
  Now I am here, answering the questions asked in the assignment with plenty of time to spare. I'll wrap this up in the morning, then finish my cleanup (I think breaking some of the Views out into separate Components will be nice) and finally, once I think it is totally done, move on to my stretch goals (time-permitting)...

  <li>Stretch</li>
  Just because I noticed xkcd had a button to fetch a random comic (even though I could do it just as easily with my own logic) I thought it might be fun to include a way to do that. Also, to potentially search by Date, but I don't think I'll have time for that. They are nice-to-haves, but I will need to wrap up the must-haves before even considering these.
</ol>

## Approximately how long did you spend working on this project? How did you allocate your time?

I probably spent around 15 hours on this project.

<ul>
  <li>The first 3 hours or so were spent going over AC, looking at the API, setting up the project locally and remotely, and creating the initial model and networking service</li>
  <li>The next 4 hours were spent building out the app, getting components on-screen. Hooking up navigation and getting the data flow to basically where I wanted it to be, and creating passing unit tests.</li>
  <li>I spent another 1-2 hours making sure all technical requirements were satisfied and adding a few things like accessibility and improved error handling that I really wanted to include.</li>
  <li>Once the error handling led me to discover some issues with my initial implementation, I spent another 4 hours on refactoring and cleanup. I had already gotten the app to a place where it was (mostly) working well enough to satisfy the technical requirements, so I was free to play around on my feature branch and work on getting it functioning better without fear of causing myself a ton of problems.</li>
  <li>After that, of course I had to spend an hour fixing the unit tests, which were all broken.</li>
  <li>My last hour or so, this morning, will be spent answering questions in this README and (time-permitting) one last look at the decisions I made last night, before heading off to work.</li>
</ul>

Overall, I'd say I spent 3 hours setting the project up, 5-6 hours fleshing it out and getting all my components on-screen, 5-6 hours refactoring and cleaning up, and 1 hour wrapping it all up.

## Did you make any significant trade-oﬀs?

The biggest trade-off I think I made was to prioritize architecture over design. When given an open-ended project without a specific Figma design I am trying to match, it's hard not to want to spend a lot of time on layout, UI, UX, and the things that the user will see and interact with on-screen. Instead I spent the majority of my time really investigating the design pattern I'd set up, assess its strengths and weaknesses, try breaking it (succeeding in that regard!) and quickly adapting.

I also spent more time trying to design a unified error handling system, with various error enums conforming to a custom error protocol that just wasn't really serving any purpose other than making testing unnecessarily burdensome, so I gave up on that after a while and just went with a more basic approach. So I would say I also spent more time experimenting with unique ways to try and make the app more scalable than I did trying to get too deep into the UI.

If I had a little more time I would probably spend a bit more time with SwiftUI-centric features like custom view modifiers and passing data through the environment (or up through preference keys) rather than just mostly injecting everything.

## Additional information?

I've already probably gone on too long in this explanation of how it went, so I'll just take this space to say thanks! This was a super fun project to work on, and the time flew by. I'd love to hear any feedback you have, especially in regards to the structure of the project and its testability!

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
