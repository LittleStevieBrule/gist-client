
# Gist-Wrapper

A wrapper for the [Octokit](https://github.com/octokit/octokit.rb) gem. Specifically for Gist.


### Prerequisites

You need [bundler](http://bundler.io/) if you do not already have it.

First clone this repo:

```ruby
 $ git clone https://github.com/LittleStevieBrule/octokit-gist-wrapper.git
```

Install the dependencies for this project:

```
$ bundle install
```

### Providing an OAuth token

To run the tests you will need a Github OAuth token. You need to provide the token in the token.yaml file like this:

```yaml
---
:token: <40 char auth token>

```

You can run the setup script. This can generate a token for you and write the token.yaml file. The script will prompted you for what you would like to do.

```
$ ./setup.rb
```
OR

Do it yourself.
You can learn more about how to generate a token here [here](https://github.com/octokit/octokit.rb#oauth-access-tokens)
The token needs to be create with gist permissions


### Running the tests

Once you have a valid token in the token.yaml file. You can run the tests:

```
rspec
```

### TODO:

