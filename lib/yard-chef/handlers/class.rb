module YARD::Handlers::Ruby
  class ClassHandler < YARD::Handlers::Ruby::Base
    handles method_call(:class)
    def process
      puts statement
    end
  end
end
