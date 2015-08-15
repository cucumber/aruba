module SimpleCov
  module Formatter
    class HTMLFormatter
      def format(result)
        Dir[File.join(File.dirname(__FILE__), "../public/*")].each do |path|
          FileUtils.cp_r(path, asset_output_path)
        end

        File.open(File.join(output_path, "index.html"), "wb") do |file|
          file.puts template("layout").result(binding)
        end
      end
    end
  end
end
