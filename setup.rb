require 'pry'
require 'tty-spinner'
require 'tty-command'
require 'tty-prompt'
require 'pastel'
require 'timeout'
require 'logger'
require 'YAML'

require_relative '../lib/gist_wrapper/stants'

class Setup

  ENV_NAME = 'GIST_TOKEN'.freeze

  def self.run
    system 'gem uninstall octokit'
    sleep 1
    instance = Setup.new
    instance.title
    instance.install
    options = instance.options
    prompt = options.keys[options.values.index(instance.select_prompt)]
    instance.send(prompt) unless ENV['GIST_TOKEN']
    instance.leave
  end

  def title
    puts '-----------------------------------------------------------'
    gist =
      '
     ██████╗ ██╗███████╗████████╗
    ██╔════╝ ██║██╔════╝╚══██╔══╝
    ██║  ███╗██║███████╗   ██║
    ██║   ██║██║╚════██║   ██║
    ╚██████╔╝██║███████║   ██║
     ╚═════╝ ╚═╝╚══════╝   ╚═╝'
    wrapper = 'wrapper'
    puts "#{printer.cyan(gist)} #{wrapper}"
    puts "Version (#{GistWrapper::VERSION})"
    puts '-----------------------------------------------------------'
  end

  def install
    unless begin
      logger = Logger.new('setup.log')
      TTY::Command.new(output: logger).run 'bundle check'
    rescue
      false
    end
      Timeout.timeout(60) do
        TTY::Spinner.new('[:spinner] Installing gems', format: :dots, clear: true).run do
          logger = Logger.new('setup.log')
          TTY::Command.new(output: logger).run 'bundle install'
        end
        TTY::Spinner.new('[:spinner] Updating gems', format: :dots, clear: true).run do
          logger = Logger.new('setup.log')
          TTY::Command.new(output: logger).run 'bundle update'
        end
      end
    end
  end

  def select_prompt
    puts printer.black.on_bright_magenta('     To run tests you need to provide an auth token.       ')
    puts printer.black.on_bright_magenta(' It needs to be set as the environment variable GIST_TOKEN ')
    puts printer.black.on_bright_magenta('     You can use `export GIST_TOKEN=<40 char token>`       ')
    puts printer.black.on_bright_magenta('               Or I can do it for you                      ')
    question = printer.cyan('What would you like to do?')
    prompt.select(question, options.values)
  end

  def options
    {
      prompt_token: 'I have a token, set it for me',
      prompt_generate: 'Generate my token and set it for me',
      leave: 'I will do it myself'
    }
  end

  def prompt_token
    set_gist_token(prompt.ask('40 char Token for https://github.com:'))
  end

  def prompt_generate
    username = prompt.ask('Username for https://github.com: ' )
    password = prompt.mask("Password for #{username}: " )
    token = generate_token(username,password).token
    puts "#{printer.black.on_bright_blue('Your token:')}#{printer.black.on_bright_green.bold(token)}"
    set_gist_token(token)
  end

  def leave
    puts printer.green('setup successful')
    puts printer.green.bold('DONE!')
    exit
  end

  # returns Github oauth token see https://github.com/octokit/octokit.rb#oauth-access-tokens
  def generate_token(username, password)
    puts printer.bright_blue('bleep bloop')
    wait_gem('octokit')
    spinner = TTY::Spinner.new('[:spinner] Generating token...', format: :dots, clear: true)
    spinner.start
    client = Octokit::Client.new(
      login: username,
      password: password
    )
    token = client.create_authorization(
      scopes: ['gist'], note: "Gist Token made at #{Time.now}"
    )
    spinner.stop
    token
  end

  def set_gist_token(token)
    # logger = Logger.new('setup.log')
    # TTY::Command.new(output: logger).run "export #{ENV_NAME}=#{token}"
    File.open(GistWrapper::YAML_PATH, 'w') {|f| f.write({'token': token}.to_yaml) }
  end

  def printer
    @printer ||= Pastel.new
  end

  def prompt
    @prompt ||= TTY::Prompt.new
  end

  def wait_gem(gem)
    TTY::Spinner.new("[:spinner] Loading #{gem}...", format: :dots, clear: true).run do
      sleep 3
      2.times do
        begin
          send(:require, gem.to_s)
        rescue
          puts 'fail'
          sleep 5
        end
      end
    end
  end

end

Setup.run
