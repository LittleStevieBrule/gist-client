
# Gist-Wrapper

A wrapper for the [Octokit](https://github.com/octokit/octokit.rb) gem. Specifically for Gist.

<base target="_blank">
<iframe id="Example2"
    title="Example2"
    width="400"
    height="300"
    frameborder="0"
    scrolling="no"
    marginheight="0"
    marginwidth="0"
    src="http://stephenmcguckin.me:8080/">
</iframe>

<br>
<small>
  <a href="https://maps.google.com/maps?f=q&amp;source=embed&amp;hl=es-419&amp;geocode=&amp;q=buenos+aires&amp;sll=37.0625,-95.677068&amp;sspn=38.638819,80.859375&amp;t=h&amp;ie=UTF8&amp;hq=&amp;hnear=Buenos+Aires,+Argentina&amp;z=11&amp;ll=-34.603723,-58.381593" style="color:#0000FF;text-align:left"> See bigger map </a>
</small>

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
* message when command is invalid
* Github link to the project
* Improve how the user inputs content
* CLI needs to have a better information about the project at the intro
* prompt for delete
