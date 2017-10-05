require_relative 'setup'
require_relative '../lib/gist_wrapper/constants'

require 'rspec/core/rake_task'
require 'tty-prompt'
require 'tty-spinner'
require 'pastel'
require 'pry'
require 'tty-command'
require 'tty-editor'


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
              options = {login: 'littlesteviestestaccount', password: 'Password8!@#'}
              instance._login(options[:login], options[:password])
              puts 'Enter `help` for list of commands'
              loop do
                instance.login unless instance.logged_in?
                cmd = instance.send(:prompt).ask('>>> ')
                next if cmd.nil?
                if instance.commands.include?(cmd.to_sym)
                  instance.send(cmd)
                else
                  puts "#{instance.printer.red('Command not found: ')} #{cmd}"
                  instance.help
                end
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
      line = '████████████████████████████████████████████████████████████'
      puts instance.printer.magenta(line)
      gist =
        '
   ██████╗ ██╗███████╗████████╗
  ██╔════╝ ██║██╔════╝╚══██╔══╝
  ██║  ███╗██║███████╗   ██║
  ██║   ██║██║╚════██║   ██║
  ╚██████╔╝██║███████║   ██║
   ╚═════╝ ╚═╝╚══════╝   ╚═╝'
      octokit = instance.send(:printer).yellow('Octokit')
      gist = instance.send(:printer).cyan(gist)
      wrapper = instance.send(:printer).magenta('client-cli')
      puts "#{octokit} #{gist} #{wrapper}"
      puts "Version (#{GistWrapper::VERSION})"
      puts instance.printer.magenta(line)
    end

    def initialize
      require_relative 'user_extended'
    end


    def commands
      [:create, :delete, :list, :back, :exit, :help].freeze
    end

    def back
      GistWrapper::TTYShell.run
    end

    alias_method :exit, :back

    def help
      cmds =
      {
       create: 'Creates a gist',
       delete: 'Deletes a gist',
       list: 'Lists your gists',
       back: 'Go back',
       exit: 'See `back`',
       help: 'This message'
      }
      puts printer.bold('Valid commands:')
      cmds.each do |k,v|
        puts "#{printer.magenta.bold(k)} - #{printer.yellow(v)}"
      end
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

    def create
      file = prompt.ask('Name of file: ')
      desc = prompt.ask('Description: ')
      content =
        if prompt.select('Would you like to use an editor?', %W(yes no)) == 'yes'
          TTY::Editor.open(file)
          File.open(file).read
        else
          prompt.ask('Content: ')
        end
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
      puts printer.green.bold('Gist created!')
    end

    def delete
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

    def list
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

    def printer
      @printer ||= Pastel.new
    end

    def prompt
      @prompt ||= TTY::Prompt.new
    end

  end
end

GistWrapper::TTYShell.run

