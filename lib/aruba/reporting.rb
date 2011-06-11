if(ENV['ARUBA_REPORT_DIR'])
  require 'fileutils'
  require 'erb'
  require 'bcat/ansi'
  require 'rdiscount'
  require 'aruba/process'
  $aruba_report_dir = File.expand_path(ENV['ARUBA_REPORT_DIR'])

  module Aruba
    module Reporting
      def pygmentize(dir, file)
        out = File.join(dir, file + '.html')
        _mkdir(File.dirname(out))
        pygmentize = Process.new(%{pygmentize -f html -O encoding=utf-8 "#{file}"}, 3, 0.5)
        pygmentize.run! do |p|
          exit_status = p.stop
          if(exit_status == 0)
            File.open(out, 'w') do |io|
              io.write(p.stdout)
            end
          elsif(p.stderr =~ /no lexer/) # Pygment's didn't recognize it
            File.open(out, 'w') do |io|
              io.write(IO.read(file))
            end
          else
            STDERR.puts "\e[31m#{p.stderr} - is pygments installed?\e[0m"
            exit $?.exitstatus
          end
        end
      end

      def aruba_report_file(path, &proc)
        path = File.join(@snapshot_dir, path)
        _mkdir(File.dirname(path))
        if block_given?
          File.open(path, 'w', &proc)
        else
          path
        end
      end
      
      def clean_snapshot_dir(scenario)
        @snapshot_dir = File.join($aruba_report_dir, "#{scenario.feature.file}:#{scenario.line}")
        FileUtils.rm_rf(@snapshot_dir) if File.directory?(@snapshot_dir)
        _mkdir(@snapshot_dir)
      end
      
      def write_title(scenario)
        aruba_report_file('_meta/title.txt') do |io|
          io.puts(scenario.title)
        end
      end

      def write_description(scenario)
        aruba_report_file('_meta/description.html') do |io|
          unescaped_description = scenario.description.gsub(/^(\s*)\\/, '\1')
          markdown = RDiscount.new(unescaped_description)
          io.puts(markdown.to_html)
        end
      end

      def write_all_stdout
        aruba_report_file('_meta/stdout.html') do |io|
          html = Bcat::ANSI.new(all_stdout).to_html
          html.gsub!(/style='color:#A00'/, 'class="red"')
          html.gsub!(/style='color:#0AA'/, 'class="yellow"')
          html.gsub!(/style='color:#555'/, 'class="grey"')
          html.gsub!(/style='color:#0A0'/, 'class="green"')
          # TODO: Do all a2h colours
          io.write(html)
        end
      end

      def pygmentize_files
        in_current_dir do
          Dir['**/*'].select{|f| File.file?(f)}.each do |f|
            pygmentize(@snapshot_dir, f)
          end
        end
      end

      def combine_all
        Kernel.puts filesystem_html
      end
      
      def filesystem_html
        erb = ERB.new(template('files.erb'), nil, '-')
        file = @snapshot_dir
        erb.result(binding)
      end
      
      def again(erb, _erbout, file)
        _erbout.concat(erb.result(binding))
      end

      def children(dir)
        Dir["#{dir}/*"].reject{|p| p =~ /_meta$/}.sort
      end

      def template(path)
        IO.read(File.join(ENV['ARUBA_REPORT_TEMPLATES'], path))
      end
    end
  end
  World(Aruba::Reporting)

  Before do |scenario|
    clean_snapshot_dir(scenario)
    write_title(scenario)
    write_description(scenario)
  end

  After do
    write_all_stdout
    pygmentize_files
    combine_all
  end
end

