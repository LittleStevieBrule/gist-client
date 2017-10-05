require_relative 'setup'
require_relative '../lib/gist_wrapper/constants'

require 'rspec/core/rake_task'
require 'tty-prompt'
require 'tty-spinner'
require 'pastel'
require 'pry'
require 'tty-command'


module GistWrapper
  class TTYShell

    attr_accessor :options

    def self.run
      header
      loop do
        begin
          opts = [
            'Run tests for CS496',
            'Interactive Mode',
            'leave'
          ]
          choice = instance.send(:prompt).select('What would you like to do',opts)
          case
            when choice == opts[0]
              TTY::Command.new.run!('rspec')
            when choice == opts[1]
              options = {login: 'littlesteviestestaccount', password: ENV['GITPASSWORD']}
              instance._login(options[:login], options[:password])
              puts 'Enter `help` for list of commands'
              loop do
                instance.login unless instance.logged_in?
                cmd = instance.send(:prompt).ask('>>> ')
                begin
                  next
                end if cmd.nil?
                instance.send(cmd) if instance.commands.include?(cmd.to_sym)
              end
            when choice == opts[2]
              exit
            else
              exit
          end
        rescue TTY::Reader::InputInterrupt
          puts ''
          puts 'restarting...'
          GistWrapper::TTYShell.run
        end
      end
    end

    def self.instance
      @instance ||= TTYShell.new
    end

    def self.header
        puts '-----------------------------------------------------------'
        octokit = 'Octokit'
        gist =
          '
     ██████╗ ██╗███████╗████████╗
    ██╔════╝ ██║██╔════╝╚══██╔══╝
    ██║  ███╗██║███████╗   ██║
    ██║   ██║██║╚════██║   ██║
    ╚██████╔╝██║███████║   ██║
     ╚═════╝ ╚═╝╚══════╝   ╚═╝'
        wrapper = instance.send(:printer).magenta('client-cli')
        puts "#{instance.send(:printer).yellow(octokit)} #{instance.send(:printer).cyan(gist)} #{wrapper}"
        puts "Version (#{GistWrapper::VERSION})"
        puts '-----------------------------------------------------------'
    end

    def initialize
      require_relative 'user_extended'
    end


    def commands
      [:create_gist, :delete_gist, :list_gists, :login, :logout, :back, :help].freeze
    end

    def back
      GistWrapper::TTYShell.run
    end

    def help
      cmds = commands.map(&:to_s).to_s
      puts "available commands #{cmds}"
    end

    def logout
      @user = nil
    end

    def _login(login, password)
      if attempt_login(login, password)
        user(login,password)
        # puts
        # puts printer.black.on_cyan("You are now logged in as #{login}: ")
        true
      else
        false
      end
    end

    def login
      loop do
        username = prompt.ask('Username for https://github.com: ' )
        password = prompt.mask("Password for #{username}: " )
        spinner = TTY::Spinner.new('[:spinner] Signing in...', format: :dots, clear: true)
        sleep 1
        spinner.auto_spin
        break spinner.stop if _login(username, password)
        spinner.stop
      end
    end

      def logged_in?
        @user
      end

    def user(login='', password = '')
      @user ||= GistWrapper::User.new({login: login, password: password})
    end

    # TODO move this into user class
    def attempt_login(login, password)
      begin
        GistWrapper::User.new({login: login, password: password}).authenticate
        true
      rescue Octokit::Unauthorized
        false
      end
    end

    def create_gist
      file = prompt.ask('Name of file: ')
      desc = prompt.ask('Description: ')
      content = prompt.ask('Contents: ' )
      gist =
        {
          description: desc,
          public: true,
          files: {
            file.to_sym => {
              content: content
            }
          }
        }
      user.create_gist(gist)
    end

    def delete_gist
      # gist_names = user.gists.map { |gist| gist.filename }
      # gist_ids = users.gists.map { |gist| gist.id }
      # gists = gist_ids.zip(gist_names).to_h
      if gists?
        gists = all_gists_names
        d = prompt.select('Which Gist would you like to delete', gists.keys)
        confirm = prompt.select('Are you sure? ', %w(yes no))
        if confirm == 'yes'
          user.delete_gist(id: gists[d])
          puts printer.red.bold("#{d.split(' - ')[0]} has been deleted!")
        end
      else
        puts printer.red('No gists to delete!')
      end
    end

    def list_gists
      if gists?
        puts printer.cyan.bold("Gist list:")
        puts printer.blue sep
        user.gists.each do |gist|
          list_gist gist
          puts printer.blue sep
        end
      else
        puts printer.red('No gists to list!')
      end
    end

    def list_gist(gist)
      puts printer.bold(gist_name(gist))
      puts printer.yellow("Description: #{gist.description}")
      puts printer.green("Contents: #{gist.content}")
    end

    def gist_name(gist)
      "#{gist.gist_filename} - #{gist.id}"
    end

    def all_gists_names
      ret = {}
      user.gists.each do |gist|
        ret[gist_name(gist)] = gist.id
      end
      ret
    end

    def gists?
      user.gist?
    end

    private

    def prompt
      @prompt ||= TTY::Prompt.new
    end

    def printer
      @printer ||= Pastel.new
    end

    def sep
      '-----------------------------------------------'
    end

  end
end

GistWrapper::TTYShell.run

