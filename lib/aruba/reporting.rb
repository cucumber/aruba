if(ENV['ARUBA_REPORT_DIR'])
  require 'fileutils'
  require 'bcat/ansi'
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

      def aruba_report_file(path)
        path = File.join(@snapshot_dir, path)
        _mkdir(File.dirname(path))
        path
      end
    end
  end
  World(Aruba::Reporting)

  Before do |scenario|
    @snapshot_dir = File.join($aruba_report_dir, "#{scenario.feature.file}:#{scenario.line}")
    FileUtils.rm_rf(@snapshot_dir) if File.directory?(@snapshot_dir)
    _mkdir(@snapshot_dir)
    File.open(aruba_report_file('description.txt'), 'w') do |io|
      io.puts(scenario.name) # TODO: pass through RDiscount
    end
  end

  After do |scenario|
    File.open(File.join(@snapshot_dir, 'stdout.html'), 'w') do |io|
      html = Bcat::ANSI.new(all_stdout).to_html
      html.gsub!(/style='color:#A00'/, 'class="red"')
      html.gsub!(/style='color:#0AA'/, 'class="yellow"')
      html.gsub!(/style='color:#555'/, 'class="grey"')
      html.gsub!(/style='color:#0A0'/, 'class="green"')
      # TODO: Do all a2h colours
      io.write(html)
    end
    in_current_dir do
      Dir['**/*'].select{|f| File.file?(f)}.each do |f|
        pygmentize(@snapshot_dir, f)
      end
    end
  end
end

