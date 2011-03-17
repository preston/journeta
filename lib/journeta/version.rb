module Journeta #:nodoc:
  module VERSION #:nodoc:

		STRING = File.read(File.join(File.dirname(__FILE__), '..', '..', 'VERSION'))
		
    MAJOR = STRING.split('.')[0]
    MINOR = STRING.split('.')[1]
    TINY  = STRING.split('.')[2]

  end
end
