if(ENV['ARUBA_REPORT_DIR'])
  require 'fileutils'
  require 'erb'
  require 'bcat/ansi'
  require 'rdiscount'
  require 'aruba/process'

  module Aruba
    module Reporting
      def pygmentize(file)
        pygmentize = Process.new(%{pygmentize -f html -O encoding=utf-8 "#{file}"}, 3, 0.5)
        pygmentize.run! do |p|
          exit_status = p.stop
          if(exit_status == 0)
            p.stdout
          elsif(p.stderr =~ /no lexer/) # Pygment's didn't recognize it
            IO.read(file)
          else
            STDERR.puts "\e[31m#{p.stderr} - is pygments installed?\e[0m"
            exit $?.exitstatus
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
        @commands
      end

      def output
        html = Bcat::ANSI.new(all_stdout).to_html
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
        file = current_dir
        erb.result(binding)
      end
      
      def again(erb, _erbout, file)
        _erbout.concat(erb.result(binding))
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
    end
  end
  World(Aruba::Reporting)

  Before do |scenario|
    @scenario = scenario
  end

  After do
    report_file = File.join(ENV['ARUBA_REPORT_DIR'], "#{@scenario.feature.file}:#{@scenario.line}.html")
    _mkdir(File.dirname(report_file))
    File.open(report_file, 'w') do |io|
      io.write(report)
    end

    FileUtils.cp_r(File.join(ENV['ARUBA_REPORT_TEMPLATES'], '.'), ENV['ARUBA_REPORT_DIR'])
    Dir["#{ENV['ARUBA_REPORT_DIR']}/**/*.erb"].each{|f| FileUtils.rm(f)}
  end
end

