require 'fileutils'
require 'bcat/ansi'

module Pygmentize
  def pygmentize(dir, file)
    pygmentize = %{pygmentize -f html -O encoding=utf-8 "#{file}"}
    out = File.join(dir, file + '.html')
    FileUtils.mkdir_p(File.dirname(out)) unless File.directory?(File.dirname(out))
    `#{pygmentize} > #{out}`
    if $?.exitstatus != 0
      STDERR.puts "\e[31mpygments not installed\e[0m"
      exit $?.exitstatus
    end
  end
end
World(Pygmentize)

Before do |scenario|
  @snapshot_dir = File.join($aruba_snapshot_parent, "#{scenario.feature.file}:#{scenario.line}")
  FileUtils.rm_rf(@snapshot_dir) if File.directory?(@snapshot_dir)
  _mkdir(@snapshot_dir)
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

