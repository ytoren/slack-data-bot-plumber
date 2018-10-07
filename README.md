# Plumber + Slack = chatbot (of sorts)

This repo contains code that demonstrate a simple use of R's `plumber` package to build a Slack app that can provide useful data using the Slack API. 

## Part 1: Plumber
The R package `plumber` ([https://www.rplumber.io](https://www.rplumber.io/)) is the main engine behind all of this. If you already have some idea about how the HTTP API wprks you can get almost everything you need from the intro page. If you don't make sure you read the (documentation)[https://www.rplumber.io/docs/] - you can focus on info secions in parts 1-4.

Once you have the app script written just run the app on your local machine and test that it's working in your browser (dont' worry, it's all in the (quickstart)[https://www.rplumber.io/docs/quickstart.html]). Depending on your platform, you might want to do more programmatic testing using `curl`.

## Part 2: HTTPS on localhost via ngrok
If you already have a machine that has a visible IP you can use it to run the `plumber` service (just make sure you open the ports and setup HTTPS correctly). However this is not a must. If you only want to test stuff I recommend setting up everything on you local machine. Luckily the good people at Slack wrote a great post on (running a local server)[https://api.slack.com/tutorials/tunneling-with-ngrok], and it boils down to installing `ngrok` (as simple as `brew cask install ngrok` on my Mac), pointing it to the same port you used for `plumber` and using the provided HTTPS url when creating the Slack app. Voila!

## Part 3: Slack
Creating your own space for testing is fairly straight forward (you'll have to register). Once you're logged in, goto (https://api.slack.com/apps)[https://api.slack.com/apps], create your own app and use the HTTPS url you got from `ngrok`. 

## Credits
I first stumbled upon this frameword on the [RViews](https://rviews.rstudio.com/2018/08/30/slack-and-plumber-part-one/) blog, but could not wait for the next parts (I built this on 07/10/2018 and only part 1 was published). 
