require 'rspec/core/formatters/junit_formatter'

describe JUnitFormatter do
  let(:now) { Time.now.utc }
  let(:output) { StringIO.new }
  let(:formatter) { JUnitFormatter.new output }

  before(:each) { Time.stub(:now => now) }

  it "starts with no failures and no successes" do
    JUnitFormatter.new(StringIO.new).test_results.should eq({:failures=>[], :successes=>[]})
  end

  it "adds passing spec to the success list" do
    formatter.example_passed "passing spec"
    formatter.test_results[:successes].should eq ["passing spec"]
  end

  it "adds failing spec to failure list" do
    formatter.example_failed "failing spec"
    formatter.test_results[:failures].should eq ["failing spec"]
  end

  it "ignores pending specs" do
    formatter.example_pending "pending spec"
    formatter.test_results.should eq({:failures=>[], :successes=>[]})
  end

  describe "#extract_errors" do
    let(:example) { stub(:example) }

    it "is empty when there are no failures" do
      metadata = {:execution_result => { :exception_encountered => nil, :exception => nil }}
      example.stub(:metadata => metadata)

      formatter.extract_errors(example).should eq("")
    end

    context "with a stacktrace" do
      let(:stacktrace) { stub(:stacktrace, :message => "foobar", :backtrace => ["foo", "bar"]) }

      it "extracts errors from :exception field" do
        metadata = {:execution_result => {:exception_encountered => nil, :exception => stacktrace }}
        example.stub(:metadata => metadata)

        formatter.extract_errors(example).should eq("foobar\nfoo\nbar")
      end

      it "extracts errors from :exception_encountered field" do
        metadata = {:execution_result => {:exception_encountered => stacktrace}}
        example.stub(:metadata => metadata)
        formatter.extract_errors(example).should eq("foobar\nfoo\nbar")
      end
    end
  end

  describe "junit xml" do
    let(:passing_metadata) do
      {
        :full_description => "a passing spec",
        :file_path => "/path/to/passing_spec.rb",
        :execution_result => { :run_time => 0.1 }
      }
    end

    let(:failing_metadata) do
      {
        :full_description => "a failing spec",
        :file_path => "/path/to/failing_spec.rb",
        :execution_result => { :exception_encountered => stacktrace, :run_time => 0.1 }
      }
    end

    let(:metadata_with_funky_characters) do
      {
        :full_description => "a passing spec >>> &\"& <<<",
        :file_path => "/path/to/passing_spec.rb",
        :execution_result => { :run_time => 0.1 }
      }
    end

    let(:stacktrace) { stub(:stacktrace, :message => "foobar", :backtrace => ["foo", "bar"]) }
    let(:passing_spec) { stub(:passing_spec) }
    let(:failing_spec) { stub(:failing_spec, :metadata => failing_metadata) }

    it "outputs the junit xml" do
      passing_spec.stub(:metadata => passing_metadata)

      formatter.example_passed passing_spec
      formatter.example_failed failing_spec

      formatter.dump_summary("0.1", 2, 1, 0)

      expected = <<-REPORT
<?xml version="1.0" encoding="utf-8" ?>
<testsuite errors="0" failures="1" tests="2" time="0.1" timestamp="#{now.iso8601}">
  <properties />
  <testcase classname="/path/to/passing_spec.rb" name="a passing spec" time="0.1" />
  <testcase classname="/path/to/failing_spec.rb" name="a failing spec" time="0.1">
    <failure message="failure" type="failure">
<![CDATA[ foobar\nfoo\nbar ]]>
    </failure>
  </testcase>
</testsuite>
      REPORT
      output.string.should eq expected
    end

    it "escapes funky characters" do
      passing_spec.stub(:metadata => metadata_with_funky_characters)

      formatter.example_passed passing_spec
      formatter.dump_summary("0.1", 2, 1, 0)

      expected = <<-REPORT
<?xml version="1.0" encoding="utf-8" ?>
<testsuite errors="0" failures="1" tests="2" time="0.1" timestamp="#{now.iso8601}">
  <properties />
  <testcase classname="/path/to/passing_spec.rb" name="a passing spec &gt;&gt;&gt; &amp;&quot;&amp; &lt;&lt;&lt;" time="0.1" />
</testsuite>
      REPORT
      output.string.should eq expected
    end
  end
end
