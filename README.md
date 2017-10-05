
# Gist-Wrapper

A wrapper for the [Octokit](https://github.com/octokit/octokit.rb) gem. Specifically for Gist.


### Prerequisites

Ruby 2.4.0 is required
I recommend using [rvm](https://rvm.io/rvm/install)


You need [bundler](http://bundler.io/) if you do not already have it.

First clone this repo:

```
 $ git clone https://github.com/LittleStevieBrule/octokit-gist-wrapper.git
```
```
$ cd octokit-gist-wrapper
```

Install the dependencies for this project:

```
$ bundle install
```

### Providing an OAuth token

To run the tests you will need a personal access token from Github. You need to put this in the token.yaml file like this:

```yaml
---
:token: ThisIsNotARealToken

```

If you run the setup script it will generate a token for you and write this token to the token.yaml file. The script will prompt you for your Github username and password.

```
$ rake setup
```

##### I want to generate it myself:
You can generate a token [here](https://github.com/settings/tokens)
The token needs to be create with gist permissions


### Running the tests

Once you have a valid token in the token.yaml file. You can run the tests:

```
$ rake tests

```

### IMPORTANT NOTE:
The Github api has a [rate limit](https://developer.github.com/v3/#rate-limiting) for the number requests. If you run into this issue you can up the rate for a personal access token using something like this:

```
$ curl -i https://api.github.com/users/whatever?access_token=<your personal access token>
```

### TODO

* improve help message
* make it clear which user is logged in
* auto complete commands
* Github link to the project
* Improve how the user inputs content
* CLI needs to have a better information about the project at the intro
* choose to list view a list of your gists and choose which one you want to view in detail
* edit!