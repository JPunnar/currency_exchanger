# README

This is a web app written as a developer test.
Example can be accessed at https://gentle-tundra-31925.herokuapp.com/

This is a web app that helps You to decide when to exchange money
from one currency to another.
Written using Ruby on Rails framework.
Rails version: 5.1.5
Ruby version: 2.4.1
App makes API requests to fetch currency exchange rates. Identical request is never made twice.
The more this app is used, the more currency exchange rates data is saved to database.
This means that speed and reliability grow with use.
Report generation time can be about one minute if making report with 250 weeks and all of the rates need to be fetched through API (due to API limitations, requests must be throttled).

Tested using Postgres database.

NB! This app is not intended for real-world use; The prediction algorithm simply uses randomness.
