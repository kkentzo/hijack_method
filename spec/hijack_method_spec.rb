require 'spec_helper'

describe HijackMethod do

  class Calee
    def hello; end
    def goodbye; end
  end

  before do
    Object.send(:remove_const, :Target) if Object.constants.include? :Target
    class Target
      # class methods
      def self.class_method(*args, &block)
        target
      end
      def self.target; end
      # instance methods
      def instance_method(*args, &block)
        target
      end
      def target; end
    end
  end

  context 'when hijacking a class method' do
    context 'when :main is specified' do
      before do
        class Target
          class << self
            extend HijackMethod
            hijack_method(:class_method,
              before: -> { Calee.new.hello },
              main: -> { true },
              after: -> { Calee.new.goodbye })
          end
        end
      end
      it 'should run the :before block' do
        expect_any_instance_of(Calee).to receive(:hello).exactly(1)
        Target.class_method
      end
      it 'should not run the original method' do
        expect(Target).not_to receive(:target)
        Target.class_method
      end
      it 'should run the :after block' do
        expect_any_instance_of(Calee).to receive(:goodbye).exactly(1)
        Target.class_method
      end
    end

    context 'when :main is not specified' do
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
        expect(Target).to receive(:target).exactly(1)
        Target.class_method
      end
      it 'should run the :after block' do
        expect_any_instance_of(Calee).to receive(:goodbye).exactly(1)
        Target.class_method
      end
    end
  end

  context 'when hijacking an instance method' do

    let(:test) { Target.new } 

    context 'when :main is specified' do
      before do
        class Target
          extend HijackMethod
          hijack_method(:instance_method,
            before: -> { Calee.new.hello },
            main: -> { true },
            after: -> { Calee.new.goodbye })
        end
      end

      it 'should run the :before block' do
        expect_any_instance_of(Calee).to receive(:hello).exactly(1)
        test.instance_method
      end
      it 'should not run the original method' do
        expect(test).not_to receive(:target)
        test.instance_method
      end
      it 'should run the :after block' do
        expect_any_instance_of(Calee).to receive(:goodbye).exactly(1)
        test.instance_method
      end
    end

    context 'when :main is not specified' do
      before do
        class Target
          extend HijackMethod
          hijack_method(:instance_method,
            before: -> { Calee.new.hello },
            after: -> { Calee.new.goodbye })
        end
      end

      it 'should run the :before block' do
        expect_any_instance_of(Calee).to receive(:hello).exactly(1)
        test.instance_method
      end
      it 'should run the original method' do
        expect(test).to receive(:target).exactly(1)
        test.instance_method
      end
      it 'should run the :after block' do
        expect_any_instance_of(Calee).to receive(:goodbye).exactly(1)
        test.instance_method
      end
    end
  end
end
