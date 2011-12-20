require "time"
require "rspec/core/formatters/base_formatter"

class JUnitFormatter < RSpec::Core::Formatters::BaseFormatter

  attr_reader :test_results

  def initialize(output)
    super(output)
    @test_results = { :failures => [], :successes => [] }
  end

  def example_passed(example)
    super(example)
    @test_results[:successes].push(example)
  end

  def example_pending(example)
    super(example)
    # let jenkins ignore this
  end

  def example_failed(example)
    super(example)
    @test_results[:failures].push(example)
  end

  def extract_errors(example)
    exception = example.metadata[:execution_result][:exception_encountered] || example.metadata[:execution_result][:exception]
    message = ""
    unless exception.nil?
      message  = exception.message
      message += "\n"
      message += format_backtrace(exception.backtrace, example).join("\n")
    end
    return message
  end

  def dump_summary(duration, example_count, failure_count, pending_count)
    super(duration, example_count, failure_count, pending_count)
    output.puts("<?xml version=\"1.0\" encoding=\"utf-8\" ?>")
    output.puts("<testsuite errors=\"0\" failures=\"#{failure_count+pending_count}\" tests=\"#{example_count}\" time=\"#{duration}\" timestamp=\"#{Time.now.iso8601}\">")
    output.puts("  <properties />")
    @test_results[:successes].each do |t|
      md          = t.metadata
      runtime     = md[:execution_result][:run_time]
      description = _xml_escape(md[:full_description])
      file_path   = _xml_escape(md[:file_path])
      output.puts("  <testcase classname=\"#{file_path}\" name=\"#{description}\" time=\"#{runtime}\" />")
    end
    @test_results[:failures].each do |t|
      md          = t.metadata
      description = _xml_escape(md[:full_description])
      file_path   = _xml_escape(md[:file_path])
      runtime     = md[:execution_result][:run_time]
      output.puts("  <testcase classname=\"#{file_path}\" name=\"#{description}\" time=\"#{runtime}\">")
      output.puts("    <failure message=\"failure\" type=\"failure\">")
      output.puts("<![CDATA[ #{extract_errors(t)} ]]>")
      output.puts("    </failure>")
      output.puts("  </testcase>")
    end
    output.puts("</testsuite>")
  end

  def _xml_escape(x)
    x.gsub("&", "&amp;").
      gsub("\"", "&quot;").
      gsub(">", "&gt;").
      gsub("<", "&lt;")
  end
end
