#!/usr/bin/env ruby
#current_dir = File.dirname(File.expand_path(__FILE__))
#lib_path = File.join(current_dir, '..', 'lib')
#$LOAD_PATH.unshift lib_path

#require File.dirname(__FILE__) + '/../lib/journeta'

Shoes.setup do
  gem 'journeta'
  gem 'hoe'
end

require 'journeta'


    class EditorEvent
      attr_accessor :diff
    end
    
    class EditorEventHandler
      
      def call(event)
        if data && data.class == EditorEvent && data.diff.class == Diff
          d = event.diff
#          @edit_box.text = ''
        else
          # ignore it
        end
      end
    end

peer_port = (2048 + rand( 2 ** 8))
@journeta = ::Journeta::Engine.new(:peer_port => peer_port, :peer_handler => EditorEventHandler.new, :groups => ['shoes_editor'])
@journeta.start

#Shoes.app :title => 'Shoes Instant Messenger' do
#  
#
#  stack :margin => '20' do
#    
#    @edit_box = edit_box :width => '100%'  do |t|
#      pp t
#      e = EditorEvent.new
#      e.diff = t.text
##      @edit_box2.text = t.text
#    end
#    
#  end
#  
#end

@journeta.stop
