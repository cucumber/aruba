require 'fileutils'

if(ENV['ARUBA_REPORT_DIR'])
  require 'aruba/platform'
  Aruba.platform.deprecated 'The use of "aruba/reporting" is deprecated. This functionality will be removed with "1.0.0"'

  ENV['ARUBA_REPORT_TEMPLATES'] ||= File.dirname(__FILE__) + '/../../templates'

  require 'fileutils'
  require 'erb'
  require 'cgi'
  require 'bcat/ansi'
  require 'rdiscount'
  require 'aruba/spawn_process'

  module Aruba
    module Reporting
      class << self
        def reports
          @reports ||= Hash.new do |hash, feature|
            hash[feature] = []
          end
        end
      end

      def pygmentize(file)
        pygmentize = Processes::SpawnProcess.new(%{pygmentize -f html -O encoding=utf-8 "#{file}"}, 3, 0.5, Dir.getwd)
        pygmentize.run! do |p|
          exit_status = p.stop(false)
          if(exit_status == 0)
            p.stdout(false)
          elsif(p.stderr(false) =~ /no lexer/) # Pygment's didn't recognize it
            IO.read(file)
          else
            STDERR.puts "\e[31m#{p.stderr} - is pygments installed?\e[0m"
            exit $CHILD_STATUS.exitstatus
          end
        end
      end

      def title
        @scenario.title
      end

      def description
        unescaped_description = @scenario.description.gsub(/^(\s*)\\/, '\1')
        markdown = RDiscount.new(unescaped_description)
        markdown.to_html
      end

      def commands
        @commands || []
      end

      def output
        aruba.config.keep_ansi = true # We want the output coloured!
        escaped_stdout = CGI.escapeHTML(all_stdout)
        html = Bcat::ANSI.new(escaped_stdout).to_html
        Bcat::ANSI::STYLES.each do |name, style|
          html.gsub!(/style='#{style}'/, %{class="xterm_#{name}"})
        end
        html
      end

      def report
        erb = ERB.new(template('main.erb'), nil, '-')
        erb.result(binding)
      end

      def files
        erb = ERB.new(template('files.erb'), nil, '-')
        file = current_directory
        erb.result(binding)
      end

      def again(erb, erbout, file)
        erbout.concat(erb.result(binding))
      end

      def children(dir)
        Dir["#{dir}/*"].sort
      end

      def template(path)
        IO.read(File.join(ENV['ARUBA_REPORT_TEMPLATES'], path))
      end

      def depth
        File.dirname(@scenario.feature.file).split('/').length
      end

      def index
        erb = ERB.new(template('index.erb'), nil, '-')
        erb.result(binding)
      end

      def index_title
        "Examples"
      end
    end
  end
  World(Aruba::Reporting)

  After do |scenario|
    @scenario = scenario
    html_file = "#{scenario.feature.file}:#{scenario.line}.html"
    report_file = File.join(ENV['ARUBA_REPORT_DIR'], html_file)
    _mkdir(File.dirname(report_file))
    File.open(report_file, 'w') do |io|
      io.write(report)
    end

    Aruba::Reporting.reports[scenario.feature] << [scenario, html_file]

    FileUtils.cp_r(File.join(ENV['ARUBA_REPORT_TEMPLATES'], '.'), ENV['ARUBA_REPORT_DIR'])
    Dir["#{ENV['ARUBA_REPORT_DIR']}/**/*.erb"].each{|f| FileUtils.rm(f)}
  end

  at_exit do
    index_file = File.join(ENV['ARUBA_REPORT_DIR'], "index.html")
    extend(Aruba::Reporting)
    File.open(index_file, 'w') do |io|
      io.write(index)
    end
  end
end
