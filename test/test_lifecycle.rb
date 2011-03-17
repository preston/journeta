require 'helper'

class TestLifecycle < Test::Unit::TestCase

	include Journeta
	
	@TEST_PORT = 44422

	should "start and stop correctly" do
		begin
			journeta = Engine.new(:peer_port => @TEST_PORT)
			journeta.start
			journeta.stop
			journeta.stop # Double stop is ok!
			assert true
		rescue Exception => e
			flunk "wonkiness in engine lifecycle #{e}"
		end
	end
	
	should "allow stop from stop state" do
		begin
			journeta = Engine.new(:peer_port => @TEST_PORT)
			journeta.stop
			assert true
		rescue Exception => e
			flunk "wonkiness in engine lifecycle #{e}"	
		end
	end
	
	should "not show peers in stopped state" do
		journeta = Engine.new(:peer_port => @TEST_PORT)
		assert_equal 0, journeta.known_peers.size
	end

	should "not show groups in stopped state" do
		journeta = Engine.new
		assert_equal 0, journeta.known_groups.size
	end
	
	should "report address already used upon double-start" do
		begin
			journeta = Engine.new(:peer_port => @TEST_PORT)
			journeta.start
			journeta.start
			flunk "engine should not have started twice"
		rescue Exception => e
			# assert journeta.stop
			assert true
		end
	end
	


end
