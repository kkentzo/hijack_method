require 'spec_helper'

describe HijackMethod do

  class Calee
    def hello
    end
    def goodbye
    end
  end

  class Target
    def self.class_method(*args, &block); end
    def instance_method(*args, &block); end
  end

  context 'when hijacking a class method' do

    before do
      class Target
        class << self
          extend HijackMethod
          hijack_method(:class_method,
            before: -> { Calee.new.hello },
            after: -> { Calee.new.goodbye })
        end
      end
    end

    it 'should run the :before block' do
      expect_any_instance_of(Calee).to receive(:hello).exactly(1)
      Target.class_method
    end

    it 'should run the original method' do
      expect(Target).to receive(:class_method).exactly(1)
      Target.class_method
    end

    it 'should run the :after block' do
      expect_any_instance_of(Calee).to receive(:goodbye).exactly(1)
      Target.class_method
    end
  end

  context 'when hijacking an instance method' do

    before do
      class Target
        extend HijackMethod
        hijack_method(:instance_method,
          before: -> { Calee.new.hello },
          after: -> { Calee.new.goodbye })
      end
    end

    let(:test) { Target.new } 

    it 'should run the :before block' do
      expect_any_instance_of(Calee).to receive(:hello).exactly(1)
      test.instance_method
    end

    it 'should run the original method' do
      expect(test).to receive(:instance_method).exactly(1)
      test.instance_method
    end

    it 'should run the :after block' do
      expect_any_instance_of(Calee).to receive(:goodbye).exactly(1)
      test.instance_method
    end
  end

end
