# frozen_string_literal: true
require 'logger'
require 'timecop'

RSpec.describe SimpleJsonLogFormatter do
  let(:logger) do
    Logger.new("#{log_dir}/test.log").tap do |logger|
      logger.formatter = SimpleJsonLogFormatter.new(opts)
      logger.progname = 'prog'
    end
  end
  let(:opts)    { {} }
  let(:log_dir) { "#{File.dirname(__FILE__)}/log" }
  let(:now)     { Time.now.iso8601 }

  before do
    FileUtils.mkdir_p log_dir
    Timecop.freeze(Time.now)
  end

  after do
    FileUtils.rm_rf log_dir
    Timecop.return
  end

  def gets
    File.open("#{log_dir}/test.log") do |f|
      f.gets # drop the `# Logfile created on ...` line
      return f.gets
    end
  end

  describe '#initialize' do
    context 'with default' do
      it 'uses default keys' do
        formatter = SimpleJsonLogFormatter.new
        expect(formatter.opts[:time_key]).to eql(:time)
        expect(formatter.opts[:severity_key]).to eql(:severity)
        expect(formatter.opts[:progname_key]).to eql(:progname)
        expect(formatter.opts[:message_key]).to eql(:message)
      end
    end

    context 'with opts time_key' do
      it 'uses custom time_key' do
        formatter = SimpleJsonLogFormatter.new('time_key' => 'foo')
        expect(formatter.opts[:time_key]).to eql('foo')
      end
    end

    context 'with opts severity_key' do
      it 'uses custom severity_key' do
        formatter = SimpleJsonLogFormatter.new('severity_key' => 'foo')
        expect(formatter.opts[:severity_key]).to eql('foo')
      end
    end

    context 'with opts message_key' do
      it 'uses custom message_key' do
        formatter = SimpleJsonLogFormatter.new('message_key' => 'foo')
        expect(formatter.opts[:message_key]).to eql('foo')
      end
    end

    context 'with opts datetime_format' do
      let(:opts) { { datetime_format: '%Y/%m/%d' } }

      it 'uses custom datetime_format' do
        logger.info('test')
        json = JSON.parse(gets)
        expect(json['time']).to match(/\d{4}\/\d{2}\/\d{2}/)
      end
    end

    context 'with opts time_key nil' do
      let(:opts) { { time_key: nil } }

      it 'does not output a time field' do
        logger.info('test')
        json = JSON.parse(gets)
        expect(json.key?('time')).to be false
      end
    end

    context 'with opts severity_key nil' do
      let(:opts) { { severity_key: nil } }

      it 'does not output a severity field' do
        logger.info('test')
        json = JSON.parse(gets)
        expect(json.key?('severity')).to be false
      end
    end

    context 'with opts progname_key nil' do
      let(:opts) { { progname_key: nil } }

      it 'does not output a progname field' do
        logger.info('test')
        json = JSON.parse(gets)
        expect(json.key?('progname')).to be false
      end
    end

    context 'with opts message_key nil' do
      let(:opts) { { message_key: nil } }

      it 'has no effect' do
        logger.info('test')
        json = JSON.parse(gets)
        expect(json.key?('message')).to be true
      end
    end

    context 'with opts datetime_format nil' do
      let(:opts) { { datetime_format: nil } }

      it 'uses iso8601 format' do
        logger.info('test')
        json = JSON.parse(gets)
        expect(json['time']).to match(/\d{4}-\d{2}-\d{2}T\d{2}\:\d{2}\:\d{2}[+-]\d{2}\:\d{2}/)
      end
    end
  end

  describe '#call' do
    context 'with opts default' do
      it 'outputs default key json' do
        logger.info('test')
        json = JSON.parse(gets)
        expect(json['time']).to eq now.to_s
        expect(json['severity']).to eq 'INFO'
        expect(json['progname']).to eq 'prog'
        expect(json['message']).to eq 'test'
      end

      context 'when hash param' do
        it 'outputs json hash' do
          logger.info(foo: 'bar')
          json = JSON.parse(gets)
          expect(json['message']).to eq('foo' => 'bar')
        end

        context 'line feed log' do
          it 'outputs line feed' do
            logger.info(foo: "foo\nbar")
            json = JSON.parse(gets)
            expect(json['message']).to eq('foo' => "foo\nbar")
          end
        end
      end

      context 'when block param string' do
        it 'outputs json string' do
          logger.info { 'test' }
          json = JSON.parse(gets)
          expect(json['message']).to eq 'test'
        end
      end

      context 'when block param hash' do
        it 'outputs json hash' do
          logger.info { { foo: 'bar' } }
          json = JSON.parse(gets)
          expect(json['message']).to eq('foo' => 'bar')
        end
      end
    end

    context 'with opts message_key' do
      let(:opts) { { message_key: 'foo' } }

      it 'outputs custom message_key json' do
        logger.info('test')
        json = JSON.parse(gets)
        expect(json['foo']).to eq 'test'
      end

      context 'line feed log' do
        it 'outputs line feed' do
          logger.info("foo\nbar")
          json = JSON.parse(gets)
          expect(json['foo']).to eq "foo\nbar"
        end
      end
    end
  end
end
